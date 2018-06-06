

function SCR_SIAULIAI_46_2_GUARDIAN_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_MQ_01_01')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_2_BEETREE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_MQ_01')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_SQ_03')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_2_SEAL_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_MQ_04')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_SQ_02')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_2_SQ_01_NPC_PRE_DIALOG(pc, dialog)
--    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_SQ_01')
--    if result1 == 'PROGRESS' then
        return 'YES'
--    end
--    return 'NO'
end

function SCR_SIAULIAI_46_2_SQ_04_01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_2_SQ_04')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end