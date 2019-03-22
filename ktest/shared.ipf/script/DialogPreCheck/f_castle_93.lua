function SCR_CASTLE93_NPC_24_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE93_NPC_25_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE93_MONSTER_QUEST_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE93_MAIN05")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end
