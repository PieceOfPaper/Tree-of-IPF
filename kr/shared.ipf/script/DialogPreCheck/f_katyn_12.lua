

function SCR_KATYN_12_OBJ_03_1_PRE_DIALOG(pc, dialog)
--    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_12_MQ_07')
--    if result1 == 'PROGRESS' then
--        return 'YES'
--    end
    return 'NO'
end

function SCR_KATYN_12_OBJ_03_2_PRE_DIALOG(pc, dialog)
--    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_12_MQ_07')
--    if result1 == 'PROGRESS' then
--        return 'YES'
--    end
    return 'NO'
end

function SCR_KATYN_12_OBJ_03_3_PRE_DIALOG(pc, dialog)
--    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_12_MQ_07')
--    if result1 == 'PROGRESS' then
--        return 'YES'
--    end
    return 'NO'
end


function SCR_KATYN_10_NPC_03_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_10_NPC_03_2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_10_NPC_03_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_10_NPC_03_4_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_10_NPC_03_5_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_10_NPC_03_6_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_08')
    if result1 == 'PROGRESS' or result1 == 'SUCCESS' or result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end


function SCR_KATYN12_RP_1_OBJ_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN12_RP_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_F_KATYN_12_TOMB_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_12_MQ_10')
    if result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end
