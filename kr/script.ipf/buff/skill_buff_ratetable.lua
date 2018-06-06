--skill_buff_ratetable.lua
-- FINAL_DAMAGECALC() -> SCR_BUFF_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable);
-- must check IsBuffApplied(self or from, buffname) == 'YES' / 'NO'


function SCR_BUFF_RATETABLE_Feint_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Feint_Debuff') == 'YES' then
        local feintSklLv = GetBuffArgs(buff);
        if feintSklLv > 0 then
            local feintRatio = 300 * feintSklLv;
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - feintRatio;
        end
    end
end

function SCR_BUFF_RATETABLE_PadImmune_Buff(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'PadImmune_Buff') ~= 'YES' then
        return;
    end
    
    rateTable.NoneDamage = 1;  
end



function SCR_BUFF_RATETABLE_Evasion_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Evasion_Buff') == 'YES' then
        
        local evasionSklLv = GetBuffArgs(buff);
        if evasionSklLv > 0 then
            local evasionRatio = evasionSklLv * 500;
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + evasionRatio;
        end
    end
end


function SCR_BUFF_RATETABLE_Conviction_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Conviction_Debuff') == 'YES' then
        if IS_PC(from) == true and skill.ClassName == "Paladin_Smite" then
            local hitCount = 3
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.8
            SetMultipleHitCount(ret, hitCount);
        end

        if skill.ClassName == "Inquisitor_GodSmash" then
            rateTable.DamageRate = rateTable.DamageRate + 0.6
        end
    end
end

function SCR_BUFF_RATETABLE_Cleave_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Cleave_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Slash' then
            rateTable.DamageRate = rateTable.DamageRate + 0.5;
        end
    end
end

function SCR_BUFF_RATETABLE_Ability_buff_SlashDEF(self, from, skill, atk, ret, rateTable, buff)
	if IsBuffApplied(self, 'Ability_buff_SlashDEF') == 'YES' then
		local attackType = skill.AttackType;
		if IS_PC(from) == true and skill.ClassID < 10000 then
			local rightHand = GetEquipItem(from, 'RH');
			attackType = rightHand.AttackType
		end
		
		if attackType == 'Slash' then
--    		rateTable.DamageRate = rateTable.DamageRate - 0.7
    		AddDamageReductionRate(rateTable, 0.7)
		end
	end
end



function SCR_BUFF_RATETABLE_Burrow_Rogue(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(from, 'Burrow_Rogue') == 'YES' then

        local BurrowSklLv = GetBuffArgs(buff); 
        if BurrowSklLv > 0 then
            local BurrowRatio = 500 * BurrowSklLv;
            rateTable.crtRatingAdd = rateTable.crtRatingAdd + BurrowRatio;
        end
    end
end


function SCR_BUFF_RATETABLE_Hamaya_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Hamaya_Debuff') == 'YES' then
      if skill.Attribute == "Holy" then
      rateTable.DamageRate = rateTable.DamageRate + 1
      end
    end
end

function SCR_BUFF_RATETABLE_EsquiveToucher_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'EsquiveToucher_Buff') == 'YES' then
        local EsquiveSklLv = GetBuffArg(buff);
        if EsquiveSklLv > 0 then
            local EsquiveRatio = 1000 * EsquiveSklLv;
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + EsquiveRatio;
        end
    end
end


function SCR_BUFF_RATETABLE_Preparation_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Preparation_Buff') == 'YES' then
        local PrepaSklLv = GetBuffArgs(buff);
        if PrepaSklLv > 0 then
            local PrepaRatio = 5000 + PrepaSklLv * 500
            rateTable.blkAdd = rateTable.blkAdd + PrepaRatio;
        end
    end
end


function SCR_BUFF_RATETABLE_Flanconnade_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Flanconnade_Buff') == 'YES' then
        local FlanconnadeSklLv = GetBuffArgs(buff);
        if FlanconnadeSklLv > 0 then
            local FlanconnadeRatio = 8000
            rateTable.blkAdd = rateTable.blkAdd + FlanconnadeRatio;
        end
    end
end


function SCR_BUFF_RATETABLE_Stun(self, from, skill, atk, ret, rateTable, buff)

     if IsBuffApplied(self, 'Stun') == 'YES' then
        local attackType = skill.AttackType;
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' then
            rateTable.crtRatingAdd = rateTable.crtRatingAdd + 3000;
        end
    end
end

function SCR_BUFF_RATETABLE_UC_stun(self, from, skill, atk, ret, rateTable, buff)

     if IsBuffApplied(self, 'UC_stun') == 'YES' then
        local attackType = skill.AttackType;
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' then
            rateTable.crtRatingAdd = rateTable.crtRatingAdd + 3000;
        end
    end
end


function SCR_BUFF_RATETABLE_RunningShot_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'RunningShot_Buff') == 'YES' then
        if IS_PC(from) == true and IsNormalSKillBySkillID(from, skill.ClassID) == 1 or skill.ClassName == "Bow_Hanging_Attack" or skill.ClassName == "Cannon_Attack" or skill.ClassName == "DoubleGun_Attack" then
        	local addFactor = 0;
            local RunningShot = GetSkill(from, "QuarrelShooter_RunningShot")
            if RunningShot ~= nil then
                addFactor = TryGetProp(RunningShot, 'SkillFactor')
            end
            
			rateTable.AddSkillFator = rateTable.AddSkillFator + addFactor;
            
            local hitCount = 2;
			
            AddMultipleHitCount(ret, hitCount);
        end
    end
end

function SCR_BUFF_RATETABLE_Limacon_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Limacon_Buff') == 'YES' then
        if IS_PC(from) == true and IsNormalSKillBySkillID(from, skill.ClassID) == 57 or skill.ClassName == "Pistol_Attack2" then
            local addRate = 0.5 + (skill.Level - 1) * 0.1
            rateTable.DamageRate = rateTable.DamageRate + addRate
        end
    end
end



function SCR_BUFF_RATETABLE_Slithering_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Slithering_Buff') == 'YES' then
        local SlitheringsklLv = GetBuffArgs(buff);
        if SlitheringsklLv > 0 then
            local SlitheringRatio = 500 * SlitheringsklLv;
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + SlitheringRatio;
            
            if GetExProp(self, "NotRet") ~= 1 then
                local blk = 3500 + 100 * SlitheringsklLv;
                rateTable.blkAdd = rateTable.blkAdd + blk;
            end
            
            if skill.ClassType == 'Magic' then
                local missAdd = 1;
                rateTable.missResult = rateTable.missResult + missAdd;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_ShieldCharge_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'ShieldCharge_Buff') == 'YES' then
        local sklLv = GetBuffArgs(buff);
        if sklLv > 0 and skill.ClassType == "Missile" then
            local blk = 2500 + 200 * sklLv;
            rateTable.blkAdd = rateTable.blkAdd + blk;
        end
    end
end


function SCR_BUFF_RATETABLE_SoulDuel_DEF(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'SoulDuel_DEF') == 'YES' and  IsBuffApplied(from, 'SoulDuel_ATK') == 'NO' then   
        rateTable.missResult = 1
    end
end

function SCR_BUFF_RATETABLE_UmboBlow_Buff(self, from, skill, atk, ret, rateTable, buff)

    if GetExProp(self, "NotRet") ~= 1 then
        if IsBuffApplied(self, 'UmboBlow_Buff') == 'YES' then
            local blk = 4000;
            rateTable.blkAdd = rateTable.blkAdd + blk;
        end
    end
end


function SCR_BUFF_RATETABLE_Ability_buff_Shield(self, from, skill, atk, ret, rateTable, buff)

    if GetExProp(self, "NotRet") ~= 1 then
        if IsBuffApplied(self, 'Ability_buff_Shield') == 'YES' then
            if skill.ClassType == 'Missile' then
                local ratio = IMCRandom(1, 2);
                if ratio == 1 then
                    rateTable.abilityBuffShield = 1;
                end
            end
        end
    end
end


function SCR_BUFF_RATETABLE_Savagery_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(from, 'Savagery_Buff') == 'YES' then
        local attackType = skill.AttackType;
        if IS_PC(from) == true and skill.ClassID < 10000 and attackType == 'None' then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' then
            local hitCount = 2
            local addRate = 0;
            local savagery = GetSkill(from, "Barbarian_Savagery")
            if savagery ~= nil then
                addRate = addRate + 0.1 * savagery.Level
            end
            
            rateTable.DamageRate = rateTable.DamageRate + addRate;
            SetMultipleHitCount(ret, hitCount);
        end
    end
end

function SCR_BUFF_RATETABLE_CrossGuard_Debuff(self, from, skill, atk, ret, rateTable, buff)
    local caster = GetBuffCaster(buff)
    if IsBuffApplied(self, 'CrossGuard_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' and IsSameObject(caster, from) == 1 then

            local crossGuardSklLv = GetBuffArgs(buff);
            if crossGuardSklLv > 0 then
                rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + (0.95 + crossGuardSklLv * 0.05);
            end

            local hitCount = 2;
            SetMultipleHitCount(ret, hitCount);
        end
    end
end


function SCR_BUFF_RATETABLE_HighKick_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'HighKick_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Strike' then
            rateTable.DamageRate = rateTable.DamageRate + 0.3
        end
    end
end

function SCR_BUFF_RATETABLE_DoublePunch_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'DoublePunch_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Strike' then
            rateTable.DamageRate = rateTable.DamageRate + 0.2
        end
    end
end

function SCR_BUFF_RATETABLE_God_Finger_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'God_Finger_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Strike' then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

function SCR_BUFF_RATETABLE_Ngadhundi_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Ngadhundi_Debuff') == 'YES' then
        if skill.ClassType == "Missile" then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
    end
end


function SCR_BUFF_RATETABLE_DirtyWall_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'DirtyWall_Debuff') == 'YES' then
        if skill.ClassType == "Missile" then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
    end
