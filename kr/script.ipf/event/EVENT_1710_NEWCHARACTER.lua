function SCR_PRE_NPC_EVENT_1710_NEWCHARACTER(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local aObj = GetAccountObj(pc)
    if sObj ~= nil and aObj ~= nil then
        if sObj.EVENT_1710_NEWCHARACTER_CHECK == 1 and aObj.EVENT_1710_NEWCHARACTER_REWARD_COUNT < 3 then
            return 'YES'
        end
    end
    
end

--function SCR_KLAPEDA_USKA_NORMAL_5(self,pc)
--    local selectlog = ShowSelDlg(pc, 0, 'EVENT_1710_NEWCHARACTER_DLG1', ScpArgMsg('Yes'), ScpArgMsg('No'))
--    if selectlog == 1 then
--        local aObj = GetAccountObj(pc)
--        local sObj = GetSessionObject(pc, 'ssn_klapeda')
--        if sObj ~= nil and aObj ~= nil then
--            local tx = TxBegin(pc)
--            TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_1', 1, 'EVENT_1710_NEWCHARACTER')
--            TxSetIESProp(tx, aObj, 'EVENT_1710_NEWCHARACTER_REWARD_COUNT', aObj.EVENT_1710_NEWCHARACTER_REWARD_COUNT + 1)
--            TxSetIESProp(tx, sObj, 'EVENT_1710_NEWCHARACTER_CHECK', sObj.EVENT_1710_NEWCHARACTER_CHECK + 1)
--            local ret = TxCommit(tx)
--            if ret == 'SUCCESS' then
--                ShowOkDlg(pc, 'EVENT_1710_NEWCHARACTER_DLG2', 1)
--            end
--        end
--    end
--end


function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_2', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Mic', 10, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD03_106_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_106_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_104_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF02_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_104_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_124_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_124_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')

    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_3', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Drug_PvP_MSPD3_TA', 20, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_Drug_Alche_HP15', 50, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_Drug_Alche_SP15', 50, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD02_109_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_107_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF02_119_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_106_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC03_107_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'SPR03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSP02_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_106_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_106_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_4', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Premium_indunReset_1add', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 3, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_4(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_5', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD03_102_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC02_124_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'SPR03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSP03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_121_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_121_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_5(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_6', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_drug_steam_1h', 20, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_Drug_Alche_HP15', 50, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_Drug_Alche_SP15', 50, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_Enchantchip14', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_6(pc)
    local point = TryGetProp(pc, 'AbilityPoint')
     if point == 'None' then
        point = '0';
    end
    local addPoint = point + 2000
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_7', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_boostToken_14d', 2, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Goddess_Statue', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxSetIESProp(tx, pc, 'AbilityPoint', addPoint);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
       AbilityPointMongoLog(pc, addPoint, point, 0, 'EVENT_1710_NEWCHARACTER'); 
    end    
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_7(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_8', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Premium_indunReset', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 3, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_113_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_111_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC03_111_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'SPR03_107_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSP03_107_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_142_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_142_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_8(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_9', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Goddess_Statue', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_boostToken_14d', 4, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'R_Premium_boostToken02', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_Enchantchip14', 3, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_9(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_10', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_111_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF03_105_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_112_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_108_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC03_103_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'SPR03_109_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSP03_109_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'RAP03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_151_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_151_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_11', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Premium_indunReset', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 3, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_11(pc)
    local point = TryGetProp(pc, 'AbilityPoint')
     if point == 'None' then
        point = '0';
    end
    local addPoint = point + 2000
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_12', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_boostToken_14d', 8, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'R_Premium_boostToken03', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Goddess_Statue', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxSetIESProp(tx, pc, 'AbilityPoint', addPoint);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
       AbilityPointMongoLog(pc, addPoint, point, 0, 'EVENT_1710_NEWCHARACTER'); 
    end    
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_12(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_13', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'SWD03_116_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSW03_117_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'STF03_114_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSF03_109_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TBW03_109_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'BOW03_110_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MAC03_116_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'SPR03_112_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TSP03_112_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'RAP03_102_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'MUS03_101_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'TOP01_155_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'LEG01_155_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_13(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_14', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, '161215Event_Seed_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Premium_indunReset', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 3, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_14(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_15', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxGiveItem(tx, 'Moru_Gold_EVENT_1710_NEWCHARACTER', 1, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_misc_gemExpStone_randomQuest4', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_boostToken_14d', 8, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Premium_dungeoncount_Event', 3, 'EVENT_1710_NEWCHARACTER')
    TxGiveItem(tx, 'Event_1704_Goddess_Statue', 1, 'EVENT_1710_NEWCHARACTER')
    local ret = TxCommit(tx);
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_15(pc)
    local point = TryGetProp(pc, 'AbilityPoint')
     if point == 'None' then
        point = '0';
    end
    local addPoint = point + 5000
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_BOX_16', 1, 'EVENT_1710_NEWCHARACTER')
    
    TxSetIESProp(tx, pc, 'AbilityPoint', addPoint);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
       AbilityPointMongoLog(pc, addPoint, point, 0, 'EVENT_1710_NEWCHARACTER'); 
    end    
end
function SCR_USE_EVENT_1710_NEWCHARACTER_BOX_16(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if sObj ~= nil then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        local nowDate = year..'/'..month..'/'..day..'/'..hour..'/'..min
    
        local tx = TxBegin(pc);
        TxSetIESProp(tx, sObj, 'EVENT_1710_NEWCHARACTER_TPBOX_DATE', nowDate)
        TxGiveItem(tx, 'EVENT_1710_NEWCHARACTER_TPBOX', 1, 'EVENT_1710_NEWCHARACTER')
        local ret = TxCommit(tx);
    end
end

function SCR_PRE_EVENT_1710_NEWCHARACTER_TPBOX(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if sObj ~= nil then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        if sObj.EVENT_1710_NEWCHARACTER_TPBOX_DATE ~= 'None' then
            local nowMin = SCR_DATE_TO_YMIN_BASIC_2000(year, month, day, hour, min)
            local lastDate = SCR_STRING_CUT(sObj.EVENT_1710_NEWCHARACTER_TPBOX_DATE)
            local lastMin = SCR_DATE_TO_YMIN_BASIC_2000(lastDate[1], lastDate[2], lastDate[3], lastDate[4], lastDate[5])
            local nextMin = 60*24*7
            
            if lastMin + nextMin <= nowMin then
                return 1
            else
                local remainTime = lastMin + nextMin - nowMin
                local remainDay = math.floor(remainTime/(60*24))
                local remainHour = math.floor(remainTime%(60*24)/60)
                local remainMin = math.floor(remainTime%(60*24)%60)
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1710_NEWCHARACTER_MSG1","DAY",remainDay,"HOUR",remainHour,"MIN",remainMin), 10);
                return 0
            end
        end
    end
    return 0
end

function SCR_USE_EVENT_1710_NEWCHARACTER_TPBOX(pc)
	local aobj = GetAccountObj(pc);
	if aobj ~= nil then
        local tx = TxBegin(pc);
    	TxAddIESProp(tx, aobj, "GiftMedal", 100, "EVENT_1710_NEWCHARACTER_TPBOX");
    	local ret = TxCommit(tx);
    	if ret == 'SUCCESS' then
    	    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("EVENT_1710_NEWCHARACTER_MSG2","ITEM",GetClassString('Item','EVENT_1710_NEWCHARACTER_TPBOX','Name'),"TP",100), 10)
        end
    end
end
