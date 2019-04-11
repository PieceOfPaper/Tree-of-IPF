function SCR_ACT2_DISS1_BOX_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ACT2_DISS1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
