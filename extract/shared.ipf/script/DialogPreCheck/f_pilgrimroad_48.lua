function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, '')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_48_BOARDPLACE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_48_EXCAVATION01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_48_EXCAVATION03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_070')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM_48_EXCAVATION01_PRE_DIALOG(pc, dialog)
    local item = GetInvItemCount(pc, "PILGRIM_48_SQ_040_ITEM_1")
    if item < 1 then
        return 'YES'
    end
    return 'NO'
end

