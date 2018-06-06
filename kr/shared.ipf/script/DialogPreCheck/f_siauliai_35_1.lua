function SCR_SIAULIAI_35_1_ALCHEMY_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_35_1_ALCHEMY_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_35_1_ALCHEMY_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_35_1_ALCHEMY_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_35_1_ALCHEMY_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI351_HIDDENQ1_PREITEM_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_35_1_SQ_10')
    if result1 == 'COMPLETE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_351_HIDDENQ1_ITEM1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_351_HQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_351_HIDDENQ1_ITEM2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAULIAI_351_HQ1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
