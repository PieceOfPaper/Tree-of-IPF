
function GUILDEVENTPOPUP_ON_INIT(addon, frame)

	addon:RegisterMsg("GUILD_PROPERTY_UPDATE", "UPDATE_GUILD_EVENT_POPUP");
	addon:RegisterMsg("GUILD_INFO_UPDATE", "UPDATE_GUILD_EVENT_POPUP");
	addon:RegisterMsg('GAME_START', 'UPDATE_GUILD_EVENT_POPUP');			
	addon:RegisterMsg('PARTY_UPDATE', 'UPDATE_GUILD_EVENT_POPUP');			
end

function OPEN_GUILDEVENTPOPUP(frame)
	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if isLeader == 1 then
		REQ_JOIN_GUILDEVENT(frame, nil, 1)
	end

	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");

	btn_join:SetTextByKey("value", ScpArgMsg("Join"));
	btn_join:ShowWindow(1);
	btn_close:SetTextByKey("value", ScpArgMsg("GuildEventAgree"));
	btn_close:ShowWindow(1);
end

function UPDATE_GUILD_EVENT_POPUP()
	--여러 참여/거절 메세지가 동시에 올 경우에 Debouce 사용하면 갱신이 너무 늦어질 수 있으므로 Throttle 처리
	ThrottleScript("ON_UPDATE_GUILDEVENT_POPUP", 0.1);
end

