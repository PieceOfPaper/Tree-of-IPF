
function GUILD_ON_INIT(addon, frame)
	-- guild info update msg
	addon:RegisterOpenOnlyMsg("GUILD_PROPERTY_UPDATE", "ON_GUILD_INFO_UPDATE");
	addon:RegisterOpenOnlyMsg("GUILD_INFO_UPDATE", "ON_GUILD_INFO_UPDATE");
	addon:RegisterMsg("GUILD_EVENT_UPDATE", "ON_GUILD_INFO_UPDATE");
    
	addon:RegisterMsg("GUILD_ENTER", "ON_GUILD_ENTER");
	addon:RegisterMsg("GUILD_OUT", "ON_GUILD_OUT");
	addon:RegisterMsg("GUILD_MASTER_REQUEST", "ON_GUILD_MASTER_REQUEST");	
	
	AUTHORITY_GUILD_INVITE = 1
	AUTHORITY_GUILD_BAN = 2
end

function ON_GUILD_ONE_SAY(frame, msg, argStr, argNum)
	local properties = GET_CHILD(frame, "properties");
	local boardlist = GET_CHILD_RECURSIVELY(properties, 'boardlist')
	boardlist:RemoveAllChild();
	
	local cnt = session.guildState.GetBoardCount()
	local sysTime = geTime.GetServerSystemTime();
	for i = cnt - 1, 0, -1 do
		local board = session.guildState.GetGuildBoardByIndex(i);
		if nil ~= board then
			local ctrlSet = boardlist:CreateControlSet("guild_board_ctrl", "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 0, 0, 0, 0);
			local name = ctrlSet:GetChild('name');
			name:SetTextByKey('value', board:GetName() ..':'..board:GetMsg());

			local reg = ctrlSet:GetChild('regTime');
			local regTime = imcTime.ImcTimeToSysTime(board.regTime);

			if	sysTime.wYear == regTime.wYear and
				sysTime.wMonth == regTime.wMonth and
				sysTime.wDay == regTime.wDay then
				reg:SetTextByKey('value',regTime.wHour .. ':'..regTime.wMinute);
			else
				reg:SetTextByKey('value',regTime.wYear .. '/'..regTime.wMonth ..'/'..regTime.wDay);
			end
		end
	end
	GBOX_AUTO_ALIGN(boardlist, 10, 0, 10, true, false);
end

function ON_GUILD_MASTER_REQUEST(frame, msg, argStr)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if nil ==pcparty then
		return;
	end
	local leaderAID = pcparty.info:GetLeaderAID();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	local leaderName = 'None'
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if leaderAID == partyMemberInfo:GetAID() then
			leaderName = partyMemberInfo:GetName();
		end
	end

	local yesScp = string.format("ui.Chat('/agreeGuildMaster')");
	local noScp = string.format("ui.Chat('/disagreeGuildMaster')");
	ui.MsgBox(ScpArgMsg("DoYouWantGuildLeadr{N1}{N2}",'N1',leaderName,'N2', pcparty.info.name), yesScp, noScp);
end

function SHOW_GUILD_NEUTRALTY_REMAIN_TIME(ctrl)
local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	if 0 > startSec then
		ctrl:SetTextByKey("value", "");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	local str = ScpArgMsg("NeutralityChangeTime{TIME}",'TIME', timeTxt);
	ctrl:SetTextByKey("value", str);
	return 1;
end

function ON_GUILD_UPDATE_NEUTRALITY(frame, pcparty)
	
	local warinfo = frame:GetChild("warinfo");
	local neutrality = GET_CHILD(warinfo, "neutrality", "ui::CCheckBox");
	local state = 0;

	if true == pcparty.info:GetNeutralityState() then
		state = 1;
	end
	
	neutrality:SetCheck(state);
	local neutralityTime = warinfo:GetChild("neutralityTime");
	local difSec = session.party.GetGuildNeutraltyRaminTime();
	if difSec > 0 then
		neutralityTime:ShowWindow(1);
		neutralityTime:SetUserValue("REMAINSEC", difSec);
		neutralityTime:SetUserValue("STARTSEC", imcTime.GetAppTime());
		SHOW_GUILD_NEUTRALTY_REMAIN_TIME(neutralityTime);
		neutralityTime:RunUpdateScript("SHOW_GUILD_NEUTRALTY_REMAIN_TIME", 1);
	else
		neutralityTime:SetTextByKey("value", "");
		neutralityTime:StopUpdateScript("SHOW_GUILD_NEUTRALTY_REMAIN_TIME");
	end
end

function ON_GUILD_OUT(frame)
	frame:ShowWindow(0);

	local sysMenuFrame = ui.GetFrame("sysmenu");
	SYSMENU_CHECK_HIDE_VAR_ICONS(sysMenuFrame);

end


function ON_GUILD_ENTER(frame, msg, str, isEnter)
	local partynamegbox = GET_CHILD_RECURSIVELY(frame, 'partynamegbox')
	partynamegbox:EnableHitTest(1);
	DebounceScript("UPDATE_GUILDINFO", 0.2);	
end

function GUILD_TAB_CHANGE(parent, ctrl)
	local curtabIndex	    = ctrl:GetSelectItemIndex();
	if curtabIndex ~= 0 then
		local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
		guild_authority_popup:ShowWindow(0);
	end
end

function ON_GUILD_INFO_UPDATE(frame, msg)
	DebounceScript("UPDATE_GUILDINFO", 0.2);
end

function GUILD_UI_CLOSE(frame)
	local partynamegbox = GET_CHILD_RECURSIVELY(frame, 'partynamegbox')
	partynamegbox:EnableHitTest(1);
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	guild_authority_popup:ShowWindow(0);
end

function UPDATE_GUILD_ABILITY_INFO(frame, partyObj)
	local properties = GET_CHILD(frame, "properties");
	local groupbox_1 = GET_CHILD(properties, "groupbox_1"); 
	local ablist = GET_CHILD_RECURSIVELY(groupbox_1, 'ablist')
	ablist:RemoveAllChild();

	local clsList, cnt = GetClassList("Guild_Ability");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local ctrlSet = ablist:CreateControlSet("guild_info_ability_ctrl", "CTRLSET_" .. cls.ClassID,  ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(cls.Icon);
		local t_ability_name = GET_CHILD(ctrlSet, "t_ability_name");
		t_ability_name:SetTextByKey("name", cls.Name);
		local curLevel = partyObj["AbilLevel_" .. cls.ClassName];
		t_ability_name:SetTextByKey("level", curLevel);
		local t_ability_desc = GET_CHILD(ctrlSet, "t_ability_desc");
		t_ability_desc:SetTextByKey("value", cls.Desc);
	end

	GBOX_AUTO_ALIGN(ablist, 10, 0, 10, true, false);
end

function UPDATE_GUILD_WAR_INFO(frame, pcparty, partyObj)

	local warinfo = GET_CHILD(frame, "warinfo");
	local chk_agit_enter_onlyguild = GET_CHILD(warinfo, "chk_agit_enter_onlyguild");
	chk_agit_enter_onlyguild:SetCheck(partyObj.GuildOnlyAgit);
	
	local existEnemy = GUILD_UPDATE_ENEMY_PARTY(frame, pcparty);
	if existEnemy == 1 then
		frame:RunUpdateScript("UPDATE_REMAIN_GUILD_ENEMY_TIME",20,0,0,1);
	else
		frame:StopUpdateScript("UPDATE_REMAIN_GUILD_ENEMY_TIME");
	end
	
	ON_GUILD_UPDATE_NEUTRALITY(frame, pcparty);
	
	GUILD_UPDATE_TOWERINFO(frame, pcparty, partyObj);

	GUILD_UPDATE_SKL_OBJ_INFO(frame, partyObj);
end

function GUILD_UPDATE_SKL_OBJ_INFO(frame, guildObj)
	local warinfo = GET_CHILD(frame, "warinfo");

	local maxCnt = TryGetProp(guildObj, 'Templer_BuildForge_Lv');
	if nil == maxCnt then
		maxCnt = 0;
	end

	local nowCnt = 0; 
	for i = 1, maxCnt do 
		if guildObj["BuildingLife_Forge_" .. i] ~= "None" then
			nowCnt = nowCnt + 1;
		end
	end

	local forge = GET_CHILD_RECURSIVELY(warinfo, 'forge');
	forge:SetTextByKey('cnt',nowCnt);
	forge:SetTextByKey('max', maxCnt);

	maxCnt = TryGetProp(guildObj, 'Templer_BuildShieldCharger_Lv');
	if nil == maxCnt then
		maxCnt = 0;
	end
	
	nowCnt = 0; 
	for i = 1, maxCnt do 
		if guildObj["BuildingLife_ShieldCharger_" .. i] ~= "None" then
			nowCnt = nowCnt + 1;
		end
	end

	local charge = GET_CHILD_RECURSIVELY(warinfo, 'charge');
	charge:SetTextByKey('cnt',nowCnt);
	charge:SetTextByKey('max',maxCnt);

end

function UPDATE_GUILDINFO(frame)
	
	if frame == nil then
		frame = ui.GetFrame("guild");
	end

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		frame:ShowWindow(0);
		return;
	end

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	local leaderAID = pcparty.info:GetLeaderAID();
	local partyObj = GetIES(pcparty:GetObject());

	local information = GET_CHILD(frame, "information");
	local warInfo = GET_CHILD(frame, "warInfo");

	local savememo = GET_CHILD_RECURSIVELY(frame, 'savememo')
	savememo:ShowWindow(isLeader);	
	local saveNotice = GET_CHILD_RECURSIVELY(frame, 'saveNotice')
	saveNotice:ShowWindow(isLeader);	

	local noticegbox = GET_CHILD_RECURSIVELY(frame, 'noticegbox')
	noticegbox:EnableHitTest(isLeader);
	local partynamegbox = GET_CHILD_RECURSIVELY(frame, 'partynamegbox')
	partynamegbox:EnableHitTest(0);
	local partynotegbox = GET_CHILD_RECURSIVELY(frame, 'partynotegbox')
	partynotegbox:EnableHitTest(isLeader);

	local partyname_edit = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	local partynote = GET_CHILD_RECURSIVELY(frame, 'partynote')
	local notice_edit = GET_CHILD_RECURSIVELY(frame, 'notice_edit')
	
	partyname_edit:SetText(pcparty.info.name);
	partynote:SetText(pcparty.info:GetProfile());
	notice_edit:SetText(pcparty.info:GetNotice());
	
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();

	local gbox_member = information:GetChild("gbox_member");
	local gbox_list = gbox_member:GetChild("gbox_list");
	gbox_list:RemoveAllChild();

	local showOnlyConnected = config.GetXMLConfig("Guild_ShowOnlyConnected");

    IMC_LOG("INFO_NORMAL", "[count:"..tostring(count));

	local connectionCount = 0;
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);

		if showOnlyConnected == 0 or partyMemberInfo:GetMapID() > 0 then

			local ctrlSet = gbox_list:CreateControlSet("guild_memberinfo", partyMemberInfo:GetAID(), ui.LEFT, ui.TOP, 0, 0, 0, 0);
			ctrlSet:SetUserValue("AID", partyMemberInfo:GetAID());
			local txt_teamname = ctrlSet:GetChild("txt_teamname");
			local txt_duty = ctrlSet:GetChild("txt_duty");
			local txt_location = ctrlSet:GetChild("txt_location");
			txt_teamname:SetTextByKey("value", partyMemberInfo:GetName());
			txt_teamname:SetTextTooltip(partyMemberInfo:GetName());

            IMC_LOG("INFO_NORMAL", "[name:"..partyMemberInfo:GetName());

			local grade = partyMemberInfo.grade;
			if leaderAID == partyMemberInfo:GetAID() then
				local dutyName = "{ol}{#FFFF00}" .. ScpArgMsg("GuildMaster") .. "{/}{/}";
				dutyName = dutyName .. " " .. pcparty:GetDutyName(grade);
				txt_duty:SetTextByKey("value", dutyName);
			else
				local dutyName = pcparty:GetDutyName(grade);
				txt_duty:SetTextByKey("value", dutyName);
			end
		
			local pic_online = GET_CHILD(ctrlSet, "pic_online");
			local locationText = "";
			if partyMemberInfo:GetMapID() > 0 then
				local mapCls = GetClassByType("Map", partyMemberInfo:GetMapID());
				if mapCls ~= nil then
					locationText = string.format("[%s%d] %s", ScpArgMsg("Channel"), partyMemberInfo:GetChannel() + 1, mapCls.Name);
					connectionCount = connectionCount + 1;
				end

				pic_online:SetImage("guild_online");
			else
				local logoutSec = partyMemberInfo:GetLogoutSec();
				if logoutSec >= 0 then
					locationText = GET_DIFF_TIME_TXT(logoutSec);
				else				
					locationText = ScpArgMsg("Logout");
				end
				pic_online:SetImage("guild_offline");
			end

			txt_location:SetTextByKey("value", locationText);
			txt_location:SetTextTooltip(locationText);
			SET_EVENT_SCRIPT_RECURSIVELY(ctrlSet, ui.RBUTTONDOWN, "POPUP_GUILD_MEMBER");
		end
	end		

	gbox_list:SetEventScript(ui.SCROLL, 'SET_AUTHO_MEMBERS_SCROLL');
	
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	if guild_authority_popup:IsVisible() == 1 then
		local authority_count = guild_authority_popup:GetUserIValue("AUTHO_S_ROW");	
		local maxCount = count;
		if showOnlyConnected == 1 then
			maxCount = connectionCount;
		end
		if authority_count ~= maxCount then
			guild_authority_popup:ShowWindow(0);
		end
	end

	GBOX_AUTO_ALIGN(gbox_list, 0, 0, 0, true, false);

	local text_memberinfo = gbox_member:GetChild("text_memberinfo");
	
	local memberStateText = ScpArgMsg("GuildMember{Cur}/{Max}People,OnLine{On}People", "Cur", count, "Max", pcparty:GetMaxGuildMemberCount(), "On", connectionCount);
	text_memberinfo:SetTextByKey("value", memberStateText);
	
	local chk_showonlyconnected = GET_CHILD(gbox_member, "chk_showonlyconnected");
	chk_showonlyconnected:SetCheck(showOnlyConnected);

	UPDATE_GUILD_ABILITY_INFO(frame, partyObj);

	UPDATE_GUILD_WAR_INFO(frame, pcparty, partyObj);
	
	UPDATE_GUILD_EVENT_INFO(frame, pcparty, partyObj);

    SendSystemLog()
end

function GUILD_UPDATE_TOWERINFO(frame, pcparty, partyObj)

	local houseInfo = partyObj.HousePosition;
	local properties = frame:GetChild("warinfo");
	local txt_guildtowercount = properties:GetChild("txt_guildtowercount");
	local txt_guildtowerposition = properties:GetChild("txt_guildtowerposition");
	
	txt_guildtowerposition:StopUpdateScript("UPDATE_TOWER_REMAIN_TIME");
	txt_guildtowerposition:StopUpdateScript("UPDATE_TOWER_DESTROY_TIME");

	if houseInfo == "None" then

		local countText = ScpArgMsg("GuildTower") ..  " (0)";
		txt_guildtowercount:SetTextByKey("value", countText);
		txt_guildtowerposition:SetTextByKey("value", "");
		txt_guildtowerposition:SetTextByKey("remaintime", "");
		txt_guildtowerposition:ShowWindow(0);

	else

		txt_guildtowerposition:ShowWindow(1);
		local towerInfo = StringSplit(houseInfo, "#");
		if #towerInfo == 3 then
			local destroyPartyName = towerInfo[2];
			local destroyedTime = towerInfo[3];
	
			local countText = ScpArgMsg("GuildTower") ..  " (1)";
			txt_guildtowercount:SetTextByKey("value", countText);
			
			if destroyPartyName == "None" then
				destroyPartyName = ScpArgMsg("Enemy");
			end

			local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
			positionText = positionText .. "{nl}" .. ScpArgMsg("ToRebuildableTime") .. " " ;
			txt_guildtowerposition:SetTextByKey("value", positionText);
			txt_guildtowerposition:SetUserValue("PARTYNAME", destroyPartyName);
	
			txt_guildtowerposition:SetUserValue("DESTROYTIME", destroyedTime);
			txt_guildtowerposition:RunUpdateScript("UPDATE_TOWER_DESTROY_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_DESTROY_TIME(txt_guildtowerposition);


		else
			local mapID = towerInfo[1];
			local towerID = towerInfo[2];
			local x = towerInfo[3];
			local y = towerInfo[4];
			local z = towerInfo[5];
			local builtTime = towerInfo[6];

			local mapCls = GetClassByType("Map", mapID);
		
			local countText = ScpArgMsg("GuildTower") ..  " (1)";
			txt_guildtowercount:SetTextByKey("value", countText);
			local positionText = MAKE_LINK_MAP_TEXT(mapCls.ClassName, x, z);
			txt_guildtowerposition:SetTextByKey("value", positionText);
	
			txt_guildtowerposition:SetUserValue("BUILTTIME", builtTime);
			txt_guildtowerposition:RunUpdateScript("UPDATE_TOWER_REMAIN_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_REMAIN_TIME(txt_guildtowerposition);
		end
	end
	
end

function GUILD_UPDATE_ENEMY_PARTY(frame, pcparty)

	local properties = frame:GetChild("warinfo");
	local gbox_enemy_list = properties:GetChild("gbox_enemy_list");
	local gbox_list = gbox_enemy_list:GetChild("gbox_list");
	gbox_list:RemoveAllChild();

	local cnt = pcparty.info:GetEnemyPartyCount();
	for i = 0 , cnt - 1 do
		local enemyInfo = pcparty.info:GetEnemyPartyByIndex(i);
		local ctrlSet = gbox_list:CreateControlSet("guildwar_ctrlset", "CTRLSET_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local t_guildname = ctrlSet:GetChild("t_guildname");
		local t_remainTime = ctrlSet:GetChild("t_remainTime");
		t_guildname:SetTextByKey("value", enemyInfo:GetPartyName());
		
		local serverTime = geTime.GetServerFileTime();
		local warEndTime = enemyInfo:GetEndTime();
		local remainSec = imcTime.GetIntDifSecByTime(warEndTime, serverTime);

		if remainSec <= 0 then
			local remainRemoveSec = (GUILD_WAR_REST_MINUTE * 60 + remainSec)
			local remainTimeText = GET_TIME_TXT_DHM(remainRemoveSec);
			t_remainTime:SetTextByKey("value", ScpArgMsg("NextDeclareWarAbleTime") .. " " .. remainTimeText);
		else
			local remainTimeText = GET_TIME_TXT_DHM(remainSec);
			t_remainTime:SetTextByKey("value", remainTimeText);
		end
	end
	
	GBOX_AUTO_ALIGN(gbox_list, 0, 0, 0, true, false);
	if cnt > 0 then
		return 1;
	else
		return 0;
	end

end

function UPDATE_REMAIN_GUILD_ENEMY_TIME(frame)

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return 1;
	end

	GUILD_UPDATE_ENEMY_PARTY(frame, pcparty);
	return 1;
end

function GUILD_BAN(name)

	ui.Chat("/partybanByAID " .. PARTY_GUILD.. " " .. name);	

end

function SAVE_GUILD_NAME_AND_MEMO(parent, ctrl)

	local frame = parent:GetTopParentFrame();

	local partyname_edit = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	local partynote = GET_CHILD_RECURSIVELY(frame, 'partynote')
	local partyName = partyname_edit:GetText();
	local partyNote = partynote:GetText();

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	local partyObj = GetIES(pcparty:GetObject());
	local nowPartyName = pcparty.info.name;
	local nowPartyNote = pcparty.info:GetProfile();

	local badword = IsBadString(partyName);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end

	badword = IsBadString(partyNote);
	if badword ~= nil then
		--ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		--return;
	end
	
	if nowPartyName ~= partyName then
		party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_NAME, partyName);
	end

	if partyNote ~= nil and nowPartyNote ~= partyNote then
		party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_PROFILE, partyNote);
	end

	partyname_edit:ReleaseFocus()
	partynote:ReleaseFocus()

end

function GUILD_SHOW_ONLY_CONNECTED(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	DebounceScript("UPDATE_GUILDINFO", 0.2);

	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	guild_authority_popup:ShowWindow(0);
end


function UPDATE_GUILD_EVENT_INFO(frame, pcparty, partyObj)
	local pcAcc = GetMyAccountObj();

	if partyObj["GuildBossSummonFlag"] ~= 1 then
		session.minimap.RemoveIconInfo("GuildBossSummon");
	end
	if partyObj["GuildInDunFlag"] ~= 1 then
		session.minimap.RemoveIconInfo("GuildIndun");
	end

	if partyObj["GuildBossSummonFlag"] == 1 and pcAcc.GuildEventSeq == partyObj.GuildEventSeq then
		local locInfo = geClientGuildEvent.GetGuildEventLocaionInfo(pcparty, "GuildBossSummonLocInfo");
		if locInfo ~= nil then
			local mapCls = GetClassByType("Map", locInfo.mapID);
			local pos = geClientPartyQuest.GetLocInfoPos(locInfo);
			local mapprop = session.GetCurrentMapProp();
			if locInfo.mapID == mapprop.type then
				session.minimap.AddIconInfo("GuildBossSummon", "trasuremapmark", pos, ClMsg("GuildEventLocal"), true, "None", 1.5);
			end
		end
	elseif partyObj["GuildInDunFlag"] == 1 then
		local locInfo = geClientGuildEvent.GetGuildEventLocaionInfo(pcparty, "GuildInDunLocInfo");
		if locInfo ~= nil then
			local mapCls = GetClassByType("Map", locInfo.mapID);
			local pos = geClientPartyQuest.GetLocInfoPos(locInfo);
			local mapprop = session.GetCurrentMapProp();
			if locInfo.mapID == mapprop.type then
				session.minimap.AddIconInfo("GuildIndun", "trasuremapmark", pos, ClMsg("GuildEventLocal"), true, "None", 1.5);
			end
		end
	end

	if partyObj["GuildRaidFlag"] == 1 then
		if partyObj["GuildRaidStage"] > 1 then
			local raidStage = string.format("raidStage%d", partyObj["GuildRaidStage"] - 1);
			session.minimap.RemoveIconInfo(raidStage);
		end
		local stageMapID = geClientGuildEvent.GetStageMapID(pcparty)
		local mapprop = session.GetCurrentMapProp();
		if mapprop.type == stageMapID then
			local pos = geClientGuildEvent.GetStagePos(pcparty)
			local raidStage = string.format("raidStage%d", partyObj["GuildRaidStage"]);
			session.minimap.AddIconInfo(raidStage, "trasuremapmark", pos, ClMsg("GuildEventLocal"), true, "None", 1.5);
		end
	end
end

function WAR_BEGIN_MSG(partyName)

	local msg = ScpArgMsg("WarStartedWith{GuildName}", "GuildName", partyName);
	ui.SysMsg(msg);
		
end

function WAR_END_MSG(partyName)

	local msg = ScpArgMsg("WarEndedWith{GuildName}", "GuildName", partyName);
	ui.SysMsg(msg);

end