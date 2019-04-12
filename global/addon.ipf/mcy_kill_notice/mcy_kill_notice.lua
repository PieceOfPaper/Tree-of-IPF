

function MCY_KILL_NOTICE_ON_INIT(addon, frame)

	addon:RegisterMsg('MCY_KILL_NOTICE', 'ON_MCY_KILL_NOTICE');

end

function ON_MCY_KILL_NOTICE(frame, msg, str, teamID)

	local sList = StringSplit(str, "\\");
	local textFormat = sList[1];
	if sList[2] == "M" then
		local killer = sList[4];
		local killed = sList[5];
		MCY_NOTICE_KILL(frame, teamID, textFormat, nil, nil, killer, killed);
	else
		local job = tonumber(sList[2]);
		local gender = tonumber(sList[3]);
		local killer = sList[4];
		local killed = sList[5];
		MCY_NOTICE_KILL(frame, teamID, textFormat, job, gender, killer, killed);
	end

end

function MCY_NOTICE_KILL(frame, teamID, textFormat, killerJob, killerGender, killer, killed)
	


	frame:ShowWindow(1);

	local pic = GET_CHILD(frame, "pic", "ui::CPicture");
	if killerJob ~= nil then
		local imgName = GET_JOB_ICON(killerJob);
		pic:SetImage(imgName);
		pic:ShowWindow(1);
	else
		pic:ShowWindow(0);
	end

	local myTeam = GET_MY_TEAMID();
	local font = "";
	--[[
	if teamID == myTeam then
		font = "{@st46}";
	else
		font = "{@st47}";
	end
	]]

	local text = frame:GetChild("text");
	if killed == nil then
		local txt = string.format(textFormat, killer);
		text:SetTextByKey("value", txt);
	else
		local txt = string.format(textFormat, killer, killed);
		text:SetTextByKey("value", txt);
	end

	frame:SetDuration(2);
end

