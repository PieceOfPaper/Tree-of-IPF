function SCR_NPC_GOSTOPGIRL_DIALOG(self, pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local get_item = GetInvItemList(pc);
    local someitem = get_item 
    local aObj = GetAccountObj(pc); 
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local Neck = GetInvItemCount(pc, "E_Artefact_631001")
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_2', ScpArgMsg("ShopBuy"), ScpArgMsg("Moru_King_Select_1"), ScpArgMsg("Moru_King_Select_2"), ScpArgMsg("Auto_DaeHwa_JongLyo"))
    if select == 1 then
        ShowTradeDlg(pc, "Event_Shop_Moru", 5)
    elseif select ==2 then
        if aObj.EV170530_MORU_KING == yday or Neck >= 1 then
            ShowOkDlg(pc, 'NPC_EVENT_MORUKING_1', 1)
            return
        else
            local tx = TxBegin(pc) 
            TxGiveItem(tx, 'E_Artefact_631001', 1, "MORU_KING_EVENT")
            TxSetIESProp(tx, aObj, 'EV170530_MORU_KING', yday)  
            local ret = TxCommit(tx)
            ShowOkDlg(pc, 'NPC_EVENT_MORUKING_6', 1)
        end
    elseif select == 3 then
        local select2 = ShowSelDlg(pc, 0, 'NPC_EVENT_MORUKING_3', ScpArgMsg("Moru_King_Select_3"), ScpArgMsg("Moru_King_Select_4"), ScpArgMsg("Moru_King_Select_5"), ScpArgMsg("Moru_King_Select_6"), ScpArgMsg("Moru_King_Select_7"))
        if select2 == 1 then
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 8 and someitem.Reinforce_2 < 10 then
                    local tx = TxBegin(pc) 
                    TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")  
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                        return
                    end
                end 
            end
            if someitem.ClassID ~= 635122 or (someitem.ClassID == 635122 and someitem.Reinforce_2 < 8 and someitem.Reinforce_2 > 10) then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end          
        elseif select2 == 2 then
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 10 and someitem.Reinforce_2 < 15 then
                    local tx = TxBegin(pc) 
                    TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")  
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                        return
                    end
                end 
            end
            if someitem.ClassID ~= 635122 or (someitem.ClassID == 635122 and someitem.Reinforce_2 < 10 and someitem.Reinforce_2 > 15) then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end          
        elseif select2 == 3 then
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 15 and someitem.Reinforce_2 < 20 then
                    local tx = TxBegin(pc) 
                    TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Gold_14d', 1, "MORU_KING_EVENT")  
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                        return
                    end
                end 
            end
            if someitem.ClassID ~= 635122 or (someitem.ClassID == 635122 and someitem.Reinforce_2 < 15 and someitem.Reinforce_2 > 20) then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end          
        elseif select2 == 4 then
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 20 and someitem.Reinforce_2 < 25 then
                    local tx = TxBegin(pc) 
                    TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Gold_14d', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Silver', 1, "MORU_KING_EVENT")  
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                        return
                    end
                end 
            end
            if someitem.ClassID ~= 635122 or (someitem.ClassID == 635122 and someitem.Reinforce_2 < 20 and someitem.Reinforce_2 > 25) then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end          
        elseif select2 == 5 then
            for i = 1 , table.getn(get_item) do
		        local someitem = get_item[i];
                if someitem.ClassID == 635122 and someitem.Reinforce_2 >= 25 then
                    local tx = TxBegin(pc) 
                    TxTakeItemByObject(tx, someitem, 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Drug_Fortunecookie', 5, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Event160929_14d', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Gold_14d', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Silver', 1, "MORU_KING_EVENT")
                    TxGiveItem(tx, 'Moru_Diamond_14d', 1, "MORU_KING_EVENT")  
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        AddBuff(self, pc, 'Event_Moru_King', 1, 0, 3600000, 1);
                        return
                    end
                end 
            end
            if someitem.ClassID ~= 635122 or (someitem.ClassID == 635122 and someitem.Reinforce_2 < 25) then
                ShowOkDlg(pc, 'NPC_EVENT_MORUKING_5', 1)        
            end          
        end     
    end
end