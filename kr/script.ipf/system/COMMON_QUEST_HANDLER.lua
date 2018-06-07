-- COMMON_QUEST_HANDLER.lua


function COMMON_QUEST_HANDLER(self,pc, npcfuncname)
--    if npcfuncname ~= nil then
--        npcfuncname = string.gsub(string.gsub(string.gsub(string.gsub(npcfuncname,'SCR_',''),'_DIALOG',''),'_ENTER',''),'_LEAVE','')
--    end
    
    if pc == nil or pc.ClassName ~= 'PC' then
        return
    end
    
    if npcfuncname ~= nil then
        if isHideNPC(pc, npcfuncname) == 'YES' then
            return
        end
    elseif self ~= nil then
        if GetPropType(self,'Dialog') ~= nil and self.Dialog ~= 'None' then
            if isHideNPC(pc, self.Dialog) == 'YES' then
                return
            end
        end
        if GetPropType(self,'Enter') ~= nil and self.Enter ~= 'None' then
            if isHideNPC(pc, self.Enter) == 'YES' then
                return
            end
        end
        if GetPropType(self,'Leave') ~= nil and self.Leave ~= 'None' then
            if isHideNPC(pc, self.Leave) == 'YES' then
                return
            end
        end
    end
    
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_COMMON_QUEST_HANDLER_PCKa_nilin_Kyeongu_BalSaeng_L_3_")..self.ClassName.. GetZoneName(pc))
        DumpCallStack()
    end
    
    SCR_DIALOG_ANIM(self,pc)            
        
    
    
    local quest_list = {};        
    local quest_name = {};    
    local npc_normal = {};
    local npc_normal_check = {};               
    local select_dialog ;       
    local i;
    local y = 1;
    local x = 1;
    local selfname
    local npcquestcount_list = {}

    local rt_questname = 'None'
    local rt_questname_beforestate = 'None'
    
    if npcfuncname ~= nil then
        selfname = npcfuncname
    else
        if self.Dialog ~= 'None' and self.Dialog ~= '' then
            selfname = self.Dialog;
        elseif self.Enter ~= 'None' and self.Enter ~= '' then
            selfname = self.Enter;
        elseif self.Leave ~= 'None' and self.Leave ~= '' then
            selfname = self.Leave;
        end
    end
    local npcselectdialog = GetClass('NPCSelectDialog', selfname);
    
    if npcselectdialog ~= nil then
        select_dialog = npcselectdialog.SelectDialog;
        
        if npcselectdialog.SD_QuestDialog1 ~= 'None' or npcselectdialog.SD_QuestDialog2 ~= 'None' or npcselectdialog.SD_QuestDialog3 ~= 'None' or npcselectdialog.SD_QuestDialog4 ~= 'None' or npcselectdialog.SD_QuestDialog5 ~= 'None' then
            local condition_select_dialog = SCR_QUESTCONDITION_SELECTDIALOG(self, pc, selfname)
            if condition_select_dialog ~= nil then
                select_dialog = condition_select_dialog
            end
        end
        
        select_dialog = SCR_DLG_RANDOM(pc, select_dialog, 'SELECT')
        
        for i = 1, 50 do
            if npcselectdialog['QuestName'..i] ~= 'None' then
                quest_list[y] = npcselectdialog['QuestName'..i];
                quest_name[y] = GetClassString('QuestProgressCheck', npcselectdialog['QuestName'..i], 'Name');
                y = y + 1;
            end
        end
        for i = 1, MAX_NORMALDIALOG_COUNT do
            if npcselectdialog['NormalDialog'..i] ~= 'None' then
                if SCR_NORMALDIALOG_CHECK(pc, npcselectdialog['NormalDialog'..i..'_Condition'], npcselectdialog['NormalDialog'..i..'_PrecheckScript'], npcselectdialog['NormalDialog'..i..'_Quest'], npcselectdialog['NormalDialog'..i..'_QuestState'], npcselectdialog['NormalDialog'..i..'_Level'] ) == 'YES' then
                    npc_normal[x] = npcselectdialog['NormalDialog'..i]
                    x = x + 1;
                    npc_normal_check[#npc_normal_check + 1] = i
                end
            end
        end
    else
        ErrorLog('Quest NPC : '..selfname..ScpArgMsg("Auto_NPCSelectDialog_xmle_HaeDang_NPCui_KweSeuTeu/KiBonKiNeung_i_DeungLogDoeeo_issJi_anSeupNiDa"))
        return
    end
    
    for i = 1, 4 do
        if GetPropType(self,'QuestCount'..i) ~= nil then
            npcquestcount_list[#npcquestcount_list + 1] = self['QuestCount'..i]
        end
    end
    
    local quest_count, quest_check, quest_succ, quest_progress, lvImpossibleList = SCR_QUESTPROGRESS_CHECK( pc, quest_list, quest_name, npcquestcount_list);
    
    if #lvImpossibleList > 0 then
        local txt = ScpArgMsg("LvImpossibleQuestMsg").."{nl}"
        local flag = false
        for i = 1, #lvImpossibleList do
            local impossibleIES = GetClass('QuestProgressCheck',lvImpossibleList[i])
            if selfname == impossibleIES.StartNPC then
                txt = txt..impossibleIES.Name..' : Lv '..impossibleIES.Lvup..'{nl}'
                flag = true
            end
        end
        if flag == true then
            txt = string.sub(txt, 1, string.len(txt) - 4)
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll',txt, 15)
        end
    end
    
    if quest_count + quest_succ + quest_progress + #npc_normal ~= 0 then
        if self ~= nil and IsBuffApplied(pc, 'DialogSafe') == 'NO' then
            local flag = 0
            if self.Dialog ~= 'None' then 
                if self.Enter == 'None' and self.Leave == 'None' then
                    flag = 1
                elseif (self.Enter ~= 'None' or self.Leave ~= 'None') and self.Dialog == npcfuncname then
                    flag = 1
                end
            end
            if flag == 1 then
                if self ~= nil then
                    local npcOwner = GetOwner(self)
                    if npcOwner == nil or IsSameActor(npcOwner, pc) == "NO" then
                        AddBuff(pc, pc, 'DialogSafe', 1, 0, 0, 1)
                    end
                end
            end
        end
        
        select_quest, select_condition, direct_quest = SCR_QUESTSELECT(self, pc, selfname, quest_check, quest_count, quest_progress, quest_succ, npc_normal, quest_list, quest_name, select_dialog);
        if select_quest == nil then
            return
        end
        rt_questname = quest_list[select_quest]
        if select_quest == -100 then
            return
        elseif select_quest == 0 then
            rt_questname = direct_quest
        elseif select_quest == -10 then
            if npcselectdialog.IdleDialog ~= 'None' then
                local idledialog = npcselectdialog.IdleDialog
                if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
                    local condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                    if condition_idledialog ~= nil then
                        idledialog = condition_idledialog
                    end
                end
                
                SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, idledialog)
                
--                idledialog = SCR_DLG_RANDOM(pc, idledialog)
--                ShowOkDlg(pc,idledialog, 1);
            end
        elseif select_condition ~= nil then
            
            rt_questname_beforestate = select_condition
            
            local questIES = GetClass('QuestProgressCheck', quest_list[select_quest]);
            local quest_auto = GetClass('QuestProgressCheck_Auto', quest_list[select_quest]);
            
            if quest_auto ~= nil then
                local sObj = GetSessionObject(pc, 'ssn_klapeda');
                
                if select_condition == 'POSSIBLE' then
                    if questIES.StartNPC == selfname then
                        
                        SCR_QUEST_POSSIBLE(pc, quest_list[select_quest], self,selfname)
                    else
                        if npcselectdialog.IdleDialog ~= 'None' then
                            local idledialog = npcselectdialog.IdleDialog
                            if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
                                local condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                                if condition_idledialog ~= nil then
                                    idledialog = condition_idledialog
                                end
                            end
                            
                            SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, idledialog)
                            
--                            idledialog = SCR_DLG_RANDOM(pc, idledialog)
--                            ShowOkDlg(pc,idledialog, 1);
                        end
                    end
                elseif select_condition == 'PROGRESS' then
                    local isStartNPC = 'NO'
                    
                    if questIES.StartNPC == selfname then
                        isStartNPC = 'YES'
                    end
                    if questIES.ProgNPC == selfname then
                        
                        SCR_QUEST_PROGRESS(self, pc, quest_list[select_quest], isStartNPC, selfname)
                    elseif questIES.StartNPC == selfname then
                        if quest_auto.Progress_StartNPCDialog1 ~= 'None' then
                            SCR_QUEST_LINE(pc, self, quest_auto.Progress_StartNPCDialog1, nil, isStartNPC, quest_list[select_quest], nil, 'Progress')
                        end
                    else
                        if npcselectdialog.IdleDialog ~= 'None' then
                            local idledialog = npcselectdialog.IdleDialog
                            if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
                                local condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                                if condition_idledialog ~= nil then
                                    idledialog = condition_idledialog
                                end
                            end
                            
                            SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, idledialog)
--                            idledialog = SCR_DLG_RANDOM(pc, idledialog)
--                            ShowOkDlg(pc,idledialog, 1);
                        end
                    end
                elseif select_condition == 'SUCCESS' then
                    if questIES.EndNPC == selfname then
                        SCR_QUEST_SUCCESS(pc, quest_list[select_quest], self, selfname)
                    elseif questIES.StartNPC == selfname then
                        if quest_auto.Success_StartNPCDialog1 ~= 'None' then
                            SCR_QUEST_LINE(pc, self,quest_auto.Success_StartNPCDialog1, nil, nil, quest_auto.ClassName, nil, 'Success')
                        end
                    elseif questIES.ProgNPC == selfname then
                        if quest_auto.Success_ProgNPCDialog1 ~= 'None' then
                            SCR_QUEST_LINE(pc, self, quest_auto.Success_ProgNPCDialog1, nil, nil, quest_auto.ClassName, nil, 'Success')
                        end
                    else
                        if npcselectdialog.IdleDialog ~= 'None' then
                            local idledialog = npcselectdialog.IdleDialog
                            if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
                                local condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                                if condition_idledialog ~= nil then
                                    idledialog = condition_idledialog
                                end
                            end
                            
                            SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, idledialog)
                            
--                            idledialog = SCR_DLG_RANDOM(pc, idledialog)
--                            ShowOkDlg(pc,idledialog, 1);
                        end
                    end
                end
            else
                local funcquest = _G['SCR_'..selfname..'_'..quest_list[select_quest]];
                if funcquest ~= nil then
                    funcquest(self, pc, select_condition);
                end
            end
        else
            local npcQuestFlag = false
            for i = 1, #quest_check do
                if selfname ~= nil then
                    if quest_check[i] == 'POSSIBLE' then
                        local questIES = GetClass('QuestProgressCheck', quest_list[i]);
                        if questIES ~= nil then
                            if questIES.StartNPC == selfname then
                                npcQuestFlag = true
                                break
                            end
                        end
                    elseif quest_check[i] == 'PROGRESS' then
                        local questIES = GetClass('QuestProgressCheck', quest_list[i]);
                        if questIES ~= nil then
                            if questIES.StartNPC == selfname or questIES.ProgNPC == selfname then
                                npcQuestFlag = true
                                break
                            end
                        end
                    elseif quest_check[i] == 'SUCCESS' then
                        local questIES = GetClass('QuestProgressCheck', quest_list[i]);
                        if questIES ~= nil then
                            if questIES.StartNPC == selfname or questIES.ProgNPC == selfname or questIES.EndNPC == selfname then
                                npcQuestFlag = true
                                break
                            end
                        end
                    end
                end
            end
            
            local npc_normal_select =  npc_normal_check[select_quest-#quest_list]
            
            if #npc_normal_check == 1 and npcQuestFlag == false then
                local normalbeforedialog = npcselectdialog['NormalBeforeDialog'..npc_normal_select]
                
                local condition_idledialog
                if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
                    condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                    if condition_idledialog ~= nil then
                        SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, condition_idledialog)
                    end
                end
                
                if condition_idledialog == nil and normalbeforedialog ~= 'None' then
                    normalbeforedialog = SCR_DLG_RANDOM(pc, normalbeforedialog)
                    ShowOkDlg(pc,normalbeforedialog, 1)
                end
            end
            
            local jobChangeTemp = SCR_STRING_CUT(npcselectdialog['NormalDialog'..npc_normal_select..'_PrecheckScript'])
            if jobChangeTemp[1] ~= 'None' and jobChangeTemp[1] =='SCR_TEMP_JOBCHANGE_RANK' then
                local funcnormal = _G['SCR_TEMP_JOBCHANGE_RANK_EXE']
                funcnormal(self,pc,jobChangeTemp)
            else
                local funcnormal = _G['SCR_'..selfname..'_NORMAL_'..npc_normal_select];
                if funcnormal ~= nil then
                    funcnormal(self, pc);
                end
            end
        end
    else
        if npcselectdialog.IdleDialog ~= 'None' then
            local idledialog = npcselectdialog.IdleDialog
            
            if npcselectdialog.ID_QuestDialog1 ~= 'None' or npcselectdialog.ID_QuestDialog2 ~= 'None' or npcselectdialog.ID_QuestDialog3 ~= 'None' or npcselectdialog.ID_QuestDialog4 ~= 'None' or npcselectdialog.ID_QuestDialog5 ~= 'None' then
               
                local condition_idledialog = SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
                if condition_idledialog ~= nil then
                    idledialog = condition_idledialog
                end
            end
            SCR_NPC_EXPLAIN_SELECT(self, pc, selfname, idledialog)
            
--            idledialog = SCR_DLG_RANDOM(pc, idledialog)
--            ShowOkDlg(pc,idledialog, 1);
        end
    end

    return rt_questname, rt_questname_beforestate
end



function SCR_QUEST_POSSIBLE(pc, questname, self, selfname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_POSSIBLE_PCKa_nilin_Kyeongu_BalSaeng_L_251_")..questname)
        DumpCallStack()
    end
    
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    local select_state
    local select2
    if questIES == nil or quest_auto == nil then
        print('ERROR QUEST QuestName NULL',questname)
    end
    
    
    local result = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Possible_PCLoopAnim, questname, 'TRACK_BEFORE')
    SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
    if result == 'NO' then
        return
    end
    
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    if sObj ~= nil then
        if questIES.ReenterTime ~= 'None' then
            local sec_min, sec_max = string.match(questIES.ReenterTime, '(%d+)/(%d+)')
            sec_min = tonumber(sec_min)
            sec_max = tonumber(sec_max)
            if sec_min ~= nil and sec_max ~= nil then
                if sec_min <= sec_max then
                    local reentertime_random = IMCRandom(sec_min, sec_max)
                    local now_time = os.date('*t')
                    local reenter_next = (now_time['year'] - 2000) * 3600 * 24 * 365 + now_time['yday'] * 3600 * 24 + now_time['hour'] * 3600 + now_time['min'] * 60 + now_time['sec'] + reentertime_random
                    sObj[questIES.QuestPropertyName..'_RT'] = reenter_next
					QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName..'_RT', "StateChange", "State", reenter_next);

                    SaveSessionObject(pc,sObj)
                else
                    print(questname,ScpArgMsg("Auto_KweSeuTeuui_ReenterTime_KeolLeom_min_Kapi_max_KapBoDa_Jagaya_Ham"))
                end
            else
                print(questname,ScpArgMsg("Auto_KweSeuTeuui_ReenterTime_KeolLeom_HyeongSig_oLyu_EX>_SusJa/SusJa"))
            end
        end
    else
        print(questname,ScpArgMsg("Auto_KweSeuTeuui_StartArea_Mein_MaeNiJeo_SeSyeon_oBeuJegTeuKa_BiJeongSang_ipNiDa."))
    end
    
    
    if quest_auto.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] == 'None' then
        local tx = TxBegin(pc);
            TxEnableInIntegrate(tx)
            SCR_QUEST_RANDOMREWARD_SET(tx, pc, sObj, questIES, quest_auto)
        local ret = TxCommit(tx, 1);
		if ret == 'FAIL' then
			PrintLogLine(quest_auto.Name, "QUEST RandomReward Setting Transaction FAIL")
		    return 'Transaction FAIL';
		end
    end
    
    if quest_auto.Possible_SelectDialog1 == 'None' then
        SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil , selfname)
    else
        
        if string.find(quest_auto.Possible_SelectDialog1, '/') == nil then
            if quest_auto.Possible_AnswerExplain ~= 'None' then
                if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
                    local agree = quest_auto.Possible_AnswerAgree
                    local cancel = quest_auto.Possible_AnswerCancel
                    
                    if agree == 'None' then
                        agree = nil
                    end
                    
                    if cancel == 'None' then
                        cancel = nil
                    end
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    select2 = ShowSelDlg(pc, 0 , dlg , questname, agree, quest_auto.Possible_AnswerExplain, cancel)
                    if select2 == 1 then
                        select_state = 'AGREE'
                    elseif select2 == 2 then
                        select_state = 'EXPLAIN'
                    else
                        select_state = 'CANCEL'
                    end
                else
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    ShowSelDlg(pc, 0 , dlg, quest_auto.Possible_AnswerExplain)
                    select_state = 'EXPLAIN'
                end
            else
                if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
                    local agree = quest_auto.Possible_AnswerAgree
                    local cancel = quest_auto.Possible_AnswerCancel
                    
                    if agree == 'None' then
                        agree = nil
                    end
                    
                    if cancel == 'None' then
                        cancel = nil
                    end
                    
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    select2 = ShowSelDlg(pc, 0 ,  dlg, questname, agree, cancel)
                    if select2 == 1 then
                        select_state = 'AGREE'
                    else
                        select_state = 'CANCEL'
                    end
                else
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    ShowOkDlg(pc, dlg,1)
                    select_state = 'AGREE'
                end
            end
            if select_state == 'AGREE' then
                SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil, selfname)
            elseif select_state == 'CANCEL' then
                SCR_QUEST_POSSIBLE_CANCEL(pc, questname)
            elseif select_state == 'EXPLAIN' then
                SCR_QUEST_POSSIBLE_EXPLAIN(pc, questname, self, selfname)
            end
        else
            SCR_QUEST_LINE(pc, self, quest_auto.Possible_SelectDialog1, nil, nil, questname, nil, 'Possible')
            SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil, selfname)
        end
    end
end

