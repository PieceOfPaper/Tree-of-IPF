

function SCR_MINE_3_RESQUE3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_3_RESQUE3')
    if result1 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CMINE6_TO_KATYN7_1_START_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_3_BOSS')
    local result2 = SCR_QUEST_CHECK(pc, 'CMINE6_TO_KATYN7_1')
    if result1 == 'POSSIBLE' or result2 == 'POSSIBLE' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CMINE3_BOSSROOM_OPEN_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'ACT4_MINE3_ENTER')
    if result1 == 'POSSIBLE' or result1 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end
