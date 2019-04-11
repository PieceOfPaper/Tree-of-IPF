function SCR_KATYN14_JOHN_SOL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN14_MQ_18')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN14_MQ_05_ITEM_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN14_MQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
