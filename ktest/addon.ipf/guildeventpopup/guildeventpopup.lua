function GUILDEVENTPOPUP_ON_INIT(addon, frame)
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_START", "ON_GUILD_EVENT_RECRUITING_START");		
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_END", "ON_GUILD_EVENT_RECRUITING_END");		
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_LIST", "ON_GUILD_EVENT_RECRUITING_LIST");		
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_ADD", "ON_GUILD_EVENT_RECRUITING_ADD");	
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_REMOVE", "ON_GUILD_EVENT_RECRUITING_REMOVE");	
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_IN", "ON_GUILD_EVENT_RECRUITING_IN");	
	addon:RegisterMsg("GUILD_EVENT_RECRUITING_OUT", "ON_GUILD_EVENT_RECRUITING_OUT");	
	addon:RegisterMsg("GUILD_EVENT_WAITING_LOCATION", "ON_GUILD_EVENT_WAITING_LOCATION");	
	GUILD_EVENT_TABLE = nil;
end

function ON_GUILD_EVENT_WAITING_LOCATION(frame, msg, argstr, argnum)
	local posList = StringSplit(argstr, ";");
	if #posList ~= 3 then
		return;
	end
	local pos = MakeVec3(posList[1], posList[2], posList[3])

	local mapCls = GetClassByType("Map", argnum);
	local txt_locinfo = MAKE_LINK_MAP_TEXT_NO_POS_NO_FONT(mapCls.ClassName, pos.x, pos.z);
	local locationInfo = GET_CHILD_RECURSIVELY(frame, "locationInfo")
	locationInfo:SetTextByKey("value", txt_locinfo);

	local mapprop = session.GetCurrentMapProp();
	if argnum == mapprop.type then
		session.minimap.AddIconInfo("GuildIndun", "trasuremapmark", pos, ClMsg("GuildEventLocal"), true, "None", 1.5);
	end
end

function INIT_GUILD_EVENT_TABLE(eventID, timeStr, recruitingSec, maxPlayerCnt)
	GUILD_EVENT_TABLE = {}
	GUILD_EVENT_TABLE.EVENT_ID = eventID;
	GUILD_EVENT_TABLE.START_TIME_STR = timeStr;
	GUILD_EVENT_TABLE.RECRUITING_SEC = recruitingSec;
	GUILD_EVENT_TABLE.MAX_PLAYER_CNT = maxPlayerCnt;
	GUILD_EVENT_TABLE.PARTICIPANTS = {};
	GUILD_EVENT_TABLE.GET_PARTICIPANT_CNT = 
	function() 
		local cnt = 0; 
	    for i, v in pairs(GUILD_EVENT_TABLE.PARTICIPANTS) do
      		cnt = cnt + 1;
    	end
	 	return cnt;
	 end;
end

function ON_GUILD_EVENT_RECRUITING_START(frame, msg, argstr, argnum)

	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");
	local groupbox_1 = GET_CHILD(frame, "groupbox_1");
	local locationInfo = GET_CHILD(groupbox_1, "locationInfo");
	local goalInfo = GET_CHILD(groupbox_1, "goalInfo");
	local eventCls = GetClassByType("GuildEvent", argnum);
	if eventCls == nil then
		return;
	end
	local mapCls = GetClass("Map", eventCls.StartMap);
	if mapCls == nil then
		return;
	end

	INIT_GUILD_EVENT_TABLE(argnum, argstr, eventCls.RecruitingSec, eventCls.MaxPlayerCnt)
	local isRefused = geClientGuildEvent.IsRefusedGuildEvent(GUILD_EVENT_TABLE.EVENT_ID, GUILD_EVENT_TABLE.START_TIME_STR) 
	if isRefused == true then
		return;
	end

	GUILD_EVENT_POPUP_UPDATE_STARTWAITSEC(frame)
	GUILDEVENTPOPUP_SET_PARTICIPANTS(frame, GUILD_EVENT_TABLE.PARTICIPANTS, GUILD_EVENT_TABLE.EVENT_ID)

	local mapName = dic.getTranslatedStr(mapCls.Name);
	local eventName = dic.getTranslatedStr(eventCls.Name);
	locationInfo:SetTextByKey("value", mapName);
	goalInfo:SetTextByKey("value", eventName);

	frame:RunUpdateScript("GUILD_EVENT_POPUP_UPDATE_STARTWAITSEC", 1, 0, 0, 1)
	btn_join:ShowWindow(1);
	btn_close:ShowWindow(1);
	frame:ShowWindow(1);