function SCR_QUEST_RANDOMREWARD_SET(tx, pc, sObj, questIES, quest_auto)
    local randomReward = SCR_STRING_CUT(quest_auto.Success_RandomReward)
    if quest_auto.Success_RandomExcept == 'YES' then
        if GetPropType(sObj, questIES.QuestPropertyName..'_RRL') ~= nil then
            local list = {}
            local rewardHistory = SCR_STRING_CUT(sObj[questIES.QuestPropertyName..'_RRL'])
            for i = 1, #randomReward do
                local duplFlag = false
                for j = 1, #rewardHistory do
                    if tonumber(rewardHistory[j]) == i then
                        duplFlag = true
                    end
                end
                
                if duplFlag == false then
                    list[#list + 1] = i
                end
            end
            if #list > 0 then
                local rand = IMCRandom(1, #list)
                local itemSetting = randomReward[list[rand]]
                if string.find(itemSetting, "SCR_QUEST_RANDOM_") ~= nil then
                    local subStrList = SCR_STRING_CUT(itemSetting, ':')
                    local subStr_func = _G[subStrList[1]];
                    if subStr_func ~= nil then
                        itemSetting = subStr_func(pc,questIES.QuestPropertyName,subStrList)
                    end
                end
                local checkItemInfo = SCR_STRING_CUT(itemSetting, ':')
                local itemIES = GetClass('Item', checkItemInfo[1])
                local recipeIES = GetClass('Recipe', checkItemInfo[1])
                if itemIES ~= nil or recipeIES ~= nil then
                    TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RR',itemSetting..':'..list[rand])
                else
                    ErrorLog("Quest : ["..questIES.QuestPropertyName.."]  Success_RandomReward :["..checkItemInfo[1].."] not find idspace Item/Recipe".. GetZoneName(pc))
                end
            end
        end
    else
        local rand = IMCRandom(1, #randomReward)
        local itemSetting = randomReward[rand]
        if string.find(itemSetting, "SCR_QUEST_RANDOM_") ~= nil then
            local subStrList = SCR_STRING_CUT(itemSetting, ':')
            local subStr_func = _G[subStrList[1]];
            if subStr_func ~= nil then
                itemSetting = subStr_func(pc,questIES.QuestPropertyName,subStrList)
            end
        end
        local checkItemInfo = SCR_STRING_CUT(itemSetting, ':')
        local itemIES = GetClass('Item', checkItemInfo[1])
        local recipeIES = GetClass('Recipe', checkItemInfo[1])
        if itemIES ~= nil or recipeIES ~= nil then
            TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RR', itemSetting..':'..rand)
        else
            ErrorLog("Quest : ["..questIES.QuestPropertyName.."]  Success_RandomReward :["..checkItemInfo[1].."] not find idspace Item/Recipe".. GetZoneName(pc))
        end
    end
end

function SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(pc, questname, self)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE_PCKa_nilin_Kyeongu_BalSaeng_L_357_")..questname)
        DumpCallStack()
    end
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    local before_data;
    local questID = questIES.ClassID;
    
	if sObj[questIES.QuestPropertyName] == QUEST_ABANDON_VALUE then
	    
	    before_data = 'ABANDON'
	elseif sObj[questIES.QuestPropertyName] == QUEST_FAIL_VALUE then
	    
	    before_data = 'FAIL'
	elseif sObj[questIES.QuestPropertyName] == QUEST_SYSTEMCANCEL_VALUE then
	    
	    before_data = 'SYSTEMCANCEL'
	elseif sObj[questIES.QuestPropertyName] == QUEST_RANKRESET_VALUE then
	    
	    before_data = 'RANKRESET'
    end
    
    if sObj[questIES.QuestPropertyName] == CON_QUESTPROPERTY_END and IsGM(pc) ~= 1 and questIES.QuestMode ~= 'KEYITEM' then
        IMC_LOG("ERROR_IS_NOT_GM_QUEST_RESET : ","Team:"..GetTeamName(pc)..", AID:"..GetPcAIDStr(pc)..", QuestName:"..questname)
        return before_data
    end
    
    if isHideNPC(pc, questIES.ProgNPC) == 'YES' then
        if questname == 'VPRISON511_MQ_PRE_01' then
            
        else
            UnHideNPC(pc, questIES.ProgNPC)
        end
    end
    
    if self ~= nil and questIES.NPCQuestCount ~= 'None' then
        if string.find(questIES.NPCQuestCount, '/') == nil then
            if self[questIES.NPCQuestCount] <= 0  then
                return
            else
                self[questIES.NPCQuestCount] = self[questIES.NPCQuestCount] - 1
            end
        else
            local temp_list = {}
            local i
            temp_list = SCR_STRING_CUT(questIES.NPCQuestCount)

            for i = 1, #temp_list do
                if self[temp_list[i]] <= 0  then
                    return
                else
                    self[temp_list[i]] = self[temp_list[i]] - 1
                end
            end
        end
    end
    
    if quest_auto.Possible_PauseItemMSG ~= 'None' then
        PauseItemGetPacket(pc);
    end

    

    local prognpc_gentype = {}
    local gentype_classcount
    local i
    local npc_gentype = 0
    local npc_open_map
    local npc_open_npc

    if quest_auto.Possible_NextNPC == 'ENDNPC' then
        npc_open_map = 'EndMap'
        npc_open_npc = 'EndNPC'
    else
        npc_open_map = 'ProgMap'
        npc_open_npc = 'ProgNPC'
    end

    gentype_classcount = GetClassCount('GenType_'..questIES[npc_open_map])

    if gentype_classcount > 0 and quest_auto.Possible_NextNPC_Icon ~= 'NO' and questIES[npc_open_npc] ~= 'None' then
        for i = 0 , gentype_classcount-1 do
            if  GetClassStringByIndex('GenType_'..questIES[npc_open_map], i, 'Dialog') == questIES[npc_open_npc] or GetClassStringByIndex('GenType_'..questIES[npc_open_map], i, 'Enter') == questIES[npc_open_npc] or GetClassStringByIndex('GenType_'..questIES[npc_open_map], i, 'Leave') == questIES[npc_open_npc] then
                prognpc_gentype[#prognpc_gentype+1] = GetClassNumberByIndex('GenType_'..questIES[npc_open_map], i, 'GenType')
            end
        end

        if #prognpc_gentype > 0 then
            for i = 1, #prognpc_gentype do
                if GetNPCStateByGenType(pc, questIES[npc_open_map], prognpc_gentype[i]) < 1 then
                    npc_gentype = prognpc_gentype[i]
                end
            end
        end
    end



    if quest_auto.Possible_Smartgen == 'YES' then
        local smartgen_sObj = GetSessionObject(pc, 'ssn_smartgen')
        if smartgen_sObj ~= nil then
            SCR_SMARTGEN_GENFLAG_RESTART(smartgen_sObj)
        end
    end
    
    
    local abandonBanItemList = {}
    
    for i = 1, 5 do
        if quest_auto['Abandon_TakeItem_Ban'..i] ~= 'None' then
            local flag = 'NO'
            local pess = false
            if quest_auto['Abandon_TakeItem_Ban_CreateCheck'..i] ~= 'None' then
                local checkInfo = SCR_STRING_CUT(quest_auto['Abandon_TakeItem_Ban_CreateCheck'..i])
                local checkFunc = _G[checkInfo[1]]
                if checkFunc ~= nil then
                    flag = checkFunc(pc, questIES, quest_auto, checkInfo)
                    if flag == nil then
                        flag = 'NO'
                    elseif flag == 'YES' then
                        pess = true
                    end
                else
                    ErrorLog('Quest Abandon_TakeItem_Ban_CreateCheck Function Not find '..'Quest : '..questIES.ClassName..'Column : Abandon_TakeItem_Ban_CreateCheck'..i..'Function '..quest_auto['Abandon_TakeItem_Ban_CreateCheck'..i])
                end
            else
                flag = 'YES'
            end
            
            if flag == 'YES' then
                local abanItem = quest_auto['Abandon_TakeItem_Ban'..i]
                local abanItemCount = GetInvItemCount(pc, abanItem)
                local abanItemIES = GetClass('Item', abanItem)
                if abanItemIES ~= nil then
                    if abanItemCount <= 0 and abanItemIES ~= nil and abanItemIES.ItemType == 'Quest' then
                        if pess == true then
                            local giveCount = 0
                            for x = 1, 4 do
                                if quest_auto['Possible_ItemName'..i] == abanItem then
                                    if giveCount < quest_auto['Possible_ItemCount'..i] then
                                        giveCount = quest_auto['Possible_ItemCount'..i]
                                    end
                                end
                            end
                            
                            for x = 1, 4 do
                                if quest_auto['Progress_ItemName'..i] == abanItem then
                                    if giveCount < quest_auto['Progress_ItemCount'..i] then
                                        giveCount = quest_auto['Progress_ItemCount'..i]
                                    end
                                end
                            end
                            
                            for x = 1, QUEST_MAX_INVITEM_CHECK do
                                if questIES['Succ_InvItemName'..i] == abanItem then
                                    if giveCount < questIES['Succ_InvItemCount'..i] then
                                        giveCount = questIES['Succ_InvItemCount'..i]
                                    end
                                end
                            end
                            
                            for x = 1, QUEST_MAX_EQUIP_CHECK do
                                if questIES['Succ_EqItemName'..i] == abanItem then
                                    if giveCount < 1 then
                                        giveCount = 1
                                    end
                                end
                            end
                            
                            abandonBanItemList[#abandonBanItemList + 1] = {}
                            abandonBanItemList[#abandonBanItemList][1] = abanItem
                            abandonBanItemList[#abandonBanItemList][2] = giveCount
                        else
                            local abanFlag = true
                            for x = 1, 4 do
                                if quest_auto['Possible_ItemName'..i] == abanItem then
                                    abanFlag = false
                                    break
                                end
                            end
                            
                            if abanFlag == true then
                                for x = 1, 4 do
                                    if quest_auto['Progress_ItemName'..i] == abanItem then
                                        abanFlag = false
                                        break
                                    end
                                end
                            end
                            
                            if abanFlag == true then
                                for x = 1, QUEST_MAX_INVITEM_CHECK do
                                    if questIES['Succ_InvItemName'..i] == abanItem then
                                        abanFlag = false
                                        break
                                    end
                                end
                            end
                            
                            if abanFlag == true then
                                for x = 1, QUEST_MAX_EQUIP_CHECK do
                                    if questIES['Succ_EqItemName'..i] == abanItem then
                                        abanFlag = false
                                        break
                                    end
                                end
                            end
                            
                            if abanFlag == true then
                                abandonBanItemList[#abandonBanItemList + 1] = {}
                                abandonBanItemList[#abandonBanItemList][1] = abanItem
                                abandonBanItemList[#abandonBanItemList][2] = 1
                            end
                        end
                    end
                else
                    ErrorLog('ERROR> Quest : '..questname..' Property : Abandon_TakeItem_Ban'..i..'(itemClassName : '..abanItem..') not find'..questname)
                end
            end
        end
    end
    
    
    if sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MIN or sObj[questIES.QuestPropertyName] > CON_QUESTPROPERTY_MAX or quest_auto.QuestSave == 'YES' or quest_auto.Possible_ItemName1 ~= 'None'or npc_gentype > 0 or quest_auto.Possible_UIOpen1 ~= 'None' or quest_auto.Possible_UIOpen2 ~= 'None' or quest_auto.Possible_UIOpen3 ~= 'None' or quest_auto.Possible_UIOpen4 ~= 'None' or quest_auto.Possible_TakeItemName1 ~= 'None' or (tonumber(quest_auto.Possible_MedalADD) ~= nil and tonumber(quest_auto.Possible_MedalADD) ~= 0) or quest_auto.Possible_NextNPC == 'ENDNPC' or quest_auto.Possible_NextNPC == 'SUCCESS' or #abandonBanItemList > 0 or (quest_auto.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] == 'None') then
        
        local tx = TxBegin(pc);
        TxEnableInIntegrate(tx)
        
        if questIES.ClassName == 'TUTO_TP_SHOP' then
            local aObj = GetAccountObj(pc)
            if aObj.TUTO_TP_SHOP_REWARD == 0 then
                TxSetIESProp(tx, aObj, 'TUTO_TP_SHOP_REWARD', 1)
            end
        end
        
        if quest_auto.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] == 'None' then
            SCR_QUEST_RANDOMREWARD_SET(tx, pc, sObj, questIES, quest_auto)
        end
        
        if sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MIN or sObj[questIES.QuestPropertyName] > CON_QUESTPROPERTY_MAX then
            TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_MIN);
			QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", CON_QUESTPROPERTY_MIN);
        end
        
        if quest_auto.QuestSave == 'YES' then
            TxSetIESProp(tx, sObj, 'QUESTSAVE', questIES.ClassID);
        end

        if quest_auto.Possible_UIOpen1 ~= 'None' then
            local uistate_property, value = string.match(quest_auto.Possible_UIOpen1,'(.+)[/](.+)')
            if pc[uistate_property] ~= nil then
                TxSetIESProp(tx, pc, uistate_property, value);
            end
        end

        if quest_auto.Possible_UIOpen2 ~= 'None' then
            local uistate_property, value = string.match(quest_auto.Possible_UIOpen2,'(.+)[/](.+)')
            if pc[uistate_property] ~= nil then
                TxSetIESProp(tx, pc, uistate_property, value);
            end
        end

        if quest_auto.Possible_UIOpen3 ~= 'None' then
            local uistate_property, value = string.match(quest_auto.Possible_UIOpen3,'(.+)[/](.+)')
            if pc[uistate_property] ~= nil then
                TxSetIESProp(tx, pc, uistate_property, value);
            end
        end

        if quest_auto.Possible_UIOpen4 ~= 'None' then
            local uistate_property, value = string.match(quest_auto.Possible_UIOpen4,'(.+)[/](.+)')
            if pc[uistate_property] ~= nil then
                TxSetIESProp(tx, pc, uistate_property, value);
            end
        end

        if npc_gentype > 0 then
            TxChangeGenTypeState(tx, questIES[npc_open_map], npc_gentype, 1)
        end
        
        for i = 1, 5 do
            SCR_QUEST_TAKEITEM(pc,tx,quest_auto['Possible_TakeItemName'..i], quest_auto['Possible_TakeItemCount'..i],questname)
        end
        
        if #abandonBanItemList > 0 then
            for i = 1, #abandonBanItemList do
                TxGiveItem(tx, abandonBanItemList[i][1], abandonBanItemList[i][2], "Q_" .. questID);
            end
        end
        
        if quest_auto.Possible_ItemName1 ~= 'None' then
            local item_groupname = GetClassString('Item',quest_auto.Possible_ItemName1,'GroupName')
            if sObj[questIES.QuestPropertyName] == 0 or item_groupname == 'Quest' or quest_auto.Possible_AbandonItemGive == 'YES' or before_data == 'RANKRESET' then
        		TxGiveItem(tx, quest_auto.Possible_ItemName1, quest_auto.Possible_ItemCount1, "Q_" .. questID);
    		end
		end
		if quest_auto.Possible_ItemName2 ~= 'None' then
		    local item_groupname = GetClassString('Item',quest_auto.Possible_ItemName2,'GroupName')
            if sObj[questIES.QuestPropertyName] == 0 or item_groupname == 'Quest' or quest_auto.Possible_AbandonItemGive == 'YES' or before_data == 'RANKRESET' then
    		    TxGiveItem(tx, quest_auto.Possible_ItemName2, quest_auto.Possible_ItemCount2, "Q_" .. questID);
    		end
		end
		if quest_auto.Possible_ItemName3 ~= 'None' then
		    local item_groupname = GetClassString('Item',quest_auto.Possible_ItemName3,'GroupName')
            if sObj[questIES.QuestPropertyName] == 0 or item_groupname == 'Quest' or quest_auto.Possible_AbandonItemGive == 'YES' or before_data == 'RANKRESET' then
    		    TxGiveItem(tx, quest_auto.Possible_ItemName3, quest_auto.Possible_ItemCount3, "Q_" .. questID);
    		end
		end
		if quest_auto.Possible_ItemName4 ~= 'None' then
		    local item_groupname = GetClassString('Item',quest_auto.Possible_ItemName4,'GroupName')
            if sObj[questIES.QuestPropertyName] == 0 or item_groupname == 'Quest' or quest_auto.Possible_AbandonItemGive == 'YES' or before_data == 'RANKRESET' then
    		    TxGiveItem(tx, quest_auto.Possible_ItemName4, quest_auto.Possible_ItemCount4, "Q_" .. questID);
    		end
		end
		
		if tonumber(quest_auto.Possible_MedalADD) ~= nil and tonumber(quest_auto.Possible_MedalADD) ~= 0 and ( sObj[questIES.QuestPropertyName] == 0 or quest_auto.Possible_AbandonItemGive == 'YES') then
    		local aobj = GetAccountObj(pc);
        	TxAddIESProp(tx, aobj, "Medal", quest_auto.Possible_MedalADD,"QuestPossibleAdd");
		end
		
		if quest_auto.Possible_NextNPC == 'ENDNPC' then
            SCR_QUESTPROPERTY_MAX(tx, pc, sObj, questIES, questname)
        end
        if quest_auto.Possible_NextNPC == 'SUCCESS' then
            SCR_QUESTPROPERTY_MAX(tx, pc, sObj, questIES, questname)
        end
		
		if questIES.Quest_SSN ~= 'None' then
			local sObj2 = GetSessionObject(pc, questIES.Quest_SSN);
			if sObj2 == nil then
	            TxCreateSessionObject(tx, questIES.Quest_SSN);
			end
		end


		local ret = TxCommit(tx, 1);
		if ret == 'FAIL' then
			PrintLogLine(quest_auto.Name, "QUEST POSSIBLE Transaction FAIL")
		    return 'Transaction FAIL';
		elseif ret == 'SUCCESS' then
		    if self ~= nil then
    		    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    			if self.StrArg1 ~= 'None' and string.find(self.StrArg1, 'COLLECT/') ~= nil then
    			    local itemList =  string.gsub(self.StrArg1, 'COLLECT/', '')
    			    local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
    			    if sObj_quest ~= nil then
    			        itemList = SCR_STRING_CUT(itemList)
    			        local itemIndex = math.floor((math.floor(self.NumArg2 / 100) + 1) % #itemList)
    			        if itemIndex == 0 then
    			            itemIndex = #itemList
    			        end
    			        if itemIndex > 0 and #itemList >= itemIndex then
    			            sObj_quest.SSNInvItem = itemList[itemIndex]
    			            SaveSessionObject(pc, sObj_quest)
    			        end
    			    end
    			elseif argstr1 ~= nil and string.find(argstr1, 'COLLECT/ZONEAUTO') ~= nil then
    			    local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
    			    if sObj_quest ~= nil then
--    			        local rand = IMCRandom(1, 100)
    			        local itemList, monList, zoneClassNameList = DROPITEM_REQUEST1_PROGRESS_CHECK_FUNC_SUB(pc)
    			        
    			        if #zoneClassNameList > 0 then
			                local monRand = IMCRandom(1, #zoneClassNameList)
			                
			                local addCount = 0
			                if pc.Lv <= 150 then
			                    addCount = 0
			                elseif pc.Lv <= 200 then
			                    addCount = 20
			                elseif pc.Lv <= 300 then
			                    addCount = 50
			                else
			                    addCount = 70
			                end
			                    
			                sObj_quest.SSNMonKill = 'ZONEMONKILL'..':'..zoneClassNameList[monRand]..'/'..80+addCount
			                SaveSessionObject(pc, sObj_quest)
    			        else
    			        
--    			        if rand <= 70 then
--    			            qType = 'MonKill'
--    			        end
--    			        
--    			        if qType == 'MonKill' and (monList == nil or #monList <= 2) then
--    			            qType = 'Item'
--    			        elseif qType == 'Item' and (itemList == nil or #itemList <= 2) then
--    			            qType = 'MonKill'
--    			        end
    			        
--    			        if qType == 'MonKill' then
--    			            if #monList > 0 then
--    			                local monRand = IMCRandom(1, #monList)
--    			                print('DDDDDDDDDDDDDD',monList[monRand][1]..":"..monList[monRand][2]..":"..monList[monRand][3])
--    			                sObj_quest.SSNMonKill = monList[monRand][1]..":"..monList[monRand][2]..":"..monList[monRand][3]
--    			                SaveSessionObject(pc, sObj_quest)
--    			            end
--    			        else
--                            if #itemList > 0 then
--            		            local beforeValue = sObj.DROPITEM_REQUEST1_TRL
--                			    local beforeItemList = SCR_STRING_CUT(beforeValue)
--                			    local count = #itemList
--                			    for i = 1, count do
--                			        local selItem
--                			        local itemIES
--                			        if #itemList == 1 then
--                			            itemIES = GetClass('Item', itemList[1][1])
--                			            selItem = itemList[1][1]..":"..itemList[1][2]..":"..itemList[1][3]
--                			        else
--                    			        local itemRand = IMCRandom(1, #itemList)
--                    			        
--                    			        itemIES = GetClass('Item', itemList[itemRand][1])
--                    			        local findIndex = table.find(beforeItemList, itemIES.ClassID)
--                    			        if findIndex == 0 then
--                    			            selItem = itemList[itemRand][1]..":"..itemList[itemRand][2]..":"..itemList[itemRand][3]
--                    			        else
--                    			            table.remove(itemList, itemRand)
--                    			        end
--                    			    end
--                    			    
--                    			    if selItem ~= nil then
--                    			        sObj_quest.SSNInvItem = selItem
--                    			        SaveSessionObject(pc, sObj_quest)
--                    			        if beforeValue == 'None' then
--                			                beforeValue = ''
--                			            else
--                			                beforeValue = beforeValue.."/"
--                			            end
--                			            sObj.DROPITEM_REQUEST1_TRL = beforeValue..itemIES.ClassID
--                			            SaveSessionObject(pc, sObj)
--                			            
--                    			        break
--                    			    end
--                			    end
--                			end
                		end
                    end
    			end
			end
		end
	end
	
	for i = 1 , 4 do
		if quest_auto["Possible_Buff" .. i] ~= 'None' then
			SCR_QUEST_BUFF(pc, quest_auto, 'Possible_Buff' .. i);
		end
	end

    return before_data
end

function SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questname, self, abandon_restart_flag, selfname, quest_auto, noSleepFlag, onlyDlgFlag)
    
    if quest_auto.Possible_AgreeDialog1 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog1, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog1' and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog2 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog2, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog2'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog3 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog3, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog3'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog4 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog4, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog4'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog5 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog5, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog5'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog6 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog6, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog6'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog7 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog7, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog7'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog8 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog8, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog8'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog9 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog9, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog9'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Possible_AgreeDialog10 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Possible_AgreeDialog10, before_data, nil, questname, abandon_restart_flag, 'Possible', noSleepFlag, onlyDlgFlag)
    end
    if quest_auto.Possible_PauseItemMSG == 'Possible_AgreeDialog10'  and onlyDlgFlag ~= 'YES' then
        ResumeItemGetPacket(pc);
    end
end

function SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, abandon_restart_flag, selfname)
    if self == nil and (questname == 'DROPITEM_COLLECTINGQUEST' or questname == 'DROPITEM_REQUEST1') then
        return
    end
    
    if 0 == GetQuestCheckState(pc, questname) then
        SetQuestCheckState(pc, questname, 1);
    else
        return {'LOCK_POSSIBLE_AGREE'}
    end
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    
    local isTrackPlay = SCR_TRACK_START(pc, questIES.ClassName, quest_auto.Track1, 'Possible', selfname)
    
    if isTrackPlay == false then
        SetQuestCheckState(pc, questname, 0)
        return
    end
    
    
    local result = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Possible_PCLoopAnim, questname, 'TRACK_AFTER')
    SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
    if result == 'NO' then
        SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Possible')
        SetQuestCheckState(pc, questname, 0)
        return
    end
    
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_POSSIBLE_AGREE_PCKa_nilin_Kyeongu_BalSaeng_L_624_")..questname)
        DumpCallStack()
    end
    
    local before_data = SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(pc, questname, self) 
    if before_data == 'invOverFail' then
        SetQuestCheckState(pc, questname, 0)
        return
    end
    
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    
    if quest_auto.Possible_NextNPC == 'PROGRESS' then
        SetQuestCheckState(pc, questname, 0)
        SCR_QUEST_PROGRESS(self, pc, questname, nil, selfname)
        return
    end
    
    if quest_auto.Possible_NextNPC == 'SUCCESS' then
        SetQuestCheckState(pc, questname, 0)
        SCR_QUEST_SUCCESS(pc, questname, self, selfname)
        return
    else
        SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questname, self, abandon_restart_flag, selfname, quest_auto, 'NO')
    end
    
    if quest_auto.Possible_PauseItemMSG ~= 'AfterPossibleTrack' and quest_auto.Possible_PauseItemMSG ~= 'None' then
        ResumeItemGetPacket(pc);
    end
    
    for i = 1, 6 do
	    if quest_auto['Possible_AgreeQuest'..i] ~= 'None' then
	        local result1 = SCR_QUEST_CHECK(pc,quest_auto['Possible_AgreeQuest'..i])
	        if result1 == 'POSSIBLE' then
	            SCR_QUEST_POSSIBLE_AGREE(pc, quest_auto['Possible_AgreeQuest'..i], self, nil, selfname)
	        end
	    end
	end
	
    SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Possible')
    
    SetQuestCheckState(pc, questname, 0)
end

function SCR_QUEST_POSSIBLE_CANCEL(pc, questname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_POSSIBLE_CANCEL_PCKa_nilin_Kyeongu_BalSaeng_L_733_")..questname)
        DumpCallStack()
    end
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);

    SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'PossibleCancel')
end

function SCR_QUEST_POSSIBLE_EXPLAIN(pc, questname, self, selfname)
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    
    if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
        local agree = quest_auto.Possible_AnswerAgree
        local cancel = quest_auto.Possible_AnswerCancel
        
        if agree == 'None' then
            agree = nil
        end
        
        if cancel == 'None' then
            cancel = nil
        end
        
        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, 'Possible')
        local select3 = ShowSelDlg(pc, 0 ,  dlg, questname,  agree, cancel)
    
        if select3 == 1 then
            SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil, selfname)
        else
            SCR_QUEST_POSSIBLE_CANCEL(pc, questname)
        end
    else
        SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil, selfname)
        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, 'Possible')
        ShowOkDlg(pc, dlg,1)
    end
end

function SCR_QUEST_PROGRESS_DLG(self, pc, questname, selfname, quest_auto, noSleepFlag)
    if quest_auto.Progress_Dialog1 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog1, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog1' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog2 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog2, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog2' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog3 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog3, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog3' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog4 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog4, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog4' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog5 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog5, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog5' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog6 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog6, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog6' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog7 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog7, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog7' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog8 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog8, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog8' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog9 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog9, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog9' then
        ResumeItemGetPacket(pc);
    end
    if quest_auto.Progress_Dialog10 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Progress_Dialog10, nil, nil, questname, nil, 'Progress', noSleepFlag)
    end

    if quest_auto.Progress_PauseItemMSG == 'Progress_Dialog10' then
        ResumeItemGetPacket(pc);
    end
end

function SCR_QUEST_PROGRESS(self, pc, questname, isStartNPC, selfname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_PROGRESS_PCKa_nilin_Kyeongu_BalSaeng_L_759_")..questname)
        DumpCallStack()
    end
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    local questID = questIES.ClassID;
    
    
    if sObj[questIES.QuestPropertyName] == 1 then
        
         
        local result1 = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Progress_PCLoopAnim, questname, 'TRACK_BEFORE')
        SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
        if result1 == 'NO' then
            return
        end
        
        
        local isTrackPlay = SCR_TRACK_START(pc, questIES.ClassName, quest_auto.Track1, 'Progress', selfname)
        
        if isTrackPlay == false then
            return
        end
        
        
        local result2 = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Progress_PCLoopAnim, questname, 'TRACK_AFTER')
        SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
        if result2 == 'NO' then
            SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Progress')
            return
        end

        if quest_auto.Progress_PauseItemMSG ~= 'None' then
            PauseItemGetPacket(pc);
        end
        
        local result3 = SCR_QUEST_PROGRESS_PROP_CHANGE(self, pc, questname, isStartNPC, selfname)
        
        if result3 == 'invOverFail' then
            return
        end
        
    end
    
    local sObj = GetSessionObject(pc, 'ssn_klapeda');

	if quest_auto.Progress_Buff1 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Progress_Buff1')
    end
    if quest_auto.Progress_Buff2 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Progress_Buff2')
    end
    if quest_auto.Progress_Buff3 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Progress_Buff3')
    end
    if quest_auto.Progress_Buff4 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Progress_Buff4')
    end
    
    if quest_auto.Progress_NextNPC == 'SUCCESS' then
        SCR_QUEST_SUCCESS(pc, questname, self, selfname)
    else
        SCR_QUEST_PROGRESS_DLG(self, pc, questname, selfname, quest_auto, 'NO')
    end
    
    if quest_auto.Progress_PauseItemMSG ~= 'AfterProgressTrack' and quest_auto.Progress_PauseItemMSG ~= 'None' then
        ResumeItemGetPacket(pc);
    end
    
    SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Progress')
end

function SCR_QUEST_SUCCESS(pc, questname, self, selfname, noSleepFlag)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUEST_SUCCESS_PCKa_nilin_Kyeongu_BalSaeng_L_1047_")..questname)
        DumpCallStack();
		return;
    end
    
    -- 중국 과몰입 관련
    if GetServerNation() == "CHN" then
        local earningRate = GetEarningRate(pc)
        if earningRate == 0 then
            SendSysMsg(pc, 'CyouCantCompleteQuest');
            return
        end
    end
    		
	if 0 == GetQuestCheckState(pc, questname) then
		SetQuestCheckState(pc, questname, 1);
	else
		return {'LOCK_SUCCESS'};
	end

    local questIES = GetClass('QuestProgressCheck', questname);
    local questID = questIES.ClassID;
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);    
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    local sObj2 = GetSessionObject(pc, questIES.Quest_SSN);
    
    local i = 1
    local tx_error = {}
    local jobclassname = SCR_JOBNAME_MATCHING(pc.JobName)
    
    if noSleepFlag ~= 'YES' then
        local result1 = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Success_PCLoopAnim, questname, 'TRACK_BEFORE')
        SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
        if result1 == 'NO' then
            SetQuestCheckState(pc, questname, 0)
            return
        end
        
        local isTrackPlay = SCR_TRACK_START(pc, questIES.ClassName, quest_auto.Track1, 'Success', selfname)
        
        if isTrackPlay == false then
            SetQuestCheckState(pc, questname, 0)
            return
        end
        
        
        local result2 = SCR_QUEST_T_PCLOOPANIM(self, pc, quest_auto.Success_PCLoopAnim, questname, 'TRACK_AFTER')
        SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
        if result2 == 'NO' then
            SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Success')
            SetQuestCheckState(pc, questname, 0)
            return
        end
    end
    
    
    if quest_auto.Success_PauseItemMSG ~= 'None' then
        PauseItemGetPacket(pc);
    end
    
    
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use  = SCR_REPEAT_REWARD_CHECK(pc, questIES, quest_auto, sObj)
    
    local sel = 1
    
    local dlgShowState = SCR_QUEST_SUCC_REWARD_DLG(pc, questIES, quest_auto, sObj)
    
    if noSleepFlag ~= 'YES' and dlgShowState == 'DlgBefore' then
        sel = ShowQuestSelDlg(pc, questIES.ClassName, 1);
        if sel ~= nil then
            if sObj[questIES.QuestPropertyName] < 0 then
                SetQuestCheckState(pc, questname, 0)
                return
            end
        end
    else
        local pcProperty = GetClass('reward_property', questname)
        if pcProperty ~= nil then
            sel = ShowQuestSelDlg(pc, questIES.ClassName, 1);
            if sel ~= nil then
                if sObj[questIES.QuestPropertyName] < 0 then
                    SetQuestCheckState(pc, questname, 0)
                    return
                end
            end
        end
    end
    
    if sel == nil or sel <= 0 then
        SetQuestCheckState(pc, questname, 0)
        return
    end
    
    local follower = GetScpObjectList(pc, questIES.ClassName)
    if follower ~= nil then
        if #follower ~= 0 then
            for i =1 , #follower do
                if follower[i].StrArg2 == questIES.ClassName then
                    if follower[i].NumArg4 == 0 then
                        Kill(follower[i])
                    end
                end
            end
        end
    end
    
    
    if quest_auto.Success_Smartgen == 'YES' then
        local smartgen_sObj = GetSessionObject(pc, 'ssn_smartgen')
        if smartgen_sObj ~= nil then
            SCR_SMARTGEN_GENFLAG_RESTART(smartgen_sObj)
        end
    end
    
    local partyObj = GetPartyObj(pc)
    if partyObj ~= nil then
        if quest_auto.Success_PartyPropChange ~= 'None' and string.find(quest_auto.Success_PartyPropChange, '/') ~= nil then
            local cutList = SCR_STRING_CUT(quest_auto.Success_PartyPropChange)
            if #cutList >= 3 then
                local maxStep = math.floor(#cutList / 3) + 1
                for index = 1, maxStep do
                    local nowStep = ((index -1) * 3) + 1
                    local propName = cutList[nowStep]
                    local propBefore = tonumber(cutList[nowStep+1])
                    local propAfter = tonumber(cutList[nowStep+2])
                    if GetPropType(partyObj, propName) ~= nil and propBefore ~= nil and propAfter ~= nil then
                        if partyObj[propName] == propBefore then
                            ChangePartyProp(pc, PARTY_NORMAL, propName, propAfter)
                            CustomMongoLog(pc, "RequestPartyQuest", "PartyPropName", propName, "BeforeStep", propBefore, "AfterStep", propAfter);
                        end
                    end
                end
            end
        end
    end
    
    local succJobExp = 0
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    if quest_auto.Success_TX_Func ~= 'None' then
        local strList = SCR_STRING_CUT(quest_auto.Success_TX_Func)
        local tx_func = _G[strList[1]];
        if tx_func ~= nil then
            local tx_func_result = tx_func(pc, tx, questname, strList)
        else
            print(questname..ScpArgMsg("Auto__KweSeuTeuui_Success_TX_Func_:_")..quest_auto.Success_TX_Func..ScpArgMsg("Auto__HamSuKa_JonJaeHaJi_anSeupNiDa."))
        end
    end
    
    
    if quest_auto.Success_ChangeJob ~= 'None' then
        TxChangeJob(tx, quest_auto.Success_ChangeJob);
	
	    local etc = GetETCObject(pc); 
		if etc.JobChanging ~=  0 then
    		TxSetIESProp(tx, etc, "JobChanging", 0);
		end
		
        PlayEffect(pc, 'F_pc_class_change', 1)
    end
    
    
    if quest_auto.Success_HonorPoint ~= 'None' then
        local honor_name, point_value = string.match(quest_auto.Success_HonorPoint,'(.+)[/](.+)')
        if honor_name ~= nil then
            TxAddAchievePoint(tx, honor_name, tonumber(point_value))
        end
    end
    
    
    
    
    if #repeat_reward_achieve > 0 then
        for i = 1, #repeat_reward_achieve do
            TxAddAchieve(tx, repeat_reward_achieve[i][2])
        end
    end
    
    
    if #repeat_reward_achieve_point > 0 then
        for i = 1, #repeat_reward_achieve_point do
            if repeat_reward_achieve_point[i][2] ~= nil then
                TxAddAchievePoint(tx, repeat_reward_achieve_point[i][2], tonumber(repeat_reward_achieve_point[i][3]))
            end
        end
    end
    
    
    if #repeat_reward_item > 0 then
        for i = 1, #repeat_reward_item do
            local result4 = TxGiveItem(tx, repeat_reward_item[i][2], tonumber(repeat_reward_item[i][3]), "Q_" .. questID);
            if result4 == 0 then
    	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxGiveItem_HamSu')..quest_auto.Success_RepeatComplete
    	    end
        end
    end
    

    if quest_auto.Success_UIOpen1 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Success_UIOpen1,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Success_UIOpen2 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Success_UIOpen2,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Success_UIOpen3 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Success_UIOpen3,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Success_UIOpen4 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Success_UIOpen4,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if jobclassname == 'WAR' then
        if quest_auto.Success_SkillVanName1_WAR ~= 'None' then
            LearnSkill(pc, quest_auto.Success_SkillVanName1_WAR)
        end
    end
    if jobclassname == 'WIZ' then
        if quest_auto.Success_SkillVanName1_WIZ ~= 'None' then
            LearnSkill(pc, quest_auto.Success_SkillVanName1_WIZ)
        end
    end
    if jobclassname == 'ARC' then
        if quest_auto.Success_SkillVanName1_ARC ~= 'None' then
            LearnSkill(pc, quest_auto.Success_SkillVanName1_ARC)
        end
    end
    if jobclassname == 'CLR' then
        if quest_auto.Success_SkillVanName1_MNK ~= 'None' then
            LearnSkill(pc, quest_auto.Success_SkillVanName1_MNK)
        end
    end
    if jobclassname == 'SOR' then
        if quest_auto.Success_SkillVanName1_SOR ~= 'None' then
            LearnSkill(pc, quest_auto.Success_SkillVanName1_SOR)
        end
    end
    
    for i = 1, 5 do
        local result5 = SCR_QUEST_TAKEITEM(pc,tx,quest_auto['Success_TakeItemName'..i], quest_auto['Success_TakeItemCount'..i],questname)
        if result5 == 0 then
	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxTakeItem_HamSu')..quest_auto['Success_TakeItemName'..i]
	    end
    end
    
    if questIES.Succ_QuestNeedItemAutoTake == 'YES' and (questIES.Succ_Check_InvItem > 0 or (sObj2 ~= nil and sObj2.SSNInvItem ~= 'None')) then
        if questIES.Succ_Check_InvItem > 0 then
            for i = 1, 4 do
                local itemSameCheck = 0
                for x = 1, 5 do
                    if quest_auto['Success_TakeItemName'..x] == questIES['Succ_InvItemName'..i] then
                        itemSameCheck = 1
                        break
                    end
                end
                if itemSameCheck == 0 then
                    if questIES['Succ_InvItemName'..i] ~= 'None' then
                        local takeCount = questIES['Succ_InvItemCount'..i]
                        local itemIES = GetClass('Item', questIES['Succ_InvItemName'..i])
                        if itemIES ~= nil and itemIES.ItemType == 'Quest' then
                            takeCount = -100
                        end
                        local result6 = SCR_QUEST_TAKEITEM(pc,tx,questIES['Succ_InvItemName'..i], takeCount,questname)
                        if result6 == 0 then
                	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxTakeItem_HamSu')..questIES['Succ_InvItemName'..i]
                	    end
                	end
            	end
            end
        end
        
        if sObj2 ~= nil and sObj2.SSNInvItem ~= 'None' then
            local itemList = SCR_STRING_CUT(sObj2.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
                local itemSameCheck = 0
                for x = 1, 5 do
                    if quest_auto['Success_TakeItemName'..x] == itemList[i*3 - 2] then
                        itemSameCheck = 1
                        break
                    end
                end
                if itemSameCheck == 0 then
                    if itemList[i*3 - 2] ~= 'None' then
                        local takeCount = itemList[i*3 - 1]
                        local itemIES = GetClass('Item', itemList[i*3 - 2])
                        if itemIES ~= nil and itemIES.ItemType == 'Quest' then
                            takeCount = -100
                        end
                        local result6 = SCR_QUEST_TAKEITEM(pc,tx,itemList[i*3 - 2], takeCount,questname)
                        if result6 == 0 then
                	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxTakeItem_HamSu')..itemList[i*3 - 2]
                	    end
                	end
            	end
            end
        end
    end
        
	
	
    if sel > 0 and sel <50 then
        if repeat_reward_select == false or (repeat_reward_select == true and repeat_reward_select_use == true) then
            if quest_auto['Success_SelectItemName'..sel] ~= 'None' then
        	    local result7 = TxGiveItem(tx, quest_auto['Success_SelectItemName'..sel], quest_auto['Success_SelectItemCount'..sel], "Q_" .. questID);
        	    if result7 == 0 then
        	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxGiveItem_HamSu')..quest_auto['Success_SelectItemName'..sel]
        	    end
        	end
        end
    end
    
    
    for i = 1, 4 do
        if quest_auto['Success_ItemName'..i] ~= 'None' then
            local result8 = TxGiveItem(tx, quest_auto['Success_ItemName'..i], quest_auto['Success_ItemCount'..i], "Q_" .. questID);
        	if result8 == 0 then
        		tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxGiveItem_HamSu')..quest_auto['Success_ItemName'..i]
        	end
    	end
	end
	
	if jobclassname ~= nil then
	    if quest_auto.Success_JobItem_Name1 ~= 'None' then
            for i = 1, 20 do
                if quest_auto['Success_JobItem_Name'..i] ~= 'None' and quest_auto['Success_JobItem_JobList'..i] ~= 'None' then
                    local jobList = SCR_STRING_CUT(quest_auto['Success_JobItem_JobList'..i])
                    if SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, jobList, jobclassname, pc.Gender, quest_auto.Success_ChangeJob) == 'YES' then
               		    local result9 = TxGiveItem(tx, quest_auto['Success_JobItem_Name'..i], quest_auto['Success_JobItem_Count'..i], "Q_" .. questID);
                   	    if result9 == 0 then
                   	        tx_error[#tx_error + 1] = ScpArgMsg('Auto_TxGiveItem_HamSu')..quest_auto['Success_JobItem_Name'..i]
                   	    end
                    end
                end
            end
        end
    end
    
    if quest_auto.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] ~= 'None' then
        local randomReward = SCR_STRING_CUT(quest_auto.Success_RandomReward)
        local saveRandItem = sObj[questIES.QuestPropertyName..'_RR']
        if saveRandItem ~= 'None' then
            local randomRewardItem = SCR_STRING_CUT_COLON(saveRandItem)
            
            local resultRandomRewardItem = TxGiveItem(tx, randomRewardItem[1], tonumber(randomRewardItem[2]), "Q_" .. questID);
            TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RR', 'None')
            if quest_auto.Success_RandomExcept == 'YES' and GetPropType(sObj, questIES.QuestPropertyName..'_RRL') ~= nil then
                local historyNum
                if #randomRewardItem >= 3 then
                    historyNum = randomRewardItem[3]
                elseif table.find(randomReward, saveRandItem) > 0 then
                    historyNum = table.find(randomReward, saveRandItem)
                end
                local list = sObj[questIES.QuestPropertyName..'_RRL']
                if list == 'None' or list == '' then
                    list = historyNum
                else
                    list = list..'/'..historyNum
                end
                
                if list ~= nil then
                    local rrlFlag = false
                    local historyNumList = SCR_STRING_CUT(list)
                    for i = 1, #randomReward do
                        if table.find(historyNumList, tostring(i)) == 0 then
                            rrlFlag = true
                            break
                        end
                    end
                    if rrlFlag == true then
                        TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RRL', list)
                    else
                        TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RRL', 'None')
                    end
                end
            end
       	    if resultRandomRewardItem == 0 then
       	        tx_error[#tx_error + 1] = 'RandomRewardItem Transaction '..randomRewardItem[1]
       	    end
        end
    end
    
    
    if TryGetProp(quest_auto , 'StepRewardList1') ~= nil and TryGetProp(quest_auto , 'StepRewardList1') ~= 'None' then
        local lastRewardList = TryGetProp(sObj, questIES.QuestPropertyName..'_SRL')
        local maxRewardIndex =  SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(pc, questIES.ClassName)

        if maxRewardIndex ~= nil and maxRewardIndex > 0 then
            local rewardList = SCR_TABLE_TYPE_SEPARATE(SCR_STRING_CUT(TryGetProp(quest_auto, 'StepRewardList'..maxRewardIndex)), {'ITEM'})
            local itemList = rewardList['ITEM']
            if itemList ~= nil and #itemList > 0 then
                for i2 = 1, #itemList/2 do
                    local itemName = itemList[i2*2 - 1]
                    local itemCount = itemList[i2*2]
                    local resultStepRewardItem = TxGiveItem(tx, itemName, itemCount, "Q_" .. questID);
               	    if resultStepRewardItem == 0 then
               	        tx_error[#tx_error + 1] = 'StepRewardItem Transaction '..itemName
               	    end
                end
            end
            
            if lastRewardList ~= nil then
                if lastRewardList == 'None' then
                    TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_SRL', maxRewardIndex)
                else
                    TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_SRL', lastRewardList..'/'..maxRewardIndex)
                end
            end
        end
    end
	
	if (quest_auto.Success_Exp > 0 or repeat_reward_exp > 0 or quest_auto.Success_Lv_Exp > 0) and pc.Lv < PC_MAX_LEVEL then
	    local expup = 0
	    if quest_auto.Success_Exp > 0 then
	        expup = quest_auto.Success_Exp
	    end
	    if repeat_reward_exp > 0 then
	        expup = expup + repeat_reward_exp
	    end
	    
	    if quest_auto.Success_Lv_Exp > 0 then
	        local xpIES = GetClass('Xp', pc.Lv)
	        if xpIES ~= nil then
	            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * quest_auto.Success_Lv_Exp)
	            if lvexpvalue ~= nil and lvexpvalue > 0 then
    	            expup = expup + lvexpvalue
	            end
                local lvjobexpvalue =  math.floor(xpIES.QuestStandardJobExp * quest_auto.Success_Lv_Exp)
                if lvjobexpvalue ~= nil and lvjobexpvalue > 0 then
    	            succJobExp = succJobExp + lvjobexpvalue
                end
	        end
	    end
	    
	    TxGiveExp(tx, expup, "Quest");
	end
	
	if repeat_reward_npc_point > 0 and self ~= nil then
	    local genID = GetGenTypeID(self)
	    if genID ~= nil then
	        local npcState = GetMapNPCState(pc, genID)
	        if npcState ~= nil then
	            local npc_point_value = npcState + repeat_reward_npc_point
	            TxChangeNPCState(tx, genID, npc_point_value)
	        end
	    end
	end
	
	if quest_auto.Success_SkillPoint > 0 then
    	local before_point = pc.SkillPtsByLevel
		TxSetIESProp(tx, pc, 'SkillPtsByLevel', before_point + quest_auto.Success_SkillPoint)
	end
	
	
    local beforeValue
	if quest_auto.Success_StatByBonus > 0 then
	    beforeValue = pc.StatByBonus
		TxAddIESProp(tx, pc, 'StatByBonus', quest_auto.Success_StatByBonus);
	end
	
	
	if quest_auto.Success_PropertyByBonus > 0 then
    	TxAddIESProp(tx, pc, 'PropertyByBonus', quest_auto.Success_PropertyByBonus)
    end
    
    if tonumber(quest_auto.Success_MedalADD) ~= nil and tonumber(quest_auto.Success_MedalADD) ~= 0 then
		local aobj = GetAccountObj(pc);
    	TxAddIESProp(tx, aobj, "Medal", quest_auto.Success_MedalADD, "QuestSuccessAdd");
	end
	
	
	if quest_auto.Success_HitMe ~= 0 then
        if type(quest_auto.Success_HitMe) == 'number' then
            local iesObj = CreateGCIES('Monster', 'TreasureBox1');
            iesObj.Faction = 'Peaceful';
            iesObj.Name = pc.Name..ScpArgMsg("Auto_ui_HitMe")
            iesObj.Dialog = 'MON_DUMMY'
            iesObj.Enter = 'MON_DUMMY'
            local posX, posY, posZ = GetPos(pc)
            local mon = CreateMonster(pc, iesObj, posX, posY, posZ, 0, 30);
            if mon ~= nil then
                SetLayer(mon, GetLayer(pc))
                CreateSessionObject(mon, 'SSN_COUNTDOWN_KILL')
				INIT_ITEM_OWNER(mon, pc);
                CreateSessionObject(pc, 'SSN_QUESTREWARD_HITME', 1)
                local sObj_hitme = GetSessionObject(pc, 'SSN_QUESTREWARD_HITME')
                if sObj_hitme ~= nil then
                    local list, cnt = SelectObject(pc, 300, 'ALL')
                    if cnt > 0 then
                        for i= 1, cnt do
                            if list[i].ClassName == 'TreasureBox1' and list[i].UniqueName == GetPcAIDStr(pc) then
                                mon = list[i]
                                break
                            end
                        end
                    end
                    SetArgObj1(sObj_hitme, mon)
                    TxSetIESProp(tx, sObj_hitme, "Value", quest_auto.Success_HitMe)
                    TxSetIESProp(tx, sObj_hitme, "QuestName", questname)
                end
            end
            
            local pc_layer = GetLayer(pc);
    		if pc_layer ~= nil and pc_layer ~= 0 then
    			SetLayer(mon, pc_layer);
    		end
        else
            print(questname, ScpArgMsg("Auto_KweSeuTeu_questIES.Success_HitMe_Kapi_SusJaKa_aNipNiDa."));
        end
    end
    
    
    for index = 1, 4 do
        if quest_auto['Success_LinkQuest_Propery'..index] ~= 'None' then
            local quest_classname, property_num, property_value = string.match(quest_auto['Success_LinkQuest_Propery'..index],'(.+)[/](.+)[/](.+)')
            if quest_classname ~= nil then
                local linkquest = GetClass('QuestProgressCheck',quest_classname)
                if linkquest ~= nil then
                    local linkquest_sObj = GetSessionObject(pc, linkquest.Quest_SSN, 1)
                    if linkquest_sObj ~= nil then
                        if tonumber(property_value) ~= nil then
                            TxSetIESProp(tx, linkquest_sObj, 'QuestInfoValue'..property_num, linkquest_sObj['QuestInfoValue'..property_num] + tonumber(property_value))
                        elseif property_value == 'MAX' then
                            TxSetIESProp(tx, linkquest_sObj, 'QuestInfoValue'..property_num, linkquest_sObj['QuestInfoMaxCount'..property_num])
                        end
                    end
                end
            end
        end
    end
    
    if TryGetProp(quest_auto, 'StepRewardList1') ~= nil and TryGetProp(quest_auto, 'StepRewardList1') ~= 'None' then
        for i = 1, 10 do
        end
    end
    
    if questIES.QuestMode == 'REPEAT' then
        if GetPropType(sObj,questIES.QuestPropertyName..'_R') == nil then
            print('ERROR> '..questIES.ClassName..' Quest Property nil : '..questIES.QuestPropertyName..'_R')
        else
            if sObj[questIES.QuestPropertyName..'_R'] < questIES.Repeat_Count - 1 or questIES.Repeat_Count == 0 then
                local value = 0
                local value2 = sObj[questIES.QuestPropertyName..'_R'] + 1
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value)
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_R', value2)
				QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", value);
				QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName..'_R', "StateChange", "State", value2);
            else
                local value2 = sObj[questIES.QuestPropertyName..'_R'] + 1
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_END)
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_R', value2)
				QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", CON_QUESTPROPERTY_END);
				QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName..'_R', "StateChange", "State", value2);
            end
        end
    elseif questIES.QuestMode == 'PARTY' then
        local groupEndFlag = false
        local qroupQuestList = {}
        
        if questIES.QuestGroup ~= 'None' and string.find(questIES.QuestGroup, '/') ~= nil then
            local cutStr = SCR_STRING_CUT(questIES.QuestGroup)
            local groupName = cutStr[1]
            local questNum = tonumber(cutStr[3])
            if groupName ~= nil and questNum ~= nil then
                local cnt = GetClassCount('QuestProgressCheck')
                local subFlag = false
            	for i = 0, cnt - 1 do
            		local indexQuestIES = GetClassByIndex('QuestProgressCheck', i);
            		if indexQuestIES ~= nil then
            		    if indexQuestIES.QuestGroup ~= 'None' and string.find(indexQuestIES.QuestGroup, groupName..'/') ~= nil then
            		        local subCutStr =  SCR_STRING_CUT(indexQuestIES.QuestGroup)
            		        local subCutNum = tonumber(subCutStr[3])
            		        qroupQuestList[#qroupQuestList + 1] = indexQuestIES.ClassName
            		        
            		        if indexQuestIES.ClassName ~= questIES.ClassName and questNum < subCutNum then
            		            subFlag = true
            		        end
            		    end
            		end
            	end
            	if subFlag == false then
            	    groupEndFlag = true
            	end
            end
    	end
    	
        if questIES.QuestGroup == 'None'then
            if sObj[questIES.QuestPropertyName] ~= 0 then
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, 0)
        		QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", 0);
        	end
        	local now_time = os.date('*t')
            local year = now_time['year']
            local yday = now_time['yday']
            local hour = now_time['hour']
            local value = sObj.PARTY_Q_COUNT1
            TxSetIESProp(tx, sObj, 'PARTY_Q_TIME1', year..'/'..yday..'/'..hour)
            TxSetIESProp(tx, sObj, 'PARTY_Q_COUNT1', value + 1)
            QuestStateMongoLog(pc, 'None', 'PARTY_Q_TIME1', "PartyQuest", "Value", year..'/'..yday..'/'..hour);
            QuestStateMongoLog(pc, 'None', 'PARTY_Q_COUNT1', "PartyQuest", "Value", value + 1);
    	elseif groupEndFlag == true and #qroupQuestList >= 1 then
            for i = 1, #qroupQuestList do
                if sObj[qroupQuestList[i]] ~= 0 then
        	        TxSetIESProp(tx, sObj, qroupQuestList[i], 0)
            		QuestStateMongoLog(pc, 'None', qroupQuestList[i], "StateChange", "State", 0);
            	end
    	    end
    	    local now_time = os.date('*t')
            local year = now_time['year']
            local yday = now_time['yday']
            local hour = now_time['hour']
            local value = sObj.PARTY_Q_COUNT1
            TxSetIESProp(tx, sObj, 'PARTY_Q_TIME1', year..'/'..yday..'/'..hour)
            TxSetIESProp(tx, sObj, 'PARTY_Q_COUNT1', value + 1)
            QuestStateMongoLog(pc, 'None', 'PARTY_Q_TIME1', "PartyQuest", "Value", year..'/'..yday..'/'..hour);
            QuestStateMongoLog(pc, 'None', 'PARTY_Q_COUNT1', "PartyQuest", "Value", value + 1);
        else
            if sObj[questIES.QuestPropertyName] ~= CON_QUESTPROPERTY_END then
                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_END)
        		QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", CON_QUESTPROPERTY_END);
        	end
    	end
    else
        if sObj[questIES.QuestPropertyName] ~= CON_QUESTPROPERTY_END then
            TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_END)
    		QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", CON_QUESTPROPERTY_END);
    	end
    end

    if quest_auto.QuestSave == 'YES' then
        TxSetIESProp(tx, sObj, 'QUESTSAVE', 0)
    end
	
	local ret = TxCommit(tx, 1);
	if quest_auto.Success_StatByBonus > 0 then
    	local afterValue = pc.StatByBonus
        CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", quest_auto.Success_StatByBonus, "Way", "Q_"..questname, "Type", "QUEST_SUCCESS")
    end
    if ret == 'SUCCESS' then
        if succJobExp > 0 then
            GiveJobExp(pc, succJobExp, "Quest");
        end
    end
	if ret == 'FAIL' then
	    print(questIES.Name,'QUEST SUCCESS Transaction FAIL')
	    SetQuestCheckState(pc, questname, 0)
	    return tx_error;
	else
	    if pc ~= nil then
    	    InvalidateStates(pc);
			QuestStateMongoLog(pc, questname, questname, "Complete");

    	else
    	    ErrorLog(ScpArgMsg("Auto_KweSeuTeu_Success_CheoLiJung_PCKa_eopSeupNiDa."))
    	end
	end
	
	
	
    if quest_auto.Success_Buff1 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Success_Buff1')
    end
    if quest_auto.Success_Buff2 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Success_Buff2')
    end
    if quest_auto.Success_Buff3 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Success_Buff3')
    end
    if quest_auto.Success_Buff4 ~= 'None' then
        SCR_QUEST_BUFF(pc, quest_auto, 'Success_Buff4')
    end
    local index
    
    if questIES.Quest_SSN ~= 'None' then
        if sObj2 ~= nil then
        	DestroySessionObject(pc, sObj2)
        else
            sObj2 = GetSessionObject(pc, questIES.Quest_SSN, 1);
            DestroySessionObject(pc, sObj2)
    	end
    end
    
    
    for i = 1, 6 do
    if quest_auto['Success_AgreeQuest'..i] ~= 'None' then
	        local result10 = SCR_QUEST_CHECK(pc,quest_auto['Success_AgreeQuest'..i])
	        if result10 == 'POSSIBLE' then
	            SCR_QUEST_POSSIBLE_AGREE(pc, quest_auto['Success_AgreeQuest'..i], nil, nil, selfname)
	        end
	    end
	end

    if quest_auto.Success_Dialog1 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog1, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog1' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog2 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog2, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog2' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog3 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog3, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog3' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog4 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog4, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog4' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog5 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog5, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog5' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog6 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog6, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog6' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog7 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog7, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog7' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog8 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog8, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog8' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog9 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog9, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog9' then
        ResumeItemGetPacket(pc);
    end

    if quest_auto.Success_Dialog10 ~= 'None' then
        SCR_QUEST_LINE(pc, self, quest_auto.Success_Dialog10, nil, nil, questname, nil, 'Success', noSleepFlag)
    end
    if quest_auto.Success_PauseItemMSG == 'Success_Dialog10' then
        ResumeItemGetPacket(pc);
    end
    
    if quest_auto.Success_PauseItemMSG ~= 'AfterSuccessTrack' and quest_auto.Success_PauseItemMSG ~= 'None' then
        ResumeItemGetPacket(pc);
    end
    
    if quest_auto.Success_Rullet ~= 'None' then
        RulletToPC(pc, quest_auto.Success_Rullet, "Rullet")
    end
    
    if noSleepFlag ~= 'YES' then
        SCR_TRACK_END(pc, questIES.ClassName, quest_auto.Track1, 'Success')
    
        if quest_auto.Success_NextQuestName1 ~= 'None' then
            if string.find(quest_auto.Success_NextQuestName1,'NORMAL_') == nil then
                SCR_QUEST_POSSIBLE(pc, quest_auto.Success_NextQuestName1)
                
            else
                local normaldialog = _G[quest_auto.Success_NextQuestName1]
                if normaldialog ~= nil then
                    normaldialog(nil,pc)
                else
                    print(questname,ScpArgMsg("Auto_KweSeuTeu_quest_auto.Success_NextQuestName1_KeolLeomui_HaeDang_HamSuKa_eopSeupNiDa.") )
                end
            end
        end
    end
    
    

