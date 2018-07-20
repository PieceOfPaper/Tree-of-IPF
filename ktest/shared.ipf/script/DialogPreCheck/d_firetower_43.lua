function SCR_FTOWER43_MQ_03_BOOK_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER43_MQ_03')
    local result2 = SCR_QUEST_CHECK(pc, 'FIRETOWER_45_HQ_02')
    if result == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end