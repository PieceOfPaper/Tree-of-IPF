function SCR_LIMESTONE_52_5_MQ_6_OBJ_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_LIMESTONE_52_5_MQ_6_OBJ_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_LIMESTONE_52_5_MQ_6_ANTIEVIL_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_9')
    if result ~= 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end