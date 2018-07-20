function CHECK_CHALLENGE_MODE(pc, mon)
	local isChallengeModeMon = GetExProp(mon, "IsChallengeModeMon");

	local zoneInst = GetZoneInstID(pc);
	local isEnableChallengeModeZone = IsEnableChallengeModeZone(zoneInst);
	if isChallengeModeMon == 0 and isEnableChallengeModeZone == 0 then
		return;
	end
	if isChallengeModeMon == 0 then
		local owner = GetOwner(mon);
		if owner ~= nil then
			return;
		end

		local layer = GetLayer(mon);
		local layerObj = GetLayerObject(zoneInst, layer);

		if IsBuffApplied(mon, "ChallengeModeTrigger") == "YES" then

			local warpHandler = GetExProp(layerObj, "ChallengeModeWarpHandler");
			local isAlreadyOpend = 0;
			if warpHandler ~= 0 then
				local warpObj = GetByHandle(zoneInst, warpHandler);
				if warpObj ~= nil then
					isAlreadyOpend = 1;
				end
			end
			if isAlreadyOpend == 1 then
				SendSysMsg(pc, "AlreadyOpendChallengeModePortal");
				return
			end
			CREATE_CHALLENGE_MODE_PORTAL(mon, zoneInst, layerObj);
		end
		if layerObj ~= nil then
			local warpHandler = GetExProp(layerObj, "ChallengeModeWarpHandler");
			local isAlreadyOpend = 0;
			if warpHandler ~= 0 then
				local warpObj = GetByHandle(zoneInst, warpHandler);
				if warpObj ~= nil then
					isAlreadyOpend = 1;
				end
			end

			if isAlreadyOpend == 0 then
				local monKillCount = GetExProp(layerObj, "ChallengeModeKillMonCount") + 1;
			
				local clsList = GetClassList("challenge_mode");
				local dpk = GetClassByNameFromList(clsList, "DPK");
				if monKillCount >= TryGet(dpk, "Value") then
					SetExProp(layerObj, "ChallengeModeKillMonCount", 0);
					local warpPortalTriggerCreateDealyTime = GetClassByNameFromList(clsList, "WarpPortalTriggerCreateDealyTime");
                    
					RunScript("CREATE_CHALLENGE_MODE_TRIGGER", pc, layerObj, TryGet(warpPortalTriggerCreateDealyTime, "Value"));
				else
					SetExProp(layerObj, "ChallengeModeKillMonCount", monKillCount);
				end
			end
		end
	else
		local layer =  GetLayer(mon);
		local layerObj = GetLayerObject(zoneInst, layer);

		if layerObj ~= nil then
			local monKillCount = GetExProp(layerObj, "ChallengeModeKillMonCount");
			local eliteMonsterBuff = GetBuffByName(mon, "EliteMonsterBuff");
			if eliteMonsterBuff ~= nil then
				local clsList = GetClassList("challenge_mode");
				local dpk_eliteBonus = GetClassByNameFromList(clsList, "DPK_EliteMonBonus");

				monKillCount = monKillCount + TryGet(dpk_eliteBonus, "Value");
			else
				monKillCount = monKillCount + 1;
			end

			SetExProp(layerObj, "ChallengeModeKillMonCount", monKillCount);
		end
	end
end

function CHALLENGE_MODE_SET_TITLE_WARP_PORTAL(warp, warpPortalLifeTime)
    local startTime = imcTime.GetAppTimeMS();

    while 1 do
        sleep(1000);

        local curTime = imcTime.GetAppTimeMS();

        local time = (warpPortalLifeTime * 1000) - (curTime - startTime);
        time = time / 1000;

        local min = math.floor(time / 60);
        local sec = math.fmod(time, 60);
 
        if min < 0 or sec < 0 then
            ChallengeModeWarpPortalTitle(warp, "");
            break;
        else
            if sec > 10 then
                ChallengeModeWarpPortalTitle(warp, string.format("0%d : %d", min, sec));
            else
                ChallengeModeWarpPortalTitle(warp, string.format("0%d : 0%d", min, sec));
            end
        end
    end
end

function CREATE_CHALLENGE_MODE_PORTAL(mon, zoneInst, layerObj)
	local clsList = GetClassList("challenge_mode");
	local warpPortalLifeTimeCls = GetClassByNameFromList(clsList, "WarpPortalLifeTime");
	local warpPortalLifeTime = 600;
	if warpPortalLifeTimeCls ~= nil then
		local value = TryGet(warpPortalLifeTimeCls, "Value");
		if value ~= 0 then
			warpPortalLifeTime = value / 1000;
		end
	end

	local x, y, z = GetPos(mon);
	local warp = CREATE_MONSTER_EX(mon, "Hiddennpc_Challenge_Start", x, y, z, GetDirectionByAngle(mon), "Neutral", 1, SET_CHALLENGE_MODE_WARP_STONE);
	AttachEffect(warp, 'F_circle25', 2, 'TOP')
	SetLifeTime(warp, warpPortalLifeTime);
	SetDeadScript(warp, "SCR_DESTROY_CHALLENGE_MODE_WARP");

	local handle = GetHandle(warp);
	SetExProp(layerObj, "ChallengeModeWarpHandler", handle);

	BroadcastSysMsg(mon, "Create_ChallengeMode_WarpPortal");
	RunScript("CHALLENGE_MODE_SET_TITLE_WARP_PORTAL", warp, warpPortalLifeTime);
	
	ChallengeModeCreateMongoLog(warp, handle, x, y, z);
end

function SCR_DESTROY_CHALLENGE_MODE_WARP(self)
	ChallengeModeWarpDestroyed(self);
end

function CREATE_CHALLENGE_MODE_TRIGGER(pc, layerObj, createDelayTime)
	sleep(createDelayTime);

	local mon = CreateNearMonGen(pc);
	if mon ~= nil then
		AddBuff(mon, mon, "ChallengeModeTrigger", 1, 0);
	end
end

function SET_CHALLENGE_MODE_WARP_STONE(mon)
	mon.Enter = "None";
	mon.Dialog = "CHALLENGE_MODE_WARP";
end

function SET_CHALLENGE_MODE_NEXT_LEVEL(mon)
	mon.Enter = "None";
	mon.Dialog = "CHALLENGE_MODE_NEXT_LEVEL";