end

function SCR_BUFF_RATETABLE_HigherRotten_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'HigherRotten_Debuff') == 'YES' then
        if skill.ClassType == "Missile" then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
    end

    if IsBuffApplied(self, 'HigherRotten_Debuff') == 'YES' and IS_PC(self) == true then
        if skill.ClassType == 'Melee' or skill.ClassType == 'Missile' then
            rateTable.AddDefence = -(GetSumOfEquipItem(self, 'DEF') + GetSumOfEquipItem(self, 'ADD_DEF'));
        elseif skill.ClassType == 'Magic' then
            rateTable.AddDefence = -(GetSumOfEquipItem(self, 'MDEF') + GetSumOfEquipItem(self, 'ADD_MDEF'));
        end
    end
    
    if IsBuffApplied(from, 'HigherRotten_Debuff') == 'YES' and IS_PC(from) == true then
        if skill.ClassType == 'Melee' or skill.ClassType == 'Missile' then
            rateTable.AddAtkDamage = -(GetSumOfEquipItem(from, 'MINATK') + GetSumOfEquipItem(from, 'PATK') + GetSumOfEquipItem(from, 'ADD_MINATK'));
        elseif skill.ClassType == 'Magic' then
            rateTable.AddAtkDamage = -(GetSumOfEquipItem(from, 'MATK') + GetSumOfEquipItem(from, 'ADD_MATK') + GetSumOfEquipItem(from, 'ADD_MINATK'));
        end
    end
end

function SCR_BUFF_RATETABLE_Disenchant_Debuff_Abil(self, from, skill, atk, ret, rateTable, buff)

    local caster = GetBuffCaster(buff);
    local abil = GetAbility(caster, "PlagueDoctor12");
    if abil == nil then
        return;
    end
    
    if IsBuffApplied(self, 'Disenchant_Debuff_Abil') == 'YES' and IS_PC(self) == true then
        if skill.ClassType == 'Melee' or skill.ClassType == 'Missile' then
            rateTable.AddDefence = -(GetSumOfEquipItem(self, 'DEF') + GetSumOfEquipItem(self, 'ADD_DEF'));
        elseif skill.ClassType == 'Magic' then
            rateTable.AddDefence = -(GetSumOfEquipItem(self, 'MDEF') + GetSumOfEquipItem(self, 'ADD_MDEF'));
        end
    end 
end

function SCR_BUFF_RATETABLE_UC_rotten(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'UC_rotten') == 'YES' then
        if skill.ClassType == "Missile" then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
    end
end


function SCR_BUFF_RATETABLE_Isa_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Isa_Buff') == 'YES' then
        if skill.Attribute == 'Ice' then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
        
        if IS_PC(from) == true and IsNormalSKillBySkillID(from, skill.ClassID) == 1 then
            local caster = GetBuffCaster(buff)
            if caster ~= nil then
                local abil = GetAbility(caster, "RuneCaster2")
                if abil ~= nil and IMCRandom(1, 9999) < abil.Level * 500 then
                    AddBuff(from, self, 'UC_slowdown', 1, 0, 4000, 1);
                end
            end
        end
    end
end


function SCR_BUFF_RATETABLE_SteadyAim_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'SteadyAim_Buff') == 'YES' then
        local SteadyAim = GetSkill(from, "Ranger_SteadyAim")
        if SteadyAim ~= nil then
            addrate = 0.01 * SteadyAim.Level
        end
        
        local addDamage = 0
        local addDamageByLevel = SteadyAim.Level * 10
        local Ranger14_abil = GetAbility(from, "Ranger14")
        if Ranger14_abil ~= nil and SteadyAim.Level >= 3 then
            addDamage = addDamage + Ranger14_abil.Level * 2;
        end
        
        if skill.ClassType == 'Missile' then
            local abilRanger32 = GetAbility(from, "Ranger32");
            local RHEquipItem = GetEquipItem(from, "RH")
            if TryGetProp(RHEquipItem, "ClassType") == "THBow" and abilRanger32 ~= nil and TryGetProp(abilRanger32, "ActiveState") == 1 then
                addrate = addrate * 1.5
            end
            rateTable.DamageRate = rateTable.DamageRate + addrate
            rateTable.AddTrueDamage = rateTable.AddTrueDamage + (addDamage + addDamageByLevel);
        end
        
        local abilRanger33 = GetAbility(from, "Ranger33");
        if TryGetProp(skill, "Job") == "Ranger" and abilRanger33 ~= nil and TryGetProp(abilRanger33, "ActiveState") == 1 then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

--function SCR_BUFF_RATETABLE_Slithering_Debuff(self, from, skill, atk, ret, rateTable, buff)
--
--    if IsBuffApplied(self, 'Slithering_Debuff') == 'YES' then
--        local attackType = skill.AttackType
--        if IS_PC(from) == true and skill.ClassID < 10000 then
--            local rightHand = GetEquipItem(from, 'RH');
--            attackType = rightHand.AttackType
--        end
--        
--        local Rodelero29_abilLv = GetBuffArg(buff);
--        if attackType == 'Strike' then
--            rateTable.DamageRate = rateTable.DamageRate + Rodelero29_abilLv * 0.1
--        end
--    end
--end

function SCR_BUFF_RATETABLE_SpearLunge_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'SpearLunge_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end


