function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Steam_Event_Observer"), ScpArgMsg("Cancel"))
    
    if select == 1 then
        SCR_EV_OBSERVER_QUEST(self,pc)
    elseif select == 2 then
        SCR_EV_OBSERVER_QUEST(self,pc)
    end
end
