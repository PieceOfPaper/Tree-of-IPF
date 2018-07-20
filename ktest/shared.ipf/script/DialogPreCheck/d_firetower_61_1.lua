function SCR_FD_FTOWER611_TYPE_B_ROAMER_NPC_PRE_DIALOG(pc, dialog, handle)
    local buff = info.GetBuffByName(handle, 'FD_FIRETOWER611_T02_ROMER_CK');
    if buff ~= nil then
        return 'NO'
    end
    return 'YES'
end


function SCR_FIRETOWER691_MQ_5_NPC_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end