--    if questIES.QuestEndMode == 'SYSTEM' and quest_auto.Success_Move ~= 'None' then
    if noSleepFlag ~= 'YES' and quest_auto.Success_Move ~= 'None' then
        
        if string.find(quest_auto.Success_Move, 'warp/') ~= nil then
            local function_name, warp_name, black_flag = string.match(quest_auto.Success_Move, '([/a-z]+)[ +]([_a-zA-Z0-9]+)[ +]([_a-zA-Z0-9]+)')
            if black_flag == 'fadeout' then
                sleep(2000)
                UIOpenToPC(pc,'fullblack',1)
                sleep(500)
                
                local pc_layer = GetLayer(pc)
                local obj = GetLayerObject(GetZoneInstID(pc), pc_layer);
                if obj ~= nil then
                	if obj.EventName == questname then
                        if pc_layer ~= 0 then
                            SetLayer(pc, 0)
                        end
                    end
                end
            end
            ResetScrollLockBox(pc)
            Warp(pc, warp_name)
        elseif string.find(quest_auto.Success_Move, 'setpos/') ~= nil then
            local function_name, x, y, z, black_flag = string.match(quest_auto.Success_Move, '([/a-z]+)[ +]([%-0-9]+)[ +]([%-0-9]+)[ +]([%-0-9]+)[ +]([_a-zA-Z0-9]+)')
            if black_flag == 'fadeout' then
                sleep(2000)
                UIOpenToPC(pc,'fullblack',1)
                sleep(500)

                local pc_layer = GetLayer(pc)
                local obj = GetLayerObject(GetZoneInstID(pc), pc_layer);
                if obj ~= nil then
                	if obj.EventName == questname then
                        if pc_layer ~= 0 then
                            SetLayer(pc, 0)
                        end
                    end
                end
            end
            ResetScrollLockBox(pc)
            SetPos(pc, x, y, z)
        elseif string.find(quest_auto.Success_Move, 'setposmoveanim/') ~= nil then
            local function_name, x, z, black_flag = string.match(quest_auto.Success_Move, '([/a-z]+)[ +]([%-0-9]+)[ +]([%-0-9]+)[ +]([_a-zA-Z0-9]+)')
            if black_flag == 'fadeout' then
                sleep(2000)
                UIOpenToPC(pc,'fullblack',1)
                sleep(500)

                local pc_layer = GetLayer(pc)
                local obj = GetLayerObject(GetZoneInstID(pc), pc_layer);
                if obj ~= nil then
                	if obj.EventName == questname then
                        if pc_layer ~= 0 then
                            SetLayer(pc, 0)
                        end
                    end
                end
            end
            ResetScrollLockBox(pc)
            SetPosMoveAnim(pc, x, z)
        elseif string.find(quest_auto.Success_Move, 'movezone/') ~= nil then
            local movezone_list = SCR_STRING_CUT(quest_auto.Success_Move)
            sleep(tonumber(movezone_list[6]))
            UIOpenToPC(pc,'fullblack',1)
            sleep(500)
            
            local pc_layer = GetLayer(pc)
            local obj = GetLayerObject(GetZoneInstID(pc), pc_layer);
            if obj ~= nil then
            	if obj.EventName == questname then
                    if pc_layer ~= 0 then
                        SetLayer(pc, 0)
                    end
                end
            end
            ResetScrollLockBox(pc)
            MoveZone(pc, movezone_list[2], tonumber(movezone_list[3]), tonumber(movezone_list[4]), tonumber(movezone_list[5]))
            
            local function_name, x, z, black_flag = string.match(quest_auto.Success_Move, '([/a-z]+)[ +]([%-0-9]+)[ +]([%-0-9]+)[ +]([_a-zA-Z0-9]+)')
        else
            print(questname,ScpArgMsg("Auto_KweSeuTeu_quest_auto.Success_Move_Kapi_HyeongSige_MajJi_anSeupNiDa."))
        end
    end
    
    
    local zoneID = GetZoneInstID(pc);
    local pc_layer = GetLayer(pc);
    if pc_layer > 0 then
        ResetLayerBox(zoneID, pc_layer)
    end
    
	SCR_LINE_QUEST_END_MSG(pc, questIES, quest_auto, sObj)
	
	SetQuestCheckState(pc, questname, 0);
	
