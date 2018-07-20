-- buff_monster_abiliy.lua

function MON_BORN_ATTRIBUTE_Avoidance(self)
    AddBuff(self, self, 'Ability_buff_Avoidance');
end

function MON_BORN_ATTRIBUTE_Antimage(self)
	AddBuff(self, self, 'Ability_buff_Antimage');
end

function MON_BORN_ATTRIBUTE_Antiwarrior(self)
	AddBuff(self, self, 'Ability_buff_Antiwarrior');
end

function MON_BORN_ATTRIBUTE_Explosion(self)
    AddBuff(self, self, 'Ability_buff_Explosion');
end

function MON_BORN_ATTRIBUTE_Immune(self)
    AddBuff(self, self, 'Ability_buff_Immune');
end

function MON_BORN_ATTRIBUTE_Pauldron(self)
    AddBuff(self, self, 'Ability_buff_Pauldron');
end

function MON_BORN_ATTRIBUTE_Shield(self)
    AddBuff(self, self, 'Ability_buff_Shield');
end

function MON_BORN_ATTRIBUTE_attribute(self)
    AddBuff(self, self, 'Ability_buff_attribute');
end

function MON_BORN_ATTRIBUTE_HealFactor(self)
    AddBuff(self, self, 'Ability_buff_HealFactor');
end

function MON_BORN_ATTRIBUTE_SolidStrong(self)
    AddBuff(self, self, 'Ability_buff_SolidStrong');
end

function MON_BORN_ATTRIBUTE_MultipleDEF(self)
    AddBuff(self, self, 'Ability_buff_MultipleDEF');
end

function MON_BORN_ATTRIBUTE_MultipleMDEF(self)
    AddBuff(self, self, 'Ability_buff_MultipleMDEF');
end

function MON_BORN_ATTRIBUTE_SlashDEF(self)
    AddBuff(self, self, 'Ability_buff_SlashDEF');
end

function MON_BORN_ATTRIBUTE_Avoidance2(self)
    AddBuff(self, self, 'Ability_buff_Avoidance2');
end

function MON_BORN_ATTRIBUTE_Berserk(self)
    AddBuff(self, self, 'Ability_buff_Berserk');
end

function MON_BORN_ATTRIBUTE_AntiMissileATK(self)
    AddBuff(self, self, 'Ability_buff_AntiMissileATK');
end

function MON_BORN_ATTRIBUTE_AntiPadATK(self)
    AddBuff(self, self, 'Ability_buff_AntiPadATK');
end

function MON_BORN_ATTRIBUTE_AntiJointpenalty(self)
    AddBuff(self, self, 'Ability_buff_AntiJointpenalty');
end

function MON_BORN_ATTRIBUTE_PC_SummonBoss(self)
    AddBuff(self, self, 'Ability_buff_PC_SummonBoss');
end

function MON_BORN_ATTRIBUTE_PC_Summon(self)
    AddBuff(self, self, 'Ability_buff_PC_Summon');
end

function MON_BORN_FIREFOX_PC_Summon(self)
    AddBuff(self, self, 'Ability_buff_PC_FireFox_Summon');
end

function MON_BORN_ATTRIBUTE_Weakness_Melee(self)
    AddBuff(self, self, 'Ability_Weakness_Melee');
end

function MON_BORN_ATTRIBUTE_Weakness_Missile(self)
    AddBuff(self, self, 'Ability_Weakness_Missile');
end

function MON_BORN_ATTRIBUTE_Weakness_Magic(self)
    AddBuff(self, self, 'Ability_Weakness_Magic');
end
function MON_BORN_DETECTING(self)
    AddBuff(self, self, "Ability_Detecting_Buff")
end

function MON_BORN_ATTRIBUTE_INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS(self)
    AddBuff(self, self, 'INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS');
end

-- Field Boss --
function SCR_FIELD_BOSS_NEAR_ENTER(self, pc)
    AddBuff(self, pc, 'Ability_SoulCrystal_Debuff', 1, 0, 0, 1)
end

function SCR_FIELD_BOSS_NEAR_LEAVE(self, pc)
    RemoveBuff(pc, 'Ability_SoulCrystal_Debuff')
end

function SCR_BUFF_ENTER_Ability_SoulCrystal_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Ability_SoulCrystal_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_GIVEDMG_Ability_SoulCrystal_Debuff(self, buff, sklID, damage, target, ret)
    if IsBuffApplied(self, "Ability_SoulCrystal_Debuff") == "YES" then
        RemoveBuff(self, 'Safe')
    end
    return 1;
