
-- Session Start
function SCR_CREATE_SSN_SMARTGEN(self, sObj)
	local sObj_main = GetSessionObject(self, 'ssn_klapeda');
	
	if sObj_main ~= nil then
        sObj.ZoneID = sObj_main.PRESENT_ZONEID;
	end
	
	SCR_SMARTGEN_ZONEENTER(self, sObj, nil, nil, GetZoneName(self), nil)
	
	if IS_BASIC_FIELD_DUNGEON(self) == 'YES' then
        SetTimeSessionObject(self, sObj, 1, 3000, "SCR_SMARTGEN_TIMER_STRIGGER")
        RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SMARTGEN_TIMER_STRIGGER_MONKILL', 'NO')
        SetTimeSessionObject(self, sObj, 2, 10000, "SCR_SMARTGEN_TIMER_STRIGGER_BATTLE_TYPE")
        
--        --EVENT_1804_ROOT
--        local eventZone = SMARTGEN_EVENT_ZONE_TABLE()
--        if table.find(eventZone, GetZoneName(self)) > 0 then
--            SetTimeSessionObject(self, sObj, 3, 3000, "SCR_SMARTGEN_TIMER_STRIGGER_EVENT")
--        end
    end
	-- Time Limit
	--SetTimeSessionObject(self, sObj, 1, 500, "SCR_SMARTGEN_TIMER")
--	SetTimeSessionObject(self, sObj, 2, 500, "SCR_SCROLLLOCKGEN_TIMER")

	sObj.Value = 0;
end

-- Session Reenter
function SCR_REENTER_SSN_SMARTGEN(self, sObj)
	RegisterHookMsg(self, sObj, "ZoneEnter", "SCR_SMARTGEN_ZONEENTER", "NO");
	sObj.RootCrystalGenTime = 0
	
	sObj.SMTG_STrigger_Time = GetClassNumber('SessionObject', sObj.ClassName, 'SMTG_STrigger_Time')
	sObj.SMTG_STrigger_KillType1 = 0
    sObj.SMTG_STrigger_KillType2 = 0
    sObj.SMTG_STrigger_KillType3 = 0
	
	if IS_BASIC_FIELD_DUNGEON(self) == 'YES' then
        SetTimeSessionObject(self, sObj, 1, 3000, "SCR_SMARTGEN_TIMER_STRIGGER")
        RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SMARTGEN_TIMER_STRIGGER_MONKILL', 'NO')
        SetTimeSessionObject(self, sObj, 2, 10000, "SCR_SMARTGEN_TIMER_STRIGGER_BATTLE_TYPE")
        
--        --EVENT_1804_ROOT
--        local eventZone = SMARTGEN_EVENT_ZONE_TABLE()
--        if table.find(eventZone, GetZoneName(self)) > 0 then
--            SetTimeSessionObject(self, sObj, 3, 3000, "SCR_SMARTGEN_TIMER_STRIGGER_EVENT")
--        end
    end
	--SetTimeSessionObject(self, sObj, 1, 500, "SCR_SMARTGEN_TIMER")         
--	SetTimeSessionObject(self, sObj, 2, 500, "SCR_SCROLLLOCKGEN_TIMER") 
end

-- Session Clear
function SCR_DESTROY_SSN_SMARTGEN(self, sObj)
end


--function SCR_TIMEOUT_SSN_SMARTGEN(self, sObj)
--    SCR_SMARTGEN_TIMEOUT(self, sObj);
--end

function SCR_SMARTGEN_TIMER_STRIGGER_MONKILL(self, sObj, msg, argObj, argStr, argNum)
    local monFaction = GetCurrentFaction(argObj)
    if GetLayer(self) ~= 0 then
        return
    end
    if monFaction ~= 'Monster' and monFaction ~= 'Monster_Chaos1' and monFaction ~= 'Monster_Chaos2' and monFaction ~= 'Monster_Chaos3' and monFaction ~= 'Monster_Chaos4' then
        return
    end
    
    local sTriggerTimeBasic = GetClassNumber('SessionObject', sObj.ClassName, 'SMTG_STrigger_Time')
    if sObj.SMTG_STrigger_Time > sTriggerTimeBasic and sObj.SMTG_STrigger_Time > 0 then
        sObj.SMTG_STrigger_Time = sObj.SMTG_STrigger_Time - 0.1
        sObj.SMTG_STrigger_KillCount = sObj.SMTG_STrigger_KillCount + 1
    end
    
