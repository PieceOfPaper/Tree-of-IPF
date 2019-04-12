function SCR_STEAM_OBSERVER_EVENT(pc, sObj, msg, argObj, argStr, argNum)
    if argObj == nil or argObj.ClassName == 'PC' then
        return
    end
    
    local rand = IMCRandom(1, 3)
    local isMission = IsMissionInst(zoneInst);

    if rand > 3 or isMission == 1 then
        return
    end

    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local i, result = 0, 0
    local now_time = os.date('*t')
    local year = now_time['year']
    local yday = now_time['yday']

    if aObj.PlayTimeEventRewardCount > 10 or aObj.PlayTimeEventPlayMin == year..'/'..yday then
        return
    end
    
    local questsucc = {
        {'Klaida', 'EV_OBSERVER1'}, -- 곤충형
        {'Widling', 'EV_OBSERVER2'}, -- 야수형
        {'Forester', 'EV_OBSERVER3'}, -- 식물형
        {'Velnias', 'EV_OBSERVER4'}, -- 악마형
        {'Paramune', 'EV_OBSERVER5'}, -- 변이형
    }
    
    for i = 1, 5 do
        if sObj[questsucc[i][2]] == 200 then
            result = i
            break
        end
    end 
    
    if result ~= 0 then
        return
    end
    
    for i = 1, 5 do
        if argObj.RaceType == questsucc[i][1] and sObj[questsucc[i][2]] == 1 then
            result = i
            break
        end
    end

    if result == 0 then
        return
    elseif result >= 1 then
        PlaySound(pc, 'quest_success_2')
        local tx = TxBegin(pc)
        TxSetIESProp(tx, sObj, questsucc[result][2], 200);
    	local ret = TxCommit(tx)
    end
end

function SCR_EV_OBSERVER_QUEST(self,pc)
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local EventDay = 'PlayTimeEventPlayMin'
    local EventCount = 'PlayTimeEventRewardCount'
    local questTable = { 
        'EV_OBSERVER1', 'EV_OBSERVER2', 'EV_OBSERVER3', 'EV_OBSERVER4', 'EV_OBSERVER5'
    }
    
    local result, num = 0, 0
    local now_time = os.date('*t')
    local year = now_time['year']
    local yday = now_time['yday']
    
    if aObj.PlayTimeEventRewardCount >= 10 then
        ShowOkDlg(pc, 'EV_TREASURE_DESC_05', 1)
        return
    end
    
    if aObj.PlayTimeEventPlayMin == year..'/'..yday then
        ShowOkDlg(pc, 'EV_OBSERVER_ING', 1)
        return
    end

    for i = 1, 5 do
        if sObj[questTable[i]] == 1 then
            result = 1
        end
        
        if sObj[questTable[i]] == 200 then
            result = 2
            num = i
            break
        end
    end
    
    if result == 1 then
        ShowOkDlg(pc, 'EV_OBSERVER_DESC', 1)
        return
    end

    if result == 2 then
        local reward = {
            {'Premium_boostToken_14d', 1 },
            {'Moru_Silver', 1 },
            {'Premium_Enchantchip', 2 },
            {'Premium_boostToken_14d', 2 },
            {'Premium_eventTpBox_20', 1 },
            {'Premium_boostToken_14d', 3 },
            {'Moru_Silver', 1 },
            {'Premium_Enchantchip', 3 },
            {'Premium_boostToken_14d', 4 },
            {'ABAND01_115', 1 }
        }
        ShowOkDlg(pc, 'EV_OBSERVER_SUCC', 1)
        local tx = TxBegin(pc)
        TxGiveItem(tx, reward[aObj.PlayTimeEventRewardCount + 1][1], reward[aObj.PlayTimeEventRewardCount + 1][2], "160809_EVENT");
        TxSetIESProp(tx, sObj, questTable[num], 300);
        TxSetIESProp(tx, aObj, 'PlayTimeEventPlayMin', year..'/'..yday);
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', aObj.PlayTimeEventRewardCount + 1);
    	local ret = TxCommit(tx)
    	
    	return
    end
    
    local select = ShowSelDlg(pc,0, 'EV_OBSERVER_SEL', ScpArgMsg("Yes"), ScpArgMsg("No"))
    
    if select == 1 then
        local rand = IMCRandom(1, 5)
        ShowOkDlg(pc, 'EV_OBSERVER_DESC', 1)
        local tx = TxBegin(pc)
        TxSetIESProp(tx, sObj, questTable[rand], 1);
    	local ret = TxCommit(tx)
    end
end
