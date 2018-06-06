
function SCR_CASTLE_20_1_OBJ_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_1_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_2_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_2_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_2_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_3_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_5_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_5_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_6_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_6_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE_20_4_OBJ_6_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'CASTLE_20_4_SQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
