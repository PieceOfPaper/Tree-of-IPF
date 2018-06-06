function SCR_CASTLE651_MQ_02_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_02_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_02_3_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_02_4_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_02_5_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_04_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_04_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_04_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_1_MQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE651_MQ_04_4_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_04_5_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE651_MQ_05_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_1_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE651_MQ_05_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_1_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE651_MQ_05_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_1_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE651_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_1_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
