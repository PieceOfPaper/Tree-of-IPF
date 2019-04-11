function SCR_ABBEY641_BOX01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_1_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
