function WORLDPVP_ON_INIT(addon, frame)

	addon:RegisterMsg("PVP_TIME_TABLE", "ON_PVP_TIME_TABLE");
	addon:RegisterMsg("PVP_PC_INFO", "ON_PVP_PC_INFO");
	addon:RegisterMsg("PVP_STATE_CHANGE", "ON_PVP_STATE_CHANGE");
	addon:RegisterMsg("PVP_PROPERTY_UPDATE", "ON_PVP_PROPERTY_UPDATE");
	addon:RegisterMsg("PVP_HISTORY_UPDATE", "ON_PVP_HISTORY_UPDATE");
	addon:RegisterMsg("WORLDPVP_RANK_PAGE", "ON_WORLDPVP_RANK_PAGE");
	addon:RegisterMsg("WORLDPVP_RANK_ICON", "ON_WORLDPVP_RANK_ICON");
			
end

g_enablePVPExp = 0;

function WORLDPVP_FIRST_OPEN(frame)
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
		droplist:AddItem(cls.ClassID, "{@st42}" .. cls.Name);
		droplist_rank:AddItem(cls.ClassID, "{@st42}" .. cls.Name);		
	end

	droplist:SelectItemByKey(1);

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
	
	WORLDPVP_SET_UI_MODE(frame, "");
	local ret = worldPVP.RequestPVPInfo();
	if ret == false then
		ON_PVP_TIME_TABLE(frame);
	else
		local bg = frame:GetChild("bg");
		local loadingtext = bg:GetChild("loadingtext");
		local charinfo = bg:GetChild("charinfo");
		loadingtext:ShowWindow(1);
		charinfo:ShowWindow(0);
	end

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
	local objPropName = clsName .. "_" .. propName;
	local propValue = pvpObj:GetPropValue(objPropName, defValue);
	ctrl:SetTextByKey("value", propValue);
end

function ON_PVP_PROPERTY_UPDATE(frame)
	UPDATE_WORLDPVP(frame);
end

function ON_PVP_PC_INFO(frame)
	UPDATE_WORLDPVP(frame);
	ON_PVP_HISTORY_UPDATE(frame);
end

function UPDATE_WORLDPVP(frame)
	local bg = frame:GetChild("bg");
	local loadingtext = bg:GetChild("loadingtext");
	local charinfo = bg:GetChild("charinfo");
	loadingtext:ShowWindow(0);
	charinfo:ShowWindow(1);
	
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if nullptr == pvpObj then
		return;
	end

	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	local pvpType = droplist:GetSelItemKey();
	local cls = GetClassByType("WorldPVPType", pvpType);
	local clsName = cls.ClassName;
	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "rp", "RP", 1000);
	local teer = charinfo:GetChild("teer")
	local objPropName = clsName .. "_GRADE";
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
	

	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "win", "WIN", 0);
	SET_PVP_TYPE_PROP(charinfo, pvpObj, clsName, "lose", "LOSE", 0);
	
	local curDateString = imcTime.GetCurDateString();
	local todayGetShopPoint = 0;
	local todayGetEXPPoint = 0;
	if curDateString == pvpObj:GetPropValue("LastPointGetDate") then
		todayGetShopPoint = pvpObj:GetPropValue("TodayGetShopPoint");
		todayGetEXPPoint = pvpObj:GetPropValue("TodayGetEXPPoint");
	end

	local todayStr;
	if g_enablePVPExp == 1 then
		todayStr = string.format("EXP : %d/%d, Shop : %d/%d", todayGetEXPPoint ,PVP_DAY_MAX_SHOP_POINT, todayGetShopPoint, PVP_DAY_MAX_EXP_POINT);
	else
		todayStr = string.format("%s : %d/%d", ScpArgMsg("ShopPoint"),todayGetShopPoint, PVP_DAY_MAX_EXP_POINT);
	end

	local todaypoint = charinfo:GetChild("todaypoint");
	todaypoint:SetTextByKey("value", todayStr);

	local curExpPoint = pvpObj:GetPropIValue("ExpPoint", 0);
	local expgauge = GET_CHILD(charinfo, "expgauge", "ui::CGauge");
	expgauge:SetPoint(curExpPoint, PVP_MAX_EXP_POINT);
	local expbtn = charinfo:GetChild("getexp");
	expgauge:ShowWindow(g_enablePVPExp);
	expbtn:ShowWindow(g_enablePVPExp);

	local joinBtn = charinfo:GetChild("join");
	local isPlaying = session.worldPVP.IsPlayingType(pvpType);
	if isPlaying == true then
		joinBtn:SetEnable(1);
	else
		joinBtn:SetEnable(0);
	end

