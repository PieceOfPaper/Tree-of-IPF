function SCR_WARP_1101_TO_WARP_1102_PRE_DIALOG(pc, dialog, handle)
    local Secret_Item = GetInvItemCount(pc, "VELNIASP54_1_SECRET_KEY11")
    if Secret_Item >= 1 then
        return 'YES' 
    end
    return 'NO'
end

function SCR_WARP_1201_TO_WARP_1202_PRE_DIALOG(pc, dialog, handle)
    local Secret_Item = GetInvItemCount(pc, "VELNIASP54_1_SECRET_KEY12")
    if Secret_Item >= 1 then
        return 'YES'
    end
    return 'NO'
end

function SCR_VELNIAS_TREASURE01_PRE_DIALOG(pc, dialog, handle)
    local Secret_Item = GetInvItemCount(pc, "VELNIASP54_1_SECRET_KEY12")
    if Secret_Item >= 1 then
        return 'YES'
    end
    return 'NO'
end

function SCR_VELNIAS_TREASURE02_PRE_DIALOG(pc, dialog, handle)
    local Secret_Item = GetInvItemCount(pc, "VELNIASP54_1_SECRET_KEY11")
    if Secret_Item >= 1 then
        return 'YES'
    end
    return 'NO'
end
