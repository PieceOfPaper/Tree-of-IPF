
function SCR_PRISON_79_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_6_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result ~= 'IMPOSSIBLE' and result ~= 'POSSIBLE' and result ~= 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_7_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_7_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_7_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_7_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_79_OBJ_7_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_79_MQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
