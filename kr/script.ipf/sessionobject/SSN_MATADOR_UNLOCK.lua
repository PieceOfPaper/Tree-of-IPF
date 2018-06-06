function SCR_SSN_MATADOR_UNLOCK_BASIC_HOOK(self, sObj)
	SCR_REGISTER_QUEST_PROP_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, "KillMonster", "SCR_MATADOR_UNLOCK_KillMonster", "YES");
	SetTimeSessionObject(self, sObj, 1, 1000, "SSN_MATADOR_UNLOCK_TIME_CHECK")
end
function SCR_CREATE_SSN_MATADOR_UNLOCK(self, sObj)
	SCR_SSN_MATADOR_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_MATADOR_UNLOCK(self, sObj)
	SCR_SSN_MATADOR_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_MATADOR_UNLOCK(self, sObj)
end

function SCR_MATADOR_UNLOCK_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    local zone_Name = GetZoneName(self)
    local item_Drop_cnt = IMCRandom(1, 3)
    if zone_Name == "f_tableland_73" then--HIDDEN_MATADOR_MSTEP3_1
        if sObj.Goal1 == 1 then
            if argObj.ClassName == "Hohen_gulak_blue" then
                local item = GetInvItemCount(self, "HIDDEN_HOHEN_HORN_ITEM1")
                local ran = IMCRandom(1, 1000)
                if item < 6 then
                    sObj.Goal10 = sObj.Goal10 + 1
                    if sObj.Goal10 >= 15 then
                        if item + item_Drop_cnt <= 6 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_HOHEN_HORN_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 6 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 6)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_HOHEN_HORN_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal10 = 0
                        return
                    end
                    if ran <= 58 then
                        if item + item_Drop_cnt <= 6 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_HOHEN_HORN_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 6 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 6)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_HOHEN_HORN_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal10 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR119_MSTEP3_BALLOON_TEXT1", 5)
                end
            end
        end
    elseif zone_Name == "f_remains_40" then--HIDDEN_MATADOR_MSTEP3_3
        if sObj.Goal3 == 2 then
            if argObj.ClassName == "Cockatries" then
                local ran = IMCRandom(1, 1000)
                local item = GetInvItemCount(self, "HIDDEN_MATADOR_MSTEP3_3_ITEM1")
                if item < 10 then
                    sObj.Goal11 = sObj.Goal11 + 1
                    if sObj.Goal11 >= 20 then
                        if item + item_Drop_cnt <= 10 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 10 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 10)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal11 = 0
                        return
                    end
                    if ran <= 170 then
                        if item + item_Drop_cnt <= 10 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 10 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 10)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM1", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal11 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR119_MSTEP3_BALLOON_TEXT4", 5)
                end
            end
        end
    elseif zone_Name == "f_huevillage_58_1" then--HIDDEN_MATADOR_MSTEP3_3
        if sObj.Goal3 == 2 then
            if argObj.ClassName == "Beetow" then
                local ran = IMCRandom(1, 1000)
                local item = GetInvItemCount(self, "HIDDEN_MATADOR_MSTEP3_3_ITEM2")
                if item < 12 then
                    sObj.Goal12 = sObj.Goal12 + 1
                    if sObj.Goal12 >= 25 then
                        if item + item_Drop_cnt <= 12 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM2", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 12 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 12)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM2", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal12 = 0
                        return
                    end
                    if ran <= 100 then
                        if item + item_Drop_cnt <= 12 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM2", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 12 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 12)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM2", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                       sObj.Goal12 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR119_MSTEP3_BALLOON_TEXT2", 5)
                end
            end
        end
    elseif zone_Name == "d_firetower_44" then--HIDDEN_MATADOR_MSTEP3_3
        if sObj.Goal3 == 2 then
            if argObj.ClassName == "minivern" then
                local ran = IMCRandom(1, 1000)
                local item = GetInvItemCount(self, "HIDDEN_MATADOR_MSTEP3_3_ITEM3")
                if item < 15 then
                    sObj.Goal13 = sObj.Goal13 + 1
                    if sObj.Goal13 >= 6 then
                        if item + item_Drop_cnt <= 15 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM3", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 15 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 15)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM3", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal13 = 0
                        return
                    end
                    if ran <= 135 then
                        if item + item_Drop_cnt <= 15 then
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM3", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        elseif item + item_Drop_cnt > 15 then
                            item_Drop_cnt = item_Drop_cnt - ((item + item_Drop_cnt) - 15)
                            RunZombieScript("GIVE_ITEM_TX", self, "HIDDEN_MATADOR_MSTEP3_3_ITEM3", item_Drop_cnt, "Quest_HIDDEN_MATADOR")
                        end
                        sObj.Goal13 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR119_MSTEP3_BALLOON_TEXT3", 5)
                end
            end
        end
    end
end

