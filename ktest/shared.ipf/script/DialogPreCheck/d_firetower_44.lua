function SCR_FTOWER44_MQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER44_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
