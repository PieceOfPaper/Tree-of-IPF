function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_NUMBER_DESC1', ScpArgMsg("Yes"), ScpArgMsg("No"))

    if select == 1 then
        SCR_EV_NUMBER_QUEST(self,pc)
    end
end