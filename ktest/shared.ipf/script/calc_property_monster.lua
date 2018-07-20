-- util
function GET_MON_STAT_CON(self, lv, statStr)
    local conRate = self["CON_Rate"]
	local conMain = conRate * (24+lv)/ 50.0;
	local newCon = math.floor((self.Lv+4)/2) + conMain;
	
	return newCon;
end

function GET_MON_STAT(self, lv, statStr)

	local cls = GetClassByType("Stat_Monster", lv);
	local stat = self[statStr .. "_Rate"] * (24+lv)/ 25.0;
	return math.floor(stat);
end

function GET_MON_ITEM_STAT(self, lv, statStr)

	local cls = GetClassByType("Stat_Monster", lv);
	local stat = cls["ITEM_" .. statStr];
	return stat;
end

function SCR_GET_MON_ADDSTAT(self, stat)
    local addStat = 0;
    
    if stat < 51 then
        addStat = stat / 5;
    elseif stat < 151 then
        addStat = 50 / 5 + (stat - 50) / 4;
    elseif stat < 301 then
        addStat = 50 / 5 + 100 / 4 + (stat - 150) / 3;
    elseif stat < 501 then
        addStat = 50 / 5 + 100 / 4 + 150 / 3 + (stat - 300) / 2;
    else
        addStat = 50 / 5 + 100 / 4 + 150 / 3 + 200 / 2 + (stat - 500);
    end
    
    return math.floor(addStat);
    
end

function SCR_Get_MON_STR(self)
	local stat = GET_MON_STAT(self, self.Lv, "STR");
    local addStat = SCR_GET_MON_ADDSTAT(self, stat)
    
    local lv = self.Lv;
	local lvRatio = 1;
	
	if lv < 15 then
	    lvRatio = 1;
	elseif lv < 40 then
	    lvRatio = 1.1;
	elseif lv < 75 then
	    lvRatio = 1.2;
	elseif lv < 120 then
	    lvRatio = 1.3;
	else
	    local rank = 3 + (lv - 120) / 50;
    	rank = math.floor(rank);
    	lvRatio = 1 + rank * 0.1;
	end
    
	local value = stat + addStat;
	value = math.floor(value * lvRatio);
	return value + self.STR_BM;
end

function SCR_Get_MON_CON(self)
	local stat = GET_MON_STAT(self, self.Lv, "CON");
    local addStat = SCR_GET_MON_ADDSTAT(self, stat)
	
	local value = math.floor(stat + addStat);
	return value + self.CON_BM;
end

function SCR_Get_MON_INT(self)
	local stat = GET_MON_STAT(self, self.Lv, "INT");
    local addStat = SCR_GET_MON_ADDSTAT(self, stat)
	
    local lv = self.Lv;
	local lvRatio = 1;
	
	if lv < 15 then
	    lvRatio = 1;
	elseif lv < 40 then
	    lvRatio = 1.1;
	elseif lv < 75 then
	    lvRatio = 1.2;
	elseif lv < 120 then
	    lvRatio = 1.3;
	else
	    local rank = 3 + (lv - 120) / 50;
    	rank = math.floor(rank);
    	lvRatio = 1 + rank * 0.1;
	end
    
	local value = stat + addStat;
	value = math.floor(value * lvRatio);
	return value + self.INT_BM;
end

function SCR_Get_MON_MNA(self)
	local stat = GET_MON_STAT(self, self.Lv, "MNA");
    local addStat = SCR_GET_MON_ADDSTAT(self, stat)
	
	local value = math.floor(stat + addStat);
	return value + self.MNA_BM;
end

function SCR_Get_MON_DEX(self)
	local stat = GET_MON_STAT(self, self.Lv, "DEX");
    local addStat = SCR_GET_MON_ADDSTAT(self, stat)
	
	local value = math.floor(stat + addStat);
	return value + self.DEX_BM;
end


