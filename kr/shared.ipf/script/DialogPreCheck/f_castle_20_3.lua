
function SCR_CASTLE_20_3_OBJ_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_6_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_7_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_6')
    local result3 = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_7')
    
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result2 == 'SUCCESS' or result3 == 'POSSIBLE' or result3 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_9_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_10_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_11_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_12_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_13_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_14_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_15_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_16_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_17_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_18_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_19_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_20_1_PRE_DIALOG(pc, dialog)
--    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_9')
--    if result == 'PROGRESS' then
--        return 'YES'
--    end
    return 'NO'
end

function SCR_CASTLE_20_3_OBJ_20_2_PRE_DIALOG(pc, dialog)
--    local result = SCR_QUEST_CHECK(pc, 'CASTLE_20_3_SQ_9')
--    if result == 'PROGRESS' then
--        return 'YES'
--    end
    return 'NO'
end
