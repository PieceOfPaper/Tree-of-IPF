function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if IsBuffApplied(pc, 'Event_Steam_Secret_Market') == 'YES' then
        RemoveBuff(pc, 'Event_Steam_Secret_Market')
    end

    if serverID == 1001 then
        select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Cancel"), ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL3"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("EVENT_STEAM_COLONY_FIRST_VICTORY_MSG"))
    else
        select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Cancel"), ScpArgMsg("NPC_EVENT_MAGAZINE_NUM1_SEL3"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"))
    end
   
    if select == 2 then
        SCR_EVNET_MAGAZINE_NUM1_NPC_DIALOG(self, pc)
    elseif select == 3 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 4 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
    elseif select == 5 then
        SCR_STEAM_COLONY_WAR_FIRST_VICTORY_REWARD(self, pc)
    end
end