function SCR_JOB_MATADOR1_PRE_FUNC(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then
        return 'NO'
    end
    
    return 'YES'
end


--3RANK REWARD FUNC
function SCR_MATADOR1_SUCCESS1(self)
    local sObj = GetSessionObject(self, "SSN_JOB_MATADOR1")
    if sObj.QuestInfoValue1 >= 15 then
        return "YES"
    end
end

--2RANK REWARD FUNC
function SCR_MATADOR1_SUCCESS2(self)
    local sObj = GetSessionObject(self, "SSN_JOB_MATADOR1")
    if sObj.QuestInfoValue1 >= 20 then
        return "YES"
    end
end

--1RANK REWARD FUNC
function SCR_MATADOR1_SUCCESS3(self)
    local sObj = GetSessionObject(self, "SSN_JOB_MATADOR1")
    if sObj.QuestInfoValue1 >= 25 then
        return "YES"
    end
end
