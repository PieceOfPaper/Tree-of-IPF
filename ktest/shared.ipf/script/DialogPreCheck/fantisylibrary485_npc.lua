function SCR_FANTASYLIB483_MQ_6_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB483_MQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end