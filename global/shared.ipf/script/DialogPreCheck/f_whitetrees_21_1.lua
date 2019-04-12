
function SCR_WTREES_21_1_OBJ_1_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_1_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_1_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_2_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_WTREES_21_1_SQ_2_CORE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_6_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_6_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_6_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_8_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES_21_1_OBJ_8_DUMMY_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'WTREES_21_1_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
