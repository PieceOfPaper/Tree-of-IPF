function SCR_RETIARII_MASTER_DIALOG(self, pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_18")
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_18');
    PlayMusicQueueLocal(pc, "master_retiarii")
    if IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
        return
    end
    local jobCircle = GetJobGradeByName(pc, 'Char1_18')
    if jobCircle > 0 then
        COMMON_QUEST_HANDLER(self,pc)
        if is_unlock == "YES" then
            return
        end
    end
    if is_unlock == 'YES' then
        COMMON_QUEST_HANDLER(self,pc)
    elseif is_unlock == 'NO' then
        local sObj = GetSessionObject(pc, "SSN_RETIARII_UNLOCK")
        if hidden_Prop < 1 then
            local sel1 = ShowSelDlg(pc, 0, "CHAR118_MSTEP1_DLG1", ScpArgMsg("CHAR118_MSTEP1_SEL1"), ScpArgMsg("CHAR118_MSTEP1_SEL2"))
            if sel1 == 1 then
                local sel2 = ShowSelDlg(pc, 0, "CHAR118_MSTEP1_DLG2", ScpArgMsg("CHAR118_MSTEP1_SEL3"), ScpArgMsg("CHAR118_MSTEP1_SEL4"))
                if sel2 == 1 then
                    ShowOkDlg(pc,  "CHAR118_MSTEP1_AFTERWARD_DLG3", 1)
                    if sObj == nil then
                        CreateSessionObject(pc, "SSN_RETIARII_UNLOCK")
                    end
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_18', 50)
                else
                    ShowOkDlg(pc,  "CHAR118_MSTEP1_AFTERWARD_DLG2", 1)
                end
            else
                ShowOkDlg(pc, "CHAR118_MSTEP1_AFTERWARD_DLG1", 1)
            end
        elseif hidden_Prop >= 50 and hidden_Prop <= 100 then
            if hidden_Prop <= 50 then
                sObj.Step22 = 1
                sObj.Step1 = 50
                sObj.Step2 = 1
                sObj.Step12 = 1
                SaveSessionObject(pc, sObj)
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_18', 100)
            end
            
            local seldlg = nil
            local discount
            if sObj.Step2 == 1 then
                discount = 5
            elseif sObj.Step2 == 2 then
                discount = 4
            elseif sObj.Step2 == 3 then
                discount = 3
            elseif sObj.Step2 == 4 then
                discount = 2
            elseif sObj.Step2 >= 5 then
                discount = 1
            end
            
            
            if (sObj.Step1 == 0) or (sObj.Step1 < discount) then
                sObj.Step20 = 1
            else
                sObj.Step24 = 1
            end
            
            if (sObj.Step1 == 0) or (sObj.Step1 < discount) then
                seldlg = ScpArgMsg("CHAR118_MSTEP2_SEL7")
            end
            
            local muscular_P = sObj.Goal1
            local endurande_P = sObj.Goal2
            local agility_P = sObj.Goal3
            local simulation_P = sObj.Goal5
            --print(muscular_P,endurande_P, agility_P, simulation_P)
            if muscular_P < 25 or endurande_P < 3 or agility_P < 20 or simulation_P < 20 then
                local sel3 = ShowSelDlg(pc, 0, "CHAR118_MSTEP2_DLG1", ScpArgMsg("CHAR118_MSTEP2_SEL1"), ScpArgMsg("CHAR118_MSTEP2_SEL2"), ScpArgMsg("CHAR118_MSTEP2_SEL3"), ScpArgMsg("CHAR118_MSTEP2_SEL5"), ScpArgMsg("CHAR118_MSTEP2_SEL6"), seldlg)
                if sel3 == 1 then
                    ShowOkDlg(pc, "CHAR118_MSTEP2_SEL1_DLG1", 1)
                    local traning_Item1 = GetInvItemCount(pc, "CHAR118_MSTEP2_1_ITEM1")
                    if traning_Item1 < 1 then
                        RunScript("GIVE_ITEM_TX", pc, "CHAR118_MSTEP2_1_ITEM1", 1, "Quest_HIDDEN_RETIARII")
                    end
                    if muscular_P < 25 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("RETIARII_TRAINING_1_MSG1", "GOAL1", 25-muscular_P), 7)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_1_MSG2"), 7)
                    end
                elseif sel3 == 2 then
                    ShowOkDlg(pc, "CHAR118_MSTEP2_SEL2_DLG1", 1)
                    if endurande_P < 3 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_2_MSG1", "GOAL1", 3-endurande_P), 7)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_2_MSG2"), 7)
                    end
                    if GetInvItemCount(pc, "CHAR118_MSTEP2_2_ITEM1") < 1 or GetInvItemCount(pc, "CHAR118_MSTEP2_2_ITEM2") < 1 then
                        local tx1 = TxBegin(pc);
                        local traning_Item2 = { 
                                                "CHAR118_MSTEP2_2_ITEM1",
                                                "CHAR118_MSTEP2_2_ITEM2"
                                              }
                        for i = 1, #traning_Item2 do
