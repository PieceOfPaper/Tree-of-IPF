function SCR_THORN392_MQ_05_M_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_2_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN392_SQ_01_P_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_2_SQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN392_SQ_03_M_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_2_SQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN392_SQ07_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_2_SQ05')
    if result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end