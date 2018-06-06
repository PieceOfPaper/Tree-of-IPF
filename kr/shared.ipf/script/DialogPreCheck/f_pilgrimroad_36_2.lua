function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, '')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_36_2_MATERIALS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_36_2_SQ_060')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_36_2_SQ_090_DROP_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_36_2_SQ_090')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIMROAD362_HIDDEN_TABLE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIMROAD362_HQ1')
    if result == 'IMPOSSIBLE' then
        return 'YES'
    end
    return 'NO'
end
