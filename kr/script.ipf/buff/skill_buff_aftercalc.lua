-- skill_buff_aftercalc.lua
-- CALC_FINAL_DAMAGE() -> SCR_BUFF_AFTERCALC_UPDATE(self, from, skill, atk, ret, buff);
-- SCR_BUFF_AFTERCALC_HIT_  <- be attacked
-- SCR_BUFF_AFTERCALC_ATK_  <- buffed object attack

function SCR_BUFF_AFTERCALC_HIT_PainBarrier_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    if ret.ResultType ~= HITRESULT_CRITICAL then
        ret.ResultType = HITRESULT_BLOW;
    end
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_AFTERCALC_HIT_ShieldPush_Debuff(self, from, skill, atk, ret, buff)

    if IMCRandom(1, 100) > 70 then
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);
        
        local x, y, z = GetPos(from);
        local angle = GetAngleFromPos(self, x, z);
        KnockDown(self, from, 45, angle, 10, 3, 1, 100)
        
        EndSyncPacket(from, key, 0);
    end

end

function SCR_BUFF_AFTERCALC_HIT_GT_STAGE_10_ROOT(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_BLOW;
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Ausirine_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_SAFETY;
    ret.HitDelay = 0;
    ret.Damage = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Mon_Golden_Bell_Shield_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_SAFETY;
    ret.HitDelay = 0;
    ret.Damage = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Golden_Bell_Shield_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_SAFETY;
    ret.HitDelay = 0;
    ret.Damage = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Golden_Bell_Shield_Safety(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_SAFETY;
    ret.HitDelay = 0;
    ret.Damage = 0;
end

function SCR_BUFF_AFTERCALC_HIT_CounterSpell_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'CounterSpell_Buff') == 'YES' and skill.ClassType == 'Magic' then
        ret.KDPower = 0;
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 0;
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        SkillTextEffect(nil, self, from, "SHOW_GUNGHO", nil);
    end
end

function SCR_BUFF_AFTERCALC_HIT_Ironskin_Buff(self, from, skill, atk, ret, buff)
    if skill.ClassType == "Melee" then
        local damReflect = self.DamReflect;
        local Iron = GetSkill(self, 'Monk_IronSkin')
        if Iron ~= nil and damReflect > 0 then
--            local key = GetSkillSyncKey(self, ret);
            local x, y, z = GetPos(self);
--          StartSyncPacket(self, key);
            
            ret.KDPower = 0;
            ret.ResultType = HITRESULT_NONE;
            ret.HitType = HIT_SAFETY;
            ret.HitDelay = 0;
            ret.Damage = 0;

            local dmgratio = 0.5 + Iron.Level * 0.1
            local Monk2_abil = GetAbility(self, "Monk2")
            if Monk2_abil ~= nil then
                dmgratio = dmgratio + Monk2_abil.Level * 0.05
            end
                
            local dmg = from.MINPATK * dmgratio
            DamageReflect(self, from, Iron.ClassName, dmg, "None", "Strike", "Melee", HIT_MOTION, HITRESULT_BLOW);
--          TakeDamage(self, from, Iron.ClassName, dmg, "None", "Strike", "Melee", HIT_MOTION, HITRESULT_BLOW);
            PlayEffect(self, 'F_sys_IronSkinblock', 0.4, 0, 0)
--          EndSyncPacket(self, key)
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_HellBreath_Buff(self, from, skill, atk, ret, buff)

    if from.MonRank == 'Boss' then
        return ;
    end

    if IsBuffApplied(self, 'HellBreath_Buff') == 'YES' and skill.ClassType == "Melee" then
        local skl = GetSkill(self, 'Pyromancer_HellBreath')
        if skl ~= nil then
            ret.KDPower = 0;
            ret.ResultType = HITRESULT_NONE;
            ret.HitType = HIT_SAFETY;
            ret.HitDelay = 0;
            ret.Damage = 0;
            SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            SkillTextEffect(nil, self, from, "SHOW_GUNGHO", nil);
        end
    end
end


function SCR_BUFF_AFTERCALC_HIT_todal_shield(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'ReflectShield_Buff') == 'NO' then
        local dmg = ret.Damage * 0.25;
        DamageReflect(self, from, "None", dmg, "Melee", "Melee", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW);
    end
end


function SCR_BUFF_AFTERCALC_HIT_UC_petrify(self, from, skill, atk, ret, buff)
    ret.Damage = ret.Damage / 2;
end

function SCR_BUFF_AFTERCALC_ATK_WedgeFormation_buff(self, from, skill, atk, ret, buff)
    
    local propValue = GetExProp(buff, 'PATK_BM');
    if propValue > 0 and ret.Damage > 1 then
        SetRepeatlyHit(ret, 'WedgeFormation_buff', 1);
    end
end


function SCR_BUFF_AFTERCALC_HIT_ReflectShield_Buff(self, from, skill, atk, ret, buff)
    local spendSP = TryGetProp(self, "MSP") * 0.01
    local currentSP = TryGetProp(self, "SP")
    
    local abilWizard2 = GetAbility(self, "Wizard2")
    if abilWizard2 ~= nil and TryGetProp(abilWizard2, "ActiveState") == 1 then
        local reduceSP = TryGetProp(self, "MNA") * (TryGetProp(abilWizard2, "Level") * 0.01)
        spendSP = spendSP - reduceSP
        if spendSP <= 1 then
            spendSP = 1
        end
    end
    
    SetExProp(self, "REFLECTSHIELD_SPENDSP", spendSP)
    SetExProp(self, "REFLECTSHIELD_CURRENTSP", currentSP)
    
    if currentSP > spendSP then
        if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
            ret.Damage = ret.Damage * 0.8;
            
            if ret.Damage < 1 then
                ret.Damage = 1;
            end
            
            ret.KDPower = 0;
            ret.HitType = HIT_SAFETY;
            ret.HitDelay = 0;
            SetExProp(from, "CHECK_SKL_KD_PROP", 1);
    --        RunScript("Reflect_Sync", self, from, skill, dmg, ret)
        end
    end
end



function SCR_BUFF_AFTERCALC_HIT_GenbuArmor_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        if ret.Damage < 1 then
            ret.Damage = 1;
        end
        if skill.Attribute == "Ice" and IMCRandom(1, 100) < 10 then
        	ret.ResultType = HITRESULT_MISS
        end
        
        local genbuArmorSkill = GetSkill(self, "Onmyoji_GenbuArmor")
        if genbuArmorSkill ~= nil then
        	local abilDamageRate = 0
        	local abilOnmyoji12 = GetAbility(self, "Onmyoji12")
        	if abilOnmyoji12 ~= nil and abilOnmyoji12.ActiveState == 1 then
        		abilDamageRate = abilOnmyoji12.Level * 0.01
        	end
        	
            ret.Damage = ret.Damage * (0.9 - (genbuArmorSkill.Level * 0.05)) + abilDamageRate
        end
        
    	local abilOnmyoji11 = GetAbility(self, "Onmyoji11")
    	local remainSP = TryGetProp(self, "SP")
    	if abilOnmyoji11 ~= nil and abilOnmyoji11.ActiveState == 1 then
    		if skill.ClassType == "Melee" or skill.ClassType == "Missile" then
    			if IMCRandom(1, 100) < abilOnmyoji11.Level * 2 then
			        ret.Damage = 0;
			        ret.ResultType = HITRESULT_DODGE;
			        ret.HitType = HIT_DODGE;
			        ret.EffectType = HITEFT_NO;
			        ret.HitDelay = 0;
	        	end
		    end
        end
        
		AddSP(self, -ret.Damage)
        if remainSP < ret.Damage then
        	AddHP(self, -(ret.Damage - remainSP))
        end
		
        ret.Damage = 0;
    end
end


function SCR_BUFF_AFTERCALC_HIT_Ability_buff_attribute(self, from, skill, atk, ret, buff)
    --Ability_buff_attribute (mon.attribute, skill attribute is Same? Heal : damage)
    if skill.Attribute == self.Attribute then
        Heal(self, math.floor(ret.Damage), 0);
        ret.Damage = 0;
    end
end


function SCR_BUFF_AFTERCALC_HIT_Cleric_Revival_Buff(self, from, skill, atk, ret, buff)
    
    if self.HP <= ret.Damage then
        local reviveSkillLv = GetBuffArgs(buff);
        if reviveSkillLv == 0 then
            reviveSkillLv = 1;
        end
            
        ret.Damage = self.HP - 1;
        local buffTime = reviveSkillLv * 1000;
        if IsPVPServer(self) == 1 then
             buffTime = 3000;
        end

        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        AddBuff(self, self, 'Cleric_Revival_Leave_Buff', reviveSkillLv, 0, buffTime, 1);
        EndSyncPacket(self, key);
    end
end

function SCR_BUFF_AFTERCALC_HIT_RevengedSevenfold_Buff(self, from, skill, atk, ret, buff)
    if IsSameActor(self, from) == "NO" and ret.Damage > 0 and GetRelation(self, from) == "ENEMY" and TryGetProp(skill, 'ClassType') ~= 'AbsoluteDamage' then
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local skill = GetSkill(caster, "Kabbalist_RevengedSevenfold")
            if skill ~= nil then
                local dmg = ret.Damage + (ret.Damage * (skill.Level * 0.1))
                
                ret.Damage = 1;
                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
                
                RunScript("Revenged_Sync", self, from, skill, dmg, ret, caster)
                RemoveBuff(self, buff.ClassName);
            end
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_Subzero_Buff(self, from, skill, atk, ret, buff)
    local dmg = ret.Damage / 2
    local caster = GetBuffCaster(buff);
    local sklLv = GetBuffArg(buff)
    local FreezeRating = 10 + sklLv * 5
    local abilCryomancer9 = GetAbility(caster, "Cryomancer9");
    if abilCryomancer9 ~= nil and TryGetProp(abilCryomancer9, "ActiveState") == 1 then
        FreezeRating = math.floor(FreezeRating * (1 + abilCryomancer9.Level * 0.05));
    end
    
    local random = IMCRandom(1, 100)
    if skill.ClassType == "Melee" and 
        skill.ClassName ~= 'Hoplite_ThrouwingSpear' and skill.ClassName ~= 'Peltasta_ShieldLob' and
        skill.ClassName ~= 'Shinobi_Kunai' and skill.ClassName ~= 'Dragoon_Gae_Bulg' and skill.ClassName ~= 'Monk_EnergyBlast' and
        skill.ClassName ~= 'Monk_God_Finger_Flicking' and
        FreezeRating >= random and ret.Damage > 0 then
        ret.Damage = dmg
        ret.KDPower = 0;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
    
        local addDamage = 0;
        local Cryomancer10_abil = GetAbility(caster, "Cryomancer10")
        if Cryomancer10_abil ~= nil then
            local shield = GetEquipItem(self, 'LH')
            if shield ~= nil and shield.ClassType == "Shield" then
            addDamage = shield.DEF * Cryomancer10_abil.Level * 0.5
        end
    end
    
    RunScript("SubzeroShield_sync", self, from, skill, dmg + addDamage, ret, caster)
else
 ret.Damage = ret.Damage
 ret.KDPower = 0;
 ret.HitType = HIT_BASIC;
 ret.HitDelay = 0;
 SetExProp(from, "CHECK_SKL_KD_PROP", 1);
end
end

function SCR_BUFF_AFTERCALC_ATK_Invocation_Debuff(self, from, skill, atk, ret, buff)
    if GetHandle(from) == GetExProp(self, 'CASTER_HANDLE') then 
        return;
    end
    
    if skill.ClassName ~= "Warlock_Invocation" then
        local checkDamage = ret.Damage;
        if IS_PC(self)~= true and self.HPCount > 0 then
            checkDamage = 1;
        end
        if IsDead(self) == 1 or checkDamage >= self.HP then
            SUMMON_INVOCATION_MONSTER(from, self, skill.Level);
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_Ability_buff_SolidStrong(self, from, skill, atk, ret, buff)
    local increaseRatio = 1.5;
    local decreaseRatio = 0.5;

    if skill.ClassName == "Rogue_Backstab" then
        ret.Damage = ret.Damage * increaseRatio;
    elseif skill.ClassName == "Doppelsoeldner_Cyclone" then
        ret.Damage = ret.Damage * decreaseRatio;
    end
end

function SCR_BUFF_AFTERCALC_HIT_Foretell_Immune_Buff(self, from, skill, atk, ret, buff)
	if IsBuffApplied(self, 'Foretell_Immune_Buff') == 'YES' and IsMoving(self) == 1 then
        ret.KDPower = 0;
        ret.ResultType = HITRESULT_MISS;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 0;
	end
	
--    local sklLevel = GetBuffArg(buff)
--    if IsBuffApplied(self, 'Foretell_Immune_Buff') == 'YES' and IMCRandom(1, 100) < 40 + sklLevel * 3 then
--        ret.KDPower = 0;
--        ret.ResultType = HITRESULT_MISS;
--        ret.HitType = HIT_SAFETY;
--        ret.HitDelay = 0;
--        ret.Damage = 0;
--    end
end

function SCR_BUFF_AFTERCALC_HIT_Foretell_Magic_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Foretell_Magic_Buff') == 'YES' and skill.ClassType == 'Magic' then
        ret.KDPower = 0;
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 0;
    end
end

function SCR_BUFF_AFTERCALC_HIT_Foretell_Missile_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Foretell_Missile_Buff') == 'YES' and skill.ClassType == 'Missile' then
        ret.KDPower = 0;
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 0;
    end
end

function SCR_BUFF_AFTERCALC_HIT_Foretell_TrueDamage_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Foretell_TrueDamage_Buff') == 'YES' then
        if skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
            ret.KDPower = 0;
            ret.ResultType = HITRESULT_NONE;
            ret.HitType = HIT_SAFETY;
            ret.HitDelay = 0;
            ret.Damage = 0;
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_MissileHole_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'MissileHole_Buff') == 'YES' and (skill.HitType == 'Force' or skill.ClassType == 'Missile') then
        ret.KDPower = 0;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 1;
    end
