function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)

    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')

    if sObj.CHRISTMAS_ARTEFACT_30D == 0 then
        local tx = TxBegin(pc)
    	TxSetIESProp(tx, sObj, 'CHRISTMAS_ARTEFACT_30D', 1);
    	TxGiveItem(tx, 'Artefact_630020_30d', 1, "EVNET_CHRISTMAS_Artefact30d");
    	TxGiveItem(tx, 'Artefact_630021_30d', 1, "EVNET_CHRISTMAS_Artefact30d");
    	local ret = TxCommit(tx)
    end

    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Steam_VerUP_Select01"), ScpArgMsg("EVENT_JUMP_MISSION_1"), ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL1"), ScpArgMsg("EVENT_STEAM_BEGINNER_SEL1"), ScpArgMsg("EVENT_STEAM_RETURN_SEL1"), ScpArgMsg("EVENT_STEAM_SETTLE_SEL1"), ScpArgMsg("Cancel")) 
    
    if select == 1 then
        if aObj.EVENT_WHITE_R1 ~= 171212 then -- reset
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_WHITE_R1', 171212)
            TxSetIESProp(tx, aObj, 'EVENT_WHITE_R2', 0)
            local ret = TxCommit(tx)
        end

        if sObj.EVENT_VALUE_SOBJ03 ~= 171212 and (pc.Lv <= 350 and pc.Lv >= 50) then
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
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ03', 171212);
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ02', 0)
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ01', nextLv)
            TxGiveItem(tx, 'LevelUp_Reward_EV', 10, 'Event_VerUP_Box');
            local ret = TxCommit(tx)
        elseif pc.Lv == 360 and aObj.EVENT_WHITE_R2 == 0 then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_WHITE_R2', 171212)
            TxGiveItem(tx, 'Premium_RankReset_60d', 1, 'Event_VerUP_Box2');
            local ret = TxCommit(tx)
        elseif sObj.EVENT_VALUE_SOBJ03 > 0 then
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG2', 1)
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("ICantLikeMe"), 5)
        end
    elseif select == 2 then
        SCR_EVENT_JUMP_MISSION_DIALOG(self, pc)
    elseif select == 3 then
        SCR_EVENT_STEAM_CHRISTMAS_DIALOG(self, pc)
    elseif select == 4 then
        SCR_STEAM_BEGINNER_EVENT_DIALOG(self,pc)
    elseif select == 5 then
        SCR_STEAM_RETURN_EVENT_DIALOG(self,pc)
    elseif select == 6 then
        SCR_STEAM_SETTLE_EVENT_DIALOG(self,pc)
    end
end