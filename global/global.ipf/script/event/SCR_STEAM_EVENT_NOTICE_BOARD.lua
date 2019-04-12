function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    if pc.Lv < 50 then
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
                TxGiveItem(tx, 'NECK99_102', 1, "EVENT_THANKSGIVINGDAY_DAY")
                TxSetIESProp(tx, aobj, 'Event_HiddenReward', 2)
            end
            local ret = TxCommit(tx);
        end
    end
end