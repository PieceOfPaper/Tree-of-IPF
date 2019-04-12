function SCR_BRACKEN631_BAG01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN_63_1_SQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN631_BAG02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN_63_1_SQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN631_BAG03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN_63_1_SQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN631_MEDICAL_PLANT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN_63_1_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PRIEST3_HERB1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST3')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'JOB_2_PRIEST3_ITEM1')
        if itemCnt <= 2 then
            return 'YES'
        end
        return 'NO'
    end
end

function SCR_BRACKEN631_DOG02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN_63_1_MQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_BRACKEN631_RP_1_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'BRACKEN631_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN631_DOG_PRE_DIALOG(pc, dialog)
    return 'NO'
end
