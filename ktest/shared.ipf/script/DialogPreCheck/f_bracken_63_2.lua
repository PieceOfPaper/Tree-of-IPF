function SCR_BRACKEN632_TRACES01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_OBJECT06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_SEARCH01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_TRACES_SEARCH02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN632_MEDICAL_PLANT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PRIEST3_HERB2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST3')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'JOB_2_PRIEST3_ITEM2')
        if itemCnt <= 2 then
            return 'YES'
        end
        return 'NO'
    end
end
