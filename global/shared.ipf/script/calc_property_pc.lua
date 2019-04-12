function SCR_GET_JOB_STR(pc)
	
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return GetJobObject(pc).STR;
	end

	return 1;
end

function SCR_GET_JOB_DEX(pc)
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return jobObj.DEX;
	end

	return 1;
end

function SCR_GET_JOB_CON(pc)
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return jobObj.CON;
	end

	return 1;
end

function SCR_GET_JOB_INT(pc)
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return jobObj.INT;
	end

	return 1;
end

function SCR_GET_JOB_MNA(pc)
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return jobObj.MNA;
	end

	return 1;
end

function SCR_GET_JOB_LUCK(pc)
	local jobObj = GetJobObject(pc);
	if jobObj ~= nil then
		return jobObj.LUCK;
	end

	return 1;
end

function SCR_Get_Const(self)

	return (self.Lv + 5) / math.pi;

end

function GET_STAT_POINT(pc)
	
	return pc.StatByLevel + pc.StatByBonus - pc.UsedStat;
		
end

function SCR_GET_MAX_WEIGHT(pc)
	
	local rewardProperty = GET_REWARD_PROPERTY(pc, "MaxWeight")

	local value = 5000 + pc.MaxWeight_BM + pc.MaxWeight_Bonus + (pc.CON * 5) + (pc.STR * 5) + rewardProperty;

	return value;
end

function SCR_GET_NOW_WEIGHT(pc)
	return GetTotalItemWeight(pc);
end

function SCR_GET_ADDSTAT(self, stat)
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

function SCR_GET_STR(self)
    local rewardProperty = GET_REWARD_PROPERTY(self, "STR")
	local baseStr = self.STR_JOB + self.STR_STAT + self.STR_Bonus + GetExProp(self, "STR_TEMP") + rewardProperty;
	
	local addStat = SCR_GET_ADDSTAT(self, baseStr);
	local value = baseStr + addStat;
	local jobCount = GetTotalJobCount(self);
	
	value = value + value * (jobCount - 1) * 0.1;
	value = math.floor(value + self.STR_ADD, 1);
	
	if value < 1 then
        value = 1;
    end
    
	return value;

end

function SCR_GET_ADDSTR(self)

	local itemSTR = GetSumOfEquipItem(self, 'STR');
	return self.STR_BM + itemSTR;

end

function SCR_GET_DEX(self)
    local rewardProperty = GET_REWARD_PROPERTY(self, "DEX")
	local baseDex = self.DEX_JOB + self.DEX_STAT + self.DEX_Bonus + GetExProp(self, "DEX_TEMP") + rewardProperty;
	local addStat = SCR_GET_ADDSTAT(self, baseDex)
	local value = math.floor(baseDex + self.DEX_ADD + addStat, 1);
	
	if value < 1 then
        value = 1;
    end

	return value;

end

function SCR_GET_ADDDEX(self)

	local itemAGI = GetSumOfEquipItem(self, 'DEX');
	return self.DEX_BM + itemAGI;

end


function SCR_GET_CON(self)
    local rewardProperty = GET_REWARD_PROPERTY(self, "CON")
	local baseCon = self.CON_JOB + self.CON_STAT + self.CON_Bonus + GetExProp(self, "CON_TEMP") + rewardProperty;
    local addStat = SCR_GET_ADDSTAT(self, baseCon)
	
	local value = math.floor(baseCon + self.CON_ADD + addStat, 1);

	if value < 1 then
        value = 1;
    end

	return value;

end

function SCR_GET_ADDCON(self)

	local itemCON = GetSumOfEquipItem(self, 'CON');
	return self.CON_BM + itemCON;

end

function SCR_GET_INT(self)
    local rewardProperty = GET_REWARD_PROPERTY(self, "INT")
	local baseInt = self.INT_JOB + self.INT_STAT + self.INT_Bonus + GetExProp(self, "INT_TEMP") + rewardProperty;
    local addStat = SCR_GET_ADDSTAT(self, baseInt)
    local value = baseInt + addStat;
	local jobCount = GetTotalJobCount(self);
	
	value = value + value * (jobCount - 1) * 0.1;
	value = math.floor(value + self.INT_ADD, 1);
	
	if value < 1 then
        value = 1;
    end

	return value;

end

function SCR_GET_ADDINT(self)
	local itemINT = GetSumOfEquipItem(self, 'INT');
	return self.INT_BM + itemINT;
end

function SCR_GET_MNA(self)
    local rewardProperty = GET_REWARD_PROPERTY(self, "MNA")
	local baseMna = self.MNA_JOB + self.MNA_STAT + self.MNA_Bonus + GetExProp(self, "MNA_TEMP") + rewardProperty;
    local addStat = SCR_GET_ADDSTAT(self, baseMna)
	
	local value = math.floor(baseMna + self.MNA_ADD + addStat, 1);

	if value < 1 then
        value = 1;
    end

	return value;
end

function SCR_GET_ADDMNA(self)
	local itemWIS = GetSumOfEquipItem(self, 'MNA');
	return self.MNA_BM + itemWIS;
end

function SCR_GET_LUCK(self)

	local baseluck = self.LUCK_JOB + self.LUCK_STAT;
	return math.max(baseluck + self.LUCK_ADD, 1);

end

function SCR_GET_ADDLUCK(self)

	local itemLUCK = GetSumOfEquipItem(self, 'LUCK');
	return self.LUCK_BM + itemLUCK;

end

function SCR_Get_RefreshHP(self)

	return self.MHP * 0.3;
end


