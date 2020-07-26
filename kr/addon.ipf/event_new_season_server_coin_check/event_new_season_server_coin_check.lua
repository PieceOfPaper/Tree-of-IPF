function EVENT_NEW_SEASON_SERVER_COIN_CHECK_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_OPEN_COMMAND", "EVENT_NEW_SEASON_SERVER_COIN_CHECK_OPEN_COMMAND");
end

function EVENT_NEW_SEASON_SERVER_COIN_CHECK_OPEN_COMMAND()
	ui.OpenFrame("event_new_season_server_coin_check");
end

function EVENT_NEW_SEASON_SERVER_COIN_CHECK_OPEN(frame)
	local tab = GET_CHILD(frame, "tab");
	EVENT_NEW_SEASON_SERVER_COIN_CHECK_TAB_CLICK(frame, tab)

	local tiptext = GET_CHILD_RECURSIVELY(frame, "tiptext");
	tiptext:SetTextByKey("value", ClMsg("EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text"));
end

function EVENT_NEW_SEASON_SERVER_COIN_CHECK_CLOSE(frame)
end

function EVENT_NEW_SEASON_SERVER_COIN_CHECK_TAB_CLICK(parent, ctrl)
	local index = ctrl:GetSelectItemIndex();

	if index == 0 then
		COIN_ACQUIRE_STATE_OPEN(parent:GetTopParentFrame());
	elseif index == 1 then
        STAMP_TOUR_STATE_OPEN(parent:GetTopParentFrame());
    elseif index == 2 then
        CONTENTS_MISSION_STATE_OPEN(parent:GetTopParentFrame());
	end

end

