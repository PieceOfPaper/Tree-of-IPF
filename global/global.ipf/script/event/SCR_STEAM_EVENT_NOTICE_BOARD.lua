function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Valentine2017_Select1"), ScpArgMsg("EVENT_STEAM_BEGINNER_SEL1"), ScpArgMsg("EVENT_STEAM_RETURN_SEL1"), ScpArgMsg("EVENT_STEAM_SETTLE_SEL1"), ScpArgMsg("Cancel")) 
    
    if select == 1 then
        SCR_EVENT_REWARD_5DAY_DIALOG(self,pc)
    elseif select == 2 then
        SCR_STEAM_BEGINNER_EVENT_DIALOG(self,pc)
    elseif select == 3 then
        SCR_STEAM_RETURN_EVENT_DIALOG(self,pc)
    elseif select == 4 then
        SCR_STEAM_SETTLE_EVENT_DIALOG(self,pc)
    end
end