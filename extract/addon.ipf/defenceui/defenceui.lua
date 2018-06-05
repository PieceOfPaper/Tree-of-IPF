

function DEFENCEUI_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("MGAME_VALUE_UPDATE", "DEFENCEUI_MGAME_VALUE_UPDATE");
end

function DEFENCEUI_MGAME_VALUE_UPDATE(frame, msg, propName, propValue)
	DEFENCEUI_UPDATE(frame);
end

function DEFENCEUI_OPEN(frame)
	DEFENCEUI_UPDATE(frame);
end

function DEFENCEUI_UPDATE(frame)
	
	local mgameInfo = session.mission.GetMGameInfo();
	local etcObj = GetMyEtcObject();
	local myTeamID = etcObj.Team_Mission;

	local tower_1 = mgameInfo:GetUserValue("Statue_1");
	local tower_2 = mgameInfo:GetUserValue("Statue_2");
	local round_1 = mgameInfo:GetUserValue("Round_1");
	local round_2  = mgameInfo:GetUserValue("Round_2");
	local pccount_1 = mgameInfo:GetUserValue("AlivePCCount_1");
	local pccount_2 = mgameInfo:GetUserValue("AlivePCCount_2");

	local txt_team1_tower;
	local txt_team2_tower;
	local txt_team1_round;
	local txt_team2_round;
	local txt_team1_pccount;
	local txt_team2_pccount;
	if myTeamID == 1 then
		txt_team1_tower = frame:GetChild("txt_our_tower");
		txt_team2_tower = frame:GetChild("txt_enemy_tower");
		txt_team1_round = frame:GetChild("txt_our_round");
		txt_team2_round = frame:GetChild("txt_enemy_round");
		txt_team1_pccount = frame:GetChild("txt_our_pccount");
		txt_team2_pccount = frame:GetChild("txt_enemy_pccount");
	else
		txt_team2_tower = frame:GetChild("txt_our_tower");
		txt_team1_tower = frame:GetChild("txt_enemy_tower");
		txt_team2_round = frame:GetChild("txt_our_round");
		txt_team1_round = frame:GetChild("txt_enemy_round");
		txt_team2_pccount = frame:GetChild("txt_our_pccount");
		txt_team1_pccount = frame:GetChild("txt_enemy_pccount");
	end

	txt_team1_tower:SetTextByKey("value", tower_1);
	txt_team2_tower:SetTextByKey("value", tower_2);
	txt_team1_round:SetTextByKey("value", round_1);
	txt_team2_round:SetTextByKey("value", round_2);
	txt_team1_pccount:SetTextByKey("value", pccount_1);
	txt_team2_pccount:SetTextByKey("value", pccount_2);

	local txt_time = frame:GetChild("txt_time");
	local isStarted = mgameInfo:GetUserValue("GameStarted");
	if isStarted == 1 then
		txt_time:ShowWindow(0);
	else
		txt_time:RunUpdateScript("AUTO_UPDATE_DEFENCEUI", 0, 0, 0,1);
		txt_time:ShowWindow(1);
	end
	

end

function AUTO_UPDATE_DEFENCEUI(txt_time)

	local type = config.GetConfigInt("partycompetitiontype");

	local remainSec = session.party.GetPartyCompetitionStartWaitSecond(type);
	local min = math.floor(remainSec / 60);
	local sec = remainSec % 60;
	local timeStr;
	if remainSec >= 0 then
		timeStr = string.format("%d:%02d", min, sec);
	else
		timeStr = "";
	end

	local txt = ScpArgMsg("GameWillBeStarterdAfter{Time}", "Time", timeStr);
	txt_time:SetTextByKey("value", txt);
	if remainSec > 0 then	
		return 1;
	else
		txt_time:ShowWindow(0);
		return 0;
	end

	return 1;

end




