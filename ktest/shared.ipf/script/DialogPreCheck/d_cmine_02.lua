

function SCR_MINE_2_PURIFY_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_2')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_4')
    if result1 == 'POSSIBLE' or result1 == 'SUCCESS' or result2 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_2_PIPE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_2')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_2_PIPE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_4')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_PURIFY_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_5')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_11')
    if result1 == 'POSSIBLE' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_7_ENERGY_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_7')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_10')
    if result1 == 'POSSIBLE' or result2 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_10_OIL_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_10')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_PURIFY_7_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_14')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_21')
    if result1 == 'POSSIBLE' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_16_PART_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_16')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_2_CRYSTAL_20_PART_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_2_CRYSTAL_20')
    if result1 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end
