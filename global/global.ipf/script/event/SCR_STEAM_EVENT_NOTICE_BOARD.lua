function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if serverID == 1001 or serverID == 1004 then
        select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_COOPERATION_DLG4"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("EVENT_COOPERATION_DLG3"))
    else
        select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_COOPERATION_DLG4"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"))
    end

    if select == 2 then
        SCR_GUILD_ATTENDANCE_DIALOG(self, pc)
    elseif select == 3 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 4 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
    elseif select == 5 then
        SCR_EVENT_COOPERRATION_DIALOG(self, pc)
    end
end