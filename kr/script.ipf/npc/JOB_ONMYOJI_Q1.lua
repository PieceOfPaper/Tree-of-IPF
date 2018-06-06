
--JOB_ONMYOJI_QUSET_SCRIPT
function SCR_JOB_ONMYOJI_Q1_OBJ_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_ONMYOJI_Q1_GIMMICK_WALL_SETTING(self)
    local x, y, z = GetPos(self)
    local angle_list = {"0", "90", "180", "270"} --4방향 정각도
    local wall_dis = 40 --결계벽 간격
    local wall_count = math.ceil(wall_dis/#angle_list) --결계벽 한방향의 결계 개수
    local limit_max_dis = wall_dis * wall_count --결계벽 최대 범위
    SetExProp_Pos(self, "COMMON_POS", x, y, z)
    SetExProp(self, 'WALL_DIS', wall_dis)
    SetExProp(self, 'WALL_COUNT', wall_count)
    SetExProp(self, 'LIMIT_MAX_DIS', limit_max_dis)
    for i = 1, #angle_list do
        for j = 1, wall_count do
            local charge_dis = (wall_dis/2) + (wall_dis * (j-1))
            local pos_x, pos_y, pos_z = 0
            if i == 1 then
                pos_x, pos_y, pos_z = x+charge_dis, y, z
            elseif i == 2 then
                pos_x, pos_y, pos_z = x, y, z+charge_dis
            elseif i == 3 then
                pos_x, pos_y, pos_z = x+charge_dis, y, z+limit_max_dis
            elseif i == 4 then
                pos_x, pos_y, pos_z = x+limit_max_dis, y, z+charge_dis
            end
            local wall = CREATE_NPC(self, "Hiddennpc", pos_x, pos_y, pos_z, angle_list[i], "Neutral", GetLayer(self), 'UnvisibleName');
            AttachEffect(wall, 'F_light073_yellow_loop', 3, 'MID')
        end
        SetExProp(self, 'ANGLE_LIST'..i, angle_list[i])
    end
    
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local pc_list, pc_cnt = GetLayerPCList(zoneID, layer)
    if pc_cnt > 0 then
        for k = 1, pc_cnt do
            SetExArgObject(self, "PC", pc_list[k])
        end
    end
end

function SCR_JOB_ONMYOJI_Q1_GIMMICK_MON_SETTING(self)
    local x, y, z = GetExProp_Pos(self, "COMMON_POS")
    local wall_dis = GetExProp(self, 'WALL_DIS')
    local wall_count = GetExProp(self, 'WALL_COUNT')
    local limit_max_dis = GetExProp(self, 'LIMIT_MAX_DIS')

    local mon_dis = wall_dis/8 --몬스터 체크 간격(간격에 따른 모델 또는 이펙트의 크기조정 필요)
    local low_mon_cnt = 2 --속도 로우 몬스터 개체수
    local normal_mon_cnt = 12 --속도 노멀 몬스터 개체수
    local high_mon_cnt = 2 --속도 하이 몬스터 개체수
    local level_of_difficulty = { 30, 60, 90 } --실패횟수에 따른 난이도 조정

    local pc_obj = GetExArgObject(self, "PC")
    local sObj = nil
    if pc_obj ~= nil then
        sObj = GetSessionObject(pc_obj, "SSN_JOB_ONMYOJI_Q1")
    end
    local sObj_main = GetSessionObject(pc_obj, 'ssn_klapeda')
    local failCount = sObj_main['JOB_ONMYOJI_Q1_FC']

    if failCount >= level_of_difficulty[1] and failCount < level_of_difficulty[2] then
        low_mon_cnt = low_mon_cnt + 2
    elseif failCount >= level_of_difficulty[2] and failCount < level_of_difficulty[3] then
        low_mon_cnt = low_mon_cnt + 2
        normal_mon_cnt = normal_mon_cnt + 2
    elseif failCount >= level_of_difficulty[3] then
        low_mon_cnt = low_mon_cnt + 2
        normal_mon_cnt = normal_mon_cnt + 2
        high_mon_cnt = high_mon_cnt + 2
    end
    local total_mon_cnt = low_mon_cnt + normal_mon_cnt + high_mon_cnt --몬스터 총 개체수
    SetExProp(self, 'MON_DIS', mon_dis)
    SetExProp(self, 'LOW_MON_CNT', low_mon_cnt)
    SetExProp(self, 'NORMAL_MON_CNT', normal_mon_cnt)
    SetExProp(self, 'HIGH_MON_CNT', high_mon_cnt)
    SetExProp(self, 'TOTAL_MON_CNT', total_mon_cnt)
    local mon_type_list = {}
    for i = 1, total_mon_cnt do
        local mid_cnt = total_mon_cnt / 2
        if i <= total_mon_cnt - (normal_mon_cnt + high_mon_cnt) then
            table.insert(mon_type_list, JOB_ONMYOJI_Q1_GIMMICK_MON_SET_LOW)
        elseif i > total_mon_cnt - (normal_mon_cnt + high_mon_cnt) and i <= total_mon_cnt - high_mon_cnt then
            table.insert(mon_type_list, JOB_ONMYOJI_Q1_GIMMICK_MON_SET_NORMAL)
        elseif i > total_mon_cnt - high_mon_cnt and i <= total_mon_cnt then
            table.insert(mon_type_list, JOB_ONMYOJI_Q1_GIMMICK_MON_SET_HIGH)
        end
    end

    mon_type_list = SCR_RANDOM_ARRANGE(mon_type_list)
    for i = 1, total_mon_cnt do
        local mon_name = 'Onmyoji_Paper_Doll_white' --몬스터 개체 타입1
        local mid_cnt = total_mon_cnt / 2
        if i > mid_cnt then
            mon_name = 'Onmyoji_Paper_Doll_red' --몬스터 개체 타입2
        end
        local mon_type = mon_type_list[i]
        local ran_x = IMCRandom(x+(wall_dis/2), x+(limit_max_dis-20))
        local ran_z = IMCRandom(z+(wall_dis/2), z+(limit_max_dis-20))
        local pos_x, pos_y, pos_z = ran_x, y, ran_z
        local mon = CREATE_MONSTER_EX(self, mon_name, pos_x, pos_y, pos_z, GetExProp(self, 'ANGLE_LIST'..IMCRandom(1,4)), 'Neutral', nil, mon_type)
        SetExArgObject(self, 'mon_'..i, mon)
        SetExProp(mon, 'WALL_DIS', wall_dis)
        SetExProp(mon, 'MON_DIS', mon_dis)
        SetExProp(mon, 'LIMIT_MAX_DIS', limit_max_dis)
        SetExProp(mon, 'MON_NUMBER', i)
        SetExProp_Pos(mon, "COMMON_POS", x, y, z)
        EnableAIOutOfPC(mon)
        PlayEffect(mon, 'F_smoke150_white', 0.3)
    end
    self.NumArg1 = self.NumArg1 + 1
end

function JOB_ONMYOJI_Q1_GIMMICK_MON_SET_LOW(mon)
    if mon.ClassName == "Onmyoji_Paper_Doll_white" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_WHITE")
    elseif mon.ClassName == "Onmyoji_Paper_Doll_red" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_RED")
    end
    mon.SimpleAI = "JOB_ONMYOJI_Q1_MONSTER_AI"
    mon.Enter = "JOB_ONMYOJI_Q1_GIMMICK_MON"
    mon.FIXMSPD_BM = 21
end

function JOB_ONMYOJI_Q1_GIMMICK_MON_SET_NORMAL(mon)
    if mon.ClassName == "Onmyoji_Paper_Doll_white" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_WHITE")
    elseif mon.ClassName == "Onmyoji_Paper_Doll_red" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_RED")
    end
    mon.SimpleAI = "JOB_ONMYOJI_Q1_MONSTER_AI"
    mon.Enter = "JOB_ONMYOJI_Q1_GIMMICK_MON"
    mon.FIXMSPD_BM = 28
end

function JOB_ONMYOJI_Q1_GIMMICK_MON_SET_HIGH(mon)
    if mon.ClassName == "Onmyoji_Paper_Doll_white" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_WHITE")
    elseif mon.ClassName == "Onmyoji_Paper_Doll_red" then
        mon.Name = ScpArgMsg("JOB_ONMYOJI_Q1_MON_NAME_RED")
    end
    mon.SimpleAI = "JOB_ONMYOJI_Q1_MONSTER_AI"
    mon.Enter = "JOB_ONMYOJI_Q1_GIMMICK_MON"
    mon.FIXMSPD_BM = 35
end

function SCR_JOB_ONMYOJI_Q1_GIMMICK_MON_ENTER(self, pc)
end

function SCR_JOB_ONMYOJI_Q1_GIMMICK_CONTROL_AI(self)
    if self.NumArg1 > 0 then
        local x, y, z = GetExProp_Pos(self, "COMMON_POS")
        local x = x - 16
        local z = z - 3
        local wall_dis = GetExProp(self, 'WALL_DIS')
        local wall_count = GetExProp(self, 'WALL_COUNT')
        local limit_max_dis = GetExProp(self, 'LIMIT_MAX_DIS')
        
        local mon_dis = GetExProp(self, 'MON_DIS')
        local low_mon_cnt = GetExProp(self, 'LOW_MON_CNT')
        local normal_mon_cnt = GetExProp(self, 'NORMAL_MON_CNT')
        local high_mon_cnt = GetExProp(self, 'HIGH_MON_CNT')
        local total_mon_cnt = GetExProp(self, 'TOTAL_MON_CNT')
        local currection_num = 1 --몬스터 체크 간격에 따른 보정값(5:1, 간격이 크면 보정값이 안들어가도 됨)

        local pc_obj = GetExArgObject(self, "PC")
        local sObj = nil
        if pc_obj ~= nil then
            sObj = GetSessionObject(pc_obj, "SSN_JOB_ONMYOJI_Q1")
        end

        if sObj ~= nil then
            for i = 1, total_mon_cnt do
                local mon = GetExArgObject(self, 'mon_'..i)
                local x_mon, y_mon, z_mon = GetPos(mon)
                local x_index = math.floor(math.abs(x - x_mon) / mon_dis) + 1
                local z_index = math.floor(math.abs(z - z_mon) / mon_dis) + 1
                local pos = x_index.."/"..z_index
                local mon_kill_list = {}
                
                for j = 1, total_mon_cnt do
                    local string_cut_list = SCR_STRING_CUT(pos)
                    local x_index1 = string_cut_list[1]
                    local z_index1 = string_cut_list[2]
                    local sub_mon = GetExArgObject(self, 'mon_'..j)
                    local x_sub_mon, y_sub_mon, z_sub_mon = GetPos(sub_mon)
                    local x_index2 = math.floor(math.abs(x - x_sub_mon) / mon_dis) + 1
                    local z_index2 = math.floor(math.abs(z - z_sub_mon) / mon_dis) + 1
                    if x_index2 >= x_index1 - currection_num 
                    and x_index2 <= x_index1 + currection_num
                    and z_index2 >= z_index1 - currection_num 
                    and z_index2 <= z_index1 + currection_num then
                        table.insert(mon_kill_list, sub_mon)
                    end
                end
                if #mon_kill_list >= 2 then
                    local mon_color_list = {}
                    local mon_spd_list = {}
                    for j = 1, #mon_kill_list do
                        mon_spd_list[j] = mon_kill_list[j].FIXMSPD_BM
                    end
                    mon_spd_list = SCR_RANDOM_ARRANGE(mon_spd_list)
                    local point_check = 0
                    for j = 1, #mon_kill_list do
                        for k = 1, #mon_kill_list do
                            if mon_kill_list[j].ClassName ~= mon_kill_list[k].ClassName then
                                point_check = point_check + 1
                            end
                        end
                    end
                    
                    local before_point = sObj.QuestInfoValue1
                    for j = 1, #mon_kill_list do
                        StopMove(mon_kill_list[j])
                        local mon_number = GetExProp(mon_kill_list[j], 'MON_NUMBER')
                        local mon_name = mon_kill_list[j].ClassName
                        local mon_spd = mon_spd_list[j]
                        local mon_type = nil
                        if mon_spd == 21 then
                            mon_type = JOB_ONMYOJI_Q1_GIMMICK_MON_SET_LOW
                        elseif mon_spd == 28 then
                            mon_type = JOB_ONMYOJI_Q1_GIMMICK_MON_SET_NORMAL
                        elseif mon_spd == 35 then
                            mon_type = JOB_ONMYOJI_Q1_GIMMICK_MON_SET_HIGH
                        end
                        Dead(mon_kill_list[j])
                        ClearExArgObject(self, 'mon_'..mon_number)
                        local low_point = 1
                        local high_point = 5
                        if point_check == 0 then --포인트 획득 조건 체크
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + high_point
                        else
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + low_point
                        end
                        
                        if SCR_JOB_ONMYOJI_Q1_REW3_CHECK(pc_obj) == 'YES' and sObj.Step3 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
                            sObj.Step3 = 1
                        elseif SCR_JOB_ONMYOJI_Q1_REW2_CHECK(pc_obj) == 'YES' and sObj.Step2 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
                            sObj.Step2 = 1
                        elseif SCR_JOB_ONMYOJI_Q1_REW1_CHECK(pc_obj) == 'YES' and sObj.Step1 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
                            sObj.Step1 = 1
                        end
                        SaveSessionObject(pc_obj, sObj)
                        local ran_x = IMCRandom(x+(wall_dis/2), x+limit_max_dis)
                        local ran_z = IMCRandom(z+(wall_dis/2), z+limit_max_dis)
                        local pos_x, pos_y, pos_z = ran_x, y, ran_z
                        local mon = CREATE_MONSTER_EX(self, mon_name, pos_x, pos_y, pos_z, GetExProp(self, 'ANGLE_LIST'..IMCRandom(1,4)), 'Neutral', nil, mon_type)
                        SetExArgObject(self, 'mon_'..mon_number, mon)
                        SetExProp(mon, 'WALL_DIS', wall_dis)
                        SetExProp(mon, 'MON_DIS', mon_dis)
                        SetExProp(mon, 'LIMIT_MAX_DIS', limit_max_dis)
                        SetExProp(mon, 'MON_NUMBER', mon_number)
                        SetExProp_Pos(mon, "COMMON_POS", x, y, z)
                        EnableAIOutOfPC(mon)
                        PlayEffect(mon, 'F_smoke150_white', 0.3)
                    end
                    local now_point = sObj.QuestInfoValue1
                    if before_point ~= now_point then
                        local add_point = now_point - before_point
                        SendAddOnMsg(pc_obj, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_ONMYOJI_Q1_MSG2{add_point}{total_point}", "add_point", add_point, "total_point", now_point), 3)
                    end
                end
            end
        end

    end
end

function SCR_JOB_ONMYOJI_Q1_GIMMICK_MON_AI(self)
    if self.NumArg1 > 3 then
        local angle = math.floor(GetDirectionByAngle(self))
        
        local mon_dis = GetExProp(self, 'MON_DIS')
        local x, y, z = GetExProp_Pos(self, "COMMON_POS")
        local x = x - 16
        local z = z - 3
        local x_mon, y_mon, z_mon = GetPos(self)
        local x_index = math.floor(math.abs(x - x_mon) / mon_dis) + 1
        local z_index = math.floor(math.abs(z - z_mon) / mon_dis) + 1
    
        if x_index >= 80 then
            angle = -180
            SetDirectionByAngle(self, angle)
            StopMove(self)
        elseif x_index <= 6 then
            angle = 0
            SetDirectionByAngle(self, angle)
            StopMove(self)
        elseif z_index >= 80 then
            angle = -90
            SetDirectionByAngle(self, angle)
            StopMove(self)
        elseif z_index <= 6 then
            angle = 90
            SetDirectionByAngle(self, angle)
            StopMove(self)
        end
        local angle_check = math.floor(GetDirectionByAngle(self))
        if angle_check >= 135 and angle_check < 180 then
            angle_check = -180
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        elseif angle_check >= 45 and angle_check < 135 then
            angle_check = 90
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        elseif angle_check >= 0 and angle_check < 45 then
            angle_check = 0
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        elseif angle_check >= -45 and angle_check < 0 then
            angle_check = 0
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        elseif angle_check >= -135 and angle_check < -45 then
            angle_check = -90
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        elseif angle_check >= -180 and angle_check < -136 then
            angle_check = -180
            SetDirectionByAngle(self, angle_check)
--            StopMove(self)
        end
        local zoneID = GetZoneInstID(self)
        local dir = GetDirectionByAngle(self)
        local _far = 50
        local x1, y1, z1 = GetFrontPosByAngle(self, dir, _far, 1, x_mon, y_mon, z_mon, 1);
        if IsValidPos(zoneID, x1, y1, z1) == 'YES' then
            MoveEx(self, x1, y1, z1, 1)
        end
    else
        self.NumArg1 = self.NumArg1 + 1
    end

end
