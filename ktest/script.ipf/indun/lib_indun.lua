--lib_indun.lua
function TEST_RESET_CNT(pc)

	if nil == pc then
		return;
	end

	local aobj = GetAccountObj(pc);
	if nil == aobj then
		return;
	end
	print('acc cnt ' .. TryGetProp(aobj, "GuildBattleWeeklyPlayCnt"));
	print('acc reward ' .. TryGetProp(aobj, "GuildBattleWeeklyPlayReward"));
	print('acc time ' .. TryGetProp(aobj, "GuildBattleWeeklyPlayReset"));
end

function TEST_GUILD_CNT(pc)
	
	local guildObj = GetGuildObj(pc);
	if guildObj ~= nil then
		print('guild cnt ' .. TryGetProp(guildObj, 'GuildBattleWeeklyJoinCnt'));
		print('guild reward ' .. TryGetProp(guildObj, 'GuildBattleWeeklyJoinReward'));
	end
end

function RESET_GUILD_PVP_WEEKLY_COUNT(pc, tx)
	if nil == pc then
		return;
	end

	local aobj = GetAccountObj(pc);
	if nil == aobj then
		return;
	end

    if nil == TryGetProp(aobj, "GuildBattleWeeklyPlayReset") then
        return;
    end

	local curDate = GetCurdateInHourNumber();
	if curDate < aobj.GuildBattleWeeklyPlayReset then
		return;
	end
	local nextResetTime = GetNextGuildPVPWeeklyResetTime();
	-- 한번 셋팅된거면 
	if aobj.GuildBattleWeeklyPlayReset == nextResetTime then
		return;
	end 

	-- 이게모야 S
	local zoneEnterUseTx = true;
	if tx == nil then
		tx = TxBegin(pc);
		zoneEnterUseTx = false;
	end

	if nil == tx then
		return;
	end
	
	-- 주간 보상을 받지 않았을 경우 초기화 안함. 
	if aobj.GuildBattleWeeklyPlayReward ~= 0 then
		TxSetIESProp(tx, aobj, "GuildBattleWeeklyPlayCnt", 0, "GuildPVP");
		TxSetIESProp(tx, aobj, "GuildBattleWeeklyPlayReward", 0, "GuildPVP");
	end
	TxSetIESProp(tx, aobj, "GuildBattleWeeklyPlayReset", nextResetTime, "GuildPVP");
	
	if zoneEnterUseTx == true then
		return;
	end

	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		 return;
	end
	
	SendAccountProperty(pc);
end

