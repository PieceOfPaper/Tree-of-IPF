function SCR_ADD_KILL_WHALE(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
    local objList, objCount = GetWorldObjectList(self, "PC", 200)
    local time = 3600000
    for i = 1, objCount do
        local obj = objList[i];
        if obj.ClassName == 'PC' then
            ADDBUFF(self, obj, 'Event_Golden_Whale_1', 0, 0, time, 1);
            if IsBuffApplied(obj, 'Event_Golden_Whale_2') == 'YES' then
                RemoveBuff(obj, 'Event_Golden_Whale_2')
            end
        end
    end
end

function SCR_GOLDEN_WHALE_EVENT_DIALOG(self,pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_GOLDEN_WHALE_1', ScpArgMsg("Event_GOLDEN_WHALE_2"), ScpArgMsg("Cancel"))
    if select == 1 then
        if  aObj.EV170711_GOLDEN_WHALE_2 ~= yday then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EV170711_GOLDEN_WHALE_1', 0);
            TxSetIESProp(tx, aObj, 'EV170711_GOLDEN_WHALE_2', yday);
            local ret = TxCommit(tx)
        elseif aObj.PlayTimeEventPlayMin ~= 'EVENT_GOLDEN_WHALE' and yday == 193 then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EV170711_GOLDEN_WHALE_1', 0);
            TxSetIESProp(tx, aObj, 'PlayTimeEventPlayMin', 'EVENT_GOLDEN_WHALE');
            local ret = TxCommit(tx)
        end
        
        if aObj.EV170711_GOLDEN_WHALE_1 > 3 and aObj.EV170711_GOLDEN_WHALE_2 == yday then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
            return
        end
        if IsBuffApplied(pc, 'Event_Golden_Whale_1') == 'YES' and IsBuffApplied(pc, 'Event_Golden_Whale_2') == 'NO' then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Event_Golden_Whale_Box', 1, 'Event_Golden_Whale');
            TxSetIESProp(tx, aObj, 'EV170711_GOLDEN_WHALE_1', aObj.EV170711_GOLDEN_WHALE_1 + 1);
            TxSetIESProp(tx, aObj, 'EV170711_GOLDEN_WHALE_2', yday);
            local ret = TxCommit(tx)
            if ret == "SUCCESS" then
                local buff = GetBuffByName(pc, 'Event_Golden_Whale_1')
                local remainTime = GetBuffRemainTime(buff);
                AddBuff(self, pc, 'Event_Golden_Whale_2', 1, 0, remainTime, 1);
            end            
        elseif IsBuffApplied(pc, 'Event_Golden_Whale_1') == 'NO' then
            ShowOkDlg(pc, 'NPC_EVENT_GOLDEN_WHALE_2', 1)
            return
        elseif IsBuffApplied(pc, 'Event_Golden_Whale_1') == 'YES' and  IsBuffApplied(pc, 'Event_Golden_Whale_2') == 'YES' then
            ShowOkDlg(pc, 'NPC_EVENT_GOLDEN_WHALE_3', 1)
            return   
        end
    end  
end

function SCR_BUFF_ENTER_Event_Golden_Whale_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3;
    self.MaxSta_BM = self.MaxSta_BM + 20
end

function SCR_BUFF_UPDATE_Event_Golden_Whale_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Event_Golden_Whale_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3;
    self.MaxSta_BM = self.MaxSta_BM - 20
end

function SCR_BUFF_ENTER_Event_Golden_Whale_2(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Event_Golden_Whale_2(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Event_Golden_Whale_2(self, buff, arg1, arg2, over)
end

function SCR_EVENT_GOLDEN_WHALE_TS_BORN_ENTER(self)
end

function SCR_EVENT_GOLDEN_WHALE_TS_BORN_UPDATE(self)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']
    local sec = now_time['sec']
    local timeTable = {
        0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24
    }
    
    local _obj = GetScpObjectList(self, 'EVENT_GOLDEN_WHALE')
    if #_obj == 0 and self.NumArg1 ~= hour then
        for i = 1, #timeTable do
            if timeTable[i] == hour and (min >= 0 and min <= 30) then  
                local x, z, y = GetPos(self)
                local mon = CREATE_MONSTER_EX(self, 'boss_stone_whale_orange_E1', x, y, z, 0, 'Monster');
                AddScpObjectList(self, 'EVENT_GOLDEN_WHALE', mon)
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 3600);
                self.NumArg1 = hour
                break
            end
        end
    elseif #_obj >= 2 then
        for j = 2, #_obj do
            Kill(_obj[j])
        end
    end
end

function SCR_EVENT_GOLDEN_WHALE_TS_BORN_LEAVE(self)
end

function SCR_EVENT_GOLDEN_WHALE_TS_DEAD_ENTER(self)
end

function SCR_EVENT_GOLDEN_WHALE_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_GOLDEN_WHALE_TS_DEAD_LEAVE(self)
end

function SCR_CREATE_GOLDEN_WHALE_DIALOG(self,pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']
    local sec = now_time['sec']
    local timeTable = {
        0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24
    }
    
    local _obj = GetScpObjectList(self, 'EVENT_GOLDEN_WHALE')
 
    if #_obj == 0 and self.NumArg1 ~= hour then
        for i = 1, #timeTable do
            if timeTable[i] == hour and (min >= 0 and min <= 30) then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("KATYN14_SUB_08_MSG03"), '#SITGROPESET', 5)
                if result == 1 then
                  local x, z, y = GetPos(self)
                  local mon = CREATE_MONSTER_EX(self, 'boss_stone_whale_orange_E1', x, y, z, 0, 'Monster');
                  AddScpObjectList(self, 'EVENT_GOLDEN_WHALE', mon)
                  EnableAIOutOfPC(mon)
                  SetLifeTime(mon, 3600);
                  self.NumArg1 = hour
                end
                break
            end
        end
    elseif #_obj >= 2 then
        for j = 2, #_obj do
            Kill(_obj[j])
        end
    end
end