-- skill_aftercalc.lua
-- CALC_FINAL_DAMAGE() -> SCR_SKILL_AFTERCALC_UPDATE(self, from, skill, atk, ret, rateTable, buff);

function SCR_SKILL_AFTERCALC_HIT_Paladin_Smite(self, from, skill, atk, ret)

    if IS_PC(self) ~= true and (self.HPCount > 0 or self.KDArmor > 900) then
        return ;
    end
    
    local abil = GetAbility(from, "Paladin4")
    if abil ~= nil then
        local damage = SCR_LIB_ATKCALC_RH(from, skill);
        RunScript('SCR_SMITE_PALADIN4_TAKEDAMAGE', self, from, damage/2 + skill.SkillAtkAdd)
    end
end

function SCR_SMITE_PALADIN4_TAKEDAMAGE(self, from, damage)
    sleep(950)
    TakeDamage(from, self, "None", damage, "Melee", "Strike", "Melee", HIT_REFLECT, HITRESULT_BLOW);
end

function SCR_SKILL_AFTERCALC_HIT_Musketeer_HeadShot(self, from, skill, atk, ret)
    local abil = GetAbility(from, 'Musketeer9');
    if abil ~= nil and IMCRandom(1,9999) < abil.Level * 250 then
        RunScript('ADD_BUFF_DELAY', self, from, 'Stun', 1, 0, 3000, 1, 850);
    end
end

function SCR_SKILL_AFTERCALC_HIT_Musketeer_Snipe(self, from, skill, atk, ret)
    local abil = GetAbility(from, 'Musketeer10');
    if abil ~= nil and IMCRandom(1,9999) < abil.Level * 350 then
        RunScript('ADD_BUFF_DELAY', self, from, 'Stun', 1, 0, 3000, 1, 200);
    end
end

function SCR_SKILL_AFTERCALC_HIT_Ranger_HighAnchoring(self, from, skill, atk, ret)
    local abilRanger34 = GetAbility(from, "Ranger34");
	if abilRanger34 ~= nil and TryGetProp(abilRanger34, "ActiveState") == 1 then
        local skillList = {"Ranger_SpiralArrow", "Ranger_BounceShot", "Ranger_TimeBombArrow"}
    	
    	for i = 1, #skillList do
    		local skill = GetSkill(from, skillList[i])
    		if skill ~= nil then
    			AddCoolDown(from, skill.CoolDownGroup, -1000)
    		end
    	end
    end
    
    local abil = GetAbility(from, 'Ranger31');
    if abil ~= nil then
        RunScript('ADD_BUFF_DELAY', self, from, 'HighAnchoring_Debuff', abil.Level, 0, 5000, 1, 200);
    end
end

function SCR_SKILL_AFTERCALC_HIT_Musketeer_BayonetThrust(self, from, skill, atk, ret)
    local abil = GetAbility(from, 'Musketeer14');
    if abil ~= nil then
        AddBuff(from, self, 'BayonetThrust_Debuff', abil.Level, 0, 60000 + (abil.Level * 20000), 1)
    end
end

function SCR_SKILL_AFTERCALC_HIT_QuarrelShooter_RapidFire(self, from, skill, atk, ret)
    local abil = GetAbility(from, 'QuarrelShooter23');
    if abil ~= nil and IMCRandom(1,9999) < 5000 then
        RunScript('ADD_BUFF_DELAY', self, from, 'RapidFire_Debuff', 1, 0, abil.Level * 3000, 1, 200);
    end
end

