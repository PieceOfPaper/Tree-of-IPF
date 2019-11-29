function EVENT_STAMP_TOUR_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_STAMP_TOUR_UI_OPEN_COMMAND", "ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND");
	addon:RegisterMsg("EVENT_STAMP_TOUR_REWARD_GET", "ON_EVENT_STAMP_TOUR_REWARD_GET");

end

function OPEN_EVENT_STAMP_TOUR(frame)
	EVENT_STAMP_TOUR_CREATE_PAGE(frame);
	EVENT_STAMP_TOUR_SET_PAGE();
end

function CLOSE_EVENT_STAMP_TOUR(frame)

end

function ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND()
	ui.OpenFrame("event_stamp_tour");
end

-- controlset 초기화
function EVENT_STAMP_TOUR_CREATE_PAGE(frame)
	local clsList, allmissionCnt = GetClassList('note_eventlist');

	-- 띠지 control 생성
	local LABEL_OFFSET_Y = frame:GetUserConfig('LABEL_OFFSET_Y');
	local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
	label_tab:ClearItemAll();	
	label_tab:EnableHitTest(1);
	
	for i = 0, allmissionCnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local image = cls.TypeIcon;
		label_tab:AddItem("", true, "EVENT_STAMP_TOUR_SET_PAGE", image, image.."_cursoron", image.."_clicked", cls.TypeName, false);
	end
	
	-- 미션 내용 control 생성
	local misson_gb = GET_CHILD_RECURSIVELY(frame, 'misson_gb');
	local DESC_OFFSET_Y = frame:GetUserConfig('DESC_OFFSET_Y');
	misson_gb:RemoveAllChild();
	local misson_gb_y = 0;

	for i = 1, 3 do
		local ctrlSet = misson_gb:CreateOrGetControlSet('event_stamp_tour_mission_block', 'MISSIONBLOCK_'..i, 0, misson_gb_y);
		ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');	
		ctrlSet:ShowWindow(1);
		ctrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP);

		local reward_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'reward_bg');
		reward_bg:RemoveAllChild();
		
		misson_gb_y = misson_gb_y + ctrlSet:GetHeight() + DESC_OFFSET_Y;
	end

end

function EVENT_STAMP_TOUR_SET_PAGE(argnum)
	local frame = ui.GetFrame('event_stamp_tour');

	local REWARD_TEXT_FONT = frame:GetUserConfig('REWARD_TEXT_FONT');
	local REWARD_CLEAR_BG_ALPHA = frame:GetUserConfig('REWARD_CLEAR_BG_ALPHA');
	local REWARD_CHECK_BG_ALPHA = frame:GetUserConfig('REWARD_CHECK_BG_ALPHA');
	local REWARD_DESC_OFFSET_Y = frame:GetUserConfig('REWARD_DESC_OFFSET_Y');

	local misson_gb = GET_CHILD_RECURSIVELY(frame, 'misson_gb');
	local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
	local clsList, allmissionCnt = GetClassList('note_eventlist');

	local currentpage = label_tab:GetSelectItemIndex();
	local missionCls = GetClassByIndexFromList(clsList, currentpage);

	local typename_text = GET_CHILD_RECURSIVELY(frame, 'typename_text');
	typename_text:SetTextByKey('value', missionCls.TypeName);

	local accObj = GetMyAccountObj();

	for i = 1, 3 do
		local clearprop = TryGetProp(missionCls, "ClearProp"..i, 'None');
		local clear = TryGetProp(accObj, clearprop, 'false');

		local ctrlSet = GET_CHILD_RECURSIVELY(misson_gb, 'MISSIONBLOCK_'..i);
		ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');

		-- 난이도
		local levet_text = GET_CHILD_RECURSIVELY(ctrlSet, 'levet_text');
		levet_text:SetTextByKey('value', ClMsg("EventStampTourLevel_"..i));

		-- 미션 내용
		local desc = GET_CHILD_RECURSIVELY(ctrlSet, 'desc');
		local missiontext = TryGetProp(missionCls, "Desc"..i, "");
		local missionlist = StringSplit(missiontext, ":");
		desc:SetTextByKey('value', missionlist[1]);
		-- 툴팁으로 자세한 미션 내용 출력
		if #missionlist > 1 then
			local tooltipText = string.format( "%s", missionlist[2]);
			desc:SetTextTooltip(tooltipText);
			desc:EnableHitTest(1);
		else
			desc:SetTextTooltip("");
			desc:EnableHitTest(0);
		end

		-- 진행상황		
		local checkprop = TryGetProp(missionCls, "CheckProp"..i, 'None');
		local proplist = StringSplit(checkprop, "/");
		local propname = proplist[1];
		local goalcnt = proplist[2];
		local curcnt = TryGetProp(accObj, propname, 0);

		local desc = GET_CHILD_RECURSIVELY(ctrlSet, 'gauge');
		desc:SetPoint(curcnt, goalcnt);
		
		-- 보상 text
		local reward = TryGetProp(missionCls, "Reward"..i, "None")
		local rewardliststr = StringSplit(reward, '/');
		local rewardcnt = #rewardliststr;

		local reward_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'reward_bg');
		reward_bg:RemoveAllChild();

		local reward = GET_CHILD_RECURSIVELY(ctrlSet, 'reward');			
		reward:ShowWindow(0);
		if rewardcnt > 0 then
			reward:ShowWindow(1);
		end

		local reward_Y = 0;
		for j = 1, rewardcnt - 1, 2 do
			local itemcls = GetClass('Item', rewardliststr[j]);
			local itemname = TryGetProp(itemcls, 'Name', 'None');

			local rewardtext = reward_bg:CreateOrGetControl('richtext', 'REWARD_TEXT_'..(math.floor(j/2)), 0, reward_Y, 100, 10);
			rewardtext:SetText(itemname.." "..rewardliststr[j+1]..ClMsg("Piece"));
			rewardtext:SetFontName(REWARD_TEXT_FONT)
			rewardtext:SetGravity(ui.RIGHT, ui.TOP);

			reward_Y = reward_Y + REWARD_DESC_OFFSET_Y;
		end

		-- 목표 수치 달성
		local check_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'check_bg');
		check_bg:ShowWindow(0);
		check_bg:EnableHitTest(0);
		if clear ~= 'true' and tonumber(goalcnt) <= tonumber(curcnt) then
			check_bg:ShowWindow(1);
            check_bg:SetAlpha(REWARD_CHECK_BG_ALPHA);
			check_bg:EnableHitTest(1);

			check_bg:SetEventScript(ui.LBUTTONUP, 'EVENT_STAMP_TOUR_MISSION_CLEAR_CHECK')
			check_bg:SetEventScriptArgString(ui.LBUTTONUP, missionCls.TypeName);
			check_bg:SetEventScriptArgNumber(ui.LBUTTONUP, i);
		end

		-- 보상 획득
		local clear_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'clear_bg');
		local clear_Pic = GET_CHILD_RECURSIVELY(ctrlSet, 'clear_Pic');
		clear_bg:ShowWindow(0);
		clear_Pic:ShowWindow(0);

		if clear == 'true' then
			clear_bg:ShowWindow(1);
            clear_bg:SetAlpha(REWARD_CLEAR_BG_ALPHA);
			clear_Pic:ShowWindow(1);

			if config.GetServiceNation() ~= 'KOR' then
				clear_Pic:SetImage("very_nice_stamp_eng");
			end
		end


	end

