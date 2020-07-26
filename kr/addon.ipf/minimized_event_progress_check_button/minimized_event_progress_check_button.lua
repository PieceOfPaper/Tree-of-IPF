function MINIMIZED_EVENT_PROGRESS_CHECK_BUTTON_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START", "MINIMIZED_EVENT_PROGRESS_CHECK_BUTTON_INIT");
end

function MINIMIZED_EVENT_PROGRESS_CHECK_BUTTON_INIT(frame)
	local accObj = GetMyAccountObj();

	local btn = GET_CHILD(frame, "openBtn");
	btn:SetEventScript(ui.LBUTTONUP, "MINIMIZED_EVENT_PROGRESS_CHECK_BUTTON_CLICK");
	
	local title = GET_CHILD(frame, "title");

	-- SEASON_SERVER
	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		btn:SetImage("god_roulette_coin_entrance");
		btn:SetEventScriptArgNumber(ui.LBUTTONUP, 2);
		
		title:SetTextByKey("value", ClMsg("GODDESS_ROULETTE"));
		return;
	end

	-- FLEX_BOX
	if IS_EVENT_NEW_SEASON_SERVER(accObj) == false then
		btn:SetImage("flex_box_btn");
		btn:SetEventScriptArgNumber(ui.LBUTTONUP, 3);
		
		title:SetTextByKey("value", ClMsg("FLEX!"));
		return;
	end

	frame:ShowWindow(0);
end

function MINIMIZED_EVENT_PROGRESS_CHECK_BUTTON_CLICK(parent, ctrl, argStr, type)	
	local frame = ui.GetFrame("event_progress_check");
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);
		return;
	end

	EVENT_PROGRESS_CHECK_OPEN_COMMAND("", "", "", type);
end