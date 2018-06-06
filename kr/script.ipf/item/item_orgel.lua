function SCR_USE_ORGEL(self, argObj, argStr, arg1, arg2)
    local argStrList = StringSplit(argStr, ';');
    if #argStrList ~= 3 and argStrList[1] ~= 'build' then -- argStr must be "orgel_xac_className;pc_TimeAnimName;orgel_TimeAnimName"
        return;
    end
    
    if argStrList[1] ~= 'build' then
        local result = PlayPairAnimation(self, argStrList[1], '#'..argStrList[2], '#'..argStrList[3], 0, 'dummy_musicbox');    
        if result ~= 1 then
            return;
        end
    end
    
    local pcx, pcy, pcz = GetPos(self)
    local zoneID = GetZoneInstID(self)
    local nowLayer = GetLayer(self)
    local bgmFlag = 1
    local objList, objCnt = GetWorldObjectListByPos(zoneID, nowLayer, pcx, pcy, pcz, 'PC', 200)
    for i = 1, objCnt do
        local isBuild = GetExProp(objList[i],'ORGEL_NPC_ISBUILD')
        if IsPlayingPairAnimation(objList[i]) == 1 or isBuild == 1 then
            if string.find(argStrList[1], 'musicbox_wedding') ~= nil then
                local orgel = GetExArgObject(objList[i], 'ORGEL_NPC')
                if orgel ~= nil and IsDead(orgel) then
                    local isWedding = GetExProp(orgel,'ORGEL_NPC_ISWEDDING')
                    if isWedding == 1 then
                        bgmFlag = 0
                        break
                    end
                end
            end
        end
    end
    if bgmFlag == 1 then
        local bgmNum = 1
        if string.find(argStrList[1], 'musicbox_wedding') ~= nil then
            bgmNum = 1
        elseif string.find(argStrList[1], 'musicbox_cake') ~= nil then
            bgmNum = 2
        elseif string.find(argStrList[1], 'musicbox_maple') ~= nil then
            bgmNum = 3
        elseif string.find(argStrList[1], 'musicbox_main') ~= nil then
            bgmNum = 4
        elseif string.find(argStrList[1], 'musicbox_bear') ~= nil then
            bgmNum = 5
        elseif string.find(argStrList[2], 'musicbox_popolion') ~= nil then
            bgmNum = 6
        end
        local npc
        if argStrList[1] == 'build' then
            local zoneID = GetZoneInstID(self)
            local pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
            if IsValidPos(zoneID, pos_list[1][1], pos_list[1][2], pos_list[1][3]) ~= 'YES' then
                pos_list[1][1] = pcx
                pos_list[1][2] = pcy
                pos_list[1][3] = pcz
            end
            npc = CREATE_NPC(self, argStrList[2], pos_list[1][1], pos_list[1][2], pos_list[1][3], 315, "Peaceful", nowLayer, nil, nil, nil, 1, 1, nil, 'NPC_ORGEL_'..bgmNum)
        else
            npc = CREATE_NPC(self, 'HiddenTrigger2', pcx, pcy, pcz, 0, "Peaceful", nowLayer, nil, nil, nil, 1, 1, nil, 'NPC_ORGEL_'..bgmNum)
        end
        if npc ~= nil then
            EnableAIOutOfPC(npc)
            SetExProp(npc,'PCX', pcx)
            SetExProp(npc,'PCZ', pcz)
            if string.find(argStrList[1], 'musicbox_wedding') ~= nil then
                SetExProp(npc,'ORGEL_NPC_ISWEDDING', 1)
            end
            SetExArgObject(self, 'ORGEL_NPC', npc)
            SetExArgObject(npc, 'ORGEL_PC', self)
            SetExProp(self,'ORGEL_NPC_ISBUILD', 1)
        end
    end
end

function TEST_PLAY_ORGEL(pc, xacClassName)
    print("오르골 실행: xac 이름("..xacClassName..')');
    PlayPairAnimation(pc, xacClassName, '#PC_Orgel', '#Monster_Orgel', 0, 'dummy_musicbox');
end

function TEST_STOP_ORGEL(pc)
    print("오르골 정지");
    StopPairAnimation(pc);
end

