function SCR_C_NUNNERY_NPC1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'TUTO_UPHILL_DEFENSE')
    if result == 'PROGRESS' then
        return 'YES'
    else
    return 'YES'
    end
end

function SCR_REQUEST_MISSION_ABBEY_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'TUTO_SAALUS_NUNNERY')
    if result == 'PROGRESS' then
        return 'YES'
    else
    return 'YES'
    end
end
