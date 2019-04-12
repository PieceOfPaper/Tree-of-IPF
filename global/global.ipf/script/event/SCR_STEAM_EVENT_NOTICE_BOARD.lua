function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local serverID = GetServerGroupID()
    local select = 0;

    if IsBuffApplied(pc, 'Event_Steam_Secret_Market') == 'YES' then
        RemoveBuff(pc, 'Event_Steam_Secret_Market')
    end

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("EVENT_STEAM_2018REWARD_DLG1"), ScpArgMsg("EVENT_STEAM_2018REWARD_DLG2"), ScpArgMsg("Cancel"))
  
    if select == 1 then
        SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc)
    elseif select == 2 then
        SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc)
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

function SCR_STEAM_TREASURE_EVENT_1902_WEEKEND_DIALOG(self, pc) -- 버전업 기년 특별 접속 보상 이벤트 해외 전용 보상용 NPC -- 
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']
    local dayCheckReward = {
        {13, 'Ability_Point_Stone_1000_14d_Team', 5},
        {14, 'EVENT_190124_RankReset_Point_Lv2', 1},
        {15, 'Moru_Gold_14d_Team', 2},
        {16, 'EVENT_1902_NEWYEAR_FORTUNEPOUCH', 1},
        {17, 'EVENT_1902_NEWYEAR_FORTUNEPOUCH', 1}
    }
    --print(day)
    ShowOkDlg(pc, 'STEAM_TREASURE_EVENT_1902_WEEKEND_NPC_DLG1', 1)
    if aObj.STEAM_TREASURE_EVENT_1902_WEEKEND ~= day then
        for i = 1, #dayCheckReward do
            local tx = TxBegin(pc);
            local result = i
             --print(result)
            if dayCheckReward[result][1] == day then
                for j = 2, #dayCheckReward[result], 2 do
                    --print(j)
                    --print(dayCheckReward[result][j]..'/'..dayCheckReward[result][j+1])
                    TxSetIESProp(tx, aObj, 'STEAM_TREASURE_EVENT_1902_WEEKEND', day)
                    TxGiveItem(tx, dayCheckReward[result][j], dayCheckReward[result][j+1], "STEAM_TREASURE_EVENT_1902_WEEKEND")
                end
            end
            local ret = TxCommit(tx);
            --print(aObj.STEAM_TREASURE_EVENT_1902_WEEKEND)
        end
    else
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("UNDER301_EVENT1_REWARD_TAKE"), 5); -- 이미 보상을 받았습니다. -- 
    end
end