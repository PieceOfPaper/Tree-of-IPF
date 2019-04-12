function SCR_STEAM_WEDDING_CHECK(self,pc)
    local weddingCard = GetInvItemCount(pc, "Event_Steam_Wedding_Card")
    local aObj = GetAccountObj(pc); 
    local invItemList = GetInvItemList(pc);
	
    if  weddingCard == 0 then
        return
    end
    for i = 1 , #invItemList do
		local invItem = invItemList[i];
        if invItem ~= nil and invItem.ClassName == "Event_Steam_Wedding_Card" and invItem.LifeTime ~= 0 and invItem.ItemLifeTimeOver == 0 then
            local tx = TxBegin(pc) 
            TxGiveItem(tx, 'Event_Steam_Wedding_Fire', 3, "STEAM_WEDDING")
            TxTakeItem(tx, 'Event_Steam_Wedding_Card', 1, "STEAM_WEDDING")
            TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_2', aObj.EV170613_STEAM_WEDDING_2 + 1)  
            local ret = TxCommit(tx)
        else
            local tx = TxBegin(pc) 
            TxGiveItem(tx, 'Event_Steam_Wedding_Fire', 1, "STEAM_WEDDING")
            TxTakeItem(tx, 'Event_Steam_Wedding_Card', 1, "STEAM_WEDDING")
            TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_2', aObj.EV170613_STEAM_WEDDING_2 + 1)  
            local ret = TxCommit(tx)
        end
        break
    end
end

function SCR_BUFF_ENTER_Event_Steam_Wedding(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2
end

function SCR_BUFF_LEAVE_Event_Steam_Wedding(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2
end

function SCR_NPC_STEAM_WEDDING_DIALOG(self, pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    if pc.Lv < 50 then
        return
    end
    
    local aObj = GetAccountObj(pc); 
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local rand = IMCRandom(1, 15)
    local weddingCard = GetInvItemCount(pc, "Event_Steam_Wedding_Card")
    local zone_npcList = {
        {'NPC_EVENT_STEAM_WEDDING_NPC_1', 1}, {'NPC_EVENT_STEAM_WEDDING_NPC_2', 2}, {'NPC_EVENT_STEAM_WEDDING_NPC_3', 3},
        {'NPC_EVENT_STEAM_WEDDING_NPC_4', 4}, {'NPC_EVENT_STEAM_WEDDING_NPC_5', 5}, {'NPC_EVENT_STEAM_WEDDING_NPC_6', 6},
        {'NPC_EVENT_STEAM_WEDDING_NPC_7', 7}, {'NPC_EVENT_STEAM_WEDDING_NPC_8', 8}, {'NPC_EVENT_STEAM_WEDDING_NPC_9', 9},
        {'NPC_EVENT_STEAM_WEDDING_NPC_10', 10}, {'NPC_EVENT_STEAM_WEDDING_NPC_11', 11}, {'NPC_EVENT_STEAM_WEDDING_NPC_12', 12},
        {'NPC_EVENT_STEAM_WEDDING_NPC_13', 13}, {'NPC_EVENT_STEAM_WEDDING_NPC_14', 14}, {'NPC_EVENT_STEAM_WEDDING_NPC_15', 15},
    }
    
    
    if aObj.EV170613_STEAM_WEDDING_2 >= 15 and aObj.EV170613_STEAM_WEDDING_3 == 0 then
        local tx = TxBegin(pc) 
        TxGiveItem(tx, 'Event_1704_WeddingBox', 1, "STEAM_WEDDING")
        TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_3', 1)  
        local ret = TxCommit(tx)
        ShowOkDlg(pc, 'NPC_EVENT_STEAM_WEDDING_4', 1)
        return
    end
    if aObj.EV170613_STEAM_WEDDING_3 >= 1 then
        ShowOkDlg(pc, 'NPC_EVENT_STEAM_WEDDING_5', 1)
        return
    end
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_STEAM_WEDDING_1', ScpArgMsg("Event_Steam_Wedding_1"), ScpArgMsg("Event_Steam_Wedding_2"))
    if select == 1 then
        if aObj.EV170613_STEAM_WEDDING_1 ~= yday and weddingCard == 0 and aObj.EV170613_STEAM_WEDDING_3 == 0 then
            local tx = TxBegin(pc) 
            TxGiveItem(tx, 'Event_Steam_Wedding_Card', 1, "STEAM_WEDDING")
            TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_1', yday)
            TxSetIESProp(tx, aObj, 'EV170613_STEAM_WEDDING_4', rand)
            local ret = TxCommit(tx)
            ShowOkDlg(pc, zone_npcList[aObj.EV170613_STEAM_WEDDING_4][1], 1)
        elseif weddingCard >= 1 then
            ShowOkDlg(pc, 'NPC_EVENT_STEAM_WEDDING_3', 1)
        elseif aObj.EV170613_STEAM_WEDDING_1 == yday then
            ShowOkDlg(pc, 'NPC_EVENT_STEAM_WEDDING_2', 1)
        end
    elseif select == 2 then
        if aObj.EV170613_STEAM_WEDDING_3 == 1 then
            ShowOkDlg(pc, 'NPC_EVENT_STEAM_WEDDING_4', 1)
            return
        end
        if weddingCard >= 1 then
            ShowOkDlg(pc, zone_npcList[aObj.EV170613_STEAM_WEDDING_4][1], 1)
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Event_Steam_Wedding_3", "WEDDINGCOUNT", 15 - aObj.EV170613_STEAM_WEDDING_2), 5)
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Event_Steam_Wedding_3", "WEDDINGCOUNT", 15 - aObj.EV170613_STEAM_WEDDING_2), 5)
        end
    end
end

--function SCR_SIAUL_WEST_LAIMONAS_DIALOG(self, pc)
--    local weddingNum = 1
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_SIAULIAI16_BOWEIN_DIALOG(self, pc)
--    local weddingNum = 2
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_SIAULIAI15RE_GERMEYA_DIALOG(self, pc)
--    local weddingNum = 3
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_SIAULIAI11RE_NOTORESU_DIALOG(self, pc)
--    local weddingNum = 4
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_BRACKEN633_PEAPLE01_DIALOG(self, pc)
--    local weddingNum = 5
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_BRACKEN631_TRADESMAN01_DIALOG(self, pc)
--    local weddingNum = 6
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_BRACKEN632_PEAPLE01_DIALOG(self, pc)
--    local weddingNum = 7
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_GELE_57_3_HQ01_NPC01_DIALOG(self, pc)
--    local weddingNum = 8
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_GELE574_ERRA_DIALOG(self, pc)
--    local weddingNum = 9
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self, pc)
--end
--
--function SCR_CHAPEL_TABERIJUS_DIALOG(self, pc)
--    local weddingNum = 10
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_HUEVILLAGE_58_1_MQ01_NPC_DIALOG(self, pc)
--    local weddingNum = 11
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_HUEVILLAGE_58_2_MQ01_NPC_DIALOG(self, pc)
--    local weddingNum = 12
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_HUEVILLAGE_58_3_MQ03_NPC_DIALOG(self, pc)
--    local weddingNum = 13
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_ROKAS_24_KEFEK_DIALOG(self, pc)
--    local weddingNum = 14
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end
--
--function SCR_THORN_BLACKMAN_TRIGGER2_DIALOG(self, pc)
--    local weddingNum = 15
--    local aObj = GetAccountObj(pc);
--    if aObj.EV170613_STEAM_WEDDING_4 == weddingNum then
--        SCR_STEAM_WEDDING_CHECK(self,pc)
--    end
--    COMMON_QUEST_HANDLER(self,pc)
--end