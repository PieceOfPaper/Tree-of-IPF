function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_PLATEPIECES_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_070')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAINS37_3_MAGNET_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_090')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_WELL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_041')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_WELL_AFTER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_041')
    if result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