function SCR_SKILL_AFTERCALC_HIT_Mon_pcskill_CorpseTower_Skill_1(self, from, skill, atk, ret)
    local owner = GetOwner(from)
    if owner ~= nil then
        local skl = GetSkill(owner, 'Necromancer_RaiseDead')
        if skl == nil then 
            return;
        end
        local sklLv = skl.Level;
        local maxSkullCount = sklLv
        if maxSkullCount >= 5 then
            maxSkullCount = 5
        end
        
        local list, listCnt = GetSkullSoldierSummonList(owner, skl.ClassName);
        if listCnt == maxSkullCount then
            return;
        end
        
        local Necromancer23_abil = GetAbility(owner, 'Necromancer23')
        local checkDamage = ret.Damage;
        if IS_PC(self) ~= true then
            if self.HPCount > 0 then
                checkDamage = 1;
            end
        end
        
        if Necromancer23_abil ~= nil and skill.ClassName == 'Mon_pcskill_CorpseTower_Skill_1' and (IsDead(self) == 1 or checkDamage >= self.HP) then
            local iesObj = CreateGCIES('Monster', 'pcskill_skullsoldier');
            if iesObj ~= nil then
                iesObj.Lv = owner.Lv;
                iesObj.StatType = 1
                iesObj.Faction = 'Summon'
                
                local x, y, z = GetFrontRandomPos(self, 30, 30);
                local mon = CreateMonster(owner, iesObj, x, y, z, 0, 0);
                SetExProp_Str(mon, "SKLNAME", skl.ClassName);
                local sklbonus = 0.6 + skl.Level * 0.1
                local abilbonus = 1
                
                local Necromancer7_abil = GetAbility(self, "Necromancer7")
                if Necromancer7_abil ~= nil then
                    abilbonus = abilbonus + Necromancer7_abil.Level * 0.005;
                end
                
                mon.MATK_BM = (300 + (self.INT * sklbonus)) * abilbonus
                mon.PATK_BM = (300 + (self.INT * sklbonus)) * abilbonus
                mon.MHP_BM = mon.MHP_BM + skl.Level * 500
                
                local Necromancer20_abil = GetAbility(self, 'Necromancer20')
                if Necromancer20_abil ~= nil then
                    mon.MHP_BM = mon.MHP_BM + math.floor(mon.MHP * Necromancer20_abil.Level * 0.01)
                end
                
                Invalidate(mon, "MHP");
                
                SetOwner(mon, owner, 0)
                SetHookMsgOwner(mon, owner)
                RunSimpleAI(mon, 'follow_mon_sleep');
                SetDeadScript(mon, "SKULL_SOLDIER_DEAD");
                
                DontUseEventHandler(mon, "handler_eat_heal");
                DontUseEventHandler(mon, "handler_hp_runaway");
                
                BroadcastRelation(mon);
                AddSkullSoldierSummon(owner, mon)
                
                SetLifeTime(mon, 300)
            end
        end
    end
end

function SCR_SKILL_AFTERCALC_HIT_Mon_pcskill_skullsoldier_Skill_1(self, from, skill, atk, ret)
    
    ret.HitType = HIT_BASIC;
    
    local owner = GetOwner(from)
    if owner ~= nil then
        local abil = GetAbility(owner, 'Necromancer22')
        if abil ~= nil and (skill.ClassName == 'Mon_pcskill_skullsoldier_Skill_1' and IsDead(self) == 1 or ret.Damage >= self.HP) then
            NECRO_ADD_DEADPARTS(owner, self.ClassID, abil.Level)
        end
    end
end

function SCR_SKILL_AFTERCALC_HIT_Mon_pcskill_skullarcher_Skill_1(self, from, skill, atk, ret)
    ret.HitType = HIT_BASIC;
end

function SCR_SKILL_AFTERCALC_HIT_Doppelsoeldner_Zwerchhau(self, from, skill, atk, ret)
    ret.HitDelay = 100;
end


function PUNISH_SYNC(caster, target, skill, ret)

end

function SCR_SKILL_AFTERCALC_HIT_Fencer_AttaqueAuFer(self, from, skill, atk, ret)
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local handType = 'RH'
    local equipItem = GetEquipItem(self, handType);
    if equipItem == nil then
        return;
    end

    if GetBuffByName(self, 'Warrior_ThrowItem_Debuff_'..handType) ~= nil then
        return;
    end

    local monObj = CreateGCIES('Monster', 'skill_equip_object');
    monObj.Name = "skill_equip_object" .. tostring(GetHandle(self))
    
    local x,y,z = GetFrontRandomPos(from, 100);
    local angle = GetAngleToPos(from, x, z);
    local mon = CreateMonster(self, monObj, x, y, z, angle, 0, 0, GetLayer(self));
    if mon == nil then
        RemoveBuff(self, 'Warrior_ThrowItem_Debuff_'..handType);
        return;
    end

    SetShadowRender(mon, 0);
    DelayEnterWorld(mon);
    SetExArgObject(self, "THROW_ITEM_OBJ_"..handType, mon);
    ChangeApcItemBodyPT(mon, self, 'FindXac', handType);
    local startRotateBillboard = 0;
    local endRotateBillboard = 0;
    local isReverse = false;
    local dirAngle = GetDirectionByAngle(self);
    startRotateBillboard = dirAngle
    endRotateBillboard = dirAngle + 90;
    
    if dirAngle > -50 and dirAngle < 120 then
        isReverse = true;
    end
    
    if isReverse == true then
        local tmp = startRotateBillboard
        startRotateBillboard = endRotateBillboard
        endRotateBillboard = tmp
    end
    
    local dist = GetDistance(self, mon) * 0.0065;
    RunScript('SHOW_DELAY_THROWITEM', mon, self, angle, dist,x, y, z, startRotateBillboard, endRotateBillboard, handType, from, skill.Level);
