--  worldpvp_result.lua

function GUILDPVP_SET_AUTO_CHECK_TIME(frame, autoExitTime)
	local autoexittext = frame:GetChild("autoexittext");
	autoexittext:SetTextByKey("value", math.floor(autoExitTime));
	autoexittext:SetUserValue("END_TIME", imcTime.GetAppTime() + math.floor(autoExitTime));
	autoexittext:RunUpdateScript("WORLDPVP_RESULT_UPDATE_EXITTIME", 0, 0, 0, 1);
end

function GUILDPVP_SET_ELASPED_TIME(frame)
	local mgameInfo = session.mission.GetMGameInfo();
	local startTime = mgameInfo:GetUserValue("ToEndBattle_START");
	local elapsedTime = GetServerAppTime() - startTime;
	local min, sec = GET_QUEST_MIN_SEC(elapsedTime);
	local richtext_2 = frame:GetChild("richtext_2");
	richtext_2:SetTextByKey("min", min);
	richtext_2:SetTextByKey("sec", sec);
end

function GUILDPVP_SET_FIGHT_INFO(frame, type, win, lose)
	local gBox = frame:GetChild(type .. "Box")
	local total = gBox:GetChild(type .."Total")
	total:SetTextByKey("win", win);
	total:SetTextByKey("lose", lose);
end

function GUILDPVP_SET_GUILD_INFO(frame, type, index)
	local info = session.mgame.GetPVPAdditionalInfo();
	local gBox = frame:GetChild(type .. "Box")

	local serverName = gBox:GetChild(type .. "SN")
	local groupID = info:GetGuildGroupID(index);
	serverName:SetTextByKey("value", GetServerNameByGroupID(groupID));

	local guildName = gBox:GetChild(type .."GN")
	guildName:SetTextByKey("value", info:GetGuildName(index));

end

function GUILDPVP_SET_GUILD_INFO_SKIN(frame, winTeam)
	-- 둘다패배 무승부따윈 없다.
	local gBox = frame:GetChild("winBox")
	local result_1 = GET_CHILD(frame, "result_1", "ui::CPicture");
	local result_2 = GET_CHILD(frame, "result_2", "ui::CPicture");
	local winBox = gBox:GetChild("winTitle")

	if winTeam == 0 then
		gBox:SetSkinName("guildbattle_lose_bg");
		winBox:SetSkinName("guildbattle_lose_name")
		result_1:SetImage('guildbattle_lose');
		result_2:SetImage('guildbattle_lose');
	else
		gBox:SetSkinName("guildbattle_win_bg");
		winBox:SetSkinName("guildbattle_win_name")
		result_1:SetImage('guildbattle_win');
		result_2:SetImage('guildbattle_lose');
	end
end

function GUILDPVP_SET_TOWER_HP(frame, type, towerHP)
	local gBox = frame:GetChild(type .. "Box")
	local hpText = gBox:GetChild(type .. "HP")
	local hpPer = math.floor(towerHP/1000 * 100);
	if hpPer < 0 then
		hpPer = 0;
	end
	hpText:SetTextByKey("value", hpPer);

	local gauge =  GET_CHILD(gBox, type .. "Gague", "ui::CGauge");
	if 0 > towerHP then
		towerHP = 0;
	end
	gauge:SetPoint(towerHP, 1000);
end

function GUILDPVP_SET_KILL_DEATH_SCORE(frame, type, type2, score)
	local gBox = frame:GetChild(type .. "Box")
	local text = gBox:GetChild(type .. type2)
	text:SetTextByKey("value", score);
end