function SCR_Get_MON_MHP(self)
	
	if self.HPCount > 0 then
		return self.HPCount;
	end
	
	local value = 0;
	local lv = self.Lv;
	local lvRatio = 1;
	
	if lv < 15 then
	    lvRatio = 1;
	elseif lv < 40 then
	    lvRatio = 1.033;
	elseif lv < 75 then
	    lvRatio = 1.066;
	elseif lv < 120 then
	    lvRatio = 1.099;
	else
	    local rank = 3 + (lv - 120) / 50;
    	rank = math.floor(rank);
    	lvRatio = 1 + rank * 0.033;
	end

	local cls = GetClassByType("Stat_Monster", lv);
    if cls == nil then
		return;
	end

    local rate = cls.ALL_STAT/ 25.0;
    
    local conRate = self["CON_Rate"]
	local conMain = conRate * (24+lv)/ 50.0;
	local newCon = math.floor((self.Lv+4)/2) + conMain;
	
    local addCon = SCR_GET_MON_ADDSTAT(self, newCon)
	
    newCon = newCon + addCon;
    
	local lvValue = math.floor((lv - 1) * 8.5 * lvRatio);
	local monStatValue = newCon * 17 ;
	
	monStatValue = monStatValue * lvRatio * rate;
	
	local cls = GetClassByType("Stat_Monster", lv);
	
	local hpValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			hpValue = cls2.HP;
		end
	end
	

	value = lvValue;
	value = value + monStatValue;
    value = value * hpValue / 100;
  
	value = value + self.MHP_BM;

	if value < 1 then
	    value = 1;
	end
	
    value = value * JAEDDURY_MON_MHP_RATE;		-- JAEDDURY

	return math.floor(value);
	
end

function SCR_Get_MON_MSP(self)

	local mna = self.MNA;	
	local lv = self.Lv;
	local byBuff = self.MSP_BM;
	local byLevel = math.floor((lv -1) * 6.7);
	local byStat = math.floor(mna * 13);

	local value = byLevel + byStat + byBuff;
	
	if value < 1 then
	    value = 1;
	end
	return math.floor(value);
end

-- monster only
function SCR_GET_MON_EXP(self)
	if self.EXP_Rate + self.JEXP_Rate == 0 then
		return 0;
	end

	local level = GetExProp(self, "LEVEL_FOR_EXP");
	if level == 0 then
   		level = self.Lv;
	end

    local multipleValue = 0;
    
	local cls = GetClassByType("Stat_Monster", level);
	local value = cls.EXP_BASE;    

	local expValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			expValue = cls2.EXP;
		end
	end

	value = value * expValue / 100;
	value = value;
	
	return math.floor(value);
end

function SCR_GET_MON_JOBEXP(self)

	if self.EXP_Rate + self.JEXP_Rate == 0 then
		return 0;
	end

	local level = self.Lv;
	local multipleValue = 0;	
    
	local cls = GetClassByType("Stat_Monster", level);
	local value = cls.JEXP_BASE;

	local jexpValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			jexpValue = cls2.JEXP;
		end
	end
	value = value * jexpValue / 100;

	if self.EXP_Rate ~= 0 then
		local mul = (self.EXP_Rate + self.JEXP_Rate) / 2;		
		mul = (mul - 100) / 3 + 100;
		value = value * self.JEXP_Rate / mul;
	end

	value = value;

	return math.floor(value);
end

function SCR_Get_MON_DEF(self)

	if self.HPCount > 0 then
		return 9999999;
	end

	if self.FixedDefence > 0 then
		return self.FixedDefence;
	end

	local lvValue = math.floor(self.Lv/2);
	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "DEF");
	--local monStatValue = self.CON * 17;
	local lv = self.Lv;
	local cls = GetClassByType("Stat_Monster", lv);
	local defValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			defValue = cls2.DEF;			
		end
	end

    
	local value = itemStat * defValue / 100;

	value = value + lvValue;
	value = value + self.DEF_BM;

	if value < 0 then
		value = 0;
	end
	
    value = value * JAEDDURY_MON_DEF_RATE;		-- JAEDDURY

	return math.floor(value)
end


function SCR_Get_MON_HR(self)
	local value = 0;	
	local lv = self.Lv;

	local lvValue = lv;
	local monStatValue = self.DEX;	
	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "HR") * (self.DEX / 5.0);
	
	value = lvValue;
	value = value + monStatValue;
	
	value = value + self.HR_BM;	
	return math.floor(value);	
end

