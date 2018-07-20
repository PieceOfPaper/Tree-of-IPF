function SCR_ABBEY22_4_SUBQ4_POT_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'ABBEY22_4_SQ4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ABBEY22_4_SUBQ7_NPC2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'ABBEY22_4_SQ7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end