end

function SCR_BUFF_AFTERCALC_ATK_EpeeGarde_Buff(self, from, skill, atk, ret, buff)

    if IsBuffApplied(from, 'EpeeGarde_Buff') == 'YES' and ret.ResultType == HITRESULT_CRITICAL then
        local attackType = skill.AttackType
        if IS_PC(from) == true and skill.ClassID < 10000 then
            local rightHand = GetEquipItem(from, 'RH');
            attackType = rightHand.AttackType
        end
        
        if attackType == 'Aries' then
            local sklLevel = GetBuffArg(buff)
            ret.Damage = ret.Damage + math.floor(ret.Damage * 0.5);
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_Incineration_Debuff(self, from, skill, atk, ret, buff)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        return;
    end
    
    local abil = GetAbility(caster, "PlagueDoctor13")
    if abil == nil or self.HP > ret.Damage then
        return;
    end
    
    local buffList, listCnt = GetBuffListByStringProp(self, "CopyAble", "YES");
    local objList, objCount = SelectObjectNear(from, self, 100, 'ENEMY');
    
    local targetList = {};

    for i = 1, objCount do
        local obj = objList[i];
        if 'NO' == IsSameActor(obj, self) then
            targetList[#targetList + 1] = obj;
            if #targetList >= abil.Level then
                break;
            end
        end
   end
   
   PlaySound(from, 'skl_eff_debuff_20')
   for i = 1 , #targetList do
       local obj = targetList[i];
       for j = 1, listCnt do
           local buff = buffList[j];
           local arg1, arg2 = GetBuffArg(buff)
           local buffTime = GetBuffRemainTime(buff)
          local buff2 = AddBuff(from, obj, buff.ClassName, arg1, arg2, buffTime, 1);
       end
   end
end

function SCR_BUFF_AFTERCALC_ATK_EnchantLightning_Buff(self, from, skill, atk, ret, buff)

    local pCls = GetClass("Skill", skill.ClassName)
    skill.Attribute = pCls.Attribute;
end

function SCR_BUFF_AFTERCALC_HIT_PatronSaint(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'PatronSaint') == 'YES' then
        local buffTarget = GetExProp_Str(self, "SOUL_BUFF");
        if buffTarget ~= nil then
            if buffTarget == 'PATRON_GIVE' then
                if ret == nil or GetStructIndex(ret) > 0 then
                    return;
                end
                
                local caster = GetBuffCaster(buff);
                if caster == nil then
                    return;
                end
                
                local dmg = ret.Damage;
                ret.Damage = 0;
                ret.ResultType = HITRESULT_NONE;
                ret.HitType = HIT_NOHIT;
                ret.EffectType = HITEFT_NO;
                ret.HitDelay = 0;
                
                local key = GetSkillSyncKey(self, ret);
                StartSyncPacket(self, key);
                
                local abil = GetExProp(self, "SOUL_BUFF_ABIL");
                
                if abil ~= nil then
                    dmg = math.floor(dmg - (dmg * (abil * 0.05)));
                end
                
                TakeDamage(from, caster, skill.ClassName, dmg);
                EndSyncPacket(self, key);
                
                local remain = GetExProp(self, "SOUL_BUFF_COUNT");
                SetExProp(self, "SOUL_BUFF_COUNT", remain - 1);
                
                if remain - 1 <= 0 then
                    RemoveBuff(self, buff.ClassName)
                end
            end
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_Barrier_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Barrier_Buff') == 'YES' then
        if ret.Damage <= 0 then
            return 1;
        end
        
        local dmg = ret.Damage;
        local caster = GetBuffCaster(buff);
        if caster == nil then
            return 1;
        end
        
        local Paladin9_abil = GetAbility(caster, 'Paladin9');
        if Paladin9_abil ~= nil then
            local HitType = TryGetProp(skill, "HitType")
            local ClassType = TryGetProp(skill, "ClassType")
            if HitType == 'Force' or ClassType == 'Missile' then
                dmg = dmg - (dmg * (Paladin9_abil.Level * 0.1))
                
                if dmg < 0 then
                    dmg = 0;
                end
                ret.Damage = math.floor(dmg);
            end
        end
        
        local Paladin20_abil = GetAbility(caster, 'Paladin20');
        local Paladin20_ActiveState = TryGetProp(Paladin20_abil, "ActiveState")
        local damage = GET_SKL_DAMAGE(from, caster, skill.ClassName);
        if Paladin20_abil ~= nil and Paladin20_ActiveState == 1 and IsBuffApplied(caster, 'Barrier_Buff') == 'YES' then
            local partyMemberList, partyMemberCnt = GetPartyMemberList(caster, PARTY_NORMAL, range)
            for i = 1, (partyMemberCnt - 1) do
                if partyMemberList[i] ~= nil and  IsSameActor(caster, self) == "NO" and IsDead(caster) == 0 then
                    ret.Damage = 0;
                    ret.ResultType = HITRESULT_NONE;
                    ret.HitType = HIT_NOHIT;
                    ret.EffectType = HITEFT_NO;
                    ret.HitDelay = 0;
                    
                    TakeDamage(from, caster, skill.ClassName, damage);
                end
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_AFTERCALC_ATK_ScudInstinct_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'ScudInstinct_Buff') == 'YES' then
        local over = GetBuffOver(from, 'ScudInstinct_Buff')
        if over >= 1 then
            local skill_list = {
                                'Barbarian_Embowel',
                                'Barbarian_StompingKick',
                                'Barbarian_Cleave',
                                'Barbarian_HelmChopper',
                                'Barbarian_Seism',
                                'Barbarian_GiantSwing',
                                'Barbarian_Pouncing'
                                }
            for i = 1, #skill_list do
                if skill.ClassName == skill_list[i] then
                    if skill.ClassName == 'Barbarian_GiantSwing' then
                        ret.Damage = ret.Damage + math.floor(ret.Damage * 0.12 * over);
                    else
                    ret.Damage = ret.Damage + math.floor(ret.Damage * 0.06 * over);
                    end
                    
                    AddBuff(from, from, 'ScudInstinct_Buff', 1, 0, 0, 0)
                    return 1;
                end
            end
        else
            return 0;
        end
    else
        return 0;
    end
    return 1;
