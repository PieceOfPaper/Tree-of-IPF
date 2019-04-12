
function GUILD_ON_INIT(addon, frame)
	
	addon:RegisterOpenOnlyMsg("GUILD_PROPERTY_UPDATE", "ON_GUILD_PROPERTY_UPDATE");
	addon:RegisterOpenOnlyMsg("GUILD_INFO_UPDATE", "ON_GUILD_INFO_UPDATE");
	addon:RegisterMsg("GUILD_NEUTRALITY_UPDATE", "ON_GUILD_NEUTRALITY_UPDATE");
	addon:RegisterMsg("GAME_START_3SEC", "GUILD_GAME_START_3SEC");	
	addon:RegisterMsg("MYPC_GUILD_JOIN", "ON_MYPC_GUILD_JOIN");
	addon:RegisterMsg("GUILD_ENTER", "ON_GUILD_ENTER");
	addon:RegisterMsg("GUILD_OUT", "ON_GUILD_OUT");
	addon:RegisterMsg("GUILD_EVENT_UPDATE", "ON_GUILD_INFO_UPDATE");
		

end

function ON_GUILD_NEUTRALITY_UPDATE(frame, msg, strArg, numArg)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return;
	end

	if strArg ~= nil and strArg == "Change" then
		if true == pcparty.info:GetNeutralityState() then
			ui.SysMsg(ScpArgMsg("ChangeGuildNeutralityState{DAY}",'DAY',GET_TIME_TXT(GUILD_NEUTRALITY_TIME,1)));
		else
			ui.SysMsg(ScpArgMsg("ChangeGuildNoneNeutralityState{DAY}",'DAY',GET_TIME_TXT(GUILD_NEUTRALITY_TIME,1)));
		end
	end

	ON_GUILD_UPDATE_NEUTRALITY(frame, pcparty);
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
	
	local properties = frame:GetChild("properties");
	local neutrality = GET_CHILD(properties, "neutrality", "ui::CCheckBox");
	local state = 0;

	if true == pcparty.info:GetNeutralityState() then
		state = 1;
	end
	
	neutrality:SetCheck(state);
	local neutralityTime = properties:GetChild("neutralityTime");
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

function ON_GUILD_SET_NEUTRALITY(frame)
	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
		ON_GUILD_NEUTRALITY_UPDATE(ui.GetFrame("guild"));
		return;
	end

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if nil == pcparty then
		return;
	end

	local yesScp = string.format("C_GUILD_SET_NEUTRALITY(%d)", 1);
	local noScp = string.format("C_GUILD_SET_NEUTRALITY(%d)", 0);
	if true == pcparty.info:GetNeutralityState() then
		--중립상태 해제
		ui.MsgBox(ScpArgMsg("WantTobeChangedNoneNeutralityState{DAY}",'DAY',GET_TIME_TXT(GUILD_NEUTRALITY_TIME,1)), yesScp, noScp);
	else
		--중립상태 원함
		ui.MsgBox(ScpArgMsg("WantTobeChangedNeutralityState{DAY}",'DAY',GET_TIME_TXT(GUILD_NEUTRALITY_TIME,1)), yesScp, noScp);
	end

end

function C_GUILD_SET_NEUTRALITY(change)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if nil == pcparty then
		return;
	end
	
	if change == 0 then
		local frame = ui.GetFrame("guild");
		ON_GUILD_NEUTRALITY_UPDATE(frame);
		return;
	end

	session.guildState.ChangeGuildNeutralityState(pcparty.info);
end

function ON_GUILD_OUT(frame)
	frame:ShowWindow(0);

	local sysMenuFrame = ui.GetFrame("sysmenu");
	SYSMENU_CHECK_HIDE_VAR_ICONS(sysMenuFrame);

end


function ON_GUILD_ENTER(frame, msg, str, isEnter)
	UPDATE_GUILDINFO(frame);	
end

function ON_MYPC_GUILD_JOIN(frame)

	frame:ShowWindow(1);

end