end

function ON_GUILD_EVENT_RECRUITING_END(frame, msg, argstr, argnum)
	if GUILD_EVENT_TABLE ~= nil and GUILD_EVENT_TABLE.START_TIME_STR ~= argstr then
		return;
	end

	GUILD_EVENT_TABLE = nil;
	
	GUILDEVENTPOPUP_SET_PARTICIPANTS(frame)
	frame:StopUpdateScript("GUILD_EVENT_POPUP_UPDATE_STARTWAITSEC");
	frame:ShowWindow(0);
end

function ON_GUILD_EVENT_RECRUITING_LIST(frame, msg, argstr, argnum)
	GUILD_EVENT_TABLE.PARTICIPANTS = {}
	local tokenList = StringSplit(argstr, ";");
    for i = 1, #tokenList do
        local token = tokenList[i];
        if token ~= "" then
            GUILD_EVENT_TABLE.PARTICIPANTS[token] = true;
        end
    end

	GUILDEVENTPOPUP_SET_PARTICIPANTS(frame)
end

function ON_GUILD_EVENT_RECRUITING_ADD(frame, msg, argstr, argnum)
	GUILD_EVENT_TABLE.PARTICIPANTS[argstr] = true;
	GUILDEVENTPOPUP_SET_PARTICIPANTS(frame)
end

function ON_GUILD_EVENT_RECRUITING_REMOVE(frame, msg, argstr, argnum)
	GUILD_EVENT_TABLE.PARTICIPANTS[argstr] = nil;
	GUILDEVENTPOPUP_SET_PARTICIPANTS(frame)
end

function ON_GUILD_EVENT_RECRUITING_IN(frame, msg, argstr, argnum)
	local btn_join = GET_CHILD(frame, "btn_join", "ui::CButton");
	local btn_close = GET_CHILD(frame, "btn_close", "ui::CButton");
	-- 일단 길드 이벤트 모집 시작한 사람(권한 있음)에게만 argnum이 1로 들어오도록 해놨으므로, 마감 또는 취소 기능은 시작한 사람만 가능하다.
	if argnum == 1 then
		btn_join:SetTextByKey('value', ScpArgMsg('RecruitmentEnd'));
		btn_join:SetEventScript(ui.LBUTTONUP, "GUILD_EVENT_RECRUIT_END");
		btn_close:SetTextByKey('value', ScpArgMsg('Cancel'));
		btn_close:SetEventScript(ui.LBUTTONUP, "GUILD_EVENT_RECRUIT_CANCEL");

		btn_join:ShowWindow(1);
		btn_close:ShowWindow(1);
	else
		btn_join:ShowWindow(0);
		btn_close:ShowWindow(0);
	end
end

function ON_GUILD_EVENT_RECRUITING_OUT(frame, msg, argstr, argnum)
	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");
	frame:ShowWindow(0);

	if GUILD_EVENT_TABLE ~= nil then
		geClientGuildEvent.SetRefusedGuildEvent(GUILD_EVENT_TABLE.EVENT_ID, GUILD_EVENT_TABLE.START_TIME_STR);
	end
end

function REQ_JOIN_GUILD_EVENT(parent, ctrl)
	control.CustomCommand("GUILDEVENT_JOIN", 0);
end

function REQ_ClOSE_GUILD_EVENT(parent, ctrl)
	control.CustomCommand("GUILDEVENT_REFUSAL", 0);