end

function SHOW_DELAY_THROWITEM(mon, self, angle, dist, x, y, z, startRotateBillboard, endRotateBillboard, handType,from, lv)
    sleep(150)

    local buff = AddBuff(from, self, 'Warrior_ThrowItem_Debuff_'..handType, 0, 0, 15000, 1);
    if buff == nil then
        EnterDelayedActor(mon);
        return;
    end

    SetExProp(buff, 'IS_DETHRONE_SKIL', 2)
    SetExProp(buff, 'DETHRONE_SKIL_CHECkTIME', imcTime.GetAppTime() + 2 + (lv * 0.2))
    ThrowItem(self, mon, 'FindXac', handType, x, y, z, 0.5, 0, 700, 1, 'None', 0, startRotateBillboard, endRotateBillboard, 0.8, dist);
    sleep(dist * 1200)
    EnterDelayedActor(mon);

    if IsZombie(mon) == 1 or IsDead(mon) == 1 then
        return;
    end

    AddEffect(mon, 'F_item_drop_white_loop', 5.0, 1, 'BOT')
    SetFixRotateBillboard(mon, 45);
    if IsZombie(self) ~= 1 and IsDead(self) ~= 1 then
        KnockDown(mon, self, 30, angle, 70, 2);
        return;
    end
end

function SCR_SKILL_AFTERCALC_HIT_Rancer_Crush(self, from, skill, atk, ret)
    
    local owner = GetOwner(self)
    
    if owner == nil or GetRelation(self, from) ~= 'ENEMY' then
        return ;
    end
    
    local sleepTime = 200
    
    RunScript('DELAY_KNOCKBACK', self, from, sleepTime);

end

function SCR_SKILL_AFTERCALC_HIT_Rancer_Joust(self, from, skill, atk, ret)
    
    local owner = GetOwner(self)
    
    if owner == nil or GetRelation(self, from) ~= 'ENEMY' then
        return ;
    end
    
    local sleepTime = 200
    
    RunScript('DELAY_KNOCKBACK', self, from, sleepTime);

end

function SCR_SKILL_AFTERCALC_HIT_Musketeer_ButtStroke(self, from, skill, atk, ret)
    
    local abil = GetAbility(from, "Musketeer20")
    if abil == nil then
        return;
    end
    
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    local buff = AddBuff(from, self, 'ButtStroke_Debuff', 1 , 0, 12000, 1);
    EndSyncPacket(self, key);
end

function DELAY_KNOCKBACK(self, from, sleepTime)
    sleep(sleepTime)
    local angle = GetAngleTo(from, self)
    KnockBack(self, from, 250, angle, 10, 1)
end

function SCR_SKILL_AFTERCALC_HIT_Oracle_TwistOfFate(self, from, skill, atk, ret)
    
    local dmgRate = IMCRandom((8 * skill.Level) - 7, 8 * skill.Level)
    
    if IS_PC(self) == false then
        if IsFieldBoss(self) == 1 or (self.MonRank == "Boss" and (self.DebuffRank == "Field" or self.DebuffRank == "Hero")) then
            ret.Damage = 0;
            return ;
        elseif self.MonRank == "Boss" then
            dmgRate = dmgRate / 2
        end
    end

    local newdamage = math.floor(self.MHP * dmgRate / 100)
    local limitDamage = GET_LIMIT_MAX_DAMAGE(self, from, skill);
    if limitDamage > 0 and newdamage > limitDamage then
        newdamage = limitDamage
    end
    
    SetExProp(self, "TwistOfFate_DamageRate", newdamage)
    ret.Damage = newdamage


end



