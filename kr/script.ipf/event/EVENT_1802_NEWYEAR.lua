function SCR_USE_EVENT_1802_NEWYEAR_FORTUNEPOUCH(self,argObj,BuffName,arg1,arg2)
    local count = IMCRandom(50,150)
    local tx = TxBegin(self);
    TxEnableInIntegrate(tx);
    TxGiveItem(tx, 'EVENT_1802_NEWYEAR_GOLDCOIN', count, "EVENT_1802_NEWYEAR_FORTUNEPOUCH")
    local ret = TxCommit(tx);
end


--function SCR_EVENT_1802_NEWYEAR_MONKILL(self, sObj, msg, argObj, argStr, argNum)
--    if IsIndun(self) == 1 or IsPVPServer(self) == 1 or IsMissionInst(self) == 1 then
--        return
--    end
--    if argObj.Lv < 50 then
--        return
--    end
--    if argObj.Lv < self.Lv - 30 or argObj.Lv > self.Lv + 30 then
--        return
--    end
--    local targetRate = 1
--    if argObj.Lv > 100 then
--        targetRate = 9
--    end
--    if IMCRandom(1, 100) <= targetRate then
--        local curMap = GetZoneName(self);
--        local mapCls = GetClass("Map", curMap);
--        
--        if IS_BASIC_FIELD_DUNGEON(self) == 'YES' then
--            local tx = TxBegin(self);
--            TxGiveItem(tx, 'EVENT_1802_NEWYEAR_GOLDCOIN', 1, "EVENT_1802_NEWYEAR_FIELD")
--            local ret = TxCommit(tx);
--        end
--    end
--end

function SCR_EVENT_1802_NEWYEAR_NPC_DIALOG(self, pc)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    local nowDate = year..'/'..month..'/'..day
--    
--    local aObj = GetAccountObj(pc)
--    if aObj == nil then
--        return
--    end
--    
--    local select = ShowSelDlg(pc, 0, 'EVENT_1802_NEWYEAR_DLG1', ScpArgMsg('EVENT_1802_NEWYEAR_MSG1'), ScpArgMsg('EventShop'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    if select == 1 then
--        if aObj.EVENT_1802_NEWYEAR_FORTUNEPOUCH_DATE ~= nowDate then
--            local tx = TxBegin(pc);
--            TxGiveItem(tx, 'EVENT_1802_NEWYEAR_FORTUNEPOUCH', 1, "EVENT_1802_NEWYEAR_NPC")
--            TxSetIESProp(tx, aObj, "EVENT_1802_NEWYEAR_FORTUNEPOUCH_DATE", nowDate)
--            local ret = TxCommit(tx);
--        else
--            ShowOkDlg(pc, 'EVENT_1802_NEWYEAR_DLG2', 1)
--            return
--        end
--    elseif select == 2 then
--        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP3_OPEN()")
--    end
end


function SCR_USE_EVENT_1802_NEWYEAR_ACHIEVE(self,argObj,BuffName,arg1,arg2)
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, 'EVENT_1802_NEWYEAR_ACHIEVE', 1)
    local ret = TxCommit(tx);
end

function SCR_PRE_EVENT_1802_NEWYEAR_ACHIEVE(self)
    local value = GetAchievePoint(self, 'EVENT_1802_NEWYEAR_ACHIEVE')
    if value == 0 then
        return 1
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1802_NEWYEAR_MSG2"), 5);
    end
    
    return 0;
end