--                            print(#traning_Item2)
                            if GetInvItemCount(pc, traning_Item2[i]) < 1 then
                                TxGiveItem(tx1, traning_Item2[i], 1, 'Quest_HIDDEN_RETIARII');
                            end
                        end
                        local ret = TxCommit(tx1);
                        if ret == "FAIL" then
                            print("tx FAIL!")
                        end
                    end
                elseif sel3 == 3 then
                    ShowOkDlg(pc, "CHAR118_MSTEP2_SEL3_DLG1",1)
                    if agility_P < 20 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_3_MSG1", "GOAL1", 20-agility_P), 7)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_3_MSG2"), 7)
                    end
                elseif sel3 == 4 then
                    ShowOkDlg(pc, "CHAR118_MSTEP2_SEL5_DLG1", 1)
                    if simulation_P < 20 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_4_MSG1", "GOAL1", 20-simulation_P), 7)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("RETIARII_TRAINING_4_MSG2"), 7)
                    end
                elseif sel3 == 5 then
                    ShowOkDlg(pc, "CHAR118_MSTEP2_SEL6_DLG1", 1)
                elseif sel3 == 6 then
                    local food_Item = GetInvItemCount(pc, "CHAR118_MSTEP2_ITEM1")
                    if food_Item < 1 then
                        if IsBuffApplied(pc, "CHAR118_MSTEP2_ITEM1_BUFF1") == "NO" then
                            ShowOkDlg(pc, "CHAR118_MSTEP2_SEL7_DLG1", 1)
                            RunScript("GIVE_ITEM_TX", pc, "CHAR118_MSTEP2_ITEM1", 1, "Quest_HIDDEN_RETIARII")
                        else
                            ShowOkDlg(pc, "CHAR118_MSTEP2_SEL7_DLG2", 1)
                        end
                    else
                        ShowOkDlg(pc, "CHAR118_MSTEP2_SEL7_DLG2", 1)
                    end
                end
                if GetInvItemCount(pc, "CHAR118_MSTEP2_ITEM2") < 1 then
                    RunScript("GIVE_ITEM_TX", pc, "CHAR118_MSTEP2_ITEM2", 1, "Quest_HIDDEN_RETIARII")
                    ShowOkDlg(pc, "CHAR118_MSTEP2_DLG2", 1)
                end
            elseif muscular_P >= 25 and endurande_P >= 3 and agility_P >= 20 and simulation_P >= 20 then
                ShowOkDlg(pc, "CHAR118_MSTEP3_DLG1", 1)
                local sObj = GetSessionObject(pc, "SSN_RETIARII_UNLOCK")
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_18', 200)
                goal_group = sObj.Step7 
                for i = 1, 3 do
                    if isHideNPC(pc, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i) == "NO" then
                        HideNPC(pc, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i)
                        --Chat(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i, 1)
                    end
                end
                local tx1 = TxBegin(pc);
                local retiarii_item = {
                                        'CHAR118_MSTEP2_ITEM1',
                                        'CHAR118_MSTEP2_1_ITEM1',
                                        'CHAR118_MSTEP2_2_ITEM1',
                                        'CHAR118_MSTEP2_2_ITEM2',
                                        'CHAR118_MSTEP2_ITEM2'
                                    }
                for i = 1, #retiarii_item do
                    if GetInvItemCount(pc, retiarii_item[i]) >= 1 then
                        TxTakeItem(tx1, retiarii_item[i], GetInvItemCount(pc, retiarii_item[i]), 'Quest_HIDDEN_RETIARII');
                    end
                end
                local ret = TxCommit(tx1);
                local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char1_18')
                if ret2 == "FAIL" then
                    print("tx FAIL!")
                elseif ret2 == "SUCCESS" then
                    print("tx SUCCESS!")
                    SetTitle(self, "")
                    if sObj ~= nil then
                        DestroySessionObject(pc, sObj)
                    end
                end
            end
        end
    end
end