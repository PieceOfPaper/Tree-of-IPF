function SCR_ABBEY_35_3_VINE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY_35_3_SQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY_35_3_MAGIC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY_35_3_SQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY_35_3_PAPER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY_35_3_SQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end