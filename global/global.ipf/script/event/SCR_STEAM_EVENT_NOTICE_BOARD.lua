function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if IsBuffApplied(pc, 'Event_Steam_Secret_Market') == 'YES' then
        RemoveBuff(pc, 'Event_Steam_Secret_Market')
    end

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("EVENT_STEAM_COLONY_FIRST_VICTORY_MSG"), ScpArgMsg("Cancel"))
  

    if select == 1 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 2 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
    elseif select == 3 then
        local state = GetColonyWarState()
        if state ~= 2 then
            SCR_STEAM_COLONY_WAR_FIRST_VICTORY_REWARD(self, pc)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("CanNotActiveByColonyWarJoin"), 7)
        end
    end
end

function SCR_STEAM_TREASURE_EVENT_FEDIMIAN_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Event_Fedimian_1"), ScpArgMsg("Cancel"))   
    if select == 1 then
        SCR_EVENT171018_FEDIMIAN_RAID_DIALOG(self,pc)
    end
end