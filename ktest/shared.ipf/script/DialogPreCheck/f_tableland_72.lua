function SCR_TABLE72_GLASS1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_72_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_TABLE72_SUBQ6_ARTIFACT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_72_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end