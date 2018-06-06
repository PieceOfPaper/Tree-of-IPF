
-- 어빌 UNLOCK체크용

function PC_PCAA(pc)
local jobHistory = GetJobHistorySting(pc)
	print(jobHistory)
end

function CHECK_ABILITY_LOCK(pc, ability)


	if ability.Job == "None" then
		return "UNLOCK";
	end

	local jobHistory = GetJobHistoryString(pc)
	
	if string.find(ability.Job, ";") == nil then
		
		if string.find(jobHistory, ability.Job) ~= nil then
			local jobCls = GetClass("Job", ability.Job)
		
			local abilGroupClass = GetClass("Ability_"..jobCls.EngName, ability.ClassName);
			if abilGroupClass == nil then
				abilGroupClass = GetClass("Ability", ability.ClassName);
			end

			if abilGroupClass == nil then
				IMC_NORMAL_INFO("abilGroupClass is nil!!  jobCls.EngName : "..jobCls.EngName.."  ability.ClassName : "..ability.ClassName)
				return "UNLOCK"
			end


			local unlockFuncName = abilGroupClass.UnlockScr;

			if abilGroupClass.UnlockScr == "None" then
				return "UNLOCK"
			end
		
			local scp = _G[unlockFuncName];
			local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, ability);
		
			return ret;
		end
	else
		local sList = StringSplit(jobHistory, ";");
		for i = 1, #sList do
			if string.find(ability.Job, sList[i]) ~= nil then
				local jobCls = GetClass("Job", sList[i])
				local abilGroupClass = GetClass("Ability_"..jobCls.EngName, ability.ClassName);
				if abilGroupClass == nil then
					abilGroupClass = GetClass("Ability", ability.ClassName);
				end

				local unlockFuncName = abilGroupClass.UnlockScr;

				if abilGroupClass.UnlockScr == "None" then
					return "UNLOCK"
				end
		
				local scp = _G[unlockFuncName];
				local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, ability);

				if ret == "UNLOCK" then
					return ret;
				end
			end
		end
	end

	IMC_NORMAL_INFO("abilityUnlock Error");
	return "UNLOCK";
	
	
			--[[


	if ability.Job ~= "None" and string.find(ability.Job, ";") == nil then
		
		local jobCls = GetClass("Job", ability.Job)
		
		local abilGroupClass = GetClass("Ability_"..jobCls.EngName, ability.ClassName);

		local unlockFuncName = abilGroupClass.UnlockScr;
		
		local scp = _G[unlockFuncName];
		local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, abilObj);
		
		return ret;
	end

	return "UNLOCK";
	]]--
end

function SCR_ABIL_NONE_ACTIVE(self, ability)
    
end

function SCR_ABIL_NONE_INACTIVE(self, ability)

end

function SCR_ABIL_JUMP_ACTIVE(self, ability)

	self.Jumpable = 1;

end

function SCR_ABIL_JUMP_INACTIVE(self, ability)

	self.Jumpable = 0;

end

function SCR_ABIL_DASH_ACTIVE(self, ability)

	self.Runnable = 1;

end

function SCR_ABIL_DASH_INACTIVE(self, ability)

	self.Runnable = 0;

end

function SCR_ABIL_STEP_ACTIVE(self, ability)

	self.Steppable = 1;

end

function SCR_ABIL_STEP_INACTIVE(self, ability)

	self.Steppable = 0;

end

function SCR_ABIL_MOVINGSHOT_ACTIVE(self, ability)

	self.MovingShotable = 1;

end

function SCR_ABIL_MOVINGSHOT_INACTIVE(self, ability)

	self.MovingShotable = 0;

end


