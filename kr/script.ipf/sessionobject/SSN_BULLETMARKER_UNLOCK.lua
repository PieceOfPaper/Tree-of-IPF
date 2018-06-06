function SCR_SSN_BULLETMARKER_UNLOCK_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, "AttackMonster", "SSN_BULLETMARKER_ATTACK", "YES")
    RegisterHookMsg(self, sObj, "KillMonster", "SSN_BULLETMARKER_KILL", "YES")
    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_SSN_BULLETMARKER_OBJ_GEN")
end
function SCR_CREATE_SSN_BULLETMARKER_UNLOCK(self, sObj)
	SCR_SSN_BULLETMARKER_UNLOCK_BASIC_HOOK(self, sObj)
    
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
        
    local _now_tiem = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
    local ran = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
    local temp = 0
    local num = 0
    for i = 1, 2 do --10
        local j = 1
        num = IMCRandom(1, #ran)
        sObj['Goal'..ran[num]] = 1
        local zum = ran[num]
--        print("sObj.Goal"..zum.." : "..sObj['Goal'..zum], num)
        for z = 1, #ran do
--            print("sObj.Goal"..zum.." : "..sObj['Goal'..zum], "sObj.Goal"..ran[z].." : "..sObj['Goal'..ran[z]])
            if sObj['Goal'..zum] ~= sObj['Goal'..ran[z]] then
                temp = ran[z]
                ran[j] = temp
                j = j + 1
            end
        end
        table.remove(ran, #ran)
--        print("-------------------------------")
    end
--    for c = 1, 20 do
--        print("sObj.Goal"..c.." : "..sObj['Goal'..c])
--    end
    sObj.String1 = _now_tiem
    sObj.String2 = "ON"
    SaveSessionObject(self, sObj)
end

function SCR_REENTER_SSN_BULLETMARKER_UNLOCK(self, sObj)
	SCR_SSN_BULLETMARKER_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_BULLETMARKER_UNLOCK(self, sObj)
end

function SSN_BULLETMARKER_KILL(self, sObj, Msg, ArgObj, ArgStr, ArgNum)
    local prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char3_18')
    if prop >= 100 then
        if GetZoneName(self) == "f_farm_49_3" then
            if ArgObj.ClassName == "Melatanun" or ArgObj.ClassName == "tree_root_mole_pink" or ArgObj.ClassName == "Carcashu_green" then
                local item = GetInvItemCount(self, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local item2 = GetInvItemCount(self, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if item2 < 150 then
                    if item < 150 then
                        RunScript("GIVE_ITEM_TX", self, "HIDDEN_BULLET_MSTEP3_ITEM2", 1, "Quest_HIDDEN_BULLET")
                    else
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg("HIDDEN_BULLET_MSTEP3_MSGM1"), 5)
                    end
                end
            end
        end
        
        local item1 = GetInvItemCount(self, "HIDDEN_BULLET_MSTEP3_1_ITEM1")
        local item2 = GetInvItemCount(self, "BULLETMARKER_QUEST_SKILL1")
        if item2 < 1 then
            if item1 < 260 then
                if ArgObj.Attribute == 'Ice' then
                    local rnd_min = math.floor(ArgObj.Lv / 200);
                    local rnd_max = math.floor(ArgObj.Lv / 100);
                    
                    if rnd_min >= 2 then
                        rnd_min = 3;
                    elseif rnd_min < 1 then
                        rnd_min = 1;
                    end
                    
                    if rnd_max >= 2 then
                        rnd_max = 4;
                    elseif rnd_max < 1 then
                        rnd_max = 1;
                    end
--                    print(rnd_min, rnd_max)
                    local rnd = IMCRandom(rnd_min, rnd_max)
                    RunScript('GIVE_ITEM_TX', self, 'HIDDEN_BULLET_MSTEP3_1_ITEM1', rnd, "Quest_JOB_DRUID_6_1")
                    
                end
            end
        end
    end
end

function SSN_BULLETMARKER_ATTACK(self, sObj, Msg, ArgObj, ArgStr, ArgNum)
    if ArgObj.ClassName == "Spion_red" then
        if ArgObj.Enter == "HIDDEN_CHAR318_MSETP3_1_MON" then
            if ArgStr == "BULLETMARKER_QUEST_SKILL1" then
                if sObj.Step2 < 1 then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("HIDDEN_CHAR318_MSETP3_3_MSG1"),5)
                    sObj.Step2 = 1
                    SaveSessionObject(self, sObj)
                    if isHideNPC(self, "MSETP3_1_EFF_TACTICS1") == "NO" then
                        HideNPC(self, "MSETP3_1_EFF_TACTICS1")
                    end
                    PlayEffectLocal(ArgObj, self, "F_explosion050_fire_violet",1, "MID")
                    --print("111111")
                else
                    PlayEffect(ArgObj, "F_explosion050_fire_violet",1, "MID")
                end
            end
        end
    elseif ArgObj.ClassName == "Firent" then
        if ArgObj.Enter == "HIDDEN_CHAR318_MSETP3_2_MON" then
            if sObj.Step3 < 1 then
                if ArgStr == "BULLETMARKER_QUEST_SKILL2" then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("HIDDEN_CHAR318_MSETP3_3_MSG2"),5)
                    sObj.Step3 = 1
                    SaveSessionObject(self, sObj)
                    if isHideNPC(self, "MSETP3_1_EFF_TACTICS2") == "NO" then
                        HideNPC(self, "MSETP3_1_EFF_TACTICS2")
                    end
                    PlayEffect(ArgObj, "F_explosion051_fire",1, "MID")
                    --print("222222")
                end
            else
                PlayEffect(ArgObj, "F_explosion051_fire",1, "MID")
            end
        end
    elseif ArgObj.ClassName == "Repusbunny_purple" then
        if ArgObj.Enter == "HIDDEN_CHAR318_MSETP3_3_MON" then
            if sObj.Step4 < 1 then
                if ArgStr == "BULLETMARKER_QUEST_SKILL3" then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("HIDDEN_CHAR318_MSETP3_3_MSG3"),5)
                    sObj.Step4 = 1
                    SaveSessionObject(self, sObj)
                    if isHideNPC(self, "MSETP3_1_EFF_TACTICS3") == "NO" then
                        HideNPC(self, "MSETP3_1_EFF_TACTICS3")
                    end
                    PlayEffect(ArgObj, "F_explosion050_fire_blue",1, "MID")
                    --print("333333")
                end
            else
                PlayEffect(ArgObj, "F_explosion050_fire_blue",1, "MID")
            end
        end
    end
    
    if sObj.Step2 >= 1 and sObj.Step3 >= 1 and sObj.Step4 >= 1 then
        local prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char3_18')
        if prop < 200 then
            SCR_SET_HIDDEN_JOB_PROP(self, 'Char3_18', 200)
            ShowBalloonText(self, "CHAR318_MSTEP3_COMP", 3)
        end
    end
