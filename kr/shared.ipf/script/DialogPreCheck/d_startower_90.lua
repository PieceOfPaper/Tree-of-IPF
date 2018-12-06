function SCR_D_STARTOWER_90_1ST_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_90_MQ_30")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_2ND_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_89_MQ_70")
    if questCheck == "PROGRESS" or questCheck2 == "SUCCESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_1ST_HIDE_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_90_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_2ND_HIDE_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_90_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_3RD_HIDE_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_90_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_STATUE_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "STARTOWER_89_MQ_50")
    local questCheck2 = SCR_QUEST_CHECK(pc, "STARTOWER_89_MQ_60")
    if questCheck1 == "SUCCESS" then
        return "YES"
    elseif questCheck2 == "POSSIBLE" or questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_90_MQ_HIDDENWALL_PRE_DIALOG(pc, dialog)
    return "NO"
end

function SCR_D_STARTOWER_90_MQ_HIDDENWALL_TRIGGER_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_90_MQ_40")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end