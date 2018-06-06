function SCR_GELE574_MQ_04_BOSS_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'GELE574_MQ_04_STUN');
    if buff ~= nil then
        return 'YES'
    end
    return 'NO'
end

function SCR_INSTANCE_DUNGEON_CHAPLE_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'TUTO_INSTANT_DUNGEON')
    if result == 'PROGRESS' then
        return 'YES'
    else
    return 'YES'
    end
end

