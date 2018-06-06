
function SCR_PRISON_81_OBJ_1_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_81_MQ_2')
    if result == 'PROGRESS' or result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_81_OBJ_1_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_81_MQ_2')
    if result == 'PROGRESS' or result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_81_OBJ_1_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_81_MQ_2')
    if result == 'PROGRESS' or result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_81_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_81_MQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