--    --EVENT_1804_ROOT
--    local sTriggerTimeBasic_Event = GetClassNumber('SessionObject', sObj.ClassName, 'EVENT_STrigger_Time')
--    if sObj.EVENT_STrigger_Time > sTriggerTimeBasic_Event and sObj.EVENT_STrigger_Time > 0 then
--        sObj.EVENT_STrigger_Time = sObj.EVENT_STrigger_Time - 0.1
--    end
end

function SCR_SMARTGEN_TIMER_STRIGGER_BATTLE_TYPE(self, sObj, remainTime)
    if sObj.SMTG_STrigger_KillCount > 0 then
        if sObj.SMTG_STrigger_KillCount >= 6 then
            sObj.SMTG_STrigger_KillType1 = sObj.SMTG_STrigger_KillType1 + 1
        else
            sObj.SMTG_STrigger_KillType2 = sObj.SMTG_STrigger_KillType2 + 1
        end
--        print('BBBB 10SEC CHECK',sObj.SMTG_STrigger_KillType1,sObj.SMTG_STrigger_KillType2)
        
        sObj.SMTG_STrigger_KillCount = 0
    else
        sObj.SMTG_STrigger_KillType3 = sObj.SMTG_STrigger_KillType3 + 1
    end
end

function SCR_SMARTGEN_TIMER_STRIGGER(self, sObj, remainTime)
    if GetLayer(self) ~= 0 then
        return
    end
    
    local sTriggerTimeBasic = GetClassNumber('SessionObject', sObj.ClassName, 'SMTG_STrigger_Time')
    
    if sObj.SMTG_CurrentZone ~= GetZoneName(self) then
        sObj.SMTG_STrigger_Time = sTriggerTimeBasic
        sObj.SMTG_CurrentZone = GetZoneName(self)
    end
    
    local timeMin = 700
    local timeMax = 1400
--    local timeMin = 15
--    local timeMax = 25
    
    if sTriggerTimeBasic >= sObj.SMTG_STrigger_Time then
        sObj.SMTG_STrigger_Time = IMCRandom(timeMin, timeMax)
    end
    
    --time counting
    if IsBattleState(self) == 1 then
        local flag1 = 0
        local objList, objCnt = GetWorldObjectList(self, "MON", 200)
        if objCnt > 0 then
            for i = 1, objCnt do
                local obj = objList[i]
                local sTriggerType = GetExProp(obj, 'STRIGGERTYPE')
                if sTriggerType ~= nil and (sTriggerType == 1 or sTriggerType == 2) then
                    flag1 = 1
                    break
                end
            end
        end
        
        if flag1 == 0 then
            sObj.SMTG_STrigger_Time  = sObj.SMTG_STrigger_Time - 3
        end
    end
    
    if sObj.SMTG_STrigger_Time > sTriggerTimeBasic and sObj.SMTG_STrigger_Time <= 0 then
        --create summon trigger
        local objList, objCnt = GetWorldObjectList(self, "MON", 200)
        if objCnt >= 30 or (sObj.SMTG_STrigger_KillType1 + sObj.SMTG_STrigger_KillType2)/(sObj.SMTG_STrigger_KillType1 + sObj.SMTG_STrigger_KillType2 + sObj.SMTG_STrigger_KillType3) < 0.3 then
            sObj.SMTG_STrigger_Time = math.floor(IMCRandom(timeMin, timeMax)/2)
            sObj.SMTG_STrigger_KillType1 = 0
            sObj.SMTG_STrigger_KillType2 = 0
            sObj.SMTG_STrigger_KillType3 = 0
        else
            sObj.SMTG_STrigger_Time = sTriggerTimeBasic
            
            local x,y,z = GetPos(self)
            local mon_list = SCR_GET_AROUND_MONGEN_MONLIST(self, GetZoneName(self), GetCurrentFaction(self), 100, x, y, z)
            if mon_list ~= nil and #mon_list > 0 then
                local pos_list = SCR_CELLGENPOS_LIST(self, 'Front1', 0)
                if mon_list[1][2] == 'None' or mon_list[1][2] == '' then
                    local monIES = GetClass('Monster', mon_list[1][1])
                    mon_list[1][2] = monIES.Name
                end
                local mon = CREATE_MONSTER(self, mon_list[1][1], pos_list[1][1], pos_list[1][2], pos_list[1][3], nil, mon_list[1][6], 0, nil, mon_list[1][3], mon_list[1][2], nil, nil, 1, nil, nil, mon_list[1][4], nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, mon_list[1][8])
                if mon ~= nil then
                    SetExProp(mon, 'STRIGGERTYPE', 1)
                    AddBuff(self, mon, 'SuperMonGen', 1, 0, 0, 1)
                    SetLifeTime(mon, 300)
                    EnableAIOutOfPC(mon)
                    SetDeadScript(mon, 'SMTG_STrigger_Create')
                    
                  local battleTypeValue = sObj.SMTG_STrigger_KillType1 / (sObj.SMTG_STrigger_KillType1 + sObj.SMTG_STrigger_KillType2)
