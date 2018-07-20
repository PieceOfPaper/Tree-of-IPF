function SCR_PRISON621_MQ_04_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON621_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_PRISON62_1_PAPER01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON623_MQ_07')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_01')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_02')
    local result4 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_04')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' and result4 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_PRISON62_1_PAPER02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON623_MQ_07')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_01')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_02')
    local result4 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_04')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' and result4 == 'COMPLETE'then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_PRISON62_1_PAPER03_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON623_MQ_07')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_01')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_02')
    local result4 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_04')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' and result4 == 'COMPLETE'then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_PRISON62_1_PAPER04_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON623_MQ_07')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_01')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_02')
    local result4 = SCR_QUEST_CHECK(pc, 'PRISON621_SQ_04')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' and result4 == 'COMPLETE'then
        return 'YES'
    end
    return 'NO'
end
