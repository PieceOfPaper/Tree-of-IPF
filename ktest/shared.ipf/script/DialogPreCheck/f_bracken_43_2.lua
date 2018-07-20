function SCR_BRACKEN432_SUBQ1_FLOWER_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ1_BRACKEN_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ1_WATER_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ4_BRACKEN_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ3_MON_A_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ3_MON_B_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN432_SUBQ8_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_2_SQ8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
