

function SCR_THORN23_OWL4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN23_Q_17')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN23_OWL5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN23_Q_17')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN23_OWL6_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN23_Q_17')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end