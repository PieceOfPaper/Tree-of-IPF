function SCR_NRU_ALWAYS_DIALOG(self,pc)
    if GetServerNation() ~= 'GLOBAL' then
      return
    end
    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local aObj = GetAccountObj(pc);
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_NRU_ALWAYS_3', ScpArgMsg("steam_Nru_Always_1"), ScpArgMsg("Auto_DaeHwa_JongLyo"))
    if select == 1 then
        if month >= 5 and day >= 9 and year >= 2017 then
            if aObj.EV170516_NRU_ALWAYS_AOBJ < 4 then
                if sObj.EV170516_NRU_ALWAYS_SOBJ == 0 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'Event_Nru_Always_Box_1', 1, 'EV170516_NRU');
                    TxSetIESProp(tx, aObj, 'EV170516_NRU_ALWAYS_AOBJ', aObj.EV170516_NRU_ALWAYS_AOBJ + 1);
                    TxSetIESProp(tx, sObj, 'EV170516_NRU_ALWAYS_SOBJ', sObj.EV170516_NRU_ALWAYS_SOBJ + 1);
                	local ret = TxCommit(tx)
                	SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("steam_Nru_Always_2", "NRUCOUNT", 4 - aObj.EV170516_NRU_ALWAYS_AOBJ), 5)    
                else
                    ShowOkDlg(pc,'NPC_EVENT_NRU_ALWAYS_1', 1)
                end
            else
                ShowOkDlg(pc,'NPC_EVENT_NRU_ALWAYS_2', 1)
            end
        else
            ShowOkDlg(pc,'NPC_EVENT_RETENTION_2', 1)
       end
    end 
end