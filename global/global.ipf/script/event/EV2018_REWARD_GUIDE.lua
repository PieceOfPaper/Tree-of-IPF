function SCR_EV2018_REWARD_GUIDE_DIALOG(self, pc) --초보, 복귀 이벤트 --

    local aObj = GetAccountObj(pc); 
    local teamlv = GetTeamLevel(pc)
    local teamName = GetTeamName(pc)
    if teamlv == 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then --팀 레벨이 1이고, 가이드 상자를 받지 않았으면 들어와라 --
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'Event_Nru2_Box_1_re', 1, "EV_GuideBox_Give");
        TxSetIESProp(tx, aObj, 'EV2018_STEAM_GUIDE_CHECK', aObj.EV2018_STEAM_GUIDE_CHECK + 1); -- 상자 받았으면 +1 --
        IMCLOG_CONTENT('ENTER_EV_GUIDE', 'ENTER_EV_GUIDE  '..'..PC_LV : '..pc.Lv..'  '..'TEAM_LV : '..teamlv..'  '..'TEAM_NAME : '..teamName) -- Log --
        local ret = TxCommit(tx);
        ShowOkDlg(pc, 'NPC_EVENT_2018GUIDE_DLG3', 1) --트리 오브 세이비어에 오신 것을 환영합니다. --
    else   
        ShowOkDlg(pc, 'NPC_EVENT_2018GUIDE_DLG1', 1)    --팀 레벨이 1이 아니거나, 이미 가이드 상자를 받으셨습니다. --       
    end
end

function SCR_EV2018_REWARD_DAYDAY_DIALOG(self, pc) -- 출석체크 이벤트 --
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local reward = {
    {1, 'Drug_Fortunecookie_14d', 1},{2, 'Event_drug_steam_1h', 1},
    {3, 'Event_Goddess_Statue_3d', 1},{4, 'Drug_Fortunecookie_14d', 1},
    {5, 'Mic', 1},{6, 'Adventure_Reward_Seed_3d', 1},
    {7, 'Premium_dungeoncount_Event', 1},{8, 'Drug_Fortunecookie_14d', 1},
    {9, 'Event_Steam_Happy_New_Year', 1},{10, 'RestartCristal', 1},
    {11, 'GIMMICK_Drug_HPSP2', 1},{12, 'Drug_Fortunecookie_14d', 1},
    {13, 'Premium_indunReset_1add_14d', 1},{14, 'Premium_awakeningStone14', 1},
    {15, 'Premium_WarpScroll_14d', 1},{16, 'Drug_Fortunecookie_14d', 1},
    {17, 'Premium_boostToken_14d', 1},{18, 'Moru_Silver', 1},
    {19, 'Moru_Gold_14d', 1},{20, 'Premium_Enchantchip14', 1},
    {21, 'Ability_Point_Stone_500_14d', 1}
    } --보상 리스트 --
    
    if aObj.EV2018_STEAM_DAYDAY_COUNT >= 21 then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EV2018_STEAM_DAYDAY_COUNT', 0)
        local ret = TxCommit(tx)    
    end

    if aObj.EV2018_STEAM_DAYDAY_CHECK == yday then -- 같은 날에 못받습니다 --
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
        return
    end

        for i = 1, table.getn(reward) do
            if reward[i][1] == aObj.EV2018_STEAM_DAYDAY_COUNT + 1 then -- 내가 받을 일차 계산 --
                local result = i
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'EV2018_STEAM_DAYDAY_CHECK', yday) -- 보상 받은 날짜 저장 --
                TxSetIESProp(tx, aObj, 'EV2018_STEAM_DAYDAY_COUNT', aObj.EV2018_STEAM_DAYDAY_COUNT + 1) -- 보상 받았으면 일차 +1 --
                TxSetIESProp(tx, aObj, 'EV2018_STEAM_DAYDAY_LOG', aObj.EV2018_STEAM_DAYDAY_LOG + 1) -- Log --
                    for j = 2, #reward[result], 2 do
                        TxGiveItem(tx, reward[result][j], reward[result][j+1], 'EV_DAYDAY_Give');
                    end
                    local teamlv = GetTeamLevel(pc)
                    local teamName = GetTeamName(pc)
                    IMCLOG_CONTENT('ENTER_EV_DAYDAY', 'ENTER_EV_DAYDAY  '..'..PC_LV : '..pc.Lv..'  '..'TEAM_LV : '..teamlv..'  '..'TEAM_NAME : '..teamName..'  '..'DAY_COUNT : '..aObj.EV2018_STEAM_DAYDAY_LOG) -- Log --
                local ret = TxCommit(tx)
                if ret == "SUCCESS" then
                    ShowOkDlg(pc, ScpArgMsg('EVENT_STEAM_2018REWARD_DLG3', "COUNT", aObj.EV2018_STEAM_DAYDAY_COUNT), 1) -- 보상 받았으면 메세지 --
                end
                break
            end
        end
end


