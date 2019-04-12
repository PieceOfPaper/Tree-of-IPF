function WORLDPVP_ON_INIT(addon, frame)
	addon:RegisterMsg("PVP_TIME_TABLE", "ON_PVP_TIME_TABLE");
	addon:RegisterMsg("PVP_PC_INFO", "ON_PVP_PC_INFO");
	addon:RegisterMsg("PVP_STATE_CHANGE", "ON_PVP_STATE_CHANGE");
	addon:RegisterMsg("PVP_PROPERTY_UPDATE", "ON_PVP_PROPERTY_UPDATE");
	addon:RegisterMsg("PVP_HISTORY_UPDATE", "ON_PVP_HISTORY_UPDATE");
	addon:RegisterMsg("WORLDPVP_RANK_PAGE", "ON_WORLDPVP_RANK_PAGE");
	addon:RegisterMsg("WORLDPVP_RANK_ICON", "ON_WORLDPVP_RANK_ICON");
	addon:RegisterMsg("PLAY_COUNT_MAX", "ON_PLAY_COUNT_MAX");
    addon:RegisterMsg('UPDATE_WORLDPVP_GAME_LIST', 'WORLDPVP_PUBLIC_GAME_LIST');
end

g_enablePVPExp = 1;

function ON_PLAY_COUNT_MAX(frame, msg)	

	local resetTime = RANK_RESET_HOUR % 12;
	local isPM = RANK_RESET_HOUR / 2;

	if resetTime == 0 then
		resetTime = 12;
	end

	local ampm;
	if isPM == 1 then
		ampm = ScpArgMsg("PM");
	else
		ampm = ScpArgMsg("AM");
	end
	
	ui.SysMsg(ScpArgMsg("MAXPVPEnterCount{AMPM}{TIME}",'AMPM', ampm, 'TIME', resetTime));

	local playGuildBattle = false;
	
	frame = ui.GetFrame("worldpvp");
	local cnt = session.worldPVP.GetPlayTypeCount();
	for i = 0, cnt -1 do
		local type = session.worldPVP.GetPlayTypeByIndex(i);
		if type == 210 then
			frame = ui.GetFrame("guildbattle_league");
		end
	end
	
	local bg = frame:GetChild("bg");
	local loadingtext = bg:GetChild("loadingtext");
	local charinfo = bg:GetChild("charinfo");
	local joinBtn = charinfo:GetChild("join");
	joinBtn:SetEnable(1);
end

function WORLDPVP_FIRST_OPEN(frame)
	frame:SetUserValue("DROPLIST_CREATED", 1);
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	local bg_ranking = frame:GetChild("bg_ranking");
	local droplist_rank = GET_CHILD(bg_ranking, "droplist", "ui::CDropList");

	droplist:ClearItems();
	droplist_rank:ClearItems();
	local clsList, cnt = GetClassList("WorldPVPType");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.MatchType ~="Guild" then
			droplist:AddItem(cls.ClassID, "{@st42}" .. cls.Name);
			droplist_rank:AddItem(cls.ClassID, "{@st42}" .. cls.Name);		
		end
	end

	droplist:SelectItemByKey(1);

	if cnt <= 1 then
		droplist:ShowWindow(0);
		droplist_rank:ShowWindow(0);
	end
	
	local btnReward = bg_ranking:GetChild("btn_reward");
	btnReward:SetVisible(0);

	OPEN_WORLDPVP(frame);
	ON_PVP_HISTORY_UPDATE(frame);
end

function WORLDPVP_ON_RELOAD(frame)
	WORLDPVP_FIRST_OPEN(frame);
end

function CLOSE_WORLDPVP(frame)
	local popup = ui.GetFrame("minimizedalarm");
	ON_PVP_PLAYING_UPDATE(popup);
end

