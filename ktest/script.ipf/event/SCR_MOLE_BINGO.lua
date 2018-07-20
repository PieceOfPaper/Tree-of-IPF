function SCR_MOLE_BINGO_START(pc)
    if GetLayer(pc) == 0 and ( IS_BASIC_FIELD_DUNGEON(pc) == 'YES' or GetClassString('Map', GetZoneName(pc), 'MapType') == 'City') then
        local gsObj = GetSessionObject(pc,'SSN_MOLE_BINGO')
        if gsObj == nil then
            local cellMax = 5
            local x,y,z = GetPos(pc)
            local zoneID = GetZoneInstID(pc)
            for i = 1, cellMax do
                for i2 = 1, cellMax do
                    if IsValidPos(zoneID, x - 24*i, y+50, z + 24*i2) ~= 'YES' then
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
            
            SetExProp(pc,'MBG_CELL',cellMax)
            SetExProp(pc,'MBG_TIC_TIME',7000)
            SetExProp(pc,'MBG_TIC_TIME_ADD',-500)
            SetExProp(pc,'MBG_TIC_TIME_MIN',3000)
            SetExProp(pc,'MBG_TIC_NEXT_TIME',0)
            SetExProp(pc,'MBG_TIC_MON_COUNT_MIN',5)
            SetExProp(pc,'MBG_TIC_MON_COUNT_MAX',7)
            SetExProp(pc,'MBG_SUCC_POINT',30)
            SetExProp(pc,'MBG_NOW_POINT',0)
            SetExProp(pc,'MBG_L1_POINT',10)
            SetExProp(pc,'MBG_L1_POINT_ADD',6)
            SetExProp(pc,'MBG_REWARD_ITEM_FLAG',0)
            SetExProp(pc,'MBG_PLAY_TIME_MAX', 180000)
            SetExProp(pc,'MBG_CENTER_X', x)
            SetExProp(pc,'MBG_CENTER_Y', y+50)
            SetExProp(pc,'MBG_CENTER_Z', z)
            SetExProp(pc,'MBG_START_TIME', 0)
            
            
            CreateSessionObject(pc, 'SSN_MOLE_BINGO')
        else
            SCR_MOLE_BINGO_END(pc,gsObj)
        end
    end
end

function SCR_MOLE_BINGO_END(pc,sObj)
    local succPoint = GetExProp(pc,'MBG_SUCC_POINT')
    local nowPoint = GetExProp(pc,'MBG_NOW_POINT')
    if nowPoint >= succPoint then
        EVENT_1804_ARBOR_NPC_GIMMICK_REWARD_2(pc)
    end
    
    local cellMax = GetExProp(pc,'MBG_CELL')
    for i = 1, cellMax do
        for i2 = 1, cellMax do
            local obj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..i2)
            if obj ~= nil then
                SetExArgObject(pc, 'MBG_MON_'..i..'_'..i2, nil)
                ClearEffect(obj)
                Kill(obj)
            end
        end
    end
    
    SetExProp(pc,'MBG_CELL',nil)
    SetExProp(pc,'MBG_TIC_TIME',nil)
    SetExProp(pc,'MBG_TIC_TIME_ADD', nil)
    SetExProp(pc,'MBG_TIC_TIME_MIN',nil)
    SetExProp(pc,'MBG_TIC_NEXT_TIME',nil)
    SetExProp(pc,'MBG_TIC_MON_COUNT_MIN',nil)
    SetExProp(pc,'MBG_TIC_MON_COUNT_MAX',nil)
    SetExProp(pc,'MBG_SUCC_POINT',nil)
    SetExProp(pc,'MBG_NOW_POINT',nil)
    SetExProp(pc,'MBG_L1_POINT',nil)
    SetExProp(pc,'MBG_L1_POINT_ADD',nil)
    SetExProp(pc,'MBG_REWARD_ITEM_FLAG',nil)
    SetExProp(pc,'MBG_PLAY_TIME_MAX', nil)
    SetExProp(pc,'MBG_CENTER_X', nil)
    SetExProp(pc,'MBG_CENTER_Y', nil)
    SetExProp(pc,'MBG_CENTER_Z', nil)
    SetExProp(pc,'MBG_START_TIME', nil)
    
    DestroySessionObject(pc, sObj)
    
    SetTitle(pc, '')
    SetLayer(pc, 0)
    local companion = GetMyCompanion(pc)
    if companion ~= nil then
        SetLayer(companion, 0)
    end
