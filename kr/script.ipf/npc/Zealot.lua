function ZEALOT_GIMMICK_GEN(self)
    if self.NumArg4 == 0 then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        local chk1 = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day) % 12  + 1
        local chk2 = hour * 60 + min
        local chk3
        
        local var1, var2
        local type1
        
        if GetZoneName(self) == 'f_coral_32_1' or GetZoneName(self) == 'f_coral_32_2' then
            type1 = 1
        else
            type1 = 2
        end
        
        if type1 == 1 then
            if hour == 0 or hour == 12 then
                var1 = 95
                var2 = 196
            elseif hour == 1 or hour == 13 then
                var1 = 76
                var2 = 124
            elseif hour == 2 or hour == 14 then
                var1 = 3
                var2 = 136
            elseif hour == 3 or hour == 15 then
                var1 = 81
                var2 = 130
            elseif hour == 4 or hour == 16 then
                var1 = 17
                var2 = 139
            elseif hour == 5 or hour == 17 then
                var1 = 95
                var2 = 145
            elseif hour == 6 or hour == 18 then
                var1 = 48
                var2 = 159
            elseif hour == 7 or hour == 19 then
                var1 = 57
                var2 = 199
            elseif hour == 8 or hour == 20 then
                var1 = 7
                var2 = 144
            elseif hour == 9 or hour == 21 then
                var1 = 23
                var2 = 121
            elseif hour == 10 or hour == 22 then
                var1 = 21
                var2 = 178
            else
                var1 = 6
                var2 = 118
            end
        else
            if hour == 0 or hour == 12 then
                var1 = 1
                var2 = 24
            elseif hour == 1 or hour == 13 then
                var1 = 5
                var2 = 23
            elseif hour == 2 or hour == 14 then
                var1 = 8
                var2 = 55
            elseif hour == 3 or hour == 15 then
                var1 = 3
                var2 = 98
            elseif hour == 4 or hour == 16 then
                var1 = 10
                var2 = 78
            elseif hour == 5 or hour == 17 then
                var1 = 57
                var2 = 25
            elseif hour == 6 or hour == 18 then
                var1 = 65
                var2 = 34
            elseif hour == 7 or hour == 19 then
                var1 = 27
                var2 = 67
            elseif hour == 8 or hour == 20 then
                var1 = 88
                var2 = 38
            elseif hour == 9 or hour == 21 then
                var1 = 34
                var2 = 57
            elseif hour == 10 or hour == 22 then
                var1 = 56
                var2 = 26
            else
                var1 = 78
                var2 = 74
            end
        end
        
        chk3 = (year + month*2 + day*3 + (year + (month + var1)*(day+var2))%50)%4
        
        chk3 = hour * 60 + chk3*10
        
        if chk2 == chk3 then
            local timeval = 0
            local mon1
            local mon2
            local mon3
            local mon4
            local mon5
            
            local pos = { { 1377, 225, 19}, { 973, 226, 1187}, { -199, 141, 326 }, { -423, 222, -354 }, { 947, 172, -1234 }, { -1070, -77, -878 }, { -1150, -20, 678 }, { 202, -56, 1481 }, { 964, 29, -846 }, { 361, 17, 1128 }, { 1330, -213, 287 }, { -2172, 53, -615 }, { 1241, 140, 1436 },  { -539, 17, 1895 }, { 206, -120, 997 }, { 407, 729, 337 }, { 1026, 157, -1461 }, { -1749, -77, -838 }, { -1207, -20, -409 }, { -424, 76, 1369 }, { -724, 261, 1122 }, { -1777, 698, 684 }, { 1447, 661, -100 }, { 270, 32, -1717 }, { -1400, 0, -636 } }
            
            if GetZoneName(self) == 'f_coral_32_1' then
                mon1 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[1][1], pos[1][2], pos[1][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon2 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[2][1], pos[2][2], pos[2][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon3 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[3][1], pos[3][2], pos[3][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon4 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[4][1], pos[4][2], pos[4][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon5 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[5][1], pos[5][2], pos[5][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
            elseif GetZoneName(self) == 'f_coral_32_2' then
                timeval = 5
                mon1 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[6][1], pos[6][2], pos[6][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon2 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[7][1], pos[7][2], pos[7][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon3 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[8][1], pos[8][2], pos[8][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon4 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[9][1], pos[9][2], pos[9][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon5 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[10][1], pos[10][2], pos[10][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
            elseif GetZoneName(self) == 'f_maple_25_1' then
                timeval = 10
                mon1 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[11][1], pos[11][2], pos[11][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon2 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[12][1], pos[12][2], pos[12][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon3 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[13][1], pos[13][2], pos[13][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon4 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[14][1], pos[14][2], pos[14][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon5 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[15][1], pos[15][2], pos[15][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
            elseif GetZoneName(self) == 'f_maple_25_2' then
                timeval = 15
                mon1 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[16][1], pos[16][2], pos[16][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon2 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[17][1], pos[17][2], pos[17][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon3 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[18][1], pos[18][2], pos[18][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon4 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[19][1], pos[19][2], pos[19][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon5 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[20][1], pos[20][2], pos[20][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
            elseif GetZoneName(self) == 'f_maple_25_3' then
                timeval = 20
                mon1 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[21][1], pos[21][2], pos[21][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon2 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[22][1], pos[22][2], pos[22][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon3 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[23][1], pos[23][2], pos[23][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon4 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[24][1], pos[24][2], pos[24][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
                mon5 = CREATE_MONSTER_EX(self, 'monument_03_small', pos[25][1], pos[25][2], pos[25][3], -123, 'Neutral', 1, ZEALOT_GIMMICK_SET)
            end
            SetLifeTime(mon1, 1800);
            SetLifeTime(mon2, 1800);
            SetLifeTime(mon3, 1800);
            SetLifeTime(mon4, 1800);
            SetLifeTime(mon5, 1800);
            mon1.NumArg4 = 1+timeval
            mon2.NumArg4 = 2+timeval
            mon3.NumArg4 = 3+timeval
            mon4.NumArg4 = 4+timeval
            mon5.NumArg4 = 5+timeval
            self.NumArg4 = 1
        end
    else
        self.NumArg4 = self.NumArg4 - 1
    end
end

function ZEALOT_GIMMICK_SET(self)
    self.Name = "UnvisibleName"
    self.Dialog = "ZEALOT_GIMMICK_DLG"
	self.BTree = "None";
	self.Tactics = "None";
end

function SCR_ZEALOT_GIMMICK_DLG_DIALOG(self, pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_19')
    if _hidden_prop >= 51 and _hidden_prop <= 60 then
        if _hidden_prop == (self.NumArg4 + 50) then
            ShowBookItem(pc, 'ZEALOT_BOOK2', 1)
            ShowBalloonText(pc, "ZEALOT_STONE_DLG3", 5)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 100)
        else
            local rand = IMCRandom(1, 3)
            if rand == 1 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG4", 5)
            elseif rand == 2 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG5", 5)
            elseif rand == 3 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG6", 5)
            end
        end
    elseif _hidden_prop >= 100 and _hidden_prop < 120 then
        ShowBalloonText(pc, "ZEALOT_STONE_DLG8", 5)
    elseif _hidden_prop >= 120 and _hidden_prop <= 135 then
        if _hidden_prop == (self.NumArg4 + 110) then
            ShowBookItem(pc, 'ZEALOT_BOOK3', 1)
            ShowBalloonText(pc, "ZEALOT_STONE_DLG3", 5)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 200)
        else
            local rand = IMCRandom(1, 3)
            if rand == 1 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG4", 5)
            elseif rand == 2 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG5", 5)
            elseif rand == 3 then
                ShowBalloonText(pc, "ZEALOT_STONE_DLG6", 5)
            end
        end
    elseif _hidden_prop >= 200 and _hidden_prop < 250 then
        ShowBalloonText(pc, "ZEALOT_STONE_DLG8", 5)
    else
        ShowBalloonText(pc, "ZEALOT_STONE_DLG7", 5)
    end
end

function SCR_ZEALOT_GIMMICK_STONE1_DIALOG(self, pc)
    if IS_KOR_TEST_SERVER() then
        return;
    else
        local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_19')
        if _hidden_prop == 0 then
            ShowBookItem(pc, 'ZEALOT_BOOK1', 1)
            ShowBalloonText(pc, "ZEALOT_STONE_DLG2", 5)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 1)
        else
            ShowBookItem(pc, 'ZEALOT_BOOK1', 1)
        end
    end
end

-- 지뢰찾�? ?¸?
function SCR_ZEALOT_QUEST_SETTING(self, sObj, num, x, y, z, reward)
    sObj.Step1 = 1 -- ?¸????롿처�
    sObj.Step2 = num*2+7 -- ?????????ª??+ 1 만큼 지??¤?
    sObj.Step3 = num -- ????????????치룿????
    sObj.Step4 = 0 -- ??????? 초기??
    if reward ~= nil then -- reward ???￥값????????´??값으?¿초궿?
        sObj.Step5 = reward
        SaveSessionObject(self, sObj)
    end
    
    --cnt??num(????????°룿줿??? ??ª?? + 최꽠????????? ??ª?
    local cnt = num + 6
    local minelist = {}
    
    for i = 1, cnt do
        minelist[i] = {}
        for j = 1, cnt do
            minelist[i][j] = CREATE_NPC(self, "HiddenTrigger6", x+((i-1)*20), y, z+((j-1)*20), 0, "Neutral", GetLayer(self), 'UnvisibleName');
            AttachEffect(minelist[i][j], 'F_pattern013_ground2_white', 1, 'MID')
            SetExArgObject(self, 'mine_'..i..'_'..j, minelist[i][j])
        end
    end
    
    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG6')..sObj.Step2..ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG7'), 8)
end

-- 지??¸??뮿꽿???
function SCR_ZEALOT_QUEST_POS(self, sObj, num, x, z)
    local x = x - 16
    local z = z - 3
    local x_pc, y_pc, z_pc = GetPos(self)
    local x_index = math.floor(math.abs(x - x_pc) / 20) + 1
    local z_index = math.floor(math.abs(z - z_pc) / 20) + 1
    local zealot_obj = {}
    local mine_cnt = 0
    
    -- num + 최꽠????????? ??ª?
    num = num + 6

    if x_pc < x then
        return;
    end
    
    if z_pc < z then
        return;
    end
    
    -- Step1 = 吏꾪�?????? 0 = ??�옉??�맖, 1 = ??�씠???명똿?? 2 = 吏????�젙?? 3 = ??�뙣
    -- Step2 = ??�씠?꾩뿉 ?곕Ⅸ 吏???�앸?
    -- Step3 = ??�씠??蹂댁??�
    -- Step4 = 泥댄�????????�옄
    -- Step5 = 蹂댁긽以?�빞???깃툒 1 = ??�툒, 2 = 以묎?? 3 = ?곴툒
    -- NumArg1 = ??�옉吏??泥댄�?0, 1�??�щ텇
    -- NumArg2 = 吏??蹂댁?� 泥댄�?0, 1�??�щ텇
    
    if sObj.Step1 == 3 then
        return
    end
    
    -- 지뢰배??받아?¤�
    for x_index = 1, num do
        zealot_obj[x_index] = {}
        for z_index = 1, num do
            zealot_obj[x_index][z_index] = GetExArgObject(self, 'mine_'..x_index..'_'..z_index)
        end
    end
    
    -- 지뢰배�
    if sObj.Step1 == 1 then
        sObj.Step1 = sObj.Step1 + 1
        zealot_obj[x_index][z_index].NumArg1 = 1
        
        for i = 1, sObj.Step2 do
            while 1 do
                local x_mine = IMCRandom(1, num)
                local y_mine = IMCRandom(1, num)
                if zealot_obj[x_mine][y_mine].NumArg1 ~= 1 then
                    if zealot_obj[x_mine][y_mine].NumArg2 ~= 1 then
                        zealot_obj[x_mine][y_mine].NumArg2 = 1
                        break
                    end
                end
            end
        end
        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG8'), 8)
    end
    
    local total_num = (sObj.Step3 + 6) * (sObj.Step3 + 6) - sObj.Step2
    
    -- 吏?�고�?
    if zealot_obj[x_index][z_index].NumArg2 == 1 then -- ?�?�� ????吏?�곕????�뙣泥섎?
        sObj.Step1 = 3
        DetachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_white')
        DetachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_green')
        AttachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_red', 1, 'MID')
        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG5'), 8) -- ?¤?¨처뤊    
    else
        if zealot_obj[x_index][z_index].NumArg3 == 1 then -- ?´?´�???????????´�??ª?��?�?
            mine_cnt = SCR_ZEALOT_QUEST_MINE_CHECK(zealot_obj, num, x_index, z_index)
            Chat(zealot_obj[x_index][z_index], mine_cnt, 5)
        else -- ?꾨땲??�㈃ ??????�뼱�?寃껋?�濡?泥섎?
            zealot_obj[x_index][z_index].NumArg3 = 1
            sObj.Step4 = sObj.Step4 + 1
            mine_cnt = SCR_ZEALOT_QUEST_MINE_CHECK(zealot_obj, num, x_index, z_index)
            DetachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_white')
            AttachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_green', 1, 'MID')
            if mine_cnt ~= 0 then -- ?¸�?지????¼�??ª??출력
                Chat(zealot_obj[x_index][z_index], mine_cnt, 10)
            else -- ?¸�?지????¼�????�??지?¿�?
                SCR_ZEALOT_QUEST_BLANK_CHECK(zealot_obj, num, sObj, x_index, z_index)
            end
            SendAddOnMsg(self, 'NOTICE_Dm_scroll', sObj.Step4..' / '..total_num..ScpArgMsg('JOB_ZEALOT_QUEST_COSTUME_MSG9'), 8)
        end
    end
end

-- 지??받꽠좌표 ???¸�?칸의 지???ª??검????반환
function SCR_ZEALOT_QUEST_MINE_CHECK(zealot_obj, num, x_index, z_index)
    local count = 0
    
    for x_index = x_index-1, x_index+1 do
        if x_index > 0 and x_index < num+1 then
            for z_index = z_index-1, z_index+1 do
                if z_index > 0 and z_index < num+1 then
                    if zealot_obj[x_index][z_index].NumArg2 > 0 then
                        count = count + 1
                    end
                end
            end
        end
    end
    
    return count;
end

-- 지??�? 좌표 ?? ?¸�?칸을 검????걿꽿?¸??????????까꽠검?????
function SCR_ZEALOT_QUEST_BLANK_CHECK(zealot_obj, num, sObj, x_index, z_index)
    for x_index = x_index-1, x_index+1 do
        if x_index > 0 and x_index < num+1 then
            for z_index = z_index-1, z_index+1 do
                if z_index > 0 and z_index < num+1 then
                    if zealot_obj[x_index][z_index].NumArg3 == 0 then
                        zealot_obj[x_index][z_index].NumArg3 = 1 -- ?곌쾬??�줈 蹂�
                        sObj.Step4 = sObj.Step4 + 1
                        mine_cnt = SCR_ZEALOT_QUEST_MINE_CHECK(zealot_obj, num, x_index, z_index)
                        DetachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_white')
                        AttachEffect(zealot_obj[x_index][z_index], 'F_pattern013_ground2_green', 1, 'MID')
                        if mine_cnt > 0 then
                            Chat(zealot_obj[x_index][z_index], mine_cnt, 5)
                        else
                            SCR_ZEALOT_QUEST_BLANK_CHECK(zealot_obj, num, sObj, x_index, z_index)
                        end
                    end
                end
            end
        end
    end
end

function SCR_ZEALOT_QUEST_COSTUME_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function ZEALOT_TIMETABLE(self)
--    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_19')
    local _hidden_prop = 121
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local chk1 = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day) % 12  + 1
    local chk2 = math.floor(SCR_DATE_TO_YMIN_BASIC_2000(year, month, day, hour, min) % 1440)
    local chk3
    local chk4
    local chk5
    local chk6
    local chkpos1 = "Disables"
    local chkpos2 = "Disables"
    
    local timetable1 = { 110, 90, 50, 100, 10, 80, 40, 60, 0, 20, 70, 30 }
    local timetable2 = { 60, 90, 50, 10, 20, 0, 100, 40, 70, 30, 80, 110 }
    
    local timetable3 = { 170, 230, 180, 220, 140, 210, 130, 190, 120, 200, 150, 160 }
    local timetable4 = { 140, 120, 160, 220, 180, 150, 230, 210, 200, 170, 190, 130 }
    
    local timetable5 = { 300, 270, 250, 260, 290, 340, 240, 280, 310, 350, 320, 330 }
    local timetable6 = { 340, 240, 320, 330, 350, 310, 250, 270, 260, 290, 280, 300 }

    local timetable7 = { 440, 360, 390, 430, 380, 420, 460, 470, 370, 410, 400, 450 }
    local timetable8 = { 380, 420, 460, 400, 450, 360, 390, 430, 470, 370, 410, 440 }

    local timetable9 = { 550, 480, 500, 490, 530, 520, 510, 570, 580, 590, 560, 540 }
    local timetable10 = { 530, 520, 510, 570, 590, 560, 540, 580, 550, 480, 500, 490 }
    
    local timetable11 = { 650, 690, 610, 660, 630, 700, 710, 680, 620, 670, 640, 600 }
    local timetable12 = { 700, 710, 680, 620, 670, 640, 600, 650, 690, 610, 660, 630 }

    local timetable13 = { 760, 730, 770, 830, 780, 720, 810, 740, 790, 820, 800, 750 }
    local timetable14 = { 740, 790, 820, 800, 750, 770, 830, 780, 720, 810, 760, 730 }

    local timetable15 = { 890, 880, 840, 850, 900, 930, 860, 940, 920, 910, 950, 870 }
    local timetable16 = { 920, 910, 950, 870, 900, 930, 860, 940, 890, 880, 840, 850 }

    local timetable17 = { 1050, 990, 1000, 980, 1070, 970, 1060, 1010, 1040, 960, 1020, 1030 }
    local timetable18 = { 990, 1050, 970, 1020, 1010, 1000, 1030, 1040, 1070, 980, 1060, 960 }
    
    local timetable19 = { 1150, 1080, 1190, 1160, 1130, 1110, 1180, 1120, 1090, 1100, 1170, 1140 }
    local timetable20 = { 1190, 1150, 1110, 1130, 1080, 1160, 1120, 1140, 1090, 1100, 1170, 1180 }

    local timetable21 = { 1240, 1290, 1200, 1310, 1230, 1270, 1210, 1220, 1280, 1250, 1260, 1300 }
    local timetable22 = { 1220, 1280, 1250, 1260, 1300, 1240, 1290, 1200, 1310, 1230, 1270, 1210 }

    local timetable23 = { 1410, 1380, 1430, 1330, 1400, 1440, 1340, 1350, 1320, 1360, 1370, 1390, 1420 }
    local timetable24 = { 1350, 1320, 1360, 1370, 1390, 1420, 1430, 1410, 1380, 1330, 1400, 1440, 1340 }

    local pos = { { 1377, 225, 19}, { 973, 226, 1187}, { -199, 141, 326 }, { -423, 222, -354 }, { 947, 172, -1234 }, { -1070, -77, -878 }, { -1150, -20, 678 }, { 202, -56, 1481 }, { 964, 29, -846 }, { 361, 17, 1128 }, { 1330, -213, 287 }, { -2172, 53, -615 }, { 1241, 140, 1436 },  { -539, 17, 1895 }, { 206, -120, 997 }, { 407, 729, 337 }, { 1026, 157, -1461 }, { -1749, -77, -838 }, { -1207, -20, -409 }, { -424, 76, 1369 }, { -724, 261, 1122 }, { -1777, 698, 684 }, { 1447, 661, -100 }, { 270, 32, -1717 }, { -1400, 0, -636 } }

    if chk2 < 120 then
        chk3 = timetable1[chk1]
        chk4 = timetable2[chk1]
    elseif chk2 >= 120 and chk2 < 240 then
        chk3 = timetable3[chk1]
        chk4 = timetable4[chk1]
    elseif chk2 >= 240 and chk2 < 360 then
        chk3 = timetable5[chk1]
        chk4 = timetable6[chk1]
    elseif chk2 >= 360 and chk2 < 480 then
        chk3 = timetable7[chk1]
        chk4 = timetable8[chk1]
    elseif chk2 >= 480 and chk2 < 600 then
        chk3 = timetable9[chk1]
        chk4 = timetable10[chk1]
    elseif chk2 >= 600 and chk2 < 720 then
        chk3 = timetable11[chk1]
        chk4 = timetable12[chk1]
    elseif chk2 >= 720 and chk2 < 840 then
        chk3 = timetable13[chk1]
        chk4 = timetable14[chk1]
    elseif chk2 >= 840 and chk2 < 960 then
        chk3 = timetable15[chk1]
        chk4 = timetable16[chk1]
    elseif chk2 >= 960 and chk2 < 1080 then
        chk3 = timetable17[chk1]
        chk4 = timetable18[chk1]
    elseif chk2 >= 1080 and chk2 < 1200 then
        chk3 = timetable19[chk1]
        chk4 = timetable20[chk1]
    elseif chk2 >= 1200 and chk2 < 1320 then
        chk3 = timetable21[chk1]
        chk4 = timetable22[chk1]
    elseif chk2 >= 1320 and chk2 < 1440 then
        chk3 = timetable23[chk1]
        chk4 = timetable24[chk1]
    end

    if chk3 > chk2 then
        chk5 = math.floor((chk3-chk2)/60).." : "..math.floor((chk3-chk2)%60)
    elseif chk3 < chk2 and chk3 - chk2 > -30 then
        chk5 = "Now Available"
    else
        chk5 = "TimeOver"
    end
    
    if chk4 > chk2 then
        chk6 = math.floor((chk4-chk2)/60).." : "..math.floor((chk4-chk2)%60)
    elseif chk4 < chk2 and chk4 - chk2 > -30 then
        chk5 = "Now Available"
    else
        chk6 = "TimeOver"
    end
    
    if _hidden_prop >= 51 and _hidden_prop <= 60 then
        chkpos1 = "( "..pos[_hidden_prop - 50][1]..", "..pos[_hidden_prop - 50][2]..", "..pos[_hidden_prop - 50][3].." )"
    elseif _hidden_prop >= 121 and _hidden_prop <= 135 then
        chkpos2 = "( "..pos[_hidden_prop - 120][1]..", "..pos[_hidden_prop - 120][2]..", "..pos[_hidden_prop - 120][3].." )"
    end
    
    Chat(self, "[3-1] "..math.floor(chk3/60).." : "..math.floor(chk3%60).."  //  remaining : "..chk5.."  //  "..chkpos1, 1)
    Chat(self, "[3-3] "..math.floor(chk4/60).." : "..math.floor(chk4%60).."  //  remaining : "..chk6.."  //  "..chkpos2, 1)
end