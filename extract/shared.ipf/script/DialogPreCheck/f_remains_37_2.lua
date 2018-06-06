function SCR_REMAINS37_2_MT03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_2_SQ_060')
    if result == 'SUCCESS' or result == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_2_BUSH_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_2_SQ_050')
    if result == 'PROGRESS' then
        local invent = GetInvItemCount(pc, 'REMAINS37_2_SQ_050_ITEM_1')
        if invent < 6 then
            return 'YES'
        end
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
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_WELL_AFTER')
    if result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