function SCR_Get_MON_DR(self)
	if self.HPCount > 0 then
		return 0;
	end


	local value = 0;
	local lv = self.Lv;

	local lvValue = lv;
	local monStatValue = self.DEX;
	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "DR");	
	
	value = lvValue;
	value = value + monStatValue;
	
	value = value + self.DR_BM;

	return math.floor(value);
end

function SCR_Get_MON_MHR(self)
	local value = 0;	
	--local lv = self.Lv;

	--local lvValue = lv;
	--local monStatValue = self.INT;
	
	--value = lvValue + (lvValue + 4);
	--value = value + monStatValue;
	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "HR")

	value = itemStat + self.MHR_BM;	
	return math.floor(value);	
end

function SCR_Get_MON_MDEF(self)
	if self.HPCount > 0 then
		return 9999999;
	end

	local lvValue = math.floor(self.Lv/2);
	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "DEF");
	local monStatValue = self.MNA;	
	local lv = self.Lv;
	local cls = GetClassByType("Stat_Monster", lv);
	local defValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			defValue = cls2.MDEF;
		end
	end
    
	local value = itemStat * defValue / 100;

	value = value + lvValue + monStatValue;
	value = value + self.MDEF_BM;

	if value < 0 then
		value = 0;
	end
	
    value = value * JAEDDURY_MON_DEF_RATE;		-- JAEDDURY

	return math.floor(value)
end

function SCR_Get_MON_CRTHR(self)
	local value = 0;
	local lv = self.Lv;
	local monStatValue = self.DEX;
	
	
	value = monStatValue;	
	value = value + self.CRTHR_BM;

	return math.floor(value);
end

function SCR_Get_MON_CRTDR(self)
	if self.HPCount > 0 then
		return 999999;
	end


	local value = 0;
	local lv = self.Lv;
	local monStatValue = self.CON;
	
	
	value = monStatValue;	
	value = value + self.CRTDR_BM;

	return math.floor(value);
end

function SCR_Get_MON_CRTATK(self)

	local monStatValue = self.STR * 1;
	value = monStatValue + self.CRTATK_BM;
	return math.floor(value);
end

function SCR_Get_MON_ATKRATIO(self)
	local atkRatio = 100;
	if self.StatType ~= 'None' then
		local cls = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls ~= nil then
			atkRatio = cls.ATK;
		end
	end
	
	atkRatio = atkRatio / 100;
	return atkRatio;
end


function SCR_Get_MON_MINPATK(self)

	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "ATK");
	local atkRatio = SCR_Get_MON_ATKRATIO(self);
	local range = self.ATK_RANGE;
	local byStat = self.STR;
	local lv = self.Lv;
	local buff = self.PATK_BM;

	local value = (itemStat * (2.0 - range/100.0) + byStat + lv) * atkRatio;
	value = value + buff;

   	if value < 1 then
		value = 1;
	end
	--value = value * JAEDDURY_MON_ATK_RATE;		-- JAEDDURY
	return math.floor(value);
    
end

function SCR_Get_MON_MAXPATK(self)
	
    local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "ATK");
    local atkRatio = SCR_Get_MON_ATKRATIO(self);
	local range = self.ATK_RANGE;
	local lv = self.Lv;
	local buff = self.PATK_BM;

	local byStat = self.STR;
	local value = (itemStat * (range/100.0) + byStat + lv) * atkRatio;
	value = value + buff;

   	if value < 1 then
		value = 1;
	end
	
	--value = value * JAEDDURY_MON_ATK_RATE;		-- JAEDDURY
	return math.floor(value);
	
end

function SCR_Get_MON_MINMATK(self)

	local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "ATK");
	local atkRatio = SCR_Get_MON_ATKRATIO(self);
	local range = self.ATK_RANGE;
	local byStat = self.INT;
	local lv = self.Lv;
	local buff = self.MATK_BM;
	local value = (itemStat * (2.0 - range/100.0) + byStat + lv) * atkRatio;
	value = value + buff;
    
   	if value < 1 then
		value = 1;
	end

	--value = value * JAEDDURY_MON_ATK_RATE;		-- JAEDDURY
	return math.floor(value);
    
end

