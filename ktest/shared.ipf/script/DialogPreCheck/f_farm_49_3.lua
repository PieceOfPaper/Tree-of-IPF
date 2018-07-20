function SCR_FARM493_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_3_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM493_SQ_07_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_3_SQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM493_SQ_08_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_3_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM493_SQ_08_OBJ2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_3_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