function SSN_MATADOR_UNLOCK_TIME_CHECK(self, sObj, remainTime)
--    print(sObj.String1, sObj.Step4 )
--    print("sObj.Step5 value : "..sObj.Step5, "sObj.Step6 value : "..sObj.Step6)
    
    if sObj.Step6 >= 1 then
        MATADOR_TIME_CHECK(self, sObj, "String1", "Step6", 5)
    end
    
    if sObj.Step5 >= 1 then
        MATADOR_TIME_CHECK(self, sObj, "String2", "Step5", 5)
    end
    
    if sObj.Step7 >= 1 then
        MATADOR_TIME_CHECK(self, sObj, "String3", "Step7", 5)
    end
--    if sObj.Step1 < 1 then
--        print(sObj.Step1.." step3_1 ing")
--    else
--        print(sObj.Step1.." step3_1 Done")
--    end
--    if sObj.Step2 < 1 then
--        print(sObj.Step2.." step3_2 ing")
--    else
--        print(sObj.Step2.." step3_2 Done")
--    end
--        if sObj.Step3 < 1 then
--        print(sObj.Step3.." step3_3 ing")
--    else
--        print(sObj.Step3.." step3_3 Done")
--    end
--    if sObj.Step4 < 1 then
--        print(sObj.Step4.." step3_4 ing")
--    else
--        print(sObj.Step4.." step3_4 Done")
--    end
--    print("--------------------")
end

function MATADOR_TIME_CHECK(self, sObj, _String, _Step, num)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _today = tonumber(year..month..day);
    local _time = tonumber(hour * 60) + tonumber(min);
    
    local string_cut_list = SCR_STRING_CUT(sObj[_String]);
    local _next_time
    if _Step == "Step5" then
        _next_time = num - (sObj.Step9 % 5)
--        print("_next_time : ".._next_time)
    end
    if _Step == "Step6" then
        _next_time = num
    end
    if _Step == "Step7" then
        _next_time = num - (sObj.Step10 % 5)
    end
    if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
        local _last_day = tonumber(string_cut_list[1]);
        local _last_time = tonumber(string_cut_list[2]);
            
        if _last_day ~= _today then
            _last_time = _last_time - 1440;
        end
--        print('BBB', _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
        if _time >= _last_time + _next_time then
             --print(_last_time + _next_time)
             sObj[_Step] = 0
        end
        
    end
end

function MATADOR_TIMETABLE(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local chk1 = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day) % 24  + 1
    local chk2 = math.floor(SCR_DATE_TO_YMIN_BASIC_2000(year, month, day, hour, min) % 1440)
    local chk3
    local chk4
    local chk5
    local chk6
    
    local timetable1 = { 110, 170, 90, 50, 100, 230, 10, 80, 180, 40, 220, 140, 210, 130, 60, 0, 190, 20, 70, 120, 30, 200, 150, 160 }
    local timetable3 = { 440, 360, 300, 270, 250, 390, 430, 260, 290, 380, 340, 420, 240, 460, 470, 370, 410, 280, 310, 350, 320, 330, 400, 450 }
    local timetable5 = { 550, 650, 690, 480, 500, 490, 610, 660, 630, 700, 530, 520, 710, 510, 680, 620, 570, 670, 640, 600, 580, 590, 560, 540 }
    local timetable7 = { 890, 880, 760, 840, 730, 850, 770, 900, 830, 780, 720, 810, 930, 860, 940, 740, 920, 910, 790, 820, 800, 950, 750, 870 }
    local timetable9 = { 1010, 990, 1150, 970, 1190, 1160, 980, 1040, 1070, 1050, 1030, 1120, 1140, 1080, 1100, 1000, 1130, 1060, 1090, 960, 1170, 1180, 1200, 1020 }
    local timetable11 = { 1410, 1240, 1290, 1380, 1200, 1430, 1310, 1330, 1230, 1270, 1400, 1440, 1340, 1210, 1220, 1280, 1350, 1250, 1260, 1300, 1320, 1360, 1370, 1390, 1420 }
    
    --MINERAL_object create time table renew script
    if chk2 < 240 then
        chk3 = timetable1[chk1]
    elseif chk2 >= 240 and chk2 < 480 then
        chk3 = timetable3[chk1]
    elseif chk2 >= 480 and chk2 < 720 then
        chk3 = timetable5[chk1]
    elseif chk2 >= 720 and chk2 < 960 then
        chk3 = timetable7[chk1]
    elseif chk2 >= 960 and chk2 < 1200 then
        chk3 = timetable9[chk1]
    elseif chk2 >= 1200 and chk2 < 1440 then
        chk3 = timetable11[chk1]
    end

    
    if chk3 > chk2 then
        chk5 = math.floor((chk3-chk2)/60).." : "..math.floor((chk3-chk2)%60)
    elseif chk3 < chk2 and chk3 - chk2 > -30 then
        chk5 = "Now Available"
    else
        chk5 = "TimeOver"
    end
    
    Chat(self, "[3-1] "..math.floor(chk3/60).." : "..math.floor(chk3%60).."  //  remaining : "..chk5.."  //", 3)
end