function SCR_GIMMICK_QUICKNESS_TEST1_START(pc)
    if GetLayer(pc) == 0 and ( IS_BASIC_FIELD_DUNGEON(pc) == 'YES' or GetClassString('Map', GetZoneName(pc), 'MapType') == 'City') then
        local gsObj = GetSessionObject(pc,'SSN_GIMMICK_QUICKNESS_TEST1')
        if gsObj == nil then
            local cellMax = 4
            local x,y,z = GetPos(pc)
            local zoneID = GetZoneInstID(pc)
            for i = 1, cellMax do
                for i2 = 1, cellMax do
                    if IsValidPos(zoneID, x - 30*i, y, z + 30*i2) ~= 'YES' then
                        return
                    end
                end
            end
            
            local newlayer = GetNewLayer(pc)
            local companion = GetMyCompanion(pc)
            SetLayer(pc, newlayer)
            if companion ~= nil then
                SetLayer(companion, newlayer)
            end
            
            
            SetExProp(pc,'GQT_CELL',cellMax)
            SetExProp(pc,'GQT_SUCCESSPOINT',300)
            SetExProp(pc,'GQT_READYTIME',3000)
            SetExProp(pc,'GQT_CELL_COUNT_MIN',2)
            SetExProp(pc,'GQT_CELL_COUNT_MAX',4)
            SetExProp(pc,'GQT_STEP_MAX',60)
            
            SetExProp(pc,'GQT_LIMIT_MIN',2000)
            SetExProp(pc,'GQT_TIC_MIN',3000)
            SetExProp(pc,'GQT_TIC_MAX',4000)
            SetExProp(pc,'GQT_SPEED_ACC_STEP',10)
            SetExProp(pc,'GQT_SPEED_ACC',500)
            
            SetExProp(pc,'GQT_MINUS_MIN',1)
            SetExProp(pc,'GQT_MINUS_MAX',2)
            SetExProp(pc,'GQT_MINUS_START_STEP',2)
            SetExProp(pc,'GQT_MINUS_ACC_STEP',10)
            SetExProp(pc,'GQT_MINUS_ACC',1)
            
            SetExProp(pc,'GQT_KNOCKBACK_MIN',1)
            SetExProp(pc,'GQT_KNOCKBACK_MAX',2)
            SetExProp(pc,'GQT_KNOCKBACK_START_STEP',3)
            SetExProp(pc,'GQT_KNOCKBACK_ACC_STEP',10)
            SetExProp(pc,'GQT_KNOCKBACK_ACC',1)
            
            CreateSessionObject(pc, 'SSN_GIMMICK_QUICKNESS_TEST1')
        else
            SCR_GIMMICK_QUICKNESS_TEST1_END(pc,gsObj)
        end
    end
end

function SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
    local succPoint = GetExProp(pc,'GQT_SUCCESSPOINT')
    if sObj.Goal1 >= succPoint then
        EVENT_1804_ARBOR_NPC_GIMMICK_REWARD_1(pc)
        local aobj = GetAccountObj(pc);
        local nowPoint = sObj.Goal1
        local maxPoint = aobj.EVENT_1804_ARBOR_GIMMICK1_MAXPOINT
        PlaySound(pc, 'quest_success_3')
        PlayEffect(pc, 'F_explosion015_anvil_success', 0.5, 'TOP')
        if maxPoint < nowPoint then
            RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX',pc, nil, nil, nil, nil, "QUICKNESS_TEST1", 'ACCOUNT/EVENT_1804_ARBOR_GIMMICK1_MAXPOINT/'..nowPoint)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG11","POINT",nowPoint, "MAXPOINT", maxPoint)..ScpArgMsg("MOLE_BINGO_MSG6"), 10);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG11","POINT",nowPoint, "MAXPOINT", maxPoint), 10);
        end
    end
    
    local cellMax = GetExProp(pc,'GQT_CELL')
    
    for i = 1, cellMax do
        for i2 = 1, cellMax do
            local cell = GetExArgObject(pc, 'GQT_CELL_'..i..'_'..i2)
            if cell ~= nil then
                ClearEffect(cell)
                Kill(cell)
            end
        end
    end
    
    SetExProp(pc,'GQT_CELL',nil)
    SetExProp(pc,'GQT_SUCCESSPOINT',nil)
    SetExProp(pc,'GQT_READYTIME',nil)
    SetExProp(pc,'GQT_CELL_COUNT_MIN',nil)
    SetExProp(pc,'GQT_CELL_COUNT_MAX',nil)
    SetExProp(pc,'GQT_STEP_MAX',nil)
    SetExProp(pc,'GQT_LIMIT_MIN',nil)
    SetExProp(pc,'GQT_TIC_MIN',nil)
    SetExProp(pc,'GQT_TIC_MAX',nil)
    SetExProp(pc,'GQT_SPEED_ACC_STEP',nil)
    SetExProp(pc,'GQT_SPEED_ACC',nil)
    
    SetExProp(pc,'GQT_MINUS_MIN',nil)
    SetExProp(pc,'GQT_MINUS_MAX',nil)
    SetExProp(pc,'GQT_MINUS_START_STEP',nil)
    SetExProp(pc,'GQT_MINUS_ACC_STEP',nil)
    SetExProp(pc,'GQT_MINUS_ACC',nil)
    
    SetExProp(pc,'GQT_KNOCKBACK_MIN',nil)
    SetExProp(pc,'GQT_KNOCKBACK_MAX',nil)
    SetExProp(pc,'GQT_KNOCKBACK_START_STEP',nil)
    SetExProp(pc,'GQT_KNOCKBACK_ACC_STEP',nil)
    SetExProp(pc,'GQT_KNOCKBACK_ACC',nil)
    DestroySessionObject(pc, sObj)
    
    SetTitle(pc, '')
    SetLayer(pc, 0)
    local companion = GetMyCompanion(pc)
    if companion ~= nil then
        SetLayer(companion, 0)
    end
