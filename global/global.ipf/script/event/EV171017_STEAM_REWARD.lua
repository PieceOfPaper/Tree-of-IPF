function SCR_EVENT_STEAM_ELITE_CHECK(self, sObj, msg, argObj, argStr, argNum)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local aObj = GetAccountObj(self)
    local year, month, day, hour, min = GetAccountCreateTime(self)
    if ((month >= 10 and day >= 17) or (month >= 11)) and year >= 2017 then
        return
    end
    if  self.Lv >= 50 or aObj.EV171017_STEAM_CB_CHECK == 1 then
        if TryGetProp(argObj, "MonRank") == "Elite" then
            local pcLayer = GetLayer(self)
            if pcLayer > 0 then
            local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
            local flag = 'NO'
                if obj ~= nil then
                    if obj.EventName ~= nil and obj.EventName ~= "None" then
                    local etc = GetETCObject(self)
            		    if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
            			local trackInitCount = etc[obj.EventName..'_TRACK']
            			    if trackInitCount <= 1 then
            				    flag = 'YES'
            				end
            			end
                    end
                end
           		if flag == 'NO' then
           		    return
           		end
           	end  
            local rand = IMCRandom(1, 5)        
            if rand >= 4 then --40
                local tx = TxBegin(self);
    			TxGiveItem(tx, 'Event_Goddess_Medal', 1, "EV171017_STEAM_REWARD");
    			local ret = TxCommit(tx);
            end
        end
    end
end

function SCR_EV171017_STEAM_REWARD_DIALOG(self, pc)

    local year, month, day, hour, min = GetAccountCreateTime(pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    if ((month >= 10 and day >= 17) or (month >= 11)) and year >= 2017 then
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_7', 1)
        return 
    end
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local aObj = GetAccountObj(pc)
    local qCount = GetInvItemCount(pc, 'Event_Goddess_Medal')
    local reward = {
    {1, 'Event_Sol_BOX_2', 1, 'Event_Lv315_Ore_Box', 2},{2, 'Event_Sol_BOX_6', 1, 'Event_Lv315_Ore_Box', 2},
    {3, 'Event_Sol_BOX_3', 1, 'Event_Lv315_Ore_Box', 2},{4, 'Event_Sol_BOX_6', 1, 'Event_Lv315_Ore_Box', 2},
    {5, 'Event_Sol_BOX_4', 1, 'Event_Lv315_Ore_Box', 2},{6, 'Event_Sol_BOX_6', 1, 'Event_Lv315_Ore_Box', 2},
    {7, 'Event_Sol_BOX_5', 1, 'Event_Lv315_Ore_Box', 2},{8, 'Premium_WarpScroll_14d', 10, 'Gacha_G_013', 1, 'Event_Lv315_Ore_Box', 2},
    {9, 'Premium_dungeoncount_Event', 1 , 'Event_Lv315_Ore_Box', 2},{10, 'Event_Goddess_Statue', 2, 'Event_Lv315_Ore_Box', 2},
    {11, 'Premium_indunReset_1add_14d', 1, 'Event_Lv315_Ore_Box', 2},{12, 'Paste_Bait_shrimp', 60, 'Spread_Bait_basic', 1, 'Event_Lv315_Ore_Box', 2},
    {13, 'CS_IndunReset_GTower_14d', 1, 'Event_Lv315_Ore_Box', 2},{14, 'Event_drug_steam_1h', 5, 'Event_Lv315_Ore_Box', 2},
    {15, 'PremiumToken_5d_Steam', 1, 'Event_Lv315_Ore_Box', 2},{16, 'Premium_WarpScroll_14d', 10, 'Gacha_G_013', 1, 'Event_Lv315_Ore_Box', 2},
    {17, 'Premium_dungeoncount_Event', 1 , 'Event_Lv315_Ore_Box', 2},{18, 'Event_Goddess_Statue', 2, 'Event_Lv315_Ore_Box', 2},
    {19, 'Premium_indunReset_1add_14d', 1, 'Event_Lv315_Ore_Box', 2},{20, 'Moru_Silver', 1, 'Moru_Gold_14d', 1, 'Event_Lv315_Ore_Box', 2},
    {21, 'Paste_Bait_shrimp', 60, 'Spread_Bait_basic', 1, 'Event_Lv315_Ore_Box', 2},{22, 'CS_IndunReset_GTower_14d', 1, 'Event_Lv315_Ore_Box', 2},
    {23, 'Event_drug_steam_1h', 5, 'Event_Lv315_Ore_Box', 2},{24, 'Premium_WarpScroll_14d', 10, 'Gacha_G_013', 1, 'Event_Lv315_Ore_Box', 2},
    {25, 'Premium_dungeoncount_Event', 1 , 'Event_Lv315_Ore_Box', 2},{26, 'Premium_indunReset_1add_14d', 1, 'Event_Lv315_Ore_Box', 2},
    {27, 'CS_IndunReset_GTower_14d', 1, 'Event_Lv315_Ore_Box', 2},{28, 'Moru_Diamond_14d', 1, 'Ability_Point_Stone', 1, 'Event_Lv315_Ore_Box', 2}
    }
    
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_TODAY_NUMBER_9', ScpArgMsg("DayQuest_Rand_Desc03"), ScpArgMsg("Cancel")) 
    if select == 1 then
        if aObj.EV171017_STEAM_REWARD_DAY == yday then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
            return
        end
        if qCount >= 3 then
            local tx = TxBegin(pc)   
            for i = 1, table.getn(reward) do
                if reward[i][1] == aObj.EV171017_STEAM_REWARD_COUNT + 1 then
                    local result = i
                    TxSetIESProp(tx, aObj, 'EV171017_STEAM_REWARD_DAY', yday)
                    TxSetIESProp(tx, aObj, 'EV171017_STEAM_REWARD_COUNT', aObj.EV171017_STEAM_REWARD_COUNT + 1)
                    TxTakeItem(tx, 'Event_Goddess_Medal', qCount, 'EV171017_STEAM_REWARD');
                    for j = 2, #reward[result], 2 do
                        TxGiveItem(tx, reward[result][j], reward[result][j+1], 'EV171017_STEAM_REWARD');
                    end
                    local ret = TxCommit(tx)
                    ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_2', 1)
                    break
                end
            end
        else
            ShowOkDlg(pc, 'NPC_EVENT_STEAM_REWARD_1', 1)
        end
    end 
end