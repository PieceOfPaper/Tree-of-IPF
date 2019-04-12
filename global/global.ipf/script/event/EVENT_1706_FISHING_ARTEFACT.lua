function SCR_EVENT_1706_FISHING_ARTEFACT_DIALOG(self,pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local fishing = GetInvItemCount(pc, "Silver_Fish")
    local select = ShowSelDlg(pc, 0, 'EVENT_1706_FISHING_ARTEFACT_DLG1', ScpArgMsg("Event_Steam_fishing_1"), ScpArgMsg("Auto_DaeHwa_JongLyo"))
    if select == 1 then
        if fishing >= 3 then
            local tx = TxBegin(pc)
            TxTakeItem(tx, 'Silver_Fish', 3, 'Steam_Fishing_Event_2');
            local ret = TxCommit(tx)
            if ret == "SUCCESS" then
                AddBuff(self, pc, 'Event_Steam_Fishing_1', 1, 0, 3600000, 1);
                return
            end
        else
            ShowOkDlg(pc, 'NPC_EVENT_STEAM_FISHING_1', 1)
            return    
        end
    end              
end
