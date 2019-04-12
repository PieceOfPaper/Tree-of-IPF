function PARTYCOMPETITIONLIST_ON_INIT(addon, frame)
	
	

end

function OPEN_PARTY_COMPETITION_LIST()

	ui.Chat("/partycompetitionjoinstate");

end

function PARTY_COMPETITION_UPDATE()
	
	local frame = ui.GetFrame("partycompetitionlist");
	UPDATE_PARTY_COMPETITION_LIST(frame);

end

function PARTY_COMPETITION_JOIN_MSG(type)
	local cls = GetClassByType("PartyCompetition", type);
	local msg = ScpArgMsg("MatchingCompletedJoinTheGame{Name}", "Name", cls.Name);
	ui.SysMsg(msg);
end

function TIME_TEXT_BY_MINUTE(dayOfWeekString, minute)

	local hour = math.floor(minute / 60);
	local minute = minute  - hour * 60;
	return string.format("%s %d:%02d", dayOfWeekString, hour, minute);

end

function UPDATE_PARTY_COMPETITION_LIST(frame)
	
	local gbox_list = frame:GetChild("gbox_list");
	gbox_list:RemoveAllChild();

	local partyCount = session.party.GetPartyCompetitionStates();
	local cnt = partyCount:size();
	for i = 0 , cnt - 1 do
		local type = partyCount:at(i);
		local cls = GetClassByType("PartyCompetition", type);
		local ctrlSet = gbox_list:CreateControlSet('partycompetition_set', "INFO_" .. type, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local txt_name = ctrlSet:GetChild("txt_name");
		local txt_time = ctrlSet:GetChild("txt_time");
		local txt_unit = ctrlSet:GetChild("txt_unit");
		txt_name:SetTextByKey("value", cls.Name);
		ctrlSet:SetUserValue("TYPE", type);
		txt_unit:SetTextByKey("value", ScpArgMsg(cls.PartyType));
		
		local btn = GET_CHILD(ctrlSet, "btn");
		local isJoining = session.party.GetPartyCompetitionJoinState(type);
		if isJoining == 1 then
			btn:SetTextByKey("value", ScpArgMsg("PVP_State_Finding"));
		elseif isJoining == 2 then
			btn:SetTextByKey("value", ScpArgMsg("EnterGame"));
			btn:SetUserValue("TYPE", type);
			btn:RunUpdateScript("AUTO_UPDATE_COMPETITION_START_TIME", 0, 0, 0,1);
			AUTO_UPDATE_COMPETITION_START_TIME(btn);
		else
			btn:SetTextByKey("value", ScpArgMsg("Join"));
		end

		if isJoining ~= 2 then
			local strList = StringSplit(cls.Time, "#");
			local dayOfWeekString = GET_DAYOFWEEK_STR(tonumber(strList[2]));

			local startMin = tonumber(strList[3]) * 60 + tonumber(strList[4]);
			local endMin = startMin + tonumber(strList[5]);
			local startTimeStr = TIME_TEXT_BY_MINUTE(dayOfWeekString, startMin);
			local endTimeStr = TIME_TEXT_BY_MINUTE(dayOfWeekString, endMin);

			txt_time:SetTextByKey("value", startTimeStr .. " ~ " .. endTimeStr);		
		end
	end

	GBOX_AUTO_ALIGN(gbox_list, 0, 1, 0, true, false);
end

function AUTO_UPDATE_COMPETITION_START_TIME(btn)
	local type = btn:GetUserIValue("TYPE");
	local remainSec = session.party.GetPartyCompetitionStartWaitSecond(type);
	local min = math.floor(remainSec / 60);
	local sec = remainSec % 60;
	local timeStr;
	if remainSec >= 0 then
		timeStr = string.format("%d:%02d", min, sec);
	else
		timeStr = "";
	end

	local parent = btn:GetParent();
	local txt_time = parent:GetChild("txt_time");
	txt_time:SetTextByKey("value", timeStr);
	if remainSec > 0 then	
		return 1;
	else
		return 0;
	end
end

function JOIN_PARTY_COMPETITION(parent, ctrl)

	local type = parent:GetUserIValue("TYPE");
	local cls = GetClassByType("PartyCompetition", type);
	local isJoining = session.party.GetPartyCompetitionJoinState(type);
	if isJoining ~= 2 then
		if cls.PartyType == "Party" then
			if 0 == AM_I_LEADER(PARTY_NORMAL) then
				ui.MsgBox(ScpArgMsg("OnlyPartyLeader"));
				return;
			end
		else
			if 0 == AM_I_LEADER(PARTY_GUILD) then
				ui.MsgBox(ScpArgMsg("OnlyGuildLeader"));
				return;
			end
		end
	end

	if isJoining == 2 then
		ui.Chat("/partycompetition " .. type .. " 2");
	elseif isJoining == 1 then
		ui.Chat("/partycompetition " .. type .. " 0");
	else
		ui.Chat("/partycompetition " .. type .. " 1");		
	end

end


