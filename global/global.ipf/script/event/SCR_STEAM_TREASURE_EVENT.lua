function SCR_EV_TREASURE_SCC_ENTER(self,pc)
    --[[
    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    local triNum, num = 0, 0
    local treasureTime = 'PlayTimeEventPlayMin'
    local treasureCount = 'PlayTimeEventRewardCount'
    local triTable = {
        'Num1', 'Num2', 'Num3', 'Num4', 'Num5', 'Num6', 'Num7',
        'Num8', 'Num9', 'Num10', 'Num11', 'Num12', 'Num13', 'Num14',
    }
    
    for num = 1, table.getn(triTable) do
        if argstr1 == triTable[num] then
            triNum = num
        end
    end
    
    local mapID = GetMapID(self);
    local questResult = {
        { 1021, 'EV_TREASURE_CHEST_01'},
        { 1032, 'EV_TREASURE_CHEST_02'},
        { 1041, 'EV_TREASURE_CHEST_03'},
        { 1051, 'EV_TREASURE_CHEST_04'},
        { 1021, 'EV_TREASURE_CHEST_05'},
        { 1032, 'EV_TREASURE_CHEST_06'},
        { 1041, 'EV_TREASURE_CHEST_07'},
        { 1162, 'EV_TREASURE_CHEST_08'},
        { 1171, 'EV_TREASURE_CHEST_09'},
        { 1122, 'EV_TREASURE_CHEST_10'},
        { 3910, 'EV_TREASURE_CHEST_11'},
        { 1162, 'EV_TREASURE_CHEST_12'},
        { 1171, 'EV_TREASURE_CHEST_13'},
        { 1122, 'EV_TREASURE_CHEST_14'}
    }
    
    local rewardItem = {
        { 'Event_drug_steam', 1 },
        { 'Premium_boostToken', 1 },
        { 'Event_drug_steam', 1, 'Premium_boostToken', 1, 'Premium_eventTpBox_20', 1 }, -- 3
        { 'Event_drug_steam', 2 },
        { 'Premium_boostToken', 2 },
        { 'Event_drug_steam', 2, 'Premium_boostToken', 2, 'Premium_eventTpBox_30', 1 }, -- 6
        { 'Event_drug_steam', 3 },
        { 'Premium_boostToken', 3 },
        { 'Premium_Enchantchip', 5, 'steam_PremiumToken_7d', 1 }, -- 9
        { 'Event_drug_steam', 4 },
        { 'Premium_boostToken', 4 },
        { 'Premium_SkillReset', 1, 'Premium_indunReset', 1 }, -- 12
        { 'ABAND01_114', 1, 'Premium_indunReset', 2 }, -- 13
        { 'Achieve_Geographer', 1, 'steam_Hat_629503_ev', 1 }, --14
    }
    
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    local a, possible = 0, 0
    
    if possible == 0 then -- fail
        return
    end
    
    local select = ShowSelDlg(pc,0, 'EV_TREASURE_DESC_04', ScpArgMsg("Yes"), ScpArgMsg("No"))
    
	if select == 2 or select == nil then
		return;
	elseif select == 1 then
	    local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_TamSaeg_Jung"), '#SITGROPESET', 2)
	    
	    if result == 1 then
	        PlayEffect(self, 'F_smoke046', 0.5)
	        PlayEffect(self, 'F_spread_out025_yellow', 1)
	        
	        local i, j
	        local questCls, questReward, reward
	        
	        reward = ShowQuestSelDlg(pc, 'EV_TREASURE_CHEST_15', 1)
	        if reward ~= nil then
	            local rewardNum = 0
	            local now_time = os.date('*t')
                local year = now_time['year']
                local yday = now_time['yday']
                local hour = now_time['hour']
	            local tx = TxBegin(pc)
	            
	            for rewardNum = 1, table.getn(rewardItem[aObj[treasureCount] + 1]), 2 do
	                TxGiveItem(tx, rewardItem[aObj[treasureCount] + 1][rewardNum], rewardItem[aObj[treasureCount] + 1][rewardNum + 1], 'STEAM_EVENT_TREASURE')
	            end
	            
                TxSetIESProp(tx, sObj, questResult[triNum][2], 300)
                TxSetIESProp(tx, aObj, treasureCount, aObj[treasureCount] + 1)
                
                if hour <= 5 then
                    TxSetIESProp(tx, aObj, treasureTime, year..'/'..yday - 1)
                else
                    TxSetIESProp(tx, aObj, treasureTime, year..'/'..yday)
                end
                
                local ret = TxCommit(tx)
                --ShowOkDlg(pc, 'EV_TREASURE_DESC_06', 1)
	        end
	    end
		return;
	end
	--]]
