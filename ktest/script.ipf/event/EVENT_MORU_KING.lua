function SCR_NPC_GOSTOPGIRL_DIALOG(self, pc)
    local get_item = GetInvItemList(pc);
    local someitem = get_item 
    local aObj = GetAccountObj(pc); 
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_2', ScpArgMsg("ShopBuy"), ScpArgMsg("Moru_King_Select_1"), ScpArgMsg("Moru_King_Select_2"), ScpArgMsg("Auto_DaeHwa_JongLyo"))
    if select == 1 then
        ShowTradeDlg(pc, "Event_Shop_Moru", 5)
    elseif select ==2 then
        if aObj.EV170530_MORU_KING == yday then
            ShowOkDlg(pc, 'NPC_EVENT_MORUKING_1', 1)
            return
        else
            local tx = TxBegin(pc) 
            TxGiveItem(tx, 'E_Artefact_631001', 1, "MORU_KING_EVENT")
            TxSetIESProp(tx, aObj, 'EV170530_MORU_KING', yday)  
            TxGiveItem(tx, 'Event_drug_steam_team', 2, "MORU_KING_EVENT")
            local ret = TxCommit(tx)
            ShowOkDlg(pc, 'NPC_EVENT_MORUKING_6', 1)
        end
    elseif select == 3 then
        local select2 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_3', ScpArgMsg("Moru_King_Select_3"), ScpArgMsg("Moru_King_Select_4"), ScpArgMsg("Moru_King_Select_5"), ScpArgMsg("Moru_King_Select_6"), ScpArgMsg("Moru_King_Select_7"))
        if select2 == 1 then
	        local flag = 0
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 8 and someitem.Reinforce_2 < 10 then
                    flag = 1
                    local select3 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_1\\'..ScpArgMsg("EVENT_1712_MORUKING_MSG1","COUNT",someitem.Reinforce_2,"PR",someitem.PR), ScpArgMsg("EVENT_1712_MORUKING_MSG2"), ScpArgMsg("EVENT_1712_MORUKING_MSG3"))
                    if select3 == 1 then
                        local tx = TxBegin(pc) 
                        TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
    --                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                            return
                        end
                    end
                end 
            end
            if flag == 0 then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end
        elseif select2 == 2 then
	        local flag = 0
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 10 and someitem.Reinforce_2 < 15 then
                    flag = 1
                    local select3 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_1\\'..ScpArgMsg("EVENT_1712_MORUKING_MSG1","COUNT",someitem.Reinforce_2,"PR",someitem.PR), ScpArgMsg("EVENT_1712_MORUKING_MSG2"), ScpArgMsg("EVENT_1712_MORUKING_MSG3"))
                    if select3 == 1 then
                        local tx = TxBegin(pc) 
                        TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
    --                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")  
                        
                        TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
    --                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                            return
                        end
                    end
                end 
            end
            if flag == 0 then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end
        elseif select2 == 3 then
	        local flag = 0
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 15 and someitem.Reinforce_2 < 20 then
                    flag = 1
                    local select3 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_1\\'..ScpArgMsg("EVENT_1712_MORUKING_MSG1","COUNT",someitem.Reinforce_2,"PR",someitem.PR), ScpArgMsg("EVENT_1712_MORUKING_MSG2"), ScpArgMsg("EVENT_1712_MORUKING_MSG3"))
                    if select3 == 1 then
                        local tx = TxBegin(pc) 
                        TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
    --                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Gold_14d', 1, "MORU_KING_EVENT")  
                        
                        TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
                        TxGiveItem(tx, 'misc_BlessedStone', 3, 'MORU_KING_EVENT');
                        
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
    --                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                            return
                        end
                    end
                end 
            end
            if flag == 0 then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end
        elseif select2 == 4 then
	        local flag = 0
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 20 and someitem.Reinforce_2 < 25 then
                    flag = 1
                    local select3 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_1\\'..ScpArgMsg("EVENT_1712_MORUKING_MSG1","COUNT",someitem.Reinforce_2,"PR",someitem.PR), ScpArgMsg("EVENT_1712_MORUKING_MSG2"), ScpArgMsg("EVENT_1712_MORUKING_MSG3"))
                    if select3 == 1 then
                        local tx = TxBegin(pc) 
                        TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
    --                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Gold_14d', 1, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Silver', 1, "MORU_KING_EVENT")  
                        
                        TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
                        TxGiveItem(tx, 'Premium_item_transcendence_Stone', 2, 'MORU_KING_EVENT');
                        
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
    --                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                            return
                        end
                    end
                end 
            end
            if flag == 0 then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end
        elseif select2 == 5 then
	        local flag = 0
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 25 then
                    flag = 1
                    local select3 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_1\\'..ScpArgMsg("EVENT_1712_MORUKING_MSG1","COUNT",someitem.Reinforce_2,"PR",someitem.PR), ScpArgMsg("EVENT_1712_MORUKING_MSG2"), ScpArgMsg("EVENT_1712_MORUKING_MSG3"))
                    if select3 == 1 then
                        local tx = TxBegin(pc) 
                        TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
    --                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Event160929_14d', 3, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Gold_14d', 3, "MORU_KING_EVENT")
                        TxGiveItem(tx, 'Moru_Silver', 3, "MORU_KING_EVENT")
                        
                        TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
                        TxGiveItem(tx, 'Premium_item_transcendence_Stone', 5, 'MORU_KING_EVENT');
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
    --                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                            return
                        end
                    end
                end 
            end
            if flag == 0 then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end
        end     
    end
end

function SCR_BUFF_ENTER_Event_Moru_King(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Event_Moru_King(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Event_Moru_King(self, buff, arg1, arg2, over)
end