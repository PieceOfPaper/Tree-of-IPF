function SCR_FTOWER45_MQ_05_D_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FTOWER45_MQ_06')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end