--function SCR_GET_SwordMastery_Bonus(ability)
--	
--	return ability.Level * 100;
--	
--end
--
--function SCR_ABIL_SWORDMASTERY_ACTIVE(self, ability)
--
--	local rItem  = GetEquipItem(self, 'RH');
--	
--	if rItem.ClassType2 == "Sword" then
--		local addValue = self.MAXPATK * SCR_GET_SwordMastery_Bonus(ability) / 100
--		self.PATK_BM = self.PATK_BM + addValue;
--		SetExProp(ability, "ADD", addValue);
--	else
--		SetExProp(ability, "ADD", 0);
--	end
--
--
--	-- PATK_BM????려줬으??MINPATK?? MAXPATK????시 계산????야??는??
--	-- ???? self.MAXPATK????번 ??출??기??문??invalidate??needCalc값이 false??변경되??서 cp계산????시??????게??	
--	-- ?? MINPATK????시계산??고 MAXPATK?? ??전값을 그??????고??게 ??
--	-- ??럴??그냥 ??하??관??칼럼????시 계산??도??Invalidate(self, 관??값) ??주????게 처리가??
--	-- 좋??구조????니지??문제??결??빠름. 좋??방법????각??시간이??을??고????보기로.. 좋??????이??으????재??에????려주면 감사.
--	Invalidate(self, "MINPATK");
--	Invalidate(self, "MAXPATK");
--end

--function SCR_ABIL_SWORDMASTERY_INACTIVE(self, ability)
--
--	local addValue = GetExProp(ability, "ADD");
--	self.PATK_BM = self.PATK_BM - addValue;
--
--	Invalidate(self, "MINPATK");
--	Invalidate(self, "MAXPATK");
--end


function SCR_ABIL_HIGHLANDER9_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	local addValue = 0;
	
	if rItem.ClassType == "THSword" then
		addValue = math.floor(self.CRTATK * ability.Level * 0.1)
	end
	
	self.CRTATK_BM = self.CRTATK_BM + addValue;
	SetExProp(ability, "ADD_CRTATK", addValue);
	
    Invalidate(self, "CRTATK");
end

function SCR_ABIL_HIGHLANDER9_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD_CRTATK");	
	self.CRTATK_BM = self.CRTATK_BM - addValue;

	Invalidate(self, "CRTATK");
end




function SCR_GET_MaceMastery_Bonus(ability)
	
	return ability.Level * 5;
	
end

function SCR_ABIL_MACEMASTERY_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	
	if rItem.ClassType2 == "Mace" then
		local addValue = self.MAXPATK * SCR_GET_MaceMastery_Bonus(ability) / 100
		self.PATK_BM = self.PATK_BM + addValue;
		SetExProp(ability, "ADD", addValue);
	else
		SetExProp(ability, "ADD", 0);
	end
end

function SCR_ABIL_MACEMASTERY_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD");
	self.PATK_BM = self.PATK_BM - addValue;	
	
end




function SCR_GET_StaffMastery_Bonus(ability)
	
	return ability.Level * 5;
	
end

function SCR_ABIL_STAFFMASTERY_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	
	if rItem.ClassType2 == "Staff" or rItem.ClassType2 == "Wand" then
		local addValue = self.MAXMATK * SCR_GET_StaffMastery_Bonus(ability) / 100
		self.MATK_BM = self.MATK_BM + addValue;
		SetExProp(ability, "ADD", addValue);
	else
		SetExProp(ability, "ADD", 0);
	end
end

function SCR_ABIL_STAFFMASTERY_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD");
	self.MATK_BM = self.MATK_BM - addValue;	
	
end



function SCR_ABIL_PYROMANCER8_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	local addValue = 0;
	
	if rItem.ClassType == "THStaff" then
		addValue = ability.Level * 3
	end
	
	self.Fire_Atk_BM = self.Fire_Atk_BM + addValue;
	SetExProp(ability, "ADD_FIRE", addValue);

end

function SCR_ABIL_PYROMANCER8_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD_FIRE");
	self.Fire_Atk_BM = self.Fire_Atk_BM - addValue;
	
end


function SCR_ABIL_CRYOMANCER5_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	local addValue = 0;
	
	if rItem.ClassType == "Staff" then
		addValue = ability.Level * 3
	end
	
	self.Ice_Atk_BM = self.Ice_Atk_BM + addValue;
	SetExProp(ability, "ADD_ICE", addValue);

end

function SCR_ABIL_CRYOMANCER5_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD_ICE");
	self.Ice_Atk_BM = self.Ice_Atk_BM - addValue;
	
end



