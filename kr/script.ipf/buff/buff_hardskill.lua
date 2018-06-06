-- buff_hardskill.lua




-- TimeRuler
function SCR_BUFF_ENTER_TimeRuler(self, buff, arg1, arg2, over)
	
	SaveTimeRulerInfo(self);
end

function SCR_BUFF_UPDATE_TimeRuler(self, buff, arg1, arg2, RemainTime, ret, over)
	
	local caster = GetBuffCaster(buff);	
	if caster == nil then
		return 0;	-- RemoveBuff(self, 'TimeRuler');
	end

	if caster.HP <= 0 then
		return 0;	-- RemoveBuff(self, 'TimeRuler');
	end

	return 1;
end

function SCR_BUFF_LEAVE_TimeRuler(self, buff, arg1, arg2, over)

	if self.HP >= 0 then
		LoadTimeRulerInfo(self);
	end
end


-- TimeReverse
function SCR_BUFF_ENTER_TimeReverse(self, buff, arg1, arg2, over)
	SaveTimeReverse(self)
	SetExProp(buff, 'IS_HOLD', 0);
end

function SCR_BUFF_UPDATE_TimeReverse(self, buff, arg1, arg2, RemainTime, ret, over)
	
	if RemainTime >= arg1/2 then
		SaveTimeReverse(self);
	else
		if GetExProp(buff, 'IS_HOLD') == 0 then
			SetExProp(buff, 'IS_HOLD', 1);			
			HoldMonScp(self);
end

		SkillCancel(self);
		PlayTimeReverse(self, 0);
	end
	return 1;
end

function SCR_BUFF_LEAVE_TimeReverse(self, buff, arg1, arg2, over)
	PlayTimeReverse(self, 1);
	UnHoldMonScp(self);
end

-- Link
function SCR_BUFF_ENTER_Link(self, buff, arg1, arg2, over)
	-- self.MSPD_BM = self.MSPD_BM - (10 * (arg1 + 1));
	SetTakeDamageScp(self, "TAKE_DMG_LINK");
	SetExProp_Str(self, "LINK_BUFF", buff.ClassName);

	local buffCaster = GetBuffCaster(buff);
	if buffCaster ~= nil then
		
		local Archer9_abil = GetAbility(buffCaster, 'Archer9');
		if	Archer9_abil ~= nil then
			local subDef = Archer9_abil.Level * 0.02
			self.DEF_RATE_BM = self.DEF_RATE_BM - subDef;
			SetExProp(buff, 'SUB_DEF_ABIL', subDef);
		end
	end
end

function SCR_BUFF_LEAVE_Link(self, buff, arg1, arg2, over)
	-- self.MSPD_BM = self.MSPD_BM + (10 * (arg1 + 1));
	RemoveTakeDamageScp(self, "TAKE_DMG_LINK");

	local subDef = GetExProp(buff, 'SUB_DEF_ABIL');
	self.DEF_RATE_BM = self.DEF_RATE_BM + subDef;

	local buffCaster = GetBuffCaster(buff);
	if buffCaster ~= nil then
		local linkMemberList = GetLinkObjects(buffCaster, self, buff.ClassName);
		if linkMemberList ~= nil then
			for i = 1 , #linkMemberList do
				local obj = linkMemberList[i];
				if 0 == IsSameObject(obj, self) then
					RemoveBuff(obj, buff.ClassName);
				end
			end
		end

		--LINK_DESTRUCT(buffCaster, buff.ClassName);
	end
end

-- Link
function SCR_BUFF_ENTER_Link_Physical(self, buff, arg1, arg2, over)
	-- self.MSPD_BM = self.MSPD_BM - (10 * (arg1 + 1));
	SetTakeDamageScp(self, "TAKE_DMG_LINK_PHYSICAL");
	SetExProp_Str(self, "LINK_BUFF", buff.ClassName);

	local buffCaster = GetBuffCaster(buff);
	if buffCaster ~= nil then
		
		local linker1_abil = GetAbility(buffCaster, 'Linker1');
		if linker1_abil ~= nil then
	
			local memberCount = 0;
			local linkMemberList = GetLinkObjects(buffCaster, self, buff.ClassName);
			if linkMemberList ~= nil then
				memberCount = #linkMemberList;
			end

			local addDef = (memberCount * linker1_abil.Level) * 0.01;
            self.DEF_RATE_BM = self.DEF_RATE_BM + addDef;
			SetExProp(buff, 'ADD_DEF_ABIL', addDef);
		end
	end
