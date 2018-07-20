--sObj.Step1 : MSTEP1 progress check , sObj.Step11, sObj.Goal11  : time check
--sObj.Step2, Goal2  : MSTEP2 progress check , sObj.Step12, sObj.Goal12  : time check
--sObj.Step3 : MSTEP3 progress check
--sObj.String1 : fake and finded obj(MSTEP1)
--sObj.String2 : fake and finded obj(MSTEP2)

function PIED_PIPER_TIME_CHECK(self)
  	local time = os.date('*t')
    local month = time['month']
    local day = time['day']
    local hour = time['hour']
    local min = time['min']
    if month < 10 then
        month = tostring("0"..month)
    end
    if day < 10 then
        day = tostring("0"..day)
    end
    if hour < 10 then
        hour = tostring("0"..hour)
    end
    if min < 10 then
        min = tostring("0"..min)
    end
    local today = tostring(month..day)
    local nowtime = tostring((hour * 60) + min)
    return today, nowtime
end

function SCR_SSN_PIED_PIPER_MSTEP_TIME_TABLE(self, sObj)
    local day, time = PIED_PIPER_TIME_CHECK(self)
    local today = tonumber(day)
    local nowtime = tonumber(time)
    local zone = GetZoneName(self)

    --first
    if sObj.Step1 > 0 then
        if sObj.Step11 == 0 and sObj.Goal11 == 0 then
            sObj.Step11= today
            sObj.Goal11 = nowtime
            local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
            SCR_RANDOM_ARRANGE(obj_list)
            for i = 1, 5 do
                if sObj.String1 == nil or sObj.String1 == "None" then
                    sObj.String1 = tostring(obj_list[i])
                else
                    sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                end
            end
        end
    end
    if sObj.Step2 > 0 then
        if sObj.Step12 == 0 and sObj.Goal12 == 0 then
            sObj.Step12 = today
            sObj.Goal12 = nowtime
            local obj_list1 = { 1, 2, 3, 4 }
            local obj_list2 = { 5, 6, 7, 8, 9 }
            local obj_list3 = { 10, 11, 12, 13 }
            SCR_RANDOM_ARRANGE(obj_list1)
            SCR_RANDOM_ARRANGE(obj_list2)
            SCR_RANDOM_ARRANGE(obj_list3)
            local obj_list = { obj_list1, obj_list2, obj_list3 }
            for i = 1, #obj_list do
                table.remove(obj_list[i], 1)
            end
            for i = 1, #obj_list do
                table.remove(obj_list[i], 1)
            end
            for i = 1, #obj_list do
                for j = 1, #obj_list[i] do
                    if sObj.String2 == nil or sObj.String2 == "None" then
                        sObj.String2 = tostring(obj_list[i][j])
                    else
                        sObj.String2 = sObj.String2.."/"..tostring(obj_list[i][j])
                    end
                end
            end
        end
    end

    --later
    if sObj.Step11 ~= 0 and sObj.Goal11 ~= 0 then
        local lastday = sObj.Step11
        local lasttime = sObj.Goal11
        if today == lastday then
            if nowtime - lasttime >= 3 then
                sObj.Step11 = today
                sObj.Goal11 = nowtime
                sObj.String1 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 5 do
                    if sObj.String1 == nil or sObj.String1 == "None" then
                        sObj.String1 = tostring(obj_list[i])
                    else
                        sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                    end
                end
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 3 then
                sObj.Step11 = today
                sObj.Goal11 = nowtime
                sObj.String1 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 5 do
                    if sObj.String1 == nil or sObj.String1 == "None" then
                        sObj.String1 = tostring(obj_list[i])
                    else
                        sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                    end
                end
            end
        end
    end
    if sObj.Step12 ~= 0 and sObj.Goal12 ~= 0 then
        local lastday = sObj.Step12
        local lasttime = sObj.Goal12
        if today == lastday then
            if nowtime - lasttime >= 3 then
                sObj.Step12 = today
                sObj.Goal12 = nowtime
                sObj.String2 = "None"
                local obj_list1 = { 1, 2, 3, 4 }
                local obj_list2 = { 5, 6, 7, 8, 9 }
                local obj_list3 = { 10, 11, 12, 13 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = { obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    for j = 1, #obj_list[i] do
                        if sObj.String2 == nil or sObj.String2 == "None" then
                            sObj.String2 = tostring(obj_list[i][j])
                        else
                            sObj.String2 = sObj.String2.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
                SCR_CHAR312_MSTEP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 3 then
                sObj.Step12 = today
                sObj.Goal12 = nowtime
                sObj.String2 = "None"
                local obj_list1 = { 1, 2, 3, 4 }
                local obj_list2 = { 5, 6, 7, 8, 9 }
                local obj_list3 = { 10, 11, 12, 13 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = { obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    for j = 1, #obj_list[i] do
                        if sObj.String2 == nil or sObj.String2 == "None" then
                            sObj.String2 = tostring(obj_list[i][j])
                        else
                            sObj.String2 = sObj.String2.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
                SCR_CHAR312_MSTEP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        end
    end
    SaveSessionObject(self, sObj)

end

function SCR_SSN_JOB_PIED_PIPER_UNLOCK_BASIC_HOOK(self, sObj)

    RegisterHookMsg(self, sObj, "GetItem", "CHAR312_MSTEP_GetItem", "NO")
    SetTimeSessionObject(self, sObj, 1, 1000, 'SCR_SSN_PIED_PIPER_MSTEP_TIME_TABLE')

end

function SCR_CREATE_SSN_JOB_PIED_PIPER_UNLOCK(self, sObj)
	SCR_SSN_JOB_PIED_PIPER_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_PIED_PIPER_UNLOCK(self, sObj)
	SCR_SSN_JOB_PIED_PIPER_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_JOB_PIED_PIPER_UNLOCK(self, sObj)
end

function CHAR312_MSTEP_GetItem(self, sObj, msg, argObj, giveWay, itemType, itemCount, hookInfo)
    local itemname = GetClassString('Item', itemType, 'ClassName');
    local itemIES = GetClass('Item',itemname)
    if itemIES.ClassName == 'CHAR312_MSTEP1_ITEM1' then
        --MSTEP1
        local max_cnt = 30
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR312_MSTEP1_MSG4"), 3)
        end
    end
end

function SCR_CHAR312_MSTEP2_OBJ_EFFECT_RUN(self, zone, sObj)
    local obj_list = { "CHAR312_MSTEP2_OBJ1", 
                        "CHAR312_MSTEP2_OBJ2",
                        "CHAR312_MSTEP2_OBJ3",
                        "CHAR312_MSTEP2_OBJ4",
                        "CHAR312_MSTEP2_OBJ5",
                        "CHAR312_MSTEP2_OBJ6",
                        "CHAR312_MSTEP2_OBJ7",
                        "CHAR312_MSTEP2_OBJ8",
                        "CHAR312_MSTEP2_OBJ9",
                        "CHAR312_MSTEP2_OBJ10",
                        "CHAR312_MSTEP2_OBJ11",
                        "CHAR312_MSTEP2_OBJ12",
                        "CHAR312_MSTEP2_OBJ13" }
    if zone == "f_coral_32_2" then
        if sObj.Goal2 < 1000 then
            local list, cnt = SelectObject(self, 350, "ALL", 1)
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].ClassName == "noshadow_npc" then
                        for j = 1, #obj_list do
                            local num = 0
                            if "CHAR312_MSTEP2_OBJ"..j == TryGetProp(list[i], "Enter") then
                                num = j
                            end
                            if num ~= 0 then
                                local string_cut_list = SCR_STRING_CUT(sObj.String2);
                                if table.find(string_cut_list, num) <= 0 then
                                    RemoveEffectLocal(list[i], self, "F_ground163_blue_loop")
                                    AddEffectLocal(list[i], self, "F_ground163_blue_loop", 3, 0, "BOT")
                                else
                                    RemoveEffectLocal(list[i], self, "F_ground163_blue_loop")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end