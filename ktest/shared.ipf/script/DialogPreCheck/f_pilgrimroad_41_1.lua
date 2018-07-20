function SCR_PILGRIM411_SQ_02_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_1_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM411_SQ_04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_1_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM411_SQ_08_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_1_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_HT3_PILGRIM41_1_WELLROPE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_1_SQ07')
    if result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end
