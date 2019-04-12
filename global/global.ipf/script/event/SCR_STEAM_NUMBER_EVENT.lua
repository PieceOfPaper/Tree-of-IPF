function SCR_EV_NUMBER_QUEST(slef, pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local yday = now_time['yday']
    local aObj = GetAccountObj(pc)
    local qCount = GetInvItemCount(pc, 'Event_160913_1')

    if aObj.PlayTimeEventRewardCount >= 20 then
        ShowOkDlg(pc, 'EV_TREASURE_DESC_05', 1)
        return
    elseif year..'/'..yday == aObj.PlayTimeEventPlayMin then
        ShowOkDlg(pc, 'EV_NUMBER_DESC3', 1)
        return
    elseif qCount < 5 then
        ShowOkDlg(pc, 'EV_NUMBER_DESC2', 1)
        return
    end

    if aObj.DailyTimePoint == 0 then
        local rand = IMCRandom(1, 10)
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'DailyTimePoint', rand)
        TxSetIESProp(tx, aObj, 'DailyTime_ResetTime', 0)
    	local ret = TxCommit(tx)
    end
--    local select = ShowSelDlg(pc, 0, 'EV_NUMBER_SEL1', '1', '2', ScpArgMsg('KLAIPE_HQ_01_MSG03'), ScpArgMsg('KLAIPE_HQ_01_MSG04'), 
--    ScpArgMsg('KLAIPE_HQ_01_MSG05'), ScpArgMsg('KLAIPE_HQ_01_MSG06'), ScpArgMsg('Number7'), ScpArgMsg('Number8'), ScpArgMsg('Number9'), ScpArgMsg('Number10'))

    local select = ShowSelDlg(pc, 0, 'EV_NUMBER_SEL1', '1', '2','3', '4', '5', '6', '7', '8', '9', '10' )
    
    if select == nil then
        return
    elseif select == aObj.DailyTimePoint then
        local reward = {
            {'Drug_Premium_HP1',            50 },
            {'GIMMICK_Drug_PMATK1',          5 },
            {'Drug_Premium_SP1',            50 },
            {'GIMMICK_Drug_PMDEF1',          5 },
            {'NECK99_102',                   1 }, -- 5
            {'RestartCristal',               3 },
            {'GIMMICK_Drug_PMATK1',         10 },
            {'Premium_repairPotion',         5 },
            {'GIMMICK_Drug_PMDEF1',         10 },
            {'Premium_boostToken',           2 }, -- 10
            {'Premium_Enchantchip14',        2 },
            {'Moru_Silver',                  1 },
            {'Premium_WarpScroll_bundle10',  1},
            {'Premium_Enchantchip14',        3 },
            {'Premium_boostToken',           3 }, -- 15
            {'Premium_eventTpBox_20',        1 },
            {'Premium_indunReset_14d',       2 },
            {'PremiumToken_1d',              1 },
            {'misc_gemExpStone_randomQuest4', 1 },
            {'Hat_628096',                   1 } -- 20
        }
        
        --print(aObj.PlayTimeEventRewardCount, aObj.PlayTimeEventRewardCount, aObj.DailyTimePoint, aObj.PlayTimeEventPlayMin)
        --print(reward[aObj.PlayTimeEventRewardCount + 1][1], reward[aObj.PlayTimeEventRewardCount + 1][2])

        local tx = TxBegin(pc)
        if aObj.PlayTimeEventRewardCount == 9 then
            TxGiveItem(tx, 'R_Premium_boostToken02', 5, "160913_EVENT_ADD")
        elseif aObj.PlayTimeEventRewardCount == 14 then
            TxGiveItem(tx, 'R_Premium_boostToken03', 5, "160913_EVENT_ADD")
        end
        TxGiveItem(tx, reward[aObj.PlayTimeEventRewardCount + 1][1], reward[aObj.PlayTimeEventRewardCount + 1][2], "160913_EVENT");
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', aObj.PlayTimeEventRewardCount + 1)
        TxSetIESProp(tx, aObj, 'DailyTimePoint', 0)
        TxSetIESProp(tx, aObj, 'PlayTimeEventPlayMin', year..'/'..yday)
        if aObj.Event_HiddenReward == 0 then
            TxAddAchievePoint(tx, 'TheLuckyNumber', 1)
            TxSetIESProp(tx, aObj, 'Event_HiddenReward', 2)
        end
        if aObj.Event_HiddenReward == 1 then
            TxSetIESProp(tx, aObj, 'Event_HiddenReward', 0)
        end
        TxTakeItem(tx, 'Event_160913_1', 5, "160913_TAKEITEM");
    	local ret = TxCommit(tx)
    	if ret == 'FAIL' then
    	    ShowOkDlg(pc, 'EV_QUESTITEM_LOCK', 1)
    	else
    	    ShowOkDlg(pc, 'EV_NUMBER_RESULT1', 1)
    	end
    elseif select < aObj.DailyTimePoint then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'Event_HiddenReward', 1)
        TxTakeItem(tx, 'Event_160913_1', 5, "160913_TAKEITEM");
        local ret = TxCommit(tx)
        if ret == 'FAIL' then
    	    ShowOkDlg(pc, 'EV_QUESTITEM_LOCK', 1)
    	else
    	    ShowOkDlg(pc, 'EV_NUMBER_RESULT2', 1)
    	end
    elseif select > aObj.DailyTimePoint then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'Event_HiddenReward', 1)
        TxTakeItem(tx, 'Event_160913_1', 5, "160913_TAKEITEM");
        local ret = TxCommit(tx)
        if ret == 'FAIL' then
    	    ShowOkDlg(pc, 'EV_QUESTITEM_LOCK', 1)
    	else
    	    ShowOkDlg(pc, 'EV_NUMBER_RESULT3', 1)
    	end
    end
end

function SCR_EVENT_NUMBER_DROPITEM(pc, sObj, msg, argObj, argStr, argNum)
    if argObj.ClassID >= 45132 and argObj.ClassID <= 45136 then
        local rand = IMCRandom(1, 5)
        
        if rand >= 3 then
            local tx = TxBegin(pc);
			TxGiveItem(tx, 'Event_160913_1', 1, "160913_DROPITEM");
			local ret = TxCommit(tx);
        end
    end
end