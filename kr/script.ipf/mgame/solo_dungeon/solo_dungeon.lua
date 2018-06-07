--solo_dungeon.lua

function SCR_SOLO_DUNGEON_STAGE_MONSTER_SUMMON(self)

    AddBuff(self, self, 'Mon_invincible', 1, 0, 0, 1)
    local mval = GetMGameValue(self, 'STAGE_COUNT')
    local zoneID = GetZoneInstID(self)
    local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
    SetSafeHide(self, 1)
    if cnt ~= 0 then
        for k = 1, cnt do
            AddoOnMsgToZone(list[k], 'NOTICE_Dm_scroll', mval..ScpArgMsg("SoloDungeonStageMSG"), 5)
        end
    end
    
    local cntCtrl = mval
    
    if mval < 5 then
        cntCtrl = 5
    end
    
    if mval > 20 then
        cntCtrl = 20
    end
    
    local x, y, z = GetPos(self)
    local follwerListCheck = GetExProp(self, 'FollowerListCheck')
    if follwerListCheck ~= 1 then
        for i = 1, cntCtrl do
            RunScript('SCR_SOLO_DUNGEON_DOUGHNUT_POS_SUMMON', self, x, y, z, mval)
        end
        
        if cntCtrl > 10 then
            local eliteCnt = math.floor((mval-5)/5)
            
            if eliteCnt > 10 then
                eliteCnt = 10
            end
            for j = 1, eliteCnt do
                RunScript('SCR_SOLO_DUNGEON_DOUGHNUT_POS_SUMMON', self, x, y, z, mval)
            end
        end
    end
    RunSimpleAI(self, 'SOLO_DUNGEON_SELF_KILL')
end

