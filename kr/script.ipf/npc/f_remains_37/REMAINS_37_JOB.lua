

function SCR_MASTER_CHRONO_DIALOG(self, pc)
    local questCheck1 = SCR_QUEST_CHECK(pc,'JOB_SORCERER_6_1')
    local questCheck2 = SCR_QUEST_CHECK(pc,'MASTER_SORCERER1')
    
    if questCheck1 == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_SORCERER_6_1')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SORCERER_6_1_MSG1"), 'TALK', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CATACOMB_04_SQ_03')
        
        if result == 1 then
            LookAt(pc, self)
            ShowOkDlg(pc, 'JOB_SORCERER_6_1_CHRONO_dlg', 1)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_SORCERER_6_1', 'QuestInfoValue3', 1)
        end
        
    elseif questCheck2 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SORCERER1")
        
        if sObj.QuestInfoValue3 == 0 then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'MASTER_SORCERER1')
            local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SORCERER_6_1_MSG1"), 'TALK', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'MASTER_SORCERER1')
            
            if result == 1 then
                LookAt(pc, self)
                ShowOkDlg(pc, 'JOB_SORCERER_6_1_CHRONO_dlg', 1)
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_MASTER_SORCERER1', 'QuestInfoValue3', 1)
            end
            
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
        
    end
    
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    if hidden_prop == 1 then
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_19', 2)
        UnHideNPC(pc, "JOB_SHADOWMANCER_MASTER")
        HideNPC(pc, "DCAPITAL_105_SHADOW_DEVICE")
        ShowOkDlg(pc, 'JOB_SHADOWMANCER_INTRODUCE_CHRONO_DLG', 1)
        ShowBalloonText(pc, "JOB_SHADOWMANCER_UNLOCK_MONOLOGUE", 5)
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end


function SCR_MASTER_FALCONER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end