function SCR_PRECHECK_ORGEL(self, argStr, arg1, arg2)
    local argStrList = StringSplit(argStr, ';');
    if #argStrList ~= 3 and argStrList[1] ~= 'build' then
        return;
    end
    if IsFishingState(self) == 1 then
        return 0;
    end
    local isBuild = GetExProp(self,'ORGEL_NPC_ISBUILD')
    if IsPlayingPairAnimation(self) == 1 or isBuild == 1 then
        if IsPlayingPairAnimation(self) == 1 then
            StopPairAnimation(self);
        end
        local orgelNPC =  GetExArgObject(self, 'ORGEL_NPC')
        if orgelNPC ~= nil then
            SysMsg(self, 'Instant', ScpArgMsg('Orgel_MSG1'))
            Kill(orgelNPC)
            SetExProp(self,'ORGEL_NPC_ISBUILD', 0)
            SetExArgObject(self, 'ORGEL_NPC', nil)
        end
        return 0;
    end
    
    if GetRidingCompanion(self) ~= nil then
        SysMsg(self, 'Instant', ScpArgMsg('Orgel_MSG3'))
        return 0
    end
    
    if IsSitState(self) == 1 then
        SysMsg(self, 'Instant', ScpArgMsg('Orgel_MSG4'))
        return 0
    end
    
    local nowLayer = GetLayer(self)
    if IsIndun(self) == 1 or IsPVPServer(self) == 1 or IsMissionInst(self) == 1 then
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG3'))
        return 0
    end
    if nowLayer > 0 then
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG4'))
        return 0
    end
    local zoneID = GetZoneInstID(self)
    local pcx, pcy, pcz = GetPos(self)
    local objList, objCnt = GetWorldObjectListByPos(zoneID, nowLayer, pcx, pcy, pcz, 'PC', 200)
    for i = 1, objCnt do
        local isBuild = GetExProp(objList[i],'ORGEL_NPC_ISBUILD')
        if IsPlayingPairAnimation(objList[i]) == 1 or isBuild == 1 then
            if string.find(argStrList[1], 'musicbox_wedding') ~= nil then
                local npc = GetExArgObject(objList[i], 'ORGEL_NPC')
                if npc ~= nil and IsDead(npc) == 0 then
                    local isWedding = GetExProp(npc,'ORGEL_NPC_ISWEDDING')
                    if isWedding == nil or isWedding == 0 then
                        SysMsg(self, 'Instant', ScpArgMsg('Orgel_MSG2'))
                        return 0
                    end
                end
            else
                SysMsg(self, 'Instant', ScpArgMsg('Orgel_MSG2'))
                return 0
            end
        end
    end
    
    return 1;
end


function SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
    local nowSec = math.floor(os.clock())
    local lastSec = GetExProp(self,'ORGEL_NPC_CHECK_TIME')
    if lastSec == nil then
        lastSec = 0
    end
    if lastSec + 2 <=  nowSec then
        SetExProp(self,'ORGEL_NPC_CHECK_TIME',nowSec)
        local pc = GetExArgObject(self, 'ORGEL_PC')
        if pc == nil then
            Dead(self)
        else
            local isBuild = GetExProp(pc,'ORGEL_NPC_ISBUILD')
            if isBuild ~= 1 then
                if IsPlayingPairAnimation(pc) ~= 1 then
                    Dead(self)
                end
                local nowX, nowY, nowZ = GetPos(pc)
                local pcx = GetExProp(self,'PCX')
                local pcz = GetExProp(self,'PCZ')
                if SCR_POINT_DISTANCE(nowX, nowZ, pcx, pcz) >= 30 then
                    SetExProp(pc,'ORGEL_NPC_ISBUILD', 0)
                    Dead(self)
                end
            end
        end
    end
end

function SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
    local pc = GetExArgObject(self, 'ORGEL_PC')
    if pc ~= nil then
        StopPairAnimation(pc);
        SetExArgObject(pc, 'ORGEL_NPC', nil)
    end
    SetExArgObject(self, 'ORGEL_PC', nil)
end






function SCR_NPC_ORGEL_1_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_1_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_1_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_1_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_1_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_1_TS_DEAD_LEAVE(self)
end


function SCR_NPC_ORGEL_2_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_2_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_2_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_2_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_2_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_2_TS_DEAD_LEAVE(self)
end



function SCR_NPC_ORGEL_3_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_3_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_3_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_3_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_3_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_3_TS_DEAD_LEAVE(self)
end



function SCR_NPC_ORGEL_4_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_4_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_4_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_4_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_4_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_4_TS_DEAD_LEAVE(self)
end



function SCR_NPC_ORGEL_5_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_5_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_5_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_5_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_5_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_5_TS_DEAD_LEAVE(self)
end


function SCR_NPC_ORGEL_6_TS_BORN_ENTER(self)
end

function SCR_NPC_ORGEL_6_TS_BORN_UPDATE(self)
    SCR_NPC_ORGEL_TS_BORN_UPDATE(self)
end

function SCR_NPC_ORGEL_6_TS_BORN_LEAVE(self)
end

function SCR_NPC_ORGEL_6_TS_DEAD_ENTER(self)
    SCR_NPC_ORGEL_TS_DEAD_ENTER(self)
end

function SCR_NPC_ORGEL_6_TS_DEAD_UPDATE(self)
end

function SCR_NPC_ORGEL_6_TS_DEAD_LEAVE(self)
end
