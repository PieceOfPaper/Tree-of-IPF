function SCR_PILGRIM312_SQ_06_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM312_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM312_SQ_01_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM312_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

