function SCR_JOB_RETIARII1_CENTER_POS()
    return -1068, -41, -316
end

function SCR_JOB_RETIARII1_MONLIST()
    local monClassNameList = {'Onion','Popolion_Blue','Jukopus','ellom'}
    return monClassNameList
end

function SCR_SSN_JOB_RETIARII1_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, 'UseSkill', 'SSN_JOB_RETIARII1_UseSkill', 'NO')
    RegisterHookMsg(self, sObj, 'SetLayer', 'SSN_JOB_RETIARII1_SetLayer', 'NO')
    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_SSN_JOB_RETIARII1_TRACK_START")
end
function SCR_CREATE_SSN_JOB_RETIARII1(self, sObj)
	SCR_SSN_JOB_RETIARII1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_RETIARII1(self, sObj)
	SCR_SSN_JOB_RETIARII1_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_JOB_RETIARII1(self, sObj)
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JOB_RETIARII1_MSG4","POINT", sObj.QuestInfoValue1), 10)
end

function SCR_TIMEOUT_SSN_JOB_RETIARII1(self, sObj)
    SetTimeSessionObject(self, sObj, 2, 1000, "None")
    SetTimeSessionObject(self, sObj, 3, 3000, "None")
    SetTimeSessionObject(self, sObj, 4, 1000, "None")
    SetTitle(self, '')
    local maxRewardIndex = SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(self, sObj.QuestName)
    if maxRewardIndex ~= nil and maxRewardIndex > 0 then
    	SCR_SSN_TIMEOUT_PARTY_SUCCESS(self, sObj.QuestName, nil, nil)
    else
        RunZombieScript('ABANDON_Q_BY_NAME',self, sObj.QuestName, 'FAIL')
    end
end

function SCR_SSN_JOB_RETIARII1_TRACK_START(self, sObj)
    if IS_JOB_RETIARII1_TRACK(self) == 'YES' then
	    SetExProp(self,'JOB_RETIARII1_STATE', 1)
	    SetTimeSessionObject(self, sObj, 2, 1000, "SCR_SSN_JOB_RETIARII1_TIMER1")
	    SetTimeSessionObject(self, sObj, 3, 3000, "SCR_SSN_JOB_RETIARII1_TIMER2")
	    SetTimeSessionObject(self, sObj, 4, 1000, "SCR_SSN_JOB_RETIARII1_TIMER3")
	    
	    SetTimeSessionObject(self, sObj, 1, 1000, "None")
	    
	    local npc1 = CREATE_NPC(self, 'crystal_vakarine', -1170,-41,-195, 315, 'Peaceful', GetLayer(self), 'UnvisibleName', nil, nil, nil, 1, nil, 'JOB_RETIARII1_ENTICEMENT')
	    local npc2 = CREATE_NPC(self, 'crystal_vakarine', -1030, -41, -348, 315, 'Peaceful', GetLayer(self), 'UnvisibleName', nil, nil, nil, 1, nil, 'JOB_RETIARII1_ENTICEMENT')
--	    local npc1 = CREATE_NPC(self, 'magictrap_core', -1170,-41,-195, 315, 'Peaceful', GetLayer(self), nil, nil, nil, nil, 1, nil, 'JOB_RETIARII1_ENTICEMENT')
--	    local npc2 = CREATE_NPC(self, 'magictrap_core', -1030, -41, -348, 315, 'Peaceful', GetLayer(self), nil, nil, nil, nil, 1, nil, 'JOB_RETIARII1_ENTICEMENT')
    end
end

function SCR_SSN_JOB_RETIARII1_TIMER1(self, sObj, remainTime)
    local remainTime = math.floor(remainTime/1000)
    local lastSec = GetExProp(self,'JOB_RETIARII1_TARGET_SEC')
    local targetCount = GetExProp(self,'JOB_RETIARII1_TARGET_COUNT')
    
    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
    local questName = sObj.QuestName
    local failCount = sObj_main[questName..'_FC']
    
    local changeSec = 10
    
    
    if failCount >= 300 then
        changeSec = changeSec + 5
    elseif failCount >= 150 then
        changeSec = changeSec + 3
    elseif failCount >= 50 then
        changeSec = changeSec + 1
    end
    
    if (lastSec + changeSec < remainTime) or targetCount == nil or targetCount == 0 then
        targetCount = IMCRandom(3,5)
        SetExProp(self,'JOB_RETIARII1_TARGET_COUNT', targetCount)
        SetExProp(self,'JOB_RETIARII1_TARGET_SEC', remainTime)
    end
    SetTitle(self, ScpArgMsg("JOB_RETIARII1_MSG1","COUNT", targetCount))