function SCR_BUFF_RATETABLE_Preparation_Buff_End(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Preparation_Buff_End') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        if attackType == 'Aries' then
            rateTable.DamageRate = rateTable.DamageRate + 1
            SkillEndRemoveBuff(from, "Preparation_Buff_End")
        end
    end
end

function SCR_BUFF_RATETABLE_Lunge_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Lunge_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Slash' then
            rateTable.DamageRate = rateTable.DamageRate + 0.3
        end
    end
end


function SCR_BUFF_RATETABLE_Mon_Golden_Bell_Shield_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Mon_Golden_Bell_Shield_Buff') == 'YES'then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        PlayEffect(self, 'F_sys_IronSkinblock', 0.4, 0, 0)
        EndSyncPacket(self, key)
        
    end
end
 

function SCR_BUFF_RATETABLE_Golden_Bell_Shield_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Golden_Bell_Shield_Buff') == 'YES' and skill.ClassName ~= 'Monk_Golden_Bell_Shield' then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        PlayEffect(self, 'F_sys_IronSkinblock', 0.4, 0, 0)
        EndSyncPacket(self, key)
        
    end
end
 
function SCR_BUFF_RATETABLE_Golden_Bell_Shield_Safety(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Golden_Bell_Shield_Safety') == 'YES' then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        PlayEffect(self, 'F_sys_IronSkinblock', 0.4, 0, 0)
        EndSyncPacket(self, key)
    end
end 
   

function SCR_BUFF_RATETABLE_Rain_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Rain_Debuff') == 'YES' then 
        if skill.Attribute == "Lightning" then
            rateTable.DamageRate = rateTable.DamageRate + 0.35;
        end
    end
end 

function SCR_BUFF_RATETABLE_Mastema_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Mastema_Debuff') == 'YES' then 
        if skill.Attribute == "Holy" then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
    end
end 


function SCR_BUFF_RATETABLE_AttaqueCoquille_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'AttaqueCoquille_Debuff') == 'YES' then 
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == "Aries" then
         rateTable.AddIgnoreDefensesRate =  rateTable.AddIgnoreDefensesRate + 0.1
--            local defadd = self.DEF
--            rateTable.AddAtkDamage = rateTable.AddAtkDamage + defadd;
        end
    end
end

function SCR_BUFF_RATETABLE_Petrification(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Petrification') == 'YES' then
    	if skill.Attribute == 'Fire' or skill.Attribute == 'Soul' then
    	local hitCount = 2
    	
    	rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.5
    	SetMultipleHitCount(ret, hitCount);
    	elseif skill.ClassType == 'Missile' or skill.ClassType == 'Magic' then
	        AddDamageReductionRate(rateTable, 0.9)
	    end
    end
end

function SCR_BUFF_RATETABLE_Camouflage_Buff(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'Camouflage_Buff') == 'YES' then

        local count = GetExProp(self, 'IGNORE_MELEE_ATK');
        if count > 0 and skill.ClassType ~= 'Magic' then

            rateTable.IgnoreDamage = 1;
            SetExProp(self, "IGNORE_MELEE_ATK", count - 1);
        end
    end
end 


function SCR_BUFF_RATETABLE_UC_bound(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'UC_bound') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.1; 
    end
end 

function SCR_BUFF_RATETABLE_enchanted_poison(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(from, 'enchanted_poison') == 'YES' then
        if IS_PC(from) == true and skill.ClassID > 99 then
            return;
        end
        
        local over = GetOver(buff)
        local ratio = 2500 + (over * 200);
        
        if ratio > IMCRandom(0, 10000) then
            AddBuff(from, self, 'UC_poison', self.Lv, 0, 10000, 1);
        end
    end
end 

function SCR_BUFF_RATETABLE_Web_FlyObject(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'Web_FlyObject') == 'YES' and self.MoveType == "Flying" then
    
        local Hunter4_abilLv = GetBuffArgs(buff);
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if Hunter4_abilLv > 0 and (attackType == 'Slash' or attackType == 'Strike') then
            rateTable.DamageRate = rateTable.DamageRate + (0.2 * Hunter4_abilLv);
        end
    end
end


function SCR_BUFF_RATETABLE_Cloaking_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Cloaking_Buff') == 'YES' then
        local Scout1_abil = GetAbility(from, 'Scout1')
        if Scout1_abil ~= nil then
            local MINPATK = TryGetProp(from, "MINPATK")
            local MAXPATK = TryGetProp(from, "MAXPATK")
            local addDamage = ((MINPATK + MAXPATK) / 2) * 0.5
            rateTable.AddTrueDamage = rateTable.AddTrueDamage + addDamage;
        end
    end
end 

function SCR_BUFF_RATETABLE_QuickCast_Buff(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(from, 'QuickCast_Buff') == 'YES' and skill.ClassType == 'Magic' then
        local abil = GetAbility(from, "Wizard8")
        if abil ~= nil then
            rateTable.DamageRate = rateTable.DamageRate + (0.1 * abil.Level);
        end
    end
end


function SCR_BUFF_RATETABLE_Link_Enemy(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'Link_Enemy') == 'YES' then

        local Linker8_abilLv, Linker9_abilLv, Linker10_abilLv = GetBuffArgs(buff);

        if Linker8_abilLv > 0 and skill.Attribute == 'Lightning' then
            rateTable.DamageRate = rateTable.DamageRate + (0.1 * Linker8_abilLv);
        end
        
        if Linker9_abilLv > 0 and skill.Attribute == 'Poison' then
            rateTable.DamageRate = rateTable.DamageRate + (0.1 * Linker9_abilLv);
        end
        
        if Linker10_abilLv > 0 and skill.Attribute == 'Earth' then
            rateTable.DamageRate = rateTable.DamageRate + (0.1 * Linker10_abilLv);
        end
    end
end 


function SCR_BUFF_RATETABLE_SwellLeftArm_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'SwellLeftArm_Buff') == 'YES' then
        local caster = GetBuffCaster(buff);
        local Thaumaturge6 = GetAbility(caster, "Thaumaturge6")
        local Thaumaturge7 = GetAbility(caster, "Thaumaturge7")
        if Thaumaturge6 ~= nil and IsBuffApplied(self, 'ShrinkBody_Debuff') == 'YES' then
            local MINMATK = TryGetProp(caster, "MINMATK")
            local addDamage = MINMATK * (Thaumaturge6.Level * 0.3)
            
            rateTable.AddAtkDamage = rateTable.AddAtkDamage + addDamage;
        end

        if Thaumaturge7 ~= nil and IsBuffApplied(self, 'SwellBody_Debuff') == 'YES' then
            AddBuff(from, self, 'UC_debrave', 1, 0, 8000 * Thaumaturge7.Level, 1);
        end
        
        if skill.ClassName == "Wizard_MagicMissile" then
            local hitCount = 2
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
            AddMultipleHitCount(ret, hitCount);
        end
    end
end

function SCR_BUFF_RATETABLE_DeprotectedZone_Debuff(self, from, skill, atk, ret, rateTable, buff)
    
    if IsBuffApplied(self, 'DeprotectedZone_Debuff') == 'YES' then
        
        local Cleric7_abilLv = GetBuffArgs(buff);
        local rItem  = GetEquipItem(from, 'RH');
        if Cleric7_abilLv > 0 and skill.ClassID < 100 and rItem.ClassType2 == "Sword" then
            AddBuff(from, self, 'UC_deprotect', 1, 0, Cleric7_abilLv * 1000, 1);  
        end
    end
end 


function SCR_BUFF_RATETABLE_Lethargy_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Lethargy_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if (IS_PC(from) == true and GetJobObject(from).CtrlType ~= 'Wizard') and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        local Wizard7_abilLv = GetBuffArgs(buff);
        if Wizard7_abilLv > 0 and attackType == 'Strike' then
            rateTable.DamageRate = rateTable.DamageRate + (0.1 * Wizard7_abilLv);
        end
        
        if skill.HitType == "Pad" then
        	rateTable.DamageRate = rateTable.DamageRate + 0.2
        end
        
        local abilWizard24 = GetAbility(from, "Wizard24");
        if abilWizard24 ~= nil and abilWizard24.ActiveState == 1 and skill.HitType == "Pad" then
        	local abilDamageRate = 0.03 * abilWizard24.Level
        	rateTable.DamageRate = rateTable.DamageRate + abilDamageRate;
        end
    end
end

function SCR_BUFF_RATETABLE_ScullSwing_Debuff(self, from, skill, atk, ret, rateTable, buff)
    
--    if self.Size ~= "M" and self.Size ~= "L" then
--        return ;
--    end
    if self.Size == "M" and self.Size == "L" then
        if skill.ClassName == 'Highlander_VerticalSlash' then
            
            local defadd = GetExProp(buff, "ADD_DEF");
            rateTable.blkAdd = rateTable.blkAdd - 10000;
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - 10000;
            
            if self.Size == 'M' then
                defadd = defadd * 0.8
            end
            SkillTextEffect(nil, self, from, 'SHOW_SKILL_EFFECT', 0, nil, 'skill_verticalslash');
            rateTable.AddAtkDamage = rateTable.AddAtkDamage + defadd;
        end
    else
        return;
    end
end

function SCR_BUFF_RATETABLE_ResistElements_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'ResistElements_Buff') == 'YES' then
        local missAdd = 0;
        local damageRate = 0;
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local resistSkl = GetSkill(caster, "Paladin_ResistElements")
            if resistSkl ~= nil and (skill.Attribute == "Fire" or skill.Attribute == "Ice" or skill.Attribute == "Lightning" or skill.Attribute == "Poison" or skill.Attribute == "Earth") then
                missAdd = missAdd + 100 * resistSkl.Level;
                
                local abil = GetAbility(caster, "Paladin1")
                if abil ~= nil then
                    missAdd = missAdd + 80 * abil.Level;
                end
                
                damageRate = 0.025 * resistSkl.Level;
            end
        end
        
--        rateTable.DamageRate = rateTable.DamageRate - damageRate
		AddDamageReductionRate(rateTable, damageRate)
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_JollyRoger_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'JollyRoger_Buff') == 'YES' then
        local missAdd = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local partyMemberCount = 0
            local party = GetPartyObj(caster, 0);
            if party ~= nil then
                partyMemberCount = GetPartyAliveMemberCount(party) - 1;
            end
            
            local JollyRogerSkill = GetSkill(self, "Corsair_JollyRoger")
            if JollyRogerSkill == nil then
                return
            end
            
            local abil = GetAbility(caster, "Corsair14")
            if abil ~= nil and JollyRogerSkill.Level >= 2 then
                missAdd = missAdd + 50 * abil.Level;
            end
            
            missAdd = missAdd * partyMemberCount
        end
        
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_Slow_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Slow_Debuff') == 'YES' then
        local missDiscount = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Chronomancer6")
            if abil ~= nil then
                missDiscount = missDiscount + 600 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating - missDiscount;
    end
end

function SCR_BUFF_RATETABLE_JincanGu_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'JincanGu_Debuff') == 'YES' then
        local dodgeRatio = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Wugushi6")
            if abil ~= nil then
                dodgeRatio = dodgeRatio + 500 * abil.Level;
            end
        end
        
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - dodgeRatio;
    end
end

