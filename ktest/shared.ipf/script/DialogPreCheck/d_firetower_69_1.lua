function SCR_FIRETOWER691_MQ_1_NPC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_MQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
