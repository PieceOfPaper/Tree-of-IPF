function SCR_ZACHA2F_SQ_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA2F_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ZACHA33_QUEST04_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA33_QUEST04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA33_QUEST04_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA33_QUEST04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA33_QUEST04_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA33_QUEST04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end