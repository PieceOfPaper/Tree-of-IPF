function WORLDPVP_MSG_ON_INIT(addon, frame)
	addon:RegisterMsg('COLONYWAR_GUILD_KILL_MSG', 'ON_COLONYWAR_GUILD_KILL_MSG');
end

function ON_COLONYWAR_GUILD_KILL_MSG(frame, msg, argstr, argnum)
	local COLONYWAR_OFFSET_Y = frame:GetUserConfig("COLONYWAR_OFFSET_Y");
	local splitedString = StringSplit(argstr, "#");
	local killerIcon = splitedString[1];
	local selfIcon = splitedString[2];
	local killerName = splitedString[3];
	local selfName = splitedString[4];
	local targetGuildName = splitedString[5];
	local isKilled = splitedString[6];
	local isMyGuildKilled  = isKilled == "KILL"
	frame:SetOffset(frame:GetGlobalX(), COLONYWAR_OFFSET_Y);
	frame:ShowWindow(1);
	frame:SetDuration(3);

	local text = frame:GetChild("text");
	if isMyGuildKilled then
		local msgString = ScpArgMsg("Colony_GuildMember{Name}Killed{Target}OfGuild{TargetGuild}", "Name", "{#99CC00}" .. killerName .. "{/}", "Target", "{#FF5500}" .. selfName.. "{/}", "TargetGuild", "{#FF5500}" .. targetGuildName.. "{/}");
		text:SetTextByKey("value", msgString);
	else
		local msgString = ScpArgMsg("Colony_GuildMember{Name}HasKilledBy{From}OfGuild{FromGuild}", "Name", "{#99CC00}" .. selfName.. "{/}", "From", "{#FF5500}" .. killerName.. "{/}", "FromGuild", "{#FF5500}" .. targetGuildName.. "{/}");
		text:SetTextByKey("value", "{#FFFFFF}" .. msgString);
	end
end

function WORLDPVP_GET_ICON(iconString, myTeam)
	local iconInfo = ui.GetPCIconInfoByString(iconString);

	local outLineColor = "";
	if myTeam == true then
		outLineColor = "CC00FF00";
	else
		outLineColor = "CCFF0000";
	end

	return ui.CaptureModelHeadImage_IconInfo(iconInfo);
	
end

function WORLDPVP_UI_MSG_KILL(argString)
	local frame = ui.GetFrame("worldpvp_msg");
	local WORLDPVP_OFFSET_Y = frame:GetUserConfig("WORLDPVP_OFFSET_Y");
	
	local splitedString = StringSplit(argString, "#");
	local killerIcon = splitedString[1];
	local selfIcon = splitedString[2];
	local killerName = splitedString[3];
	local selfName = splitedString[4];
	local killerTeamID = tonumber(splitedString[5]);
	
	local myActor = GetMyActor();
	local myTeamID = myActor:GetTeamID();
	
	frame:SetOffset(frame:GetGlobalX(), WORLDPVP_OFFSET_Y);
	frame:ShowWindow(1);
	frame:SetDuration(3);

	--killerIcon = WORLDPVP_GET_ICON(killerIcon, myTeamID == killerTeamID);
	--selfIcon = WORLDPVP_GET_ICON(selfIcon, myTeamID ~= killerTeamID);
	--local pic_1 = GET_CHILD(frame, "pic_1");
	--local pic_2 = GET_CHILD(frame, "pic_2");
	--pic_1:SetImage(killerIcon);
	--pic_2:SetImage(selfIcon);
	local text = frame:GetChild("text");
	if myTeamID == killerTeamID then
		local msgString = ScpArgMsg("{Killer}Killed{Killee}", "Killer", "{#99CC00}" .. killerName .. "{/}", "Killee", "{#FF5500}" .. selfName.. "{/}");
		text:SetTextByKey("value", msgString);
	else
		local msgString = ScpArgMsg("{Killee}BeKilled{Killer}", "Killee", "{#FF5500}" .. selfName.. "{/}", "Killer", "{#99CC00}" .. killerName.. "{/}");
		text:SetTextByKey("value", "{#FFFFFF}" .. msgString);
	end

end



