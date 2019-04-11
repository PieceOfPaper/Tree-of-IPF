
function SCR_PILGRIM52_TOMB01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_011')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM52_BIGREED_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM52_TOMB01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_060')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_TOMB02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_070')
    if result == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_BAG_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_070')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_SPRING_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_080')
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_081')
    if result == 'POSSIBLE' or result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_POT_GET_PRE_DIALOG(pc, dialog) --??
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_080')
    if result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM52_WATERPOT01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_081')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_WATERPOT01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_081')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_WATERPOT01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_081')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_TOMBSTONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_PILGRIM52_PLACE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_080')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_PLACE02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_080')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_PILGRIM52_PLACE03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM52_SQ_080')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_JOB_2_HOPLITE_ARMOR_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_HOPLITE5')
    if result == 'PROGRESS' then
        local Item_Cnt = GetInvItemCount(pc, "JOB_2_HOPLITE5_ITEM2")
        if Item_Cnt <= 9 then
            return 'YES'
        end
    end
    return 'NO'
end
