function SCR_D_STARTOWER_88_1ST_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_70")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_1ST_DEFENCE_AFTER_DEVICE_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_D_STARTOWER_88_1ST_DEFENCE_INLAYER_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_70")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_1ST_SUMMON_PORTAL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_20")
    local questCheck2 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_40")
    if questCheck1 == "PROGRESS" then
        return "YES"
    elseif questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_2ND_SUMMON_PORTAL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_20")
    local questCheck2 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_40")
    if questCheck1 == "PROGRESS" then
        return "YES"
    elseif questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_3RD_SUMMON_PORTAL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_20")
    local questCheck2 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_40")
    if questCheck1 == "PROGRESS" then
        return "YES"
    elseif questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_4TH_SUMMON_PORTAL_PRE_DIALOG(pc, dialog)
    local questCheck1 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_20")
    local questCheck2 = SCR_QUEST_CHECK(pc, "STARTOWER_88_MQ_40")
    if questCheck1 == "PROGRESS" then
        return "YES"
    elseif questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_1ST_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_2ND_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_3RD_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_D_STARTOWER_88_VELNIAS_4TH_CONTROL_DEVICE_PRE_DIALOG(pc, dialog)
    return "NO"
end