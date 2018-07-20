function SCR_ORCHARD_34_1_SQ_2_OBJ_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_2_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_2_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_2_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_2_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_2_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_7')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_6_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_7_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_7_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_7_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_10_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_12_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_13_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_14_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_2_OBJ_15_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORCHARD_34_1_SQ_4_MON_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_1_SQ_4')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_1_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_2_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_3_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_4_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_5_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end