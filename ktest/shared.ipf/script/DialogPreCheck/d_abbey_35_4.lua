function SCR_ABBEY_35_4_SQ_2_FOOD_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ABBEY_35_4_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end