end

function SCR_SSN_MOLE_BINGO_BASIC_HOOK(pc, sObj)
    PlaySound(pc, 'character_start')
    local succPoint = GetExProp(pc,'MBG_SUCC_POINT')
    local playTimeMax = GetExProp(pc,'MBG_PLAY_TIME_MAX')
    SendAddOnMsg(pc, "NOTICE_Dm_stage_start", ScpArgMsg("MOLE_BINGO_MSG1","SEC", playTimeMax/1000,"POINT",succPoint), 10);
    SetTimeSessionObject(pc, sObj, 1, 5000, 'SSN_MOLE_BINGO_TIME1')
	RegisterHookMsg(pc, sObj, "ZoneEnter", "SSN_MOLE_BINGO_ZoneEner", "YES");
    RegisterHookMsg(pc, sObj, "SetLayer", "SSN_MOLE_BINGO_SetLayer", "YES");
end


function SCR_CREATE_SSN_MOLE_BINGO(pc, sObj)
	SCR_SSN_MOLE_BINGO_BASIC_HOOK(pc, sObj)
end

function SCR_REENTER_SSN_MOLE_BINGO(pc, sObj)
    SCR_MOLE_BINGO_END(pc,sObj)
end

function SCR_DESTROY_SSN_MOLE_BINGO(pc, sObj)
end

function SSN_MOLE_BINGO_ZoneEner(pc, sObj, msg, argObj, argStr, argNum)
    SCR_MOLE_BINGO_END(pc,sObj)
end

function SSN_MOLE_BINGO_SetLayer(pc, sObj, msg, argObj, argStr, beforeLayer)
    SCR_MOLE_BINGO_END(pc,sObj)
end

function SSN_MOLE_BINGO_TIME1(pc, sObj, remainTime)
    SetTimeSessionObject(pc, sObj, 1, 5000, 'None')
    SetTimeSessionObject(pc, sObj, 2, 100, 'SSN_MOLE_BINGO_TIME2')
	RegisterHookMsg(pc, sObj, "AttackMonster", "SSN_MOLE_BINGO_AttackMonster", "YES");
	RegisterHookMsg(pc, sObj, "AttackMonster_PARTY", "SSN_MOLE_BINGO_AttackMonster_PARTY", "YES");
	
    local nowTime = math.floor(os.clock()*10)
    SetExProp(pc,'MBG_START_TIME', nowTime)
    SetExProp(pc,'MBG_TIC_NEXT_TIME', nowTime)
end

function SSN_MOLE_BINGO_TIME2(pc, sObj, remainTime)
    local nowTime = math.floor(os.clock()*10)
    local startTime = GetExProp(pc,'MBG_START_TIME')
    local succPoint = GetExProp(pc,'MBG_SUCC_POINT')
    local nowPoint = GetExProp(pc,'MBG_NOW_POINT')
    local playTimeMax = GetExProp(pc,'MBG_PLAY_TIME_MAX')
