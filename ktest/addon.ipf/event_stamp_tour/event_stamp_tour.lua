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
		if TryGetProp(missionCls,"Desc"..i,'None') == 'None' then
			for j = i,3 do
				ctrlSet:ShowWindow(0)
			end
			break
		end
		ctrlSet:ShowWindow(1)
		-- 난이도
		local levet_text = GET_CHILD_RECURSIVELY(ctrlSet, 'levet_text');
		levet_text:SetTextByKey('value', ClMsg("EventStampTourLevel_"..i));
		
		-- 미션 내용
		local desc = GET_CHILD_RECURSIVELY(ctrlSet, 'desc');
		local missiontext = dic.getTranslatedStr(TryGetProp(missionCls, "Desc"..i, ""));
		local delimeter = string.find(missiontext,':')

		-- 툴팁으로 자세한 미션 내용 출력
		if delimeter ~= nil then
			local mainText = string.sub(missiontext,1,delimeter-1)
			desc:SetTextByKey('value', mainText);
			local subText = string.sub(missiontext,delimeter+1)
			local tooltipText = string.format( "%s", subText);
			desc:SetTextTooltip(tooltipText);
			desc:EnableHitTest(1);
		else
			desc:SetTextByKey('value', missiontext);
			desc:SetTextTooltip("");
			desc:EnableHitTest(0);
		end
		
		-- 진행상황		
		local checkprop = TryGetProp(missionCls, "CheckProp"..i, 'None');
		local proplist = StringSplit(checkprop, "/");
		local propname = proplist[1];
		local goalcnt = proplist[2];
		local curcnt = TryGetProp(accObj, propname, 0);

		local gauge = GET_CHILD_RECURSIVELY(ctrlSet, 'gauge');
		gauge:SetPoint(curcnt, goalcnt);
		
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
		local go_btn = GET_CHILD_RECURSIVELY(ctrlSet,'go_btn')
		local shortCut = TryGetProp(missionCls,'ShortCut'..i)
		if shortCut == nil or shortCut == 'None' then
			go_btn:SetEnable(0)
		else
			go_btn:SetEventScriptArgString(ui.LBUTTONUP, shortCut);
			go_btn:SetEventScriptArgNumber(ui.LBUTTONUP, (3 * currentpage) + i);
			go_btn:SetEnable(1)
		end
		local helpBtn = GET_CHILD_RECURSIVELY(ctrlSet,'question')
		local helpType = TryGetProp(missionCls,'HelpType'..i)
		helpBtn:SetEventScriptArgNumber(ui.LBUTTONUP, helpType);
		helpBtn:SetEnable(1)
		if helpType == nil or helpType == 0 then
			helpBtn:SetEnable(0)
		end
		if clear == 'true' then
			clear_bg:ShowWindow(1);
            clear_bg:SetAlpha(REWARD_CLEAR_BG_ALPHA);
			clear_Pic:ShowWindow(1);

			if config.GetServiceNation() ~= 'KOR' then
				clear_Pic:SetImage("very_nice_stamp_eng");
			end
			local go_btn = GET_CHILD_RECURSIVELY(ctrlSet,'go_btn')
			go_btn:SetEnable(0)
			helpBtn:SetEnable(0)
		end
		local weekNum = TryGetProp(missionCls, "ArgNum"..i, 0);
		local comingsoon_Pic = GET_CHILD_RECURSIVELY(ctrlSet, 'comingsoon_Pic');
		comingsoon_Pic:ShowWindow(0);
		if weekNum ~= 0 then
			if EVENT_STAMP_IS_COMING_SOON(weekNum) == true then
				clear_bg:ShowWindow(1);
				clear_bg:SetAlpha(REWARD_CLEAR_BG_ALPHA);
				comingsoon_Pic:ShowWindow(1);
				go_btn:SetEnable(0)
				helpBtn:SetEnable(0)
				desc:SetTextByKey('value', ScpArgMsg("STAMP_TOUR_WEEK_MSG","week",weekNum));
			end
		end
	end
end