function SCR_Get_MHP(self)
	
	local jobObj = GetJobObject(self);
		
	local con = self.CON;	
	local lv = self.Lv;

	local byItemRatio = (1.0 + GetSumOfEquipItem(self, 'MHPRatio') * 0.01);

	local byItem = GetSumOfEquipItem(self, 'MHP');
	local byBuff = self.MHP_BM;
	local byLevel = math.floor((lv -1) * 8.5 * 2);
	local byStat = math.floor(con * 85);

	local rewardProperty = GET_REWARD_PROPERTY(self, "MHP")

	local value = ((jobObj.JobRate_HP * byLevel) + byStat) * byItemRatio + byItem + self.MHP_Bonus + byBuff + rewardProperty;
	
	if value < 1 then
	    value = 1;
	end
	
	return math.floor(value);
		
end

function SCR_Get_MSP(self)

	local mna = self.MNA;
	local lv = self.Lv;

	local byItem = GetSumOfEquipItem(self, 'MSP');
	local byBuff = self.MSP_BM;
	local byLevel = math.floor((lv -1) * 6.7);
	local byStat = math.floor(mna * 13);
	
	local addSp = 0;
    local jobObj = GetJobObject(self);
	if jobObj.CtrlType == 'Cleric' then
        	addSp = self.Lv * 1.675;
	end

	local rewardProperty = GET_REWARD_PROPERTY(self, "MSP")

	local value = (jobObj.JobRate_SP * byLevel) + byItem + byStat + self.MSP_Bonus + byBuff + addSp + rewardProperty;
	
	if value < 1 then
	    value = 0;
	end
	
	return math.floor(value);

end

function SCR_Get_MINPATK(self)
	local jobObj = GetJobObject(self);
		
	local str = self.STR;	
	local lv = self.Lv;
	local buff = self.PATK_BM;

	local byItem = GetSumOfEquipItem(self, 'MINATK');
	local byItem2 = GetSumOfEquipItem(self, 'PATK');
	local byItem3 = GetSumOfEquipItem(self, 'ADD_MINATK');
	local leftMinAtk = 0;
	
	if jobObj.CtrlType == 'Warrior' then
        	str = str * 1.3;
	end
	
	
	if GetEquipItemForPropCalc(self, 'LH') ~= nil then
    	leftHand = GetEquipItemForPropCalc(self, 'LH');
    	leftMinAtk = leftHand.MINATK;
    end
    
    local throwItemMinAtk = 0;
	if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and GetEquipItemForPropCalc(self, 'RH') ~= nil then
    	rightHand = GetEquipItemForPropCalc(self, 'RH');
    	throwItemMinAtk = rightHand.MINATK;
    end
    
	local value = lv + str + byItem + byItem2 + byItem3 + buff - leftMinAtk - throwItemMinAtk;
	
	return math.floor(value);
end

function SCR_Get_MAXPATK(self)
	local jobObj = GetJobObject(self);
	
	local str = self.STR;	
	local lv = self.Lv;
	local buff = self.PATK_BM;

	local byItem = GetSumOfEquipItem(self, 'MAXATK');
	local byItem2 = GetSumOfEquipItem(self, 'PATK');
	local byItem3 = GetSumOfEquipItem(self, 'ADD_MAXATK');
    local leftMaxAtk = 0;
	local maxpatk_bm = self.MAXPATK_BM;
	
    
	if jobObj.CtrlType == 'Warrior' then
        	str = str * 1.3;
	end
	
	
	if GetEquipItemForPropCalc(self, 'LH') ~= nil then
    	leftHand = GetEquipItemForPropCalc(self, 'LH');
    	leftMaxAtk = leftHand.MAXATK;
    end
    
    local throwItemMaxAtk = 0;
	if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and GetEquipItemForPropCalc(self, 'RH') ~= nil then
    	rightHand = GetEquipItemForPropCalc(self, 'RH');
    	throwItemMaxAtk = rightHand.MAXATK;
    end
	
	local value = lv + str + byItem + byItem2 + byItem3 + buff - leftMaxAtk - throwItemMaxAtk + 0 + maxpatk_bm;
	
	return math.floor(value);
end

function SCR_Get_MINPATK_SUB(self)
	local jobObj = GetJobObject(self);
		
	local str = self.STR;	
	local lv = self.Lv;
	local buff = self.PATK_BM;

	local byItem = GetSumOfEquipItem(self, 'MINATK');
	local byItem2 = GetSumOfEquipItem(self, 'PATK');
	local byItem3 = GetSumOfEquipItem(self, 'ADD_MINATK');
	local rightMinAtk = 0;
	if GetEquipItemForPropCalc(self, 'RH') ~= nil then
    	rightHand = GetEquipItemForPropCalc(self, 'RH');
    	rightMinAtk = rightHand.MINATK;
    end
	
	if jobObj.CtrlType == 'Warrior' then
        	str = str * 1.3;
	end
	
	local value = lv + str + byItem + byItem2 + byItem3 + buff - rightMinAtk;
	
	return math.floor(value);
end

function SCR_Get_MAXPATK_SUB(self)
	local jobObj = GetJobObject(self);
	
	local str = self.STR;	
	local lv = self.Lv;
	local buff = self.PATK_BM;
	local sub_bm = self.MAXPATK_SUB_BM;

	local byItem = GetSumOfEquipItem(self, 'MAXATK');
	local byItem2 = GetSumOfEquipItem(self, 'PATK');
	local byItem3 = GetSumOfEquipItem(self, 'ADD_MAXATK');
	local rightMaxAtk = 0;
	if GetEquipItemForPropCalc(self, 'RH') ~= nil then
    	rightHand = GetEquipItemForPropCalc(self, 'RH');
    	rightMaxAtk = rightHand.MAXATK;
    end
	
	if jobObj.CtrlType == 'Warrior' then
        	str = str * 1.3;
	end

	local value = lv + str + byItem + byItem2 + byItem3 + buff + sub_bm - rightMaxAtk;
	
	return math.floor(value);
