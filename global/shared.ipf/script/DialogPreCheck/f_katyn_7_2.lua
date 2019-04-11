function SCR_KATYN72_BOSS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN72_MQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN72_CORPSE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN72_MQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
function SCR_KATYN72_RASSFLY_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN72_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN72_GHOST_PRE_DIALOG(pc, dialog)
    return 'NO'
end