function SCR_ABIL_SORCERER2_ACTIVE(self, ability)

    local addrsp = ability.Level
    self.RSP_BM = self.RSP_BM + addrsp
    SetExProp(ability, "ADD_RSP", addrsp);

end

function SCR_ABIL_SORCERER2_INACTIVE(self, ability)

	local addrsp = GetExProp(ability, "ADD_RSP");
	self.RSP_BM = self.RSP_BM - addrsp

end



function SCR_GET_BowMastery_Bonus(ability)
	
	return ability.Level * 5;
	
end

function SCR_ABIL_BOWMASTERY_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	
	if rItem.ClassType2 == "Bow" then
		local addValue = self.MAXPATK * SCR_GET_BowMastery_Bonus(ability) / 100;
		self.PATK_BM = self.PATK_BM + addValue;
		SetExProp(ability, "ADD", addValue);
	else
		SetExProp(ability, "ADD", 0);
	end
end

function SCR_ABIL_BOWMASTERY_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD");
	self.PATK_BM = self.PATK_BM - addValue;
	
end



function SCR_ABIL_ELEMENTALIST6_ACTIVE(self, ability)

    local resiceadd = 4 + ability.Level;
    local resfireadd = 4 + ability.Level;
    local reslightadd = 4 + ability.Level;
	
	if IS_PC(self) == true then
		self.ResIce_BM = self.ResIce_BM + resiceadd;
		self.ResFire_BM = self.ResFire_BM + resfireadd;
		self.ResLightning_BM = self.ResLightning_BM + reslightadd;
	end
    
	SetExProp(ability, "ADD_ICE", resiceadd);
    SetExProp(ability, "ADD_FIRE", resfireadd);
    SetExProp(ability, "ADD_LIGHT", reslightadd);
	
end

function SCR_ABIL_ELEMENTALIST6_INACTIVE(self, ability)

    local resiceadd = GetExProp(ability, "ADD_ICE");
    local resfireadd = GetExProp(ability, "ADD_FIRE");
    local reslightadd = GetExProp(ability, "ADD_LIGHT");
    
	if IS_PC(self) == true then
		self.ResIce_BM = self.ResIce_BM - resiceadd;
		self.ResFire_BM = self.ResFire_BM - resfireadd;
		self.ResLightning_BM = self.ResLightning_BM - reslightadd;
	end
end

function CHECK_ARMORMATERIAL(self, meaterial)

    local count = 0;
    
	if GetEquipItem(self, 'SHIRT').Material == meaterial then
	    count = count + 1
	end
	if GetEquipItem(self, 'PANTS').Material == meaterial then
	    count = count + 1
	end
	if GetEquipItem(self, 'GLOVES').Material == meaterial then
	    count = count + 1
	end
	if GetEquipItem(self, 'BOOTS').Material == meaterial then
	    count = count + 1
	end
	
	return count
	
end


function SCR_ABIL_CLOTH_ACTIVE(self, ability)

    local count = CHECK_ARMORMATERIAL(self, "Cloth")
    local addmsp = 0;
    local addmdef = 0;
	
	if count >= 3 then
	    addmsp = math.floor(ability.Level * 10.05);
	end
	
	if count == 4 then
	    addmdef = math.floor(ability.Level / 2);
	end
	
	SetExProp(self, "CLOTH_ARMOR_COUNT", count);
	
	self.MSP_BM = self.MSP_BM + addmsp;
	self.MDEF_BM = self.MDEF_BM + addmdef;
	Invalidate(self, "MSP");
	Invalidate(self, "MDEF");
	SetExProp(ability, "ADD_MSP", addmsp);
	SetExProp(ability, "ADD_MDEF", addmdef);

end

function SCR_ABIL_CLOTH_INACTIVE(self, ability)

	local addmsp = GetExProp(ability, "ADD_MSP");
	local addmdef = GetExProp(ability, "ADD_MDEF");
	
	self.MSP_BM = self.MSP_BM - addmsp;
	self.MDEF_BM = self.MDEF_BM - addmdef;
	Invalidate(self, "MSP");
	Invalidate(self, "MDEF");
	
end

