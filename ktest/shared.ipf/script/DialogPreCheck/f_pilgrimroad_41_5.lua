function SCR_PILGRIM415_TREE_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_PILGRIM415_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_07_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ06')
    if result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_07_1_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_5_SQ07')
    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
        local list, cnt = SelectObjectByFaction(pc, 150, 'Monster')
        if cnt == 0 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_10_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_10_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_10_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM415_SQ_11_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_5_SQ11')
    if result == 'POSSIBLE' or result == 'PROGRESS'  or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end
