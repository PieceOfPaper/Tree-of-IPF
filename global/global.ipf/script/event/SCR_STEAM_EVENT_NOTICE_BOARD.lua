function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)

    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("EVENT_SURVIVAL_NAME"), ScpArgMsg("Event_Nru2_Guide_1"), ScpArgMsg("Event_CB_1"), ScpArgMsg("Event_Today_Number_1"), ScpArgMsg("Cancel")) 
    local TeamLevel = GetTeamLevel(pc);

    if TeamLevel == 1 then
        local tx = TxBegin(pc)
    	TxSetIESProp(tx, aObj, 'EV171114_STEAM_NRU_JOIN_CHECK', 1);
    	local ret = TxCommit(tx)
    end
    
    if select == 1 then
        SCR_CURSE_DOOR_DIALOG(self,pc) 
    elseif select == 2 then
        SCR_EVENT_NRU2_315GUIDE_DIALOG(self,pc)
    elseif select == 3 then
        SCR_EVENT_CB_DIALOG(self,pc)
    elseif select == 4 then
        SCR_EV171017_STEAM_REWARD_DIALOG(self, pc)
    end
end

function EVENT_PROPERTY_RESET(pc, aObj, sObj)
    local now_time = os.date('*t')
    local yday = now_time['yday']
    
--    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Pet_Event' then -- 현재 진행중인 이벤트
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "Pet_Event");
--        TxSetIESProp(tx, aObj, 'EVENT_VALEN_R1', 0);
--    	local ret = TxCommit(tx)
--    end
    
    if aObj.DAYCHECK_EVENT_PLAYMIN ~= yday then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_PLAYMIN', yday);
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 0);
    	local ret = TxCommit(tx)
    end
end

function EVENT_LVUP_13094(self,pc)
    local aObj = GetAccountObj(pc);
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    if pc.Lv < 50 then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("NeedMorePcLevel"), 5)
        return
    end
    
    local select = 0
    
    if sObj.EVENT_VALUE_SOBJ01 ~= 0 then
        select = ShowSelDlg(pc, 0, 'NPC_EVENT_VERUP_DLG6', ScpArgMsg("Auto_DaeHwa_JongLyo"), ScpArgMsg("steam_OneYear_1"), ScpArgMsg("Steam_VerUP_Select01"), ScpArgMsg("Steam_VerUP_Select02"), ScpArgMsg("Steam_VerUP_Select03"))
    else
        select = ShowSelDlg(pc, 0, 'NPC_EVENT_VERUP_DLG6', ScpArgMsg("Auto_DaeHwa_JongLyo"), ScpArgMsg("steam_OneYear_1"), ScpArgMsg("Steam_VerUP_Select01"), ScpArgMsg("Steam_VerUP_Select02"))
    end
    
    if select == 2 then
        if GetServerNation() ~= 'GLOBAL' then
            return
        end
        local now_time = os.date('*t')
        local yday = now_time['yday']
        if 87 == yday then
            if sObj.EVENT_VALUE_SOBJ07 == 0 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'Event_Fire_Songpyeon', 3, 'Event_1year');
                TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ07', 1)
                local ret = TxCommit(tx)
            elseif sObj.EVENT_VALUE_SOBJ07 > 0 then
                ShowOkDlg(pc,'NPC_EVENT_OneYear_2', 1)
            end
        else
            ShowOkDlg(pc,'NPC_EVENT_OneYear_1', 1)    
        end             
    elseif select == 3 then
        if sObj.EVENT_VALUE_SOBJ03 == 0 and pc.Lv < 330 then
            local nextLv = 0
	        local nextlv_group = {280, 235, 185, 135, 85, 45, 1}
	        for i = 1, table.getn(nextlv_group) do
        	    if pc.Lv >= nextlv_group[i] then
        	        nextLv = i + pc.Lv
        	        break
        	    end
        	end
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG1', 1)
            local tx = TxBegin(pc)
            TxAddIESProp(tx, sObj, 'EVENT_VALUE_SOBJ03', 1);
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ01', nextLv)
            TxGiveItem(tx, 'LevelUp_Reward_EV', 10, 'Event_VerUP_Box');
            local ret = TxCommit(tx)
        elseif pc.Lv == 330 then
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG8', 1)
        elseif sObj.EVENT_VALUE_SOBJ03 > 0 then
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG2', 1)    
        end
    elseif select == 4 then
        if aObj.EVENT_VALUE_AOBJ04 == 0 then
            if pc.Lv == 330 then
                ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG3', 1)
                local tx = TxBegin(pc)
                TxAddIESProp(tx, aObj, 'EVENT_VALUE_AOBJ04', 1);
                TxGiveItem(tx, 'Premium_eventTpBox_120', 1, 'Event_VerUP_Tp');
                local ret = TxCommit(tx)
            elseif pc.Lv ~= 330 then
                ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG4', 1)
            end
        elseif aObj.EVENT_VALUE_AOBJ04 > 0 then
            ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG5', 1)    
        end
    elseif select == 5 then
        local sObj = GetSessionObject(pc, 'ssn_klapeda')
        if sObj.EVENT_VALUE_SOBJ02 < 10 then
            if pc.Lv >= 330 then
                ShowOkDlg(pc,'NPC_EVENT_VERUP_DLG8', 1)
            else
                SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("LevelUp_Event_Desc02", "NEXTLV", sObj.EVENT_VALUE_SOBJ01), 5)
            end
        end
    end
end