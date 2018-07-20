function SCR_WARP_C_KLAIPE_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end


function SCR_STEAM_TREASURE_EVENT_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end


function SCR_INSTANCE_DUNGEON_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end


function SCR_KLAPEDA_NPC_DAEGIL_CAT_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_KLAPEDA_NPC_CAT_NYAN_01_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_KLAPEDA_KLAPEDA_NPC_12_02_PRE_DIALOG(pc, dialog, handle)
    local sObj = GetSessionObject(pc, "SSN_CATBUTLER_GIMMICK")
    if sObj ~= nil then
        return 'NO'
    else 
        return 'YES'
    end
end


function SCR_HT_KLAPEDA_CAT_01_PRE_DIALOG(pc, dialog, handle)
    local sObj = GetSessionObject(pc, "SSN_CATBUTLER_GIMMICK")
    if sObj ~= nil then
        return 'NO'
    else 
        return 'YES'
    end
end


function SCR_KLAPEDA_NPC_DOG_WANG_01_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_KLAPEDA_NPC_DOG_WANG_02_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_KLAPEDA_NPC_DOG_WANG_03_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end