function SCR_BRACKEN434_SUBQ1_PAPER_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_4_SQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN434_SUBQ2_ORB_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_4_SQ2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN434_SUB6_PLANT_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_4_SQ5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN434_SUBQ8_STONE_NPC1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_4_SQ8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
