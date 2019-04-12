function SCR_ABBEY225_SUBQ5_NPC2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'ABBEY22_5_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ABBEY225_SUBQ9_HARUGAL_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end