function SCR_Get_MON_MAXMATK(self)
	
    local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "ATK");
    local atkRatio = SCR_Get_MON_ATKRATIO(self);
	local range = self.ATK_RANGE;
	local lv = self.Lv;
	local byStat = self.INT;
	local buff = self.MATK_BM;
	local value = (itemStat * (range/100.0) + byStat + lv) * atkRatio;
	value = value + buff;
    
   	if value < 1 then
		value = 1;
	end

	--value = value * JAEDDURY_MON_ATK_RATE;		-- JAEDDURY
	return math.floor(value);
	
end

function SCR_Get_MON_BLKABLE(self)
	if self.HPCount > 0 then
		return 0;
	end

	return self.Blockable;
end

function SCR_Get_MON_BLK(self)
	local value = 0;
	local lv = self.Lv;
	local monStatValue = self.CON;	
	
	value = monStatValue;	
	value = value + self.BLK_BM + lv*0.5;	

	if self.BLKABLE == 1 then
		return math.floor(value);
	end

	return 0;
end

function SCR_Get_MON_BLK_BREAK(self)
	local value = 0;
	local lv = self.Lv;
	local monStatValue = self.MNA;
	
	value = monStatValue;	
	value = value + self.BLK_BREAK_BM + lv*0.5;

	return math.floor(value);
end


-- old

function SCR_Get_MON_KDArmorType(self)
	if self.HPCount > 0 then
		return 9999;
	end


	local value = self.KDArmor;
	return value;
end

function SCR_GET_MON_RHPTIME(self)
	return 10000;
end

function SCR_GET_COMPANION_RHPTIME(self)
	return 5000;
end

function SCR_GET_MON_MSHIELD(self)
	
	return self.ShieldRate/100 * self.MHP;

end

-- Regenerate HP
function SCR_Get_MON_RHP(self)
	if self.HPCount > 0 then
		return 0;
	end
	
	if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
		return 0;
	end

	local value = 0;
	value = value + self.RHP_BM;
	return value;
end

-- Attack damage


--function GET_MON_TABLE_VALUE(self, propName)
--	local lv = self.Lv;
--	local cls = GetClassByType("Stat_Monster", lv);

--	local value = cls[propName] + self[propName .. "_BM"];
--	return math.floor(value);
--end



-- Critical defence
function SCR_Get_MON_CRTDEF(self)

	local value = self.Lv;
	value = value + self.CRTDEF_BM;
	return math.floor(value);
end

-- Dodge rating reduce
function SCR_Get_MON_DRR(self)

	local value = 25;
	value = value + self.DRR_BM;
	return math.floor(value);
end

-- Threatening
function SCR_Get_MON_TR(self)

	local value = 10;
	value = value + self.TR_BM;
	return math.floor(value);
end

-- Add
function SCR_Get_MON_ADD_FIRE(self)

	local value = 0;
	value = value + self.ADD_FIRE_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_ICE(self)

	local value = 0;
	value = value + self.ADD_ICE_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_POISON(self)

	local value = 0;
	value = value + self.ADD_POISON_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_LIGHTNING(self)

	local value = 0;
	value = value + self.ADD_LIGHTNING_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_SOUL(self)

	local value = 0;
	value = value + self.ADD_SOUL_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_EARTH(self)

	local value = 0;
	value = value + self.ADD_EARTH_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_HOLY(self)

	local value = 0;
	value = value + self.ADD_HOLY_BM;
	return math.floor(value);
end

function SCR_Get_MON_ADD_DARK(self)

	local value = 0;
	value = value + self.ADD_DARK_BM;
	return math.floor(value);
end

function SCR_Get_MON_HitRange(self)

	local value = 10;
	return math.floor(value);
end

function SCR_Get_MON_ASPD(self)

	local value = 0;
	value = self.AniASPD * 1.25;
	value = value * (100 - self.ASPD_BM) / 100;
	if value < 500 then
		value = 500;
	elseif value > 10000 then
		value = 10000;
	end
	return math.floor(value);
end

function SCR_GET_SKL_CAST_MON(skill)

	return skill.BasicCast;

end

