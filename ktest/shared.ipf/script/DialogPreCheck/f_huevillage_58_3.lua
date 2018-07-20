function SCR_HUEVILLAGE_58_3_MQ01_GRASS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_MQ02_FLOWER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ02')
    local result2 = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_SQ02')
    if result == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_MQ03_DRUM_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_MQ03_DRUM_FAKE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_MQ04_NPC01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_MQ04_NPC02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_MQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_3_SQ01_NPC02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_SQ01')
    if result == 'COMPLETE' then
        return 'NO'
    end
    return 'YES'
end

function SCR_HUEVILLAGE_58_3_SQ01_NPC03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_3_SQ01')
    if result == 'COMPLETE' then
        return 'NO'
    end
    return 'YES'
end
