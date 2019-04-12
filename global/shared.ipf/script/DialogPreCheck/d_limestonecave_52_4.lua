function SCR_LIMESTONE_52_4_PORTAL_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_4_MQ_2')
    local result2 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_4_SQ_3')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end