function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if IsBuffApplied(pc, 'Event_Steam_Secret_Market') == 'YES' then
        RemoveBuff(pc, 'Event_Steam_Secret_Market')
    end

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("EventShop"), ScpArgMsg("Cancel"))
  
    if select == 1 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 2 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
    elseif select == 3 then
        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP2_OPEN()")
    end
end

function SCR_STEAM_2018_TREASURE_EVENT_DIALOG(self,pc) -- 국내 수확 이벤트 함수명 바꿔서 사용 --
      -- SCR_STEAM_TREASURE_EVENT_DIALOG -- 검색 로그 남김 --
    if pc.Lv < 50 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1801_ORB_MSG8","LV",50), 10);
        return
    end
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Get_RedSeed"), ScpArgMsg("Cancel"))

    if select == 1 then
        local aobj = GetAccountObj(pc);
        local now_time = os.date('*t')
        local yday = now_time['yday']
        local hour = now_time['hour']
        local min = now_time['min']
        
        if aobj.THANKSGIVINGDAY_DAY ~= yday then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aobj, 'THANKSGIVINGDAY_DAY', yday)
            TxGiveItem(tx, 'Event_Seed_ThanksgivingDay', 1, "EVENT_THANKSGIVINGDAY_DAY")
            
            if aobj.Event_HiddenReward ~= 2 then
                TxGiveItem(tx, 'NECK99_102_team', 1, "EVENT_THANKSGIVINGDAY_DAY")
                TxSetIESProp(tx, aobj, 'Event_HiddenReward', 2)
            end
            local ret = TxCommit(tx);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg('EVENT_1705_CORSAIR_MSG4'),10)
        end
    end
end

function SCR_STEAM_TREASURE_EVENT_FEDIMIAN_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Event_Fedimian_1"), ScpArgMsg("Cancel"))   
    if select == 1 then
        SCR_EVENT171018_FEDIMIAN_RAID_DIALOG(self,pc)
    end
end