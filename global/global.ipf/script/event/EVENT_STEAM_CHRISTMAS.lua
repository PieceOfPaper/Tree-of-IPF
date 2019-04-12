function SCR_EVENT_STEAM_CHRISTMAS_DIALOG(self, pc)
    if pc.Lv < 50 then
        ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_NPC3', 1)
        return
    end
    
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local aObj = GetAccountObj(pc);
    local rand = IMCRandom(1, 20)
    local ChristBox = GetInvItemCount(pc, "Event_Steam_Christmas_Box")
    local zone_npcList = {
        {1171, 1}, {1162, 2}, {1006, 3},
        {1122, 4}, {3960, 5}, {3970, 6},
        {3980, 7}, {1111, 8}, {1131, 9},
        {1251, 10}, {1021, 11}, {1001, 12},
        {1032, 13}, {2081, 14}, {2082, 15},
        {2083, 16}, {2084, 17}, {2088, 18},
        {1381, 19}, {2089, 20}
    }
    local select = ShowSelDlg(pc, 0, 'EVENT_STEAM_CHRISTMAS_NPC1', ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL2"), ScpArgMsg('CATACOMB_HALLOWEEN_MSG2','COUNT',aObj.STEAM_CHRISTMAS_COUNT), ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL5"), ScpArgMsg("Cancel"))
    
    if select == 1 then
        if aObj.STEAM_CHRISTMAS_DAYCHECK ~= yday and ChristBox == 0 and aObj.STEAM_CHRISTMAS_NPC_SELECT == 0 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Event_Steam_Christmas_Box', 1, "EVENT_STEAM_CHRISTMAS_BOX");
            TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_DAYCHECK', yday);
            TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_NPC_SELECT', zone_npcList[rand][1]);
            local ret = TxCommit(tx)
            local map = GetClassString('Map', aObj.STEAM_CHRISTMAS_NPC_SELECT, 'Name')
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL6", "MAP", map), 7);
        else
            ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_NPC2', 1) 
        end
    elseif select == 2 then
        if aObj.STEAM_CHRISTMAS_HIDDEN_COUNT == 2 then
            ShowOkDlg(pc, 'NPC_EVENT_NRU_ALWAYS_2', 1)
            return
        end
        ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_NPC5', 1)
        if aObj.STEAM_CHRISTMAS_COUNT >= 10 and aObj.STEAM_CHRISTMAS_HIDDEN_COUNT == 0 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Moru_Silver', 2, "EVENT_STEAM_CHRISTMAS_SILVERANVIL");
            TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_HIDDEN_COUNT', 1);
            local ret = TxCommit(tx)
        end
        if aObj.STEAM_CHRISTMAS_COUNT >= 20 and aObj.STEAM_CHRISTMAS_HIDDEN_COUNT == 1 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Moru_Gold_14d', 2, "EVENT_STEAM_CHRISTMAS_GOLDANVIL");
            TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_HIDDEN_COUNT', 2);
            local ret = TxCommit(tx)
        end
    elseif select == 3 then
        if aObj.STEAM_CHRISTMAS_NPC_SELECT == 0 then
            ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_NPC4', 1)
            return
        end
        local map = GetClassString('Map', aObj.STEAM_CHRISTMAS_NPC_SELECT, 'Name')
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL6", "MAP", map), 7);
    end
end

function SCR_CHRISTMAS_SANTA_DIALOG(self, pc)
    if pc.Lv < 50 then
        ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_NPC3', 1)
        return
    end
    
    local aObj = GetAccountObj(pc);
    local ChristBox = GetInvItemCount(pc, "Event_Steam_Christmas_Box")
    local select = ShowSelDlg(pc, 0, 'EVENT_STEAM_CHRISTMAS_MAP_NPC1', ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL3"), ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL4"), ScpArgMsg("Cancel"))
    
    if select == 1 then
        if ChristBox >= 1 then
            EquipOuter = GetEquipItem(pc, "OUTER")
            EquipHelmet = GetEquipItem(pc, "HELMET")      
            if EquipOuter.ClassName == 'costume_Com_75' or EquipOuter.ClassName == 'costume_Com_76' or EquipOuter.ClassName == 'costume_war_m_016' or 
            EquipOuter.ClassName == 'costume_war_f_016' or EquipOuter.ClassName == 'costume_wiz_m_016' or EquipOuter.ClassName == 'costume_wiz_f_016' or 
            EquipOuter.ClassName == 'costume_arc_m_019' or EquipOuter.ClassName == 'costume_arc_f_019' or EquipOuter.ClassName == 'costume_clr_m_017' or 
            EquipOuter.ClassName == 'costume_clr_f_017' or EquipOuter.ClassName == 'costume_Com_77' or EquipHelmet.ClassName == 'helmet_Rudolf01' then
                local tx = TxBegin(pc)
                TxTakeItem(tx, 'Event_Steam_Christmas_Box', 1, "EVENT_STEAM_CHRISTMAS_BOX_Take");
                TxGiveItem(tx, 'Event_Steam_Christmas_Reward_Box', 1, "EVENT_STEAM_CHRISTMAS_BOX_Give");
                TxGiveItem(tx, 'Drug_Fortunecookie', 1, "EVENT_STEAM_CHRISTMAS_COSTUME");
                TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_COUNT', aObj.STEAM_CHRISTMAS_COUNT + 1);
                TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_NPC_SELECT', 0);
                local ret = TxCommit(tx)
                if ret == "SUCCESS" then
                    ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_MAP_NPC3', 1)
                end
            else    
                local tx = TxBegin(pc)
                TxTakeItem(tx, 'Event_Steam_Christmas_Box', 1, "EVENT_STEAM_CHRISTMAS_BOX_Take");
                TxGiveItem(tx, 'Event_Steam_Christmas_Reward_Box', 1, "EVENT_STEAM_CHRISTMAS_BOX_Give");
                TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_COUNT', aObj.STEAM_CHRISTMAS_COUNT + 1);
                TxSetIESProp(tx, aObj, 'STEAM_CHRISTMAS_NPC_SELECT', 0);
                local ret = TxCommit(tx)
                if ret == "SUCCESS" then
                    ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_MAP_NPC3', 1)
                end
            end
        end
    elseif select == 2 then
        ShowOkDlg(pc, 'EVENT_STEAM_CHRISTMAS_MAP_NPC2', 1)
    end
end

function SCR_USE_EVENT_STEAM_CHRISTMAS_GUIDE(self, argstring, arg1, arg2) --아이템 사용 가이드
    local aObj = GetAccountObj(self);
    local map = GetClassString('Map', aObj.STEAM_CHRISTMAS_NPC_SELECT, 'Name')
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_CHRISTMAS_SEL6", "MAP", map), 7);
end

function SCR_CHRISTMAS_NPC_DIALOG(self, pc)
    local curMap = GetZoneName(pc);
    local mapCls = GetClass("Map", curMap);
    local aObj = GetAccountObj(pc);

    if aObj.STEAM_CHRISTMAS_NPC_SELECT == mapCls.ClassID then
        SCR_CHRISTMAS_SANTA_DIALOG(self, pc)
    end
end