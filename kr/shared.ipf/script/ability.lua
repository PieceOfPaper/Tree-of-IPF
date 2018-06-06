function PC_PCAA(pc)
local jobHistory = GetJobHistorySting(pc)
    print(jobHistory)
end

function CHECK_ABILITY_LOCK(pc, ability)


    if ability.Job == "None" then
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

    IMC_LOG("INFO_NORMAL", "abilityUnlock Error");
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
    local MINMATK = TryGetProp(self, "MINMATK")
    if rItem.ClassType == "Staff" then
        addValue = math.floor(MINMATK * ability.Level * 0.03)
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
    SetExProp(self, "CLOTH_ARMOR_COUNT", count);
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
    local count = CHECK_ARMORMATERIAL(self, "Leather")
    local addCRTHR = 0;
    local addHR = 0;
    
    if count >= 3 then
        addCRTHR = 30;
        addHR = 30;
    end
    
    if count == 4 then
        addCRTHR = 50;
        addHR = 50;
    end
    
    self.CRTHR_BM = self.CRTHR_BM + addCRTHR;
    self.HR_BM = self.HR_BM + addHR;
    Invalidate(self, "CRTHR");
    Invalidate(self, "HR");
    
    SetExProp(ability, "ADD_CRTHR", addCRTHR);
    SetExProp(ability, "ADD_HR", addHR);
end

function SCR_ABIL_LEATHER_INACTIVE(self, ability)
    local addCRTHR = GetExProp(ability, "ADD_CRTHR");
    local addHR = GetExProp(ability, "ADD_HR");
    
    self.CRTHR_BM = self.CRTHR_BM - addCRTHR;
    self.HR_BM = self.HR_BM - addHR;
    
    Invalidate(self, "CRTHR");
    Invalidate(self, "HR");
end


function SCR_ABIL_IRON_ACTIVE(self, ability)
    local count = CHECK_ARMORMATERIAL(self, "Iron")
    
    SetExProp(self, "IRON_ARMOR_COUNT", count);
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
        return true -- 스킬이 없어도 true를 반환하여, tx가 롤백되지 않도록 한다.
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
		
		if rItemType == 'Staff' then
			ChangeNormalAttack(self, "Magic_Attack");
		end
    end
    
	self.MAXMATK_RATE_BM = self.MAXMATK_RATE_BM + addMaxMATKRate;
	
	SetExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE", addMaxMATKRate);
end

function SCR_ABIL_KABBALIST21_INACTIVE(self, ability)
	local addMaxMATKRate = GetExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE");
	self.MAXMATK_RATE_BM = self.MAXMATK_RATE_BM - addMaxMATKRate;
	
	ChangeNormalAttack(self, "None");
	
	DelExProp(self, "ABIL_KABBALIST21_MAX_MATK_RATE");
end

function SCR_ABIL_KABBALIST22_ACTIVE(self, ability)
	local addMSPD = 0;
	local isAbilKabbalist22 = 0;
	
	local count = CHECK_ARMORMATERIAL(self, "Cloth")
	if count >= 4 then
		addMSPD = 5;
		
		isAbilKabbalist22 = 1;
	end
	
	self.MSPD_BM = self.MSPD_BM + addMSPD;
	
	SetExProp(self, "ABIL_KABBALIST22_MSPD", addMSPD);
	SetExProp(self, "ABIL_KABBALIST22_ON", isAbilKabbalist22);
end

function SCR_ABIL_KABBALIST22_INACTIVE(self, ability)
	local addMSPD = GetExProp(self, "ABIL_KABBALIST22_MSPD");
	self.MSPD_BM = self.MSPD_BM - addMSPD;
	
	DelExProp(self, "ABIL_KABBALIST22_MSPD");
	DelExProp(self, "ABIL_KABBALIST22_ON");
end