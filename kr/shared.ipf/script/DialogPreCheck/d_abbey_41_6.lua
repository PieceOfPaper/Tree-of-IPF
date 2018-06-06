function SCR_ABBEY416_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY41_6_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY416_SQ_09_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY41_6_SQ09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY416_SQ_09_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_ABBEY416_SQ_09_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_ABBEY416_SQ_09_3_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_ABBEY416_SQ_10_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY41_6_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
