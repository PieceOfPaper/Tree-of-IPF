function SCR_ABBEY643_MAGIC_POINT01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_3_SQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end