end

function SET_CHALLENGE_MODE_STOP_LEVEL(mon)
	mon.Enter = "None";
	mon.Dialog = "CHALLENGE_MODE_STOP_LEVEL";
end

function SET_CHALLENGE_MODE_COMPLETE_LEVEL(mon)
	mon.Enter = "None";
	mon.Dialog = "CHALLENGE_MODE_COMPLETE_LEVEL";
end

function GET_IS_APPROPRIATE_LEVEL(pc)
	local mapCls = GetMapProperty(pc);
	if mapCls == nil then
		return 0;
	end

	if pc.Lv < 200 then
		return 1;
	end

	if pc.Lv < (mapCls.QuestLevel - 30) then
		return 1;
	end

	if pc.Lv > (mapCls.QuestLevel + 30) then
		return 2;
	end

	return 3;
end

function SCR_CHALLENGE_MODE_WARP_DIALOG(self, target)
	if ChallengeModeIsEnableReJoin(target, GetHandle(self)) == 1 then
		ExecClientScp(target, "DIALOG_ACCEPT_CHALLENGE_MODE_RE_JOIN(" .. tostring(GetHandle(self)) .. ")");
	else
		ExecClientScp(target, "DIALOG_ACCEPT_CHALLENGE_MODE(" .. tostring(GetHandle(self)) .. ")");
	end
end

function SCR_CHALLENGE_MODE_NEXT_LEVEL_DIALOG(self, target)
	ExecClientScp(target, "DIALOG_ACCEPT_NEXT_LEVEL_CHALLENGE_MODE(" .. tostring(GetHandle(self)) .. ")");
end

function SCR_CHALLENGE_MODE_STOP_LEVEL_DIALOG(self, target)
	ExecClientScp(target, "DIALOG_ACCEPT_STOP_LEVEL_CHALLENGE_MODE(" .. tostring(GetHandle(self)) .. ")");
end

function SCR_CHALLENGE_MODE_COMPLETE_LEVEL_DIALOG(self, target)
	ExecClientScp(target, "DIALOG_COMPLETE_CHALLENGE_MODE(" .. tostring(GetHandle(self)) .. ")");
end

function CHALLENGE_MODE_MON_POWERUP(mon, level, pcCount)
	local clsList = GetClassList("challenge_mode");

	local atk = nil;
	local mhp = nil;
	local def = nil;
	local mdef = nil;
	local mhp = nil;
	
	if mon.MonRank == "Boss" then
        atk = GetClassByNameFromList(clsList, "Boss_PowerUp_AtkRate_Lv" .. level);
        matk = GetClassByNameFromList(clsList, "Boss_PowerUp_MAtkRate_Lv" .. level);
        def = GetClassByNameFromList(clsList, "Boss_PowerUp_DefRate_Lv" .. level);
        mdef = GetClassByNameFromList(clsList, "Boss_PowerUp_MDefRate_Lv" .. level);
   	    mhp = GetClassByNameFromList(clsList, "Boss_PowerUp_MHPRate_Lv" .. level);  
	else
        atk = GetClassByNameFromList(clsList, "PowerUp_AtkRate_Lv" .. level);
        matk = GetClassByNameFromList(clsList, "PowerUp_MAtkRate_Lv" .. level);
        def = GetClassByNameFromList(clsList, "PowerUp_DefRate_Lv" .. level);
        mdef = GetClassByNameFromList(clsList, "PowerUp_MDefRate_Lv" .. level);
        mhp = GetClassByNameFromList(clsList, "PowerUp_MHPRate_Lv" .. level);  
	end

	local atkRate = 99;
	if atk ~= nil then
		atkRate = TryGet(atk, "Value");
	end

	local matkRate = 99;
	if matkRate ~= nil then
		matkRate = TryGet(matk, "Value");
	end

	local defRate = 99;
	if defRate ~= nil then
		defRate = TryGet(def, "Value");
	end

	local mdefRate = 99;
	if mdefRate ~= nil then
		mdefRate = TryGet(mdef, "Value");
	end

	local mhpRate = 99;
	if mhpRate ~= nil then
		mhpRate = TryGet(mhp, "Value");
	end

	local partyPenalty = (pcCount - 1) * 0.2;

	local addpatk = math.floor(mon.MAXPATK - mon.PATK_BM) * atkRate;
	local addmatk = math.floor(mon.MAXMATK - mon.MATK_BM) * matkRate;
	local adddef = math.floor(mon.DEF - mon.DEF_BM) * defRate;
	local addmdef = math.floor(mon.MDEF - mon.MDEF_BM) * mdefRate;
	local addmhp = math.floor(mon.MHP - mon.MHP_BM) * (mhpRate + partyPenalty);
	
	local avgPATK = (SCR_Get_MON_MINPATK(mon) + SCR_Get_MON_MAXPATK(mon)) / 2;
	local avgMATK = (SCR_Get_MON_MINMATK(mon) + SCR_Get_MON_MAXMATK(mon)) / 2;

	SetExProp(mon, "CHALLENGE_MODE_DEFAULT_PATK", avgPATK);
	SetExProp(mon, "CHALLENGE_MODE_DEFAULT_MATK", avgMATK);
	SetExProp(mon, "CHALLENGE_MODE_DEFAULT_DEF", mon.DEF);
	SetExProp(mon, "CHALLENGE_MODE_DEFAULT_MDEF", mon.MDEF);
	SetExProp(mon, "CHALLENGE_MODE_DEFAULT_MHP", mon.MHP);
	
	mon.PATK_BM = mon.PATK_BM + addpatk;
	mon.MATK_BM = mon.MATK_BM + addmatk;
	mon.DEF_BM = mon.DEF_BM + adddef;
	mon.MDEF_BM = mon.MDEF_BM + addmdef;
	mon.MHP_BM = mon.MHP_BM + addmhp;

	InvalidateStates(mon);
	AddHP(mon, mon.MHP);
end

