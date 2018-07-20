function SCR_KATYN_SUCH_POINT_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SUCH_POINT_01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_SUCH_POINT_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SUCH_POINT_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_SUCH_POINT_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SUCH_POINT_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_SUCH_POINT_04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SUCH_POINT_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_SUCH_POINT_05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SUCH_POINT_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN7_MQ06_TRACK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'KATYN71_MQ_06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
