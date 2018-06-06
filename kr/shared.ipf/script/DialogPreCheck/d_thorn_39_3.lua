function SCR_THORN393_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_3_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
