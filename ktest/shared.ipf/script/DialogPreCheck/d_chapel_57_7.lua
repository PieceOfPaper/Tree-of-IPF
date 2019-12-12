function SCR_CHAPLE577_MQ_04_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue1 >= quest_ssn.QuestInfoMaxCount1 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAPLE577_MQ_04_2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue2 >= quest_ssn.QuestInfoMaxCount2 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue3 >= quest_ssn.QuestInfoMaxCount3 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_4_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue4 >= quest_ssn.QuestInfoMaxCount4 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_5_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue5 >= quest_ssn.QuestInfoMaxCount5 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_6_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue6 >= quest_ssn.QuestInfoMaxCount6 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_7_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue7 >= quest_ssn.QuestInfoMaxCount7 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end


function SCR_CHAPLE577_MQ_04_8_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE577_MQ_04')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_CHAPLE577_MQ_04')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue8 >= quest_ssn.QuestInfoMaxCount8 then
                return 'NO'
            end
        end
        return 'YES'
    end
    return 'NO'
end

