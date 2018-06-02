function SCR_THORN22_FIREWOOD_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN22_Q_4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN22_FIREWOOD_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN22_Q_4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end