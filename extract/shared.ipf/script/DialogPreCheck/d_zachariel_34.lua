function SCR_ZACHA3F_MQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA3F_MQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA3F_POT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA3F_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ZACHA3F_SQ_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA3F_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



