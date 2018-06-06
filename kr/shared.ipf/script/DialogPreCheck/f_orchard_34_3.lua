function SCR_ORCHARD_34_3_SQ_OBJ_9_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_34_3_SQ_10')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_6_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_7_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_8_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_9_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ1_10_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end