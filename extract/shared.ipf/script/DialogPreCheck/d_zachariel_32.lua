function SCR_ZACHA32_QUEST01_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ZACHA32_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA32_QUEST01_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA32_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA32_QUEST01_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA32_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA32_QUEST01_04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA32_QUEST01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA1F_MQ_01_MON_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA1F_MQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ZACHA32_MQ_04_D_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ZACHA1F_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