end

function SCR_Get_MINMATK(self)
	local jobObj = GetJobObject(self);
		
	local str = self.INT;	
	local lv = self.Lv;
	local buff = self.MATK_BM;

	local byItem = GetSumOfEquipItem(self, 'MATK');
	local byItem2 = GetSumOfEquipItem(self, 'ADD_MATK');
    local byItem3 = GetSumOfEquipItem(self, 'ADD_MINATK');
	
	local value = lv + str + byItem + byItem2 + byItem3 + buff;
	
	return math.floor(value);
end

function SCR_Get_MAXMATK(self)
	local jobObj = GetJobObject(self);
		
	local str = self.INT;	
	local lv = self.Lv;
	local buff = self.MATK_BM;

	local byItem = GetSumOfEquipItem(self, 'MATK');
	local byItem2 = GetSumOfEquipItem(self, 'ADD_MATK');
	local byItem3 = GetSumOfEquipItem(self, 'ADD_MAXATK');
	
	local value = lv + str + byItem + byItem2 + byItem3 + buff;
	
	return math.floor(value);
end

function SCR_Get_DEF(self)
	
	local byItem = GetSumOfEquipItem(self, "DEF") + GetSumOfEquipItem(self, "ADD_DEF");
	local byBuff = self.DEF_BM;
	local byLevel = math.floor(self.Lv / 2);
    
    local addDef = 0;
    local jobObj = GetJobObject(self);
	if jobObj.CtrlType == 'Warrior' then
    	addDef = self.Lv / 4;
	end
	
	local throwItemDef = 0;
	if IsBuffApplied(self, 'Warrior_LH_VisibleObject') == 'YES' and GetEquipItemForPropCalc(self, 'LH') ~= nil then
    	leftHand = GetEquipItemForPropCalc(self, 'LH');
        throwItemDef = leftHand.DEF
    end	
    
    local value = byItem + byBuff + byLevel + addDef + self.MAXDEF_Bonus - throwItemDef;
    
	if value < 1 then
	    value = 0;
	end
	return math.floor(value);

end

function SCR_Get_BLKABLE(self)
    
	local isShield = GetSumOfEquipItem(self, 'BlockRate');
	if isShield > 0 then
		return 1;
	end
	
	if IsBuffApplied(self, 'CrossGuard_Buff') == 'YES' or IsBuffApplied(self, 'StoneSkin_Buff') == 'YES' then
	    return 2;
	end	
	
	return 0;
end

function SCR_Get_BLK(self)

	local isShield = GetSumOfEquipItem(self, 'BlockRate');
	local byLevel = self.Lv;
	local blk = GetSumOfEquipItem(self, 'BLK');
	local stat = self.CON;
	local Peltasta5_abil = GetAbility(self, 'Peltasta5')
	
	if isShield > 1 then
	    isShield = 1;
	end
	
	local jobObj = GetJobObject(self);
	if jobObj.CtrlType == 'Warrior' then
    	isShield = isShield * 2;
	end

	local blkrate = 0;
	if self.BLKABLE == 1 then
	    blkrate = byLevel * 0.5 + stat + blk + isShield * byLevel * 0.03;
	end
	
	local value = math.floor(blkrate + self.BLK_BM)

	if Peltasta5_abil ~= nil and self.BLKABLE == 1 then
	    value = math.floor(value + (value * (Peltasta5_abil.Level * 0.05)))
	end
	
	if value < 0 then
	    value = 0;
	end
	
	if self.BLKABLE ~= 0 then
		return math.floor(value);
	end

	return 0;
end

function SCR_Get_BLK_BREAK(self)
	local jobObj = GetJobObject(self);
	local blk = GetSumOfEquipItem(self, 'BLK_BREAK');
	local byLevel = self.Lv;
	local stat = self.MNA;
	local str = self.STR;
	local value = byLevel * 0.5 + stat + blk + self.BLK_BREAK_BM + str;
	if jobObj.CtrlType == 'Warrior' then
        	value = value + str * 0.2;
	end
	return math.floor(value);
end

function SCR_Get_HR(self)
	
	local byItem = GetSumOfEquipItem(self, 'HR') + GetSumOfEquipItem(self, 'ADD_HR');
	local stat = self.DEX;
	local byLevel = self.Lv;
    
	local addHr = 0;
    local jobObj = GetJobObject(self);
	if jobObj.CtrlType == 'Archer' then
    	addHr = (self.Lv + 4) / 4;
	end
    
	local value = stat + byLevel + addHr + byItem;
	value = value + self.HR_BM;	
	return math.floor(value);
end

function SCR_Get_DR(self)
	local byItem = GetSumOfEquipItem(self, 'DR') + GetSumOfEquipItem(self, 'ADD_DR');
	local stat = self.DEX;
	local byLevel = self.Lv;
	
	local addDr = 0;
    local jobObj = GetJobObject(self);
	if jobObj.CtrlType == 'Archer' then
        	addDr = self.Lv / 8;
	end
	
	local value = stat + byLevel + addDr + byItem;
	value = value + self.DR_BM;	
	return math.floor(value);