end

function SCR_SSN_JOB_RETIARII1_TIMER2(self, sObj, remainTime)
    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
    local questName = sObj.QuestName
    local failCount = sObj_main[questName..'_FC']
    local cenX, cenY, cenZ = SCR_JOB_RETIARII1_CENTER_POS()
    local layer = GetLayer(self)
    
    local monRate = {100,100,100,100}
    
    local targetRate1 = failCount%4 + 1
    local targetRate2 = (targetRate1 + 2)%4 + 1
    
    if failCount >= 300 then
        monRate[targetRate1] = monRate[targetRate1] + 100
        monRate[targetRate2] = monRate[targetRate2] + 100
    elseif failCount >= 150 then
        monRate[targetRate1] = monRate[targetRate1] + 50
        monRate[targetRate2] = monRate[targetRate2] + 50
    elseif failCount >= 50 then
        monRate[targetRate1] = monRate[targetRate1] + 20
        monRate[targetRate2] = monRate[targetRate2] + 20
    end
    
    local maxRate = 0
    for index = 1, #monRate do
        maxRate = maxRate + monRate[index]
    end
    
    local monClassNameList = SCR_JOB_RETIARII1_MONLIST()
    
    for i = 1, 40 do
        SCR_JOB_RETIARII1_MON_CREATE(self, sObj, i,failCount, monRate, maxRate, cenX, cenY, cenZ, monClassNameList, layer)
    end
end
function SCR_SSN_JOB_RETIARII1_TIMER3(self, sObj, remainTime)
    if IsPlayingDirection(self) ~= 1 then
        SendSkillQuickSlot(self, 1, 'Retiarii_Quest1')
        SetTimeSessionObject(self, sObj, 4, 1000, "None")
    end
