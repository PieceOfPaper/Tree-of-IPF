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
    local result = SCR_QUEST_CHECK(pc,'FLASH_58_SQ_050')
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
