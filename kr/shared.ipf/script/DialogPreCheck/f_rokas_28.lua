function SCR_ROKAS28_SEAL_TRUE3_PRE_DIALOG(pc, dialog)
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

function SCR_ROKAS28_SEAL_TRUE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS28_QM1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS28_SEAL_FAKE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS28_QM1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

