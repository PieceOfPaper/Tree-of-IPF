
function GUILDEVENTPOPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("GUILD_PROPERTY_UPDATE", "ON_UPDATE_GUILDEVENT_POPUP");
	addon:RegisterMsg("GUILD_INFO_UPDATE", "ON_UPDATE_GUILDEVENT_POPUP");
	addon:RegisterMsg('GAME_START', 'ON_UPDATE_GUILDEVENT_POPUP');

end

function UPDATE_GUILD_EVENT_POPUP()

	local frame = ui.GetFrame("guildeventpopup");
	ON_UPDATE_GUILDEVENT_POPUP(frame);

end

function ON_UPDATE_GUILDEVENT_POPUP(frame)

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());
	local GuildInDunFlag = partyObj.GuildInDunFlag;
	local GuildBossSummonFlag = partyObj.GuildBossSummonFlag;
	local GuildRaidFlag = partyObj.GuildRaidFlag;
	
	if GuildInDunFlag == 0 and GuildBossSummonFlag == 0 and GuildRaidFlag == 0 then
		frame:ShowWindow(0);
		return;
	end

	local LocInfo = nil

	local guildEventCls = nil
	
	if GuildInDunFlag ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", partyObj.GuildInDunSelectInfo);
		LocInfo = partyObj.GuildInDunLocInfo;
	elseif GuildBossSummonFlag ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", partyObj.GuildBossSummonSelectInfo);
		LocInfo = partyObj.GuildBossSummonLocInfo;
	elseif GuildRaidFlag ~= 0 then
		guildEventCls = GetClassByType("GuildEvent", partyObj.GuildRaidSelectInfo);
		LocInfo = guildEventCls.StageLoc_1;
	end
	
	frame:SetUserValue("CLSSID", guildEventCls.ClassID);
	frame:SetUserValue("STARTWAITSEC", guildEventCls.StartWaitSec);

	local sysTime = geTime.GetServerSystemTime();
	local endTime = imcTime.GetSysTimeByStr(partyObj.GuildEventStartTime);
	local difSec = imcTime.GetDifSec(sysTime, endTime);
	if difSec >= guildEventCls.StartWaitSec then
		return;
	end

	frame:SetUserValue("ELAPSED_SEC", difSec);
	frame:SetUserValue("START_SEC", imcTime.GetAppTime());
	if GuildInDunFlag == 1 or GuildBossSummonFlag == 1 then
		local sList = StringSplit(LocInfo, ":");
	local mapID = sList[1];
	local genType = sList[2];
	local genListIndex = sList[3];
	local mapID = tonumber(sList[1]);
	local genType = tonumber(sList[2]);
	local genListIndex = tonumber(sList[3]);

	local mapCls = GetClassByType("Map", mapID);
	local mapprop = geMapTable.GetMapProp(mapCls.ClassName);
	local genTypeProp = mapprop:GetMongen(genType);
	local genList = genTypeProp.GenList;
	local posInfo;
	if genListIndex < genList:Count() then
		posInfo = genList:Element(genListIndex);
	end

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if isLeader == 1 then
			REQ_JOIN_GUILDEVENT(nil, nil, 1)
			--return;
	end
		local etcObj = GetMyEtcObject();

		if etcObj.GuildEventSelectTime ~= "None" and IsLaterThanByStr(etcObj.GuildEventSelectTime) == 0 then
			if etcObj.GuildEventStartTimeSave == partyObj.GuildEventBroadCastTime then
			frame:ShowWindow(0);
			return;
		end
		end
		
		
		frame:ShowWindow(1);
		if etcObj.GuildEventSeq == partyObj.GuildEventSeq then
			--frame:ShowWindow(0);
		else
	frame:ShowWindow(1);
		end

		local goalInfo = GET_CHILD_RECURSIVELY(frame, "goalInfo")
		goalInfo:SetTextByKey("value", guildEventCls.Name);

		local locationInfo = GET_CHILD_RECURSIVELY(frame, "locationInfo")
		local txt_locinfo = MAKE_LINK_MAP_TEXT_NO_POS(mapCls.ClassName, posInfo.x, posInfo.z);
		locationInfo:SetTextByKey("value", txt_locinfo);

		local memberCount =  GET_CHILD_RECURSIVELY(frame, "memberCount")
		memberCount:SetTextByKey("value", partyObj.GuildEventJoinCount);
		local aliveMemberCount = session.party.GetAliveMemberCount(PARTY_GUILD);
		memberCount:SetTextByKey("value2", aliveMemberCount);
		
	
	frame:RunUpdateScript("GUILDEVENTPOPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)

	local btn_join = GET_CHILD(frame, "btn_join");
		local btn_close = GET_CHILD(frame, "btn_close");
		
		if isLeader == 1 then
			btn_join:ShowWindow(0);
			btn_close:ShowWindow(0);
		elseif etcObj.GuildEventSeq == partyObj.GuildEventSeq then
			if IsLaterStrByStr(partyObj.GuildEventBroadCastTime, etcObj.GuildEventJoinSelectTime) == 1 then
			else
			btn_join:ShowWindow(0);
				btn_close:ShowWindow(0);
			end
		else
		btn_join:SetTextByKey("value", ScpArgMsg("Join"));
		btn_join:ShowWindow(1);
			btn_close:SetTextByKey("value", ScpArgMsg("GuildEventAgree"));
			btn_close:ShowWindow(1);
		end	
	
	elseif GuildRaidFlag == 1 then
		local sList = StringSplit(LocInfo, " ");
		local mapName = sList[1];
		local mapCls = GetClass("Map", mapName);
		local posX = tonumber(sList[2]);
		local posZ = tonumber(sList[4]);

		local isLeader = AM_I_LEADER(PARTY_GUILD);

		if isLeader == 1 then
			REQ_JOIN_GUILDEVENT(nil, nil, 1)
			--return;
		end
		frame:ShowWindow(1);
		local etcObj = GetMyEtcObject();

		if etcObj.GuildEventSelectTime ~= "None" and IsLaterThanByStr(etcObj.GuildEventSelectTime) == 0 then
			if etcObj.GuildEventStartTimeSave == partyObj.GuildEventBroadCastTime then
				frame:ShowWindow(0);
				return;
			end
		end

		if etcObj.GuildEventSeq == partyObj.GuildEventSeq then
			--frame:ShowWindow(0);
		else
			frame:ShowWindow(1);
		end

		local goalInfo = GET_CHILD_RECURSIVELY(frame, "goalInfo")
		goalInfo:SetTextByKey("value", guildEventCls.Name);

		local locationInfo = GET_CHILD_RECURSIVELY(frame, "locationInfo")
		local txt_locinfo = MAKE_LINK_MAP_TEXT_NO_POS(mapCls.ClassName, posX, posZ);
		locationInfo:SetTextByKey("value", txt_locinfo);
			
		local memberCount =  GET_CHILD_RECURSIVELY(frame, "memberCount")
		memberCount:SetTextByKey("value", partyObj.GuildEventJoinCount);
		local aliveMemberCount = session.party.GetAliveMemberCount(PARTY_GUILD);
		memberCount:SetTextByKey("value2", aliveMemberCount);
	
		frame:RunUpdateScript("GUILDEVENTPOPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)

		local btn_join = GET_CHILD(frame, "btn_join");
		local btn_close = GET_CHILD(frame, "btn_close");
		if isLeader == 1 then
			btn_join:ShowWindow(0);
			btn_close:ShowWindow(0);
		elseif etcObj.GuildEventSeq == partyObj.GuildEventSeq then
			if IsLaterStrByStr(partyObj.GuildEventBroadCastTime, etcObj.GuildEventJoinSelectTime) == 1 then
			else
			btn_join:ShowWindow(0);
			btn_close:ShowWindow(0);
			end
		else
			btn_join:SetTextByKey("value", ScpArgMsg("Join"));
			btn_join:ShowWindow(1);
			btn_close:SetTextByKey("value", ScpArgMsg("GuildEventAgree"));
			btn_close:ShowWindow(1);
		end		
	end

end

function REQ_JOIN_GUILDEVENT(parent, ctrl, isLeader)

	if isLeader ~= 1 then
		isLeader = 0
	end
	--local frame = parent:GetTopParentFrame();
--	frame:Set
	control.CustomCommand("GUILDEVENT_JOIN", isLeader);


end

function REQ_ClOSE_GUILDEVENT(parent, ctrl)

	local frame = parent:GetTopParentFrame();

	control.CustomCommand("GUILDEVENT_REFUSAL", frame:GetUserIValue("CLSSID"));

	frame:ShowWindow(0);

end

function GUILDEVENTPOPUP_UPDATE_STARTWAITSEC(frame)

	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local elapsedSec = frame:GetUserIValue("ELAPSED_SEC");
	local startSec = frame:GetUserIValue("START_SEC");
	local curSec = imcTime.GetAppTime() -  startSec + elapsedSec;
	local remainSec = startWaitSec - curSec;
	remainSec = math.floor(remainSec);
	if remainSec < 0 then
		frame:ShowWindow(0);
		return 0;
	end

	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(remainSec, startWaitSec);
	local txt_startwaittime = frame:GetChild("txt_startwaittime");	

	local remainMin = math.floor(remainSec / 60);
	local remainSec = remainSec % 60;
	local timeText = string.format("%d : %02d", remainMin, remainSec);
	txt_startwaittime:SetTextByKey("value", timeText);

	return 1;
end