end

function SCR_Get_MHR(self)
	
	local byItem = GetSumOfEquipItem(self, 'MHR');
	local byItem2 = GetSumOfEquipItem(self, 'ADD_MHR');
	local value = byItem + byItem2;
	value = value + self.MHR_BM;
	return math.floor(value);
end

function SCR_Get_MDEF(self)

	local byItem = GetSumOfEquipItem(self, 'MDEF');
	local byItem2 = GetSumOfEquipItem(self, 'ADD_MDEF');
	local byLevel = self.Lv * 0.5;
	local addDef = 0;
	local jobObj = GetJobObject(self);
	local byStat = self.MNA / 5;
	
	if jobObj.CtrlType == 'Wizard' then
    	addDef = self.Lv / 4;
	end
	
	local value = byLevel + byItem + byItem2 + addDef + byStat;
	value = value + self.MDEF_BM;
	return math.floor(value);
end

function SCR_Get_CRTHR(self)
	
	local byItem = GetSumOfEquipItem(self, 'CRTHR');
	local stat = self.DEX;
    local addCrthr = 0;
    local jobObj = GetJobObject(self); -- ?u??? ?????????? ??? ??? ????
	if jobObj.CtrlType == 'Archer' then
        addCrthr = self.Lv / 5;
	end
    
    local value = stat + byItem + addCrthr + self.CRTHR_BM;
    
	return math.floor(value);
end

function SCR_Get_CRTDR(self)

	local byItem = GetSumOfEquipItem(self, 'CRTDR');
	local stat = self.CON;
	local value = stat + byItem + self.CRTDR_BM;
	return math.floor(value);
end

function SCR_Get_CRTATK(self)

	local byAbil = 0;
	local byStat = self.STR * 1
	local byItem = GetSumOfEquipItem(self, "CRTATK");
	local byBuff = self.CRTATK_BM;

    local value = byStat + byAbil + byItem + byBuff;
	return math.floor(value);
end

function SCR_Get_CRTDEF(self)
	return 0;
end

function SCR_Get_RHP(self)
	local jobObj = GetJobObject(self);  -- job
	if jobObj == nil then
		return 0;
	end

	local byJob = jobObj.JobRate_HP;
	local baseMHP = self.MHP;
	local byItem = GetSumOfEquipItem(self, 'RHP');
    
    if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
		return 0;
	end

	local value = byJob * self.Lv * 0.5 + self.CON + self.RHP_BM;
	value = value + byItem;

	if value < 1 then
	    value = 0;
	end
	
--	local sacrifice = GetExProp(self, 'SACRIFICE_RHP');
--	if sacrifice > 0 then
--		return 0;
--	end


	return math.floor(value);

end

function SCR_GET_RHPTIME(self)
	local byStat = 20000;
	local byItem = GetSumOfEquipItem(self, 'RHPTIME');
	local byBuff = self.RHPTIME_BM;
	
	local value = byStat - byItem - byBuff;

	if IsBuffApplied(self, 'SitRest') == 'YES' then	
	    value = value / 2;
	end
	
	if value < 1000 then
	    value = 1000;
	end
	
	return value;
	

end

function SCR_GET_RSPTIME(self)
	local byStat = 20000;
	local byItem = GetSumOfEquipItem(self, 'RSPTIME');
	local byBuff = self.RSPTIME_BM;
	local value = byStat - byItem - byBuff;
	
	if IsBuffApplied(self, 'SitRest') == 'YES' then	
	    value = value / 2;
	end
	
	if value < 0 then
	    value = 1000;
	end
	
	return value;

end

function SCR_Get_RSP(self)

    local jobObj = GetJobObject(self);  -- job
    local byJob = jobObj.JobRate_SP;
	local baseMSP = self.MSP;
	local byItem = GetSumOfEquipItem(self, 'RSP');
	local byAbil = 0
	if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
		return 0;
	end
	
	if GetBuffByProp(self, 'Keyword', 'Formation') ~= nil then 
     return 0;
  end 
  
  if GetBuffByProp(self, 'Keyword', 'SpDrain') ~= nil then 
     return 0;
  end 
	
	local Cle_abil4 = GetAbility(self, 'Meditaion');
	if Cle_abil4 ~= nil then
		byAbil = Cle_abil4.Level * (baseMSP * 0.01);
	end
	
	local addRsp = 0;

	if jobObj.CtrlType == 'Cleric' then
        addRsp = self.Lv / 4;
	end
	
	local value = byJob * self.Lv * 0.5 + self.MNA + addRsp + self.RSP_BM;

	value = value + byAbil * baseMSP + byItem;

	if value < 1 then
	    value = 1;
	end
	
	if IsBuffApplied(self, 'Summoning_Buff') == 'YES' then	
	    value = 0;
	end	
		
	return math.floor(value);
 
end


function SCR_Get_StunRate(self)
	
	local byItem = GetSumOfEquipItem(self, "StunRate");
	local byBuff = self.StunRate_BM;
	
	local value = byItem + byBuff;
	return math.floor(value);
end


function SCR_Get_Revive(self)

	local byItem = GetSumOfEquipItem(self, 'Revive');
	local byBuff = self.Revive_BM;

	local value = byItem + byBuff;
	return math.floor(value);
 end
 
function SCR_Get_HitCount(self)
 
 	local byItem = GetSumOfEquipItem(self, "HitCount");
	local byBuff = self.HitCount_BM;

 	local value = byItem + byBuff;
	return math.floor(value);
 end
 
