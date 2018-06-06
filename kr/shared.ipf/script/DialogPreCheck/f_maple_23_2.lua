function SCR_MAPLE232_SQ_02_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'MAPLE23_2_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MAPLE232_SQ_04_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'MAPLE23_2_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MAPLE232_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'MAPLE23_2_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MAPLE232_SQ_09_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'MAPLE23_2_SQ09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
