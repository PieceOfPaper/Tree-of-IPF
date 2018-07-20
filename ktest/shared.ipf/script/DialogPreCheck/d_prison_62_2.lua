
function SCR_PRISON622_RP_1_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON622_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