end

function SCR_SSN_BULLETMARKER_OBJ_GEN(self, sObj)
    if sObj.String2 == "ON" then
        if sObj.String3 == "FIND" then
            local now_time = os.date('*t')
            local year = now_time['year']
            local month = now_time['month']
            local day = now_time['day']
            local hour = now_time['hour']
            local min = now_time['min']
            
            local _today = tonumber(year..month..day);
            local _time = tostring(hour * 60) + tostring(min)
            local _now_tiem = tostring(year..month..day).."/"..tostring(hour * 60 + min)
            --print("22222222")
            --sObj.String1= "20171116"
            
            local string_cut_list = SCR_STRING_CUT(sObj.String1);
            local _next_time = 10
            
            if string_cut_list[2] == nil then
                string_cut_list[2] = "0"
            end
            
            if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
                local _last_day = tonumber(string_cut_list[1]);
                local _last_time = tonumber(string_cut_list[2]);
                
                if _last_day ~= _today then
                    _last_time = _last_time - 1440;
                end
                --print('BBB', _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
                --print("(sObj.String1 : "..sObj.String1.." / _now_tiem : ".._now_tiem)
                --print("time : ".._time, "last_time :".._last_time, "next_time : ".._next_time)
                if _time >= _last_time + _next_time then
                    local ran = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
                    local arr = {}
                    local temp = 0
                    local num = 0
                    local count = 0
                    for a = 1, 20 do
                        if sObj['Goal'..a] <= 0 then
                            count = count + 1
                        elseif sObj['Goal'..a] > 0 then
                            local j = 1
                            --print("1111111", sObj['Goal'..a], a)
                            table.insert(arr, ran[a])
                        end
                    end
                    
                    if #arr > 0 then
                        for z = 1, #ran do
                            for x= 1, #arr do
                                if ran[z] == arr[x] then
                                    table.remove(ran, z)
                                end
                            end
                        end
                    end
        --            print(count, #ran)
        --            for r = 1, #ran do
        --                print(ran[r])
        --            end
                    if count > 18 then
                        for i = 1, count - 18 do --10
                            local j = 1
                            num = IMCRandom(1, #ran)
                            sObj['Goal'..ran[num]] = 1
                            local zum = ran[num]
                            for z = 1, #ran do
--                                print("sObj.Goal"..zum.." : "..sObj['Goal'..zum], "sObj.Goal"..ran[z].." : "..sObj['Goal'..ran[z]])
                                if sObj['Goal'..zum] ~= sObj['Goal'..ran[z]] then
                                    temp = ran[z]
                                    ran[j] = temp
                                    j = j + 1
                                end
                            end
                            table.remove(ran, #ran)
        --                    print("-------------------------------")
                        end
                        sObj.String1 = _now_tiem
                        sObj.String3 = "None"
                        SaveSessionObject(self, sObj)
                    end
--                    for c = 1, 20 do
--                        if sObj['Goal'..c] == 1 then
--                            print("sObj.Goal"..c.." : "..sObj['Goal'..c])
--                        end
--                    end
                --end
                end
            end
        end
    end
end

--Test function
function BULLETMARKER_ELECTRICSTONE(self)
    local sObj = GetSessionObject(self, "SSN_BULLETMARKER_UNLOCK")
    local loc = {}
    loc[1] = {142, 128, -1151}
    loc[2] = {638, 80, -993}
    loc[3] = {-389, 127, -1378}
    loc[4] = {745, 80, -591}
    loc[5] = {383, 123, -435}
    loc[6] = {136, 243, -367}
    loc[7] = {1032, 29, -86}
    loc[8] = {770, 80, 272}
    loc[9] = {297, 80, 307}
    loc[10] = {621, 160, 654}
    loc[11] = {391, 80, -123}
    loc[12] = {1195, 80, 628}
    loc[13] = {325, 200, 910}
    loc[14] = {-153, 176, -951}
    loc[15] = {914, 29, -629}
    loc[16] = {148, 80, 468}
    loc[17] = {250, 123, -713}
    loc[18] = {-133, 184, -609}
    loc[19] = {427, 127, -915}
    loc[20] = {1057, 80, 909}
    if sObj ~= nil then
        for c = 1, 20 do
            if sObj['Goal'..c] == 1 then
                Chat(self, "ELECTRICSTONE arr["..c.."] pos : "..loc[c][1].." "..loc[c][2].." "..loc[c][3], 2)
            end
        end
    end
end