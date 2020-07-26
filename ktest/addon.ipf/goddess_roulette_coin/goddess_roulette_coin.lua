function GODDESS_ROULETTE_COIN_ON_INIT(addon, frame)
	addon:RegisterMsg("GODDESS_ROULETTE_COIN_OPEN_COMMAND", "GODDESS_ROULETTE_COIN_OPEN_COMMAND");
	addon:RegisterMsg("GODDESS_ROULETTE_DAILY_PLAY_TIME_UPDATE", "GODDESS_ROULETTE_DAILY_PLAY_TIME_UPDATE");	
end

function GODDESS_ROULETTE_COIN_OPEN_COMMAND()
	ui.OpenFrame("goddess_roulette_coin");
end

function GODDESS_ROULETTE_COIN_OPEN(frame)
	local tab = GET_CHILD(frame, "tab");
	tab:SelectTab(0);
	GODDESS_ROULETTE_COIN_TAB_CLICK(frame, tab)

	local tiptext = GET_CHILD_RECURSIVELY(frame, "tiptext");
	tiptext:SetTextByKey("value", ClMsg("EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text"));
end

function GODDESS_ROULETTE_COIN_TAB_CLICK(parent, ctrl)
	local index = ctrl:GetSelectItemIndex();

	if index == 0 then
		GODDESS_ROULETTE_COIN_ACQUIRE_STATE_OPEN(parent:GetTopParentFrame());
	elseif index == 1 then
        GODDESS_ROULETTE_COIN_STAMP_TOUR_STATE_OPEN(parent:GetTopParentFrame());
    elseif index == 2 then
        GODDESS_ROULETTE_COIN_CONTENTS_STATE_OPEN(parent:GetTopParentFrame());
	end

end

------------------------- 획득 현황 -------------------------
function GODDESS_ROULETTE_COIN_ACQUIRE_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', frame:GetUserConfig("COIN_ACQUIRE_TITLE"));
    
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);
	
	local fullblack_pic = GET_CHILD(frame, "fullblack_pic");
	fullblack_pic:ShowWindow(0);
	
	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

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
		local gb = GET_CHILD(ctrlSet, "gb");
		gb:SetTextTooltip(ClMsg("GoddessRouletteTexttooltip_"..i));

		local state = GET_CHILD(ctrlSet, "state");
		local curvalue = 0;
		local maxvalue = 9999999;
		if i == 1 then
			-- 전체 코인 획득량
			text:SetTextByKey('value', ClMsg('EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_'..i));

			curvalue = TryGetProp(accObj, "GODDESS_ROULETTE_COIN_ACQUIRE_COUNT", 0);
			maxvalue = GODDESS_ROULETTE_COIN_MAX_COUNT;
		elseif i == 2 then
			-- 한 시간 접속
			text:SetTextByKey('value', ClMsg('EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_'..i));

			curvalue = TryGetProp(accObj, "GODDESS_ROULETTE_DAILY_PLAY_TIME_MINUTE", 0);
			if 60 < curvalue then	-- 60분 넘으면 그냥 60분으로 표시하자
				curvalue = 60;
			end
			maxvalue = GODDESS_ROULETTE_DAILY_PLAY_TIME_VALUE;

			if maxvalue <= curvalue then
				local clear_text = blackbg:CreateOrGetControl("richtext", "clear_text", 0, 0, 500, 80);
				clear_text:SetText("{@st42b}{s20}"..ClMsg("GoddessRouletteDailyPlayTimeClearText"));
				clear_text:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
				clear_text:SetTextAlign("center", "top");
			end			
		elseif i == 3 then
			-- 스탬프 투어
			text:SetTextByKey('value', ClMsg('EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_'..i));

			curvalue = GET_GODDESS_ROULETTE_STAMP_TOUR_CLEAR_COUNT();
			maxvalue = GODDESS_ROULETTE_STAMP_TOUR_MAX_COUNT;
			
			npc_pos_btn:ShowWindow(1);
			npc_pos_btn:SetEventScript(ui.LBUTTONUP, "NPC_POS_BTN_CLICK");
			npc_pos_btn:SetTextTooltip(ClMsg("GoddessRouletteNpcTextTooltip"));
			
			--------- 스탬프 투어 이벤트 종료 ---------
			blackbg:ShowWindow(1);
			blackbg:SetAlpha(90);
			
			local clear_text = blackbg:CreateOrGetControl("richtext", "clear_text", 0, 0, 500, 80);
			clear_text:SetText("{@st42b}{s20}"..ClMsg("EndEventMessage"));
			clear_text:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
			clear_text:SetTextAlign("center", "top");
			--------- 스탬프 투어 이벤트 종료 ---------
		elseif i == 4 then
			-- 콘텐츠 
			text:SetTextByKey('value', ClMsg("DailyContentMissionAcquireCount"));

			curvalue = TryGetProp(accObj, "GODDESS_ROULETTE_DAILY_CONTENTS_ACQUIRE_COUNT", 0);
			maxvalue = GODDESS_ROULETTE_DAILY_CONTENTS_MAX_COIN_COUNT;
			
			-- 이벤트 공개 전 음영처리
			-- blackbg:ShowWindow(1);
			-- blackbg:SetAlpha(90);

			-- local pic2 = ctrlSet:CreateControl("picture", "comming_soon_pic", 0, 0, 316, 76);
			-- tolua.cast(pic2, "ui::CPicture");
			-- pic2:SetImage("coming_soon_notice");
			-- pic2:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
			-- pic2:SetEnableStretch(1);
			
			if maxvalue <= curvalue then
				local clear_text = blackbg:CreateOrGetControl("richtext", "clear_text", 0, 0, 500, 80);
				clear_text:SetText("{@st42b}{s20}"..ClMsg("GoddessRouletteDailyPlayTimeClearText"));
				clear_text:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
				clear_text:SetTextAlign("center", "top");
			end			
		elseif i == 5 then
			-- 룰렛
			text:SetTextByKey('value', ClMsg('EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_'..i));

			curvalue = GET_USE_ROULETTE_COUNT(accObj);
			maxvalue = GODDESS_ROULETTE_MAX_COUNT;

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
			maxvalue = ScpArgMsg("{Min}", "Min", GODDESS_ROULETTE_DAILY_PLAY_TIME_VALUE);
		end

		state:SetTextByKey('cur', curvalue);
		state:SetTextByKey('max', maxvalue);

		y = y + ctrlSet:GetHeight();
	end