end



function SCR_BUFF_AFTERCALC_HIT_Virus_Debuff(self, from, skill, atk, ret, buff)
    if skill.ClassName == "Wugushi_WugongGu" or skill.ClassName == "Default" then
        return;
    end
    
    if IsBuffApplied(self, 'Virus_Debuff') == 'YES' then
        local virusMaxCount = GetExProp(buff, 'VIRUS_MAX_COUNT');
        local virusSpreadCount = GetExProp(buff, 'VIRUS_SPREAD_COUNT');
        
        if virusSpreadCount >= virusMaxCount then
            return;
        end
        
        local spreadRange = 50;
        local buffCaster = GetBuffCaster(buff);
        
        local list, cnt = SelectObjectNear(buffCaster, self, spreadRange, 'ENEMY');
        for i = 1, cnt do
            local obj = list[i];
            if obj ~= nil then
                if IsSameActor(self, obj) == "NO" then
                    local virus_list = { };
                    local buff_list = GetBuffList(obj)
                    if #buff_list >= 1 then
                        for j = 1, #buff_list do
                            if buff_list[j].ClassName == 'Virus_Debuff' or buff_list[j].ClassName == 'Virus_Spread_Debuff' then
                                virus_list[#virus_list + 1] = buff_list[j];
                            end
                        end
                    end
                    
                    if #virus_list >= 1 then
                        for k = 1, #virus_list do
                            local virusCaster = GetBuffCaster(virus_list[k]);
                            if IsSameActor(buffCaster, virusCaster) == "YES" then
                                return;
                            end
                        end
                    end
                    
                    local buffTime = 10000;
                    local abil = GetAbility(buffCaster, 'Wugushi4')
                    if abil ~= nil then
                        buffTime = buffTime + 1000 * abil.Level;
                    end
                    
                    local key = GetSkillSyncKey(from, ret);
                    StartSyncPacket(from, key);
                    AddBuff(buffCaster, obj, 'Virus_Spread_Debuff', buff.Lv, 0, buffTime, 1);
                    EndSyncPacket(from, key, 0);
                    
                    SetExProp(buff, 'VIRUS_SPREAD_COUNT', virusSpreadCount + 1);
                    return;
                end
            end
        end
    end
end

--Boss_Reflect_attack--
function SCR_BUFF_AFTERCALC_HIT_Boss_Reflect_attack(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'ReflectShield_Buff') == 'NO' then
        local dmg = ret.Damage * 0.15;
        DamageReflect(self, from, "None", dmg, "Melee", "Melee", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW);
    end
end
--Boss_Reflect_attack--

function SCR_BUFF_AFTERCALC_HIT_Raise_Debuff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Raise_Debuff') == 'YES' then
        if ret.Damage <= 0 then
            return 1;
        end
        if skill.ClassName == 'Hunter_Snatching' or skill.ClassName == 'Cannoneer_ShootDown' or skill.ClassName == 'Musketeer_Birdfall' then
            local dmg = ret.Damage;
            dmg = dmg + (dmg * 0.5)
            if dmg < 0 then
                dmg = 0;
            end
            
            ret.Damage = math.floor(dmg);
        end
    end
    return 1;
end

function SCR_BUFF_AFTERCALC_HIT_Methadone_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    if ret.ResultType ~= HITRESULT_CRITICAL then
        ret.ResultType = HITRESULT_BLOW;
    end
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Invulnerable_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    if ret.ResultType ~= HITRESULT_CRITICAL then
        ret.ResultType = HITRESULT_BLOW;
    end
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Hallucination_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Hallucination_Buff') == 'YES' then
        local caster = GetBuffCaster(buff)
        local damage = GET_SKL_DAMAGE(from, caster, skill.ClassName)
        local dummyPC = GET_TARGETLIST_DUMMYPC_FOR_EXPROP(caster, "EXPROP_SHADOW_DUMMYPC")
        if IsSameActor(from, caster) == "NO" and IsDead(caster) == 0 then
            for i = 1 , #dummyPC do
                local dummyPClist = dummyPC[i]
                ret.Damage = 0;
                ret.ResultType = HITRESULT_NONE;
                ret.HitType = HIT_NOHIT;
                ret.EffectType = HITEFT_NO;
                ret.HitDelay = 0;
                
                TakeDamage(from, dummyPClist, skill.ClassName, damage, skill.Attribute, skill.AttackType, skill.ClassType);
                
                if IsDead(dummyPClist) == 1 then
                    RemoveBuff(self, "Hallucination_Buff")
                end
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_AFTERCALC_ATK_BlindFaith_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'BlindFaith_Buff') == 'YES' then
        local caster = GetBuffCaster(buff)
        local attackSkill = GetSkill(caster, "Zealot_BlindFaith")
        if skill.ClassName == attackSkill.ClassName then
            return
        end
        
        local blindFaithSP = GetExProp(buff, "BLINDFAITH_REMAINSP")
        
        local damage = blindFaithSP * (2 + ((attackSkill.Level - 1) * 0.2))
        
        if IsSameActor(caster, self) == "NO" then
            TakeDadak(caster, self, attackSkill.ClassName, damage, 0.25, "Holy", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_NO_HITSCP)
        end
        
        local atkCount = GetExProp(buff, "BlindFaith_Count")
        atkCount = atkCount - 1;
        
        if atkCount <= 0 then
            RemoveBuff(caster, buff.ClassName)
        end
        
        SetExProp(buff, "BlindFaith_Count", atkCount)
        local abil = GetAbility(caster, "Zealot7")
        if abil ~= nil and abil.ActiveState == 1 then
            local abilLevel = TryGetProp(abil, 'Level');
            if abilLevel == nil then
                abilLevel = 1;
            end
            AddBuff(caster, self, "BlindFaith_Debuff", abilLevel, 0, 10000, 1)
        end
    end
