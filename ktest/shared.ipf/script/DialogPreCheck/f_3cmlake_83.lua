function SCR_3CMLAKE_83_OBELISK2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_83_SQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_OBELISK1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_83_SQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_WORKBENCH3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_WORKBENCH1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_MQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_WORKBENCH2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_WORKBENCH1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_83_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_OBJ2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_OBJ2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_OBJ3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_83_OBJ4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_OBJ3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_OBJ4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_HERB2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_SQ_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_HERB1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_MQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_3CMLAKE_84_BUCKET1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_3CMLAKE_84_BUCKET2_PRE_DIALOG(pc, dialog)
--HT
    local result = SCR_QUEST_CHECK(pc, 'F_3CMLAKE_84_MQ_02')
    if result == 'COMPLETE' then
        return 'YES'
    end
--HT
    return 'NO'
end