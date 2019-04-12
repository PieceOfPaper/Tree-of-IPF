function SCR__PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_PLATEPIECES_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_070')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_REMAINS37_3_MAGNET_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_090')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_WELL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_041')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS37_3_WELL_AFTER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'REMAINS37_3_SQ_041')
    if result == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ2_1_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 5 or sObj.Goal7 == 6 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ2_2_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 5 or sObj.Goal7 == 6 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ2_3_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 5 or sObj.Goal7 == 6 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR220_MSETP2_5_OBJ2_4_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        if sObj.Goal7 == 5 or sObj.Goal7 == 6 then
            return 'YES'
        end
    end
    return 'NO'
end