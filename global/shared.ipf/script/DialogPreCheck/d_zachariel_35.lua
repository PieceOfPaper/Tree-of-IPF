function SCR_ZACHA4F_MQ_02_HIDE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ZACHA4F_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA4F_GUARDIAN01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ZACHA4F_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA4F_GUARDIAN02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ZACHA4F_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end