function SCR_JOB_SHADOWMANCER_Q1_PRE_CHECK(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then -- IF TAKE REWARD ALL
        return 'NO'
    else
        return 'YES' -- IF NOT THAT
    end
end


function SCR_JOB_SHADOWMANCER_Q1_REW1_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_Q1')
    if sObj ~= nil then
        if sObj.Goal1 > 60 then
            return 'YES'
        end
    end
end


function SCR_JOB_SHADOWMANCER_Q1_REW2_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_Q1')
    if sObj ~= nil then
        if sObj.Goal1 > 70 then
            return 'YES'
        end
    end
end


function SCR_JOB_SHADOWMANCER_Q1_REW3_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_Q1')
    if sObj ~= nil then
        if sObj.Goal1 > 80 then
            return 'YES'
        end
    end
end