function OPEN_WORLDPVP(frame)

	local title = frame:GetChild("title");
	title:SetTextByKey("value", ScpArgMsg("TeamBattleLeague"));
    
	local tab = GET_CHILD(frame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end
	
	local bg = frame:GetChild("bg");
	local loadingtext = bg:GetChild("loadingtext");
	local charinfo = bg:GetChild("charinfo");

	WORLDPVP_SET_UI_MODE(frame, "");
	local ret = worldPVP.RequestPVPInfo();
	if ret == false then
		ON_PVP_TIME_TABLE(frame);
	else
		loadingtext:ShowWindow(1);
	    charinfo:ShowWindow(0);
	end
	
	local join = charinfo:GetChild("join");
	join:SetEnable(0);
	
	local cnt = session.worldPVP.GetPlayTypeCount();
	if cnt > 0 then
		local isGuildBattle = 0;
		for i = 1, cnt do
			local type = session.worldPVP.GetPlayTypeByIndex(i);
			if type == 210 then
				isGuildBattle = 1;
				break;
			end
		end

		if isGuildBattle == 0 then
			join:SetEnable(1);
		end
	end

	UPDATE_WORLDPVP(frame);
	ON_PVP_STATE_CHANGE(frame);
end

function GET_AM_HOUR_MINUTE(minute)
	local h = math.floor(minute / 60);
	local m = minute - h * 60;
	local am = "AM";
	if h > 12 then
		am = "PM";
		h = h - 12;
	end

	return string.format("%s %02d:%02d", am, h, m);
end

function SET_PVP_TYPE_PROP(bg, pvpObj, clsName, ctrlName, propName, defValue)
	local ctrl = bg:GetChild(ctrlName);
	if ctrl ~= nil then
		local objPropName = clsName .. "_" .. propName;
		local propValue = pvpObj:GetPropValue(objPropName, defValue);
		ctrl:SetTextByKey("value", propValue);
	end
end

function ON_PVP_PROPERTY_UPDATE(frame)
	UPDATE_WORLDPVP(frame);
end

function ON_PVP_PC_INFO(frame)
	UPDATE_WORLDPVP(frame);
	ON_PVP_HISTORY_UPDATE(frame);
end

function GET_PVP_OBJECT_FOR_TYPE(cls)
	if cls.MatchType =="Guild" then
		local pcparty = session.party.GetPartyInfo(PARTY_GUILD);

		if pcparty == nil then -- dummyScore
			local mySession = session.GetMySession();
			local cid = mySession:GetCID();
			return session.worldPVP.GetPVPObject(cid);
		end
		local partyID = pcparty.info:GetPartyID();	
		return session.worldPVP.CreatePVPObject(partyID);
	else
		local mySession = session.GetMySession();
		local cid = mySession:GetCID();
		return session.worldPVP.GetPVPObject(cid);
	end
end

function UPDATE_WORLDPVP(frame)
	local bg = frame:GetChild("bg");
	local loadingtext = bg:GetChild("loadingtext");
	local charinfo = bg:GetChild("charinfo");
    local gbox_playcnt = GET_CHILD(charinfo, "gbox_playcnt");

	loadingtext:ShowWindow(0);
    charinfo:ShowWindow(1);
	gbox_playcnt:ShowWindow(0);
	
	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	local pvpType = droplist:GetSelItemKey();
	local cls = GetClassByType("WorldPVPType", tonumber(pvpType));
	if cls == nil then
		return;
	end
	local clsName = cls.ClassName;

	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(cls);
	if nil == pvpObj then
		return;
	end

	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "rp", "RP", 1000);
	local teer = charinfo:GetChild("teer")
	local objPropName = clsName .. "_GRADE";
	if teer ~= nil then
		local gradeValue = pvpObj:GetPropIValue(objPropName, 0);
		if gradeValue == 0 then
			teer:SetTextByKey("value", "");
		else
			local baseGrade = math.floor(gradeValue / 10);
			local semiGrade = gradeValue % 10;
			local gradeCls = GetClassByType("WorldPVPGrade", baseGrade);
			local gradeText = string.format("{img %s 32 32} %s %d", gradeCls.Image, gradeCls.Name, semiGrade + 1);
			teer:SetTextByKey("value", gradeText);
		end
	end
	

	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "win", "WIN", 0);
	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "lose", "LOSE", 0);
	
	local curDateString = imcTime.GetCurDateString();
	local lastPointGetDateName = GetPVPPointPropName(clsName, "LastPointGetDate");
	local todayGetShopPointName = GetPVPPointPropName(clsName, "TodayGetShopPoint");
	local shopPointName = GetPVPPointPropName(clsName, "ShopPoint");
    
	local joinBtn = charinfo:GetChild("join");
	local isPlaying = session.worldPVP.IsPlayingType(pvpType);
	if isPlaying == true then
		joinBtn:SetEnable(1);
	else
		joinBtn:SetEnable(0);
	end

	if cls.MatchType == "Guild" then
		local isLeader = AM_I_LEADER(PARTY_GUILD);
		if isLeader == 0 then
			local pvpGuid = frame:GetUserIValue("GUILD_PVP_GUID_" .. pvpType);
			if pvpGuid == 0 then
				joinBtn:SetEnable(0);
				joinBtn:SetTextTooltip("");
			else										
				local zonePCCount = frame:GetUserIValue("GUILD_PVP_PCCOUNT_" .. pvpType);
				local tooltipString = string.format("(%d/%d)", zonePCCount, cls.MaxGuildPlayer);
				joinBtn:SetTextTooltip(tooltipString);
				joinBtn:SetEnable(1);
			end
		end
		gbox_playcnt:ShowWindow(1);
		SET_PVP_TYPE_PROP(gbox_playcnt, pvpObj, clsName, "todaycnt", "Cnt", 0);
		GUILDBATTLE_LEAGUE_SET_GUILDPVP_TYPE_PROP(gbox_playcnt, "guildCnt", "Guild", "GuildBattleWeeklyJoinCnt");
		GUILDBATTLE_LEAGUE_SET_GUILDPVP_TYPE_PROP(gbox_playcnt, "myCnt", "Account", "GuildBattleWeeklyPlayCnt");

	end

