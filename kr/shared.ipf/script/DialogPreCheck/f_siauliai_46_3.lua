

function SCR_SIAULIAI_46_3_BEEHIVE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_01')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_03')
    if result1 == 'PROGRESS' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_AUSTEJA_ALTAR_01_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_AUSTEJA_ALTAR_02_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_04')
    local result2 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_01')
    if result1 == 'PROGRESS' or result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_SQ_02_KIT_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_MQ_03')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAULIAI_46_3_SQ_04_FARM_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'SIAULIAI_46_3_SQ_04')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ1_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ2_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ3_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ4_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ5_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ6_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ7_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ8_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ9_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ10_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ11_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ12_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ13_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHAR312_MSTEP1_OBJ14_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end
