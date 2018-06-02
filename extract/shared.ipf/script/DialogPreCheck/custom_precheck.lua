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
end

function SCR_JOB_2_HUNTER_4_1_BOX_2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_HUNTER_4_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end

function SCR_JOB_2_HUNTER_4_1_BOX_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_HUNTER_4_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end



function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_2_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_3_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_4_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end

function SCR_JOB_2_PSYCHOKINO_5_1_BOOK_5_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'JOB_2_PSYCHOKINO_5_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
end
