--skill_buff_takedamage.lua
-- pc->GetBuffList()->OnEvent(BET_TAKE_DAMAGE, skill ? skill->GetClassID() : 0, hpDamage, from);
-- pc->GetBuffList()->OnEvent(BET_TAKE_DAMAGE, skill ? skill->GetClassID() : 0, hpDamage);
-- return 0 is removebuff. (self is defender)

-- buff_monster

function SCR_BUFF_TAKEDMG_UC_bound(self, buff, sklID, damage, attacker)
	return 0;
end

function SCR_BUFF_TAKEDMG_UC_sleep(self, buff, sklID, damage, attacker)
    local count = GetExProp(buff, "UC_sleep_COUNT")
    
    count = count - 1;
    if count <= 0 then
	return 0;
end

    SetExProp(buff, "UC_sleep_COUNT", count);
    return 1;
end

function SCR_BUFF_TAKEDMG_UC_petrify(self, buff, sklID, damage, attacker)
	if IMCRandom(1,10000) > 9000 then
        return 0;
    else
        return 1;
    end
end

--Ability_buff_Antimage
function SCR_BUFF_TAKEDMG_Ability_buff_Antimage(self, buff, sklID, damage, attacker)
    local skill = GetClassByType("Skill", sklID);
    if skill ~= nil then
        if skill.ClassType == 'Magic' then
            local healHP = self.MHP * 0.1
	        Heal(self, math.floor(healHP) , 0);
        end
    end
    return 1;
end
--

--Ability_buff_Antiwarrior
function SCR_BUFF_TAKEDMG_Ability_buff_Antiwarrior(self, buff, sklID, damage, attacker)
    local skill = GetClassByType("Skill", sklID);
    if skill ~= nil then
        if skill.ClassType == 'Melee' or skill.ClassType == 'Missile' then
            local healHP = self.MHP * 0.1
	        Heal(self, math.floor(healHP) , 0);
        end
    end
    return 1;
end
--

function SCR_BUFF_TAKEDMG_UC_deprotect(self, buff, sklID, damage, attacker)
	if IsBuffApplied(self, 'UC_armorbreak') == 'YES' then
        return 0;
    else
        return 1;
    end
end



-- buff_hardskill
function SCR_BUFF_TAKEDMG_sorcerer_bat(self, buff, sklID, damage, attacker)
	
	if IsDead(attacker) == 0 then
		ATTACK_SORCERER_BAT(self, buff, attacker)
	end

	return 1;
end



-- buff_contents
function SCR_BUFF_TAKEDMG_CHAPLE576_MQ_08(self, buff, sklID, damage, attacker)
	if GetHpPercent(self) < 0.5 then
	    if IMCRandomFloat(1, 2) > 1 then
	        SetOwner(self, attacker, 1)
	        SetCurrentFaction(self, GetCurrentFaction(attacker));
	        AddBuff(self, self, 'COMMON_BUFF_DEAD', 1, 0, 15000, 1)
	        RemoveBuff(self, 'CHAPLE576_MQ_08')
	        RunSimpleAIOnly(self, 'CHAPLE576_MQ_08')
	        if attacker.ClassName == 'PC' then
                local result = SCR_QUEST_CHECK(attacker, 'CHAPLE576_MQ_08')
                if result == 'PROGRESS' then
                    SCR_PARTY_QUESTPROP_ADD(attacker, 'SSN_CHAPLE576_MQ_08', 'QuestInfoValue1', 1)
                end
            end
	    end
	end

	return 1;
end




-- buff
function SCR_BUFF_TAKEDMG_Rest(self, buff, sklID, damage, attacker)
	return 0;
end

function SCR_BUFF_TAKEDMG_SitRest(self, buff, sklID, damage, attacker)
	return 0;
end

function SCR_BUFF_TAKEDMG_UnlockChest_Buff(self, buff, sklID, damage, attacker)
	return 0;
end

function SCR_BUFF_TAKEDMG_GuardImpact(self, buff, sklID, damage, attacker)
	return 0;
end

function SCR_BUFF_TAKEDMG_SelfHeal(self, buff, sklID, damage, attacker)
	local damBuff = GetExProp_Str(buff, "BUFFWHENDAMAGE");
	if damBuff ~= "None" then
		local time = GetExProp(buff, "DAMBUFFTIME");
		AddBuff(self, self, damBuff, 1, 0, time, 1);
		SetExProp_Str(buff, "BUFFWHENDAMAGE", "None");
	end

	return 0;
end

function SCR_BUFF_TAKEDMG_Cloaking_Buff(self, buff, sklID, damage, attacker)

	if damage > 0 then
		return 0;
	end

	return 1;
end

