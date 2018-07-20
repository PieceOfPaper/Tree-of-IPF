function SCR_CORAL_44_2_SQ_30_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_2_SQ_30')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_44_2_SQ_60_STONE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_2_SQ_60')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_44_2_SQ_90_DARK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_2_SQ_90')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_44_2_SQ_40_EFF_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end

function SCR_CORAL_44_2_SQ_20_LOCK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_2_SQ_20')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end