function GUILD_TAB_CHANGE(parent, ctrl)


end

function ON_GUILD_INFO_UPDATE(frame, msg)

	UPDATE_GUILDINFO(frame);

end

function ON_GUILD_PROPERTY_UPDATE(frame, msg)
	UPDATE_GUILDINFO(frame);

end

function GUILD_GAME_START_3SEC(frame)

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return;
	end

	local cnt = pcparty.info:GetEnemyPartyCount();
	for i = 0 , cnt - 1 do
		local enemyInfo = pcparty.info:GetEnemyPartyByIndex(i);
		local serverTime = geTime.GetServerFileTime();
		local difSec = imcTime.GetIntDifSecByTime(serverTime, enemyInfo:GetStartTime());
		local remainSec = GUILD_WAR_AUTO_END_MINUTE * 60 - difSec;
		if remainSec > 0 then
			local msg = ScpArgMsg("WarWith{Name}GuildRemain{Time}", "Name", enemyInfo:GetPartyName(), "Time", GET_TIME_TXT_DHM(remainSec));
			ui.SysMsg(msg);
		end
	end
	
end

function UPDATE_GUILDINFO(frame)

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		frame:ShowWindow(0);
		return;
	end

	local information = GET_CHILD(frame, "information");
	local properties = GET_CHILD(frame, "properties");

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	local leaderAID = pcparty.info:GetLeaderAID();
	local partyObj = GetIES(pcparty:GetObject());

	local partyname_edit = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	local partynote = GET_CHILD_RECURSIVELY(frame, 'partynote')
	local notice_edit = GET_CHILD_RECURSIVELY(frame, 'notice_edit')
	partyname_edit:SetText(pcparty.info.name);
	partynote:SetText(pcparty.info:GetProfile());
	notice_edit:SetText(pcparty.info:GetNotice());
	
	partyname_edit:EnableHitTest(isLeader);
	partynote:EnableHitTest(isLeader);

	local savememo = GET_CHILD_RECURSIVELY(frame, 'savememo')
	savememo:ShowWindow(isLeader);	

	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();

	local gbox_member = information:GetChild("gbox_member");
	local gbox_list = gbox_member:GetChild("gbox_list");
	gbox_list:RemoveAllChild();

	local showOnlyConnected = config.GetXMLConfig("Guild_ShowOnlyConnected");

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
				pic_online:SetImage("guild_offline");
			end

			txt_location:SetTextByKey("value", locationText);
			txt_location:SetTextTooltip(locationText);

			SET_EVENT_SCRIPT_RECURSIVELY(ctrlSet, ui.RBUTTONDOWN, "POPUP_GUILD_MEMBER");
		end
	end		

	GBOX_AUTO_ALIGN(gbox_list, 0, 0, 0, true, false);

	local text_memberinfo = gbox_member:GetChild("text_memberinfo");
	
	local memberStateText = ScpArgMsg("GuildMember{Cur}/{Max}People,OnLine{On}People", "Cur", count, "Max", GUILD_BASIC_MAX_MEMBER + partyObj.AbilLevel_MemberExtend, "On", connectionCount);
	text_memberinfo:SetTextByKey("value", memberStateText);

	local chk_showonlyconnected = GET_CHILD(gbox_member, "chk_showonlyconnected");
	chk_showonlyconnected:SetCheck(showOnlyConnected);
	
	local chk_agit_enter_onlyguild = GET_CHILD(properties, "chk_agit_enter_onlyguild");
	chk_agit_enter_onlyguild:SetCheck(partyObj.GuildOnlyAgit);

	local existEnemy = GUILD_UPDATE_ENEMY_PARTY(frame, pcparty);
	if existEnemy == 1 then
		frame:RunUpdateScript("UPDATE_REMAIN_GUILD_ENEMY_TIME",20,0,0,1);
	else
		frame:StopUpdateScript("UPDATE_REMAIN_GUILD_ENEMY_TIME");
	end

	ON_GUILD_UPDATE_NEUTRALITY(frame, pcparty);

	GUILD_UPDATE_TOWERINFO(frame, pcparty, partyObj);

	UPDATE_GUILD_EVENT_INFO(frame, pcparty, partyObj);

