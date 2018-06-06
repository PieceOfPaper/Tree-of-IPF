function SCR_FLIBRARY484_VIVORA_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB484_MQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end