function SCR_SOLO_DUNGEON_DOUGHNUT_POS_SUMMON(self, x, y, z, mval)
    local time = IMCRandom(1, 1500);
    sleep(time)
    local monClsList, moncnt = GetClassList('d_solo_MonsterList');
    local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 50, 300)
    local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
    local normalList = {}
    local bossList = {} 
    
    for i = 1, moncnt do
        local cls = GetClassByIndexFromList(monClsList, i);
        if TryGetProp(cls, 'Summon_Rank') == 'Normal' then
            normalList[#normalList + 1] = cls.Summon_Monster_List
        end
        if TryGetProp(cls, 'Summon_Rank') == 'Boss' then
            bossList[#bossList + 1] = cls.Summon_Monster_List
        end
    end
    --Normal and elite Monster--
    if mval % 2 == 1 then
        local selectMon = IMCRandom(1, #normalList);
        local selectSummon = normalList[selectMon]
        local summonMonster = CREATE_MONSTER_EX(self, selectSummon, dPos['x'], y, dPos['z'], angle, 'Monster', nil);
        SCR_SOLO_DUNGEON_STAGE_MON_SPEC(summonMonster, mval)
        PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 1.5);
        DisableBornAni(summonMonster)
        SetOwner(summonMonster,self,1)
        table.remove(normalList, selectMon)
    end
    
    
    --Boss Monster--
    if mval % 2 == 0 then
        local bossSummonCheck = GetExProp(self, 'BossSummonCheck')
        if bossSummonCheck ~= 1 then
            local selectBoss = IMCRandom(1, #bossList);
            local summonBoss = bossList[selectBoss]
            local summonMonster = CREATE_MONSTER_EX(self, summonBoss, -29, 4, 4, angle, 'Monster', nil);
            SCR_SOLO_DUNGEON_STAGE_MON_SPEC(summonMonster, mval)
            PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 3.5);
            DisableBornAni(summonMonster)
            SetOwner(summonMonster,self,1)
            table.remove(bossList, selectBoss)
            SetExProp(self, 'BossSummonCheck', 1)
        end
    end
    SetExProp(self, 'FollowerListCheck', 1)
end

function SCR_SOLO_DUNGEON_SELF_KILL_SIMPLE_AI(self)
    local mval = GetMGameValue(self, 'STAGE_COUNT')
    local follwerListCheck = GetExProp(self, 'FollowerListCheck')
    local followerList, followercnt = GetFollowerList(self);
    local eliteBuffAddCheck = GetExProp(self, 'EliteBuffAddCheck')
    if followercnt ~= 0 then
        if eliteBuffAddCheck ~= 1 then
            if mval > 10 and mval % 2 ~= 0 then
                local eliteCnt = math.floor((mval-5)/5)
                if eliteCnt > 10 then
                    eliteCnt = 10
                end
                for i = 1, eliteCnt do
                    --local eliteRandom = IMCRandom(1, followercnt)
                    for j = 1, 5 do
                        if IsBuffApplied(followerList[i],'EliteMonsterBuff') == "NO" then
                            AddBuff(self, followerList[i], 'EliteMonsterBuff', 1, 0, 0, 1)
                        end
                    end
                end
                SetExProp(self, 'EliteBuffAddCheck', 1)
            end
        end
    end
    
    if follwerListCheck == 1 then
        if #followerList == 0 then
            Dead(self);
        end
    end
end

function SCR_SOLO_DUNGEON_STAGE_MON_SPEC(summonMonster, mval)
    local stageATKAddRate = 1.025
    local stageDEFAddRate = 1.015
    local stageHPAddRate = 1.1
    
    local rankAddVal = 1
    
    if summonMonster.MonRank == 'Boss' then
        rankAddVal = 3
    end
    
    local myMinPATK = math.floor(summonMonster.MINPATK*(stageATKAddRate^(mval-1))) - summonMonster.MINPATK
    local myMaxPATK = math.floor(summonMonster.MAXPATK*(stageATKAddRate^(mval-1))) - summonMonster.MAXPATK
    local averagePATK = (myMinPATK + myMaxPATK)/2
    
    local myMinMATK = math.floor(summonMonster.MINMATK*(stageATKAddRate^(mval-1))) - summonMonster.MINMATK
    local myMaxMATK = math.floor(summonMonster.MAXMATK*(stageATKAddRate^(mval-1))) - summonMonster.MAXMATK
    local averageMATK = (myMinMATK + myMaxMATK)/2
    
    local myDef = math.floor(summonMonster.DEF*(stageDEFAddRate^(mval-1))) - summonMonster.DEF
    local myMDef = math.floor(summonMonster.MDEF*(stageDEFAddRate^(mval-1))) - summonMonster.MDEF
    local myMHP = math.floor(summonMonster.MHP*(stageHPAddRate^(mval-1)))- summonMonster.MHP
    local myMSPD = math.floor((summonMonster.MSPD - summonMonster.MSPD_BM) * 1.0);
    
    if summonMonster.MonRank == 'Normal' then
        summonMonster.MSPD_BM = summonMonster.MSPD_BM + myMSPD;
    end
    
    summonMonster.PATK_BM = averagePATK * rankAddVal
    summonMonster.MATK_BM = averageMATK * rankAddVal
    summonMonster.DEF_BM = myDef * rankAddVal
    summonMonster.MDEF_BM = myMDef * rankAddVal
    summonMonster.MHP_BM = myMHP
    InvalidateStates(summonMonster)
    AddHP(summonMonster, summonMonster.MHP);
end


function SCR_STAGE_END_STOPDEBUFF_MON(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, pcCnt = GetCmdPCList(cmd:GetThisPointer());
    
    for i = 1, pcCnt do
            
        local pc = list[i]
        
        local objList, cnt = GetWorldObjectList(pc, "MON", -1)
        for i = 1, cnt do
            AddBuff(pc, objList[i], 'Monster_Stop_Debuff')
        end
    end
end

function SCR_SOLODUNGEON_PONIT_CALC(cmd, curStage, eventInst, obj)
--stage point calc--
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local mval = 0
    local pc = 0
    local stagePoint = 1000
    local myStagePoint = 0
    
    if cnt ~= nil and cnt ~= 0 then
        for i = 1, cnt do
            pc = list[i];
            mval = GetMGameValue(pc, 'STAGE_COUNT')
            myStagePoint = mval * stagePoint
        end
    end
    
--monster point calc--
    local objList, objcnt = GetWorldObjectList(pc, "MON", -1)
    local monManager = 0
    local pointCnt = mval
    local addPointCnt = 0
    if objcnt ~= 0 then
        for j = 1, objcnt do
            if IsDead(objList[j]) == 0 then
                if objList[j].ClassName == 'HiddenTrigger6_Solo_Dungeon_Trigger' then
                    monManager = objList[j]
                end
            end
        end
    end
    
    local followerList, followercnt = GetFollowerList(monManager)
    if mval < 5 then
        pointCnt = 5
    end
    
    if mval > 20 then
        pointCnt = 20
    end

    
    if mval > 10 and mval % 2 ~= 0 then
        addPointCnt = math.floor((mval-5)/5)
    
        if addPointCnt > 10 then
            addPointCnt = 10
        end
    end
    
    if mval % 2 == 0 then
        pointCnt = 1
        addPointCnt = 0
    end
    
    local totalPointCnt = pointCnt + addPointCnt
    local monPoint = 100
    local nowPointCnt = totalPointCnt - followercnt
    local myPoint = nowPointCnt * monPoint

--Date point calc--
    local standardDate = GetPrevWeeklyTime(GetDBTime(), SOLO_DUNGEON_RESET_DAY_OF_WEEK, SOLO_DUNGEON_RESET_HOUR)
    local maxPointScore = 60.48
    local beforeCalcPoint = imcTime.GetDifSec(standardDate, GetDBTime())
    local afterCalcPoint = beforeCalcPoint * 0.0001
    local finalTimePointScore = maxPointScore + afterCalcPoint
    
--final point calc--

    local finalMyPoint = myStagePoint + myPoint + finalTimePointScore

    RunScript("SCR_SOLODUNGEON_RANK_CALC", pc, finalMyPoint, mval, nowPointCnt)
    RunScript("END_SOLO_DUNGEON_PLAY_LOG", pc, mval, nowPointCnt, beforeCalcPoint, finalMyPoint)
    
end

function SCR_SOLODUNGEON_RANK_CALC(pc, finalMyPoint, mval, nowPointCnt)
    if pc == nil then
        return 
    end

    local lastScore = GetCurrentSoloDungeonInfo(pc, "All");
    local ret = RegisterSoloDungeonRanking(pc, finalMyPoint, mval, nowPointCnt, lastScore)
    
    SendSoloDungeonCurrentRanking(pc,'All')
    SendSoloDungeonCurrentRanking(pc,'Warrior')
    SendSoloDungeonCurrentRanking(pc,'Wizard')
    SendSoloDungeonCurrentRanking(pc,'Archer')
    SendSoloDungeonCurrentRanking(pc,'Cleric')
    
    if ret == 1 then
        SendSoloDungeonStageScore(pc,finalMyPoint, mval, nowPointCnt)
    end
end

function START_SOLO_DUNGEON_PLAY_LOG(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local mval = 0
    local pc = 0
    
    if cnt ~= nil and cnt ~= 0 then
        for i = 1, cnt do
            pc = list[i];
            mval = GetMGameValue(pc, 'STAGE_COUNT')
        end
    end
    
    local year, weekNumber = SoloDungeonSeason();
    local stage = mval
    
    local standardDate = GetPrevWeeklyTime(GetDBTime(), SOLO_DUNGEON_RESET_DAY_OF_WEEK, SOLO_DUNGEON_RESET_HOUR)
    local startTime = imcTime.GetDifSec(standardDate, GetDBTime())
    SetExProp(pc, 'SOLO_DUNGEON_START_TIME', startTime)
    
    SoloDungeonMongoLog(pc, year, weekNumber, "Start", stage, 0);
end

function END_SOLO_DUNGEON_PLAY_LOG(pc, mval, nowPointCnt, beforeCalcPoint, finalMyPoint)
    local year, weekNumber = SoloDungeonSeason();
    local stage = mval
    local monKillCnt = nowPointCnt
    local startTime = GetExProp(pc, 'SOLO_DUNGEON_START_TIME')
    local playTime = -(beforeCalcPoint - startTime)
    local score = finalMyPoint
    
    local rank = GetTotalJobCount(pc)
    
    local timeOut = GetExProp(pc, 'SOLO_DUNGEON_TIME_OUT')
    local reason = 0
    
    if timeOut == 1 then
        reason = "TmeOut"
    end
    
    local death = GetExProp(pc, 'SOLO_DUNGEON_DEAD')
    
    if death == 1 then
        reason = "Death"
    end
    
    local out = GetExProp(pc, 'SOLO_DUNGEON_PC_OUT')
    
    if out == 1 then
        reason = "Out"
    end
    
    SoloDungeonMongoLog(pc, year, weekNumber, "End", stage, 1, "MonKillCnt", monKillCnt, "PlayTime", playTime, "Score", score, "Rank", rank, "Reason", reason);
end

function DEAD_SOLO_DUNGEON_PLAY_LOG(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local pc = 0
    if cnt ~= nil and cnt ~= 0 then
        for i = 1, cnt do
            pc = list[i];
        end
    end
    local dead = 1
    SetExProp(pc, 'SOLO_DUNGEON_DEAD', dead)
end


function TIME_OUT_SOLO_DUNGEON_PLAY_LOG(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local pc = 0
    if cnt ~= nil and cnt ~= 0 then
        for i = 1, cnt do
            pc = list[i];
        end
    end
    local timeOut = 1
    SetExProp(pc, 'SOLO_DUNGEON_TIME_OUT', timeOut)
end

function PC_OUT_SOLO_DUNGEON_PLAY_LOG(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_NORMAL, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local pc = 0
    if cnt ~= nil and cnt ~= 0 then
        for i = 1, cnt do
            pc = list[i];
        end
    end
    local out = 1
    SetExProp(pc, 'SOLO_DUNGEON_PC_OUT', out)
end


function SEND_SOLO_DUNGEON_RANKING(pc)
    SendSoloDungeonCurrentRanking(pc, "All");
    SendSoloDungeonCurrentRanking(pc, "Warrior");
    SendSoloDungeonCurrentRanking(pc, "Wizard");
    SendSoloDungeonCurrentRanking(pc, "Archer");
    SendSoloDungeonCurrentRanking(pc, "Cleric");

    SendSoloDungeonPrevRanking(pc, "All")
    SendSoloDungeonPrevRanking(pc, "Warrior")
    SendSoloDungeonPrevRanking(pc, "Wizard")
    SendSoloDungeonPrevRanking(pc, "Archer")
    SendSoloDungeonPrevRanking(pc, "Cleric")

    SendSoloDungeonCurrentMyRanking(pc, "All")
    SendSoloDungeonCurrentMyRanking(pc, "Warrior")
    SendSoloDungeonCurrentMyRanking(pc, "Wizard")
    SendSoloDungeonCurrentMyRanking(pc, "Archer")
    SendSoloDungeonCurrentMyRanking(pc, "Cleric")

    SendSoloDungeonPrevMyRanking(pc, "All")
    SendSoloDungeonPrevMyRanking(pc, "Warrior")
    SendSoloDungeonPrevMyRanking(pc, "Wizard")
    SendSoloDungeonPrevMyRanking(pc, "Archer")
    SendSoloDungeonPrevMyRanking(pc, "Cleric")

    SendAddOnMsg(pc, "DO_SOLODUNGEON_RANKINGPAGE_OPEN")
end