end

function SCR_SSN_GIMMICK_QUICKNESS_TEST1_BASIC_HOOK(pc, sObj)
    local x,y,z = GetPos(pc)
    local cellMax = GetExProp(pc,'GQT_CELL')
    local zoneID = GetZoneInstID(pc)
    local maxStep = GetExProp(pc,'GQT_STEP_MAX')
    local tmax = math.floor(GetExProp(pc,'GQT_TIC_MAX')/1000)
    local readyTime = GetExProp(pc,'GQT_READYTIME')
    
    local npcLifeTime = (maxStep+1) * tmax + math.floor(readyTime/1000)
    
    for i = 1, cellMax do
        for i2 = 1, cellMax do
            if IsValidPos(zoneID, x - 30*i, y, z + 30*i2) ~= 'YES' then
                return
            end
        end
    end
    
    local cellList = {}
    for i = 1, cellMax do
        cellList[i] = {}
        for i2 = 1, cellMax do
            local npc = CREATE_NPC(pc, 'HiddenTrigger6', x - 30*i, y, z + 30*i2, 0, nil, GetLayer(pc), '', nil, nil, 1, nil, nil, 'GIMMICK_QUICKNESS_TEST1_NPC1')
            if npc ~= nil then
                AttachEffect(npc, 'F_pattern013_ground_white', 1, 'BOT')
                
                SetExArgObject(npc, 'GQT_NPC_START_PC', pc)
                SetExProp(npc,'GQT_NPC_START',1)
                
                SetLifeTime(npc, npcLifeTime)
                cellList[i][i2] = npc
                SetExArgObject(pc, 'GQT_CELL_'..i..'_'..i2, npc)
            end
        end
    end
    
    sObj.String1 = x..'/'..y..'/'..z
    
    PlaySound(pc, 'character_start')
    SetTimeSessionObject(pc, sObj, 1, readyTime, 'SSN_GIMMICK_QUICKNESS_TEST1_TIME1')
	RegisterHookMsg(pc, sObj, "ZoneEnter", "SSN_GIMMICK_QUICKNESS_TEST1_ZoneEner", "YES");
    RegisterHookMsg(pc, sObj, "SetLayer", "SSN_GIMMICK_QUICKNESS_TEST1_SetLayer", "YES");
end


function SCR_CREATE_SSN_GIMMICK_QUICKNESS_TEST1(pc, sObj)
	SCR_SSN_GIMMICK_QUICKNESS_TEST1_BASIC_HOOK(pc, sObj)
end

function SCR_REENTER_SSN_GIMMICK_QUICKNESS_TEST1(pc, sObj)
    SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
end

function SCR_DESTROY_SSN_GIMMICK_QUICKNESS_TEST1(pc, sObj)
end

function SSN_GIMMICK_QUICKNESS_TEST1_ZoneEner(pc, sObj, msg, argObj, argStr, argNum)
    SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
