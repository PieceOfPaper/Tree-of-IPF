function SCR_PILGRIM313_SQ_06_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM313_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM313_SQ_04_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM313_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM313_SQ_02_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM313_SQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end