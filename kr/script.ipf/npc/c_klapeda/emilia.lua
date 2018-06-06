function SCR_EMILIA_DIALOG(self,pc,isQuest)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_EAST_PREPARE_SUCC(self)
    local select = ShowSelDlg(self, 0, 'Emilia_Select_1', ScpArgMsg('Auto_MiscShop'), ScpArgMsg('Auto_CashShop'), ScpArgMsg('Auto_JongLyo'))
     if select == 1 then
       ShowTradeDlg(self, 'Klapeda_Misc', 5);
    elseif select == 2 then
       --ShowTradeDlg(self, 'Klapeda_Cash', 5);

	   SendAddOnMsg(pc, "TP_SHOP_UI_OPEN", "", 0);
    end
    
    ShowOkDlg(self, 'EAST_PREPARE_COMP')
end

function SCR_EMILIA_NORMAL_1(self,pc)
	ShowTradeDlg(pc, 'Klapeda_Misc', 5);
end

--function SCR_EMILIA_NORMAL_2(self,pc)
--	EVENT_1705_SCHWARZEREITER_NPC(self,pc)
--end

function SCR_BASIC_CITY_WARP_OPEN(pc, tx, quest, propList)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if sObj[propList[2]] ~= 300 then
        TxSetIESProp(tx, sObj, propList[2], 300)
    end
end

function SCR_EMILIA_NORMAL_2_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step1 == 1 or sObj.Step2 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_EMILIA_NORMAL_2(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT1")
            if sObj.Step1 == 1 then
                if sObj.Goal1 == 0 then
                    local sel = ShowSelDlg(pc, 1, "CHAR220_MSETP2_1_1_DLG1", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        sObj.Goal1 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_1_DLG1_1", 1)
                        return
                    end
                elseif sObj.Goal1 == 1 then
                    local max_cnt = 80
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_1_1_ITEM2")
                    if cnt >= max_cnt then
                        sObj.Goal1 = 10
                        SaveSessionObject(pc, sObj)
                        local cnt_else = GetInvItemCount(pc, "CHAR220_MSTEP2_1_1_ITEM1")
                        if cnt_else > 0 then
                            RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_1_1_ITEM1", cnt_else, "CHAR220_MSTEP2_1_1");
                        end
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_1_1_ITEM2", cnt, "CHAR220_MSTEP2_1_1");
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_1_DLG3", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_1_DLG2", 1)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_1_1_DLG4", 1)
                end
            elseif sObj.Step2 == 1 then
                if sObj.Goal2 == 0 then
                    local sel = ShowSelDlg(pc, 1, "CHAR220_MSETP2_1_2_DLG1", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        sObj.Goal2 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_2_DLG1_1", 1)
                        return
                    end
                elseif sObj.Goal2 == 1 then
                    local max_cnt = 80
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_1_2_ITEM1")
                    if cnt >= max_cnt then
                        sObj.Goal2 = 10
                        SaveSessionObject(pc, sObj)
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_1_2_ITEM1", cnt, "CHAR220_MSTEP2_1_2");
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_2_DLG3", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_1_2_DLG2", 1)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_1_2_DLG4", 1)
                end
            end
        end
    end
end