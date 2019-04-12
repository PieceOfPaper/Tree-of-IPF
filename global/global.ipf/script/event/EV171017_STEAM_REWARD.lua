--function SCR_EVENT_STEAM_ELITE_CHECK(self, sObj, msg, argObj, argStr, argNum)
--    if GetServerNation() ~= 'GLOBAL' then
--        return
--    end
--    local aObj = GetAccountObj(self)
--    local year, month, day, hour, min = GetAccountCreateTime(self)
--    if ((month >= 10 and day >= 17) or (month >= 11)) and year >= 2017 then
--        return
--    end
--    if  self.Lv >= 50 or aObj.EV171017_STEAM_CB_CHECK == 1 then
--        if TryGetProp(argObj, "MonRank") == "Elite" then
--            local pcLayer = GetLayer(self)
--            if pcLayer > 0 then
--            local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
--            local flag = 'NO'
--                if obj ~= nil then
--                    if obj.EventName ~= nil and obj.EventName ~= "None" then
--                    local etc = GetETCObject(self)
--            		    if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
--            			local trackInitCount = etc[obj.EventName..'_TRACK']
--            			    if trackInitCount <= 1 then
--            				    flag = 'YES'
--            				end
--            			end
--                    end
--                end
--           		if flag == 'NO' then
--           		    return
--           		end
--           	end  
--            local rand = IMCRandom(1, 5)        
--            if rand >= 4 then --40
--                local tx = TxBegin(self);
--    			TxGiveItem(tx, 'Event_Goddess_Medal', 1, "EV171017_STEAM_REWARD");
--    			local ret = TxCommit(tx);
--            end
--        end
--    end
--end

function SCR_EV171017_STEAM_REWARD_DIALOG(self, pc)

    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local aObj = GetAccountObj(pc)
    local qCount = GetInvItemCount(pc, 'Event_Goddess_Medal')
    
    if aObj.EV171114_STEAM_NRU_JOIN_CHECK == 1 then
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_7', 1)
        return        
    end
    
    local reward = {
    {1, 'Event_Sol_BOX_2', 1, 'Premium_Enchantchip14', 1},{2, 'Event_Sol_BOX_6', 1, 'Premium_Enchantchip14', 1},
    {3, 'Event_Sol_BOX_3', 1, 'Premium_Enchantchip14', 1},{4, 'Event_Sol_BOX_6', 1, 'Premium_Enchantchip14', 1},
    {5, 'Event_Sol_BOX_4', 1, 'Premium_Enchantchip14', 1},{6, 'Event_Sol_BOX_6', 1, 'Premium_Enchantchip14', 1},
    {7, 'Event_Sol_BOX_5', 1, 'Premium_Enchantchip14', 1},{8, 'Premium_Enchantchip14', 1, 'Event_Reinforce_100000coupon', 1},
    {9, 'Premium_Enchantchip14', 1 , 'misc_gemExpStone_randomQuest1', 1},{10, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest2', 1},
    {11, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest3', 1},{12, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest4', 1},
    {13, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest1', 1},{14, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest2', 1},
    {15, 'PremiumToken_5d_Steam', 1, 'card_Xpupkit01_500_14d', 1},{16, 'Premium_Enchantchip14', 1, 'Event_Reinforce_100000coupon', 1},
    {17, 'Premium_Enchantchip14', 1 , 'misc_gemExpStone_randomQuest3', 1},{18, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest4', 1},
    {19, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest1', 1},{20, 'Ability_Point_Stone_500', 1, 'Moru_Silver', 1, 'Moru_Gold_14d', 1},
    {21, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest2', 1},{22, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest3', 1},
    {23, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest4', 1},{24, 'Premium_Enchantchip14', 1, 'Event_Reinforce_100000coupon', 1},
    {25, 'Premium_Enchantchip14', 1 , 'misc_gemExpStone_randomQuest1', 1},{26, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest2', 1},
    {27, 'Premium_Enchantchip14', 1, 'misc_gemExpStone_randomQuest3', 1},{28, 'Moru_Diamond_14d', 1, 'Ability_Point_Stone', 1, 'card_Xpupkit01_event', 1}
    }
    
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_TODAY_NUMBER_9', ScpArgMsg("Moru_King_Select_1"), ScpArgMsg("DayQuest_Rand_Desc03"), ScpArgMsg("Cancel")) 
    if pc.Lv >= 50 or aObj.EV171114_STEAM_CB_CHECK == 1 then
        if select == 1 then
                if aObj.EV171114_STEAM_CLOVER_DAY ~= yday then
                    local tx = TxBegin(pc)
            		TxSetIESProp(tx, aObj, 'EV171114_STEAM_CLOVER_DAY', yday);
            		TxSetIESProp(tx, aObj, 'EV171114_STEAM_ALL_JOIN_CHECK', 1);
            		TxGiveItem(tx, 'E_Artefact_631001', 1, 'EV171114_STEAM');
            		local ret = TxCommit(tx)
        		else
        		    ShowOkDlg(pc, 'NPC_EVENT_JP_DAY_CHECK_2', 1)
            		return
        		end
        elseif select == 2 then
            if aObj.EV171017_STEAM_REWARD_DAY == yday then
                ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
                return
            end
            if qCount >= 1 then
                local tx = TxBegin(pc)   
                for i = 1, table.getn(reward) do
                    if reward[i][1] == aObj.EV171114_STEAM_REWARD_COUNT + 1 then
                        local result = i
                        TxSetIESProp(tx, aObj, 'EV171017_STEAM_REWARD_DAY', yday)
                        TxSetIESProp(tx, aObj, 'EV171114_STEAM_REWARD_COUNT', aObj.EV171114_STEAM_REWARD_COUNT + 1)
                        TxTakeItem(tx, 'Event_Goddess_Medal', qCount, 'EV171114_STEAM');
                        for j = 2, #reward[result], 2 do
                            TxGiveItem(tx, reward[result][j], reward[result][j+1], 'EV171114_STEAM');
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
    else
        ShowOkDlg(pc, 'EV_PRISON_DESC2', 1)
    end 
end