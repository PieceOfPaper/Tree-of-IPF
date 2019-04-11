function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_2_HEAL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_2_SQ_010')
    if result == 'POSSIBLE' or result == 'PROGRESS' or result == 'SUCCESS'then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_1_MT02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_020')
    local result2 = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_021')
    if result1 == 'POSSIBLE' and result1 == 'PROGRESS' or result1 == 'SUCCESS' or
        result2 == 'POSSIBLE' or result2 == 'PROGRESS'  then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAINS37_1_KRAUT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_1_KRAUT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAINS37_1_MT01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_010')
    local result2 = SCR_QUEST_CHECK(pc,'REMAINS37_1_SQ_011')
    if result1 == 'POSSIBLE' and result1 == 'PROGRESS' or result1 == 'SUCCESS' or
        result2 == 'POSSIBLE' or result2 == 'PROGRESS'  then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_2_STONES_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_2_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_2_BRANCHES_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_2_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