end
function SCR_LINE_QUEST_END_MSG(pc, questIES, quest_auto, sObj)
    local ret = SCR_LINE_QUEST_END_MSG_CHECK(pc, questIES, quest_auto, sObj)
    if ret == 'YES' then
        local questKOR = questIES.Name
	    if questIES.QuestGroup ~= "None" then
	        if string.find(questIES.QuestGroup, "/") ~= nil then
	            local groupInfo = SCR_STRING_CUT(questIES.QuestGroup)
	            if #groupInfo >= 3 then
	                questKOR = groupInfo[2]
	            end
	        end
	    end
        SendAddOnMsg(pc, "NOTICE_Dm_quest_complete","["..questKOR..ScpArgMsg("LINE_QUEST_END_MSG"), 7);
    end
end

function SCR_LINE_QUEST_END_MSG_CHECK(pc, questIES, quest_auto, sObj)
	local clsList, cnt = GetClassList('QuestProgressCheck');
	if nil == clsList or 0 == cnt then
		return;
	end

    if sObj == nil then
		return;
	end

   local flag = false
   
   if quest_auto.Success_NextQuestName1 ~= "None" then
       flag = true
   else
      for i = 0, cnt - 1 do
      	local questSUB = GetClassByIndexFromList(clsList, i);
      	if questSUB.ClassName ~= "None" and questSUB.ClassName ~= questIES.ClassName then
      	    if questSUB.Check_QuestCount > 0 then
         		for x = 1, 4 do
         		    if questSUB["QuestName"..x] ~= "None" then
             	        if questSUB["QuestName"..x] == questIES.ClassName then
                	        if questSUB.PossibleUI_Notify ~= "NO" and sObj[questSUB.ClassName] < 300  then
                	            flag = true
                	            break
                	        end
             	        end
         		    end
         		end
			end
      	end
      	
      	if flag == true then
      	    break
      	end
      end
   end
   
   for i = 1, 10 do
        if string.find(string.upper(quest_auto['Success_Dialog'..i]), 'NOTICE') ~= nil then
            flag = true
            break
        end
   end
   
   if flag == false then
       return 'YES'
   end
end