end

function GET_GODDESS_ROULETTE_STAMP_TOUR_CLEAR_COUNT()
	local accObj = GetMyAccountObj();
	local curCount = 0;
	for i = 1, GODDESS_ROULETTE_STAMP_TOUR_MAX_COUNT do
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

function GODDESS_ROULETTE_DAILY_PLAY_TIME_UPDATE(frame, msg, time)
	local frame = ui.GetFrame("goddess_roulette_coin");	
	if frame:IsVisible() == 0 then
		return;
	end

	local tab = GET_CHILD(frame, "tab");
	local index = tab:GetSelectItemIndex();
	if index ~= 0 then
		return;
	end

	local listgb = GET_CHILD(frame, "listgb");
	local ctrlSet = GET_CHILD_RECURSIVELY(frame, "CTRLSET_2");
	if ctrlSet == nil then
		return;
	end
	
	local state = GET_CHILD(ctrlSet, "state");
	state:SetTextByKey("cur", time);

	if 60 <= tonumber(time) then
		local blackbg = GET_CHILD(ctrlSet, "blackbg");
		blackbg:ShowWindow(1);
		blackbg:SetAlpha(90);
	end
end

------------------------- 스탬프 -------------------------
function GODDESS_ROULETTE_COIN_STAMP_TOUR_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', frame:GetUserConfig("STAMP_TOUR_TITLE"));
    
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);
	
	local fullblack_pic = GET_CHILD(frame, "fullblack_pic");
	fullblack_pic:ShowWindow(0);

	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

	local accObj = GetMyAccountObj();
	local stampTourCheck = TryGetProp(accObj, "REGULAR_EVENT_STAMP_TOUR");
	if stampTourCheck == 1 then
		-- 스탬프 투어 진행 중일 경우
		notebtn:ShowWindow(1);

		local y = 0;
		y = CREATE_GODDESS_ROULETTE_COIN_STAMP_TOUR_LIST(y, listgb, false);	-- 완료 되지 않은 목표 우선 표시
		y = CREATE_GODDESS_ROULETTE_COIN_STAMP_TOUR_LIST(y, listgb, true);
	else		
		-- 스탬프 투어 시작 전
		-- local ctrl = listgb:CreateControl("richtext", "stamp_tour_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
		-- ctrl:SetTextFixWidth(1);
		-- ctrl:SetTextAlign("center", "top");
		-- ctrl:SetFontName("black_24");
		-- ctrl:SetText(ClMsg("EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text2"));		

		-- 스탬프 투어 종료
		local ctrl = listgb:CreateControl("richtext", "stamp_tour_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrl:SetTextFixWidth(1);
		ctrl:SetTextAlign("center", "top");
		ctrl:SetFontName("black_24");
		ctrl:SetText(ClMsg("EndEventMessage"));		
	end
end

function CREATE_GODDESS_ROULETTE_COIN_STAMP_TOUR_LIST(starty, listgb, isClear)	
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local y = starty;
	local clsList, clsCnt = GetClassList("note_eventlist");
	for i = 0, clsCnt - 3 do	-- 주간(1), 주간(2)는 룰렛코인 주지 않아 clsCnt - 3
		local missionCls = GetClassByIndexFromList(clsList, i);
		for j = 1, 3 do
			local clearprop = TryGetProp(missionCls, "ClearProp"..j, 'None');
			local clear = TryGetProp(accObj, clearprop, 'false');

			if (clear == 'true' and isClear == true) or (clear == 'false' and isClear == false) then
				local missiontext = TryGetProp(missionCls, "Desc"..j, "");
				local missionlist = StringSplit(missiontext, ":");

				if missiontext ~= "None" then
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
					rewardcnt:SetTextByKey('value', GODDESS_ROULETTE_STAMP_TOUR_CLEAR_COIN_COUNT);
		
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
	end

	return y;
end

------------------------- 콘텐츠 -------------------------
function GODDESS_ROULETTE_COIN_CONTENTS_STATE_OPEN(frame)
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', frame:GetUserConfig("CONTENTS_MISSION_TITLE"));
    
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

	-- 콘텐츠 미션 보여주기 전
	-- local fullblack_pic = GET_CHILD(frame, "fullblack_pic");
	-- fullblack_pic:RemoveAllChild();
	-- fullblack_pic:ShowWindow(1);

	-- local pic2 = fullblack_pic:CreateControl("picture", "comming_soon_pic", 0, 0, 474, 114);
	-- tolua.cast(pic2, "ui::CPicture");
	-- pic2:SetImage("coming_soon_notice");
	-- pic2:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	-- pic2:SetEnableStretch(1);

	-- 콘텐츠 미션 보여주기 후
	local fullblack_pic = GET_CHILD(frame, "fullblack_pic");
	local accObj = GetMyAccountObj();
	local check = TryGetProp(accObj, "GODDESS_ROULETTE_DAILY_CONTENTS_ACQUIRE_COUNT", 0);
	if GODDESS_ROULETTE_DAILY_CONTENTS_MAX_COIN_COUNT <= check then
		overtext:ShowWindow(1);
		fullblack_pic:ShowWindow(1);
	else
		fullblack_pic:ShowWindow(0);
		CREATE_GODDESS_ROULETTE_COIN_CONTENTS_LIST(listgb);
	end
end

function CREATE_GODDESS_ROULETTE_COIN_CONTENTS_LIST(listgb)
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local y = 0;
	local clsList, clscnt  = GetClassList("goddess_roulette_contents");
	for i = 0, clscnt - 1 do
		local missionCls = GetClassByIndexFromList(clsList, i);

		local ctrlSet = listgb:CreateControlSet("simple_to_do_list", "CTRLSET_" ..i,  ui.CENTER_HORZ, ui.TOP, -10, y, 0, 0);
		local rewardtext = GET_CHILD(ctrlSet, "rewardtext");
		rewardtext:SetTextByKey('value', missionCls.ContentsName);
	
		local rewardcnt = GET_CHILD(ctrlSet, "rewardcnt");
		rewardcnt:SetTextByKey('value', missionCls.Coin);

		y = y + ctrlSet:GetHeight();
	end
end
