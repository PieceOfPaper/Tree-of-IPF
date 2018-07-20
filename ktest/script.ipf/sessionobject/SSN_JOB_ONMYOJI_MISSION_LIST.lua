--sObj.Step1 : mission1-1 , sObj.Goal1 : mission1-1 progress check 
--sObj.Step2 : mission1-2 , sObj.Goal2 : mission1-2 progress check , sObj.Step12, sObj.Goal12  : time check
--sObj.Step3 : mission2-1 , sObj.Goal3 : mission2-1 progress check , sObj.Step13, sObj.Goal13  : time check
--sObj.Step4 : mission2-2 , sObj.Goal4 : mission2-2 progress check , sObj.Step14, sObj.Goal14  : time check
--sObj.Step5 : mission3 , sObj.Goal5 : mission3 progress check
--sObj.Step6 : mission4 , sObj.Goal6 : mission4 progress check
--sObj.Step7 : mission5 , sObj.Goal7 : mission5 progress check , sObj.Step17, sObj.Goal17  : time check
--sObj.Step8 : mission6 , sObj.Goal8 : mission6 progress check , sObj.Step18, sObj.Goal18  : time check
--sObj.Step9 : mission7 , sObj.Goal9 : mission7 progress check , sObj.Step19, sObj.Goal19  : time check
--sObj.String1 : fake and finded obj(mission1-2)
--sObj.String2 : fake and finded obj(mission2-1, 2-2)
--sObj.String3 : fake and finded obj(mission5)
--sObj.String4 : fake and finded obj(mission6)
--sObj.String5 : fake obj(mission7)
--sObj.String6 : finded obj(mission7)
function ONMYOJI_TIME_CHECK(self)
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

