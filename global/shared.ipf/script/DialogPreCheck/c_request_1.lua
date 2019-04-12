function SCR_MISSIONSHOP_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'TUTO_REQUEST_MISSION')
    if result == 'PROGRESS' then
        return 'YES'
    else
    return 'YES'
    end
end

