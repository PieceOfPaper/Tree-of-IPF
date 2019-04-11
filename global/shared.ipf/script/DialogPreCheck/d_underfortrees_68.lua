function SCR_VELNIAS_PLANT_PRE_DIALOG(pc, dialog, handle)
    local result01 = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_68_MQ010')
    if result01 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_UNDER68_GHOST_PRE_DIALOG(pc, dialog, handle)
    local result01 = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_68_SQ020')
    if result01 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end