function SCR_ABIL_MERGEN(self)
	local Bow_Attack = GetSkill(self, 'Bow_Attack');
	if nil ~= Bow_Attack then
		InvalidateSkill(self, 'Bow_Attack');
		SendSkillProperty(self, Bow_Attack);
	end

	local CrossBow_Attack = GetSkill(self, 'CrossBow_Attack');
	if nil ~= CrossBow_Attack then
		InvalidateSkill(self, 'CrossBow_Attack');
		SendSkillProperty(self, CrossBow_Attack);
	end
end

function SCR_ABIL_MERGEN1_ACTIVE(self, ability)
	SCR_ABIL_MERGEN(self)
end

function SCR_ABIL_MERGEN1_INACTIVE(self, ability)
	SCR_ABIL_MERGEN(self)
end

function SCR_ABIL_LEATHER_ACTIVE(self, ability)

    local count = CHECK_ARMORMATERIAL(self, "Leather")
    local adddr = 0;
    
	if count >= 3 then
	    adddr = ability.Level;
	end
	
	if count == 4 then
	    adddr = math.floor(adddr * 1.5);
	end

	self.DR_BM = self.DR_BM + adddr;
	Invalidate(self, "DR");
	SetExProp(ability, "ADD_DR", adddr);

end

function SCR_ABIL_LEATHER_INACTIVE(self, ability)

	local adddr = GetExProp(ability, "ADD_DR");
	
	self.DR_BM = self.DR_BM - adddr;
	Invalidate(self, "DR");
	
end


function SCR_ABIL_IRON_ACTIVE(self, ability)

    local count = CHECK_ARMORMATERIAL(self, "Iron")
    local addmhp = 0;
    local addsta = 0;
	
	if count >= 3 then
	    addmhp = ability.Level * 34;
	end
	
	if count == 4 then
	    addsta = math.floor(ability.Level / 3);
	end
	
	SetExProp(self, "IRON_ARMOR_COUNT", count);

	self.MHP_BM = self.MHP_BM + addmhp;
	self.MaxSta_BM = self.MaxSta_BM + addsta;
	Invalidate(self, "MHP");
	Invalidate(self, "MaxSta");
	SetExProp(ability, "ADD_MHP", addmhp);
	SetExProp(ability, "ADD_MSTA", addsta);

end

function SCR_ABIL_IRON_INACTIVE(self, ability)

	local addmhp = GetExProp(ability, "ADD_MHP");
	local addsta = GetExProp(ability, "ADD_MSTA");
	
	self.MHP_BM = self.MHP_BM - addmhp;
	self.MaxSta_BM = self.MaxSta_BM - addsta;
	Invalidate(self, "MHP");
	Invalidate(self, "MaxSta");
end


function SCR_ABIL_CATAPHRACT26_ACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_EarthWave")
    if skl ~= nil then
        skl.Attribute = "Earth"
    end
    
end

function SCR_ABIL_CATAPHRACT26_INACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_EarthWave")
    if skl ~= nil then
        skl.Attribute = "Melee"
    end

end

function SCR_ABIL_CATAPHRACT28_ACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_EarthWave")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_CATAPHRACT28_INACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_EarthWave")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function SCR_ABIL_CATAPHRACT29_ACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_SteedCharge")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
    
end

function SCR_ABIL_CATAPHRACT29_INACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_SteedCharge")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function SCR_ABIL_CATAPHRACT30_ACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_DoomSpike")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
    
end

function SCR_ABIL_CATAPHRACT30_INACTIVE(self, ability)

    local skl = GetSkill(self, "Cataphract_DoomSpike")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function SCR_ABIL_PALADIN4_ACTIVE(self, ability)
    local skl = GetSkill(self, "Paladin_Smite")
    if skl ~= nil then
        skl.KnockDownHitType = 4
        skl.KDownValue = 250
    end
end


function SCR_ABIL_PALADIN4_INACTIVE(self, ability)
    local skl = GetSkill(self, "Paladin_Smite")
    if skl ~= nil then
        skl.KnockDownHitType = 1
        skl.KDownValue = 10
    end
end

