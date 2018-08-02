function SCR_DCAPITAL105_SQ_3_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL105_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL105_SQ_5_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL105_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