function SCR_QUESTCONDITION_SELECTDIALOG(self, pc, selfname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUESTCONDITION_SELECTDIALOG_PCKa_nilin_Kyeongu_BalSaeng_L_1830_")..self.ClassName.. GetZoneName(pc))
        DumpCallStack()
    end
    local npcselectdialog = GetClass('NPCSelectDialog', selfname);
    local condition_select_dialog
    local i

    if npcselectdialog ~= nil then
        for i = 1, 5 do
            local flag = 0
            local result = 0
            
            if npcselectdialog['SD_QuestDialog'..i] ~= 'None' then
                if npcselectdialog['SD_QuestName'..i] ~= 'None' then
                    if npcselectdialog['SD_QuestState'..i] ~= 'None' then
                        flag = flag + 1
                        
                        local value = SCR_QUEST_CHECK(pc,npcselectdialog['SD_QuestName'..i])
                        if SCR_QUEST_STATE_COMPARE(value, npcselectdialog['SD_QuestState'..i]) == 'YES' then
                            result = result + 1
                        end
                    else
                        print(npcselectdialog['SD_QuestName'..i]..ScpArgMsg("Auto_KweSeuTeuNeun_JonJaeHaJiMan_BiKyoHaNeun_SD_QuestState[i]_ui_Kapi_SeolJeongDoeeo_issJi_anSeupNiDa."))
                    end
                end
                
                if npcselectdialog['SD_PrecheckScript'..i] ~= 'None' then
                    flag = flag + 1
                    
                    local precheckfunc = _G[npcselectdialog['SD_PrecheckScript'..i]];
                	if precheckfunc ~= nil then
                	    local return_vale1 = precheckfunc(self, pc, selfname)
                	    
                	    if return_vale1 == 'YES' then
                	        result = result + 1
                	    end
                	end
                end
                
                if npcselectdialog['SD_LvUp'..i] > 0 then
                    flag = flag + 1
                    
                    if pc.Lv >= npcselectdialog['SD_LvUp'..i] then
                        result = result + 1
                    end
                end
                
                if npcselectdialog['SD_DialogCount'..i] ~= 'None' then
                    flag = flag + 1
                    
                    local value = SCR_STRING_CUT(npcselectdialog['SD_DialogCount'..i])
                    if #value == 2 then
                        local sObj_main = GetSessionObject(pc,'ssn_klapeda')
                        
                        if GetPropType(sObj_main, value[1]) ~= nil then
                            if sObj_main[value[1]] >= value[2] then
                                result = result + 1
                            end
                        end
                    end
                end
                
                if flag > 0 and flag == result then
                    condition_select_dialog = npcselectdialog['SD_QuestDialog'..i]
                end
            end
        end
    end

    return condition_select_dialog
end


function SCR_QUESTCONDITION_IDLEDIALOG(self, pc, selfname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUESTCONDITION_IDLEDIALOG_PCKa_nilin_Kyeongu_BalSaeng_L_1904_")..self.ClassName.. GetZoneName(pc))
        DumpCallStack()
    end
    local npcselectdialog = GetClass('NPCSelectDialog', selfname);
    local condition_idledialog
    local i

    if npcselectdialog ~= nil then
        for i = 1, 5 do
            local flag = 0
            local result = 0
            
            if npcselectdialog['ID_QuestDialog'..i] ~= 'None' then
                if npcselectdialog['ID_QuestName'..i] ~= 'None' then
                    if npcselectdialog['ID_QuestState'..i] ~= 'None' then
                        flag = flag + 1
                        
                        local value = SCR_QUEST_CHECK(pc,npcselectdialog['ID_QuestName'..i])
                        if SCR_QUEST_STATE_COMPARE(value, npcselectdialog['ID_QuestState'..i]) == 'YES' then
                            result = result + 1
                        end
                    else
                        print(npcselectdialog['ID_QuestName'..i]..ScpArgMsg("Auto_KweSeuTeuNeun_JonJaeHaJiMan_BiKyoHaNeun_ID_QuestState[i]_ui_Kapi_SeolJeongDoeeo_issJi_anSeupNiDa."))
                    end
                end
                
                if npcselectdialog['ID_PrecheckScript'..i] ~= 'None' then
                    flag = flag + 1
                    
                    local precheckfunc = _G[npcselectdialog['ID_PrecheckScript'..i]];
                	if precheckfunc ~= nil then
                	    local return_vale1 = precheckfunc(self, pc, selfname)
                	    
                	    if return_vale1 == 'YES' then
                	        result = result + 1
                	    end
                	end
                end
                
                if npcselectdialog['ID_LvUp'..i] > 0 then
                    flag = flag + 1
                    
                    if pc.Lv >= npcselectdialog['ID_LvUp'..i] then
                        result = result + 1
                    end
                end
                
                if npcselectdialog['ID_DialogCount'..i] ~= 'None' then
                    flag = flag + 1
                    
                    local value = SCR_STRING_CUT(npcselectdialog['ID_DialogCount'..i])
                    if #value == 2 then
                        local sObj_main = GetSessionObject(pc,'ssn_klapeda')
                        
                        if GetPropType(sObj_main, value[1]) ~= nil then
                            if sObj_main[value[1]] >= value[2] then
                                result = result + 1
                            end
                        end
                    end
                end
                
                if flag > 0 and flag == result then
                    condition_idledialog = npcselectdialog['ID_QuestDialog'..i]
                end
            end
        end
    end

    return condition_idledialog
end

function SCR_QUESTPROPERTY_MAX(tx, pc, sObj, questIES, questname)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_QUESTPROPERTY_MAX_PCKa_nilin_Kyeongu_BalSaeng_L_1977_")..questname)
        DumpCallStack()
    end
    
    if sObj[questIES.QuestPropertyName] ~= CON_QUESTPROPERTY_MAX then
        TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_MAX);
        
    	QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", CON_QUESTPROPERTY_MAX);
    end
end

function SCR_NORMALDIALOG_CHECK(pc, normal_condition, normal_precheckscript, normal_quest, normal_queststate, normal_level)
    if pc == nil then
        ErrorLog(ScpArgMsg("Auto_SCR_NORMALDIALOG_CHECK_PCKa_nilin_Kyeongu_BalSaeng_L_1990_")..normal_condition.. normal_precheckscript.. normal_quest.. normal_queststate.. normal_level)
        DumpCallStack()
    end
    local quest_check = 'NO'
    local level_check = 'NO'

    if normal_condition == 'AND' then
        local check_flag = 0
        local check_result = 0

        if normal_quest ~= 'None' then
            if normal_queststate ~= 'None' then
                check_flag = check_flag + 1;
                local result = SCR_QUEST_CHECK(pc,normal_quest)
                if SCR_QUEST_STATE_COMPARE(result, normal_queststate) == 'YES' then
                    check_result = check_result + 1;
                end
            else
                print(normal_quest..ScpArgMsg("Auto_KweSeuTeuNeun_JonJaeHaJiMan_BiKyoHaNeun_NormalDialog[i]_QuestState_ui_Kapi_SeolJeongDoeeo_issJi_anSeupNiDa."))
            end
        end
        if normal_level > 0 then
            check_flag = check_flag + 1;
            if pc.Lv >= normal_level then
                check_result = check_result + 1;
            end
        end

        if normal_precheckscript ~= 'None' then
            check_flag = check_flag + 1;
            local funcInfo = SCR_STRING_CUT(normal_precheckscript)
            local precheckscp = _G[funcInfo[1]];
            if precheckscp ~= nil then
                if precheckscp(pc,funcInfo) == 'YES' then
                    check_result = check_result + 1;
                end
            else
                print(normal_precheckscript..ScpArgMsg("Auto_HamSuKa_eopeum"))
            end
        end

        if check_flag == check_result then
            return 'YES'
        else
            return 'NO'
        end
    else
        if normal_quest ~= 'None' then
            if normal_queststate ~= 'None' then
                local result = SCR_QUEST_CHECK(pc,normal_quest)
                quest_check = SCR_QUEST_STATE_COMPARE(result, normal_queststate)
                if quest_check == 'YES' then
                    return 'YES'
                end
            else
                print(normal_quest..ScpArgMsg("Auto_KweSeuTeuNeun_JonJaeHaJiMan_BiKyoHaNeun_NormalDialog[i]_QuestState_ui_Kapi_SeolJeongDoeeo_issJi_anSeupNiDa."))
            end
        end

        if pc.Lv >= normal_level and normal_level > 0 then
            return 'YES'
        end

        local precheckscp = _G[normal_precheckscript];
        if precheckscp ~= nil then
            if precheckscp(pc) == 'YES' then
                return 'YES'
            end
        end

        if normal_quest == 'None' and normal_level == 0 and normal_precheckscript == 'None' then
            return 'YES'
        end

        return 'NO'
    end
end

function SCR_QUEST_DLG_CHANGE_TERMS_CHECK(pc, terms, questname, quest_state)
    if terms[1] == 'LV' then
        local pcLv = pc.Lv
        local numValue = tonumber(terms[3])
        if terms[2] == '>=' then
            if pcLv >= numValue then
                return 'YES'
            end
        elseif terms[2] == '<=' then
            if pcLv <= numValue then
                return 'YES'
            end
        elseif terms[2] == '==' then
            if pcLv == numValue then
                return 'YES'
            end
        end
    elseif terms[1] == 'GENDER' then
        local pcGender = pc.Gender
        if pcGender == 1 and terms[2] == 'M' then
            return 'YES'
        elseif pcGender == 2 and terms[2] == 'F' then
            return 'YES'
        end
    elseif terms[1] == 'JOBTYPE' then
        local jobClass = GetClass('Job', pc.JobName)
        if jobClass ~= nil and jobClass.CtrlType == terms[2] then
            return 'YES'
        end
    elseif terms[1] == 'JOBCIRCLE' then
        local circle = GetJobGradeByName(pc, terms[2])
        local numValue = tonumber(terms[4])
        if terms[3] == '>=' then
            if circle >= numValue then
                return 'YES'
            end
        elseif terms[3] == '<=' then
            if circle <= numValue then
                return 'YES'
            end
        elseif terms[3] == '==' then
            if circle == numValue then
                return 'YES'
            end
        end
    elseif terms[1] == 'JOB' then
        if pc.JobName == terms[2] then
            return 'YES'
        end
    elseif terms[1] == 'QUEST' then
        local sObj_main = GetSessionObject(pc,'ssn_klapeda')
        local numValue = tonumber(terms[4])
        if GetPropType(sObj_main, terms[2]) ~= nil then
            if terms[3] == '>=' then
                if sObj_main[terms[2]] >= numValue then
                    return 'YES'
                end
            elseif terms[3] == '<=' then
                if sObj_main[terms[2]] <= numValue then
                    return 'YES'
                end
            elseif terms[3] == '==' then
                if sObj_main[terms[2]] == numValue then
                    return 'YES'
                end
            end
        end
    elseif terms[1] == 'RANK' then
        local pcRank =  GetTotalJobCount(pc)
        local numValue = tonumber(terms[3])
        if terms[2] == '>=' then
            if pcRank >= numValue then
                return 'YES'
            end
        elseif terms[2] == '<=' then
            if pcRank <= numValue then
                return 'YES'
            end
        elseif terms[2] == '==' then
            if pcRank == numValue then
                return 'YES'
            end
        end
    elseif terms[1] == 'EQACHIEVE' then
        if GetEquipAchieveName(pc) == terms[2] then
            return 'YES'
        end
    elseif terms[1] == 'REPEAT' then
        if questname ~= nil and quest_state ~= nil then
            local sObj_main = GetSessionObject(pc,'ssn_klapeda')
            if GetPropType(sObj_main, questname..'_R') ~= nil then
                local targetValue = tonumber(terms[3]) - 1
                if quest_state == 'Success' then
                    targetValue = targetValue + 1
                end
                
                if terms[2] == '>=' then
                    if sObj_main[questname..'_R'] >= targetValue then
                        return 'YES'
                    end
                elseif terms[2] == '<=' then
                    if sObj_main[questname..'_R'] <= targetValue then
                        return 'YES'
                    end
                elseif terms[2] == '==' then
                    if sObj_main[questname..'_R'] == targetValue then
                        return 'YES'
                    end
                end
            end
        end
    end
    return 'NO'
end

function SCR_QUEST_DLG_CHANGE(pc, quest_auto, targetDlg, questname, quest_state)
    for i = 1, 10 do
        if GetPropType(quest_auto,'DialogChange_TDlg'..i) ~= nil and quest_auto['DialogChange_TDlg'..i] == targetDlg then
            if GetPropType(quest_auto, 'DialogChange_Terms'..i) ~= nil and quest_auto['DialogChange_Terms'..i] ~= 'None' and quest_auto['DialogChange_Terms'..i] ~= '' then
                if GetPropType(quest_auto, 'DialogChange_CDlg'..i) ~= nil and quest_auto['DialogChange_CDlg'..i] ~= 'None' and quest_auto['DialogChange_CDlg'..i] ~= '' then
                    local termsList = SCR_STRING_CUT(quest_auto['DialogChange_Terms'..i])
                    if termsList[1] == 'OR' then
                        for x = 2, #termsList do
                            local terms = SCR_STRING_CUT_COLON(termsList[x])
                            local result = SCR_QUEST_DLG_CHANGE_TERMS_CHECK(pc, terms, questname, quest_state)
                            if result == 'YES' then
                                return quest_auto['DialogChange_CDlg'..i]
                            end
                        end
                    else
                        local startValue = 1
                        if termsList[1] == 'AND' then
                            startValue = 2
                        end
                        local flag = true
                        for x = startValue, #termsList do
                            local terms = SCR_STRING_CUT_COLON(termsList[x])
                            local result = SCR_QUEST_DLG_CHANGE_TERMS_CHECK(pc, terms, questname, quest_state)
                            if result == 'NO' then
                                flag = false
                                break
                            end
                        end
                        if flag == true then
                            return quest_auto['DialogChange_CDlg'..i]
                        end
                    end
                end
            end
        end
    end
    
    return targetDlg
end

function SCR_QUEST_LINE(pc, npc, argmsg, before_data, isStartNPC, questname, abandon_restart_flag, quest_state, noSleepFlag, onlyDlgFlag)
    local new_line = argmsg
    local dlg_type
    local seltxt
    local dlgtxt
    local enter_name
    local move_x
    local move_z
    local move_speed
    local jobclassname
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);

	if string.find(argmsg, 'Retry%%') ~= nil then

	    argmsg = string.gsub(argmsg,'Retry%%','')

	    local normalmsg, abandonmsg, failmsg =  string.match(argmsg,'(.+)[%%](.+)[%%](.+)')

	    if before_data == nil then
            argmsg = normalmsg
        elseif before_data == 'ABANDON' then
            argmsg = abandonmsg
        elseif before_data == 'FAIL' then
            argmsg = failmsg
        elseif before_data == 'SYSTEMCANCEL' then
            argmsg = normalmsg
        else
            argmsg = normalmsg
        end

	    if argmsg == 'None' then
	        return
	    end
	end
    if string.find(argmsg, 'NOTICE_New_Item_JobItem;') ~= nil and onlyDlgFlag ~= 'YES' then
        new_line = string.gsub(argmsg,'NOTICE_New_Item_JobItem;','')
        local cut_list = SCR_STRING_CUT_SEMICOLON(new_line)
        if #cut_list > 0 then
            local i
            
            jobclassname = SCR_JOBNAME_MATCHING(pc.JobName)
        	
            for i = 1, #cut_list do
                if string.find(cut_list[i],jobclassname..'/') ~= nil then
                    new_line = string.gsub(cut_list[i],jobclassname..'/','')
                    SendAddOnMsg(pc, "NOTICE_New_Item", new_line, 7)
                end
            end
        end
    elseif string.find(argmsg, 'NOTICE_New_Item/') ~= nil and onlyDlgFlag ~= 'YES' then
        new_line = string.gsub(argmsg,'NOTICE_New_Item/','')
        SendAddOnMsg(pc, "NOTICE_New_Item", new_line, 7)
    elseif string.find(argmsg, 'Notice/') ~= nil then
        new_line = string.gsub(argmsg,'Notice/','')
        if string.find(new_line, '#') ~= nil then
            local notice_list = SCR_STRING_CUT_SHAP(new_line)
            
            if string.find(notice_list[1], '/') ~= nil then
                local notice_name, notice = string.match(notice_list[1],'(.+)[/](.+)')
                SendAddOnMsg(pc, "NOTICE_Dm_"..notice_name, notice, tonumber(notice_list[2]))
            else
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", notice_list[1], tonumber(notice_list[2]))
            end
        else
            if string.find(new_line, '/') ~= nil then
                local notice_name, notice = string.match(new_line,'(.+)[/](.+)')
                SendAddOnMsg(pc, "NOTICE_Dm_"..notice_name, notice, 7)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", new_line, 7)
            end
        end
    elseif string.find(argmsg, 'SysMsgChat/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        new_line = string.gsub(argmsg,'SysMsgChat/','')
        Chat(pc,new_line)
    elseif string.find(argmsg, 'SysMsgMsgBox/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        new_line = string.gsub(argmsg,'SysMsgMsgBox/','')
        SysMsg(pc, 'MsgBox', new_line)
    elseif string.find(argmsg, 'SysMsgInstant/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        new_line = string.gsub(argmsg,'SysMsgInstant/','')
        SysMsg(pc, 'Instant', new_line)
    elseif string.find(argmsg, 'NPCChat/') and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') ~= nil then
        local chat_msg = SCR_STRING_CUT(argmsg)
        local fndList, fndCount = SelectObject(pc, 200, 'ALL', 1);
    	for i = 1, fndCount do
    	    if fndList[i].ClassName ~= 'PC' then
        		if fndList[i].Dialog == chat_msg[2] or fndList[i].Enter == chat_msg[2]  or fndList[i].Leave == chat_msg[2] then
        		    Chat(fndList[i],chat_msg[3])
        		    break
        		end
    		end
    	end
    elseif noSleepFlag ~= 'YES' and  string.find(argmsg, 'CustomOkDlg/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        local dlg_type, DialogClsName, dlgscp = string.match(argmsg,'(CustomOkDlg/)(.+)[/](.+)')
        local dialog_txt

        local dialog_scp = _G[dlgscp];
        if dialog_scp ~= nil then
            dialog_txt = dialog_scp(pc);
        else
            print(dlgscp,ScpArgMsg("Auto_KeoSeuTeom_DaeSa_SeuKeuLipTeu_HamSuKa_eopSeupNiDa."))
        end
        
        if isStartNPC == 'YES' and quest_auto.Possible_AnswerExplain ~= 'None' and quest_auto.Possible_ExplainDialog1 ~= 'None' then
            local select = ShowSelDlg(pc, 0, DialogClsName .. "\\" .. dialog_txt, quest_auto.Possible_AnswerExplain, ScpArgMsg("Auto_DaeHwa_JongLyo"))
            if select == 1 then
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, quest_state)
                ShowOkDlg(pc, dlg, 0)
            end
        else
            ShowOkDlg(pc, DialogClsName .. "\\" .. dialog_txt, 0);
        end
        
    elseif noSleepFlag ~= 'YES' and string.find(argmsg, 'JobGenderOkDlg/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then

        jobclassname = SCR_JOBNAME_MATCHING(pc.JobName)

    	local gender

        if pc.Gender == 1 then
            gender = 'M'
        else
            gender = 'F'
        end

        new_line = string.gsub(argmsg,'JobGenderOkDlg/','')
        local new_line_list = SCR_STRING_CUT(new_line)
        local new_line_job_list = SCR_STRING_CUT_SEMICOLON(new_line_list[1])
        local new_line_gender_list = SCR_STRING_CUT_SEMICOLON(new_line_list[2])
        local flag = 0
        local flag2 = 0
        
        for key, value in pairs(new_line_job_list) do
            if value == jobclassname then
                flag = 1
                break
            end
        end
        
        for key, value in pairs(new_line_gender_list) do
            if value == gender then
                flag2 = 1
                break
            end
        end
        
        
        if flag == 1 and flag2 == 1 then
            if isStartNPC == 'YES' and quest_auto.Possible_AnswerExplain ~= 'None' and quest_auto.Possible_ExplainDialog1 ~= 'None' then
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line_list[3]..'_'..jobclassname..'_'..gender, questname, quest_state)
                local select = ShowSelDlg(pc, 0, dlg, quest_auto.Possible_AnswerExplain, ScpArgMsg("Auto_DaeHwa_JongLyo"))
                if select == 1 then
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, quest_state)
                    ShowOkDlg(pc, dlg, 0)
                end
            else
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line_list[3]..'_'..jobclassname..'_'..gender, questname, quest_state)
                ShowOkDlg(pc, dlg, 0);
            end
        end
    elseif noSleepFlag ~= 'YES' and string.find(argmsg, 'GenderOkDlg/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        local gender

        if pc.Gender == 1 then
            gender = 'M'
        else
            gender = 'F'
        end

        new_line = string.gsub(argmsg,'GenderOkDlg/','')
        
        if isStartNPC == 'YES' and quest_auto.Possible_AnswerExplain ~= 'None' and quest_auto.Possible_ExplainDialog1 ~= 'None' then
            local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line..'_'..gender, questname, quest_state)
            local select = ShowSelDlg(pc, 0, dlg, quest_auto.Possible_AnswerExplain, ScpArgMsg("Auto_DaeHwa_JongLyo"))
            if select == 1 then
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, quest_state)
                ShowOkDlg(pc, dlg, 0)
            end
        else
            local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line..'_'..gender, questname, quest_state)
            ShowOkDlg(pc, dlg, 0);
        end
    elseif noSleepFlag ~= 'YES' and string.find(argmsg, 'JobOkDlg/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        jobclassname = SCR_JOBNAME_MATCHING(pc.JobName)

        new_line = string.gsub(argmsg,'JobOkDlg/','')
        
        local new_line_list = SCR_STRING_CUT(new_line)
        local new_line_job_list = SCR_STRING_CUT_SEMICOLON(new_line_list[1])
        
        local flag = 0
        
        for key, value in pairs(new_line_job_list) do
            if value == jobclassname then
                flag = 1
                break
            end
        end
        
        
        if flag == 1 then
            if isStartNPC == 'YES' and quest_auto.Possible_AnswerExplain ~= 'None' and quest_auto.Possible_ExplainDialog1 ~= 'None' then
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line_list[2]..'_'..jobclassname, questname, quest_state)
                local select = ShowSelDlg(pc, 0, dlg, quest_auto.Possible_AnswerExplain, ScpArgMsg("Auto_DaeHwa_JongLyo"))
                if select == 1 then
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, quest_state)
                    ShowOkDlg(pc, dlg, 0)
                end
            else
                local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, new_line_list[2]..'_'..jobclassname, questname, quest_state)
                ShowOkDlg(pc, dlg, 0);
            end
        end
    elseif noSleepFlag ~= 'YES' and string.find(argmsg, 'SelDlg/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') then
        dlg_type, dlgtxt, seltxt = string.match(argmsg,'(SelDlg/)(.+)[/](.+)')
        
        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, dlgtxt, questname, quest_state)
        ShowSelDlg(pc, 0, dlg, seltxt)
    elseif string.find(argmsg, 'FadeOutIN/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') and onlyDlgFlag ~= 'YES' then
        local fade_time = 0
        fade_time = string.gsub(argmsg,'FadeOutIN/','')
        fade_time = tonumber(fade_time)
        if fade_time ~= nil then
            UIOpenToPC(pc,'fullblack',1)
            sleep(fade_time)
            UIOpenToPC(pc,'fullblack',0)
        end
    elseif string.find(argmsg, 'EffectLocalNPC/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, npc_function, effect_name, effect_size, effect_pos = string.match(argmsg,'(EffectLocalNPC/)(.+)[/](.+)[/](.+)[/](.+)')
        local fndList, fndCount = SelectObject(pc, 200, 'ALL', 1);
    	for i = 1, fndCount do
    	    if fndList[i].ClassName ~= 'PC' then
        		if fndList[i].Dialog == npc_function or fndList[i].Enter == npc_function or fndList[i].Leave == npc_function then
        		    if effect_pos ~= nil and effect_pos ~= 'None' then
            		    PlayEffectLocal(fndList[i], pc, effect_name, effect_size, 1, effect_pos)
            		else
            		    PlayEffectLocal(fndList[i], pc, effect_name, effect_size)
            		end
        		end
    		end
    	end
    elseif string.find(argmsg, 'EffectLocal/') ~= nil and onlyDlgFlag ~= 'YES' then
        new_line = string.gsub(argmsg,'EffectLocal/','')
        local effectlocal = SCR_STRING_CUT(new_line)
        if #effectlocal >= 2 then
            PlayEffectLocal(pc, pc, effectlocal[1], effectlocal[2])
        else
            PlayEffectLocal(pc, pc, effectlocal[1])
        end
        
    elseif string.find(argmsg, 'ForkPtclLocal/') ~= nil and onlyDlgFlag ~= 'YES' then
        new_line = string.gsub(argmsg,'ForkPtclLocal/','')
		PlayEffectLocal(self, pc, new_line, 6.0, 1, "BOT", 1);
--    elseif string.find(argmsg, 'OkDlg/') ~= nil then
--        new_line = string.gsub(argmsg,'OkDlg/','')
--        local dlg_value = SCR_DLG_RANDOM(pc, new_line)
--        ShowOkDlg(pc, dlg_value, 1);
    elseif string.find(argmsg, 'UnHideNPC/') ~= nil and onlyDlgFlag ~= 'YES' then
        local unHideNPC_Info = SCR_STRING_CUT(argmsg)
        if #unHideNPC_Info == 2 or tonumber(unHideNPC_Info[3]) == 0 then
            UnHideNPC(pc, unHideNPC_Info[2])
        elseif #unHideNPC_Info >= 3 then
            RunZombieScript('SCR_UNHIDENPC_RUN',pc, unHideNPC_Info[2], unHideNPC_Info[3])
        end
    elseif string.find(argmsg, 'HideNPC/') ~= nil and onlyDlgFlag ~= 'YES' then
        local hideNPC_Info = SCR_STRING_CUT(argmsg)
        if #hideNPC_Info == 3 or tonumber(hideNPC_Info[4]) == 0 then
            local x, y, z = GetPos(pc)
            HideNPC(pc, hideNPC_Info[2], x, z, 0)
        elseif #hideNPC_Info >= 4 then
            RunZombieScript('SCR_HIDENPC_RUN',pc, hideNPC_Info[2],0,hideNPC_Info[4])
        end
    elseif string.find(argmsg, 'NPCState;') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, list = string.match(argmsg,'(NPCState;)(.+)')
        local list_table = SCR_STRING_CUT_SEMICOLON(list)
        
        if #list_table > 0 then
            local tx = TxBegin(pc);
            TxEnableInIntegrate(tx)
            for i = 1, #list_table do
                local npc_info = SCR_STRING_CUT(list_table[i])
                if #npc_info >= 2 and #npc_info <= 3 then
                    local npc_value
                    if #npc_info == 3 then
                        npc_value = npc_info[3]
                    else
                        npc_value = 1
                    end
                    
                    TxChangeGenTypeState(tx, npc_info[1], tonumber(npc_info[2]), tonumber(npc_value))
                end
            end
            
            local ret = TxCommit(tx);
        end
        
--        local state = GetNPCStateByGenType(pc, zone_name, tonumber(gentype))
--        if state < 1 then
--            local tx = TxBegin(pc);
--            TxEnableInIntegrate(tx)
--            TxChangeGenTypeState(tx, zone_name, tonumber(gentype), 1)
--            local ret = TxCommit(tx);
--        end
    elseif noSleepFlag ~= 'YES' and string.find(argmsg, 'Sleep/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') and onlyDlgFlag ~= 'YES' then
        new_line = string.gsub(argmsg,'Sleep/','')
        sleep(tonumber(new_line))
    elseif string.find(argmsg, 'NPCAin/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, npc_function, ain_name, flag = string.match(argmsg,'(NPCAin/)(.+)[/](.+)[/](.+)')
        local fndList, fndCount = SelectObject(pc, 200, 'ALL', 1);
    	for i = 1, fndCount do
    	    if fndList[i].ClassName ~= 'PC' then
        		if fndList[i].Dialog == npc_function or fndList[i].Enter == npc_function or fndList[i].Leave == npc_function then
        		    PlayAnimLocal(fndList[i], pc, ain_name, tonumber(flag))
        		    break
        		end
    		end
    	end
    elseif string.find(argmsg, 'NPCForceEffect/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, npc_function, effectNum = string.match(argmsg,'(NPCForceEffect/)(.+)[/](.+)')
        local fndList, fndCount = SelectObject(pc, 200, 'ALL', 1);
    	for i = 1, fndCount do
    	    if fndList[i].ClassName ~= 'PC' then
        		if fndList[i].Dialog == npc_function or fndList[i].Enter == npc_function or fndList[i].Leave == npc_function then
        		    PlayExpEffect(fndList[i], pc, 'stamina', tonumber(effectNum))
        		    break
        		end
    		end
    	end
    elseif string.find(argmsg, 'PCAin/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, ain_name, flag = string.match(argmsg,'(PCAin/)(.+)[/](.+)')
        PlayAnimLocal(pc, pc, ain_name, tonumber(flag))
    elseif string.find(argmsg, 'CameraShockWaveLocal/') ~= nil and (abandon_restart_flag == nil or abandon_restart_flag ~= 'YES') and onlyDlgFlag ~= 'YES' then
        local list = SCR_STRING_CUT(argmsg)
        CameraShockWave(pc, tonumber(list[2]), tonumber(list[3]), tonumber(list[4]), tonumber(list[5]), tonumber(list[6]), tonumber(list[7]))
    elseif string.find(argmsg, 'Func/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlgList = SCR_STRING_CUT(argmsg)
        local func_name = dlgList[2]
        local is_Track_i = 3;
        if dlgList[2] == 'TrackInTrack' then
            func_name = dlgList[3]
            is_Track_i = 4;
            SCR_QUEST_DLG_BEFORE_TRACK_END(pc, questname, quest_auto.Track1, quest_state)
        end
        
        local func = _G[func_name];
        if func ~= nil then
            
            local add_arg = { }
            if dlgList[is_Track_i] ~= nil then
                for i = is_Track_i, #dlgList do
                    add_arg[#add_arg + 1] = dlgList[i];
                end
            end
            
            local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
            if obj ~= nil then
                obj.EventNextTrack = func_name
            end
            
            func(pc, questname, npc, func_name, add_arg);
            
            local questIES = GetClass('QuestProgressCheck', questname);
            local sObj = GetSessionObject(pc, 'ssn_klapeda');
            local dlgShowState = SCR_QUEST_SUCC_REWARD_DLG(pc, questIES, quest_auto, sObj)
            
            if dlgShowState == 'DlgAfter' then
                WAIT_END_DIRECTION(pc)
                local sel = ShowQuestSelDlg(pc, questIES.ClassName, 1);
            end
        else
            print(func_name,ScpArgMsg("Auto_JiJeongHan_HamSuKa_eopSeupNiDa."))
        end
    elseif string.find(argmsg, 'Help/') ~= nil and onlyDlgFlag ~= 'YES' then
        local dlg_type, help_classname = string.match(argmsg,'(Help/)(.+)')
        AddHelpByName(pc, help_classname)
    elseif string.find(argmsg, 'BalloonText/') ~= nil then
        local msgList = SCR_STRING_CUT(argmsg)
        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, msgList[2], questname, quest_state)
        ShowBalloonText(pc, dlg, tonumber(msgList[3]))
    elseif string.find(argmsg, 'UnHideFadeOutNPC/') ~= nil and onlyDlgFlag ~= 'YES' then
        local hideNPC_Info = SCR_STRING_CUT(argmsg)
        local npcList = string.gsub(argmsg,'UnHideFadeOutNPC/','')
        local delay = 1500
        if #hideNPC_Info >= 3 then
            if tonumber(hideNPC_Info[#hideNPC_Info]) ~= nil then
                npcList = string.gsub(npcList,'/'..hideNPC_Info[#hideNPC_Info],'')
                delay = tonumber(hideNPC_Info[#hideNPC_Info])
            end
        end
        local npcListInfo = SCR_STRING_CUT(npcList)
        if #npcListInfo > 0 then
            for i = 1, #npcListInfo do
                UnHideNPC(pc, npcListInfo[i])
            end
        end
    elseif string.find(argmsg, 'HideFadeOutNPC/') ~= nil and onlyDlgFlag ~= 'YES' then
        local hideNPC_Info = SCR_STRING_CUT(argmsg)
        local npcList = string.gsub(argmsg,'HideFadeOutNPC/','')
        local delay = 1500
        if #hideNPC_Info >= 3 then
            if tonumber(hideNPC_Info[#hideNPC_Info]) ~= nil then
                npcList = string.gsub(npcList,'/'..hideNPC_Info[#hideNPC_Info],'')
                delay = tonumber(hideNPC_Info[#hideNPC_Info])
            end
        end
        local npcListInfo = SCR_STRING_CUT(npcList)
        if #npcListInfo > 0 then
            for i = 1, #npcListInfo do
                HideNPC(pc, npcListInfo[i])
            end
        end
    else
        if string.find(argmsg, '/') == nil and string.find(argmsg, '%%') == nil and string.find(argmsg, ';') == nil and noSleepFlag ~= 'YES' then
            if  abandon_restart_flag == nil or abandon_restart_flag ~= 'YES' then
                local dlg_value = SCR_DLG_RANDOM(pc, new_line)
                
                if pc == nil then
                    ErrorLog(ScpArgMsg("Auto_COMMON_QUEST_HANDLER_Dlg_UI_Jung_PCKa_nilin_Kyeongu_BalSaeng_L_2309_")..quest_auto.ClassName)
                    DumpCallStack()
                else
                    if isStartNPC == 'YES' and quest_auto.Possible_AnswerExplain ~= 'None' and quest_auto.Possible_ExplainDialog1 ~= 'None' then
                        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, dlg_value, questname, quest_state)
                        local select = ShowSelDlg(pc, 0, dlg, quest_auto.Possible_AnswerExplain, ScpArgMsg("Auto_DaeHwa_JongLyo"))
                        if select == 1 then
                            local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, quest_state)
                            ShowOkDlg(pc, dlg, 0)
                        end
                    else
                        local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, dlg_value, questname, quest_state)
                        ShowOkDlg(pc, dlg, 0);
                    end
                end
            end
        end
    end
end

function SCR_DLG_RANDOM(pc, dlg, type_value)
    local dlg_value = dlg
    
    if string.find(dlg, '/') ~= nil then
        local dlg_list = SCR_STRING_CUT(dlg)
        local last_room = tonumber(dlg_list[#dlg_list])
        
        if #dlg_list > 0 then
            if last_room ~= nil then
                if type_value ~= 'SELECT' and IMCRandom(1,10000) <= last_room then
                    dlg_value = dlg_list[#dlg_list - 1]
                else
                    dlg_value = dlg_list[IMCRandom(1,#dlg_list - 2)]
                end
            else
                dlg_value = dlg_list[IMCRandom(1,#dlg_list)]
            end
        end
    end
    
    return dlg_value
end

function SCR_QUEST_BUFF(pc, quest_auto, column_name)
    local buffList = SCR_STRING_CUT(quest_auto[column_name])
    local buff_name, buffarg1, buffarg2, buff_time, buff_remove = string.match(quest_auto[column_name],'(.+)[/](.+)[/](.+)[/](.+)[/](.+)')
    buff_name = buffList[1]
    buffarg1 = tonumber(buffList[2])
    buffarg2 = tonumber(buffList[3])
    buff_time = tonumber(buffList[4])
    buff_over = buffList[5]
    buff_remove = buffList[6]
    if buff_name ~= nil then
        if buff_remove == 'REMOVE' then
            RemoveBuff(pc, buff_name)
        elseif buff_remove == nil or buff_remove == 'None' then
            AddBuff(pc, pc, buff_name, buffarg1, buffarg2, buff_time, buff_over);
        end
    else
        print(quest_auto.ClassName..ScpArgMsg("Auto__KweSeuTeu")..column_name..ScpArgMsg("Auto_KeolLeom_MunBeop_oLyu"))
    end
end

function SCR_TRACK_START(pc, questname, track_txt, quest_state, selfname)
	
	if GetExProp(pc, "IS_BOT_PC") == 1 then
		return false;
	end

    local result = true
    local changeBGM
    if track_txt ~= 'None' then
        local list = SCR_STRING_CUT(track_txt)
        if list[3] ~= nil then
            if list[1] == 'S'..quest_state then
                if list[6] ~= nil then
                    SCR_QUEST_LINE(pc, nil, list[6], nil, nil, questname)
                    sleep(500)
                end
                local quest_track1 = _G[list[3]]
                local isdirection = IsDirectionExist(list[3])
                if quest_track1 ~= nil or isdirection == 1 then
                    if list[5] ~= nil and list[5] ~= 'None' then
                        changeBGM = list[5]
                        PlayMusicQueueLocal(pc, changeBGM)
                        sleep(100)
                    end
                    local pc_layer_1 = GetLayer(pc)
                    
                    local myParty = GetPartyObj(pc);
                    local partyPlayerList, cnt
                    
					if myParty ~= nil and myParty.IsQuestShare == 1 then
					    partyPlayerList, cnt = GET_PARTY_ACTOR(pc, 0);
					end
					
					local sObj = GetSessionObject(pc, 'ssn_klapeda')
    				
    				local questIES_auto = GetClass('QuestProgressCheck_Auto', questname)
    				local questIES = GetClass('QuestProgressCheck', questname)
    				
    				if sObj.TRACK_QUEST_NAME ~= 'None' or IsPlayingDirection(pc) > 0 or GetLayer(pc) ~= 0 then
    				    return false
    				end
    				local pcNoticeMsgReward = ''
    				local pcNoticeMsgShop = ''
    				local pcNoticeMsgBefore = ''
    				if cnt ~= nil and cnt > 0 then
						if questIES_auto.Track_PartyPlay == 'YES' then
            				for i = 1, cnt do
            				    if IsSameActor(partyPlayerList[i], pc) == 'NO' then
                				    if GetLayer(partyPlayerList[i]) == 0 and IsPlayingDirection(partyPlayerList[i]) ~= 1 then
                				        local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
                				        if sObjPartyPC.TRACK_QUEST_NAME == 'None' then
                				            local ret, quest_reason = SCR_TRACK_PARTYPLAY_SOBJ_PRECHECK(partyPlayerList[i], questname, list[1], selfname)
                    				        if ret > 0 then
                    				            sObjPartyPC.TRACK_QUEST_NAME = questname
                    				        elseif ret == -1 then
                    				            local processingQuestList = SCR_PROCESSING_QUEST_LIST_NAME_CONCAT(partyPlayerList[i])
                    				            if processingQuestList ~= '' then
                    				                pcNoticeMsgReward = pcNoticeMsgReward..partyPlayerList[i].Name..','
    		    							        SysMsg(partyPlayerList[i], 'Instant',ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_PROGRESS','BEFORE_QUEST',processingQuestList,'NEXT_QUEST',questIES.Name))
                    				                SendAddOnMsg(partyPlayerList[i], "NOTICE_Dm_Bell",ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_PROGRESS','BEFORE_QUEST',processingQuestList,'NEXT_QUEST',questIES.Name), 10)
                    				            end
                    				        elseif ret == -2 then
                				                pcNoticeMsgShop = pcNoticeMsgShop..partyPlayerList[i].Name..','
    		    							    SysMsg(partyPlayerList[i], 'Instant',ScpArgMsg('PARTY_PLAYER_SHOP_PROGRESS','NEXT_QUEST',questIES.Name))
                    				            SendAddOnMsg(partyPlayerList[i], "NOTICE_Dm_Bell",ScpArgMsg('PARTY_PLAYER_SHOP_PROGRESS','NEXT_QUEST',questIES.Name), 10)
                    				        else
                    				            if quest_reason ~= nil then
        		    							    if type(quest_reason) == 'string' then
        		    							        quest_reason = {quest_reason}
        		    							    end
                    				                pcNoticeMsgBefore = pcNoticeMsgBefore..partyPlayerList[i].Name..','
        		    							    local txt = SCR_QUEST_REASON_TXT(partyPlayerList[i],questIES, quest_reason)
        		    							    if txt ~= nil and type(txt) == 'string' and txt ~= '' then
        		    							        SysMsg(partyPlayerList[i], 'Instant',ScpArgMsg('QuestReasonBeforeTxt')..txt..ScpArgMsg('QuestReasonBeforeTxt3'))
            		    							    SendAddOnMsg(partyPlayerList[i], "NOTICE_Dm_Bell",ScpArgMsg('QuestReasonBeforeTxt')..txt..ScpArgMsg('QuestReasonBeforeTxt3'), 10)
            		    							else
        		    							        SysMsg(partyPlayerList[i], 'Instant',ScpArgMsg('QuestReasonBeforeTxt2'))
            		    							    SendAddOnMsg(partyPlayerList[i], "NOTICE_Dm_Bell",ScpArgMsg('QuestReasonBeforeTxt2'), 10)
            		    							end
        		    							end
    		    							end
                	    			    end
                				    end
                				else
                				    sObj.TRACK_QUEST_NAME = questname
                				end
            				end
            				if pcNoticeMsgReward ~= '' or pcNoticeMsgShop ~= '' or pcNoticeMsgBefore ~= '' then
            				    if pcNoticeMsgReward ~= '' then
            				        pcNoticeMsgReward = string.sub(pcNoticeMsgReward, 1, string.len(pcNoticeMsgReward) - 1)
            				    end
            				    if pcNoticeMsgShop ~= '' then
            				        pcNoticeMsgShop = string.sub(pcNoticeMsgShop, 1, string.len(pcNoticeMsgShop) - 1)
            				    end
            				    if pcNoticeMsgBefore ~= '' then
            				        pcNoticeMsgBefore = string.sub(pcNoticeMsgBefore, 1, string.len(pcNoticeMsgBefore) - 1)
            				    end
            				    
            				    local msg = ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_SHOP_MSG1')
            				    if pcNoticeMsgReward ~= '' then
            				        msg = msg..ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_SHOP_MSG2','REWARD',pcNoticeMsgReward)
            				    end
            				    if pcNoticeMsgShop ~= '' then
            				        msg = msg..ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_SHOP_MSG3','SHOP',pcNoticeMsgShop)
            				    end
            				    if pcNoticeMsgBefore ~= '' then
            				        msg = msg..ScpArgMsg('PARTY_PLAYER_QUEST_REWARD_SHOP_MSG4','BEFORE',pcNoticeMsgBefore)
            				    end
            				    SysMsg(pc, 'Instant',msg)
            				end
            			end
        			end
        			
    				if isdirection == 1 then
                        PlayDirection(pc, list[3], 0, 1);
                        CustomMongoLog(pc, "QuestTrack", "Type", "Init", "QuestName", questname, "TrackName", list[3], "TrackOwner", pc.Name, "Zone", GetZoneName(pc), "TrackType","Direction")
                    elseif quest_track1 ~= nil then
                        quest_track1(pc)
                        CustomMongoLog(pc, "QuestTrack", "Type", "Init", "QuestName", questname, "TrackName", list[3], "TrackOwner", pc.Name, "Zone", GetZoneName(pc), "TrackType","Function")
                    end
                    
				    local trackInPartyPC = 1
				    
    				if cnt ~= nil and cnt > 0 then
						if questIES_auto.Track_PartyPlay == 'YES' then
            				for i = 1, cnt do
            				    if IsSameActor(partyPlayerList[i], pc) == 'NO' then
                				    if GetLayer(partyPlayerList[i]) == 0 and IsPlayingDirection(partyPlayerList[i]) ~= 1 then
                				        local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
                				        if sObjPartyPC.TRACK_QUEST_NAME == questname then
                				            local ret = SCR_TRACK_PARTYPLAY_SOBJ_PRECHECK(partyPlayerList[i], questname, list[1], selfname)
                    				        if ret > 0 then
                    				            trackInPartyPC = trackInPartyPC + 1
                    				            RunZombieScript("SCR_TRACK_PARTYPLAY", partyPlayerList[i], pc, questname, list[1], i, isdirection, changeBGM, selfname, list[3]);
    		    							end
                	    			    end
                				    end
                				end
            				end
            			end
        			end
        			
					if isdirection == 1 then
						StartDirection(pc);
						CustomMongoLog(pc, "QuestTrack", "Type", "Start", "QuestName", questname, "TrackName", list[3], "TrackOwner", pc.Name, "Zone", GetZoneName(pc))
					end
					
                    if cnt ~= nil and cnt > 0 then
				        for i = 1, cnt do
					        local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
					        if sObjPartyPC ~= nil then
    					        if sObjPartyPC.TRACK_QUEST_NAME == questname then
    					            sObjPartyPC.TRACK_QUEST_NAME = 'None'
    					        end
    					    end
					    end
					end
					
                    result = true
                    SetTrackName(pc, questname);
                    
           			local pc_layer_2 = GetLayer(pc)
       			    local tx = TxBegin(pc);
       			    TxEnableInIntegrate(tx)
       			    local etc = GetETCObject(pc)
				    if GetPropType(etc, questIES_auto.ClassName..'_TRACK') ~= nil then
       			        local value = etc[questIES_auto.ClassName..'_TRACK'] + 1
       			        TxSetIESProp(tx, etc, questIES_auto.ClassName..'_TRACK', value)
       			        --etc[questIES_auto.ClassName..'_TRACK'] = value
       			        --print('UUUU'..pc.Name,etc[questIES_auto.ClassName..'_TRACK'])
       			    end
       			    
       			    
           			if pc_layer_1 ~= pc_layer_2 then
                        if sObj ~= nil then
                            if sObj[questIES.QuestPropertyName] < 0 then
                                local value = 11
                                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value);
								QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", value);
                            else
                                local value = sObj[questIES.QuestPropertyName] + 10
                                TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value);
								QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", value);
                            end
                            
                            
                            local quest_sObj
                            if  questIES.Quest_SSN ~= 'None' and questIES.Quest_SSN ~= '' then
                                quest_sObj = GetSessionObject(pc, questIES.Quest_SSN);
                                if quest_sObj == nil then
                                    TxCreateSessionObject(tx, questIES.Quest_SSN);
                                end
                            end
                    	end
                    	
                        local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
                        if obj ~= nil then
                        	obj.EventName = questname
                        	obj.EventOwner = pc.Name
							SetExProp_Str(pc, "LayerEventName", obj.EventName);
                            BroadLayerObjectProp(pc, 'EventName')
                            BroadLayerObjectProp(pc, 'EventOwner')
                            if cnt ~= nil and cnt > 0 then
                				for i = 1, cnt do
                				    if IsSameActor(partyPlayerList[i], pc) == 'NO' and GetLayer(pc) > 0 and GetLayer(pc) == GetLayer(partyPlayerList[i]) then
                                        BroadLayerObjectProp(partyPlayerList[i], 'EventName')
                                        BroadLayerObjectProp(partyPlayerList[i], 'EventOwner')
                				    end
                				end
                			end
                        end
           			end
           			
           			local ret = TxCommit(tx, 1);
            		
            		if ret == 'FAIL' then
            		    print(questIES.Name,'SCR_TRACK_START Transaction FAIL')
            		else
            		    if questIES.Quest_SSN ~= 'None' and questIES.Quest_SSN ~= '' then
            		        local quest_sObj = GetSessionObject(pc, questIES.Quest_SSN)
                    		if GetPropType(quest_sObj,'Countdown_StartType') ~= nil and GetPropType(quest_sObj,'Countdown_Time') ~= nil then
                                if quest_sObj.Countdown_StartType == 'TrackStart' and quest_sObj.Countdown_Time > 0  then
                                    SCR_QUEST_COUNTDOWN_FUNC(pc, quest_sObj)
                                end
                            end
                        end
                    end
           		else
           		    print(ScpArgMsg("Auto_{Auto_1}_KweSeuTeuui_{Auto_2}_TeuLaegi_eopSeupNiDa.", "Auto_1",questname,"Auto_2", list[3]))
                end
            end
        end
    end
    
    return result
end

function SCR_QUEST_COUNTDOWN_FUNC(pc, sObj)
    SetSessionObjectTime(pc, sObj, sObj.Countdown_Time)
    local funcDef = _G['SCR_'..sObj.ClassName..'_DEFENCE']
    if funcDef ~= nil then
        funcDef(pc, sObj)
    end
    local func = _G['SCR_'..sObj.ClassName..'_COUNTTIME']
    if func ~= nil then
        SetSessionObjectTimeScp(pc, sObj, 'SCR_'..sObj.ClassName..'_COUNTTIME', 1000)
    end
    --print('QQQQQQQQ')
end

function SCR_PARTY_SOBJ_TIME_SHARE(self, sObj, remainTime)
    local obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
    if obj == nil then
		return;
	end

	if sObj.QuestName ~= obj.EventName then
		return;
	end

     local partyPlayerList, cnt = GET_PARTY_ACTOR(self, 0)
     local pc_layer_1 = GetLayer(self)
     if cnt <= 0 then
		return;
	end

     for i = 1, cnt do
         if SHARE_QUEST_PROP(self, partyPlayerList[i]) == true and partyPlayerList[i].Name ~= obj.EventOwner then
             local eventOwner = partyPlayerList[i]
             local eventOwnerSobj = GetSessionObject(eventOwner, sObj.ClassName)
			
             if eventOwnerSobj ~= nil then
                 local eventOwnerRemainTime = GetSessionObjectTime(self, sObj)
                 if eventOwnerRemainTime ~= nil then
                     SetSessionObjectTime(eventOwner, eventOwnerSobj, eventOwnerRemainTime)
                     break
                 end
             end
         end
     end
end
function SCR_DIE_DIRECTION_CHECK(self, sObj, remainTime)
	if IsDead(self) == 1 or IsPlayingDirection(self) > 0 then
		SetSessionObjectTime(self, sObj, remainTime + 1)
		return 'YES'
	end
	
	return 'NO'
end
function SCR_TRACK_END(pc, questname, track_txt, quest_state)
    
    local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
    if obj ~= nil then
        if obj.EventOwner ~= pc.Name then
            local monList, monCount = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
            if monCount > 0 then
                for i = 1, monCount do
                    if monList[i].ClassName == 'PC' and obj.EventOwner == monList[i].Name then
                        return
                    end
                end
            end
        end
    end
    
    if track_txt ~= 'None' then
		
		
		pc.FIXMSPD_BM = 0;
		InvalidateMSPD(pc);

        local list = SCR_STRING_CUT(track_txt)
        if list[3] ~= nil and GetLayer(pc) ~= 0 then
            if list[2] == 'E'..quest_state or quest_state == 'PossibleCancel' then

                local questIES = GetClass('QuestProgressCheck', questname);
                local sObj = GetSessionObject(pc, 'ssn_klapeda');
                
                local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
--                print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_1111111,_Leieo_oBeuJegTeu_:_"),obj)
                if obj ~= nil then
--                    print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_2222222,_Leieo_oBeuJegTeu_EventName_:_"),obj.EventName)
                    WAIT_END_DIRECTION(pc)
                    obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
                	if obj.EventName == questname then
                	    local pc_layer = GetLayer(pc)
--                        print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_333333,_PC_HyeonJae_Leieo_:_"), pc_layer)
                        if pc_layer ~= 0 then
                            local questIES_Auto = GetClass('QuestProgressCheck_Auto', questname);
                            local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc));
                            if cnt ~= nil and cnt > 0 then
                                local partySuccessFlag = false
                                local eNPC
                                if quest_state == 'Success' and questIES.QuestEndMode == 'NPCDIALOG' and questIES_Auto.Track_PartyPlay == 'YES' and questIES.EndNPC ~= 'None' then
                                    local npcList, npcCnt = SelectObject(pc, 500, 'ALL')
                                    if npcCnt > 0 then
                                        for i = 1, npcCnt do
                                            if npcList[i].ClassName ~= 'PC' then
                                                if npcList[i].Dialog == questIES.EndNPC or npcList[i].Enter == questIES.EndNPC or npcList[i].Leave == questIES.EndNPC then
                                                    partySuccessFlag = true
                                                    eNPC = npcList[i]
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                for i = 1, cnt do
                                    if partySuccessFlag == true and IsSameActor(pcList[i], pc) == 'NO' then
                                        local ret = SCR_QUEST_CHECK(pcList[i], questIES.ClassName)
                                        if ret == 'SUCCESS' then
                                            local noSleepFlag = 'YES'
                                            RunZombieScript('SCR_QUEST_SUCCESS',pcList[i], questname, eNPC, nil, noSleepFlag)
                                        end
                                    end
                                end
                            end
                                    
                            local monList, monCount = GetLayerMonList(GetZoneInstID(pc), GetLayer(pc))
                            local deadMonCount = 0
                            
                            if monCount > 0 then
                                for i = 1, monCount do
                                    if monList[i].ClassName ~= 'PC' and GetCurrentFaction(monList[i]) == 'Monster' then
                                        deadMonCount = deadMonCount + 1
                                        Dead(monList[i])
                                    elseif monList[i].ClassName == 'HitMe' then
                                        SetLayer(monList[i], 0)
                                    end
                                end
                            end
                            if deadMonCount > 0 then
                                sleep(1500)
                            end
                            
                            
                            
                            if questIES_Auto.Possible_NextNPC ~= "ENDNPC" and questIES_Auto.Possible_NextNPC ~= "SUCCESS" and questIES_Auto.Progress_NextNPC ~= "ENDNPC" and questIES_Auto.Progress_NextNPC ~= "SUCCESS" then
                                
                                local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc));
                                if cnt ~= nil and cnt > 0 then
                                    for i = 1, cnt do
                                        if questIES.QuestEndMode == 'SYSTEM' then
                                            local sObj_party = GetSessionObject(pcList[i], 'ssn_klapeda');
                                            local ret = SCR_LINE_QUEST_END_MSG_CHECK(pcList[i], questIES, questIES_Auto, sObj_party)
                                            if ret ~= 'YES' then
                                                SendAddOnMsg(pcList[i], "NOTICE_Dm_Clear",questIES.Name..ScpArgMsg("QuestTrackSuccessNotice"), 5)
                                            end
                                        else
                                            SendAddOnMsg(pcList[i], "NOTICE_Dm_Clear",questIES.Name..ScpArgMsg("QuestTrackSuccessNotice"), 5)
                                        end
                                        PlaySound(pc, 'quest_success_2')
                                    end
                                end
                            end
                            
                            SCR_TRACK_END_ITEMGETPACKET_LOCK(pc, list, questIES_Auto)
                            
                            if list[4] ~= nil then
                                local sleepTime = tonumber(list[4])
                                
                                if sleepTime ~= nil and sleepTime > 0 then
                                    sleep(sleepTime)
                                end
                            end
                            local itemList, itemCount = GetLayerItemList(GetZoneInstID(pc), GetLayer(pc))
                            if itemCount > 0 then
                                for i = 1, itemCount do
                                    if itemList[i].ClassName ~= 'PC' and ( 1 == IsItem(itemList[i]) or itemList[i].Tactics == 'MON_HITME') then
                                        SetLayer(itemList[i], 0)
                                    end
                                end
                            end
                            
                            local changeBGM
                            if list[5] ~= nil and list[5] ~= 'None' then
                                changeBGM = list[5]
                                StopMusicQueueLocal(pc, changeBGM)
                                sleep(100)                                      
                            end
                            
                            
                            local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc));
                            obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
                            local layerOwner = obj.EventOwner
                            
                            if cnt ~= nil and cnt > 0 then
                                for i = 1, cnt do
                                    if IsSameActor(pcList[i], pc) == 'NO' then
--                                        print(pcList[i].Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum"))
                                        if changeBGM ~= nil then
                                            StopMusicQueueLocal(pcList[i], changeBGM)
                                        end
                                        SetLayer(pcList[i], 0)
--                                        if IsInScrollLockBox(pcList[i]) == 1 then
--                                            ResetScrollLockBox(pcList[i])
--                                        end
                                        CustomMongoLog(pcList[i], "QuestTrack", "Type", "End", "QuestName", questname, "TrackName", list[3], "TrackOwner", layerOwner, "Zone", GetZoneName(pcList[i]))
--                                        print(pcList[i].Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNaKo_Leieo_ByeonKyeong_MogPyo_:_0")..ScpArgMsg("Auto_HyeonJae_Leieo_:_")..GetLayer(pcList[i]))
                                    end
                                end
                            end
--                            print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_Leieo_ByeonKyeong_Jeon"))
                            StopDirectionByName(pc, list[3])
--                            ResetScrollLockBox(pc)
                            SetLayer(pc, 0)
                            
                            CustomMongoLog(pc, "QuestTrack", "Type", "End", "QuestName", questname, "TrackName", list[3], "TrackOwner", layerOwner, "Zone", GetZoneName(pc))
--                            print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNaKo_Leieo_ByeonKyeong_MogPyo_:_0")..ScpArgMsg("Auto_HyeonJae_Leieo_:_")..GetLayer(pc))
                            
							local dlgShowState = SCR_QUEST_SUCC_REWARD_DLG(pc, questIES, questIES_Auto, sObj)
                            
                            if dlgShowState == 'DlgAfter' then
                                local sel = ShowQuestSelDlg(pc, questIES.ClassName, 1);
                            end
                        end
                	end
                end
            end
        end
    end
end

function SCR_TRACK_END_ITEMGETPACKET_LOCK(pc, list, questIES_Auto)
    if list[1] == 'SPossible' and questIES_Auto.Possible_PauseItemMSG == 'AfterPossibleTrack' then
        ResumeItemGetPacket(pc);
    elseif list[1] == 'SProgress' and questIES_Auto.Progress_PauseItemMSG == 'AfterProgressTrack' then
        ResumeItemGetPacket(pc);
    elseif list[1] == 'SSuccess' and questIES_Auto.Success_PauseItemMSG == 'AfterSuccessTrack' then
        ResumeItemGetPacket(pc);
    end
end
function SCR_DIALOG_ANIM(self,pc)
    if GetPropType(self, 'SET') ~= nil then
        local animIES = GetClass('npcidleanim',self.SET)
        if animIES ~= nil then
            local index
            local animlist = {}
            for index = 1, 5 do
                if animIES['Idle'..index] ~= nil then
                    if animIES['Idle'..index] ~= 'None' then
                        animlist[#animlist + 1] = animIES['dialog'..index]
                    end
                end
            end
    
            if #animlist == 0 then
                return
            end
            PlayAnimLocal(self, pc, animlist[IMCRandom(1, #animlist)], 0);
        end
    end
end

function SCR_INV_SLOT_CHECK(pc,item_list, rullet_use, take_list)
    local result
    local slot_count = 'NO'
    local slot_maxstack_over = {}
    local blank_slot = GetEmptyItemSlotCount(pc)
    local overlap_slot = 0
    local i
    
    for x = 1, #item_list do
        local flag = 0
        for y = 1, #item_list do
            if item_list[y][2] < 0 then
                table.remove(item_list,y)
                flag = 1
                break
            end
        end
        if flag == 0 then
            break
        end
    end
    
    for x = 1, #take_list do
        local flag = 0
        for y = 1, #take_list do
            if take_list[y][2] == 0 then
                table.remove(take_list,y)
                flag = 1
                break
            end
        end
        if flag == 0 then
            break
        end
    end
    
    if rullet_use == 'YES' then
        blank_slot = blank_slot - 1
    end
    if take_list ~= nil and #take_list > 0 then
        for i = 1, #take_list do
            local takeitem_count = GetInvItemCount(pc, take_list[i][1])
            if take_list[i][2] ~= -100 and( takeitem_count <= 0 or takeitem_count < take_list[i][2] )then
                local takeitem_name = GetClassString('Item', take_list[i][1], 'Name')
                SysMsg(pc, 'Instant', takeitem_name..ScpArgMsg("Auto__aiTemi_PilyoLyange_MoJaLapNiDa."));
                result = 'NO'
                
                return result
            else
                local takeitem = GetClass('Item', take_list[i][1])
                if takeitem ~= nil then
                    if takeitem.MaxStack <= 1 then
                        blank_slot = blank_slot + 1
                    else
                        if takeitem_count == take_list[i][2] then
                            blank_slot = blank_slot + 1
                        end
                    end
                end
            end
        end
    end
    
    if blank_slot < 0 then
        slot_count = 'NO'
    elseif #item_list <= blank_slot then
        slot_count = 'YES'
        
        for i = 1, #item_list do
            local itemIES = GetClass('Item', item_list[i][1])
            if itemIES ~= nil then
                if itemIES.MaxStack > 1 then
                    local item_count = GetInvItemCount(pc, item_list[i][1])
                    
                    if item_count > 0 then
                        if item_count + item_list[i][2] <= itemIES.MaxStack then
                        else
                            slot_maxstack_over[#slot_maxstack_over + 1]  = {}
                            slot_maxstack_over[#slot_maxstack_over][1] = item_list[i][1]
                            slot_maxstack_over[#slot_maxstack_over][2] = itemIES.MaxStack - item_count - item_list[i][2]
                        end
                    end
                end
            end
        end
    else
        local i,j
        local temp_item_list = {}
        local overlap_list = {}
        
        
        for i = 1, #item_list - 1 do
            for j = i +1 , #item_list do
                if GetClassNumber('Item', item_list[i][1], 'MaxStack') > 1 then
                    if item_list[i][1] == item_list[j][1] then
                        item_list[i][1] = 'None'
                        item_list[j][2] = item_list[i][2] + item_list[j][2]
                    end
                end
            end
        end
        
        for i = 1, #item_list do
            if item_list[i][1] ~= 'None' then
                temp_item_list[#temp_item_list + 1] = {}
                temp_item_list[#temp_item_list][1] = item_list[i][1]
                temp_item_list[#temp_item_list][2] = item_list[i][2]
            end
        end
        
        if item_list ~= temp_item_list then
            item_list = temp_item_list
        end
        
        
        for i = 1, #item_list do
            local itemIES = GetClass('Item', item_list[i][1])
            if itemIES ~= nil then
                if itemIES.MaxStack > 1 then
                    local item_count = GetInvItemCount(pc, item_list[i][1])
                    if item_count > 0 then
                        if item_count + item_list[i][2] <= itemIES.MaxStack then
                            overlap_slot = overlap_slot + 1
                        else
                            slot_maxstack_over[#slot_maxstack_over + 1]  = {}
                            slot_maxstack_over[#slot_maxstack_over][1] = item_list[i][1]
                            slot_maxstack_over[#slot_maxstack_over][2] = itemIES.MaxStack - item_count - item_list[i][2]
                        end
                    end
                end
            end
        end
        
        if #item_list - overlap_slot <= blank_slot then
            slot_count = 'YES'
        end
    end
    
    if slot_count == 'YES' and #slot_maxstack_over == 0 then
        result = 'YES'
    else
        local slot_maxstack_over_item = ''
        
        if #slot_maxstack_over > 0 then
            for i = 1, #slot_maxstack_over do
                if i == 1 then
                    slot_maxstack_over_item = GetClassString('Item', slot_maxstack_over[i][1],'Name')
                else
                    slot_maxstack_over_item = slot_maxstack_over_item..', '..GetClassString('Item', slot_maxstack_over[i][1],'Name')
                end
            end
        end
        
        if slot_count == 'NO' then
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_inBenToLiKa_KaDeug_Cha_aiTemeul_HoegDeug_Hal_Su_eopSeupNiDa!{nl}_']'_KiLo_JeugSeogSangJeomeul_yeoleo_inBenToLiLeul_BiwoJuSeyo."), 8);
--            SysMsg(pc, 'Instant', ScpArgMsg("Auto_inBenToLie_Bin_SeulLosi_PilyoHapNiDa."))
        elseif #slot_maxstack_over > 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_!", slot_maxstack_over_item..ScpArgMsg("Auto__SeulLosDang_NuJeog_SuChiLeul_ChoKwa_HapNiDa."), 8);
--            SysMsg(pc, 'Instant', slot_maxstack_over_item..ScpArgMsg("Auto__SeulLosDang_NuJeog_SuChiLeul_ChoKwa_HapNiDa."))
        end
        
        result = 'NO'
    end
    
    return result
end


function SCR_QUEST_TAKEITEM(pc,tx,take_item_classname, take_item_count,questname)
    local take_flag = 'No'
    local result
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname)
    local questID = quest_auto.ClassID
    local takeitemBan = 'NO'
    
    if take_item_count < 0 then
        take_flag = 'ALL'
    end
    
    if quest_auto ~= nil then
        for i = 1, 5 do
            if take_item_classname == quest_auto['Abandon_TakeItem_Ban'..i] then
                takeitemBan = 'YES'
                break
            end
        end
    end
    
    if take_item_classname ~= 'None' then
		local itemCls = GetClass('Item', take_item_classname);
		local eqpSlot;
		if itemCls.ItemType == "Equip" then
			eqpSlot = itemCls.DefaultEqpSlot;
		else
			eqpSlot = "None";
		end

        if eqpSlot ~= 'None' then
            if take_flag == 'ALL' then
                print(questname,ScpArgMsg("Auto_KweSeuTeu_JangBi_aiTem_SagJe_Si_KajKoissNeun_JeonBuLeul_Ppaeseul_Su_eopSeupNiDa._Count_Ka_eumSuLo_DoeeoissSeupNiDa."))
                return
            else
                eqpItem = GetEquipItem(pc, eqpSlot)
                if eqpItem.ClassName == take_item_classname then
                    TxTakeEquipItem(tx, eqpSlot)
                    take_item_count = take_item_count - 1
                end
                
                if take_item_count > 0 then
                    if takeitemBan == 'YES' then
                        local count = GetInvItemCount(pc, take_item_classname)
                        if count > 0 then
                            if take_item_count > count then
                                take_item_count = count
                            end
                            result = TxTakeItem(tx, take_item_classname, take_item_count, "Q_" .. questID) 
                        end
                    else
                        result = TxTakeItem(tx, take_item_classname, take_item_count, "Q_" .. questID)
                    end
                end
            end
        else
            local count = GetInvItemCount(pc, take_item_classname);
            if take_flag == 'ALL' then
                
                if count > 0 then
            		result = TxTakeItem(tx, take_item_classname, count, "Q_" .. questID);
            	end
        	else
        	    if takeitemBan == 'YES' then
        	        if count > 0 then
                        if take_item_count > count then
                            take_item_count = count
                        end
                        result = TxTakeItem(tx, take_item_classname, take_item_count, "Q_" .. questID) 
                    end
        	    else
            	    result = TxTakeItem(tx, take_item_classname, take_item_count, "Q_" .. questID);
            	end
        	end
        end
	end
	
	if result == 0 and IsGM(pc) == 1 then
	    local itemCls = GetClass('Item', take_item_classname);
	    SendAddOnMsg(pc, "NOTICE_Dm_!", 'TxTake Error : Item Name('..itemCls.Name..') ClassName('..take_item_classname..')', 10)
	end
	
	return result
end


function SCR_QUEST_T_PCLOOPANIM(self, pc, animlist, questname, anim_position)
    if animlist ~= 'None' then
        local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
        local questIES = GetClass('QuestProgressCheck', questname);
        
        local list = SCR_STRING_CUT(animlist)
        if list ~= nil and list[4] == anim_position then
            if tonumber(list[3]) == nil then
                return questname..ScpArgMsg("Auto__KweSeuTeu_PCLoopAnim_KeolLeom_SeBeonJjae_inJaKa_SusJaKa_aNim")
            end
            
            local result
            
            if self ~= nil and list[6] ~= nil and list[6] ~= 'None' then
        		AttachEffect(self, list[6], tonumber(list[7]), list[8], 0, 0, 0, 1);
            end
            
            if pc ~= nil and list[9] ~= nil and list[9] ~= 'None' then
        		AttachEffect(pc, list[9], tonumber(list[10]), list[11], 0, 0, 0, 1);
            end
            
            if self ~= nil then
                LookAt(pc, self)
            end
            
            
            
--            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, tonumber(list[3]), questname)
            
            if list[5] ~= nil and list[5] ~= 'None' then
                result = DOTIMEACTION_R_FAILTIME_SET(pc, questname, list[1], tonumber(list[3]), list[2], list[5])
--                result = DOTIMEACTION_R(pc, list[1], list[2], animTime, list[5])
            else
                result = DOTIMEACTION_R_FAILTIME_SET(pc, questname, list[1], tonumber(list[3]), list[2])
--                result = DOTIMEACTION_R(pc, list[1], list[2], animTime)
            end
            
--            DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, questname)
            
            
            if result == nil or result == 0 then
                if self ~= nil and list[6] ~= nil and list[6] ~= 'None' then
                    RemoveEffect(self, list[6], 1)
                end
                return 'NO'
            end
        end
    end
    
    return 'YES'
end

function SCR_QUEST_SUCCESS_CHANGE(pc, questname)
    local questIES = GetClass('QuestProgressCheck', questname);
    local main_sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    if main_sObj ~= nil then
        if main_sObj[questIES.QuestPropertyName] ~= CON_QUESTPROPERTY_MAX then
            local tx = TxBegin(pc);
            TxEnableInIntegrate(tx)
            TxSetIESProp(tx, main_sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_MAX);
        	local ret = TxCommit(tx, 1);
        	if ret == 'FAIL' then
        	    print(quest_auto.Name,'SCR_QUEST_SUCCESS_CHANGE Transaction FAIL')
        	end
        end
	end
	
    local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
    if sObj_quest ~= nil then
        if questIES.QuestEndMode == 'SYSTEM' then
            SCR_SSN_SUCC_PLAY_COMPLETE(pc, sObj_quest)
        else
            SCR_SSN_SUCC_CHECK_TIMER(pc, sObj_quest)
        end
    end
end



function SCR_QUEST_PROGRESS_PROP_CHANGE(self, pc, questname, isStartNPC, selfname)
    local questIES = GetClass('QuestProgressCheck', questname);
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    local questID = questIES.ClassID;
    local endnpc_gentype = {}
    local gentype_classcount = GetClassCount('GenType_'..questIES.EndMap)
    local i
    local npc_gentype = 0

    if gentype_classcount > 0 and quest_auto.Progress_NextNPC_Icon ~= 'NO' and questIES.EndNPC ~= 'None' then
        for i = 0 , gentype_classcount-1 do
            if GetClassStringByIndex('GenType_'..questIES.EndMap, i, 'Dialog') == questIES.EndNPC or GetClassStringByIndex('GenType_'..questIES.EndMap, i, 'Enter') == questIES.EndNPC or GetClassStringByIndex('GenType_'..questIES.EndMap, i, 'Leave') == questIES.EndNPC then
                endnpc_gentype[#endnpc_gentype+1] = GetClassNumberByIndex('GenType_'..questIES.EndMap, i, 'GenType')
            end
        end
        if #endnpc_gentype > 0 then
            for i = 1, #endnpc_gentype do
                if GetNPCStateByGenType(pc, questIES.EndMap, endnpc_gentype[i]) < 1 then
                    npc_gentype = endnpc_gentype[i]
                end
            end
        end
    end
    
    if quest_auto.Progress_Smartgen == 'YES' then
        local smartgen_sObj = GetSessionObject(pc, 'ssn_smartgen')
        if smartgen_sObj ~= nil then
            SCR_SMARTGEN_GENFLAG_RESTART(smartgen_sObj)
        end
    end
    
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    if npc_gentype > 0 then
        TxChangeGenTypeState(tx, questIES.EndMap, npc_gentype, 1)
    end


    if quest_auto.Progress_UIOpen1 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Progress_UIOpen1,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Progress_UIOpen2 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Progress_UIOpen2,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Progress_UIOpen3 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Progress_UIOpen3,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end

    if quest_auto.Progress_UIOpen4 ~= 'None' then
        local uistate_property, value = string.match(quest_auto.Progress_UIOpen4,'(.+)[/](.+)')
        if pc[uistate_property] ~= nil then
            TxSetIESProp(tx, pc, uistate_property, value);
        end
    end
    
    for i = 1, 5 do
        SCR_QUEST_TAKEITEM(pc,tx,quest_auto['Progress_TakeItemName'..i], quest_auto['Progress_TakeItemCount'..i],questname)
    end
    
	
        
    for i = 1, 4 do
        if quest_auto['Progress_ItemName'..i] ~= 'None' and quest_auto['Progress_ItemCount'..i] > 0 then
            TxGiveItem(tx, quest_auto['Progress_ItemName'..i], quest_auto['Progress_ItemCount'..i], "Q_" .. questID);
        end
    end
    
    if sObj[questIES.QuestPropertyName] == 1 then
	    local value = 2
	    TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value)
		QuestStateMongoLog(pc, questIES.ClassName, questIES.QuestPropertyName, "StateChange", "State", value);
    end
    
    if quest_auto.Progress_NextNPC == 'ENDNPC' then
        SCR_QUESTPROPERTY_MAX(tx, pc, sObj, questIES, questname)
    end
    if quest_auto.Progress_NextNPC == 'SUCCESS' then
        SCR_QUESTPROPERTY_MAX(tx, pc, sObj, questIES, questname)
    end
    
    
	local ret = TxCommit(tx, 1);
	if ret == 'FAIL' then
	    print(questIES.Name,'QUEST PROGRESS Transaction FAIL')
	    return 'Transaction FAIL';
	end
	
	for i = 1, 6 do
    if quest_auto['Progress_AgreeQuest'..i] ~= 'None' then
	        local result1 = SCR_QUEST_CHECK(pc,quest_auto['Progress_AgreeQuest'..i])
	        if result1 == 'POSSIBLE' then
	            SCR_QUEST_POSSIBLE_AGREE(pc, quest_auto['Progress_AgreeQuest'..i], nil, nil, selfname)
	        end
	    end
	end
end



function SCR_TRACK_PARTYPLAY(partyPlayer, pc, questname, trackSteate, pcIndex, isdirection, changeBGM, selfname, trackname)
    if GetLayer(partyPlayer) == 0 and IsPlayingDirection(partyPlayer) ~= 1 then
        CloseDlg(partyPlayer)
		SCR_TRACK_SETPOS_PARTY(partyPlayer, pc, questname, pcIndex, isdirection, trackSteate, changeBGM, selfname, trackname);
    end
end

function SCR_TRACK_SETPOS_PARTY(partyPlayer, pc, questname, pcIndex, isdirection, trackSteate, changeBGM, selfname, trackname)

    local pos_list = SCR_CELLGENPOS_LIST(pc, 'Basic5', 0)
    local zoneInsID = GetZoneInstID(pc)
                
    local x = pos_list[pcIndex%(#pos_list) + 1][1]
    local y = pos_list[pcIndex%(#pos_list) + 1][2] + 70
    local z = pos_list[pcIndex%(#pos_list) + 1][3]
        
    if IsValidPos(zoneInsID, x, y, z) == 'YES' then
    else
        local flag = 0
            
        for i = 1, 100 do
            local index = IMCRandom(1,#pos_list)
            x = pos_list[index][1]
            y = pos_list[index][2] + 30
            z = pos_list[index][3]
            if IsValidPos(zoneInsID, x, y, z) == 'YES' then
                flag = 100
                break
            end
        end
            
        if flag == 0 then
            x, y, z = GetPos(pc)
        end
    end  

	local addedMspd = 0
    if GetLayer(partyPlayer) == 0 and IsPlayingDirection(partyPlayer) ~= 1 then
	
        if changeBGM ~= nil then
            PlayMusicQueueLocal(partyPlayer, changeBGM)
        end
		if isdirection == 1 then
			AddDirectionPC(pc, partyPlayer);
			CustomMongoLog(partyPlayer, "QuestTrack", "Type", "Init", "QuestName", questname, "TrackName", trackname, "TrackOwner", pc.Name, "Zone", GetZoneName(partyPlayer), "TrackType","Direction")
		end

		if GetDistance(pc, partyPlayer) < 280 then
			InvalidateStates(partyPlayer);
			addedMspd = 200
			MoveEx(partyPlayer,x,y,z,1,"RUN");
			
			sleep(500);
		else
			PlayAnim(partyPlayer,'WARP')
			sleep(500);
			SetPos(partyPlayer, x, y, z);
			local list, cnt= GetFollowerList(partyPlayer);
			for i = 1 , cnt do
				local fol = list[i];
				SetPos(fol, x, y, z);
			end
			LookAt(partyPlayer, pc);
		end

   	
		if isdirection ~= 1 then
    	    SetLayer(partyPlayer, GetLayer(pc))
    	    CustomMongoLog(partyPlayer, "QuestTrack", "Type", "Init", "QuestName", questname, "TrackName", trackname, "TrackOwner", pc.Name, "Zone", GetZoneName(partyPlayer), "TrackType","Function")
    	end

    	RunZombieScript("SCR_TRACK_PARTYPLAY_SOBJ", partyPlayer, questname, trackSteate, selfname);		

		if isdirection == 1 then

			sleep(500);

			PlayAnim(partyPlayer,'ASTD');

			sleep(500);

			ReadyDirectionPC(pc, partyPlayer);
			if addedMspd > 0 then
--				partyPlayer.MSPD_BM = partyPlayer.MSPD_BM - addedMspd;
				InvalidateStates(partyPlayer);
				local pc_x, pc_y, pc_z = GetPos(partyPlayer);
				if SCR_POINT_DISTANCE(x,z,pc_x,pc_z) > 50 then
					PlayAnim(partyPlayer,'ASTD');
					local list, cnt= GetFollowerList(partyPlayer);
					for i = 1 , cnt do
						local fol = list[i];
						SetPos(fol, x, y, z);
					end
					SetPos(partyPlayer, x, y, z);
				end
			end

			LookAt(partyPlayer, pc);
			return;
    	end
	else
		PlayAnim(partyPlayer,'WARP')
		sleep(500)	
	end

	sleep(500)
	PlayAnim(partyPlayer,'ASTD');
	if addedMspd > 0 then
--		partyPlayer.MSPD_BM = partyPlayer.MSPD_BM - addedMspd;
		InvalidateStates(partyPlayer);
	end

	LookAt(partyPlayer, pc);
end

function SCR_TRACK_PARTYPLAY_SOBJ(partyPlayer, questname, trackSteate, selfname)
	local flag2, quest_reason, preQuestList = SCR_TRACK_PARTYPLAY_SOBJ_PRECHECK(partyPlayer, questname, trackSteate, selfname)
	local main_sObj = GetSessionObject(partyPlayer, 'ssn_klapeda')
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname)
    local sObjTimeFlag = false
    
    if flag2 > 0 and flag2 <= 3 then
        sObjTimeFlag = true
        
        if flag2 == 1 then
            SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(partyPlayer, questname)
            SCR_QUEST_POSSIBLE_AGREE_DLG(partyPlayer, questname, nil, nil, selfname, quest_auto, 'YES')
        elseif flag2 == 2 then
            SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(partyPlayer, questname)
            SCR_QUEST_POSSIBLE_AGREE_DLG(partyPlayer, questname, nil, nil, selfname, quest_auto, 'YES')
            
            SCR_QUEST_PROGRESS_PROP_CHANGE(nil, partyPlayer, questname, 'YES', selfname)
            SCR_QUEST_PROGRESS_DLG(nil, partyPlayer, questname, selfname, quest_auto, 'YES')
        elseif flag2 == 3 then
            SCR_QUEST_PROGRESS_PROP_CHANGE(nil, partyPlayer, questname, 'YES', selfname)
            SCR_QUEST_PROGRESS_DLG(nil, partyPlayer, questname, selfname, quest_auto, 'YES')
        end
    elseif flag2 == 6 or flag2 == 7 then
        sObjTimeFlag = true
        SCR_QUEST_SUCCESS(partyPlayer, preQuestList, nil, selfname, 'YES')
        if flag2 == 6 then
            SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(partyPlayer, questname)
            SCR_QUEST_POSSIBLE_AGREE_DLG(partyPlayer, questname, nil, nil, selfname, quest_auto, 'YES')
        elseif flag2 == 7 then
            SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(partyPlayer, questname)
            SCR_QUEST_POSSIBLE_AGREE_DLG(partyPlayer, questname, nil, nil, selfname, quest_auto, 'YES')
            
            SCR_QUEST_PROGRESS_PROP_CHANGE(nil, partyPlayer, questname, 'YES', selfname)
            SCR_QUEST_PROGRESS_DLG(nil, partyPlayer, questname, selfname, quest_auto, 'YES')
        end
    end
    
    
    local tx = TxBegin(partyPlayer);
    TxEnableInIntegrate(tx)
    local etc = GetETCObject(partyPlayer)
    if GetPropType(etc, quest_auto.ClassName..'_TRACK') ~= nil then
        local value = etc[quest_auto.ClassName..'_TRACK'] + 1
        TxSetIESProp(tx, etc, quest_auto.ClassName..'_TRACK', value)
        --print('XXXX'..partyPlayer.Name,etc[quest_auto.ClassName..'_TRACK'])
    end
    
    if flag2 == 1 or flag2 == 2 or flag2 == 3 or flag2 == 6 or flag2 == 7  then
        if main_sObj ~= nil then
            local value = main_sObj[questname] + 10
    		TxSetIESProp(tx, main_sObj, questname, value);
        end
    end
    local ret = TxCommit(tx, 1);
	
	if ret == 'FAIL' then
	    print(quest_auto.Name,'SCR_TRACK_PARTYPLAY_SOBJ Transaction FAIL')
	else
		QuestStateMongoLog(partyPlayer, questname, questname, "StateChange", "State", value);
	end
	
    
    if main_sObj ~= nil then
        main_sObj.TRACK_QUEST_NAME = 'None'
    end
    
    
    if sObjTimeFlag == true then
        local questIES = GetClass('QuestProgressCheck',questname)
        if questIES.Quest_SSN ~= 'None' and questIES.Quest_SSN ~= '' then
            if quest_sObj == nil then
    		    quest_sObj = GetSessionObject(partyPlayer, questIES.Quest_SSN)
    		end
    	    if quest_sObj ~= nil then
        		if GetPropType(quest_sObj,'Countdown_StartType') ~= nil and GetPropType(quest_sObj,'Countdown_Time') ~= nil then
                    if quest_sObj.Countdown_StartType == 'TrackStart' and quest_sObj.Countdown_Time > 0  then
                        SCR_QUEST_COUNTDOWN_FUNC(partyPlayer, quest_sObj)
                        
                    end
                end
            end
        end
    end
end

function SCR_TRACK_PARTYPLAY_SOBJ_PRECHECK(partyPlayer, questname, trackSteate, selfname)
    local ret = 0
    
    local cnt, qList, vList = GetQuestCheckStateList(partyPlayer);
	
	if cnt > 0 then
    	for i = 1, cnt do
    	    if vList[i] > 0 then
    	        ret = -1
    	        return ret
    	    end
    	end
    end
    
    local shopCheck = CanBeWarpStateToQuestLayer(partyPlayer)
    
    if shopCheck ~= 1 then
        ret = -2
        return ret
    end
    
	
    local result, quest_reason = SCR_QUEST_CHECK(partyPlayer, questname)
    local preQuestList
    if result == 'IMPOSSIBLE' then
        if #quest_reason == 1 and quest_reason[1] == 'Check_QuestCount' then
            local questIES = GetClass('QuestProgressCheck', questname)
            local questIES_Auto = GetClass('QuestProgressCheck_Auto', questname)
            if questIES.Check_QuestCount == 1 and questIES.QuestCount1 == 300 and questIES.QuestTerms1 == '>=' then
                local tQuestIES = GetClass('QuestProgressCheck', questIES.QuestName1)
                if tQuestIES.EndNPC == questIES.StartNPC then
                    local result2 = SCR_QUEST_CHECK(partyPlayer, questIES.QuestName1)
                    if result2 ~= nil and result2 == 'SUCCESS' then
                        preQuestList = questIES.QuestName1
                        
                        if trackSteate == 'SPossible' then
                            ret = 6
                        elseif trackSteate == 'SProgress' then
                            ret = 7
                        end
                    end
                end
            end
        end
    elseif result == 'SUCCESS' then
        ret = 4
    elseif result == 'COMPLETE' then
        ret = 5
    elseif trackSteate == 'SPossible' then
        if result == 'POSSIBLE' then
            ret = 1;
        end
    elseif trackSteate == 'SProgress' then
        if result == 'POSSIBLE' then
            ret = 2;
        elseif result == 'PROGRESS' then
            local main_sObj = GetSessionObject(partyPlayer, 'ssn_klapeda')
            if main_sObj[questname] == 1 then
                ret = 3;
            end
        end
    end
    
    return ret, quest_reason, preQuestList
end

function SCR_UNHIDENPC_RUN(pc, npcFuncName, sleepTime)
    if sleepTime ~= nil then
        sleep(tonumber(sleepTime))
        UnHideNPC(pc, npcFuncName)
    end
end
function SCR_HIDENPC_RUN(pc, npcFuncName, basicTime, hideTime)
    if hideTime ~= nil then
        sleep(tonumber(hideTime))
        HideNPC(pc, npcFuncName, x, z, basicTime)
    end
end

function SCR_INV_SLOT_CHECK_BEFORE(pc,item_list, rullet_use, take_list)
    
    local giveItem_temp = SCR_STRING_CUT(item_list)
    local takeItem_temp = SCR_STRING_CUT(take_list)
    local giveItem = {}
    local takeItem = {}
    if giveItem_temp ~= nil and  #giveItem_temp > 1 then
        for i = 1 , #giveItem_temp / 2 do
            if tonumber(giveItem_temp[i*2]) > 0 then
                giveItem[#giveItem + 1] = {}
                giveItem[#giveItem][1] = giveItem_temp[i*2 - 1]
                giveItem[#giveItem][2] = tonumber(giveItem_temp[i*2])
            end
        end
    end
    if takeItem_temp ~= nil and  #takeItem_temp > 1 then
        for i = 1, #takeItem_temp/2 do
            if tonumber(takeItem_temp[i*2]) ~= 0 then
                takeItem[#takeItem + 1] = {}
                takeItem[#takeItem][1] = takeItem_temp[i*2 - 1]
                takeItem[#takeItem][2] = tonumber(takeItem_temp[i*2])
            end
        end
    end
    
    local result = SCR_INV_SLOT_CHECK(pc,giveItem, rullet_use, takeItem)
    
--    if result == 'NO' then
--        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_inBenToLiKa_KaDeug_Cha_aiTemeul_HoegDeug_Hal_Su_eopSeupNiDa!{nl}_']'_KiLo_JeugSeogSangJeomeul_yeoleo_inBenToLiLeul_BiwoJuSeyo."), 8);
--    end
    return result
end

function SCR_SSN_TIMEOUT_PARTY_SUCCESS(pc,questName, hideNPCList, unhideNPCList)
	local partyPlayerList, cnt = GET_PARTY_ACTOR(pc, 0)
    local pc_layer_1 = GetLayer(pc)

	
	if cnt > 0 then
        for i = 1, cnt do
            if IsSameActor(pc, partyPlayerList[i]) == 'YES' or SHARE_QUEST_PROP(pc, partyPlayerList[i]) == true then
                if pc_layer_1 == GetLayer(partyPlayerList[i]) then
                    local result = SCR_QUEST_CHECK(partyPlayerList[i], questName)
                    if result == 'PROGRESS' or result == 'SUCCESS' then
                        local hideNPC = SCR_STRING_CUT(hideNPCList)
                        if hideNPCList ~= nil and #hideNPC > 0 and hideNPC[1] ~= "" then
                            for y = 1, #hideNPC do
                                HideNPC(partyPlayerList[i], hideNPC[y], 0, 0, 0)
                            end
                        end
                        
                        local unhideNPC = SCR_STRING_CUT(unhideNPCList)
                        if unhideNPC ~= nil and  #unhideNPC > 0 and unhideNPC[1] ~= "" then
                            for y = 1, #unhideNPC do
                                UnHideNPC(partyPlayerList[i], unhideNPC[y])
                            end
                        end
                        RunZombieScript('SCR_QUEST_SUCCESS_CHANGE',partyPlayerList[i], questName)
                    end
                end
            end
        end
    end
end


function SCR_QUEST_DLG_BEFORE_TRACK_END(pc, questname, track_txt, quest_state)
    
    if GetLayer(pc) == 0 then
        return
    end
    
    
    local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
    if obj ~= nil then
        if obj.EventOwner ~= pc.Name then
            return
        end
    end
    
    if track_txt ~= 'None' then
		
		
		pc.FIXMSPD_BM = 0;
		InvalidateMSPD(pc);

        local list = SCR_STRING_CUT(track_txt)
        if list[3] ~= nil and GetLayer(pc) ~= 0 then
            if list[2] == 'E'..quest_state or quest_state == 'PossibleCancel' then

                local questIES = GetClass('QuestProgressCheck', questname);
                local questIES_auto = GetClass('QuestProgressCheck_Auto', questname)
                local sObj = GetSessionObject(pc, 'ssn_klapeda');
                
                local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
--                print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_1111111,_Leieo_oBeuJegTeu_:_"),obj)
                if obj ~= nil then
--                    print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_2222222,_Leieo_oBeuJegTeu_EventName_:_"),obj.EventName)
                	if obj.EventName == questname then
                	    local pc_layer = GetLayer(pc)
--                        print(pc.Name..ScpArgMsg("Auto__KaeLigTeo_")..questname..ScpArgMsg("Auto__KweSeuTeu_yeonChul_KkeutNasseum_333333,_PC_HyeonJae_Leieo_:_"), pc_layer)
                        if pc_layer ~= 0 then
                            local monList, monCount = GetLayerMonList(GetZoneInstID(pc), GetLayer(pc))
                            local deadMonCount = 0
                            
                            if monCount > 0 then
                                for i = 1, monCount do
                                    if monList[i].ClassName ~= 'PC' and GetCurrentFaction(monList[i]) == 'Monster' then
                                        deadMonCount = deadMonCount + 1
                                        Dead(monList[i])
                                    elseif monList[i].ClassName == 'HitMe' then
                                        SetLayer(monList[i], 0)
                                    end
                                end
                            end
                            if deadMonCount > 0 then
                                sleep(1500)
                            end
                            
                            WAIT_END_DIRECTION(pc)
                            
                            SCR_TRACK_END_ITEMGETPACKET_LOCK(pc, list, questIES_auto)
                            
                            if list[4] ~= nil then
                                local sleepTime = tonumber(list[4])
                                
                                if sleepTime ~= nil and sleepTime > 0 then
                                    sleep(sleepTime)
                                end
                            end
                            local itemList, itemCount = GetLayerItemList(GetZoneInstID(pc), GetLayer(pc))
                            if itemCount > 0 then
                                for i = 1, itemCount do
                                    if itemList[i].ClassName ~= 'PC' and ( 1 == IsItem(itemList[i]) or itemList[i].Tactics == 'MON_HITME') then
                                        SetLayer(itemList[i], 0)
                                    end
                                end
                            end
                            
                            local changeBGM
                            if list[5] ~= nil and list[5] ~= 'None' then
                                changeBGM = list[5]
                                StopMusicQueueLocal(pc, changeBGM)
                                sleep(100)                                      
                            end
                            
                            
                            local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc));
                            if cnt ~= nil and cnt > 0 then
                                for i = 1, cnt do
                                    if IsSameActor(pcList[i], pc) == 'NO' then
                                        if changeBGM ~= nil then
                                            StopMusicQueueLocal(pcList[i], changeBGM)
                                        end
                                        SetLayer(pcList[i], 0)
                                    end
                                end
                            end
							QuestStateMongoLog(pc, questname, questname, "Quest Track End")
                        end
                	end
                end
            end
        end
    end
end


function SCR_QUEST_TRACK_OWNER_OUT(pc, questname, track_txt, quest_state, beforeLayer)
    
    
    if beforeLayer == nil then
        beforeLayer = GetLayer(pc)
    end
    
    if beforeLayer == 0 then
        return
    end
    local obj = GetLayerObject(GetZoneInstID(pc), beforeLayer);
    if obj ~= nil then
        if obj.EventOwner ~= pc.Name then
            return
        end
    end
    if track_txt ~= 'None' then
		pc.FIXMSPD_BM = 0;
		InvalidateMSPD(pc);
        local list = SCR_STRING_CUT(track_txt)
        if list[3] ~= nil and beforeLayer ~= 0 then
            if list[2] == 'E'..quest_state or quest_state == 'PossibleCancel' then
                local questIES = GetClass('QuestProgressCheck', questname);
                local questIES_auto = GetClass('QuestProgressCheck_Auto', questname)
                local sObj = GetSessionObject(pc, 'ssn_klapeda');
                
                if obj ~= nil then
                	if obj.EventName == questname then
                        local monList, monCount = GetLayerMonList(GetZoneInstID(pc), beforeLayer)
                        if monCount > 0 then
                            for i = 1, monCount do
                                if monList[i].ClassName ~= 'PC' and GetCurrentFaction(monList[i]) == 'Monster' then
                                    Kill(monList[i])
                                elseif monList[i].ClassName == 'HitMe' then
                                    SetLayer(monList[i], 0)
                                end
                            end
                        end
                        
                        local itemList, itemCount = GetLayerItemList(GetZoneInstID(pc), beforeLayer)
                        if itemCount > 0 then
                            for i = 1, itemCount do
                                if itemList[i].ClassName ~= 'PC' and ( 1 == IsItem(itemList[i]) or itemList[i].Tactics == 'MON_HITME') then
                                    SetLayer(itemList[i], 0)
                                end
                            end
                        end
                        
                        local changeBGM
                        if list[5] ~= nil and list[5] ~= 'None' then
                            changeBGM = list[5]
                            StopMusicQueueLocal(pc, changeBGM)
                        end
                        
                        SCR_TRACK_END_ITEMGETPACKET_LOCK(pc, list, questIES_auto)
                        
                        
                        local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), beforeLayer);
                        if cnt ~= nil and cnt > 0 then
                            for i = 1, cnt do
                                if IsSameActor(pcList[i], pc) == 'NO' then
                                    if changeBGM ~= nil then
                                        StopMusicQueueLocal(pcList[i], changeBGM)
                                    end
                                    local ret = SCR_QUEST_CHECK(pcList[i], questname)
                                    if ret == 'PROGRESS' or (questIES.QuestEndMode == 'SYSTEM' and ret == 'SUCCESS') then
                                        RunZombieScript('ABANDON_Q_BY_NAME',pcList[i], questname, 'SYSTEMCANCEL')
                                    end
                                    RunZombieScript('SCR_QUEST_TRACK_OWNER_OUT_MOVE',pcList[i])
                                end
                            end
                        end
						 QuestStateMongoLog(pc, questname, questname, "Quest Track End")
                	end
                end
            end
        end
    end
end

function SCR_QUEST_TRACK_OWNER_OUT_MOVE(pc)
    WAIT_END_DIRECTION(pc)
    SetLayer(pc, 0)
--    if IsInScrollLockBox(pc) == 1 then
--        ResetScrollLockBox(pc)
--    end
end


function PARTY_HOOK_FUNCTION(hookFuncName,self, party_pc, sObj, msg, argObj, argStr, argNum)
    local func = _G[hookFuncName]
    if func ~= nil then
        if party_pc ~= nil and self ~= nil then
            if SHARE_QUEST_PROP(self, party_pc) == true then
                if GetLayer(self) ~= 0 then
                    if GetLayer(self) == GetLayer(party_pc) then
                        func(self, sObj, msg, argObj, argStr, argNum)
                    end
                else
                    func(self, sObj, msg, argObj, argStr, argNum)
                end
            end
        end
    else
        print('Error : Hook Function not found')
    end
end

function SCR_QUEST_DIALOG_REPLAY_SERVER(pc, qusetClassID)
    local questIES = GetClassByType('QuestProgressCheck',qusetClassID)
    local quest_auto = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
    local questname = questIES.ClassName
    if quest_auto.Possible_SelectDialog1 == 'None' then
        SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questIES.ClassName, nil, nil, nil, quest_auto, nil, 'YES')
    else
        if string.find(quest_auto.Possible_SelectDialog1, '/') == nil then
            local select2, select_state
            if quest_auto.Possible_AnswerExplain ~= 'None' then
                if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
                    local agree = quest_auto.Possible_AnswerAgree
                    local cancel = quest_auto.Possible_AnswerCancel
                    
                    if agree == 'None' then
                        agree = nil
                    end
                    
                    if cancel == 'None' then
                        cancel = nil
                    end
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    select2 = ShowSelDlg(pc, 0 , dlg , questname, agree, quest_auto.Possible_AnswerExplain, cancel)
                    if select2 == 1 then
                        select_state = 'AGREE'
                    elseif select2 == 2 then
                        select_state = 'EXPLAIN'
                    else
                        select_state = 'CANCEL'
                    end
                else
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    ShowSelDlg(pc, 0 , dlg, quest_auto.Possible_AnswerExplain)
                    select_state = 'EXPLAIN'
                end
            else
                if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
                    local agree = quest_auto.Possible_AnswerAgree
                    local cancel = quest_auto.Possible_AnswerCancel
                    
                    if agree == 'None' then
                        agree = nil
                    end
                    
                    if cancel == 'None' then
                        cancel = nil
                    end
                    
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    select2 = ShowSelDlg(pc, 0 ,  dlg, questname, agree, cancel)
                    if select2 == 1 then
                        select_state = 'AGREE'
                    else
                        select_state = 'CANCEL'
                    end
                else
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_SelectDialog1, questname, 'Possible')
                    ShowOkDlg(pc, dlg,1)
                    select_state = 'AGREE'
                end
            end
            if select_state == 'AGREE' then
                SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questIES.ClassName, nil, nil, nil, quest_auto, nil, 'YES')
            elseif select_state == 'CANCEL' then
                return
            elseif select_state == 'EXPLAIN' then
                if quest_auto.Possible_AnswerAgree ~= 'None' or quest_auto.Possible_AnswerCancel ~= 'None' then
                    local agree = quest_auto.Possible_AnswerAgree
                    local cancel = quest_auto.Possible_AnswerCancel
                    
                    if agree == 'None' then
                        agree = nil
                    end
                    
                    if cancel == 'None' then
                        cancel = nil
                    end
                    
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, 'Possible')
                    local select3 = ShowSelDlg(pc, 0 ,  dlg, questname,  agree, cancel)
                
                    if select3 == 1 then
                        SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questIES.ClassName, nil, nil, nil, quest_auto, nil, 'YES')
                    else
                        return
                    end
                else
                    SCR_QUEST_POSSIBLE_AGREE(pc, questname, self, nil, selfname)
                    local dlg = SCR_QUEST_DLG_CHANGE(pc, quest_auto, quest_auto.Possible_ExplainDialog1, questname, 'Possible')
                    ShowOkDlg(pc, dlg,1)
                end
            end
        else
            SCR_QUEST_LINE(pc, self, quest_auto.Possible_SelectDialog1, nil, nil, questname, nil, 'Possible')
            SCR_QUEST_POSSIBLE_AGREE_DLG(pc, questIES.ClassName, nil, nil, nil, quest_auto, nil, 'YES')
        end
    end
    
end


function SCR_QUEST_DIALOGSAFE_BUFF_ADD(self, pc)
    if self ~= nil and IsBuffApplied(pc, 'DialogSafe') == 'NO' then
        AddBuff(pc, pc, 'DialogSafe', 1, 0, 0, 1)
    end
end


function SCR_PROCESSING_QUEST_LIST_NAME_CONCAT(pc)
    local processingQuestList = SCR_PROCESSING_QUEST_LIST(pc)
    local ret = ''
    if #processingQuestList > 0 then
        for i = 1, #processingQuestList do
            ret = ret..processingQuestList[i][2]..', '
        end
        
        ret = string.sub(ret,1, string.len(ret) - 2)
    end
    
    return ret
end

function SCR_PROCESSING_QUEST_LIST(pc)
    local processingQuestList = {}
    local cnt, qList, vList = GetQuestCheckStateList(pc);
	for i = 1, cnt do
		if vList[i] > 0 then
		    local questIES = GetClass('QuestProgressCheck',qList[i])
		    if questIES ~= nil then
		        processingQuestList[#processingQuestList + 1] = {}
    		    processingQuestList[#processingQuestList][1] = qList[i]
    		    processingQuestList[#processingQuestList][2] = questIES.Name
		    end
		end
	end
	
	return processingQuestList
end

function SCR_JOB_CHANGE_REWARD_COMPANION(pc, tx, questname, strList)
    local petName = strList[2]
    local petItem = strList[3]
    local retItemList = {}
    
    local list = GET_PET_LIST(pc)
	local flag = 0
	if list ~= nil and #list > 0 then
    	for i=1, #list do
    		local clsName, name, level = GET_PET_BY_INDEX(list, i)
    		if clsName == petName then
    		    flag = 1
    		    break
    		end
    	end
    end
	if flag == 0 then
    	local questID = GetClassNumber('QuestProgressCheck', questname, 'ClassID')
	    TxGiveItem(tx, petItem, 1, "Q_" .. questID)
	    retItemList[#retItemList + 1] = petItem
	end
	
	return retItemList
end
