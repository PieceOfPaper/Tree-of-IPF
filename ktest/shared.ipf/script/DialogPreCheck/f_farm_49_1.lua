function SCR_FARM491_MQ_02_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_MQ_02_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_DANDELION_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM491_SQ_04_BUNDLE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM49_1_SQ08_OBJ1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_SQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ1_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ2_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ3_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ4_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ5_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ6_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ7_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ8_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ9_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ10_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ11_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ12_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ13_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ14_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_2_2_OBJ15_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end