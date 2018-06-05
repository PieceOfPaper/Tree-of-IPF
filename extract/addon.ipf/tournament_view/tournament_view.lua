
function TOURNAMENT_VIEW_ON_INIT(addon, frame)
	addon:RegisterMsg("TOURNAMENT_TEAM_UPDATE", "ON_TOURNAMENT_TEAM_UPDATE");
	addon:RegisterMsg("TOURNAMENT_BATTLE_WIN", "ON_TOURNAMENT_BATTLE_WIN");
end

function CHAT_TOURNAMENT(msg)
	geMGame.ReqTournamentChat(msg);
end

function TOURNAMENT_GAME(isPlaying)

	local sysFrame = ui.GetFrame("sysmenu");
	local frame = ui.GetFrame("tournament_view");
	frame:SetUserValue("PLAYING", isPlaying);
	if isPlaying == 1 then
		frame:ShowWindow(0);
		SYSMENU_DELETE_QUEUE_BTN(sysFrame, "TOURNAMENT_VIEW");
		g_uiChatHandler = nil;
	else
		-- frame:ShowWindow(1);

		local btn = SYSMENU_CREATE_QUEUE_BTN(sysFrame, "TOURNAMENT_VIEW", "button_collection", 1);
		local toggleScp = "ui.ToggleFrame('tournament_view')";
		btn:SetEventScript(ui.LBUTTONUP, toggleScp);
		g_uiChatHandler = "CHAT_TOURNAMENT";
	end
end

function TNMT_VIEW(p, ctrl, handle, teamNumber)
	-- view.SetDirectorPosRatio(0.8);
	geMGame.ReqTournamentView(1, teamNumber);
	geMGame.ReqTournamentView(2, handle);
end

function TNMT_VIEW_ON(ctrl, handle, teamNumber)

	local mgameInfo = session.mission.GetMGameInfo();
	local teaminfo = mgameInfo:GetTeamByNumber(teamNumber);
	local pc = teaminfo:GetPCByHandle(handle);
	if pc == nil then
		pc = mgameInfo:GetPCByHandle(handle);
	end

	local info = session.otherPC.GetByStrCID(pc:GetCID());
	if info == nil or info:GetAge() >= 10 then
		ui.PropertyCompare(handle, 0);
	end

	ctrl:SetUserValue("CID", pc:GetCID());
	if info == nil then
		ctrl:RunUpdateScript("TNMT_VIEW_CHECK_PROPERTY_GET");
	else
		local tip = OPEN_TNMT_COMPARE(pc:GetCID());
		MOVE_FRAME_TO_MOUSE_POS(tip, -100);
		ui.SetTopMostFrame(tip);
	end
	
end

function TNMT_VIEW_RBTN(ctrl, a, handle, teamNumber)
	local mgameInfo = session.mission.GetMGameInfo();
	local teaminfo = mgameInfo:GetTeamByNumber(teamNumber);
	local pc = teaminfo:GetPCByHandle(handle);
	if pc == nil then
		pc = mgameInfo:GetPCByHandle(handle);
	end

	local info = session.otherPC.GetByStrCID(pc:GetCID());
	if info == nil or info:GetAge() >= 10 then
		ui.PropertyCompare(handle, 0);
		return;
	end

	if handle == 0 then
		return;
	end

	if pc ~= nil then
		ui.CloseFrame("tournament_view");
		local fr = TOURNAMENT_GIFT_OPEN(handle, pc:GetName());
		fr:SetUserValue("CID", pc:GetCID());
		MOVE_FRAME_TO_MOUSE_POS(fr, 100, -150);
		fr:RunUpdateScript("AUTOPOS_TNMT_COMPARE");
	end
end

function AUTOPOS_TNMT_COMPARE(frame)
	local cid = frame:GetUserValue("CID");
	local tip = OPEN_TNMT_COMPARE(cid);
	local x = frame:GetX();
	local y = frame:GetY();
	tip:ShowWindow(1);
	tip:MoveFrame(x, y + frame:GetHeight() + 10);
	if 1 == keyboard.IsKeyPressed("ESCAPE") then
		frame:ShowWindow(0);
		tip:ShowWindow(0);
		return 0;
	end

	return 1;
end

function TNMT_VIEW_CHECK_PROPERTY_GET(ctrl)
	local cid = ctrl:GetUserValue("CID");
	local info = session.otherPC.GetByStrCID(cid);
	if info ~= nil then
		local tip = OPEN_TNMT_COMPARE(cid);
		MOVE_FRAME_TO_MOUSE_POS(tip, -100);
		ui.SetTopMostFrame(tip);
		return 0;
	end

	return 1;
end

function TNMT_VIEW_OFF(ctrl, handle, teamNumber)

	ctrl:StopUpdateScript("TNMT_VIEW_CHECK_PROPERTY_GET");
	CLOSE_TNMT_COMPARE(ctrl:GetUserValue("CID"));

end

function GET_TEAM_ICON_STR(team)
	local ret = "";
	for i = 0 , team:GetPCCount() - 1 do
		if i ~= 0 then
			ret = ret .. " ";
		end

		local pc = team:GetPC(i);
		local iconName = ui.CaptureModelHeadImage_IconInfo(pc:GetIcon());
		ret = ret .. string.format("{a @#TNMT_VIEW %d %d}{img %s 52 52}{/}", pc:GetHandle(), team.teamNumber,iconName);
	end

	return ret;
end

function GET_TEAM_STR(team)

	local ret = "";
	for i = 0 , team:GetPCCount() - 1 do
		if i ~= 0 then
			ret = ret .. " ";
		end

		local pc = team:GetPC(i);
		ret = ret .. string.format("{a @#TNMT_VIEW %d %d}%s{/}", pc:GetHandle(), team.teamNumber, pc:GetName());
	end

	return ret;
end

function ON_TOURNAMENT_BATTLE_WIN(frame, msg, winTeam, loseTeam)
	winTeam = tonumber(winTeam);
	local tourna = GET_CHILD(frame, "tourna", "ui::CTournament");
	tourna:AddMemberStep(winTeam, 2.0, 1.0);
	frame:ShowWindow(1); 
end

function ON_TOURNAMENT_TEAM_UPDATE(frame)

	local mgameInfo = session.mission.GetMGameInfo();
		
	local tourna = GET_CHILD(frame, "tourna", "ui::CTournament");
	tourna:ClearMember();

	local firstNumber = 0;
	if mgameInfo:GetTeamCount() > 0 then
		local team = mgameInfo:GetTeam(0);
		firstNumber = team.teamNumber;
	end

	if firstNumber % 2 == 1 then
		firstNumber = firstNumber - 1;
	end

	local drawCount = tourna:GetMaxCount();
	for i = 0 , drawCount - 1 do
		local team = mgameInfo:GetTeamByNumber(i + firstNumber);
		if team ~= nil then
			local str = GET_TEAM_STR(team);
			tourna:AddMember(team.teamNumber, "", str, team.step, team.lose, team.gaming);
		end
	end	
	
	tourna:RebuildControls();

	local isPlaying = frame:GetUserIValue("PLAYING");
	if isPlaying == 0 and world.GetLayer() == 0 and mgameInfo:GetTeamCount() >= 2 then
		local team = mgameInfo:GetTeam(0);
		if team:GetPCCount() > 0 then
			local pc = team:GetPC(0);
			geMGame.ReqTournamentView(1, team.teamNumber);
			geMGame.ReqTournamentView(2, pc:GetHandle());
		end
	end

end

function T_VIEW_MYPC(frame)
	-- view.SetDirectorPosRatio(0.8);
	geMGame.ReqTournamentView(3, 0);
end