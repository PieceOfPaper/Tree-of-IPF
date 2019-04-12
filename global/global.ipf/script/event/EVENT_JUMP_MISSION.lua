-- //mgame EVENT_JUMP_MISSION
--//setpos 113.00, 364.43, 1769.00
--//setpos -222, 293, 1908
--//setpos 79, 364, 1064
--//setpos -807, -109, 407
--//setpos -163, 367, 1003
function SCR_BUFF_ENTER_Event_Jump_1(self, buff, arg1, arg2, over)
    self.FIXMSPD_BM = 32
    Invalidate(self, 'MSPD');
end

function SCR_BUFF_LEAVE_Event_Jump_1(self, buff, arg1, arg2, over)
    self.FIXMSPD_BM = 0
    Invalidate(self, 'MSPD');
end

function SCR_BUFF_ENTER_Event_Jump_2(self, buff, arg1, arg2, over)
    self.FIXMSPD_BM = 40
    Invalidate(self, 'MSPD');
end

function SCR_BUFF_LEAVE_Event_Jump_2(self, buff, arg1, arg2, over)
    self.FIXMSPD_BM = 0
    Invalidate(self, 'MSPD');
end

function SCR_JUMP_TIME_CHECK(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local pc = nil

    for i = 1, cnt do
        if list[i] ~= nil then
            pc = list[i]
            break
        end
    end

    if pc ~= nil then
        local zoneObj = GetLayerObject(pc);
        SetExProp(zoneObj, "TIME_COUNT", 1);
    end
end

function SCR_JUMP_BUFF_CHECK(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local pc = nil

    for i = 1, cnt do
        if list[i] ~= nil then
            pc = list[i]
            if IsBuffApplied(pc, 'Event_Jump_1') == 'YES' then
                RemoveBuff(pc, 'Event_Jump_1')
                AddBuff(pc, pc, "Event_Jump_2", 1, 0, 900000, 1);
            end
            --AddBuff(pc, pc, "Event_Jump_2", 1, 0, 900000, 1);
        end
    end
end

function INIT_EVNET_JUMP_STAT(pc)
    AddBuff(pc, pc, "Event_Jump_1", 1, 0, 900000, 1);     
end

function SCR_EVENT_JUMP_MISSION_DIALOG(self, pc)
    AUTOMATCH_INDUN_DIALOG(pc, nil, 'E_f_tableland_11_1')
end

function SCR_EVENT_JUMP_POTAL_DIALOG(self, pc)
    MoveZone(pc, 'E_f_tableland_11_1', -1570.32, 597.43, 1898.20);
end

function SCR_EVENT_JUMP_NPC_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local now_time = os.date('*t')
    local yday = now_time['yday']
    
    if sObj.EVENT_JUMP_NPC_REWARD ~= yday then    
        local tx = TxBegin(pc)
        TxEnableInIntegrate(tx)
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP2', 2, "EVENT_JUMP_HPSP2");
        TxSetIESProp(tx, sObj, 'EVENT_JUMP_NPC_REWARD', yday);
        local ret = TxCommit(tx)
        ShowOkDlg(pc, 'EVENT_JUMP_MISSION_NPC1', 1)
    end
end

function SCR_EVENT_JUMP_BOX_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local zoneObj = GetLayerObject(pc);
	local GOAL_COUNT = GetExProp(zoneObj, 'GOAL_COUNT')

    if sObj.EVENT_JUMP_BOX_REWARD ~= yday then
        local TIME_COUNT = GetExProp(zoneObj, 'TIME_COUNT')
        if TIME_COUNT == 0 then
            local tx = TxBegin(pc)
            TxEnableInIntegrate(tx)
            TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 1, "EVENT_JUMP_GET_Ability");
            local ret = TxCommit(tx)
        end
        EquipOuter = GetEquipItem(pc, "OUTER")
        EquipHelmet = GetEquipItem(pc, "HELMET")      
        if EquipOuter.ClassName == 'costume_Com_75' or EquipOuter.ClassName == 'costume_Com_76' or EquipOuter.ClassName == 'costume_war_m_016' or 
            EquipOuter.ClassName == 'costume_war_f_016' or EquipOuter.ClassName == 'costume_wiz_m_016' or EquipOuter.ClassName == 'costume_wiz_f_016' or 
            EquipOuter.ClassName == 'costume_arc_m_019' or EquipOuter.ClassName == 'costume_arc_f_019' or EquipOuter.ClassName == 'costume_clr_m_017' or 
            EquipOuter.ClassName == 'costume_clr_f_017' or EquipOuter.ClassName == 'costume_Com_77' or EquipHelmet.ClassName == 'helmet_Rudolf01' then    
            local tx = TxBegin(pc)
            TxEnableInIntegrate(tx)
            TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 1, "EVENT_JUMP_GET_Ability");
            TxGiveItem(tx, 'Drug_Fortunecookie', 1, "EVENT_JUMP_GET_Fortun");
            TxSetIESProp(tx, sObj, 'EVENT_JUMP_BOX_REWARD', yday);
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                SetExProp(zoneObj, "GOAL_COUNT", GOAL_COUNT + 1);
                GOAL_COUNT = GetExProp(zoneObj, 'GOAL_COUNT')
                MoveZone(pc, 'E_f_tableland_11_1', -756.33, -109.71, 441.79);
            end
        else
            local tx = TxBegin(pc)
            TxEnableInIntegrate(tx)
            TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 1, "EVENT_JUMP_GET_Ability");
            TxSetIESProp(tx, sObj, 'EVENT_JUMP_BOX_REWARD', yday);
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                SetExProp(zoneObj, "GOAL_COUNT", GOAL_COUNT + 1);
                GOAL_COUNT = GetExProp(zoneObj, 'GOAL_COUNT')
                MoveZone(pc, 'E_f_tableland_11_1', -756.33, -109.71, 441.79);
            end
        end
    end
    if GOAL_COUNT >= 5 then
		Kill(self)
		return;
	end