function GET_CHALLENGE_MODE_COMPLETE_BUFF_TIME()
	local curTime = GetDBTime();
	local strNextDay;
	if curTime.wHour >= 6 then
		local nextDay = imcTime.AddSec(curTime, 86399);
		strNextDay = string.format("%04d%02d%1d%02d%02d%02d%02d", nextDay.wYear, nextDay.wMonth, nextDay.wDayOfWeek, nextDay.wDay, 6, 0, 0, 0);
		
	else
		strNextDay = string.format("%04d%02d%1d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, curTime.wDayOfWeek, curTime.wDay, 6, 0, 0, 0);
	end

	local nextResetTime = imcTime.GetSysTimeByStr(strNextDay);

	local buffTime = imcTime.GetIntDifSec(nextResetTime, curTime) * 1000;

	return buffTime;
end

function CHALLENGE_MODE_PLAYER_BUFF(pc, level)
	SetExProp(pc, "ChallengeMode_Level", level);
	RemoveBuff(pc, "ChallengeMode_Player");
	AddBuff(pc, pc, "ChallengeMode_Player", 1, 0);
end

-- 참여 가능 여부 체크
function CHALLENGE_MODE_IS_ENABLE_JOIN(group, pc, warpHandle, level, isShowErrorMsg)
	-- group 가 nil 인 경우는 싱글 또는 파티의 최초 진입자인 경우
	-- nil 이 아닌 경우는 파티원이 따라 들어가는 경우
	if group ~= nil then
		-- 이 경우 이미 실패했거나 파괴 중일 때는 들여보내주지 말자
		local state = GetChallengeModeState(group);
		if state == "Fail" or state == "Destroy" or state == "Complete" then
			if isShowErrorMsg == 1 then
				SendSysMsg(pc, "AlreadyFailOrDestroy_ChallengeMode");
			end
			return "NO";
		end
	end

	if level > 1 then
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "CantJoinTheGroup");
		end
		return "NO";
	end

	if IsBuffApplied(pc, "ChallengeMode_Completed") == "YES" then
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "YouAlreadyPlayedChallengeMode");
		end
		return "NO";
	end

	local isAppropriateLevel = GET_IS_APPROPRIATE_LEVEL(pc);
	if isAppropriateLevel == 0 then
		-- 맵 데이터가 정상적이지 않은 경우
		return "NO";
	elseif isAppropriateLevel == 1 then
		-- 레벨이 낮음
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "CantJoinLowLevel_ChallengeMode");
		end
		return "NO";
	elseif isAppropriateLevel == 2 then
		-- 레벨이 높음
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "CantJoinHighLevel_ChallengeMode");
		end
		return "NO";
	end
	
	local layer = GetLayer(pc);
	local zoneInst = GetZoneInstID(pc);
	local layerObj = GetLayerObject(zoneInst, layer);

	local handle = GetExProp(layerObj, "ChallengeModeWarpHandler");
	if handle ~= warpHandle then
		-- 나쁜짓하려는 아이들일 가능성이 높음
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "AlreadyEndedChallengeMode");
		end
		return "NO";
	else
		-- 이미 포탈이 닫힌 경우 체크
		if handle == 0 then
			if isShowErrorMsg == 1 then
				SendSysMsg(pc, "AlreadyEndedChallengeMode");
			end
			return "NO";
		else
			local warp = GetByHandle(zoneInst, handle);
			if warp == nil then
				if isShowErrorMsg == 1 then
					SendSysMsg(pc, "AlreadyEndedChallengeMode");
				end
				return "NO";
			end
		end
	end

	return "YES";
end

function CHALLENGE_MODE_IS_ENABLE_RE_JOIN(group, layerObj, pc, joinedCIDList, joinedCIDCount, level, isShowErrorMsg)
	if IsBuffApplied(pc, "ChallengeMode_Completed") == "NO" then
		return "NO", 0;
	end

	local isJoined = false;
	local cid = GetPcCIDStr(pc);
	for i = 1, joinedCIDCount do
		local joinedCID = joinedCIDList[i];

		if cid == joinedCID then
			isJoined = true;
			break;
		end
	end
	
	if isJoined == false then
		return "NO", 0;
	end

	local lastJoinedLevel = GetExProp(layerObj, "ChallengeModeJoinedLevel_" .. cid);
	if lastJoinedLevel > 0 and lastJoinedLevel ~= level then
		if isShowErrorMsg == 1 then
			SendSysMsg(pc, "CantReJoin_DifferentLevel_ChallengeMode");
			return "NO", 0;
		else
			return "NO", 1;
		end
	end
    if level > 1 then
        local leavedTimeName = "ChallengeModeLeavedTime" .. cid;
        local leavedTime = GetExProp(layerObj, leavedTimeName)
        local diffTimeMS = imcTime.GetAppTimeMS() - leavedTime;
        if diffTimeMS >= 300000 then
            SendSysMsg(pc, "ChallengeModeReJoinPossibleTimeOut");
            return "NO", 0;
        end
    end
	return "YES", 0;
end

function CHALLENGE_MODE_JOIN_PLAYER(gameObject, pc, layer, isReJoin)
	local level = GetChallengeModeLevel(gameObject);
	SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "SHOW#" .. tostring(level) .. "#");

	local state = GetChallengeModeState(gameObject);
	if state == "Run" or state == "Boss" then
		local playTime = GetChallengeModePlayTime(gameObject);

		local clsList = GetClassList("challenge_mode");
		local challengeTimeCls = GetClassByNameFromList(clsList, "ChallengeTime");
		local challengeTime = TryGet(challengeTimeCls, "Value");

		local leftTime = challengeTime - playTime;
		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "START_CHALLENGE_TIMER#" .. leftTime .. "#");
	elseif state == "Complete" then
		local stateTime = GetChallengeModeStateTime(gameObject);

		local clsList = GetClassList("challenge_mode");
		local completeTimeCls = GetClassByNameFromList(clsList, "CompleteTime");
		local completeTime = TryGet(completeTimeCls, "Value");

		local leftTime = completeTime - stateTime;
		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "START_CHALLENGE_TIMER#" .. leftTime .. "#");
	end
	
	if isReJoin == 0 then
		local buffTime = GET_CHALLENGE_MODE_COMPLETE_BUFF_TIME();
		AddBuff(pc, pc, "ChallengeMode_Completed", 1, 0, buffTime);
	end
	CHALLENGE_MODE_PLAYER_BUFF(pc, 1);

	SetLayer(pc, layer, 0);

	FADE_OUT(pc, 1);

	RunScript("CHALLENGE_MODE_FADE_IN", pc);
	
	local level = GetChallengeModeLevel(gameObject);
	local type = "Join";
	if isReJoin == 1 then
		type = "ReJoin";
	end
	
	CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", type, "Level", tostring(level));
