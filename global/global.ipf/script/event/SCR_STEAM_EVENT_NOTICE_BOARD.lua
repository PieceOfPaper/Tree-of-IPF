function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)

    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Steam_VerUP_Select01"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL5"), ScpArgMsg("EVENT_STEAM_BEGINNER_SEL1"), ScpArgMsg("EVENT_STEAM_RETURN_SEL1"), ScpArgMsg("EVENT_STEAM_SETTLE_SEL1"), ScpArgMsg("Cancel")) 
    local TeamLevel = GetTeamLevel(pc);

    if TeamLevel == 1 then
        local tx = TxBegin(pc)
    	TxSetIESProp(tx, aObj, 'EV171114_STEAM_NRU_JOIN_CHECK', 1);
    	local ret = TxCommit(tx)
    end
    
    if select == 1 then
        if sObj.EVENT_VALUE_SOBJ03 ~= 171212 and (pc.Lv <= 349 and pc.Lv >= 50) then
            local nextLv = 0
	        local nextlv_group = {330, 280, 235, 185, 135, 85, 45, 1}
	        for i = 1, table.getn(nextlv_group) do
        	    if pc.Lv >= nextlv_group[i] then
        	        nextLv = i + pc.Lv
        	        break
        	    end
        	end
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG1', 1)
            local tx = TxBegin(pc)
            TxAddIESProp(tx, sObj, 'EVENT_VALUE_SOBJ03', 171212);
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ01', nextLv)
            TxSetIESProp(tx, aObj, 'EVENT_WHITE_R1', 0)
            TxGiveItem(tx, 'LevelUp_Reward_EV', 10, 'Event_VerUP_Box');
            local ret = TxCommit(tx)
        elseif pc.Lv == 360 and aObj.EVENT_WHITE_R1 == 0 then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_WHITE_R1', 171212)
            TxGiveItem(tx, 'Premium_RankReset_60d', 1, 'Event_VerUP_Box2');
            local ret = TxCommit(tx)
        elseif sObj.EVENT_VALUE_SOBJ03 > 0 then
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG2', 1)
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("ICantLikeMe"), 5)
        end
    elseif select == 2 then
        SCR_BLUEORB_MONLVUP_DIALOG(self,pc)
    elseif select == 3 then
        SCR_STEAM_BEGINNER_EVENT_DIALOG(self,pc)
    elseif select == 4 then
        SCR_STEAM_RETURN_EVENT_DIALOG(self,pc)
    elseif select == 5 then
        SCR_STEAM_SETTLE_EVENT_DIALOG(self,pc)
    end
end