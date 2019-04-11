function SCR_PILGRIM50_ALTAR_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_020')
    if result == 'PROGRESS' or result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_GHOST_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_020')
    if result == 'PROGRESS' or result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_FLOWER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_ANGRY01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_050')
    if result == 'PROGRESS' or result == 'POSSIBLE' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM50_ANGRY02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_060')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_ANGRY03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_070')
    if result == 'PROGRESS' or result == 'POSSIBLE' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_ALTAR02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_080')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_ALTAR01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_090')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM50_SQ_028_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM50_SQ_028')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

