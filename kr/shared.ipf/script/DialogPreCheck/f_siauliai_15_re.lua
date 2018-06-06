function SCR_SIAU15RE_MQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU15RE_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_SIAU15RE_MQ_03_NPC_RUN_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU15RE_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU15RE_SQ_02_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU15RE_SQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU15RE_SQ_05_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU15RE_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end