
function SCR_GODDESS_STATUE_EV_TS_BORN_ENTER(self)
end

function SCR_GODDESS_STATUE_EV_TS_BORN_UPDATE(self)
end

function SCR_GODDESS_STATUE_EV_TS_BORN_LEAVE(self)
end

function SCR_GODDESS_STATUE_EV_TS_DEAD_ENTER(self)
end

function SCR_GODDESS_STATUE_EV_TS_DEAD_UPDATE(self)
end

function SCR_GODDESS_STATUE_EV_TS_DEAD_LEAVE(self)
end

function SCR_GODDESS_STATUE_EV_DIALOG(self, pc) 
    local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_KyeongBae_Jung"), 'WORSHIP', 30)
    if result == 1 then
        if IsBuffApplied(pc, 'Event_Goddess') == 'YES' then
            RemoveBuff(pc, 'Event_Goddess');
        end
        PlayEffect(self, "F_buff_basic025_white_line", 1)
        AddBuff(self, pc, "Event_Goddess", 1, 0, 1800000, 1);
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('Goddess_Statue1'), 5)
    end
end

function SCR_BUFF_ENTER_Event_Goddess(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 1
	self.RSP_BM = self.RSP_BM + 77;
    self.RHP_BM = self.RHP_BM + 42
	local addMhp = self.MHP * 0.1
	SetExProp(buff, "GODDESS_ADD_MHP", addMhp);
	self.MHP_BM = self.MHP_BM + addMhp
end

function SCR_BUFF_LEAVE_Event_Goddess(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1
    self.RSP_BM = self.RSP_BM - 77;
    self.RHP_BM = self.RHP_BM - 42;
	local removeMhp = GetExProp(buff, "GODDESS_ADD_MHP");
	self.MHP_BM = self.MHP_BM - removeMhp
end

function SCR_USE_ITEM_GODDESS_STATUE(pc)
    local posRandom = IMCRandom(10, 40)
    local x, y, z = GetFrontPos(pc, posRandom);
    --CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog)
    local npc = CREATE_NPC(pc, 'farm47_statue_zemina_small', x, y, z, -45, "Neutral", GetLayer(pc), GetName(pc), 'GODDESS_STATUE_EV', nil, nil, 1, nil, 'GODDESS_STATUE_EV')   	    
    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('Goddess_Statue3'), 5)
    SetLifeTime(npc, 300)
end

function SCR_PRECHECK_GODDESS_EV(pc)
    local x, y, z = GetPos(pc);
	if 0 == IsFarFromNPC(pc, x, y, z, 100) then
		SendSysMsg(pc, "TooNearFromNPC");	
		return 0;
	end
	return 1;
end