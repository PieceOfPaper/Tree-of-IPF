function SCR_NICO_811_SUBQ022_OBJ_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_2_1')
    local result2 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_2')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_NICO_811_SUBQ022_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_2_1')
    local result2 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_2')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

--NICO_811_SUBQ0241_OBJ
function SCR_NICO_811_SUBQ0241_OBJ_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_4_1')
    local result2 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_4')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_NICO_811_SUBQ0241_OBJ_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_4_1')
    local result2 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_1_SQ_02_4')
    if result1 == 'PROGRESS' then
        return 'YES'
    elseif result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end