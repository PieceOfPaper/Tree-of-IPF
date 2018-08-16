function SCR_JOB_2_RANGER_3_1_OBJ_STONE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_RANGER_3_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    
    local result2 = SCR_QUEST_CHECK(pc, 'JOB_2_SAPPER_3_1')
    if result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_JOB_2_HUNTER_4_1_BOX_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_HUNTER_4_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_HUNTER_4_1_BOX_2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_HUNTER_4_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_HUNTER_4_1_BOX_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_HUNTER_4_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end



function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_1_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_2_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_3_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_4_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_5_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_PSYCHOKINO1')
    if questCheck1 == 'PROGRESS' or questCheck2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_MIKO_6_1_CMINE_66_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_UNDER_59_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_CASTLE_67_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_UNDER_68_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_STOWER_60_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_VPRISON_54_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_MIKO_6_1_FTOWER_61_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end
