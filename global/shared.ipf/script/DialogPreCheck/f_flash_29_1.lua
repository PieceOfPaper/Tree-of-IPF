function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_29_1_DETECTOR04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_29_1_SQ_020')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_29_1_DETECTOR03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_29_1_SQ_020')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_29_1_DETECTOR01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_29_1_SQ_020')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH_29_1_DETECTOR02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_29_1_SQ_020')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FLASH29_1_SQ_100_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FLASH_29_1_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
