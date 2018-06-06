-- fed_tool.lua

function SCR_FED_TOOL_DIALOG(self,pc,isQuest)
    local result = SCR_QUEST_CHECK(pc, 'REMAINS37_1_SQ_030') 
    if result == "PROGRESS" then
    
        local invent = GetInvItemCount(pc, 'REMAINS37_1_SQ_030_ITEM_3')
        if invent < 1 then
            ShowOkDlg(pc, "REMAINS37_1_SQ_030_PR")
            sleep(1000)
            ShowOkDlg(pc, "REMAINS37_1_SQ_030_PR_2")
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAINS37_1_SQ_030', 'QuestInfoValue1', 1, nil, "REMAINS37_1_SQ_030_ITEM_3/1")
        else
            ShowOkDlg(pc, "REMAINS37_1_SQ_030_PR_3")
        end
    
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_FED_TOOL_NORMAL_1(self,pc)
	ShowTradeDlg(pc, 'Fedimian_Misc', 5);
end

function SCR_FED_TOOL_NORMAL_2_PRE(pc)
    --PIED_PIPER_HIDDEN
    if IS_KOR_TEST_SERVER() then
        return 'NO'
    else
        local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
        if prop <= 100 then
            return 'YES'
        end
    end
end

function SCR_FED_TOOL_NORMAL_2(self, pc)
    --PIED_PIPER_HIDDEN
    if IS_KOR_TEST_SERVER() then
        return
    else
        local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char3_12')
        if is_unlock == "NO" then
            local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
            if prop < 10 then
                local sel1 = ShowSelDlg(pc, 1, "CHAR312_PRE_MSTEP1_DLG1", ScpArgMsg("CHAR312_PRE_MSTEP1_TXT1"), ScpArgMsg("CHAR312_PRE_MSTEP1_TXT3"))
                if sel1 == 1 then
                    local sel2 = ShowSelDlg(pc, 1, "CHAR312_PRE_MSTEP1_DLG2", ScpArgMsg("CHAR312_PRE_MSTEP1_TXT2"), ScpArgMsg("CHAR312_PRE_MSTEP1_TXT3"))
                    if sel2 == 1 then
                        local tx = TxBegin(pc)
                        if isHideNPC(pc, "CHAR312_PRE_MSTEP1_SOLDIER1") == "YES" then
                            TxUnHideNPC(tx, 'CHAR312_PRE_MSTEP1_SOLDIER1')
                        end
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_12', 10)
                            ShowOkDlg(pc, "CHAR312_PRE_MSTEP1_DLG3", 1)
                            sleep(500)
                            ShowBalloonText(pc, 'CHAR312_PRE_MSTEP1_DLG_START', 7)
                        else
                            return
                        end
        	        else
        	            ShowOkDlg(pc, "CHAR312_PRE_MSTEP1_DLG_CANCLE", 1)
        	        end
                else
                    ShowOkDlg(pc, "CHAR312_PRE_MSTEP1_DLG_CANCLE", 1)
                end
            else
                ShowOkDlg(pc, "CHAR312_PRE_MSTEP1_DLG4", 1)
                sleep(500)
                ShowBalloonText(pc, 'CHAR312_PRE_MSTEP1_DLG_START', 7)
            end
        else
            return
        end
    end

end

function SCR_BLACKSMITH_FEDIMIAN_DIALOG(self,pc,isQuest)
   COMMON_QUEST_HANDLER(self,pc);
end

function SCR_BLACKSMITH_FEDIMIAN_NORMAL_1(self,pc)
	FlushItemDurability(pc);
    SendAddOnMsg(pc, "OPEN_DLG_REPAIR", "", 0);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "repair140731")
end

function SCR_BLACKSMITH_FEDIMIAN_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Recipe', 5);
end

function SCR_BLACKSMITH_FEDIMIAN_NORMAL_3(self,pc)
    SendAddOnMsg(pc, "DO_OPEN_MANAGE_GEM_UI", "", 0);
end

function SCR_BLACKSMITH_FEDIMIAN_NORMAL_4(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 0, self);
end

function SCR_BLACKSMITH_FEDIMIAN_NORMAL_5(self,pc)
    UIOpenToPC(pc, 'itemdecompose', 1)
end



