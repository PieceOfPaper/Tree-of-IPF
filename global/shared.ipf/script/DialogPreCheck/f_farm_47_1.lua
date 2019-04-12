function SCR_FARM471_RP_1_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM471_RP_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_FARM47_WOODPICK_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_1_SQ_010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_FARM47_HERBS_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc,'FARM47_1_SQ_050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

