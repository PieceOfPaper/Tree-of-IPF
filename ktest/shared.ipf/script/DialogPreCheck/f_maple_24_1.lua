function SCR_F_MAPLE_241_MQ_03_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_F_MAPLE_241_MQ_04_1_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_04_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_F_MAPLE_241_MQ_04_2_OBJ_TRUE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_04_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_F_MAPLE_241_MQ_04_2_OBJ_FAKE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_04_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_F_MAPLE_241_MQ_04_2_OBJ_FAKE2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_04_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_F_MAPLE_241_MQ_04_2_OBJ_FAKE3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_MAPLE_24_1_MQ_04_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