end



function SCR_BUFF_ENTER_Ability_buff_Avoidance(self, buff, arg1, arg2, over)
    self.DR_BM = 100;
end

function SCR_BUFF_LEAVE_Ability_buff_Avoidance(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_Ability_buff_Explosion(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_Explosion(self, buff, arg1, arg2, over)
    local objList, objCount = SelectObject(self, 40, 'PC');
     PlayEffect(self, 'F_buff_explosion_burst', 1);
    for i = 1, objCount do
        local obj = objList[i];
        if obj.ClassName == 'PC' then
            local angle = GetAngleTo(self, obj);
            TakeDamage(self, obj, "None", (self.MAXPATK * 1.5) , "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
            KnockBack(obj, self, 150, angle, 60, 1);
        end
    end
end







function SCR_BUFF_ENTER_Ability_buff_Debuff_Immune(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_Debuff_Immun(eself, buff, arg1, arg2, over)
    
end








function SCR_BUFF_ENTER_Ability_buff_Pauldron(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_Pauldron(self, buff, arg1, arg2, over)
end










function SCR_BUFF_ENTER_Ability_buff_Shield(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_Shield(self, buff, arg1, arg2, over)
end








function SCR_BUFF_ENTER_Ability_buff_attribute(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_attribute(self, buff, arg1, arg2, over)
end









function SCR_BUFF_ENTER_Ability_buff_LevelUp(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_LevelUp(self, buff, arg1, arg2, over)
end









function SCR_BUFF_ENTER_Ability_buff_HealFactor(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Ability_buff_HealFactor(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.HP < self.MHP then
        Heal(self, self.MHP/20, 0);
    end
    return 1;
end

function SCR_BUFF_LEAVE_Ability_buff_HealFactor(self, buff, arg1, arg2, over)
end



function SCR_BUFF_ENTER_Ability_buff_MultipleDEF(self, buff, arg1, arg2, over)
    local ADDDEF = self.DEF * 3;
    local ADDMDEF = self.MDEF * 0.5;
    SetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_DEF", ADDDEF);
    SetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_MDEF", ADDMDEF)
    self.DEF_BM = self.DEF_BM + ADDDEF;
    self.MDEF_BM = self.MDEF_BM - ADDMDEF;
end


function SCR_BUFF_LEAVE_Ability_buff_MultipleDEF(self, buff, arg1, arg2, over)
    local ADDDEF = GetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_DEF");
    local ADDMDEF = GetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_MDEF");
    self.DEF_BM = self.DEF_BM - ADDDEF;     
    self.MDEF_BM = self.MDEF_BM + ADDMDEF;
end





function SCR_BUFF_ENTER_Ability_buff_MultipleMDEF(self, buff, arg1, arg2, over)
    local ADDDEF = self.DEF * 0.5;
    local ADDMDEF = self.MDEF * 3;
    SetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_DEF", ADDDEF);
    SetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_MDEF", ADDMDEF);
    self.DEF_BM = self.DEF_BM - ADDDEF;
    self.MDEF_BM = self.MDEF_BM + ADDMDEF;
end


function SCR_BUFF_LEAVE_Ability_buff_MultipleMDEF(self, buff, arg1, arg2, over)
    local ADDDEF = GetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_DEF");
    local ADDMDEF = GetExProp(buff, "ABILITY_BUFF_MULTIPLE_ADD_MDEF");
    self.DEF_BM = self.DEF_BM + ADDDEF;
    self.MDEF_BM = self.MDEF_BM - ADDMDEF;      
end






-- 8 Rank Monster Buff set --
function SCR_BUFF_ENTER_Ability_buff_Avoidance2(self, buff, arg1, arg2, over)
    local ADD_DR = math.floor(self.DR * 1.0);
    
    SetExProp(buff, "ABILITY_BUFF_AVOIDANCE_ADD_DR", ADD_DR);
    
    self.DR_BM = self.DR_BM + ADD_DR;
end

function SCR_BUFF_LEAVE_Ability_buff_Avoidance2(self, buff, arg1, arg2, over)
    local ADD_DR = GetExProp(buff, "ABILITY_BUFF_AVOIDANCE_ADD_DR");
    
    self.DR_BM = self.DR_BM - ADD_DR;
end



function SCR_BUFF_ENTER_Ability_buff_Berserk(self, buff, arg1, arg2, over)
    local ADD_CRTDR = 500;
--    local ADD_DEF = -0.2;
--    local ADD_ATK = 0.2;
    
    SetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_CRTDR", ADD_CRTDR);
--    SetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_DEF", ADD_DEF);
--    SetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_ATK", ADD_ATK);
    
    self.CRTDR_BM = self.CRTDR_BM - ADD_CRTDR;
--    self.DEF_RATE_BM = self.DEF_RATE_BM + ADD_DEF;
--    self.PATK_RATE_BM = self.PATK_RATE_BM + ADD_ATK;
end

function SCR_BUFF_LEAVE_Ability_buff_Berserk(self, buff, arg1, arg2, over)
    local ADD_CRTDR = GetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_CRTDR");
--    local ADD_DEF = GetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_DEF");
--    local ADD_ATK = GetExProp(buff, "ABILITY_BUFF_BERSERK_ADD_ATK");
    
    self.CRTDR_BM = self.CRTDR_BM + ADD_CRTDR;
--    self.DEF_RATE_BM = self.DEF_RATE_BM - ADD_DEF;
--    self.PATK_RATE_BM = self.PATK_RATE_BM - ADD_ATK;
end

function SCR_BUFF_RATETABLE_Ability_buff_Berserk(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_buff_Berserk') == 'YES' then
        rateTable.DamageRate = 1;
    end
    
    if IsBuffApplied(from, 'Ability_buff_Berserk') == 'YES' then
        rateTable.DamageRate = 1;
    end
end



function SCR_BUFF_ENTER_Ability_buff_AntiMissileATK(self, buff, arg1, arg2, over)
    SetExProp(buff, "ATTACKED_COUNT", 5);
end

function SCR_BUFF_LEAVE_Ability_buff_AntiMissileATK(self, buff, arg1, arg2, over)

end

function SCR_BUFF_AFTERCALC_HIT_Ability_buff_AntiMissileATK(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Ability_buff_AntiMissileATK') == 'YES' and (skill.HitType == 'Force' or skill.ClassType == 'Missile') then
        ret.KDPower = 0;
        ret.HitType = HIT_SAFETY;
        ret.HitDelay = 0;
        ret.Damage = 1;
    end
end

function SCR_BUFF_TAKEDMG_Ability_buff_AntiMissileATK(self, buff, sklID, damage, attacker)

    if damage < 0 then
        return 1;
    end
    
    local skill = GetClassByType("Skill", sklID);
    if IsBuffApplied(self, 'Ability_buff_AntiMissileATK') == 'YES' and (skill.HitType == 'Force' or skill.ClassType == 'Missile') then
        local attackedCount = tonumber( GetExProp(buff, "ATTACKED_COUNT") ) - 1;
        SetExProp(buff, "ATTACKED_COUNT", attackedCount);
        
        if attackedCount <= 0 then
            return 0;
        end
    end

    return 1;
end



function SCR_BUFF_ENTER_Ability_buff_AntiPadATK(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Ability_buff_AntiPadATK(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_AFTERCALC_HIT_Ability_buff_AntiPadATK(self, from, skill, atk, ret, buff)
--    if IsBuffApplied(self, 'Ability_buff_AntiPadATK') == 'YES' then    
--        local x, y, z = GetPos(self)
--        local padList = SelectPad(self, skill.ClassName, x, y, z, 40)
--        if #padList >= 1 then
--            for i = 1, #padList do
--                if IsSameActor(GetPadOwner(padList[i]), from) == 'YES' then
--                    ret.Damage = math.floor(ret.Damage * 0.5);
--                    return;
--                end
--            end
--        end
--
--        if skill.ClassType == 'Missile' then
--            ret.Damage = math.floor(ret.Damage * 1.5);
--        end
--    end
end



function SCR_BUFF_ENTER_Ability_buff_AntiJointpenalty(self, buff, arg1, arg2, over)
    SetExProp(buff, "ATTACKED_COUNT", 3);
end

function SCR_BUFF_LEAVE_Ability_buff_AntiJointpenalty(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_AFTERCALC_HIT_Ability_buff_AntiJointpenalty(self, from, skill, atk, ret, buff)
    if IsBuffApplied(self, 'Ability_buff_AntiJointpenalty') == 'YES' and IsBuffApplied(self, 'Link_Enemy') == 'YES' then    
        ret.Damage = math.floor(ret.Damage * 1.5);
    end
end

function SCR_BUFF_TAKEDMG_Ability_buff_AntiJointpenalty(self, buff, sklID, damage, attacker)
    if damage < 0 then
        return 1;
    end
    
    if IsBuffApplied(self, 'Ability_buff_AntiJointpenalty') == 'YES' and IsBuffApplied(self, 'Link_Enemy') == 'YES' then
        local attackedCount = tonumber( GetExProp(buff, "ATTACKED_COUNT") ) - 1;
        SetExProp(buff, "ATTACKED_COUNT", attackedCount);
        
        if attackedCount <= 0 then
            local buffLink = GetBuffByName(self, 'Link_Enemy')
            local buffCaster = GetBuffCaster(buffLink);
            if buffCaster ~= nil then
                RemoveLinkByBuffName(buffCaster, 'Link_Enemy')
                SetExProp(buff, "ATTACKED_COUNT", 3);
            end
        end
    end
    
    return 1;
end

function SCR_PC_FireFox_Summon_ENTER(self, buff, arg1, arg2, over)
    local myOwner = nil;
    for i = 1, 10 do
        sleep(100)
        if GetOwner(self) ~= nil then
            myOwner = GetOwner(self)
        end
    end
    
    local selfMATK = (TryGetProp(self, "MINMATK") + TryGetProp(self, "MAXMATK")) / 2
    local ownerMATK = SCR_GET_PC_ATK(myOwner, "Magic") - selfMATK
    
    self.MATK_BM = self.MATK_BM + ownerMATK
    
    SetExProp(buff, "FIREFOX_MATK", ownerMATK)
    
    Invalidate(self, "MINMATK");
    Invalidate(self, "MAXMATK");
end

function SCR_PC_FireFox_Summon_LEAVE(self, buff, arg1, arg2, over)
    local ownerMATK = GetExProp(buff, "FIREFOX_MATK")
    
    self.MATK_BM = self.MATK_BM - ownerMATK
end

function SCR_PC_FireFox_Summon_RATETABLE(self, from, skill, atk, ret, rateTable, buff)
    
end


function SCR_PC_Summon_ENTER(self, buff, arg1, arg2, over)
    local myOwner = nil;
    for i = 1, 10 do
        sleep(100)
        if GetOwner(self) ~= nil then
            myOwner = GetOwner(self)
        end
    end
    
    local addFactorRate = 0;
    local addCON = 0;
    if myOwner ~= nil then
        if myOwner.ClassName == 'PC' then
            local ownerLv = TryGetProp(myOwner, "Lv");
            if ownerLv == nil then
                ownerLv = 1;
            end
            
            local ownerMNA = TryGetProp(myOwner, "MNA");
            if ownerMNA == nil then
                ownerMNA = 1;
            end
            
            addFactorRate = math.floor((ownerMNA / (ownerLv + 1)) * 100);
            if addFactorRate < 0 then
                addFactorRate = 0;
            end
            
            addFactorRate = addFactorRate / 100;
            
            addCON = math.floor(addCON + (ownerMNA * 0.75));
        end
    end
    
    self.SkillFactorRate_RATE_BM = self.SkillFactorRate_RATE_BM + addFactorRate;
    self.CON_BM = self.CON_BM + addCON;
    
    SetExProp(buff, "ADD_FACTOR_RATE", addFactorRate);
    SetExProp(buff, "ADD_CON", addCON);
    
    Invalidate(self, "SkillFactorRate");
    Invalidate(self, "CON");
    
    Invalidate(self, "MHP");
    AddHP(self, self.MHP);
end

function SCR_PC_Summon_LEAVE(self, buff, arg1, arg2, over)
    local addFactorRate = GetExProp(buff, "ADD_FACTOR_RATE");
    local addCON = GetExProp(buff, "ADD_CON");
    
    self.SkillFactorRate_RATE_BM = self.SkillFactorRate_RATE_BM - addFactorRate;
    self.CON_BM = self.CON_BM - addCON;
end

function SCR_PC_Summon_RATETABLE(self, from, skill, atk, ret, rateTable, buff)
    local equipRatio = 0;
    if IsBuffApplied(from, 'Ability_buff_PC_SummonBoss') == 'YES' then
        equipRatio = 1.0;
    end
    
    if IsBuffApplied(from, 'Ability_buff_PC_Summon') == 'YES' then
        equipRatio = 0.5;
    end
    
    if equipRatio ~= 0 then
        local itemMATK = 0;
        local owner = GetOwner(from)
        if owner ~= nil then
            if owner.ClassName == "PC" then
                local rItem = GetEquipItem(owner, 'RH');
                if rItem ~= nil then
                    itemMATK = math.floor(rItem.MATK * equipRatio);
                end
                
--                rateTable.AddTrueDamage = rateTable.AddTrueDamage + itemMATK;
                
                rateTable.AddAtkDamage = rateTable.AddAtkDamage + itemMATK;
--                rateTable.AddDefence = rateTable.AddDefence + itemDEF;
            end
        end
    end
end



function SCR_BUFF_ENTER_Ability_buff_PC_SummonBoss(self, buff, arg1, arg2, over)
--    SCR_PC_Summon_ENTER(self, buff, arg1, arg2, over);
    RunScript("SCR_PC_Summon_ENTER", self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_PC_SummonBoss(self, buff, arg1, arg2, over)
    SCR_PC_Summon_LEAVE(self, buff, arg1, arg2, over);
end

function SCR_BUFF_RATETABLE_Ability_buff_PC_SummonBoss(self, from, skill, atk, ret, rateTable, buff)
    SCR_PC_Summon_RATETABLE(self, from, skill, atk, ret, rateTable, buff)
end


function SCR_BUFF_ENTER_Ability_buff_PC_FireFox_Summon(self, buff, arg1, arg2, over)
--    SCR_PC_Summon_ENTER(self, buff, arg1, arg2, over);
    RunScript("SCR_PC_FireFox_Summon_ENTER", self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_PC_FireFox_Summon(self, buff, arg1, arg2, over)
    SCR_PC_FireFox_Summon_LEAVE(self, buff, arg1, arg2, over);
end

function SCR_BUFF_RATETABLE_Ability_buff_PC_FireFox_Summon(self, from, skill, atk, ret, rateTable, buff)
    SCR_PC_FireFox_Summon_RATETABLE(self, from, skill, atk, ret, rateTable, buff)
end



function SCR_BUFF_ENTER_Ability_buff_PC_Summon(self, buff, arg1, arg2, over)
--    SCR_PC_Summon_ENTER(self, buff, arg1, arg2, over);
    RunScript("SCR_PC_Summon_ENTER", self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Ability_buff_PC_Summon(self, buff, arg1, arg2, over)
    SCR_PC_Summon_LEAVE(self, buff, arg1, arg2, over);
end

function SCR_BUFF_RATETABLE_Ability_buff_PC_Summon(self, from, skill, atk, ret, rateTable, buff)
    SCR_PC_Summon_RATETABLE(self, from, skill, atk, ret, rateTable, buff)
end



--boss Weakness buff
function SCR_BUFF_ENTER_Ability_Weakness_Melee(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_LEAVE_Ability_Weakness_Melee(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_RATETABLE_Ability_Weakness_Melee(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Melee') == 'YES' then
        local classType = TryGetProp(skill, 'ClassType');
        if classType == 'Melee' then
            rateTable.DamageRate = rateTable.DamageRate + 0.15;
        end
    end
end



function SCR_BUFF_ENTER_Ability_Weakness_Missile(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_LEAVE_Ability_Weakness_Missile(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_RATETABLE_Ability_Weakness_Missile(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Missile') == 'YES' then
        local classType = TryGetProp(skill, 'ClassType');
        if classType == 'Missile' then
            rateTable.DamageRate = rateTable.DamageRate + 0.15;
        end
    end
end


function SCR_BUFF_ENTER_Ability_Weakness_Magic(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_LEAVE_Ability_Weakness_Magic(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_RATETABLE_Ability_Weakness_Magic(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Magic') == 'YES' then
        local classType = TryGetProp(skill, 'ClassType');
        if classType == 'Magic' then
            rateTable.DamageRate = rateTable.DamageRate + 0.15;
        end
    end
end


function SCR_BUFF_ENTER_Ability_Detecting_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_Ability_Detecting_Buff(self, buff, arg1, arg2, over)
    local fndList, fndCount = SelectObject(self, 100, 'ENEMY', 1, 1)
    if fndCount ~= nil then
        for i = 1, fndCount do
            if IsBuffApplied(fndList[i], "UC_Detected_Debuff") ~= 'YES' then
                AddBuff(fndList[i], fndList[i], 'UC_Detected_Debuff',1,1,10000)
            end
            if IsBuffApplied(fndList[i], "Cloaking_Buff") == 'YES' or IsBuffApplied(fndList[i], "Burrow_Rogue") == 'YES' then
                RemoveBuff(fndList[i], "Cloaking_Buff")
                RemoveBuff(fndList[i], "Burrow_Rogue")
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Ability_Detecting_Buff(self, buff, arg1, arg2, over)

end