end

function CHALLENGE_MODE_IS_ENABLE_NEXT_LEVEL(pc, handle)
	if handle == 0 then
		return "NO";
	end

	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	if layerObj ~= nil then
		local warpHandle = GetExProp(layerObj, "NextWarpHandle");
		if warpHandle == handle then
			return "YES";
		end
	end

	return "NO";
end

function CHALLENGE_MODE_IS_ENABLE_STOP_LEVEL(pc, handle)
	if handle == 0 then
		return "NO";
	end

	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	if layerObj ~= nil then
		local warpHandle = GetExProp(layerObj, "StopWarpHandle");
		if warpHandle == handle then
			return "YES";
		end
	end

	return "NO";
end

function CHALLENGE_MODE_LEAVE_PLAYER(pc, layerObj)
	RemoveBuff(pc, "ChallengeMode_Player");

	SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "HIDE#");
	
	CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Leave");
	
	local leavedTimeName = "ChallengeModeLeavedTime" .. GetPcCIDStr(pc);
    SetExProp(layerObj, leavedTimeName, imcTime.GetAppTimeMS());

end

function CHALLENGE_MODE_FADE_IN(pc)
    sleep(1000);
	FADE_OUT(pc, 0);
end

function CHALLENGE_MODE_REWARD(pc, level)
	local tx = TxBegin(pc);
	if tx ~= nil then
       	local clsList = GetClassList("challenge_mode");
    	local mapCls = GetMapProperty(pc);
    	if mapCls == nil then
		    return 0;
		end

        if 200 <= mapCls.QuestLevel and mapCls.QuestLevel <= 299 then
        	local rewardCubeName = GetClassByNameFromList(clsList, "RewardCubeName200");
                TxGiveItem(tx, TryGet_Str(rewardCubeName, "Value_Str"), level, "CHALLENGE_MODE_REWARD");
        elseif 300 <= mapCls.QuestLevel then
       		local rewardCubeName = GetClassByNameFromList(clsList, "RewardCubeName300")
                TxGiveItem(tx, TryGet_Str(rewardCubeName, "Value_Str"), level, "CHALLENGE_MODE_REWARD");
    	end
        if 300 <= mapCls.QuestLevel and level >= 6 then
            local rewardCubeName = GetClassByNameFromList(clsList, "AddRewardCubeName")
                TxGiveItem(tx, TryGet_Str(rewardCubeName, "Value_Str"), level-5, "CHALLENGE_MODE_REWARD");
        end
        TxAddAchievePoint(tx, "Challenge_AP1", 1)
    	local ret = TxCommit(tx);
    	if ret ~= "SUCCESS" then
    		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "RewardFailed", "Level", level, "RewardItem", TryGet_Str(rewardCubeName, "Value_Str"));
    		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "RewardFailed", "Level", level, "Challenge_AdventurePoint1", 1);
    		IMC_LOG('ERROR_TX_FAIL', 'CHALLENGE_MODE_REWARD_ENTER: aid['..GetPcAIDStr(pc)..']');
    	else
    		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "RewardSuccess", "Level", level, "RewardItem", TryGet_Str(rewardCubeName, "Value_Str"));
    	    CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "RewardSuccess", "Level", level, "Challenge_AdventurePoint1", 1);
    	end
    end
end

function CHALLENGE_MODE_READY_ENTER(gameObject, layerObj, pcList, pcCount)
	ChallengeModeCompleteLevel(gameObject);
	local level = GetChallengeModeLevel(gameObject);

	SetExProp(layerObj, "ChallengeModeLevel", level);
	SetExProp(layerObj, "ChallengeModeKillMonCount", 0);
	SetExProp(layerObj, "ChallengeModeCreateMonCount", 0);
	SetExProp(layerObj, "IsCreatedChallengeModeWarp", 0);
	SetExProp(layerObj, "IsCreatedChallengeModeBossMonster", 0);
	SetExProp(layerObj, "IsChallengeModeShowMonKillMax", 0);
	SetExProp(layerObj, "CreateChallengeMonCount", 0);

	if level > 0 then
		for i = 1, pcCount do
			local pc = pcList[i];
			CHALLENGE_MODE_PLAYER_BUFF(pc, level);
			SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "GAUGERESET#" .. tostring(level) .. "#");

			CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Ready", "Level", tostring(level));
		end
	end
end

function CHALLENGE_MODE_READY_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if stateTime >= 5000 then
		ChallengeModeChangeState(gameObject, "Run");
	end
end

function CHALLENGE_MODE_READY_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function CHALLENGE_MODE_RUN_ENTER(gameObject, layerObj, pcList, pcCount)
	ResetChallengeModePlayTime(gameObject);
	local level = GetChallengeModeLevel(gameObject);

	local clsList = GetClassList("challenge_mode");
	local challengeTimeCls = GetClassByNameFromList(clsList, "ChallengeTime");
	local challengeTime = tostring(TryGet(challengeTimeCls, "Value"));
	
	for i = 1, pcCount do
		local pc = pcList[i];
		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "START_CHALLENGE_TIMER#" .. challengeTime .. "#");

		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Run", "Level", tostring(level));
	end
end