function ON_UPDATE_GUILDEVENT_POPUP()
	local frame = ui.GetFrame("guildeventpopup");
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

	
	local currentTime = geTime.GetServerSystemTime();
	local startTime = imcTime.GetSysTimeByStr(partyObj.GuildEventStartTime);

	local difSec = imcTime.GetDifSec(currentTime, startTime);
	if difSec >= guildEventCls.StartWaitSec then
		return;
	end
	frame:SetUserValue("START_TIME", partyObj.GuildEventStartTime);

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
		
		local accObj = GetMyAccountObj();
		--�̺�Ʈ ����
		if IsLaterOrSameStrByStr(accObj.GuildEventSelectTime, partyObj.GuildEventBroadCastTime) == 1 and accObj.GuildEventSeq ~= partyObj.GuildEventSeq then
			frame:ShowWindow(0);
		else
			frame:ShowWindow(1);	
		end		

		local goalInfo = GET_CHILD_RECURSIVELY(frame, "goalInfo")
		goalInfo:SetTextByKey("value", guildEventCls.Name);

		local locationInfo = GET_CHILD_RECURSIVELY(frame, "locationInfo")
		local txt_locinfo = MAKE_LINK_MAP_TEXT_NO_POS_NO_FONT(mapCls.ClassName, posInfo.x, posInfo.z);
		locationInfo:SetTextByKey("value", txt_locinfo);

		local memberCount =  GET_CHILD_RECURSIVELY(frame, "memberCount")
		memberCount:SetTextByKey("value", partyObj.GuildEventJoinCount);
		local aliveMemberCount = session.party.GetAliveMemberCount(PARTY_GUILD);
		memberCount:SetTextByKey("value2", aliveMemberCount);
		
		frame:RunUpdateScript("GUILDEVENTPOPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)

		local btn_join = GET_CHILD(frame, "btn_join");
		local btn_close = GET_CHILD(frame, "btn_close");
		
		local isLeader = AM_I_LEADER(PARTY_GUILD);
		if (IsLaterOrSameStrByStr(accObj.GuildEventSelectTime, partyObj.GuildEventBroadCastTime) == 1 and accObj.GuildEventSeq == partyObj.GuildEventSeq)
			or isLeader == 1 then
			btn_join:ShowWindow(0);	
			btn_close:ShowWindow(0);
		end		
	elseif GuildRaidFlag == 1 then
		local sList = StringSplit(LocInfo, " ");
		local mapName = sList[1];
		local mapCls = GetClass("Map", mapName);
		local posX = tonumber(sList[2]);
		local posZ = tonumber(sList[4]);

		local accObj = GetMyAccountObj();
		--이벤트 거절
		if IsLaterOrSameStrByStr(accObj.GuildEventSelectTime, partyObj.GuildEventBroadCastTime) == 1 and accObj.GuildEventSeq ~= partyObj.GuildEventSeq then
			frame:ShowWindow(0);
			return;
		else
			frame:ShowWindow(1);
				
		end	
		
		local goalInfo = GET_CHILD_RECURSIVELY(frame, "goalInfo")
		goalInfo:SetTextByKey("value", guildEventCls.Name);

		local locationInfo = GET_CHILD_RECURSIVELY(frame, "locationInfo")
		local txt_locinfo = MAKE_LINK_MAP_TEXT_NO_POS_NO_FONT(mapCls.ClassName, posX, posZ);
		locationInfo:SetTextByKey("value", txt_locinfo);

		local memberCount =  GET_CHILD_RECURSIVELY(frame, "memberCount")
		memberCount:SetTextByKey("value", partyObj.GuildEventJoinCount);
		local aliveMemberCount = session.party.GetAliveMemberCount(PARTY_GUILD);
		memberCount:SetTextByKey("value2", aliveMemberCount);
	
		frame:RunUpdateScript("GUILDEVENTPOPUP_UPDATE_STARTWAITSEC", 0, 0, 0, 1)
		
		local btn_join = GET_CHILD(frame, "btn_join");
		local btn_close = GET_CHILD(frame, "btn_close");
		
		local isLeader = AM_I_LEADER(PARTY_GUILD);		
		--이미 선택함.
		if (IsLaterOrSameStrByStr(accObj.GuildEventSelectTime, partyObj.GuildEventBroadCastTime) == 1 and accObj.GuildEventSeq == partyObj.GuildEventSeq)
			or isLeader == 1 then
			btn_join:ShowWindow(0);	
			btn_close:ShowWindow(0);
		end	
	end
	
	GUILDEVENTPOPUP_SET_UIITEM(frame, partyObj, guildEventCls);
	
	GUILDEVENTPOPUP_UI_RELOCATION(frame);
end

function REQ_JOIN_GUILDEVENT(parent, ctrl, isLeader)

	if isLeader ~= 1 then
		isLeader = 0
	end

	local frame = parent:GetTopParentFrame();
	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");

	btn_join:ShowWindow(0);	
	btn_close:ShowWindow(0);
	control.CustomCommand("GUILDEVENT_JOIN", isLeader);
end

function REQ_ClOSE_GUILDEVENT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");
	
	btn_join:ShowWindow(0);	
	btn_close:ShowWindow(0);
	
	control.CustomCommand("GUILDEVENT_REFUSAL", frame:GetUserIValue("CLSSID"));

	frame:ShowWindow(0);

end

function GUILDEVENTPOPUP_UPDATE_STARTWAITSEC(frame)
	local startTime = imcTime.GetSysTimeByStr(frame:GetUserValue("START_TIME"));
	local currentTime = geTime.GetServerSystemTime();

	local difSec = imcTime.GetDifSec(currentTime, startTime);

	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local remainSec = startWaitSec - difSec;
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

function GUILDEVENTPOPUP_UI_RELOCATION(frame)

	local nHeight = 0;
	local gBox = GET_CHILD(frame, "groupbox_1");
	local txt_currentcount = GET_CHILD(frame, "txt_currentcount");
	nHeight = txt_currentcount:GetY() + txt_currentcount:GetHeight() + 10;
	gBox:SetPos(0, nHeight + 10);
	
	local txt_goal = GET_CHILD(gBox, "goal", "ui::CRichText");
	local txt_location = GET_CHILD(gBox, "location", "ui::CRichText");
	local txt_joincount = GET_CHILD(gBox, "txt_joincount", "ui::CRichText");	
	local txt_goalInfo = GET_CHILD(gBox, "goalInfo", "ui::CRichText");
	local txt_locationInfo = GET_CHILD(gBox, "locationInfo", "ui::CRichText");
	local txt_memberCount = GET_CHILD(gBox, "memberCount", "ui::CRichText");
	txt_goalInfo:SetPos(txt_goal:GetWidth(), 0);
	txt_location:SetPos(0, txt_goalInfo:GetHeight() - 5);
	txt_locationInfo:SetPos(txt_location:GetWidth(), txt_goalInfo:GetHeight() - 5);
	txt_joincount:SetPos(0, txt_locationInfo:GetHeight() - 5 + txt_locationInfo:GetY());	
	txt_memberCount:SetPos(txt_joincount:GetWidth(), txt_locationInfo:GetHeight() - 5 + txt_locationInfo:GetY());	

	nHeight = nHeight + gBox:GetHeight();
	
	local gaugeBar = GET_CHILD(frame, "gauge");
	local txt_startwaittime = GET_CHILD(frame, "txt_startwaittime");
	gaugeBar:SetPos(gaugeBar:GetX(), nHeight-10);
	txt_startwaittime:SetPos( 0 , nHeight - 3);

	nHeight = nHeight + gaugeBar:GetHeight() + 10;

	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");
	btn_join:SetPos(btn_join:GetX(),nHeight);
	btn_close:SetPos(btn_close:GetX(),nHeight);
	
	nHeight = nHeight + btn_join:GetHeight() + 10;

	local backG = GET_CHILD(frame, "bg");
	backG:SetPos(backG:GetX(), nHeight);
	backG:Resize(backG:GetWidth(), frame:GetHeight() - nHeight - 20);
end;

function GUILDEVENTPOPUP_SET_UIITEM(frame, partyObj, guildEventCls)
	local playerCnt = guildEventCls.PlayerCnt;	
	local backG = GET_CHILD(frame, "bg");
	local txt_joined_member = GET_CHILD(backG, "txt_joined_member");
	local txt_refused_member = GET_CHILD(backG, "txt_refused_member");
	local bgAccept = GET_CHILD(backG, "bgAccept");
	local bgRefuse = GET_CHILD(backG, "bgRefuse");
	local nHeight = txt_joined_member:GetY();

	local strMember = string.format("%s/%s{/}", partyObj.GuildEventJoinCount, playerCnt);	
	txt_joined_member:SetTextByKey("value", strMember);
	nHeight = nHeight + txt_joined_member:GetHeight();
	bgAccept:SetPos(bgAccept:GetX(), nHeight);

	GUILDEVENTPOPUP_SET_UICONTROLSET(partyObj, "GuildEventAceeptedAID_", frame:GetUserConfig("AGREE_MEMBER_FACE_COLORTONE"), frame:GetUserConfig("AGREE_MEMBER_NAME_FONT_COLORTAG"), bgAccept);
	GUILDEVENTPOPUP_SET_UICONTROLSET(partyObj, "GuildEventRefusedAID_", frame:GetUserConfig("REFUSE_MEMBER_FACE_COLORTONE"), frame:GetUserConfig("REFUSE_MEMBER_NAME_FONT_COLORTAG"), bgRefuse);

	nHeight = nHeight + bgAccept:GetHeight() + 15;
	txt_refused_member:SetPos(txt_refused_member:GetX(), nHeight);
	nHeight = nHeight + txt_refused_member:GetHeight();
	bgRefuse:SetPos(bgRefuse:GetX(), nHeight);
	nHeight = nHeight + bgRefuse:GetHeight();
	backG:SetScrollBar(backG:GetHeight());
	bgRefuse:Resize(bgRefuse:GetWidth(), bgRefuse:GetHeight() + 20);
end;

function GUILDEVENTPOPUP_SET_UICONTROLSET(partyObj, propName, MEMBER_FACE_COLORTONE, MEMBER_NAME_FONT_TAG, memberBox)
	local aBoxItemHeight = 0;
	local eventMemberMaxCount = 30;
	memberBox:RemoveAllChild();
	memberBox:Resize(memberBox:GetWidth(), 0);

	
	for i = 0 , eventMemberMaxCount - 1 do				
	   	local tempText = string.format("%s%02d",  propName, i+1);
		local writedAid = TryGetProp(partyObj, tempText);

		local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, writedAid);
		if memberInfo ~= nil then
			local partyMemberName = memberInfo:GetName();		
			local ctrlSet = memberBox:CreateControlSet("guildEvent_popup_listItem", memberInfo:GetAID(), ui.LEFT, ui.TOP, 0, aBoxItemHeight, 0, 0);
			
			local jobIcon = GET_CHILD(ctrlSet, "jobportrait");
			local nameObj = ctrlSet:GetChild('name_text');
				
			local iconinfo = memberInfo:GetIconInfo();
			local jobCls  = GetClassByType("Job", iconinfo.job);
			if nil ~= jobCls then						
				jobIcon:SetImage(jobCls.Icon);
				jobIcon:SetTextTooltip(GET_JOB_NAME(jobCls, iconinfo.gender));
			end											
			jobIcon:SetColorTone(MEMBER_FACE_COLORTONE)
			local nameText = string.format("%s%s", MEMBER_NAME_FONT_TAG, partyMemberName);
			partyMemberName = nameText;
			nameObj:SetTextByKey("name", partyMemberName);		
				
			-- 파티원 레벨 표시 -- 
			local levelRichText = ctrlSet:GetChild('level_text');
			local level = memberInfo:GetLevel();	
			local lvText = string.format("%s%s %d",MEMBER_NAME_FONT_TAG, ScpArgMsg("Level"), level); 
			levelRichText:SetTextByKey("lv",  lvText);
			aBoxItemHeight = aBoxItemHeight + nameObj:GetHeight() + 5;
			memberBox:Resize(memberBox:GetWidth(), aBoxItemHeight);		
		end
	end
end;