function SCR_BUFF_RATETABLE_Forecast_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Forecast_Buff') == 'YES' then
        local missAdd = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Oracle6")
            if abil ~= nil then
                missAdd = missAdd + 100 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_RetreatShot(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'RetreatShot') == 'YES' then
        local missAdd = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Schwarzereiter3")
            if abil ~= nil then
                missAdd = missAdd + 50 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_Link_Sacrifice(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Link_Sacrifice') == 'YES' then
        local missAdd = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Linker3")
            if abil ~= nil then
                missAdd = missAdd + 200 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_Linker_Sacrifice(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Linker_Sacrifice') == 'YES' then
        local missAdd = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Linker3")
            if abil ~= nil then
                missAdd = missAdd + 200 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating + missAdd;
    end
end

function SCR_BUFF_RATETABLE_Circling_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Circling_Buff') == 'YES' and (skill.ClassName == 'Hoplite_ThrouwingSpear' or skill.ClassName == 'Peltasta_ShieldLob') then
        rateTable.DamageRate = rateTable.DamageRate + 2;
    end
    
    if IsBuffApplied(self, 'Circling_Buff') == 'YES' then
        local missDiscount = 0;
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local abil = GetAbility(caster, "Falconer7")
            if abil ~= nil then
                missDiscount = missDiscount + 500 * abil.Level;
            end
        end
        
        rateTable.missRating = rateTable.missRating - missDiscount;
    end
end

function SCR_BUFF_RATETABLE_LastRites_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'LastRites_Buff') == 'YES' and (IsBuffApplied(from, 'Cleric_Revival_Buff') == 'YES' or IsBuffApplied(from, 'Cleric_Revival_Leave_Buff') == 'YES') then
        local caster = GetBuffCaster(buff)
        local abil = GetAbility(caster, "Chaplain5")
        if abil ~= nil then
            rateTable.blkAdd = rateTable.blkAdd - abil.Level * 1500;
        end
    end
end

--function SCR_BUFF_RATETABLE_LastRites_ActiveBuff(self, from, skill, atk, ret, rateTable, buff)
--    if IsBuffApplied(from, 'LastRites_ActiveBuff') == 'YES' and (IsBuffApplied(from, 'Cleric_Revival_Buff') == 'YES' or IsBuffApplied(from, 'Cleric_Revival_Leave_Buff') == 'YES') then
--        local caster = GetBuffCaster(buff)
--        local abil = GetAbility(caster, "Chaplain5")
--        if abil ~= nil then
--            rateTable.blkAdd = rateTable.blkAdd - abil.Level * 1500;
--        end
--    end
--end


function SCR_BUFF_RATETABLE_Gae_Bulg_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Gae_Bulg_Debuff') == 'YES' then
        if skill.ClassType == 'Melee' then
        local hitCount = 2
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.15
            SetMultipleHitCount(ret, hitCount);
        end
    end
end

function SCR_BUFF_RATETABLE_Langort_BlkAbil(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Langort_BlkAbil') == 'YES' then
        local abil = GetAbility(self, "Peltasta28")
        if abil ~= nil then
            rateTable.blkAdd = rateTable.blkAdd + abil.Level * 500;
        end
    end
end

function SCR_BUFF_RATETABLE_Safe(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Safe') == 'YES' then
        rateTable.IgnoreDamage = 1;
    end
end

function SCR_BUFF_RATETABLE_SneakHit_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'SneakHit_Buff') == 'YES' then
        local angle = 120
        local skillLevel = GetBuffArg(buff)
        
        local selfx, selfz = GetDir(from)
        local targetx, targetz = GetDir(self)
        
        local selfDir = GetAngleTo(from, self)
        local monDir = DirToAngle(targetx, targetz)
        
        local relativeAngle = selfDir - monDir
        local revAngle = angle * -1
        relativeAngle = math.floor(relativeAngle)
   
        if GetExProp(from, "IS_BACKATTACK") == 1 or (angle/2 >= relativeAngle and 0 <= relativeAngle) or (revAngle/2 <= relativeAngle and 0 >= relativeAngle) then
            local addCriRatio = 3000 + skillLevel * 200
            rateTable.crtRatingAdd = rateTable.crtRatingAdd + addCriRatio;
        end
    end
end

function SCR_BUFF_RATETABLE_HellBreath_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'HellBreath_Debuff') == 'YES' and skill.Attribute == "Fire" then
        rateTable.DamageRate = rateTable.DamageRate + 0.5;
    end
end

function SCR_BUFF_RATETABLE_Blistering_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Blistering_Debuff') == 'YES' then
        
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            
            local abil = GetAbility(caster, "Falconer10")
            if abil ~= nil and IMCRandom(1,10000) < 1500 then
                AddBuff(caster, self, 'Blistering_Debuff_Abil', abil.Level, 0, 3000, 1);
            end
            
        end
        
    end
end

function SCR_BUFF_RATETABLE_Commence_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Commence_Buff') == 'YES' and IMCRandom(1,10000) > 5000 then
        AddBuff(from, self, 'Commence_Debuff', sklLv, 0, 10000, 1);  
    end
    if IsBuffApplied(from, 'Commence_Buff') == 'YES' and skill.ClassName == 'Cataphract_Rush' then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
    end
end

function SCR_BUFF_RATETABLE_Maze_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Maze_Debuff') == 'YES' and skill.ClassName == 'Sage_Maze' and GetSkillOwner(skill).Name == GetBuffCaster(buff).Name then
        
    else
        rateTable.IgnoreDamage = 1;
    end
end

function SCR_BUFF_RATETABLE_EvasiveAction_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'EvasiveAction_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + skillLevel * 200;
    end

end

function SCR_BUFF_RATETABLE_Enchantment_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(from, 'Enchantment_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        if IMCRandom(1,10000) < 400 * skillLevel then
            AddBuff(from, self, 'UC_confuse', 1, 0, 6000 + skillLevel * 100, 1);
        end
    end

end

function SCR_BUFF_RATETABLE_Agility_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Agility_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        local addDodge = GetStamina(self) * (0.001 * skillLevel)
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + addDodge
    end

end

function SCR_BUFF_RATETABLE_DarkSight_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'DarkSight_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        local addDodge = 1000 + skillLevel * 300
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + addDodge
    end

end

function SCR_BUFF_RATETABLE_murmillo_helmet(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'murmillo_helmet') == 'YES' then
        if skill.ClassType == 'Melee' then
            local addDodge = 3000
            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - addDodge;
        elseif skill.ClassType == 'Missile' then
            local addBlk = 4900
            rateTable.blkAdd = rateTable.blkAdd + addBlk;
        elseif skill.ClassType == 'Magic' then
            local addMiss = 4900
            rateTable.missRating = rateTable.missRating + addMiss;
        end
    end
end

function SCR_BUFF_RATETABLE_EvadeThrust_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'EvadeThrust_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        local addBlk = 4000
        rateTable.blkAdd = rateTable.blkAdd + addBlk;
    end
    
    if IsBuffApplied(self, 'EvadeThrust_Buff') == 'YES' and skill.ClassType == 'Magic' then
--        rateTable.DamageRate = rateTable.DamageRate - 0.3;
        AddDamageReductionRate(rateTable, 0.3)
    end
end

function SCR_BUFF_RATETABLE_HeadButtAbil_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'HeadButtAbil_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        local abilLv = GetBuffArg(buff);
        if attackType == 'Strike' then
            rateTable.DamageRate = rateTable.DamageRate + (abilLv * 0.06)
        end
    end
end

function SCR_BUFF_RATETABLE_Zwerchhau_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Zwerchhau_Debuff') == 'YES' then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end

        if attackType == 'Slash' and self.ArmorMaterial ~= 'Iron' then
            rateTable.DamageRate = rateTable.DamageRate + 0.8
        end
    end
end

function SCR_BUFF_RATETABLE_Serpentine_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Serpentine_Debuff') == 'YES' then
        if skill.ClassType == 'Melee' and (skill.UseType == 'MELEE_GROUND' or skill.UseType == 'TARGET_GROUND') then
            local value = 0.5
            if skill.ClassName == "Hoplite_Pierce" then
                value = 0.7
            end
            
            rateTable.DamageRate = rateTable.DamageRate + value;
        end
    end
end

function SCR_BUFF_RATETABLE_BloodCurse_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'BloodCurse_Debuff') == 'YES' then
        local healValue = math.floor(atk * (0.1 + skill.Level * 0.02))
        
        Heal(from, healValue, 0)
    end
end

function SCR_BUFF_RATETABLE_CavalryCharge_Debuff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'CavalryCharge_Debuff') == 'YES' then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + 3500
    end
end

function SCR_BUFF_RATETABLE_Merkabah_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Merkabah_Buff') == 'YES' then
        if skill.ClassType == 'Magic' then
            rateTable.missRating = rateTable.missRating + 3000;
        else
            rateTable.blkAdd = rateTable.blkAdd + 1500;
        end
    end
end

function SCR_BUFF_RATETABLE_Levitation_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Levitation_Buff') == 'YES' then
    	if skill.ClassType == 'Melee' then
	        rateTable.missResult = 1;
        end
        
    	if skill.ClassType == 'Missile' then
	        rateTable.DamageRate = rateTable.DamageRate + 0.5;
        end
    end
    
    if IsBuffApplied(from, 'Levitation_Buff') == 'YES' then
		local abilFeatherfoot18 = GetAbility(from, 'Featherfoot18');
		if abilFeatherfoot18 ~= nil and abilFeatherfoot18.ActiveState == 1 then
			if TryGetProp(skill, 'Job') == "Featherfoot" then
				local addDamageRate = abilFeatherfoot18.Level * 0.1;
				rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
			end
		end
	end
end

function SCR_BUFF_RATETABLE_HangingShot(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'HangingShot') == 'YES' and skill.ClassType == 'Melee' then
        rateTable.missResult = 1;
    end
    
    if IsBuffApplied(self, 'HangingShot') == 'YES' and skill.ClassType == 'Missile' then
        rateTable.DamageRate = rateTable.DamageRate + 0.5
    end
end

function SCR_BUFF_RATETABLE_StormCalling_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'StormCalling_Debuff') == 'YES' and skill.ClassID > 10000 and skill.Attribute == "Lightning" then
        if skill.ClassName == 'Kriwi_Zaibas' then
            rateTable.DamageRate = rateTable.DamageRate + 1.5
        elseif skill.ClassName == 'Elementalist_Electrocute' then
            rateTable.DamageRate = rateTable.DamageRate + 1
        else
            rateTable.DamageRate = rateTable.DamageRate + 1.3
        end
    end
    
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local abil = GetAbility(caster, "Daoshi10")
        if abil ~= nil and IsBuffApplied(self, 'StormCalling_Debuff') == 'YES' and skill.ClassType == "Melee" then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

