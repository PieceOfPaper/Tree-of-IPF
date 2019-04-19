function SCR_NICO812_SUB10_NPC1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_2_SQ_11')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_NICO812_SUB10_NPC2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_2_SQ_11')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_NICO812_SUB10_NPC3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_2_SQ_11')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_NICO812_SUB5_NPC_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'F_NICOPOLIS_81_2_SQ_05')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end