function SCR_SKILL_AFTERCALC_HIT_Corsair_PistolShot(self, from, skill, atk, ret)
    if IS_PC(from) == true then
        local Corsair17_abil = GetAbility(from, "Corsair17")
        if Corsair17_abil ~= nil then
            local list, cnt = SelectObjectNear(from, self, 100, 'ENEMY');
            if cnt >= 1 then
                list = SCR_ARRAY_SHUFFLE(list);
                for i = 1, cnt do
                    if IsSameObject(list[i], self) == 0 then
                        local damage = GET_SKL_DAMAGE(from, list[i], 'Corsair_PistolShot');
                        local abil_ratio = Corsair17_abil.Level * 0.1;
                        
                        damage = damage + (damage * abil_ratio);
                        damage = math.floor(damage);
                        
--                        TakeDamage(from, list[i], 'Corsair_PistolShot', damage);
--                        TakeDamage(from, list[i], 'None', damage, "Melee", "None", "Missile", HIT_MOTION, HITRESULT_BLOW);
--                        local skl = GetNormalSkill(from)
                        if ret.Damage >= 1 then
                            local maxRatio = IMCRandom(1, 100);
                            local ratio = 15
                            if ratio >= maxRatio then
                                SetExProp(self, "IS_TAKE_CRITICAL", 1)
                            end
                        end
                        ForceDamage(from, skill, list[i], self, damage, 'MOTION', 'BLOW', 'I_archer_pistol_atk', 1.0, 'None', 'None', 0.0, 'None', 'SLOW', 500.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0)
                        return
                    end
                end
            end
        end
    end
end


function SCR_SKILL_AFTERCALC_HIT_Bulletmarker_BloodyOverdrive(self, from, skill, atk, ret)
    local abil = GetAbility(from, "Bulletmarker8")
    if abil ~= nil then
        local list, cnt = SelectObjectNear(from, self, 100, 'ENEMY');
        if cnt >= 1 then
            list = SCR_ARRAY_SHUFFLE(list);
            for i = 1, cnt do
                if IsSameObject(list[i], self) == 0 then
                    local damage = GET_SKL_DAMAGE(from, list[i], 'Bulletmarker_BloodyOverdrive');
                    local shuffleRatio = abil.Level * 5
                    
                    if IMCRandom(1, 100) <= shuffleRatio then
                        TakeDamage(from, list[i], "Bulletmarker_BloodyOverdrive", damage, skill.Attribute, skill.AttackType, skill.ClassType, skill.HitType, HITRESULT_BLOW);
                    end
                    
                    return
                end
            end
        end
    end
end

function SCR_SKILL_AFTERCALC_HIT_Bulletmarker_MozambiqueDrill(self, from, skill, atk, ret)
    local abil = GetAbility(from, "Bulletmarker10")
    if abil ~= nil then
        local list, cnt = SelectObjectNear(from, self, 100, 'ENEMY');
        if cnt >= 1 then
            list = SCR_ARRAY_SHUFFLE(list);
            for i = 1, cnt do
                if IsSameObject(list[i], self) == 0 then
                	local damage = ret.Damage
                	
					ForceDamage(from, skill, list[i], self, damage, 'MOTION', 'BLOW', 'I_archer_musket_atk003', 0.5, 'None', 'None', 0.0, 'None', 'SLOW', 500.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0)
					
					return
                end
            end
        end
    end
end

function SCR_SKILL_AFTERCALC_HIT_Dragoon_Dragontooth(self, from, skill, atk, ret)
	local rhWeapon = GetEquipItem(from, "RH")
	if rhWeapon ~= "NoWeapon" and rhWeapon.ClassType == "Spear" then
	    if ret.ResultType == HITRESULT_CRITICAL then
	        ret.Damage = ret.Damage + math.floor(ret.Damage * 0.1);
	    end
	end
end

function SCR_SKILL_AFTERCALC_HIT_Fletcher_CrossFire(self, from, skill, atk, ret)
    local Fletcher5_abil = GetAbility(from, 'Fletcher5');
    if IsBuffApplied(self, "CrossFire_Debuff") == "NO" then
        if Fletcher5_abil ~= nil then
            local damage = ret.Damage * 0.2
            if IMCRandom(0, 9999) < Fletcher5_abil.Level * 1000 then
                AddBuff(from, self, 'CrossFire_Debuff', damage, 0, 6000, 0);
            end
        end
    end
end