end

function SCR_BUFF_AFTERCALC_ATK_SnipersSerenity_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'SnipersSerenity_Buff') == 'YES' then
        local chargingRate = GetExProp(buff, "SNIPERS_CHARGE")
        local attackType = GET_SKILL_ATTACKTYPE(skill)
        if chargingRate == 1 and ret.ResultType == HITRESULT_CRITICAL and attackType == "Gun" then
            ret.Damage = ret.Damage + math.floor(ret.Damage * 0.5);
        end
        
        local abil = GetAbility(from, 'Musketeer23')
        if abil ~= nil and abil.ActiveState == 1 and attackType == 'Gun' then
            AddBuff(from, self, 'UC_armorbreak', 1, 0, 3000, 1)
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_BlindFaith_Debuff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'BlindFaith_Debuff') == 'YES' then
        if ret.ResultType == HITRESULT_CRITICAL then
            local abilLevel = GetBuffArg(buff);
            if abilLevel == nil then
                abilLevel = 1;
            end
            
            local addCrtDmgRate = abilLevel * 0.1;
            
            ret.Damage = ret.Damage + math.floor(ret.Damage * addCrtDmgRate);
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_Skill_NoDamage_Buff(self, from, skill, atk, ret, buff)
    if ret.Damage > 0 then
        if IsBuffApplied(self, 'Skill_NoDamage_Buff') == 'YES' then
            local buffLv, buffRate = GetBuffArg(buff);
            if buffRate >= 10000 or buffRate >= IMCRandom(1, 10000) then
                ret.HitType = HIT_NOHIT;
                ret.Damage = 0;
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_AFTERCALC_HIT_DaggerGuard_Buff(self, from, skill, atk, ret, buff)
    if ret.Damage > 0 then
        local buffRate = 50;
        local abilRetiarii3 = GetAbility(self, "Retiarii3");
        if abilRetiarii3 ~= nil and TryGetProp(abilRetiarii3, "ActiveState") == 1 then
            buffRate = buffRate + TryGetProp(abilRetiarii3, "Level");
        end
        
        local attackType = TryGetProp(skill, "AttackType");
        if IS_PC(from) == true and skill.ClassID < 10000 then
            if TryGetProp(skill, "UseSubweaponDamage") == "NO" then
                local rightHand = GetEquipItem(from, 'RH');
                attackType = rightHand.AttackType
            else
                local leftHand = GetEquipItem(from, 'LH');
                attackType = leftHand.AttackType
            end
        end
        
        local attackTypeList = {"Aries", "Slash", "Strike"};
        local attackTypeCheck = false;
        
        for i = 1, #attackTypeList do
            if attackTypeList[i] == attackType then
                attackTypeCheck = true;
            end
        end
        
        local abilRetiarii4 = GetAbility(self, "Retiarii3");
        if abilRetiarii4 ~= nil and TryGetProp(abilRetiarii4, "ActiveState") == 1 then
            if TryGetProp(skill, "ClassType") == "Missile" then
                attackTypeCheck = true
                buffRate = buffRate * 0.5
            end
        end
        
        if IsBuffApplied(self, "DaggerGuard_Buff") == "YES" then 
            if attackTypeCheck == true then
                if buffRate >= IMCRandom(1, 100) then
                    ret.Damage = 0;
                    ret.HitType = HIT_BLOCK;
                    ret.ResultType = HITRESULT_BLOCK;
                    local remain = GetExProp(self, "DAGGERGUARD_COUNT");
                    SetExProp(self, "DAGGERGUARD_COUNT", remain - 1);
                    if remain - 1 <= 0 then
                        RemoveBuff(self, buff.ClassName)
                    end
                end
            end
        end
    end
