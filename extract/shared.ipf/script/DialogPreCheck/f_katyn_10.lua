

function SCR_KATYN_10_OBJ_01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'KATYN_10_MQ_06')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