end

function SSN_GIMMICK_QUICKNESS_TEST1_SetLayer(pc, sObj, msg, argObj, argStr, beforeLayer)
    SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
end

function SSN_GIMMICK_QUICKNESS_TEST1_TIME1(pc, sObj, remainTime)
    local cellMax = GetExProp(pc,'GQT_CELL')
    for i = 1, cellMax do
        for i2 = 1, cellMax do
            local cell = GetExArgObject(pc, 'GQT_CELL_'..i..'_'..i2)
            if cell ~= nil then
                ClearEffect(cell)
            end
        end
    end
    local readyTime = GetExProp(pc,'GQT_READYTIME')
    SetTimeSessionObject(pc, sObj, 1, readyTime, 'None')
    SetTimeSessionObject(pc, sObj, 2, 200, 'SSN_GIMMICK_QUICKNESS_TEST1_TIME2')
    
end
function SSN_GIMMICK_QUICKNESS_TEST1_TIME2(pc, sObj, remainTime)
    local cellMax = GetExProp(pc,'GQT_CELL')
--    local succPoint = GetExProp(pc,'GQT_SUCCESSPOINT')
--    if sObj.Goal1 >= succPoint then
--        -- SUCCESS
--        PlaySound(pc, 'quest_success_3')
--        PlayEffect(pc, 'F_explosion015_anvil_success', 0.5, 'TOP')
--        SetTimeSessionObject(pc, sObj, 2, 200, 'None')
--        EVENT_1804_ARBOR_NPC_GIMMICK_REWARD_1(pc)
--        SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
--        return
--    end
    
    local maxStep = GetExProp(pc,'GQT_STEP_MAX')
    if sObj.Step3 > maxStep then
        PlaySound(pc, 'reinforce_fail')
        PlayEffect(pc, 'F_explosion015_anvil_fail', 3, 'TOP')
        SetTimeSessionObject(pc, sObj, 2, 200, 'None')
        SCR_GIMMICK_QUICKNESS_TEST1_END(pc,sObj)
        -- FAIL
        return
    end
    local basicPos = SCR_STRING_CUT(sObj.String1)
    local x,y,z = GetPos(pc)
    sObj.Step1 = sObj.Step1 + 1
    for i = 1, 10 do
        local targetCell = sObj['StrArg'..i]
        if targetCell ~= 'None' then
            targetCell = SCR_STRING_CUT(targetCell)
            if #targetCell == 2 then
                local x2 = basicPos[1]- 30 * targetCell[1]
                local z2 = basicPos[3]+ 30 * targetCell[2]
                local dist = SCR_POINT_DISTANCE(x,z,x2,z2)
                if dist <= 15 then
                    sObj.Goal1 = sObj.Goal1 + 1
                    local cell = GetExArgObject(pc, 'GQT_CELL_'..targetCell[1]..'_'..targetCell[2])
                    if cell ~= nil then
                        if cell.NumArg1 <= 4 then
                            AttachEffect(cell, 'F_pattern013_ground_white', 1, 'BOT')
                            cell.NumArg1 = cell.NumArg1 + 1
                        end
                        PlaySound(pc, 'sys_alarm_skl_status_point_count')
                        SetTitle(pc,ScpArgMsg('EVENT_1804_ARBOR_MSG12','POINT',sObj.Goal1))
--                        Chat(cell, 'Goal1 : '..sObj.Goal1,1)
                    end
                    break
                end
            end
        end
    end
    
    for i = 11, 20 do
        local targetCell = sObj['StrArg'..i]
        if targetCell ~= 'None' then
            targetCell = SCR_STRING_CUT(targetCell)
            if #targetCell == 2 then
                local x2 = basicPos[1]- 30 * targetCell[1]
                local z2 = basicPos[3]+ 30 * targetCell[2]
                local dist = SCR_POINT_DISTANCE(x,z,x2,z2)
                if dist <= 15 then
                    if sObj.Goal1 > 2 then
                        sObj.Goal1 = sObj.Goal1 - 2
                        local cell = GetExArgObject(pc, 'GQT_CELL_'..targetCell[1]..'_'..targetCell[2])
                        if cell ~= nil then
                            if cell.NumArg1 <= 4 then
                                AttachEffect(cell, 'F_pattern013_ground_green', 1, 'BOT')
                                cell.NumArg1 = cell.NumArg1 + 1
                            end
                            PlaySound(pc, 'button_click')
                            SetTitle(pc,ScpArgMsg('EVENT_1804_ARBOR_MSG12','POINT',sObj.Goal1))