function SCR_MARKET_FEDIMIAN_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'FEDIMIAN_MARKET_SEL', ScpArgMsg('KLAPEDA_MARKET_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        ShowCustomDlg(pc, "market", 5);
        REGISTERR_LASTUIOPEN_POS_SERVER(pc,"market")
    end
end

function SCR_WAREHOUSE_FEDIMIAN_DIALOG(self, pc)
	WAREHOUSE_DIALOG_COMMON(self, pc, "WAREHOUSE_FEDIMIAN_DLG");
end

function SCR_FED_ACCESSORY_DIALOG(self,pc,isQuest)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FED_ACCESSORY_NORMAL_1(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Accessory', 1);
end

function SCR_FED_ACCESSORY_NORMAL_2(self,pc)
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_1_DLG1", 1)
    ShowBalloonText(pc, "CHAR119_MSTEP3_1_PC_DLG1", 5)
    if  sObj.Goal1 < 1 then
        sObj.Goal1 = 1
        SaveSessionObject(pc, sObj)
    end
end

function SCR_FED_ACCESSORY_NORMAL_2_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    local item = GetInvItemCount(pc, "HIDDEN_HOHEN_HORN_ITEM1")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step1 < 1 then
                if item < 6 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_FED_ACCESSORY_NORMAL_3(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19');
    local item = GetInvItemCount(pc, "HIDDEN_HOHEN_HORN_ITEM1")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_1_1_DLG1", 1)
    if sObj.Step1 < 1 then
        sObj.Step1 = 1
        sObj.Goal1 = 2
        SaveSessionObject(pc, sObj)
    end
    local tx = TxBegin(pc)
    TxTakeItem(tx, "HIDDEN_HOHEN_HORN_ITEM1", item, "Quest_HIDDEN_MATADOR")
    local ret = TxCommit(tx);
    if sObj.Step1 >= 1 and sObj.Step2 >= 1 and sObj.Step3 >= 1 and sObj.Step4 >= 1 then
        --print("sObj.Step1 : "..sObj.Step1)
        if hidden_prop == 20 then
            --print(hidden_prop)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 60)
        end
    end
end

function SCR_FED_ACCESSORY_NORMAL_3_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local item = GetInvItemCount(pc, "HIDDEN_HOHEN_HORN_ITEM1")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step1 < 1 then
                if item >= 6 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_FED_ACCESSORY_NORMAL_4(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_20');
    ShowOkDlg(pc, "CHAR120_MSTEP3_1_DLG1", 1)
    if hidden_prop == 30 then
        --print(hidden_prop)
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_20', 60)
    end
end

function SCR_FED_ACCESSORY_NORMAL_4_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_20')
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    --print(sObj, prop)
    --print("prop : "..prop, "sObj : "..sObj)
    if prop >= 30 then
        if sObj ~= nil then
            return "YES"
        else
            return "NO"
        end
    end
end

function SCR_WORLDPVP_START_DIALOG(self,pc)
    local lv = pc.Lv
    local aObj = GetAccountObj(pc);
    local sysTime = GetDBTime();
    local lastPlayDate = TryGetProp(aObj, "TeamBattle_LastPlayDate");
    
    if lastPlayDate ~= "None" then
        local date = imcTime.GetSysTimeByStr(lastPlayDate);
        local nextRewardableTime = imcTime.AddSec(date, 60 * 60 * 10);
        WORLDPVP_TIME_CHECK(pc)
        local Check = TryGetProp(aObj, "TeamBattleLeague_Reward_Check")
        
        if imcTime.IsLaterThan(nextRewardableTime, sysTime) == 1 and Check == 0 then
            local select = ShowSelDlg(pc, 0, 'TEAM_BATTLE_REQUEST1_dlg1', ScpArgMsg("PVPReward"), ScpArgMsg("Close"))
            if select == 1 then
                WORLDPVP_COUNT_CHECK(pc, aObj)
            elseif select == 2 then
                
            end
        else
            ShowOkDlg(pc, 'WORLDPVP_SELECT_MSG1', 1)
        end
    else  
        ShowOkDlg(pc, 'WORLDPVP_SELECT_MSG1', 1)
    end
            UIOpenToPC(pc, "worldpvp", 1)
end

function WORLDPVP_COUNT_CHECK(pc, aObj)
    local tx = TxBegin(pc)
    TxSetIESProp(tx, aObj, "TeamBattleLeague_Reward_Check", 1)
    TxGiveItem(tx, "Team_Battle_Basic", 1, "TEAMBATTLE_DAILY_REWARD_CUBE")
    local ret = TxCommit(tx)
end

function WORLDPVP_TIME_CHECK(pc)
    local aObj = GetAccountObj(pc);
    local sysTime = GetDBTime();
    local lastPlayDate = TryGetProp(aObj, "TeamBattle_LastPlayDate");
    if lastPlayDate ~= "None" then
        local date = imcTime.GetSysTimeByStr(lastPlayDate);
        local nextRewardableTime = imcTime.AddSec(date, 60 * 60 * 10);
        if imcTime.IsLaterThan(nextRewardableTime, sysTime) == 0 then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, "TeamBattleLeague_Reward_Check", 0)
            local ret = TxCommit(tx)
        end
    end
end

function SCR_FEDIMIAN_APPRAISER_DIALOG(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13')
    if hidden_prop == 270 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM8') == 1 then
            local sel = ShowSelDlg(pc, 0, 'CHAR313_MSTEP13_1_DLG3', ScpArgMsg('CHAR313_MSTEP13_1_MSG1'), ScpArgMsg('Appraisal'))
            if sel == 1 then
                ShowOkDlg(pc, "CHAR313_MSTEP13_1_DLG1", 1)
                UIOpenToPC(pc,'fullblack',1)
                sleep(1000)
                UnHideNPC(pc, "FEDIMIAN_APPRAISER_NPC")
                HideNPC(pc, "FEDIMIAN_APPRAISER")
                UIOpenToPC(pc,'fullblack',0)
                return;
            elseif sel == 2 then
            	local NpcHandle = GetHandle(self);
        		SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
        		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
                ShowCustomDlg(pc, 'appraisal', 5);
                
        	    DelExProp(pc, "APPRAISER_HANDLE");
            end
        end
    elseif hidden_prop < 270 then
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_FEDIMIAN_APPRAISER_NPC_DIALOG(self, pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char3_13');
    if is_unlock == 'YES' then
    	COMMON_QUEST_HANDLER(self,pc)
    elseif IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    else
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13')
        if hidden_prop == 270 then
            if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM8') >= 1 then
                ShowOkDlg(pc, 'CHAR313_MSTEP13_1_DLG2', 1)
                local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
                if sObj ~= nil then
                    DestroySessionObject(pc, sObj)
                end
                local tx1 = TxBegin(pc);
                local appraiser_item = {
                                        'KLAIPE_CHAR313_ITEM1',
                                        'R_KLAIPE_CHAR313_ITEM2',
                                        'KLAIPE_CHAR313_ITEM2',
                                        'KLAIPE_CHAR313_ITEM3',
                                        'KLAIPE_CHAR313_ITEM4',
                                        'KLAIPE_CHAR313_ITEM5',
                                        'KLAIPE_CHAR313_ITEM6',
                                        'KLAIPE_CHAR313_ITEM7',
                                        'KLAIPE_CHAR313_ITEM8'
                                    }
                for i = 1, #appraiser_item do
                    if GetInvItemCount(pc, appraiser_item[i]) >= 1 then
                        TxTakeItem(tx1, appraiser_item[i], GetInvItemCount(pc, appraiser_item[i]), 'HIDDEN_APPRAISER_MSTEP13_1');
                    end
                end
                local ret = TxCommit(tx1);
                if ret == "SUCCESS" then
                    local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char3_13')
                    if ret2 == "FAIL" then
                        print("tx FAIL!")
                    end
                else
                    print("tx FAIL!")
                end
            end
        elseif hidden_prop < 270 then
            COMMON_QUEST_HANDLER(self,pc)
        end
    end
end

function SCR_FEDIMIAN_APPRAISER_NPC_NORMAL_1(self,pc)
--	local select = ShowSelDlg(pc, 0, 'FEDIMIAN_APPRAISER_NPC_DLG2', ScpArgMsg('Appraisal'), ScpArgMsg('Close'))
--    if select == 1 then
--	local NpcHandle = GetHandle(self);
--		SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
--		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
--        ShowCustomDlg(pc, 'appraisal', 5);
--	end
	local NpcHandle = GetHandle(self);
	SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
    ShowCustomDlg(pc, 'appraisal', 5);
	DelExProp(pc, "APPRAISER_HANDLE");
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 50 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
            return 'YES'
	    end
    end
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_4_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 100 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM6') == 1 then
            return 'YES'
	    end
    end
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_1(self,pc)
    
--	local select = ShowSelDlg(pc, 0, 'FEDIMIAN_APPRAISER_DLG2', ScpArgMsg('Appraisal'), ScpArgMsg('Close'))
--    if select == 1 then
--	local NpcHandle = GetHandle(self);
--		SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
--		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
--        ShowCustomDlg(pc, 'appraisal', 5);
--	end
    
    local NpcHandle = GetHandle(self);
	SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
    ShowCustomDlg(pc, 'appraisal', 5);
	DelExProp(pc, "APPRAISER_HANDLE");
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_2(self,pc)
    -- 재감정
    
    UIOpenToPC(pc, 'itemrandomreset', 1)
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_3(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    ShowOkDlg(pc, "CHAR313_MSTEP6_1_DLG1", 1)
    PlayAnimLocal(self, pc, "LOOK", 1)
    sleep(1200)
    PlayAnimLocal(self, pc, "STD", 1)
    ShowOkDlg(pc, "CHAR313_MSTEP6_1_DLG2", 1)
    if hidden_prop == 50 then
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 60)
    end
end

function SCR_FEDIMIAN_APPRAISER_NORMAL_4(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    ShowOkDlg(pc, "CHAR313_MSTEP10_1_DLG1", 1)
    PlayAnimLocal(self, pc, "LOOK", 1)
    sleep(1000)
    PlayAnimLocal(self, pc, "STD", 1)
    ShowOkDlg(pc, "CHAR313_MSTEP10_1_DLG2", 1)
    UIOpenToPC(pc,'fullblack',1)
    sleep(1000)
    UIOpenToPC(pc,'fullblack',0)
    ShowOkDlg(pc, "CHAR313_MSTEP10_1_DLG3", 1)
    if hidden_prop == 100 then
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 200)
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM6') >= 1 and GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM7') == 0 then
            local tx1 = TxBegin(pc);
            TxTakeItem(tx1, "KLAIPE_CHAR313_ITEM6", 1, "Quest_HIDDEN_APPRAISER");
            TxTakeItem(tx1, "KLAIPE_CHAR313_ITEM1", 1, "Quest_HIDDEN_APPRAISER");
            TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM9", 1, "Quest_HIDDEN_APPRAISER");
            TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM7", 1, "Quest_HIDDEN_APPRAISER");
            local ret = TxCommit(tx1);
        end
    end
end


--function SCR_FEDIMIAN_APPRAISER_NORMAL_5(self,pc)
--    ShowTradeDlg(pc, 'Master_Appraiser', 5);
--end

--function SCR_FEDIMIAN_APPRAISER_NORMAL_5(self,pc)
--    UIOpenToPC(pc, 'itemrandomreset', 1)
--end

function SCR_TUTO_APPRAISE_NPC_ENTER(self, pc)
	if 1 == IsDummyPC(pc) then
		return;
	end

--    AddHelpByName(pc, "TUTO_ITEM_APPRAISE")
end


function JOB_APPRAISER51_ABBADON(self)
    local item_cnt1 = GetInvItemCount(self, "JOB_APPRAISER5_1_ITEM1")
    local item_cnt2 = GetInvItemCount(self, "JOB_APPRAISER5_1_ITEM2")
    if item_cnt1 >= 1 or item_cnt2 >= 1 then
        RunZombieScript('GIVE_TAKE_ITEM_TX', self, nil,"JOB_APPRAISER5_1_ITEM1/"..item_cnt1.."/JOB_APPRAISER5_1_ITEM2/"..item_cnt2, "Quest")
    end
end

function JOB_APPRAISER52_ABBADON(self)
    local item_cnt1 = GetInvItemCount(self, "JOB_APPRAISER5_1_ITEM1")
    local item_cnt2 = GetInvItemCount(self, "JOB_APPRAISER5_1_ITEM2")
    local temp1 = 0
    local temp2 = 0
    
    
    if item_cnt1 < 1 then
        temp1 = 1
    end
    if item_cnt2 < 1 then
        temp2 = 1
    end
    if item_cnt1 < 1 or item_cnt2 < 1 then
        RunZombieScript('GIVE_TAKE_ITEM_TX', self, "JOB_APPRAISER5_1_ITEM1/"..temp1.."/JOB_APPRAISER5_1_ITEM2/"..temp2,nil, "Quest")
    end
end


function SCR_FEDIMIAN_TERIAVELIS_ENTER(self, pc)
    local levelCheck = pc.Lv
    if levelCheck >= 360 then
        AddHelpByName(pc, 'TUTO_ICOR')
    end
end




function SCR_FEDIMIAN_TERIAVELIS_DIALOG(self, pc)
     COMMON_QUEST_HANDLER(self, pc)
--     local TeriavelisSelect = ShowSelDlg(pc, 0, 'NPC_TERIAVELIS_DLG1', ScpArgMsg("LegendRecipe"),ScpArgMsg("itemoptionextract"),ScpArgMsg("itemoptionadd"),ScpArgMsg("legenditemtranscend"), ScpArgMsg("Close"))
--
--    if TeriavelisSelect == 1 then
--        SHOW_ITEM_TRANCEND_UI(pc, 'legend_craft', 5, 1, self);
--    elseif TeriavelisSelect == 2 then
--        UIOpenToPC(pc,'itemoptionextract',1)
--    elseif TeriavelisSelect == 3 then
--        UIOpenToPC(pc,'itemoptionadd',1)
--    elseif TeriavelisSelect == 4 then
--        SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 1, self);
--    end
     
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_1(self,pc)
    ShowTradeDlg(pc, 'Teliavelis', 5);
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_2(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'legend_craft', 5, 1, self);
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_3(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemoptionextract', 5, 1, self);
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_4(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemoptionadd', 5, 1, self);
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_5(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 1, self);
end

function SCR_FEDIMIAN_TERIAVELIS_NORMAL_6(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 1, self);
end