--    if nowPoint >= succPoint then
--        local rewardFlag = GetExProp(pc,'MBG_REWARD_ITEM_FLAG')
--        if rewardFlag == 0 then
--            SetExProp(pc,'MBG_REWARD_ITEM_FLAG',1)
--            PlaySound(pc, 'quest_success_3')
--            PlayEffect(pc, 'F_explosion015_anvil_success', 0.5, 'TOP')
--            SendAddOnMsg(pc, "NOTICE_Dm_stage_clear", ScpArgMsg("MOLE_BINGO_MSG2","POINT",succPoint), 10);
--        end
--    end
--    print('XXXXXXXXXXXXXXXX',startTime + playTimeMax/100, nowTime)
    if startTime + playTimeMax/100 < nowTime then
        local aobj = GetAccountObj(pc);
        local maxPoint = aobj.MOLE_BINGO_MAX_POINT
        if maxPoint < nowPoint then
            maxPoint = nowPoint
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("MOLE_BINGO_MSG3","POINT",nowPoint, "MAXPOINT", maxPoint)..ScpArgMsg("MOLE_BINGO_MSG6"), 10);
            RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX',pc, nil, nil, nil, nil, "MOLE_BINGO", 'ACCOUNT/MOLE_BINGO_MAX_POINT/'..nowPoint)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("MOLE_BINGO_MSG3","POINT",nowPoint, "MAXPOINT", maxPoint), 10);
        end
        SCR_MOLE_BINGO_END(pc,sObj)
        return
    end
    local ticNextTime = GetExProp(pc,'MBG_TIC_NEXT_TIME')
    if ticNextTime <= nowTime then
        local ticTime = GetExProp(pc,'MBG_TIC_TIME')
        if nowPoint > 0 then
