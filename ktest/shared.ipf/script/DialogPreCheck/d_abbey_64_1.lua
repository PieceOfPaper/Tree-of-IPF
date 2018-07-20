function SCR_ABBEY641_BOX01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_1_SQ030')
    if result == 'PROGRESS' then
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
