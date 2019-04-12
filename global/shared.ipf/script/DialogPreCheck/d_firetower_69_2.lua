
function SCR_FTOWER_69_2_G1_1_BOX_DUMMY_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end

function SCR_FTOWER_69_2_G1_1_BOX_PRE_DIALOG(pc, dialog, handle)
    return 'YES'
end


function SCR_FTOWER_69_2_G2_1_BOX_PRE_DIALOG(pc, dialog, handle)
    local x, y, z = GetPos(pc)
    if y >= 200 then
        return 'YES'
    end
    return 'NO'
end