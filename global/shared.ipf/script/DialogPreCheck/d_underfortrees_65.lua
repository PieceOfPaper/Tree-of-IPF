function SCR_KINGDOM_GUARDIAN01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KINGDOM_GUARDIAN02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KINGDOM_GUARDIAN03_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KINGDOM_GUARDIAN04_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KINGDOM_GUARDIAN05_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_GLASS_MATERIAL_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SETUP_BOOM01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SETUP_BOOM02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_65_MQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
