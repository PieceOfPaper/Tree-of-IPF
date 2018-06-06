function SCR_FARM493_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_3_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