end

function GUILD_UPDATE_TOWERINFO(frame, pcparty, partyObj)

	local houseInfo = partyObj.HousePosition;
	local properties = frame:GetChild("properties");
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
	
function UPDATE_TOWER_REMAIN_TIME(txt_guildtowerposition)

	local builtTime = txt_guildtowerposition:GetUserValue("BUILTTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_LIFE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	local difSecString = GET_TIME_TXT_DHM(difSec);
	txt_guildtowerposition:SetTextByKey("remaintime", difSecString);
	return 1;

end

function UPDATE_TOWER_DESTROY_TIME(txt_guildtowerposition)

	local builtTime = txt_guildtowerposition:GetUserValue("DESTROYTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_DESTROY_REBUILD_ABLE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	if difSec > 0 then
		local difSecString = GET_TIME_TXT_DHM(difSec);
		txt_guildtowerposition:SetTextByKey("remaintime", difSecString);
	else
		local destroyPartyName = txt_guildtowerposition:GetUserValue("PARTYNAME");
		local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
		txt_guildtowerposition:SetTextByKey("value", positionText);
		txt_guildtowerposition:SetTextByKey("remaintime", ScpArgMsg("AbleToRebuild"));
		return 0;
	end

	return 1;

end

function GUILD_UPDATE_ENEMY_PARTY(frame, pcparty)

	local properties = frame:GetChild("properties");
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
		local difSec = imcTime.GetIntDifSecByTime(serverTime, enemyInfo:GetStartTime());
		local remainSec = GUILD_WAR_AUTO_END_MINUTE * 60 - difSec;
		if remainSec <= 0 then
			local remainRemoveSec = (GUILD_WAR_REST_MINUTE + GUILD_WAR_AUTO_END_MINUTE) * 60 - difSec;
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

function POPUP_GUILD_MEMBER(parent, ctrl)

	local aid = parent:GetUserValue("AID");
	if aid == "None" then
		aid = ctrl:GetUserValue("AID");
	end
	
	local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, aid);
	local isLeader = AM_I_LEADER(PARTY_GUILD);
	local myAid = session.loginInfo.GetAID();

	local name = memberInfo:GetName();

	local contextMenuCtrlName = string.format("{@st41}%s{/}", name);
	local context = ui.CreateContextMenu("PC_CONTEXT_MENU", name, 0, 0, 170, 100);
	if isLeader == 1 and aid ~= myAid then
		ui.AddContextMenuItem(context, ScpArgMsg("ChangeDuty"), string.format("GUILD_CHANGE_DUTY('%s')", name));
		ui.AddContextMenuItem(context, ScpArgMsg("Ban"), string.format("GUILD_BAN('%s')", name));
	end

	if isLeader == 1 then

		local list = session.party.GetPartyMemberList(PARTY_GUILD);
		if list:Count() == 1 then
			ui.AddContextMenuItem(context, ScpArgMsg("Disband"), "ui.Chat('/destroyguild')");
		end
	else
		if aid == myAid then
			ui.AddContextMenuItem(context, ScpArgMsg("GULID_OUT"), "OUT_GUILD()");
		end
	end

	ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", name));
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end


function OUT_GUILD()
	ui.Chat("/outguild");
end

function GUILD_CHANGE_DUTY(name)

	local memberInfo = session.party.GetPartyMemberInfoByName(PARTY_GUILD, name);

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	local grade = memberInfo.grade;
	local dutyName = pcparty:GetDutyName(grade);

	local inputFrame = INPUT_STRING_BOX("", "EXEC_GUILD_CHANGE_DUTY", dutyName);
	inputFrame:SetUserValue("NAME", name);
	
end

function EXEC_GUILD_CHANGE_DUTY(frame, ctrl)

	if ctrl:GetName() == "inputstr" then
		frame = ctrl;
	end

	local duty = GET_INPUT_STRING_TXT(frame);
	local name = frame:GetUserValue("NAME");
	local memberInfo = session.party.GetPartyMemberInfoByName(PARTY_GUILD, name);
		
	party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_DUTY, duty, memberInfo:GetAID());
	frame:ShowWindow(0);

