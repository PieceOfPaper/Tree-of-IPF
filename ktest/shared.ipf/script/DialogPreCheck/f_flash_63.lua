function SCR_FLASH63_SQ_08_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH63_SQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH63_SQ_10_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH63_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH63_SQ_12_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH63_SQ_12')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end




function SCR_FLASH63_SQ_04_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH63_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH63_SQ13_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH63_SQ13')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH63_SQ14_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH63_SQ14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