function SCR_Get_BackHit(self)
 
	local byItem = GetSumOfEquipItem(self, "BackHit");
	local value = byItem;
	return math.floor(value);
 end
 
function SCR_Get_Aries_Bonus(self)

	local byItem = GetSumOfEquipItem(self, 'Aries');
	local value = byItem + self.Aries_Bonus_BM;
	return math.floor(value);
	
end

function SCR_Get_Aries_Defence(self)

	local byItem = GetSumOfEquipItem(self, 'AriesDEF');
	local value = byItem + self.DefAries_BM;
	return math.floor(value);
	
end

function SCR_Get_Slash_Bonus(self)

	local byItem = GetSumOfEquipItem(self, 'Slash');
	local value = byItem + self.Slash_Bonus_BM;
	return math.floor(value);
	
end

function SCR_Get_Slash_Defence(self)

	local byItem = GetSumOfEquipItem(self, 'SlashDEF');
	local value = byItem + self.DefSlash_BM
	return math.floor(value);
	
end

function SCR_Get_Strike_Bonus(self)

	local byItem = GetSumOfEquipItem(self, 'Strike');
	local value = byItem + self.Strike_Bonus_BM;
	return math.floor(value);
	
end

function SCR_Get_Strike_Defence(self)

	local byItem = GetSumOfEquipItem(self, 'StrikeDEF');
	local value = byItem + self.DefStrike_BM
	return math.floor(value);
	
end

function SCR_Get_TR(self)

	local value = 50;
	value = value + self.TR_BM;
	return math.floor(value);
end

function SCR_Get_KDArmorType(self)

	local jobObj = GetJobObject(self);
	local armor = 0;

	if jobObj.CtrlType == 'Warrior' then 
    	armor = 1;
    
    elseif jobObj.CtrlType == 'Wizard' then 
    	armor = 0;
    
    elseif jobObj.CtrlType == 'Archer' then 
    	armor = 0;

	elseif jobObj.CtrlType == 'Cleric' then 
    	armor = 1;
	end
	
	if IsBuffApplied(self, 'Safe') == 'YES' or IsBuffApplied(self, 'PainBarrier_Buff') == 'YES' then
		armor = 99999;
	end

	return armor;
end


function SCR_Get_ASPD(self)

	return self.ASPD_BM;

end


function SCR_Get_MSPD(self)

	if self.FIXMSPD_BM ~= 0 then
		return self.FIXMSPD_BM;
	end
	
	local value = 30.0;
	local byItem = GetSumOfEquipItem(self, 'MSPD');
    
	if self.ClassName == 'PC' then
		value = value + byItem + self.MSPD_BM;
		value = value * (100 + self.SPD_BM) / 100;

		local nowweight;
		if IsServerSection(self) == 1 then
			
			nowweight = self.NowWeight
			if self.NowWeight >= self.MaxWeight then
				value = value / 3;
			end
		else
			local pc = GetMyPCObject();
			
			nowweight = pc.NowWeight
			if pc.NowWeight >= pc.MaxWeight then
				value = value / 3;
			end
		end

		
	end
	
	if self.DashRun == 1 then
		value = value + 10;
	end
	
	if value > 60 then
	    value = 60;
	end
	
    value = value + self.MSPD_Bonus;
	value = value * SERV_MSPD_FIX;

	return math.floor(value);
end

function SCR_Get_MinR(self)

	local value = 0;
	rweapon = GetEquipItemForPropCalc(self, 'RH');
	lweapon = GetEquipItemForPropCalc(self, 'LH');
	stance = GetCurrentStance(self);
	if stance.ClassType == 'Force' then
		value = 0;
	end
	return value;
end

function SCR_Get_MaxR(self)

	local value = 5;
	rweapon = GetEquipItemForPropCalc(self, 'RH');
	stance = GetCurrentStance(self);
	if stance.ClassType == 'Force' then
		value = 300;
		return;
	end
	value = rweapon.MaxR;
	return value;
end

function SCR_Get_MaxRFwd(self)

	local value = self.MaxR;
	local stance = GetCurrentStance(self);
	if stance.ClassType == 'Magic' then
		return value;
	end
	value = value + 15;
	return value;
end

function SCR_Get_SR(pc) 	
	local byStat = 3;
	local jobObj = GetJobObject(pc);
	if jobObj.CtrlType == 'Warrior' then
	    byStat = 4;
	end
	if jobObj.CtrlType == 'Archer' then
    	byStat = 0;
	end
	local byItem = GetSumOfEquipItem(pc, "SR");
	local byBuff = pc.SR_BM;
	return byStat + byBuff + byItem;

end


function SCR_Get_SDR(pc)

	local byStat = 1;
	local byItem = GetSumOfEquipItem(pc, "SDR");
	local byBuff = pc.SDR_BM;
	return byStat + byBuff + byItem;

end

function SCR_Get_ForceVel(self)

	local value = 100;
	return value;
end

-- KnockDown power
function SCR_GET_KDPOWER(self)

	local value = 0
	value = value + self.KDPow_BM;
	return math.floor(value);
end

function SCR_Get_MGP(self)

	local value = 500 + self.MGP_BM;
	return math.floor(value);
end

function SCR_Get_CAST(self)

	local value = 1;
	return 1;
end

function SCR_Get_BOOST(self)

	local value = 1;
	return 1;
end

function SCR_Get_JUMP(self)

	local value = 350;
	return value;
end

function SCR_Get_AddSplCount(self)

	return self.Lv + self.AddSplCount_BM;
end

