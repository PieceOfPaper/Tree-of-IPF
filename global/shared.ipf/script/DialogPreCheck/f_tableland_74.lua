function SCR_TABLE74_SUBQ4_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_74_SQ4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end