function CHALLENGE_MODE_RUN_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	local clsList = GetClassList("challenge_mode");
	local challengeTimeCls = GetClassByNameFromList(clsList, "ChallengeTime");

	if playTime >= TryGet(challengeTimeCls, "Value") then
		for i = 1, pcCount do
			local pc = pcList[i];
			SendSysMsg(pc, "TimeOver_ChallengeMode");
		end

		SetExProp_Str(layerObj, "FailReason", "TimeOut");
		ChallengeModeChangeState(gameObject, "Fail");
		return;
	end

	local level = GetChallengeModeLevel(gameObject);
	local createMonCount = GetExProp(layerObj, "ChallengeModeCreateMonCount");
	local killMonCount = GetExProp(layerObj, "ChallengeModeKillMonCount");
	
	local clsList = GetClassList("challenge_mode");
	local killCount = GetClassByNameFromList(clsList, "KillCount_Lv" .. level);
	local targetKillCount = TryGet(killCount, "Value");
	
	local isAllDead = 1;

	for i = 1, pcCount do
		local pc = pcList[i];
		
		if IsDead(pc) == 0 then
			isAllDead = 0;
		end

		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "REFRESH#" .. tostring(killMonCount) .. "#" .. tostring(targetKillCount) .. "#");
	end
	
	if isAllDead == 1 then
		for i = 1, pcCount do
			local pc = pcList[i];
			SendSysMsg(pc, "AllDead_ChallengeMode");
		end
		SetExProp_Str(layerObj, "FailReason", "AllDead");
		ChallengeModeChangeState(gameObject, "Fail");
	end
	
	if killMonCount >= targetKillCount then
		local isChallengeModeShowMonKillMax = GetExProp(layerObj, "IsChallengeModeShowMonKillMax");
		if isChallengeModeShowMonKillMax == 0 then
			for i = 1, pcCount do
				local pc = pcList[i];
				SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "MONKILLMAX#");
			end

			SetExProp(layerObj, "IsChallengeModeShowMonKillMax", 1);
		end

		ChallengeModeChangeState(gameObject, "Boss");
	else
		local pc = pcList[1];
		
		local zoneInst = GetZoneInstID(pc);
		local layer = GetLayer(pc);

		local monCount = 0;
		local monList, cnt = GetLayerMonList(zoneInst, layer);
		for i = 1, cnt do
			local owner = GetOwner(monList[i]);
			local isFriend = 0;
			if owner ~= nil then
				if GetObjType(owner) == OT_PC then
					isFriend = 1;
				end
			end

			if isFriend == 0 then
				local topHater = GetNearTopHateEnemy(monList[i]);
				if topHater == nil then
					InsertHate(monList[i], pc, 1);
				end

				monCount = monCount + 1;
			end
		end
		
		if monCount <= 10 then
			local gentype_idspace = 'GenType_'..GetZoneName(pc);
			local clsList, class_count = GetClassList(gentype_idspace);
			
			if class_count > 0 then
				local monList = {};

				for i = 0, class_count - 1 do
					local classIES_gentype = GetClassByIndexFromList(clsList, i);
					if classIES_gentype.Faction == "Monster" then
						local clsMon = GetClass("Monster", classIES_gentype.ClassType);
						if clsMon ~= nil and clsMon.MonRank == "Normal" and clsMon.MoveType ~= "Holding" then
							monList[#monList + 1] = clsMon;
						end
					end
				end
				
				if #monList > 0 then
					local createCount = 0;
					
					local clsList = GetClassList("challenge_mode");
					local createMonsterCountCls = GetClassByNameFromList(clsList, "CreateMonsterCount_Lv" .. level);
					local createMonsterCount = TryGet(createMonsterCountCls, "Value");

					for i = 1, createMonsterCount - monCount do
						local pcIndex = IMCRandom(1, pcCount);
						local randomPC = pcList[pcIndex];
						local x1, y1, z1 = GetPos(randomPC);
						local x, y, z = GetRandomPosInRange (randomPC, x1, y1, z1, 20, 50);
                       	
						if IsValidPos(zoneInst, x, y, z) == "YES" then
							local monIndex = IMCRandom(1, #monList);
							local monObj = CreateGCIES('Monster', monList[monIndex].ClassName);
						    monObj.Lv = monList[monIndex].Level;
							local mon = CreateMonster(randomPC, monObj, x, y, z, 0, 200, 0, layer);
							if mon ~= nil then
        						local level = GetChallengeModeLevel(gameObject);
        						if level >= 6 then
            						local percent = (createMonCount + createCount) / targetKillCount;
        							if math.fmod(percent, 0.2) == 0 then
        							    AddBuff(mon, mon,  "EliteMonsterBuff", 1, 0);
        							end
        						end
        						
								createCount = createCount + 1;

								InsertHate(monObj, randomPC, 999);

								CHALLENGE_MODE_MON_POWERUP(mon, level, pcCount);

								SetExProp(mon, "IsChallengeModeMon", 1);
							end
						end
					end

					SetExProp(layerObj, "ChallengeModeCreateMonCount", createMonCount + createCount);
				end
			end
		end
	end
end

function CHALLENGE_MODE_RUN_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if pcCount < 1 then
		return;
	end

	local pc = pcList[1];
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);

	local monList, cnt = GetLayerMonList(zoneInst, layer);
	for i = 1, cnt do
		local owner = GetOwner(monList[i]);
		local isFriend = 0;
		if owner ~= nil then
			if GetObjType(owner) == OT_PC then
				isFriend = 1;
			end
		end

		if isFriend == 0 then
			Dead(monList[i]);
		end
	end
end

function CHALLENGE_MODE_BOSS_ENTER(gameObject, layerObj, pcList, pcCount)
	local level = GetChallengeModeLevel(gameObject);

	for i = 1, pcCount do
		local pc = pcList[i];
		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Boss", "Level", tostring(level));
	end
end

function CHALLENGE_MODE_BOSS_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	local clsList = GetClassList("challenge_mode");
	local challengeTime = GetClassByNameFromList(clsList, "ChallengeTime");

	if playTime >= TryGet(challengeTime, "Value") then
		for i = 1, pcCount do
			local pc = pcList[i];
			SendSysMsg(pc, "TimeOver_ChallengeMode");
		end
		SetExProp_Str(layerObj, "FailReason", "TimeOut");
		ChallengeModeChangeState(gameObject, "Fail");
		return;
	end

	--if pcCount < 1 then
	--	SetExProp_Str(layerObj, "FailReason", "EmptyPlayer");
	--	ChallengeModeChangeState(gameObject, "Fail");
	--	return;
	--end
	
	local level = GetChallengeModeLevel(gameObject);
	local clsList = GetClassList("challenge_mode");
	local killCount = GetClassByNameFromList(clsList, "KillCount_Lv" .. level);
	local targetKillCount = TryGet(killCount, "Value");

	local isAllDead = 1;

	for i = 1, pcCount do
		local pc = pcList[i];

		if IsDead(pc) == 0 then
			isAllDead = 0;
		end

		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "REFRESH#" .. tostring(targetKillCount) .. "#" .. tostring(targetKillCount) .. "#");
	end

	if isAllDead == 1 then
		for i = 1, pcCount do
			local pc = pcList[i];
			SendSysMsg(pc, "AllDead_ChallengeMode");
		end
		SetExProp_Str(layerObj, "FailReason", "AllDead");
		ChallengeModeChangeState(gameObject, "Fail");
	end

	if stateTime >= 5000 then
		local isCreatedChallengeModeBossMonster = GetExProp(layerObj, "IsCreatedChallengeModeBossMonster");
		if isCreatedChallengeModeBossMonster == 0 then
    		local bossMonClassName = "item_summon_boss_RingCrawler";
            local bossLevel = 300;
            local clsList, cnt = GetClassList("item_summonboss");
            if cnt > 0 then
            local bossMonList = {}
                for i = 0, cnt - 1 do
                local bossclass = GetClassByIndexFromList(clsList, i);
                    if bossclass.OnlyCardBookUse ~= "YES" then
                        bossMonList[#bossMonList + 1] = bossclass;
                    end
                end
            local randomIndex = IMCRandom(1, #bossMonList);
            local bossCls = bossMonList[randomIndex];
            if bossCls ~= nil then
                    bossMonClassName = bossCls.MonsterClassName;
                else
                    IMC_LOG("ERROR_CHALLENGE_MODE", "Boss Class is nullptr, RandomIndex : " .. tostring(randomIndex));
                end
            else
                IMC_LOG("ERROR_CHALLENGE_MODE", "item_summonboss Data is empty");
            end
            local pcIndex = IMCRandom(1, pcCount);
            local randomPC = pcList[pcIndex];
            
            local mapCls = GetMapProperty(randomPC);
            if mapCls ~= nil then
                bossLevel = mapCls.QuestLevel;
            else
                local sumLevel = 0;
                for i = 1, pcCount do
                    local pc = pcList[i];
                    sumLevel = sumLevel + pc.Lv;
                end

                bossLevel = sumLevel / pcCount;

                IMC_LOG("ERROR_CHALLENGE_MODE", "Map Class is nullptr");
            end

            local monObj = CreateGCIES('Monster', bossMonClassName);
            monObj.Lv = bossLevel;
            monObj.StatType = "7001";

			local zoneInst = GetZoneInstID(randomPC);

			local range = 50;
			local x, y, z = GetPos(randomPC);
			x, y, z = GetRandomPos(randomPC, x, y, z, range);

			while 1 do
				if IsValidPos(zoneInst, x, y, z) == "YES" then
					break;
				end

				x, y, z = GetRandomPos(randomPC, x, y, z, range);
				range = range + 50;
			end

			local mon = CreateMonster(randomPC, monObj, x, y, z, 0, 0, 0, layer);
			if mon ~= nil then
				if 200 <= mapCls.QuestLevel and mapCls.QuestLevel <= 230 then
					monObj.DropItemList = "Challenge_boss_drop_220";
				elseif 231 <= mapCls.QuestLevel and mapCls.QuestLevel <= 280 then
					monObj.DropItemList = "Challenge_boss_drop_270";
				elseif 281 <= mapCls.QuestLevel and mapCls.QuestLevel <= 325 then
					monObj.DropItemList = "Challenge_boss_drop_315";
				elseif 326 <= mapCls.QuestLevel then
					monObj.DropItemList = "Challenge_boss_drop_350";
				end

				InsertHate(monObj, randomPC, 999);
		
				CHALLENGE_MODE_MON_POWERUP(mon, level, pcCount);

				SetExProp(mon, "IsChallengeModeMon", 1);
				SetExProp(layerObj, "BossHandler", GetHandle(mon));
			end

			SetExProp(layerObj, "IsCreatedChallengeModeBossMonster", 1);
		end
	end

	local zoneInst = GetZoneInstID(pcList[1]);
	local handle = GetExProp(layerObj, "BossHandler");
	local bossMon = GetByHandle(zoneInst, handle);
	if bossMon ~= nil then
		if IsDead(bossMon) == 1 then
			ChallengeModeChangeState(gameObject, "Complete");
		end
	end
end

function CHALLENGE_MODE_BOSS_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function CHALLENGE_MODE_COMPLETE_ENTER(gameObject, layerObj, pcList, pcCount)
	if pcCount < 1 then
		return;
	end
	
	local level = GetChallengeModeLevel(gameObject);

	local clsList = GetClassList("challenge_mode");
	local completeTimeCls = GetClassByNameFromList(clsList, "CompleteTime");
	local completeTime = tostring(TryGet(completeTimeCls, "Value"));

	for i = 1, pcCount do
		local pc = pcList[i];
		SendAddOnMsg(pc, "UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "START_CHALLENGE_TIMER#" .. completeTime .. "#");
		
		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Complete", "Level", tostring(level));
	end
end

function CHALLENGE_MODE_COMPLETE_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if stateTime >= 10000 then
		local isCreatedChallengeModeWarp = GetExProp(layerObj, "IsCreatedChallengeModeWarp");
		if isCreatedChallengeModeWarp == 0 then
			local randomIndex = IMCRandom(1, pcCount);
			local pc = pcList[randomIndex];
			
			local clsList = GetClassList("challenge_mode");
			local limitLevel = GetClassByNameFromList(clsList, "Level");
			local level = GetChallengeModeLevel(gameObject);
			local warpLifeTime = GetClassByNameFromList(clsList, "CompleteTime")
			local time = TryGet(warpLifeTime, "Value");
			if time == 0 then
			    time = 600;
			else
			    time = time / 1000 + 300;
			end
			if level < TryGet(limitLevel, "Value") then

				local zoneInst = GetZoneInstID(pc);
				local x, y, z = GetPos(pc);
				local x1, y1, z1, x2, y2, z2;

				local range = 50;
				while 1 do
					local xx, yy, zz;
					xx = x + 30;
					yy = y;
					zz = z + 30;

					if IsValidPos(zoneInst, x, y, z) == "YES" then
						if IsValidPos(zoneInst, xx, yy, zz) == "YES" then
							x1 = xx;
							y1 = yy;
							z1 = zz;
							
							x2 = x;
							y2 = y;
							z2 = z;
							break;
						end
					end

					x, y, z = GetRandomPos(pc, x, y, z, range);
					range = range + 50;
				end

				local warp_stop = CREATE_MONSTER_EX(pc, "Hiddennpc_Challenge_Stop", x1, y1, z1, GetDirectionByAngle(pc), "Neutral", 1, SET_CHALLENGE_MODE_STOP_LEVEL);
				AttachEffect(warp_stop, 'F_circle25_blue', 2, 'TOP')
				SetLifeTime(warp_stop, time);

				SetExProp(layerObj, "StopWarpHandle", GetHandle(warp_stop));

				x, y, z = GetPos(pc);
				local warp_next = CREATE_MONSTER_EX(pc, "Hiddennpc_Challenge_Next", x2, y2, z2, GetDirectionByAngle(pc), "Neutral", 1, SET_CHALLENGE_MODE_NEXT_LEVEL);
				AttachEffect(warp_next, 'F_circle25_red', 2, 'TOP')
				SetLifeTime(warp_next, time);
		
				SetExProp(layerObj, "NextWarpHandle", GetHandle(warp_next));
			else
				local x, y, z = GetPos(pc);

				local warp_stop = CREATE_MONSTER_EX(pc, "Hiddennpc_Challenge_Stop", x, y, z, GetDirectionByAngle(pc), "Neutral", 1, SET_CHALLENGE_MODE_COMPLETE_LEVEL);
				AttachEffect(warp_stop, 'F_circle25', 2, 'TOP')
				SetLifeTime(warp_stop, time);

				SetExProp(layerObj, "StopWarpHandle", GetHandle(warp_stop));
			end

			SetExProp(layerObj, "IsCreatedChallengeModeWarp", 1);
		end
	end
	
	local clsList = GetClassList("challenge_mode");
	local completeTimeCls = GetClassByNameFromList(clsList, "CompleteTime");
	local completeTime = TryGet(completeTimeCls, "Value");

	if stateTime >= completeTime then
		ChallengeModeChangeState(gameObject, "Reward");
	end
end

function CHALLENGE_MODE_COMPLETE_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if pcCount > 0 then
		local pc = pcList[1];
		local zoneInst = GetZoneInstID(pc);
		local layer = GetLayer(pc);

		local monList, cnt = GetLayerMonList(zoneInst, layer);
		for i = 1, cnt do
			local owner = GetOwner(monList[i]);
			local isFriend = 0;
			if owner ~= nil then
				if GetObjType(owner) == OT_PC then
					isFriend = 1;
				end
			end

			if isFriend == 0 then
				Dead(monList[i]);
			end
		end
	
		local stopWarpHandle = GetExProp(layerObj, "StopWarpHandle");
		if stopWarpHandle ~= 0 then
			local warp = GetByHandle(zoneInst, stopWarpHandle);
			if warp ~= nil then
				Dead(warp);
			end

			SetExProp(layerObj, "StopWarpHandle", 0);
		end

		local nextWarpHandle = GetExProp(layerObj, "NextWarpHandle");
		if nextWarpHandle ~= 0 then
			local warp = GetByHandle(zoneInst, nextWarpHandle);
			if warp ~= nil then
				Dead(warp);
			end

			SetExProp(layerObj, "NextWarpHandle", 0);
		end
	end
end

function CHALLENGE_MODE_REWARD_ENTER(gameObject, layerObj, pcList, pcCount)
	local level = GetChallengeModeLevel(gameObject);

	for i = 1, pcCount do
		local pc = pcList[i];
		RunScript("CHALLENGE_MODE_REWARD", pc, level);
		
		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Reward", "Level", tostring(level));
	end
end

function CHALLENGE_MODE_REWARD_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if stateTime >= 10000 then
		ChallengeModeChangeState(gameObject, "Destroy");
	end
end

function CHALLENGE_MODE_REWARD_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function CHALLENGE_MODE_FAIL_ENTER(gameObject, layerObj, pcList, pcCount)
	local level = GetChallengeModeLevel(gameObject);
	
	local failReason = GetExProp_Str(layerObj, "FailReason");

	for i = 1, pcCount do
		local pc = pcList[i];

		CustomMongoLog(pc, "ChallengeMode", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "Type", "Fail", "Level", tostring(level), "FailReason", failReason);
	end

	if pcCount > 0 then
		local pc = pcList[1];
		local zoneInst = GetZoneInstID(pc);
		local layer = GetLayer(pc);

		local monList, cnt = GetLayerMonList(zoneInst, layer);
		for i = 1, cnt do
			local mon = monList[i];
			local owner = GetOwner(mon);
			local isFriend = 0;
			if owner ~= nil then
				if GetObjType(owner) == OT_PC then
					isFriend = 1;
				end
			end

			if isFriend == 0 then
				if mon.MonRank == "Boss" then
					ResetHate(mon);
					AddBuff(mon, mon, "Invincible", 1, 0);
				else
					Dead(mon);
				end
			end
		end
	
		local stopWarpHandle = GetExProp(layerObj, "StopWarpHandle");
		if stopWarpHandle ~= 0 then
			local warp = GetByHandle(zoneInst, stopWarpHandle);
			if warp ~= nil then
				Dead(warp);
			end

			SetExProp(layerObj, "StopWarpHandle", 0);
		end

		local nextWarpHandle = GetExProp(layerObj, "NextWarpHandle");
		if nextWarpHandle ~= 0 then
			local warp = GetByHandle(zoneInst, nextWarpHandle);
			if warp ~= nil then
				Dead(warp);
			end
		
			SetExProp(layerObj, "NextWarpHandle", 0);
		end
	end
end

function CHALLENGE_MODE_FAIL_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
	if stateTime >= 5000 then
		ChallengeModeChangeState(gameObject, "Destroy");
	end
end

function CHALLENGE_MODE_FAIL_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function CHALLENGE_MODE_DESTROY_ENTER(gameObject, layerObj, pcList, pcCount)
	local level = GetChallengeModeLevel(gameObject);

	for i = 1, pcCount do
		local pc = pcList[i];

		SetLayer(pc, 0);
		
		FADE_OUT(pc, 1);

		RunScript("CHALLENGE_MODE_FADE_IN", pc);
	end
	ChallengeModeSetDead(gameObject);
end

function CHALLENGE_MODE_DESTROY_UPDATE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function CHALLENGE_MODE_DESTROY_LEAVE(gameObject, layerObj, pcList, pcCount, playTime, stateTime)
end

function SCR_BUFF_ENTER_ChallengeMode_Completed(self, buff, arg1, arg2, over)
	ChallengeModeStartReJoinChecker(self);
end

-- CHEAT FOR TEST
function TEST_CM_SET_DPK(pc, value)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	if layerObj ~= nil then
		local monKillCount1 = GetExProp(layerObj, "ChallengeModeKillMonCount");

		SetExProp(layerObj, "ChallengeModeKillMonCount", value);
		
		local monKillCount2 = GetExProp(layerObj, "ChallengeModeKillMonCount");
		
		Chat(pc, string.format("Set DPK : %d -> %d", monKillCount1, monKillCount2));
	end
end

function TEST_CM_GET_DPK(pc)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	if layerObj ~= nil then
		local monKillCount = GetExProp(layerObj, "ChallengeModeKillMonCount");
		Chat(pc, string.format("Current DPK : %d", monKillCount));
		
		local warpHandler = GetExProp(layerObj, "ChallengeModeWarpHandler");
		if warpHandler ~= 0 then
			local warpObj = GetByHandle(zoneInst, warpHandler);
			if warpObj ~= nil then
				Chat(pc, "Warp Already Opened");
			end
		end
	end
end

function TEST_CM_CREATE_TRIGGER(pc)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);

	RunScript("CREATE_CHALLENGE_MODE_TRIGGER", pc, layerObj, 0);
end

function TEST_CM_GET_KILL_COUNT(pc)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	
	local level = GetExProp(layerObj, "ChallengeModeLevel");
	if level < 1 then
		Chat(pc, "Not ChallengeMode");
		return;
	end

	local level = GetExProp(layerObj, "ChallengeModeLevel");
	
	local clsList = GetClassList("challenge_mode");
	local killCount = GetClassByNameFromList(clsList, "KillCount_Lv" .. level);
	local targetKillCount = TryGet(killCount, "Value");

	local killMonCount = GetExProp(layerObj, "ChallengeModeKillMonCount");
	Chat(pc, string.format("Mon Kill Count : %d / %d", killMonCount, targetKillCount));
end

function TEST_CM_GET_ALIVE_MON_COUNT(pc)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	
	local level = GetExProp(layerObj, "ChallengeModeLevel");
	if level < 1 then
		Chat(pc, "Not ChallengeMode");
		return;
	end

	local createMonCount = GetExProp(layerObj, "ChallengeModeCreateMonCount");
	local killMonCount = GetExProp(layerObj, "ChallengeModeKillMonCount");
		
	Chat(pc, string.format("Alive Mon Count : %d", createMonCount - killMonCount));
end

function TEST_CM_SHOW_MON_STATS(pc)
	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);
	
	local monsters = {};

	local monList, cnt = GetLayerMonList(zoneInst, layer);
	for i = 1, cnt do
		local owner = GetOwner(monList[i]);
		local isFriend = 0;
		if owner ~= nil then
			if GetObjType(owner) == OT_PC then
				isFriend = 1;
			end
		end

		if isFriend == 0 then
			if monList[i].Faction == "Monster" then
				local isExists = 0;
				for j = 1, #monsters do
					if monsters[j].ClassName == monList[i].ClassName then
						isExists = 1;
						break;
					end
				end

				if isExists == 0 then
					monsters[#monsters + 1] = monList[i];
				end
			end
		end
	end

	local level = GetExProp(layerObj, "ChallengeModeLevel");
	if level < 1 then
		for i = 1, #monsters do
			local avgPATK = (SCR_Get_MON_MINPATK(monsters[i]) + SCR_Get_MON_MAXPATK(monsters[i])) / 2;
			local avgMATK = (SCR_Get_MON_MINMATK(monsters[i]) + SCR_Get_MON_MAXMATK(monsters[i])) / 2;

			Chat(pc, string.format("%s : PATK[%d], MATK[%d], DEF[%d], MDEF[%d], MHP[%d]", monsters[i].Name, avgPATK, avgMATK, monsters[i].DEF, monsters[i].MDEF, monsters[i].MHP));
		end
	else
		for i = 1, #monsters do
			local defPATK = GetExProp(monsters[i], "CHALLENGE_MODE_DEFAULT_PATK");
			local defMATK = GetExProp(monsters[i], "CHALLENGE_MODE_DEFAULT_MATK");
			local defDEF = GetExProp(monsters[i], "CHALLENGE_MODE_DEFAULT_DEF");
			local defMDEF = GetExProp(monsters[i], "CHALLENGE_MODE_DEFAULT_MDEF");
			local defMHP = GetExProp(monsters[i], "CHALLENGE_MODE_DEFAULT_MHP");
			
			local avgPATK = (SCR_Get_MON_MINPATK(monsters[i]) + SCR_Get_MON_MAXPATK(monsters[i])) / 2;
			local avgMATK = (SCR_Get_MON_MINMATK(monsters[i]) + SCR_Get_MON_MAXMATK(monsters[i])) / 2;

			Chat(pc, string.format("%s : PATK[%d -> %d], MATK[%d -> %d], DEF[%d -> %d], MDEF[%d -> %d], MHP[%d -> %d]", monsters[i].Name, defPATK, avgPATK, defMATK, avgMATK, defDEF, monsters[i].DEF, defMDEF, monsters[i].MDEF, defMHP, monsters[i].MHP));
		end
	end
end

function TEST_CM_SET_LEVEL(pc, setLevel)
	local nLevel = tonumber(setLevel);
	if nLevel < 1 then
		return;
	end

	local zoneInst = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local layerObj = GetLayerObject(zoneInst, layer);

	local level = GetExProp(layerObj, "ChallengeModeLevel");
	if level < 1 then
		Chat(pc, "Not ChallengeMode");
		return;
	end
	
	SetChallengeModeLevel_Debug(pc, nLevel);
end

function TEST_CM_GET_LEVEL(pc)
	local level = GetChallengeModeLevel_Debug(pc);
	if level < 0 then
		Chat(pc, "Not ChallengeMode");
		return;
	end

	Chat(pc, "ChallengeMode Level : " .. tostring(level));
end