end

function EVENT_STAMP_TOUR_MISSION_CLEAR_CHECK(frame, ctrl, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	ui.SetHoldUI(true);
	ReserveScript("HOLDUI_UNFREEZE()", 3);

	frame = ui.GetFrame('event_stamp_tour');
	local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
	local currentpage = label_tab:GetSelectItemIndex();
	local numvalue = ((3 * currentpage) + argNum);
	
	pc.ReqExecuteTx_NumArgs("SCR_EVENT_STAMP_TOUR_CHECK", numvalue);
end

function HOLDUI_UNFREEZE()
   ui.SetHoldUI(false);
end

-- 보상 획득한 level 미션 블럭 UI 변경
function ON_EVENT_STAMP_TOUR_REWARD_GET(frame, msg, argstr, argnum)
	local misson_gb = GET_CHILD_RECURSIVELY(frame, 'misson_gb');
	local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
	local currentpage = label_tab:GetSelectItemIndex();

	local level = argnum;
	if currentpage >= 1 then
		level = argnum % (3 * currentpage);

		if level == 0 then
			level = 3;
		end
	end

	local misson_gb = GET_CHILD_RECURSIVELY(frame, 'misson_gb');
	local ctrlSet = GET_CHILD_RECURSIVELY(misson_gb, 'MISSIONBLOCK_'..level);
	ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');

	local REWARD_CLEAR_BG_ALPHA = frame:GetUserConfig('REWARD_CLEAR_BG_ALPHA');
	
	local check_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'check_bg');
	check_bg:ShowWindow(0);
	check_bg:EnableHitTest(0);

	-- 보상 획득
	local clear_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'clear_bg');
	local clear_Pic = GET_CHILD_RECURSIVELY(ctrlSet, 'clear_Pic');
	clear_bg:ShowWindow(0);
	clear_Pic:ShowWindow(0);
	
	if config.GetServiceNation() ~= 'KOR' then
		clear_Pic:SetImage("very_nice_stamp_eng");
	end

	UI_PLAYFORCE(clear_Pic, "sizeUpAndDown");
	clear_bg:ShowWindow(1);
	clear_bg:SetAlpha(REWARD_CLEAR_BG_ALPHA);
	clear_Pic:ShowWindow(1);

	label_tab:EnableHitTest(0);
	ReserveScript("HOLDTABUI_UNFREEZE()", 2.5);
end

function HOLDTABUI_UNFREEZE()
   local frame = ui.GetFrame('event_stamp_tour');
   local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
   label_tab:EnableHitTest(1);
end