function SCR_GET_MOVING_SHOT(pc)

	local jobfunc = _G[ "MOVING_SHOT_" .. pc.Job ]
	if jobfunc == nil then
		return 0;
	end

	return jobfunc(pc);

end

function SCR_GET_JUMPING_SHOT(pc)

	local jobfunc = _G[ "JUMPING_SHOT_" .. pc.Job ]
	if jobfunc == nil then
		return 1;
	end

	return jobfunc(pc);

end


function SCR_PC_MOVINGSHOTABLE(pc)

	local jobObj = GetJobObject(pc);
	if jobObj == nil then
		return 0;
	end

	if jobObj.CtrlType == 'Archer' then
		return 1;
	end

	if GetBuffByName(pc, 'Warrior_EnableMovingShot_Buff') then
		return 1;
	end

	if GetBuffByName(pc, 'Warrior_RushMove_Buff') then
		return 1;
	end

	return 0;

end

function SCR_MOVING_SHOT_SPEED(pc) -- archer moving shot
	
	local spd = 0;
	if pc.MovingShotable == 0 then
		return spd;
	end


	if GetJobObject(pc).CtrlType == 'Archer' then 
		spd = 0.8;
	end
	
	spd = spd + pc.MovingShot_BM;
	return spd;

end

function SCR_Get_MSTA(self)
    
	local itemSta = GetSumOfEquipItem(self, 'MSTA');
	if itemSta == nil then
		itemSta = 0;
	end

	local rewardProperty = GET_REWARD_PROPERTY(self, "MSTA")

	local result = 25000 + itemSta * 1000 + self.MaxSta_BM * 1000 + self.MAXSTA_Bonus * 1000 + (rewardProperty * 1000);
	return result;

end

function SCR_Get_Sta_RunStart(self)

	return 0;
	
end

function SCR_Get_Sta_Run(self)
	local value = 50;
	
	if self.DashRun == 1 then
		value = value + 500;
	end
	
	return 250 * value / 100;
end

function SCR_Get_Sta_Recover(self)

    local value = 0;

	if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
		return 0;
	end

    value = 400 + self.REST_BM + self.RSta_BM;

	if IsBuffApplied(self, 'SitRest') == 'YES' then	
	    return value * 2;
	end
	
    return value;

end

function SCR_Get_Sta_R_Delay(self)

	return 1000;

end

function SCR_Get_Sta_Runable(self)

	--return 3000;
	return 250;
end

function SCR_Get_Sta_Jump(self)

	--local temp = 100;
	--return 1500 * temp / 100;
	return 0;
end

function SCR_Get_Sta_Step(self)

	local temp = 100;

	return 2500 * temp / 100;
	-- return 5000;
end

function SCR_Get_GuardImpactTime(self)

	return 1500 + self.GuardImpactTime_BM;

end

function SCR_Get_PC_HitCount(pc)

	local RH = GetEquipItemForPropCalc(pc, 'RH');
	return RH.HitCount;

end

function SCR_GET_PC_SKLPOWER(self)
	local jobObj = GetJobObject(self);
	local byStat = 0;
	local byItem = GetSumOfEquipItem(self, 'SkillPower');
	local byBuff = self.SkillPower_BM;
	return math.floor( byStat + byItem + byBuff);
end

function SCR_GET_PC_HPDRAIN(pc)
	
	return 2 + pc.HPDrain_ADD;
	
end

function SCR_GET_PC_HPDRAIN_ADD(pc)

	return pc.HPDrain_BM;

end

function SCR_GET_PC_PIERCE(pc)

	return pc.Lv + pc.PIE_ADD;

end

function SCR_GET_PC_PIE_ADD(pc)

	return pc.PIE_BM;

end

function SCR_GET_PC_KDHIT(pc)

	return pc.KDHit_BM;
	
end

function SCR_GET_PC_KDBONUS(pc)
	local basestat = 120;
	local byItem = GetSumOfEquipItem(pc, 'KDBonus');
	local byStat = basestat;
	local byLevel = 10 * pc.Lv;
	local byBuff = pc.KDBonus_BM;
	local value = byItem + byStat + byLevel + byBuff;
	return value;
end

function SCR_GET_PC_KDDEFENCE(pc)
	local basestat = 30;
	local byItem = GetSumOfEquipItem(pc, 'KDDefence');
	local byStat = basestat;
	local byLevel = 10 * pc.Lv;
	local byBuff = pc.KDBonus_BM;
	local value = byItem + byStat + byLevel + byBuff;
	return value;
end


function SCR_GET_PC_GUARDABLE(pc)
	local rItem  = GetEquipItemForPropCalc(pc, 'RH');
	local lItem  = GetEquipItemForPropCalc(pc, 'LH');
	if lItem ~= nil and lItem.LHandSkill ~= "None" then	
		return 0;
	end
	
	--local hldGuard = GetStanceSkill(pc, "Highlander_CrossGuard");
	local pelGuard = GetStanceSkill(pc, "Warrior_Guard");
	
	--if rItem.ClassType == "THSword" then
	--	return 1;
	--end
	
	if IsBuffApplied(pc, "Impaler_Buff") == "YES" then
		return 0;
	end


	if pelGuard ~= nil and (lItem ~= nil and lItem.ClassType == "Shield") then	
		return 1; 
	end

	return 0;
end

