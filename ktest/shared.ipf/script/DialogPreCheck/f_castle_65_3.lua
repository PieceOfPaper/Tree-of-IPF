function SCR_CASTLE653_SQ_01_1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE653_SQ_01_2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE653_SQ_01_3_PRE_DIALOG(pc, dialog)
    return 'NO'
end


function SCR_CASTLE653_RP_2_OBJ_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE653_RP_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end