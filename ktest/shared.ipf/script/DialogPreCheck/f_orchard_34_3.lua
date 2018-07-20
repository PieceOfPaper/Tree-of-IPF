function SCR_ORCHARD_34_3_SQ_OBJ_9_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_3_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
