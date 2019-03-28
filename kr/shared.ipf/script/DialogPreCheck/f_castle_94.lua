function SCR_CASTLE94_NPC_03_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE94_NPC_05_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE94_MAIN05_SHIELD_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE94_NPC_01_PRE_DIALOG(pc, dialog, handle)
    local questCheck1 = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN05")
    local questCheck2 = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN06")
    local questCheck3 = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN07")
    if questCheck1 == "PROGRESS" or questCheck1 == "SUCCESS" then
        return "YES"
    elseif questCheck2 == "POSSIBLE" or questCheck2 == "PROGRESS" or questCheck2 == "SUCCESS" then
        return "YES"
    elseif questCheck3 == "POSSIBLE" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE94_NPC_02_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN07")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE94_NPC_MONUMENT_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE94_NPC_04_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end