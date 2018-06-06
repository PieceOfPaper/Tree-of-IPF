function SCR_PRISON621_MQ_04_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON621_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