g_isCreateIndunResetTypeList = false;
g_indunResetTypeList = {};
function CREATE_INDUN_RESET_LIST(clslist, cnt, etcObj)
    for i = 0, cnt - 1 do
        local pCls = GetClassByIndexFromList(clslist, i);
        local countType = "InDunCountType_" .. pCls.PlayPerResetType;
        local indunType = TryGetProp(etcObj, countType);
        if indunType ~= nil then
            local find = false;
            for _,value in pairs(g_indunResetTypeList) do
                if value == countType then
                    find = true;
                    break
                end
            end
            if find == false then
                g_indunResetTypeList[#g_indunResetTypeList + 1] = countType;
            end
        end 
    end
end

g_indunRewardResetTypeList = {};
function CREATE_INDUN_REWARD_RESET_LIST(clslist, cnt, etcObj)
    for i = 0, cnt - 1 do
        local pCls = GetClassByIndexFromList(clslist, i);
        local reward = pCls.RewardPerReset;
        if reward == "YES" then 
            local countType = "InDunRewardCountType_" .. pCls.PlayPerResetType;
            local indunType = TryGetProp(etcObj, countType);
            if indunType ~= nil then
                local find = false;
                for _,value in pairs(g_indunRewardResetTypeList) do
                    if value == countType then
                        find = true;
                        break
                    end
                end
                if find == false then
                    g_indunRewardResetTypeList[#g_indunRewardResetTypeList + 1] = countType;
                end
            end 
        end
    end
end


function RESET_INDUN_COUNT(pc)
	local clslist, cnt = GetClassList("Indun");
	if nil == clslist then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

    --indun.xml에 모든 리스트를 초기화 로직 돌때마다 순회하고 있어서 최초 한번만 만들어서 쓸 수 있게 변경
    if g_isCreateIndunResetTypeList ~= true then
        CREATE_INDUN_RESET_LIST(clslist, cnt, etcObj)
        CREATE_INDUN_REWARD_RESET_LIST(clslist, cnt, etcObj)
        g_isCreateIndunResetTypeList = true;
	end

    if IsRequiredIndunDailyReset(etcObj.Indun_ResetTime) == 0 then
		return;
	end 
	
    local beforeResetTime = etcObj.Indun_ResetTime

    local tx = TxBegin(pc);
	if nil == tx then
		return;
	end

    TxEnableInIntegrate(tx)

    for i = 1, #g_indunResetTypeList do
        if TryGetProp(etcObj, g_indunResetTypeList[i]) ~= nil then
            TxSetIESProp(tx, etcObj, g_indunResetTypeList[i], 0);       
        end
	end

    for i = 1, #g_indunRewardResetTypeList do
        if TryGetProp(etcObj, g_indunRewardResetTypeList[i]) ~= nil then
            TxSetIESProp(tx, etcObj, g_indunRewardResetTypeList[i], 0);     
        end
    end
	
    local nextResetTime = GetNextIndunDailyResetTime();
    TxSetIESProp(tx, etcObj, "Indun_ResetTime", nextResetTime);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
        local indunCount = 0;

        for i = 1, #g_indunResetTypeList do
            if TryGetProp(etcObj, g_indunResetTypeList[i]) ~= nil then
                indunCount = indunCount + etcObj[g_indunResetTypeList[i]]
            end 
        end

        if 0 ~= indunCount then
            if beforeResetTime ~= etcObj.Indun_ResetTime then
                for i = 1, #g_indunResetTypeList do
                if TryGetProp(etcObj, g_indunResetTypeList[i]) ~= nil then
                        if etcObj[g_indunResetTypeList[i]] ~= 0 then
                            etcObj[g_indunResetTypeList[i]] = 0;
    end
            end 
        end
        end
    end
		SendProperty(pc, etcObj);
	end
end

function MGAME_CHECK_INDUN(pc, cmd, indunName)
	if GetObjType(pc) ~= OT_PC or IsDummyPC(pc) == 1 then
		return;
	end

    local indunCls = GetClass("Indun", indunName);
    if nil == indunCls then
		return;
	end

	SendMapMode(pc, "Indun");

    local maxPlayerCount = indunCls.PlayerCnt;
	local list, cnt = GetLayerPCList(pc);
    if cnt > maxPlayerCount then
		SendSysMsg(pc, "OverIndunMaxPC");
		PcReturnToZone(pc);
		return;
	end

	local isJoined = GetPCIndunJoinFlag(pc);
	if isJoined == 1 then
		INDUN_REWARD_UI_OPEN(pc, indunCls);	
		return;
	end
	
	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	if etcObj.IndunFreeTime == 'None' then
		local count = 1;

		local tx = TxBegin(pc);
		if nil == tx then
			return;
		end
        TxEnableInIntegrate(tx);

		local isIndunMultipleValue = IsIndunMultiple(pc);
		if isIndunMultipleValue == 1 and etcObj.IndunMultipleRate > 0 then 
            if indunCls.PlayPerResetType == 200 then -- 원래 100(인던), 200(미션)만 적용인데, 100은 다른 데서 처리하기로 했다고 함
                TX_INDUN_MULTIPLE(pc, tx);
            else
                CHECK_INDUN_MULTIPLE(pc); -- 인던 보스 처치 전에 배수토큰 적용 실패한 아이면 실패시키자
			end
			
            count = etcObj.IndunMultipleRate + 1;
			end
			
        local WeeklyEnterableCountPropName = "InDunCountType_" .. indunCls.PlayPerResetType;
        local didit = GetExProp(pc, "MovedIndun");
        if didit ~= 1 and indunCls.AdmissionItemName == 'None' then
            if WeeklyEnterableCountPropName ~= 'InDunCountType_400' then
                TxAddIESProp(tx, etcObj, "IndunWeeklyEnteredCount_"..indunCls.PlayPerResetType, count);
            end
        end
        
        TxAddAchievePoint(tx, "INDUN", count);

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			if isIndunMultipleValue == 1 then
				UseIndunMultipleMongoLog(pc, etcObj.IndunMultipleRate, indunName)
			end
			SetPCIndunJoinFlag(pc); 
            SetExProp(pc, "MovedIndun", 1);
        -- 트랜잭션 실패하는 일이 있더래도, 배수권은 초기화 해주자
        else
            etcObj.IndunMultipleZoneID = 0;
            etcObj.IndunMultipleMGameName = "None"; 
            etcObj.IndunMultipleIndunType = 0;
            etcObj.IndunMultipleRate = 0;
            etcObj.IndunMultipleRate_Reserve = 0;
		end 
	else
		SetPCIndunJoinFlag(pc); 
	end	

    INDUN_REWARD_UI_OPEN(pc, indunCls);    
end

function INDUN_REWARD_UI_OPEN(pc, indunCls)
    if indunCls.PlayPerResetType ~= 100 then
        return;
    end    

    SendAddOnMsg(pc, 'OPEN_INDUN_REWARD_HUD', tostring(indunCls.ClassID));
end

function SEND_INDUN_REWARD_PERTAGE(pc, percent)
    SendAddOnMsg(pc, 'OPEN_INDUN_REWARD_HUD', 'None', percent);
end
	
function IS_ENABLE_ENTER_INDUN(pc, indunName)	
	local etcObj = GetETCObject(pc);
	if etcObj == nil then
		return 0;
	end

    local indunCls = GetClass("Indun", indunName);
    local indunMinPCRank = TryGetProp(indunCls, 'PCRank')
    local totaljobcount = GetTotalJobCount(pc)
    
    if nil == indunCls then
		return 0;
	end

	if etcObj.IndunFreeTime ~= 'None' then
		return 1;
	end
	
    if indunMinPCRank ~= nil then
        if indunMinPCRank > totaljobcount and indunMinPCRank ~= totaljobcount then
            return 0;
        end
    end

    if IS_ENABLE_ENTER_TO_INDUN_WEEKLY(pc, indunCls, false) == false then
        return 0;
    end
    
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    if admissionItemName == "None" or admissionItemName == nil then
        local tokenEnterableCntBonus = indunCls.PlayPerReset_Token;
    
        -- check daily enterable count
        local dailyEnteredCnt = etcObj["InDunCountType_" .. indunCls.PlayPerResetType];
        local dailyMaxEnterableCnt = indunCls.PlayPerReset;
        if IsPremiumState(pc, ITEM_TOKEN) == 1 then
            dailyMaxEnterableCnt = dailyMaxEnterableCnt + tokenEnterableCntBonus;
		end
        if dailyEnteredCnt >= dailyMaxEnterableCnt then	        
			return 0;
		end
    else
        local invAdmissionItemCount = GetInvItemCount(pc,admissionItemName);
        local admissionTakeItemCount = GET_ADMISSION_ITEM_TAKE_COUNT(pc, indunCls);
        if invAdmissionItemCount >= admissionTakeItemCount then
            return 1;
        else
            return 0;
        end
    end
	return 1;
end

function GET_ADMISSION_ITEM_TAKE_COUNT(pc, indunCls)
    local etc = GetETCObject(pc);
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local nowEnteredCount = math.floor(TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")), 0) * admissionPlayAddItemCount);
    local isTokenState = IsPremiumState(pc, ITEM_TOKEN)
    
    if isTokenState > 0 then
        isTokenState = TryGetProp(indunCls, "PlayPerReset_Token");
    end
    
    local admissionTakeItemCount = admissionItemCount + nowEnteredCount - isTokenState;

    return admissionTakeItemCount;
end

function INDUN_AUTO_MATCHING_SUCCESS(pc, indunName, partyID)

	REQ_MOVE_TO_INDUN(pc, indunName);

end

function GET_INDUM_AUTO_MATCH_MENU()
	
	return ScpArgMsg("INSTANCE_DUNGEON_AUTO_SEARCH_MSG_ExpBonus{Percent}", "Percent", INDUN_AUTO_FIND_EXP_BONUS);

end

function AUTOMATCH_INDUN_DIALOG(pc, dialogText, indunName, randomMission)
	INDUN_ENTER_DIALOG_AND_UI(pc, dialogText, indunName, 1, randomMission);
end

function INDUN_ENTER_DIALOG_AND_UI(pc, dlgText, indunName, enableAutoMatch, randomMission)
	if pc == nil or indunName == nil then
		return;
	end

	-- 이미 인던 신청 UI 떠있는 상태에서는 안되게!
	if GetExProp(pc, "REGISTER_INDUN_TYPE") ~= 0 then 
		return;
	end

	-- get data and default set
	local indunCls = GetClass('Indun', indunName);
	if indunCls == nil then
		return;
	end
	if enableAutoMatch == nil then
		enableAutoMatch = 1; -- default
	end
	if randomMission == nil then
		randomMission = 0; -- default
	end
	local indunType = indunCls.ClassID;
	if randomMission == 1 then
		indunType = indunCls.FindType; -- random인 경우
	end
	local isAlreadyPlaying = 0;
	if enableAutoMatch == 1 then
		isAlreadyPlaying = IsAutoMatchIndunExist(pc, indunType); -- 자동매칭 가능한 경우 재입장 여부 검사
	end

	-- show dialog
	if dlgText ~= nil then
		ShowOkDlg(pc, dlgText, 1);
	end

	-- show ui
	SetExProp(pc, "RANDOM_MISSION", indunCls.FindType);
	SetExProp(pc, "REGISTER_INDUN_TYPE", indunCls.ClassID); -- 아무데서나 다이얼로그 만들어서 인던 신청하면 안돼서 존에서 기억하게 함
	SetExProp(pc, "ENABLE_AUTOMATCH", enableAutoMatch);
	ShowIndunEnterDialog(pc, indunType, isAlreadyPlaying, enableAutoMatch);
end

function INDUN_REENTER_DIALOG(pc, indunCls, dialogText, cantReenterDialogText, randomMission)

	local indunType = indunCls.ClassID;
	if 1 == randomMission then
		indunType = indunCls.FindType;
	end

	local isAlreadyPlaying = IsAutoMatchIndunExist(pc, indunType);
	if isAlreadyPlaying == 1 then
		local select = ShowSelDlg(pc, 0, dialogText, ScpArgMsg("ReEnterAutoMatchIndun"), ScpArgMsg('INSTANCE_DUNGEON_MSG02'))
		if select == 1 then
			ReEnterAutoMatchIndun(pc, indunType);
		end
	else
		ShowOkDlg(pc, cantReenterDialogText, 1);
	end
end

function CHECK_INDUN_ADMISSION_ITEM(pc, indunName)
    local indunCls = GetClass('Indun', indunName);
    if indunCls ~= nil and indunCls.AdmissionItemName ~= 'None' then
        local itemObj, cnt = GetInvItemByName(pc, indunCls.AdmissionItemName);
        if itemObj == nil or cnt < 1 or IsFixedItem(itemObj) == 1 then
            return false;
        end
    end
    return true;
end

function REQ_MOVE_TO_INDUN(pc, indunName, joinMethod, randomMission)
    if pc == nil then
        return;
    end

    if CHECK_INDUN_ADMISSION_ITEM(pc, indunName) == false then
        return;
    end

	if nil == randomMission then
		randomMission = 0;
	end

    local indunCls = GetClass("Indun", indunName);
    if indunCls == nil then
		return;
	end

	local empoweringLv = 0;
	if joinMethod == 1 then
		local empoweringBuff = GetBuffByName(pc, "Empowering_Buff");
		if empoweringBuff ~= nil then
			empoweringLv = GetBuffArg(empoweringBuff);
		end
	end
		
    if indunCls.Level > pc.Lv + empoweringLv then
    	SendSysMsg(pc, 'NeedMorePcLevel');
		return;
	end	

    local enableEnterIndun = IS_ENABLE_ENTER_INDUN(pc, indunCls.ClassName);
    local indunType = indunCls.ClassID;
    local resetGroupID = TryGetProp(indunCls, 'PlayPerResetType');

    if randomMission > 0 then -- 랜덤이면 랜덤으로 찾을 수 있게 해야 함
        indunType = indunCls.FindType;
	end

	if joinMethod == 4 then -- 재입장
        local isPlayingDirectEnterIndun = IsPlayingDirectEnterIndun(pc, indunCls.MGame);
        if isPlayingDirectEnterIndun == 1 then
            ExecClientScp(pc, "INDUN_ALREADY_PLAYING()");
            
            local isGiveUp = ReqGiveUpPrevPlayingIndun(pc);
            if isGiveUp == 0 then
                return;
            else
				ExecClientScp(pc, "REFRESH_REENTER_UNDERSTAFF_BUTTON(0)");
                GiveUpPrevPlayingDirectEnterIndun(pc, indunCls.MGame);
            end
        end
    
		ReEnterAutoMatchIndun(pc, indunType);
		return;
	end

    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");

	if joinMethod == 2 then -- 자동 매칭 신청한 경우
        local isPlayingDirectEnterIndun = IsPlayingDirectEnterIndun(pc, indunCls.MGame);
        if isPlayingDirectEnterIndun == 1 then
            ExecClientScp(pc, "INDUN_ALREADY_PLAYING()");

            local isGiveUp = ReqGiveUpPrevPlayingIndun(pc);
            if isGiveUp == 0 then
                return;
            else
				ExecClientScp(pc, "REFRESH_REENTER_UNDERSTAFF_BUTTON(0)");
                GiveUpPrevPlayingDirectEnterIndun(pc, indunCls.MGame);
            end
        end
		
		local isAlreadyPlaying = IsAutoMatchIndunExist(pc, indunType);
		if isAlreadyPlaying == 1 then
			ExecClientScp(pc, "INDUN_ALREADY_PLAYING()");

			local isGiveUp = ReqGiveUpPrevPlayingIndun(pc);
			if isGiveUp == 0 then
				return;
			else
				ExecClientScp(pc, "REFRESH_REENTER_UNDERSTAFF_BUTTON(0)");
				GiveUpPrevPlayingAutoMatchedIndun(pc, indunType);
			end
		end
    
        if admissionItemName == "None" or admissionItemName == nil then
            if enableEnterIndun == 0 then
                local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			    ExecClientScp(pc, scp);			
				return;
			end
        else
            if enableEnterIndun == 0 then
                local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			    ExecClientScp(pc, scp);			
                return;
            end
        end
		RegisterAutoMatchingIndun(pc, pc, indunType); 
		return;
	end

	if joinMethod == 3 then -- 파티원과 자동 매칭하기
        if admissionItemName == "None" or admissionItemName == nil then
            if enableEnterIndun == 0 then
                local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			    ExecClientScp(pc, scp);			
				return;
			end
        else
            if enableEnterIndun == 0 then
                local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			    ExecClientScp(pc, scp);			
                return;
            end
        end
        local levelLimit = TryGetProp(indunCls, 'AutoMatchLevelLimit');
		local indunAmendLevelLimit = 0;
        if resetGroupID == 100 then
			indunAmendLevelLimit = 999; -- 인던인 경우에는 레벨 제한 없이 파티매칭 갈 수 있게 해주자
		end
		if levelLimit ~= nil then
            TryAutoMathchWithParty(pc, indunType, levelLimit, indunCls.Level, indunAmendLevelLimit);
		end
		return;
	end
	
    local isAlreadyPlaying = IsAutoMatchIndunExist(pc, indunType);
    if isAlreadyPlaying == 1 then
        ExecClientScp(pc, "INDUN_ALREADY_PLAYING()");

        local isGiveUp = ReqGiveUpPrevPlayingIndun(pc);
        if isGiveUp == 0 then
            return;
        else
			ExecClientScp(pc, "REFRESH_REENTER_UNDERSTAFF_BUTTON(0)");
            GiveUpPrevPlayingAutoMatchedIndun(pc, indunType);
	end
	end

    local openedMission, alreadyJoin, missionInstID, mGameType = 0, 1, 0, 0;
    
    if randomMission > 0 then
        randomMission = 1;      
    end

    openedMission, alreadyJoin, mGameType, missionInstID = OpenPartyMission(pc, pc, randomMission, indunCls.MGame, "", enableEnterIndun);
    if admissionItemName == "None" or admissionItemName == nil then
        if enableEnterIndun == 0 and openedMission == 0 then
            local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			ExecClientScp(pc, scp);			
			return;
		end
    else
        if enableEnterIndun == 0 then            
            return;
        end
    end

	if -7723 == openedMission then
		SendSysMsg(pc, "OnlyOnePcJoin");
		return;
	end

	if 0 == openedMission then
        IMC_LOG("INFO_NORMAL", "Cannot Open " .. indunCls.ClassID .." ".. GetPcAIDStr(pc) .." ".. randomMission .. " " ..mGameType);
		SendSysMsg(pc, "MissionInstanceFull");
		return;
	end

	if nil == openedMission or nil == alreadyJoin then
		local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "NotBelongsToParty");
		ExecClientScp(pc, scp);
		return;
	end

    if admissionItemName == "None" or admissionItemName == nil then 
        if enableEnterIndun == 0 and alreadyJoin == 0 then       
			local scp = string.format("INDUN_CANNOT_YET(\'%s\')", "CannotJoinIndunYet");            
			ExecClientScp(pc, scp);
			return;
		end
    else
        if enableEnterIndun == 0 then
            return;
        end
    end

    SCR_INDUN_MULTIPLE_VALUE_SET(pc, alreadyJoin, missionInstID, indunCls.MGame)
	ReqMoveToMission(pc, openedMission, mGameType);
end

--이 함수 CPP에서도 호출한다. 인자값추가등을 하려면 거기도 변경해줘야함
function SCR_INDUN_MULTIPLE_VALUE_SET(pc, alreadyJoin, missionInstID, indunMultipleMGameName, playPerResetType)
	
	if pc == nil then
		return;
	end

	if missionInstID == nil then
		missionInstID = 0
	end

    local cls = GetClassByStrProp("Indun", "MGame", indunMultipleMGameName);

    local playPerResetType = TryGetProp(cls, 'PlayPerResetType');

	if indunMultipleMGameName == nil then
		indunMultipleMGameName = "None";
	end
	
	local etcObj = GetETCObject(pc);

    --미션 또는 인던이 아니면 배수모드를 세팅할 필요가 없다.
    --이전값이 어떻게 되었든 초기화 해주자.

    if false == (playPerResetType == 100 or playPerResetType == 200) then
        etcObj.IndunMultipleZoneID = 0;
        etcObj.IndunMultipleMGameName = "None";
        etcObj.IndunMultipleIndunType = 0;
        etcObj.IndunMultipleState = 0;
        etcObj.IndunMultipleRate = 0;
        IndunMultipleRate_Reserve = 0;        
        return;
    end
    
	local reset = false;
	--인던 배수를 사용
	if etcObj.IndunMultipleState == 1 then
		if alreadyJoin == 0 then -- 최초 접속
			--내가 들어간 존 인스턴스 아이디 값
		etcObj.IndunMultipleZoneID = missionInstID;
			--내가 들어간 존 미니게임 이름
			etcObj.IndunMultipleMGameName = indunMultipleMGameName;
			--내가 배율을 셋팅한 값을 가지고 보상 로직의 배율을 셋팅해줌.
			etcObj.IndunMultipleRate = etcObj.IndunMultipleRate_Reserve;
		else -- 재접속
            if etcObj.IndunMultipleZoneID == missionInstID and etcObj.IndunMultipleMGameName == indunMultipleMGameName then                
                -- 이전에 세팅한 값 그대로 가져갈 수 있도록 함                
			else
				reset = true;
			end
		end
	else -- 인던 배수 사용 후 or 아예 사용안함
		if alreadyJoin == 0 then -- 최초 접속
			reset =true
		else -- 재접속
			if etcObj.IndunMultipleZoneID ~= missionInstID or etcObj.IndunMultipleMGameName ~= indunMultipleMGameName then
				reset =true		
			end
		end
	end

		etcObj.IndunMultipleState = 0;

	if reset == true then
		etcObj.IndunMultipleZoneID = 0;
		etcObj.IndunMultipleMGameName = "None";
		etcObj.IndunMultipleIndunType = 0;
	end
	
----인던 배수를 사용하고, 최초 접속
--if etcObj.IndunMultipleState == 1 and alreadyJoin == 0 then
--	etcObj.IndunMultipleZoneID = missionInstID;
--	etcObj.IndunMultipleMGameName = indunMultipleMGameName;
--	etcObj.IndunMultipleState = 0;
----인던 배수를 사용하지 않고, 최초 접속
--elseif etcObj.IndunMultipleState == 0 and alreadyJoin == 0 then 
--	etcObj.IndunMultipleZoneID = 0;
--	etcObj.IndunMultipleMGameName = "None";
----이전에 인던 배수를 사용했는지 안했는지 모르겠지만, 인던 배수를 변경하여, 재접속
--elseif etcObj.IndunMultipleState == 1 and alreadyJoin == 1 then
--	etcObj.IndunMultipleState = 0;
--	etcObj.IndunMultipleZoneID = 0;
--	etcObj.IndunMultipleMGameName = "None";
----인던 배수권을 사용한 상태이고, 배율을 바꾸지 않은 상태에서, 재접속
--elseif etcObj.IndunMultipleState == 0 and alreadyJoin == 1 then
--	if etcObj.IndunMultipleZoneID ~= missionInstID or etcObj.IndunMultipleMGameName ~= indunMultipleMGameName then
--		etcObj.IndunMultipleState = 0;
--		etcObj.IndunMultipleZoneID = 0;
--		etcObj.IndunMultipleMGameName = "None";	
--	end
--end
end


function SCR_BUFF_ENTER_PartyIndunExpBuff(self, buff, arg1, arg2, over)

	SetExProp(self, "IndunExpBuff", 1);

end

function SCR_BUFF_LEAVE_PartyIndunExpBuff(self, buff, arg1, arg2, over)

	SetExProp(self, "IndunExpBuff", 0);

end

function SCR_BUFF_ENTER_TeamLevel(self, buff, arg1, arg2, over)

	if arg1 <= 1 then
		return;
	end

	local teamLvCls = GetClassByType("XP_TeamLevel", arg1);
	if teamLvCls == nil then
		return;
	end

	local addValue = teamLvCls.ExpBonus * 0.01;
	local expBonus = GetExProp(self, "EXPBonusByBuff");	
	expBonus = expBonus + addValue;
	SetExProp(self, "EXPBonusByBuff", expBonus);

end

function SCR_BUFF_LEAVE_TeamLevel(self, buff, arg1, arg2, over)

	SetExProp(self, "EXPBonusByBuff", 0);

end

function GIVE_EXP_BONUS_PC(pc)

	local zone_Obj = GetLayerObject(pc);
	local pcListString = GetExProp_Str(zone_Obj, "EXP_BONUS_PC_LIST");

	local pcAID = GetPcAIDStr(pc);
	local pcList = TokenizeByChar(pcListString, "#");
	local expBonusPC = false;
	for i = 1 , #pcList do
		if pcList[i] == pcAID then	
			expBonusPC = true;
			break;
		end
	end

	if expBonusPC == true then
		if GetBuffByName(pc, "PartyIndunExpBuff") == nil then
			AddBuff(pc, pc, "PartyIndunExpBuff", 0, 0, 0, 0);
		end
	end
	

end


function SCR_INDUNMULTIPLE_GIVE_ITEM(pc, name)
	local etc = GetETCObject(pc);
	local count = etc.IndunMultipleRate;

    local itemCls = GetClass("Item", name)
    --아이템 그룹이 젬이면 다시 먹으면 안됨.
    if itemCls ~= nil then
        if itemCls.GroupName == "Gem" then
            return;
        end
    end

	if count < 1 then
		return;
	end

     if pc.MaxWeight <= pc.NowWeight then
        return;
    end

    local tx = TxBegin(pc);
	TxEnableInIntegrate(tx);
	TxGiveItem(tx, name, count, "IndunMultiple")
	local ret = TxCommit(tx);
	if ret == 'SUCCESS'  then
	end
end

function GET_INDUN_MULTIPLE_ITEM_COUNT(pc)
    if pc == nil then
        return 0;
    end

    local count = 0;
    local invItemList, slotCountList = GetInvItemList(pc);
    for i = 1, #invItemList do
        local invItem = invItemList[i];

        if IS_INDUN_MULTIPLE_ITEM(invItem.ClassName) == 1 then
            if IsFixedItem(invItem) == 0 then
                count = count + slotCountList[i];
            end
        end
    end

    return count;
end

function TX_INDUN_MULTIPLE(pc, tx)
    local etcObj = GetETCObject(pc);
    local pcInvList = GetInvItemList(pc);
    local isLockItem = false;
    local isTakeItem = false;
    if pcInvList ~= nil and #pcInvList > 0 then
        --기간제 아이템 카운트(논스택이기 때문에 하나씩 꺼내서 처리)
        local takeCnt = etcObj.IndunMultipleRate;
        local dungeonCountItemList = { };
        for i = 1 , #pcInvList do
            local invItem = pcInvList[i];
            if invItem ~= nil and invItem.ClassName == "Premium_dungeoncount_Event" and invItem.LifeTime > 0 and invItem.ItemLifeTimeOver < 1 then
                --락이면 제외 시킴.
                if IsFixedItem(invItem) ~= 1 then
                    dungeonCountItemList[#dungeonCountItemList + 1] = invItem;
                end
            end
        end
                    
        --아이템 갯수 체크(인벤토리에 있는 것과, 락이 걸려있지 않은 기간제 배수권)
        local multipleItemCount = GET_INDUN_MULTIPLE_ITEM_COUNT(pc);
        if takeCnt <= multipleItemCount then
            -- 기간제 토큰을 먼저 차감      
            if #dungeonCountItemList >= 1 then
                local _temp = nil;
                for j = 1, #dungeonCountItemList - 1 do
                    for k = j + 1, #dungeonCountItemList do
                        local firstLifeTimeDiff = GetTimeDiff(dungeonCountItemList[j].ItemLifeTime);
                        local SecondLifeTimeDiff = GetTimeDiff(dungeonCountItemList[k].ItemLifeTime);
                        if firstLifeTimeDiff < SecondLifeTimeDiff then
                            _temp = dungeonCountItemList[j];
                            dungeonCountItemList[j] = dungeonCountItemList[k];
                            dungeonCountItemList[k] = _temp;
                        end
                    end
                end

                for l = 1, #dungeonCountItemList do
                    local dungeonCountItem = dungeonCountItemList[l];
                    TxTakeItemByObject(tx, dungeonCountItem, 1, "IndunMultipleUse");
                    takeCnt = takeCnt - 1;
                    if takeCnt < 1 then
                        break;
                    end
                end
            end

            -- 기간제를 제외한 남은 개수만큼 차감: 모험일지 전용 토큰 먼저. 아 정말 이러고 싶지 않다. 이거 어떡하냐 진짜
            if takeCnt > 0 then
                local item, itemCnt  = GetInvItemByName(pc, "Adventure_dungeoncount_01");
                if item ~= nil then
                    if IsFixedItem(item) == 1 then
                        isLockItem = true;
                    end
                    local _takeCnt = math.min(itemCnt, takeCnt);
                    if isLockItem == false then
                        TxTakeItem(tx, "Adventure_dungeoncount_01", _takeCnt, "IndunMultipleUse");
                    end
                    isTakeItem = true;
                    takeCnt = takeCnt - _takeCnt;
                end
            else
                isTakeItem = true;
            end

            -- 기간제를 제외한 남은 개수만큼 차감
            if takeCnt > 0 then
                local item, itemCnt  = GetInvItemByName(pc, "Premium_dungeoncount_01");
                if item ~= nil then
                    if IsFixedItem(item) == 1 then
                        isLockItem = true;
                    end
    
                    if isLockItem == false then
                        TxTakeItem(tx, "Premium_dungeoncount_01", takeCnt, "IndunMultipleUse");
                    end
                    isTakeItem = true;
                end
            else
                isTakeItem = true;
            end
        end
    end

    --아이템 락걸려있는 상태로 넘어오면 다 리셋 시켜준다.
    if isLockItem == true or isTakeItem == false then
        etcObj.IndunMultipleZoneID = 0;
        etcObj.IndunMultipleMGameName = "None"; 
        etcObj.IndunMultipleIndunType = 0;
        etcObj.IndunMultipleRate = 0;
        etcObj.IndunMultipleRate_Reserve = 0;
    end
end

function CHECK_INDUN_MULTIPLE(pc)
    local etcObj = GetETCObject(pc);
    if etcObj == nil then
        return;
    end

    local multipleCnt = etcObj.IndunMultipleRate;
    if GET_INDUN_MULTIPLE_ITEM_COUNT(pc) < multipleCnt then
        etcObj.IndunMultipleZoneID = 0;
        etcObj.IndunMultipleMGameName = "None"; 
        etcObj.IndunMultipleIndunType = 0;
        etcObj.IndunMultipleRate = 0;
        etcObj.IndunMultipleRate_Reserve = 0;

        SendSysMsg(pc, 'MultipleErrorCannotReward');
        return;    
    end
end

-- 인던 신고 기능
function SCR_GET_BADPLAYER_REASON(msg)
	if msg == "IndunBadPlayerReport_Reason_Trolling" then
		return "Trolling";
	elseif msg == "IndunBadPlayerReport_Reason_Abusive" then
		return "Abusive";
	elseif msg == "IndunBadPlayerReport_Reason_Etc" then
		return "Etc";
	end

	return "Falsification";
end

function SCR_ADD_INDUN_BADPLAYER_REPORTER_BUFF(pc)
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

	AddBuff(pc, pc, "System_IndunBadPlayerReporter", 1, 0, buffTime);
end

function IS_ENABLE_ENTER_TO_INDUN_WEEKLY(pc, indunCls, isOnlyCheckLimitCount)
	local limitCount = indunCls.WeeklyEnterableCount;	
	if limitCount == 0 then -- 주간 입장 횟수 체크 안하는 인던들
		return true;
	end

	local resetGroupID = indunCls.PlayPerResetType;
	local etc = GetETCObject(pc);
	if IsPremiumState(pc, ITEM_TOKEN) == 1 then
		limitCount = limitCount + indunCls.PlayPerReset_Token;
	end	
	if etc['IndunWeeklyEnteredCount_'..resetGroupID] < limitCount then
		return true;
	end

	-- 여기서 추가로 재료 소진하여 추가 입장 가능한 부분 구현해주시면 됩니다
	-- 재료 소진을 제외한 순수 입장 횟수만 체크해야하는 경우, 아래에 넣어주세요
	if isOnlyCheckLimitCount == false then
		if indunCls.ClassName == "M_GTOWER_1" or indunCls.ClassName == "M_GTOWER_2" then
			return GET_AVAILABLE_GTOWER_ADMISSION_TICKET_ITEM(pc) ~= nil;
		end
	end

	return false;
end

function RESET_INDUN_WEEKLY_ENTERED_COUNT(pc)    
    local clslist, cnt = GetClassList("Indun");
	if nil == clslist then
		IMC_LOG('FATAL_ASSERT_EX', 'RESET_INDUN_WEEKLY_ENTERED_COUNT: Indun Cls is null! Plz check indun.xml');
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		IMC_LOG('FATAL_ASSERT_EX', 'RESET_INDUN_WEEKLY_ENTERED_COUNT: PCEtc Cls is null! Plz check pc_etc.xml');
		return;
	end

	local curSettedTime = etcObj.IndunWeeklyResetTime;
    if IsRequiredIndunWeeklyReset(curSettedTime) == 0 then
		return;
	end 
	
    local tx = TxBegin(pc);
	if nil == tx then
		return;
	end

    TxEnableInIntegrate(tx)

    for i = 0, cnt - 1 do
    	local cls = GetClassByIndexFromList(clslist, i);
    	if cls.WeeklyEnterableCount > 0 then
    		TxSetIESProp(tx, etcObj, 'IndunWeeklyEnteredCount_'..cls.PlayPerResetType, 0);
    	end
    end

    local nextResetTime = GetNextIndunWeeklyResetTime();
    TxSetIESProp(tx, etcObj, 'IndunWeeklyResetTime', nextResetTime);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendProperty(pc, etcObj);
		return;
	end
end

function TEST_GET_INDUN_WEEKLY_INFO(pc)
	local etc = GetETCObject(pc);
	Chat(pc, '인던 주간 입장 횟수 다음 초기화 날짜['..etc.IndunWeeklyResetTime..'], 현재 입장횟수['..etc['IndunWeeklyEnteredCount_400']..']');
end

function TEST_SET_ENTER_COUNT(pc)
	local etc = GetETCObject(pc);
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxSetIESProp(tx, etc, 'IndunWeeklyEnteredCount_400', 1);
	local ret = TxCommit(tx);
	Chat(pc, "set count: "..ret);
end