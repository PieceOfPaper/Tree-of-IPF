function SCR_FARM492_MQ_02_ROOF_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_MQ_02_WOODBOX_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_MQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_MQ_04_FARMER_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_MQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_MQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_MQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_MQ_06_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_FARM492_SQ_03_GRAPE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_SQ03')
    if result == 'PROGRESS' then
            return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_SQ_04_BUSH_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM492_SQ_06_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'FARM49_2_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
