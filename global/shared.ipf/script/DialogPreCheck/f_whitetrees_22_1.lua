function SCR_WTREES221_SUBQ3_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_WTREES221_SUBQ5_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES221_SUBQ8_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ8')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES221_SUBQ_PILLAR1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES221_SUBQ_PILLAR2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_WTREES221_SUBQ_PILLAR3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'WTREES22_1_SQ10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end