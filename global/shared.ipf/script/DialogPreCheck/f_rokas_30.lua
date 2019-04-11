function SCR_ROKAS30_ZACARIEL_SERVANT2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_ZACARIEL_SERVANT1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_SEALDESTROY2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ6_1')
    if result == 'PROGRESS' or result == 'POSSIBLE'then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_SEALDESTROY1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_SAELDEVICE2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_SAELDEVICE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_MQ5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS30_PIPOTI05_TRIGGER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS30_PIPOTI05')
    if result == 'PROGRESS' or result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

