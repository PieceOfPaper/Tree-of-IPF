function PC_PCAA(pc)
local jobHistory = GetJobHistorySting(pc)
    print(jobHistory)
end

function LOGGING_ABILITY_CHECK(isEnableLogging, abilityName, logMsg)
	if isEnableLogging ~= nil and isEnableLogging == true then
		IMC_LOG("LOGGING_ABILITY_CHECK", "AbilityName : " .. abilityName .. ", LogMsg : " .. logMsg);
	end
end

function CHECK_ABILITY_LOCK(pc, ability, isEnableLogging)    
    if IsServerSection(pc) == 1 then
        if IS_REAL_PC(pc) == 'NO' then  -- 진짜 PC가 ??니??--
            if GetExProp(pc, "BUNSIN") == 1 then    -- ??는 분신?¸? --
                local bunsinOwner = GetExArgObject(pc, 'BUNSIN_OWNER'); -- 분신 본체가 ??는가? --
                if bunsinOwner == nil then
					LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[LOCK] BunsinOwner is nullptr");
                    return 'LOCK';
                else
                    pc = bunsinOwner;   -- ??는 본체??--
                end
            else
				LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[LOCK] Not Real Pc");
                return 'LOCK';
            end
        end
    end
    
    if ability.Job == "None" then
		LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[UNLOCK] Ability Job is None");
        return "UNLOCK";
    end

    local jobHistory = '';
    if IsServerObj(pc) == 1 then
        jobHistory = GetJobHistoryString(pc);
    else
        jobHistory = GetMyJobHistoryString();
    end
    
    if string.find(ability.Job, ";") == nil then
        
        if string.find(jobHistory, ability.Job) ~= nil then
            local jobCls = GetClass("Job", ability.Job)
        
            local abilGroupClass = GetClass("Ability_"..jobCls.EngName, ability.ClassName);
            if abilGroupClass == nil then
                abilGroupClass = GetClass("Ability", ability.ClassName);
            end

            if abilGroupClass == nil then
                IMC_LOG("INFO_NORMAL", "abilGroupClass is nil!!  jobCls.EngName : "..jobCls.EngName.."  ability.ClassName : "..ability.ClassName)
				LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[UNLOCK] abilGroupClass is nullptr");
                return "UNLOCK"
            end

            local unlockFuncName = TryGetProp(abilGroupClass, 'UnlockScr', 'None');
            if unlockFuncName == 'None' then
                LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[UNLOCK] abilGroupClass.UnlockScr is None");
                return "UNLOCK"
            end
        
            local scp = _G[unlockFuncName];
            local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, ability);
        
			LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[" .. ret .. "] Result1");
			
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
                                
                local unlockFuncName = TryGetProp(abilGroupClass, 'UnlockScr')

                if  unlockFuncName == nil or abilGroupClass.UnlockScr == "None" then
					LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[UNLOCK] abilGroupClass.UnlockScr is None");
                    return "UNLOCK"
                end

                local scp = _G[unlockFuncName];
                local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, ability);

                if ret == "UNLOCK" then
					LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[" .. ret .. "] Result2");
                    return ret;
                end
            end
        end
    end

    IMC_LOG("INFO_NORMAL", "abilityUnlock Error");
	LOGGING_ABILITY_CHECK(isEnableLogging, ability.ClassName, "[UNLOCK] Error1");
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

function GET_ABILITY_SKILL_CATEGORY_LIST(abilClsName)
    local abilCls = GetClass("Ability", abilClsName);
    if abilCls == nil then
        return {}
    end
    if abilCls.SkillCategory == "All" or abilCls.SkillCategory == "None" then
        return {}
    end
    local category_list = StringSplit(abilCls.SkillCategory, ';')
    return category_list
end

function IS_ACTIVE_ABILITY(self, abilName)
    if IS_PC(self) == false then
        return 0;
    end

    local abil = GetAbility(self, abilName);
    if abil ~= nil then
        if TryGetProp(abil, 'ActiveState') == 1 then
            return 1;
        end

        if TryGetProp(abil, 'AlwaysActive') == 'YES' then
            return 1;
        end
    end
    
    return 0;
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

function SCR_ABIL_HIGHLANDER9_ACTIVE(self, ability)
    if GetExProp(self, "BUNSIN") == 1 then
        return
    end
    
    local rItem  = GetEquipItem(self, 'RH');
    if rItem.ClassType == "THSword" then
        AddBuff(self, self, "Highlander9_Buff");
    end
end

function SCR_ABIL_HIGHLANDER9_INACTIVE(self, ability)
    RemoveBuff(self, "Highlander9_Buff");
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
	local crtHR = TryGetProp(self, "CRTHR")
	local crthrRate = 0
    local rItem  = GetEquipItem(self, 'RH');
    if rItem.ClassType == "Staff" then
		SetCastingSpeedBuffInfo(self, "StaffMastery", 50);
    end
end

function SCR_ABIL_STAFFMASTERY_INACTIVE(self, ability)
	RemoveCastingSpeedBuffInfo(self, "StaffMastery");