end

function JOIN_WORLDPVP(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	local pvpType = droplist:GetSelItemKey();	

	local cls = GetClassByType("WorldPVPType", pvpType);
	if nil == cls then
		ui.SysMsg(ScpArgMsg("DonotOpenPVP"))
		return;
	end
	
	if cls.MatchType == "Guild" then
		local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
		if pcparty == nil then
			ui.SysMsg(ScpArgMsg("PleaseJoinGuild"));
			return;
		end
	end

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	
	if cls.MatchType ~= "Guild" or isLeader == 0 then
		JOIN_WORLDPVP_BY_TYPE(frame, pvpType);
		return;
	end

	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(cls);
	if nullptr == pvpObj then
		ui.SysMsg(ScpArgMsg("DonotOpenPVP"))
		return;
	end
	
	local myCnt = pvpObj:GetPropValue(cls.ClassName .. "_Cnt", 0);
	local yesScp = string.format("NOTICE_AND_CHECK_PVP_COUNT(%d, %d)", pvpType, myCnt) 
	
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_PLAYING then
		ui.MsgBox(ScpArgMsg("ExistsPlayingPVP"), yesScp, "None");	
	elseif state == PVP_STATE_NONE then
		local msg = ScpArgMsg("PVPEnter{COUNT}{MAX}",'COUNT',myCnt, 'MAX',cls.MaxPlayCount )
		ui.MsgBox(msg, yesScp, "None");
	elseif state == PVP_STATE_FINDING then
		local msg = ScpArgMsg("AskPVPEnterCancel")
		ui.MsgBox(msg, yesScp, "None");
	end
end

function NOTICE_AND_CHECK_PVP_COUNT(pvpType, playCnt)
	local cls = GetClassByType("WorldPVPType", pvpType);
	if nil == cls then
		return;
	end

	if cls.MatchType ~= "Guild" then
		return;
	end

	JOIN_WORLDPVP_BY_TYPE(ui.GetFrame('guildbattle_league'), pvpType);
end

function JOIN_WORLDPVP_BY_TYPE(frame, pvpType)
	local bg = frame:GetChild("bg");
	local cls = GetClassByType("WorldPVPType", pvpType);
    local join = nil;
    if bg ~= nil then
	    local charinfo = bg:GetChild("charinfo");
	    join = charinfo:GetChild("join");
    else
        join = GET_CHILD_RECURSIVELY(frame, 'teamBattleMatchingBtn');
    end
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_NONE then

		if cls.Party == 0 then
			if session.GetPcTotalJobGrade() < WORLDPVP_MIN_JOB_GRADE and cls.MatchType ~= "Guild" then
				local msg = ScpArgMsg("OnlyAbleOver{Rank}", "Rank", WORLDPVP_MIN_JOB_GRADE);
				ui.MsgBox(msg);
				 return;
			end

			if cls.MatchType == "Guild" then
				local isLeader = AM_I_LEADER(PARTY_GUILD);
				if isLeader == 1 then
					worldPVP.ReqJoinPVP(pvpType, PVP_STATE_FINDING);
					join:SetEnable(0);
				else
					local pvpGuid = frame:GetUserIValue("GUILD_PVP_GUID_" .. pvpType);
					if pvpGuid > 0 then
						worldPVP.ReqJoinGuildPVP(pvpType, pvpGuid)
					else
						ui.SysMsg(ScpArgMsg("DonotPlayGuildBattleYet"))
						return;
					end
				end
			else
				worldPVP.ReqJoinPVP(pvpType, PVP_STATE_FINDING);
				join:SetEnable(0);
			end
		else
			local partyMemberList = session.party.GetPartyMemberList(PARTY_NORMAL);
			local curCount = 0;
			if partyMemberList ~= nil then
				local count = partyMemberList:Count();
				for i = 0 , count - 1 do
					local partyMemberInfo = partyMemberList:Element(i);
					if partyMemberInfo:GetMapID() > 0 then
						curCount = curCount + 1;
					end
				end
			end

			if curCount < cls.PlayerCnt then
				local strBuf = string.format(ClMsg("NotEnoughPartyMember(%d/%d)"), curCount, cls.PlayerCnt);
				ui.SysMsg(strBuf);
				return;
			end
		
			worldPVP.ReqInvitePartyPVP(pvpType);
			ui.MsgBox(ClMsg("InvitedPartyMembers_WaitAccept"));
		end

	elseif state == PVP_STATE_FINDING then
		worldPVP.ReqJoinPVP(pvpType, PVP_STATE_NONE);
		join:SetEnable(0);
	elseif state == PVP_STATE_PLAYING then

		if cls.MatchType == "Guild" then
			local pvpGuid = frame:GetUserIValue("GUILD_PVP_GUID_" .. pvpType);
			if pvpGuid > 0 then
				worldPVP.ReqJoinGuildPVP(pvpType, pvpGuid);
			end
		end
	end

end

function ON_PVP_STATE_CHANGE(frame, msg, pvpType)
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local state = session.worldPVP.GetState();

	local stateText = GetPVPStateText(state);
	local viewText = ClMsg( "PVP_State_".. stateText );
	local join = charinfo:GetChild("join");
	join:SetTextByKey("text", viewText);

	if state == PVP_STATE_FINDING then
		local bg = frame:GetChild("bg");
		local charinfo = bg:GetChild("charinfo");
		local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
		if nil == pvpType then
			return;
		end
		pvpType = tonumber(pvpType);
		pvpType = math.floor(pvpType);
		pvpType = tostring(pvpType);
		local curType = droplist:GetSelItemKey();
		if curType ~= pvpType then
			droplist:SelectItemByKey(pvpType);
			UPDATE_WORLDPVP(frame);
		end
	elseif state == PVP_STATE_READY then
		local cls = GetClassByType("WorldPVPType", pvpType);
		if cls.MatchType ~= "Guild" then
			return;
		end
		local isLeader = AM_I_LEADER(PARTY_GUILD);
		if 1 ~= isLeader then
			return;
		end
		ui.Chat("/sendMasterEnter");
	end

	if 1 == ui.IsFrameVisible("worldpvp_ready") then
		WORLDPVP_READY_STATE_CHANGE(state, pvpType);
	end
end

function WORLDPVP_TYPE_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	UPDATE_WORLDPVP(frame);

	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local droplist = GET_CHILD(charinfo, "droplist");
	local bg_ranking = frame:GetChild("bg_ranking");
	if nil == bg_ranking then
		return;
	end
	local droplist_rank = GET_CHILD(bg_ranking, "droplist");
	if nil == droplist_rank then	
		return;
	end
	droplist_rank:SelectItemByKey(droplist:GetSelItemKey());
	local pvpCls = GetClassByType("WorldPVPType", droplist:GetSelItemKey());
	if pvpCls.MatchType == "Guild" then
		WORLDPVP_REQUEST_RANK(frame, 1, 1);
	end
	
end

function WORLDPVP_RANK_TYPE_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	WORLDPVP_REQUEST_RANK(frame, 1, 1);
end

function ON_PVP_TIME_TABLE(frame)

	local bg = frame:GetChild("bg");
	local timetable = bg:GetChild("timetable");
	local tbg = timetable:GetChild("tbg");
	local time_text = tbg:GetChild("time_text");

	local txt = ""; -- frame:GetUserConfig("TIME_TABLE_FONT");
	local sysTime = geTime.GetServerSystemTime();
	local cnt = session.worldPVP.GetPVPTableCount();
	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetPVPTableByIndex(i);
		
		local todayCnt = session.worldPVP.CreateDayOfWeekVec(info, sysTime.wDayOfWeek);
		if todayCnt > 0 then
			local cls = GetClassByType("WorldPVPType", info.type);
			txt = txt .. string.format("%s{nl}", cls.Name);
			for j = 0 , todayCnt - 1 do
				local timeInfo = session.worldPVP.GetTodayTime(j);
				local startTxt = GET_AM_HOUR_MINUTE(timeInfo.startMin);
				local endTxt = GET_AM_HOUR_MINUTE(timeInfo.endMin);
				txt = txt .. string.format("%s ~ %s{nl}", startTxt, endTxt);
			end
		end
		
	end

	time_text:SetTextByKey("value", txt);
	
end

function ON_PVP_HISTORY_UPDATE(frame)

	local bg = frame:GetChild("bg");
	local recent = bg:GetChild("recent");
	local rbg = recent:GetChild("rbg");

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if nullptr == pvpObj then
		return;
	end

	DESTROY_CHILD_BYNAME(rbg, "HISTORY_");
	local cnt = pvpObj:GetHistoryCount();
	for i = 0 , cnt - 1 do
		local pvp_history = rbg:CreateControlSet("pvp_history", "HISTORY_" .. i, ui.LEFT, ui.TOP, 10, 0, 0, 0);

		local name = pvp_history:GetChild("name");
		local time = pvp_history:GetChild("time");
		local score = pvp_history:GetChild("score");

		local historyInfo = pvpObj:GetHistoryByIndex(cnt - 1 - i);
		local historyCls = GetClassByType("WorldPVPType", historyInfo.type);
		name:SetTextByKey("value", historyCls.Name);
		local sysTime = imcTime.ImcTimeToSysTime(historyInfo:GetTime());
		local timeText = string.format("%02d-%02d %0d:%0d", sysTime.wMonth, sysTime.wDay, sysTime.wHour, sysTime.wMinute);
		time:SetTextByKey("value", timeText);
		
		local pointStr;
		if historyInfo.addPoint > 0 then
			pointStr = "+" .. historyInfo.addPoint;
		else
			pointStr = historyInfo.addPoint;
		end
		score:SetTextByKey("value", pointStr);
	end	

	GBOX_AUTO_ALIGN(rbg, 35, 0, 10, true, false);

end

function WORLDPVP_REQUEST_RANK(frame, page, findMyRanking)

	local bg = frame:GetChild("bg");
	local bg_ranking = frame:GetChild("bg_ranking");
	local droplist_rank = GET_CHILD(bg_ranking, "droplist", "ui::CDropList");
	local pvpType = droplist_rank:GetSelItemKey();
	local cls = GetClassByType("WorldPVPType", pvpType);
	
	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(cls);
	if nullptr == pvpObj then
		return;
	end

	local bg_ranking = frame:GetChild("bg_ranking");
	local input_findname = GET_CHILD(bg_ranking, "input_findname", "ui::CEditControl");

	if findMyRanking == nil then
		findMyRanking = 0;
	end

	worldPVP.RequestPVPRanking(pvpType, 0, -1, page, findMyRanking, input_findname:GetText());
	worldPVP.RequestGuildBattlePrevSeasonRanking(pvpType);

end

function WORLDPVP_OBSERVE_UI(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	worldPVP.RequestPublicGameList();
	WORLDPVP_SET_UI_MODE(frame, "observer");

		end
				
function REFRESH_PVP_OBSERVE_LIST()
	worldPVP.RequestPublicGameList();
end

function WORLDPVP_SHOW_RANKING(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	WORLDPVP_REQUEST_RANK(frame, 1, 1);
	WORLDPVP_SET_UI_MODE(frame, "ranking");
				
end

function SHOW_WORLDPVP_PAGE(parent)
	local frame = parent:GetTopParentFrame();
	WORLDPVP_SET_UI_MODE(frame, "");
end

function WORLDPVP_SET_UI_MODE(frame, uiType)
	local bg_ranking = frame:GetChild("bg_ranking");
	local bg_observer = frame:GetChild("bg_observer");
	local bg = frame:GetChild("bg");
	bg_ranking:ShowWindow(0);
	bg_observer:ShowWindow(0);
	bg:ShowWindow(0);
	if uiType == "" then
		bg:ShowWindow(1);
	else
		local openBG = frame:GetChild("bg_" .. uiType);
		openBG:ShowWindow(1);
	end
	
	
end

function UPDATE_PVP_RANK_CTRLSET(ctrlSet, info)
	local iconInfo = info:GetIconInfo();
	local key = info:GetCID();
	local myName = GETMYFAMILYNAME();
	local isMyAccount = false;
	if myName == iconInfo:GetFamilyName() then
		isMyAccount = true;
	end

	local imgName = GET_JOB_ICON(iconInfo.job);

	local txt_name = ctrlSet:GetChild("txt_name");
	local pic = GET_CHILD(ctrlSet, "pic");
	ctrlSet:SetUserValue("CID", key);
	if isMyAccount == true then
		txt_name:SetTextByKey("value", "{#0000FF}" .. iconInfo:GetGivenName() .. "{nl}" .. iconInfo:GetFamilyName());
	else
		txt_name:SetTextByKey("value", iconInfo:GetGivenName() .. "{nl}" .. iconInfo:GetFamilyName());
	end

	local txt_point = ctrlSet:GetChild("txt_point");
	if txt_point ~= nil then
		txt_point:SetTextByKey("value", info.point);
	end

	pic:SetImage(imgName);

	local txt_rank = ctrlSet:GetChild("txt_rank");
	txt_rank:SetTextByKey("value", info.ranking + 1);

end

function ON_WORLDPVP_RANK_PAGE(frame)

	local bg_ranking = frame:GetChild("bg_ranking");

	local type = session.worldPVP.GetRankProp("Type");
	local cls = GetClassByType("WorldPVPType", type);

	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");

	local cnt = session.worldPVP.GetRankInfoCount();
	local gbox_ctrls = bg_ranking:GetChild("gbox_ctrls");
	gbox_ctrls:RemoveAllChild();

	if cls.MatchType == "Guild" then
		OPEN_GUILDBATTLE_RANKING_FRAME(0);
		return;
	end

	local rankPageFont = frame:GetUserConfig("RANK_PAGE_FONT");

	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = gbox_ctrls:CreateControlSet("pvp_rank_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);

	end

	GBOX_AUTO_ALIGN(gbox_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor((totalCount + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(bg_ranking, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);
	control:SetUserValue("PAGE", page);
	
	local btnReward = bg_ranking:GetChild("btn_reward");
    
	local cid = session.GetMySession():GetCID();
	local myRank = session.worldPVP.GetPrevRankInfoByCID(cid);
	if myRank ~= nil then
		-- 1,2,3� �����ش�.
		if myRank.ranking < 3 then
			btnReward:SetVisible(1);
		end
	else
		btnReward:SetVisible(0);
	end
end

function ON_WORLDPVP_RANK_ICON(frame, msg, cid, argNum, info)

	local bg_ranking = frame:GetChild("bg_ranking");
	local gbox_ctrls = bg_ranking:GetChild("gbox_ctrls");
	local ctrlSet = GET_CHILD_BY_USERVALUE(gbox_ctrls, "CID", cid);
	if ctrlSet ~= nil then
		info = tolua.cast(info, "WORLD_PVP_RANK_INFO_C");
		UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);
	end
	
	
	

end

function WORLDPVP_RANK_SELECT_PREV(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg_ranking = frame:GetChild("bg_ranking");
	local control = GET_CHILD(bg_ranking, "control", 'ui::CPageController')
	local page = control:GetUserIValue("PAGE");
	
	WORLDPVP_REQUEST_RANK(frame, page - 1 );
	ui.DisableForTime(control, 0.5);

end

function WORLDPVP_RANK_SELECT_NEXT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg_ranking = frame:GetChild("bg_ranking");
	local control = GET_CHILD(bg_ranking, "control", 'ui::CPageController')
	local page = control:GetUserIValue("PAGE");
	
	WORLDPVP_REQUEST_RANK(frame, page + 1);
	ui.DisableForTime(control, 0.5);

end

function WORLDPVP_RANK_SELECT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg_ranking = frame:GetChild("bg_ranking");
	local control = GET_CHILD(bg_ranking, "control", 'ui::CPageController')
	
	WORLDPVP_REQUEST_RANK(frame, control:GetCurPage() + 1);

end

function WORLDPVP_GET_EXP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if nullptr == pvpObj then
		return;
	end

	local curExpPoint = pvpObj:GetPropIValue("ExpPoint", 0);
	if curExpPoint == 0 then
		return;
	end

	worldPVP.RequestGetExp(curExpPoint);
		
end

function GET_PVP_POINT_C()
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if pvpObj == nil then
		return 0;
	end

	return pvpObj:GetPropIValue("ShopPoint", 0);
end

function PVP_CARD_GET_ITEM_C()

	local level = GETMYPCLEVEL();
	local name, count = GetWorldPVPExpCard(level);
	local text = ScpArgMsg("DifferentByPCLevel");
	return name, count, text;

end

function WORLDPVP_READY_STATE_CHANGE(state, pvpType)
	if state == PVP_STATE_NONE then
		ui.CloseFrame("worldpvp_ready");
	else
		WORLDPVP_READY_UI(pvpType);
	end
end

function WORLDPVP_READY_TIME(readyTime)
	local frame = ui.GetFrame("worldpvp_ready");
	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(100, 100);
	gauge:SetPointWithTime(0, readyTime * 0.001);
	frame:ReserveScript("PVP_READY_ACCEPT", 5, 0);
end

function WORLDPVP_READY_UI(pvpType)
	local frame = ui.GetFrame("worldpvp_ready");
	frame:ShowWindow(1);

	local readyCount = session.worldPVP.GetReadyCount();
	local notReadyCount = session.worldPVP.GetNotReadyCount();
	if notReadyCount == 0 then
		local gauge = GET_CHILD(frame, "gauge");
		gauge:StopTimeProcess();
	end

	local state = session.worldPVP.GetState();

	local gbox = frame:GetChild("gbox");
	gbox:RemoveAllChild();
	gbox:Resize(frame:GetWidth(), gbox:GetHeight());

	local pictureIndex = 0;
	for i = 0 , readyCount - 1 do
		local pic = gbox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 30, 30, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetImage("house_change_man");
		pictureIndex = pictureIndex + 1;
	end

	for i = 0 , notReadyCount - 1 do
		local pic = gbox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 30, 30, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetColorTone("FF222222");
		pic:SetImage("house_change_man");
		pictureIndex = pictureIndex + 1;
	end
	
	GBOX_AUTO_ALIGN_HORZ(gbox, 0, 0, 0, true, true);
	
	local isGuildPVP = false;
	local cls = GetClassByType("WorldPVPType", tonumber(pvpType));
	if nil ~= cls then
		if TryGetProp(cls, "MatchType") == "Guild" then
			isGuildPVP = true;
		end
	end
end

function PVP_READY_ACCEPT(parent, ctrl)
	worldPVP.SendReadyState();
end

function WORLDPVP_INVITE_FROM_PARTY(inviterName, idx, pvpType, accountID)

	local cls = GetClassByType("WorldPVPType", pvpType);
	if cls == nil then
		return;
	end

	local msgString = ScpArgMsg("{Name}InvitedYouTo{PVPName}_JoinIt?", "Name", inviterName, "PVPName", cls.Name);

	local yesScp = string.format("ACCEPT_PVP_PARTY(\"%s\", %d, 1)", accountID, idx);
	local noScp = string.format("ACCEPT_PVP_PARTY(\"%s\", %d, 0)", accountID, idx);
	ui.MsgBox(msgString, yesScp, noScp);

end

function ACCEPT_PVP_PARTY(accountID, idx, isAccept)

	worldPVP.AcceptPVPPartyInvite(accountID, idx, isAccept);	
	
end


function WORLDPVP_OBSERVER_GET_TEAM_STR(teamName, jobID)
	local jobCls = GetClassByType("Job", jobID);
	if jobCls == nil then
		return teamName;
	end

	return string.format("%s (%s)", teamName, GET_JOB_NAME(jobCls));
end

function WORLDPVP_PUBLIC_GAME_SET_PCTEAM(frame, gbox, teamVec, teamID)

	local guildName = "None";
	local count = teamVec:GetCount();
	for i = 0 , count - 1 do

		local pcInfo = teamVec:GetByIndex(i);
		guildName = pcInfo:GetGuildName();	

		local pcSet = gbox:CreateOrGetControlSet("pvp_observe_ctrlset_pc_" .. teamID, "PC_" .. i, 0, 0);
		local lv = pcSet:GetChild("lv");
		local name = pcSet:GetChild("name");
		lv:SetTextByKey("value", pcInfo.level);
		name:SetTextByKey("value", pcInfo:GetFamilyName());
		local pic_job = GET_CHILD(pcSet, "pic_job");
		pic_job:SetImage(GET_JOB_ICON(pcInfo.jobID));
		local pic_rank = GET_CHILD(pcSet, "pic_rank");
		if pcInfo.rank == 0 then
			pic_rank:ShowWindow(0);
		else
			local txt_rank = pic_rank:GetChild("txt_rank");
			txt_rank:SetTextByKey("value", pcInfo.rank);
		end
	
	end

	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);

	return guildName;
end

function WORLDPVP_PUBLIC_GAME_LIST_BY_TYPE(isGuildPVP)
	local gameCnt = session.worldPVP.GetPublicGameCount();	
	local gameIndexList = {};		
	for i = 0 , gameCnt - 1 do
		local info = session.worldPVP.GetPublicGameByIndex(i);
		local cls = GetClassByType("WorldPVPType", info.gameType);
		local matchType = TryGetProp(cls, "MatchType");

		if isGuildPVP == 1 and matchType == "Guild" or isGuildPVP ~= 1 and matchType ~= "Guild"  then
			gameIndexList[#gameIndexList + 1] = i;
		end		
	end

	return gameIndexList;
end

function SET_VS_NAMES(frame, ctrlSet, num, name)
	local vx_text = ctrlSet:GetChild("vx_text");
	local teamName = ctrlSet:GetChild("team_name_"..num);
	local imgTokken = nil;
	local fontTokken = nil;
	if "None" ~= name then
		imgTokken = frame:GetUserConfig("IMAGE_TEAMBATTLE");
		fontTokken = frame:GetUserConfig("FONT_TEAMBATTLE");
		local img = string.format("{img guild_master_mark %d %d}", 32, 20) 
		if num == 1 then
			teamName:SetTextByKey("name", img..""..name);
		elseif num == 2 then
			teamName:SetTextByKey("name", img..""..name);
		end
		vx_text:SetTextByKey("vs", string.format("%s", "VS"));
	else
		if num == 1 then
			teamName:SetTextByKey("name", ScpArgMsg('TeamBattleLeagueText'));
		elseif num == 2 then
			vx_text:SetTextByKey("name", "");
		end
		vx_text:SetTextByKey("vs", "");
	end
end;

function MSG_OBSERVE_GAME(parent, ctrl)
	local gameID = parent:GetUserIValue("GAME_ID");

	local yesScp = string.format("EXECOBSERVE_GAME(%d)", gameID);
	ui.MsgBox(ScpArgMsg("ReallyObserveThisGame?"), yesScp, "None");

end

function EXECOBSERVE_GAME(gameID)
	
	worldPVP.RequestObservePublicGame(gameID);

end

function UPDATE_GAMETIME_TXT(ctrl)

	local startSec = ctrl:GetUserIValue("START_SEC");
	local startAppTime = ctrl:GetUserIValue("START_TIME");
	local addSec = imcTime.GetAppTime() - startAppTime;
	local curSec = startSec + addSec;
	local gameSec = math.floor(curSec);
	local gameMin = math.floor(gameSec / 60);
	gameSec = gameSec % 60;
	local timeStr = string.format("%02d:%02d", gameMin, gameSec);
	ctrl:SetTextByKey("value", timeStr);
	return 1;

end

function RUN_PVP_BY_PARTYEVENT()

	local cls = GetClass("WorldPVPType", "Two_Party");
	local frame = ui.GetFrame("worldpvp");
-- 	frame:SetUserValue("BY_PARTY_QUEST", 1);
	JOIN_WORLDPVP_BY_TYPE(frame, cls.ClassID);
	
end

function PVP_OPEN_POINT_SHOP(parent, ctrl)

	TOGGLE_PROPERTY_SHOP("PVPShop");

end
   
function PVP_REWARD(parent, ctrl)
	local type = session.worldPVP.GetRankProp("Type");
	local cls = GetClassByType("WorldPVPType", type);

	worldPVP.RequestGetWorldPVPReward(type);
end                    

function WORLDPVP_TAB_CHANGE(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local tab = GET_CHILD(frame, "tab");
	local index = tab:GetSelectItemIndex();
	if index == 0 then
		SHOW_WORLDPVP_PAGE(frame);
	elseif index == 1 then
		WORLDPVP_SHOW_RANKING(frame);
	elseif index == 2 then
		WORLDPVP_OBSERVE_UI(frame);
	end
	
end

function GUILD_PVP_MISSION_CREATED(roomGuid, gameType, isCreated, zonePCCount)

	local frame = ui.GetFrame("worldpvp");
	if 0 == frame:IsVisible() then
		frame = ui.GetFrame("guildbattle_league");
	end
	
	if isCreated == 1 then
		frame:SetUserValue("GUILD_PVP_GUID_" .. gameType, roomGuid);
		frame:SetUserValue("GUILD_PVP_PCCOUNT_" .. gameType, zonePCCount);
	else
		frame:SetUserValue("GUILD_PVP_GUID_" .. gameType, 0);
	end

	local isFrameOpened = frame:GetUserIValue("DROPLIST_CREATED");
	if isFrameOpened == 1 then
		UPDATE_WORLDPVP(frame);
	end

end