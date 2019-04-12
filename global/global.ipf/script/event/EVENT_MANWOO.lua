function S_AI_DEAD_BUFF_RANGE_2(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
    local time = 3600000
    local objList, objCount = SelectObjectNear(self, self, 180, 'ENEMY');		
    for i = 1, objCount do
	    local obj = objList[i];
	    if obj.ClassName == 'PC' then
	        ADDBUFF(self, obj, 'Event_ManWoo_2', 0, 0, time, 1);
	    end
	end	 
end

function SCR_BUFF_ENTER_Event_ManWoo_2(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 5
end

function SCR_BUFF_LEAVE_Event_ManWoo_2(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 5
end

function SCR_EVENT_MANWOO_TS_BORN_ENTER(self)
end

function SCR_EVENT_MANWOO_TS_BORN_UPDATE(self)
--    if self.NumArg1 < 40 then
--        local heal = math.floor(self.MHP/4)
--        AddHP(self, heal)
--        self.NumArg1 = self.NumArg1+ 1
--    elseif self.NumArg1 >= 40 and self.NumArg1 < 60 then
--        self.NumArg1 = self.NumArg1+ 1
--    elseif self.NumArg1 >= 40 then
--        self.NumArg1 = 0
--    end
--    HOLD_MON_SCP(self, 2000);
end

function SCR_EVENT_MANWOO_TS_BORN_LEAVE(self)
end

function SCR_EVENT_MANWOO_TS_DEAD_ENTER(self)
S_AI_DEAD_BUFF_RANGE_2(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
end

function SCR_EVENT_MANWOO_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_MANWOO_TS_DEAD_LEAVE(self)
end

--item
function SCR_PRECHECK_MANWOO(self)
	if OnKnockDown(self) == 'NO' and GetRidingCompanion(self) == nil and IsBuffApplied(self, 'HangingShot') == 'NO' then --Unavailable while riding on companion
		return 1;
	end
	SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('ManWoo_1'), 5)
	return 0;
end

function SCR_BUFF_ENTER_Event_ManwooBuff1(self, buff, arg1, arg2, over)
    local rand = IMCRandom(1, 100)
    if rand >= 1 and rand <= 25 then
        AddBuff(self, self, 'Event_ManWoo_1', 1, 0, 180000, 1);
    elseif rand > 25 and rand <=50 then
        PlayEffect(self, 'I_emo_sleep', 1)
        PlayAnim(self, 'STUN', 1)
    elseif rand > 50 and rand <=75 then
        PlayEffect(self, 'F_pc_level_up', 4)
    elseif rand > 70 and rand <=100 then
        PlayAnim(self, 'KNOCKDOWN_BOUNCE', 2)
    end
end

function SCR_BUFF_UPDATE_Event_ManwooBuff1(self, buff, arg1, arg2, over)
    if RemainTime > 180000 then
        SetBuffRemainTime(self, buff.ClassName, 180000)
    end
    return 1
end

--function SCR_USE_ITEM_Event_ManwooBuff2(self,argObj,BuffName,arg1,arg2)
--    PlayEffect(self, 'I_emo_sleep', 1)
--    PlayAnim(self, 'STUN', 1)--sleep
--end
--
--function SCR_USE_ITEM_Event_ManwooBuff3(self,argObj,BuffName,arg1,arg2)
--    PlayEffect(self, 'F_pc_level_up', 4)--level up
--end
--
--function SCR_USE_ITEM_Event_ManwooBuff4(self,argObj,BuffName,arg1,arg2)
--    PlayAnim(self, 'KNOCKDOWN_BOUNCE', 2)--dead
--end

--dialog
function SCR_NPC_EVENT_MANWOO1_DIALOG(self, pc)
    ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG1', 1)
end

function SCR_NPC_EVENT_MANWOO2_DIALOG(self, pc)
    ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG2', 1)
end

function SCR_NPC_EVENT_MANWOO3_DIALOG(self, pc)
    ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG3', 1)
end

--companion
function SCR_BUFF_ENTER_Event_ManWoo_Pet_1(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'Event_ManWoo_Pet_2', 1, 0, 0, 1);    
end

function SCR_BUFF_LEAVE_Event_ManWoo_Pet_1(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'Event_ManWoo_Pet_2');
end

--npc
function SCR_NPC_EVENT_MANWOO_DIALOG(self, pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local now_time = os.date('*t')
    local yday = now_time['yday']
    if sObj.EVENT_VALUE_SOBJ04 >= 1 then
        ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG7', 1)
        if sObj.EVENT_VALUE_SOBJ06 == yday then
        ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG9', 1)
        return
        end
        local tx = TxBegin(pc) 
        TxGiveItem(tx, "Event_ManWoo_1", 50, "MANWOO_CUBE")
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ04', sObj.EVENT_VALUE_SOBJ04 + 1)
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ06', yday)
        local ret = TxCommit(tx)
        ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG8', 1)
        return
    end
    local select2 = ShowSelDlg(pc, 0, 'NPC_EVENT_MANWOO_DLG4', ScpArgMsg("ManWoo_2"), ScpArgMsg("Auto_DaeHwa_JongLyo"))  
    if select2 == 1 then
        ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG5', 1)
        local tx = TxBegin(pc) 
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ05', sObj.EVENT_VALUE_SOBJ05 + 1)
        local ret = TxCommit(tx)
    end    
end

--npc enter/ leave
function SCR_EVENT_MANWOO_NPC_ENTER(self, pc)
end

function SCR_EVENT_MANWOO_NPC_LEAVE(self, pc)
local sObj = GetSessionObject(pc, 'ssn_klapeda')
local manwoo = GetInvItemCount(pc, "Event_ManWooCube_1")    
    if manwoo == 0 then
        if sObj.EVENT_VALUE_SOBJ05 >= 1 then
            ShowOkDlg(pc, 'NPC_EVENT_MANWOO_DLG6', 1)
            local tx = TxBegin(pc)
            TxGiveItem(tx, "Event_ManWooCube_1", 1, "MANWOO_CUBE")
            TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ04', sObj.EVENT_VALUE_SOBJ04 + 1)
            local ret = TxCommit(tx)
        end
    end
end