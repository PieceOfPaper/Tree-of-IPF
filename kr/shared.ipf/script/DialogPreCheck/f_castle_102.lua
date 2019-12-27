function SCR_CASTLE102_RAIMA_WHEEL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "CASTLE102_MQ_02")
    local questCheck2 = SCR_QUEST_CHECK(pc, "CASTLE102_MQ_04")
    if questCheck1 == "SUCCESS" or questCheck1 == "COMPLETE" then
        if questCheck2 ~= "SUCCESS" and questCheck2 ~= "COMPLETE" then
            return "YES"
        end
    end
    return "NO"
end


function SCR_CASTLE102_AUSTEJA_01_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "F_CASTLE_99_MQ_07")
    if questCheck1 == "COMPLETE" then
        return "YES"
    end
    return "NO"
end


function SCR_CASTLE102_AUSTEJA_02_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "CASTLE102_MQ_05")
    if questCheck1 == "SUCCESS" or questCheck1 == "COMPLETE" then
        return "YES"
    end
    return "NO"
end


function SCR_CASTLE102_MQ_06_VIVORA_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "CASTLE102_MQ_05")
    if questCheck1 == "SUCCESS" or questCheck1 == "COMPLETE" then
        return "YES"
    end
    return "NO"
end


function SCR_ANOTHER_SPACE_PORTAL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "CASTLE102_MQ_05")
    if questCheck1 == "SUCCESS" or questCheck1 == "COMPLETE" then
        return "YES"
    end
    return "NO"
end