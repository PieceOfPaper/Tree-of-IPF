

function SCR_SIAULIAI_46_4_BEEHIVE01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_4_MQ_01')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_4_SQ_01')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_4_MEADBARREL_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_4_MQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_4_MEADBOX_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_4_MQ_04')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_4_SQ_02')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI462_HQ2')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI462_HQ2')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI462_HQ2')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
