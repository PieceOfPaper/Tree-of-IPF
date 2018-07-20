-- skill_ratetable.lua
-- FINAL_DAMAGECALC() -> SCR_SKILL_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable);

function SCR_SKILL_RATETABLE_Ranger_SpiralArrow(self, from, skill, atk, ret, rateTable)

    local hitCount = 6
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 5;
    SetMultipleHitCount(ret, hitCount);
end

function SCR_SKILL_RATETABLE_Hoplite_Pierce(self, from, skill, atk, ret, rateTable)
    local hitCount = 0;
    if IsBuffApplied(from, 'Savagery_Buff') == 'YES' then
        hitCount = 1;
    end
    
	if GetBuffByProp(self, 'Keyword', 'Shock') then
		local abil_Hoplite29 = GetAbility(from, "Hoplite29")
		if abil_Hoplite29 ~= nil and abil_Hoplite29.ActiveState == 1 then
			hitCount = hitCount + 2
		end
	end
	
    if self.Size == 'S' then
        hitCount = hitCount + 1;
    elseif self.Size == 'M' then
        hitCount = hitCount + 2;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
    else
        hitCount = hitCount + 3;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2;
		
        if self.Size ~= 'L' then
            -- XL
            if GetAbility(from, 'Hoplite2') ~= nil then
                hitCount = hitCount + 1;
                rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 3;
            end
        end
    end
    
    if hitCount > 0 then
        SetMultipleHitCount(ret, hitCount);
    end
	
    local abil = GetAbility(from, 'Hoplite3');
    if abil ~= nil then
        if IMCRandom(1, 100) < abil.Level * 2 then
            AddBuff(from, self, 'CriticalWound', 1, 0, 6000, 1);
        end
    end
end



function SCR_SKILL_RATETABLE_Fletcher_BarbedArrow(self, from, skill, atk, ret, rateTable)
    local hitCount = 0;
    if self.ArmorMaterial == 'Cloth' then
        hitCount = 3       
        rateTable.DamageRate = (hitCount * rateTable.MultipleHitDamageRate) + 2;        
    elseif self.ArmorMaterial == 'Leather' then
        hitCount = 2
        rateTable.DamageRate = (hitCount * rateTable.MultipleHitDamageRate) + 1;        
    elseif self.ArmorMaterial == 'Iron' then
        hitCount = 1        
    elseif self.ArmorMaterial == 'Ghost' then
        rateTable.IgnoreDamage = 1        
    end

    if hitCount > 0 then
        SetMultipleHitCount(ret, hitCount);
    end
end

function SCR_SKILL_RATETABLE_Wizard_EnergyBolt(self, from, skill, atk, ret, rateTable)
    local hitCount = 2;
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
    
    if IsBuffApplied(self, 'Sleep_Debuff') == 'YES' then
        local Wizard4_abil = GetAbility(from, "Wizard4")
        if Wizard4_abil ~= nil then
            rateTable.AddTrueDamage = rateTable.AddTrueDamage + math.floor(from.MINMATK * 0.4 * Wizard4_abil.Level);
        end
    end
    
    SetMultipleHitCount(ret, hitCount)
end


function SCR_SKILL_RATETABLE_Archer_TwinArrows(self, from, skill, atk, ret, rateTable)

    local hitCount = 2;
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
    SetMultipleHitCount(ret, hitCount)
    
end

function SCR_SKILL_RATETABLE_Elementalist_FreezingSphere(self, from, skill, atk, ret, rateTable)
    local hitCount = 2;
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
    SetMultipleHitCount(ret, hitCount)
end


function SCR_SKILL_RATETABLE_Barbarian_Seism(self, from, skill, atk, ret, rateTable)
    local hitCount = 3;
    local dmgRatio = 2;
    
    local buff = GetBuffByName(from, 'ScudInstinct_Buff');
    if buff ~= nil then
        local buffOver = GetOver(buff)
        if buffOver >= 5 then
            hitCount = 5;
            dmgRatio = 4;
        end
    end
    
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + dmgRatio;
    if hitCount > 0 then
        SetMultipleHitCount(ret, hitCount)
    end
end


function SCR_SKILL_RATETABLE_Cryomancer_IceBolt(self, from, skill, atk, ret, rateTable)
    local hitCount = 2;
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
    SetMultipleHitCount(ret, hitCount, 1)
end
    
function SCR_SKILL_RATETABLE_Cataphract_EarthWave(self, from, skill, atk, ret, rateTable)
    local hitCount = 5
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 4
    if hitCount > 0 then
        SetMultipleHitCount(ret, hitCount)
    end
    
    local state = GetActionState(self);
    if state == 'AS_KNOCKDOWN' or state == 'AS_DOWN' then
        rateTable.DamageRate = rateTable.DamageRate + 0.5
    end
end

function SCR_SKILL_RATETABLE_Cataphract_DoomSpike(self, from, skill, atk, ret, rateTable)
    local hitCount = 5
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 4
    if hitCount > 0 then
        SetMultipleHitCount(ret, hitCount)
    end
end

function SCR_SKILL_RATETABLE_Ranger_Barrage(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, 'Feint_Debuff') == 'YES' then
        local hitCount = 2
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;        
        SetMultipleHitCount(ret, hitCount);
    end
end

function SCR_SKILL_RATETABLE_Wizard_EarthQuake(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, 'Lethargy_Debuff') == 'YES' then
        local hitCount = 2
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
        SetMultipleHitCount(ret, hitCount);
    end
    
    if IS_PC(self) == false then
		if TryGetProp(self, 'MoveType') == 'Normal' or TryGetProp(self, 'MoveType') == 'Holding' then
			if GetBuffByProp(self, 'Keyword', 'FlyingState') == nil then
	    		rateTable.DamageRate = rateTable.DamageRate + 1;
	    	end
	    end
	elseif IS_PC(self) == true and GetBuffByProp(self, 'Keyword', 'FlyingState') == nil then
		rateTable.DamageRate = rateTable.DamageRate + 1;
	end
end


