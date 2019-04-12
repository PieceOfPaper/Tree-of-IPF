function SCR_D_STARTOWER_89_1ST_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_89_MQ_30")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_89_2ND_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_89_MQ_60")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end