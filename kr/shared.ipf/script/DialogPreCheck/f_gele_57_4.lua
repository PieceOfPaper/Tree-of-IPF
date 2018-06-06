function SCR_GELE574_MQ_04_BOSS_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'GELE574_MQ_04_STUN');
    if buff ~= nil then
        return 'YES'
    end
    return 'NO'
end