

function SCR_SIAULIAI_46_1_ALTAR_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_MQ_02')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_SQ_01')
    if result1 == 'POSSIBLE' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_1_DEADTREE01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_MQ_04')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_SQ_02')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_1_DEADTREE02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_MQ_05')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_1_SQ_03_BAG01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_SQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_1_SQ_03_BAG02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_SQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_1_SQ_03_BAG03_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_1_SQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI46_1_HIDDEN_EVENT_PRE_DIALOG(pc, dialog, handle)
    local obj_list, obj_cnt = SelectObject(pc, 100, "ALL")
    for  i = 1, obj_cnt do
--    print("1111111111111")
        if obj_list[i].ClassName == "stone_monument3" then
--        print("2222222222222")
            if obj_list[i].NumArg2 < 1 then
--                print("33333333", obj_list[i].NumArg2, obj_list[i].ClassName)
                return 'YES'
            elseif obj_list[i].NumArg2 >= 1 then
--                print("4444444")
                return 'YES'
            end
        end
    end
end