function SCR_BUFF_RATETABLE_Bazooka_Buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(from, 'Bazooka_Buff') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        rateTable.DamageRate = rateTable.DamageRate + (skillLevel * 0.1)
    end

end

function SCR_BUFF_RATETABLE_Gohei_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Gohei_Buff') == 'YES' and skill.ClassType == 'Missile' then
      rateTable.blkResult = 1
    end
end

function SCR_BUFF_RATETABLE_ButtStroke_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'ButtStroke_Debuff') == 'YES' and skill.AttackType == "Gun" then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
    end
end

function SCR_BUFF_RATETABLE_Crown_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Crown_Buff') == 'YES' and skill.ClassName == "Highlander_Moulinet" then
        rateTable.DamageRate = rateTable.DamageRate + 1;
    end
end


function SCR_BUFF_RATETABLE_FeverTime(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'FeverTime') == 'YES' then
        if skill.ClassType == 'Missile' then
            local addRate = GetBuffArgs(buff);
            if addRate == nil then
                addRate = 1;
            end
            addRate = 0.15 + ((addRate - 1) * 0.03);
            rateTable.DamageRate = rateTable.DamageRate + addRate;
        end
    end
end

function SCR_BUFF_RATETABLE_Archer_Kneelingshot(self, from, skill, atk, ret, rateTable, buff)
    local abil = GetAbility(from, "Cannoneer14");
    if abil ~= nil then
        if IsBuffApplied(from, 'Archer_Kneelingshot') == 'YES' and skill.ClassName == 'Cannoneer_CannonBlast' or skill.ClassName == 'Cannoneer_CannonShot' or skill.ClassName == 'Cannoneer_ShootDown' or skill.ClassName == 'Cannoneer_SiegeBurst' or skill.ClassName == 'Cannoneer_CannonBarrage' then
            rateTable.crtRatingAdd = rateTable.crtRatingAdd + (abil.Level * 100)
        end
    end
end
--function SCR_BUFF_RATETABLE_Coursing_Debuff(self, from, skill, atk, ret, rateTable, buff)
--  local skillLevel = GetBuffArg(buff)
--  if IsBuffApplied(self, "Coursing_Debuff") == 'YES'then
--      local rateAdd = skillLevel * 0.01
--      rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate - rateAdd
--    end
--end

function SCR_BUFF_RATETABLE_DeedsOfValor(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'DeedsOfValor') == 'YES' then
        local skillLv = GetBuffArg(buff);
        local addValue = 0.05 + ((skillLv - 1) * 0.02);
        
        rateTable.DamageRate = rateTable.DamageRate + addValue;
    end
    
    if IsBuffApplied(self, 'DeedsOfValor') == 'YES' then
        local skillLv = GetBuffArg(buff);
        local addValue = 0.05 + ((skillLv - 1) * 0.01);
        
        rateTable.DamageRate = rateTable.DamageRate + addValue;
    end
end

function SCR_BUFF_RATETABLE_Sorcerer_Obey_PC_DEF_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Sorcerer_Obey_PC_DEF_Buff') == 'YES' then
--        rateTable.DamageRate = rateTable.DamageRate - 0.2;
        AddDamageReductionRate(rateTable, 0.2)
    end
end

function SCR_BUFF_RATETABLE_Sorcerer_Obey_Status_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Sorcerer_Obey_Status_Buff') == 'YES' then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local Sorcerer15_abil = GetAbility(caster, "Sorcerer15")
            local abil_ratio = 0
            if Sorcerer15_abil ~= nil then
                abil_ratio = Sorcerer15_abil.Level * 0.005;
--                abil_ratio = Sorcerer15_abil.Level * 0.5;
            end
            rateTable.DamageRate = rateTable.DamageRate + abil_ratio;
--            rateTable.AddSkillFator = rateTable.AddSkillFator + abil_ratio
        end
    end
end



function SCR_BUFF_RATETABLE_Blessing_Buff(self, from, skill, atk, ret, rateTable, buff)
	if IsBuffApplied(from, 'Blessing_Buff') == 'YES' then
	    if GetRelation(self, from) == "ENEMY" then
	    	local addTrueDamage = GetExProp(buff, "BlessingValue");
	    	rateTable.AddTrueDamage = rateTable.AddTrueDamage + math.floor(addTrueDamage);
--			SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS', math.floor(value), nil, "skill_Blessing");
	    end
    end
end



function SCR_BUFF_RATETABLE_StoneSkin_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'StoneSkin_Buff') == 'YES' then
        local attackType = GET_SKILL_ATTACKTYPE(skill)
        if attackType == 'Slash' or attackType == 'Aries' or attackType == 'Arrow' or attackType == 'Gun' or attackType == 'Magic' then
            local skillLv = GetBuffArgs(buff);
            local buffValue = (10 + math.floor((skillLv - 1) * 2.5)) / 100;
            
--            rateTable.DamageRate = rateTable.DamageRate - buffValue;
            AddDamageReductionRate(rateTable, buffValue)
        end
    end
end

function SCR_BUFF_RATETABLE_TransmitPrana_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'TransmitPrana_Debuff') == 'YES' and skill.Attribute == 'Soul' then
        rateTable.DamageRate = rateTable.DamageRate + 0.5;
    end
    
    if IsBuffApplied(from, 'TransmitPrana_Debuff') == 'YES' and skill.ClassType == "Magic" then
        local skillLv = GetBuffArg(buff);
        local fromMATK = TryGetProp(from, "MINMATK");
        if fromMATK == nil then
            fromMATK = 0;
        end
        
        local addSoulAtk = fromMATK * ( 0.5 + skillLv * 0.03);
        if skill.Attribute == 'Soul' then
            addSoulAtk = addSoulAtk * 1.5;
        end
        
        addSoulAtk = math.floor(addSoulAtk);
        
        rateTable.AddAttributeDamageSoul = rateTable.AddAttributeDamageSoul + addSoulAtk;
--        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS', math.floor(addSoulAtk), nil, "skill_TransmitPrana");
    end
end

function SCR_BUFF_RATETABLE_Hexing_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Hexing_Debuff') == 'YES' and skill.ClassName == "Bokor_Effigy" then
        local bonusHitCount = 3;
        
        if IsBuffApplied(from, "item_EffigyBonus1_buff") == 'YES' then
            bonusHitCount = 2;
        end
        
        local propName = buff.ClassName..'_'..tostring(GetHandle(from));
        local hitCount = GetExProp(buff, propName);
        
        if hitCount + 1 >= bonusHitCount then
            local minRate = SCR_GET_Effigy_Ratio(skill) - 1;
            local maxRate = SCR_GET_Effigy_Ratio2(skill) - 1;
            
            local addRate = IMCRandomFloat(minRate, maxRate);
            
            rateTable.DamageRate = rateTable.DamageRate + addRate;
            
            SetExProp(buff, propName, 0);
        else
            SetExProp(buff, propName, hitCount + 1);
        end
        
        local abilBokor2 = GetAbility(from, "Bokor2")
        if abilBokor2 ~= nil and IMCRandom(1,9999) < abilBokor2.Level * 500 then
            AddBuff(from, self, 'Blind', 1, 0, 5000, 1);
        end
    end
    
    if IsBuffApplied(self, 'Hexing_Debuff') == 'YES' then
        local caster = GetBuffCaster(buff)
        if caster == nil then
            caster = from;
        end
        
        local abil = GetAbility(caster, "Bokor9")
        local Bokor9_abilLv = GetBuffArgs(buff);
        if abil ~= nil then
            if Bokor9_abilLv > 0 and skill.Attribute == 'Dark' and abil.ActiveState == 1 then
                rateTable.DamageRate = rateTable.DamageRate + (0.1 * Bokor9_abilLv);
            end
        end
        
        local Featherfoot8_abil = GetAbility(caster, "Featherfoot8")
        if Featherfoot8_abil ~= nil and IMCRandom(1,9999) < Featherfoot8_abil.Level * 100 then
            rateTable.DamageRate = rateTable.DamageRate + 1
        end
        
    end
end

function SCR_BUFF_RATETABLE_Sanctuary_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Sanctuary_Buff') == 'YES' then
        local attackerBuff = GetBuffByName(from, 'Sanctuary_Buff');
        if attackerBuff ~= nil then
            local addHolyDamage = 0;
            if skill.ClassType == "Melee" or skill.ClassType == "Missile" then
                local addDEF = GetExProp(attackerBuff, "ADD_DEF");
                if addDEF == nil then
                    addDEF = 0;
                end
                
                addHolyDamage = addDEF;
            elseif skill.ClassType == "Magic" then
                local addMDEF = GetExProp(attackerBuff, "ADD_MDEF");
                if addMDEF == nil then
                    addMDEF = 0;
                end
                
                addHolyDamage = addMDEF;
            end
            
            rateTable.AddAttributeDamageHoly = rateTable.AddAttributeDamageHoly + addHolyDamage;
        end
    end
