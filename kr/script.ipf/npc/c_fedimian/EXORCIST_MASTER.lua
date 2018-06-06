function SCR_EXORCIST_MASTER_DIALOG(self, pc)
    PlayMusicQueueLocal(pc, "master_Exorcist")
    if GetServerNation() == 'KOR' and GetServerGroupID() == 9001 then
        COMMON_QUEST_HANDLER(self, pc)
        return
    end
    
    local jobCircle = GetJobGradeByName(pc, 'Char4_20')
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_20');
    if jobCircle > 0 then
        COMMON_QUEST_HANDLER(self,pc)
        if is_unlock == "YES" then
            return
        end
    end
    
    if is_unlock == 'YES' then
        COMMON_QUEST_HANDLER(self,pc)
    else
        local sObj = GetSessionObject(pc, "SSN_EXORCIST_UNLOCK")
        if sObj == nil then
            CreateSessionObject(pc, "SSN_EXORCIST_UNLOCK")
        end
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
        if hidden_prop < 10 then
            local sel = ShowSelDlg(pc, 0, "EXORCIST_MASTER_STEP1_DLG1", ScpArgMsg("CHAR4_20_STEP1_SEL1"), ScpArgMsg("CHAR4_20_STEP1_SEL2"))
            if sel == 1 then
                local sel2 = ShowSelDlg(pc, 0, "EXORCIST_MASTER_STEP1_DLG2", ScpArgMsg("CHAR4_20_STEP1_SEL3"), ScpArgMsg("CHAR4_20_STEP1_SEL4"))
                if sel2 == 1 then
                    ShowOkDlg(pc, "EXORCIST_MASTER_STEP1_DLG3")
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 10)
                    RunScript("GIVE_ITEM_TX", pc, "EXORCIST_JOB_HIDDEN_ITEM", 1, "Quest_HIDDEN_EXORCIST")
                end
            end
        elseif hidden_prop < 11 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP1_EX_DLG1")
        elseif hidden_prop == 80 then
            local sel = ShowSelDlg(pc, 0, "EXORCIST_MASTER_STEP3_DLG1", ScpArgMsg("CHAR4_20_STEP3_SEL1"), ScpArgMsg("CHAR4_20_STEP3_SEL2"))
            if sel == 1 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP3_DLG2")
                local exorcist_Book = {
                                        "CHAR420_MSTEP3_1_ITEM1",
                                        "CHAR420_MSTEP3_1_ITEM2",
                                        "CHAR420_MSTEP3_1_ITEM3",
                                        "CHAR420_MSTEP3_1_ITEM4"
                                      }
                local tx = TxBegin(pc)
                for i = 1, #exorcist_Book do
                    if GetInvItemCount(pc, exorcist_Book[i]) < 1 then
                        TxGiveItem(tx, exorcist_Book[i], 1, 'Quest_HIDDEN_EXORCIST');
                    end
                end
                local ret = TxCommit(tx);
                if ret == "SUCCESS" then
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 81)
                end
            end
        elseif hidden_prop == 81 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP3_DLG3")
        elseif hidden_prop == 82 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP3_DLG4")
            local sObj = GetSessionObject(pc, "SSN_EXORCIST_UNLOCK")
            local exorcist_Master_Q = {
                                        "EXORCIST_MASTER_Q1",
                                        "EXORCIST_MASTER_Q2",
                                        "EXORCIST_MASTER_Q3",
                                        "EXORCIST_MASTER_Q4"
                                      }
            local sel_arr1 = { 
                                {ScpArgMsg('EXORCIST_MASTER_Q1_A1'), ScpArgMsg('EXORCIST_MASTER_Q1_A2'), ScpArgMsg('EXORCIST_MASTER_Q1_A3')},
                                {ScpArgMsg('EXORCIST_MASTER_Q1_B1'), ScpArgMsg('EXORCIST_MASTER_Q1_B2'), ScpArgMsg('EXORCIST_MASTER_Q1_B3')},
                                {ScpArgMsg('EXORCIST_MASTER_Q1_C1'), ScpArgMsg('EXORCIST_MASTER_Q1_C2'), ScpArgMsg('EXORCIST_MASTER_Q1_C3')},
                                {ScpArgMsg('EXORCIST_MASTER_Q1_D1'), ScpArgMsg('EXORCIST_MASTER_Q1_D2'), ScpArgMsg('EXORCIST_MASTER_Q1_D3')}
                             }
            local temp
            
            for i = 1, #sel_arr1 do
                for j = 1, 3 do
                    local ran = IMCRandom(1, #sel_arr1[i])
            	    temp = sel_arr1[i][j]
            	    sel_arr1[i][j] = sel_arr1[i][ran]
            	    sel_arr1[i][ran] = temp
                end
            end
            
            for i = 1, #exorcist_Master_Q do
                local ran = IMCRandom(1, #exorcist_Master_Q)
                if exorcist_Master_Q[ran] == "EXORCIST_MASTER_Q1" then
                    local sel = ShowSelDlg(pc, 0, exorcist_Master_Q[ran], sel_arr1[ran][1], sel_arr1[ran][2], sel_arr1[ran][3], ScpArgMsg('EXORCIST_MASTER_Q_ABANDON'))
                    if sel == 1 then
                        if sel_arr1[ran][1] == ScpArgMsg('EXORCIST_MASTER_Q1_A1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 2 then
                        if sel_arr1[ran][2] == ScpArgMsg('EXORCIST_MASTER_Q1_A1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 3 then
                        if sel_arr1[ran][3] == ScpArgMsg('EXORCIST_MASTER_Q1_A1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    else
                        sObj.Step1 = 0
                        return
                    end
                elseif exorcist_Master_Q[ran] == "EXORCIST_MASTER_Q2" then
                    local sel = ShowSelDlg(pc, 0, exorcist_Master_Q[ran], sel_arr1[ran][1], sel_arr1[ran][2], sel_arr1[ran][3], ScpArgMsg('EXORCIST_MASTER_Q_ABANDON'))
                    if sel == 1 then
                        if sel_arr1[ran][1] == ScpArgMsg('EXORCIST_MASTER_Q1_B1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 2 then
                        if sel_arr1[ran][2] == ScpArgMsg('EXORCIST_MASTER_Q1_B1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 3 then
                        if sel_arr1[ran][3] == ScpArgMsg('EXORCIST_MASTER_Q1_B1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    else
                        sObj.Step1 = 0
                        return
                    end
                elseif exorcist_Master_Q[ran] == "EXORCIST_MASTER_Q3" then
                    local sel = ShowSelDlg(pc, 0, exorcist_Master_Q[ran], sel_arr1[ran][1], sel_arr1[ran][2], sel_arr1[ran][3], ScpArgMsg('EXORCIST_MASTER_Q_ABANDON'))
                    if sel == 1 then
                        if sel_arr1[ran][1] == ScpArgMsg('EXORCIST_MASTER_Q1_C1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 2 then
                        if sel_arr1[ran][2] == ScpArgMsg('EXORCIST_MASTER_Q1_C1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 3 then
                        if sel_arr1[ran][3] == ScpArgMsg('EXORCIST_MASTER_Q1_C1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    else
                        sObj.Step1 = 0
                        return
                    end
                elseif exorcist_Master_Q[ran] == "EXORCIST_MASTER_Q4" then
                    local sel = ShowSelDlg(pc, 0, exorcist_Master_Q[ran], sel_arr1[ran][1], sel_arr1[ran][2], sel_arr1[ran][3], ScpArgMsg('EXORCIST_MASTER_Q_ABANDON'))
                    if sel == 1 then
                        if sel_arr1[ran][1] == ScpArgMsg('EXORCIST_MASTER_Q1_D1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 2 then
                        if sel_arr1[ran][2] == ScpArgMsg('EXORCIST_MASTER_Q1_D1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    elseif sel == 3 then
                        if sel_arr1[ran][3] == ScpArgMsg('EXORCIST_MASTER_Q1_D1') then
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                            sObj.Step1 = sObj.Step1 + 1
                        else
                            table.remove(exorcist_Master_Q, ran)
                            table.remove(sel_arr1, ran)
                        end
                    else
                        sObj.Step1 = 0
                        return
                    end
                end
            end
            if sObj.Step1 >= 3 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP3_DLG5")
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 90)
            else
                sObj.Step1 = 0
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP3_DLG6")
            end
        elseif hidden_prop == 90 then
            local msg = ScpArgMsg("EXORCIST_MASTER_STEP321_MSG1")
            EXORCIST_NPCOBJECT_HIDE(pc, "CHAR420_STEP321_NPC", "EXORCIST_MASTER_STEP321_DLG1", "EXORCIST_MASTER_STEP321_DLG2", msg)
        elseif hidden_prop == 101 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP321_DLG8", 1)
            if isHideNPC(pc, "CHAR420_STEP321_NPC") == "NO" then
                UIOpenToPC(pc,'fullblack',1)
                local tx = TxBegin(pc)
                TxHideNPC(tx, "CHAR420_STEP321_NPC")
                local ret = TxCommit(tx)
                if ret == "SUCCESS" then
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 110)
                    sleep(500)
                end
                UIOpenToPC(pc,'fullblack',0)
            end
        elseif hidden_prop == 110 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP322_DLG1", 1)
            local npc_arr = {
                                "CHAR420_STEP322_NPC1",
                                "CHAR420_STEP322_NPC2"
                            }
            local tx = TxBegin(pc)
            for i =1, #npc_arr do
                if isHideNPC(pc, npc_arr[i]) == "YES" then
                    TxUnHideNPC(tx, npc_arr[i])
                end
            end
            local ret = TxCommit(tx)
            if ret == "SUCCESS" then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_MASTER_STEP322_MSG1"), 5)
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 111)
            end
        elseif hidden_prop == 111 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP322_DLG2", 1)
        elseif hidden_prop == 114 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP322_DLG17")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 115)
        elseif hidden_prop == 120 then
            local msg = ScpArgMsg("EXORCIST_MASTER_STEP323_MSG1")
            EXORCIST_NPCOBJECT_HIDE(pc, "CHAR420_STEP323_NPC1", "EXORCIST_MASTER_STEP323_DLG1", "EXORCIST_MASTER_STEP323_DLG2", msg)
        elseif hidden_prop == 121 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("EXORCIST_MASTER_ANSWER1"), 'TALK', 3)
            if result == 1 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP323_DLG3")
                UIOpenToPC(pc,'fullblack',1)
                local tx = TxBegin(pc)
                TxHideNPC(tx, "CHAR420_STEP323_NPC1")
                local ret = TxCommit(tx)
                if ret == "SUCCESS" then
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 130)
                    sleep(500)
                end
                UIOpenToPC(pc,'fullblack',0)
                ShowBalloonText(pc, "EXORCIST_MASTER_STEP323_TXT7", 5)
            else
                return
            end
        elseif hidden_prop == 130 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP33_DLG1", 1)
            local tx = TxBegin(pc)
            TxUnHideNPC(tx, "EXORCIST_MASTER_STEP33_NPC1")
            TxUnHideNPC(tx, "EXORCIST_MASTER_STEP33_NPC2")
            if GetInvItemCount(pc, "EXORCIST_MSTEP33_ITEM3") < 1 then
                TxGiveItem(tx, "EXORCIST_MSTEP33_ITEM3", 1, 'Quest_HIDDEN_EXORCIST');
            end
            local ret = TxCommit(tx)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 131)
        elseif hidden_prop == 140 then
            ShowOkDlg(pc, 'EXORCIST_MASTER_STEP4_DLG1', 1)
            local tx1 = TxBegin(pc);
            local exorcist_item = {
                                    'EXORCIST_MSTEP33_ITEM2',
                                    'EXORCIST_MSTEP33_ITEM1',
                                    'EXORCIST_MSTEP323_ITEM1',
                                    'EXORCIST_MSTEP322_ITEM1',
                                    'CHAR4_20_STEP2_2',
                                    'CHAR420_MSTEP3_1_ITEM4',
                                    'CHAR420_MSTEP3_1_ITEM3',
                                    'CHAR420_MSTEP3_1_ITEM2',
                                    'CHAR420_MSTEP3_1_ITEM1',
                                    'EXORCIST_JOB_HIDDEN_ITEM',
                                    'EXORCIST_MSTEP33_ITEM3'
                                }
            for i = 1, #exorcist_item do
                if GetInvItemCount(pc, exorcist_item[i]) >= 1 then
                    TxTakeItem(tx1, exorcist_item[i], GetInvItemCount(pc, exorcist_item[i]), 'Quest_HIDDEN_EXORCIST');
                end
            end
            local ret = TxCommit(tx1);
            if ret == "SUCCESS" then
                local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_20')
                if ret2 == "FAIL" then
                    print("tx FAIL!")
                elseif ret2 == "SUCCESS" then
                    print("tx SUCCESS!")
                    local sObj = GetSessionObject(pc, "SSN_EXORCIST_UNLOCK")
                    if sObj ~= nil then
                        DestroySessionObject(pc, sObj)
                    end
                end
            else
                print("tx FAIL!")
            end
        else
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP1_DLG4")
        end
    end
end

function EXORCIST_NPCOBJECT_HIDE(pc, hidenpc, dlg1, dlg2, msg)
    if isHideNPC(pc, hidenpc) == "YES" then
        if dlg1 ~= nil and dlg1 ~= "None" then
            ShowOkDlg(pc, dlg1, 1)
        end
        UIOpenToPC(pc,'fullblack',1)
        local tx = TxBegin(pc)
        TxUnHideNPC(tx, hidenpc)
        local ret = TxCommit(tx)
        if ret == "SUCCESS" then
            if hidenpc ~= nil and hidenpc ~= "None" then
                sleep(500)
            end
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", msg, 5)
        end
        UIOpenToPC(pc,'fullblack',0)
    else
        if dlg2 ~= nil and dlg2 ~= "None" then
            ShowOkDlg(pc, dlg2, 1)
        end
    end
end