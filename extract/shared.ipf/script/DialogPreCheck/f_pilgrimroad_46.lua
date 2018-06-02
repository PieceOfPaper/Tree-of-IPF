function SCR_PILGRIM46_REED_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM46_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM46_FOOD02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM46_SQ_100')
    if result == 'PROGRESS' or result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM46_DRAPELIUN_TALK_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'PILGRIM46_SQ_050_STUN');
    if buff ~= nil then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PALADIN5_TRIGGER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PALADIN5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
