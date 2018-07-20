function SCR_BRACKEN422_SQ_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_06_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_06_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_06_3_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_06_4_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_06_5_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_07_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_08_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ08')
    local quest_ssn = GetSessionObject(pc, 'SSN_BRACKEN42_2_SQ08')
    if result == 'PROGRESS' then
        if quest_ssn.Step1 ~= 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_08_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ08')
    local quest_ssn = GetSessionObject(pc, 'SSN_BRACKEN42_2_SQ08')
    if result == 'PROGRESS' then
        if quest_ssn.Step2 ~= 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_08_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ08')
    local quest_ssn = GetSessionObject(pc, 'SSN_BRACKEN42_2_SQ08')
    if result == 'PROGRESS' then
        if quest_ssn.Step3 ~= 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_08_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ08')
    local quest_ssn = GetSessionObject(pc, 'SSN_BRACKEN42_2_SQ08')
    if result == 'PROGRESS' then
        if quest_ssn.Step4 ~= 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_08_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ08')
    local quest_ssn = GetSessionObject(pc, 'SSN_BRACKEN42_2_SQ08')
    if result == 'PROGRESS' then
        if quest_ssn.Step5 ~= 1 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_BRACKEN422_SQ_11_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_BRACKEN422_SQ_12_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'BRACKEN42_2_SQ12')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'BRACKEN42_2_SQ12_2_ITEM')
        if itemCnt <= 7 then
            return 'YES'
        end
    end
    return 'NO'
end
