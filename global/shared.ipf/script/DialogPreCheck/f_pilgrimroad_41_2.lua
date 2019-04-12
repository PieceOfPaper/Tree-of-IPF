function SCR_PILGRIM412_SQ_02_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_2_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM412_SQ_09_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_2_SQ09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
