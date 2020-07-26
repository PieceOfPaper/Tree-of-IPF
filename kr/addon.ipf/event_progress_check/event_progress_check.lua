function EVENT_PROGRESS_CHECK_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_PROGRESS_CHECK_OPEN_COMMAND", "EVENT_PROGRESS_CHECK_OPEN_COMMAND");
end

function EVENT_PROGRESS_CHECK_OPEN_COMMAND(frame, msg, argStr, type)
	EVENT_PROGRESS_CHECK_OPEN(type);
end

function EVENT_PROGRESS_CHECK_OPEN(type)
	local frame = ui.GetFrame("event_progress_check");

	EVENT_PROGRESS_CHECK_INIT(frame, type)
	EVENT_PROGRESS_CHECK_TAB_CLICK(frame, nil, "", type);

	frame:ShowWindow(1);
end

function EVENT_PROGRESS_CHECK_CLOSE(frame)
	frame:ShowWindow(0);
end

function EVENT_PROGRESS_CHECK_INIT(frame, type)
	local title = GET_CHILD_RECURSIVELY(frame, "title");
	title:SetTextByKey("value", ClMsg(GET_EVENT_PROGRESS_CHECK_TITLE(type)));

	local tab = GET_CHILD(frame, "tab");
	tab:SelectTab(0);
	tab:SetEventScript(ui.LBUTTONUP, "EVENT_PROGRESS_CHECK_TAB_CLICK");
	tab:SetEventScriptArgNumber(ui.LBUTTONUP, type);

	local tabtitlelist = GET_EVENT_PROGRESS_CHECK_TAB_TITLE(type);
	for i = 1, 3 do 
		tab:ChangeCaption(i - 1, "{@st66b}{s18}"..ClMsg(tabtitlelist[i]), false);
	end
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:SetTextByKey("value", ClMsg(GET_EVENT_PROGRESS_CHECK_NOTE_NAME(type)));
	notebtn:SetEventScript(ui.LBUTTONUP, GET_EVENT_PROGRESS_CHECK_NOTE_BTN(type));
end

function EVENT_PROGRESS_CHECK_TAB_CLICK(parent, ctrl, argStr, type)
	local tab = GET_CHILD(parent:GetTopParentFrame(), "tab");
	local index = tab:GetSelectItemIndex();

	if index == 0 then
		EVENT_PROGRESS_CHECK_ACQUIRE_STATE_OPEN(parent:GetTopParentFrame(), type);
	elseif index == 1 then
        EVENT_PROGRESS_CHECK_STAMP_TOUR_STATE_OPEN(parent:GetTopParentFrame(), type);
    elseif index == 2 then
        EVENT_PROGRESS_CHECK_CONTENTS_STATE_OPEN(parent:GetTopParentFrame(), type);
	end
end

