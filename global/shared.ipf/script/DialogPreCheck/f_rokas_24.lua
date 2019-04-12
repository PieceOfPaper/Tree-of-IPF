function SCR_ROKAS_24_BEACON_TRIGGER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_KILL1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS_24_RELIC_TRIGGER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_KILL3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_BOX1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_MQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_DEVICE_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_QB_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_DEVICE_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_QB_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_FORSYTHIA_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_QB_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_SUPP_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_QB_15')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS24_MQFLOWER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_MQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_REXIPHER2_BOSS_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_REXIPHER2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ROKAS24_RP_2_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS24_RP_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end