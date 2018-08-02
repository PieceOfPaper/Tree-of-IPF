function SCR_JOB_PIED_PIPER_Q1_PRE_CHECK(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then -- IF TAKE REWARD ALL
        return 'NO'
    else
        return 'YES' -- IF NOT THAT
    end
end


function SCR_JOB_PIED_PIPER_Q1_REW1_CHECK(pc, stepRewardFuncList) --보상아이템 지급 포인트별 사전 체크
    local sObj = GetSessionObject(pc, 'SSN_JOB_PIED_PIPER_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 6 then
            return 'YES'
        end
    end
end


function SCR_JOB_PIED_PIPER_Q1_REW2_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_PIED_PIPER_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 8 then
            return 'YES'
        end
    end
end


function SCR_JOB_PIED_PIPER_Q1_REW3_CHECK(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_PIED_PIPER_Q1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 10 then
            return 'YES'
        end
    end
end

function IS_ENABLED_PIED_PIPER_FLUTING_OCTAVE_3(pc)
    local sObj = GetSessionObject(pc, "ssn_klapeda")
    if sObj == nil then
        return 0;
    end
    
    if sObj.JOB_PIED_PIPER_Q1_SRL == "None" then
        return 0;
    end
    
    local tokenList = TokenizeByChar(sObj.JOB_PIED_PIPER_Q1_SRL, "/");
    local questHash = {};
    for i = 1, #tokenList do
        local token = tonumber(tokenList[i]);
        if token ~= nil then
            questHash[token] = true;
        end
    end
    
    if questHash[1] and questHash[2] and questHash[3] then
        return 1;
    end

    return 0;
end

function IS_ENABLED_PIED_PIPER_FLUTING_OCTAVE(pc, scale, octave, isSharp)
    if octave < 3 then
        return 1;
    else
        return IS_ENABLED_PIED_PIPER_FLUTING_OCTAVE_3(pc);
    end
end