function SCR_BUFF_TAKEDMG_ShinobiCloaking_Buff(self, buff, sklID, damage, attacker)

	if damage > 0 then
		return 0;
	end

	return 1;
end


function SCR_BUFF_TAKEDMG_Sleep_Debuff(self, buff, sklID, damage, attacker)
	 local count = GetExProp(self, "TAKEDMG_COUNT")
    if count < 1 then
	    return 0;
	end
	
	SetExProp(self, "TAKEDMG_COUNT", count-1)
	return 1;
end

function SCR_BUFF_TAKEDMG_Conversion_Debuff(self, buff, sklID, damage, attacker)
	if IS_PC(self) == true or self.MonRank ~= 'Normal' then
        return 1;
    end
    
	if GetZoneName(self) == "mission_groundtower_1" then
		return 1;
	end
    
	local caster = GetBuffCaster(buff);
	if IsSameObject(caster, attacker) == 1 then
		local mhp = self.MHP
		rate = (damage/mhp) * 100;
        
		local casterLv = caster.Lv
		local selfLv = self.Lv
		local sublv = casterLv - selfLv;
		local penalty = 0
		
		if sublv < 0 then
			penalty = sublv * 0.1
		end
        
		rate = rate - (rate * penalty);
        
        local bufflv, arg2 = GetBuffArg(buff);
        if bufflv > 1 then
            for i = 2, bufflv do
                rate = rate + (rate * 0.1)
            end
        end
        if IMCRandomFloat(0, 100) < rate and self.Size ~= "XL" then
            if self.HP > 0 then
                local list, cnt = GetConversionList(caster);
                local skill = GetSkill(caster, "Paladin_Conversion")
                if skill ~= nil then
                    
                    if bufflv <= cnt then
                        return 1;
                    end
                    
                    SetOwner(self, caster, 1);
                    RunSimpleAI(self, 'follow_mon');
                    self.BTree = 'None';
                    SetHookMsgOwner(self, caster)
                    SetCurrentFaction(self, GetCurrentFaction(caster));
                    AddBuff(caster, self, "Conversion_Buff", 1, 0, 600000)
                    AddConversionList(caster, self);
                    RemoveHate(self, caster);
                    SkillCancel(self);
                    
                    local abil = GetAbility(caster, 'Paladin6');
                    if abil ~= nil then
                        local pcSTR = caster.STR
                        self.PATK_BM = self.PATK_BM + (pcSTR * 0.5)
                    end
                end
			end
		end
	end
	return 1;
end


function SCR_BUFF_TAKEDMG_Burrow(self, buff, sklID, damage, attacker)
	HOLD_MON_SCP(self, 4000);
	return 0;
end

--function SCR_BUFF_TAKEDMG_DeedsOfValor(self, buff, sklID, damage, attacker)
--
--    local level = GetExProp(buff, 'SKL_LV')
--    local remainTime = GetBuffRemainTime(buff);
--	local ratioFuncName = 'SCR_GET_DeedsOfValor_Ratio2';
--	local valor = GetSkill(self, 'Doppelsoeldner_DeedsOfValor')
--	local over = 1;
--
--	if IsFunc(ratioFuncName) == 1 and nil ~= valor then
--		local func = _G[ratioFuncName];
--		local MaxOver = func(valor, self);
--		if 1 ~= IsOverBuff(self, 'DeedsOfValor', MaxOver) then
--			AddBuff(self, self, 'DeedsOfValor', level, 0, remainTime, 1)
--		end
--	end
--
--	return 1;
--end


function SCR_BUFF_TAKEDMG_item_set_016pre_buff(self, buff, sklID, damage, attacker)

	local skill = GetClassByType("Skill", sklID);
	if skill ~= nil then
		if IS_PC(self) == true and skill.Attribute == 'Dark' then
    		local result = IMCRandom(1, 100);
    		if result == 1 then
    			AddBuff(self, self, 'item_set_016_buff', 1, 0, 5000, 1);
    		end
		end
	end
	return 1;
end


function SCR_BUFF_TAKEDMG_item_set_038pre_buff(self, buff, sklID, damage, attacker)

	local skill = GetClassByType("Skill", sklID);
	if skill ~= nil then
		if IS_PC(self) == true and attacker.RaceType == 'Velnias' then
    		local result = IMCRandom(1, 100);
    		if result <= 5 then
                if IsBuffApplied(self, "item_set_038_buff") == "NO" then
--                    local healHp = self.MHP * 0.1;
--                    Heal(self, healHp, 0);
                    AddBuff(self, self, 'item_set_038_buff');
                end
    		end
		end
	end
	return 1;
end