end

function GUILD_BAN(name)

	ui.Chat("/partyban " .. PARTY_GUILD.. " " .. name);	

end

function UI_CHECK_GUILD_UI_OPEN(propname, propvalue)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return 0;
	end

	return 1;

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

function SAVE_GUILD_NOTICE(parent, ctrl)

	local frame = parent:GetTopParentFrame();

	local notice_edit = GET_CHILD_RECURSIVELY(frame, 'notice_edit')
	local noticeText = notice_edit:GetText();

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	local nowNotice = pcparty.info:GetNotice();

	local badword = IsBadString(nowNotice);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end

	if nowNotice ~= noticeText then
		party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_NOTICE, noticeText);
	end

	notice_edit:ReleaseFocus();

end

function GUILD_SHOW_ONLY_CONNECTED(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	UPDATE_GUILDINFO(frame);

end

function CHANGE_AGIT_ENTER_OPTION(parnet, ctrl)

	ctrl = AUTO_CAST(ctrl);
	
	party.ReqChangeProperty(PARTY_GUILD, "GuildOnlyAgit", ctrl:IsChecked());

end


function UPDATE_GUILD_EVENT_INFO(frame, pcparty, partyObj)
	local pcEtc = GetMyEtcObject();

	if partyObj["GuildBossSummonFlag"] ~= 1 then
		session.minimap.RemoveIconInfo("GuildBossSummon");
	end
	if partyObj["GuildInDunFlag"] ~= 1 then
		session.minimap.RemoveIconInfo("GuildIndun");
	end

	if partyObj["GuildBossSummonFlag"] == 1 and pcEtc.GuildEventSeq == partyObj.GuildEventSeq then
		local locInfo = geClientGuildEvent.GetGuildEventLocaionInfo(pcparty, "GuildBossSummonLocInfo");
		if locInfo ~= nil then
			local mapCls = GetClassByType("Map", locInfo.mapID);
			local pos = geClientPartyQuest.GetLocInfoPos(locInfo);
			geClientGuildEvent.RunGuildEventAssembleCheck(true);
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
			--geClientGuildEvent.RunGuildEventAssembleCheck(true);
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
			geClientGuildEvent.RunGuildEventRaidFieldCheck(true);
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

--[[
function FIELD_BOSS_TEST()

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);

	local partyObj = GetIES(pcGuild:GetObject());

	print(partyObj["GuildBossSummonLocInfo"])

	local locInfo = geClientGuildEvent.GetGuildEventLocaionInfo(pcGuild);

	if locInfo ~= nil then
		local mapCls = GetClassByType("Map", locInfo.mapID);
		local linkStr = string.format("{#a62300}{a @SHOW_PARTY_QUEST_MAP_UI}%s{/}{/}", mapCls.Name);
		local descStr = ScpArgMsg("IfAllPartyMemberAssembleTo{MapName}_QuestWillBeStarted", "MapName", linkStr);
		--desc:SetTextByKey("value", descStr);
		--ctrlSet:SetUserValue("IS_ACCEPTED", "YES");
	
		local pos = geClientPartyQuest.GetLocInfoPos(locInfo);
		--geClientPartyQuest.RunPartyQuestAssembleCheck(true);
		local mapprop = session.GetCurrentMapProp();
		if locInfo.mapID == mapprop.type then
			session.minimap.AddIconInfo("PartyQuest_", "trasuremapmark", pos, ClMsg("PartyQuestArea"), true, "None", 1.5);
		end
	end

	print(locInfo.mapID)
	--ui.SysMsg(ScpArgMsg(msg));
	--ui.OpenFrame("indun");
end
]]--