function SCR_SKILL_RATETABLE_Doppelsoeldner_Redel(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Doppelsoeldner21")
    if abil ~= nil and skill.Level >= 6 then
        local addRate = abil.Level;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + addRate;
        SetMultipleHitCount(ret, 2);
    end
end

function SCR_SKILL_RATETABLE_Doppelsoeldner_Zucken(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Doppelsoeldner20")
    if abil ~= nil and skill.Level >= 6 then
        local addRate = abil.Level
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + addRate
        SetMultipleHitCount(ret, 2);
    end
    
    if IsBuffApplied(self, 'UC_shock') == 'YES' or IsBuffApplied(self, 'Crown_Buff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.25
    end
end

function SCR_SKILL_RATETABLE_Sapper_PunjiStake(self, from, skill, atk, ret, rateTable)
    
    local ratio = 0;
    if self.Size == 'M' then
        rateTable.DamageRate = rateTable.DamageRate + 0.5;
        ratio = ratio + 50;
    elseif self.Size == 'L' then
        rateTable.DamageRate = rateTable.DamageRate + 1.0;
        ratio = ratio + 100;
    end

    if ratio > 0 then
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end
end


function SCR_SKILL_RATETABLE_Monk_HandKnife(self, from, skill, atk, ret, rateTable)
    
    if IsBuffApplied(self, 'DeprotectedZone_Debuff') == 'YES' then
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);

        local x, y, z = GetPos(self);
        local atkerAnagle = GetDirectionByAngle(from)
        local width = 25;
        local dist = 180;
        local ex, ey, ez = GetAroundPosByPos(x, y, z, atkerAnagle, dist);
        local ax, ay, az = GetAroundPosByPos(x, y, z, atkerAnagle, 35);
        local objList, objCount = SelectObjectBySquareCoor(from, "ENEMY", x, y, z, ex, ey, ez, width, 50, 0, drawArea);
        PlayEffectToGround(self, 'E_wizard_gust_shot', ax, ay, az, 1.4, 0, 0, atkerAnagle+90)
        
        local damage = SCR_LIB_ATKCALC_RH(from, skill);
        for i = 1, objCount do
            local obj = objList[i];
            TakeDamage(from, obj, "None", damage + skill.SkillAtkAdd, "Melee", "Strike", "Melee", HIT_REFLECT, HITRESULT_BLOW);

            local angle = GetAngleFromPos(obj, x, z);
      if obj.MonRank ~= 'Boss' then
            if IS_PC(obj) == false and obj.HPCount == 0 then
                    if GetPropType(obj, 'MoveType') ~= nil and obj.MoveType ~= 'Holding' then
                        KnockDown(obj, from, 300, angle, 85, 1, 1, 100)
                    end
                end
            end
        end
        EndSyncPacket(from, key, 0);
    end
end

function SCR_SKILL_RATETABLE_Sadhu_EctoplasmAttack(self, from, skill, atk, ret, rateTable)
    local job = GetClass("Job", 'Char4_6');
    if nil ~= job then
        rateTable.AddJobAtkRate = job.JobRate_ATK 
    end
    
    local owner = GetOwner(from);
    if owner ~= nil then
        if IS_PC(owner) == true then
            local buff = GetBuffByName(owner, "TransmitPrana_Debuff");
            if buff ~= nil then
                SCR_BUFF_RATETABLE_TransmitPrana_Debuff(self, owner, skill, atk, ret, rateTable, buff)
            end
        end
    end
    
    local objList, objCount = SelectObjectNear(from, self, 60, 'ENEMY');
    if objCount > 0 then
        if objCount > 2 then
            objCount = 2
        end
        for i = 1 , objCount do
            InsertHate(objList[i], from, 10);
        end
    end
end

function SCR_SKILL_RATETABLE_Swordman_PommelBeat(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, 'Stun') == 'YES' or IsBuffApplied(self, 'UC_stun') == 'YES' then
        rateTable.AddAtkDamage = rateTable.AddAtkDamage + 200;
    end
    if self.Size == "S" or self.Size == "M" then
        rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate + (0.01 + (skill.Level - 1) * 0.005);
    end
end

function SCR_SKILL_RATETABLE_Swordman_DoubleSlash(self, from, skill, atk, ret, rateTable)
    if GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        rateTable.AddAtkDamage = rateTable.AddAtkDamage + 200;
    
    end
    
    local abil = GetAbility(from, 'Swordman10');
    if abil ~= nil then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + abil.Level * 700;
    end
end

function SCR_SKILL_RATETABLE_Highlander_SkyLiner(self, from, skill, atk, ret, rateTable)
    if GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 0.7;
    end
end


function SCR_SKILL_RATETABLE_Highlander_Moulinet(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Highlander10');
    if abil ~= nil then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + abil.Level * 1200;
    end
end

function SCR_SKILL_RATETABLE_Barbarian_Cleave(self, from, skill, atk, ret, rateTable)
    if GetBuffByProp(self, 'Keyword', 'Stun') ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 1.5
    end
end

function SCR_SKILL_RATETABLE_Bokor_BwaKayiman(self, from, skill, atk, ret, rateTable)
    local totalZombieSTR = 0;
    local zombieList, listCnt = GetZombieSummonList(from);
    if listCnt >= 1 then
        for i = 1, listCnt do
            totalZombieSTR = totalZombieSTR + zombieList[i].STR;
        end
        
        rateTable.AddAtkDamage = rateTable.AddAtkDamage + math.floor((totalZombieSTR/listCnt) * 3);
    end
end

function SCR_SKILL_RATETABLE_Rogue_Backstab(self, from, skill, atk, ret, rateTable)

    rateTable.crtRatingAdd = rateTable.crtRatingAdd + (5000 + skill.Level * 200);
    rateTable.DamageRate = rateTable.DamageRate + 1
    if GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        local Rogue7_abil = GetAbility(from, 'Rogue7')
        if Rogue7_abil ~= nil then
            RemoveBuffKeyword(self, 'Debuff', 'Wound', 1, 99);
            AddBuff(from, self, 'UC_hemorrhage', Rogue7_abil.Level, from.MINPATK, 9000 + Rogue7_abil.Level * 1000, 1);
        end
    end
end


function SCR_SKILL_RATETABLE_Hoplite_SynchroThrusting(self, from, skill, atk, ret, rateTable)
    
    if IsUsingSkill(self) and GetUseSkillStartTime(self) / 1000 + 1 > imcTime.GetAppTime() then     
        rateTable.DamageRate = rateTable.DamageRate + 1;
        SkillTextEffect(nil, from, self, "SHOW_DMG_COUNTER", nil, nil);

        local abil = GetAbility(from, 'Hoplite6');
        if abil ~= nil then
            AddBuff(from, from, 'Warrior_Once_Critical_Buff', 1, 0, 10000, 1);
        end
    end
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo14');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end

function SCR_SKILL_RATETABLE_Paladin_Smite(self, from, skill, atk, ret, rateTable)
    
    if self.RaceType == 'Velnias' or self.RaceType == 'Paramune' then
        rateTable.DamageRate = rateTable.DamageRate + 1.5;
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', 200, nil, skill.ClassID);
    end
end

function SCR_SKILL_RATETABLE_Dievdirbys_Carve(self, from, skill, atk, ret, rateTable)
    if self.RaceType == 'Forester' then
        local addFactor = 25;
        rateTable.AddSkillFator = rateTable.AddSkillFator + addFactor;
--      local value = 100;
--        rateTable.AddAtkDamage = rateTable.AddAtkDamage + value;      
--      SkillTextEffect(ret, self, from, 'SHOW_SKILL_BONUS', value, nil, "skill_WoodCarve");
--      SkillTextEffect(ret, self, from, 'SHOW_SKILL_BONUS', addFactor, nil, "skill_WoodCarve");
    end
end

function SCR_SKILL_RATETABLE_Fletcher_BodkinPoint(self, from, skill, atk, ret, rateTable)
    
    local bodkin = GetSkill(from, 'Fletcher_BodkinPoint')
    local bodkinrate = 100
        if IsPVPServer(self) == 1 then
            bodkinrate = 70
        end
    if bodkinrate >= IMCRandom(1, 100) and GetBuffByProp(self, 'Group2', 'Shield') ~= nil then
        RemoveBuffGroup(self, 'Buff', 'Shield', 1, 1);
        SkillTextEffect(nil, self, from, "SHOW_BODKIN_BREAK_SHIELD", nil);
    end
end

function SCR_SKILL_RATETABLE_Barbarian_Pouncing(self, from, skill, atk, ret, rateTable)
    local addRatio = 0;
    local buff = GetBuffByName(from, 'ScudInstinct_Buff');
    if buff ~= nil then
        local buffOver = GetOver(buff);
        addRatio = buffOver * 600;
    end
    
    if GetBuffByProp(self, 'Keyword', 'Stun') ~= nil and IMCRandom(1, 10000) < skill.Level * 600 + addRatio then
        rateTable.DamageRate = rateTable.DamageRate + 2;
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', 200, nil, skill.ClassID);
    end
end

function SCR_SKILL_RATETABLE_Necromancer_FleshHoop(self, from, skill, atk, ret, rateTable)
    if GetBuffByProp(self, 'Keyword', 'Rotten') ~= nil and IMCRandom(1, 10000) < 5000 then
        rateTable.DamageRate = rateTable.DamageRate + 0.1;
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', 10, nil, skill.ClassID);
    end
end


function SCR_SKILL_RATETABLE_Peltasta_RimBlow(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo8');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
--      rateTable.DamageRate = rateTable.DamageRate + abilLevel * 0.2;
    end
        
    local abil = GetAbility(from, 'Peltasta24');
    if abil ~= nil and IsBuffApplied(from, 'HighGuard_Buff') == 'YES' and skill.Level >= 6 then
        rateTable.DamageRate = rateTable.DamageRate + 0.5 + (abil.Level * 0.1);
    end
    
    if GetBuffByProp(self, 'Keyword', 'Freeze') ~= nil or GetBuffByProp(self, 'Keyword', 'Petrify') ~= nil then
        
        rateTable.DamageRate = rateTable.DamageRate + 2;
        
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_EFFECT', 0, nil, "skill_rimblow_powerbal");
        
    end
end

function SCR_SKILL_RATETABLE_Peltasta_ShieldLob(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo8');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Peltasta_ButterFly(self, from, skill, atk, ret, rateTable)
    local addRate = 1;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo13');
        local addDamageRate = abilLevel * 0.1;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Peltasta_UmboThrust(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo8');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rodelero_ShieldCharge(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo12');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rodelero_TargeSmash(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo12');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
    if GetBuffByProp(self, 'Keyword', 'Freeze') ~= nil or GetBuffByProp(self, 'Keyword', 'Petrify') ~= nil then
        
        rateTable.DamageRate = rateTable.DamageRate + 1;
            
        local abil = GetAbility(from, 'Rodelero1')
        if abil ~= nil then
            rateTable.DamageRate = rateTable.DamageRate + abil.Level * 0.2;
        end
            
        local debuff = GetBuffByProp(self, 'Keyword', 'Solid');
        if debuff ~= nil then
            RemoveBuff(self, debuff.ClassName)
        end
        
    end
end

function SCR_SKILL_RATETABLE_Rodelero_ShieldPush(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo12');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rodelero_ShootingStar(self, from, skill, atk, ret, rateTable)
    local addRate = 1;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo13');
        local addDamageRate = abilLevel * 0.1;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rodelero_ShieldShoving(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo12');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rodelero_ShieldBash(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo12');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
    
end

function SCR_SKILL_RATETABLE_Rogue_Vendetta(self, from, skill, atk, ret, rateTable)
    
    if GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        local Rogue6_abil = GetAbility(from, 'Rogue6')
        if Rogue6_abil ~= nil then
            rateTable.DamageRate = rateTable.DamageRate + 1;
        end
    end
end

function SCR_SKILL_RATETABLE_Peltasta_UmboBlow(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        local abilLevel = GET_ABIL_LEVEL(from, 'Murmillo8');
        local addDamageRate = abilLevel * 0.15;
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end

    local abil = GetAbility(from, 'Peltasta25');
    if abil ~= nil and IsBuffApplied(from, 'HighGuard_Buff') == 'YES' and skill.Level >= 6 then
        rateTable.DamageRate = rateTable.DamageRate + 0.5 + (abil.Level * 0.1);
    end
    
    if IsBuffApplied(self, 'Guard_Debuff') == 'YES' then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1.5;
        
        local hitCount = 2
        SetMultipleHitCount(ret, hitCount);
    end
    
end

function SCR_SKILL_RATETABLE_Cannoneer_ShootDown(self, from, skill, atk, ret, rateTable)
    if IS_PC(self) == false and self.MoveType == "Flying" then
        rateTable.DamageRate = rateTable.DamageRate;
    else
        rateTable.DamageRate = rateTable.DamageRate - 0.5;
    end
    
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end
    
    local abil = GetAbility(from, "Cannoneer1")
    if abil ~= nil then
        rateTable.blkAdd = rateTable.blkAdd - abil.Level * 600;
    end
    
    local abilCannoneer18 = GetAbility(from, 'Cannoneer18');
    if abilCannoneer18 ~= nil and abilCannoneer18.ActiveState == 1 then
        if TryGetProp(self, 'MoveType') == 'Flying' then
            local hitCount = 3;
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
            SetMultipleHitCount(ret, hitCount);
        end
    end
end


function SCR_SKILL_RATETABLE_Cannoneer_CannonShot(self, from, skill, atk, ret, rateTable)
    if IS_PC(self) == false and self.MoveType == "Flying" and IsBuffApplied(self, "ShootDown_Debuff") == 'NO' then
        rateTable.DamageRate = rateTable.DamageRate - 0.5;
    else
        rateTable.DamageRate = rateTable.DamageRate;
    end
    
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end 
    
    local abil = GetAbility(from, "Cannoneer1")
    if abil ~= nil then
        rateTable.blkAdd = rateTable.blkAdd - abil.Level * 600;
    end
    
    local abilCannoneer17 = GetAbility(from, 'Cannoneer17');
    if abilCannoneer17 ~= nil and abilCannoneer17.ActiveState == 1 then
        if TryGetProp(self, 'MoveType') == 'Normal' or TryGetProp(self, 'MoveType') == 'Holding' or IS_PC(self) == true then
            local hitCount = 3;
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
            SetMultipleHitCount(ret, hitCount);
        end
    end
end

function SCR_SKILL_RATETABLE_Cannoneer_SiegeBurst(self, from, skill, atk, ret, rateTable)
    
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end 
    
    local abil = GetAbility(from, "Cannoneer1")
    if abil ~= nil then
        rateTable.blkAdd = rateTable.blkAdd - abil.Level * 600;
    end
    
    local abilCannoneer19 = GetAbility(from, 'Cannoneer19');
    if abilCannoneer19 ~= nil and abilCannoneer19.ActiveState == 1 then
        local addCriticalRate = abilCannoneer19.Level * 1000;
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + addCriticalRate;
    end
end

function SCR_SKILL_RATETABLE_Cannoneer_CannonBlast(self, from, skill, atk, ret, rateTable)
    
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end 
    
    local abil = GetAbility(from, "Cannoneer1")
    if abil ~= nil then
        rateTable.blkAdd = rateTable.blkAdd - abil.Level * 600;
    end
end

function SCR_SKILL_RATETABLE_Highlander_VerticalSlash(self, from, skill, atk, ret, rateTable)

    local debuffCnt = 0;
    local list, cnt = GetBuffList(self);
    for i=1, cnt do
        local debuff = list[i]
        if debuff.Group1 == "Debuff" then
            debuffCnt = debuffCnt + 1
        end
    end
    
    rateTable.DamageRate = rateTable.DamageRate + debuffCnt * 0.3;
end

function SCR_SKILL_RATETABLE_Dragoon_Serpentine(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Dragoon4');
    if abil ~= nil then
        if IMCRandom(1, 9999) < abil.Level * 200 then
			AddBuff(from, self, 'CriticalWound', 1, 0, 8000, 1);
        end
    end
end

function SCR_SKILL_RATETABLE_Dragoon_Dragon_Soar(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Dragoon9');
    if abil ~= nil then
        if IMCRandom(1, 9999) < abil.Level * 500 then
            AddBuff(from, self, 'UC_shock', 1, 0, 10000, 1);
        end
    end
    
    local abil = GetAbility(from, "Dragoon16")
    local DragonSoarSkill = GetSkill(from, "Dragoon_Dragon_Soar")
    if DragonSoarSkill == nil then
        return
    end
    if abil ~= nil and abil.ActiveState == 1 and DragonSoarSkill.Level >= 11 then
        local addRate = 1;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + addRate;
        SetMultipleHitCount(ret, 2);
    end
    
    local moveType = TryGetProp(self, "MoveType")
    local flyingState = GetBuffByProp(self, 'Keyword', 'FlyingState');
    if (IS_PC(self) == false and moveType == "Flying") or flyingState ~= nil then
    	rateTable.DamageRate = rateTable.DamageRate + 0.3;
    end
end

function SCR_SKILL_RATETABLE_Warlock_DarkTheurge(self, from, skill, atk, ret, rateTable)
	local skillOwner = GetSkillOwner(skill);
	if skillOwner ~= nil then
	    local abil_Warlock8 = GetAbility(skillOwner, 'Warlock8');
	    if abil_Warlock8 ~= nil and abil_Warlock8.ActiveState == 1 then
	        if IMCRandom(1, 9999) < abil_Warlock8.Level * 100 then
	            AddBuff(from, self, 'Blind', 1, 0, 10000, 1);
	        end
	    end
	    
	    local abil_Warlock16 = GetAbility(skillOwner, 'Warlock16');
	    if abil_Warlock16 ~= nil and abil_Warlock16.ActiveState == 1 then
	    	if IsBuffApplied(self, 'Fear') == 'YES' then
		        local addRate = abil_Warlock16.Level * 0.1;
		        rateTable.DamageRate = rateTable.DamageRate + addRate;
		    end
	    end
	end
end

function SCR_SKILL_RATETABLE_Kabbalist_Merkabah(self, from, skill, atk, ret, rateTable)
    local riderCount = GetExProp(skill, "RIDERCOUNT");
    rateTable.DamageRate = rateTable.DamageRate + riderCount
end

function SCR_SKILL_RATETABLE_Bokor_Hexing(self, from, skill, atk, ret, rateTable)
    rateTable.NoneDamage = 1
end


--function SCR_SKILL_RATETABLE_Pardoner_Dekatos(self, from, skill, atk, ret, rateTable)
--    local result = IMCRandom(1, 100)
--    
--    if self.ClassName == "hidden_monster2" or self.ClassName == "pcskill_icewall" or self.ClassName == "pcskill_dirtypole" then
--        return;
--    end
--
--    if result < 11 then
--        PlaySound(from, "money_jackpot")
--        GIVE_REWARD_MONEY(self, from, 100, 15, 5);
--    end
--end


function SCR_SKILL_RATETABLE_Oracle_DeathVerdict(self, from, skill, atk, ret, rateTable)
   rateTable.NoneDamage = 1
end

function SCR_SKILL_RATETABLE_Sapper_DetonateTraps(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Sapper31');
    if abil ~= nil and IS_PC(self) == false and self.MoveType == "Flying" then
        rateTable.DamageRate = rateTable.DamageRate + abil.Level * 0.5;
    end
end

function SCR_SKILL_RATETABLE_Archer_Multishot(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Mark');
    if abil ~= nil then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + abil.Level * 150;
    end
end

function SCR_SKILL_RATETABLE_Warlock_PoleofAgony(self, from, skill, atk, ret, rateTable)

end

function SCR_SKILL_RATETABLE_Paladin_Conviction(self, from, skill, atk, ret, rateTable)

    if GetBuffByProp(self, 'Keyword', 'Stun') ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 0.2;
    end

end

function SCR_SKILL_RATETABLE_Pyromancer_HellBreath(self, from, skill, atk, ret, rateTable)
    
    if skill.ClassName == "Pyromancer_HellBreath" and IMCRandom(1, 10000) < skill.Level * 100 then
        AddBuff(from, self, 'HellBreath_Debuff', 1, 0, 7000, 1);
    end
end

function SCR_SKILL_RATETABLE_Barbarian_GiantSwing(self, from, skill, atk, ret, rateTable)
    
    if skill.ClassName == "Barbarian_GiantSwing" and IMCRandom(1, 1000) < skill.Level * 150 then
        AddBuff(from, self, 'giantswing_Debuff', 1, 0, 10000, 1);
    end
end

function SCR_SKILL_RATETABLE_Rancer_HeadStrike(self, from, skill, atk, ret, rateTable)
    local addCriRatio = 3000 + skill.Level * 200
    rateTable.crtRatingAdd = rateTable.crtRatingAdd + addCriRatio;
end

function SCR_SKILL_RATETABLE_Normal_Attack_TH(self, from, skill, atk, ret, rateTable)

    local Lancer1_abil = GetAbility(from, "Lancer1")
    if nil == Lancer1_abil then
        return;
    end
    local rate = Lancer1_abil.Level * 100;
            local random = IMCRandom(1,9999);
    if skill.ClassName == "Normal_Attack_TH" and random < rate then
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);
        
        local x, y, z = GetPos(from);
        local angle = GetAngleFromPos(self, x, z);
        KnockDown(self, from, 45, angle, 10, 3, 1, 100)
        
        EndSyncPacket(from, key, 0);
    end
end

function SCR_SKILL_RATETABLE_Rancer_SpillAttack(self, from, skill, atk, ret, rateTable)
    if IS_PC(self) == false and self.RaceType == "Widling" then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.5;
    end
    
    if GetVehicleState(self) == 1 then
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);
        
        rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - 10000
        
        local list = GetSummonedPetList(self);
        for i = 1 , #list do
            local pet = list[i];
            RideVehicle(self, pet, 0);
            
            local x, y, z = GetPos(from);
            local angle = GetAngleFromPos(self, x, z);
            KnockDown(self, from, 45, angle, 10, 3, 1, 100)
        end
        
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.2;
        EndSyncPacket(from, key, 0);
    end
    
    SetMultipleHitCount(ret, 3)
end

function SCR_SKILL_RATETABLE_Rancer_Quintain(self, from, skill, atk, ret, rateTable)
    local skillOwner = GetSkillOwner(skill) 
    local abil_Lancer11 = GetAbility(skillOwner, 'Lancer11');
     
    if IsBuffApplied(self, 'Crush_Debuff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 1.5;
        if abil_Lancer11 ~= nil and 1 == abil_Lancer11.ActiveState then
            SetMultipleHitCount(ret, 3)
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2
        end
    end
end

function SCR_SKILL_RATETABLE_Hackapell_Skarphuggning(self, from, skill, atk, ret, rateTable)
    
--  local debuff = GetBuffByName(self, 'Archer_Def_Debuff');
--  if debuff ~= nil then
--      local over = GetOver(debuff)
--      rateTable.DamageRate = rateTable.DamageRate + (0.1 * over);
--      SetMultipleHitCount(ret, math.floor(1 + over * 0.7))
--  end
    if IsBuffApplied(self, "SaberAries_Debuff") == 'YES' then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2;
        SetMultipleHitCount(ret,3)
    else
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
        SetMultipleHitCount(ret,2)
    end
end

function SCR_SKILL_RATETABLE_Hackapell_StormBolt(self, from, skill, atk, ret, rateTable)
--  local debuff = GetBuffByName(self, 'Archer_Def_Debuff');
--  if debuff ~= nil then
--      local over = GetOver(debuff)
--      rateTable.DamageRate = rateTable.DamageRate + (0.05 * over);
--      SetMultipleHitCount(ret, math.floor(1 + over * 0.5))
--  end
    local multipleCount = 0 
    if IsBuffApplied(self, "SaberAries_Debuff") == 'YES' then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 4;
        multipleCount = 5;
    else
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2
        multipleCount = 3;
    end
    
    SetMultipleHitCount(ret,multipleCount)
    
    local abil = GetAbility(from, "Hackapell11")
    if abil ~= nil and abil.ActiveState == 1 then
        local buffList, buffCnt = GetBuffListByStringProp(self, "Group2", "Freeze")
        if buffCnt == nil then
            buffCnt = 0
        end
        
        if buffCnt ~= 0 or TryGetProp(self, 'Attribute') == "Ice" then
            rateTable.DamageRate = rateTable.DamageRate + 0.5;
        end
    end
end

function SCR_SKILL_RATETABLE_Mergen_TrickShot(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Mergen13")
    if abil ~= nil then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
        local hitCount = 3
        SetMultipleHitCount(ret, hitCount);
    end
end

function SCR_SKILL_RATETABLE_Mergen_QuickFire(self, from, skill, atk, ret, rateTable)
    local rand = IMCRandom(-25, 5)
    rateTable.DamageRate = rateTable.DamageRate + rand/100;
end

function SCR_SKILL_RATETABLE_Doppelsoeldner_Zwerchhau(self, from, skill, atk, ret, rateTable)
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2;
    SetMultipleHitCount(ret, 3);
end


function SCR_SKILL_RATETABLE_Doppelsoeldner_Sturzhau(self, from, skill, atk, ret, rateTable)

    local addDamage = self.DEF
    if addDamage > skill.Level * 200 then
        addDamage = skill.Level * 200;
    end
    
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 2;
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + addDamage;
    rateTable.blkAdd = rateTable.blkAdd - skill.Level * 500;
    
    SetMultipleHitCount(ret, 3);
    
end

function SCR_SKILL_RATETABLE_Featherfoot_KundelaSlash(self, from, skill, atk, ret, rateTable)

    if IsBuffApplied(self, 'Hexing_Debuff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 1
    end
    
end

function SCR_SKILL_RATETABLE_Cannoneer_CannonBarrage(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end
    
    local abilCannoneer20 = GetAbility(from, 'Cannoneer20');
    if abilCannoneer20 ~= nil and abilCannoneer20.ActiveState == 1 then
        local addDamageRate = abilCannoneer20.Level * 0.04;
        rateTable.DamageRate = rateTable.DamageRate - addDamageRate;
    end
    
    rateTable.DamageRate = rateTable.DamageRate + 0.2;
    
	local abilCannoneer1 = GetAbility(from, "Cannoneer1")
	if abilCannoneer1 ~= nil then
		rateTable.blkAdd = rateTable.blkAdd - abilCannoneer1.Level * 600;
	end
end

function SCR_SKILL_RATETABLE_Cannon_Attack(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, "SmokeGrenade_Debuff") == 'YES' then
        local addRate = 0.3
        
        local abil_10 = GetAbility(from, "Cannoneer10")
        if abil_10 ~= nil then
            addRate = addRate + abil_10.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end
    
	local abilCannoneer1 = GetAbility(from, "Cannoneer1")
	if abilCannoneer1 ~= nil then
		rateTable.blkAdd = rateTable.blkAdd - abilCannoneer1.Level * 600;
	end
end

function SCR_SKILL_RATETABLE_Cannoneer_SweepingCannon(self, from, skill, atk, ret, rateTable)
	local abilCannoneer1 = GetAbility(from, "Cannoneer1")
	if abilCannoneer1 ~= nil then
		rateTable.blkAdd = rateTable.blkAdd - abilCannoneer1.Level * 600;
	end
end

function SCR_SKILL_RATETABLE_PlagueDoctor_Incineration(self, from, skill, atk, ret, rateTable)

    if IsBuffApplied(self, "PlagueVapours_Debuff") == 'YES' and skill.ClassName == "PlagueDoctor_Incineration" then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
    end

end

function SCR_SKILL_RATETABLE_Kabbalist_Nachash(self, from, skill, atk, ret, rateTable)

    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key);
    
    local objList, objCount = SelectObjectNear(self, self, 80, 'ENEMY');
    for i = 1 , objCount do
        local obj = objList[i]
        AddBuff(from, obj, "Prophecy_Buff", 1, 0, 10000, 1);
    end
    
    EndSyncPacket(from, key);

end

function SCR_SKILL_RATETABLE_Hackapell_LegShot(self, from, skill, atk, ret, rateTable)

    local hitCount = 2;
    --rateTable.DamageRate = rateTable.DamageRate + 1
    SetMultipleHitCount(ret, hitCount)
    
end

function SCR_SKILL_RATETABLE_Murmillo_Takedown(self, from, skill, atk, ret, rateTable)

    rateTable.blkAdd = rateTable.blkAdd - 10000;
    rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - 10000

end

function SCR_SKILL_RATETABLE_Murmillo_Headbutt(self, from, skill, atk, ret, rateTable)
    RunScript('SCR_FEINT_ABIL', self, from)
    
    local stun = GetBuffByProp(self, 'Keyword', 'Stun')
    if stun ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 1
    end
    
    if IsBuffApplied(from, 'murmillo_helmet') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 1
    else
        RunScript('SCR_HEADBUTT_STUN', from)
    end
    
    local abil = GetAbility(from, 'Murmillo10')
    if abil ~= nil then
        AddBuff(from, self, 'HeadButtAbil_Debuff', abil.Level, 0, 10000, 1);
    end
end

function SCR_HEADBUTT_STUN(self)
    sleep(500);
    if IMCRandom(1, 10000) < 5100 then
        AddBuff(self, self, 'Stun', 1, 0, 3000, 1);
    end
end

function SCR_SKILL_RATETABLE_Doppelsoeldner_Zornhau(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Doppelsoeldner22')
    if abil ~= nil and skill.Level >= 6 then
        local hitCount = 1 + abil.Level;
        local addRate = abil.Level;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + addRate;
        SetMultipleHitCount(ret, hitCount)
    end
end

function SCR_SKILL_RATETABLE_Musketeer_BayonetThrust(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, 'Musketeer13')
    if abil ~= nil and IMCRandom(1, 10000) < abil.Level * 200 then
        local hitCount = 2
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
        SetMultipleHitCount(ret, hitCount)
        
        AddBuff(from, self, 'UC_bleed', 1, 0, 10000, 1);
    end
end

function SCR_SKILL_RATETABLE_Musketeer_ButtStroke(self, from, skill, atk, ret, rateTable)
    local Musketeer19_abil = GetAbility(from, 'Musketeer19')
    if Musketeer19_abil ~= nil and GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 1;
    end
end

function SCR_SKILL_RATETABLE_Musketeer_Birdfall(self, from, skill, atk, ret, rateTable)
    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key); 
    
    local flyingPenalty = 1;
    local abilMusketeer26 = GetAbility(from, 'Musketeer26');
    if abilMusketeer26 ~= nil and abilMusketeer26.ActiveState == 1 then
        flyingPenalty = 0;
    end
    
    if IS_PC(self) == false then
        if self.MoveType == "Flying" or flyingPenalty == 0 then
            local hitCount = 3
            SetMultipleHitCount(ret, hitCount)
            if self.MoveType == "Flying" then
                rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.1;
                AddBuff(from, self, 'Stun', 1, 0, 3000, 1);
            end
        else
            rateTable.DamageRate = rateTable.DamageRate - 0.3;
        end
    else
        local debuff = GetBuffByProp(self, 'Keyword', 'FlyingState');
        if debuff ~= nil or flyingPenalty == 0 then
            local hitCount = 3
            SetMultipleHitCount(ret, hitCount)
            
            if debuff ~= nil then
                rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 0.1;
                RemoveBuff(self, debuff.ClassName)
            end
        else
            rateTable.DamageRate = rateTable.DamageRate - 0.3;
        end
    end
    
    EndSyncPacket(from, key, 0);
end

function SCR_SKILL_RATETABLE_Featherfoot_BloodCurse(self, from, skill, atk, ret, rateTable)
    
    local damage = math.floor(from.MHP * 0.6) * (1 + skill.Level * 0.1)
    
    local abil = GetAbility(from, 'Featherfoot12')
    if abil ~= nil then
        damage = math.floor(from.MHP * 0.8) * (1 + skill.Level * 0.1)
    end
    
    local abil_Featherfoot18 = GetAbility(from, 'Featherfoot18')
    if abil_Featherfoot18 ~= nil then
        damage = damage + (damage * (abil_Featherfoot18.Level * 0.1))
    end
    
    rateTable.AddTrueDamage = rateTable.AddTrueDamage + damage;
end

function SCR_SKILL_RATETABLE_Dragoon_DargonDive(self, from, skill, atk, ret, rateTable)
    local damage = math.floor(from.MHP * 1.5)
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + damage;
end

function SCR_SKILL_RATETABLE_Dragoon_Dethrone(self, from, skill, atk, ret, rateTable)
    if self.Size == 'XL' then
        AddBuff(from, self, 'DethroneBoss_Debuff', 1, 0, 4000 * skill.Level, 1);
    else
        AddBuff(from, self, 'Dethrone_Debuff', 1, 0, 5000, 1);
    end
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
    SetMultipleHitCount(ret, 2)
end

function SCR_SKILL_RATETABLE_Hackapell_CavalryCharge(self, from, skill, atk, ret, rateTable)
    RunScript('SCR_FEINT_ABIL', self, from)
end

function SCR_SKILL_RATETABLE_Inquisitor_GodSmash(self, from, skill, atk, ret, rateTable)
    local rItem = GetEquipItem(from, 'RH')
    if rItem ~= nil and rItem.AttachType == "Mace" or rItem.AttachType == "THMace" then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
    end
    
    local addDamage = self.MAXMATK * 0.05;
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + addDamage;
    
    local abil = GetAbility(from, "Inquisitor10");
    if abil ~= nil then
        rateTable.DamageRate = rateTable.DamageRate * (1 + abil.Level * 0.01);
    end
    
    local abil = GetAbility(from, "Inquisitor12")
    local abilDamage = 0
    if abil ~= nil and abil.ActiveState == 1 then
        if IS_PC(self) == false and self.RaceType == "Velnias" then
            abilDamage = abil.Level * 0.1
            
            rateTable.DamageRate = rateTable.DamageRate + abilDamage;
        elseif IS_PC(self) == true and IsBuffApplied(self, 'Judgment_Debuff') == 'YES' then
        	abilDamage = abil.Level * 0.1
        	
        	rateTable.DamageRate = rateTable.DamageRate + abilDamage;
        end
    end
end

function SCR_SKILL_RATETABLE_Inquisitor_PearofAnguish(self, from, skill, atk, ret, rateTable)

    if GetExProp(self, 'FLY_ATTACk') == 1 then
         rateTable.DamageRate = rateTable.DamageRate + 0.5;
         DelExProp(self, 'FLY_ATTACk')
    end

    local abil = GetAbility(from, "Inquisitor6");
    if abil ~= nil then
        rateTable.DamageRate = rateTable.DamageRate * (1 + abil.Level * 0.01);
    end
end

function SCR_SKILL_RATETABLE_Mon_pcskill_bone_Skill_1(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(GetOwner(from), "Featherfoot13")
    if abil ~= nil then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1.5;
        SetMultipleHitCount(ret, 3)
    end
    
    if IsBuffApplied(GetOwner(from), 'Levitation_Buff') == 'YES' then
        local abilFeatherfoot18 = GetAbility(GetOwner(from), "Featherfoot18")
        if abilFeatherfoot18 ~= nil then
            local addDamageRate = abilFeatherfoot18.Level * 0.1;
            rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
        end
    end
end

function SCR_SKILL_RATETABLE_Mon_pcskill_boss_werewolf_Skill_1(self, from, skill, atk, ret, rateTable)
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + from.MAXMATK;
end

function SCR_SKILL_RATETABLE_Mon_pcskill_boss_werewolf_Skill_3(self, from, skill, atk, ret, rateTable)
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + from.MAXMATK;
end

function SCR_SKILL_RATETABLE_Mon_pcskill_boss_werewolf_Skill_4(self, from, skill, atk, ret, rateTable)
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + from.MAXMATK;
end

function SCR_SKILL_RATETABLE_Mon_pcskill_boss_werewolf_Skill_5(self, from, skill, atk, ret, rateTable)
    rateTable.AddAtkDamage = rateTable.AddAtkDamage + from.MAXMATK;
end

function SCR_SKILL_RATETABLE_Sage_UltimateDimension(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Sage4")
    if abil ~= nil and IMCRandom(1, 10000) < abil.Level * 500 then
        AddBuff(from, self, 'UC_confuse', 1, 0, 8000, 1);
    end
end

function SCR_SKILL_RATETABLE_Highlander_CartarStroke(self, from, skill, atk, ret, rateTable)
    local state = GetActionState(self);
    if state == 'AS_KNOCKDOWN' or state == 'AS_DOWN' then
        rateTable.DamageRate = rateTable.DamageRate + 1
    end
end

function SCR_SKILL_RATETABLE_Monk_PalmStrike(self, from, skill, atk, ret, rateTable)
    local def = self.DEF
    if def > atk then
        def = atk
    end
    
    rateTable.AddTrueDamage = rateTable.AddTrueDamage + def;
end

function SCR_SKILL_RATETABLE_Monk_HandKnife(self, from, skill, atk, ret, rateTable)
    local mna = self.MNA * 2
    if mna > atk then
        mna = atk
    end
    
    rateTable.AddTrueDamage = rateTable.AddTrueDamage + mna;
end

function SCR_SKILL_RATETABLE_Alchemist_AlchemisticMissile(self, from, skill, atk, ret, rateTable)
    
    local hitCount = 2;
   rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
    SetMultipleHitCount(ret, hitCount)
end

function SCR_SKILL_RATETABLE_Falconer_BlisteringThrash(self, from, skill, atk, ret, rateTable)
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 5
    
    local raceType = TryGetProp(self, "RaceType")
    if IS_PC(self) == false then
	    if raceType == "Widling" then
	    	rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end

function SCR_SKILL_RATETABLE_Elementalist_Electrocute(self, from, skill, atk, ret, rateTable)
    rateTable.DamageRate = rateTable.DamageRate + 4;
    
end

function SCR_SKILL_RATETABLE_Hunter_RushDog(self, from, skill, atk, ret, rateTable)
    rateTable.DamageRate = rateTable.DamageRate + 4;
end

function SCR_SKILL_RATETABLE_Sapper_Claymore(self, from, skill, atk, ret, rateTable)
    local abil_33 = GetAbility(from, "Sapper33")
    local abil_30 = GetAbility(from, 'Sapper30');
    if abil_33 ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 0.5;
    end
    
    if abil_30 ~= nil and IS_PC(self) == false and self.MoveType == "Flying" then
        rateTable.DamageRate = rateTable.DamageRate + abil_30.Level * 0.1;
    end
    
end

function SCR_SKILL_RATETABLE_Sapper_BroomTrap(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Sapper34")
    if abil ~= nil then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + 5000
    end
end

function SCR_SKILL_RATETABLE_Sapper_SpikeShooter(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Sapper35")
    if abil ~= nil then
        rateTable.crtRatingAdd = rateTable.crtRatingAdd + 5000;
    end
end

function SCR_SKILL_RATETABLE_Wugushi_NeedleBlow(self, from, skill, atk, ret, rateTable)
    if skill.ClassName == "Wugushi_NeedleBlow" then
        if IsBuffApplied(self, 'Archer_BlowGunPoison_Debuff') == 'YES' then
            rateTable.EnableCritical = 0
            rateTable.EnableDodge = 0;
            rateTable.EnableBlock = 0;
        end
    end
end

function SCR_SKILL_RATETABLE_Wugushi_WugongGu(self, from, skill, atk, ret, rateTable)
    if skill.ClassName == "Wugushi_WugongGu" then
        if IsBuffApplied(self, 'Virus_Debuff') == 'YES' then
            rateTable.EnableCritical = 0
            rateTable.EnableDodge = 0;
            rateTable.EnableBlock = 0;
        end
    end
end

function SCR_SKILL_RATETABLE_Wugushi_ThrowGuPot(self, from, skill, atk, ret, rateTable)
    if skill.ClassName == "Wugushi_ThrowGuPot" then
        rateTable.EnableCritical = 0
        rateTable.EnableDodge = 0;
        rateTable.EnableBlock = 0;
    end
end

function SCR_SKILL_RATETABLE_Fletcher_BroadHead(self, from, skill, atk, ret, rateTable)
    if skill.ClassName == "Fletcher_BroadHead" then
        if IsBuffApplied(self, 'BroadHead_Debuff') == 'YES' then
            rateTable.EnableCritical = 0
            rateTable.EnableDodge = 0;
            rateTable.EnableBlock = 0;
        end
    end
end

function SCR_SKILL_RATETABLE_Musketeer_Snipe(self, from, skill, atk, ret, rateTable)
    if GetBuffByProp(self, 'Keyword', 'Wound') ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 0.2
    end
    
	local abil_Musketeer21 = GetAbility(from, "Musketeer21");
	if abil_Musketeer21 ~= nil and abil_Musketeer21.ActiveState == 1 then
		rateTable.EnableDodge = 0;
	end
end

function SCR_SKILL_RATETABLE_Hoplite_ThrouwingSpear(self, from, skill, atk, ret, rateTable)
    local dist = GetActorDistance(from, self)
    dist = math.min(dist/100, 1)
    rateTable.DamageRate = rateTable.DamageRate + dist
end

function SCR_SKILL_RATETABLE_Cataphract_SteedCharge(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, 'Dethrone_Debuff') == 'YES' or IsBuffApplied(self, 'DethroneBoss_Debuff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.3
    end
end

function SCR_SKILL_RATETABLE_Pardoner_Indulgentia(self, from, skill, atk, ret, rateTable)
    local oblationSkill = GetSkill(from, "Pardoner_Oblation")
    local oblationCurCount = 0;
    local oblationMaxCount = 0;
    
    local abil = GetAbility(from, "Pardoner3")
    local ActiveState = TryGetProp(abil, "ActiveState")
    if oblationSkill ~= nil and abil ~= nil and ActiveState == 1 and oblationSkill.Level >= 6 then
        oblationCurCount = GetOblationShopCount(from);
        oblationMaxCount = GET_OBLATION_MAX_COUNT(skill.Level)
        oblationCurCount = oblationCurCount * 0.02
        oblationMaxCount = oblationMaxCount * 0.0002
        
        if oblationCurCount > oblationMaxCount then
            oblationCurCount = oblationMaxCount
        end
    end
    
    rateTable.DamageRate = rateTable.DamageRate + oblationCurCount
end



function SCR_SKILL_RATETABLE_Common_ForcedAttack(self, from, skill, atk, ret, rateTable)
    rateTable.NoneDamage = 1;
--    DetachEffect(self, 'I_sys_target001_circle');
--    AttachEffect(self, 'I_sys_target001_circle', 2.0, 'BOT');
    AttachEffect(self, 'I_question_arrow_mash', 0.5, 'TOP');
    AttachEffect(self, 'F_lineup017_red3', 1.0, 'BOT');
    AttachEffect(self, 'F_lineup022_red', 0.5, 'BOT');
    SetExArgObject(from, "OWNER_FORCED_TARGET", self);
--    ObjectColorBlend(self, 255, 110, 100, 200, 1, 0.3);
    ObjectColorBlend(self, 255, 110, 100, 200, 1, 0.0);
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 0.5);
end

function SCR_SKILL_RATETABLE_Hackapell_GrindCutter(self, from, skill, atk, ret, rateTable)
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 4;
    SetMultipleHitCount(ret, 5)
end

function SCR_SKILL_RATETABLE_DoubleGun_Attack(self, from, skill, atk, ret, rateTable)
    SetMultipleHitCount(ret, 2)
end

function SCR_SKILL_RATETABLE_Templer_MortalSlash(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, "BattleOrders_Debuff") == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.2
    end
end

function SCR_SKILL_RATETABLE_Kriwi_DivineStigma(self, from, skill, atk, ret, rateTable)
    if TryGetProp(self, 'RaceType') == 'Velnias' then
        local addRate = 0;
        local abil_Kriwi19 = GetAbility(from, "Kriwi19");
        if abil_Kriwi19 ~= nil and skill.Level >= 10 then
            addRate = addRate + abil_Kriwi19.Level * 0.1;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addRate;
    end
end

function SCR_SKILL_RATETABLE_Rancer_Chage(self, from, skill, atk, ret, rateTable)
    local distRate = GetExProp(self, "CHARGE_DIST")
    if distRate ~= nil then
       rateTable.DamageRate = rateTable.DamageRate + distRate
    end

end

function SCR_SKILL_RATETABLE_Bulletmarker_FullMetalJacket(self, from, skill, atk, ret, rateTable)
    rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate + 0.5
end

function SCR_SKILL_RATETABLE_Sage_DimensionCompression(self, from, skill, atk, ret, rateTable)
    local castTime, skillID, maxCastingTime, isLoopingCharge = GetDynamicCastingSkill(from);
    if castTime <= 0 then
        return
    end
    local chargingRate = castTime / maxCastingTime
    
    rateTable.DamageRate = rateTable.DamageRate + chargingRate;
end

function SCR_SKILL_RATETABLE_Dragoon_DragonFall(self, from, skill, atk, ret, rateTable)
	if IS_PC(from) == true then
	    local abil = GetAbility(from, "Dragoon18")
	    if abil ~= nil and abil.ActiveState == 1 then
			
			local totalWeight = GetTotalItemWeight(from);
			if totalWeight == nil then
				totalWeight = 0;
			end
			
			local maxWeight = TryGetProp(from, 'MaxWeight');
			if maxWeight == nil then
				return;
			end
			
			if (totalWeight / maxWeight) >= 0.5 then
				rateTable.EnableBlock = 0;
			end
	    end
	end
end

function SCR_SKILL_RATETABLE_Musketeer_PenetrationShot(self, from, skill, atk, ret, rateTable)
    local abilMusketeer25 = GetAbility(from, "Musketeer25")
    if abilMusketeer25 ~= nil and abilMusketeer25.ActiveState == 1 then
        local addRate = 1;
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + addRate;
        SetMultipleHitCount(ret, 2);
    end
end

function SCR_SKILL_RATETABLE_Bulletmarker_MozambiqueDrill(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Bulletmarker9")
    if abil ~= nil and abil.ActiveState == 1 then
        local defensesAbil = abil.Level * 0.1
        
        rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate + defensesAbil
    end
end

function SCR_SKILL_RATETABLE_Shadowmancer_ShadowThorn(self, from, skill, atk, ret, rateTable)
    local abil = GetAbility(from, "Shadowmancer4")
    local hitCount = 2
    if abil ~= nil and abil.ActiveState == 1 then
        if IS_PC(self) == false and (self.MoveType == "Normal" or self.MoveType == "Holding") then
            SetMultipleHitCount(ret, hitCount);
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
        end
    end
end

function SCR_SKILL_RATETABLE_Matador_Faena(self, from, skill, atk, ret, rateTable)
    if IsBuffApplied(self, 'SeeRed_Debuff') == 'YES' then
        SetExProp(from, "IS_CRITICAL", 1)
    end
    
    local defenderSize = TryGetProp(self, 'Size');
    if defenderSize ~= nil and (defenderSize == 'L' or defenderSize == 'XL') then
    	rateTable.DamageRate = rateTable.DamageRate + 0.2;
    end
end


function SCR_SKILL_RATETABLE_Zealot_Immolation(self, from, skill, atk, ret, rateTable)
    if skill.ClassName == "Zealot_Immolation" then
        if IsBuffApplied(self, 'Immolation_Debuff') == 'YES' then
            rateTable.EnableDodge = 0;
            rateTable.EnableBlock = 0;
            rateTable.EnableCritical = 0;
        end
    end
end

function SCR_SKILL_RATETABLE_Hoplite_LongStride(self, from, skill, atk, ret, rateTable)
    if IS_PC(from) == true then
        local totalWeight = GetTotalItemWeight(from);
        if totalWeight == nil then
            totalWeight = 0;
        end
        
        local maxWeight = TryGetProp(from, 'MaxWeight');
        if maxWeight == nil then
            return;
        end
        
        local weightValue = totalWeight / maxWeight
        if weightValue > 1 then
        	weightValue = 1
        end
        
        rateTable.DamageRate = rateTable.DamageRate + weightValue;
    end
end

function SCR_SKILL_RATETABLE_Cataphract_Impaler(self, from, skill, atk, ret, rateTable)
	if GetBuffByProp(self, 'Keyword', 'Shock') then
        SetExProp(from, "IS_CRITICAL", 1)
    end
end


function SCR_SKILL_RATETABLE_Dragoon_Dragontooth(self, from, skill, atk, ret, rateTable)
	local attackerCRTHR = TryGetProp(from, 'CRTHR');
	if attackerCRTHR == nil or attackerCRTHR < 0 then
		attackerCRTHR = 0;
	end
	
	rateTable.AddCrtHR = rateTable.AddCrtHR + attackerCRTHR;
	
	local rhWeapon = GetEquipItem(from, "RH")
	if rhWeapon ~= "NoWeapon" and rhWeapon.ClassType == "THSpear" then
		rateTable.AddIgnoreDefensesRate = rateTable.AddIgnoreDefensesRate + 0.5
	end
end


function SCR_SKILL_RATETABLE_Falconer_Hovering(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Widling" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
		
		if self.Size == "XL" then
			local abil_Falconer16 = GetAbility(from, "Falconer16")
			local bossDamage = 0
			if abil_Falconer16 ~= nil and abil_Falconer16.ActiveState == 1 then
				bossDamage = abil_Falconer16.Level * 0.1
				
				rateTable.DamageRate = rateTable.DamageRate + bossDamage
			end
		end
	end
end


function SCR_SKILL_RATETABLE_Falconer_Pheasant(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Widling" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
		
		local abil_Falconer17 = GetAbility(from, "Falconer17")
		if abil_Falconer17 ~= nil and abil_Falconer17.ActiveState == 1 then
			local hitCount = 5
		    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1.5;
		    SetMultipleHitCount(ret, hitCount);
		end
	end
end

function SCR_SKILL_RATETABLE_Psychokino_PsychicPressure(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Paramune" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end


function SCR_SKILL_RATETABLE_Psychokino_Telekinesis(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Paramune" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end


function SCR_SKILL_RATETABLE_Psychokino_MagneticForce(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Paramune" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end


function SCR_SKILL_RATETABLE_Psychokino_GravityPole(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Paramune" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end


function SCR_SKILL_RATETABLE_Psychokino_HeavyGravity(self, from, skill, atk, ret, rateTable)
	if IS_PC(self) == false then
		if self.RaceType == "Paramune" then
			rateTable.DamageRate = rateTable.DamageRate + 0.5
		end
	end
end


function SCR_SKILL_RATETABLE_NakMuay_Attack(self, from, skill, atk, ret, rateTable)
    SetMultipleHitCount(ret, 2)
end

function SCR_SKILL_RATETABLE_NakMuay_TeKha(self, from, skill, atk, ret, rateTable)
    if IS_PC(self) == false then
        if TryGetProp(self, "Size") == "S" then
            rateTable.DamageRate = rateTable.DamageRate + 0.5
        end
    end
end

function SCR_SKILL_RATETABLE_NakMuay_KhaoLoi(self, from, skill, atk, ret, rateTable)
    if TryGetProp(self, "MoveType") == "Flying" then
        rateTable.DamageRate = rateTable.DamageRate + 0.5
    end
end

function SCR_SKILL_RATETABLE_RuneCaster_Tiwaz(self, from, skill, atk, ret, rateTable)
    if TryGetProp(self, "RaceType") == "Velnias" then
        rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
		SetMultipleHitCount(ret, 2);
    end
end

function SCR_SKILL_RATETABLE_Shinobi_Kunai(self, from, skill, atk, ret, rateTable)
    local addCrt = from.CRTHR
    local abilShinobi9 = GetAbility(from, "Shinobi9")
    if abilShinobi9 ~= nil and TryGetProp(abilShinobi9, "ActiveState") == 1 then
        rateTable.AddCrtHR = rateTable.AddCrtHR + addCrt
    end
    
    if IS_REAL_PC(from) == "NO" then
        if GetExProp(from, "BUNSIN") == 1 then
            rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1;
    		SetMultipleHitCount(ret, 2);
        end
    end
end

function SCR_SKILL_RATETABLE_Rodelero_Slithering(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
end

function SCR_SKILL_RATETABLE_Corsair_DustDevil(self, from, skill, atk, ret, rateTable)
    local addLHRate = 0.6;
    local addRhRate = -0.2;
    SCR_ADD_ATK_BY_SUBWEAPON(self, from, skill, atk, ret, rateTable, addLHRate, addRhRate);
end

function SCR_SKILL_RATETABLE_Murmillo_ScutumHit(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
end

function SCR_SKILL_RATETABLE_Murmillo_ShieldTrain(self, from, skill, atk, ret, rateTable)
    local addRate = 0.3;
    SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate);
end

function SCR_SKILL_RATETABLE_Rancer_Joust(self, from, skill, atk, ret, rateTable)
    local hitCount = 2
    rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + (hitCount - 1);
    SetMultipleHitCount(ret, hitCount);
end

function SCR_SKILL_RATETABLE_Corsair_HexenDropper(self, from, skill, atk, ret, rateTable)
    local addLHRate = 0.6;
    local addRhRate = -0.2;
    SCR_ADD_ATK_BY_SUBWEAPON(self, from, skill, atk, ret, rateTable, addLHRate, addRhRate);
end

function SCR_SKILL_RATETABLE_Corsair_PistolShot(self, from, skill, atk, ret, rateTable)
    if ret.Damage >= 1 then
        local maxRatio = IMCRandom(1, 100);
        local ratio = 15
        if ratio >= maxRatio then
            SetExProp(self, "IS_TAKE_CRITICAL", 1)
        end
    end
end

function SCR_SKILL_RATETABLE_Retiari_DaggerFinish(self, from, skill, atk, ret, rateTable)
    local targetMHP = self.MHP
    local targetHP = self.HP
    local targetHPRate = (targetHP/targetMHP) * 100
    
    if targetHPRate < 50 then
        local addDamageRate = 30 /targetHPRate
        
        if addDamageRate >= 2.5 then
            addDamageRate = 2.5
        end
        local textRate = (addDamageRate + 1) * 100
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', textRate, nil, skill.ClassID);
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate
    end
    
    if GetBuffByProp(self, "Keyword", "Strap") ~= nil then
        rateTable.DamageRate = rateTable.DamageRate + 1
    end
end


function SCR_SKILL_RATETABLE_Onmyoji_WhiteTigerHowling(self, from, skill, atk, ret, rateTable)
	local abilOnmyoji7 = GetAbility(from, "Onmyoji7")
	local abilDamageRate = 0
	if abilOnmyoji7 ~= nil and abilOnmyoji7.ActiveState == 1 then
		abilDamageRate = abilOnmyoji7.Level * 0.05
		
		if TryGetProp(self, "RaceType") == "Widling" then
			rateTable.DamageRate = rateTable.DamageRate + abilDamageRate
		end
	end
	
	if TryGetProp(self, "RaceType") == "Forester" then
		rateTable.DamageRate = rateTable.DamageRate + 0.5
	end
end

function SCR_SKILL_RATETABLE_Retiarii_TridentFinish(self, from, skill, atk, ret, rateTable)
    if ret.Damage > 1 then
	    if GetBuffByProp(self, "Keyword", "Strap") ~= nil then
	        local ratio = 50;
	        if ratio >= IMCRandom(1, 100) then
	            SetExProp(self, "IS_TAKE_CRITICAL", 1);
	        end
	        
	        rateTable.DamageRate = rateTable.DamageRate + 1
	    end
	end
end


function SCR_SKILL_RATETABLE_Onmyoji_Toyou(self, from, skill, atk, ret, rateTable)
	local state = GetActionState(self);
	if state == 'AS_KNOCKDOWN' or state == 'AS_DOWN' then
        local reductionRate = 0.5
        AddDamageReductionRate(rateTable, reductionRate);
        if IMCRandom(1, 100) < 10 then
        	AddBuff(from, self, "Hold", 1, 0, 3000, 1)
        end
	end
end


function SCR_SKILL_RATETABLE_Mon_pcskill_FireFoxShikigami_Skill_1(self, from, skill, atk, ret, rateTable)
    local hitCount = 2
	
	rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + (hitCount - 1);
    SetMultipleHitCount(ret, hitCount);
end

function SCR_SKILL_RATETABLE_Pyromancer_FireBall(self, from, skill, atk, ret, rateTable)
	if IsBuffApplied(from, 'FireFoxShikigami_Onmyoji18_Buff') == 'YES' then
	    local hitCount = 3
		
		rateTable.MultipleHitDamageRate = rateTable.MultipleHitDamageRate + 1
	    SetMultipleHitCount(ret, hitCount);
    end
end