function SCR_BUFF_TAKEDMG_item_set_013pre_buff(self, buff, sklID, damage, attacker)

	if IsBuffApplied(self, 'item_set_013pre_buff') == 'YES' then
	
		local skill = GetClassByType("Skill", sklID);
		if skill ~= nil then
    		if IS_PC(self) == true and skill.Attribute == 'Earth' then
				AddBuff(self, self, 'item_set_013_buff', 1, 0, 10000, 1);
			end
		end
	end

	return 1;
end

function SCR_BUFF_TAKEDMG_ReflectShield_Buff(self, buff, sklID, damage, attacker)
	if damage <= 0 then
		return 1;
	end
    
    local spendSP = GetExProp(self, "REFLECTSHIELD_SPENDSP")
    local currentSP = GetExProp(self, "REFLECTSHIELD_CURRENTSP")
    if currentSP <= spendSP then
        return 1;
    end
    
	if IsBuffApplied(self, 'ReflectShield_Buff') == 'YES' and IsSameActor(self, attacker) == "NO" then
		local shieldLv = GetBuffArg(buff);
        local count = shieldLv

		local attackedCount = tonumber( GetExProp(buff, "ATTACKED_COUNT") );
		SetExProp(buff, "ATTACKED_COUNT", attackedCount + 1);
        
        AddSP(self, -spendSP)
		if count <= attackedCount + 1 then
			return 0;
		end
	end

	return 1;
end

function SCR_BUFF_TAKEDMG_MissileHole_Buff(self, buff, sklID, damage, attacker)

    if damage < 0 then
        return 1;
    end
    
    local skill = GetClassByType("Skill", sklID);
    if IsBuffApplied(self, 'MissileHole_Buff') == 'YES' and (skill.HitType == 'Force' or skill.ClassType == 'Missile') then
        local skillLv = GetBuffArg(buff);
        local count = 4 + (skillLv - 1) * 3;
        
        local attackedCount = tonumber( GetExProp(buff, "MISSILEHOLE_ATTACKED_COUNT") );
        
        if IS_PC(attacker) == true then
            SetExProp(buff, "MISSILEHOLE_ATTACKED_COUNT", attackedCount + 3);
        else
            SetExProp(buff, "MISSILEHOLE_ATTACKED_COUNT", attackedCount + 1);
        end
        
        if count <= attackedCount + 1 then
            return 0;
        end
    end

	return 1;
end

function SCR_BUFF_TAKEDMG_HereticsFork_Debuff(self, buff, sklID, damage, attacker)
    local skill = GetClassByType("Skill", sklID);
    
    if skill.ClassName ~= "Inquisitor_HereticsFork" then
        local damage = GetExProp(buff, "HERETICSFORK_DAMAGE")
        
        local addDamage = damage * 0.1
        
        SetExProp(buff, "HERETICSFORK_DAMAGE", damage + addDamage);
    end
    
    return 1;
end

function SCR_BUFF_TAKEDMG_IronBoots_Debuff(self, buff, sklID, damage, attacker)
    
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    
    mspdadd = mspdadd + mspdadd * 0.01
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
	return 1;
end

function SCR_BUFF_TAKEDMG_PearofAnguish_Debuff(self, buff, sklID, damage, attacker)
    local remainTime = GetBuffRemainTime(buff);
    SetBuffRemainTime(self, buff.ClassName, remainTime - 300);
	return 1;
end

function SCR_BUFF_TAKEDMG_Savior_Buff(self, buff, sklID, damage, attacker, ret)
	return UPDATE_SHIELD_BUFF_DAMAGE(self, buff, sklID, damage, attacker, ret)
end

--function SCR_BUFF_TAKEDMG_Foretell_Buff(self, buff, sklID, damage, attacker, ret)
--  if IsBuffApplied(self, 'Foretell_Buff') == 'YES' and IsMoving(self) == 1 then
--      ret.HitType = HIT_SAFETY;
--      ret.Damage = 0;
--  end
--end

function SCR_BUFF_TAKEDMG_TSW03_111_Buff(self, buff, sklID, damage, attacker, ret)
	return UPDATE_SHIELD_BUFF_DAMAGE(self, buff, sklID, damage, attacker, ret)
end

function SCR_BUFF_TAKEDMG_Mon_Shield(self, buff, sklID, damage, attacker, ret)
	return UPDATE_SHIELD_BUFF_DAMAGE(self, buff, sklID, damage, attacker, ret)
end

function SCR_BUFF_TAKEDMG_Exchange(self, buff, sklID, damage, attacker, ret)
	return UPDATE_SHIELD_BUFF_DAMAGE(self, buff, sklID, damage, attacker, ret)
end

function SCR_BUFF_TAKEDMG_spector_shield(self, buff, sklID, damage, attacker, ret)
	return UPDATE_SHIELD_BUFF_DAMAGE(self, buff, sklID, damage, attacker, ret)
end