function SCR_Get_MON_MSPD(self)
 
	local fixMspd = self.FIXMSPD_BM;

	if fixMspd ~= 0.0 then
		return math.max(0, fixMspd);
	end

	local wlkMspd = self.WlkMSPD;
	if wlkMspd == 0 then
		return 0;
	end

	local moveType = GetExProp(self, 'MOVE_TYPE_CURRENT');
	
	if moveType ~= 0 then
		local moveSpd = wlkMspd + self.MSPD_BM;
		if moveType == 2 then
			moveSpd = self.RunMSPD + self.MSPD_BM;
		elseif moveType == 3 then
			moveSpd = wlkMspd + self.RunMSPD + self.MSPD_BM;
		end
	
		return moveSpd;
	end
	
	local value = 0;
	value = wlkMspd + self.MSPD_BM;
	if value < 0 then
		value = 0;
	end

	local mspdValue = 100;
	if self.StatType ~= 'None' then
		local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls2 ~= nil then
			mspdValue = cls2.MoveSpeed;
		end
	end
	
	value = value * mspdValue / 100;
	
	value = value * (100 + self.SPD_BM) / 100;
	
	value = value * SERV_MSPD_FIX;
	return math.floor(value);
end


function SCR_Get_MON_minRange(self)

	local value = 0;
	value = self.MinR;
	return math.floor(value);
end

function SCR_Get_MON_maxRange(self)

	local value = 0;
	value = self.MaxR;
	value = value + self.maxRange_BM;
	if value < (self.MinR + 2) then
		value = self.MinR + 2;
	elseif value > 300 then
		value = 300;
	end
	return math.floor(value);
end

function SCR_Get_MON_KDPow(self)

	local value = 0;
	value = value + self.KDPow_BM;
	value = value * self.KDRank;
	return math.floor(value);
end

---------------------------------KnockDown-------------------------
function SCR_GET_MON_KDBONUS(self)
	local basestat = 120;
	local byStat = basestat;
	local byLevel = 10 * self.Lv;
	local byBuff = self.KDBonus_BM;
	value = byStat + byLevel + byBuff;
	return value;
end

function SCR_GET_MON_KDDEFENCE(self)
	local basestat = 80;
	local byStat = basestat;
	local byLevel = 10 * self.Lv;
	local byBuff = self.KDBonus_BM;
	value = byStat + byLevel + byBuff;
	return value;
end
---------------------------------------------------------------------

function SCR_Get_MON_MGP(self)

	return 65535;

end

function SCR_Get_MON_SR(self)
    local value = self.MonSR + self.SR_BM;
	return math.floor(value)
end

function SCR_Get_MON_SDR(self)
    local value = 5;
    
    if self.MonSDR < 0 then	-- ?º??
		return -1;
	elseif self.Size == 'S' then
        value = 1;
    elseif self.Size == 'M' then
        value = 2;
    elseif self.Size == 'L' then
        value = 3;
    end
    
	return value + self.SDR_BM;
end

function SCR_GET_MONSKL_COOL(skill)
	return skill.BasicCoolDown;
end

function SCR_MON_COMBOABLE(mon)

	if mon.GroupName == "Monster" then
		return 1;
	end
	
	return 0;

end

function SCR_GET_MON_FIRE_DEF(self)
    local value = 0;
    value = self.Fire_Def_BM;
	return value;
end

function SCR_GET_MON_ICE_DEF(self)
    local value = 0;
    value = self.Ice_Def_BM;
	return value;
end

function SCR_GET_MON_POISON_DEF(self)
    local value = 0;
    value = self.Poison_Def_BM;
	return value;
end

function SCR_GET_MON_LIGHTNING_DEF(self)
    local value = 0;
    value = self.Lightning_Def_BM;
	return value;
end

function SCR_GET_MON_SOUL_DEF(self)
    local value = 0;
    value = self.Soul_Def_BM;
	return value;
end

function SCR_GET_MON_EARTH_DEF(self)
    local value = 0;
    value = self.Earth_Def_BM;
	return value;
end

function SCR_GET_MON_HOLY_DEF(self)
    local value = 0;
    value = self.Holy_Def_BM;
	return value;
end

function SCR_GET_MON_DARK_DEF(self)
    local value = 0;
    value = self.Dark_Def_BM;
	return value;
end

function SCR_GET_MON_LIMIT_BUFF_COUNT(self)
	
	local count = 10;
	count = count + self.LimitBuffCount_BM;
	return count;
end

