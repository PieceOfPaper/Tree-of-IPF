function treasureBox_buff_event_act(self, pc, argNum, evt)
    PlayAnimLocal(pc, pc, 'KICKBOX', 0);
	PlayAnimLocal(self, pc, 'OPENED', 1);
	sleep(900);
	
	local tx = TxBegin(pc);

	TxChangeNPCState(tx, evt.genType, -1);
	
    SCR_GETBOXBUFF(self, pc, argNum, evt)
--	SCR_EVENTEXPUP(self, pc, tx, expcount)
	
	local ret = TxCommit(tx);
	
	sleep(2000);
	PlayAnimLocal(self, pc, 'CLOSE', 0);
end

function treasureBox_event_act(self, pc, argNum, evt, itemname, moneycount)

    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
		if xac_ssn == nil then
			return;
		end

    	xac_ssn.Step1 = 3500
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return;
    end
    
    PlayAnimLocal(pc, pc, 'KICKBOX', 0);
	PlayAnimLocal(self, pc, 'OPENED', 1);
	sleep(900);
	
	local tx = TxBegin(pc);

	TxChangeNPCState(tx, evt.genType, -1);
    
    if itemname ~= nil and moneycount ~= nil then
    	TxGiveItem(tx, itemname, moneycount, "OperGive");
    end

--	SCR_EVENTEXPUP(self, pc, tx, expcount)

	local ret = TxCommit(tx);
	DestroySessionObject(pc, xac_ssn)
	sleep(2000);
--	PlayAnimLocal(self, pc, 'CLOSE', 0);
end

function treasureBox_event_dir_act(self, pc, argNum, evt, itemname, moneycount)
    
	PlayAnimLocal(self, pc, 'SHAKEOPEN', 1);
	sleep(900);
	
	local tx = TxBegin(pc);

--	TxChangeNPCState(tx, evt.genType, -1);
    
    if itemname ~= nil and moneycount ~= nil then
    	TxGiveItem(tx, itemname, moneycount,"OperGive");
    end

	local ret = TxCommit(tx);
	
	sleep(2000);
end



function SCR_EVENTEXPUP(self, pc, tx, multiple)
    
    SCR_MAP_EVENT_REWARD_ONESHOT(pc)
    
    if multiple == nil or multiple == 0 then
        multiple = 1
    end
    
    local exp_num = math.floor(GetClassNumber('Map', GetZoneName(pc),'EventExp') * multiple)
    
    if exp_num ~= nil and exp_num > 0 then
        local x, y, z = GetPos(self)
        if x ~= nil then
            PlayExpEffectByPos(pc,"exp", exp_num, x, y, z)
        end
        TxGiveExp(tx, exp_num)
        PlayExpText(pc, exp_num)
--        SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', exp_num..ScpArgMsg("Auto__KyeongHeomChi_HoegDeug"), 2)
    end
end

function XAC_EVENTEXPUP(pc, x, y, z, tx, multiple)
    
    SCR_MAP_EVENT_REWARD_ONESHOT(pc)
    
    if multiple == nil or multiple == 0 then
        multiple = 1
    end
    
    local exp_num = math.floor(GetClassNumber('Map', GetZoneName(pc),'EventExp') * multiple)
    
    if exp_num ~= nil and exp_num > 0 then
        if x ~= nil then
            PlayExpEffectByPos(pc,"exp", exp_num, x, y, z)
        end
        TxGiveExp(tx, exp_num)
        PlayExpText(pc, exp_num)
--        SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', exp_num..ScpArgMsg("Auto__KyeongHeomChi_HoegDeug"), 2)
    end
end

function GIVE_EVENTEXPUP_ITEM_TX(self, pc, item, count, giveWay)
	local tx = TxBegin(pc);
    TxGiveItem(tx, item, count, giveWay);    
    SCR_EVENTEXPUP(self, pc, tx)
    
	local ret = TxCommit(tx);
end
