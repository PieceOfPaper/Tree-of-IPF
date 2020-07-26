function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK');
	addon:RegisterMsg("GAME_START", "GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK");
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK(frame)
	local accObj = GetMyAccountObj();
	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		local ctrl = GET_CHILD(frame, "openBtn");
		ctrl:SetEventScript(ui.LBUTTONUP, "MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK");
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK()
	local frame = ui.GetFrame('event_new_season_server_coin_check');
	frame:ShowWindow(1);
end

function GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK(frame)
	local accObj = GetMyAccountObj();
	
	local ctrl = GET_CHILD(frame, "openBtn");
	ctrl:SetEventScript(ui.LBUTTONUP, "GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK_CLICK");

	frame:ShowWindow(1);
end

function GODDESS_ROULETTE_COIN_BUTTON_OPEN_CHECK_CLICK()
	local frame = ui.GetFrame("goddess_roulette_coin");
	frame:ShowWindow(1);
end
