function SCR_SIAULIAI50_BUILD01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_BUILD02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD07_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_FENCE_BUILD07_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_160')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_PLANT_BIGREPRESS_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_180')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI50_PLANT_BIGREPRESS_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_50_1_SQ_180')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT3_SIAULIAI_50_1_SEED_PRE_DIALOG(pc, dialog)
    local ht3_item = GetInvItemCount(pc, 'HT3_SIAULIAI_50_1_SQ_MAN01_ITEM1')    
    if ht3_item ~= 0 then
        return 'YES'
    end
    return 'NO'
end

function SCR_FREE_DUNGEON_SIGN1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'TUTO_FREE_DUNGEON')
    if result == 'PROGRESS' then
        return 'YES'
    else
    return 'YES'
    end
end