function SCR_ABIL_HIGHLANDER32_ACTIVE(self, ability)

    local skl = GetSkill(self, "Highlander_ScullSwing")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_HIGHLANDER32_INACTIVE(self, ability)

    local skl = GetSkill(self, "Highlander_ScullSwing")
    if skl ~= nil then
        skl.KnockDownHitType = 3
    end

end

function SCR_ABIL_RODELERO30_ACTIVE(self, ability)
    local skl = GetSkill(self, "Rodelero_TargeSmash")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
end

function SCR_ABIL_RODELERO30_INACTIVE(self, ability)
    local skl = GetSkill(self, "Rodelero_TargeSmash")
    if skl ~= nil then
        skl.KnockDownHitType = 3
    end
end

function SCR_ABIL_SCHWARZEREITER1_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	local lItem  = GetEquipItem(self, 'LH');
    local addhr = 0;
    
	if rItem.ClassType2 == "Gun" or lItem.ClassType2 == "Gun" then
		addhr = ability.Level * 500
	end
	
	--self.HR_BM = self.HR_BM + addhr;
	
	--SetExProp(ability, "ADD_HR", addhr);
	SetExProp(self, "ABIL_HR_ADD", addhr)
end

function SCR_ABIL_SCHWARZEREITER1_INACTIVE(self, ability)
	--local addhr = GetExProp(ability, "ADD_HR");
	
	--self.HR_BM = self.HR_BM - addhr;
	
	DelExProp(self, "ABIL_HR_ADD")
end

function SCR_ABIL_CATAPHRACT31_ACTIVE(self, ability)
	local rItem  = GetEquipItem(self, 'RH');
    local addBlkBreak = 0;
	
	if rItem.ClassType == "THSpear" then
		addBlkBreak = ability.Level * 1000
	end
	
	SetExProp(self, "ABIL_BLKBREAK_ADD", addBlkBreak)
end

function SCR_ABIL_CATAPHRACT31_INACTIVE(self, ability)
    DelExProp(self, "ABIL_BLKBREAK_ADD")
end


function SCR_ABIL_WEIGHT_ACTIVE(self, ability)
    self.MaxWeight_BM = self.MaxWeight_BM + ability.Level * 20
end

function SCR_ABIL_WEIGHT_INACTIVE(self, ability)
    self.MaxWeight_BM = self.MaxWeight_BM - ability.Level * 20
end

function SCR_ABIL_CRYOMANCER21_ACTIVE(self, ability)
    local lItem  = GetEquipItem(self, 'LH');
    local addmdef = 0;
    local addresice = 0;
    
	if lItem.ClassType == "Shield" then
		addmdef = math.floor(lItem.DEF * ability.Level * 0.25)
		addresice = math.floor(lItem.DEF * ability.Level * 0.25)
	end
	
	self.MDEF_BM = self.MDEF_BM + addmdef; 
	self.ResIce_BM = self.ResIce_BM + addresice;
	
	SetExProp(ability, "ADD_MDEF", addmdef);
	SetExProp(ability, "ADD_RESICE", addresice);
end

function SCR_ABIL_CRYOMANCER21_INACTIVE(self, ability)
    local addmdef = GetExProp(ability, "ADD_MDEF", addmdef);
    local addresice = GetExProp(ability, "ADD_RESICE", addresice);
    
	self.MDEF_BM = self.MDEF_BM - addmdef; 
	self.ResIce_BM = self.ResIce_BM - addresice;
end




function SCR_GET_Penetration_Bonus(ability)
	
	return ability.Level * 1
	
end


-- SCR_ABIL_KRIWI1
function SCR_ABIL_KRIWI1_ACTIVE(self, ability)

    self.ResFire_BM = self.ResFire_BM + (ability.Level * 5)
    self.ResDark_BM = self.ResDark_BM - (ability.Level * 3)

end

function SCR_ABIL_KRIWI1_INACTIVE(self, ability)

    self.ResFire_BM = self.ResFire_BM - (ability.Level * 5)
    self.ResDark_BM = self.ResDark_BM + (ability.Level * 3)

end

