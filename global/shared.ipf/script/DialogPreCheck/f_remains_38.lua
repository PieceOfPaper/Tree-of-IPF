function SCR_REMAINS38_RP_1_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS38_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAIN38_SQ_CORPSE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN37_MQ02')
    if result == 'IMPOSSIBLE' or result == 'POSSIBLE' or result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAIN38_MQ07_AFTER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN38_SQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SSN_REMAIN38_MQ07_MON_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN38_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAIN38_SQ06_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc,'REMAIN38_SQ05')
    local result2 = SCR_QUEST_CHECK(pc,'REMAIN38_SQ06')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_SSN_REMAIN38_SQ03_MON_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN38_SQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAIN38_SQ02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAIN38_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end