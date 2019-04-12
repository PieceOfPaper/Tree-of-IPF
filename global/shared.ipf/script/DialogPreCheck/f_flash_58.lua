function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_58_GRASS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_58_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_58_PETRIFACTION_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc,'FLASH_58_SQ_050')
    local result2 = SCR_QUEST_CHECK(pc,'FLASH29_1_HQ1')
    if result1 == 'PROGRESS' or result2 == "IMPOSSIBLE" then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_58_GRASS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_58_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH58_HIDDEN_OBJ4_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND28_1_HQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
