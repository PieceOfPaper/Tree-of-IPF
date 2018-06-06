function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, '')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