function EVENT_STAMP_TOUR_MISSION_CLEAR_CHECK(frame, ctrl, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	frame = ui.GetFrame('event_stamp_tour');
	local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
	local currentpage = label_tab:GetSelectItemIndex();
	local missionCls = GetClassByNumProp("note_eventlist","ClassID",currentpage+1)
	local reward = TryGetProp(missionCls, "Reward"..argNum, "None")
	local rewardliststr = StringSplit(reward, '/');
	local checkProp = {'ShopTrade','TeamTrade','UserTrade','MarketTrade'}
	local isTradable = true
	local itemName = "None"
	for i = 1,#rewardliststr,2 do
		local itemTradable = false
		local item = GetClass("Item",rewardliststr[i])
		for j = 1,#checkProp do
			if TryGetProp(item,checkProp[j]) == "YES" then
				itemTradable = true
				break
			end
		end
		if itemTradable == false then
			itemName = item.Name
			isTradable = false
		end
	end
	local numvalue = ((3 * currentpage) + argNum);
	if isTradable == true then
		EVENT_STAMP_TOUR_MISSION_CLEAR(numvalue)
	else
		local yesScp = string.format("EVENT_STAMP_TOUR_MISSION_CLEAR(\"%s\")", numvalue);
		local msgBox = ui.MsgBox(ScpArgMsg("STAMP_TOUR_TRADE_WARNING","item",itemName), yesScp, "None");
		local yesBtn = GET_CHILD_RECURSIVELY(msgBox,"YES")
	end
end

function EVENT_STAMP_TOUR_MISSION_CLEAR(numvalue)
	ui.SetHoldUI(true);
	ReserveScript("HOLDUI_UNFREEZE()", 3);
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
	local go_btn = GET_CHILD_RECURSIVELY(ctrlSet,'go_btn')
	go_btn:SetEnable(0)

	label_tab:EnableHitTest(0);
	ReserveScript("HOLDTABUI_UNFREEZE()", 2.5);
end

function HOLDTABUI_UNFREEZE()
   local frame = ui.GetFrame('event_stamp_tour');
   local label_tab = GET_CHILD_RECURSIVELY(frame, 'label_tab');
   label_tab:EnableHitTest(1);
end

function ON_EVENT_STAMP_TOUR_GO_BUTTON_CLICK(parent,ctrl,argStr,argNum)
	if argStr == nil or argStr == "None" then
		return
	end
	local argList = StringSplit(argStr,'/')
	local type = argList[1]
	if type == 'ui' then
		local frameName = argList[2]
		ui.OpenFrame(frameName)
	elseif type == 'warp' then
		pc.ReqExecuteTx_NumArgs("SCR_EVENT_STAMP_TOUR_SHORTCUT", argNum);
	elseif type == 'scp' then
		local Script = _G[argList[2]]
		Script()
	end
end

function ON_EVENT_STAMP_TOUR_HELP_CLICK(parent,ctrl,argStr,argNum)
	if argNum == nil or argNum == 0 then
		return
	end
	local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", argStr, argNum)
end

function SCR_EVENT_STAMP_OPEN_WEEKLY_BOSS_UI()
	local frame = ui.GetFrame('induninfo')
	frame:ShowWindow(1)
	local tab = GET_CHILD_RECURSIVELY(frame, "tab");
	tab:SelectTab(1);
	INDUNINFO_TAB_CHANGE(frame)
end

function SCR_EVENT_STAMP_OPEN_ADVENTURE_BOOK_MAP()
	local frame = ui.GetFrame('adventure_book')
	frame:ShowWindow(1)
	local tab = GET_CHILD_RECURSIVELY(frame, "bookmark");
	tab:SelectTab(7);
end

function EVENT_STAMP_IS_COMING_SOON(week)
	local startTime = imcTime.GetSysTime(2020,4,16,6)
	local week_startTime = imcTime.AddSec(startTime,(week-1)*7*24*60*60)
	local currentDate = geTime.GetServerSystemTime()
	if imcTime.GetDifSec(week_startTime,currentDate) > 0 then
		return true
	end
	return false
end