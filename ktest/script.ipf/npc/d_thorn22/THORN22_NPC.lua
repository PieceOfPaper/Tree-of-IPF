function SCR_THORN22_Q_14_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_BOSSKILL_1_TRIGGER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_Q_16_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_Q_18_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_DOMINIC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_SAMSON_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_FIREWOOD_1_DIALOG(self, pc)
    local quest_sObj = GetSessionObject(pc, 'SSN_THORN22_Q_4')
    if quest_sObj ~= nil then
        if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
            LookAt(pc, self)
            
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'SSN_THORN22_Q_4')
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_TtaelKam_MoeuKi"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'SSN_THORN22_Q_4')
            if result == 1 then
                
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_THORN22_Q_4', 'QuestInfoValue1', 1, nil, 'THORN22_Firewood_1/1')
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_THORN22_Q_4', 'QuestMapPointView1', 0, 0)
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_KaSiSup_MaLeun_NaMusKaJi_HoegDeug!"), 3);
                HideNPC(pc, 'THORN22_FIREWOOD_1',0,0,0)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_Nameun_KaSiSup_MaLeun_NaMusKaJi_eopeum"), 3);
        end
    end
end

function SCR_THORN22_FIREWOOD_2_DIALOG(self, pc)
    local quest_sObj = GetSessionObject(pc, 'SSN_THORN22_Q_4')
    if quest_sObj ~= nil then
        if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
            LookAt(pc, self)
            
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'THORN22_Q_4')
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_TtaelKam_MoeuKi"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'THORN22_Q_4')
            if result == 1 then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_THORN22_Q_4', 'QuestInfoValue1', 1, nil, 'THORN22_Firewood_1/1')
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_THORN22_Q_4', 'QuestMapPointView2', 0, 0)
                
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_KaSiSup_MaLeun_NaMusKaJi_HoegDeug!"), 3);
                HideNPC(pc, 'THORN22_FIREWOOD_2',0,0,0)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_Nameun_KaSiSup_MaLeun_NaMusKaJi_eopeum"), 3);
        end
    end
end

function SCR_THORN22_Q_6_TRIGGER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_Q_6_BONFIRE_ENTER(self, pc)
end

function SCR_THORN22_OROURKE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_JULIAN_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_JULIAN_NORMAL_1_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop == 60 then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN22_JULIAN_NORMAL_1(self,pc)
    if GetInvItemCount(pc, "CHAR4_20_STEP2_2") >= 1 then
        ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_2_DLG4")
        local tx = TxBegin(pc)
        TxTakeItem(tx, "CHAR4_20_STEP2_2", 1, 'Quest_HIDDEN_EXORCIST');
        local ret = TxCommit(tx);
        if ret == "SUCCESS" then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("EXORCIST_MASTER_STEP2_2_MSG1"), 5)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 61)
        else
            print("tx FAIL!")
        end
    end
end

function SCR_THORN22_POULLTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_OWL1_DIALOG(self, pc)
    --for search KATYN_10_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.KATYN_10_HQ_01_1 ~= 300 then
        main_ssn.KATYN_10_HQ_01_1 = 300
    --print(main_ssn.KATYN_10_HQ_01_1)
    end
    
    COMMON_QUEST_HANDLER(self,pc)    
end

function SCR_THORN22_OWL2_DIALOG(self, pc)
    --for search KATYN_10_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.KATYN_10_HQ_01_2 ~= 300 then
        main_ssn.KATYN_10_HQ_01_2 = 300
        --print(main_ssn.KATYN_10_HQ_01_2)
    end
    COMMON_QUEST_HANDLER(self,pc)    
end

function SCR_THORN22_Q_18_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_AREA_WARING01_DIALOG(self, pc)
    ShowOkDlg(pc, "THORN22_WARING01",1)
end

function SCR_THORN22_ADD_SUB_01_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_ADD_SUB_02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_ADD_SUB_03_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_ADD_SUB_04_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_THORN22_ADD_SUB_05_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function SCR_CREATE_SSN_THORN22_ADD_SUB_02(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_REENTER_SSN_THORN22_ADD_SUB_02(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_DESTROY_SSN_THORN22_ADD_SUB_02(self, sObj)
end



function SCR_CREATE_SSN_THORN22_ADD_SUB_05(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_REENTER_SSN_THORN22_ADD_SUB_05(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_DESTROY_SSN_THORN22_ADD_SUB_05(self, sObj)
end