function SCR_USE_EVENT_NRU2_BOX_1(pc) -- Base BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
      if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken02_event01', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'NECK99_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Klaipe', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SWD04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_MAC04_108', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSF04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_STF04_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SPR04_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSP04_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_BOW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TBW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SHD04_102', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_104', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'PremiumToken_3d_event', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Nru2_Box_2_re', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru2_Box_3_re', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru2_Box_4_re', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru2_Box_5_re', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru2_Box_6_re', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru2_Box_7_re', 1, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_NRU2_BOX_2(pc) -- Lv1 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken02_event01', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'NECK99_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Klaipe', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SWD04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_MAC04_108', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSF04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_STF04_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SPR04_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TSP04_107', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_BOW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_TBW04_106', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_SHD04_102', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_104', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'PremiumToken_3d_event', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'NECK99_107', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'BRC99_103', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'BRC99_104', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_NRU2_BOX_3(pc) -- Lv50 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_104', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'PremiumToken_3d_event', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_SWD04_106', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_TSW04_106', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_MAC04_108', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_TSF04_106', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_STF04_107', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_SPR04_103', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_TSP04_107', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_BOW04_106', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_TBW04_106', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_SHD04_102', 1, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_NRU2_BOX_4(pc) -- Lv170 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_103', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'BRC99_104', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'PremiumToken_3d_event', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'E_BRC04_101', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_NRU2_BOX_5(pc) -- Lv220 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'PremiumToken_3d_event', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'E_BRC03_108', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'E_BRC04_103', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_NRU2_BOX_6(pc) -- Team Lv 2 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_WarpScroll', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local teamlv = GetTeamLevel(pc)
        if teamlv >= 2 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV_GuideBox_Give');
            local ret = TxCommit(tx)
        else
            ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1) -- 팀레벨이 부족합니다 --
        end
    end
end

function SCR_USE_EVENT_NRU2_BOX_7(pc) -- Team Lv 3 BOX --
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc);
    if sObj.EV180109_STEAM_BEGINNER_SESSION_CHECK >= 1 and aObj.EV2018_STEAM_GUIDE_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'RestartCristal', 5, 'EV170711_NRU2');
        TxGiveItem(tx, 'Mic', 10, 'EV170711_NRU2');
        TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Warp_Dungeon_Lv100_2', 1, 'EV170711_NRU2');
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV170711_NRU2');
        TxGiveItem(tx, 'Event_Nru2_Box_8', 1, 'EV170711_NRU2');
        local ret = TxCommit(tx)
    else
        local teamlv = GetTeamLevel(pc)
        if teamlv >= 3 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Premium_StatReset14', 1, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Premium_SkillReset_14d', 1, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 2, 'EV_GuideBox_Give');
            TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV_GuideBox_Give');
            local ret = TxCommit(tx)
        else
            ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1) -- 팀레벨이 부족합니다 --
        end
    end
end

function SCR_USE_EVENT_NRU2_BOX_1_RE(pc) -- Base BOX --
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Event_Nru2_Box_2_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_Nru2_Box_3_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_Nru2_Box_4_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_Nru2_Box_5_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_Nru2_Box_6_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_Nru2_Box_7_re', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Steam_Event_Weapon_Select_Box_14day', 1, 'EV_GuideBox_Give');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_2_RE(pc) -- Lv1 BOX --
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'NECK99_107', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'BRC99_103', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'BRC99_104', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_3_RE(pc) -- Lv50 BOX --
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'E_FOOT04_101', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_SWD04_106', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_TSW04_106', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_MAC04_108', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_TSF04_106', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_STF04_107', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_SPR04_103', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_TSP04_107', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_BOW04_106', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_TBW04_106', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_SHD04_102', 1, 'EV_GuideBox_Give');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_4_RE(pc) -- Lv170 BOX --
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'E_BRC04_101', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_5_RE(pc) -- Lv220 BOX --
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'E_BRC03_108', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'E_BRC04_103', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Mic', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'RestartCristal', 3, 'EV_GuideBox_Give');
    TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
    local ret = TxCommit(tx)
end

function SCR_USE_EVENT_NRU2_BOX_6_RE(pc) -- Team Lv 2 BOX --
    local teamlv = GetTeamLevel(pc)
    if teamlv >= 2 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_WarpScroll_14d', 2, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    else
        ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1) -- 팀레벨이 부족합니다 --
    end
end

function SCR_USE_EVENT_NRU2_BOX_7_RE(pc) -- Team Lv 3 BOX --
    local teamlv = GetTeamLevel(pc)
    if teamlv >= 3 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_StatReset14', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Premium_SkillReset_14d', 1, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 2, 'EV_GuideBox_Give');
        TxGiveItem(tx, 'Event_Nru_Buff_Item', 2, 'EV_GuideBox_Give');
        local ret = TxCommit(tx)
    else
        ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1) -- 팀레벨이 부족합니다 --
    end
end

function SCR_USE_EVENT_RETURN_BOX(pc) --복귀 유저 상자 --
    local aObj = GetAccountObj(pc);
    local teamlv = GetTeamLevel(pc)
    local teamName = GetTeamName(pc)
    local tx = TxBegin(pc)
    TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_RETURN")
    TxGiveItem(tx, 'Event_Cb_Buff_Potion', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_boostToken03_event01', 2, "EVENT_RETURN")
    TxGiveItem(tx, 'Ability_Point_Stone_500_14d', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_SkillReset_14d', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_StatReset14', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Event_Nru2_Box_1_re', 1, "EVENT_RETURN")
    IMCLOG_CONTENT('ENTER_EV_GUIDE', 'ENTER_EV_RETRUN  '..'..PC_LV : '..pc.Lv..'  '..'TEAM_LV : '..teamlv..'  '..'TEAM_NAME : '..teamName) -- Log --
    local ret = TxCommit(tx)
end