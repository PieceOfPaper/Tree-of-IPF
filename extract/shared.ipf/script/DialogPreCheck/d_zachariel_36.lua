function SCR_ZACHA36_POT1_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA5F_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ZACHA5F_MQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA5F_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
