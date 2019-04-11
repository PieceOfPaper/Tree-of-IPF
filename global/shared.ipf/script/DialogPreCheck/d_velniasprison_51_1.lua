function SCR_VPRISON511_MQ_04_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON511_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
