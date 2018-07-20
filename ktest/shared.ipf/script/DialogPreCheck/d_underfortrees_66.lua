function SCR_UNDER66_KINGDOM_GUADIAN01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_UNDER66_DEAD_KINGDOM_GUADIAN01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_UNDER66_DEAD_KINGDOM_GUADIAN02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_UNDER66_DEAD_KINGDOM_GUADIAN03_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_UNDER66_DEAD_KINGDOM_GUADIAN04_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BOMB_BOX_PRE_DIALOG(pc, dialog, handle)
    local result01 = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ050')
    local result02 = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_66_MQ060')
    if result01 == 'PROGRESS' then
        return 'YES'
    elseif result02 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end




