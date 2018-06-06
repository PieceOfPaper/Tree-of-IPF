function SCR_HUEVILLAGE_58_1_SQ02_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'HUEVILLAGE_58_1_SQ02')
    if result == 'POSSIBLE' or result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end