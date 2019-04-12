function SCR_KATYN_18_RE_SQ_OBJ_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_3_DUMMY_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_3_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_5')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_3_2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_5')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_3_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_5')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_18_RE_SQ_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_18_RE_SQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
