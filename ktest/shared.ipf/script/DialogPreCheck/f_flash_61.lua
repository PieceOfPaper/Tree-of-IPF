


function SCR_FLASH61_SQ_07_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end




function SCR_FLASH61_SQ_09_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_09')
    local result2 = SCR_QUEST_CHECK(pc,'FLASH61_SQ_11')
    if result == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FLASH61_SQ_09_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_09')
    
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH61_SQ_09_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH61_SQ_09_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_FLASH61_SQ_04_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



--
--function SCR_FLASH61_SQ_02_NPC_PRE_DIALOG(pc, dialog)
--    local result = SCR_QUEST_CHECK(pc,'FLASH61_SQ_02')
--    if result == 'PROGRESS' then
--        return 'YES'
--    end
--    return 'NO'
--end
