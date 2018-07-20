
function SCR_JOB_ORACLE_6_1_TRIGGER1_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_ORACLE_6_1_TRIGGER2_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_JOB_ORACLE_6_1_TRIGGER3_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_ROKAS_36_1_SQ_040_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS_36_1_SQ_040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_REMAINS38_HIDDEN_RUNE_PRE_DIALOG(pc, dialog)
        return 'YES'
end
