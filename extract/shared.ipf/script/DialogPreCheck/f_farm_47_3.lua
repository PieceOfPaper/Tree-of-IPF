
function SCR_FARM47_BURY01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_BURY02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_CROPS01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_MAGIC_PLACE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_MAGIC01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_040')
    if result == 'PROGRESS' or result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_MAGIC_PRE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_3_SQ_020')
    if result == 'PROGRESS'  then
        return 'YES'
    end
    return 'NO'
end