function SCR_SSN_ONMYOJI_MISSION_TIME_TABLE(self, sObj)
    local day, time = ONMYOJI_TIME_CHECK(self)
    local today = tonumber(day)
    local nowtime = tonumber(time)
    local zone = GetZoneName(self)
    
    --first
    if sObj.Step2 > 0 then
        if sObj.Step12 == 0 and sObj.Goal12 == 0 then
            sObj.Step12 = today
            sObj.Goal12 = nowtime
            local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8 }
            SCR_RANDOM_ARRANGE(obj_list)
            for i = 1, 3 do
                if sObj.String1 == nil or sObj.String1 == "None" then
                    sObj.String1 = tostring(obj_list[i])
                else
                    sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                end
            end
        end
    end
    if sObj.Step3 > 0 then
        if sObj.Step13 == 0 and sObj.Goal13 == 0 then
            sObj.Step13 = today
            sObj.Goal13 = nowtime
            local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
            SCR_RANDOM_ARRANGE(obj_list)
            for i = 1, 9 do
                if sObj.String2 == nil or sObj.String2 == "None" then
                    sObj.String2 = tostring(obj_list[i])
                else
                    sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                end
            end
        end
    end
    if sObj.Step4 > 0 then
        if sObj.Step14 == 0 and sObj.Goal14 == 0 then
            sObj.Step14 = today
            sObj.Goal14 = nowtime
            local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
            SCR_RANDOM_ARRANGE(obj_list)
            for i = 1, 9 do
                if sObj.String2 == nil or sObj.String2 == "None" then
                    sObj.String2 = tostring(obj_list[i])
                else
                    sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                end
            end
        end
    end
    if sObj.Step7 > 0 then
        if sObj.Step17 == 0 and sObj.Goal17 == 0 then
            sObj.Step17 = today
            sObj.Goal17 = nowtime
            local obj_list1 = { 1, 2, 3, 4, 5 }
            local obj_list2 = { 6, 7, 8, 9, 10 }
            local obj_list3 = { 11, 12, 13, 14, 15 }
            SCR_RANDOM_ARRANGE(obj_list1)
            SCR_RANDOM_ARRANGE(obj_list2)
            SCR_RANDOM_ARRANGE(obj_list3)
            local obj_list = { obj_list1, obj_list2, obj_list3 }
            for i = 1, #obj_list do
                for j = 1, 2 do
                    if sObj.String3 == nil or sObj.String3 == "None" then
                        sObj.String3 = tostring(obj_list[i][j])
                    else
                        sObj.String3 = sObj.String3.."/"..tostring(obj_list[i][j])
                    end
                end
            end
        end
    end
    if sObj.Step8 > 0 then
        if sObj.Step18 == 0 and sObj.Goal18 == 0 then
            sObj.Step18 = today
            sObj.Goal18 = nowtime + IMCRandom(5, 10)
            local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
            SCR_RANDOM_ARRANGE(obj_list)
            for i = 1, 10 do
                if sObj.String4 == nil or sObj.String4 == "None" then
                    sObj.String4 = tostring(obj_list[i])
                else
                    sObj.String4 = sObj.String4.."/"..tostring(obj_list[i])
                end
            end
        end
    end
    if sObj.Step9 > 0 then
        if sObj.Step19 == 0 and sObj.Goal19 == 0 then
            sObj.Step19 = today
            sObj.Goal19 = nowtime

            local obj_list1 = { 1, 2, 3 }
            local obj_list2 = { 4, 5, 6 }
            local obj_list3 = { 7, 8, 9 }
            SCR_RANDOM_ARRANGE(obj_list1)
            SCR_RANDOM_ARRANGE(obj_list2)
            SCR_RANDOM_ARRANGE(obj_list3)
            local obj_list = {obj_list1, obj_list2, obj_list3 }
            for i = 1, #obj_list do
                table.remove(obj_list[i], 1)
            end
            for i = 1, #obj_list do
                for j = 1, #obj_list[i] do
                    if sObj.String5 == nil or sObj.String5 == "None" then
                        sObj.String5 = tostring(obj_list[i][j])
                    else
                        sObj.String5 = sObj.String5.."/"..tostring(obj_list[i][j])
                    end
                end
            end
        end
    end

    --later
    if sObj.Step12 ~= 0 then
        local lastday = sObj.Step12
        local lasttime = sObj.Goal12
        if today == lastday then
            if nowtime - lasttime >= 2 then
                sObj.Step12 = today
                sObj.Goal12 = nowtime
                sObj.String1 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 3 do
                    if sObj.String1 == nil or sObj.String1 == "None" then
                        sObj.String1 = tostring(obj_list[i])
                    else
                        sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                    end
                end
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 2 then
                sObj.Step12 = today
                sObj.Goal12 = nowtime
                sObj.String1 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 3 do
                    if sObj.String1 == nil or sObj.String1 == "None" then
                        sObj.String1 = tostring(obj_list[i])
                    else
                        sObj.String1 = sObj.String1.."/"..tostring(obj_list[i])
                    end
                end
            end
        end
    end
    if sObj.Step13 ~= 0 then
        local lastday = sObj.Step13
        local lasttime = sObj.Goal13
        if today == lastday then
            if nowtime - lasttime >= 3 then
                sObj.Step13 = today
                sObj.Goal13 = nowtime
                sObj.String2 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 9 do
                    if sObj.String2 == nil or sObj.String2 == "None" then
                        sObj.String2 = tostring(obj_list[i])
                    else
                        sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 3 then
                sObj.Step13 = today
                sObj.Goal13 = nowtime
                sObj.String2 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 9 do
                    if sObj.String2 == nil or sObj.String2 == "None" then
                        sObj.String2 = tostring(obj_list[i])
                    else
                        sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        end
    end
    if sObj.Step14 ~= 0 then
        local lastday = sObj.Step14
        local lasttime = sObj.Goal14
        if today == lastday then
            if nowtime - lasttime >= 3 then
                sObj.Step14 = today
                sObj.Goal14 = nowtime
                sObj.String2 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 9 do
                    if sObj.String2 == nil or sObj.String2 == "None" then
                        sObj.String2 = tostring(obj_list[i])
                    else
                        sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                    end
                end
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 3 then
                sObj.Step14 = today
                sObj.Goal14 = nowtime
                sObj.String2 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list)
                for i = 1, 9 do
                    if sObj.String2 == nil or sObj.String2 == "None" then
                        sObj.String2 = tostring(obj_list[i])
                    else
                        sObj.String2 = sObj.String2.."/"..tostring(obj_list[i])
                    end
                end
            end
        end
    end
    if sObj.Step17 ~= 0 then
        local lastday = sObj.Step17
        local lasttime = sObj.Goal17
        if today == lastday then
            if nowtime - lasttime >= 5 then
                sObj.Step17 = today
                sObj.Goal17 = nowtime
                sObj.String3 = "None"
                local obj_list1 = { 1, 2, 3, 4, 5 }
                local obj_list2 = { 6, 7, 8, 9, 10 }
                local obj_list3 = { 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = { obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    for j = 1, 2 do
                        if sObj.String3 == nil or sObj.String3 == "None" then
                            sObj.String3 = tostring(obj_list[i][j])
                        else
                            sObj.String3 = sObj.String3.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 5 then
                sObj.Step17 = today
                sObj.Goal17 = nowtime
                sObj.String3 = "None"
                local obj_list1 = { 1, 2, 3, 4, 5 }
                local obj_list2 = { 6, 7, 8, 9, 10 }
                local obj_list3 = { 11, 12, 13, 14, 15 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = { obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    for j = 1, 2 do
                        if sObj.String3 == nil or sObj.String3 == "None" then
                            sObj.String3 = tostring(obj_list[i][j])
                        else
                            sObj.String3 = sObj.String3.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        end
    end
    if sObj.Step18 ~= 0 then
        local lastday = sObj.Step18
        local lasttime = sObj.Goal18
        if today == lastday then
            if nowtime >= lasttime then
                sObj.Step18 = today
                sObj.Goal18 = nowtime + IMCRandom(5, 10)
                sObj.String4 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
                for i = 1, 10 do
                    if sObj.String4 == nil or sObj.String4 == "None" then
                        sObj.String4 = tostring(obj_list[i])
                    else
                        sObj.String4 = sObj.String4.."/"..tostring(obj_list[i])
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        elseif today ~= lastday then
            if (nowtime +1440) >= lasttime then
                sObj.Step18 = today
                sObj.Goal18 = nowtime + IMCRandom(5, 10)
                sObj.String4 = "None"
                local obj_list = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
                for i = 1, 10 do
                    if sObj.String4 == nil or sObj.String4 == "None" then
                        sObj.String4 = tostring(obj_list[i])
                    else
                        sObj.String4 = sObj.String4.."/"..tostring(obj_list[i])
                    end
                end
                SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
            end
        end
    end
    if sObj.Step19 ~= 0 then
        local lastday = sObj.Step19
        local lasttime = sObj.Goal19
        if today == lastday then
            if nowtime - lasttime >= 3 then
                sObj.Step19 = today
                sObj.Goal19 = nowtime
                sObj.String5 = "None"
                sObj.String6 = "None"
                local obj_list1 = { 1, 2, 3 }
                local obj_list2 = { 4, 5, 6 }
                local obj_list3 = { 7, 8, 9 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = {obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    for j = 1, #obj_list[i] do
                        if sObj.String5 == nil or sObj.String5 == "None" then
                            sObj.String5 = tostring(obj_list[i][j])
                        else
                            sObj.String5 = sObj.String5.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
            end
        elseif today ~= lastday then
            if (nowtime +1440) - lasttime >= 3 then
                sObj.Step19 = today
                sObj.Goal19 = nowtime
                sObj.String5 = "None"
                sObj.String6 = "None"
                local obj_list1 = { 1, 2, 3 }
                local obj_list2 = { 4, 5, 6 }
                local obj_list3 = { 7, 8, 9 }
                SCR_RANDOM_ARRANGE(obj_list1)
                SCR_RANDOM_ARRANGE(obj_list2)
                SCR_RANDOM_ARRANGE(obj_list3)
                local obj_list = {obj_list1, obj_list2, obj_list3 }
                for i = 1, #obj_list do
                    table.remove(obj_list[i], 1)
                end
                for i = 1, #obj_list do
                    for j = 1, #obj_list[i] do
                        if sObj.String5 == nil or sObj.String5 == "None" then
                            sObj.String5 = tostring(obj_list[i][j])
                        else
                            sObj.String5 = sObj.String5.."/"..tostring(obj_list[i][j])
                        end
                    end
                end
            end
        end
    end
    SaveSessionObject(self, sObj)
end

function SCR_SSN_JOB_ONMYOJI_MISSION_LIST_BASIC_HOOK(self, sObj)

    RegisterHookMsg(self, sObj, "KillMonster", "CHAR220_MSETP2_KillMonsterItem", "YES")
    RegisterHookMsg(self, sObj, "GetItem", "CHAR220_MSETP2_GetItem", "NO")
    SetTimeSessionObject(self, sObj, 1, 1000, 'SCR_SSN_ONMYOJI_MISSION_TIME_TABLE')

end
function SCR_CREATE_SSN_JOB_ONMYOJI_MISSION_LIST(self, sObj)
	SCR_SSN_JOB_ONMYOJI_MISSION_LIST_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_ONMYOJI_MISSION_LIST(self, sObj)
	SCR_SSN_JOB_ONMYOJI_MISSION_LIST_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_JOB_ONMYOJI_MISSION_LIST(self, sObj)
end

function CHAR220_MSETP2_KillMonsterItem(self, sObj, msg, argObj, argStr, argNum)

    local zone = GetZoneName(self)
    if zone == "d_underfortress_30_2"
        or zone == "f_flash_60"
        or zone == "f_flash_64"
        or zone == "f_tableland_11_1" then
        if sObj.Step1 == 1 then
            --mission1-1
            local max_cnt = 80
            local item1 = 'CHAR220_MSTEP2_1_1_ITEM1'
            local item2 = 'CHAR220_MSTEP2_1_1_ITEM2'
            local inv_item = GetInvItemCount(self, item2)
            if sObj.Goal1 == 1 and inv_item < max_cnt then
                if argObj.ClassName == "saltisdaughter"
                    or argObj.ClassName == "saltisdaughter_mage"
                    or argObj.ClassName == "saltisdaughter_bow"
                    or argObj.ClassName == "saltisdaughter_green"
                    or argObj.ClassName == "saltisdaughter_red"
                    or argObj.ClassName == "saltisdaughter_bow_green"
                    or argObj.ClassName == "saltisdaughter_mage_red" then
                    local give_cnt = IMCRandom(1, 2)
                    RunScript('GIVE_ITEM_TX', self, item1, give_cnt, "CHAR220_MSTEP2_1_1");
                end
            end
        end
    elseif zone == "d_thorn_23" or zone == "f_bracken_42_2" then
        if sObj.Step5 == 1 then
            --mission3
            local max_cnt = 50
            local item1 = 'CHAR220_MSTEP2_3_ITEM1'
            local item2 = 'CHAR220_MSTEP2_3_ITEM2'
            local inv_item = GetInvItemCount(self, item2)
            if sObj.Goal5 == 2 and inv_item < max_cnt then
                if argObj.ClassName == "duckey" then
                    local give_cnt = IMCRandom(1, 2)
                    RunScript('GIVE_ITEM_TX', self, item1, give_cnt, "CHAR220_MSTEP2_3");
                elseif argObj.ClassName == "duckey_red" then
                    local give_cnt = 2
                    RunScript('GIVE_ITEM_TX', self, item1, give_cnt, "CHAR220_MSTEP2_3");
                end
            end
        end
    elseif zone == "f_pilgrimroad_41_3" or zone == "f_pilgrimroad_41_5" then
        if sObj.Step6 == 1 then
            --mission4
            local cnt = 1
            local max_cnt = 102
            local item = 'CHAR220_MSTEP2_4_ITEM1'
            local inv_item = GetInvItemCount(self, item)
            if sObj.Goal6 >= 2 and sObj.Goal6 < max_cnt and inv_item < cnt then
                if argObj.ClassName == "lapasape_mage_brown"
                    or argObj.ClassName == "lapasape_bow_brown" then
                    if sObj.Goal6 < max_cnt then
                        sObj.Goal6 = sObj.Goal6 + 1
                    else
                        sObj.Goal6 = max_cnt
                    end
                    local txt_cnt = { 27, 52, 77 }
                    if sObj.Goal6 == txt_cnt[1] then
                        ShowBalloonText(self, "CHAR220_MSETP2_4_MON_KILL_DLG1", 7)
                    elseif sObj.Goal6 == txt_cnt[2] then
                        ShowBalloonText(self, "CHAR220_MSETP2_4_MON_KILL_DLG2", 7)
                    elseif sObj.Goal6 == txt_cnt[3] then
                        ShowBalloonText(self, "CHAR220_MSETP2_4_MON_KILL_DLG3", 7)
                    end
                    if sObj.Goal6 == max_cnt then
                        local give_cnt = 1
                        if GetInvItemCount(self, item) < cnt then
                            RunScript('GIVE_ITEM_TX', self, item, give_cnt, "CHAR220_MSTEP2_4");
                            ShowBalloonText(self, "CHAR220_MSETP2_4_MON_KILL_DLG4", 7)
                        end
                    end
                    SaveSessionObject(self, sObj)
                end
            end
        end
    end

end

function CHAR220_MSETP2_GetItem(self, sObj, msg, argObj, giveWay, itemType, itemCount, hookInfo)
    local itemname = GetClassString('Item', itemType, 'ClassName');
    local itemIES = GetClass('Item',itemname)
    if itemIES.ClassName == 'CHAR220_MSTEP2_1_1_ITEM2' then
        --mission1-1
        local max_cnt = 80
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_1_1_MSG3"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_1_2_ITEM1' then
        --mission1-2
        local max_cnt = 80
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_1_2_MSG4"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_2_1_ITEM1' then
        --mission2-1
        local max_cnt = 15
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_2_1_MSG4"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_2_2_ITEM1' then
        --mission2-2
        local max_cnt = 15
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_2_2_MSG3"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_3_ITEM2' then
        --mission3
        local max_cnt = 50
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_3_MSG3"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_5_ITEM1' then
        --mission5
        local max_cnt = 15
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_5_MSG4"), 3)
        end
    elseif itemIES.ClassName == 'CHAR220_MSTEP2_6_ITEM2' then
        --mission6
        local max_cnt = 20
        if GetInvItemCount(self, itemIES.ClassName) >= max_cnt then
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_6_MSG5"), 3)
        end
    end
end


function SCR_CHAR220_MSETP2_OBJ_EFFECT_RUN(self, zone, sObj)
    if zone == "f_katyn_13" then
        local obj_list = { "CHAR220_MSETP2_2_1_OBJ1", 
                            "CHAR220_MSETP2_2_1_OBJ2",
                            "CHAR220_MSETP2_2_1_OBJ3",
                            "CHAR220_MSETP2_2_1_OBJ4",
                            "CHAR220_MSETP2_2_1_OBJ5",
                            "CHAR220_MSETP2_2_1_OBJ6",
                            "CHAR220_MSETP2_2_1_OBJ7",
                            "CHAR220_MSETP2_2_1_OBJ8",
                            "CHAR220_MSETP2_2_1_OBJ9",
                            "CHAR220_MSETP2_2_1_OBJ10",
                            "CHAR220_MSETP2_2_1_OBJ11",
                            "CHAR220_MSETP2_2_1_OBJ12",
                            "CHAR220_MSETP2_2_1_OBJ13",
                            "CHAR220_MSETP2_2_1_OBJ14",
                            "CHAR220_MSETP2_2_1_OBJ15" }
        local list, cnt = SelectObject(self, 200, "ALL", 1)
        if cnt >= 1 then
            for i = 1, cnt do
                if list[i].ClassName == "noshadow_npc" then
                    for j = 1, #obj_list do
                        local num = 0
                        if "CHAR220_MSETP2_2_1_OBJ"..j == TryGetProp(list[i], "Dialog") then
                            num = j
                        end
                        if num ~= 0 then
                            local max_cnt = 15
                            if GetInvItemCount(self, 'CHAR220_MSTEP2_2_1_ITEM1') < max_cnt then
                                local string_cut_list = SCR_STRING_CUT(sObj.String2);
                                if table.find(string_cut_list, num) <= 0 then
                                    RemoveEffectLocal(list[i], self, "F_light094_blue_loop2")
                                    AddEffectLocal(list[i], self, "F_light094_blue_loop2", 4, 0, "MID")
                                else
                                    RemoveEffectLocal(list[i], self, "F_light094_blue_loop2")
                                end
                            else
                                RemoveEffectLocal(list[i], self, "F_light094_blue_loop2")
                            end
                        end
                    end
                end
            end
        end
    elseif zone == "f_orchard_34_1" or zone == "f_orchard_34_3" or zone == "f_siauliai_35_1" then
        local obj_list = { "CHAR220_MSETP2_5_OBJ1_1", 
                            "CHAR220_MSETP2_5_OBJ1_2",
                            "CHAR220_MSETP2_5_OBJ1_3",
                            "CHAR220_MSETP2_5_OBJ1_4",
                            "CHAR220_MSETP2_5_OBJ1_5",
                            "CHAR220_MSETP2_5_OBJ1_6",
                            "CHAR220_MSETP2_5_OBJ1_7",
                            "CHAR220_MSETP2_5_OBJ1_8",
                            "CHAR220_MSETP2_5_OBJ1_9",
                            "CHAR220_MSETP2_5_OBJ1_10",
                            "CHAR220_MSETP2_5_OBJ1_11",
                            "CHAR220_MSETP2_5_OBJ1_12",
                            "CHAR220_MSETP2_5_OBJ1_13",
                            "CHAR220_MSETP2_5_OBJ1_14",
                            "CHAR220_MSETP2_5_OBJ1_15" }
        local list, cnt = SelectObject(self, 200, "ALL", 1)
        if cnt >= 1 then
            for i = 1, cnt do
                if list[i].ClassName == "noshadow_npc" then
                    for j = 1, #obj_list do
                        local num = 0
                        if "CHAR220_MSETP2_5_OBJ1_"..j == TryGetProp(list[i], "Dialog") then
                            num = j
                        end
                        if num ~= 0 then
                            local max_cnt = 15
                            if GetInvItemCount(self, 'CHAR220_MSTEP2_5_ITEM1') < max_cnt then
                                local string_cut_list = SCR_STRING_CUT(sObj.String3);
                                if table.find(string_cut_list, num) <= 0 then
                                    RemoveEffectLocal(list[i], self, "F_cleric_AustrasKoks_loop")
                                    AddEffectLocal(list[i], self, "F_cleric_AustrasKoks_loop", 3, 0, "BOT")
                                else
                                    RemoveEffectLocal(list[i], self, "F_cleric_AustrasKoks_loop")
                                end
                            else
                                RemoveEffectLocal(list[i], self, "F_cleric_AustrasKoks_loop")
                            end
                        end
                    end
                end
            end
        end
    end
end