end



-- OgouVeve_Buff
function SCR_BUFF_RATETABLE_OgouVeve_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'OgouVeve_Buff') == 'YES' then
        local lv, arg2 = GetBuffArg(buff);
        
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local pad = GetPadByBuff(caster, buff);
            if pad ~= nil then
                lv = GetPadArgNumber(pad, 1);
            end
        end
        
        local addDamageRate = lv * 0.1;
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end

function SCR_BUFF_RATETABLE_Judgment_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Judgment_Debuff") == "YES" then
        if TryGetProp(self, "RaceType") == "Velnias" then
            if skill.Attribute == "Holy"  then
                rateTable.DamageRate = rateTable.DamageRate + 0.1;
            end
        end
        
        if IS_PC(self) == true then
            rateTable.DamageRate = rateTable.DamageRate + 0.1;
        end
    end
end

function SCR_BUFF_RATETABLE_EnchantEarth_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'EnchantEarth_Buff') == 'YES' then
        local EnchantEarthSklLv = GetBuffArgs(buff);
        if EnchantEarthSklLv > 0 then
            local EnchantEarthRatio = 500 + EnchantEarthSklLv * 200
            rateTable.blkAdd = rateTable.blkAdd + EnchantEarthRatio;
        end
    end
end

function SCR_BUFF_RATETABLE_Ole_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Ole_Buff') == 'YES' then
        local addCritical = 0;
        
        local skillLevel = GetExProp(buff, "OLE_LEVEL")
        local topAttacker = GetTopHatePointChar(self)
		
        if topAttacker ~= nil and IsSameActor(topAttacker, from) == "YES"  then
            addCritical = 1000 + (skillLevel * 200);
        else
        	addCritical = 500 + (skillLevel * 100);
        end
		
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + addCritical;
    end
end

function SCR_BUFF_RATETABLE_HakkaPalle_Buff(self, from, skill, atk, ret, rateTable, buff)
    local attackType = skill.AttackType
    local dodgeRatio = 1000
    local HakkaPalleSklLv = GetBuffArgs(buff);
    if HakkaPalleSklLv > 0 then
        dodgeRatio = dodgeRatio + HakkaPalleSklLv * 200
    end
    if IS_PC(from) == true and IsNormalSKillBySkillID(from, skill.ClassID) == 1 then
        local weaponHand = 'RH';
        local useSubWeapon = TryGetProp(skill, 'UseSubweaponDamage');
        if useSubWeapon == 'YES' then
            weaponHand = 'LH';
        end
        
        local weapon = GetEquipItem(from, weaponHand);
        attackType = TryGetProp(weapon, 'AttackType');
    end
    
    if IsBuffApplied(self, "HakkaPalle_Buff") == "YES" and (attackType == "Slash" or attackType == "Aries" or attackType == "Strike") then
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + dodgeRatio
    end
end

function SCR_BUFF_RATETABLE_Daino_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Daino_Buff') == 'YES' then
        if IS_PC(from) == true and IsNormalSKillBySkillID(from, skill.ClassID) == 1 then
            if skill.ClassType == 'Melee' then
                rateTable.NotCalculated = 1;
                local damage = SCR_GET_PC_ATK(from, 'Magic');
                
                local key = GetSkillSyncKey(from, ret);
                StartSyncPacket(from, key);
                
                TakeDamage(from, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, "Magic", skill.HitType, HITRESULT_NO_HITSCP)
                
                EndSyncPacket(from, key);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_DivineStigma_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'DivineStigma_Debuff') == 'YES' then
        if skill.ClassName == 'Kriwi_Zaibas' then
            rateTable.DamageRate = rateTable.DamageRate + 0.5;
        end
    end
end

function SCR_BUFF_RATETABLE_Aukuras_Kriwi18_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Aukuras_Kriwi18_Buff') == 'YES' then
        if skill.ClassType == 'Magic' then
            local addFireDamage = GetBuffArgs(buff);
            rateTable.AddAttributeDamageFire = rateTable.AddAttributeDamageFire + addFireDamage;
        end
    end
end

function SCR_BUFF_RATETABLE_CounterSpell_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'CounterSpell_Buff') == 'YES' then
        if skill.ClassType == 'Magic' then
            rateTable.NoneDamage = 1;
        end
    end
end

function SCR_BUFF_RATETABLE_DragoonHelmet_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'DragoonHelmet_Buff') == 'YES' then
        if skill.Job == "Dragoon" then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

-- DeathVerdict_Buff
function SCR_BUFF_RATETABLE_DeathVerdict_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'DeathVerdict_Buff') == 'YES' then
        local addDamageRate = GetExProp(buff, 'ADD_DAMAGE_RATE');
        addDamageRate = addDamageRate / 100;
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end

-- Foretell_Buff
function SCR_BUFF_RATETABLE_Foretell_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Foretell_Buff') == 'YES' then
        rateTable.EnableDodge = 0;
    end
end

function SCR_BUFF_RATETABLE_Fanaticism_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Fanaticism_Buff') == 'YES' then
        local FanaticismSklLv = GetBuffArgs(buff)
        
        local addDamageRate = 0.05 + (FanaticismSklLv * 0.05);
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
    return 1;
end

function SCR_BUFF_RATETABLE_NonInvasiveArea_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'NonInvasiveArea_Buff') == 'YES' then
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local Skl = GetSkill(caster, "Templer_NonInvasiveArea")
            if Skl ~= nil then
                rateTable.EnableMagicBlock = 1
                local blkRate = 1500 + Skl.Level * 300
                rateTable.blkAdd = rateTable.blkAdd + blkRate;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_SnipersSerenity_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'SnipersSerenity_Buff') == 'YES' then
        local abil_Musketeer22 = GetAbility(from, "Musketeer22")
        local attackType = GET_SKILL_ATTACKTYPE(skill)
        if abil_Musketeer22 ~= nil and abil_Musketeer22.ActiveState == 1 and attackType == "Gun" then
            rateTable.EnableBlock = 0;
        end
    end
end

function SCR_BUFF_RATETABLE_Methadone_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Methadone_Buff') == 'YES' then
        
        rateTable.DamageRate = rateTable.DamageRate + 0.2
    end
end

function SCR_BUFF_RATETABLE_BackSlide_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'BackSlide_Buff') == 'YES' then
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio + 5000
    end
end

function SCR_BUFF_RATETABLE_LightningHands_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'LightningHands_Debuff') == 'YES' then
        if TryGetProp(skill, "ClassType") == "Magic" then
            rateTable.DamageRate = rateTable.DamageRate + 0.2
        end
    end
end

function SCR_BUFF_RATETABLE_AcrobaticMount_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'AcrobaticMount_Buff') == 'YES' then
        if TryGetProp(skill, "EnableCompanion") == "YES" then
        	local AcrobaticMountSklLv = GetBuffArgs(buff)
        	local skillDamage = 0
        	
        	if AcrobaticMountSklLv > 0 then
        		skillDamage = AcrobaticMountSklLv * 0.05
        	end
        	
            rateTable.DamageRate = rateTable.DamageRate + skillDamage
        end
    end
end

function SCR_BUFF_RATETABLE_Hangmansknot_SDR_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Hangmansknot_SDR_Debuff') == 'YES' then
    	local abil_Linker6 = GetAbility(from, "Linker6")
    	if abil_Linker6 ~= nil and abil_Linker6.ActiveState == 1 then
	    	local damageRate = abil_Linker6.Level * 0.05
	    	
	        rateTable.DamageRate = rateTable.DamageRate + damageRate
	    end
    end
end

function SCR_BUFF_RATETABLE_BuildRoost_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'BuildRoost_Buff') == 'YES' then
		if skill.Job == "Falconer" then
        	rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

function SCR_BUFF_RATETABLE_Stabbing_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Stabbing_Buff') == 'YES' then
    	if skill.ClassName == 'Hoplite_Stabbing' then
			local over = GetBuffOver(from, 'Stabbing_Buff')
			local addDamageRate = over * 0.1;
			rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
		end
    end
end

function SCR_BUFF_RATETABLE_Concentrate_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Concentrate_Buff') == 'YES' then
	    if GetRelation(self, from) == "ENEMY" and skill.ClassName ~= "Default" and (skill.ClassType == "Melee" or skill.ClassType == "Missile") then
            if GetExProp(buff, "ConcentrateCount") > 0 then
			    local addTrueDamage = GetExProp(buff, "ConcentrateValue");
			    rateTable.AddTrueDamage = rateTable.AddTrueDamage + math.floor(addTrueDamage);
			    
			    ret.HitType = HIT_CONCENTRATE;
	        end
	    end
    end
end

function SCR_BUFF_RATETABLE_GroovingMuzzle_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'GroovingMuzzle_Buff') == 'YES' then
        local rItem = GetEquipItem(from, 'RH');
        if rItem ~= nil and rItem.ClassType == "Musket" then
		    local addIgnoreDefensesRate = 0.15;
		    rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate + addIgnoreDefensesRate;
		    
		    if IsNormalSKillBySkillID(from, skill.ClassID) == 1 and skill.ClassName ~= 'Default' then
			    local rate = 3000;	-- 30% --
			    if rate >= IMCRandom(1, 10000) then
			    	SetExProp(from, "IS_CRITICAL", 1)
					local hitCount = 3;
					
					AddMultipleHitCount(ret, hitCount);
					rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2;
			    end
			end
		end
    end
