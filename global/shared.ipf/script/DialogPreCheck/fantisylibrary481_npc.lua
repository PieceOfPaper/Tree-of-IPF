function SCR_D_FANTASYLIB_48_1_COLLECTION_OBJ_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, 'SSN_COLLECT_310')
    if sObj ~= nil then
        if sObj.Goal1 == 0 then
            return 'YES'
        end
    end
    return 'NO'
end