function SCR_PC_GUARD_ON(pc)

    local Peltasta10_abil = GetAbility(pc, 'Peltasta10')
    local blkadd = math.floor(pc.Lv * 5.5);
    local defadd = 0;
    
    if Peltasta10_abil ~= nil then
        defadd = math.floor(pc.DEF * 0.1 * Peltasta10_abil.Level);
    end
    
    pc.BLK_BM = pc.BLK_BM + blkadd;
    pc.DEF_BM = pc.DEF_BM + defadd;
    pc.Jumpable = pc.Jumpable - 1;
	
    SetExProp(pc, 'ADD_BLK', blkadd);
    SetExProp(pc, 'ADD_BUFF', defadd);
    InvalidateStates(pc);
    
end

function SCR_PC_GUARD_OFF(pc)

    local blkadd = GetExProp(pc, 'ADD_BLK');
    local defadd = GetExProp(pc, 'ADD_BUFF');
    
    pc.BLK_BM = pc.BLK_BM - blkadd;
    pc.DEF_BM = pc.DEF_BM - defadd
    pc.Jumpable = pc.Jumpable + 1;
    
    InvalidateStates(pc);
    
end

 function SCR_Get_SkillAngle(self)
	
	local itemValue = GetSumOfEquipItem(self, 'SkillAngle');
	return self.SkillAngle_BM + itemValue;
	
 end

 function SCR_Get_SkillRange(self)
 
	local itemValue = GetSumOfEquipItem(self, 'SkillRange');
	return self.SkillRange_BM + itemValue;
 
 end
  
 

function SCR_Get_TrustRange(self)
 
	return GetSumOfEquipItem(self, "Aries_Range");

end

function SCR_Get_SlashRange(self)
 
	return GetSumOfEquipItem(self, "Slash_Range");
	 
end

function SCR_Get_StrikeRange(self)
 
	return GetSumOfEquipItem(self, "Strike_Range");
	 
end

function SCR_Get_PostDelay(self)

	return GetSumOfEquipItem(self, "PostDelay");

end

function SCR_GET_ADDFEVER(self)

	local addFeverCombo = 0;
	return addFeverCombo;
end


function SCR_GET_FIRE_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_FIRE");
    local byBuff = pc.Fire_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_ICE_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_ICE");
    local byBuff = pc.Ice_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_POISON_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_POISON");
    local byBuff = pc.Poison_Atk_BM;
    local byAbil;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_LIGHTNING_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LIGHTNING");
    local byBuff = pc.Lightning_Atk_BM;
    local byAbil;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_EARTH_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_EARTH");
    local byBuff = pc.Earth_Atk_BM;
    local byAbil;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_HOLY_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_HOLY");
    local byBuff = pc.Holy_Atk_BM;
    local byAbil;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_DARK_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_DARK");
    local byBuff = pc.Dark_Atk_BM;
    local byAbil;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Widling_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_WIDLING");
    local byBuff = pc.Widling_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Paramune_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_PARAMUNE");
    local byBuff = pc.Paramune_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Forester_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_FORESTER");
    local byBuff = pc.Forester_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Velnias_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_VELIAS");
    local byBuff = pc.Velnias_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Klaida_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_KLAIDA");
    local byBuff = pc.Klaida_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Cloth_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_CLOTH");
    local byBuff = pc.Cloth_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Leather_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LEATHER");
    local byBuff = pc.Leather_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Chain_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_CHAIN");
    local byBuff = pc.Chain_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Iron_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_IRON");
    local byBuff = pc.Iron_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_Ghost_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_GHOST");
    local byBuff = pc.Ghost_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_SmallSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_SMALLSIZE");
    local byBuff = pc.SmallSize_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_MiddleSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_MIDDLESIZE");
    local byBuff = pc.MiddleSize_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_LargeSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LARGESIZE");
    local byBuff = pc.LargeSize_Atk_BM;
    
    local value = byItem + byBuff;
	return math.floor(value);
end

function SCR_GET_BASE_WEAPON_DEF(pc)
    local value = pc.CON;
    return 0;
    --return value;
end