-- 코인 획득 현황 UI 
function COIN_ACQUIRE_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', frame:GetUserConfig("COIN_ACQUIRE_TITLE"));
	
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local y = 0;
	for i = 1, 5 do
		local ctrlSet = listgb:CreateControlSet('icon_with_current_state', "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, y, 0, 0);
		local iconpic = GET_CHILD(ctrlSet, "iconpic");
		local iconname = frame:GetUserConfig("COIN_ACQUIRE_STAT_ICON_"..i);
		iconpic:SetImage(iconname);
		
		local npc_pos_btn = GET_CHILD(ctrlSet, "btn");
		npc_pos_btn:ShowWindow(0);

		local blackbg = GET_CHILD(ctrlSet, "blackbg");
		blackbg:ShowWindow(0);

		local text = GET_CHILD(ctrlSet, "text");
		text:SetTextByKey('value', ClMsg('EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_'..i));
		
		local state = GET_CHILD(ctrlSet, "state");
		local curvalue = 0;
		local maxvalue = 9999999;
		if i == 1 then
			curvalue = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_COIN_ACQUIRE_COUNT");
			maxvalue = EVENT_NEW_SEASON_SERVER_COIN_MAX_COUNT;
		elseif i == 2 then
			curvalue = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_DAY_PLAY_TIME_MINUTE");
			if 60 < curvalue then	-- 60분 넘으면 그냥 60분으로 표시하자
				curvalue = 60;
			end
			maxvalue = EVENT_NEW_SEASON_SERVER_DAY_PLAY_TIME_VALUE;
		elseif i == 3 then
			curvalue = GET_STAMP_TOUR_CLEAR_COUNT();
			maxvalue = EVENT_NEW_SEASON_SERVER_STAMP_TOUR_MAX_COUNT;
			
			npc_pos_btn:ShowWindow(1);
			npc_pos_btn:SetEventScript(ui.LBUTTONUP, "NPC_POS_BTN_CLICK");
		elseif i == 4 then
			curvalue = GET_CONTENT_MISSION_CLEAR_COUNT();
			maxvalue = EVENT_NEW_SEASON_SERVER_CONTENT_MISSION_MAX_COUNT;
		elseif i == 5 then
			curvalue = GET_USE_ROULETTE_COUNT(accObj);
			maxvalue = EVENT_NEW_SEASON_SERVER_ROULETTE_MAX_COUNT;

			-- 이벤트 공개 전 음영처리
			-- blackbg:ShowWindow(1);
			-- blackbg:SetAlpha(90);

			-- local pic2 = ctrlSet:CreateControl("picture", "comming_soon_pic", 0, 0, 316, 76);
			-- tolua.cast(pic2, "ui::CPicture");
			-- pic2:SetImage("coming_soon_notice");
			-- pic2:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
			-- pic2:SetEnableStretch(1);		
		end

		-- 진행도 완료시 음영처리
		if maxvalue <= curvalue then
			blackbg:ShowWindow(1);
			blackbg:SetAlpha(90);
		end

		if i == 2 then
			maxvalue = ScpArgMsg("{Min}", "Min", EVENT_NEW_SEASON_SERVER_DAY_PLAY_TIME_VALUE);
		end

		state:SetTextByKey('cur', curvalue);
		state:SetTextByKey('max', maxvalue);

		y = y + ctrlSet:GetHeight();
	end

end

-- 스탬프 투어 미션 목록
function STAMP_TOUR_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext", "richtext");
	nametext:SetTextByKey('value', frame:GetUserConfig("STAMP_TOUR_TITLE"));

	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();

	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local stampTourCheck = TryGetProp(accObj, "REGULAR_EVENT_STAMP_TOUR");
	if stampTourCheck == 1 then
		notebtn:ShowWindow(1);

		local y = 0;
		y = CREATE_STAMP_TOUR_STATE_LIST(y, listgb, false);	-- 완료 되지 않은 목표 우선 표시
		y = CREATE_STAMP_TOUR_STATE_LIST(y, listgb, true);
	else		
		local ctrl = listgb:CreateControl("richtext", "stamp_tour_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrl:SetTextFixWidth(1);
		ctrl:SetTextAlign("center", "top");
		ctrl:SetFontName("black_24");
		ctrl:SetText(ClMsg("EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text2"));		
	end

end

function CREATE_STAMP_TOUR_STATE_LIST(starty, listgb, isClear)	
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local y = starty;
	local clsList, clsCnt = GetClassList("note_eventlist");
	for i = 0, clsCnt - 1 do
		local missionCls = EVENT_STAMP_GET_CURRENT_MISSION("REGULAR_EVENT_STAMP_TOUR",i);
		if missionCls == nil then
			break
		end
		for j = 1, 3 do
			local clearprop = TryGetProp(missionCls, "ClearProp"..j, 'None');
			local clear = TryGetProp(accObj, clearprop, 'false');

			if (clear == 'true' and isClear == true) or (clear == 'false' and isClear == false) then
				local missiontext = TryGetProp(missionCls, "Desc"..j, "");
				local missionlist = StringSplit(missiontext, ":");
				
				local ctrlSet = listgb:CreateControlSet('check_to_do_list', "CTRLSET_" ..i.."_"..j,  ui.CENTER_HORZ, ui.TOP, -10, y, 0, 0);
				local rewardtext = GET_CHILD(ctrlSet, "rewardtext");
				rewardtext:SetTextByKey('value', missionlist[1]);
				if #missionlist > 1 then
					local tooltipText = string.format( "%s", missionlist[2]);
					rewardtext:SetTextTooltip(tooltipText);
					rewardtext:EnableHitTest(1);
				else
					rewardtext:SetTextTooltip("");
					rewardtext:EnableHitTest(0);
				end
	
				local rewardcnt = GET_CHILD(ctrlSet, "rewardcnt");
				rewardcnt:SetTextByKey('value', EVENT_NEW_SEASON_SERVER_STAMP_TOUR_CLEAR_COIN_COUNT);
	
				local checkbox = GET_CHILD(ctrlSet, "checkbox");
				local completion = GET_CHILD(ctrlSet, "completion");
				local checkline = GET_CHILD(ctrlSet, "checkline");

				if clear == 'true' then
					completion:ShowWindow(1);
					checkline:ShowWindow(1);
				else
					completion:ShowWindow(0);
					checkline:ShowWindow(0);
				end
				y = y + ctrlSet:GetHeight();
			end
		end
	end

	return y;
end

-- 콘텐츠 목표 확인
function CONTENTS_MISSION_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext", "richtext");
	nametext:SetTextByKey('value', frame:GetUserConfig("CONTENTS_MISSION_TITLE"));

	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local y = 0;
	y = CREATE_MISSION_STATE_LIST(y, listgb, false);	-- 완료 되지 않은 목표 우선 표시
	y = CREATE_MISSION_STATE_LIST(y, listgb, true);
end

function CREATE_MISSION_STATE_LIST(starty, listgb, isClear)
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local y = starty;
	local clsList, clscnt  = GetClassList("event_new_season_server_content_clear_coin_reward");
	for i = 0, clscnt - 1 do
		local missionCls = GetClassByIndexFromList(clsList, i);
			
		local clearprop = string.format( "%s_%s", 'EVENT_NEW_SEASON_SERVER_CONTENT_FIRST_CLEAR_CHECK', missionCls.ClassID);
		local clear = TryGetProp(accObj, clearprop, 0);

		if (clear == 1 and isClear == true) or (clear == 0 and isClear == false) then
			local ctrlSet = listgb:CreateControlSet('check_to_do_list', "CTRLSET_" ..i,  ui.CENTER_HORZ, ui.TOP, -10, y, 0, 0);
			local rewardtext = GET_CHILD(ctrlSet, "rewardtext");
			rewardtext:SetTextByKey('value', missionCls.ContentsName);
	
			local rewardcnt = GET_CHILD(ctrlSet, "rewardcnt");
			rewardcnt:SetTextByKey('value', missionCls.FirstCoin);
	
			local checkbox = GET_CHILD(ctrlSet, "checkbox");
			local completion = GET_CHILD(ctrlSet, "completion");
			local checkline = GET_CHILD(ctrlSet, "checkline");
				
			if clear == 1 then
				completion:ShowWindow(1);
				checkline:ShowWindow(1);
			else
				completion:ShowWindow(0);
				checkline:ShowWindow(0);
			end
			
			y = y + ctrlSet:GetHeight();
		end
	end

	return y;
end

function GET_STAMP_TOUR_CLEAR_COUNT()
	local accObj = GetMyAccountObj();
	if accObj == nil then return 0;	end

	local curCount = 0;
	for i = 1, EVENT_NEW_SEASON_SERVER_STAMP_TOUR_MAX_COUNT do
		local propname = "None";
		if i < 10 then
			propname = "REGULAR_EVENT_STAMP_TOUR_CHECK0"..i;
		else
			propname = "REGULAR_EVENT_STAMP_TOUR_CHECK"..i;
		end

		local curvalue = TryGetProp(accObj, propname);
		
		if curvalue == "true" then
			curCount = curCount + 1;
		end
	end

	return curCount;
end

function GET_CONTENT_MISSION_CLEAR_COUNT()
	local accObj = GetMyAccountObj();
	if accObj == nil then return 0;	end

	local curCount = 0;
	for i = 1, EVENT_NEW_SEASON_SERVER_CONTENT_MISSION_MAX_COUNT do
		local propname = "EVENT_NEW_SEASON_SERVER_CONTENT_FIRST_CLEAR_CHECK_"..i;
		local curvalue = TryGetProp(accObj, propname);
		
		if curvalue == 1 then
			curCount = curCount + 1;
		end

	end

	return curCount;
end

function NPC_POS_BTN_CLICK(frame, msg, argStr, argNum)
	local context = ui.CreateContextMenu("npc_pos", "", 0, 0, 120, 120);
    
    scpScp = string.format("EVENT_NPC_POS_MINIMAP(\"%s\")", "Klapeda");    
	ui.AddContextMenuItem(context, ClMsg("Klapeda"), scpScp);
	
    scpScp = string.format("EVENT_NPC_POS_MINIMAP(\"%s\")", "c_orsha");    
    ui.AddContextMenuItem(context, ClMsg("c_orsha"), scpScp);

    ui.OpenContextMenu(context);
end

function EVENT_NPC_POS_MINIMAP(mapname)
	
	if mapname == "Klapeda" then
		SCR_SHOW_LOCAL_MAP("c_Klaipe", true, -292, 291)
	elseif mapname == "c_orsha" then
		SCR_SHOW_LOCAL_MAP("c_orsha", true, -985, 415)
	end
end