function SCR_SIAU16_SQ_04_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU16_SQ_04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_SIAU16_SQ_05_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU16_SQ_05')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_JOB_2_CLERIC3_PATIENT_PRE_DIALOG(pc, dialog)
    return 'NO'
end
