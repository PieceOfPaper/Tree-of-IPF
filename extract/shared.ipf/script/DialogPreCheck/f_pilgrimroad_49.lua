function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, '')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_49_STONE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_49_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
