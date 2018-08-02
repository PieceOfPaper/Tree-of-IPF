function SCR_D_STARTOWER_92_MQ_60_TRIGGER_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_60")
    if questCheck2 == "POSSIBLE" or questCheck2 == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_STARTOWER_92_MQ_20_HIDDEN_NPC_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_STARTOWER_92_MQ_20_STARSTONE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end