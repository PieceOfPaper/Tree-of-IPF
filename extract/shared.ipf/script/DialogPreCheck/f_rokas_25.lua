
function SCR_ROKAS25_SWITCH4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_REXIPHER5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_SWITCH3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_REXIPHER4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_SWITCH1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_REXIPHER1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_HILDA_STRUCTURE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_FIREWOOD_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_EX2_STRUCTURE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_EX2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_CALDRON2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_CALDRON1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_HILDA_STRUCTURE_TRUE1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_HILDA_STRUCTURE_TRUE2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS25_HILDA_STRUCTURE_TRUE3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

