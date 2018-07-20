function SCR_MASTER_PROPERTY_PRECHECK(pc, checkJob)
    local pcJobLv = GetJobLevelByName(pc, checkJob)
    if pcJobLv >= 1 then
        return 'YES'
    end
    
    return 'NO'
end

--SWORDMAN CLASS
function SCR_MASTER_SWORDMAN_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_1')
end

function SCR_MASTER_PELTASTA_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_3')
end

function SCR_MASTER_HIGHLANDER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_2')
end

function SCR_JOB_HOPLITE2_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_4')
end


function SCR_JOB_BARBARIAN2_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_6')
end

function SCR_MASTER_CATAPHRACT_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_7')
end

function SCR_JOB_CORSAIR4_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_8')
end

function SCR_MASTER_DOPPELSOELDNER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_9')
end

function SCR_JOB_RODELERO3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_10')
end

function SCR_JOB_SQUIRE3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_11')
end

function SCR_JOB_CENT4_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_5')
end

function SCR_MASTER_FENCER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_14')
end

function SCR_MASTER_FENCER_NORMAL_2_PRE(pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_1")
    if quest == "PROGRESS" then
        return 'YES'
    end
    return 'NO'
end

function SCR_MASTER_FENCER_NORMAL_3_PRE(pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_2")
    if quest == "PROGRESS" then
        return 'YES'
    end
    return 'NO'
end

function SCR_CHAR120_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_20')
end

function SCR_MATADOR_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_19')
end

function SCR_RETIARII_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_18')
end

function SCR_PIED_PIPER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_12')
end

--SWORDMAN ABILSHOP
--function SCR_MASTER_SWORDMAN_NORMAL_1(self, pc)
--   SCR_OPEN_ABILSHOP(pc, "ability_warrior");
--end

--function SCR_MASTER_HIGHLANDER_NORMAL_1(self, pc)
--   SCR_OPEN_ABILSHOP(pc, "Ability_Highlander");
--end

--function SCR_MASTER_PELTASTA_NORMAL_1(self, pc)
--   SCR_OPEN_ABILSHOP(pc, "Ability_Peltasta");
--end

function SCR_JOB_HOPLITE2_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Hoplite");
end


function SCR_JOB_BARBARIAN2_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Barbarian");
end

function SCR_MASTER_CATAPHRACT_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Cataphract");
end

function SCR_JOB_CORSAIR4_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Corsair");
end

function SCR_MASTER_DOPPELSOELDNER_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Doppelsoeldner");
end

function SCR_JOB_RODELERO3_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Rodelero");
end

function SCR_JOB_SQUIRE3_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Squire");
end

function SCR_JOB_SQUIRE3_1_NPC_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Squire', 5);
end

function SCR_JOB_CENT4_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Centurion");
end

function SCR_MASTER_FENCER_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Fencer");
end

function SCR_MASTER_FENCER_NORMAL_2(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_1")
    if quest == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_APPRAISER5_1")
        local item_cnt = GetInvItemCount(pc, "JOB_APPRAISER5_1_ITEM1")
        if item_cnt < 1 then
            ShowOkDlg(pc, "JOB_APPRAISER5_1_FENCER1", 1)
            RunScript('GIVE_ITEM_TX', pc, 'JOB_APPRAISER5_1_ITEM1', 1, "Quest_JOB_APPRAISER5_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_APPRAISER5_1_MSG1"), 4);
            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
            SaveSessionObject(pc, sObj)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_1_MSG2"), 4);
        end
    end
end

function SCR_MASTER_FENCER_NORMAL_3(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_2")
    if quest == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_APPRAISER5_2")
        ShowOkDlg(pc, "JOB_APPRAISER5_1_FENCER2", 1)
        local item_cnt1 = GetInvItemCount(pc, "JOB_APPRAISER5_1_ITEM1")
        local item_cnt2 = GetInvItemCount(pc, "JOB_APPRAISER5_2_ITEM1")
        if item_cnt2 >= 1 then
            RunScript('GIVE_TAKE_ITEM_TX', pc, nil, "JOB_APPRAISER5_1_ITEM1/1/JOB_APPRAISER5_2_ITEM1/1", "Quest_JOB_APPRAISER5_1")
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_2_MSG1"), 4);
            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
            SaveSessionObject(pc, sObj)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_2_MSG2"), 4);
        end
    end
end

function SCR_MATADOR_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Matador");
end

function SCR_CHAR120_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_NakMuay");
end

function SCR_RETIARII_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, 'Ability_Retiarii')
end

function SCR_RETIARII_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'RETIARII_MASTER', 5);
end

function SCR_PIED_PIPER_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, 'Ability_PiedPiper')
end

--WIZARD CLASS
function SCR_MASTER_WIZARD_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_1')
end

function SCR_MASTER_ICEMAGE_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_3')
end

function SCR_MASTER_FIREMAGE_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_2')
end

function SCR_JOB_PSYCHOKINESIST2_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_4')
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_5')
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 60 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') >= 1 then
            if GetInvItemCount(pc, 'R_KLAIPE_CHAR313_ITEM2') == 0 and GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM2') == 0 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_4_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 60 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') >= 1 then
            if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM2') >= 1 and GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM3') >= 1 and GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM4') >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_JOB_SORCERER4_1_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_6')
end

function SCR_JOB_LINKER2_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_7')
end

function SCR_MASTER_CHRONO_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_8')
end

function SCR_ENCHANTER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_18')
end

function SCR_SAGE_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_14')
end
--HIDDEN_RUNECASTER
function SCR_MASTER_CHRONO_NORMAL_3_PRE(pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop == 257 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_3') == 0 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_MASTER_CHRONO_NORMAL_4_PRE(pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 100 then
        local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
        if sObj ~= nil then
            if sObj.Step1 >= 10 then
                return 'YES'
            end
        end
    end
end

function SCR_JOB_NECRO4_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_9')
end

function SCR_JOB_THAUMATURGE3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_10')
end

function SCR_JOB_WARLOCK3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_11')
end

--WIZARD ABILSHOP
--function SCR_MASTER_WIZARD_NORMAL_1(self, pc)
--   SCR_OPEN_ABILSHOP(pc, "Ability_Wizard");
--end

function SCR_MASTER_FIREMAGE_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_FireMage");
end

function SCR_MASTER_FIREMAGE_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_FireMage', 5);
end

function SCR_MASTER_ICEMAGE_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_FrostMage");
end

function SCR_MASTER_ICEMAGE_NORMAL_2(self, pc)
   ShowTradeDlg(pc, 'Master_IceMage', 5);
end

function SCR_JOB_PSYCHOKINESIST2_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Psychokino");
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Alchemist");
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Alchemist', 5);
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_3(self, pc)
    ShowOkDlg(pc, 'CHAR313_MSTEP7_1_DLG1', 1)
    local tx1 = TxBegin(pc);
    if GetInvItemCount(pc, 'R_KLAIPE_CHAR313_ITEM2') == 0 and GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM5') then
        local hidden_item = {
                                "R_KLAIPE_CHAR313_ITEM2", 
                                "KLAIPE_CHAR313_ITEM5"
                            }
        for i = 1, #hidden_item do
            TxGiveItem(tx1, hidden_item[i], 1, "Quest_HIDDEN_APPRAISER");
        end
    end
    local ret = TxCommit(tx1);
    if ret == "SUCCESS" then
        UnHideNPC(pc, "HIDDEN_WATER_REMAINS")
    end
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_4(self, pc)
    ShowOkDlg(pc, 'CHAR313_MSTEP9_1_DLG1', 1)
    --PlayAnimLocal(self, pc, "Flask", 1)
    ShowBalloonText(pc, "CHAR313_MSTEP9_1_MSG1", 5)
    UIOpenToPC(pc,'fullblack',1)
    sleep(1000)
    UIOpenToPC(pc,'fullblack',0)
    ShowOkDlg(pc, "CHAR313_MSTEP9_1_DLG2", 1)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 60 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM6') == 0 then
            local tx1 = TxBegin(pc);
            local appraiser_item = {
                                        'R_KLAIPE_CHAR313_ITEM2',
                                        'KLAIPE_CHAR313_ITEM2',
                                        'KLAIPE_CHAR313_ITEM3',
                                        'KLAIPE_CHAR313_ITEM4',
                                        'KLAIPE_CHAR313_ITEM5',
                                    }
                for i = 1, #appraiser_item do
                    if GetInvItemCount(pc, appraiser_item[i]) >= 1 then
                        TxTakeItem(tx1, appraiser_item[i], GetInvItemCount(pc, appraiser_item[i]), 'HIDDEN_APPRAISER_MSTEP13_1');
                    end
                end
            TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM6", 1, "Quest_HIDDEN_APPRAISER");
            local ret = TxCommit(tx1);
            if ret == 'SUCCESS' then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 100)
                ShowOkDlg(pc, "CHAR313_MSTEP9_1_DLG3", 1)
                ShowBalloonText(pc, "CHAR313_MSTEP9_1_MSG2", 5)
            end
        end
    end
