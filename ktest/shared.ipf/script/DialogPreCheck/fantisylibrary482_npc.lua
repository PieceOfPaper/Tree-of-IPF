function SCR_FANTASYLIB482_MQ_3_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB482_MQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FANTASYLIB482_MQ_5_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB482_MQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end