--                        print('BVBBBBBBBB',battleTypeValue)
                    if battleTypeValue >= 0.1 then
                        SetExProp(mon, 'STRIGGERTBATTLETYPE', 1)
                    else
                        SetExProp(mon, 'STRIGGERTBATTLETYPE', 2)
                    end
                    
                    sObj.SMTG_STrigger_KillType1 = 0
                    sObj.SMTG_STrigger_KillType2 = 0
                    sObj.SMTG_STrigger_KillType3 = 0
                end
            end
        end
    end
end

function SMTG_STrigger_Create(self)
    if GetKiller(self) == nil then
        return
    end
    
    PlayEffect(self, 'F_smoke005_dark', 1, 1,'MID')
    PlaySound(self, 'mon_jackpot')
    
    local x,y,z = GetPos(self)
    local index
    local npc = CREATE_NPC(self, 'HiddenTrigger2', x, y, z, 0, 'Peaceful', 0, 'UnvisibleName', nil, nil, nil, 1, nil, nil, nil, nil, nil, nil, nil)
    if npc ~= nil then
        SetExProp(npc, 'STRIGGERTYPE', 2)
        SetLifeTime(npc, 60)
        EnableAIOutOfPC(npc)
        local mon_list = SCR_GET_AROUND_MONGEN_MONLIST(self, GetZoneName(self), 'Law', 300, x, y, z)
        if mon_list ~= nil and #mon_list > 0 then
            local monInfo = ''
            for i = 1, 4 do
                local rand = IMCRandom(1, #mon_list)
                if monInfo == '' then
                    monInfo = mon_list[rand][1]..':None:'..GetClassNumber('Monster', mon_list[rand][1], 'Level')
                else
                    monInfo = monInfo..'/'..mon_list[rand][1]..':None:'..GetClassNumber('Monster', mon_list[rand][1], 'Level')
                end
            end
          local battleType = GetExProp(self, 'STRIGGERTBATTLETYPE')
--    print('HHHH NPC GEN2222',battleType,monInfo)
            if battleType == 1 then
                SCR_CREATE_SSN_MON_SUMMON_FUN(npc, 15000, '8/12', monInfo, 'Random', nil, 100, 30, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil, nil, nil)
            else
                SCR_CREATE_SSN_MON_SUMMON_FUN(npc, 5000, '3/3', monInfo, 'Random', nil, 100, 30, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
            end
        end
    end
end




