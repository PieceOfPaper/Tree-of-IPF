function SCR_BRACKEN633_LOSTPAPER01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_LOSTPAPER02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_LOSTPAPER03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_LOSTPAPER04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_LOSTPAPER_FAKE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_JOB_2_PRIEST3_HERB3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST3')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'JOB_2_PRIEST3_ITEM3')
        if itemCnt <= 2 then
            return 'YES'
        end
        return 'NO'
    end
end

function SCR_BRACKEN633_DEVICE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_MQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ02_MAGICSHILDE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ02_MAGICSHILDE02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ02_MAGICSHILDE03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ02_MAGICSHILDE04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ03_BOX01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ03_BOX02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ03_BOX03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ03_BOX04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ030')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN633_SQ04_BOX_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN_63_3_SQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_BRACKEN633_RP_1_OBJ_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN633_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
