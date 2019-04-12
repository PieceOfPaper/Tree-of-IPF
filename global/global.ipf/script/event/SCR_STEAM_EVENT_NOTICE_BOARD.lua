function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
--    if pc.Lv < 100 then
--        ShowOkDlg(pc, 'EV_PRISON_DESC2', 1)
--        return
--    end
--    local aObj = GetAccountObj(pc);
--    
--    EVENT_PROPERTY_RESET(pc, aObj, sObj)
--    
--    if pc.MHP - pc.HP > 0 then
--        AddHP(pc, pc.MHP - pc.HP);
--    end
--    
--    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Prison_Select1"), ScpArgMsg("Prison_Select3"), ScpArgMsg("Prison_Select2", "COUNT", aObj.PlayTimeEventRewardCount), ScpArgMsg("Cancel"))
--    
--    if select == 1 then
--        AUTOMATCH_INDUN_DIALOG(pc, nil, 'Indun_d_prison_62_1_event')
--    elseif select == 2 then
--        AUTOMATCH_INDUN_DIALOG(pc, nil, 'Indun_d_prison_event_easy')
--    elseif select == 3 then
--        if aObj.PlayTimeEventRewardCount >= 10 and aObj.Event_HiddenReward == 0 then
--            local tx = TxBegin(pc)
--            TxAddIESProp(tx, aObj, 'Event_HiddenReward', 1);
--            TxGiveItem(tx, 'Premium_Enchantchip14', 3, 'Prison_Event');
--        	local ret = TxCommit(tx)
--        elseif aObj.PlayTimeEventRewardCount >= 20 and aObj.Event_HiddenReward == 1 then
--            local tx = TxBegin(pc)
--            TxAddIESProp(tx, aObj, 'Event_HiddenReward', 1);
--            TxGiveItem(tx, 'Hat_628290', 1, 'Prison_Event');
--        	local ret = TxCommit(tx)
--        else
--            ShowOkDlg(pc, 'EV_PRISON_DESC1')
--    	end
--    end
end

function EVENT_PROPERTY_RESET(pc, aObj, sObj)
    local etcObj = GetETCObject(pc);
    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Prison' then -- 현재 진행중인 이벤트
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "Prison");
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 0);
        TxSetIESProp(tx, aObj, 'Event_HiddenReward', 0);
        TxSetIESProp(tx, etcObj, 'InDunCountType_900', 0);
    	local ret = TxCommit(tx)
    	print(ret)
    end
end