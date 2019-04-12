function SCR_FARM491_MQ_02_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_MQ_02_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_DANDELION_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_SQ_04_BUNDLE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM49_1_SQ08_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
