function SCR_BRACKEN421_SQ_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ01')
    if result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_04_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_04_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ04')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'BRACKEN42_1_SQ04_ITEM')
        if itemCnt >= 3 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_06_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_08_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_1_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN421_SQ_08_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end
