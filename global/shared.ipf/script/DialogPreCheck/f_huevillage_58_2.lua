function SCR_HUEVILLAGE_58_2_MQ02_BUCKET01_PRE_DIALOG(pc, dialog)

    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_2_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_2_MQ03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_2_MQ03')
    if result == 'POSSIBLE' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HUEVILLAGE_58_2_OBELISK_AFTER_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_HUEVILLAGE_58_2_SQ01_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_2_SQ01')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end
