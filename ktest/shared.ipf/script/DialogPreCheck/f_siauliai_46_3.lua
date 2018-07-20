

function SCR_SIAULIAI_46_3_BEEHIVE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_01')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_03')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_AUSTEJA_ALTAR_01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_AUSTEJA_ALTAR_02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_04')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_01')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_SQ_02_KIT_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_SQ_04_FARM_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_04')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
