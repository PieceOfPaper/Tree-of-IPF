function SCR_JOB_ONMYOJI_Q1_PRE_CHECK(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then -- IF TAKE REWARD ALL
        return 'NO'
    else
        return 'YES' -- IF NOT THAT
    end
end


function SCR_JOB_ONMYOJI_Q1_REW1_CHECK(pc, stepRewardFuncList) --보상아이템 지급 포인트별 사전 체크
    local sObj = GetSessionObject(pc, 'SSN_JOB_ONMYOJI_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 > 350 then
            return 'YES'
        end
    end
end


function SCR_JOB_ONMYOJI_Q1_REW2_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_ONMYOJI_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 > 450 then
            return 'YES'
        end
    end
end


function SCR_JOB_ONMYOJI_Q1_REW3_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_ONMYOJI_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 > 550 then
            return 'YES'
        end
    end
end