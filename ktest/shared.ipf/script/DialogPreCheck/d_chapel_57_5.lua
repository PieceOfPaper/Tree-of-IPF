function SCR_CHAPLE575_MQ_06_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE575_MQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end