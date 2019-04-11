function SCR_FTOWER42_SQ_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER42_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end