end

function JUMP_MISSION_YELLOW_HIDE(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%4 == 0 then
        RemoveEffect(self, "F_ground008_yellow", 1)
    elseif sec%2 == 0 then
        AttachEffect(self, 'F_ground008_yellow', 3, "BOT");
    end
end

function JUMP_MISSION_BLUE_HIDE(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%4 == 0 then
        RemoveEffect(self, "F_ground008_blue", 1)
    elseif sec%2 == 0 then
        AttachEffect(self, 'F_ground008_blue', 3, "BOT");
    end
end

function JUMP_MISSION_RED_HIDE(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%4 == 0 then
        RemoveEffect(self, "F_ground008_red", 1)
    elseif sec%2 == 0 then
        AttachEffect(self, 'F_ground008_red', 3, "BOT");
    end
end

function JUMP_MISSION_GREEN_HIDE(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%4 == 0 then
        RemoveEffect(self, "F_ground008_green", 1)
    elseif sec%2 == 0 then
        AttachEffect(self, 'F_ground008_green', 3, "BOT");
    end
end

function JUMP_MISSION_UPDOWN(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%4 == 0 then
        if sec ~= self.NumArg1 then
            self.NumArg1 = sec;
            local _height = GetFlyHeight(self)
            local _max = 150;
            local _min = 30;
            
            if _height >= _max then
                FlyMath(self, _min, 3, 1)
            elseif _height <= _min then
                FlyMath(self, _max, 3, 1)
            end
        end
    end
end

function JUMP_MISSION_UPDOWN2(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%6 == 0 then
        if sec ~= self.NumArg1 then
            self.NumArg1 = sec;
            local _height = GetFlyHeight(self)
            local _max = 270;
            local _min = 50;
            
            if _height >= _max then
                FlyMath(self, _min, 3, 1)
            elseif _height <= _min then
                FlyMath(self, _max, 3, 1)
            end
        end
    end
end
--//setpos -221.28, 367.64, 1197.16
function JUMP_MISSION_UPDOWN3(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if sec%6 == 0 then
        if sec ~= self.NumArg1 then
            self.NumArg1 = sec;
            local _height = GetFlyHeight(self)
            local _max = 270;
            local _min = 180;
            
            if _height >= _max then
                FlyMath(self, _min, 3, 1)
            elseif _height <= _min then
                FlyMath(self, _max, 3, 1)
            end
        end
    end
end

--//mgame EVENT_JUMP_MISSION

function SCR_EVENT_JUMP_WARP_DIALOG(self, pc)
    MoveZone(pc, 'E_f_tableland_11_1', 583.73, -163.55, -1517.94);
end

function SCR_EVENT_JUMP_WARP2_DIALOG(self, pc)
    MoveZone(pc, 'E_f_tableland_11_1', -83.06, -162.22, -1302.70);
end

function SCR_EVENT_JUMP_WARP3_DIALOG(self, pc)
    MoveZone(pc, 'E_f_tableland_11_1', -414.77, 56.26, -90.90);
end

function SCR_EVENT_JUMP_WARP4_DIALOG(self, pc)
    MoveZone(pc, 'E_f_tableland_11_1', 67.00, 127.53, 1529.53);
end

function JUMP_MISSION_30(self)
    FlyMath(self, 30, 0, 0);
end

function JUMP_MISSION_60(self)
    FlyMath(self, 60, 0, 0);
end

function JUMP_MISSION_90(self)
    FlyMath(self, 90, 0, 0);
end

function JUMP_MISSION_120(self)
    FlyMath(self, 120, 0, 0);
end

function JUMP_MISSION_150(self)
    FlyMath(self, 150, 0, 0);
end

function JUMP_MISSION_180(self)
    FlyMath(self, 180, 0, 0);
end

function JUMP_MISSION_210(self)
    FlyMath(self, 210, 0, 0);
end

function JUMP_MISSION_240(self)
    FlyMath(self, 240, 0, 0);
end

function JUMP_MISSION_270(self)
    FlyMath(self, 270, 0, 0);
end

function JUMP_MISSION_300(self)
    FlyMath(self, 300, 0, 0);
end
-- //mgame EVENT_JUMP_MISSION