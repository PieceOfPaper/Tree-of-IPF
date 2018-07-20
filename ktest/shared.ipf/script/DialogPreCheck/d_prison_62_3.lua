function SCR_PRISON623_SQ_01_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON623_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PRISON623_MQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON623_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
