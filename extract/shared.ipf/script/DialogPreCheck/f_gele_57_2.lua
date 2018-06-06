function SCR_GELE572_MQ_05_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'GELE572_MQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_GELE572_MQ_07_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'GELE572_MQ_07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_GELE572_MQ_09_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'GELE572_MQ_09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end