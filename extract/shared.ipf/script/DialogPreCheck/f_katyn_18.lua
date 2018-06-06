function SCR_MON_KATYN18_HID_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN18_MQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN18_EMPTY_OWL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN18_MQ_13')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN18_MQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN18_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end