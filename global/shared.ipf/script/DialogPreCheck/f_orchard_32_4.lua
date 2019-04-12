function SCR_ORCHARD324_RP_1_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD324_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ORCHARD324_BINDIG1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_BINDIG2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_BINDIG3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_EVIL1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_EVIL2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_EVIL3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD324_EVIL4_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_324_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end