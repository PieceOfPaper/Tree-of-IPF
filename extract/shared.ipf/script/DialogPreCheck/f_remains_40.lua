function SCR_REMAINS_40_MQ_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_MQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_MQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_MQ_04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_MQ_05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_MQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS40_MQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS_40_HQ_01_TB_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS_40_HQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HIDDEN_TRESURE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'PARTY_Q_081')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'PARTY_Q8_CRYSTAL_FIND') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_HIDDEN_TRESURE02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'PARTY_Q_081')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'PARTY_Q8_CRYSTAL_FIND') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_HIDDEN_TRESURE03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'PARTY_Q_081')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'PARTY_Q8_CRYSTAL_FIND') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_HIDDEN_TRESURE04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'PARTY_Q_081')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'PARTY_Q8_CRYSTAL_FIND') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end