function SCR_GET_DEF_ARIES(pc)
    local byItem = GetSumOfEquipItem(pc, "AriesDEF");
    local byBuff = pc.DefAries_BM;
    local byStat = SCR_GET_BASE_WEAPON_DEF(pc)
    
    local value = byStat + byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_DEF_SLASH(pc)
    local byItem = GetSumOfEquipItem(pc, "SlashDEF");
    local byBuff = pc.DefSlash_BM;
    local byStat = SCR_GET_BASE_WEAPON_DEF(pc)
    
    local value = byStat + byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_DEF_STRIKE(pc)
    local byItem = GetSumOfEquipItem(pc, "StrikeDEF");
    local byBuff = pc.DefStrike_BM;
    local byStat = SCR_GET_BASE_WEAPON_DEF(pc)
    
    local value = byStat + byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_FIRE(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_FIRE");
    local byBuff = pc.ResFire_BM;
      
      local value = byItem + byBuff
      
	return math.floor(value);
end

function SCR_GET_RES_ICE(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_ICE");
    local byBuff = pc.ResIce_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_POISON(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_POISON");
    local byBuff = pc.ResPoison_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_LIGHTNING(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_LIGHTNING");
    local byBuff = pc.ResLightning_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_EARTH(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_EARTH");
    local byBuff = pc.ResEarth_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_HOLY(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_HOLY");
    local byBuff = pc.ResHoly_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_RES_DARK(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_DARK");
    local byBuff = pc.ResDark_BM;
    
    local value = byItem + byBuff;
    
	return math.floor(value);
end

function SCR_GET_SKL_ADD_COOLDOWN(pc)
    return 1;
end

function SCR_GET_ADDOVERHEAT(pc, skill)

	if skill == nil then
		return 0;
	end

	local cls = GetClassByType('skill_oh_reduce', pc.INT)
	if cls ~= nil then
		return math.floor( cls['Circle_'..skill.SklCircleLv] );
	end

	return 0;
end

function SCR_GET_PC_LIMIT_BUFF_COUNT(self)

	local count = 5;
	local TokenBuffCnt = 0

	if 'Warrior' == GetJobObject(self).CtrlType then
		count = 7;
	elseif 'Cleric' == GetJobObject(self).CtrlType then
	  count = 7;
	end
	
	-- �����ü��... 
	if 1 == IsDummyPC(self) then
		return count;
	end
	
	if 1 == IsPremiumState(self, ITEM_TOKEN) then
	  TokenBuffCnt = 1
	end
	
	local abil = GetAbility(self, "AddBuffCount")
	if abil ~= nil then
	    count = count + 1
	end
	
	count = count + self.LimitBuffCount_BM + TokenBuffCnt;

	return count;

end

function GET_MAXHATE_COUNT(self)

	local mapID = GetMapID(self);
	local cls = GetClassByType('Map', mapID);
	if cls ~= nil then
		local value = cls.MaxHateCount;
		value = value + self.MaxHateCount_BM
		return value;
	end

	return 100;
end

function GET_ArmorMaterial_ID(self)
	
	local equipbodyItem		= GetEquipItemForPropCalc(self, 'SHIRT');
	armorMaterial			= equipbodyItem.Material;
	
	if armorMaterial == 'Cloth' then
		self.ArmorMaterial = 'Cloth';
		return 1;
	elseif armorMaterial == 'Leather' then
		self.ArmorMaterial = 'Leather';
		return 2;
	elseif armorMaterial == 'Iron' then
		self.ArmorMaterial = 'Iron';
		return 3;
	elseif armorMaterial == 'Ghost' then
		self.ArmorMaterial = 'Ghost';
		return 4;
	elseif armorMaterial == 'Chain' then	
		self.ArmorMaterial = 'Chain';
		return 5;
	end
end

function SCR_GET_ARIES_ATKFACTOR_PC(self)
    return self.AriesAtkFactor_PC_BM;
end

function SCR_GET_SLASH_ATKFACTOR_PC(self)
    return self.SlashAtkFactor_PC_BM;
end

function SCR_GET_STRIKE_ATKFACTOR_PC(self)
    return self.StrikeAtkFactor_PC_BM;
end

function SCR_GET_MISSILE_ATKFACTOR_PC(self)
    return self.MissileAtkFactor_PC_BM;
end

function SCR_GET_FIRE_ATKFACTOR_PC(self)
    return self.FireAtkFactor_PC_BM;
end

function SCR_GET_ICE_ATKFACTOR_PC(self)
    return self.IceAtkFactor_PC_BM;
end

function SCR_GET_LIGHTNING_ATKFACTOR_PC(self)
    return self.LightningAtkFactor_PC_BM;
end

function SCR_GET_POISON_ATKFACTOR_PC(self)
    return self.PoisonAtkFactor_PC_BM;
end

function SCR_GET_EARTH_ATKFACTOR_PC(self)
    return self.EarthAtkFactor_PC_BM;
end

function SCR_GET_HOLY_ATKFACTOR_PC(self)
    return self.HolyAtkFactor_PC_BM;
end

function SCR_GET_DARK_ATKFACTOR_PC(self)
    return self.DarkAtkFactor_PC_BM;
end

function SCR_GET_ARIES_DEFFACTOR_PC(self)
    return self.AriesDefFactor_PC_BM;
end

function SCR_GET_SLASH_DEFFACTOR_PC(self)
    return self.SlashDefFactor_PC_BM;
end

function SCR_GET_STRIKE_DEFFACTOR_PC(self)
    return self.StrikeDefFactor_PC_BM;
end

function SCR_GET_MISSILE_DEFFACTOR_PC(self)
    return self.MissileDefFactor_PC_BM;
end

function SCR_GET_FIRE_DEFFACTOR_PC(self)
    return self.FireDefFactor_PC_BM;
end

function SCR_GET_ICE_DEFFACTOR_PC(self)
    return self.IceDefFactor_PC_BM;
end

function SCR_GET_LIGHTNING_DEFFACTOR_PC(self)
    return self.LightningDefFactor_PC_BM;
end

function SCR_GET_POISON_DEFFACTOR_PC(self)
    return self.PoisonDefFactor_PC_BM;
end

function SCR_GET_EARTH_DEFFACTOR_PC(self)
    return self.EarthDefFactor_PC_BM;
end

function SCR_GET_HOLY_DEFFACTOR_PC(self)
    return self.HolyDefFactor_PC_BM;
end

function SCR_GET_DARK_DEFFACTOR_PC(self)
    return self.DarkDefFactor_PC_BM;
end

function GET_REWARD_PROPERTY(self, propertyName)
	
	local sObj = GetSessionObject(self, 'ssn_klapeda')
	local rewardProperty = 0;

	if sObj == nil and IsServerObj(self) == 0 then
		local pc = GetMyPCObject()
		sObj = GetSessionObject(pc, 'ssn_klapeda')
	end

	if sObj ~= nil then
		local list, listCnt = GetClassList("reward_property");
		
		for i = 0, listCnt -1 do
			local cls = GetClassByIndexFromList(list, i);
			if cls ~= nil and TryGetProp(cls, "Property") == propertyName then
				if sObj[cls.ClassName] == 300 then
					rewardProperty = rewardProperty + cls.Value
				end
			end
		end
	end

	return rewardProperty
end