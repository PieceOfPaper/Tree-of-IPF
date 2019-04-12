function SCR_BRACKEN431_SUBQ_START_NPC_PRE_DIALOG(pc, dialog)
    local item_cnt = GetInvItemCount(pc, "BRACKEN431_SUBQ1_ITEM1")
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ1')
    if result == 'IMPOSSIBLE' then
        if item_cnt < 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ1_NPC1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_BRACKEN431_SUBQ4_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ6_NPC1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ6_NPC2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ6_NPC3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ6_NPC4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN431_SUBQ6_SEED_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN43_1_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end