function GUILDPVP_RESULT_UI(argStr)
	local stringList = StringSplit(argStr, "\\");
	local frame = ui.GetFrame("guildpvp_result");

	local winTeam = tonumber(stringList[1]);
	if winTeam == 2 then
		GUILDPVP_SET_GUILD_INFO(frame, "win", 1);
		GUILDPVP_SET_GUILD_INFO(frame, "lose", 0);
	else
		GUILDPVP_SET_GUILD_INFO(frame, "win", 0);	
		GUILDPVP_SET_GUILD_INFO(frame, "lose", 1);
	end

	GUILDPVP_SET_GUILD_INFO_SKIN(frame, winTeam)
	GUILDPVP_SET_ELASPED_TIME(frame);
	GUILDPVP_SET_AUTO_CHECK_TIME(frame, tonumber(stringList[2]));

	GUILDPVP_SET_FIGHT_INFO(frame, "win", tonumber(stringList[3]), tonumber(stringList[4]));
	GUILDPVP_SET_FIGHT_INFO(frame, "lose", tonumber(stringList[5]), tonumber(stringList[6]));

	GUILDPVP_SET_TOWER_HP(frame, "win", tonumber(stringList[7]))
	GUILDPVP_SET_TOWER_HP(frame, "lose", tonumber(stringList[8]))

	GUILDPVP_SET_KILL_DEATH_SCORE(frame, "win", "kill", tonumber(stringList[9]));
	GUILDPVP_SET_KILL_DEATH_SCORE(frame, "win", "Death", tonumber(stringList[10]));
	
	GUILDPVP_SET_KILL_DEATH_SCORE(frame, "lose", "kill", tonumber(stringList[11]));
	GUILDPVP_SET_KILL_DEATH_SCORE(frame, "lose", "Death", tonumber(stringList[12]));

	local tokenPerChar = 10;
	local startIndex = 12
	local charCount = (#stringList - startIndex) / tokenPerChar;
	local winIndex, loseIndex = 1, 1;
	for i = 0, charCount - 1 do
		local idexBase = i * tokenPerChar + startIndex;
		if winIndex <= 3 then
			local gBox = frame:GetChild("winBox_2")
			GUILDPVP_SET_USER_SCORE(gBox, "win", winIndex, idexBase, stringList);
			winIndex = winIndex + 1;
		else
			local gBox = frame:GetChild("loseBox_2")
			GUILDPVP_SET_USER_SCORE(gBox, "lose", loseIndex, idexBase, stringList);
			loseIndex = loseIndex + 1;
		end
	end

	frame:ShowWindow(1);
end

function GUILDPVP_SET_USER_SCORE(frame, type, index, indexBase, stringList)
	local aid = stringList[indexBase + 1];
	local level = tonumber(stringList[indexBase + 2]);
	local teamID = tonumber(stringList[indexBase + 3]);
	local remainPoint = tonumber(stringList[indexBase + 4]);
	local isConnected = stringList[indexBase + 5];
	local iconStr = stringList[indexBase + 6];
	local famName = stringList[indexBase + 7];
	local charName = stringList[indexBase + 8];
	local killCnt = stringList[indexBase + 9];
	local deathCnt = stringList[indexBase + 10];
	local pic = GET_CHILD(frame, type .."UserClassIcon_"..index);
	pic:ShowWindow(1);

	local UserLevel = frame:GetChild(type .."UserLevel_"..index)
	UserLevel:ShowWindow(1);
	UserLevel:SetTextByKey("value", level);

	local UserName = frame:GetChild(type .."UserName_"..index)
	UserName:ShowWindow(1);
	UserName:SetTextByKey("value", charName);

	local UserKillCnt =frame:GetChild(type .."UserKillCnt_"..index)
	UserKillCnt:ShowWindow(1);
	UserKillCnt:SetTextByKey("value", killCnt);

	local UserDeathCnt = frame:GetChild(type .."UserDeathCnt_"..index)
	UserDeathCnt:ShowWindow(1);
	UserDeathCnt:SetTextByKey("value", deathCnt);

	if 'None' == aid then
		pic:ShowWindow(0);
		UserLevel:ShowWindow(0);
		UserName:ShowWindow(0);
		UserKillCnt:ShowWindow(0);
		UserDeathCnt:ShowWindow(0);
	else
		local iconInfo = ui.GetPCIconInfoByString(iconStr);
		local iconName = ui.CaptureModelHeadImage_IconInfo(iconInfo);
		pic:SetImage(iconName);
	end

	local mvp = GET_CHILD(frame, type .."MVP_"..index);
	if index == 1 then
		mvp:ShowWindow(1);
	else
		mvp:ShowWindow(0);
	end
end