-- hardskill_sorcerer.lua �� ��ũ��Ʈ�� shared�� ������ ���ϰ�... Ŭ���� �ʿ��ؼ� �״�� ����
function CLIENT_SORCERER_SUMMONING_MON(self, caster, skl, item)

	if nil == self then
		return;
	end

	if nil == caster then
		return;
	end

	if nil == skl then
		return;
	end

	self.Lv = caster.Lv;
	self.StatType = 30
		
	local monDef = self.DEF;
	local monMDef = self.MDEF;

	local sklbonus = 1 + skl.Level * 0.1
	local itembonus = 1 + item.Level * 0.1
	self.MATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
	self.PATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
	
	self.DEF_BM = (monDef / 2  + (caster.MNA * sklbonus)) * itembonus
	self.MDEF_BM = (monMDef / 2 + (caster.MNA * sklbonus)) * itembonus
end

function SCR_GET_MON_SKILLFACTORRATE(self)
    local value = 100;
    if self.StatType ~= 'None' then
		local cls = GetClass("Stat_Monster_Type", "type"..self.StatType);
		if cls ~= nil then
			value = cls.SkillFactorRate;
		end
	end
	
	return value;
end


function SCR_Get_MON_Slash_Res(self)
	local value = 0;

	local Slash_Res = TryGetProp(self, "Slash_Res")
	if Slash_Res == nil then
	    Slash_Res = 0;
	end
	
	local Slash_Def_BM = TryGetProp(self, "Slash_Def_BM")
	if Slash_Def_BM == nil then
	    Slash_Def_BM = 0;
	end
	
	value = value + Slash_Res + Slash_Def_BM;
	return value;
end

function SCR_Get_MON_Aries_Res(self)
	local value = 0;
    
	local Aries_Res = TryGetProp(self, "Aries_Res")
	if Aries_Res == nil then
	    Aries_Res = 0;
	end
	
	local Aries_Def_BM = TryGetProp(self, "Aries_Def_BM")
	if Aries_Def_BM == nil then
	    Aries_Def_BM = 0;
	end
    
	value = value + Aries_Res + Aries_Def_BM;
	return value;
end

function SCR_Get_MON_Strike_Res(self)
	local value = 0;
	
	local Strike_Res = TryGetProp(self, "Strike_Res")
	if Strike_Res == nil then
	    Strike_Res = 0;
	end
	
	local Strike_Def_BM = TryGetProp(self, "Strike_Def_BM")
	if Strike_Def_BM == nil then
	    Strike_Def_BM = 0;
	end
	
	value = value + Strike_Res + Strike_Def_BM;
	return value;
end

function SCR_Get_MON_Magic_Res(self)
	local value = 0;
	
	local magicRes = TryGetProp(self, "Magic_Res")
	if magicRes == nil then
		magicRes = 0;
	end

	local magicDefBM = TryGetProp(self, "Magic_Def_BM")
	if magicDefBM == nil then
		magicDefBM = 0;
	end

	value = value + magicRes + magicDefBM;

	return value;
end

function SCR_Get_MON_Arrow_Res(self)
	local value = 0;
    
	local Arrow_Res = TryGetProp(self, "Arrow_Res")
	if Arrow_Res == nil then
	    Arrow_Res = 0;
	end
	
	local Arrow_Def_BM = TryGetProp(self, "Arrow_Def_BM")
	if Arrow_Def_BM == nil then
	    Arrow_Def_BM = 0;
	end
	
	value = value + Arrow_Res + Arrow_Def_BM;
	return value;
end

function SCR_Get_MON_Gun_Res(self)
	local value = 0;
	
	local Gun_Res = TryGetProp(self, "Gun_Res")
	if Gun_Res == nil then
	    Gun_Res = 0;
	end
	
	local Gun_Def_BM = TryGetProp(self, "Gun_Def_BM")
	if Gun_Def_BM == nil then
	    Gun_Def_BM = 0;
	end
	
	value = value + Gun_Res + Gun_Def_BM;
	return value;
end

function SCR_Get_MON_Cannon_Res(self)
	local value = 0;
	
	local Cannon_Res = TryGetProp(self, "Cannon_Res")
	if Cannon_Res == nil then
	    Cannon_Res = 0;
	end
	
	local Cannon_Def_BM = TryGetProp(self, "Cannon_Def_BM")
	if Cannon_Def_BM == nil then
	    Cannon_Def_BM = 0;
	end
	
	value = value + Cannon_Res + Cannon_Def_BM;
	return value;
end