end


function SCR_ABIL_CRYOMANCER5_ACTIVE(self, ability)

--    local rItem  = GetEquipItem(self, 'RH');
--    local addValue = 0;
--    local MINMATK = TryGetProp(self, "MINMATK")
--    if rItem.ClassType == "Staff" then
--        addValue = math.floor(MINMATK * ability.Level * 0.03)
--    end
-- 
--    self.Ice_Atk_BM = self.Ice_Atk_BM + addValue;
--    SetExProp(ability, "ADD_ICE", addValue);

end

function SCR_ABIL_CRYOMANCER5_INACTIVE(self, ability)

--    local addValue = GetExProp(ability, "ADD_ICE");
--    self.Ice_Atk_BM = self.Ice_Atk_BM - addValue;
    
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
    local lowestGrade = nil;
    
    local itemList = { };
    itemList[#itemList + 1] = "SHIRT";
    itemList[#itemList + 1] = "PANTS";
    itemList[#itemList + 1] = "GLOVES";
    itemList[#itemList + 1] = "BOOTS";
	
	local noItemList = { };
	noItemList[#noItemList + 1] = "NoShirt";
	noItemList[#noItemList + 1] = "NoPants";
	noItemList[#noItemList + 1] = "NoGloves";
	noItemList[#noItemList + 1] = "NoBoots";
    
    for i = 1, #itemList do
    	local item = GetEquipItem(self, itemList[i]);
    	if TryGetProp(item, "Material", "None") == meaterial and 0 == table.find(noItemList, TryGetProp(item, "ClassName", "None")) then
    		count = count + 1;
    		local itemGrade = TryGetProp(item, "ItemGrade", 1);
    		if lowestGrade == nil or lowestGrade > itemGrade then
    			lowestGrade = itemGrade;
    		end
    	end
    end
	
	if lowestGrade == nil then
		lowestGrade = 1;
	end
	
    return count, lowestGrade;
    
end


function SCR_ABIL_CLOTH_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Cloth");
    
    local value = 0;
    
    if count >= 4 then
	    value = 150     -- 15%
	end
    
    SetExProp(self, "CLOTH_ARMOR_ABIL_VALUE", value);
end

function SCR_ABIL_CLOTH_INACTIVE(self, ability)
    
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
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Leather")
	
    local crtValue = 0;
    local damageValue = 0;
    
    if count >= 4 then
	    crtValue = 200;     -- 20%
	    damageValue = 150;  -- 15%
        
        if IS_ACTIVE_ABILITY(self, "Hunter16") == 1 then
            AddBuff(self, self, "Hunter_Companion_Bonus_Buff");
        end
	end
    
    SetExProp(self, "LEATHER_ARMOR_ABIL_VALUE", crtValue);
    SetExProp(self, "LEATHER_ARMOR_ABIL_VALUE_DAMAGE", damageValue);
end

function SCR_ABIL_LEATHER_INACTIVE(self, ability)
	RemoveBuff(self, "Hunter_Companion_Bonus_Buff");
end


function SCR_ABIL_IRON_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Iron")
    
    local value = 0;
    
    if count >= 4 then
	    value = 150     -- 15%
	end
    
    SetExProp(self, "IRON_ARMOR_ABIL_VALUE", value);
end

function SCR_ABIL_IRON_INACTIVE(self, ability)
    
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
    local skl = GetSkill(self, "Cleric_Smite")
    if skl ~= nil then
        skl.KnockDownHitType = 4
        skl.KDownValue = 250
    end
end


function SCR_ABIL_PALADIN4_INACTIVE(self, ability)
    local skl = GetSkill(self, "Cleric_Smite")
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
    
    if rItem.ClassType == "Musket" then
        addhr = ability.Level * 500
        SetExProp(self, "MUSKET_HR_ADD", addhr)
    elseif lItem.ClassType == "Pistol" then
        addhr = ability.Level * 500
        SetExProp(self, "PISTOL_HR_ADD", addhr)
    end
    
    --self.HR_BM = self.HR_BM + addhr;
    
    --SetExProp(ability, "ADD_HR", addhr);
    --SetExProp(self, "ABIL_HR_ADD", addhr)
end

function SCR_ABIL_SCHWARZEREITER1_INACTIVE(self, ability)
    --local addhr = GetExProp(ability, "ADD_HR");
    
    --self.HR_BM = self.HR_BM - addhr;
    DelExProp(self, "MUSKET_HR_ADD")
    DelExProp(self, "PISTOL_HR_ADD")
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
        addmdef = math.floor(lItem.DEF * ability.Level * 0.05)
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
    if rItem.ClassType == "Mace" or rItem.ClassType == "THMace" then
        addresdark = ability.Level * 10
    end
    
    self.ResDark_BM = self.ResDark_BM + addresdark
    
    SetExProp(ability, "ABIL_RESDARK_ADD", addresdark)
end

function SCR_ABIL_INQUISITOR9_INACTIVE(self, ability)
    local addresdark = GetExProp(ability, "ABIL_RESDARK_ADD")
    
    self.ResDark_BM = self.ResDark_BM - addresdark
end

function SCR_ABIL_SWORDMASTERY_ACTIVE(self, ability)
    local addDEF = 0;
    local addSpeed = 0;

    local rItem  = GetEquipItem(self, 'RH');
    if rItem.ClassType == "Sword" then
        local lItem  = GetEquipItem(self, 'LH');
        if lItem.ClassType == "Shield" then
            local akt = (rItem.MINATK + rItem.MAXATK) / 2
            addDEF = math.floor(akt * 0.2);
        else
            addSpeed = 200;
        end
    end
    
    self.DEF_BM = self.DEF_BM + addDEF;
    
    SetExProp(ability, "ABIL_ADD_DEF", addDEF);
    SetExProp(self, "ABIL_ADD_ATKSPD", addSpeed);
end

function SCR_ABIL_SWORDMASTERY_INACTIVE(self, ability)
    local addDEF = GetExProp(ability, "ABIL_ADD_DEF");
    DelExProp(self, "ABIL_ADD_ATKSPD");
    self.DEF_BM = self.DEF_BM - addDEF;
end

function SCR_ABIL_SCHWARZEREITER2_ACTIVE(self, ability)
    local lItem  = GetEquipItem(self, 'LH');
    local value = 0;
    if lItem.ClassType == "Pistol" then
        value = 1;
    end
    SetExProp(self, "ABIL_ADD_HIT", value)
end

function SCR_ABIL_SCHWARZEREITER2_INACTIVE(self, ability)
    DelExProp(self, "ABIL_ADD_HIT")
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

end

function SCR_ABIL_MONK3_INACTIVE(self, ability)

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


function SCR_ABIL_DRAGOON14_ACTIVE(self, ability)

    local skl = GetSkill(self, "Dragoon_Dethrone")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_DRAGOON14_INACTIVE(self, ability)

    local skl = GetSkill(self, "Dragoon_Dethrone")
    if skl ~= nil then
        skl.KnockDownHitType = 3
    end

end

function SCR_ABIL_THSWORD_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addSR = 0
    if rItem.ClassType == "THSword" then
        addSR = 1
    end

    SetExProp(self, "ABIL_THSWORD_SR", addSR)
end

function SCR_ABIL_THSWORD_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THSWORD_SR")
end

function SCR_ABIL_THSTAFF_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addSR = 0
    if rItem.ClassType == "THStaff" then
        addSR = 1
    end
    
    SetExProp(self, "ABIL_THSTAFF_SR", addSR)
end

function SCR_ABIL_THSTAFF_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THSTAFF_SR")
end

function SCR_ABIL_THSPEAR_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addSkillRange = 0
    if rItem.ClassType == "THSpear" then
        addSkillRange = 10
    end
    
    SetExProp(self, "ABIL_THSPEAR_RANGE", addSkillRange)
end

function SCR_ABIL_THSPEAR_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THSPEAR_RANGE")
end

function SCR_ABIL_THMACE_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addBlkBreak = 0
    if rItem.ClassType == "THMace" then
        addBlkBreak = 85
    end
    
    SetExProp(self, "ABIL_THMACE_BLKBLEAK", addBlkBreak)
end

function SCR_ABIL_THMACE_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THMACE_BLKBLEAK")
end

function SCR_ABIL_THMACE_SR_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addSR = 0
    if rItem.ClassType == "THMace" then
        addSR = 5
    end
	
    SetExProp(self, "ABIL_THMACE_SR", addSR)
end

function SCR_ABIL_THMACE_SR_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THMACE_SR")
end

function SCR_ABIL_THMACE_StrikeDamage_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addDamageRate = 0
    if rItem.ClassType == "THMace" then
        addDamageRate = 0.1
    end
	
    SetExProp(self, "ABIL_THMACE_STRIKE_DAMAGE", addDamageRate)
end

function SCR_ABIL_THMACE_StrikeDamage_INACTIVE(self, ability)
    DelExProp(self, "ABIL_THMACE_STRIKE_DAMAGE")
end

function SCR_ABIL_SPEAR_ACTIVE(self, ability)
    local rItem  = GetEquipItem(self, 'RH');
    local addSkillRange = 0
    if rItem.ClassType == "Spear" then
        addSkillRange = 5
    end
    
    SetExProp(self, "ABIL_SPEAR_RANGE", addSkillRange)
end

function SCR_ABIL_SPEAR_INACTIVE(self, ability)
    DelExProp(self, "ABIL_SPEAR_RANGE")
end



function SCR_ABIL_KABBALIST21_ACTIVE(self, ability)
        local addMaxMATKRate = 0.0;
        
        local rItem  = GetEquipItem(self, 'RH');
        local rItemType = TryGetProp(rItem, 'ClassType');
        if rItem ~= nil and (rItemType == 'Staff' or rItemType == 'Mace') then
    	    addMaxMATKRate = 0.2;
    	end
    	
    	self.MAXMATK_RATE_BM = self.MAXMATK_RATE_BM + addMaxMATKRate;
    	SetExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE", addMaxMATKRate);
	end

function SCR_ABIL_KABBALIST21_INACTIVE(self, ability)
    local addMaxMATKRate = GetExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE");
    self.MAXMATK_RATE_BM = self.MAXMATK_RATE_BM - addMaxMATKRate;
    DelExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE");
end

function SCR_ABIL_KABBALIST22_ACTIVE(self, ability)
	local addMSPD = 0;
	local addBLKABLE = 0;
	
	local count = CHECK_ARMORMATERIAL(self, "Cloth")
	if count >= 4 then
		addMSPD = 5;
		addBLKABLE = 1;
	end
	
	self.MSPD_BM = self.MSPD_BM + addMSPD;
	self.BLKABLE_BM = self.BLKABLE_BM + addBLKABLE;
	
	SetExProp(self, "ABIL_KABBALIST22_MSPD", addMSPD);
	SetExProp(self, "ABIL_KABBALIST22_BLKABLE", addBLKABLE);
end

function SCR_ABIL_KABBALIST22_INACTIVE(self, ability)
	local addMSPD = GetExProp(self, "ABIL_KABBALIST22_MSPD");
	local addBLKABLE = GetExProp(self, "ABIL_KABBALIST22_BLKABLE");
	
	self.MSPD_BM = self.MSPD_BM - addMSPD;
	self.BLKABLE_BM = self.BLKABLE_BM - addBLKABLE;
	
	DelExProp(self, "ABIL_KABBALIST22_MSPD");
	DelExProp(self, "ABIL_KABBALIST22_BLKABLE");
end

function SCR_ABIL_WIZARD23_ACTIVE(self, ability)

    local skl = GetSkill(self, "Wizard_EarthQuake")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
    
end

function SCR_ABIL_WIZARD23_INACTIVE(self, ability)

    local skl = GetSkill(self, "Wizard_EarthQuake")
    if skl ~= nil then
        skl.KnockDownHitType = 4
    end

end

function SCR_ABIL_MACE_ACTIVE(self, ability)
	local addHeaLPwrRate = 0;
	local rItem  = GetEquipItem(self, 'RH');
	if TryGetProp(rItem, "ClassType") == "Mace" then
	   addHeaLPwrRate = ability.Level * 0.02
	end
    
	SetExProp(self, "ABIL_MACE_ADDHEAL", addHeaLPwrRate);
end

function SCR_ABIL_MACE_INACTIVE(self, ability)
    DelExProp(self, "ABIL_MACE_ADDHEAL");
end


function SCR_ABIL_PELTASTA5_ACTIVE(self, ability)
    
    local lItem  = GetEquipItem(self, 'LH');
    local addValue = 0;
    
    if lItem.ClassType == "Shield" then
        addValue = ability.Level;
    end
    
    self.MaxHateCount_BM = self.MaxHateCount_BM + addValue;
    SetExProp(ability, "ADD_MaxHateCount", addValue);
    
    Invalidate(self, "MaxHateCount");
end

function SCR_ABIL_PELTASTA5_INACTIVE(self, ability)
    
    local addValue = GetExProp(ability, "ADD_MaxHateCount");
    self.MaxHateCount_BM = self.MaxHateCount_BM - addValue;
	
    Invalidate(self, "MaxHateCount");
end

function SCR_ABIL_DOPPELSOELDNER24_ACTIVE(self, ability)
    local addsta = 5
    self.MaxSta_BM = self.MaxSta_BM - addsta;
    SetExProp(ability, 'ADD_STA', addsta);
end

function SCR_ABIL_DOPPELSOELDNER24_INACTIVE(self, ability)
    local addsta = GetExProp(ability, 'ADD_STA');
    self.MaxSta_BM = self.MaxSta_BM + addsta;
end

function SCR_ABIL_MUSKETEER30_ACTIVE(self, ability)
    local minPATK = TryGetProp(self, "MINPATK")
    local maxPATK = TryGetProp(self, "MAXPATK")
    local addATK = 0
    local addMSPD = 1
    addATK = ((minPATK + maxPATK)/2 - self.PATK_BM) * (ability.Level * 0.01)
    
    self.MSPD_BM = self.MSPD_BM - addMSPD
    
    SetExProp(self, "add_Musketeer30_ATK", addATK)
    SetExProp(self, "add_Musketeer30_MSPD", addMSPD)
end

function SCR_ABIL_MUSKETEER30_INACTIVE(self, ability)
    local addMSPD = GetExProp(self, "add_Musketeer30_MSPD")
    
    self.MSPD_BM = self.MSPD_BM + addMSPD
    
    DelExProp(self, "add_Musketeer30_ATK")
end

function SCR_ABIL_TIGERHUNTER5_ACTIVE(self, ability)
    local skl = GetSkill(self, "TigerHunter_Blitz")
    if skl ~= nil then
        skl.KnockDownHitType = 3
    end
    
end

function SCR_ABIL_TIGERHUNTER5_INACTIVE(self, ability)
    local skl = GetSkill(self, "TigerHunter_Blitz")
    if skl ~= nil then
        skl.KnockDownHitType = 1
    end
end

function IS_ABILITY_KEYWORD(abilCls, keyword)
    local keywordStr = TryGetProp(abilCls, "Keyword");
    if keywordStr == nil or keywordStr == "None" then
        return false;
    end

	local tokenList = StringSplit(keywordStr, ";");
    for i = 1, #tokenList do
        local token = tokenList[i];
        if token == keyword then
            return true;
        end
    end
    return false;
end

function SCR_ABIL_Psychokino24_ACTIVE(self, ability)
    if IS_ACTIVE_ABILITY(self, "Wizard30") == 0 then
        local skl = GetSkill(self, "Wizard_Teleportation")
        if skl ~= nil then
            SetSkillOverHeat(self, skl.ClassName, 2, 1)
        end
    end
end

function SCR_ABIL_Psychokino24_INACTIVE(self, ability)
    local skl = GetSkill(self, "Wizard_Teleportation")
    if skl ~= nil then
        SetSkillOverHeat(self, skl.ClassName, 0, 1)
    end
end

function SCR_ABIL_STATCHANGE_Cleric_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_1", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Cleric_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_1")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Kriwi_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_3", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Kriwi_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_3")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Dievdirbys_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_7", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Dievdirbys_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_7")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Paladin_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_11", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Paladin_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_11")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Pardoner_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_10", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Pardoner_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_10")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Druid_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_5", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Druid_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_5")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Chaplain_ACTIVE(self, ability)

    SetExProp(self, "CHANGE_STAT_Char4_12", 1)
    
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_STATCHANGE_Chaplain_INACTIVE(self, ability)
    
    DelExProp(self, "CHANGE_STAT_Char4_12")

    Invalidate(self, "STR");
    Invalidate(self, "INT");
    Invalidate(self, "DEX");
    Invalidate(self, "MNA");
end

function SCR_ABIL_Barbarian35_ACTIVE(self, ability)
    local armorCount, lowestArmorGrade = CHECK_ARMORMATERIAL(self, "Leather");

    if armorCount >= 4 then
        AddBuff(self, self, "Barbarian_Beast_Buff");
    end
end

function SCR_ABIL_Barbarian35_INACTIVE(self, ability)
    RemoveBuff(self, "Barbarian_Beast_Buff");
end

function SCR_ABIL_Matador21_ACTIVE(self, ability)
    local skill = GetSkill(self, "Matador_CorridaFinale");
    if skill ~= nil then
        local dummySkill = AddInstSkill(self, "Matador_CorridaFinale_Hidden", skill.Level);

        local sklAttribute = skill.Attribute;
        skill.Attribute = "Fire";
        dummySkill.Attribute = "Fire";

        SetExProp_Str(self, "Matador21_ATTRIBUTE", sklAttribute);
        AddBuff(self, self, "CorridaFinale_Hidden_Buff");
    end
end

function SCR_ABIL_Matador21_INACTIVE(self, ability)
    RemoveInstSkill(self, "Matador_CorridaFinale_Hidden");
    
    local skill = GetSkill(self, "Matador_CorridaFinale");
    if skill ~= nil then
        local sklAttribute = GetExProp_Str(self, "Matador21_ATTRIBUTE");
        skill.Attribute = sklAttribute;
        RemoveBuff(self, "CorridaFinale_Hidden_Buff");
    end
end

function SCR_ABIL_Doppelsoeldner27_ACTIVE(self, ability)
    local skill = GetSkill(self, "Doppelsoeldner_Zornhau");
    if skill ~= nil then
        SetSkillOverHeat(self, skill.ClassName, 3, 1);
    end
end

function SCR_ABIL_Doppelsoeldner27_INACTIVE(self, ability)
    local skill = GetSkill(self, "Doppelsoeldner_Zornhau");
    if skill ~= nil then
        SetSkillOverHeat(self, skill.ClassName, 0, 1);
    end
end

function SCR_ABIL_Arditi10_ACTIVE(self, ability)
    local armorCount, lowestArmorGrade = CHECK_ARMORMATERIAL(self, "Leather");

    if armorCount >= 4 then
        AddBuff(self, self, "Arditi_Leather_Buff", 1, 0, 0, 1);
    end
end

function SCR_ABIL_Arditi10_INACTIVE(self, ability)
    RemoveBuff(self, "Arditi_Leather_Buff");
end

function SCR_ABIL_RuneCaster13_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Cloth");

    if count >= 4 then
        AddBuff(self, self, "Hagalaz_Abil_Buff");
    end
end

function SCR_ABIL_RuneCaster13_INACTIVE(self, ability)
    RemoveBuff(self, "Hagalaz_Abil_Buff");
end

function SCR_ABIL_Squire14_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Cloth")
    
    if count >= 4 then
        AddBuff(self, self, "Squire14_Buff");
	end
end

function SCR_ABIL_Squire14_INACTIVE(self, ability)
    RemoveBuff(self, "Squire14_Buff");
end

function SCR_ABIL_Squire15_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Leather")
    
    if count >= 4 then
        AddBuff(self, self, "Squire15_Buff");
	end
end

function SCR_ABIL_Squire15_INACTIVE(self, ability)
	RemoveBuff(self, "Squire15_Buff");
end

function SCR_ABIL_Squire16_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Iron")
    
    if count >= 4 then
        AddBuff(self, self, "Squire16_Buff");
	end
end

function SCR_ABIL_Squire16_INACTIVE(self, ability)
	RemoveBuff(self, "Squire16_Buff");
end

function SCR_ABIL_Exorcist19_ACTIVE(self, ability)
    local skill = GetSkill(self, "Exorcist_Katadikazo");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        skill.Attribute = "Fire";
        SetExProp_Str(self, "Exorcist19_Attribute", attribute);
    end
end

function SCR_ABIL_Exorcist19_INACTIVE(self, ability)
	local skill = GetSkill(self, "Exorcist_Katadikazo");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Exorcist19_Attribute");
        skill.Attribute = attribute;
    end
end

function SCR_ABIL_Appraiser7_ACTIVE(self, ability)
    local skill = GetSkill(self, "Appraiser_Blindside");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        skill.Attribute = "Fire";
        SetExProp_Str(self, "Appraiser7_Attribute", attribute);
        SetSkillOverHeat(self, skill.ClassName, 0, 1);
    end
end

function SCR_ABIL_Appraiser7_INACTIVE(self, ability)
	local skill = GetSkill(self, "Appraiser_Blindside");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Appraiser7_Attribute");
        skill.Attribute = attribute;
        SetSkillOverHeat(self, skill.ClassName, 3, 1);
    end
end

function SCR_ABIL_Hoplite33_ACTIVE(self, ability)
    local skill = GetSkill(self, "Hoplite_ThrouwingSpear");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        skill.Attribute = "Earth";
        SetExProp_Str(self, "Hoplite33_Attribute", attribute);
        skill.KnockDownHitType = 1
    end
end

function SCR_ABIL_Hoplite33_INACTIVE(self, ability)
	local skill = GetSkill(self, "Hoplite_ThrouwingSpear");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Hoplite33_Attribute");
        skill.Attribute = attribute;
        skill.KnockDownHitType = 4
    end
end

function SCR_ABIL_Exorcist20_ACTIVE(self, ability)
    local skill = GetSkill(self, "Exorcist_Rubric");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        skill.Attribute = "Dark";
        SetExProp_Str(self, "Exorcist20_Attribute", attribute);
        AddBuff(self, self, "Rubric_Hidden_Buff");
    end
end

function SCR_ABIL_Exorcist20_INACTIVE(self, ability)
	local skill = GetSkill(self, "Exorcist_Rubric");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Exorcist20_Attribute");
        skill.Attribute = attribute;
        RemoveBuff(self, "Rubric_Hidden_Buff");
    end
end

function SCR_ABIL_Hunter16_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Leather");

    if count >= 4 then
        AddBuff(self, self, "Hunter_Companion_Bonus_Buff");
    end
end

function SCR_ABIL_Hunter16_INACTIVE(self, ability)
    RemoveBuff(self, "Hunter_Companion_Bonus_Buff");
end

function SCR_ABIL_TigerHunter9_ACTIVE(self, ability)
    AddBuff(self, self, "TigerHunter_Damage_Bonus_Buff");
end

function SCR_ABIL_TigerHunter9_INACTIVE(self, ability)
    RemoveBuff(self, "TigerHunter_Damage_Bonus_Buff");
end

function SCR_ABIL_Templar8_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Iron");

    if count >= 4 then
        AddBuff(self, self, "Templar_Plate_Buff");
    end
end

function SCR_ABIL_Templar8_INACTIVE(self, ability)
    RemoveBuff(self, "Templar_Plate_Buff");
end

function SCR_ABIL_Cleric25_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Cloth");

    if count >= 4 then
        AddBuff(self, self, "Cleric_Cloth_Buff");
    end
end

function SCR_ABIL_Cleric25_INACTIVE(self, ability)
    RemoveBuff(self, "Cleric_Cloth_Buff");
end

function SCR_ABIL_Sadhu26_ACTIVE(self, ability)
    local count, lowestGrade = CHECK_ARMORMATERIAL(self, "Cloth");

    if count >= 4 then
        AddBuff(self, self, "Sadhu_Cloth_Buff");
    end
end

function SCR_ABIL_Sadhu26_INACTIVE(self, ability)
    RemoveBuff(self, "Sadhu_Cloth_Buff");
end

function SCR_ABIL_Sheriff8_ACTIVE(self, ability)
    RemoveBuff(self, "Westraid_Buff");
end

function SCR_ABIL_Sheriff8_INACTIVE(self, ability)
    RemoveBuff(self, "Westraid_Buff");
end

function SCR_ABIL_Assassin18_ACTIVE(self, ability)
    AddBuff(self, self, "Assassin_Request_Buff");
end

function SCR_ABIL_Assassin18_INACTIVE(self, ability)
    RemoveBuff(self, "Assassin_Request_Buff");
end

function SCR_ABIL_Outlaw20_ACTIVE(self, ability)
    local skill = GetSkill(self, "OutLaw_Rampage");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        local enableCompanion = TryGetProp(skill, "EnableCompanion");

        skill.Attribute = "Ice";
        skill.EnableCompanion = "None";

        SetExProp_Str(self, "Outlaw20_Attribute", attribute);
        SetExProp_Str(self, "Outlaw20_companion", enableCompanion);
    end
end

function SCR_ABIL_Outlaw20_INACTIVE(self, ability)
    local skill = GetSkill(self, "OutLaw_Rampage");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Outlaw20_Attribute");
        local enableCompanion = GetExProp_Str(self, "Outlaw20_companion");

        skill.Attribute = attribute;
        skill.EnableCompanion = enableCompanion;
    end
end

function SCR_ABIL_Matross14_ACTIVE(self, ability)
    local skill = GetSkill(self, "Matross_CrouchingStrike");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");

        skill.Attribute = "Lightning";

        SetExProp_Str(self, "Matross14_Attribute", attribute)
    end
end

function SCR_ABIL_Matross14_INACTIVE(self, ability)
    local skill = GetSkill(self, "Matross_CrouchingStrike");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Matross14_Attribute");

        skill.Attribute = attribute;
    end
end

function SCR_ABIL_Ranger38_ACTIVE(self, ability)
    local skill = GetSkill(self, "Ranger_BounceShot");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");

        skill.Attribute = "ICE";

        SetExProp_Str(self, "Ranger38_Attribute", attribute)
        AddBuff(self, self, "BounceShot_Hidden_Buff");
    end
end

function SCR_ABIL_Ranger38_INACTIVE(self, ability)
    local skill = GetSkill(self, "Ranger_BounceShot");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Ranger38_Attribute");

        skill.Attribute = attribute;
        
        RemoveBuff(self, "BounceShot_Hidden_Buff");
    end
end
function SCR_ABIL_Corsair21_ACTIVE(self, ability)
    AddInstSkill(self, "Corsair_Bombardments", 1);
end

function SCR_ABIL_Corsair21_INACTIVE(self, ability)
    RemoveInstSkill(self, "Corsair_Bombardments");
end

function SCR_ABIL_Chronomancer17_ACTIVE(self, ability)
    SetExProp(self, "BACKMASKING_HIDDEN_ABIL_STATE", 0);

    local skill = GetSkill(self, "Chronomancer_BackMasking");
    if skill ~= nil then
        UpdateSkillSpendItemBySkillID(self, skill.ClassID);
    end
end

function SCR_ABIL_Chronomancer17_INACTIVE(self, ability)
    SetExProp(self, "BACKMASKING_HIDDEN_ABIL_STATE", 0);
    
    local skill = GetSkill(self, "Chronomancer_BackMasking");
    if skill ~= nil then
        UpdateSkillSpendItemBySkillID(self, skill.ClassID);
    end
end

function SCR_ABIL_Wizard30_ACTIVE(self, ability)
    local skl = GetSkill(self, "Wizard_Teleportation")
    if skl ~= nil then
        SetSkillOverHeat(self, skl.ClassName, 0, 1)
    end
end

function SCR_ABIL_Wizard30_INACTIVE(self, ability)
    if IS_ACTIVE_ABILITY(self, "Psychokino24") == 1 then
        local skl = GetSkill(self, "Wizard_Teleportation")
        if skl ~= nil then
            SetSkillOverHeat(self, skl.ClassName, 2, 1)
        end
    end
end

function SCR_ABIL_Archer35_ACTIVE(self, ability)
    local skl = GetSkill(self, "Archer_Jump");
    if skl ~= nil then
        skl.BasicCoolDown = 10000;
    end
end

function SCR_ABIL_Archer35_INACTIVE(self, ability)
    local skl = GetSkill(self, "Archer_Jump");
    if skl ~= nil then
        skl.BasicCoolDown = 15000;
    end
end

function SCR_ABIL_Swordman33_ACTIVE(self, ability)
    local skill = GetSkill(self, "Swordman_Thrust");
    if skill ~= nil then
        SetSkillOverHeat(self, skill.ClassName, 2, 1);
    end
end

function SCR_ABIL_Swordman33_INACTIVE(self, ability)
    local skill = GetSkill(self, "Swordman_Thrust");
    if skill ~= nil then
        SetSkillOverHeat(self, skill.ClassName, 5, 1);
    end
end

function SCR_ABIL_Sorcerer19_ACTIVE(self, ability)
    local tgt = nil;
    local tgtList = GetAliveFolloweList(self);
    if #tgtList == 0 then
        return;
    end

    local etc = GetETCObject(self);
    for i = 1, #tgtList do
        local obj = tgtList[i];
        if etc.Sorcerer_bosscardName1 == obj.ClassName or etc.Sorcerer_bosscardName2 == obj.ClassName then
            tgt = obj;
            break;
        end
    end

    if nil == tgt then
        return;
    end

    PlayEffect(tgt, "F_pc_SummonRemove_mon", 1.0, nil, "BOT");

    Dead(tgt);
end

function SCR_ABIL_Sorcerer19_INACTIVE(self, ability)
    local tgt = nil;
    local tgtList = GetAliveFolloweList(self);
    if #tgtList == 0 then
        return;
    end

    local etc = GetETCObject(self);
    for i = 1, #tgtList do
        local obj = tgtList[i];
        if etc.Sorcerer_bosscardName1 == obj.ClassName or etc.Sorcerer_bosscardName2 == obj.ClassName then
            tgt = obj;
            break;
        end
    end

    if nil == tgt then
        return;
    end

    PlayEffect(tgt, "F_pc_SummonRemove_mon", 1.0, nil, "BOT");
    
    Dead(tgt);
end

function SCR_ABIL_Elementalist33_ACTIVE(self, ability)

end

function SCR_ABIL_Elementalist33_INACTIVE(self, ability)
    local meteorSkill = GetSkill(self, "Elementalist_Meteor");
    if meteorSkill ~= nil then
        if IsBuffApplied(self, "Meteor_FireBall_Buff") == "YES" then
            local over = GetBuffOver(self, "Meteor_FireBall_Buff");
            if over > 1 then
                local cooldown = GetExProp(self, "Elementalist33_COOLDOWN");
                meteorSkill.BasicCoolDown = 40000;
                SetCoolDown(self, meteorSkill.CoolDownGroup, cooldown);
            end
            RemoveBuff(self, "Meteor_FireBall_Buff");
        end

        for i = 1, 3 do
            local padList = GetMyPadList(self, "Elementalist_MovingFireBall_" .. i);
            if padList[1] ~= nil then
                RemovePad(self, "Elementalist_MovingFireBall_" .. i);
            end
        end
    end
end

function SCR_ABIL_Oracle23_ACTIVE(self, ability)
    local divineMightSkill = GetSkill(self, "Oracle_DivineMight");
    if divineMightSkill ~= nil then
        local basicCoolDown = TryGetProp(divineMightSkill, "BasicCoolDown");
        divineMightSkill.BasicCoolDown = 60000;
        SetExProp(self, "Oracle23_COOLDOWN", basicCoolDown);
    end
end

function SCR_ABIL_Oracle23_INACTIVE(self, ability)
    local divineMightSkill = GetSkill(self, "Oracle_DivineMight");
    if divineMightSkill ~= nil then
        local basicCoolDown = GetExProp(self, "Oracle23_COOLDOWN");
        divineMightSkill.BasicCoolDown = basicCoolDown;
        DelExProp(self, "Oracle23_COOLDOWN");
    end
end

function SCR_ABIL_Arbalester16_ACTIVE(self, ability)
    AddBuff(self, self, "Arbalester_Pre_Buff");
end

function SCR_ABIL_Arbalester16_INACTIVE(self, ability)
    RemoveBuff(self, "Arbalester_Pre_Buff");
    RemoveBuff(self, "Arbalester16_Buff")
    RemoveBuff(self, "Arbalester17_Buff")
end

function SCR_ABIL_Arbalester17_ACTIVE(self, ability)
    AddBuff(self, self, "Arbalester_Pre_Buff");
end

function SCR_ABIL_Arbalester17_INACTIVE(self, ability)
    RemoveBuff(self, "Arbalester_Pre_Buff");
    RemoveBuff(self, "Arbalester16_Buff")
    RemoveBuff(self, "Arbalester17_Buff")
end

function SCR_ABIL_Arbalester10_ACTIVE(self, ability)
    local skill = GetSkill(self, "Arbalester_DarkJudgement");
    if skill ~= nil then
        local attribute = TryGetProp(skill, "Attribute");
        skill.Attribute = "Dark";
        SetExProp_Str(self, "Arbalester10_Attribute", attribute);
    end
end

function SCR_ABIL_Arbalester10_INACTIVE(self, ability)
	local skill = GetSkill(self, "Arbalester_DarkJudgement");
    if skill ~= nil then
        local attribute = GetExProp_Str(self, "Arbalester10_Attribute");
        skill.Attribute = attribute;
    end
end

function SCR_ABIL_SPEARMASTERY_Dagger_ACTIVE(self, ability)
    local addATK = 0;

    local rItem  = GetEquipItem(self, 'RH');
    local lItem  = GetEquipItem(self, 'LH');
    if TryGetProp(rItem, "ClassType", "None") == "Spear" and TryGetProp(lItem, "ClassType", "None") == "Dagger" then
        local akt = (lItem.MINATK + lItem.MAXATK) / 2
        addATK = math.floor(akt * 0.25);
    end
    
    self.PATK_MAIN_BM = self.PATK_MAIN_BM + addATK;
    
    SetExProp(ability, "ABIL_ADD_ATK", addATK);
end

function SCR_ABIL_SPEARMASTERY_Dagger_INACTIVE(self, ability)
    local addATK = GetExProp(ability, "ABIL_ADD_ATK");
    self.PATK_MAIN_BM = self.PATK_MAIN_BM - addATK;
end