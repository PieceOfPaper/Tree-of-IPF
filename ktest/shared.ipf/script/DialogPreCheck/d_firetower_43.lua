function SCR_FTOWER43_MQ_03_BOOK_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER43_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end