end

function SCR_BUFF_AFTERCALC_HIT_INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS(self, from, skill, atk, ret, buff)
    if IsSameActor(from, self) == 'NO' then
        ret.Damage = 0;
    end
end

function SCR_BUFF_AFTERCALC_HIT_VitalProtection_Buff(self, from, skill, atk, ret, buff)
    if self.HP < ret.Damage then
        SetExProp(buff, "VITALPROTECTION_ADDHP", self.HP);
    end
end

function SCR_BUFF_AFTERCALC_HIT_Mergaite_Enter_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_SAFETY;
    ret.HitDelay = 0;
    ret.Damage = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Marschierendeslied_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    if ret.ResultType ~= HITRESULT_CRITICAL then
        ret.ResultType = HITRESULT_BLOW;
    end
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_AFTERCALC_HIT_Friedenslied_Buff(self, from, skill, atk, ret, buff)
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		local abilPiedPiper10 = GetAbility(caster, "PiedPiper10")
		if abilPiedPiper10 ~= nil and TryGetProp(abilPiedPiper10, "ActiveState") == 1 then
			ret.Damage = 0;
			ret.ResultType = HITRESULT_NONE;
			ret.HitType = HIT_NOHIT;
			ret.EffectType = HITEFT_NO;
			ret.HitDelay = 0;
		end
    end
end

function SCR_BUFF_AFTERCALC_ATK_CriticalShot_Buff(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'CriticalShot_Buff') == 'YES' and ret.ResultType == HITRESULT_CRITICAL then
        local buffOver = GetBuffOver(from, buff.ClassName);
        local addDamageRate = buffOver * 0.1;
        ret.Damage = ret.Damage + math.floor(ret.Damage * addDamageRate);
    end
end