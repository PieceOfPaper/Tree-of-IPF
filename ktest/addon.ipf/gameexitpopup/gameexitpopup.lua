function GAMEEXITPOPUP_ON_INIT(addon, frame)
 	addon:RegisterMsg('GAMEEXIT_TIMER_START', 'ON_GAMEEXIT_TIMER_START');
	addon:RegisterMsg('GAMEEXIT_TIMER_UPDATE', 'ON_GAMEEXIT_TIMER_UPDATE');
	addon:RegisterMsg('GAMEEXIT_TIMER_END', 'ON_GAMEEXIT_TIMER_END');
end

function RUN_GAMEEXIT_TIMER(type, channel)
	local frame = ui.GetFrame("gameexitpopup");

	local delayReason = "None";
	if session.colonywar.GetIsColonyWarMap() == true then
		delayReason = "InColonyWar";
	end

	local mapName = session.GetMapName();
	local mapCls = GetClass("Map",mapName)
	local mapKeyword = TryGetProp(mapCls,"Keyword","None")
	mapKeyword = StringSplit(mapKeyword,';')
	for i = 1,#mapKeyword do
		if mapKeyword[i] == 'WeeklyBossMap' then
			delayReason = "WeeklyBoss"
			break;
		end
	end

	RunGameExitTimer(type, delayReason);

	frame:SetUserValue("EXIT_TYPE", type);
	if type == "Channel" and channel ~= nil then
		frame:SetUserValue("CHANNEL", channel);
	end
end

function ON_GAMEEXIT_TIMER_START(frame, msg, reason, time)
	frame:ShowWindow(1);
	ON_GAMEEXIT_TIMER_UPDATE(frame, msg, reason, time);
end

function ON_GAMEEXIT_TIMER_UPDATE(frame, msg, reason, time)
	local type = frame:GetUserValue("EXIT_TYPE");
	if type == "Exit"
		or type == "Logout"
		or type == "Barrack"
		or type == "Channel" 
		or type == "RaidReturn"
	then
		local reasonMsg = ClMsg("GameExitDelayReason_" .. reason);
		local reasonTxt = GET_CHILD(frame, "tip", "ui::CRichText");
		reasonTxt:SetText(reasonMsg);

		local msg = ScpArgMsg("GameExit_{Time}" .. type, "Time", tostring(time));
		local txt = GET_CHILD(frame, "txt_timeout", "ui::CRichText");
		txt:SetTextByKey("value", msg);
	end
end

function ON_GAMEEXIT_TIMER_END(frame)
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
	elseif type == "RaidReturn" then
		addon.BroadMsg("WEEKLY_BOSS_DPS_END","",0);
		restart.ReqReturn();
	end
end

function GAMEEXIT_TIMER_CANCEL(frame)
	frame:SetUserValue("EXIT_TYPE", "");
	frame:ShowWindow(0);
end

function DO_QUIT_GAME()
	quickslot.RequestSave();
	SaveFavoritesBgmList();
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
	quickslot.RequestSave();
	SaveFavoritesBgmList();
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
	quickslot.RequestSave();
	SaveFavoritesBgmList();
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