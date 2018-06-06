function LEVEL_UP(self, level)

    local stat = self.StatByLevel;
    local cls = GetClassByType("Xp", level);
    local levelstat = cls.StatPts - 1;

    if levelstat > stat then
        local tx = TxBegin(self);
        TxEnableInIntegrateIndun(tx);
        TxSetIESProp(tx, self, 'StatByLevel', levelstat);
        TxSetIESProp(tx, self, 'BeforeLv', level);
        
        local ret = TxCommit(tx);
        
        if ret == 'SUCCESS' then
            StatPointMongoLog(self, "AddLv", self.UsedStat);
            AttachEffect(self, 'F_pc_level_up', 6.0, 1, "BOT", 1);
            SendAddOnMsg(self, "NOTICE_Dm_levelup_base", ScpArgMsg("Auto_KaeLigTeo_LeBeli_SangSeungHayeossSeupNiDa"), 3);
            SetLastUseSkillName(self, "LevelUp")
            AddBuff(self, self, 'LevelUpBuff', 1, 0, 500, 1);
            RunScript('DetachLevelUpEffect', self);
        else
            sleep(1000);
            print(self .. ScpArgMsg("Auto_LeBeleop_txSilPae._DoelTtaeKkaJi_LepeoptxyoCheong"), level);
            LEVEL_UP(self, level);
        end
    end
    if level > 259 then
        local ssn = GetSessionObject(self, 'SSN_TUTO_GROUNDTOWER')
        if ssn == nil then
            CreateSessionObject(self, 'SSN_TUTO_GROUNDTOWER')
        end
    end
    if level > 329 then
        AddHelpByName(self, 'TUTO_UNIQUE_RAID')
        TUTO_PIP_CLOSE_QUEST(self)
    end
--큐폴 서버 팀레벨에 따른 TP 지급 시작
  if ( GetServerNation() == 'KOR' and ( GetServerGroupID() == 9001 or GetServerGroupID() == 9501 )) then
    local TeamLevel = GetTeamLevel(self);
    local aObj = GetAccountObj(self);
    if TeamLevel <= 75 then
        if aObj.TESTSERVER_LVUP_REWARD < 15 then
        local TPbox = { --지급 아이템, 팀레벨, 지급 개수, 프로퍼티 확인
                        {'Premium_eventTpBox_50',  5,  2,  0},
                        {'Premium_eventTpBox_50', 10,  3,  1},
                        {'Premium_eventTpBox_50', 15,  4,  2},
                        {'Premium_eventTpBox_50', 20,  5,  3},
                        {'Premium_eventTpBox_50', 25,  6,  4},
                        {'Premium_eventTpBox_50', 30,  7,  5},
                        {'Premium_eventTpBox_50', 35,  8,  6},
                        {'Premium_eventTpBox_50', 40,  9,  7},
                        {'Premium_eventTpBox_50', 45, 10,  8},
                        {'Premium_eventTpBox_50', 50, 11,  9},
                        {'Premium_eventTpBox_50', 55, 12,  10},
                        {'Premium_eventTpBox_50', 60, 13,  11},
                        {'Premium_eventTpBox_50', 65, 14,  12},
                        {'Premium_eventTpBox_50', 70, 16,  13},
                        {'Premium_eventTpBox_50', 75, 20,  14}
                      }
        for i = 1, #TPbox do
            if TeamLevel >= TPbox[i][2] and aObj.TESTSERVER_LVUP_REWARD == TPbox[i][4] then
            local tx = TxBegin(self);
            TxGiveItem(tx, TPbox[i][1], TPbox[i][3], "TESTSERVER_LVUP_REWARD");
            TxSetIESProp(tx, aObj, 'TESTSERVER_LVUP_REWARD', aObj.TESTSERVER_LVUP_REWARD + 1)
            local ret = TxCommit(tx);
            break;
          end
        end
      end
    end
  end
--큐폴 서버 팀레벨에 따른 TP 지급 종료
end

function DetachLevelUpEffect(self)
    sleep(5000);
    DetachEffect(self, 'F_pc_level_up');
end

--function Notice_Use_StatPoint(self)
--  sleep(3000);
--  SendAddOnMsg(self, "NOTICE_Dm_levelup_skill", ScpArgMsg("Auto_KiBoDeu_'U'Leul_NulLeo_SeuTaeseul_olLil_Su_issSeupNiDa"), 3);
--end

