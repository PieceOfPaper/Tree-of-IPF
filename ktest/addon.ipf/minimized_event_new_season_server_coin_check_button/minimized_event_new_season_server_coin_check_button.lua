function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK');
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_OPEN_CHECK(frame)
	local accObj = GetMyAccountObj();
	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
end

function MINIMIZED_EVENT_NEW_SEASON_SERVER_COIN_CHECK_BUTTON_CLICK()
	local frame = ui.GetFrame('event_new_season_server_coin_check');
	frame:ShowWindow(1);
end
