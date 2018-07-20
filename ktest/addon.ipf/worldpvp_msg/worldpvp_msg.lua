

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
	
	local splitedString = StringSplit(argString, "#");
	local killerIcon = splitedString[1];
	local selfIcon = splitedString[2];
	local killerName = splitedString[3];
	local selfName = splitedString[4];
	local killerTeamID = tonumber(splitedString[5]);
	
	local myActor = GetMyActor();
	local myTeamID = myActor:GetTeamID();
	
	local frame = ui.GetFrame("worldpvp_msg");
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



