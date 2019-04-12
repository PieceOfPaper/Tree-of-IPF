function SCR_CORAL_32_1_HIDDEN_TRAP1_PRE_DIALOG(pc, dialog, handle)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_5')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_32_1_HIDDEN_TRAP2_PRE_DIALOG(pc, dialog, handle)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_4')
    local result2 = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_7')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_32_1_CORALPOINT1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_32_1_CORALPOINT2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_32_1_CORALPOINT3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_1_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CORAL_32_1_SQ_6_NPC_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end