end

function SCR_BUFF_LEAVE_Link_Physical(self, buff, arg1, arg2, over)
	-- self.MSPD_BM = self.MSPD_BM + (10 * (arg1 + 1));
	RemoveTakeDamageScp(self, "TAKE_DMG_LINK_PHYSICAL");

	local addDef = GetExProp(buff, 'ADD_DEF_ABIL');
	self.DEF_RATE_BM = self.DEF_RATE_BM - addDef;

	local buffCaster = GetBuffCaster(buff);
	if buffCaster ~= nil then
		local linkMemberList = GetLinkObjects(buffCaster, self, buff.ClassName);
		if linkMemberList ~= nil then
			for i = 1 , #linkMemberList do
				local obj = linkMemberList[i];
				if 0 == IsSameObject(obj, self) then
					RemoveBuff(obj, buff.ClassName);
				end
			end
		end

		--LINK_DESTRUCT(buffCaster, buff.ClassName);
	end
end

-- Link_Enemy (for enemy attack, do not share damage.)
function SCR_BUFF_ENTER_Link_Enemy(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    SkillTextEffect(nil, self, caster, "SHOW_BUFF_TEXT", buff.ClassID, nil);
    SetTakeDamageScp(self, "TAKE_DMG_LINK_ENEMY");
    SetExProp_Str(self, "LINK_ENEMY_BUFF", buff.ClassName);
    
	-- steam_different
	SET_LINK_ENEMY_COUNT(caster, buff)
	--
    
	local Linker8_abil = GetAbility(caster, "Linker8");
	local Linker9_abil = GetAbility(caster, "Linker9");
	local Linker10_abil = GetAbility(caster, "Linker10");

	local arg3, arg4, arg5 = 0, 0, 0;
	if Linker8_abil ~= nil then
		arg3 = Linker8_abil.Level;
	end

	if Linker9_abil ~= nil then
		arg4 = Linker9_abil.Level;
	end

	if Linker10_abil ~= nil then
		arg5 = Linker10_abil.Level;
	end

	SetBuffArgs(buff, arg3, arg4, arg5);
end

function SET_LINK_ENEMY_COUNT(caster, buff)
    local sklLv = 1;
    local count = 0;
    
    if caster ~= nil then
        local skl = GetSkill(caster, 'Linker_JointPenalty');
        if skl ~= nil then
            sklLv = skl.Level;
            count = math.floor(6.5 + skl.Level * 0.5);
        end
    end

	SetExProp(buff, 'LINK_COUNT', count);

--	local sklLv = 1;
--	local count = 0;
--	
--	if caster ~= nil then
--		local skl = GetSkill(caster, 'Linker_JointPenalty');
--		sklLv = skl.Level;
--		local value = math.floor(6.5 + skl.Level * 0.5);
--		count = value;
--	end
--
--	SetLinkCmdArgByBuff(caster, buff, 'count', count);
end

function SCR_BUFF_LEAVE_Link_Enemy(self, buff, arg1, arg2, over)
	if IsBuffApplied(self, buff.ClassName) == "NO" then
		RemoveTakeDamageScp(self, "TAKE_DMG_LINK_ENEMY");
	end
end

function SCR_BUFF_ENTER_Link_Enemy_Mon(self, buff, arg1, arg2, over)
	SetTakeDamageScp(self, "TAKE_DMG_LINK_ENEMY");
	SetExProp_Str(self, "LINK_ENEMY_BUFF", buff.ClassName);
end

function SCR_BUFF_LEAVE_Link_Enemy_Mon(self, buff, arg1, arg2, over)

	if IsBuffApplied(self, buff.ClassName) == "NO" then
		RemoveTakeDamageScp(self, "TAKE_DMG_LINK_ENEMY");
	end
end


function SCR_GET_MAX_PROP_FOR_PARYT(self, buff)
	local str, con, int, mna, dex = 0, 0, 0, 0, 0;
	local list, count = GetPartyMemberList(self, PARTY_NORMAL, buff.Range);

    	for i = 1, count do
		if str < list[i].STR then
			str = list[i].STR;
    		end
            
		if con < list[i].CON then
		   con = list[i].CON;
    end
	
		if int < list[i].INT then
		   int = list[i].INT;
	end
	
		if mna < list[i].MNA then
		   mna = list[i].MNA;
	end
	
		if dex < list[i].DEX then
		   dex = list[i].DEX;
	end
	end
    
	SetExProp(buff, 'Sacrifice_ADD_STR', str - self.STR);
	SetExProp(buff, 'Sacrifice_ADD_CON', con - self.CON);
	SetExProp(buff, 'Sacrifice_ADD_INT', int - self.INT);
	SetExProp(buff, 'Sacrifice_ADD_MAN', mna - self.MNA);
	SetExProp(buff, 'Sacrifice_ADD_DEX', dex - self.DEX);

	self.STR_BM = self.STR_BM + (str - self.STR);
	self.CON_BM = self.CON_BM + con - self.CON;
	self.INT_BM = self.INT_BM + int - self.INT;
	self.MNA_BM = self.MNA_BM + mna - self.MNA;
	self.DEX_BM = self.DEX_BM + dex - self.DEX; 
end

function SCR_RESET_PROP(self, buff)
	self.STR_BM = self.STR_BM - GetExProp(buff, 'Sacrifice_ADD_STR');
	self.CON_BM = self.CON_BM - GetExProp(buff, 'Sacrifice_ADD_CON');
	self.INT_BM = self.INT_BM - GetExProp(buff, 'Sacrifice_ADD_INT');
	self.MNA_BM = self.MNA_BM - GetExProp(buff, 'Sacrifice_ADD_MAN');
	self.DEX_BM = self.DEX_BM - GetExProp(buff, 'Sacrifice_ADD_DEX');

	DelExProp(buff, 'Sacrifice_ADD_STR', 0);
	DelExProp(buff, 'Sacrifice_ADD_CON', 0);
	DelExProp(buff, 'Sacrifice_ADD_INT', 0);
	DelExProp(buff, 'Sacrifice_ADD_MAN', 0);
	DelExProp(buff, 'Sacrifice_ADD_DEX', 0);
end

function SCR_BUFF_ENTER_Linker_Sacrifice(self, buff, arg1, arg2, over)
--	RemoveBuff(self, 'Linker_Sacrifice')
	RemoveBuff(self, 'Link_Sacrifice')
	RemoveBuff(self, 'Transpose_Buff')

	SCR_GET_MAX_PROP_FOR_PARYT(self, buff);
end

function SCR_BUFF_LEAVE_Linker_Sacrifice(self, buff, arg1, arg2, over)
	SCR_RESET_PROP(self, buff)
end

function SCR_BUFF_ENTER_Link_Sacrifice(self, buff, arg1, arg2, over)
--	RemoveBuff(self, 'Link_Sacrifice')
	RemoveBuff(self, 'Linker_Sacrifice') 
	RemoveBuff(self, 'Transpose_Buff')
	
	SCR_GET_MAX_PROP_FOR_PARYT(self, buff);
end

function SCR_BUFF_LEAVE_Link_Sacrifice(self, buff, arg1, arg2, over)
	SCR_RESET_PROP(self, buff)
end


function SCR_BUFF_ENTER_Link_Party(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Link_Party(self, buff, arg1, arg2, over)
	if IsBuffApplied(self, 'Link_Sacrifice') == "YES" then
	    RemoveBuff(self, 'Link_Sacrifice');
	end
	
	if IsBuffApplied(self, 'Linker_Sacrifice') == "YES" then
	    RemoveBuff(self, 'Linker_Sacrifice');
	end
end

-- PatronSaint
function SCR_BUFF_ENTER_PatronSaint(self, buff, arg1, arg2, over)
    local addrsp = math.floor(self.RSP * 0.5)
    local addrsta = 250
    
    self.RSP_BM = self.RSP_BM + addrsp;
    self.RSta_BM = self.RSta_BM + addrsta;
    
    SetExProp(self, 'ADD_RSP', addrsp);
    SetExProp(self, 'ADD_RSTA', addrsta);
	
		local caster = GetBuffCaster(buff);
	
	if caster ~= nil then
    	local Cleric19_abil = GetAbility(caster, 'Cleric19');
    	
    	local give_target = caster;
    	local take_target = self;
    	
    	if Cleric19_abil ~= nil then
    	    give_target = self;
    	    take_target = caster;
    	end
        
        local Cleric9_abil;
        
        if arg1 ~= 0 then
		AddBuff(self, caster, buff.ClassName, 0, 1, 60000, 1);
            Cleric9_abil = GetAbility(caster, "Cleric9")
        else
            Cleric9_abil = GetAbility(self, "Cleric9")
        end
        
        if Cleric9_abil ~= nil then
            SetExProp(give_target, "SOUL_BUFF_ABIL", Cleric9_abil.Level);
        end
        
        SetExProp(give_target, "SOUL_BUFF_COUNT", arg1 * 3);
        SetExProp_Str(give_target, "SOUL_BUFF", "PATRON_GIVE");
        SetExProp_Str(take_target, "SOUL_BUFF", "PATRON_TAKE");
	end
end

function SCR_BUFF_LEAVE_PatronSaint(self, buff, arg1, arg2, over)
    local addrsp = GetExProp(self, 'ADD_RSP');
    local addrsta = GetExProp(self, 'ADD_RSTA');
    
    self.RSP_BM = self.RSP_BM - addrsp
    self.RSta_BM = self.RSta_BM - addrsta
    
	if arg1 == 0 then
--		RemoveTakeDamageScp(self, "TAKE_DMG_SOUL");
	end

	local caster = GetBuffCaster(buff);	
	if caster ~= nil then
		RemoveBuffByCaster(caster, self, buff.ClassName);
	end
	
	DelExProp(self, 'ADD_RSP', 0);
	DelExProp(self, 'ADD_RSTA', 0);
	DelExProp(self, 'SOUL_BUFF_ABIL', 0);
	DelExProp(self, 'SOUL_BUFF_COUNT', 0);
end

function TAKE_DMG_SOUL(self, from, skl, damage, ret)

	if ret == nil or GetStructIndex(ret) > 0 then
		return;
	end
	
	if IMCRandom(1, 2) == 1 then
		return
	end

	local buffName = GetExProp_Str(self, "SOUL_BUFF");
	local buff = GetBuffByName(self, buffName);
	local caster = GetBuffCaster(buff);
	if caster == nil then
		return;
	end
		
	local casterHP = caster.HP;
	local myDamage = 0;

	if damage > casterHP then
		myDamage = damage - casterHP;
		damage = casterHP;
	end

	ret.Damage = myDamage;

	if ret.Damage <= 0 then
		NO_HIT_RESULT(ret);
	end

	local key = GetSkillSyncKey(self, ret);
	StartSyncPacket(self, key);
	local abil = GetAbility(self, "Cleric9")
	if abil ~= nil then
	    damage = math.floor(damage * (1 - abil.Level * 0.05))
	end
	TakeDamage(from, caster, skl.ClassName, damage);
	EndSyncPacket(self, key);
	
	local remain = GetExProp(self, "SOUL_BUFF_COUNT");	
	SetExProp(self, "SOUL_BUFF_COUNT", remain - 1);
	if remain - 1 <= 0 then
		RemoveBuff(self, buff.ClassName);
	end
end


function SCR_BUFF_ENTER_Charm(self, buff, arg1, arg2, over)

	print('h22i');

	--[[

	if self.Faction == 'Monster' then

	end

	local objList, objCount = SelectObject(pc, 100, 'ALL');
	for i = 1, objCount do
		local obj = objList[i];	
		SetOwner(obj, pc);
		SetTendency(obj, "Attack")
		ResetHateAndAttack(obj);
		--InsertHate(obj, self, 10000);
		BroadcastRelation(obj);
	end

	]]--

end

function SCR_BUFF_LEAVE_Charm(self, buff, arg1, arg2, over)

	print('h22i');

end