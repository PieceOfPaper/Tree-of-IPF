function SCR_FLASH64_SQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH64_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH64_SQ_06_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH64_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH64_SQ_07_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH64_SQ_07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH64_MQ_01_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH64_MQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH64_MQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH64_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
