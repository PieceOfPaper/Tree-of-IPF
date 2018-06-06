function SCR_LIMSTONE_52_1_CRYSTAL_PIECE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_MQ_4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_LIMESTONE_52_1_MQ_6_CLEAR_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_MQ_6')
    local result2 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_SQ_2')
    if result == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end