function SCR_D_STARTOWER_91_BOOKSHELF_01_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_70")
    if questCheck == "COMPLETE" then
        local sessionObjectCheck = GetSessionObject(pc, "SSN_STARTOWER_BOOK_SETTING")
        if sessionObjectCheck ~= nil then
            return "YES"
        end
    end
    return "NO"
end


function SCR_D_STARTOWER_91_BOOKSHELF_02_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_70")
    if questCheck == "COMPLETE" then
        local sessionObjectCheck = GetSessionObject(pc, "SSN_STARTOWER_BOOK_SETTING")
        if sessionObjectCheck ~= nil then
            return "YES"
        end
    end
    return "NO"
end


function SCR_D_STARTOWER_91_BOOKSHELF_03_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_70")
    if questCheck == "COMPLETE" then
        local sessionObjectCheck = GetSessionObject(pc, "SSN_STARTOWER_BOOK_SETTING")
        if sessionObjectCheck ~= nil then
            return "YES"
        end
    end
    return "NO"
end


function SCR_D_STARTOWER_91_BOOKSHELF_04_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_70")
    if questCheck == "COMPLETE" then
        local sessionObjectCheck = GetSessionObject(pc, "SSN_STARTOWER_BOOK_SETTING")
        if sessionObjectCheck ~= nil then
            return "YES"
        end
    end
    return "NO"
end


function SCR_D_STARTOWER_91_BOOKSHELF_05_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_92_MQ_70")
    if questCheck == "COMPLETE" then
        local sessionObjectCheck = GetSessionObject(pc, "SSN_STARTOWER_BOOK_SETTING")
        if sessionObjectCheck ~= nil then
            return "YES"
        end
    end
    return "NO"
end


function SCR_D_STARTOWER_91_1ST_DEFENCE_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_50")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_91_1ST_SUB_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_91_2ND_SUB_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_20")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_91_3RD_SUB_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_30")
    if questCheck == "SUCCESS" then
        return "YES"
    end
    return "NO"
end

function SCR_D_STARTOWER_91_4TH_SUB_DEVICE_01_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_40")
    if questCheck == "PROGRESS" or questCheck2 == "SUCCESS" then
        return "YES"
    end
    return "NO"
end


function SCR_D_STARTOWER_91_4TH_SUB_DEVICE_02_PRE_DIALOG(pc, dialog)
    return "NO"
end


function SCR_D_STARTOWER_91_ELEVATER_CONFIG_DEVICE_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_100")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end


function SCR_STARTOWER_91_MQ_30_NPC_PRE_DIALOG(pc, dialog)
    local questCheck = SCR_QUEST_CHECK(pc, "STARTOWER_91_MQ_30")
    if questCheck == "PROGRESS" then
        return "YES"
    end
    return "NO"
end