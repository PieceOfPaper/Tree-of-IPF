function SCR_LIMESTONE_52_2_HEALING_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_8')
    local result2 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_SQ_2')
    if result == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end