function Notice_Use_PropertyPoint(self)
    sleep(6000);
    SendAddOnMsg(self, "NOTICE_Dm_levelup_skill", ScpArgMsg("Auto_KiBoDeu_'['Leul_NulLeo_TeugSeongeul_Baeul_Su_issSeupNiDa"), 3);
end

function JOB_LEVEL_UP(self, beforeLv, level)

    PlayEffect(self, 'F_pc_joblevel_up', 6.0, 1, "BOT", 1);

    SendAddOnMsg(self, "NOTICE_Dm_levelup_skill", ScpArgMsg("Auto_KeulLeSeu_LeBeli_SangSeungHayeossSeupNiDa"), 3);

    local beforeLv = self.BeforeJobLv;
    if beforeLv == level then
        return;
    end

    local tx = TxBegin(self);
    TxEnableInIntegrateIndun(tx);
    TxSetIESProp(tx, self, 'BeforeJobLv', level);
    local ret = TxCommit(tx);
    

    local jobID = GetClass("Job", self.JobName).ClassID;
    local argList = {};
    argList[1] = jobID;
    local argIndex = 2;


    local treename = self.JobName;
    local list = GET_CLS_GROUP("SkillTree", treename);
    local treeCnt = #list;
    for i = 1 , treeCnt do 
        local cls = list[i];
        argList[#argList + 1] = 0;
    end
        
    local upCount = 0;
    for i = beforeLv + 1, level do
        local autoCls = GetClass("JobAutoStat", "J_" .. self.JobName .. "_" .. i);
        if autoCls ~= nil then
            for b = 1, #list do
                local cls = list[b];
                if cls.ClassName == autoCls.UpSkill then
                    argList[b + 1] = argList[b + 1] + 1;
                    upCount = upCount + 1;
                end
            end
        end
    end


    if upCount > 0 then
        SCR_TX_SKILL_UP(self, argList);
    end
    
    if level == 15 then
        local ssn = GetSessionObject(self, 'SSN_TUTO_CHANGE_JOB')
        if ssn == nil then
            CreateSessionObject(self, 'SSN_TUTO_CHANGE_JOB')
        end
    end

    InvalidateStates(self);
    Heal(self, self.MHP);
    AddSP(self, self.MSP);
    AddStamina(self, self.MaxSta);
end

function Notice_Use_SkillPoint(self)

    sleep(3000);
    SendAddOnMsg(self, "NOTICE_Dm_levelup_skill", ScpArgMsg("Auto_KiBoDeu_'K'Leul_NulLeo_SeuKileul_Baeul_Su_issSeupNiDa"), 3);
end

function RESTART_RESPOINT(self, level)

    local hpup = self.MHP * 0.5;
    local spup = self.MSP * 0.5;
    AddHP(self, hpup);
    AddSP(self, spup);
    ResurrectPc(self, "Restart");
    AddBuff(self, self, 'AfterEffect', 1, 0, 5000, 1);

end

-- DUMMY
function RESTART_HERE(self, level)
end

function ZONE_ENTER_PVP(pc)
    local jobObj = GetJobObject(pc);
    local sklList = StringSplit(jobObj.DefHaveSkill, '#');
    for i = 1 , #sklList do
        AddInstSkill(pc, sklList[i]);       
    end

    ADD_PREMIUM_BENEFIT(pc);
    RunEquipScpItem(pc);
    InvalidateStates(pc);
end

function ZONE_ENTER(pc)
    if pc == nil then
        return;
    end

    local teamName = GetTeamName(pc);
    if teamName == nil or string.len(teamName) < 2 then
        CustomMongoLog(pc,"BarrackMove","Type","Kick")
        TransferLogin(pc)
        return;
    end
    ---------------------------------------------

    -- Mission Item Remove
    GIVE_TAKE_ITEM_TX(pc, nil, 'MROKAS_BOMBFLOWER/-100/MROKAS_BOMBFUSE/-100/mrokas_Cannon/-100', "ZONE_ENTER")
    
    local mapName = GetZoneName(pc);
    local mapclass = GetClass('Map', mapName)
    local pcetc = GetETCObject(pc);
    local accObj = GetAccountObj(pc);
    
    -- nunnery mission rewardCount Check initCount reflash
    if mapclass.WorldMapPreOpen == 'YES' then
        local clslist, cnt = GetClassList("Indun");
        if clslist ~= nil then
            local flag = 0
            for i = 0, cnt - 1 do
                local mission1 = GetClassByIndexFromList(clslist, i);
                if TryGetProp(mission1, 'RewardPerReset') == 'YES' then
                    local indunInitCount = pcetc["InDunCountType_" .. mission1.PlayPerResetType];
                    local indunRewardCount = TryGetProp(pcetc,"InDunRewardCountType_" .. mission1.PlayPerResetType)
                    
                    if indunRewardCount ~= nil and indunInitCount > indunRewardCount then
                        flag = 1
                        break
                    end
                end
            end
            
            if flag == 1 then
                local playPropertyList = {}
                local tx = TxBegin(pc);
                TxEnableInIntegrate(tx)
                for i = 0, cnt - 1 do
                    local mission1 = GetClassByIndexFromList(clslist, i);
                    if TryGetProp(mission1, 'RewardPerReset') == 'YES' then
                        if table.find(playPropertyList, mission1.PlayPerResetType) == 0 then
                            local indunInitCount = pcetc["InDunCountType_" .. mission1.PlayPerResetType]
                            local indunRewardCount = TryGetProp(pcetc,"InDunRewardCountType_" .. mission1.PlayPerResetType)

                            if indunRewardCount ~= nil and indunInitCount ~= indunRewardCount then
                                playPropertyList[#playPropertyList + 1] = mission1.PlayPerResetType
                                TxSetIESProp(tx, pcetc, "InDunCountType_" .. mission1.PlayPerResetType, indunRewardCount)
                            end
                        end
                    end
                end
                local ret = TxCommit(tx);
                if ret == "SUCCESS" then        
                    IndunJoinCountMongoLog(pc, "NunneryMission", -1, "Reflash");
                end
            end
        end
    end
    
        
--  if accObj['HadVisited_' .. mapclass.ClassID] ~= 1  then
--      local tx = TxBegin(pc);
--      TxSetIESProp(tx, accObj, 'HadVisited_' .. mapclass.ClassID, 1);
--      TxCommit(tx);
--      isNeedUpdateWorldMap = true;
--  end
--  
--  if mapclass.PhysicalLinkZone ~= 'None' then
--      local linkZoneList = SCR_STRING_CUT(mapclass.PhysicalLinkZone)
--      
--      if mapName == 'd_cmine_6' then
--          if table.find(linkZoneList, 'd_cmine_8') > 0 then
--              table.remove(linkZoneList, table.find(linkZoneList, 'd_cmine_8'))
--          end
--      end
--      for i = 1, #linkZoneList do
--          local linkZoneIES = GetClass('Map', linkZoneList[i])
--          if linkZoneIES ~= nil and linkZoneIES.WorldMapPreOpen == 'YES' then
--              if accObj['HadVisited_' .. linkZoneIES.ClassID] ~= 1  then
--                  local tx = TxBegin(pc);
--                  TxSetIESProp(tx, accObj, 'HadVisited_' .. linkZoneIES.ClassID, 1);
--                  TxCommit(tx);
--                  isNeedUpdateWorldMap = true;
--              end
--          end
--      end
--  end

    local isNeedUpdateWorldMap
    local txFlag
    
    local zoneCount = GetClassCount('Map')
    for i = 0, zoneCount - 1 do
        local mapIES = GetClassByIndex('Map', i);
        if mapIES.WorldMapPreOpen == 'YES' then
            if accObj['HadVisited_' .. mapIES.ClassID] ~= 1  then
                txFlag = 1
                break
            end
            end
        end
    
    if txFlag == 1 then
        local tx = TxBegin(pc);
        for i = 0, zoneCount - 1 do
            local mapIES = GetClassByIndex('Map', i);
            if mapIES.WorldMapPreOpen == 'YES' then
                if accObj['HadVisited_' .. mapIES.ClassID] ~= 1  then
                    TxSetIESProp(tx, accObj, 'HadVisited_' .. mapIES.ClassID, 1);
                end
            end
        end
        TxCommit(tx);
        
        SendUpdateWorldMap(pc);
    end

    -- 평타나 패시브로 이용 가능한 스킬 등록
    local jobObj = GetJobObject(pc);
    local jobListStr = GetJobHistoryString(pc);
    local jobClsNameList = StringSplit(jobListStr, ";");
    local sklList = {};
    for jobIndex = 1, #jobClsNameList do
        local jobClsName = jobClsNameList[jobIndex]
        local jobCls = GetClass("Job", jobClsName);
        sklList = StringSplit(jobCls.DefHaveSkill, '#');
        for sklIndex = 1 , #sklList do
            AddInstSkill(pc, sklList[sklIndex]);        
        end
    end
    
    local equipSubWeapon = GetEquipItem(pc, 'LH');
    local lHandSkill = TryGetProp(equipSubWeapon, 'LHandSkill');
    if lHandSkill ~= nil and lHandSkill ~= 'None' then
        sklList[#sklList + 1] = lHandSkill;
    end

    if GetAbility(pc, 'Peltasta6') ~= nil then
        sklList[#sklList + 1] = 'Warrior_Guard';
    end

    local useTx = false;
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    
    if (sObj ~= nil and sObj.QSTARTZONETYPE == 'f_siauliai_west') or (sObj ~= nil and sObj.QSTARTZONETYPE == 'StartLine1' and GetInvItemCount(pc,'Escape_Orb') == 0 and GetZoneName(pc) == 'c_Klaipe') or (sObj ~= nil and sObj.QSTARTZONETYPE == 'StartLine2' and GetInvItemCount(pc,'Escape_Orb_orsha') == 0 and GetZoneName(pc) == 'c_orsha') then
        useTx = true;
    end
        
    -- new map alarm
    local mapType = TryGetProp(mapclass, 'MapType');
    if mapType ~= nil and (mapType == 'City' or mapType == 'Field' or mapType == 'Dungeon') then
        local visited = TryGetProp(accObj, 'HadVisited_'..mapclass.ClassID);    
        if mapclass.Journal == 'TRUE' and visited ~= nil and visited ~= 1 then
            ALARM_ADVENTURE_BOOK_NEW(pc, mapclass.Name);    
        end
    end

    ADD_PREMIUM_BENEFIT(pc)
    
    if useTx == true then
        local tx = TxBegin(pc);
        TxEnableInIntegrate(tx);

        SET_ITEM_LIFE_TIME(pc, tx)

        if DAILY_TIME_EVENT_FLAG == 1 then
            DAILY_TIME_EVENT_RESET(pc, tx);
        end

        RESET_GUILD_PVP_WEEKLY_COUNT(pc, tx);
        CHECK_START_HAIR_NAME(pc, tx);

        if sObj ~= nil and sObj.QSTARTZONETYPE == 'f_siauliai_west' then
            TxSetIESProp(tx, sObj, "QSTARTZONETYPE", 'StartLine1')
        end
    
        local ret = TxCommit(tx);
        
        if ret == 'SUCCESS' then
            
        end
    else
        
        SET_ITEM_LIFE_TIME(pc, nil)

        if DAILY_TIME_EVENT_FLAG == 1 then
            DAILY_TIME_EVENT_RESET(pc, nil);
        end
        
        RESET_GUILD_PVP_WEEKLY_COUNT(pc, nil);
        CHECK_START_HAIR_NAME(pc);
    end

    if sObj ~= nil then
    
        if sObj.QSTARTZONETYPE ~= "StartLine1" and sObj.QSTARTZONETYPE ~= "StartLine2" then
        
            local newstartzonestr = "StartLine1"

            if sObj["WARP_F_SIAULIAI_16"] == 300 then
                newstartzonestr = "StartLine2"
            end

            local tx = TxBegin(pc);
            TxSetIESProp(tx, sObj, "QSTARTZONETYPE", newstartzonestr)
            local ret = TxCommit(tx);

        end

    end

    local alchemist_Homunculus = TryGetProp(pcetc, 'alchemist_Homunculus');
    if alchemist_Homunculus ~= nil and 'None' ~= alchemist_Homunculus then
        local mon = SCR_ALCH_CRATE_HOMUNCLUS(pc);
        if nil ~= mon then
            SetHomunClusCommander(mon);
        end
    end

    if mapclass.MapRank == 2 then
        SendSysMsg(pc, "DeathPenaltyGem");
    elseif mapclass.MapRank >= 3 then
        SendSysMsg(pc, "DeathPenaltyGemSilverETC");
    end

    REARRANGE_BALLOON(pc, pcetc, mapclass);
    
    RunEquipScpItem(pc);
    InvalidateStates(pc);

    local skill = GetSkill(pc, "Sage_Portal");
    if skill ~= nil then
        RunScript("SCR_UPDATE_SAGE_SKL_CHECK", pc);
    end

    GUILD_EVENT_POPUP(pc);
    
    local iscolonywarmap = IsJoinColonyWarMap(pc)
    local colonywarstate = GetColonyWarState()
    if iscolonywarmap == 1 and colonywarstate == 2 then
    else
        local levelmsgType = {"WeaponChange","ArmorChange","IndunStart","RequestMission","RequestQuest","RequestParty","NunneryMission","UphillDeffense","ChallengeStart","Uniqueraid","CardEquip"}
        local idList = {}
        local pcLv = pc.Lv
        local pcEtc = GetETCObject(pc)
        local pcEtcSet = {}
        local viewIndex = 0
        local maxlv = 50
        if pcEtc ~= nil then
            for i = 1, #levelmsgType do
                local iesList = SCR_GET_XML_IES('levelinformmessage', 'Type', levelmsgType[i])
                if #iesList > 0 then
                    local id = 0
                    local level = 0
                    for i2 = 1, #iesList do
                        local viewProp = TryGetProp(iesList[i2], 'ViewPorp', 'None')
                        local viewCount = TryGetProp(iesList[i2], 'ViewCount', 0)
                        local iesLevel = TryGetProp(iesList[i2], 'Level', 99999)
                        local funcProp = TryGetProp(iesList[i2], 'FuncCheck', 'None')
                        local propFlag = 0
                        local funcFlag = 0
                        local nowCount
                        if viewProp == 'None' then
                            propFlag = 1
                        else
                            nowCount = TryGetProp(pcEtc, viewProp, 0)
                            if nowCount < viewCount then
                                propFlag = 1
                            end
                        end
                        if propFlag == 1 then
                            if iesLevel <= pcLv and iesLevel + maxlv > pcLv then
                                if funcProp == 'None' then
                                    funcFlag = 1
                                else
                                    funcProp = SCR_STRING_CUT(funcProp)
                                    local func = _G[funcProp[1]]
                                    if func ~= nil then
                                        local result = func(pc,funcProp)
                                        if result == 'YES' then
                                            funcFlag = 1
                                        else
                                            pcEtcSet[#pcEtcSet + 1] = {}
                                            pcEtcSet[#pcEtcSet][1] = viewProp
                                            pcEtcSet[#pcEtcSet][2] = nowCount + 1
                                        end
                                    end
                                end
                            else
                                if iesLevel + maxlv <= pcLv then
                                    pcEtcSet[#pcEtcSet + 1] = {}
                                    pcEtcSet[#pcEtcSet][1] = viewProp
                                    pcEtcSet[#pcEtcSet][2] = nowCount + 1
                                end
                            end
                        end
                        if funcFlag == 1 then
                            if viewProp ~= 'None' and nowCount < viewCount then
                                pcEtcSet[#pcEtcSet + 1] = {}
                                pcEtcSet[#pcEtcSet][1] = viewProp
                                pcEtcSet[#pcEtcSet][2] = nowCount + 1
                            end
                            if level < iesLevel then
                                id = TryGetProp(iesList[i2], 'ClassID')
                                level = iesLevel
                            end
                        end
                    end
                    
                    if id > 0 then
                        viewIndex = viewIndex + 1
                        idList[#idList + 1] = id
                    end
                end
                if viewIndex >= 3 then
                    break
                end
            end
            if #pcEtcSet > 0 then
                local tx = TxBegin(pc);
                for i = 1, #pcEtcSet do
                    TxSetIESProp(tx, pcEtc, pcEtcSet[i][1], pcEtcSet[i][2])
                end
                local ret = TxCommit(tx);
            end
            if #idList > 0 then
    --            print('HHHHH',table.concat(idList,'/'))
                local input = '"'..table.concat(idList,'/')..'"'
                
                ExecClientScp(pc, 'LEVEL_LINFORM_MESSAGE_CLIENT('..input..')')
            end
        end
    end
    
    local hiddenJobList = {{'Char1_13',{'SHINOBI_MASTER'}}
                            ,{'Char1_19',{'MATADOR_MASTER'}}
                            ,{'Char1_20',{'CHAR120_MASTER'}}
                            ,{'Char2_17',{'RUNECASTER_MASTER'}}
                            ,{'Char2_19',{'JOB_SHADOWMANCER_MASTER'}}
                            ,{'Char2_20',{'ONMYOJI_MASTER'}}
                            ,{'Char3_13',{'FEDIMIAN_APPRAISER_NPC'},{'FEDIMIAN_APPRAISER'}}
                            ,{'Char3_18',{'BULLETMARKER_MASTER'}}
                            ,{'Char4_12',{'CHAPLAIN_MASTER'}}
                            ,{'Char4_18',{'MIKO_MASTER'}}
                            ,{'Char4_19',{'ZEALOT_MASTER'}}
                            }
    for i = 1, #hiddenJobList do
        local jobName = hiddenJobList[i][1]
        local unhideList = hiddenJobList[i][2]
        local hideList = hiddenJobList[i][3]
        if SCR_HIDDEN_JOB_IS_UNLOCK(pc, jobName) == 'YES' then
            for i2 = 1, #unhideList do
                local npc = unhideList[i2]
                if isHideNPC(pc, npc) == 'YES' then
                    UnHideNPC(pc, npc)
                end
            end
            if hideList ~= nil then
                for i2 = 1, #hideList do
                    local npc = hideList[i2]
                    if isHideNPC(pc, npc) ~= 'YES' then
                        HideNPC(pc, npc)
                    end
                end
            end
        end
    end   
    
    if IsMGameSoulCristalLimit(pc) == 1 then
		SendSoulCristalLimit(pc)
	end
    PROCESS_PASSIVE_SKILL_DELETE(pc);
end

function PROCESS_PASSIVE_SKILL_DELETE(pc)    
    PROCESS_PASSIVE_SKILL_DELETE_GUILD_TOWER(pc);
end

function PROCESS_PASSIVE_SKILL_DELETE_GUILD_TOWER(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then        
        return;
    end

    local pcGuildID = GetGuildID(pc);
    local guild = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);    
    if IsPartyLeaderPc(guild, pc) == 0 then
        return;
    end

    local jobHistoryStr = GetJobHistoryString(pc);
    if string.find(jobHistoryStr, 'Char1_16') == nil then        
        return;
    end

    local guildTowerSkl = GetSkill(pc, 'Templer_BuildGuildTower');
    local currentTowerLevel = TryGetProp(guildTowerSkl, 'Level', 0);    
    ChangePartyProp(pc, PARTY_GUILD, "TowerLevel", currentTowerLevel);
end

function GUILD_EVENT_POPUP(pc) 
    local guildObj = GetGuildObj(pc);
    local guildEventState, changedTime = GetGuildEventState(guildObj)
    if guildEventState == nil or guildEventState == "None" then
        GUILD_EVENT_PROPERTY_RESET(pc, guildObj)
        return;
    end

    local isParticipant = IsGuildEventParticipant(pc)        
    local guildEventID = GetGuildEventID(guildObj)

    if guildEventState == "Recruiting" then
        SendAddOnMsg(pc, "GUILD_EVENT_RECRUITING_START", changedTime, guildEventID);
        SendGuildEventParticipants(pc)
        
        local str, mapID = GUILD_EVENT_START_MAP_ON_LOCATION(pc, guildObj)
        BroadcastAddOnMsgToParty(guildObj, "GUILD_EVENT_WAITING_LOCATION", str, mapID, 0);
         if isParticipant == 1 then
            GUILD_EVENT_IN_START_MAP_ON_WAITING(pc, guildEventID)
            SendAddOnMsg(pc, "GUILD_EVENT_RECRUITING_IN", "", 0);
        end
    elseif guildEventState == "Waiting" or guildEventState == "Started" then
        if isParticipant == 1 then
            local guildEventCls = GetClassByType("GuildEvent", guildEventID);
            local mapCls = GetClass("Map", guildEventCls.StartMap);

            GUILD_EVENT_IN_START_MAP_ON_WAITING(pc, guildEventID)
            
            local str, mapID = GUILD_EVENT_START_MAP_ON_LOCATION(pc, guildObj)
            BroadcastAddOnMsgToParty(guildObj, "GUILD_EVENT_WAITING_LOCATION", str, mapID, 0);
        end
    end

    --EVENT_1712_ACHIEVE
--    if GetAchievePoint(pc, 'EVENT_1712_ACHIEVE') < 1 then
--        local tx = TxBegin(pc);
--        TxEnableInIntegrate(tx);
--        TxAddAchievePoint(tx, 'EVENT_1712_ACHIEVE', 1)
--        local ret = TxCommit(tx);
--    end
end

function REARRANGE_BALLOON(pc, pcetc, mapclass)
    local balloon = TryGetProp(pcetc, "Balloon");
    if balloon ~= nil and balloon ~= "None" then
        pcetc["Balloon"] = "None";
            end
        end

function CHANGE_JOB_DEFSKILL(pc)
    local jobObj = GetJobObject(pc);
    local sklList = StringSplit(jobObj.DefHaveSkill, '#');
    for i = 1 , #sklList do
        AddInstSkill(pc, sklList[i]);
    end
end

function CHECK_START_HAIR_NAME(pc, tx)
    
    local etcObj = GetETCObject(pc);
    if nil == etcObj then
        return;
    end


    if etcObj["StartHairName"] ~= 'None' then
        return;
    end

    local zoneEnterUseTx = true;
    if tx == nil then
        tx = TxBegin(pc);
        zoneEnterUseTx = false;
    end

    if nil == tx then
        return;
    end

    local Rootclasslist = imcIES.GetClassList('HairType');
    local Selectclass   = Rootclasslist:GetClass(pc.Gender);
    local Selectclasslist = Selectclass:GetSubClassList();
    
    local curHeadIndex = GetHeadIndex(pc);
    local cls = Selectclasslist:GetByIndex(curHeadIndex-1);
    if cls ~= nil then
        local engName = imcIES.GetString(cls, 'EngName');
        local colorName = imcIES.GetString(cls, 'ColorE');
        TxSetIESProp(tx, etcObj, "StartHairName", engName);
        TxSetIESProp(tx, etcObj, "CurHairName", engName);
        TxSetIESProp(tx, etcObj, "CurHairColorName", colorName);
    end
        
    if zoneEnterUseTx == false then
        TxCommit(tx);
    end

    
end

function LEVELINFORM_WEAPONCHANGE(pc, argTable)
    local target = argTable[2]
    
    local rItem = GetEquipItem(pc, 'RH');
    local sItem = GetEquipItem(pc, "SHIRT")
    local bItem = GetEquipItem(pc, "BOOTS")
    local pItem = GetEquipItem(pc, "PANTS")
    local gItem = GetEquipItem(pc, "GLOVES")
    
    if rItem == nil or rItem.UseLv < target then
        if sItem == nil or sItem.UseLv < target then
            if bItem == nil or bItem.UseLv < target then
                if pItem == nil or pItem.UseLv < target then
                    if gItem == nil or gItem.UseLv < target then
                        return 'YES'
                    end
                end
            end
        end
    end
end

function LEVELINFORM_INDUNSTART(pc)
    local pcEtc = GetETCObject(pc)
    if pcEtc.InDunCountType_100 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_REQUESTMISSION(pc)
    local pcEtc = GetETCObject(pc)
    if pcEtc.InDunCountType_200 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_REQUESTQUEST(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if sObj.DROPITEM_REQUEST1 == 0 and sObj.DROPITEM_REQUEST1_R == 0 then
        return 'YES'
    end
end

function LEVELINFORM_REQUESTPARTY(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if sObj.PARTY_Q_COUNT1 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_NUNNERYMISSION(pc)
    local pcEtc = GetETCObject(pc)
    if pcEtc.InDunCountType_300 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_UPHILLDEFFENSE(pc)
    local pcEtc = GetETCObject(pc)
    if pcEtc.InDunCountType_500 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_CHALLENGESTART(pc)
    local isHasBuff = IsBuffApplied(pc, 'ChallengeMode_Completed')
    if isHasBuff ~= 'YES' then
        return 'YES'
    end
end

function LEVELINFORM_UNIQUERAID(pc)
    local pcEtc = GetETCObject(pc)
    if pcEtc.InDunCountType_10000 == 0 then
        return 'YES'
    end
end

function LEVELINFORM_CARDEQUIP(pc)
    local pcEtc = GetETCObject(pc)
    for i = 1, MAX_NORMAL_MONSTER_CARD_SLOT_COUNT + LEGEND_CARD_SLOT_COUNT do
        if pcEtc["EquipCardID_Slot"..i] ~= 0 then
            return
        end
    end
    return 'YES'
end
