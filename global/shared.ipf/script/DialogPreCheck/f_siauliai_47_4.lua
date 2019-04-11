
function SCR_FARM47_SCORPIO_TALK_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'FARM47_SCORPIO_STUN');
    if buff ~= nil then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_DEVINEMARK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_GRASS02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_070')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_GRASS01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_DEVINEMARK01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_DEVINEMARK02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_DEVINEMARK03_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_4_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
