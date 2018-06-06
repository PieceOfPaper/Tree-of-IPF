function SCR_JOB_DIEVDIRBYS2_NPC_DIALOG(self, pc)
    local questCheck1 = SCR_QUEST_CHECK(pc,'JOB_SORCERER_6_1')
    local questCheck2 = SCR_QUEST_CHECK(pc,'MASTER_SORCERER1')
    
    if questCheck1 == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_SORCERER_6_1')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SORCERER_6_1_MSG1"), 'TALK', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CATACOMB_04_SQ_03')
        
        if result == 1 then
            LookAt(pc, self)
            ShowOkDlg(pc, 'JOB_SORCERER_6_1_DIEVDIRBYS_dlg', 1)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_SORCERER_6_1', 'QuestInfoValue1', 1)
        end
        
    elseif questCheck2 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SORCERER1")

        if sObj.QuestInfoValue1 == 0 then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'MASTER_SORCERER1')
            local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SORCERER_6_1_MSG1"), 'TALK', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'MASTER_SORCERER1')
            
            if result == 1 then
                LookAt(pc, self)
                ShowOkDlg(pc, 'JOB_SORCERER_6_1_DIEVDIRBYS_dlg', 1)
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_MASTER_SORCERER1', 'QuestInfoValue1', 1)
            end
            
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
        if _hidden_prop < 257 then
            if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_4') == 0 then
                local rnd = IMCRandom(1, 20)
                if rnd == 1 then
                    ShowOkDlg(pc, 'HIDDEN_RUNECASTER_npc4_dlg2', 1)
                    if isHideNPC(pc, 'RUNECASTER_SIAULIAI_WEST_STONE') == 'YES' then
                        UnHideNPC(pc, 'RUNECASTER_SIAULIAI_WEST_STONE')
                    end
                    return;
                end
            end
        end
        COMMON_QUEST_HANDLER(self,pc)
    end
end
