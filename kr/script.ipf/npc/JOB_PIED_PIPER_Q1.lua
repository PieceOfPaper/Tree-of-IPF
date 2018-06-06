
--JOB_PIED_PIPER_QUSET_SCRIPT
function SCR_JOB_PIED_PIPER_Q1_OBJ_ENTER(self, pc)
end

function SCR_JOB_PIED_PIPER_Q1_GIMMICK_SETTING(self)
    sleep(300)
    local x, y, z = GetPos(self)
    local angle_list = {"0", "90", "180", "270"} --장애물 4방향 각도
    local cell_dis = 30 --셀 간 간격
    local cell_count =9 --셀 한방향의 개수
    local two_block = 3 --장애물 2칸 개수
    local one_block = 15--장애물 1칸 개수
    local init_obj = GetExProp(self, 'PIED_PIPER_Q1_INIT_OBJ')
    if init_obj ~= 1 then
        SetExProp(self, 'PIED_PIPER_Q1_INIT_OBJ', 1)
    end
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local pc_obj = GetExArgObject(self, "PC")
    if pc_obj == nil then
        local pc_list, pc_cnt = GetLayerPCList(zoneID, layer)
        if pc_cnt > 0 then
            for p = 1, pc_cnt do
                SetExArgObject(self, "PC", pc_list[p])
            end
        end
    end

    pc_obj = GetExArgObject(self, "PC")
    local sObj = nil
    if pc_obj ~= nil then
        sObj = GetSessionObject(pc_obj, "SSN_JOB_PIED_PIPER_Q1")
    end

    local sObj_main = GetSessionObject(pc_obj, 'ssn_klapeda')
    local failCount = sObj_main['JOB_PIED_PIPER_Q1_FC']
    local level_of_difficulty = { 30, 60, 90 } --실패횟수에 따른 난이도 조정
    if failCount >= level_of_difficulty[1] and failCount < level_of_difficulty[2] then
        one_block = one_block - 2
    elseif failCount >= level_of_difficulty[2] and failCount < level_of_difficulty[3] then
        one_block = one_block - 2
        two_block = two_block - 1
    elseif failCount >= level_of_difficulty[3] then
        one_block = one_block - 4
        two_block = two_block - 1
    end

    local start_pos_list = {11, 19, 91, 99}
    local start_pos = start_pos_list[IMCRandom(1, 4)]
    local end_pos
    if start_pos == 11 then
        end_pos = 99
    elseif start_pos == 19 then
        end_pos = 91
    elseif start_pos == 91 then
        end_pos = 19
    elseif start_pos == 99 then
        end_pos = 11
    end
    
    local two_block_common_pos_list = { 22, 23, 24, 25, 26, 27, 28,
                                        52, 53, 54, 55, 56, 57, 58,
                                        82, 83, 84, 85, 86, 87, 88 }

    local one_block_common_pos_list = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 
                                        21, 22, 23, 24, 25, 26, 27, 28, 29,
                                        31, 32, 33, 34, 35, 36, 37, 38, 39,
                                        41, 42, 43, 44, 45, 46, 47, 48, 49,
                                        51, 52, 53, 54, 55, 56, 57, 58, 59,
                                        61, 62, 63, 64, 65, 66, 67, 68, 69,
                                        71, 72, 73, 74, 75, 76, 77, 78, 79,
                                        81, 82, 83, 84, 85, 86, 87, 88, 89,
                                        91, 92, 93, 94, 95, 96, 97, 98, 99 }
    
    if start_pos == 11 or start_pos ==  99 then
        local two_block_del_list = {22, 23, 24, 86, 87, 88}
        local one_block_del_list = {11, 12, 21, 22, 88, 89, 98, 99}
        for i = 1, #two_block_del_list do
            local pos = table.find(two_block_common_pos_list, two_block_del_list[i])
            if pos > 0 then
                table.remove(two_block_common_pos_list, pos)
            end
        end
        for i = 1, #one_block_del_list do
            local pos = table.find(one_block_common_pos_list, one_block_del_list[i])
            if pos > 0 then
                table.remove(one_block_common_pos_list, pos)
            end
        end
    else
        local two_block_del_list = {26, 27, 28, 82, 83, 84}
        local one_block_del_list = {18, 19, 28, 29, 81, 82, 91, 92}
        for i = 1, #two_block_del_list do
            local pos = table.find(two_block_common_pos_list, two_block_del_list[i])
            if pos > 0 then
                table.remove(two_block_common_pos_list, pos)
            end
        end
        for i = 1, #one_block_del_list do
            local pos = table.find(one_block_common_pos_list, one_block_del_list[i])
            if pos > 0 then
                table.remove(one_block_common_pos_list, pos)
            end
        end
    end

    local one_block_list = {}
    local two_block_list = {}
    
    for i = 1, two_block do
        SCR_RANDOM_ARRANGE(two_block_common_pos_list)
        local block1 = two_block_common_pos_list[IMCRandom(1, #two_block_common_pos_list)]
        local block2
        local ran1 = IMCRandom(1, 4)
        if ran1 == 1 then
            block2 = block1 + 10
        elseif ran1 == 2 then
            block2 = block1 - 10
        elseif ran1 == 3 then
            local pos1 = table.find(two_block_list, block1 + 1)
            if pos1 > 0 then
                local pos2 = table.find(two_block_list, block1 - 1)
                if pos2 > 0 then
                    local ran2 = IMCRandom(1, 2)
                    if ran2 == 1 then
                        block2 = block1 + 10
                    else
                        block2 = block1 - 10
                    end
                else
                    block2 = block1 - 1
                end
            else
                block2 = block1 + 1
            end
        elseif ran1 == 4 then
            local pos1 = table.find(two_block_list, block1 - 1)
            if pos1 > 0 then
                local pos2 = table.find(two_block_list, block1 + 1)
                if pos2 > 0 then
                    local ran2 = IMCRandom(1, 2)
                    if ran2 == 1 then
                        block2 = block1 + 10
                    else
                        block2 = block1 - 10
                    end
                else
                    block2 = block1 + 1
                end
            else
                block2 = block1 - 1
            end
        end
        two_block_list[#two_block_list+1] = block1
        two_block_list[#two_block_list+1] = block2
        local pos1 = table.find(two_block_common_pos_list, block1)
        local pos2 = table.find(two_block_common_pos_list, block2)
        if pos1 > 0 then
            table.remove(two_block_common_pos_list, pos1)
        end
        if pos2 > 0 then
            table.remove(two_block_common_pos_list, pos2)
        end
    end

    for i = 1, #two_block_list do
        local block = two_block_list[i]
        local pos = table.find(one_block_common_pos_list, block)
        if pos > 0 then
            table.remove(one_block_common_pos_list, pos)
        end
    end

    for i = 1, one_block do
        SCR_RANDOM_ARRANGE(one_block_common_pos_list)
        local block = one_block_common_pos_list[IMCRandom(1, #one_block_common_pos_list)]
        one_block_list[#one_block_list+1] = block
        local pos = table.find(one_block_common_pos_list, block)
        table.remove(one_block_common_pos_list, pos)
    end

    for i = 1, cell_count do
        local charge_dis_z = 30*i
        for j = 1, cell_count do
            local charge_dis_x = (cell_dis/2) + (cell_dis * (j-1))
            local pos_x, pos_y, pos_z = x+charge_dis_x, y, z+charge_dis_z
            local x = x - 16
            local z = z - 3
            local x_index = math.floor(math.abs(x - pos_x) / cell_dis)
            local z_index = math.floor(math.abs(z - pos_z) / cell_dis)
            local pos = x_index..z_index
            if table.find(one_block_list, pos) > 0 then
                local block = CREATE_NPC(self, "Stone01", pos_x, pos_y, pos_z, angle_list[IMCRandom(1, 4)], "Neutral", GetLayer(self), 'UnvisibleName');
                SetExProp(block, 'PIED_PIPER_Q1_OBJ', 1)
            elseif table.find(two_block_list, pos) > 0 then 
                local block = CREATE_NPC(self, "Stone01", pos_x, pos_y, pos_z, angle_list[IMCRandom(1, 4)], "Neutral", GetLayer(self), 'UnvisibleName');
                SetExProp(block, 'PIED_PIPER_Q1_OBJ', 1)
            else
                local angle = angle_list[IMCRandom(1, 4)]
                local arrow = CREATE_NPC(self, "Hiddennpc_move", pos_x, pos_y, pos_z, angle, "Neutral", GetLayer(self), 'UnvisibleName');
                if tonumber(pos) == end_pos then
                    AttachEffect(arrow, 'F_ground008_green', 1.5, 'BOT', 0, 2, 0, 1)
                    SetExProp(arrow, 'END_POS', end_pos)
                else
                    AttachEffect(arrow, 'I_sys_target_arrow', 1.5, 'BOT', 0, 2, 0, 1)
                    SetExProp(arrow, 'ANGLE', angle)
                    if tonumber(pos) == start_pos then
                        AttachEffect(arrow, 'F_ground008', 1.5, 'BOT', 0, 2, 0, 1)
                        local obj = CREATE_MONSTER_EX(self, 'Hiddennpc_move02', pos_x, pos_y, pos_z, angle_list[IMCRandom(1, 4)], 'Neutral', self.Lv, PIED_PIPER_Q1_OBJ_SET);
                        AttachEffect(obj, 'F_light075_yellow_loop', 1, 'BOT', 0, 10, 0, 1)
                        SetExProp(obj, 'END_POS', end_pos)
                        SetExArgObject(obj, "PC", pc_obj)
                        SetExProp(obj, 'PIED_PIPER_Q1_OBJ', 1)
                    end
                end
                SetExProp(arrow, 'PIED_PIPER_Q1_OBJ', 1)
            end
        end
    end

end

function PIED_PIPER_Q1_OBJ_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
    mon.SimpleAI = "JOB_PIED_PIPER_Q1_INIT_AI"
	mon.KDArmor = 999
	mon.FIXMSPD_BM = 32
end

function SCR_PIED_PIPER_Q1_OBJ_MOVE_RUN(self)
    local pc_obj = GetExArgObject(self, "PC")
    local sObj = nil
    if pc_obj ~= nil then
        sObj = GetSessionObject(pc_obj, "SSN_JOB_PIED_PIPER_Q1")
    end

    if sObj ~= nil then
        local x, y, z = GetPos(self)
        local list, cnt = SelectObjectPos(self, x, y, z, 10, "ALL")
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName == "Hiddennpc_move" then
                    local end_pos = GetExProp(self, 'END_POS')
                    local end_pos_check = GetExProp(list[i], 'END_POS')
                    if end_pos_check ~= 0 and end_pos == end_pos_check then
                        local before_point = sObj.QuestInfoValue1
                        if self.NumArg1 == 0 then
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                            self.NumArg1 = self.NumArg1 + 1
                        end
                        if SCR_JOB_PIED_PIPER_Q1_REW3_CHECK(pc_obj) == 'YES' and sObj.Step3 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
                            sObj.Step3 = 1
                        elseif SCR_JOB_PIED_PIPER_Q1_REW2_CHECK(pc_obj) == 'YES' and sObj.Step2 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
                            sObj.Step2 = 1
                        elseif SCR_JOB_PIED_PIPER_Q1_REW1_CHECK(pc_obj) == 'YES' and sObj.Step1 == 0 then
                            CustomMongoLog(pc_obj, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
                            sObj.Step1 = 1
                        end
                        SaveSessionObject(pc_obj, sObj)
                        local now_point = sObj.QuestInfoValue1
                        if before_point ~= now_point then
                            local add_point = now_point - before_point
                            SendAddOnMsg(pc_obj, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_PIED_PIPER_Q1_MSG2{add_point}{total_point}", "add_point", add_point, "total_point", now_point), 3)
                        end
                    	local zoneID = GetZoneInstID(self);
                    	local layer = GetLayer(self);
                    	local del_list, del_cnt = GetLayerMonList(zoneID, layer);
                    	if del_cnt > 0 then
                            for j = 1, del_cnt do
                                local obj_check = GetExProp(del_list[j], 'PIED_PIPER_Q1_OBJ')
                                if obj_check == 1 then
                                    DetachEffect(del_list[j], 'I_sys_target_arrow')
                                    Kill(del_list[j])
                                end
                            end
                            
                        end
                        local init_list, init_cnt = GetLayerMonList(zoneID, layer);
                        if init_cnt > 0 then
                            for j = 1, init_cnt do
                                local obj_check = GetExProp(init_list[j], 'PIED_PIPER_Q1_INIT_OBJ')
                                if obj_check == 1 then
                                    RunScript('SCR_JOB_PIED_PIPER_Q1_GIMMICK_SETTING', init_list[j])
                                    return
                                end
                            end
                        end
                    else
                        local angle = GetExProp(list[i], 'ANGLE')
                        local angle_list = {0, 90, 180, 270}
                        local x1, y1, z1 = x, y, z
                        if angle == angle_list[1] then
                            x1 = x1 + 30
                        elseif angle == angle_list[2] then
                            z1 = z1 + 30
                        elseif angle == angle_list[3] then
                            x1 = x1 - 30
                        elseif angle == angle_list[4] then
                            z1 = z1 - 30
                        end
                        local after_list, after_cnt = SelectObjectPos(self, x1, y1, z1, 10, "ALL")
                        if after_cnt > 0 then
                            for j = 1, after_cnt do
                                if after_list[j].ClassName == "Hiddennpc_move" then
                                    local zoneID = GetZoneInstID(self)
                                    if IsValidPos(zoneID, x1, y1, z1) == 'YES' then
                                        MoveEx(self, x1, y1, z1, 1)
                                    end
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
