function SCR_THORN21_RP_2_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN21_RP_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end