end

function SCR_EV_TREASURE_QUEST(self,pc)
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local treasureTime = 'PlayTimeEventPlayMin'
    local treasureCount = 'PlayTimeEventRewardCount'
    local questTable = { 
        'EV_TREASURE_CHEST_01', 'EV_TREASURE_CHEST_02', 'EV_TREASURE_CHEST_03', 'EV_TREASURE_CHEST_04', 'EV_TREASURE_CHEST_05',
        'EV_TREASURE_CHEST_06', 'EV_TREASURE_CHEST_07', 'EV_TREASURE_CHEST_08', 'EV_TREASURE_CHEST_09', 'EV_TREASURE_CHEST_10',
        'EV_TREASURE_CHEST_11', 'EV_TREASURE_CHEST_12', 'EV_TREASURE_CHEST_13', 'EV_TREASURE_CHEST_14'
    }
    
    local deleteTable = {}
    local i, result, daycount, j = 0, 0, 0, 0;
    local questCls
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local year = now_time['year']
    local yday = now_time['yday']
    local today = SCR_REQUEST_YYYYMMDD_CHECK(self)
    local daycount = yday - 201
    
    for j = 2, daycount do
        if aObj[treasureTime] == year..'/'..yday - j then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aObj, treasureTime, 'None') -- reset
            local ret = TxCommit(tx);
            break
        end
    end
    
    if aObj[treasureTime] ~= 'None' and aObj[treasureTime] ~= 'Ing' then
        if aObj[treasureTime] ~= year..'/'..yday and hour >= 6 then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aObj, treasureTime, 'None') -- reset
            local ret = TxCommit(tx);
        elseif aObj[treasureTime] == year..'/'..yday or (aObj[treasureTime] ~= year..'/'..yday and hour <=  5) then
            ShowOkDlg(pc, 'EV_TREASURE_DESC_01', 1)
            return
        end
    end
     
    if aObj[treasureCount] >= 14 then
        ShowOkDlg(pc, 'EV_TREASURE_DESC_05', 1)
        return
    end
    
    local select = ShowSelDlg(pc,0, 'EV_TREASURE_DESC_02', ScpArgMsg("Yes"), ScpArgMsg("No"))
    
    if select == 2 or select == nil then
        return
    elseif select == 1 then
        for i = 1, table.getn(questTable) do
            if sObj[questTable[i]] == 200 or sObj[questTable[i]] == 1 then
                result = 1
                break
            end
        end
        
        if aObj[treasureTime] == 'Ing' then
            result = 1
        end
        
        if result == 1 then
            ShowOkDlg(pc, 'EV_TREASURE_DESC_03', 1)
            return
        end

        for i = 1, table.getn(questTable) do
            if sObj[questTable[i]] == 300 then -- end
                table.insert(deleteTable, i)
            end
        end
        
        if table.getn(deleteTable) >= 1 then
            local qt = 0
            for qt = table.getn(deleteTable), 1, -1 do
                table.remove(questTable, deleteTable[qt])
            end
        end

        local rand = IMCRandom(1, table.getn(questTable))
        questCls = questTable[rand]
        
        if result == 0 and questCls ~= nil then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, sObj, questCls, 1);
            TxSetIESProp(tx, aObj, treasureTime, 'Ing')
            local ret = TxCommit(tx);
        end
    end
end

function IS_EVENT_START(pc)
    return 'NO'
end
