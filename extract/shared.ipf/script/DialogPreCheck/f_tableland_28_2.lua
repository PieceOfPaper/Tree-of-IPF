function SCR_TABLELAND282_SQ_03_ROOT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND28_2_SQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_TABLELAND282_SQ_04_SPEAR_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND28_2_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_TABLELAND282_SQ_06_SAP_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND28_2_SQ06')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

