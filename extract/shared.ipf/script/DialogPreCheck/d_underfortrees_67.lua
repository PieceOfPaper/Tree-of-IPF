function SCR_UNDER67_GRASS_PRE_DIALOG(pc, dialog, handle)
    local result01 = SCR_QUEST_CHECK(pc, 'UNDERFORTRESS_67_MQ040')
    if result01 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
