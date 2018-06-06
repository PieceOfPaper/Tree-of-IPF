function SCR_VPRISON515_SQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON515_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
