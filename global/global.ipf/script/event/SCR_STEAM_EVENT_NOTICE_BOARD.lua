function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
--    if pc.Lv < 100 then
--        return
--    end
--    local aObj = GetAccountObj(pc);
--    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Prison_Select1"), ScpArgMsg("Prison_Select2", "COUNT", aObj.PlayTimeEventRewardCount), ScpArgMsg("Cancel"))
--    
--    EVENT_PROPERTY_RESET(pc, aObj, sObj)
--    
--    if select == 1 then
--        AUTOMATCH_INDUN_DIALOG(pc, nil, 'Indun_d_prison_62_1_event')
--    elseif select == 2 then
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
--    	end
--    end
end

function EVENT_PROPERTY_RESET(pc, aObj, sObj)
    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Prison' then -- 현재 진행중인 이벤트
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "Prison");
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 0);
        TxSetIESProp(tx, aObj, 'Event_HiddenReward', 0);
    	local ret = TxCommit(tx)
    end
end

function INIT_PRISON_EVENT_STAT(self)

	if IsDummyPC(self) == 1 then
		return;
	end

	AddBuff(self, self, 'Event_Penalty', 1, 0, 700000, 1);
end