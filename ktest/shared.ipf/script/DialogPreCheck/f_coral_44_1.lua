function SCR_CORAL_44_1_SQ_10_BAG_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_1_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_44_1_SQ_80_CORAL_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_1_SQ_80')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_44_1_SQ_110_REDSTOEN_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_1_SQ_110')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end