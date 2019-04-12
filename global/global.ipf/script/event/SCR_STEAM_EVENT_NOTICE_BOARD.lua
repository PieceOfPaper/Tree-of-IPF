function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("EVENT_STEAM_LAST_WINTER_SEL1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("Cancel")) 
    
    if select == 1 then
        SCR_EV180220_LAST_WINTER_DIALOG(self, pc)
    elseif select == 2 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 3 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
    end
end