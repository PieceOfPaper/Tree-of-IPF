function SCR_CASTLE95_OBELISK_01_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN02")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_OBELISK_02_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN04")
    if questCheck == "POSSIBLE" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_OBELISK_03_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_OBELISK_01_BROKEN_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_OBELISK_02_BROKEN_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_OBELISK_03_BROKEN_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_OBELISK_04_BROKEN_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_PORTAL_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_01_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_02_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_03_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_BOX_01_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_BOX_02_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_BOX_03_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_BOX_04_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end


function SCR_CASTLE95_SETTING_POINT_04_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end


function SCR_CASTLE95_OBJECT_PRE_DIALOG(pc, dialog, handle)
    local questCheck = SCR_QUEST_CHECK(pc, "CASTLE94_MAIN03")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return 'NO'
end