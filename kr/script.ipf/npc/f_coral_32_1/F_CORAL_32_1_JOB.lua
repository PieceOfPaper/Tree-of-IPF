
function SCR_JOB_CORSAIR_6_1_BONE_DIALOG(self, pc)
    local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_CORSAIR_6_1')
    local questCheck2 = SCR_QUEST_CHECK(pc, 'MASTER_CORSAIR1')
    if questCheck1 == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_CORSAIR_6_1')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SalPyeoBoNeun_Jung"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_CORSAIR_6_1')
        
        if result == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 1.0, nil, 'BOT')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_CORSAIR_6_1', nil, nil, nil, 'JOB_CORSAIR_6_1_ITEM/1')
        end
    elseif questCheck2 == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'MASTER_CORSAIR1')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SalPyeoBoNeun_Jung"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'MASTER_CORSAIR1')
        
        if result == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 1.0, nil, 'BOT')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_MASTER_CORSAIR1', nil, nil, nil, 'JOB_CORSAIR_6_1_ITEM/1')
        end
    end
end