end

function SCR_JOB_SORCERER4_1_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Sorcerer");
end

function SCR_JOB_SORCERER4_1_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'SORCERER4_1', 5);
end

function SCR_JOB_LINKER2_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Linker");
end

function SCR_MASTER_CHRONO_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Chronomancer");
end

function SCR_MASTER_CHRONO_NORMAL_2(self, pc)
   ShowTradeDlg(pc, 'Master_Chronomancer', 5);
end

function SCR_MASTER_CHRONO_NORMAL_3(self, pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop == 257 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_3') == 0 then
            ShowOkDlg(pc, 'HIDDEN_RUNECASTER_npc3_dlg1', 1)
            local buff = GetBuffByName(self, 'RUNECASTER_NPC_3_BUFF')
            if buff == nil then
                ShowOkDlg(pc, 'HIDDEN_RUNECASTER_npc3_dlg2', 1)
                local tx1 = TxBegin(pc);
                TxGiveItem(tx1, "HIDDEN_RUNECASTER_ITEM_3", 1, "Quest_HIDDEN_RUNECASTER");
                local ret = TxCommit(tx1);
                if ret == 'SUCCESS' then
                    local rnd = IMCRandom(1, 120)*60000;
                    AddBuff(self, self, 'RUNECASTER_NPC_3_BUFF', 1, 0, 7200000+rnd, 1)
                end
            else
                ShowOkDlg(pc, 'HIDDEN_RUNECASTER_npc3_dlg3', 2)
            end
        end
    end
end


function SCR_MASTER_CHRONO_NORMAL_4(self,pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 100 then
        local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
        if sObj ~= nil then
            if sObj.Step2 == 0 then
                local item = GetInvItemCount(pc, "CHAR312_MSTEP1_ITEM2")
                if item > 0 then
                    local sel = ShowSelDlg(pc, 1, "CHAR312_MSTEP2_DLG1", ScpArgMsg("CHAR312_MSTEP2_TXT1"), ScpArgMsg("CHAR312_MSTEP2_TXT2"))
                    if sel == 1 then
                        local tx = TxBegin(pc)
                        if GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM1") < 1 then
                            TxGiveItem(tx,"CHAR312_MSTEP2_ITEM1", 1, 'Quest_HIDDEN_PIED_PIPER');
                            TxSetIESProp(tx, sObj, 'Step2', 1);
                        end
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
                            ShowOkDlg(pc, "CHAR312_MSTEP2_DLG2", 1)
                            sleep(500)
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                        end
                        return
                    end
                end
            elseif sObj.Step2 == 1 then
                local cnt1 = GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM2")
                if cnt1 > 0 then
                    local cnt2 = GetInvItemCount(pc, "CHAR312_MSTEP1_ITEM2")
                    if cnt2 > 0 then
                        ShowOkDlg(pc, "CHAR312_MSTEP2_DLG4", 1)
                        sleep(500)
                        PlayEffectLocal(self, pc, "F_light047_red", 0.8, 0, "TOP")
                        sleep(2000)
                        local tx = TxBegin(pc)
                        if GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM3") < 1 then
                            TxGiveItem(tx,"CHAR312_MSTEP2_ITEM3", 1, 'Quest_HIDDEN_PIED_PIPER');
                            TxTakeItem(tx, "CHAR312_MSTEP2_ITEM2", cnt1, "CHAR312_MSTEP2");
                            TxTakeItem(tx, "CHAR312_MSTEP1_ITEM2", cnt2, "CHAR312_MSTEP2");
                            local cnt3 = GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM1")
                            if cnt3 > 0 then
                                TxTakeItem(tx, "CHAR312_MSTEP1_ITEM1", cnt3, "CHAR312_MSTEP2");
                            end
                            TxSetIESProp(tx, sObj, 'Step2', 10);
                            ShowOkDlg(pc, "CHAR312_MSTEP2_DLG4_1", 1)
                            sleep(500)
                            ShowBalloonText(pc, 'CHAR312_MSTEP2_DLG6', 7)
                        end
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
                            ShowOkDlg(pc, "CHAR312_MSTEP2_DLG4_1", 1)
                            sleep(500)
                            ShowBalloonText(pc, 'CHAR312_MSTEP2_DLG6', 7)
                        end
                    end
                else
                    ShowOkDlg(pc, "CHAR312_MSTEP2_DLG3", 1)
                    sleep(500)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                end
            elseif sObj.Step2 == 10 then
                if sObj.Step3 < 1 then
                    local tx = TxBegin(pc)
                    if GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM3") < 1 then
                        TxGiveItem(tx,"CHAR312_MSTEP2_ITEM3", 1, 'Quest_HIDDEN_PIED_PIPER');
                    end
                    local ret = TxCommit(tx)
                    ShowOkDlg(pc, "CHAR312_MSTEP2_DLG5", 1)
                    sleep(500)
                    ShowBalloonText(pc, 'CHAR312_MSTEP2_DLG6', 7)
                end
            end
        end
    end
end

function SCR_JOB_NECRO4_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Necromancer");
end

function SCR_JOB_NECRO4_NPC_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Necromancer', 5);
end

function SCR_JOB_THAUMATURGE3_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Thaumaturge");
end

function SCR_JOB_THAUMATURGE3_1_NPC_NORMAL_2(self, pc)
   ShowTradeDlg(pc, 'Master_Thaumaturge', 5);
end

function SCR_JOB_WARLOCK3_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Elementalist");
end

function SCR_ENCHANTER_MASTER_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Enchanter");
end

function SCR_ENCHANTER_MASTER_NORMAL_2(self, pc)
   ShowTradeDlg(pc, 'Master_Enchanter', 5);
end

function SCR_SAGE_MASTER_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Sage");
end

function SCR_SAGE_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Sage', 5);
end

function SCR_SAGE_MASTER_NORMAL_3(self, pc)
    SCR_BOOKCOLLECTIONGIMMICK_SAGE_DIALOG(self, pc)
end

--ARCHER CLASS
function SCR_MASTER_ARCHER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_1')
end

function SCR_JOB_HUNTER2_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_2')
end

function SCR_MASTER_QU_NORMAL_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_3')
end

function SCR_MASTER_RANGER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_4')
end

function SCR_JOB_SAPPER2_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_5')
end

function SCR_JOB_WUGU3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_6')
end

function SCR_MASTER_HACKAPELL_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_7')
end

function SCR_JOB_SCOUT3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_8')
end

function SCR_JOB_SCOUT3_1_NPC_NORMAL_2_PRE(pc)
    local result = SCR_HIDDEN_JOB_IS_UNLOCK(pc, "Char1_13")
    if result == "NO" then
        if GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_4') >= 1 then
            if (GetInvItemCount(pc, 'R_JOB_SHINOBI_HIDDEN_1') == 0 and GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_6') == 0) or (GetInvItemCount(pc, 'R_JOB_SHINOBI_HIDDEN_2') == 0 and GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_5') == 0) then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_MASTER_ROGUE_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_9')
end

function SCR_MASTER_SCHWARZEREITER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_10')
end

function SCR_MASTER_FLETCHER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_11')
end

function SCR_FEDIMIAN_APPRAISER_NPC_NORMAL_3_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_13')
end

function SCR_MASTER_FALCONER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_14')
end

function SCR_BULLETMARKER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_18')
end

--ARCHER ABILSHOP
function SCR_MASTER_ARCHER_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Archer");
end

function SCR_JOB_HUNTER2_1_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Hunter");
end

function SCR_MASTER_QU_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_QuarrelShooter");
end

function SCR_MASTER_QU_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_QuarrelShooter', 5);
end

function SCR_MASTER_RANGER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Ranger");
end


function SCR_JOB_SAPPER2_1_NPC_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Sapper");
end

function SCR_JOB_SAPPER2_1_NPC_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Sapper', 5);
end

function SCR_JOB_WUGU3_1_NPC_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Wugushi");
end

function SCR_JOB_WUGU3_1_NPC_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Wugushi', 5);
end

function SCR_MASTER_HACKAPELL_NORMAL_1(self, pc)
--    SCR_OPEN_ABILSHOP(pc, "None");
end

function SCR_JOB_SCOUT3_1_NPC_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Scout");
end

function SCR_JOB_SCOUT3_1_NPC_NORMAL_2(self, pc)
    ShowOkDlg(pc, 'JOB_SHINOBI_HIDDEN_SCOUT_MASTER_dlg1', 1)
    local tx1 = TxBegin(pc);
    if GetInvItemCount(pc, 'R_JOB_SHINOBI_HIDDEN_1') == 0 then
        TxGiveItem(tx1, "R_JOB_SHINOBI_HIDDEN_1", 1, "Quest_JOB_SHINOBI_HIDDEN");
    end
    if GetInvItemCount(pc, 'R_JOB_SHINOBI_HIDDEN_2') == 0 then
        TxGiveItem(tx1, "R_JOB_SHINOBI_HIDDEN_2", 1, "Quest_JOB_SHINOBI_HIDDEN");
    end
    local ret = TxCommit(tx1);
end

function SCR_MASTER_ROGUE_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Rogue");
end

function SCR_MASTER_SCHWARZEREITER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Schwarzereiter");
end

function SCR_MASTER_FLETCHER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Fletcher");
end

function SCR_MASTER_FLETCHER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Fletcher', 5);
end

function SCR_FEDIMIAN_APPRAISER_NPC_NORMAL_2(self,pc)
    -- ?�감??    UIOpenToPC(pc, 'itemrandomreset', 1)
end

function SCR_FEDIMIAN_APPRAISER_NPC_NORMAL_3(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Appraiser");
end

function SCR_FEDIMIAN_APPRAISER_NPC_NORMAL_4(self,pc)
    ShowTradeDlg(pc, 'Master_Appraiser', 5);
end

function SCR_MASTER_FALCONER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Falconer");
end

function SCR_BULLETMARKER_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Bulletmarker");
end

--CLERIC CLASS
function SCR_MASTER_CLERIC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_1')
end

function SCR_MASTER_PRIEST_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_2')
end

function SCR_MASTER_PRIEST_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_12');
    if hidden_prop == 11 or hidden_prop == 12 or hidden_prop == 100 then
        return 'YES'
    end
    return 'NO'
end


function SCR_MASTER_PRIEST_NORMAL_4_PRE(pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_20');
    if hidden_prop == 100 then
        if sObj.Step3 == 1 then
            return "YES"
        end
    end
    return 'NO'
end

function SCR_MASTER_PRIEST_NORMAL_5_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop >= 60 and hidden_prop < 70 then
        return 'YES'
    end
end

function SCR_MASTER_PRIEST_NORMAL_6_PRE(pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 100 then
        local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
        if sObj ~= nil then
            if sObj.Step2 >= 10 then
                return 'YES'
            end
        end
    end
end

function SCR_MASTER_KRIWI_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_3')
end

function SCR_MASTER_KRIWI_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop >= 10 and hidden_prop < 60 then
        return 'YES'
    end
end

function SCR_MASTER_BOCORS_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_4')
end

function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_7')
end

--HIDDEN_RUNECASTER
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_3_PRE(pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop == 257 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_4') == 0 then
            return 'YES'
        end
    end
    return 'NO'
end

--HIDDEN_NAKMUAY
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_4_PRE(pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_20')
    if _hidden_prop == 100 then
        if sObj.Step4 == 1 then
            return 'YES'
        end
    end
    return 'NO'
end

--EXORCIST
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_5_PRE(pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20')
    if _hidden_prop <= 133 then
        local item = GetInvItemCount(pc, "EXORCIST_MSTEP33_ITEM2")
        local itme1 = GetInvItemCount(pc, "EXORCIST_MSTEP33_ITEM3")
        local itme2 = GetInvItemCount(pc, "EXORCIST_JOB_HIDDEN_ITEM")
        if item < 1 then
            if itme1 >= 1 and itme2 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_JOB_SADU3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_6')
end

function SCR_GELE573_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_11')
end

function SCR_JOB_PARDONER4_1_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_10')
end

function SCR_JOB_MONK4_1_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_9')
end

function SCR_JOB_DRUID3_1_NPC_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_5')
end

function SCR_MASTER_ORACLE_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_8')
end

function SCR_DAOSHI_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_17')
end

function SCR_INQUISITOR_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_16')
end

function SCR_INQUISITOR_MASTER_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop == 70 then
        return "YES"
    end
end

function SCR_ZEALOT_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_19')
end

function SCR_EXORCIST_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_20')
end

--CLERIC CLASS
function SCR_MASTER_CLERIC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Cleric");
end

function SCR_MASTER_PRIEST_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Priest");
end

function SCR_MASTER_PRIEST_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Priest', 5);
end

function SCR_MASTER_PRIEST_NORMAL_3(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_12');
    if hidden_prop == 11 or hidden_prop == 12 then
        ShowOkDlg(pc, 'MASTER_PRIEST_Chaplain_1', 1)
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_12', 100)
        UnHideNPC(pc, 'CHAPLAIN_MASTER')
    elseif hidden_prop == 100 then
        ShowOkDlg(pc, 'MASTER_PRIEST_Chaplain_1', 1)
    end
end

--HIDDEN_NAKMUAY
function SCR_MASTER_PRIEST_NORMAL_4(self,pc)
    local item1 = GetInvItemCount(pc, "Drug_holywater")
    local item2 = GetInvItemCount(pc, "Drug_Detoxifiy")
    local item3 = GetInvItemCount(pc, "CHAR120_MSTEP5_3_ITEM1")
    if item1 >= 1 and item2 >= 1 and item3 >= 100 then
        local sel = ShowSelDlg(pc, 0, 'CHAR120_MSTEP5_3_DLG1', ScpArgMsg("CHAR120_MSTEP5_3_SEL1"))
        if sel == 1 then
            local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
            ShowOkDlg(pc, 'CHAR120_MSTEP5_3_DLG2',1)
            UIOpenToPC(pc, 'fullblack', 1)
            sleep(1500)
            UIOpenToPC(pc, 'fullblack', 0)
            ShowOkDlg(pc, 'CHAR120_MSTEP5_3_DLG3',1)
            local nakmuay_item = {
                                    'CHAR120_MSTEP5_3_ITEM1',
                                    'Drug_Detoxifiy',
                                    'Drug_holywater'
                                }
            local tx1 = TxBegin(pc)
            for i = 1, #nakmuay_item do
                if GetInvItemCount(pc, nakmuay_item[i]) > 0 then
                    local invItem, cnt = GetInvItemByName(pc, nakmuay_item[i])
                    if IsFixedItem(invItem) == 1 then
                        isLockState = 1
                    end
                    if nakmuay_item[i] == "CHAR120_MSTEP5_3_ITEM1" then
                        TxTakeItem(tx1, nakmuay_item[i], GetInvItemCount(pc, nakmuay_item[i]), 'Quest_HIDDEN_NAKMUAY');
                    elseif nakmuay_item[i] == "Drug_Detoxifiy" then
                        TxTakeItem(tx1, nakmuay_item[i], 1, 'Quest_HIDDEN_NAKMUAY');
                    elseif nakmuay_item[i] == "Drug_holywater" then
                        TxTakeItem(tx1, nakmuay_item[i], 1, 'Quest_HIDDEN_NAKMUAY');
                    end
                end
            end
            TxGiveItem(tx1, "CHAR120_MSTEP5_3_ITEM2", 1, 'Quest_HIDDEN_NAKMUAY');
            local ret = TxCommit(tx1);
            if ret == "SUCCESS" then
                sObj.Step3 = 2
                SaveSessionObject(pc, sObj)
                print("tx Success")
            else
                if isLockState == 1 then
                    SendSysMsg(pc, 'QuestItemIsLocked');
                end
                print("tx FAIL!")
            end
        end
    else
        ShowOkDlg(pc, 'CHAR120_MSTEP5_3_DLG1',1)
    end
end

function SCR_MASTER_PRIEST_NORMAL_5(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop == 60 then
        if GetInvItemCount(pc, "R_CHAR4_20_STEP2_2") < 1 then
            if GetInvItemCount(pc, "CHAR4_20_STEP2_2")< 1 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_2_DLG1")
                RunScript("GIVE_ITEM_TX", pc, "R_CHAR4_20_STEP2_2", 1, "Quest_HIDDEN_EXORCIST")
            else
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_2_DLG2")
            end
        else
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_2_DLG2")
        end
    elseif hidden_prop == 61 then
        if GetInvItemCount(pc, "CHAR4_20_STEP2_2") <= 1 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_2_DLG3")
            local hidden_item = {
                                    "R_CHAR4_20_STEP2_2",
                                    "CHAR4_20_STEP2_2"
                                }
            local tx = TxBegin(pc)
            for i = 1, #hidden_item do
                if GetInvItemCount(pc, hidden_item[i]) > 0 then
                    TxTakeItem(tx, hidden_item[i], 1, 'Quest_HIDDEN_EXORCIST');
                end
            end
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 70)
            else
                if isLockState == 1 then
                    SendSysMsg(pc, 'QuestItemIsLocked');
                end
                print("tx FAIL!")
            end
        end
    end
end

function SCR_MASTER_PRIEST_NORMAL_6(self,pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 100 then
        local sObj = GetSessionObject(pc, "SSN_JOB_PIED_PIPER_UNLOCK")
        if sObj ~= nil then
            if sObj.Step3 == 0 then
                local sel = ShowSelDlg(pc, 1, "CHAR312_MSTEP3_DLG1", ScpArgMsg("CHAR312_MSTEP3_MSG1"), ScpArgMsg("CHAR312_MSTEP3_MSG2"))
                if sel == 1 then
                    local item = GetInvItemCount(pc, "CHAR312_MSTEP2_ITEM3")
                    if item > 0 then
                        ShowOkDlg(pc, "CHAR312_MSTEP3_DLG2", 1)
                        sleep(500)
                        PlayEffectLocal(self, pc, "F_light047_red", 0.8, 0, "TOP")
                        sleep(2000)
                        local tx = TxBegin(pc)
                        if GetInvItemCount(pc, "CHAR312_MSTEP3_ITEM") < 1 then
                            TxTakeItem(tx, "CHAR312_MSTEP2_ITEM3", 1, "CHAR312_MSTEP3");
                            TxGiveItem(tx,"CHAR312_MSTEP3_ITEM", 1, 'Quest_HIDDEN_PIED_PIPER');
                            local etc = GetETCObject(pc);
                            TxSetIESProp(tx, etc, "HiddenJob_Char3_12", 200);
                            TxSetIESProp(tx, sObj, 'Step3', 10);
                        end
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
                            ShowOkDlg(pc, "CHAR312_MSTEP3_DLG3", 1)
                            sleep(500)
                            ShowBalloonText(pc, 'CHAR312_MSTEP3_DLG5', 7)
                        end
                    else
                        ShowOkDlg(pc, "CHAR312_MSTEP3_DLG4", 1)
                        sleep(500)
                        ShowBalloonText(pc, 'CHAR312_MSTEP3_DLG5', 7)
                    end
                end
            else
                ShowOkDlg(pc, "CHAR312_MSTEP3_DLG4", 1)
                sleep(500)
                ShowBalloonText(pc, 'CHAR312_MSTEP3_DLG5', 7)
            end
        end
    end
end

function SCR_MASTER_KRIWI_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Kriwi");
end

function SCR_MASTER_KRIWI_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Kriwi', 5);
end

--EXORCIST
function SCR_MASTER_KRIWI_NORMAL_3(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    local sObj = GetSessionObject(pc, "SSN_EXORCIST_UNLOCK")
    if hidden_prop == 10 then
        if GetInvItemCount(pc, "EXORCIST_MSTEP321_ITEM1") < 1 then
            ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_1_DLG1")
            RunScript("GIVE_ITEM_TX", pc, "EXORCIST_MSTEP321_ITEM1", 1, "Quest_HIDDEN_EXORCIST")
        elseif GetInvItemCount(pc, "EXORCIST_MSTEP321_ITEM1") >= 1 then
            if sObj.Goal11 + sObj.Goal12 + sObj.Goal13 + sObj.Goal14 + sObj.Goal15 < 5 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_1_DLG2")
            elseif sObj.Goal11 + sObj.Goal12 + sObj.Goal13 + sObj.Goal14 + sObj.Goal15 >= 5 then
                ShowOkDlg(pc, "EXORCIST_MASTER_STEP2_1_DLG3")
                local tx = TxBegin(pc)
                TxTakeItem(tx, "EXORCIST_MSTEP321_ITEM1", 1, 'Quest_HIDDEN_EXORCIST');
                local ret = TxCommit(tx);
                if ret == "SUCCESS" then
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 60)
                else
                    print("tx FAIL!")
                end
            end
        end
    end
end

function SCR_MASTER_BOCORS_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Bokor");
end

function SCR_MASTER_BOCORS_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Bokor', 5);
end

function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Dievdirbys");
end

function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Dievdirbys', 5);
end

--HIDDEN_RUNECASTER
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_3(self,pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop == 257 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_4') == 0 then
            ShowOkDlg(pc, 'HIDDEN_RUNECASTER_npc4_dlg1', 1)
            if isHideNPC(pc, 'RUNECASTER_SIAULIAI_WEST_STONE') == 'YES' then
                UnHideNPC(pc, 'RUNECASTER_SIAULIAI_WEST_STONE')
            end
        end
    end
end

--HIDDEN_NAKMUAY
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_4(self,pc)
    local item1 = GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM2")
    if item1 >= 48 then
        local sel = ShowSelDlg(pc, 0, 'CHAR120_MSTEP5_4_DLG1', ScpArgMsg("CHAR120_MSTEP5_4_SEL1"))
        if sel == 1 then
            local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
            ShowOkDlg(pc, 'CHAR120_MSTEP5_4_DLG2',1)
            UIOpenToPC(pc, 'fullblack', 1)
            sleep(1500)
            UIOpenToPC(pc, 'fullblack', 0)
            ShowOkDlg(pc, 'CHAR120_MSTEP5_4_DLG3',1)
            local tx1 = TxBegin(pc)
            TxTakeItem(tx1, "CHAR120_MSTEP5_4_ITEM2", GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM2"), 'Quest_HIDDEN_NAKMUAY');
            TxGiveItem(tx1, "CHAR120_MSTEP5_4_ITEM1", 1, 'Quest_HIDDEN_NAKMUAY');
            local ret = TxCommit(tx1);
            sObj.Step4 = 2
            SaveSessionObject(pc, sObj)
            if ret == "SUCCESS" then
                print("tx Success")
            else
                if isLockState == 1 then
                    SendSysMsg(pc, 'QuestItemIsLocked');
                end
                print("tx FAIL!")
            end
        end
    else
        ShowOkDlg(pc, 'CHAR120_MSTEP5_4_DLG1',1)
    end
end

--EXORCIST
function SCR_JOB_DIEVDIRBYS2_NPC_NORMAL_5(self,pc)
    if GetInvItemCount(pc, 'EXORCIST_MSTEP33_ITEM1') < 12 then
        ShowOkDlg(pc, 'EXORCIST_MASTER_STEP33_DLG2', 1)
        if SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20') < 132 then
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 132)
        end
    else
        ShowOkDlg(pc, 'EXORCIST_MASTER_STEP33_DLG3', 1)
        UIOpenToPC(pc,'fullblack',1)
        sleep(500)
        UIOpenToPC(pc,'fullblack',0)
        ShowOkDlg(pc, 'EXORCIST_MASTER_STEP33_DLG4', 1)
        local tx1 = TxBegin(pc)
        TxTakeItem(tx1, "EXORCIST_MSTEP33_ITEM1", GetInvItemCount(pc, 'EXORCIST_MSTEP33_ITEM1'), 'Quest_HIDDEN_EXORCIST');
        TxGiveItem(tx1, "EXORCIST_MSTEP33_ITEM2", 1, 'Quest_HIDDEN_EXORCIST');
        local ret = TxCommit(tx1);
        if ret == "SUCCESS" then
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 133)
        end
    end
end

function SCR_JOB_SADU3_1_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Sadhu");
end

function SCR_GELE573_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Paladin");
end

function SCR_GELE573_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Paladin', 5);
end

function SCR_JOB_PARDONER4_1_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Pardoner");
end

function SCR_JOB_PARDONER4_1_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Pardoner', 5);
end

function SCR_JOB_MONK4_1_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Monk");
end

function SCR_JOB_DRUID3_1_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Druid");
end

function SCR_MASTER_ORACLE_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Oracle");
end

function SCR_DAOSHI_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Daoshi");
end

function SCR_DAOSHI_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Daoshi', 5);
end

function SCR_INQUISITOR_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Inquisitor");
end

function SCR_INQUISITOR_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Inquisitor', 5);
end

function SCR_INQUISITOR_MASTER_NORMAL_3(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_20');
    if hidden_prop == 70 then
        local sel = ShowSelDlg(pc, 0, "CHAR4_20_STEP2_3_DLG1", ScpArgMsg("CHAR4_20_STEP2_3_SEL1"), ScpArgMsg("CHAR4_20_STEP2_3_SEL2"))
        if sel == 1 then
            ShowOkDlg(pc, "CHAR4_20_STEP2_3_DLG2", 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_20', 80);
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR4_20_STEP2_3_MSG1"), 5)
        else
            ShowOkDlg(pc, "CHAR4_20_STEP2_3_DLG3", 1)
        end
    end
end

function MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, count, sel)

    if count >= 0 then
        return 'FAIL';
    end
    local giveway = "Oracle"..sel
    local tx = TxBegin(pc); 
    TxAddIESProp(tx, aobj, "Medal", count,giveway);
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        ShowOkDlg(pc, 'JOB_ORACLE5_1_01_CANCLE', 0);
    end
    
    return ret
end

function SCR_MASTER_ORACLE_NORMAL_4(self,pc)
    local nxptakeList = {2, 1, 2, 1, 1, 1, 1, 1}

    local icon = ScpArgMsg('OraclePreMsg1')
    
    
    local return1 = GetInfoMR('WeaponEnchant', 1);
    local ret1 = GetPcNameByCID(return1);
    
    local ret2 = GetInfoMR('GainVisZone', 1);
    
    local return3 = GetInfoMR('GainVisActor', 1);
    local ret3 = GetPcNameByCID(return3);
    
    local ret4 = GetInfoMR('KillMon', 1);
    local ret5 = GetInfoMR('DeadPc', 1);
    local ret6 = GetInfoMR('KillPcByMon', 1);
    local ret7 = GetInfoMR('PartyEnter', 1);
    local ret8 = GetInfoMR('Warp', 1);
    
    local selItem = {}

    if ret1 ~= "None" then
        selItem[1] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE1')..icon..nxptakeList[1]..')'
    else
        selItem[1] = nil
    end
    if ret2 ~= "None" then
        selItem[2] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE2')..icon..nxptakeList[2]..')'
    else
        selItem[2] = nil
    end
    if ret3 ~= "None" then
        selItem[3] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE3')..icon..nxptakeList[3]..')'
    else
        selItem[3] = nil
    end
    if ret4 ~= "None" then
        selItem[4] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE4')..icon..nxptakeList[4]..')'
    else
        selItem[4] = nil
    end
    if ret5 ~= "None" then
        selItem[5] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE5')..icon..nxptakeList[5]..')'
    else
        selItem[5] = nil
    end
    if ret6 ~= "None" then
        selItem[6] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE6')..icon..nxptakeList[6]..')'
    else
        selItem[6] = nil
    end
    if ret7 ~= "None" then
        selItem[7] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE7')..icon..nxptakeList[7]..')'
    else
        selItem[7] = nil
    end
    if ret8 ~= "None" then
        selItem[8] = ScpArgMsg('MASTER_ORACLE_NORMAL_2_AGREE8')..icon..nxptakeList[8]..')'
    else
        selItem[8] = nil
    end
    
    local accFlag = 0
    for i = 1, #selItem do
        if selItem[i] == nil then
            accFlag = accFlag + 1
        end
    end
    
    if accFlag >= #selItem then
        ShowOkDlg(pc, 'MASTER_ORACLE_NORMAL_2_NODATA', 0);
        return
    end
    
    local sel = ShowSelDlg(pc, 0, 'MASTER_ORACLE_NORMAL_2_SELECT',selItem[1],selItem[2],selItem[3],selItem[4],selItem[5],selItem[6],selItem[7],selItem[8],ScpArgMsg('Auto_DaeHwa_JongLyo'))
    local aobj = GetAccountObj(pc);
    if aobj == nil or sel == nil or sel <= 0 or sel == 9 then
        ShowOkDlg(pc, 'JOB_ORACLE5_1_01_CANCLE', 0);
        return;
    end
    if GetPCTotalTPCount(pc) < nxptakeList[sel] then
        SendSysMsg(pc, "NotEnoughMedal");
        ShowOkDlg(pc, 'JOB_ORACLE5_1_01_CANCLE', 0);
        return;
    end

    
    local beforeDayStr, curDayStr = GetTimeMR();

    local isgetvalidinfo = false;


    if sel == 8 then
        local zone = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('Warp', i);
            local mapCls = GetClass("Map", name);
            zone[i] = mapCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if zone[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1_2', "rank", i, "zone", zone[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 4 then
        local zone = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('KillMon', i);
            local mapCls = GetClass("Map", name);
            zone[i] = mapCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if zone[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER2_2', "rank", i, "zone", zone[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 5 then
        local zone = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('DeadPc', i);
            local mapCls = GetClass("Map", name);
            zone[i] = mapCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if zone[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER3_2', "rank", i, "zone", zone[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 6 then
        local mon = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('KillPcByMon', i);
            local monCls = GetClass("Monster", name);
            mon[i] = monCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if mon[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER4_2', "rank", i, "mon", mon[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 2 then
        local zone = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('GainVisZone', i);
            local mapCls = GetClass("Map", name);
            zone[i] = mapCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if zone[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER5_2', "rank", i, "zone", zone[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 7 then
        local zone = {}
        local count = {}
        local dialog_txt = ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER1', "day1", beforeDayStr,"day2", curDayStr)
        for i = 1, 3 do
            local name, value = GetInfoMR('PartyEnter', i);         
            local mapCls = GetClass("Map", name);
            if mapCls ~= nil then
                zone[i] = mapCls.Name
                count[i] = NUM_KILO_CHANGE(value)
            else
                zone[i] = 'None'
                count[i] = 0;
            end
            if zone[i] ~= "None" then
                dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER6_2', "rank", i, "zone", zone[i],"count", count[i])
                isgetvalidinfo = true;
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 1 then
        local team = {}
        local character = {}
        local item = {}
        local count = {}
        local dialog_txt = ""
        for i = 1, 3 do
            local name, value, itemID = GetInfoMR('WeaponEnchant', i);
            local teamName, charName = GetPcNameByCID(name);
            local itemCls = GetClassByType("Item", itemID);
            team[i] = teamName
            character[i] = charName
            item[i] = itemCls.Name
            count[i] = NUM_KILO_CHANGE(value)
            if team[i] ~= "None" then
                if i == 1 then
                    dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER7', "rank", i, "team", team[i], "character", character[i], "item", item[i], "count", count[i])
                    isgetvalidinfo = true;
                else
                    dialog_txt = dialog_txt.."{nl}"..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER7', "rank", i, "team", team[i], "character", character[i], "item", item[i], "count", count[i])
                    isgetvalidinfo = true;
                end
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    elseif sel == 3 then
        local team = {}
        local character = {}
        local count = {}
        local dialog_txt = ""
        for i = 1, 3 do
            local name, value = GetInfoMR('GainVisActor', i);
            local teamName, charName = GetPcNameByCID(name);
            team[i] = teamName
            character[i] = charName
            count[i] = NUM_KILO_CHANGE(value)
            if team[i] ~= "None" then
                if i == 1 then
                    dialog_txt = dialog_txt..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER8', "rank", i, "team", team[i], "character", character[i], "count", count[i])
                    isgetvalidinfo = true;
                else
                    dialog_txt = dialog_txt.."{nl}"..ScpArgMsg('MASTER_ORACLE_NORMAL_2_ANSWER8', "rank", i, "team", team[i], "character", character[i], "count", count[i])
                    isgetvalidinfo = true;
                end
            end
        end
        if isgetvalidinfo == true then
            local ret = MASTER_ORACLE_NORMAL_2_MEDAL_TAKE_TX(pc, aobj, -nxptakeList[sel], sel)
            ShowOkDlg(pc, 'JOB_ORACLE5_1_01' .. "\\" .. dialog_txt, 0);
        end
    end

    if isgetvalidinfo == false then
        ShowOkDlg(pc, 'JOB_ORACLE5_1_01_CANCLE', 0);
        return;
    end
end

function SCR_ZEALOT_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Zealot");
end

function SCR_EXORCIST_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Exorcist");
end

function SCR_EXORCIST_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Exorcist', 5);
end

function SCR_OPEN_ABILSHOP(pc, shopName)

    SendAddOnMsg(pc, "ABILSHOP_OPEN", shopName, 0);
    if GET_REAMIN_ABILTIME(pc) <= 0 then
         SetExProp_Str(pc, "ABILSHOP_OPEN", shopName);
    end
end


function SCR_MASTER_QU_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_20 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_20 = 300
        --print(main_ssn.FIRETOWER_45_HQ_01_20)    
    end    
    COMMON_QUEST_HANDLER(self, pc);    
end



function SCR_MASTER_RANGER_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_21 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_21 = 300
        --print(main_ssn.FIRETOWER_45_HQ_01_21)    
    end    
    COMMON_QUEST_HANDLER(self, pc);    
end




function SCR_JOB_RANGER_2_FAIL(self, tx)
    local itemCnt = GetInvItemCount(self, 'Book6')
    if itemCnt >= 1 then
--        local tx_Quest = TxBegin(self);
        TxTakeItem(tx, "Book6", itemCnt, 'Quest');
--        local ret = TxCommit(tx);
--        
    end
end


function SCR_MASTER_CLERIC_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_28 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_28 = 300   
        --print( main_ssn.FIRETOWER_45_HQ_01_28) 
    end    
    COMMON_QUEST_HANDLER(self, pc);    
end

function SCR_TUTO_CLERIC_SUCC(pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Cleric")
end

function SCR_MASTER_PRIEST_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_30 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_30 = 300   
        --print(main_ssn.FIRETOWER_45_HQ_01_30)  
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_MASTER_KRIWI_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_29 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_29 = 300   
        --print(main_ssn.FIRETOWER_45_HQ_01_29) 
    end
    COMMON_QUEST_HANDLER(self, pc);    
end


function SCR_JOB_KRIWI1_OUT_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc);
end

function SCR_CREATE_SSN_JOB_PRIEST1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_REENTER_SSN_JOB_PRIEST1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_DESTROY_SSN_JOB_PRIEST1(self, sObj)
end


function SCR_CREATE_SSN_JOB_KRIWI1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_REENTER_SSN_JOB_KRIWI1(self, sObj)
    ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')               
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
end

function SCR_DESTROY_SSN_JOB_KRIWI1(self, sObj)
end




function SCR_ADD_PROPERTY(self)

    print(ScpArgMsg('Auto_iKeo_SayongHaNeun_KweSeuTeuDeul_JeKeoHaeJuSemyeo._TeugSeong_SilBeoLo_SaNeunKeolLo_BaKkwim.'))
  --  SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg('Auto_TeugSeong_PoinTeuLeul_HoegDeugHayeossSeupNiDa'), 5);
   -- AddPCProp(self, 'PropertyByBonus', 1);
end


function SCR_MASTER_SWORDMAN_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_1 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_1 = 300
        --print(main_ssn.FIRETOWER_45_HQ_01_1)
    end
    COMMON_QUEST_HANDLER(self, pc);    
end

function SCR_MASTER_SWORDMAN_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Warrior");
end

function SCR_TUTO_SWORDMAN_SUCC(pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Warrior")
end

function SCR_MASTER_WIZARD_DIALOG(self, pc)
    --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_10 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_10 = 300
        --print(main_ssn.FIRETOWER_45_HQ_01_10)
    end
    COMMON_QUEST_HANDLER(self, pc);    
end

function SCR_MASTER_WIZARD_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Wizard");
end

function SCR_MASTER_WIZARD_NORMAL_2(self, pc)
   ShowTradeDlg(pc, 'MASTER_WIZARD', 5);
end

function SCR_TUTO_WIZARD_SUCC(pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Wizard")
end

function SCR_MASTER_ARCHER_DIALOG(self, pc)
     --for search FIRETOWER_45_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.FIRETOWER_45_HQ_01_19 ~= 300 then
        main_ssn.FIRETOWER_45_HQ_01_19 = 300
        --print(main_ssn.FIRETOWER_45_HQ_01_19)
    end   
    COMMON_QUEST_HANDLER(self, pc);    
end




function SCR_TUTO_ARCHER_SUCC(pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Archer")
end








function SCR_CREATE_SSN_TUTO_SKILL_RUN(self, sObj)
    SCR_REGISTER_QUEST_PROP_HOOK(self, sObj);
    SetTimeSessionObject(self, sObj, 2, 1000, 'SCR_TUTOSKILL_RUN')
end

function SCR_REENTER_SSN_TUTO_SKILL_RUN(self, sObj)
    SCR_CREATE_SSN_TUTO_SKILL_RUN(self, sObj);
end

function SCR_DESTROY_SSN_TUTO_SKILL_RUN(self, sObj)
end


function SCR_TUTOSKILL_RUN(self, sObj)
    if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
        if TUTO_SKILL_CK(self) > 0 then
            SendAddOnMsg(self, 'HELP_MSG_CLOSE', "", 0)
            sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
        end
    end
end


function SCR_JOB_SWORDMAN1_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc);
end

function SCR_SSN_JOB_SWORDMAN1_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end
function SCR_CREATE_SSN_JOB_SWORDMAN1(self, sObj)
    SCR_SSN_JOB_SWORDMAN1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_SWORDMAN1(self, sObj)
    SCR_SSN_JOB_SWORDMAN1_BASIC_HOOK(self, sObj)
    ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')               
end

function SCR_DESTROY_SSN_JOB_SWORDMAN1(self, sObj)
end



function SCR_CREATE_SSN_JOB_ARCHER1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_REENTER_SSN_JOB_ARCHER1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_DESTROY_SSN_JOB_ARCHER1(self, sObj)
end


function SCR_CREATE_SSN_JOB_CLERIC1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_REENTER_SSN_JOB_CLERIC1(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
    RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_DESTROY_SSN_JOB_CLERIC1(self, sObj)
end


function TUTO_PIP_CLOSE_QUEST(self)
    SendAddOnMsg(self, 'HELP_MSG_CLOSE', "", 10)
end

function SCR_TEMP_JOBCHANGE_RANK(pc,funcInfo)
    local etc = GetETCObject(pc);
    if etc.JobChanging == 0 then
        local tarJobRank = funcInfo[2]
        local tarJobname = funcInfo[3]
        local jobCircle, jobRank = GetJobGradeByName(pc, pc.JobName)
        local jobIES = GetClass('Job', tarJobname)
        
        if jobRank == tarJobRank - 1 and GetJobLv(pc) == 15 then
            if jobIES.Rank == tarJobRank - 2 then
                return 'YES'
            elseif jobIES.Rank == tarJobRank - 1 then
                return 'YES'
            elseif jobIES.Rank == tarJobRank then
                return 'YES'
            end
        end
    end
end

function SCR_TEMP_JOBCHANGE_RANK_EXE(self, pc,funcInfo)
    local sel = ShowSelDlg(pc, 0, 'TEMP_JOBCHANGE_RANK_7_DIALOG', ScpArgMsg('TEMP_JOBCHANGE_RANK_7_OK'),ScpArgMsg('Close'))
    if sel == 1 then
        local tx = TxBegin(pc);
        local tarJobname = funcInfo[3]
        TxChangeJob(tx, tarJobname);
        local ret = TxCommit(tx);
    end
end


--SHADOW MANCER

function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_1_PRE(pc)
    local is_Unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char2_19') -- checking if you shadowmancer unlocked
    if is_Unlock == "NO" then
        local hiddenProp = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
        if hiddenProp == 2 then -- if you meet CHRONOMANCER MASTER
            return "YES"
        end
    end
    return "NO"
end

function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_1(self, pc)
    SCR_JOB_SHADOWMANCER_MASTER_UNLOCK_DOING(self, pc)
end


function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_2_PRE(pc)
    local is_Unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char2_19') -- checking if you shadowmancer unlocked
    if is_Unlock == "NO" then
        local hiddenProp = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
        if hiddenProp == 3 or hiddenProp == 4 then -- if you check shadowmancer's existent or if you accept shadowmancer's request
            return "YES"
        end
    end
    return "NO"
end

function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_2(self, pc)
    SCR_JOB_SHADOWMANCER_MASTER_UNLOCK_DOING(self, pc)
end


function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_3_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_19')
end

function SCR_JOB_SHADOWMANCER_MASTER_NORMAL_3(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Shadowmancer");
end

function SCR_JOB_DRUID3_1_NPC_NORMAL_2_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step3 == 1 or sObj.Step4 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_JOB_DRUID3_1_NPC_NORMAL_2(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT2")
            if sObj.Step3 == 1 then
                if sObj.Goal3 == 0 then
                    local sel = ShowSelDlg(pc, 1, "CHAR220_MSETP2_2_1_DLG1", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        sObj.Goal3 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_1_DLG1_1", 1)
                        sleep(500)
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                        return
                    end
                elseif sObj.Goal3 == 1 then
                    local max_cnt = 15
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_2_1_ITEM1")
                    if cnt >= max_cnt then
                        sObj.Goal3 = 10
                        SaveSessionObject(pc, sObj)
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_2_1_ITEM1", cnt, "CHAR220_MSTEP2_2_1");
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_1_DLG3", 1)
                        sleep(500)
                        PlayEffectLocal(self, pc, "F_light047_red", 0.8, 0, "TOP")
                        sleep(2000)
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_1_DLG3_1", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_1_DLG2", 1)
                        sleep(500)
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_2_1_DLG4", 1)
                end
            elseif sObj.Step4 == 1 then
                if sObj.Goal4 == 0 then
                    local sel_dlg = "CHAR220_MSETP2_2_2_DLG1_CASE1"
                    local result = SCR_QUEST_CHECK(pc, 'FARM49_1_MQ05')
                    if result ~= 'COMPLETE' then
                        sel_dlg = "CHAR220_MSETP2_2_2_DLG1_CASE2"
                    end
                    local sel = ShowSelDlg(pc, 1, sel_dlg, ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        sObj.Goal4 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_2_DLG1_1", 1)
                        return
                    end
                elseif sObj.Goal4 == 1 then
                    local max_cnt = 15
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_2_2_ITEM1")
                    if cnt >= max_cnt then
                        sObj.Goal4 = 10
                        SaveSessionObject(pc, sObj)
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_2_2_ITEM1", cnt, "CHAR220_MSTEP2_2_2");
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_2_DLG3", 1)
                        sleep(500)
                        PlayEffectLocal(self, pc, "F_light047_red", 0.8, 0, "TOP")
                        sleep(2000)
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_2_DLG3_1", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_2_2_DLG2", 1)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_2_2_DLG4", 1)
                end
            end
        end
    end
end

function SCR_JOB_CORSAIR4_NPC_NORMAL_2_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step6 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_JOB_CORSAIR4_NPC_NORMAL_2(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT4")
            if sObj.Step6 == 1 then
                if sObj.Goal6 == 0 then
                    local tx = TxBegin(pc);
                    if isHideNPC(pc, "CHAR220_MSETP2_4_NPC") == "YES" then
                        TxUnHideNPC(tx, 'CHAR220_MSETP2_4_NPC')
                    end
                    local ret = TxCommit(tx);
                    if ret == "SUCCESS" then
                        sObj.Goal6 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_4_DLG1", 1)
                    end
                    return
                elseif sObj.Goal6 >= 1 and sObj.Goal6 < 500 then
                    local tx = TxBegin(pc);
                    if isHideNPC(pc, "CHAR220_MSETP2_4_NPC") == "YES" then
                        TxUnHideNPC(tx, 'CHAR220_MSETP2_4_NPC')
                    end
                    local ret = TxCommit(tx);
                    ShowOkDlg(pc, "CHAR220_MSETP2_4_DLG2", 1)
                elseif sObj.Goal6 == 500 then
                    local tx = TxBegin(pc);
                    if isHideNPC(pc, "CHAR220_MSETP2_4_NPC") == "NO" then
                        TxHideNPC(tx, 'CHAR220_MSETP2_4_NPC')
                    end
                    local ret = TxCommit(tx);
                    if ret == "SUCCESS" then
                        sObj.Goal6 = 1000
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_4_DLG8", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    end
                else
                    local tx = TxBegin(pc);
                    if isHideNPC(pc, "CHAR220_MSETP2_4_NPC") == "NO" then
                        TxHideNPC(tx, 'CHAR220_MSETP2_4_NPC')
                    end
                    local ret = TxCommit(tx);
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_4_DLG9", 1)
                end
            end
        end
    end
end

--ONMYOJI_MASTER

function SCR_ONMYOJI_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_20')
end

function SCR_ONMYOJI_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Onmyoji");
end

function SCR_ONMYOJI_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'ONMYOJI_MASTER', 5);
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_5(self,pc)
    SetExProp(pc, 'LEGEND_NPC_HANDLE', GetHandle(self));
    UIOpenToPC(pc, 'legendprefix',1)
end

function SCR_SIAULIAIOUT_ALCHE_A_NORMAL_6(self,pc)
    UIOpenToPC(pc, 'legenddecompose',1)
end

function SCR_MASTER_ORACLE_NORMAL_3_PRE(pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 30 then
        return 'YES'
    end
end

function SCR_MASTER_ORACLE_NORMAL_3(self, pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 30 then
        if prop < 40 then
            local select = ShowSelDlg(pc, 0, 'CHAR312_PRE_MSTEP3_ORACLE_DLG1', ScpArgMsg("CHAR312_PRE_MSTEP3_ORACLE_TXT1"), ScpArgMsg("CHAR312_PRE_MSTEP3_ORACLE_TXT2"))
            if select == 1 then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR312_PRE_MSTEP3_ORACLE_TXT3"), 'TALK', 3)
                if result == 1 then
                    ShowOkDlg(pc, 'CHAR312_PRE_MSTEP3_ORACLE_DLG2', 1)
                    local tx = TxBegin(pc)
                    if GetInvItemCount(pc, "CHAR312_PRE_MSTEP_ITEM") < 1 then
                        TxGiveItem(tx,"CHAR312_PRE_MSTEP_ITEM", 1, 'Quest_HIDDEN_PIED_PIPER');
                    end
                    if isHideNPC(pc, "PIED_PIPER_MASTER") == "YES" then
                        TxUnHideNPC(tx, 'PIED_PIPER_MASTER')
                    end
                    local etc = GetETCObject(pc);
                    TxSetIESProp(tx, etc, "HiddenJob_Char3_12", 40);
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        ShowOkDlg(pc, "CHAR312_PRE_MSTEP3_ORACLE_DLG3", 1)
                    end
                end
            end
        else
            ShowOkDlg(pc, "CHAR312_PRE_MSTEP3_ORACLE_DLG4", 1)
        end
    end
end

function SCR_MASTER_ORACLE_NORMAL_2(self,pc)
    local select = ShowSelDlg(pc, 0, 'SOLO_DUNGEON_SELECT_DLG', ScpArgMsg('SoloDungeonSelectMsg_1'), ScpArgMsg('SoloDungeonSelectMsg_2'), ScpArgMsg('SoloDungeonSelectMsg_3'))
    if pc.Lv >= 300 then
        if select == 1 then
            ShowOkDlg(pc, 'SOLO_DUNGEON_SELECT_DLG2', 1)
            local missionID  = OpenMissionRoom(pc, 'SOLO_DUNGEON_MINI', "");
            ReqMoveToMission(pc, missionID);
        end
    else
        if select == 1 then
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("SoloDungeonSelectMsg_4"), 5)
            ShowOkDlg(pc, 'SOLO_DUNGEON_SELECT_DLG3', 1)
        end
    end
    if select == 2 then
        SendSoloDungeonCurrentRanking(pc, "All");
        SendSoloDungeonCurrentRanking(pc, "Warrior");
        SendSoloDungeonCurrentRanking(pc, "Wizard");
        SendSoloDungeonCurrentRanking(pc, "Archer");
        SendSoloDungeonCurrentRanking(pc, "Cleric");
    
        SendSoloDungeonPrevRanking(pc, "All")
        SendSoloDungeonPrevRanking(pc, "Warrior")
        SendSoloDungeonPrevRanking(pc, "Wizard")
        SendSoloDungeonPrevRanking(pc, "Archer")
        SendSoloDungeonPrevRanking(pc, "Cleric")
    
        SendSoloDungeonCurrentMyRanking(pc, "All")
        SendSoloDungeonCurrentMyRanking(pc, "Warrior")
        SendSoloDungeonCurrentMyRanking(pc, "Wizard")
        SendSoloDungeonCurrentMyRanking(pc, "Archer")
        SendSoloDungeonCurrentMyRanking(pc, "Cleric")
    
        SendSoloDungeonPrevMyRanking(pc, "All")
        SendSoloDungeonPrevMyRanking(pc, "Warrior")
        SendSoloDungeonPrevMyRanking(pc, "Wizard")
        SendSoloDungeonPrevMyRanking(pc, "Archer")
        SendSoloDungeonPrevMyRanking(pc, "Cleric")
    
        SendAddOnMsg(pc, "DO_SOLODUNGEON_RANKINGPAGE_OPEN")
    end
end