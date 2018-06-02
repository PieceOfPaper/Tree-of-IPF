function SCR_ROKAS31_EQ11_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS31_MS_12')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