function SCR_ABIL_INQUISITOR9_ACTIVE(self, ability)

	local rItem  = GetEquipItem(self, 'RH');
	
    local addresdark = 0
	if rItem.ClassType == "Mace" then
		addresdark = addresdark + ability.Level * 10
	end
	
	self.ResDark_BM = self.ResDark_BM + addresdark
	SetExProp(ability, "ABIL_RESDARK_ADD", addresdark)
end

function SCR_ABIL_INQUISITOR9_INACTIVE(self, ability)
	local addresdark = GetExProp(ability, "ABIL_RESDARK_ADD")
	self.ResDark_BM = self.ResDark_BM - addresdark
end



function SCR_GET_SwordMastery_Bonus(ability)
	
	return 5 + ability.Level;
	
end

function SCR_ABIL_SWORDMASTERY_ACTIVE(self, ability)  

	local rItem  = GetEquipItem(self, 'RH');
	
	if rItem.ClassType == "Sword" then
		local addValue = self.MAXPATK * (SCR_GET_SwordMastery_Bonus(ability) / 100)
		self.PATK_BM = self.PATK_BM + addValue;
		SetExProp(ability, "ADD", addValue);
	else
		SetExProp(ability, "ADD", 0);
	end
end

function SCR_ABIL_SWORDMASTERY_INACTIVE(self, ability)

	local addValue = GetExProp(ability, "ADD");
	self.PATK_BM = self.PATK_BM - addValue;
	
end













function SCR_GET_DustDevil_Bonus(ability)
	
	return 100 + (ability.Level * 10);
	
end

function SCR_ABIL_DUSTDEVIL_ACTIVE(self, ability)  

	
end

function SCR_ABIL_DUSTDEVIL_INACTIVE(self, ability)


end


function SCR_GET_WHIPPINGTOP_Bonus(ability)
	
	return ability.Level * 0.5;
	
end

function SCR_ABIL_WHIPPINGTOP_ACTIVE(self, ability)  

	
end

function SCR_ABIL_WHIPPINGTOP_INACTIVE(self, ability)


end

function SCR_ABIL_CRTDR_ACTIVE(self, ability)

	self.CRTDR_BM = self.CRTDR_BM + ability.Level * 0.5 + 4;

end

function SCR_ABIL_CRTDR_INACTIVE(self, ability)

	self.CRTDR_BM = self.CRTDR_BM - ability.Level * 0.5 - 4;

end

-- MagicArrow
function SCR_ABIL_MagicArrow_ACTIVE(self, ability)

	self.ATK_BM = self.ATK_BM + self.Lv / 3;
end

function SCR_ABIL_MagicArrow_INACTIVE(self, ability)

	self.ATK_BM = self.ATK_BM - self.Lv / 3;
end


function SCR_ABIL_Kriwi4_ACTIVE(self, ability)
	InvalidateSkill(self, 'Kriwi_Zaibas');
end

function SCR_ABIL_Kriwi4_INACTIVE(self, ability)
	InvalidateSkill(self, 'Kriwi_Zaibas');
end


function SCR_ABIL_MONK3_ACTIVE(self, ability)

    local skl = GetSkill(self, "Monk_PalmStrike")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_MONK3_INACTIVE(self, ability)

    local skl = GetSkill(self, "Monk_PalmStrike")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function SCR_ABIL_MONK9_ACTIVE(self, ability)

    local skl = GetSkill(self, "Monk_HandKnife")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_MONK9_INACTIVE(self, ability)

    local skl = GetSkill(self, "Monk_HandKnife")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function TX_SCR_SET_ABIL_HEADSHOT_OPTION(pc, tx, active)
	local skl = GetSkill(pc, 'Musketeer_HeadShot')
	if nil == skl then
		return false;
	end

	local sklValue, overValue = 0, 0;
	if active == 1 then
		sklValue = 20000;
		overValue = 20000;
		SetExProp(skl, "CoolTimeForceStart", 0);
	else -- no active state: no overheat 
		sklValue = 0;
		overValue = 0;
		SetExProp(skl, "CoolTimeForceStart", 1);
	end
	TxSetIESProp(tx, skl, "SklUseOverHeat", sklValue);
	TxSetIESProp(tx, skl, "OverHeatDelay", overValue);
	return true;
end