end

function JOIN_WORLDPVP(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	local pvpType = droplist:GetSelItemKey();
	JOIN_WORLDPVP_BY_TYPE(frame, pvpType);

end

function JOIN_WORLDPVP_BY_TYPE(frame, pvpType)
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");

	local cls = GetClassByType("WorldPVPType", pvpType);
	local join = charinfo:GetChild("join");
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_NONE then

		if cls.Party == 0 then
			worldPVP.ReqJoinPVP(pvpType, PVP_STATE_FINDING);
			join:SetEnable(0);
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
	join:SetEnable(1);

	if state == PVP_STATE_FINDING then

		-- frame:ShowWindow(1);

		local bg = frame:GetChild("bg");
		local charinfo = bg:GetChild("charinfo");
		local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
		pvpType = tonumber(pvpType);
		pvpType = math.floor(pvpType);
		pvpType = tostring(pvpType);
		local curType = droplist:GetSelItemKey();
		if curType ~= pvpType then
			droplist:SelectItemByKey(pvpType);
			UPDATE_WORLDPVP(frame);
		end
	end

	if 1 == ui.IsFrameVisible("worldpvp_ready") then
		WORLDPVP_READY_STATE_CHANGE(state);
	end

end

function WORLDPVP_TYPE_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	UPDATE_WORLDPVP(frame);
end

function WORLDPVP_RANK_TYPE_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	WORLDPVP_REQUEST_RANK(frame, 1);
end

function ON_PVP_TIME_TABLE(frame)

	local bg = frame:GetChild("bg");
	local timetable = bg:GetChild("timetable");
	local time_text = timetable:GetChild("time_text");

	local txt = frame:GetUserConfig("TIME_TABLE_FONT");
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

	time_text:SetText(txt);
	
end

function ON_PVP_HISTORY_UPDATE(frame)

	local bg = frame:GetChild("bg");
	local recent = bg:GetChild("recent");

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if nullptr == pvpObj then
		return;
	end

	DESTROY_CHILD_BYNAME(recent, "HISTORY_");
	local cnt = pvpObj:GetHistoryCount();
	for i = 0 , cnt - 1 do
		local pvp_history = recent:CreateControlSet("pvp_history", "HISTORY_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);

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

	GBOX_AUTO_ALIGN(recent, 10, 0, 10, true, false);

end

function WORLDPVP_REQUEST_RANK(frame, page)

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local pvpObj = session.worldPVP.GetPVPObject(cid);
	if nullptr == pvpObj then
		return;
	end

	local bg = frame:GetChild("bg");
	local bg_ranking = frame:GetChild("bg_ranking");
	local droplist_rank = GET_CHILD(bg_ranking, "droplist", "ui::CDropList");
	local pvpType = droplist_rank:GetSelItemKey();

	local bg_ranking = frame:GetChild("bg_ranking");
	local input_findname = GET_CHILD(bg_ranking, "input_findname", "ui::CEditControl");

	worldPVP.RequestPVPRanking(pvpType, -1, page, input_findname:GetText());

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
	WORLDPVP_REQUEST_RANK(frame, 1);
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
	local imgName = ui.CaptureModelHeadImage_IconInfo(iconInfo);

	local txt_name = ctrlSet:GetChild("txt_name");
	local pic = GET_CHILD(ctrlSet, "pic");
	local txt_point = ctrlSet:GetChild("txt_point");
	ctrlSet:SetUserValue("CID", key);
	txt_name:SetTextByKey("value", iconInfo:GetGivenName() .. " (" .. iconInfo:GetFamilyName()..")");
	txt_point:SetTextByKey("value", info.point);
	pic:SetImage(imgName);

end

function ON_WORLDPVP_RANK_PAGE(frame)

	local bg_ranking = frame:GetChild("bg_ranking");

	local type = session.worldPVP.GetRankProp("Type");
	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");

	local cnt = session.worldPVP.GetRankInfoCount();
	local gbox_ctrls = bg_ranking:GetChild("gbox_ctrls");
	gbox_ctrls:RemoveAllChild();
	local rankPageFont = frame:GetUserConfig("RANK_PAGE_FONT");

	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = gbox_ctrls:CreateControlSet("pvp_rank_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);

		local txt_rank = ctrlSet:GetChild("txt_rank");
		local ranking = ((page - 1) * WORLDPVP_RANK_PER_PAGE) + i + 1;
		txt_rank:SetTextByKey("value", ranking);
		
	end

	GBOX_AUTO_ALIGN(gbox_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor((totalCount + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(bg_ranking, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);

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


function GET_CASH_POINT_C()
	local aobj = GetMyAccountObj();
	return aobj.Medal -- + aobj.GiftMedal + aobj.ReceiveGiftMedal;
end

function WORLDPVP_READY_STATE_CHANGE(state)
	if state == PVP_STATE_NONE then
		ui.CloseFrame("worldpvp_ready");
	else
		WORLDPVP_READY_UI();
	end
end

function WORLDPVP_READY_TIME(readyTime)
	local frame = ui.GetFrame("worldpvp_ready");
	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(100, 100);
	gauge:SetPointWithTime(0, readyTime * 0.001);
	frame:ReserveScript("PVP_READY_ACCEPT", 5, 0);
end

function WORLDPVP_READY_UI()
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

	local reject = frame:GetChild("reject");
	if state == PVP_STATE_FINDED then
		reject:ShowWindow(1);
	else
		reject:ShowWindow(0);
	end
end

function PVP_READY_ACCEPT(parent, ctrl)
	worldPVP.SendReadyState(true);
end

function PVP_READY_REJECT(parnet, ctrl)
	worldPVP.SendReadyState(false);
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

	return string.format("%s (%s)", teamName, jobCls.Name);
end

function WORLDPVP_PUBLIC_GAME_LIST()

	local frame = ui.GetFrame("worldpvp");
	local bg_observer = frame:GetChild("bg_observer");
	local gbox = bg_observer:GetChild("gbox");
	gbox:RemoveAllChild();
	
	local cnt = session.worldPVP.GetPublicGameCount();
	for i = 0 , cnt - 1 do

		local info = session.worldPVP.GetPublicGameByIndex(i);
		local ctrlSet = gbox:CreateControlSet("pvp_observe_ctrlset", "CTRLSET_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		
		ctrlSet:SetUserValue("GAME_ID", info.guid);
		local txt_gametype = ctrlSet:GetChild("txt_gametype");
		local txt_gametime = ctrlSet:GetChild("txt_gametime");
		local txt_team1 = ctrlSet:GetChild("txt_team1");
		local txt_mmr = ctrlSet:GetChild("txt_mmr");
		local txt_team2 = ctrlSet:GetChild("txt_team2");

		local gameCls = GetClassByType("WorldPVPType", info.gameType);
		txt_gametype:SetTextByKey("value", gameCls.Name);
		txt_mmr:SetTextByKey("value", info.gameMMR);

		txt_gametime:SetUserValue("START_TIME", imcTime.GetAppTime());
		txt_gametime:SetUserValue("START_SEC", info.playTime * 0.001);
		txt_gametime:RunUpdateScript("UPDATE_GAMETIME_TXT", 0, 0, 0, 1);
		UPDATE_GAMETIME_TXT(txt_gametime);

		local team1Str = WORLDPVP_OBSERVER_GET_TEAM_STR(info:GetTeam1Name(), info.team1Job);
		local team2Str = WORLDPVP_OBSERVER_GET_TEAM_STR(info:GetTeam2Name(), info.team2Job);
		txt_team1:SetTextByKey("value", team1Str);
		txt_team2:SetTextByKey("value", team2Str);
	end

	GBOX_AUTO_ALIGN(gbox, 10, 3, 10, true, false);

end

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

