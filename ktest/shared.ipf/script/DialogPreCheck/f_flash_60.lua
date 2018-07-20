function SCR_FLASH60_SQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH60_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH60_SQ_09_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH60_SQ_09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH60_SQ_06_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH60_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH60_SQ_08_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH60_SQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end