end

function SCR_BUFF_RATETABLE_Skill_MomentaryEvasion_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Skill_MomentaryEvasion_Buff') == 'YES' then
    	local buffLv, buffRate = GetBuffArg(buff);
    	if buffRate >= 10000 or buffRate >= IMCRandom(1, 10000) then
	    	local addDodgeRate = 10000;
		    rateTable.FixedDodgeRate = rateTable.FixedDodgeRate + addDodgeRate;
		end
    end
end


function SCR_BUFF_RATETABLE_Muleta_Cast_End_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Muleta_Cast_End_Buff') == 'YES' then
		if skill.ClassType == "Melee" then
			rateTable.blkResult = 1
		end
    end
end

function SCR_BUFF_RATETABLE_Drain_Buff(self, from, skill, atk, ret, rateTable, buff)
    local darkTheurageCount = GetExProp(from, "DARKTHEURAGE_COUNT")
    if IsBuffApplied(from, "Drain_Buff") == "YES" then
        if TryGetProp(skill, "Attribute") == "Dark" and TryGetProp(skill, "ClassType") == "Magic" then
        local addRate = darkTheurageCount * 0.1
        rateTable.DamageRate = rateTable.DamageRate + addRate
    end
end
end

function SCR_BUFF_RATETABLE_Sleep_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Sleep_Debuff') == 'YES' then
    	local caster = GetBuffCaster(buff)
    	if caster ~= nil then
	    	local abilWizard25 = GetAbility(caster, "Wizard25")
	    	if abilWizard25 ~= nil then
				if skill.Attribute == "Melee" or skill.Attribute == "Soul" then
					rateTable.DamageRate = rateTable.DamageRate + 1;
				end
			end
		end
    end
end

function SCR_BUFF_RATETABLE_Gust_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Gust_Debuff') == 'YES' then
		if skill.Attribute == "Ice" then
			rateTable.DamageRate = rateTable.DamageRate + 0.1
		end
    end
end


function SCR_BUFF_RATETABLE_Raise_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Raise_Debuff') == 'YES' then
		rateTable.EnableDodge = 0
    end
end

function SCR_BUFF_RATETABLE_Link_Party(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Link_Party") == "YES" then
    	local caster = GetBuffCaster(buff)
    	if caster ~= nil then
	    	local abilLinker12 = GetAbility(caster, "Linker12")
			if abilLinker12 ~= nil and skill.ClassType == "Magic" then
				local spiritualChainSkill = GetSkill(caster, "Linker_SpiritualChain")
				local abilAddDamage = spiritualChainSkill.Level * 0.03
				rateTable.DamageRate = rateTable.DamageRate + abilAddDamage
			end
		end
    end
end

function SCR_BUFF_RATETABLE_FirePillar_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "FirePillar_Debuff") == "YES" then
		if IsBuffApplied(self, "StormDust_Debuff") == "YES" then
			local hitCount = 2
			
			rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
			AddMultipleHitCount(ret, hitCount);
		end
    end
end

function SCR_BUFF_RATETABLE_FireWall_Debuff(self, from, skill, atk, ret, rateTable, buff)
	local abilElementalist30 = GetAbility(from, "Elementalist30")
	if abilElementalist30 ~= nil and abilElementalist30.ActiveState == 1 then
	    if IsBuffApplied(self, "FireWall_Debuff") == "YES" then
			if skill.ClassName == "Elementalist_Meteor" then
				local hitCount = 5
				
				rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.5
				AddMultipleHitCount(ret, hitCount);
			end
	    end
	end
end

function SCR_BUFF_RATETABLE_SubWeaponCancel_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "SubWeaponCancel_Buff") == "YES" then
        if skill.ClassName == "War_JustFramePistol" or skill.ClassName == "War_JustFrameAttack" or skill.ClassName == "War_JustFrameDagger" then
            local subWeaponCancelSkill = GetSkill(from, "Corsair_SubweaponCancel");
            if subWeaponCancelSkill ~= nil then
                local skillLevel = TryGetProp(subWeaponCancelSkill, "Level");
                local addRate = skillLevel * 0.05 + 0.3;
                if addRate >= 0 then
                    rateTable.DamageRate = rateTable.DamageRate + addRate;
                end
            end
        end
    end
end

function SCR_BUFF_RATETABLE_SpiritShock_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "SpiritShock_Debuff") == "YES" then
    	local caster = GetBuffCaster(buff)
    	if caster ~= nil then
    		if skill.ClassName == "Linker_SpiritShock" and IsSameActor(from, caster) == "YES" then
				local abilLinker15 = GetAbility(from, "Linker15")
				if abilLinker15 ~= nil and abilLinker15.ActiveState == 1 then
					local pcMNA = TryGetProp(from, "MNA")
					if pcMNA < 1 then
						pcMNA = 1
					end
					
					local enemyMNA = TryGetProp(self, "MNA")
					if enemyMNA < 1 then
						enemyMNA = 1
					end
					
					local abilDamageRate = (1 + ((pcMNA + 100) / ((enemyMNA + 100) * 2)))
					if abilDamageRate > 2 then
						abilDamageRate = 2
					end
					
					rateTable.DamageRate = rateTable.DamageRate + abilDamageRate;
				end
			end
		end
    end
end

function SCR_BUFF_RATETABLE_SwashBucklingReduceDamage_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "SwashBucklingReduceDamage_Buff") == "YES" then
        local abilPeltasta1 = GetAbility(self, "Peltasta1");
        if abilPeltasta1 ~= nil and TryGetProp(abilPeltasta1, "ActiveState") == 1 then
            local abilLv = TryGetProp(abilPeltasta1, "Level");
            if abilLv ~= nil then
                reductionRate = abilLv * 0.05;
                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end


function SCR_BUFF_RATETABLE_SwellLeftArm_Abil_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "SwellLeftArm_Abil_Buff") == "YES" then
		local caster = GetBuffCaster(buff)
		if caster ~= nil then
			local abilThaumaturge17 = GetAbility(caster, "Thaumaturge17")
			if abilThaumaturge17 ~= nil then
				local abilDamageRate = abilThaumaturge17.Level * 0.01
				
				rateTable.DamageRate = rateTable.DamageRate + abilDamageRate;
			end
		end
    end
end

function SCR_BUFF_RATETABLE_Sabbath_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Sabbath_Buff") == "YES" then
        if TryGetProp(skill, "ClassName") == "Warlock_DarkTheurge" or TryGetProp(skill, "ClassName") == "Warlock_Invocation" then
            local sabbath = GetSkill(from, "Warlock_Sabbath");
            local sabbathLv = TryGetProp(sabbath, "Level");
            local sabbathAddDamage = sabbathLv * 0.1;
            rateTable.DamageRate = rateTable.DamageRate + sabbathAddDamage
        end
    end
end

function SCR_BUFF_RATETABLE_StormDust_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "StormDust_Debuff") == "YES" then
    	if TryGetProp(self, "MonRank") ~= "Boss" then
	    	if GetBuffByProp(self, "Keyword", "Position") == nil then
				if TryGetProp(self, "MoveType") == "Flying" then
					local reductionRate = 0.5
					
					AddDamageReductionRate(rateTable, reductionRate);
				end
		    end
		end
    end
end

function SCR_BUFF_RATETABLE_EnchantLightning_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "EnchantLightning_Buff") == "YES" then
        if skill.ClassType == "Melee" or skill.ClassType == "Missile" then
    	    skill.Attribute = 'Lightning';
    	end
    	
    	local buffCaster = GetBuffCaster(buff);
    	local abilEnchanter4 = GetAbility(buffCaster, "Enchanter4");
    	if abilEnchanter4 ~= nil and TryGetProp(abilEnchanter4, "ActiveState") == 1 then
    	    if skill.ClassName == "Psychokino_PsychicPressure" then
    	        skill.Attribute = 'Lightning';
    	    end
    	    
    	    if skill.ClassName == "Psychokino_GravityPole" then
    	        skill.Attribute = 'Lightning';
    	    end
    	end
    end
end

function SCR_BUFF_RATETABLE_FishingNetsDraw_Debuff(self, from, skill, atk, ret, rateTable, buff)
    local addDamageRate = 0
    local abilRetiarii1 = GetAbility(from, "Retiarii1");
    if abilRetiarii1 ~= nil and TryGetProp(abilRetiarii1, "ActiveState") == 1 then
        rateTable.EnableDodge = 0;
    end
    
    local attackType = TryGetProp(skill, "AttackType");
    if IS_PC(from) == true and skill.ClassID < 10000 then
        local rightHand = GetEquipItem(from, 'RH');
        attackType = rightHand.AttackType
    end
    
    local skillJob = TryGetProp(skill, "Job");
    if IsBuffApplied(self, "FishingNetsDraw_Debuff") == "YES" then
        if skillJob ~= "Retiarii" then
            if attackType == "Aries" then
                local weapon = GetEquipItem(from, "RH");
                if TryGetProp(weapon, "ClassType") == "Spear" and TryGetProp(skill, "UseSubweaponDamage") == "NO" then
                    addDamageRate = 1
                end
            end
        end
    end
    
    rateTable.DamageRate = rateTable.DamageRate + addDamageRate