end
--function SCR_SSN_JOB_RETIARII1_TIMER3_SUB(self,
function SCR_JOB_RETIARII1_MON_CREATE(self, sObj, i, failCount, monRate, maxRate, cenX, cenY, cenZ, monClassNameList, layer)
    
    local mon = GetExArgObject(self, 'JOB_RETIARII1_MON'..i)
    if mon == nil then
        local montyperand = IMCRandom(1,maxRate)
        local addRate = 0
        local montype = 0
        for index = 1, #monRate do
            addRate = addRate + monRate[index]
            if montyperand <= addRate then
                montype = index
                break
            end
        end
        
        local createMon = CREATE_MONSTER(self, monClassNameList[montype], cenX, cenY, cenZ, 315, 'Peaceful', layer, 1, 'JOB_RETIARII1_MON', nil, nil, nil, 130, nil, nil, 'Dummy', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'None', nil)
        if createMon ~= nil then
            SetExArgObject(self, 'JOB_RETIARII1_MON'..i, createMon)
            SetExArgObject(createMon, 'JOB_RETIARII1_PC', self)
            local randSec = IMCRandom(5,9)
            if failCount >= 300 then
                randSec = randSec + 4
            elseif failCount >= 150 then
                randSec = randSec + 2
            elseif failCount >= 50 then
                randSec = randSec + 1
            end
            
            SetExProp(createMon,'JOB_RETIARII1_RANDTIME_MOVE', randSec)
        end
    end
end

function SSN_JOB_RETIARII1_UseSkill(self, sObj, msg, sklObj)
    if sklObj.ClassName ~= 'Retiarii_Quest1' then
        return
    end
    local skillX, skillY, skillZ = GetSkillTargetPos(self)
    local zoneID = GetZoneInstID(self)
    local objList, objCnt = GetWorldObjectListByPos(zoneID, GetLayer(self), skillX, skillY, skillZ, 'MON', 35)
    local monClassNameList = SCR_JOB_RETIARII1_MONLIST()
    local targetCount = 0
    local targetList = {}
    local sameClassName
    local isSameClassName
    local basicCount = GetExProp(self,'JOB_RETIARII1_TARGET_COUNT')
    
    if objCnt > 0 then
        for i = 1, objCnt do
            if table.find(monClassNameList, objList[i].ClassName) > 0 then
                targetList[#targetList + 1] = objList[i]
                targetCount = targetCount + 1
                if isSameClassName == nil then
                    if sameClassName == nil then
                        sameClassName = objList[i].ClassName
                    elseif sameClassName ~= objList[i].ClassName then
                        isSameClassName = 0
                    end
                end
            end
        end
        if isSameClassName == nil then
            isSameClassName = 1
        end
    end
    
    if targetCount > 0 then
        local basicValue = 0
        local addValue = 0
        if targetCount == basicCount then
            basicValue = 10
            if isSameClassName == 1 then
                addValue = 5
            end
        elseif targetCount >= basicCount - 1 and targetCount <= basicCount + 1 then
            basicValue = 5
            if isSameClassName == 1 then
                addValue = 3
            end
        elseif targetCount >= basicCount - 2 and targetCount <= basicCount + 2 then
            basicValue = 1
            if isSameClassName == 1 then
                addValue = 1
            end
        end
        
        if basicValue > 0 then
            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + basicValue + addValue
            if SCR_JOB_RETIARII1_STEPREWARD_CHECK3(self) == 'YES' and sObj.Step13 == 0 then
                CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
                sObj.Step13 = 1
            elseif SCR_JOB_RETIARII1_STEPREWARD_CHECK2(self) == 'YES' and sObj.Step12 == 0 then
                CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
                sObj.Step12 = 1
            elseif SCR_JOB_RETIARII1_STEPREWARD_CHECK1(self) == 'YES' and sObj.Step11 == 0 then
                CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
                sObj.Step11 = 1
            end
            SaveSessionObject(self, sObj)
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JOB_RETIARII1_MSG2","COUNT1", basicCount, "COUNT2", targetCount,"VALUE", basicValue + addValue), 5);
            
            for i = 1, #targetList do
                StopMove(targetList[i])
                AddBuff(self, targetList[i], 'Hold', 1, 0, 2000, 1)
                SetLifeTime(targetList[i], 1.2)
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("JOB_RETIARII1_MSG3","COUNT1", basicCount, "COUNT2", targetCount), 5);
        end
    end
end

function SSN_JOB_RETIARII1_SetLayer(self, sObj, msg, argObj, argStr, argNum)
--    print('JJJJJJJJJJJJ',argNum)
--    local obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
--    print('AAAAAAAAAAA',obj)
--    if obj ~= nil then
--        print('BBBBBBBBBBBB')
--    	if obj.EventName == sObj.QuestName then
--    	    SendSkillQuickSlot(self, 1, 'Retiarii_Quest1');
--    	    return
--    	end
--    end
    if GetLayer(self) == 0 then
        SendSkillQuickSlot(self, 0, 'Retiarii_Quest1');
        SetExProp(self,'JOB_RETIARII1_TARGET_COUNT', nil)
        SetExProp(self,'JOB_RETIARII1_TARGET_SEC', nil)
        SetExProp(self,'JOB_RETIARII1_STATE', nil)
        SetExProp(self,'JOB_RETIARII1_MOVE_SEC', nil)
        SetTitle(self, '')
    end
end


function IS_JOB_RETIARII1_TRACK(self)
    local layer = GetLayer(self)
    if layer > 0 then
        local obj = GetLayerObject(GetZoneInstID(self), layer);
        if obj ~= nil then
        	if obj.EventName == 'JOB_RETIARII1' then
        	    return 'YES'
        	end
        end
    end
    return 'NO'
end


function SCR_JOB_RETIARII1_MON_TS_BORN_ENTER(self)
end

function SCR_JOB_RETIARII1_MON_TS_BORN_UPDATE(self)
    local pc = GetExArgObject(self, 'JOB_RETIARII1_PC')
    if pc == nil then
        Dead(self)
    end
    
    local moveSec = GetExProp(self,'JOB_RETIARII1_MOVE_SEC')
    local cenX, cenY, cenZ = SCR_JOB_RETIARII1_CENTER_POS()
    local posX, posY, posZ = GetPos(self)
    local moveFlag = 0
    local nowSec = math.floor(os.clock())
    
    local randSec = GetExProp(self,'JOB_RETIARII1_RANDTIME_MOVE')
    if moveSec + randSec < nowSec then
        moveFlag = 1
    end
    
    if moveFlag == 0 and SCR_POINT_DISTANCE(cenX, cenZ, posX, posZ) >= 200 then
        moveFlag = 1
    end
    
    if moveFlag == 1 then
        local zoneID = GetZoneInstID(self)
        SetExProp(self,'JOB_RETIARII1_MOVE_SEC', nowSec)
        local moveX, moveY, moveZ
        for i = 1, 100 do
            local addX = IMCRandom(-80,80)
            local addZ = IMCRandom(-80,80)
            if IsValidPos(zoneID, posX + addX, posY, posZ + addZ) == 'YES' and FindPath(zoneID, 5 , posX, posY, posZ, posX + addX, posY, posZ + addZ) == 'YES' then
                moveX = posX + addX
                moveY = posY
                moveZ = posZ + addZ
                break
            end
        end
        if moveX == nil then
            for i = 1, 100 do
                local addX = IMCRandom(-80,80)
                local addZ = IMCRandom(-80,80)
                if IsValidPos(zoneID, cenX + addX, cenY, cenZ + addZ) == 'YES' and FindPath(zoneID, 5 , cenX, cenY, cenZ, cenX + addX, cenY, cenZ + addZ) == 'YES' then
                    moveX = cenX + addX
                    moveY = cenY
                    moveZ = cenZ + addZ
                    break
                end
            end
        end
        if moveX ~= nil then
            StopMove(self)
            MoveEx(self, moveX, moveY, moveZ, 5)
        end
    end
end

function SCR_JOB_RETIARII1_MON_TS_BORN_LEAVE(self)
end

function SCR_JOB_RETIARII1_MON_TS_DEAD_ENTER(self)
end

function SCR_JOB_RETIARII1_MON_TS_DEAD_UPDATE(self)
end

function SCR_JOB_RETIARII1_MON_TS_DEAD_LEAVE(self)
end



function SCR_JOB_RETIARII1_ENTICEMENT_TS_BORN_ENTER(self)
end

function SCR_JOB_RETIARII1_ENTICEMENT_TS_BORN_UPDATE(self)
    local moveSec = GetExProp(self,'JOB_RETIARII1_MOVE_SEC')
    local cenX, cenY, cenZ = SCR_JOB_RETIARII1_CENTER_POS()
    local posX, posY, posZ = GetPos(self)
    local moveFlag = 0
    local nowSec = math.floor(os.clock())
    local monClassNameList = SCR_JOB_RETIARII1_MONLIST()
    
    if moveSec + 20 < nowSec then
        PlayEffect(self, 'I_circle009_mint_mash', 5, 'MID')
        PlayEffect(self, 'I_light018_blue', 3, 'TOP')
        
        SetExProp(self,'JOB_RETIARII1_MOVE_SEC', nowSec)
        local objList, objCnt = GetWorldObjectList(self, "MON", 100)
        if objCnt > 0 then
            for i = 1, objCnt do
                if table.find(monClassNameList, objList[i].ClassName) > 0 then
                    StopMove(objList[i])
                    MoveToTarget(objList[i], self, 50)
                end
            end
        end
    end
    
end

function SCR_JOB_RETIARII1_ENTICEMENT_TS_BORN_LEAVE(self)
end

function SCR_JOB_RETIARII1_ENTICEMENT_TS_DEAD_ENTER(self)
end

function SCR_JOB_RETIARII1_ENTICEMENT_TS_DEAD_UPDATE(self)
end

function SCR_JOB_RETIARII1_ENTICEMENT_TS_DEAD_LEAVE(self)
end