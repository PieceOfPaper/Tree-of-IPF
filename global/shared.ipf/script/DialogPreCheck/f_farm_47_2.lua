
function SCR_FARM47_MAGIC12_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_2_SQ_080')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FARM47_OLD_WOOD_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_2_SQ_030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_MAGIC_FAKE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_2_SQ_060')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM_47_2_TO_VELNIASP511_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end