end

function GUILD_EVENT_POPUP_UI_RELOCATION(frame)
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
	backG:SetScrollBar(backG:GetHeight());
end;
function GUILDEVENTPOPUP_SET_PARTICIPANTS(frame)
	local participantCount = 0;
	if GUILD_EVENT_TABLE ~= nil then
		participantCount = GUILD_EVENT_TABLE.GET_PARTICIPANT_CNT();
	end

	local backG = GET_CHILD(frame, "bg");
	local groupbox_1 = GET_CHILD(frame, "groupbox_1");
	local txt_joined_member = GET_CHILD(backG, "txt_joined_member");
	local bgAccept = GET_CHILD(backG, "bgAccept");
	local memberCount = GET_CHILD(groupbox_1, "memberCount");
	memberCount:SetTextByKey("value", participantCount)
	memberCount:SetTextByKey("value2", session.party.GetAliveMemberCount(PARTY_GUILD))
	local strMember = string.format("%s/%s{/}", participantCount, session.party.GetAliveMemberCount(PARTY_GUILD));	
	txt_joined_member:SetTextByKey("value", strMember);
	local nHeight = txt_joined_member:GetY() + txt_joined_member:GetHeight();
	bgAccept:SetPos(bgAccept:GetX(), nHeight);

	GUILD_EVENT_POPUP_SET_UICONTROLSET(bgAccept, frame:GetUserConfig("AGREE_MEMBER_FACE_COLORTONE"), frame:GetUserConfig("AGREE_MEMBER_NAME_FONT_COLORTAG"));
	GUILD_EVENT_POPUP_UI_RELOCATION(frame);
end;

function GUILD_EVENT_POPUP_SET_UICONTROLSET(memberBox, MEMBER_FACE_COLORTONE, MEMBER_NAME_FONT_TAG)
	memberBox:RemoveAllChild();
	memberBox:Resize(memberBox:GetWidth(), 0);

	if GUILD_EVENT_TABLE == nil then
		return;
	end

	local aBoxItemHeight = 0;

	for aid, value in pairs(GUILD_EVENT_TABLE.PARTICIPANTS) do				
		local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, aid);
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

function GUILD_EVENT_POPUP_UPDATE_STARTWAITSEC(frame)
	if GUILD_EVENT_TABLE == nil then
		return 0;
	end
	local startTime = imcTime.GetSysTimeByStr(GUILD_EVENT_TABLE.START_TIME_STR);
	local currentTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(currentTime, startTime);
	local remainSec = GUILD_EVENT_TABLE.RECRUITING_SEC - difSec;
	if remainSec < 0 then
		remainSec = 0
	end

	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(remainSec, GUILD_EVENT_TABLE.RECRUITING_SEC);
	local txt_startwaittime = frame:GetChild("txt_startwaittime");	

	local remainMin = math.floor(remainSec / 60);
	local remainSec = remainSec % 60;
	local timeText = string.format("%d : %02d", remainMin, remainSec);
	txt_startwaittime:SetTextByKey("value", timeText);

	return 1;
end;

function REQ_GUILD_EVENT_RECRUIT_END()
	local handle = session.GetMyHandle()
	control.CustomCommand("REQ_GUILD_EVENT_RECRUIT_END", handle)
end

function GUILD_EVENT_RECRUIT_END()
	ui.MsgBox(ScpArgMsg("ReallyEndRecruit"), "REQ_GUILD_EVENT_RECRUIT_END", "None");
end

function REQ_GUILD_EVENT_RECRUIT_CANCEL()
	local handle = session.GetMyHandle()
	control.CustomCommand("REQ_GUILD_EVENT_RECRUIT_CANCEL", handle)
end

function GUILD_EVENT_RECRUIT_CANCEL()
	ui.MsgBox(ScpArgMsg("ReallyCancelRecruit"), "REQ_GUILD_EVENT_RECRUIT_CANCEL", "None");
end