end

function SCR_BUFF_RATETABLE_ThrowingFishingNet_Debuff(self, from, skill, atk, ret, rateTable, buff)
    local addDamageRate = 0
    local abilRetiarii2 = GetAbility(from, "Retiarii2");
    if abilRetiarii2 ~= nil and TryGetProp(abilRetiarii2, "ActiveState") == 1 then
        rateTable.EnableDodge = 0;
    end
    
    local attackType = TryGetProp(skill, "AttackType");
    if IS_PC(from) == true and skill.ClassID < 10000 then
        local rightHand = GetEquipItem(from, 'RH');
        attackType = rightHand.AttackType
    end
    
    local skillJob = TryGetProp(skill, "Job");
    if IsBuffApplied(self, "ThrowingFishingNet_Debuff") == "YES" then
        if skillJob ~= "Retiarii" then
            if attackType == "Aries" then
                local weapon = GetEquipItem(from, "RH");
                if TryGetProp(weapon, "ClassType") == "Spear" and TryGetProp(skill, "UseSubweaponDamage") == "NO" then
                    addDamageRate = 1
                end
            end
        end
    end
    
    rateTable.DamageRate = rateTable.DamageRate + addDamageRate
end

--180222 ?�션 버프 추�? (?�이??RateTable???�음)--
function SCR_BUFF_RATETABLE_Potion_Demon_DMG_DOWN_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Potion_Demon_DMG_DOWN_Buff") == "YES" then
        if TryGetProp(from, "MonRank") == "Boss" then
            if TryGetProp(from, "RaceType") == "Velnias" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local reductionRate = buffarg1 / 100

                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_MIX_DMG_DOWN_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Potion_MIX_DMG_DOWN_Buff") == "YES" then
        if TryGetProp(from, "MonRank") == "Boss" then
            if TryGetProp(from, "RaceType") == "Paramune" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local reductionRate = buffarg1 / 100
                
                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Bug_DMG_DOWN_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Potion_Bug_DMG_DOWN_Buff") == "YES" then
        if TryGetProp(from, "MonRank") == "Boss" then
            if TryGetProp(from, "RaceType") == "Klaida" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local reductionRate = buffarg1 / 100
                
                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Plant_DMG_DOWN_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Potion_Plant_DMG_DOWN_Buff") == "YES" then
        if TryGetProp(from, "MonRank") == "Boss" then
            if TryGetProp(from, "RaceType") == "Forester" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local reductionRate = buffarg1 / 100

                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Wild_DMG_DOWN_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Potion_Wild_DMG_DOWN_Buff") == "YES" then
        if TryGetProp(from, "MonRank") == "Boss" then
            if TryGetProp(from, "RaceType") == "Widling" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local reductionRate = buffarg1 / 100
                
                AddDamageReductionRate(rateTable, reductionRate);
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Demon_DMG_UP_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Potion_Demon_DMG_UP_Buff") == "YES" then
        if TryGetProp(self, "MonRank") == "Boss" then
            if TryGetProp(self, "RaceType") == "Velnias" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local addDamageRate = buffarg1 / 100
                
                rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_MIX_DMG_UP_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Potion_MIX_DMG_UP_Buff") == "YES" then
        if TryGetProp(self, "MonRank") == "Boss" then
            if TryGetProp(self, "RaceType") == "Paramune" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local addDamageRate = buffarg1 / 100
                
                rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Bug_DMG_UP_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Potion_Bug_DMG_UP_Buff") == "YES" then
        if TryGetProp(self, "MonRank") == "Boss" then
            if TryGetProp(self, "RaceType") == "Klaida" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local addDamageRate = buffarg1 / 100
                
                rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Plant_DMG_UP_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Potion_Plant_DMG_UP_Buff") == "YES" then
        if TryGetProp(self, "MonRank") == "Boss" then
            if TryGetProp(self, "RaceType") == "Forester" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local addDamageRate = buffarg1 / 100
                
                rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
            end
        end
    end
end

function SCR_BUFF_RATETABLE_Potion_Wild_DMG_UP_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Potion_Wild_DMG_UP_Buff") == "YES" then
        if TryGetProp(self, "MonRank") == "Boss" then
            if TryGetProp(self, "RaceType") == "Widling" then
                local buffarg1 = GetBuffArg(buff)
                tonumber(buffarg1)
                local addDamageRate = buffarg1 / 100
                
                rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
            end
        end
    end
end
--?�기까�? 180222 ?�션 버프 추�? (?�이??RateTable???�음) ??-
--180308 카드 ?�과 추�? (카드??RateTable??받아?????�음)--
function SCR_BUFF_RATETABLE_CARD_MON_DMG_Rate_Down_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "CARD_MON_DMG_Rate_Down_Buff") == "YES" then
        if IS_PC(from) == false then
            local buffarg1 = GetBuffArg(buff)
            tonumber(buffarg1)
            local reductionRate = (math.floor(buffarg1 * 3)) / 100
            AddDamageReductionRate(rateTable, reductionRate);
        end
    end
end
--180308 카드 ?�과 ??-
function SCR_BUFF_RATETABLE_Tiksline_Debuff(self, from, skill, atk, ret, rateTable, buff)
    local buffCaster = GetBuffCaster(buff)
    local topOwner = GetTopOwner(from);
    if IsSameActor(buffCaster, topOwner) == "YES" then
        if IsBuffApplied(self, "Tiksline_Debuff") == "YES" then
            rateTable.DamageRate = rateTable.DamageRate + 0.5;
        end
    end
end

function SCR_BUFF_RATETABLE_Kraujas_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, buff.ClassName) == "YES" then
        local buffOver = GetBuffOver(from, buff.ClassName);
        local increaseRate = buffOver * 0.1
        rateTable.DamageRate = rateTable.DamageRate + increaseRate;
    elseif IsBuffApplied(self, buff.ClassName) == "YES" then
        local buffOver = GetBuffOver(self, buff.ClassName)
        local increaseRate = buffOver * 0.2
        rateTable.DamageRate = rateTable.DamageRate + increaseRate;
    end
end

function SCR_BUFF_RATETABLE_COSTUME_VELCOFFER_SET(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, "COSTUME_VELCOFFER_SET") == "YES" then

        if GetZoneName(self) == 'd_raidboss_velcoffer' then
            local reductionRate = 0.1
            
            AddDamageReductionRate(rateTable, reductionRate);
        end
    end
end

function SCR_BUFF_RATETABLE_Guardian_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Guardian_Buff") == "YES" then
    	local abilPeltasta33 = GetAbility(self, "Peltasta33")
    	if abilPeltasta33 ~= nil and abilPeltasta33.ActiveState == 1 then
	        local reductionRate = 0.2
	        
	        AddDamageReductionRate(rateTable, reductionRate);
	    end
    end
end

function SCR_BUFF_RATETABLE_Lullaby_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Lullaby_Debuff") == "YES" then
		rateTable.EnableDodge = 0
		rateTable.EnableBlock = 0
    end
end

function SCR_BUFF_RATETABLE_Engkrateia_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Engkrateia_Buff') == 'YES' then
        local skillLv = GetBuffArg(buff);
        local reductionRate = skillLv * 0.05;
        if TryGetProp(skill, "Attribute") == "Dark" or  TryGetProp(from, "RaceType") == "Velnias" then
            reductionRate = reductionRate * 1.5
        end
        
        if reductionRate >= 1 then
            reductionRate = 0.99;
        end
        
        AddDamageReductionRate(rateTable, reductionRate);
    end
end

function SCR_BUFF_RATETABLE_Fluting_DeBuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "Fluting_DeBuff") == "YES" then
		rateTable.EnableDodge = 0
		rateTable.EnableBlock = 0
    end
end

function SCR_BUFF_RATETABLE_LatentVenom_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "LatentVenom_Debuff") == "YES" then
        if TryGetProp(skill, "ClassName") == "Wugushi_LatentVenom" then
            local cnt = GetExProp(buff, "LatentVenom_Debuff_OVER")
            local addDamageRate = cnt * 0.03
            rateTable.DamageRate = rateTable.DamageRate + addDamageRate
        end
    end
end

function SCR_BUFF_RATETABLE_Gregorate_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Gregorate_Buff") == "YES" then
        local addDamageRate = GetExProp(buff, "REMOVE_BUFF_COUNT_BY_GREGORATE");
        rateTable.DamageRate = rateTable.DamageRate + (addDamageRate * 0.5);
    end
end

function SCR_BUFF_RATETABLE_TheTreeOfSepiroth_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "TheTreeofSepiroth") == "YES" then
        AddDamageReductionRate(rateTable, 0.5);
    end
end

function SCR_BUFF_RATETABLE_Lycanthropy_Half_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, "Lycanthropy_Half_Buff") == "YES" then
        local addDamageRate = 0;
        local buffLv = GetBuffArg(buff);
        if skill.ClassType == "Magic" then
            addDamageRate = buffLv * 0.06
        elseif skill.ClassType == "Melee" or skill.ClassType == "Missile" then
            addDamageRate = buffLv * 0.04
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end