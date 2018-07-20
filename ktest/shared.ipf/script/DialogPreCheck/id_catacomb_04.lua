
function SCR_HT_CATACOMB_04_SKULL_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'CATACOMB_04_SQ_09')
    if result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end