function SCR_BUFF_TAKEDMG_JincanGu_Debuff(self, buff, sklID, damage, target, ret)
    local sklCls = GetClassByType("Skill", sklID);
    local caster = GetBuffCaster(buff);
    if sklCls ~= nil and sklCls.ClassName ~= "Wugushi_JincanGu" then
        local skl = GetSkill(caster, "Wugushi_JincanGu");
        if skl ~= nil then
            if IMCRandom(1, 100) <= 10 then
                local count = GetExProp(buff, "Wugushi_JincanGu_COUNT");
                if count < skl.Level then
                    SetExProp(buff, "Wugushi_JincanGu_COUNT", count + 1)
                    RunScript("SCR_WUGUSHI_JINCANGU", self, sklID, damage, caster, nil, nil, nil);
                end
            end
        end
    end

	return 1;
end

function SCR_BUFF_TAKEDMG_Tase_Debuff(self, buff, sklID, damage, attacker, ret)
    if damage <= 0 then
        return 1;
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    
    local taseSkill = GetSkill(caster, 'Bulletmarker_Tase');
    if taseSkill == nil then
        return 0;
    end
    
    local attackerSkill = GetClassByType("Skill", sklID);
    
    if 'Bulletmarker_Tase' == TryGetProp(attackerSkill, 'ClassName') then
        return 1;
    end
    
    local atk = GET_SKL_DAMAGE(caster, self, 'Bulletmarker_Tase');
    
    TakeDadak(caster, self, 'Bulletmarker_Tase', atk, 0.15 , taseSkill.Attribute, taseSkill.AttackType, taseSkill.ClassType, HIT_LIGHTNING, HITRESULT_NO_HITSCP);
    
    local atkCount = GetExProp(buff, "TaseAttackCount")
    atkCount = atkCount - 1;
    if atkCount <= 0 then
        return 0;
    end
    
    SetExProp(buff, "TaseAttackCount", atkCount)
    
    return 1;
end
function SCR_BUFF_TAKEDMG_SnipersSerenity_Buff(self, buff, sklID, damage, attacker, ret)
    if damage <= 0 then
        return 1;
    end
    
    local remainTime = GetBuffRemainTime(buff)
    SetBuffRemainTime(self, "SnipersSerenity_Buff", remainTime - 1000)
    
    return 1;
end

-- DeathVerdict_Buff
function SCR_BUFF_TAKEDMG_DeathVerdict_Buff(self, buff, sklID, damage, attacker, ret)
    if damage > 0 then
        local cumulativeDamage = GetBuffArgs(buff);
        cumulativeDamage = cumulativeDamage + damage;
        SetBuffArgs(buff, cumulativeDamage, 0, 0);
    end
    return 1;
end

function SCR_BUFF_TAKEDMG_Enervation_Debuff(self, buff, sklID, damage, attacker, ret)
    if damage <= 0 then
        return 1;
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    
    local buffSkillName = 'Featherfoot_Enervation';
    
    local buffSkill = GetSkill(caster, buffSkillName);
    if buffSkill == nil then
        return 0;
    end
    
    local attackerSkill = GetClassByType("Skill", sklID);
    
    if attackerSkill.ClassName == buffSkillName then
        return 1;
    end
    
    local atk = GET_SKL_DAMAGE(caster, self, buffSkillName);
    local atkCount = GetExProp(buff, "EnervationAttackCount")
    
        TakeDamage(caster, self, buffSkillName, atk, buffSkill.Attribute, buffSkill.AttackType, buffSkill.ClassType, HIT_LIGHTNING, HITRESULT_NO_HITSCP);
        atkCount = atkCount - 1;
        if atkCount <= 0 then
            return 0;
        end
    
        SetExProp(buff, "EnervationAttackCount", atkCount)
    
    return 1;
end



function SCR_BUFF_TAKEDMG_Muleta_Cast_Buff(self, buff, sklID, damage, attacker, ret)
	if damage > 0 then
		if IsBuffApplied(self, 'Muleta_Cast_Buff') == 'YES' then
			local canCounter = 0;
			
			local abilMatador8 = GetAbility(self, 'Matador8');
			if abilMatador8 ~= nil and abilMatador8.ActiveState == 1 then
				canCounter = 1;
			else
				local attackerSkill = GetClassByType("Skill", sklID);
				
				local classType = TryGetProp(attackerSkill, 'ClassType');
				local attackType = TryGetProp(attackerSkill, 'AttackType');
				
				if classType == 'Melee' and (attackType == 'None' or attackType == 'Slash' or attackType == 'Aries' or attackType == 'Strike') then
					canCounter = 1;
				end
			end
			
			if canCounter == 1 then
				ret.HitType = HIT_REFLECT;
				ret.Damage = 0;
				
				return 0;
			end
		end
	end
	
	return 1;
end
