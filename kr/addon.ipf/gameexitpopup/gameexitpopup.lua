function GAMEEXITPOPUP_ON_INIT(addon, frame)
 	addon:RegisterMsg('GAMEEXIT_TIMER_START', 'ON_GAMEEXIT_TIMER_START');
	addon:RegisterMsg('GAMEEXIT_TIMER_UPDATE', 'ON_GAMEEXIT_TIMER_UPDATE');
	addon:RegisterMsg('GAMEEXIT_TIMER_END', 'ON_GAMEEXIT_TIMER_END');
end

function RUN_GAMEEXIT_TIMER(type, channel)
	local frame = ui.GetFrame("gameexitpopup");
	RunGameExitTimer(type);

	frame:SetUserValue("EXIT_TYPE", type);
	if type == "Channel" and channel ~= nil then
		frame:SetUserValue("CHANNEL", channel);
	end
end

function ON_GAMEEXIT_TIMER_START(frame, msg, time)
	frame:ShowWindow(1);
	ON_GAMEEXIT_TIMER_UPDATE(frame, msg, time);
end

function ON_GAMEEXIT_TIMER_UPDATE(frame, msg, time)
	local type = frame:GetUserValue("EXIT_TYPE");
	if type == "Exit"
		or type == "Logout"
		or type == "Barrack"
		or type == "Channel" 
	then
		local msg = ScpArgMsg("GameExit_{Time}" .. type, "Time", time);
		local txt = GET_CHILD(frame, "txt_timeout", "ui::CRichText");
		txt:SetTextByKey("value", msg);
	end
end

function ON_GAMEEXIT_TIMER_END(frame, msg)
	local type = frame:GetUserValue("EXIT_TYPE");

	if type == "Exit" then
		DO_QUIT_GAME();
	elseif type == "Logout" then
		GAME_TO_LOGIN();
	elseif type == "Barrack" then
		GAME_TO_BARRACK();
	elseif type == "Channel" then
		local channel = frame:GetUserValue("CHANNEL");
		if channel ~= nil then
			GAME_MOVE_CHANNEL(channel);
		end
	end
end

function GAMEEXIT_TIMER_CANCEL(frame)
	frame:SetUserValue("EXIT_TYPE", "");
	frame:ShowWindow(0);
end

function DO_QUIT_GAME()
	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
	-- 뭐하나라도 true면 
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.Quit(true)
			return;
		end
	end
	app.Quit(false)
end

function GAME_TO_LOGIN()
	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
	-- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.GameToLogin(true)
			return;
		end
	end
	app.GameToLogin(false)
end

function GAME_TO_BARRACK()
	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
    -- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.GameToBarrack(true)
			return;
		end
	end
	app.GameToBarrack(false)
end

function GAME_MOVE_CHANNEL(channel)
	app.ChangeChannel(channel);
end