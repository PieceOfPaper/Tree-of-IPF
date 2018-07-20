function SCR_DCAPITAL_20_5_SQ_30_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_30')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL_20_5_SQ_60_CLUE_PRE_DIALOG(pc, dialog, handle)
    local result1 = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_60')
    local result2 = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_70')
    if result1 == 'COMPLET'  then
        if result2 == 'POSSIBLE' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_DCAPITAL_20_5_SQ_90_CLUE_PRE_DIALOG(pc, dialog, handle)
    local result1 = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_90')
    local result2 = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_50')
    if result1 == 'COMPLET'  then
        if result2 == 'POSSIBLE' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_DCAPITAL_20_5_SQ_100_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_5_SQ_100')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end