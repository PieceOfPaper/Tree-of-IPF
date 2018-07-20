function SCR_CHATHEDRAL56_MQ01_PAPER_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ01_BOOK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ02_MON_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ03')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'CHATHEDRAL56_MQ03_BUFF') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ05_HINT01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ05_HINT02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ05_HINT03_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ05_HINT04_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ07_HINT01_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ07_HINT02_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ08_RED_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ08_BLUE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ08_YELLOW_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ08_GREEN_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_MQ08_PURPLE_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_MQ08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_SQ02_KILL_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHATHEDRAL56_SQ05_OBJ1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHATHEDRAL56_SQ05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


