function SCR_LSCAVE551_SQB_3_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'LSCAVE551_SQB_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_LSCAVE551_SQB_1_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'LSCAVE551_SQB_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