--                            Chat(cell, 'Goal1 : '..sObj.Goal1,1)
                        end
                    end
                    break
                end
            end
        end
    end
    
    for i = 21, 30 do
        local targetCell = sObj['StrArg'..i]
        if targetCell ~= 'None' then
            targetCell = SCR_STRING_CUT(targetCell)
            if #targetCell == 2 then
                local x2 = basicPos[1]- 30 * targetCell[1]
                local z2 = basicPos[3]+ 30 * targetCell[2]
                local dist = SCR_POINT_DISTANCE(x,z,x2,z2)
                if dist <= 15 and basicPos[2] - 5 < y and basicPos[2] + 5 > y then
                    sObj.Goal1 = sObj.Goal1 - 1
                    local cell = GetExArgObject(pc, 'GQT_CELL_'..targetCell[1]..'_'..targetCell[2])
                    if cell ~= nil then
                        local angle = GetAngleTo(pc, cell);
                        KnockBack(pc, cell, 200, angle, 60, 1)
                        PlayEffect(cell, 'I_bomb007', 1.5)
                        PlaySound(pc, 'skl_eff_fire_4')
                    end
                    break
                end
            end
        end
    end
    
    if sObj.Step2 <= 0 then
        local lastTargetCell = {}
        for i = 1, 30 do
            local targetCell = sObj['StrArg'..i]
            if targetCell ~= 'None' then
                targetCell = SCR_STRING_CUT(targetCell)
                if #targetCell == 2 then
                    local cell = GetExArgObject(pc, 'GQT_CELL_'..targetCell[1]..'_'..targetCell[2])
                    if cell ~= nil then
                        cell.NumArg1 = 0
                        ClearEffect(cell)
                    end
                end
                if i >= 1 and i <= 10 then
                    lastTargetCell[#lastTargetCell + 1] = sObj['StrArg'..i]
                end
                sObj['StrArg'..i] = 'None'
            end
        end
        
        sObj.Step3 = sObj.Step3 + 1
        local accStep = GetExProp(pc,'GQT_SPEED_ACC_STEP')
        local accSpeed = GetExProp(pc,'GQT_SPEED_ACC')
        local tmax = GetExProp(pc,'GQT_TIC_MAX')
        local tmin = GetExProp(pc,'GQT_TIC_MIN')
        local limit = GetExProp(pc,'GQT_LIMIT_MIN')
        
        if accStep > 0 and accSpeed > 0 then
            tmax = GetExProp(pc,'GQT_TIC_MAX') - (math.floor(sObj.Step3 / accStep) * accSpeed)
            tmin = GetExProp(pc,'GQT_TIC_MIN') - (math.floor(sObj.Step3 / accStep) * accSpeed)
        end
        
        local randTic
        if tmax < tmin then
            randTic = tmin
        else
            randTic = IMCRandom(tmin,tmax)
        end
        
        if randTic < limit then
            randTic = limit
        end
        sObj.Step2 = math.floor(randTic/200) * 200
        local targetCellMin = GetExProp(pc,'GQT_CELL_COUNT_MIN')
        local targetCellMax = GetExProp(pc,'GQT_CELL_COUNT_MAX')
        local targetCellCount = IMCRandom(targetCellMin,targetCellMax)
        if targetCellCount > 10 then
            targetCellCount = 10
        end
        
        for i = 1, targetCellCount do
            local randX = IMCRandom(1,cellMax)
            local randZ = IMCRandom(1,cellMax)
            local randValue = randX..'/'..randZ
            for i3 = 1, 100 do
                if table.find(lastTargetCell, randValue) == 0 then
                    break
                else
                    randX = IMCRandom(1,cellMax)
                    randZ = IMCRandom(1,cellMax)
                    randValue = randX..'/'..randZ
                end
            end
            
            local flag = 0
            for i2 = 1, 10 do
                local targetPos = sObj['StrArg'..i2]
                if targetPos ~= 'None' then
                    if targetPos == randValue then
                        flag = 1
                        break
                    end
                end
            end
            if flag == 0 then
                sObj['StrArg'..i] = randValue
                local cell = GetExArgObject(pc, 'GQT_CELL_'..randX..'_'..randZ)
                if cell ~= nil then
                    AttachEffect(cell, 'F_pattern013_ground_white', 1, 'BOT')
                end
            end
        end
        PlaySound(pc, 'game_start')
        
        local minusCellStart = GetExProp(pc,'GQT_MINUS_START_STEP')
        if minusCellStart ~= 0 and sObj.Step3 >= minusCellStart then
            local minusAccStep = GetExProp(pc,'GQT_MINUS_ACC_STEP')
            local minusAcc = GetExProp(pc,'GQT_MINUS_ACC')
            local minusCellMin = GetExProp(pc,'GQT_MINUS_MIN')
            local minusCellMax = GetExProp(pc,'GQT_MINUS_MAX')
            if minusAccStep > 0 and minusAcc > 0 then
                minusCellMin = GetExProp(pc,'GQT_MINUS_MIN') + (math.floor(sObj.Step3 / minusAccStep) * minusAcc)
                minusCellMax = GetExProp(pc,'GQT_MINUS_MAX') + (math.floor(sObj.Step3 / minusAccStep) * minusAcc)
            end
            
            local minusCellCount = IMCRandom(minusCellMin, minusCellMax)
            if minusCellCount > 10 then
                minusCellCount = 10
            end
            
            for i = 11, minusCellCount+10 do
                local randX = IMCRandom(1,cellMax)
                local randZ = IMCRandom(1,cellMax)
                local flag = 0
                for i2 = 1, 10 do
                    local targetPos = sObj['StrArg'..i2]
                    if targetPos ~= 'None' then
                        if targetPos == randX..'/'..randZ then
                            flag = 1
                            break
                        end
                    end
                end
                if flag == 0 then
                    sObj['StrArg'..i] = randX..'/'..randZ
                    local cell = GetExArgObject(pc, 'GQT_CELL_'..randX..'_'..randZ)
                    if cell ~= nil then
                        AttachEffect(cell, 'F_pattern013_ground_green', 1, 'BOT')
                    end
                end
            end
        end
        
        local knockCellStart = GetExProp(pc,'GQT_KNOCKBACK_START_STEP')
        if knockCellStart ~= 0 and sObj.Step3 >= knockCellStart then
            local knockAccStep = GetExProp(pc,'GQT_MINUS_ACC_STEP')
            local knockAcc = GetExProp(pc,'GQT_KNOCKBACK_ACC')
            local knockCellMin = GetExProp(pc,'GQT_KNOCKBACK_MIN')
            local knockCellMax = GetExProp(pc,'GQT_KNOCKBACK_MAX')
            if knockAccStep > 0 and knockAcc > 0 then
                knockCellMin = GetExProp(pc,'GQT_KNOCKBACK_MIN') + (math.floor(sObj.Step3 / knockAccStep) * knockAcc)
                knockCellMax = GetExProp(pc,'GQT_KNOCKBACK_MAX') + (math.floor(sObj.Step3 / knockAccStep) * knockAcc)
            end
            
            local knockCellCount = IMCRandom(knockCellMin, knockCellMax)
            if knockCellCount > 10 then
                knockCellCount = 10
            end
            
            for i = 21, knockCellCount+20 do
                local randX = IMCRandom(1,cellMax)
                local randZ = IMCRandom(1,cellMax)
                local flag = 0
                for i2 = 1, 20 do
                    local targetPos = sObj['StrArg'..i2]
                    if targetPos ~= 'None' then
                        if targetPos == randX..'/'..randZ then
                            flag = 1
                            break
                        end
                    end
                end
                if flag == 0 then
                    sObj['StrArg'..i] = randX..'/'..randZ
                    local cell = GetExArgObject(pc, 'GQT_CELL_'..randX..'_'..randZ)
                    if cell ~= nil then
                        AttachEffect(cell, 'F_pattern013_ground_red', 1, 'BOT')
                    end
                end
            end
        end
    else
        sObj.Step2 = sObj.Step2 - 200
    end
end


function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_BORN_ENTER(self)
end

function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_BORN_UPDATE(self)
    local pc = GetExArgObject(self, 'GQT_NPC_START_PC')
    local startValue = GetExProp(self,'GQT_NPC_START')
    if startValue == 1 then
        if pc == nil then
            Kill(self)
        end
    end
end

function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_BORN_LEAVE(self)
end

function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_DEAD_ENTER(self)
end

function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_DEAD_UPDATE(self)
end

function SCR_GIMMICK_QUICKNESS_TEST1_NPC1_TS_DEAD_LEAVE(self)
end

