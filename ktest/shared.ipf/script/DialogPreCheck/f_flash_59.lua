function SCR_FLASH59_SQ_03_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH59_SQ_03_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_03')
    local result2 = SCR_QUEST_CHECK(pc,'FLASH59_SQ_05')
    if result == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH59_SQ_03_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH59_SQ_03_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH59_SQ_03_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH59_SQ_08_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH59_SOLDIER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH59_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end






function SCR_FLASH59_SQ_12_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FLASH59_SQ_12')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