------------------------- 획득 현황 -------------------------
function EVENT_PROGRESS_CHECK_ACQUIRE_STATE_OPEN(frame, type)
	local tabtitlelist = GET_EVENT_PROGRESS_CHECK_TAB_TITLE(type);
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', ClMsg(tabtitlelist[1]));

	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);
		
	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

	local tiptext = GET_CHILD(frame, "tiptext");
	tiptext:ShowWindow(0);

	local tiptextlist = GET_EVENT_PROGRESS_CHECK_TIP_TEXT(type);
	if tiptextlist[1] ~= "None" then
		tiptext:SetTextByKey("value", ClMsg(tiptextlist[1]));
		tiptext:ShowWindow(1);
	end

	local comming_soon_pic = GET_CHILD_RECURSIVELY(frame, "comming_soon_pic");
	comming_soon_pic:ShowWindow(0);

	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local curlist = GET_EVENT_PROGRESS_CHECK_CUR_VALUE(type, accObj);
	local eventstatelist = GET_EVENT_PROGRESS_CHECK_EVENT_STATE(type);
	local iconlist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_ICON(type);    
	local textlist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_TEXT(type);
	local tooltiplist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_TOOLTIP(type);
	local maxlist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_MAX_VALUE(type);
	local npclist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_NPC(type);
	local clearlist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_CLEAR_TEXT(type);

	local y = 0;
	for i = 1, 5 do
		local ctrlSet = listgb:CreateControlSet('icon_with_current_state', "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, y, 0, 0);
		local iconpic = GET_CHILD(ctrlSet, "iconpic");
		iconpic:SetImage(iconlist[i]);

		local clear_text = GET_CHILD(ctrlSet, "clear_text");
		
		local npc_pos_btn = GET_CHILD(ctrlSet, "btn");
		if npclist[i] ~= "None" then
			npc_pos_btn:ShowWindow(1);
			npc_pos_btn:SetEventScript(ui.LBUTTONUP, "EVENT_PROGRESS_NPC_POS_BTN_CLICK");
			npc_pos_btn:SetEventScriptArgString(ui.LBUTTONUP, npclist[i]);
			npc_pos_btn:SetTextTooltip(ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_6"));
		else
			npc_pos_btn:ShowWindow(0);	
		end

		local blackbg = GET_CHILD(ctrlSet, "blackbg");
		blackbg:ShowWindow(0);

		local text = GET_CHILD(ctrlSet, "text");
		text:SetTextByKey('value', textlist[i]);

		local gb = GET_CHILD(ctrlSet, "gb");
		gb:SetTextTooltip(tooltiplist[i]);

		local comming_soon_pic = GET_CHILD(ctrlSet, "comming_soon_pic");
		comming_soon_pic:ShowWindow(0);

		local state = GET_CHILD(ctrlSet, "state");
		local curvalue = curlist[i];
		local maxvalue = maxlist[i];

		if maxvalue <= curvalue and maxvalue ~= 0 then
			blackbg:ShowWindow(1);
			blackbg:SetAlpha(90);

			if clearlist[i] ~= "None" then
				clear_text:SetTextByKey("value", ClMsg(clearlist[i]));
			end
		end

		if eventstatelist[i] == "pre" then
			blackbg:ShowWindow(1);
			blackbg:SetAlpha(90);

			comming_soon_pic:ShowWindow(1);
		elseif eventstatelist[i] == "end" then
			blackbg:ShowWindow(1);
			blackbg:SetAlpha(90);

			clear_text:SetTextByKey("value", ClMsg("EndEventMessage"));
		end

		if i == 2 then
			local timetype = GET_EVENT_PROGRESS_DAILY_PLAY_TIME_TYPE(type);
			if timetype == "min" then
				maxvalue = ScpArgMsg("{Min}", "Min", maxvalue);
			end
		end
		
		state:SetTextByKey('cur', curvalue);
		state:SetTextByKey('max', " / "..maxvalue);
		if maxvalue == 0 then
			state:SetTextByKey('max', "");
		end

		y = y + ctrlSet:GetHeight();
	end
end

------------------------- 스탬프 -------------------------
function EVENT_PROGRESS_CHECK_STAMP_TOUR_STATE_OPEN(frame, type)
	local tabtitlelist = GET_EVENT_PROGRESS_CHECK_TAB_TITLE(type);
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', ClMsg(tabtitlelist[2]));
    
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

	local tiptext = GET_CHILD(frame, "tiptext");
	tiptext:ShowWindow(0);

	local tiptextlist = GET_EVENT_PROGRESS_CHECK_TIP_TEXT(type);
	if tiptextlist[2] ~= "None" then
		tiptext:SetTextByKey("value", ClMsg(tiptextlist[2]));
		tiptext:ShowWindow(1);
	end

	local comming_soon_pic = GET_CHILD_RECURSIVELY(frame, "comming_soon_pic");
	comming_soon_pic:ShowWindow(0);
	
	local eventstatelist = GET_EVENT_PROGRESS_CHECK_EVENT_STATE(type);
	if eventstatelist[3] == "pre" then
		comming_soon_pic:ShowWindow(1);
	elseif eventstatelist[3] == "end" then
		local ctrl = listgb:CreateControl("richtext", "tos_vacance_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrl:SetTextFixWidth(1);
		ctrl:SetTextAlign("center", "top");
		ctrl:SetFontName("black_24");
		ctrl:SetText(ClMsg("EndEventMessage"));	
	else
		local accObj = GetMyAccountObj();
		local stampTourCheck = TryGetProp(accObj, "REGULAR_EVENT_STAMP_TOUR");
		if stampTourCheck == 1 then
			notebtn:ShowWindow(1);
	
			local y = 0;
			y = CREATE_EVENT_PROGRESS_CHECK_STAMP_TOUR_LIST(type, y, listgb, false);	-- 완료 되지 않은 목표 우선 표시
			y = CREATE_EVENT_PROGRESS_CHECK_STAMP_TOUR_LIST(type, y, listgb, true);
		else
			local ctrl = listgb:CreateControl("richtext", "tos_vacance_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
			ctrl:SetTextFixWidth(1);
			ctrl:SetTextAlign("center", "top");
			ctrl:SetFontName("black_24");
			ctrl:SetText(ClMsg("EVENT_2007_FLEX_BOX_CHECK_TIP_TEXT_2"));
		end
	end

end

function CREATE_EVENT_PROGRESS_CHECK_STAMP_TOUR_LIST(type, starty, listgb, isClear)	
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local rewardCls = GetClass("Item", GET_EVENT_PROGRESS_CHECK_ITEM(type));
	local y = starty;

	local group = GET_EVENT_PROGRESS_CHECK_STAMP_GROUP(type);
	local itemNmae = GET_EVENT_PROGRESS_CHECK_ITEM(type);
	local clsList, clsCnt = GetClassList("note_eventlist");
	for i = 0, clsCnt do
		local missionCls = EVENT_STAMP_GET_CURRENT_MISSION(group, i);
		if missionCls == nil then
			break
		end

		for j = 1, 3 do
			local clearprop = TryGetProp(missionCls, "ClearProp"..j, 'None');
			local clear = TryGetProp(accObj, clearprop, 'false');
			if clear == tostring(isClear) and ENABLE_CREATE_EVENT_PROGRESS_CHECK_STAMP_TOUR_LIST(missionCls, i, j) == true then
				local missionStr = TryGetProp(missionCls, "Desc"..j, "");
				local missionlist = StringSplit(missionStr, ":");
				
				local rewardStr = TryGetProp(missionCls, "Reward"..j, "");	
				if missionStr ~= "None" and missionStr ~= "" and string.find(rewardStr, rewardCls.ClassName) ~= nil then 
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
				
					local rewardicon = GET_CHILD(ctrlSet, "rewardicon");
					rewardicon:SetImage(rewardCls.Icon);
				
					local rewardcnt = GET_CHILD(ctrlSet, "rewardcnt");
					rewardcnt:SetTextByKey('value', 10);
				
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

function ENABLE_CREATE_EVENT_PROGRESS_CHECK_STAMP_TOUR_LIST(missionCls, i, j)
	local weekNum = TryGetProp(missionCls, "ArgNum"..j, 0);
	if weekNum == 0 then
		return true;
	end

	if EVENT_STAMP_IS_VALID_WEEK_SUMMER(weekNum) == false then
		return false;
	end

	local accObj = GetMyAccountObj();
	local isHidden = EVENT_STAMP_IS_VALID_WEEK_SUMMER(weekNum) == false or EVENT_STAMP_IS_HIDDEN_SUMMER(accObj, (3 * i) + j) == true;
	if isHidden == false then
		return true;
	end

	return false;
end

------------------------- 콘텐츠 -------------------------
function EVENT_PROGRESS_CHECK_CONTENTS_STATE_OPEN(frame, type)
	local tabtitlelist = GET_EVENT_PROGRESS_CHECK_TAB_TITLE(type);
	local nametext = GET_CHILD_RECURSIVELY(frame, "nametext");
	nametext:SetTextByKey('value', ClMsg(tabtitlelist[3]));
    
	local listgb = GET_CHILD(frame, "listgb");
	listgb:RemoveAllChild();
	
	local notebtn = GET_CHILD_RECURSIVELY(frame, "notebtn");
	notebtn:ShowWindow(0);

	local overtext = GET_CHILD(frame, "overtext");
	overtext:ShowWindow(0);

	local tiptext = GET_CHILD(frame, "tiptext");
	tiptext:ShowWindow(0);

	local tiptextlist = GET_EVENT_PROGRESS_CHECK_TIP_TEXT(type);
	if tiptextlist[3] ~= "None" then
		tiptext:SetTextByKey("value", ClMsg(tiptextlist[3]));
		tiptext:ShowWindow(1);
	end

	local comming_soon_pic = GET_CHILD_RECURSIVELY(frame, "comming_soon_pic");
	comming_soon_pic:ShowWindow(0);

	local eventstatelist = GET_EVENT_PROGRESS_CHECK_EVENT_STATE(type);
	if eventstatelist[4] == "pre" then
		comming_soon_pic:ShowWindow(1);
	elseif eventstatelist[4] == "end" then
		local ctrl = listgb:CreateControl("richtext", "contents_tip_text", 500, 100, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrl:SetTextFixWidth(1);
		ctrl:SetTextAlign("center", "top");
		ctrl:SetFontName("black_24");
		ctrl:SetText(ClMsg("EndEventMessage"));	
	else
		local accObj = GetMyAccountObj();
		local maxlist = GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_MAX_VALUE(type);
		local curlist = GET_EVENT_PROGRESS_CHECK_CUR_VALUE(type, accObj);
		local contentslist = GET_EVENT_PROGRESS_CONTENTS_MAX_CONSUME_COUNT(type);
		if contentslist == "daily" then
			if maxlist[4] <= curlist[4] then
				overtext:ShowWindow(1);
				return;
			end
			CREATE_EVENT_PROGRESS_CHECK_CONTENTS_LIST_DAILY(type, listgb);
		elseif contentslist == "first" then
			local y = 0;
			y = CREATE_EVENT_PROGRESS_CHECK_CONTENTS_LIST_FIRST(type, y, listgb, false);	-- 완료 되지 않은 목표 우선 표시
			y = CREATE_EVENT_PROGRESS_CHECK_CONTENTS_LIST_FIRST(type, y, listgb, true);
		end
	end
end

function CREATE_EVENT_PROGRESS_CHECK_CONTENTS_LIST_DAILY(type, listgb)
	local accObj = GetMyAccountObj();
	if accObj == nil then return; end

	local rewardCls = GetClass("Item", GET_EVENT_PROGRESS_CHECK_ITEM(type));
	local y = 0;
	local clsList, clscnt  = GetClassList("event_coin");
	for i = 0, clscnt - 1 do
		local missionCls = GetClassByIndexFromList(clsList, i);
		local ret, count = ENABLE_EVENT_PROGRESS_CONTENTS_DAILY(missionCls, rewardCls.ClassName);
		if ret == true and count ~= 0 then
			local desc = TryGetProp(missionCls, "Desc", "None");
			if desc ~= "None" then
				local ctrlSet = listgb:CreateControlSet("simple_to_do_list", "CTRLSET_" ..i,  ui.CENTER_HORZ, ui.TOP, -10, y, 0, 0);
				local rewardicon = GET_CHILD(ctrlSet, "rewardicon");
				rewardicon:SetImage(rewardCls.Icon);
			
				local rewardtext = GET_CHILD(ctrlSet, "rewardtext");
				rewardtext:SetTextByKey('value', desc);
		
				local rewardcnt = GET_CHILD(ctrlSet, "rewardcnt");
				rewardcnt:SetTextByKey('value', count);
	
				y = y + ctrlSet:GetHeight();				
			end			
		end
	end
end

function CREATE_EVENT_PROGRESS_CHECK_CONTENTS_LIST_FIRST(type, starty, listgb, isClear)
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

function ENABLE_EVENT_PROGRESS_CONTENTS_DAILY(missionCls, itemClassName)
	for i = 1, 3 do
		local coinName = TryGetProp(missionCls, "CoinName_"..i)
		if coinName == itemClassName then
			return true, TryGetProp(missionCls, "CoinCount_"..i);
		end
	end

	return false;
end
------------------------- NPC -------------------------
function EVENT_PROGRESS_NPC_POS_BTN_CLICK(frame, msg, argStr)
	local context = ui.CreateContextMenu("flex_box_npc_pos", "", 0, 0, 120, 120);

	local npclist = StringSplit(argStr, ";");
	for i = 1, #npclist do
		local npcStr = StringSplit(npclist[i], "/");

		scpScp = string.format("EVENT_PROGRESS_NPC_POS_MINIMAP(\"%s\", %d, %d)", npcStr[2], npcStr[3], npcStr[4]);
		ui.AddContextMenuItem(context, ClMsg(npcStr[1]), scpScp);
	end

    ui.OpenContextMenu(context);
end

function EVENT_PROGRESS_NPC_POS_MINIMAP(mapname, x, z)	
	SCR_SHOW_LOCAL_MAP(mapname, true, x, z)	;
end