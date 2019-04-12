function SCR_FTOWER42_MQ_05_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER42_MQ_05')
    local result2 = SCR_QUEST_CHECK(pc, 'FTOWER42_SQ_06')
    if result == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FTOWER41_MQ_02_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER41_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FTOWER41_MQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER41_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
