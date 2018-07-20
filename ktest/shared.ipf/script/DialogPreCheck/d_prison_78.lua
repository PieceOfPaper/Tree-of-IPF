
function SCR_PRISON_78_SQ_OBJ_4_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_78_SQ_OBJ_4_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_78_SQ_OBJ_4_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PRISON_78_OBJ_5_PRE_DIALOG(pc, dialog)
--    print('asdf')
    local result = SCR_QUEST_CHECK(pc, 'PRISON_78_MQ_8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
function SCR_HT_KALEJIMO_PAPER01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON_82_MQ_11')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_1')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_KALEJIMO_PAPER02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON_82_MQ_11')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_1')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_KALEJIMO_PAPER03_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON_82_MQ_11')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_1')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT_KALEJIMO_PAPER04_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON_82_MQ_11')
    local result2 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_1')
    local result3 = SCR_QUEST_CHECK(pc, 'PRISON_78_SQ_2')
    if result1 == 'COMPLETE' and result2 == 'COMPLETE' and result3 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end
