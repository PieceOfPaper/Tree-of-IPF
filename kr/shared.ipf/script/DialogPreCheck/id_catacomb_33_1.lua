function SCR_CATACOMB_33_1_COFFIN_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB_33_1_SQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CATACOMB_33_1_BOX_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB_33_1_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CATACOMB_33_1_BOX_F1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB_33_1_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CATACOMB_33_1_BOX_F2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB_33_1_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CATACOMB_33_1_BOX_F3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CATACOMB_33_1_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end