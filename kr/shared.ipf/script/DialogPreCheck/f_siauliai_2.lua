function SCR_ACT2_DISS1_BOX_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ACT2_DISS1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ1_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ2_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ3_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ4_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ5_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ6_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ7_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_1_2_OBJ8_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal2 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end