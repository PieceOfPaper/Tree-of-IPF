function SCR_MISSION_CASTLE_DICE_PRE_DIALOG(pc, dialog, handle)
    local sObj = GetSessionObject(pc, 'SSN_MISSION_CASTLE_01_PC')
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'NO'
        end
    end
    return 'YES'
end