--            Chat(pc,ScpArgMsg('MOLE_BINGO_MSG8','POINT',nowPoint), 2)
            SetTitle(pc, ScpArgMsg('EVENT_1804_ARBOR_MSG12','POINT',nowPoint))
        end
        SetExProp(pc,'MBG_TIC_NEXT_TIME', ticNextTime + ticTime/100)
        
        local monBlankList = {}
        local cellMax = GetExProp(pc,'MBG_CELL')
        for i = 1, cellMax do
            for i2 = 1, cellMax do
                local obj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..i2)
                if obj == nil then
                    monBlankList[#monBlankList + 1] = {}
                    monBlankList[#monBlankList][1] = i
                    monBlankList[#monBlankList][2] = i2
                end
            end
        end
        
        if #monBlankList > 0 then
            local monMin = GetExProp(pc,'MBG_TIC_MON_COUNT_MIN')
            local monMax = GetExProp(pc,'MBG_TIC_MON_COUNT_MAX')
            local randCount = IMCRandom(monMin, monMax)
            local blankListCount = #monBlankList
            
            local monGenList = {}
            for i = 1, randCount do
                if i > blankListCount then
                    break
                end
                local randIndex = IMCRandom(1, #monBlankList)
                monGenList[#monGenList + 1] = {}
                monGenList[#monGenList][1] = monBlankList[randIndex][1]
                monGenList[#monGenList][2] = monBlankList[randIndex][2]
                
                table.remove(monBlankList, randIndex)
            end
            
            if #monGenList > 0 then
                local zoneID = GetZoneInstID(pc)
                local monList = SCR_MOLE_BINGO_MON_LIST()
                local pcName = pc.Name
                local layre = GetLayer(pc)
                local centerX = GetExProp(pc,'MBG_CENTER_X')
                local centerY = GetExProp(pc,'MBG_CENTER_Y')
                local centerZ = GetExProp(pc,'MBG_CENTER_Z')
                for i = 1, #monGenList do
                    local genX = centerX - 24*monGenList[i][1]
                    local genY = centerY
                    local genZ = centerZ + 24*monGenList[i][2]
                    
                    if IsValidPos(zoneID, genX, genY, genZ) == 'YES' then
                        local rand = IMCRandom(1,#monList)
                        local monClassName = monList[rand]
                        local monName = ScpArgMsg("MOLE_BINGO_MSG7","PCNAME",pcName)
                        local mon = CREATE_MONSTER(pc, monClassName, genX, genY, genZ, 0, nil, layer, 1, 'MOLE_BINGO_NPC1', 'UnvisibleName', nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'None', nil, nil, nil, 100)
                        if mon ~= nil then
                            ClearBTree(mon)
                            ClearSimpleAI(mon)
                            SetExArgObject(mon, 'MBG_NPC_START_PC', pc)
                            SetExProp(mon,'MBG_NPC_START', 1)
                            SetLifeTime(mon, math.floor((ticTime-1000)/100)/10)
                            SetExProp(mon,'MBG_MON_TYPE', rand)
                            SetExProp(mon,'MBG_MON_IX', monGenList[i][1])
                            SetExProp(mon,'MBG_MON_IZ', monGenList[i][2])
                            
                            SetExArgObject(pc, 'MBG_MON_'..monGenList[i][1]..'_'..monGenList[i][2], mon)
                            
                            SCR_MOLE_BINGO_LINE_CHECK(pc, mon, monGenList[i][1], monGenList[i][2], rand)
                        end
                    end
                end
            end
        else
            local aobj = GetAccountObj(pc);
            local maxPoint = aobj.MOLE_BINGO_MAX_POINT
            if maxPoint < nowPoint then
                maxPoint = nowPoint
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("MOLE_BINGO_MSG3","POINT",nowPoint, "MAXPOINT", maxPoint)..ScpArgMsg("MOLE_BINGO_MSG6"), 10);
                RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX',pc, nil, nil, nil, nil, "MOLE_BINGO", 'ACCOUNT/MOLE_BINGO_MAX_POINT/'..nowPoint)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("MOLE_BINGO_MSG3","POINT",nowPoint, "MAXPOINT", maxPoint), 10);
            end
            SCR_MOLE_BINGO_END(pc,sObj)
        end
    end
end


function SCR_MOLE_BINGO_MON_LIST()
--    local monList = {'Onion','Bokchoy','Jukopus','raffly_blue','Leaf_diving','pino_white','Worg','Lemuria','Denden','Rondo','thornball'}
    local monList = {'Onion','Bokchoy','Jukopus','Leaf_diving'}
    return monList
end


function SCR_MOLE_BINGO_LINE_CHECK(pc, mon, iX, iZ, monType)
    local cellMax = GetExProp(pc,'MBG_CELL')
    local flagCount = 0
    
    local flagX = 0
    for i = 1, cellMax do
        local tempObj = GetExArgObject(pc, 'MBG_MON_'..iX..'_'..i)
        if tempObj == nil then
            break
        end
        local tempType = GetExProp(tempObj,'MBG_MON_TYPE')
        if tempType ~= monType then
            break
        end
        
        if i == cellMax then
            flagX = 1
            flagCount = flagCount + 1
        end
    end
    local flagZ = 0
    for i = 1, cellMax do
        local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..iZ)
        if tempObj == nil then
            break
        end
        local tempType = GetExProp(tempObj,'MBG_MON_TYPE')
        if tempType ~= monType then
            break
        end
        
        if i == cellMax then
            flagZ = 1
            flagCount = flagCount + 1
        end
    end
    
    local flagD1 = 0
    if iX == iZ then
        for i = 1, cellMax do
            local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..i)
            if tempObj == nil then
                break
            end
            local tempType = GetExProp(tempObj,'MBG_MON_TYPE')
            if tempType ~= monType then
                break
            end
            
            if i == cellMax then
                flagD1 = 1
                flagCount = flagCount + 1
            end
        end
    end
    
    local flagD2 = 0
    if iX + iZ == cellMax + 1 then
        for i = 1, cellMax do
            local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..(cellMax + 1 - i))
            if tempObj == nil then
                break
            end
            local tempType = GetExProp(tempObj,'MBG_MON_TYPE')
            if tempType ~= monType then
                break
            end
            
            if i == cellMax then
                flagD2 = 1
                flagCount = flagCount + 1
            end
        end
    end
    
    if flagCount > 0 then
        local nowTime = math.floor(os.clock()*10)
        if flagX == 1 then
            for i = 1, cellMax do
                local tempObj = GetExArgObject(pc, 'MBG_MON_'..iX..'_'..i)
                if tempObj ~= nil then
                    PlayEffect(tempObj, 'I_archer_multishot_ranger01_3_light', 1, 'MID')
                    SetExArgObject(pc, 'MBG_MON_'..iX..'_'..i, nil)
                    SetExProp(tempObj,'MBG_REWARD_ITEM_FLAG', nowTime+5)
                end
            end
        end
        if flagZ == 1 then
            for i = 1, cellMax do
                local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..iZ)
                if tempObj ~= nil then
                    PlayEffect(tempObj, 'I_archer_multishot_ranger01_3_light', 1, 'MID')
                    SetExArgObject(pc, 'MBG_MON_'..i..'_'..iZ, nil)
                    SetExProp(tempObj,'MBG_REWARD_ITEM_FLAG', nowTime+5)
                end
            end
        end
        if flagD1 == 1 then
            for i = 1, cellMax do
                local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..i)
                if tempObj ~= nil then
                    PlayEffect(tempObj, 'I_archer_multishot_ranger01_3_light', 1, 'MID')
                    SetExArgObject(pc, 'MBG_MON_'..i..'_'..i, nil)
                    SetExProp(tempObj,'MBG_REWARD_ITEM_FLAG', nowTime+5)
                end
            end
        end
        if flagD2 == 1 then
            for i = 1, cellMax do
                local tempObj = GetExArgObject(pc, 'MBG_MON_'..i..'_'..(cellMax + 1 - i))
                if tempObj ~= nil then
                    PlayEffect(tempObj, 'I_archer_multishot_ranger01_3_light', 1, 'MID')
                    SetExArgObject(pc, 'MBG_MON_'..i..'_'..(cellMax + 1 - i), nil)
                    SetExProp(tempObj,'MBG_REWARD_ITEM_FLAG', nowTime+5)
                end
            end
        end
        local nowPoint = GetExProp(pc,'MBG_NOW_POINT')
        local lPoint = GetExProp(pc,'MBG_L1_POINT')
        local vPoint = nowPoint + (flagCount * lPoint * (1 + (flagCount-1) * 0.5))
        SetExProp(pc,'MBG_NOW_POINT', math.floor(vPoint))
        
        local succPoint = GetExProp(pc,'MBG_SUCC_POINT')
        local rewardFlg = GetExProp(pc,'MBG_REWARD_ITEM_FLAG')
        
--        if rewardFlg == 0 and vPoint >= succPoint then
--            --SUCCESS ITEM REWARD
--            local aobj = GetAccountObj(pc);
--            local maxPoint = aobj.MOLE_BINGO_MAX_POINT
--            SetExProp(pc,'MBG_REWARD_ITEM_FLAG', 1)
--            PlaySound(pc, 'quest_success_3')
--            PlayEffect(pc, 'F_explosion015_anvil_success', 0.5, 'TOP')
--            SendAddOnMsg(pc, "NOTICE_Dm_stage_clear", ScpArgMsg("MOLE_BINGO_MSG5","MAXPOINT",maxPoint), 10);
--        end
        
        local ticTime = GetExProp(pc,'MBG_TIC_TIME')
        local ticTimeAdd = GetExProp(pc,'MBG_TIC_TIME_ADD')
        local ticTimeMin = GetExProp(pc,'MBG_TIC_TIME')
        
        if ticTime > ticTimeMin then
            ticTime = ticTime + ticTimeAdd
            if ticTime < ticTimeMin then
                ticTime = ticTimeMin
            end
            SetExProp(pc,'MBG_TIC_TIME', ticTime)
        end
        
        local lPointAdd = GetExProp(pc,'MBG_L1_POINT_ADD')
        SetExProp(pc,'MBG_L1_POINT',lPoint + lPointAdd)
    end
end


function SSN_MOLE_BINGO_AttackMonster(pc, sObj, msg, argObj, argStr, argNum)
    local monType = GetExProp(argObj,'MBG_MON_TYPE')
    if IsUsingNormalSkill(pc) == 1 and monType > 0 then
        local owner = GetExArgObject(argObj, 'MBG_NPC_START_PC')
        if owner ~= nil and IsSameActor(pc, owner) then
            local flag = GetExProp(argObj,'MBG_MON_ATTACK_FLAG')
            if flag == 0 then
                local playTimeMax = GetExProp(pc,'MBG_PLAY_TIME_MAX')
                SetLifeTime(argObj, playTimeMax/1000)
                AttachEffect(argObj, 'F_pattern013_ground_white', 0.4, 'BOT')
                SetExProp(argObj,'MBG_MON_ATTACK_FLAG',1)
            end
            local iX = GetExProp(argObj,'MBG_MON_IX')
            local iZ = GetExProp(argObj,'MBG_MON_IZ')
            SCR_MOLE_BINGO_LINE_CHECK(pc, argObj, iX, iZ, monType)
        end
    end
end


function SSN_MOLE_BINGO_AttackMonster_PARTY(pc, party_pc, sObj, msg, argObj, argStr, argNum)
    if party_pc ~= nil and pc ~= nil then
        if IsSameActor(pc, partyPC) == "YES" then
            return
        end
        if GetDistance(pc, partyPC) <= 200 then
            if GetLayer(pc) == GetLayer(party_pc) then
                SSN_MOLE_BINGO_AttackMonster(pc, sObj, msg, argObj, argStr, argNum)
            end
        end
    end
end



function SCR_MOLE_BINGO_NPC2_TS_BORN_ENTER(self)
end

function SCR_MOLE_BINGO_NPC2_TS_BORN_UPDATE(self)
    local channel = GetMyChannel(self)
    
    if channel == 0 then
        local summon = GetExArgObject(self, 'MBG_NPC2_SUMMON')
        if summon ~= nil then
        else
            local x,y,z = GetPos(self)
            local npc = CREATE_NPC(self, 'Board1', x, y, z, 315, 'Peaceful', GetLayer(self), ScpArgMsg('MOLE_BINGO_MSG9'), 'MOLE_BINGO_RANKING', nil, nil, 1, nil, 'MOLE_BINGO_RANKING')
            if npc ~= nil then
                EnableAIOutOfPC(npc)
                SetExArgObject(self, 'MBG_NPC2_SUMMON', npc)
            end
        end
    end
end

function SCR_MOLE_BINGO_NPC2_TS_BORN_LEAVE(self)
end

function SCR_MOLE_BINGO_NPC2_TS_DEAD_ENTER(self)
end

function SCR_MOLE_BINGO_NPC2_TS_DEAD_UPDATE(self)
end

function SCR_MOLE_BINGO_NPC2_TS_DEAD_LEAVE(self)
end




function SCR_MOLE_BINGO_RANKING_TS_BORN_ENTER(self)
end

function SCR_MOLE_BINGO_RANKING_TS_BORN_UPDATE(self)
    local channel = GetMyChannel(self)
    
    if channel == 0 then
        local now_time = os.date('*t')
        local hour = now_time['hour']
        local min = now_time['min']
        if hour%4 == 0 and min == 5 then
            if self.StrArg1 ~= hour..'/'..min then
                self.StrArg1 = hour..'/'..min
                
                local zoneID = GetZoneInstID(self)
                local zoneObj = GetLayerObject(zoneID, 0)
                local msg = ''
                for i = 1, 3 do
                    if zoneObj['MOLE_BINGO_RANKING_'..i] ~= 'None' then
                        msg = msg..ScpArgMsg("MOLE_BINGO_MSG11","RANK",i,"NAME",zoneObj['MOLE_BINGO_RANKING_'..i],"POINT",zoneObj['MOLE_BINGO_RANKING_POINT_'..i])
                    end
                end
                if msg ~= '' then
                    local now_time = os.date('*t')
                    local month = now_time['month']
                    local day = now_time['day']
                    msg = ScpArgMsg("MOLE_BINGO_MSG10","MONTH",month,"DAY",day)..msg
                    
                    BroadcastToAllServerPC(1, msg, "");
                end
            end
        end
    end
end

function SCR_MOLE_BINGO_RANKING_TS_BORN_LEAVE(self)
end

function SCR_MOLE_BINGO_RANKING_TS_DEAD_ENTER(self)
end

function SCR_MOLE_BINGO_RANKING_TS_DEAD_UPDATE(self)
end

function SCR_MOLE_BINGO_RANKING_TS_DEAD_LEAVE(self)
end



function SCR_MOLE_BINGO_RANKING_DIALOG(self, pc)
    local zoneID = GetZoneInstID(pc)
    local zoneObj = GetLayerObject(zoneID, 0)
    if zoneObj ~= nil then
        local aobj = GetAccountObj(pc);
        local teamName = GetTeamName(pc)
        local maxPoint = aobj.MOLE_BINGO_MAX_POINT
        if maxPoint > 0 then
            local duplFlag = 0
            local rankList = {}
            for i = 1, 3 do
                if zoneObj['MOLE_BINGO_RANKING_'..i] ~= 'None' then
                    rankList[#rankList + 1] = {}
                    if zoneObj['MOLE_BINGO_RANKING_'..i] == teamName then
                        if zoneObj['MOLE_BINGO_RANKING_POINT_'..i] < maxPoint then
                            rankList[#rankList][1] = teamName
                            rankList[#rankList][2] = maxPoint
                            duplFlag = 1
                        else
                            rankList[#rankList][1] = zoneObj['MOLE_BINGO_RANKING_'..i]
                            rankList[#rankList][2] = zoneObj['MOLE_BINGO_RANKING_POINT_'..i]
                        end
                    else
                        rankList[#rankList][1] = zoneObj['MOLE_BINGO_RANKING_'..i]
                        rankList[#rankList][2] = zoneObj['MOLE_BINGO_RANKING_POINT_'..i]
                    end
                end
            end
            
            if duplFlag == 0 then
                rankList[#rankList + 1] = {}
                rankList[#rankList][1] = teamName
                rankList[#rankList][2] = maxPoint
            end
            
            if #rankList > 1 then
                for i1 = 1, #rankList - 1 do
                    for i2 = 2, #rankList do
                        if rankList[i1][2] < rankList[i2][2] then
                            local tempTeamName = rankList[i1][1]
                            local tempTeamPoint = rankList[i1][2]
                            rankList[i1][1] = rankList[i2][1]
                            rankList[i1][2] = rankList[i2][2]
                            
                            rankList[i2][1] = tempTeamName
                            rankList[i2][2] = tempTeamPoint
                        end
                    end
                end
            end
            
            for i = 1, #rankList do
                if i <= 3 then
                    zoneObj['MOLE_BINGO_RANKING_'..i] = rankList[i][1]
                    zoneObj['MOLE_BINGO_RANKING_POINT_'..i] = rankList[i][2]
                end
            end
            
            GIVE_TAKE_SOBJ_ACHIEVE_TX(pc, nil, nil, nil, nil, "MOLE_BINGO", 'ACCOUNT/MOLE_BINGO_MAX_POINT/0')
        end
        
        local msg = ''
        for i = 1, 3 do
            if zoneObj['MOLE_BINGO_RANKING_'..i] ~= 'None' then
                msg = msg..ScpArgMsg("MOLE_BINGO_MSG11","RANK",i,"NAME",zoneObj['MOLE_BINGO_RANKING_'..i],"POINT",zoneObj['MOLE_BINGO_RANKING_POINT_'..i])
            end
        end
        if msg ~= '' then
            local now_time = os.date('*t')
            local month = now_time['month']
            local day = now_time['day']
            msg = ScpArgMsg("MOLE_BINGO_MSG10","MONTH",month,"DAY",day)..msg
            
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", msg, 10);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('MOLE_BINGO_MSG12'), 10);
        end
    end
end


function SCR_MOLE_BINGO_NPC1_TS_BORN_ENTER(self)
end

function SCR_MOLE_BINGO_NPC1_TS_BORN_UPDATE(self)
    if self.HP < self.MHP then
        Heal(self, self.MHP - self.HP, 0)
    end
    
    local pc = GetExArgObject(self, 'MBG_NPC_START_PC')
    local startValue = GetExProp(self,'MBG_NPC_START')
    if startValue == 1 then
        if pc == nil then
            PlayEffect(self, 'F_wizard_MAGNUMOPUS_SHOVEL_smoke', 1, 'MID')
            Kill(self)
        end
    end
    
    local nowTime = math.floor(os.clock()*10)
    local deadTime = GetExProp(self,'MBG_REWARD_ITEM_FLAG')
    if deadTime > 0 then
        if deadTime < nowTime then
            Dead(self)
        end
    end
end

function SCR_MOLE_BINGO_NPC1_TS_BORN_LEAVE(self)
end

function SCR_MOLE_BINGO_NPC1_TS_DEAD_ENTER(self)
end

function SCR_MOLE_BINGO_NPC1_TS_DEAD_UPDATE(self)
end

function SCR_MOLE_BINGO_NPC1_TS_DEAD_LEAVE(self)
end
