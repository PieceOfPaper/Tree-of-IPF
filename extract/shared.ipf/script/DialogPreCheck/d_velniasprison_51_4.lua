function SCR_VPRISON514_MQ_02_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_VPRISON514_MQ_02_NPC_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_VPRISON514_MQ_02_NPC_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_VPRISON514_MQ_04_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_VPRISON514_MQ_04_NPC_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_VPRISON514_MQ_04_NPC_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_MQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_VPRISON514_SQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'VPRISON514_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
