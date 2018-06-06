function SCR_ROKAS26_POPPY_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_SUB_Q03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST01')
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS26_SUB_Q08')
    if result == 'PROGRESS' or result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_SUB_Q12_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_SUB_Q11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_QUEST01_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_QUEST04_STONE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST04')
    local result2 = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST02_AFTER')
    if result1 == 'POSSIBLE' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_QUEST03_STONE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_QUEST05_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_ROKAS26_SUB_Q10_TRIGGER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_SUB_Q10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS26_QUEST01_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS26_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS28_SEAL_FAKE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, '')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS28_SEAL_TRUE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS28_QM1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS28_SEAL_TRUE2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS28_QM1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS28_SEAL_TRUE3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS28_QM1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
