--- calc_property_skill.lua
function GET_SKL_VALUE(skill, startValue, maxValue)
    local maxLv = 100;
    local curLv = skill.Level;
    local rate = curLv / maxLv;
    rate = math.pow(rate, 0.7);
    return startValue + rate * (maxValue - startValue);
end

function SCR_GET_SKL_ATK(skill)

    local value = skill.SklATKValue;
    local propvalue = GetClassNumber('SklRankUp', skill.ATKRankType, 'IncreaseValue');
    value = value + skill.SklATK_BM * propvalue;
    return value;
    
end

function SCR_GET_SKL_CastTime(skill)

    local value = skill.CastTimeValue;
    value = value + skill.CastTime_BM;
    return value;

end

function SCR_GET_SKL_CoolDown(skill)
    local cls = GetClassList("SkillRestrict");
    local pc = GetSkillOwner(skill);
    
    local sklCls = GetClassByNameFromList(cls, skill.ClassName);
    local coolDownClassify = nil;
    local zoneAddCoolDown = 0;
    
    if sklCls ~= nil then
        local isKeyword = TryGetProp(sklCls, "Keyword", nil)
        if IsRaidField(pc) == 1 then
            if string.find(isKeyword, "IsRaidField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "Raid_CoolDown", nil)
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        elseif IsPVPField(pc) == 1 then
            if string.find(isKeyword, "IsPVPField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "PVP_CoolDown", nil)
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        end
    end
    
    local value = skill.CoolDownValue;
    local propvalue = GetClassNumber('SklRankUp', skill.CoolDownRankType, 'IncreaseValue');
    value = value + skill.CoolDown_BM * propvalue;
    
    if coolDownClassify == "Fix" then
        value = zoneAddCoolDown;
    elseif coolDownClassify == "Add" then
        value = zoneAddCoolDown + value
    end
    
    return value;

end

function SCR_Get_SpendSP_Dargoon(skill)
    local value = SCR_Get_SpendSP(skill)
    local pc = GetSkillOwner(skill);
    
    if value < 1 then
        value = 0
    end
    
    local addValue = 1
    local pcLevel = TryGetProp(pc, "Lv", 1)
    local mnaRate = TryGetProp(pc, "MNA", 1)    
    
    if IsBuffApplied(pc, "DragoonHelmet_Buff") == "YES" then
        addValue = 2
        addValue = addValue - math.min(0.5, mnaRate / pcLevel)
        value = math.floor(value * addValue)        
    elseif IsBuffApplied(pc, "DragoonHelmet_Abil_Buff") == "YES" then
        addValue = 1.5
        addValue = addValue - math.min(0.5, mnaRate / pcLevel)
        value = math.floor(value * addValue)
    end
    
    return math.floor(value);
end

function SCR_Get_SpendSP_BUNSIN(skill)
    local value = SCR_Get_SpendSP(skill)
--    local basicsp = skill.BasicSP;
--    local lv = skill.Level;
--    local addsp = skill.LvUpSpendSp;
--    local decsp = 0;
--    
--    if basicsp == 0 then
--        return 0;
--    end
--    
    local pc = GetSkillOwner(skill);
--    local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
--    abilAddSP = abilAddSP / 100;
--    
--  local value = basicsp + (lv - 1) * addsp + abilAddSP;
--  local value = basicsp + (lv - 1) * addsp
    
--    local GHabil =  GetAbility(pc, 'Remain')
--    if GHabil ~= nil then 
--        value = value + (value * (GHabil.Level * 0.1))
--    end
--    
--    value = value + (value * abilAddSP);
--    local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
--    if zeminaLv > 0 then
--        decsp = 4 + (zeminaLv * 4);
--    end
--    value = value - decsp;
    
    if value < 1 then
        value = 0
    end
    
    if IsBuffApplied(pc, "Bunshin_Debuff") == "YES" then
        local Bunshin = GetSkill(pc, 'Shinobi_Bunshin_no_jutsu')
        
        value = value + (value * (Bunshin.Level * 0.1))
    end
    
    return math.floor(value);
end


function SCR_Get_SpendSP(skill)
    local basicSP = skill.BasicSP;
--    local lv = skill.Level;
--    local lvUpSpendSp = skill.LvUpSpendSp;
    local decsp = 0;
    local bylvCorrect = 0
    
    if basicSP == 0 then
        return 0;
    end

    local pc = GetSkillOwner(skill);
    local lv = pc.Lv
    bylvCorrect = lv - 300

    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end

    local value = basicSP * (1 + bylvCorrect)
    
    local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
    abilAddSP = abilAddSP / 100;
    
--    local lvUpSpendSpRound = math.floor((lvUpSpendSp * 10000) + 0.5)/10000;

--  value = basicsp + (lv - 1) * lvUpSpendSpRound + abilAddSP;
--  value = basicsp + (lv - 1) * lvUpSpendSpRound;
    value = math.floor(value) + math.floor(value * abilAddSP);
    
    local zeminaSP = GetExProp(pc, "ZEMINA_BUFF_SP");
    if zeminaSP ~= 0 then
        decsp = value * zeminaSP
    end
    value = value - decsp;
    
    if IsBuffApplied(pc, "Gymas_Buff") == "YES" then
        local ratio = 0.25;
        
        local isDragonPower = GetExProp(pc, 'ITEM_DRAGON_POWER')
        if tonumber(isDragonPower) >= 1 then
            ratio = ratio + 0.25
        end
        
        decsp = value * ratio
    end
    value = value - decsp;
    
    if value < 1 then
        value = 0
    end
    
    if skill.ClassName == "Scout_Cloaking" and IsBattleState(pc) == 1 and (IsPVPServer(pc) == 1 or IsPVPField(pc) == 1) then
        return 0
    end
    
    return math.floor(value);
end

function SCR_Get_SpendSP_Magic(skill)
    local value = SCR_Get_SpendSP(skill)    
--    local basicsp = skill.BasicSP;
--    local lv = skill.Level;
--    local lvUpSpendSp = skill.LvUpSpendSp;
--    local decsp = 0;
--    
--    if basicsp == 0 then
--        return 0;
--    end
--    
    local pc = GetSkillOwner(skill);

    if pc == nil then
        return math.floor(value);
    end
--
--    local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
--    abilAddSP = abilAddSP / 100;
--    
--    local value = basicsp + (lv - 1) * lvUpSpendSp + abilAddSP;
--    local value = basicsp + (lv - 1) * lvUpSpendSp;
    
    if IsBuffApplied(pc, 'Wizard_Wild_buff') == 'YES' then
        value = value * 1.5 * spRatio;
        return math.floor(value);
    end
    
    if IsBuffApplied(pc, 'MalleusMaleficarum_Debuff') == 'YES' then
        value = value * 2
        return math.floor(value);
    end
    
    if TryGetProp(skill, "ClassName", "None") == "Cleric_Heal" then
        local jobHistory = '';
        if IsServerObj(pc) == 1 then
            if IS_PC(pc) == true then
                jobHistory = GetJobHistoryString(pc);
            end
        else
            jobHistory = GetMyJobHistoryString();
        end
        
        if jobHistory ~= nil and string.find(jobHistory, "Char4_2") ~= nil then
            value = value - 25
        end
        
        if jobHistory ~= nil and string.find(jobHistory, "Char4_10") ~= nil then
            value = value - 50
        end
    end
    
--    value = value + (value * abilAddSP);
--    
--    local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
--    if zeminaLv > 0 then
--        decsp = 4 + (zeminaLv * 4);
--    end
--    value = value - decsp;
    
    if value < 1 then
        value = 0
    end
    if IsBuffApplied(pc, 'ShadowPool_Buff') == 'YES' and skill.ClassName == "Shadowmancer_ShadowPool" then
        value = 0;
    end
    
    if skill.ClassName == "Oracle_TwistOfFate" and 
        (GetZoneName(pc) == "guild_agit_1" or GetZoneName(pc) == "guild_agit_extension") then
        return 0
    end
    
    return math.floor(value);
end

function SCR_Get_SpendSP_EnableCompanion_Warrior(skill)
    local value = SCR_Get_SpendSP(skill)
    local pc = GetSkillOwner(skill)
    
    if value < 1 then
    value = 0
    end
    
    if IsBuffApplied(pc, "AcrobaticMount_Buff") == "YES" then
        if TryGetProp(skill, "EnableCompanion") == "YES" and TryGetProp(skill, "ValueType") == "Attack" then            
            if IsServerSection() == 1 then                
                local acrobaticBuff = GetBuffByName(pc, "AcrobaticMount_Buff")
                local acrobaticBuffLevel = GetBuffArg(acrobaticBuff)
                local acrobaticAddSPRate = acrobaticBuffLevel * 0.05
                value = value *(1 + acrobaticAddSPRate)
                SetExProp(acrobaticBuff, "ACROBATICMOUNT_SPENDSP", math.floor(value));
            else                
                local acrobaticBuff = GET_BUFF_BY_NAME_C("AcrobaticMount_Buff");
                local acrobaticBuffLevel = acrobaticBuff.arg1;
                local acrobaticAddSPRate = acrobaticBuffLevel * 0.05
                value = value *(1 + acrobaticAddSPRate)
            end
        end
    end

    return math.floor(value)
end

function SCR_Get_SpendSP_FanaticIllusion(skill)

    local basicSP = 25;
--    local lv = skill.Level;
--    local lvUpSpendSp = 4;
    local decsp = 0;
    local bylvCorrect = 0 
    
    if basicsp == 0 then
        return 0;
    end
    
    local pc = GetSkillOwner(skill);
    local lv = pc.Lv
    bylvCorrect = lv - 300

    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end

    local value = basicSP * (1 + bylvCorrect)

    local abilAddSP = GetAbilityAddSpendValue(pc, skill.ClassName, "SP");
    abilAddSP = abilAddSP / 100;
    
--  local value = basicsp + (lv - 1) * lvUpSpendSp + abilAddSP;
--    local value = basicsp + (lv - 1) * lvUpSpendSp;
    
    if IsBuffApplied(pc, 'Wizard_Wild_buff') == 'YES' then
        value = value * 1.5 * spRatio;
        return math.floor(value);
    end
    
    if IsBuffApplied(pc, 'MalleusMaleficarum_Debuff') == 'YES' then
        value = value * 2
        return math.floor(value);
    end    
    
    value = value + (value * abilAddSP);
    
    local zeminaLv = GetExProp(pc, "ZEMINA_BUFF_LV");
    if zeminaLv > 0 then
        decsp = 4 + (zeminaLv * 4);
    end
    value = value - decsp;
    
    if value < 1 then
        value = 0
    end
    
    return math.floor(value);
end

function SCR_Get_SpendPoison(skill)

    local lv = skill.Level;
    local lvUpSpendPoison = skill.LvUpSpendPoison;
    local basicsp = skill.BasicPoison + lvUpSpendPoison * (lv - 1);
    
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "SavePoison")
    if abil ~= nil then 
        basicsp = basicsp - (basicsp * (abil.Level * 0.01))
    end
    
    if basicsp == 0 then
        return 0;
    end
    
    return math.floor(basicsp)

end

function SCR_Skill_STA(skill)
    local basicsta = skill.BasicSta;
    if basicsta == 0 then
        return 0;
    end

    local pc = GetSkillOwner(skill);
    return basicsta * 1000;
end

function SCR_Skill_SubweaponCancel_STA(skill)
    local basicsta = skill.BasicSta;
    if basicsta == 0 then
        return 0;
    end

    local pc = GetSkillOwner(skill);
    local jolly = GetSkill(pc, 'Corsair_JollyRoger')
    if jolly ~= nil and IsBuffApplied(pc, 'JollyRoger_Buff') == 'YES' then
        basicsta = basicsta - (basicsta * (jolly.Level * 0.05))
    end
    return basicsta * 1000
end

function SCR_Skill_DoublePunch_STA(skill)

    local basicsta = skill.BasicSta;
    if basicsta == 0 then
        return 0;
    end

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Monk10')
    if abil ~= nil and abil.ActiveState == 1 then
        local random = IMCRandom(1,100);
        if random >= 51 then
            basicsta = basicsta / 2
        else
            return basicsta * 1000;
        end
    end
    return basicsta * 1000;
end

function SCR_GET_SKL_CAST(skill)

    local pc = GetSkillOwner(skill);
    local basicCast = skill.BasicCast;
    if basicCast == 0 then
        return 0;
    end
    return basicCast * (100 - pc.SPEED_BM) / 100;

end

function SCR_GET_BonusSkilDam(skill)

    return skill.BonusDam;

end

function SCR_GET_SKL_CAST_ABIL(skill)

    local basicCast = skill.BasicCast;
    return basicCast;

end

function SCR_GET_SKL_READY(skill)

    local pc = GetSkillOwner(skill);
    local stnTime = GetStanceReadyTime(pc);
    local sklFix = skill.ReadyFix;
    local byItem = GetSumOfEquipItem(pc, "ReadyFix");
    local resultValue = stnTime + sklFix + byItem;
    resultValue = resultValue * skill.SkillASPD;
    
    return math.max(0, resultValue);

end

function SCR_GET_SKL_READY_ARC(skill)

    local pc = GetSkillOwner(skill);
    local stnTime = GetStanceReadyTime(pc);
    local sklFix = skill.ReadyFix;
    local resultValue = stnTime + sklFix;

    return math.max(0, resultValue);

end

function SCR_GET_SKL_HITCOUNT(skill)

    return skill.SklHitCount;

end

function SCR_GET_SKL_HITCOUNT_BOW(skill)

    local pc = GetSkillOwner(skill);
    local rItem  = GetEquipItem(pc, 'RH');
    local weaponType = rItem.ClassType;

    if weaponType == 'Bow' then
        if rItem.ArrowCount ~= 0 then
            return rItem.ArrowCount;
        end
    end

    return skill.SklHitCount;
end   

function SCR_GET_SKL_READY_RF(skill)

    local pc = GetSkillOwner(skill);
    local stnTime = GetStanceReadyTime(pc);
    local sklFix = skill.ReadyFix;
    local resultValue = stnTime + sklFix + pc.ASPD;

    return math.max(0, resultValue);

end

function SCR_GET_SKL_COOLDOWN(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local cls = GetClassList("SkillRestrict");
    local sklCls = GetClassByNameFromList(cls, skill.ClassName);
    local coolDownClassify = nil;
    local zoneAddCoolDown = 0;
    
    if sklCls ~= nil then
        local isKeyword = TryGetProp(sklCls, "Keyword", nil)
        if IsRaidField(pc) == 1 then
            if string.find(isKeyword, "IsRaidField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "Raid_CoolDown", nil)
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        elseif IsPVPField(pc) == 1 then
            if string.find(isKeyword, "IsPVPField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "PVP_CoolDown", nil)
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        end
    end
    
    if skill.ClassName == "Cleric_Heal" then
        if IsPVPServer(pc) == 1 then
            basicCoolDown = basicCoolDown + 28000
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    
    if coolDownClassify == "Fix" then
        ret = zoneAddCoolDown;
    elseif coolDownClassify == "Add" then
        ret = zoneAddCoolDown + ret
    end
    
    return math.floor(ret);
end

function SCR_GET_SKL_COOLDOWN_KaguraDance(skill)
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown - ((TryGetProp(skill, "Level", 0) - 1) * 5000);
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    return math.floor(ret);    
end


function SCR_GET_SKL_COOLDOWN_BUNSIN(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    if skill.ClassName == "Cleric_Heal" then
        if IsPVPServer(pc) == 1 then
            basicCoolDown = basicCoolDown + 28000
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    if IsBuffApplied(pc, "Bunshin_Debuff") == "YES" then
--      local bunshinBuff = nil
--      local bunsinCount = nil
--      if IsServerObj(pc) == 1 then
--          bunshinBuff = GetBuffByName(pc, "Bunshin_Debuff")
--          bunsinCount = GetBuffArg(bunshinBuff)
--      else 
--          local handle = session.GetMyHandle();
--          bunshinBuff = info.GetBuff(handle, 3049)
--          bunsinCount = bunshinBuff.arg1
--      end
--        local Bunshin = GetSkill(pc, 'Shinobi_Bunshin_no_jutsu')
        local bunsinCount = GET_BUNSIN_COUNT(pc);

        basicCoolDown = basicCoolDown + (bunsinCount * 2000 + (basicCoolDown * (bunsinCount * 0.1)))
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    return math.floor(ret);
end


function SCR_GET_SKL_COOLDOWN_PrimeAndLoad(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local abilMusketeer29 = GetAbility(pc, "Musketeer29")
    if abilMusketeer29 ~= nil and abilMusketeer29.ActiveState == 1 then
        basicCoolDown = basicCoolDown - (abilMusketeer29.Level * 1000);
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;   
    return math.floor(ret);

end

function SCR_GET_SKL_COOLDOWN_CounterSpell(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown  - (skill.Level * 1000);
    
    if skill.ClassName == "Cleric_Heal" then
        if IsPVPServer(pc) == 1 then
            basicCoolDown = basicCoolDown + 28000
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    
    ret = math.floor(ret) * 1000;
    
    return math.floor(ret);
end

function SCR_GET_SKL_COOLDOWN_ABIL(skill)

    local basicCoolDown = skill.BasicCoolDown;
    return basicCoolDown;

end

function SCR_GET_SKL_CoolDown_BackSlide(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = (basicCoolDown + abilAddCoolDown) - (skill.Level * 1000);
    
    if skill.ClassName == "Cleric_Heal" then
        if IsPVPServer(pc) == 1 then
            basicCoolDown = basicCoolDown + 28000
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    
    return math.floor(ret);
end

function SCR_GET_SKL_CoolDown_Prevent(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = (basicCoolDown + abilAddCoolDown) - (skill.Level * 3000);
    
    if skill.ClassName == "Cleric_Heal" then
        if IsPVPServer(pc) == 1 then
            basicCoolDown = basicCoolDown + 28000
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    
    return math.floor(ret);
end

function SCR_GET_SKL_COOLDOWN_MISTWIND(skill)

    local basicCoolDown = skill.BasicCoolDown;
    local pc = GetSkillOwner(skill);
    
    basicCoolDown = basicCoolDown - 100 * pc.INT;
    
    if pc.MistWind_BM > 0 then
        return basicCoolDown * (100 - pc.MistWind_BM) / 100;
    end
    
    if basicCoolDown < skill.MinCoolDown then
        return skill.MinCoolDown;
    end

    return basicCoolDown;

end

function SCR_GET_SKL_COOLDOWN_Golden_Bell_Shield(skill)
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    basicCoolDown = basicCoolDown - (skill.Level * 1000);
    if basicCoolDown < 0 then
        basicCoolDown = 0;
    end
    
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsPVPServer(pc) == 1 then
        basicCoolDown = basicCoolDown + 10000;
    end

    return math.floor(basicCoolDown);
end

function SCR_GET_SKL_COOLDOWN_VisibleTalent(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown  - ((skill.Level - 1) * 1000);
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    
    ret = math.floor(ret) * 1000;
    
    return math.floor(ret);
end


function SCR_GET_SKL_COOLDOWN_Chronomancer_Stop(skill)
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown  - ((skill.Level - 1) * 5000);
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    
    ret = math.floor(ret) * 1000;
    
    return math.floor(ret);
end

function SCR_GET_SKL_COOLDOWN_WIZARD(skill)
    local cls = GetClassList("SkillRestrict");
    local pc = GetSkillOwner(skill);
    
    local sklCls = GetClassByNameFromList(cls, "Thaumaturge_Reversi");
    local coolDownClassify = nil
    local zoneAddCoolDown = 0;
    
    if sklCls ~= nil then
        local isMap = TryGetProp(sklCls, "Keyword", nil)
        if IsRaidField(pc) == 1 then
            if string.find(isMap, "IsRaidField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "Raid_CoolDown")
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        elseif IsPVPField(pc) == 1 then
            if string.find(isMap, "IsPVPField") == 1 then
                local addCoolDown = TryGetProp(sklCls, "Raid_CoolDown")
                addCoolDown = StringSplit(addCoolDown, "/");
                coolDownClassify, zoneAddCoolDown = addCoolDown[1], addCoolDown[2]
            end
        end
    end
    
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if basicCoolDown < skill.MinCoolDown then
        return skill.MinCoolDown;
    end
    
    if coolDownClassify == "FIX" then
        basicCoolDown = zoneAddCoolDown;
    elseif coolDownClassify == "Add" then
        basicCoolDown = zoneAddCoolDown + basicCoolDown
    end
    
    return basicCoolDown;
end

function SCR_GET_SKL_COOLDOWN_SummonFamiliar(skill)

    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if basicCoolDown < skill.MinCoolDown then
        return skill.MinCoolDown;
    end
    
    basicCoolDown = basicCoolDown - (skill.Level * 1000)
    
    return basicCoolDown;
end

function SCR_GET_SKL_COOLDOWN_Bloodletting(skill)

    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    if IsPVPServer(pc) == 1 then
        basicCoolDown = basicCoolDown + 20000;
    end

    return math.floor(basicCoolDown);

end

function SCR_GET_SKL_COOLDOWN_HealingFactor(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    if IsPVPServer(pc) == 1 then
        basicCoolDown = basicCoolDown + 20000;
    end 

    return math.floor(basicCoolDown);
    
end

function SCR_GET_SKL_COOLDOWN_GravityPole(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsPVPServer(pc) == 1 then
        basicCoolDown = basicCoolDown + 15000;
    end 

    return math.floor(basicCoolDown);
    
end

function SCR_Get_WaveLength(skill)

    local pc = GetSkillOwner(skill);
    local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "WaveLength");
    if overWriteExist == 1.0 then
        return overWritedValue;
    end 
    
    local waveLength = skill.SklWaveLength;
    if skill.SplType == "Square" then
        waveLength = waveLength + pc.SkillRange + TryGet(pc, skill.AttackType .. "_Range");
    end
    
    return waveLength;  

end

function SCR_Get_Skl_SR(skill)

    local sklSR = skill.SklSR;
    local pc = GetSkillOwner(skill);
    local sumValue = GetSumValueByItem(pc, skill, "SR");
    return sklSR + sumValue;
        
end

function SCR_SPLANGLE(skill)

    local pc = GetSkillOwner(skill);
    local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "SplAngle");
    if overWriteExist == 1.0 then
        return overWritedValue;
    end
    
    local splType = skill.SplType;
    if splType ~= "Fan" then
        return skill.SklSplAngle;
    end
    
    return skill.SklSplAngle + pc.SkillAngle;

end

function SCR_Get_SplRange(skill)

    local pc = GetSkillOwner(skill);
    
    local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "SplRange");
    if overWriteExist == 1.0 then
        return overWritedValue;
    end 

    local splRange = skill.SklSplRange;
    local splType = skill.SplType;
    if splType == "Fan" then
        splRange = splRange + pc.SkillRange + TryGet(pc, skill.AttackType .. "_Range");
    elseif splType == "Square" then
        splRange = splRange + pc.SkillAngle;
    end
    
    return splRange;

end

function SCR_Get_Skl_BackHit(skill)

    local pc = GetSkillOwner(skill);
    local overWriteExist, overWritedValue = GetOverWritedProp(pc, skill, "BackHitRange");
    if overWriteExist == 1.0 then
        return overWritedValue;
    end 
    
    return 0;

end


--[ Normal_Attack ]--
function SCR_Get_SkillFactor(skill)
    local sklFactor;
    local skillOwner = GetSkillOwner(skill);
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel;
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_Reinforce_Ability(skill)
    local pc = GetSkillOwner(skill)
    local value = skill.SklFactor + skill.SklFactorByLevel * (skill.Level - 1)--?¤í‚¬?™í„° ê³„ì‚°
    local reinfabil = skill.ReinforceAbility
    local abil = GetAbility(pc, reinfabil)--abil??reinfabil?€?
    if abil ~= nil and TryGetProp(skill, "ReinforceAbility") ~= 'None' then
        local abilLevel = TryGetProp(abil, "Level")
        local masterAddValue = 0
        if abilLevel == 100 then
            masterAddValue = 0.1
        end
        
        value = value * (1 + ((abilLevel * 0.005) + masterAddValue))
        
        local hidden_abil_cls = GetClass("HiddenAbility_Reinforce", skill.ClassName);
        if abilLevel >= 65 and hidden_abil_cls ~= nil then
        	local hidden_abil_name = TryGetProp(hidden_abil_cls, "HiddenReinforceAbil");
        	local hidden_abil = GetAbility(pc, hidden_abil_name);
        	if hidden_abil ~= nil then
        		local abil_level = TryGetProp(hidden_abil, "Level");
        		local add_factor = TryGetProp(hidden_abil_cls, "FactorByLevel", 0) * 0.01;
        		local add_value = 0;
        		if abil_level == 10 then
        			add_value = TryGetProp(hidden_abil_cls, "AddFactor", 0) * 0.01
        		end
        		value = value * (1 + (abil_level * add_factor) + add_value);
        		
        	end
        end
    end
    
    return math.floor(value)
end

function SCR_Get_SkillFactor_Molich_4(skill)
    
    local self = GetSkillOwner(skill);
    local buff = GetBuffByName(self, 'Melee_charging');
    local buffOver = 0;
    if buff ~= nil then
        buffOver = GetOver(buff);
    end
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel + buffOver;
    
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_Molich_5(skill)
    
    local self = GetSkillOwner(skill);
    local buff = GetBuffByName(self, 'Magic_charging');
    local buffOver = 0;
    if buff ~= nil then
        buffOver = GetOver(buff);
    end
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel + buffOver;
    
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_PC_summon_Canceril(skill)
    
    local self = GetSkillOwner(skill);
    local parent = GetOwner(self)
    --local etc_pc = GetETCObject(parent);
    --local itemGuid = etc_pc.Wugushi_bosscardGUID1;
    --local itembonus = item.Level * 10
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_pc_summon_Manticen(skill)
    
    local self = GetSkillOwner(skill);
    local parent = GetOwner(self)
    --local etc_pc = GetETCObject(parent);
    --local itemGuid = etc_pc.Wugushi_bosscardGUID1;
    --local itembonus = item.Level * 10
    
    sklFactor = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    return math.floor(sklFactor);
end

function SCR_Get_SkillFactor_pcskill_shogogoth(skill)
    
    local self = GetSkillOwner(skill);
    local pc = GetOwner(self)
    local value = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    
    local shoggothSkill = GetSkill(pc, 'Necromancer_CreateShoggoth');
    local abil = GetAbility(pc, "Necromancer5")      -- Skill Damage add
    if shoggothSkill ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(shoggothSkill, abil, value);
    end
    
    return math.floor(value)
end

function SCR_Get_SkillFactor_pcskill_CorpseTower(skill)
    
    local self = GetSkillOwner(skill);
    local pc = GetOwner(self)
    local value = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    
    local corpseTowerSkill = GetSkill(pc, "Necromancer_CorpseTower");
    local abil = GetAbility(pc, "Necromancer6")      -- Skill Damage add
    if corpseTowerSkill ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(corpseTowerSkill, abil, value);
    end
    
    return math.floor(value)
end

function SCR_Get_SkillFactor_pcskill_skullsoldier(skill)
    
    local self = GetSkillOwner(skill);
    local pc = GetTopOwner(self)
    local value = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    
    local skullSoldierSkill = GetSkill(pc, "Necromancer_RaiseDead");
    local abil = GetAbility(pc, "Necromancer7")      -- Skill Damage add
    if skullSoldierSkill ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(skullSoldierSkill, abil, value);
    end
    
    return math.floor(value)
end

function SCR_Get_SkillFactor_pcskill_skullarcher(skill)
    
    local self = GetSkillOwner(skill);
    local pc = GetTopOwner(self)
    local value = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    
    local skullArcherSkill = GetSkill(pc, "Necromancer_RaiseSkullarcher");
    local abil = GetAbility(pc, "Necromancer10")      -- Skill Damage add
    if skullArcherSkill ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(skullArcherSkill, abil, value);
    end
    
    return math.floor(value)
end

function SCR_Get_SklAtkAdd(skill)    
    local sklAtkAdd;
    local skillOwner = GetSkillOwner(skill);
    
    if skillOwner.ClassName == 'PC' then
    
        sklAtkAdd = skill.SklAtkAdd + (skill.Level - 1) * skill.SklAtkAddByLevel;
        
        return math.floor(sklAtkAdd);
    else
        return 0;
    end
end


function SCR_Get_ReinforceAtk(skill)
  
    local ReinforceAtkAdd = 0;
    local self = GetSkillOwner(skill);
    
    if self.ClassName == 'PC' then
--        local jobObj = GetJobObject(self);
        local weapon = GetEquipItem(self, 'RH')
        local Transcend = weapon.Transcend
        
        ReinforceAtkAdd = skill.ReinforceAtkAdd + Transcend * skill.ReinforceAtkAddByLevel;
        
        return ReinforceAtkAdd
    else
        return 1;
    end

end

function SCR_Get_NormalAttack_Lv(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.Lv
    
  return math.floor(value)
end

function SCR_ABIL_ADD_SKILLFACTOR(skill, abil, value)
    local abilLevel = TryGetProp(abil, "Level")
    local masterAddValue = 0
    if abilLevel == 100 then
        masterAddValue = 0.1
    end
    
    local value = value * (1 + ((abilLevel * 0.005) + masterAddValue))

    local pc = GetSkillOwner(skill);
    local sklClassName = TryGetProp(skill, "ClassName");
    local hidden_abil_cls = GetClass("HiddenAbility_Reinforce", sklClassName);
    if abilLevel >= 65 and hidden_abil_cls ~= nil then
        local hidden_abil_name = TryGetProp(hidden_abil_cls, "HiddenReinforceAbil");
        local hidden_abil = GetAbility(pc, hidden_abil_name);
        if hidden_abil ~= nil then
            local abil_level = TryGetProp(hidden_abil, "Level");
            local add_factor = TryGetProp(hidden_abil_cls, "FactorByLevel", 0) * 0.01;
            local add_value = 0;
            if abil_level == 10 then
                add_value = TryGetProp(hidden_abil_cls, "AddFactor", 0) * 0.01
            end
            value = value * (1 + (abil_level * add_factor) + add_value);
        end
	end
    
    return value
end

-- skillshared.lua ??function SCR_REINFORCEABILITY_FOR_BUFFSKILL(self, skill) ?€ ?´ìš© ?™ì¼?
-- ê°™ì´ ë³€ê²½í•´???
-- done , ?´ë‹¹ ?¨ìˆ˜ ?´ìš©?€ cppë¡??´ì „?˜ì—ˆ?µë‹ˆ?? ë³€ê²??¬í•­???ˆë‹¤ë©?ë°˜ë“œ???„ë¡œê·¸ëž˜?€???Œë ¤ì£¼ì‹œê¸?ë°”ëž?ˆë‹¤.
function SCR_REINFORCEABILITY_TOOLTIP(skill)
    local pc = GetSkillOwner(skill);
    local addAbilRate = 1;
    local reinforceAbilName = TryGetProp(skill, "ReinforceAbility", "None");
    if reinforceAbilName ~= "None" then
        local reinforceAbil = GetAbility(pc, reinforceAbilName)
        if reinforceAbil ~= nil then
            local abilLevel = TryGetProp(reinforceAbil, "Level")
            local masterAddValue = 0
            if abilLevel == 100 then
                masterAddValue = 0.1
            end
            addAbilRate = 1 + (reinforceAbil.Level * 0.005 + masterAddValue);

            local hidden_abil_cls = GetClass("HiddenAbility_Reinforce", skill.ClassName);
            if abilLevel >= 65 and hidden_abil_cls ~= nil then
                local hidden_abil_name = TryGetProp(hidden_abil_cls, "HiddenReinforceAbil");
                local hidden_abil = GetAbility(pc, hidden_abil_name);
                if hidden_abil ~= nil then
                    local abil_level = TryGetProp(hidden_abil, "Level");
                    local add_factor = TryGetProp(hidden_abil_cls, "FactorByLevel", 0) * 0.01;
                    local add_value = 0;
                    if abil_level == 10 then
                        add_value = TryGetProp(hidden_abil_cls, "AddFactor", 0) * 0.01
                    end
                    addAbilRate = addAbilRate * (1 + (abil_level * add_factor) + add_value);
                end
            end
        end
    end

    return addAbilRate
end

function SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil)
    return abil.Level * 1
end

function SCR_GET_Thrust_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Swordman2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Bash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Swordman1") 
    local value = 0
    if abil ~= nil then 
    return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
  end


end


function SCR_GET_PommelBeat_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Swordman25") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PommelBeat_Ratio(skill)

    return (1 + (skill.Level - 1) * 0.5)

end

function SCR_GET_DoubleSlash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Swordman27") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_RimBlow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_UmboBlow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SR_LV_ShieldLob(skill)

    local pc = GetSkillOwner(skill);
    local Peltasta4_abil = GetAbility(pc, 'Peltasta4')

    if Peltasta4_abil ~= nil and 1 == Peltasta4_abil.ActiveState then
        return pc.SR + skill.SklSR + Peltasta4_abil.Level;
    end
    return pc.SR + skill.SklSR

end

function SCR_GET_ShieldLob_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_SR_LV_PommelBeat(skill)

    local pc = GetSkillOwner(skill);    
    return skill.SklSR

end

function SCR_GET_ButterFly_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta22") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_UmboThrust_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Langort_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta27") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SR_LV_HEX(skill)
  local value = skill.Level;
    return value

end

function SCR_GET_Moulinet_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 100
    if IsBuffApplied(pc, "RidingCompanion") == "YES" then 
        value = 150
    end
    return value
end

function SCR_GET_CartarStroke_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CartarStroke_Ratio2(skill)
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, 'Highlander33')
    local value = 0.5
--    if abil ~= nil and abil.ActiveState == 1 then
--        value = value / 2
--    end
    return value
end

function SCR_GET_WagonWheel_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Crown_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ScullSwing_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander25") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SkyLiner_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander29") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CrossCut_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander30") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_VerticalSlash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Highlander31") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Stabbing_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_LongStride_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SynchroThrusting_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Pierce_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ThrouwingSpear_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SpearLunge_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hoplite26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Embowel_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Barbarian17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_StompingKick_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Barbarian20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Pouncing_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Barbarian24") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HelmChopper_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 2.5
    
    if IsBuffApplied(pc, "Frenzy_Buff") == "YES" then
        value = 4
    end
    
    return value
end

function SCR_GET_Seism_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Barbarian26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Seism_Ratio2(skill)
--  local pc = GetSkillOwner(skill)
--  local buff = GetBuffByName(pc, "ScudInstinct_Buff")
--  local buffOver = GetOver(buff)
--  if buff ~=nil and buffOver >= 5 then
--      hitCount = hitCount + 2
--    end
    local hitCount = 3
    
    return hitCount;

end

function SCR_GET_Cleave_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Barbarian27") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldCharge_Ratio(skill)
    local value = 10 + (skill.Level * 6)
    
    return value;
end

function SCR_GET_Montano_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Montano_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 5
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 2.5
    end
    
    return value;
end

function SCR_GET_TargeSmash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldPush_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldShoving_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldShoving_Bufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 1.5
    if IsPVPServer(pc) == 1 then
        value = 3
    end
    return value
end

function SCR_GET_ShieldBash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero27") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Slithering_Ratio(skill)
    local value = skill.Level * 10
    
    return value
end


function SCR_GET_Slithering_Ratio2(skill)
    local value = skill.Level * 5
    
    return value
end

function SCR_GET_Slithering_Ratio3(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_ShootingStar_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HighKick_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rodelero28") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Impaler_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cataphract14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Impaler_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 8 + skill.Level;
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 6;
    end
    return value;
end

function SCR_GET_DoomSpike_Ratio(skill)
    local value = 10 + TryGetProp(skill, "Level", 1) 
    return value
end

function SCR_GET_Rush_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cataphract11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end
function SCR_GET_Rush_Ratio3(skill)
    local pc = GetSkillOwner(skill);
    local value = 10 + skill.Level *1;
    local abil = GetAbility(pc, "Cataphract1")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.2
    end
    
    return value;
end

function SCR_GET_EarthWave_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cataphract17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SteedCharge_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cataphract20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Keelhauling_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Corsair11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Keelhauling_Ratio(skill)
    local pc = GetSkillOwner(skill);
    
    local value = 2;
    
    return value
end

function SCR_GET_DustDevil_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Corsair12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HexenDropper_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Corsair13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PistolShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Corsair16") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Cyclone_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Cyclone_Ratio2(skill)
    return 3.5
end

function SCR_GET_Mordschlag_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Punish_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Zornhau_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Zornhau_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Doppelsoeldner22')
    local hitCount = 1
    if abil ~= nil and skill.Level >= 6 and abil.ActiveState == 1 then
        hitCount = 1 + abil.Level;
    end
    return hitCount;
end

function SCR_GET_Redel_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner15") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Redel_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Doppelsoeldner21")
    local hitCount = 5
    if abil ~= nil and skill.Level >=6 and abil.ActiveState == 1 then
        hitCount = 14
    end
    
    return hitCount;

end

function SCR_GET_Zucken_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner16") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Zucken_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Doppelsoeldner20")
    local hitCount = 4
    if abil ~= nil and skill.Level >= 6 and abil.ActiveState == 1 then
        hitCount = hitCount * 2
    end
    
    return hitCount;

end

function SCR_GET_AttaqueComposee_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Lunge_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Lunge_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 50 + (20 * skill.Level)
    
    return value;

end

function SCR_GET_Lunge_BuffTime(skill)

return 4
end

function SCR_GET_SeptEtoiles_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_AttaqueCoquille_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_AttaqueCoquille_Ratio2(skill)

    local value = 4 + skill.Level * 1
  return value

end


function SCR_GET_Preparation_Ratio(skill)

    local value = 50 + skill.Level * 5
  return value

end


function SCR_GET_Preparation_Ratio2(skill)

    local value = 3
  return value

end

function SCR_GET_EsquiveToucher_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_EsquiveToucher_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 10 * skill.Level
    
  return value

end

function SCR_GET_Flanconnade_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Mijin_no_jutsu_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Shinobi3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Mijin_no_jutsu_Ratio2(skill)
    local value = 7500 - skill.Level * 500
    
    return value
end

function SCR_GET_Bunshin_no_jutsu_Ratio(skill)
    local value = 20
    
    return value
end

function SCR_GET_SummonGuildMember_Ratio(skill)
    local value = 1 * skill.Level
    
    return value
end

function SCR_GET_BattleOrders_Ratio(skill)
    local value = skill.Level * 1.5
    local addValue = skill.Level * 1.5
    value = value + addValue
    
    return value
end

function SCR_GET_BattleOrders_Ratio2(skill)
    local value = skill.Level * 1.5
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_AdvancedOrders_Ratio(skill)
    local value = skill.Level
    return value
end

function SCR_GET_AdvancedOrders_Ratio2(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_BuildForge_Time(skill)
    local value = 50 + skill.Level * 2
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = value * 0.5
    end
    
    return math.floor(value)
end

function SCR_GET_BuildForge_Ratio(skill)
    local value = 73
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_FlyingColors_Ratio(skill)
    local value = skill.Level * 8
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_FlyingColors_Ratio2(skill)
    local value = skill.Level * 5
    return value
end

function SCR_Get_SkillFactor_BuildForge(skill)
    
    local self = GetSkillOwner(skill);
    local pc = GetOwner(self)
    local value = skill.SklFactor + (skill.Level - 1) * skill.SklFactorByLevel
    
    local forgeSkill = GetSkill(pc, "Templer_BuildForge");
    local abil = GetAbility(pc, "Templar4")      -- Skill Damage add
    if forgeSkill ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(forgeSkill, abil, value);
    end
    
    return math.floor(value)
end

function SCR_GET_BuildShieldCharger_Ratio(skill)
    local value = 10 + (skill.Level * 2)
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_BuildShieldCharger_Ratio2(skill)
    local value = 5
    
    return value;
end

function SCR_GET_BuildShieldCharger_Ratio3(skill)
    local value = 60
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = 30
    end
    
    return value
end

function SCR_GET_ShareBuff_Ratio(skill)
    local value = 5 + (skill.Level * 2)
    
    return value
end

function SCR_GET_ShareBuff_Ratio2(skill)
    local value = 42 + skill.Level * 2
    
    return value;
end


function SCR_GET_ReduceCraftTime_Ratio(skill)
    local value = 5 * skill.Level
    
    return value
end

function SCR_GET_Bunshin_no_jutsu_Ratio2(skill)
    local value = skill.Level
    if value >= 3 then
        value = 3
    end
    
    return value
end

function SCR_GET_Mokuton_no_jutsu_Ratio(skill)

    local value = 15 + skill.Level * 5

  return value

end

function SCR_GET_Katon_no_jutsu_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Shinobi2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Kunai_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Shinobi1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end

function SCR_GET_DeadlyCombo_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Squire11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
    
end

function SCR_GET_Dragontooth_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Serpentine_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Gae_Bulg_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_Gae_Bulg_Ratio2(skill)

    local value = 10
  return value

end

function SCR_GET_Dragon_Soar_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Dragon_Soar_Ratio2(skill)
    local value = 5;
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon16") 
    if abil ~= nil and abil.ActiveState == 1 then 
        value = value * 2;
    end
    
    return math.floor(value);
end

function SCR_GET_Zwerchhau_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner18") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Zwerchhau_Bufftime(skill)
    local value = 6.5
    return value
end

function SCR_GET_Sturzhau_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Doppelsoeldner19") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

--function SCR_GET_Sturzhau_Ratio2(skill)
--    local value = skill.Level * 200
--    return value
--end

function SCR_GET_Sturzhau_Ratio3(skill)
    local value = skill.Level * 5
    return value
end

function SCR_GET_BalestraFente_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_AttaqueAuFer_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fencer9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_AttaqueAuFer_Bufftime(skill)
    local value = 15
    return value
end

function SCR_GET_EpeeGarde_Ratio(skill)
    local value = 35 + skill.Level * 3;

    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return math.floor(value)
end

function SCR_GET_EpeeGarde_Bufftime(skill)
    local value = 15 + skill.Level * 3
    return value

end

function SCR_GET_Dethrone_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Dethrone_Ratio2(skill)
    local value = 5
    return value
end

function SCR_GET_Dethrone_Bufftime(skill)
    local value = 10
    return value
end

function SCR_GET_DargonDive_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_DragoonHelmet_Ratio(skill)
    local value = 50
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon20")
    if abil ~= nil and abil.ActiveState == 1 then
        value = 25
    end
    
    return value;
end

function SCR_Get_DragoonHelmet_Ratio2(skill)
    local value = 100
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dragoon20")
    if abil ~= nil and abil.ActiveState == 1 then
        value = 50
    end
    
    local pcLevel = TryGetProp(pc, "Lv", 1)
    local mnaRate = TryGetProp(pc, "MNA", 1)      
    
    value = value - math.min(50, (mnaRate / pcLevel) * 100)    
    
    return value;
end

function SCR_Get_DragoonHelmet_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    
    local pcLevel = TryGetProp(pc, "Lv", 1)
    local mnaRate = TryGetProp(pc, "MNA", 1)      
    
    local value = math.min(50, (mnaRate / pcLevel) * 100)    
    
    return value;
end

function SCR_GET_MortalSlash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Templar1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SKL_COOLDOWN_MortalSlash(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local owner = GetSkillOwner(skill)
    
    if IsServerSection(owner) == 1 then
        local list, cnt = GetPartyMemberList(owner, PARTY_NORMAL, 0);
        if cnt > 1 then
            local abilCoolDownRatio = 1;
            for i = 1, cnt - 1 do
                abilCoolDownRatio = abilCoolDownRatio - 0.1;
            end
            
            if abilCoolDownRatio < 0.6 then
                abilCoolDownRatio = 0.6;
            end
            
            basicCoolDown = basicCoolDown * abilCoolDownRatio;
        end
    else
        local list = session.party.GetPartyMemberList(PARTY_NORMAL);
        if list ~= nil then
            local cnt = list:Count();
            if cnt > 1 then
                local myObj = session.party.GetMyPartyObj(PARTY_NORMAL)
                local myMapID = myObj:GetMapID()
                local myChannelInfo = session.loginInfo.GetChannel();
                
                local loginCount = 0;
                for i = 0 , cnt - 1 do
                    local partyMemberInfo = list:Element(i);
                    if partyMemberInfo:GetMapID() == myMapID and partyMemberInfo:GetChannel() == myChannelInfo then
                        loginCount = loginCount + 1;
                    end
                end
                
                local abilCoolDownRatio = 1;
                
                if loginCount > 1 then
                    for i = 1, loginCount - 1 do
                        abilCoolDownRatio = abilCoolDownRatio - 0.1;
                    end
                end
                
                if abilCoolDownRatio < 0.6 then
                    abilCoolDownRatio = 0.6;
                end
                
                basicCoolDown = basicCoolDown * abilCoolDownRatio;
            end
        end
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    
    if IsBuffApplied(pc, "Bunshin_Debuff") == "YES" then
        local bunshinBuff = nil
        local bunsinCount = nil
        if IsServerObj(pc) == 1 then
            bunshinBuff = GetBuffByName(pc, "Bunshin_Debuff")
            bunsinCount = GetBuffArg(bunshinBuff)
        else 
            local handle = session.GetMyHandle();
            bunshinBuff = info.GetBuff(handle, 3049)
            bunsinCount = bunshinBuff.arg1
        end
        
        basicCoolDown = basicCoolDown + (bunsinCount * 2000 + (basicCoolDown * (bunsinCount * 0.1)))
    end
    
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;
    return math.floor(ret);

end

function SCR_GET_CassisCrista_Bufftime(skill)

    local value = 240
    
    return value

end

function SCR_GET_CassisCrista_Ratio(skill)

    local value = 10 * skill.Level;
    
    return value

end

function SCR_GET_FrenziedSlash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrenziedSlash_Ratio2(skill)

    local value = 4 + skill.Level * 1
    
    return value
end

function SCR_GET_EvadeThrust_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Headbutt_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Headbutt_Time(skill)
    local value = 3
    
    return value
end

function SCR_GET_Takedown_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrenziedShoot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ScutumHit_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Murmillo9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShieldTrain_Ratio(skill)
    local value = 10
    return value
end

function SCR_GET_SR_LV_ScutumHit(skill)
    local pc = GetSkillOwner(skill);
    local byAbil = 0;
    local abil = GetAbility(pc, 'Murmillo16');
    if abil ~= nil and 1 == abil.ActiveState then
        byAbil = pc.SR + skill.SklSR;
    end
    
    return math.floor(pc.SR + skill.SklSR + byAbil)
end

function SCR_GET_Crush_Ratio(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_HeadStrike_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Lancer4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HeadStrike_Ratio2(skill)
    local value = 30 + skill.Level * 2
    return value
end

function SCR_GET_Joust_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Lancer6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Joust_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 10 + skill.Level * 1;
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5;
    end
    
    return value;
end

function SCR_GET_SpillAttack_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Lancer7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Quintain_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Lancer8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Commence_Ratio(skill)
    local value = skill.Level * 10
    
    return value
end

function SCR_GET_Commence_Ratio2(skill)

    local value = 5 * skill.Level
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value

end

function SCR_GET_Commence_Bufftime(skill)
    local value = 10 + skill.Level * 3
    
    return value
end

function SCR_GET_Capote_Ratio(skill)
    local value = 10 + skill.Level * 1
    
    return value
end

function SCR_GET_Capote_Ratio2(skill)
    local value = 20
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill));
    return value
end

function SCR_GET_Faena_Ratio(skill)
    local value = (skill.Level / 2) + 2
    
    return math.floor(value)
end

function SCR_GET_Faena_Ratio2(skill)
    local value = skill.Level + 2
    
    return value
end

function SCR_GET_Ole_BuffTime(skill)
    local pc = GetSkillOwner(skill)
    local value = 20
    local abil = GetAbility(pc, "Matador4")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Ole_Ratio(skill)
    local value = 10 + (skill.Level * 3)
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return math.floor(value);
end

function SCR_GET_Ole_Ratio2(skill)
    local value = 10 + skill.Level * 2;
    
    return math.floor(value);
end

function SCR_GET_BackSlide_Bufftime(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_Sprint_Ratio(skill)
    local value = 5 + skill.Level * 0.5
    
    return value
end

function SCR_GET_ShadowPool_Bufftime(skill)
    local value = skill.Level * 2
    
    return value
end

function SCR_GET_ShadowFatter_Bufftime(skill)
    local value = 3 + skill.Level
    
    return value
end

function SCR_GET_Hallucination_Bufftime(skill)
    local value = 5 + skill.Level
    
    return value
end

function SCR_Get_Enervation_BuffTime(skill)
    local value = 20 + skill.Level * 2
    
    return value
end

function SCR_GET_EnchantEarth_Ratio(skill)
    local value = 5 + skill.Level * 2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_Multishot_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Archer11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Fulldraw_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Archer12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ObliqueShot_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Archer13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_KnockbackShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Archer26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DuelShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Archer28") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Barrage_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HighAnchoring_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BounceShot_Ratio2(skill)
    local value = 50;
    return value
end

function SCR_GET_SpiralArrow_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger30") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ArrowSprinkle_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CriticalShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger25") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_TimeBombArrow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Ranger28") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ScatterCaltrop_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "QuarrelShooter11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_StonePicking_Ratio(skill)
    local value = skill.Level
    return value
end

function SCR_GET_StoneShot_Ratio(skill)
    local value = 50
    return value
end

function SCR_GET_StoneShot_Ratio2(skill)
    local value = 50
    return value
end

function SCR_GET_RapidFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "QuarrelShooter13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_RunningShot_Ratio(skill)

    local value = 50 + 30 * skill.Level
  return value

end

function SCR_GET_DestroyPavise_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "QuarrelShooter20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BroomTrap_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_StakeStockades_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper29") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_StakeStockades_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 15
    if IsPVPServer(pc) == 1 then
        value = 900
    end
    
    return value
end

function SCR_GET_StakeStockades_HitCount(skill)--CaptionRatio2
    local pc = GetSkillOwner(skill);
    local value = 15
    if IsPVPServer(pc) == 1 then
        value = 6
    end
    
    return value
end

function SCR_GET_Claymore_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_Claymore_Ratio(skill)
    local value = 5
    return value
end

function SCR_GET_PunjiStake_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_PunjiStake_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 30 + skill.Level * 5
    if IsPVPServer(pc) == 1 then
        value = 900
    end
    return value
end

function SCR_GET_DetonateTraps_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SpikeShooter_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HoverBomb_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sapper27") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Coursing_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hunter9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Snatching_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hunter10") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_RushDog_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hunter11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Retrieve_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hunter12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_NeedleBlow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wugushi11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_NeedleBlow_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level * 0.5

    return value;
end

function SCR_GET_WugongGu_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wugushi14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_WugongGu_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 10

    return value;

end

function SCR_GET_ThrowGuPot_Time(skill)
    local value = 15
    return value;
end

function SCR_GET_ThrowGuPot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wugushi17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FluFlu_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Scout11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_JincanGu_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = skill.Level
    if value > 10 then
        value = 10
    end

    return value;

end

function SCR_GET_FlareShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Scout14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FlareShot_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 25
  return value;
  
end

function SCR_GET_SplitArrow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Scout17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Vendetta_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Rogue11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Backstab_Ratio2(skill)
    local value = 2 + (skill.Level * 0.5)
    local pc = GetSkillOwner(skill);
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 2 + (skill.Level * 0.2)
    end
    
    return value
end

function SCR_GET_BroadHead_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BodkinPoint_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BarbedArrow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CrossFire_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_MagicArrow_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_MagicArrow_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level * 2
    return value 

end

function SCR_GET_Singijeon_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Fletcher25") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ConcentratedFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Schwarzereiter11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ConcentratedFire_Ratio2(skill)

    return 10;
end

function SCR_GET_Caracole_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Schwarzereiter12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_Limacon(skill)
    local pc = GetSkillOwner(skill);
    local LimaconSkill = GetSkill(pc, "Schwarzereiter_Limacon")
    local value = 0
    if LimaconSkill ~= nil then
        value = LimaconSkill.SklFactor + LimaconSkill.SklFactorByLevel * (skill.Level - 1)
    end

--    local limaconSkill = GetSkill(pc, "Schwarzereiter_Limacon");
--    local abil = GetAbility(pc, "Schwarzereiter13")      -- Skill Damage add
--    if limaconSkill ~= nil and abil ~= nil then
--        value = SCR_ABIL_ADD_SKILLFACTOR(limaconSkill, abil, value);
--    end
    
    return math.floor(value)

end

function SCR_GET_Limacon_Ratio(skill)
--    local value = 5 + (skill.Level * 1);
--    local pc = GetSkillOwner(skill);
--    if pc ~= nil then
--        local abilSchwarzereiter18 = GetAbility(pc, 'Schwarzereiter18');
--        if abilSchwarzereiter18 ~= nil and TryGetProp(abilSchwarzereiter18, 'ActiveState') == 1 then
--            value = value + 3;
--        end
--    end
--    
--    return value;
    
    local pc = GetSkillOwner(skill);
    local value = 12;
    local lv = pc.Lv
    local bylvCorrect = lv - 300
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    value = value * (1 + bylvCorrect)
    
    local abilSchwarzereiter18 = GetAbility(pc, 'Schwarzereiter18');
    if abilSchwarzereiter18 ~= nil then
        value = value + 5;
    end
    
    return math.floor(value)
end

function SCR_GET_Limacon_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 30 + ((skill.Level - 1) * 5);
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    return value
end


function SCR_GET_Limacon_BuffTime(skill)
    local value = skill.Level * 20
    return value
end

function SCR_GET_EvasiveAction_BuffTime(skill)
    local value = 300
    return value
end

function SCR_GET_RetreatShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Schwarzereiter14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_WildShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Schwarzereiter15") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EvasiveAction_Ratio(skill)

    local value = skill.Level * 2
    return value

end

function SCR_GET_EvasiveAction_Ratio2(skill)

    local value = 5
    return value

end

function SCR_GET_Hovering_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Falconer5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Pheasant_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Falconer6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BlisteringThrash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Falconer8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CannonShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cannoneer2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ShootDown_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cannoneer3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SiegeBurst_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cannoneer4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_CannonBlast_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cannoneer5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SmokeGrenade_Time(skill)
    local value = 7 + skill.Level
    return value
end

function SCR_GET_Bazooka_Ratio(skill)
    local value = 50
    return value
end


function SCR_GET_Bazooka_Ratio2(skill)
    local value = 80
    return value
end

function SCR_GET_CoveringFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HeadShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Snipe_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PenetrationShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ButtStroke_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BayonetThrust_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Combination_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Falconer9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_FirstStrike_Ratio2(skill)
    local value = skill.Level * 10
    
    return value
end

function SCR_GET_CannonBarrage_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cannoneer9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SKL_COOLDOWN_CannonBarrage(skill)
    
    local pc = GetSkillOwner(skill);
    local basicCoolDown = skill.BasicCoolDown;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    basicCoolDown = basicCoolDown + abilAddCoolDown;
    
    local abilCannoneer20 = GetAbility(pc, 'Cannoneer20');
    if abilCannoneer20 ~= nil and abilCannoneer20.ActiveState == 1 then
        local abilCoolDownRate = 1 - (abilCannoneer20.Level * 0.1);
        basicCoolDown = basicCoolDown * abilCoolDownRate;
    end
    
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    if IsBuffApplied(pc, 'SpeForceFom_Buff') == 'YES' then
        if skill.ClassName ~= "Centurion_SpecialForceFormation" then
            basicCoolDown = basicCoolDown * 0.5;
        end
    end
    local ret = math.floor(basicCoolDown) / 1000
    ret = math.floor(ret) * 1000;   
    return math.floor(ret);

end

function SCR_GET_Volleyfire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Birdfall_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Musketeer18") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Skarphuggning_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hackapell1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HakkaPalle_BuffTime(skill)
    local value = 10 + (skill.Level * 2)
    
    return value
end

function SCR_GET_BombardmentOrders_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hackapell2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BombardmentOrder_Time(skill)
    local value = 2 + skill.Level * 0.3
    return value
end

function SCR_GET_HackapellCharge_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hackapell3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HackapellCharge_BuffTime(skill)
    local value = 15 + skill.Level
    return value
end

function SCR_GET_LegShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hackapell4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_LegShot_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 50
    
    local abil = GetAbility(pc, "Hackapell5")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_StormBolt_BuffTime(skill)
    local value = 6 * skill.Level
    return value
end

function SCR_GET_Unload_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Unload_Ratio2(skill)
    local value = 6
    return value
end

function SCR_GET_FocusFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_QuickFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_TrickShot_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ArrowRain_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ParthianShaft_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_ParthianShaft_Ratio2(skill)
    local value = skill.Level * 3;
    return value
end

function SCR_GET_EnergyBolt_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wizard11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EarthQuake_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wizard13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_MagicMissile_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Wizard12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_MagicMissile_Ratio2(skill)
    local value = math.floor(0.5 + (skill.Level / 2))
    
    return value
end

function SCR_GET_FireBall_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer29") 
    local value = 5
    if abil ~= nil and abil.ActiveState == 1 then 
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_FireWall_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Flare_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FlameGround_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer26") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FirePillar_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer15") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HellBreath_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Pyromancer14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_IceBolt_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cryomancer11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_IceBolt_BuffTime(skill)
    local value = 5
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    return value
end

function SCR_GET_IciclePike_BuffTime(skill)
    local value = 5
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    return value
end

function SCR_GET_IceWall_BuffTime(skill)
    local value = 5
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    return value
end

function SCR_GET_IciclePike_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cryomancer12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_IceBlast_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cryomancer13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_SnowRolling_Ratio2(skill)
	local value = 3 + skill.Level
	if value>=10 then
		value = 10;
	end
	return value
end

function SCR_GET_Telekinesis_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Psychokino11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_MagneticForce_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Psychokino13") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_GravityPole_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Psychokino8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Meteor_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Prominence_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist26") 
    local value = 4
    if abil ~= nil and abil.ActiveState == 1 then 
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Hail_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Electrocute_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrostCloud_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FrostCloud_Ratio2(skill)

    return 12 + skill.Level * 2

end

function SCR_GET_FreezingSphere_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Elementalist24") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_pcskill_summon_Familiar(skill)
    local sklLevel = 1;
    local self = GetSkillOwner(skill);
    local parent = GetOwner(self)
    local skl = nil;
    if parent ~= nil then
        skl = GetSkill(parent, 'Sorcerer_SummonFamiliar');
        if skl ~= nil then
            sklLevel = skl.Level
        end
    end
    
    local value = skill.SklFactor + skill.SklFactorByLevel * (sklLevel - 1)
    local abil = GetAbility(parent, "Sorcerer11")      -- Skill Damage add
    if skl ~= nil and abil ~= nil then
        value = SCR_ABIL_ADD_SKILLFACTOR(skl, abil, value);
    end
    
    return math.floor(value)
end

function SCR_GET_SummonFamiliar_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sorcerer11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Evocation_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sorcerer12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Evocation_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 + 5 * skill.Level;
    
    return value
    
end

function SCR_GET_Desmodus_Ratio(skill)
    local value = skill.Level * 4
    
    return value
end

function SCR_GET_Desmodus_Ratio2(skill)
    local value = skill.Level * 6
    
    return value
end

function SCR_GET_GatherCorpse_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Necromancer11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_GatherCorpse_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level

    return value
end

function SCR_GET_FleshCannon_Ratio2(skill)
    local value = 25 + skill.Level * 5
    
    return value;
end

function SCR_GET_FleshHoop_Ratio2(skill)
    local value = skill.Level
    
    return value;
end

function SCR_GET_RevengedSevenfold_Time(skill)
    local value = 60
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 then
        value = 7
    end
    return value
end

function SCR_GET_RevengedSevenfold_Ratio(skill)
    local value = 3.5 * skill.Level
  return value

end

function SCR_GET_Ayin_sof_Time(skill)
    local value = 20 + skill.Level * 4
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = value * 0.5
    end
    
    local Kabbalist23_Abil = GetAbility(pc, "Kabbalist23")
    if Kabbalist23_Abil ~= nil and TryGetProp(Kabbalist23_Abil, "ActiveState", 0) == 1 then
        value = value * 0.5
    end
    
    return value
end

function SCR_GET_Ayin_sof_Ratio(skill)
    local value = 30
    local pc = GetSkillOwner(skill);
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    local Kabbalist23_Abil = GetAbility(pc, "Kabbalist23")
    if Kabbalist23_Abil ~= nil and TryGetProp(Kabbalist23_Abil, "ActiveState", 0) == 1 then
        value = value * 0.5
    end    
    
    return value
end

function SCR_GET_Ayin_sof_Ratio2(skill)
    local value = 15
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, "Kabbalist6")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Ayin_sof_Ratio3(skill)
    return 3000 * skill.Level;
end

function SCR_GET_Gematria_Ratio(skill)
    local value = 10;
    
    local pc = GetSkillOwner(skill);
    local abilKabbalist14 = GetAbility(pc, "Kabbalist14");
    if abilKabbalist14 ~= nil and abilKabbalist14.ActiveState == 1 then
        value = value + abilKabbalist14.Level;
    end
    
    return value;
end


function SCR_GET_Notarikon_Ratio(skill)
    local value = 10;
    
    local pc = GetSkillOwner(skill);
    local abilKabbalist14 = GetAbility(pc, "Kabbalist14");
    if abilKabbalist14 ~= nil and abilKabbalist14.ActiveState == 1 then
        value = value + abilKabbalist14.Level;
    end
    
    return value;
end



function SCR_GET_Multiple_Hit_Chance_Ratio(skill)
    local value = skill.Level * 8
  return value

end


function SCR_GET_Reduce_Level_Ratio(skill)
    local value = skill.Level
  return value

end

function SCR_GET_Reduce_Level_Ratio2(skill)
    local value = 10 + skill.Level
  return value

end

function SCR_GET_Clone_Time(skill)
    local value = skill.Level * 3
    return value
end


function SCR_GET_PoleofAgony_Bufftime(skill)
    local value = 7 + skill.Level * 1
    
    return value
end


function SCR_GET_PoleofAgony_Ratio2(skill)
    local value = 14
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = 7
    end
    return value
end

function SCR_GET_Ngadhundi_Ratio2(skill)
    local value = 10 + skill.Level * 2
  return value

end

function SCR_Get_Pass_Bufftime(skill)
    local value = skill.Level * 5
  return value

end

function SCR_GET_Combustion_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Alchemist11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BloodBath_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Featherfoot3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_BloodBath_Ratio2(skill)

    local value = 10
    return value;

end

function SCR_GET_BloodSucking_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Featherfoot4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_BloodSucking_Ratio2(skill)

  local value = 50
  return value;

end

function SCR_GET_BloodSucking_Ratio3(skill)

  local value = 40 + skill.Level * 2
  return value;

end


function SCR_GET_BonePointing_Ratio2(skill)
    local value = 35
    return value;
end



function SCR_GET_Kurdaitcha_Ratio(skill)

  local value = 15
  return value;
  
end

function SCR_GET_Kurdaitcha_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 15
    
    local abil = GetAbility(pc, 'Featherfoot14')
    if abil ~= nil and 1 == abil.ActiveState then
        value = 5
    end
    
    return value;
end

function SCR_GET_HeadShot_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 * skill.Level
    if IsPVPServer(pc) == 1 then
        value = (5 * skill.Level) + (pc.HR * 0.1)
    end
    return value;
end

function SCR_GET_HealingFactor_Time(skill)
    local value = 60
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = 20
    end
    
    return value;
end

function SCR_GET_HealingFactor_Ratio(skill)
    local value = 1020 + (skill.Level - 1) * 137.5
    return math.floor(value);
end

function SCR_GET_Bloodletting_Time(skill)

  local value = 30 + skill.Level * 5
  
  local pc = GetSkillOwner(skill);
  if IsPVPServer(pc) == 1 then
    value = value / 3
  end
   
  return math.floor(value);
  
end

function SCR_GET_Bloodletting_Ratio(skill)

  local value = 6 - skill.Level
  
  if value <= 0 then
  value = 1
  end
  
  return value;
  
end

function SCR_GET_Fumigate_Ratio(skill)

  local value = 2 + skill.Level
  return value;
  
end

function SCR_GET_Pandemic_Ratio(skill)

  local value = 3 + skill.Level * 2
  return value;
  
end

function SCR_GET_BeakMask_Time(skill)
    local value = 60
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 3
    end
    
    return math.floor(value);
  
end

function SCR_Get_Modafinil_Ratio(skill)
    local value = 3 + skill.Level * 0.5;
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    local pc = GetSkillOwner(skill)
    local casterMNA = TryGetProp(pc, "MNA");
    local baseLv = TryGetProp(pc, "Lv");
    
    local addRate = casterMNA / baseLv;
    if addRate <= 0 then
        addRate = 0;
    elseif addRate >= 1 then
        addRate = 1;
    end
    
    value = math.floor(value * (1 + addRate));
    
    return value;
end

function SCR_Get_Modafinil_Bufftime(skill)
    local value = 20 + skill.Level * 4;
    
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 3
    end
    
    return math.floor(value)
end

function SCR_GET_Disenchant_Ratio(skill)
    local value = math.min(skill.Level * 10, 100)
    return value;
end

function SCR_GET_Disenchant_Ratio2(skill)
    local value = 2 + skill.Level
    return value;
end

function SCR_Get_SkillFactor_BonePointing2(skill)

    local value = skill.SklFactor
    local owl = GetSkillOwner(skill);
    local pc = GetOwner(owl);
    if pc ~= nil then
        local bonePointingSkl = GetSkill(pc, "Featherfoot_BonePointing")
        value = bonePointingSkl.SkillFactor
    end

    return math.floor(value)

end

function SCR_GET_BonePointing_Ratio(skill)
    local value = 30 + skill.Level * 10

    return math.floor(value)
end

function SCR_GET_Ngadhundi_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Featherfoot7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PoleofAgony_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Invocation_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DarkTheurge_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock7") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DarkTheurge_Ratio2(skill)
    local value = 1
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock18");

    if abil ~= nil and TryGetProp(abil, "ActiveState") == 1 then
        value = value * 2
    end
    
    return value;
end

function SCR_GET_Mastema_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Warlock9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Drain_Bufftime(skill)
    local value = skill.Level * 4.5
    return value
end

function SCR_GET_Drain_Ratio(skill)
    local value = skill.Level
    return value
end

function SCR_GET_Drain_Ratio2(skill)
    local value = 0.7
    return value
end

function SCR_GET_Hagalaz_Ratio(skill)
    local value = skill.Level * 5
    
    return value;
end

function SCR_GET_Tiwaz_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "RuneCaster5") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_FleshStrike_Ratio(skill)
    local value = skill.Level * 10
    
    return value;
end

function SCR_GET_FleshStrike_Ratio2(skill)
    local value = 100
    
    return value
end

function SCR_GET_AlchemisticMissile_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Alchemist9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_KundelaSlash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Featherfoot11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EnchantedPowder_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Enchanter1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EnchantedPowder_Bufftime(skill)

    local value = 6 + skill.Level * 0.5;
    return value
    
end

function SCR_GET_Rewards_Ratio(skill)

    local value = skill.Level * 10;
    return value
    
end

function SCR_GET_Rewards_Ratio2(skill)

    local value = skill.Level * 10;
    return value
    
end

function SCR_GET_Agility_Ratio2(skill)
    local value = skill.Level * 0.1
    return value
end

function SCR_GET_Agility_Bufftime(skill)

    local value = 300;
    return value
    
end

function SCR_GET_Enchantment_Ratio(skill)

    local value = 4 + skill.Level;
    return value
    
end

function SCR_GET_EnchantLightning_Bufftime(skill)

    local value = 300
    return value
    
end

function SCR_GET_EnchantLightning_Ratio(skill)
--    local value = 100 * skill.Level
    local pc = GetSkillOwner(skill);
    local value = 160 + ((skill.Level - 1) * 60) + ((skill.Level / 5) * ((pc.DEX * 0.8) ^ 0.9))
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_Empowering_Bufftime(skill)

    local value = skill.Level * 10 + 20
    return value
    
end

function SCR_GET_Empowering_Ratio(skill)

    local value = skill.Level;
    return value
    
end

function SCR_GET_Empowering_Ratio2(skill)

    local value = skill.Level * 10;
    return value
    
end

function SCR_GET_Portal_Ratio(skill)
    local value = 3
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sage1")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value;
end

function SCR_GET_Portal_Time(skill)
    local value = 30 - (skill.Level - 1)
    return value;
end

function SCR_GET_MicroDimension_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sage2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_UltimateDimension_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sage3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end


function SCR_GET_HoleOfDarkness_Ratio(skill)
    local value = 10
    return math.floor(value)
end

function SCR_GET_HoleOfDarkness_Ratio2(skill)
    local value = 20
    return math.floor(value)
end

function SCR_GET_Gevura_Ratio(skill)
    local value = skill.Level * 20
    
    return value
end

function SCR_GET_Maze_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sage6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Maze_Bufftime(skill)

    local value = 5 + skill.Level * 1;
    return value

end

function SCR_GET_Blink_Bufftime(skill)

    local value = skill.Level * 2;
    return value

end

function SCR_GET_MissileHole_Bufftime(skill)
    local value = 5 + (skill.Level * 0.5);
    
    return value
end

function SCR_GET_MissileHole_Ratio(skill)
    local value = 4 + (skill.Level - 1) * 3;
    
    local pc = GetSkillOwner(skill)
    
    return math.floor(value)
end

function SCR_GET_Heal_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Cleric12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Heal_Time(skill)

    local pc = GetSkillOwner(skill);
    local value = 40;
    
    if IsPVPServer(pc) == 1 then
        value = 10;
    end
    
    return value

end

function SCR_GET_DivineMight_Ratio(skill)
    local value = skill.Level
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Oracle20")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Zaibas_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Kriwi11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Aspersion_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Priest11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Exorcise_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = (pc.MNA + pc.INT) * skill.Level
    
    return math.floor(value)
end

function SCR_GET_Exorcise_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Priest20") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Effigy_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Bokor11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Damballa_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Bokor12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Damballa_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = skill.Level * 3
  return value

end

function SCR_GET_BwaKayiman_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Bokor18") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Carve_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dievdirbys11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_Get_SkillFactor_CarveOwl2(skill)

    local value = skill.SklFactor
    local owl = GetSkillOwner(skill);
    local pc = GetOwner(owl);
    if pc ~= nil then
        local carveOwlSkl = GetSkill(pc, "Dievdirbys_CarveOwl")
        if carveOwlSkl ~= nil then
            value = carveOwlSkl.SkillFactor
        end
    end

    return math.floor(value)

end

function SCR_GET_OwlStatue_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Dievdirbys12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_AstralBodyExplosion_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sadhu11") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end

function SCR_GET_Possession_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Sadhu12") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Possession_Ratio2(skill)
    local value = skill.Level * 1 + 4;
    return math.floor(value)
end

function SCR_Get_SkillFactor_EctoplasmAttack(skill)
    local pc = GetSkillOwner(skill);
    local OutofBodySkill = GetSkill(pc, "Sadhu_OutofBody")
    local value = 0
    if OutofBodySkill ~= nil then
        value = OutofBodySkill.SkillFactor;
    end
    return math.floor(value)
end

function SCR_Get_Levitation_ratio(skill)
    local value = 30;
    return value;
end

function SCR_Get_BloodCurse_ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 60
    
    local abil = GetAbility(pc, 'Featherfoot12')
    if abil ~= nil and 1 == abil.ActiveState then
        value = 40
    end
    
    return value;
end

function SCR_Get_BloodCurse_BuffTime(skill)

    local value = 7 + 0.5 * skill.Level
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, 'Featherfoot12')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 7
    end
    
    return value;
end

function SCR_GET_Smite_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Paladin14") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Demolition_Ratio(skill)
    local value = skill.Level * 2;
    return value
end

function SCR_GET_Conviction_BuffTime(skill)
    local value = 20
    return value
end

function SCR_GET_Conviction_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Paladin17") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Conviction_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = skill.Level * 2;
    
    return value

end

function SCR_GET_CorpseTower_Bufftime(skill)

    local value = 30;
    
    return value

end

function SCR_GET_DoublePunch_Ratio(skill)
    local value = skill.Level * 20
    return value
end

function SCR_GET_DoublePunch_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * (pc.Lv * 0.15)
    return value
end

function SCR_Get_SkillFactor_DoublePunch(skill)
    local pc = GetSkillOwner(skill);
    local DoublePunchSkill = GetSkill(pc, "Monk_DoublePunch")
    local value = 0
    if DoublePunchSkill ~= nil then
        value = DoublePunchSkill.SkillFactor;
    end
    return math.floor(value)
end

function SCR_GET_PalmStrike_Ratio(skill)
    local value = 2 * skill.Level
    return value
end

function SCR_GET_HandKnife_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Monk18") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Bunshin_no_jutsu_BuffTime(skill)


    local value = skill.Level * 10

 return value

end

function SCR_GET_Aspergillum_Time(skill)
    local value = skill.Level * 60
    
    return value
end

function SCR_GET_Methadone_Time(skill)
    local value = 5 + skill.Level
    
    return value
end

function SCR_GET_IronMaiden_Time(skill)
    local value = 4 + skill.Level * 0.5
    
    return value
end

function SCR_GET_Judgment_Bufftime(skill)
    local value = 15 + skill.Level
    
    return value
end

function SCR_GET_LastRites_Time(skill)
    local value = 150 + skill.Level * 30
    return value
end

function SCR_GET_LastRites_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local pcLevel = TryGetProp(pc, "Lv")
    local pcMNA = TryGetProp(pc, "MNA")
    
    local pcLevelRate = (pcLevel / 6.5) + 15
    local baseDamageValue = 200 + (skill.Level - 1) * pcLevelRate
    local pcMnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
    local value = baseDamageValue * pcMnaRate
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_MagnusExorcismus_Time(skill)


    local value = 9
    return value

end

function SCR_GET_BuildCappella_Ratio(skill)
    local value = 30

    return value
end

function SCR_GET_BuildCappella_Ratio2(skill)
    local value = skill.Level * 10
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_Binatio_Ratio(skill)
    local value = 55 + skill.Level * 15;
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_Binatio_Time(skill)
    local value = 30;
    return value
end

function SCR_GET_ParaclitusTime_Time(skill)
    local value = 10 + skill.Level * 2
    return value
end

function SCR_GET_1InchPunch_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Monk21") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EnergyBlast_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Monk23") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_EnergyBlast_Ratio3(skill)
    local value = 35 + skill.Level * 1;
    return value;
end

function SCR_GET_God_Finger_Flicking_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Monk24") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Indulgentia_Ratio2(skill)
    local value = 76 + (skill.Level - 1) * 10
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_IncreaseMagicDEF_Bufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 300
    
    local abil = GetAbility(pc, "Pardoner6")
    local ActiveState = TryGetProp(abil, "ActiveState")
    if abil ~= nil and ActiveState == 1 then
        local abilLevel = TryGetProp(abil, "Level")
        local abilValue = abilLevel * 20
        
        value = value + abilValue
    end
    
    return value
end


function SCR_GET_IncreaseMagicDEF_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 1.5
    local pcStat = TryGetProp(pc, "MNA", 1)
    local pcLevel = TryGetProp(pc, "Lv", 1)
    local casterMnaRate = (pcStat / (pcStat + pcLevel) * 2) + 0.15
    
    value = value * casterMnaRate
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return value
end

function SCR_GET_IncreaseMagicDEF_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 3;

    return value
end

function SCR_GET_Incineration_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "PlagueDoctor2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end

function SCR_GET_Incineration_Ratio2(skill)
    local value = 10

    return value
end

function SCR_GET_Incineration_Ratio3(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "PlagueDoctor15") 
    local value = 0.5
    if abil ~= nil and TryGetProp(abil, "ActiveState", 0) == 1 then 
        value = value - 0.2   
    end

    return value
end

function SCR_GET_Nachash_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Kabbalist3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Merkabah_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Kabbalist8") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Merkabah_Ratio2(skill)

    local value = skill.Level * 10;
    return value
end

function SCR_GET_MagnusExorcismus_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Chaplain3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PlagueVapours_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "PlagueDoctor9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PlagueVapours_Bufftime(skill)
    local value = 15
    return value
end

function SCR_GET_IronMaiden_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Inquisitor2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_HereticsFork_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Inquisitor3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_IronBoots_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Inquisitor4") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PearofAnguish_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Inquisitor6") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_PearofAnguish_Ratio2(skill)

    local value = 5;
    return value

end

function SCR_GET_BreakingWheel_Bufftime(skill)
    local value = 10;
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Inquisitor20")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_MalleusMaleficarum_Bufftime(skill)

    local value = 7 + skill.Level * 3
    return value

end

function SCR_GET_MalleusMaleficarum_Ratio(skill)
    local value = 6 + (skill.Level -1)* 6;
    return value;
end

function SCR_GET_GodSmash_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Inquisitor10")
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end
end

function SCR_GET_Entrenchment_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Daoshi2") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Hurling_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Daoshi3") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_StormCalling_Ratio(skill)
    local value = skill.Level * 5
    return math.floor(value)
end

function SCR_GET_PhantomEradication_Ratio(skill)
    local value = 6;
    return math.floor(value)
end

function SCR_GET_BegoneDemon_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Daoshi9") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_DarkSight_Time(skill)
    local value = skill.Level * 60
    
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        value = 30;
    end
    
    return value;
end

function SCR_GET_DarkSight_Ratio(skill)
    local value = 40 * (1 + skill.Level * 0.1)
    return math.floor(value)
end

function SCR_GET_Hurling_Ratio2(skill)
    local value = skill.Level
    return value
end

function SCR_GET_HiddenPotential_Ratio(skill)
    local value = 10 * skill.Level
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Daoshi5")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_HiddenPotential_Ratio2(skill)
    local value = 50 * skill.Level
    return value
end

function SCR_GET_HiddenPotential_Time(skill)
    local value = 60
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Daoshi6")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 5;
    end
    
    return value
end

function SCR_GET_StormCalling_Ratio2(skill)
    local value = skill.Level * 20
    return value
end

function SCR_GET_StormCalling_Time(skill)
    local value = 3 + skill.Level
    
    return value
end

function SCR_GET_TriDisaster_Time(skill)
    local value = 12 * skill.Level
    return value;
end

function SCR_GET_TriDisaster_Ratio(skill)
    local value = skill.Level * 5
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return math.floor(value);
end

function SCR_GET_CreepingDeath_Ratio(skill)
    local value = skill.Level * 4
    return value;
end

function SCR_GET_CreepingDeath_Ratio2(skill)
    local value = 624
    
    return math.floor(value);
end

function SCR_GET_ShapeShifting_Bufftime(skill)
    local value = 50 + skill.Level * 10
    return value
end

function SCR_GET_Transform_Bufftime(skill)
    local value = 50 + skill.Level * 10
    return value
end

function SCR_GET_Lycanthropy_Bufftime(skill)
    local value = 100
    
    return value
end

function SCR_GET_Lycanthropy_Ratio(skill)
    local value = skill.Level * 10
    
    return value;
end

function SCR_GET_Lycanthropy_Ratio2(skill)
    local value = skill.Level * 10
    
    local pc = GetSkillOwner(skill);
    local abilDruid20 = GetAbility(pc, "Druid20");
    if abilDruid20 ~= nil and TryGetProp(abilDruid20, 'ActiveState') == 1 then
        value = value + 10
    end
    
    return value;
end

function SCR_Get_SkillFactor_Muleta(skill)
    local pc = GetSkillOwner(skill);
    local MuletaSkill = GetSkill(pc, "Matador_Muleta")
    local value = 0
    if MuletaSkill ~= nil then
        value = MuletaSkill.SklFactor + (MuletaSkill.Level - 1) * MuletaSkill.SklFactorByLevel
        
        local abil = GetAbility(pc, "Matador1")      -- Skill Damage add
        if abil ~= nil then
            value = SCR_ABIL_ADD_SKILLFACTOR(MuletaSkill, abil, value);
        end
    end
    
    return math.floor(value)
end

function SCR_Get_Muleta_CastTime(skill)
    local value = 1;
    
    local pc = GetSkillOwner(skill);
    local abilMatador7 = GetAbility(pc, "Matador7");
    if abilMatador7 ~= nil and TryGetProp(abilMatador7, 'ActiveState') == 1 then
        value = value + (abilMatador7.Level * 0.5);
    end
    
    return value;
end

function SCR_Get_Muleta_Ratio(skill)
    local value = 914 + (skill.Level - 1) * 50.3
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Matador1")
    if abil ~= nil then
        value = value * (1 + (abil.Level * 0.005))
    end
    
    return math.floor(value)
end

function SCR_Get_Muleta_Ratio2(skill)
    local value = skill.Level * 2
    
    return value
end

function SCR_Get_SkillFactor_DoubleGun(skill)
    local pc = GetSkillOwner(skill);
    local DoubleGunSkill = GetSkill(pc, "Bulletmarker_DoubleGunStance")
    local value = 0
    if DoubleGunSkill ~= nil then
        value = DoubleGunSkill.SklFactor + (DoubleGunSkill.Level - 1) * DoubleGunSkill.SklFactorByLevel
    end
    
    return math.floor(value)
end

function SCR_GET_DoubleGunStance_Ratio(skill)
    local value = 100 + skill.Level * 10
    
    return value
end

function SCR_GET_EmperorsBane_Time(skill)
    local value = 4
    return value;
end

function SCR_GET_EmperorsBane_Ratio(skill)
    local value = 8
    return value;
end

function SCR_GET_Gohei_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Miko1") 
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Hamaya_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Miko3")
    local value = 0
    if abil ~= nil then 
        return SCR_ABIL_ADD_SKILLFACTOR_TOOLTIP(abil);
    end

end

function SCR_GET_Hamaya_Ratio2(skill)

    local value = 10
    return value
        

end

function SCR_GET_HoukiBroom_Time(skill)
    local value = 5
    return math.floor(value)
end

function SCR_GET_HoukiBroom_Ratio(skill)
    local value = 5 + skill.Level
    return math.floor(value)
end

function SCR_GET_KaguraDance_Time(skill)
    local value = 10;
    return math.floor(value)
end

function SCR_GET_KaguraDance_Ratio(skill)
    local value = 70 + skill.Level * 2
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Miko8")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.3
    end
    
    return math.floor(value)
end

function SCR_GET_Omikuji_Time(skill)
    local value = 30
    return math.floor(value)
end

function SCR_GET_Omikuji_Ratio(skill)
    local value = 20 * skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_Omikuji_Ratio2(skill)
    local value = 10 * skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_Omikuji_Ratio3(skill)
    local value = 5 * skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_Invulnerable_Time(skill)
    local value = 20 + skill.Level
    
    return value
end

function SCR_GET_Immolation_Ratio2(skill)
    local value = skill.Level * 0.001
    
    return value
end

function SCR_GET_Fanaticism_Ratio(skill)
    local value = 10 + ((skill.Level - 1) * 5)
    
    return value
end

function SCR_GET_BlindFaith_Ratio(skill)
    local value = 20 + ((skill.Level - 1) * 20)
    
    return value
end

function SCR_GET_FanaticIllusion_Time(skill)
    local value = 5 + skill.Level * 2

    return value
end

function SCR_GET_Fanaticism_Time(skill)
    local value = 10 + skill.Level * 2

    return value
end

function SCR_GET_KaguraDance_Ratio2(skill)
    local value = 10 * skill.Level
    return math.floor(value)
end


--[BodkinPoint]]--

function SCR_Get_BodkinPoint_SkillFactor(skill)

    local value = 112 + skill.Level * 8;
    return value;
end

function SCR_GET_SR_LV_BodkinPoint(skill)

    local pc = GetSkillOwner(skill);
    return math.floor(1 + pc.SR + (skill.Level * 0.2))

end

function SCR_GET_SR_LV_Skarphuggning(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Hackapell10")
    local value = pc.SR + skill.SklSR
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_Kasiwade_Ratio(skill)

    local value = skill.Level * 5
    return value;
end


function SCR_GET_SR_LV_Stabbing(skill)

    return 1

end

function SCR_Get_BodkinPoint_Ratio(skill)

    return 25 + skill.Level * 1;

end

function SCR_Get_DeployPavise_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 30;
    
    local abil = GetAbility(pc, 'QuarrelShooter24')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 0.5;
    end
    
    return math.floor(value);
end

function SCR_Get_DeployPavise_Ratio(skill)
    local value = 15 + skill.Level * 5;
    
    local pc = GetSkillOwner(skill);
    if IsPVPField(pc) == 1 then
        value = 15;
    else
        local abil = GetAbility(pc, 'QuarrelShooter24')
        if abil ~= nil and abil.ActiveState == 1 then
            value = math.ceil(value * 0.5)
        end
    end
    
    return value;
end

function SCR_Get_DeployPavise_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'QuarrelShooter9')
    local value = 40
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level * 1
    end
    
    return value 
end

function SCR_Get_BounceShot_Ratio(skill)
    
    local value = 6;
    return value
    
end

function SCR_Get_SmokeBomb_Ratio(skill)

    return 50 + skill.Level * 0.5;

end

function SCR_Get_ArrowSprinkle_Ratio(skill)

    return 0 + skill.Level;

end


function SCR_Get_SteadyAim_Ratio(skill)
    local value = skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_Get_SteadyAim_Ratio2(skill)
    local value = skill.Level * 1.5
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end


function SCR_Get_Retrieve_Bufftime(skill)
    return 4 + skill.Level;
end

function SCR_Get_Retrieve_Ratio(skill)

    return 10 + 6 * skill.Level;
    
end

function SCR_Get_Hounding_Ratio(skill)
    local value = skill.Level * 100
    return value;
end

function SCR_Get_Snatching_Bufftime(skill)
    
    return 2 * skill.Level;
    
end


function SCR_Get_StoneCurse_Bufftime(skill)
    local pc = GetSkillOwner(skill)
    local value = 1 + skill.Level;
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 3
    end
    
    return value
    
end

function SCR_Get_StoneCurse_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 5;
    
    local abil = GetAbility(pc, 'Elementalist2')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value
end

function SCR_Get_SummonFamiliar_Ratio(skill)
    return skill.Level
end

function SCR_Get_SummonSalamion_BuffTime(skill)
    local pc = GetSkillOwner(skill)
    return 50 + skill.Level * 10
end


function SCR_Get_SummonSalamion_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    return pc.Lv
end

function SCR_Get_SummonSalamion_Ratio(skill)
    local value = 5 + (skill.Level * 3);
    
    return value;
end


function SCR_Get_SummonServant_Ratio(skill)
    local value = skill.Level
    
    if value > 5 then
        value = 5
    end
    
    return value
end

function SCR_Get_Hail_Bufftime(skill)
    local value = 10
    
    return value
end

function SCR_Get_Rain_Bufftime(skill)
    local value = 8 + skill.Level * 2
    return value
end

function SCR_Get_Rain_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 0;
    
    local abil = GetAbility(pc, 'Elementalist9')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 5;
    end
    
    return value;
end

function SCR_GET_SafetyZone_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 2;
    
    local abil = GetAbility(pc, 'Cleric18')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 1;
    end
    
    return value;
end


function SCR_GET_Briquetting_Ratio(skill)
    local value = 4.5 + skill.Level * 0.5;
    return value
end

function SCR_GET_ItemAwakening_Ratio(skill)
    return skill.Level;
end

function SCR_GET_Arrest_Ratio(skill)
    local value = 1 + skill.Level * 1
    return value
end
function SCR_Get_Quicken_Ratio(skill)
    local value = 15 + (skill.Level * 10)
    return value
end

function SCR_GET_Quicken_Bufftime(skill)
    return 30 + skill.Level * 6
end

function SCR_GET_Samsara_Bufftime(skill)
    return 5 + skill.Level * 1
end

function SCR_GET_Stop_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 5 + skill.Level * 1
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5
    end
    
    return math.floor(value)
end

function SCR_Get_Bodkin_Ratio(skill)
    local value = skill.Level * 1
    
    return value;
end


function SCR_Get_Haste_Bufftime(skill)
    local value = 40 + skill.Level * 8;
    
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 then
        value = value / 3
    end
    
    return math.floor(value)
end

function SCR_Get_CreateShoggoth_Ratio(skill)
    local value = 10 + (skill.Level * 5);
    return math.floor(value);
end

function SCR_Get_CreateShoggoth_Ratio2(skill)
    local value = 10 + (skill.Level * 5);
    return math.floor(value);
end

function SCR_Get_CreateShoggoth_Ratio3(skill)
    local value = 100
    local masterValue = 0
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Necromancer5")
    if abil ~= nil then
        if abil.Level == 100 then
            masterValue = 10
        end
        
        value = value + abil.Level * 0.5 + masterValue;
    end
    
    return value;
end

function SCR_Get_CreateShoggoth_Parts(skill)
  local pc = GetSkillOwner(skill);
    local value = 30
    return value
end

function SCR_Get_FleshCannon_Ratio(skill)
    local value = 15
    return value
end

function SCR_Get_FleshHoop_Ratio(skill)
    local value = 5
    return value
end

function SCR_GET_DirtyWall_Bufftime(skill)
    local value = 14 + skill.Level
    return value
end

function SCR_GET_DirtyWall_Ratio(skill)
    local value = 2 + skill.Level
    return value
end

function SCR_GET_DirtyWall_Ratio2(skill)
    local value = 30
    return value
end

function SCR_GET_DirtyPole_Time(skill)
    local value = 14 + skill.Level
    return value
end

function SCR_GET_DirtyPole_Ratio(skill)
    local value = 20 + skill.Level * 2
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 then
        value = 900
    end
    return value
end

function SCR_GET_DirtyPole_Ratio2(skill)
    local value = 5
    return value
end

function SCR_GET_Disinter_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 70;
    
    return value
end


function SCR_Get_Cloaking_Bufftime(skill)
    return 10 + skill.Level * 2;
end

function SCR_GET_Cloaking_Ratio(skill)
    local value = 10 + skill.Level * 2;
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value
end

function SCR_GET_DoubleAttack_Ratio(skill)
    local value = skill.Level * 5
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_DoubleAttack_Ratio2(skill)
    local value = 40
    return value
end

function SCR_GET_FreeStep_Ratio(skill)
    local value = skill.Level * 4
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value
end



function SCR_Get_SwellBody_Bufftime(skill)
    
    return 5 + skill.Level;
    
end



function SCR_Get_ShrinkBody_Bufftime(skill)
    
    return 5 + skill.Level;
    
end


function SCR_Get_SwellBody_Ratio(skill)
    
    return math.floor(3 + skill.Level * 0.5)
    
end

function SCR_Get_ShrinkBody_Ratio(skill)
    
    return math.floor(3 + skill.Level * 0.5)
    
end

function SCR_Get_Praise_Bufftime(skill)
    return 60 + 10 * (skill.Level - 1)
end

function SCR_Get_Praise_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 25 + 5 * (skill.Level - 1)
    
    return value;
end

function SCR_Get_Praise_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 0.3 * skill.Level
    
    return value;
end

function SCR_Get_Pointing_Ratio(skill)
    
    return 10 + skill.Level * 6
    
end

function SCR_Get_Growling_Ratio(skill)
    local value = skill.Level * 1.5
    return value
end

function SCR_Get_Growling_Ratio2(skill)
    local value = 3 + (skill.Level - 1) * 1
    return value
end

function SCR_Get_Camouflage_Ratio(skill)

    local value = skill.Level * 5
    return math.floor(value);

end

function SCR_Get_Camouflage_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local spdrate = 1 - (skill.Level * 0.1)
    local value = math.max(30 * spdrate, pc.MSPD * spdrate)
    return math.floor(value);

end

function SCR_Get_FluFlu_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 5;
    
    local Scout6_abil =  GetAbility(pc, 'Scout6')
    if Scout6_abil ~= nil and 1 == Scout6_abil.ActiveState then 
        value = value + (Scout6_abil.Level * 1)
    end

    return value;
end

function SCR_Get_Beprepared_Ratio(skill)

    local value = 5 * skill.Level * 1;
    return math.floor(value);
    

end

function SCR_Get_Fluflu_Bufftime(skill)
    
    local value = 8 + skill.Level * 0.2;
    return math.floor(value);

end

function SCR_Get_StoneShot_Bufftime(skill)
    local value = 4;
    local pc = GetSkillOwner(skill);
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    
    return value;
end

function SCR_GET_SnowRolling_Ratio(skill)
    local value = skill.Level * 2
    
    return math.floor(value);
end

function SCR_GET_Barrier_Ratio(skill)
    local value = 10 * skill.Level
    return value
end

function SCR_GET_Sanctuary_Ratio(skill)
    local value = 3 * skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_Sanctuary_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local MDEF = SCR_CALC_BASIC_MDEF(pc);
    local mdefRate = MDEF * (0.1 * skill.Level)
    
    return math.floor(mdefRate)
end

function SCR_GET_Sanctuary_Ratio3(skill)
    local value = 30
    local pc = GetSkillOwner(skill);
    local level = pc.Lv
    local bylvCorrect = level - 300
    
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    value = value * (1 + bylvCorrect)
    return math.floor(value)
end

function SCR_Get_Undistance_Ratio(skill)
    local value = 55 + skill.Level *5;
    return value
    
end

function SCR_Get_Undistance_Ratio2(skill)

    local value = 10 + skill.Level * 1
    
    return value
    
end

function SCR_Get_DetonateTraps_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 4

    local abil = GetAbility(pc, "Sapper4")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end

    return math.floor(value)

end

function SCR_Get_Detoxify_Ratio(skill)

    local value = 3

    return math.floor(value)
    
end

function SCR_GET_Daino_Ratio(skill)
    local value = TryGetProp(skill, 'Level', 1) * 1.5
    
    return value;
end

function SCR_Get_Coursing_Bufftime(skill)

    local value = 5 + skill.Level * 2;
    return math.floor(value)

end

function SCR_Get_Coursing_Ratio(skill)
    local value = 5 + skill.Level * 0.5;
    return value
end

function SCR_Get_Scan_Time(skill)

    local value = 8 + skill.Level * 2
    return math.floor(value)
    
end

function SCR_Get_Surespell_Bufftime(skill)
    
    return 45 + skill.Level * 18;

end

function SCR_Get_Surespell_Ratio(skill)
    local value = skill.Level - 1
    
    return value
end


function SCR_Get_Quickcast_Bufftime(skill)
    local value = 300
    
    return value;
end

function SCR_Get_Quickcast_Ratio(skill)
    local value = 5 * skill.Level
    if value > 90 then
        value = 90
    end
    return value
end


function SCR_GET_ScatterCaltrop_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 20;
    
    local abil = GetAbility(pc, "QuarrelShooter2")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level;
    end
    
    return value
end

function SCR_Get_ScatterCaltrop_Ratio2(skill)
    local value = skill.Level;
    
    if value > 15 then
        value = 15
    end
    
    return value
end

function SCR_Get_EnergyBolt_SkillFactor(skill)

    local value = 150 + skill.Level * 12;
    return value;

end


function SCR_GET_SR_LV_HighAnchoring(skill)

    local pc = GetSkillOwner(skill);
    return pc.SR + skill.SklSR + skill.Level * 1

end

--[Psychokino_Telekinesis]--
function SCR_Get_Telekinesis_SkillFactor(skill)

    local value = 110 + skill.Level * 3;
    return value;
end

function SCR_GET_Telekinesis_ThrowDist(skill)

    return 30 + skill.Level * 5;

end


function SCR_GET_PsychicPressure_Ratio(skill)
    return skill.Level + 4
end


function SCR_GET_PsychicPressure_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Psychokino10')
    if abil ~= nil and abil.ActiveState == 1 then
        return 2;
    end
    return 1
end

function SCR_GET_PsychicPressure_Ratio3(skill)
    local pc = GetSkillOwner(skill);
    local value = 42
    local bylvCorrect = pc.Lv - 300
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    value = value * (1 + bylvCorrect)
    
    local abil = GetAbility(pc, 'Psychokino10')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.2
    end
    
    return math.floor(value)
end

function SCR_GET_GravityPole_Ratio(skill)
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 then
        return skill.Level * 1
    end
    
    return 10 + skill.Level * 1
end

function SCR_GET_GravityPole_Ratio3(skill)
    local pc = GetSkillOwner(skill);
    local value = 47
    local bylvCorrect = pc.Lv - 300
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    value = value * (1 + bylvCorrect)
    
    local abil = GetAbility(pc, 'Psychokino20')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.2
    end
    
    return math.floor(value)
end


function SCR_GET_Telekinesis_ThrowCount(skill)
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Psychokino1');
    if abil ~= nil and 1 == abil.ActiveState then
        return math.ceil(0.5 * skill.Level) + abil.Level;
    end

    return math.ceil(0.5 * skill.Level)
end

function SCR_GET_Telekinesis_Holdtime(skill)
    local pc = GetSkillOwner(skill)
    local value = 3 + skill.Level * 1;
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5;
    end
    
    return math.floor(value);

end

--[Wizard_MagicMissile]--

function SCR_Get_MagicMissile_SkillFactor(skill)

    local value = 160 + skill.Level * 15;
    return value;
end


--[Pyromancer_FireBall]--

function SCR_Get_FireBall_SkillFactor(skill)

    local value = 180 + skill.Level * 14;
    return value;
end

function SCR_GET_SR_LV_FireBall(skill)

    return skill.Level

end

function SCR_GET_SR_LV_WoodCarve(skill)

    return 1;

end


--[Pyromancer_EnchantFire]--
function SCR_GET_EnchantFire_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 30 + ((skill.Level - 1) * 5) + ((skill.Level / 5) * (((pc.INT + pc.MNA) * 0.6) ^ 0.9))
    
--  local Pyromancer23_abil = GetAbility(pc, "Pyromancer23")    -- 2rank Skill Damage multiple
--    local Pyromancer24_abil = GetAbility(pc, "Pyromancer24")    -- 3rank Skill Damage multiple
--    if Pyromancer24_abil ~= nil then
--        value = value * 1.44
--    elseif Pyromancer24_abil == nil and Pyromancer23_abil ~= nil then
--        value = value * 1.38
--    end
    
    local Pyromancer16_abil = GetAbility(pc, 'Pyromancer16');
    if Pyromancer16_abil ~= nil then
        value = value + Pyromancer16_abil.Level
    end

    return math.floor(value)

end

function SCR_GET_EnchantFire_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.MINMATK * 0.1

    return math.floor(value)
  
end

function SCR_Get_FireBall_Bufftime(skill)

  return 20 + skill.Level * 5
  
end

function SCR_GET_HellBreath_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 20
    local bylvCorrect = pc.Lv - 300
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    value = value * (1 + bylvCorrect)
    
    local abil = GetAbility(pc, 'Pyromancer4')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.3
    end
    
    return math.floor(value)
end

function SCR_GET_Rapidfire_Bufftime(skill)

    local value = 1 + skill.Level*0.2
    
    return value
  
end


function SCR_GET_EnchantFire_Bufftime(skill)

  return 300;
  
end

--[Pyromancer_FirePillar]--
function SCR_Get_FirePillar_SkillFactor(skill)

    local value = 26 + skill.Level * 4;
    return value;
end
function SCR_GET_FirePillar_Time(skill)

    return 6 + skill.Level * 0.04;

end


function SCR_GET_FirePillar_HitCount(skill)

    return 5 + skill.Level;

end

function SCR_GET_FireWall_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 5
    
    local abil = GetAbility(pc, "Pyromancer31")
    if abil ~= nil and TryGetProp(abil, "ActiveState", 0) == 1 then
        value = value * 2
    end
    
    return value
end

function SCR_GET_FireWall_Ratio2(skill)
    return 2 + skill.Level;
end


function SCR_GET_IceWall_Ratio(skill)
    return 1 + skill.Level * 1
end


function SCR_GET_ElementalEssence_Ratio(skill)
    local value = skill.Level * 10
    
    return value
end


function SCR_GET_Blessing_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local pcMNA = TryGetProp(pc, "MNA")
    local pcLevel = TryGetProp(pc, "Lv")
    
    local pcLevelRate = (pcLevel / 7) + 10
	local baseDamageValue = 180 + (skill.Level - 1) * pcLevelRate
    local pcMnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
    local value = baseDamageValue * pcMnaRate
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return math.floor(value);
end


function SCR_GET_Blessing_AddCount(skill)
    local pc = GetSkillOwner(skill);
    local value = 2
    
    local Priest6_abil = GetAbility(pc, 'Priest6');
    if Priest6_abil ~= nil and 1 == Priest6_abil.ActiveState then
        value = value + Priest6_abil.Level
    end
    
    return value
end



function SCR_GET_Carve_BuffTime(skill)

    local pc = GetSkillOwner(skill);
    local value = skill.Level * 5
    
    local Dievdirbys1_abil = GetAbility(pc, 'Dievdirbys1');
    if Dievdirbys1_abil ~= nil and 1 == Dievdirbys1_abil.ActiveState then
        value = value + Dievdirbys1_abil.Level
    end
    
    return math.floor(value);

end

function SCR_GET_Sacrament_Bufftime(skill)

    return 800 + skill.Level * 100;

end


function SCR_GET_Sacrament_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local pcLevel = TryGetProp(pc, "Lv")
    local pcMNA = TryGetProp(pc, "MNA")
    
    local pcLevelRate = (pcLevel / 7) + 10
    local baseDamageValue = 180 + (skill.Level - 1) * pcLevelRate
    local pcMnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
    local value = baseDamageValue * pcMnaRate
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)

    return math.floor(value)
end

function SCR_GET_Revive_Bufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 90
    if IsPVPServer(pc) == 1 then
        value = 30
    end
    local Priest21_abil = GetAbility(pc, 'Priest21')
    if Priest21_abil ~= nil and 1 == Priest21_abil.ActiveState and IsPVPServer(pc) == 0 then
        value = value + Priest21_abil.Level * 7
    end
    
    return value
end

function SCR_GET_Revive_Ratio(skill)
    local value = 10 * skill.Level
    
    return value
end

function SCR_GET_Revive_Ratio2(skill)
    return skill.Level;
end

function SCR_GET_Exorcise_Bufftime(skill)
    local value = 10
    
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Priest23')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    return value
end

function SCR_GET_MassHeal_Ratio(skill)
    local value = 422.4 + (skill.Level - 1) * 202.56
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value
end

function SCR_GET_MassHeal_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 100 + pc.INT + pc.MNA + (skill.Level - 1) * 35
    return value
end

function SCR_GET_StoneSkin_Ratio(skill)
    local value = skill.Level * 0.4
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end


function SCR_GET_MeteorSwarm_Count(skill)
    local meteorCount = 1 + (skill.Level - 1) / 2
    
    if meteorCount > 10 then
        meteorCount = 10;
    end
    return math.floor(meteorCount);
end

function SCR_GET_Burrow_Ratio(skill)
local value = 5 * skill.Level
return value
end

function SCR_Get_HellFire_SkillFactor(skill)

    local value = 57 + skill.Level * 3;
    return value;
end


function SCR_GET_Wizard_Wild_Ratio(skill)
    
    return 15 + skill.Level * 2;
    
end

function SCR_GET_Wizard_Wild_Ratio2(skill)
    
    return 60 - skill.Level * 10;
    
end

function SCR_GET_SwiftStep_Bufftime(skill)
    return 300
end

function SCR_GET_SwiftStep_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 10 - skill.Level;
    
    if value <= 0 then
        value = 1;
    end
    
    return value

end

function SCR_GET_SwiftStep_Ratio2(skill)
    local value = 3 * skill.Level;
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill));
    
    return value
end

function SCR_GET_SwiftStep_Ratio3(skill)
     local mspdadd = 15
     return mspdadd;
end

function SCR_GET_Concentration_Ratio(skill)
     local value = 2 * skill.Level;
     value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
     
     return value;
end

function SCR_GET_Concentration_BuffTime(skill)
     local value = 300
     return value;
end

function SCR_Get_Fulldraw_BuffTime(skill)

    local pc = GetSkillOwner(skill);
    return 5 + 1 * skill.Level;

end

function SCR_Get_Lethargy_Bufftime(skill)
    local value = 20;
    local pc = GetSkillOwner(skill);
    
    local Wizard6_abil = GetAbility(pc, 'Wizard6')
    if Wizard6_abil ~= nil and 1 == Wizard6_abil.ActiveState then 
        value = value + Wizard6_abil.Level * 2
    end
    
    return value
end

function SCR_GET_SpiralArrow_Ratio(skill)
    return 6;
end



function SCR_GET_Lethargy_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = skill.Level * 2
    local abil = GetAbility(pc, "Wizard27")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * (1 + (abil.Level * 0.005))
    end
    
    return math.floor(value)
end

function SCR_GET_Lethargy_Ratio2(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_Lethargy_Ratio3(skill)
    local value = skill.Level * 3
    
    return value
end

function SCR_GET_KneelingShot_Ratio(skill)
    local value = 15;
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    return value;
end

function SCR_GET_KneelingShot_Ratio2(skill)
    local value = 250
    return value
end

function SCR_GET_KneelingShot_Ratio3(skill)
    local value = skill.Level * 30
    return value
end


function SCR_GET_BlockAndShoot_Ratio(skill)
    local value = skill.Level * 20
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value
end


function SCR_GET_ObliqueShot_Ratio(skill)
    local value = 50
    return math.floor(value)
end

function SCR_GET_Carve_Ratio(skill)
    local value = skill.Level * 5
    
    return value
end


function SCR_GET_CarveZemina_Ratio2(skill)
    local value = 15 + (skill.Level * 2)
    
    return value
end


function SCR_GET_OwlStatue_Bufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 20 + skill.Level * 2;
    return value
end

function SCR_GET_OwlStatue_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 50;
    
    if IsPVPServer(pc) == 1 then
        value = 25;
    end
    
    return value
end


function SCR_GET_SR_LV_Crown(skill)

    local pc = GetSkillOwner(skill);

    return pc.SR
end


function SCR_GET_CrossGuard_Ratio(skill)

    local pc = GetSkillOwner(skill);
--    local value = 3.9 * (skill.Level * 1);
    local value = pc.DEF * (0.005 * skill.Level)
    local Highlander22_abil = GetAbility(pc, "Highlander22")    -- 2rank Skill Damage multiple
    local Highlander23_abil = GetAbility(pc, "Highlander23")    -- 3rank Skill Damage multiple
    if Highlander23_abil ~= nil then
        value = value * 1.44
    elseif Highlander23_abil == nil and Highlander22_abil ~= nil then
        value = value * 1.38
    end

    local Highlander15_abil = GetAbility(pc, 'Highlander15');
    if Highlander15_abil ~= nil and skill.Level >= 3 then
        value = value + Highlander15_abil.Level;
    end

    return math.floor(value);

end

function SCR_GET_CrossGuard_Ratio2(skill)
    local value = skill.Level
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_GET_CrossGuard_Ratio3(skill)
    local value = 95 + skill.Level * 5
    return value
end

function SCR_GET_CorpseTower_Ratio(skill)
    local value = 30 + skill.Level * 5
    return math.floor(value);

end

function SCR_GET_CorpseTower_Ratio2(skill)
    local value = 7
    return math.floor(value);

end

function SCR_GET_CorpseTower_Ratio3(skill)
--    local value = 100
--    local masterValue = 0
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, "Necromancer6")
--    if abil ~= nil then
--        if abil.Level == 100 then
--            masterValue = 10
--        end
--        
--      value = value + abil.Level * 0.5 + masterValue;
--    end
    local value = 100 + (skill.Level * 4)
    
    return value;
end

function SCR_GET_RaiseDead_Ratio(skill)
    local value = skill.Level
    return math.floor(value);

end

function SCR_GET_RaiseDead_Ratio2(skill)
   local value = 5
   return math.floor(value);
end

function SCR_GET_RaiseDead_Ratio3(skill)
--    local value = 100
--    local masterValue = 0
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, "Necromancer7")
--    if abil ~= nil then
--        if abil.Level == 100 then
--            masterValue = 10
--        end
--        
--      value = value + abil.Level * 0.5 + masterValue;
--    end
        
    local value = 100 + (skill.Level * 10)
    
    return value;
end

function SCR_GET_RaiseSkullarcher_Ratio(skill)
    local value = skill.Level
    return math.floor(value);

end

function SCR_GET_RaiseSkullarcher_Ratio2(skill)
   local value = 5
    return math.floor(value);

end

function SCR_GET_RaiseSkullarcher_Ratio3(skill)
--    local value = 100
--    local masterValue = 0
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, "Necromancer10")
--    if abil ~= nil then
--        if abil.Level == 100 then
--            masterValue = 10
--        end
--        
--      value = value + abil.Level * 0.5 + masterValue;
--    end
        
    local value = 100 + (skill.Level * 10)
    
    return value;
end

function SCR_GET_RaiseSkullWizard_Ratio2(skill)
   local value = 5
   return math.floor(value);
end

function SCR_GET_RaiseSkullWizard_Ratio3(skill)
    local value = 100 + (skill.Level * 10)
    
    return value;
end

function SCR_GET_Trot_Ratio(skill)
    local value = skill.Level + 5
    
    return value
end

function SCR_Get_IceBolt_SkillFactor(skill)

    local value = 180 + skill.Level * 13;
    return value;
end

function SCR_GET_ReflectShield_Bufftime(skill)
    local value = 300
    
    return value;
end

function SCR_GET_ReflectShield_Ratio(skill)
    local value = 5 + (skill.Level * 3)
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_ReflectShield_Ratio2(skill)
    local value = 30;
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Wizard28')
    if abil ~= nil and abil.ActiveState == 1 then
        value = 5
    end 
    return value;
end

function SCR_GET_ReflectShield_Ratio3(skill)
	local pc = GetSkillOwner(skill)
	local value = 1
	if IsPVPField(pc)== 1 then
		value = 8
	end
	return value;
end

function SCR_GET_Exchange_Bufftime(skill)

    return 10 + skill.Level;

end

function SCR_GET_Exchange_Ratio(skill)

    return 25

end

function SCR_GET_IceWall_Bonus(skill)

    return 100 + 30 * skill.Level;

end

function SCR_GET_IceWall_Bufftime(skill)

    local lv = 5.5 - 0.5 * skill.Level;
    return math.max(3, lv);

end

function SCR_Get_IceTremor_SkillFactor(skill)

    local value = 233 + skill.Level * 31;
    return value;
end

function SCR_GET_SR_LV_IceTremor(skill)

    local pc = GetSkillOwner(skill);
    return skill.Level * 1

end

function SCR_GET_SR_LV_Fleche(skill)

    local pc = GetSkillOwner(skill);
    return 3

end

function SCR_GET_SubzeroShield_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 3;
    
    local abil = GetAbility(pc, "Cryomancer7")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 0.5
    end
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end    
    
    return value
end

function SCR_GET_SubzeroShield_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 10 + skill.Level * 5
    local abilCryomancer9 = GetAbility(pc, "Cryomancer9");
    if abilCryomancer9 ~= nil and TryGetProp(abilCryomancer9, "ActiveState") == 1 then
        value = math.floor(value * (1 + abilCryomancer9.Level * 0.05));
    end
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    
    return value;

end

function SCR_GET_Roasting_Ratio(skill)

    local value = skill.Level * 1
    return value

end

function SCR_GET_SubzeroShield_BuffTime(skill)

    local value = 15 + skill.Level * 3
    return value

end

function SCR_GET_IceWall_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 15
    local abil = GetAbility(pc, 'Cryomancer22')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + 10
    end
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 or IsRaidField(pc) == 1 then
        value = value / 2
    end    
    
    return value
end

function SCR_GET_SR_LV_Gust(skill)

    local pc = GetSkillOwner(skill);
    return pc.SR + math.floor(skill.Level / 5);

end

function SCR_GET_Gust_Distance(skill)

    return 200;

end

function SCR_GET_Gust_Ratio(skill)
    local value = 5 + skill.Level;
    
    return value
end

function SCR_GET_Gust_Bufftime(skill)

    local value = 4 + skill.Level * 0.1;
    return math.floor(value);

end

function SCR_Get_IciclePike_SkillFactor(skill)

    local value = 238 + skill.Level * 12;
    return value;
end

function SCR_Get_Effigy_SkillFactor(skill)

    local value = 209 + skill.Level * 17;
    return value;
end

function SCR_Get_StabDoll_Dist(skill)

    return (50 + 10 * skill.Level);

end

function SCR_GET_Effigy_Bonus(skill)

    local min = 160 + 7 * (skill.Level-1)
    local max = 230 + 9 * (skill.Level-1)

    return IMCRandom(min, max)

end

-- done , ?´ë‹¹ ?¨ìˆ˜ ?´ìš©?€ cppë¡??´ì „?˜ì—ˆ?µë‹ˆ?? ë³€ê²??¬í•­???ˆë‹¤ë©?ë°˜ë“œ???„ë¡œê·¸ëž˜?€???Œë ¤ì£¼ì‹œê¸?ë°”ëž?ˆë‹¤.
function SCR_GET_Effigy_Ratio(skill)
    local value = 1.60 + 0.07 * (skill.Level-1);
    return value
end

-- done , ?´ë‹¹ ?¨ìˆ˜ ?´ìš©?€ cppë¡??´ì „?˜ì—ˆ?µë‹ˆ?? ë³€ê²??¬í•­???ˆë‹¤ë©?ë°˜ë“œ???„ë¡œê·¸ëž˜?€???Œë ¤ì£¼ì‹œê¸?ë°”ëž?ˆë‹¤.
function SCR_GET_Effigy_Ratio2(skill)
    local value = 2.3 + 0.09 * (skill.Level-1)
    return value
end

function SCR_GET_SR_LV_Damballa(skill)
    return skill.Level * skill.SklSR
end

function SCR_GET_SR_LV_TwistOfFate(skill)
    return 0
end

function SCR_GET_Barrier_Bufftime(skill)

    local value = skill.Level * 4
    return math.floor(value)
end

function SCR_GET_Restoration_Ratio(skill)
    local value = 107 + (skill.Level - 1) * 6.2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_ResistElements_Bufftime(skill)
    local value = 45
    return math.floor(value)
end

function SCR_GET_ResistElements_Ratio(skill)
    local value = 10 + skill.Level * 2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_ResistElements_Ratio2(skill)
    
    local pc = GetSkillOwner(skill);
    local value = skill.Level
    
    local abil = GetAbility(pc, "Paladin1")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 0.8
    end
    
    return value
end

function SCR_GET_ResistElements_Ratio3(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 2.5

    return value
end

function SCR_GET_TurnUndead_Ratio(skill)
    return 3 + skill.Level
end

function SCR_Get_IronSkin_Time(skill)
    return 300;
end

function SCR_Get_IronSkin_Ratio(skill)
    local value = skill.Level * 1
    return value
end

function SCR_Get_Golden_Bell_Shield_Ratio(skill)
    local value = 10 * skill.Level;
    return value
end

function SCR_Get_Golden_Bell_Shield_Time(skill)
    return 3 + skill.Level;
end

function SCR_GET_1InchPunch_Bufftime(skill)
    return 5 + skill.Level * 1;
end

function SCR_GET_EnergyBlast_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = pc.MSP * (0.06 - (skill.Level * 0.002))
    
    return math.floor(value)
end

function SCR_GET_God_Finger_Flicking_Ratio(skill)
    local value = 5 + skill.Level * 2
    return value
end

function SCR_GET_God_Finger_Flicking_Ratio2(skill)
    local value = 100
    return value
end

function SCR_GET_DiscernEvil_Ratio(skill)
    local value = 25 + skill.Level * 5
    return value
end

function SCR_GET_DiscernEvil_Ratio2(skill)
    local value = skill.Level * 2
    return value
end

function SCR_GET_Indulgentia_Ratio(skill)
    local value = 3 + skill.Level
    return value
end

function SCR_Get_Oblation_Ratio(skill)
    local value = 100 * skill.Level
    return value
end

function SCR_Get_SpellShop_Ratio(skill)
    local value = 6 * skill.Level
    
    local pc = GetSkillOwner(skill);
    
    local abil = GetAbility(pc, "Pardoner4")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + (abil.Level * 2);
end

    return value
end

function SCR_COMMON_MNA_FACTOR(baseValue, skillLevel, levelFactor, mnaFactor)
    local value = baseValue + (skillLevel - 1) * levelFactor;
    value = value * mnaFactor
    return value
end

function SCR_GET_SpellShop_Sacrament_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local pcLevel = TryGetProp(pc, "Lv")
	local pcMNA = TryGetProp(pc, "MNA")
	
	local levelRate = (pcLevel / 7) + 10
	local mnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
	
    local value = SCR_COMMON_MNA_FACTOR(180, 10, levelRate, mnaRate)
    value = value * 0.3
    
    -- ì£¼ë¬¸ ?ë§¤?ì  ê°œì„¤ ê°•í™” ?¹ì„±?€ ?¬ëŸ¬ê°œë¼??SCR_REINFORCEABILITY_TOOLTIP ?¨ìˆ˜???¬ìš© ë¶ˆê?. ì§ì ‘ ?ìš© ----
    local abilAddRate = 1;
    local reinforceAbil = GetOtherAbility(pc, "Pardoner12")
    if reinforceAbil ~= nil then
        local abilLevel = TryGetProp(reinforceAbil, "Level")
        local masterAddValue = 0
        if abilLevel == 100 then
            masterAddValue = 0.1
        end
        abilAddRate = abilAddRate + (abilLevel * 0.005 + masterAddValue);
    end
    
    value = value * abilAddRate
    
    return math.floor(value)
end

function SCR_GET_SpellShop_Blessing_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local pcLevel = TryGetProp(pc, "Lv")
	local pcMNA = TryGetProp(pc, "MNA")
	
	local levelRate = (pcLevel / 7) + 10
	local mnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
	
    local value = SCR_COMMON_MNA_FACTOR(180, 10, levelRate, mnaRate)
    value = value * 0.3
    
    -- ì£¼ë¬¸ ?ë§¤?ì  ê°œì„¤ ê°•í™” ?¹ì„±?€ ?¬ëŸ¬ê°œë¼??SCR_REINFORCEABILITY_TOOLTIP ?¨ìˆ˜???¬ìš© ë¶ˆê?. ì§ì ‘ ?ìš© ----
    local abilAddRate = 1;
    local reinforceAbil = GetOtherAbility(pc, "Pardoner13")
    if reinforceAbil ~= nil then
        local abilLevel = TryGetProp(reinforceAbil, "Level")
        local masterAddValue = 0
        if abilLevel == 100 then
            masterAddValue = 0.1
        end
        abilAddRate = abilAddRate + (abilLevel * 0.005 + masterAddValue);
    end
    
    value = value * abilAddRate
    
    return math.floor(value)
end

function SCR_GET_SpellShop_IncreaseMagicDEF_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local pcLevel = TryGetProp(pc, "Lv")
	local pcMNA = TryGetProp(pc, "MNA")
	
	local levelRate = 1.5
	local mnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
	
    local value = SCR_COMMON_MNA_FACTOR(1.5, 10, levelRate, mnaRate)
    value = value * 0.3
    
    -- ì£¼ë¬¸ ?ë§¤?ì  ê°œì„¤ ê°•í™” ?¹ì„±?€ ?¬ëŸ¬ê°œë¼??SCR_REINFORCEABILITY_TOOLTIP ?¨ìˆ˜???¬ìš© ë¶ˆê?. ì§ì ‘ ?ìš© ----
    local abilAddRate = 1;
    local reinforceAbil = GetOtherAbility(pc, "Pardoner14")
    if reinforceAbil ~= nil then
        local abilLevel = TryGetProp(reinforceAbil, "Level")
        local masterAddValue = 0
        if abilLevel == 100 then
            masterAddValue = 0.1
        end
        abilAddRate = abilAddRate + (abilLevel * 0.005 + masterAddValue);
    end
    
    value = value * abilAddRate
    
    return value
end

function SCR_GET_SpellShop_Aspersion_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local pcLevel = TryGetProp(pc, "Lv")
	local pcMNA = TryGetProp(pc, "MNA")
	
	local levelRate = 1
	local mnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
	
    local value = SCR_COMMON_MNA_FACTOR(1, 15, levelRate, mnaRate)
    value = value * 0.3
    
    -- ì£¼ë¬¸ ?ë§¤?ì  ê°œì„¤ ê°•í™” ?¹ì„±?€ ?¬ëŸ¬ê°œë¼??SCR_REINFORCEABILITY_TOOLTIP ?¨ìˆ˜???¬ìš© ë¶ˆê?. ì§ì ‘ ?ìš© ----
    local abilAddRate = 1;
    local reinforceAbil = GetOtherAbility(pc, "Pardoner15")
    if reinforceAbil ~= nil then
        local abilLevel = TryGetProp(reinforceAbil, "Level")
        local masterAddValue = 0
        if abilLevel == 100 then
            masterAddValue = 0.1
        end
        abilAddRate = abilAddRate + (abilLevel * 0.005 + masterAddValue);
    end
    
    value = value * abilAddRate
    
    return value
end

function SCR_GET_Telepath_Ratio(skill)
    local value = 10 + skill.Level * 1
    return value
end

function SCR_GET_Conversion_Bufftime(skill)
    local value = 10 + skill.Level * 1
    return value
end

function SCR_GET_Carnivory_Ratio(skill)
    local value = 1 + ((skill.Level * 1) / 2)
    return math.ceil(value)
end

function SCR_GET_Carnivory_Ratio2(skill)
    local value = (skill.Level * 10)
    return math.floor(value)
end

function SCR_GET_Carnivory_Time(skill)
    local value = 15
    return value
end

function SCR_GET_StereaTrofh_Ratio(skill)
    local value = skill.Level * 7
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_Chortasmata_Time(skill)
    local value = 5 + skill.Level * 0.6
    return value
end

function SCR_GET_Chortasmata_Bufftime(skill)
    local value = 10 + skill.Level * 0.6
    return value
end

function SCR_GET_Chortasmata_Ratio(skill)
    local value = 41 + (7.6 * (skill.Level - 1));
    return value
end

function SCR_GET_ArcaneEnergy_Ratio(skill)
    local value = 0.4 * skill.Level;
    return value
end

function SCR_GET_ArcaneEnergy_Ratio2(skill)
    local value = 5 + skill.Level * 4
    return value
end

function SCR_GET_ArcaneEnergy_Bufftime(skill)
    local value = skill.Level
    local pc = GetSkillOwner(skill)
    
    local Oracle7_abil = GetAbility(pc, "Oracle7")
    if Oracle7_abil ~= nil and 1 == Oracle7_abil.ActiveState then
        value = value + Oracle7_abil.Level
    end
    
    return value
end

function SCR_GET_CallOfDeities_Ratio(skill)
    local value = 1 + skill.Level * 2;
    return value
end

function SCR_GET_Change_Ratio(skill)
    local value = skill.Level;
    return value
end

function SCR_GET_Forecast_Ratio(skill)
    local value = 300;
    local pc = GetSkillOwner(skill)
    
    local Oracle3_abil = GetAbility(pc, "Oracle3")
    if Oracle3_abil ~= nil and 1 == Oracle3_abil.ActiveState then
        value = value + Oracle3_abil.Level * 60;
    end
    
    return value
end

function SCR_GET_BeadyEyed_Time(skill)
    local value = 100 + (skill.Level * 5);
    
    return value
end

function SCR_GET_CounterSpell_Bufftime(skill)
    local value = 25;
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Oracle16")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value;
end

function SCR_GET_CounterSpell_Ratio(skill)
    local value = 5 + skill.Level * 2;
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return math.floor(value);
end

function SCR_GET_DeathVerdict_Ratio(skill)
    local value = skill.Level * 5
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return value;
end

function SCR_GET_DeathVerdict_Ratio2(skill)
    local value = 5 + skill.Level
    
    return value
end

function SCR_GET_DeathVerdict_Ratio3(skill)
    local value = 25
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Oracle18")
    if abil ~= nil and abil.ActiveState >= 1 then
        value = 11 + abil.Level * 1
    end
    
    return value
end


function SCR_GET_Prophecy_Ratio(skill)
    return skill.Level;
end

function SCR_GET_Foretell_Time(skill)
    local value = 10
    return value;
end

function SCR_GET_Foretell_Ratio(skill)
    local value = skill.Level * 6
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    return value
end

function SCR_GET_TwistOfFate_BuffTime(skill)
    local value = 30
    return value
end

function SCR_GET_TwistOfFate_Ratio(skill)
    local value = (skill.Level * 8) - 7
    return value
end

function SCR_GET_TwistOfFate_Ratio2(skill)
    local value = skill.Level * 8
    return value
end

function SCR_GET_HengeStone_Time(skill)
    local value = 20
    
    return math.floor(value)
end

function SCR_GET_ManaShield_Bufftime(skill)

    return 10 + skill.Level;

end

function SCR_GET_ManaShield_Ratio(skill)

    return 120

end

function SCR_GET_Sleep_Ratio(skill)
    local value = skill.Level
    local pc = GetSkillOwner(skill);
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 1;
    end
    return value;

end

function SCR_GET_Sleep_Ratio2(skill)
    local value = 2 + skill.Level
    return value;
end




function SCR_GET_SR_LV_Bash(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Penetration');
    
    if abil ~= nil and skill.ClassName == "Swordman_Bash" and 1 == abil.ActiveState then
      return pc.SR + skill.SklSR + abil.Level;
    end
    return pc.SR + skill.SklSR

end

function SCR_GET_Crown_Bufftime(skill)

    return 5 + (0.5 * skill.Level);

end

function SCR_GET_SynchroThrusting_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local equipWeapon = GetEquipItem(pc, 'LH');
    
    if equipWeapon ~= nil and IS_NO_EQUIPITEM(equipWeapon) == 0 then            
        leftHandAttribute   = equipWeapon.Attribute;
    end
    
    local def = equipWeapon.DEF;
--  local value = def * 5 + skill.SkillAtkAdd
    local value = def
    
    return math.floor(value);

end


function SCR_GET_SR_LV_SynchroThrusting(skill)

    local pc = GetSkillOwner(skill);
    
    return pc.SR + skill.Level

end



function SCR_GET_Finestra_Bufftime(skill)

    return 30 + (3 * skill.Level);

end

function SCR_GET_Warcry_Bufftime(skill)
    local value = 10 + (skill.Level * 2)
    
    return value;
end

function SCR_GET_Warcry_Ratio(skill)
    local value = SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value;
end

function SCR_GET_SR_LV_Pull(skill)

    local pc = GetSkillOwner(skill);
    return skill.SklSR;

end


function SCR_GET_Gungho_Bufftime(skill)
    return 300;
end

function SCR_GET_Gungho_Ratio(skill)
    local value = skill.Level * 2;
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value;
end

function SCR_GET_Gungho_Ratio2(skill)

    local pc = GetSkillOwner(skill)
    local value = 5 + (skill.Level - 1) + ((skill.Level / 5) * ((pc.STR * 0.3) ^ 0.5))
    
--    local Swordman20_abil = GetAbility(pc, "Swordman20")    -- 2rank Atk multiple
--    local Swordman21_abil = GetAbility(pc, "Swordman21")    -- 3rank Atk multiple
--    if Swordman21_abil ~= nil then
--        value = value * 1.44
--    elseif Swordman21_abil == nil and Swordman20_abil ~= nil then
--        value = value * 1.38
--    end
    
    local Swordman13_abil = GetAbility(pc, "Swordman13")
    if Swordman13_abil ~= nil and skill.Level >= 3 then
        value = value * (1 + Swordman13_abil.Level * 0.01);
    end
    
    return math.floor(value);
    
end

function SCR_GET_Bear_Bufftime(skill)
    return 300;
end

function SCR_GET_Bear_Ratio(skill)
    local value = skill.Level * 2;
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value;
end

function SCR_GET_Guardian_Bufftime(skill)
    return 30
end

function SCR_GET_Guardian_Ratio(skill)
	local pc = GetSkillOwner(skill)
    local value = 8 * skill.Level
	if IsPVPField(pc) == 1 then	
		value = 5 * skill.Level
	end
    	value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value;
end

function SCR_GET_Guardian_Ratio2(skill)

--    local pc = GetSkillOwner(skill)
----    local value = 2 + 0.9 * (skill.Level - 1);
--    local value = skill.Level * 1
--    
--    local Peltasta19_abil = GetAbility(pc, "Peltasta19")    -- 2rank Skill Damage multiple
--    local Peltasta20_abil = GetAbility(pc, "Peltasta20")    -- 3rank Skill Damage multiple
--    if Peltasta20_abil ~= nil then
--        value = value * 1.44
--    elseif Peltasta20_abil == nil and Peltasta19_abil ~= nil then
--        value = value * 1.38
--    end
--    
--    local Peltasta13_abil = GetAbility(pc, "Peltasta13")
--    if Peltasta13_abil ~= nil then
--        value = value + Peltasta13_abil.Level * 1.26;
--    end
    local value = skill.Level * 2

    return math.floor(value);
end


function SCR_GET_Concentrate_Bufftime(skill)

    return 45;

end


function SCR_GET_Concentrate_Ratio(skill)

    return skill.Level * 2;

end


function SCR_GET_Concentrate_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local statBonus = 0;
    local byAbilRate = 0;
    
    statBonus = math.floor((pc.STR * 0.1 + pc.DEX * 0.2) * skill.Level)
    
    local Swordman14_abil = GetAbility(pc, "Swordman14")
    if Swordman14_abil ~= nil and skill.Level >= 3 then
        byAbilRate = Swordman14_abil.Level * 0.01;
    end
    
    value = 5 + (skill.Level - 1) * 1.5 + statBonus;
    value = value + (value * byAbilRate);
    
    return math.floor(value);
end


function SCR_GET_ShieldPush_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = skill.Level

      return value;

end

function SCR_GET_Restrain_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local value = 30 + skill.Level * 3;

      return value;

end

function SCR_GET_Restrain_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = skill.Level * 6
    
    return math.floor(value);

end


function SCR_GET_Restrain_Ratio2(skill)

    local pc = GetSkillOwner(skill)
--    local value = 164.4 + (skill.Level - 1) * 41.1
    local value = 50 + (skill.Level * 5) + (pc.MHP * 0.01 * skill.Level) 
    
    local Swordman24_abil = GetAbility(pc, "Swordman24")    -- 3rank Skill Damage multiple
    if Swordman24_abil ~= nil then
        value = value * 1.44
    end
    
    local abil = GetAbility(pc, "Swordman15")
    if abil ~= nil then
        value = value + abil.Level * 10
    end

    return math.floor(value);

end


function SCR_GET_Frenzy_Ratio(skill)
    local value = 150 + (skill.Level * 10)

    return math.floor(value)
end


function SCR_GET_Frenzy_Bufftime(skill)
    return 30 + skill.Level * 2
end

function SCR_GET_Aggressor_Ratio(skill)

    return math.floor(10 + skill.Level * 5)

end


function SCR_GET_Aggressor_Bufftime(skill)


    return 20 + skill.Level * 2

end

function SCR_GET_Frenzy_Buff_Ratio2(skill, pc)
    if nil ~= pc then
        local abil = GetAbility(pc, 'Barbarian22');
        if nil ~= abil and 1 == abil.ActiveState then
            return skill.Level
        end
    end
    return skill.Level * 2
end

function SCR_GET_Frenzy_Buff_Ratio3(skill)
    local value = 2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value;
end

function SCR_GET_BackMasking_Ratio(skill, pc)

      return 50 + skill.Level * 10

end


function SCR_GET_Savagery_Bufftime(skill)

    return 40

end


function SCR_GET_Parrying_Bufftime(skill)

    return 50 + 10 * skill.Level

end

function SCR_GET_Parrying_Ratio(skill)

  return  9 + skill.Level

end

function SCR_Get_Zhendu_Bufftime(skill)
    
    return  300

end

function SCR_Get_Zhendu_Ratio(skill)

    local value = 0 
    local pc = GetSkillOwner(skill)
    if pc ~= nil then
        local minPATK = TryGetProp(pc, "MINPATK")
        local maxPATK = TryGetProp(pc, "MAXPATK")
        value = math.floor(((minPATK + maxPATK) / 2) * 0.1)
    end
    
    return value
end

function SCR_Get_Zhendu_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local skillLv = skill.Level;
    local value = 40 + (skillLv -1) * 7;
    if pc ~= nil then
        local STR = TryGetProp(pc, "STR")
        value = math.floor(value + ((skillLv / 4)* ((STR * 0.6) ^ 0.9)));
    end
    
    return value
end

function SCR_GET_JollyRoger_Bufftime(skill)
    local value = 35
    
    return value
end

function SCR_GET_JollyRoger_Ratio(skill)
    local value = (skill.Level * 2)
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return value;
end

function SCR_GET_SubweaponCancel_Bufftime(skill)
    local value = 5
    
    return value;
end

function SCR_GET_Looting_Bufftime(skill)
    return 9 + skill.Level
end


function SCR_GET_WeaponTouchUp_Ratio(skill)
    return skill.Level
end

function SCR_GET_WeaponTouchUp_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 2500 + skill.Level * 250 + pc.INT
    local Squire3 = GetAbility(pc, 'Squire3');
    
    if Squire3 ~= nil and 1 == Squire3.ActiveState and skill.Level >= 3 then
        value = value + Squire3.Level * 20
    end
    
    return value
end

function SCR_GET_ArmorTouchUp_Ratio(skill)
    return skill.Level
end

function SCR_GET_ArmorTouchUp_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 500 + skill.Level * 50 + pc.INT
    local Squire4 = GetAbility(pc, 'Squire4');
    
    if Squire4 ~= nil and 1 == Squire4.ActiveState and skill.Level >= 3 then
        value = value + Squire4.Level * 5
    end
    
    return value
end

function SCR_GET_Repair_Ratio(skill)
    return skill.Level;
end

function SCR_GET_UnlockChest_Ratio(skill)
    
    return skill.Level;

end


function SCR_GET_Conscript_Ratio(skill)
    
    local value = 3 + skill.Level;
    
    if value > 8 then
        value = 8
    end
    
    return value
end


function SCR_GET_Tercio_Ratio(skill)

    local pc = GetSkillOwner(skill)
    return skill.Level * 10

end

function SCR_GET_Phalanx_Ratio(skill)

    local pc = GetSkillOwner(skill)
    return skill.Level * 10

end



function SCR_GET_Wingedformation_Ratio(skill)
    local value = 50 + (3 * skill.Level)
    return value;  
end

function SCR_GET_Wedgeformation_Ratio(skill)

    return 4

end


function SCR_GET_Wedgeformation_Ratio2(skill)
    local value = 50 + skill.Level * 5
    return value

end

function SCR_GET_Testudo_Ratio(skill)
    return 50
end


function SCR_GET_Testudo_Ratio2(skill)
    return skill.Level * 30
end

function SCR_GET_DeedsOfValor_Bufftime(skill)
    return 20 + skill.Level * 3
end

function SCR_GET_DeedsOfValor_Ratio(skill)
    return 5 + (skill.Level - 1) * 2;
end

function SCR_GET_DeedsOfValor_Ratio2(skill)
    return 5 + (skill.Level - 1) * 1;
end

function SCR_GET_DeedsOfValor_Ratio3(skill)
    return 5;
end

function SCR_GET_PainBarrier_Bufftime(skill)
    local value = 5 + skill.Level * 5
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    
    return math.floor(value)
end

function SCR_GET_Double_pay_earn_Ratio(skill)
    local value = skill.Level * 30
    
    return value
end

function SCR_GET_Camp_Ratio(skill)
    return 1 + skill.Level * 0.5
end

function SCR_GET_Camp_Ratio2(skill)
    return skill.Level * 5
end

function SCR_GET_SR_LV_TEST(skill)

    local pc = GetSkillOwner(skill);
  return skill.SklSR

end

function SCR_Peltasta_SwashBuckling(self)

  return 1;
  
end


function SCR_Get_SwashBuckling_SkillFactor(skill)

    local value = 19 + skill.Level * 38;
    return value;
end


function SCR_GET_SR_LV_SwashBuckling(skill)

    local pc = GetSkillOwner(skill);
    return 6 + skill.Level

end


function SCR_GET_SwashBuckling_Ratio(skill)
    return 9 + skill.Level;

end

function SCR_GET_SwashBuckling_Ratio2(skill)
    local value = 35
    return value;

end

function SCR_GET_SwashBuckling_Bufftime(skill)
    local buffTime = 10;
    local pc = GetSkillOwner(skill);
    if pc ~= nil then
        local abilPeltasta32 = GetAbility(pc, "Peltasta32");
        if abilPeltasta32 ~= nil and TryGetProp(abilPeltasta32, "ActiveState") == 1 then
            buffTime = buffTime + TryGetProp(abilPeltasta32, "Level");
        end
    end
    
    return buffTime;
end

function SCR_Get_CrescentWing_SkillFactor(skill)
    local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
    local value = 185 + skill.Level * 49 + byItem;
    return value;
end

function SCR_GET_SR_LV_CrescentWing(skill)

    local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_GET_Provoke_Ratio(skill)

    return 300

end


function SCR_GET_Provoke_Bufftime(skill)

    return 12 + (skill.Level * 3)

end

function SCR_Get_EarthTremor_SkillFactor(skill)
    local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Strike');
    local value = 202 + skill.Level * 49 + byItem;
    return value;
end

function SCR_Get_EarthTremor_SklAtkAdd(skill)
    
    --local value = 9 + skill.Level * 5;
    local value = 0;
    return value;
end

function SCR_GET_SR_LV_EarthTremor(skill)

    local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_GET_Earthtremor_Bufftime(skill)

    return 3

end

function SCR_GET_Earthtremor_Ratio(skill)

    return 5 + skill.Level * 5;

end

function SCR_Get_Moulinet_SkillFactor(skill)
    local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
    local value = 77 + skill.Level * 3 + byItem;
    return value;
end

function SCR_Get_Moulinet_SklAtkAdd(skill)

    return 0;
end

function SCR_GET_SR_LV_Moulinet(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.SR / 2 + math.floor(skill.Level/5);
    
    if value < 1 then
        value = 1;
    end
    
    return value;

end

function SCR_Get_Cyclone_SkillFactor(skill)
    local pc = GetSkillOwner(skill);
    local byItem = GetSumOfEquipItem(pc, 'Slash');
    local value = 63 + skill.Level * 23 + byItem;
    return value;
    
end

function SCR_Get_Cyclone_SklAtkAdd(skill)
    
    --local value = 3 + skill.Level * 2;
    local value = 0;
    return value;
end

function SCR_GET_SR_LV_WhirlWind(skill)

    local pc = GetSkillOwner(skill);
  return pc.SR + skill.SklSR

end

function SCR_Get_BroadHead_SkillFactor(skill)

    local value = 92 + skill.Level * 8
    return value;
end

function SCR_Get_BroadHead_Ratio(skill)
    local caster = GetSkillOwner(skill);
    local evgDmg = (caster.MINPATK + caster.MAXPATK) / 2;
    local addDmg = 4 + (skill.Level - 1) * 3;
    
    if skill.Level > 5 then
        addDmg = 4 + (skill.Level - 1) * 5 + (skill.Level - 5) * 6.3
    end
    
    local value = math.floor(evgDmg * 0.3 + addDmg);
    return value;

end

function SCR_Get_BroadHead_Bufftime(skill)
    return 5 + skill.Level * 0.5
end

function SCR_Get_CrossFire_Ratio(skill)
    return 75 + skill.Level * 5;
end


function SCR_Get_Multishot_Ratio(skill)
    local value = 10;
    return value
end

function SCR_Get_BarbedArrow_SkillFactor(skill)

    local value = 140 + skill.Level * 25
    return value;
end

function SCR_GET_SR_LV_MultiShot(skill)

    local pc = GetSkillOwner(skill);
    return pc.SR + math.floor(skill.Level / 5) + skill.SklSR;

end


function SCR_Get_BuildRoost_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 100;
    
    local Falconer1_abil = GetAbility(pc, "Falconer1");
    if Falconer1_abil ~= nil and 1 == Falconer1_abil.ActiveState then
        value = value + Falconer1_abil.Level * 20
    end
    
    return value
end

function SCR_Get_BuildRoost_Ratio2(skill)
    local value = 20
    return value
end

function SCR_Get_Hovering_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 10;
    
    local abil = GetAbility(pc, "Falconer3")
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level * 3
    end
    
    return value
end

function SCR_Get_Circling_Ratio(skill)
    local value = 10 + skill.Level
    
    return value
end

function SCR_Get_HangingShot_Ratio(skill)
    return 14 + skill.Level
end

function SCR_GET_Aiming_Bufftime(skill)
    local value = 10 + (skill.Level * 5);
    return value;
end

function SCR_GET_FirstStrike_Bufftime(skill)
    local value = 20 + (skill.Level - 1) * 10;
    return value;
end


function SCR_GET_FirstStrike_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local lv = pc.Lv
    local bylvCorrect = lv - 300
    local spendSP = 90
    
    if bylvCorrect < 0 then
        bylvCorrect = bylvCorrect * 2.75 / 1000
    elseif bylvCorrect >= 0 then
        bylvCorrect = bylvCorrect * 1.25 / 1000
    end
    
    local spendSP = spendSP * (1 + bylvCorrect)
    
    return math.floor(spendSP)
end


function SHOOTMOVE_CYCLONE(skill)

    local pc = GetSkillOwner(skill);
    local ablLevel = GET_ABIL_LEVEL(pc, "DustDevil");

    if ablLevel > 0 then
        return 0;
    end
    
    return 0;
end

function SCR_GET_AcrobaticMount_Ratio(skill)
    local value = 5 + (skill.Level * 5)
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return value;
end

function SCR_GET_AcrobaticMount_Ratio2(skill)
    local value = skill.Level * 5
    
    return value;
end


function SCR_GET_RimBlow_Bonus(skill)

    return 25 + skill.Level * 30;

end


function SCR_GET_UmboBlow_Bonus(skill)

    return 25 + skill.Level * 30;

end

function SCR_GET_DreadWorm_Bonus(skill)

    return 25 + skill.Level * 50;

end

function SCR_GET_Rage_Bufftime(skill)

    return (12000 + 4000 * skill.Level)/1000;

end

function SCR_GET_Conviction_AttackRatio(skill)

    return 25 + skill.Level * 25;

end

function SCR_GET_Conviction_DefenceRatio(skill)

    return 20 + skill.Level * 15;

end

function SCR_GET_Soaring_Bufftime(skill)

    return 20;

end


function SCR_GET_EnergyBolt_Bonus(skill)

    return 25 + skill.Level * skill.SklFactor * 50;

end

function SCR_GET_EnergyBolt_HitSplRange(skill)

    return 30;

end

function SCR_GET_EnergyBolt_Splash(skill)

    local lv = skill.Level;
    local splCnt = math.min(3, lv) + skill.Splash_BM + 1;
    
    return splCnt;  

end

function SCR_GET_Fog_Bufftime(skill)

    return 4 + skill.Level;

end


function SCR_GET_Heal_Bufftime(skill)
    
    local cnt = skill.Level;
    if skill.Level > 10 then
        cnt = 10;
    end
    
    return cnt;

end

function SCR_GET_Heal_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local pcINT = TryGetProp(pc, "INT");
    if pcINT == nil then
        pcINT = 1;
    end
    
    local pcMNA = TryGetProp(pc, "MNA");
    if pcMNA == nil then
        pcMNA = 1;
    end
    
    local value = (pcINT + pcMNA) * 2;
    
    return math.floor(value);
end

function SCR_GET_Heal_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 150 + (skill.Level - 1) * 103
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    if pc == nil then
        return math.floor(value);
    end

    local jobHistory = '';
    if IsServerObj(pc) == 1 then
        if IS_PC(pc) == true then
            jobHistory = GetJobHistoryString(pc);
        end
    else
        jobHistory = GetMyJobHistoryString();
    end
    
    if jobHistory ~= nil and string.find(jobHistory, "Char4_2") ~= nil then
        value = value * 1.05
    end
    
    if jobHistory ~= nil and string.find(jobHistory, "Char4_15") ~= nil then
        value = value * 1.1
    end
    
    return math.floor(value);
end

function SCR_GET_Cure_Ratio(skill)
    local value = skill.Level * 10
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return value 
end


function SCR_GET_Bless_Bufftime(skill)
    
    return 45 + 10 * skill.Level;

end

function SCR_GET_Bless_Ratio(skill)

    return 12 + 5 * skill.Level;

end

function SCR_GET_Bless_Ratio2(skill)
    
    local value = 20 + skill.Level * 0.3;
    return math.floor(value);

end

function SCR_GET_SafetyZone_Bufftime(skill)

    return 5 + skill.Level;

end

function SCR_GET_DeprotectedZone_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local buffTime = skill.Level * 2 + 4;
    
    local Cleric5_abil = GetAbility(pc, "Cleric5");
    if Cleric5_abil ~= nil and 1 == Cleric5_abil.ActiveState then
        buffTime = buffTime + Cleric5_abil.Level;
    end
    
    return math.floor(buffTime);

end

function SCR_GET_DeprotectedZone_Ratio(skill)

    local pc = GetSkillOwner(skill)
    local value = 2.8 + (skill.Level - 1) * 0.7 + pc.MNA;
    
    return math.floor(value);

end

function SCR_GET_DeprotectedZone_Ratio2(skill)
    
    local value = 1 + (skill.Level - 1) * 0.5;

    return math.floor(value);

end

function SCR_GET_Fade_Bufftime(skill)
    local value = 10 + skill.Level * 2
    return math.floor(value);
end

function SCR_GET_PatronSaint_Bufftime(skill)
    local value = 60
    return math.floor(value);
end

function SCR_GET_PatronSaint_Raito(skill)
    local value = skill.Level * 5
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value;
end

function SCR_GET_Daino_Bufftime(skill)
    local value = 10 + (skill.Level * 2);
    
    return value;
end

function SCR_GET_Mackangdal_Bufftime(skill)
    local value = 4 + (skill.Level * 1)
    local pc = GetSkillOwner(skill);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5
    end
    
    return math.floor(value);
end

function SCR_GET_Hexing_Bufftime(skill)

    local value = skill.Level * 1 + 6;
    return value;

end

function SCR_GET_SpecialForceFormation_Ratio(skill)

    local value = 35 + skill.Level * 5
    return value;

end

function SCR_GET_SpecialForceFormation_Ratio2(skill)

    local value = 55 + skill.Level * 5
    return value;

end

function SCR_GET_Zombify_Bufftime(skill)

    local value = 5 + skill.Level * 5
    return value;

end

function SCR_GET_Zombify_ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 4 + skill.Level
--  local bookor8_abil = GetAbility(pc, 'Bokor8');
--  if bookor8_abil ~= nil and 1 == bookor8_abil.ActiveState then
--      value = value + bookor8_abil.Level;
--  end
    
    return value
end


function SCR_GET_CrossGuard_Bufftime(skill)
    local pc = GetSkillOwner(skill);

    return math.floor(pc.STR * 0.1);

end


function SCR_GET_Finestra_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 3 * skill.Level
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill));
    
    return math.floor(value)
end

function SCR_GET_Finestra_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 * skill.Level
    
    return math.floor(value)
end

function SCR_GET_Finestra_Ratio3(skill)

    local pc = GetSkillOwner(skill);
    
    local value = 25 + (15 * skill.Level); 
    
--    local abil = GetAbility(pc, 'Hoplite9');
--    if abil ~= nil and 1 == abil.ActiveState then
--        value = value * 2;
--    end
    
    return math.floor(value)

end

function SCR_GET_SharpSpear_Bufftime(skill)
    local value = 300
    return math.floor(value)
end

function SCR_GET_SharpSpear_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 + (skill.Level * 1)
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

function SCR_GET_HighGuard_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = skill.Level * 5
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill));
    
    if IsPVPField(pc) == 1 then
        value = value / 2
    end
    
    return value
end

function SCR_GET_HighGuard_Ratio2(skill)
    local value = 50 - (skill.Level * 2)
    return math.floor(value)
end

function SCR_GET_HighGuard_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 20
    if IsPVPField(pc) == 1 then
        value = value * 0.1
    end
    
    return value
end

function SCR_GET_HighGuard_AtkDown(skill)
    local pc = GetSkillOwner(skill);
    
    local value = skill.Level
    
    return math.floor(value)

end


function SCR_GET_HolyEnchant_Bufftime(skill)

    return 60 + 0.5 * skill.Level;

end

function SCR_GET_HolyEnchant_Ratio(skill)

    return 20 + 2 * skill.Level;

end


function SCR_GET_Haste_Ratio(skill)

    local value = 5 + skill.Level * 0.2;
    return math.floor(value);

end

function SCR_GET_Cure_Bufftime(skill)
    
    local value = 5 + skill.Level;
    return math.floor(value);

end

function SCR_GET_Aukuras_Bufftime(skill)
    local value = 30;
    
    local pc = GetSkillOwner(skill)
    local Kriwi18_abil = GetAbility(pc, "Kriwi18")
    if Kriwi18_abil ~= nil and Kriwi18_abil.ActiveState == 1 then
        value = 20;
    end
    
    return math.floor(value);
end



function SCR_GET_Aukuras_Ratio(skill)    
    local value = 39 + (19 * (skill.Level - 1));
    
    local pc = GetSkillOwner(skill)
    local abilKriwi14 = GetAbility(pc, 'Kriwi14');
    if abilKriwi14 ~= nil and skill.Level >= 3 then
        value = value * (1 + abilKriwi14.Level * 0.01);
    end
    
    local abilKriwi18 = GetAbility(pc, "Kriwi18");
    if abilKriwi18 ~= nil and abilKriwi18.ActiveState == 1 then
        value = 0;
    end
    
    return math.floor(value)
end

function SCR_GET_Aukuras_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 0
    
    if pc ~= nil then
        -- ì§€??+ ?•ì‹  ê³„ìˆ˜ ?©ì‚°
        local casterINT = TryGetProp(pc, 'INT', 1);
        local casterMNA = TryGetProp(pc, 'MNA', 1);        
        value = 100 + (TryGetProp(skill, 'Level', 0) * 90) + (casterINT + casterMNA)        
    else
        value = 100 + (TryGetProp(skill, 'Level', 0) * 90)
    end
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return math.floor(value)
end

function SCR_GET_DivineStigma_Ratio(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_DivineStigma_Ratio2(skill)
    local value = skill.Level * 5
    
    return value
end

function SCR_GET_DivineStigma_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 60;
    local abil = GetAbility(pc, "Kriwi9")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + (abil.Level * 6);
    end
    
    return math.floor(value);
end


function SCR_GET_Limitation_Bufftime(skill)

    return 180;

end

function SCR_GET_Limitation_Ratio(skill)

    local value =  10 + 0.9 * skill.Level;
    return math.floor(value);
end

function SCR_Get_Melstis_Ratio(skill)
	local pc = GetSkillOwner(skill);
	local PATKAVER = (pc.MINPATK + pc.MAXPATK)/2
	local MATKAVER = (pc.MINMATK + pc.MAXMATK)/2
	local CHOATK = 0
	if PATKAVER > MATKAVER then
		CHOATK = PATKAVER
	else
		CHOATK = MATKAVER
	end
	local value = math.floor(skill.Level * CHOATK * 0.02)
    return value

end

function SCR_Get_Melstis_Ratio2(skill)
    local pc = GetSkillOwner(skill);
--  local value = 10 + skill.Level * 5
    local value = skill.Level

    return value
end

function SCR_Get_Zalciai_Ratio(skill)
    local value = TryGetProp(skill, 'Level', 1) * 2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);    
    return value
end

function SCR_Get_Zalciai_Ratio2(skill)
    local value = TryGetProp(skill, 'Level', 1) * 1
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);    
    return value
end

function SCR_Get_Zalciai_Ratio3(skill)
    local value = skill.Level    
    return value
end

function SCR_GET_Zaibas_Ratio(skill)

    return 4 + skill.Level * 1;

end

function SCR_Get_Aspersion_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local pcLevel = TryGetProp(pc, "Lv")
    local pcMNA = TryGetProp(pc, "MNA")
    local mnaRate = (pcMNA / (pcMNA + pcLevel) * 2) + 0.15
    
    local skillValue = skill.Level
    local value = skillValue * mnaRate
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return value
end

function SCR_Get_Resurrection_Ratio(skill)
    local value = skill.Level * 10
    
    return value
end

function SCR_Get_Resurrection_Ratio2(skill)
    local value = 1;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Priest9");
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level;
    end
    
    return value
end

function SCR_Get_Resurrection_Time(skill)
    local value = math.max(1, 7 - skill.Level);
    return value
end

function SCR_Get_Monstrance_Bufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 20
    
    local abil = GetAbility(pc, "Priest22")
    local ActiveState = TryGetProp(abil, "ActiveState")
    if abil ~= nil and ActiveState == 1 then
        value = value + (abil.Level * 60)
    end
    
    return math.floor(value);
end

function SCR_Get_Monstrance_Debufftime(skill)
    local pc = GetSkillOwner(skill);
    local value = 30
    
--    local abil = GetAbility(pc, "Priest22")
--    if abil ~= nil and abil.ActiveState == 1 then
--        value = value + abil.Level
--    end
    
    return math.floor(value);
end


function SCR_Get_Monstrance_Ratio2(skill)
    local value = 5 + skill.Level * 3
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value
end

--function SCR_Get_Monstrance_Ratio3(skill)
--    local pc = GetSkillOwner(skill);
--    local value = skill.Level;
--    
--    return math.floor(value);
--end


function SCR_Get_Aspersion_Bufftime(skill)

    return 300;
end

function SCR_Get_OutofBody_Ratio(skill)
    return 180
end

function SCR_Get_OutofBody_Ratio2(skill)
    local value = skill.Level
    return value
end

function SCR_Get_OutofBody_Ratio3(skill)
    local value = skill.Level * 2
    return value
end

function SCR_Get_SkillFactor_OutofBodySkill(skill)
    local pc = GetSkillOwner(skill);
    local OutofBodySkill = GetSkill(pc, "Sadhu_OutofBody")
    local value = 0
    if OutofBodySkill ~= nil then
        value = OutofBodySkill.SkillFactor;
    end
    return math.floor(value)
end

function SCR_GET_Prakriti_Ratio(skill)
    local value = 3 + skill.Level * 0.3
    return value
end

function SCR_GET_TransmitPrana_BuffTime(skill)
    local value = 30
    return value
end

function SCR_GET_TransmitPrana_Ratio(skill)
    local value = 5 + (skill.Level * 3)
    return math.floor(value)
end

function SCR_GET_TransmitPrana_Ratio2(skill)
    local value = skill.Level * 15
    return value
end

function SCR_GET_TransmitPrana_Ratio3(skill)
    local value = TryGetProp(skill, 'Level', 1) * 3
    return value
end

function SCR_Get_VashitaSiddhi_Ratio(skill)

    return skill.Level * 5;

end

function SCR_Get_VashitaSiddhi_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 35 + skill.Level * 1;
    local abil = GetAbility(pc, "Sadhu7")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 1.2
    end
    
    return math.floor(value);

end

function SCR_Get_Physicallink_Bufftime(skill)

    return 60 + skill.Level * 10

end

function SCR_GET_Isa_Bufftime(skill)

    return 10 * skill.Level

end

function SCR_GET_Isa_Ratio(skill)

    return 10 * skill.Level

end

function SCR_GET_Hagalaz_Castingime(skill)
	local value = 2
	local pc = GetSkillOwner(skill);
	if IsBuffApplied(pc, "Runcaster_Casting_Buff") == "YES" then
		local castingBuffOver = GetBuffOver(pc, "Runcaster_Casting_Buff")
		value = 1
		if castingBuffOver == 2 then
			value = 0.5
		end
	end
	
	return value
end

function SCR_GET_Isa_Castingime(skill)
	local value = 2
	local pc = GetSkillOwner(skill);
	if IsBuffApplied(pc, "Runcaster_Casting_Buff") == "YES" then
		local castingBuffOver = GetBuffOver(pc, "Runcaster_Casting_Buff")
		value = 1
		if castingBuffOver == 2 then
			value = 0.5
		end
	end
	
	return value
end

function SCR_GET_Tiwaz_Castingime(skill)
	local value = 2
	local pc = GetSkillOwner(skill);
	if IsBuffApplied(pc, "Runcaster_Casting_Buff") == "YES" then
		local castingBuffOver = GetBuffOver(pc, "Runcaster_Casting_Buff")
		value = 1
		if castingBuffOver == 2 then
			value = 0.5
		end
	end
	
	return value
end

function SCR_GET_Algiz_Castingime(skill)
	local value = 2
	local pc = GetSkillOwner(skill);
	if IsBuffApplied(pc, "Runcaster_Casting_Buff") == "YES" then
		local castingBuffOver = GetBuffOver(pc, "Runcaster_Casting_Buff")
		value = 1
		if castingBuffOver == 2 then
			value = 0.5
		end
	end
	
	return value
end

function SCR_GET_Stan_Castingime(skill)
	local value = 2
	local pc = GetSkillOwner(skill);
	if IsBuffApplied(pc, "Runcaster_Casting_Buff") == "YES" then
		local castingBuffOver = GetBuffOver(pc, "Runcaster_Casting_Buff")
		value = 1
		if castingBuffOver == 2 then
			value = 0.5
		end
	end
	
	return value
end

function SCR_GET_Algiz_Bufftime(skill)
    local buffTime = 30 * TryGetProp(skill, "Level");
    local pc = GetSkillOwner(skill);
    local abilRuneCaster6 = GetAbility(pc, "RuneCaster6");
    if abilRuneCaster6 ~= nil and TryGetProp(abilRuneCaster6, "ActiveState") == 1 then
        local abilAddBuffTime = 10 - TryGetProp(abilRuneCaster6, "Level") * 2
        if abilAddBuffTime <= 0 then
            abilAddBuffTime = 0
end

        buffTime = buffTime - abilAddBuffTime;
    end

    return buffTime;

end

function SCR_GET_Thurisaz_Bufftime(skill)

    return 30 * skill.Level

end

function SCR_GET_Thurisaz_Ratio(skill)

    return 20
end

function SCR_GET_Thurisaz_Ratio2(skill)

    return 20

end

function SCR_Get_Bewitch_Ratio(skill)

    return 2 + skill.Level 

end
function SCR_Get_Physicallink_Ratio(skill)

    return skill.Level + 3

end
function SCR_GET_ShieldBash_Ratio2(skill)

    return 5 + skill.Level * 1

end

function SCR_Get_JointPenalty_Bufftime(skill)

    return 10 + skill.Level * 5

end

function SCR_Get_JointPenalty_Ratio(skill)
    local value = 3 + skill.Level * 0.5
    return math.floor(value)
end

function SCR_Get_JointPenalty_Ratio2(skill)
    local value = 6.5 + skill.Level * 0.5
    return math.floor(value)
end

function SCR_Get_HangmansKnot_Bufftime(skill)
    return 1 + skill.Level * 0.2;
end


function SCR_Get_UmbilicalCord_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 0;

    if pc ~= nil then
        value = pc.DEF
    end

    return value;

end

function SCR_Get_UmbilicalCord_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 0;

    if pc ~= nil then
        value = pc.RHP
    end

    return value;

end


function SCR_Get_SpiritShock_Ratio(skill)
    local value = 3 + (skill.Level * 0.5)
    
    return value;
end

function SCR_Get_ElectricShock_Ratio(skill)
    local value = 3 + (skill.Level * 0.5)
    return value;
end

function SCR_GET_Scud_Ratio(skill)

    return 10 + skill.Level * 10

end

function SCR_Get_Slow_Ratio(skill)
    return math.floor(8 + skill.Level * 1.5);
end

function SCR_Get_Slow_Ratio2(skill)
    return 14 + skill.Level * 0.5
end

function SCR_GET_MagnumOpus_Ratio(skill)
    local value = 2 + skill.Level;
    
    if value > 10 then
        value = 10;
    end
    
    return math.floor(value)
end

function SCR_Get_RunningShot_Bufftime(skill)
    return 300
end

function SCR_GET_CoverTraps_Ratio(skill)
    return 2
end

function SCR_GET_SpikeShooter_Ratio(skill)
    return 2 * skill.Level
end

function SCR_GET_SpikeShooter_Ratio2(skill)
    return 5 + skill.Level * 7;
end

function SCR_GET_HoverBomb_Ratio(skill)
    return skill.Level
end

function SCR_GET_SneakHit_Ratio(skill)
    return 30 + skill.Level * 2;
end

function SCR_GET_SneakHit_Bufftime(skill)

    local pc = GetSkillOwner(skill)
    local value = 30 + skill.Level * 4;
    
    local Rogue1_abil = GetAbility(pc, 'Rogue1');
    if Rogue1_abil ~= nil and 1 == Rogue1_abil.ActiveState then
        value = value + 2 * Rogue1_abil.Level
    end

    return value
end

function SCR_GET_Feint_Ratio(skill)
    return 3 * skill.Level;
end

function SCR_GET_Feint_Ratio2(skill)
    return 2 + skill.Level * 1
end

function SCR_GET_Feint_Bufftime(skill)
    return 10 + skill.Level * 2
end

function SCR_GET_Spoliation_Ratio(skill)
    return skill.Level
end

function SCR_GET_Evasion_Ratio(skill)
    local value = 50 * skill.Level
    
    return value
end

function SCR_GET_Evasion_Bufftime(skill)
    return 15 + skill.Level * 1;
end

function SCR_GET_Vendetta_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 5 * skill.Level

    return math.floor(value)
end

function SCR_GET_ZombieCapsule_Ratio(skill)
    local value = skill.Level

    return value
end

function SCR_GET_Vendetta_Bufftime(skill)
    return 10 + skill.Level * 2
end

function SCR_GET_Lachrymator_Bufftime(skill)
    return 7 + skill.Level * 1
end

function SCR_GET_Backstab_Ratio(skill)
    return 50 + skill.Level * 2
end

function SCR_Get_Slow_Bufftime(skill)

    return 14 + skill.Level * 0.5;

end

function SCR_GET_Fog_IceRatio(skill)

    return 13 + skill.Level * 2;

end

function SCR_GET_SplitArrow_Ratio2(skill)

    return skill.SkillFactor * 2;

end

function SCR_GET_FireBall_Bonus(skill)

    return 30 + skill.Level * 35;

end

function SCR_GET_FireBall_HitSplRange(skill)

    return 50;

end

function SCR_GET_MitigatePenalty_Ratio(skill)

    return 2 * skill.Level

end

function SCR_GET_MitigatePenalty_Ratio2(skill)

    return 0.4 * skill.Level

end

function SCR_GET_MitigatePenalty_BuffTime(skill)

    return 15 * skill.Level

end

function SCR_GET_FirePillar_Bufftime(skill)

    local value = 7 + skill.Level;
    return math.floor(value)
end

function SCR_GET_Kako_Count(skill)

    return 2;

end

function SCR_GET_Kako_Ratio(skill)

    return 8 + 2 * skill.Level;

end


function SCR_Get_FrostCloud_Bufftime(skill)

    return 10

end


function SCR_Get_FlameGround_Bufftime(skill)

    return 15 + skill.Level * 1

end


function SCR_GET_Holy_Baptism_Ratio(skill)

    local value = 10 + skill.Level * 0.4;
    return math.floor(value);

end


function SCR_Get_Raise_Ratio(skill)
    local value = skill.Level;
    
    return value;
end


function SCR_Get_Raise_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level * 1;
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5;
    end
    
    return value;

end


function SCR_GET_Holy_Baptism_Bufftime(skill)

    return 30;

end


function SCR_GET_REFRIGER_SPLASH(skill)

    local splCnt = 10;
    
    return splCnt;  

end

function SCR_GET_GUST_SPLASH(skill)

    local splCnt = math.ceil(skill.Level / 2);

    
    return splCnt;  

end


function SCR_GET_SPLASH_ICESHATTERING(skill)

    local splCnt = 10;
    
    return splCnt;  

end

function SCR_GET_ICEBOLT_HITSPLRANGE(skill)

    return 20;

end

function SCR_GET_IceBolt_Bonus(skill)

    return 40 + skill.Level * 40;

end


function SCR_GET_IcePillar_Bonus(skill)

    local value = 10 + 0.9 * skill.Level;
    return 1;

end



function SCR_Get_Swap_Ratio(skill)

    local value = skill.Level
    return value;

end


function SCR_Get_Teleportation_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 100 + skill.Level * 20;
    
    if IsBuffApplied(pc, "Thurisaz_Buff") == "YES" then
        value = value * 1.5
    end
    
    return value
end

function SCR_GET_IcePillar_Bufftime(skill)

    local value = 5 + skill.Level * 1;
    return value

end

function SCR_Get_SwellLeftArm_Ratio(skill)

    local pc = GetSkillOwner(skill);
--  local value = 34.4 + (skill.Level - 1) * 12.4 + pc.INT * 0.15;
    local value = 70 + (skill.Level - 1) * 12 + (skill.Level/5) * ((pc.INT + pc.MNA)*0.6)^0.9

    local Thaumaturge11_abil = GetAbility(pc, "Thaumaturge11")  -- 1rank Skill Damage add
    if Thaumaturge11_abil ~= nil and skill.Level >= 3 then
        value = value * (1 + Thaumaturge11_abil.Level * 0.01)    -- Temporary Value
    end

    return math.floor(value)

end

function SCR_Get_SwellRightArm_Ratio(skill)

    local pc = GetSkillOwner(skill);
    local value = 90 + (skill.Level - 1) * 20 + (skill.Level / 5) * ((pc.INT + pc.MNA) * 0.7) ^ 0.9 
    
    local Thaumaturge14_abil = GetAbility(pc, "Thaumaturge14")
    if Thaumaturge14_abil ~= nil and 1 == Thaumaturge14_abil.ActiveState and skill.Level >= 3 then
        value = value * (1 + (Thaumaturge14_abil.Level * 0.01))
    end
    
    return math.floor(value)

end

function SCR_Get_SwellRightArm_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 45 + (skill.Level - 1)*10 + (skill.Level/5) * ((pc.INT + pc.MNA)*0.6)^0.9
    
    local Thaumaturge14_abil = GetAbility(pc, "Thaumaturge14")
    if Thaumaturge14_abil ~= nil then
        value = value * (1 + Thaumaturge14_abil.Level * 0.01)
    end

    return math.floor(value)
end

function SCR_Get_SwellBrain_Ratio(skill)
    local value = skill.Level * 100
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return math.floor(value)
end

function SCR_Get_SwellBrain_Ratio2(skill)

    local pc = GetSkillOwner(skill);
    local value = 60 + (skill.Level - 1) * 10 + (skill.Level/3) * (pc.MNA * 0.7)^0.9
    local abil = GetAbility(pc, 'Thaumaturge15')
    if abil ~= nil and skill.Level >= 3 then
        value = value * (1 + abil.Level * 0.01);
    end
    return math.floor(value)

end

function SCR_Get_SpiritualChain_Bufftime(skill)

    local pc = GetSkillOwner(skill);
    local value = 30 + skill.Level * 5
    
    local abil = GetAbility(pc, 'Linker4')
    if abil ~= nil and 1 == abil.ActiveState then
        value = value + abil.Level
    end
    
    return value
end

function SCR_Get_UmbilicalCord_Bufftime(skill)

    local value = 15 + skill.Level * 5
    
    return value
    
end

function SCR_Get_SwellLeftArm_Bufftime(skill)

    local value = 300
    return value

end

function SCR_Get_SwellRightArm_Bufftime(skill)

    local value = 300
    return value

end

function SCR_Get_SwellBrain_Bufftime(skill)

    local value = 300
    return value

end

function SCR_Get_Transpose_Bufftime(skill)

    local value = 50 + skill.Level * 10

    return value;

end

--function SCR_Get_Meteor_Casttime(skill)
--    local pc = GetSkillOwner(skill);
--    local value = (skill.Level * 1) * 0.5
--    local abil = GetAbility(pc, "Elementalist25")
--    if abil ~= nil and abil.ActiveState == 1 then
--        value = value * 0.5
--    end

--    return value;
--end

function SCR_Get_Summoning_Ratio(skill)
    local value = 5 + (skill.Level * 2);
    
    return value;
end

function SCR_Get_Electrocute_Ratio(skill)
    local value = 1 + (2 + skill.Level * 0.5)
    return math.floor(value);
end


function SCR_GET_IceTremor_Bonus(skill)

    return set_LI(skill.Level, 10, 90)

end

  
function SCR_GET_TEST3_Bonus(skill)

  local lv = skill.Level;
  
  if lv >= 1 then
    return skill.BonusDam + 100;
    end
    return skill.BonusDam;
end

function SCR_GET_KDOWNPOWER(skill) 
    local pc = GetSkillOwner(skill);
    
    return skill.KDownValue;
end

function SCR_GET_KDOWNPOWER_Thrust(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "DeepStraight")

    if abil == nil then
        return skill.KDownValue;
    else
        return skill.KDownValue + (abil.Level * 50);
    end

end

function SCR_GET_KDOWNPOWER_WagonWheel(skill) 

    return skill.KDownValue + skill.Level * 25;

end


function SCR_GET_KDOWNPOWER_CartarStroke(skill) 
--    
--    local pc = GetSkillOwner(skill);
--    
--    local abil = GetAbility(pc, "Highlander28")
--    if abil ~= nil and 1 == abil.ActiveState then
--        return 0;
--    end
--    
--    local abil = GetAbility(pc, "Highlander3")
--    if abil ~= nil and 1 == abil.ActiveState then
--        return skill.KDownValue + (abil.Level * 50);
--    else
--        return skill.KDownValue;
--    end
--    
end

--function SCR_GET_KDOWNPOWER_UmboBlow(skill)
--
--    local pc = GetSkillOwner(skill);
--    local abil = GetAbility(pc, "Peltasta8")
--
--    if abil == nil then
--        return skill.KDownValue;
--    else
--        return skill.KDownValue + (abil.Level * 20);
--    end
--
--end

function SCR_GET_KDOWNPOWER_RimBlow(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Peltasta35")
    if abil ~= nil and abil.ActiveState == 1 then
        return 0
    end
    
    return skill.KDownValue;
end

function SCR_GET_KDOWNPOWER_Fulldraw(skill)

    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Overwhelming")

    if abil ~= nil and 1 == abil.ActiveState then
        return skill.KDownValue + (abil.Level * 50);
    else
        return skill.KDownValue;
    end

end


function SCR_NORMAL_PUNISH(self, from, skill, splash, ret)  
    if OnKnockDown(self) == "YES" then
        SCR_NORMAL_ATTACK(self, from, skill, splash, ret);
    else
        NO_HIT_RESULT(ret);
    end
end

function SCR_NORMAL_SYNCHROTHRUSTING(self, from, skill, splash, ret)

    -- Spear ATK ---
    local rhDamage = SCR_LIB_ATKCALC_RH(from, skill)
    
    local rightHandAttribute = "Melee"
    local rhEquipWeapon = GetEquipItem(from, 'RH');
    if rhEquipWeapon ~= nil and IS_NO_EQUIPITEM(rhEquipWeapon) == 0 then
        rightHandAttribute = rhEquipWeapon.Attribute;
    end
    
    local ariesDamage = rhDamage;
    -------------------------------------------
    
    -- Shield ATK ---
    local leftHandAttribute = "Melee"
    local lhEquipWeapon = GetEquipItem(from, 'LH');
    if lhEquipWeapon ~= nil and IS_NO_EQUIPITEM(lhEquipWeapon) == 0 then
        leftHandAttribute = lhEquipWeapon.Attribute;
    end
    
    local byItem = 0;
    local byItemList = { "DEF", "ADD_DEF" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(from, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local exceptDEF = byItem + from.DEF_BM;
    local basicDEF = TryGetProp(from, "DEF", 0) - exceptDEF
    local shieldDEF = TryGetProp(lhEquipWeapon, "DEF", 0)
    
    local atkRate = 0.65;
    local strikeDamage = (shieldDEF + basicDEF) * atkRate
    -------------------------------------------
    
    local abil = GetAbility(from, 'Hoplite7');
    if abil ~= nil then
        strikeDamage = strikeDamage * (1 - abil.Level * 0.1);
        ariesDamage = ariesDamage * (1 + abil.Level * 0.1);
    end
    
    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key);
    RunScript('SCR_SYNCHROTHRUSTING_TAKEDAMAGE', self, from, skill, ariesDamage, strikeDamage, rightHandAttribute, leftHandAttribute)
    EndSyncPacket(from, key, 0);

    NO_HIT_RESULT(ret);
end

function SCR_SYNCHROTHRUSTING_TAKEDAMAGE(self, from, skill, ariesDamage, strikeDamage, rightHandAttribute, leftHandAttribute)
    TakeDamage(from, self, skill.ClassName, ariesDamage, rightHandAttribute, "Aries", "Melee", HIT_BASIC, 0);
    sleep(200)
    TakeDamage(from, self, skill.ClassName, strikeDamage, leftHandAttribute, "Strike", "Melee", HIT_BASIC, 0);
end


function SCR_SKILL_FoldingFan(self, from, skill, splash, ret)
    NO_HIT_RESULT(ret);

    local angle = GetSkillDirByAngle(from);
        AddBuff(from, self, 'FoldingFan_Buff', 1, 0, 1300, 1);
        KnockBack(self, from, 200, angle, 30, 0.9);

    
end


function SCR_SKILL_BubbleStick(self, from, skill, splash, ret)
    NO_HIT_RESULT(ret);
    
end



function SCR_NOHIT_ATTACK(self, from, skill, splash, ret)

    NO_HIT_RESULT(ret);

    SCR_SKILL_SPECIAL_CALC(self, from, ret, skill);


end




function SCR_GET_SR_LV_TurnUndead(skill)
    local pc = GetSkillOwner(skill)
    local value = 8 + skill.Level
    
    if IsBuffApplied(pc, "Engkrateia_Buff") == "YES" then
        value = math.floor(value * 1.5)
    end
    
    if value < 1 then
        value = 1
    end
    
    return value
end

function SCR_GET_SR_LV(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.SR + skill.SklSR;
    
    if value < 1 then
        value = 1
    end

    return value
    
end


function SCR_GET_SR_LV_OUTLAW2(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Outlaw2")
    if abil ~= nil and abil.ActiveState == 1 then
        skill.SklSR = 17
    end
    
    local value = pc.SR + skill.SklSR;
    
    if value < 1 then
        value = 1
    end
    
    return value
end

function SCR_GET_SR_LV_RestInPeace(skill)

    local pc = GetSkillOwner(skill);
    local value = pc.SR + skill.SklSR;
    
    if value < 1 then
        value = 1
    end
    
    local abil = GetAbility(pc, "Bulletmarker13")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + 5
    end
    
    return value
    
end

function SCR_GET_SR_LV_Bazooka_Buff(skill)

    local pc = GetSkillOwner(skill);
    local skillSR = skill.SklSR;
    if IsBuffApplied(pc, 'Bazooka_Buff') == 'YES' then
        skillSR = math.floor(skillSR * 2);
    end
    
    local value = pc.SR + skillSR;
    
    if value < 1 then
        value = 1
    end
    
    return value
    
end


function SCR_GET_SR_LV_MagicMissile(skill)

    return 1;
    
end

function SCR_GET_SR_LV_Doppelsoeldner(skill)

    local pc = GetSkillOwner(skill);
    local skillSR = skill.SklSR;
    
    local abil =  GetAbility(pc, 'Doppelsoeldner24')
    if abil ~= nil and abil.ActiveState == 1 then
        skillSR = skillSR + abil.Level;
    end
    
    local value = pc.SR + skillSR;
    
    if value < 1 then
        value = 1
    end
    
    return value
end



function SCR_Get_SkillASPD(skill)

    local pc = GetSkillOwner(skill);
    local stc = GetStance(pc);
    if stc == nil then
        return 1.0;
    end

    return stc.SkillASPD;
end

function SCR_GET_USEOVERHEAT(skill) 
    local pc = GetSkillOwner(skill);
    --local reduce_OH_value = SCR_GET_ADDOVERHEAT(pc, skill);
    --skill.    
    local skillScale = 0.4; -- ????-- skill.xml????????
--  local byStat = math.pow(math.log(pc.MNA + 2.718282), skillScale);

    --local value = skill.SklUseOverHeat;
    local value = skill.BasicCoolDown;
    value = value * ((100 + pc.OverHeat_BM) / 100);
    if value < 0 then
        value = 0;
    end
    
--  value = value / byStat;
    
    return math.floor(value);
end

function SCR_GET_Tackle_Bonus(skill)
  
    return skill.BonusDam + 84;
    
end

function SCR_SKILL_MAXR(skill)
    local pc = GetSkillOwner(skill);
    local addMaxR = 0;
    local abilFletcher26 = GetAbility(pc, "Fletcher26");
    if TryGetProp(skill, "Job") == "Fletcher" then
        if abilFletcher26 ~= nil and TryGetProp(abilFletcher26, "ActiveState") == 1 then
            local abilLv = TryGetProp(abilFletcher26, "Level");
            addMaxR = abilLv * 10
        end
    end
    
    return skill.MaxRValue + pc.MaxR_BM + addMaxR;
    
end

function SCR_NORMALSKILL_MAXR(skill)
    
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Mergen1")
    
    local abilBonus = 0
    if abil ~= nil and 1 == abil.ActiveState then
        abilBonus = abilBonus + abil.Level;
    end
    
    return skill.MaxRValue + pc.MaxR_BM + abilBonus;
    
end

function SCR_SKILL_ITEM_MAXR(skill)

    
    local pc = GetSkillOwner(skill);

    local maxr = skill.MaxRValue + pc.MaxR_BM;

    local rItem  = GetEquipItem(pc, 'RH');
    if rItem ~= nil then
        maxr = maxr + rItem.AddSkillMaxR;
    end
    
    return maxr;
end

function SCR_GET_SKILLLV_WITH_BM(skill)
    local fixedLevel = GetExProp(skill, "FixedLevel");
    if fixedLevel > 0 then
        return fixedLevel;
    end
    
    -- ?”ë°”??ë§ˆì´???ìš© ë¶ˆê????¤í‚¬ ----
    if CHECK_SKILL_KEYWORD(skill, "ExpertSkill") == 1 and CHECK_SKILL_KEYWORD(skill, "LimitInstanceLevelUp") == 1 then
        return skill.LevelByDB;
    end
    
    local value = skill.LevelByDB + skill.Level_BM;
    if skill.GemLevel_BM > 0 then
        value = value + 1;
    end
    
    if skill.LevelByDB == 0 then
        return 0;
    end
    
    if TryGetProp(skill, "ClassName", "None") == "Peltasta_Guardian" and value > 7 then
        value = 7;
    end
    
    if value < 1 then
        value = 1;
    end

    return value;
end

function SCR_GET_SR_LV_WagonWheel(skill)
    local pc = GetSkillOwner(skill);
    local byAbil = 0;
    local abil = GetAbility(pc, 'Highlander6');
    if abil ~= nil and 1 == abil.ActiveState then
        byAbil = abil.Level * 1;
    end

    return pc.SR + skill.SklSR + byAbil
end


function SCR_GET_SPENDITEM_COUNT(skill)
    local count = skill.SpendItemBaseCount
    local pc = GetSkillOwner(skill);
    local addCount = GetAbilityAddSpendValue(pc, skill.ClassName, "SpendItem");

    return count + addCount;
end

function SCR_GET_SPENDITEM_COUNT_BackMasking(skill)
    local count = skill.SpendItemBaseCount
    local pc = GetSkillOwner(skill);
    if GetExProp(pc, "BACKMASKING_HIDDEN_ABIL_STATE") == 1 then
        count = 0;
    end

    return count;
end

function SCR_GET_SPENDITEM_COUNT_BroomTrap(skill)
    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Sapper34')
    if abil ~= nil and 1 == abil.ActiveState then
        count = count + 1;
    end
    return count;
end

function SCR_GET_SPENDITEM_COUNT_PunjiStake(skill)
    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Sapper32')
    if abil ~= nil and 1 == abil.ActiveState then
        count = count - 1;
    end
    return count;
end

function SCR_GET_SPENDITEM_COUNT_SpikeShooter(skill)
    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Sapper35')
    if abil ~= nil and 1 == abil.ActiveState then
        count = count * 2;
    end
    return count;
end

function SCR_GET_SPENDITEM_COUNT_Claymore(skill)
    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Sapper33')
    if abil ~= nil and 1 == abil.ActiveState then
        count = count * 2;
    end
    return count;
end

function SCR_GET_SPENDITEM_COUNT_GreenwoodShikigami(skill)
    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Onmyoji16')
    if abil ~= nil and abil.ActiveState == 1 then
        count = count * 2;
    end
    
    return count;
end

function SCR_GET_Dekatos_Ratio(skill)
    return 300
end


function SCR_GET_Overestimate_Ratio(skill)
    local pc = GetSkillOwner(skill);
    return skill.Level + 2
end

function SCR_GET_Overestimate_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, 'Appraiser1')
    local time = 40
    if abil ~= nil and abil.ActiveState == 1 then
        time = time + (abil.Level * 1)
    end
    return time;
end

function SCR_GET_Devaluation_Ratio(skill)
    local value = skill.Level;
    
    return value
end

function SCR_GET_Devaluation_Ratio2(skill)
    local value = 15
    
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value
end

function SCR_GET_Devaluation_Ratio3(skill)
    local value = 15
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value
end

function SCR_GET_Blindside_Ratio(skill)
    local pc = GetSkillOwner(skill);
    return 10 + (skill.Level * 2);
end


function SCR_GET_Forgery_Ratio2(skill)
    local value = 300 + (skill.Level * 100);
    
    return value
end

function SCR_GET_Apprise_Ratio(skill)
    local pc = GetSkillOwner(skill);
    return 20 + (skill.Level * 2);
end

function SCR_GET_Apprise_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    return 20 + (skill.Level * 2);
end

function SCR_GET_Devaluation_BuffTime(skill)
    local pc = GetSkillOwner(skill);
    local abil = GetAbility(pc, "Appraiser2")
    local ratio = 50
    if abil ~= nil and abil.ActiveState == 1 then
        ratio = ratio + (abil.Level * 1)
    end
    return ratio
end

function SCR_GET_Blindside_Ratio2(skill)
    local value = 5 + skill.Level
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value
end



function SCR_GET_SPENDITEM_COUNT_Aspersion(skill)

    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);
    if GetAbility(pc, 'Priest1') ~= nil then
        count = count + 1;
    end

     return count;
end


function SCR_GET_SPENDITEM_COUNT_Blessing(skill)

    local count = skill.SpendItemBaseCount;
    local pc = GetSkillOwner(skill);

    return count;
end

function SCR_GET_Hexing_Ratio(skill)
    local pc = GetSkillOwner(skill);
--    local value = 12.9 + (skill.Level - 1) * 3.2 + pc.MNA * 0.3
    local value = 7.5 + (skill.Level * 0.5)
    
    return value;
end

function SCR_GET_IronHook_Ratio(skill)
    
    local pc = GetSkillOwner(skill);
    local value = 4 + skill.Level * 1;
    local zone = GetZoneName(pc);
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5;
    end
    
    return value;
end

function SCR_GET_Ogouveve_Ratio(skill)
    
    local pc = GetSkillOwner(skill);
--    local value = 2 + 1.2 * (skill.Level - 1) + pc.INT * 0.5
    local value = skill.Level * 5
    
    return math.floor(value);
end

function SCR_GET_Ogouveve_BuffTime(skill)
    
    local pc = GetSkillOwner(skill);
    local value = 60 + skill.Level * 10
    
    return math.floor(value);
end


function SCR_GET_Ogouveve_Ratio2(skill)
    
    local value = 1 + skill.Level * 0.5
    
    return math.floor(value);
end

function SCR_GET_Ogouveve_Ratio3(skill)
    local skillLevel = TryGetProp(skill, 'Level');
    if skillLevel == nil then
        skillLevel = 0;
    end
    
    local value = skillLevel * 10;
    
    return math.floor(value);
end

function SCR_GET_Samdiveve_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = (pc.MHP - pc.MHP_BM) * (0.05 * skill.Level)
    return math.floor(value)

end

function SCR_GET_Samdiveve_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 3 + skill.Level * 1
    local zone = GetZoneName(pc)
    
    return value
end

function SCR_GET_Samdiveve_BuffTime(skill)

    local value = 40 + skill.Level * 10
    return value
     
end

function SCR_GET_CarveAustrasKoks_Ratio(skill)
    local value = 15 + skill.Level * 2
    
    return value
end


function SCR_GET_CarveAustrasKoks_Ratio2(skill)
    local value = skill.Level * 4
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return value
end

function SCR_GET_CarveVakarine_Ratio(skill)
    return skill.Level
end

function SCR_GET_CarveZemina_Ratio(skill)
    local value = 1.5 * skill.Level
    
    return value
end

function SCR_GET_CarveLaima_Ratio(skill)
    local value = skill.Level * 2
    
    return value
end

function SCR_GET_CarveLaima_Ratio3(skill)
    local pc = GetSkillOwner(skill)
    local value = 10
    if IsPVPServer(pc) == 1 then
        value = math.floor(value * 0.5);
    end
    
    return value;
end

function SCR_GET_CarveAusirine_Ratio(skill)
    local value = skill.Level * 60
    
    return value
end

function SCR_GET_DELAY_TIME(skill)
    local actor = GetSkillOwner(skill);
    if actor ~= nil then
        if actor.ClassName ~= "PC" and actor.Faction == "Monster" then
            if skill.ClassType == 'Missile' or skill.UseType == 'FORCE' or skill.UseType == 'FORCE_GROUND' then
                if actor.Lv < 75 then
                    return 3000;
                elseif actor.Lv < 170 then
                    return 2500;
                elseif actor.Lv < 220 then
                    return 2000;
                else
                    return 1500;
                end
            else
                if actor.Lv < 40 then
                    return 3000;
                elseif actor.Lv < 75 then
                    return 2500;
                elseif actor.Lv < 120 then
                    return 2000;
                elseif actor.Lv < 170 then
                    return 1500;
                elseif actor.Lv < 220 then
                    return 1000;
                else
                    return 500;
                end
            end
        end
    end
    return skill.DelayTime;
end

function SCR_USE_DELAY_TIME(skill)
    return skill.DelayTime;
end

function SCR_GET_Dig_Ratio(skill)
    local value = skill.Level;
    return value;
end



function SCR_Get_SkillFactor_Zombify(skill)
    local mon = GetSkillOwner(skill)
    local owner = GetOwner(mon)
    local ownerSkill = GetSkill(owner, "Bokor_Zombify")

    local value = skill.SklFactor + (ownerSkill.Level - 1) * skill.SklFactorByLevel
    return math.floor(value)
end

function SCR_GET_SilverBullet_BuffTime(skill)
    local value = 15 + skill.Level * 3 
    return value;
end

function SCR_GET_Tase_BuffTime(skill)
    local value = 15 + skill.Level * 3
    return value;
end

function SCR_GET_Tase_Ratio(skill)
    local value = 10
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Bulletmarker7")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_DoubleGunStance_BuffTime(skill)

end

function SCR_GET_SmashBullet_Ratio(skill)
    local value = 0
    return value;
end

function SCR_GET_TracerBullet_Ratio(skill)
    local value = 10 + skill.Level * 2
    return value;
end

function SCR_GET_TracerBullet_BuffTime(skill)
    local value = 15
    
    return value;
end

function SCR_GET_Jump_Ratio(skill)
    local value = 80 + (skill.Level * 10)
    return value;
end

function SCR_GET_InfiniteAssault_Ratio(skill)
    local value = skill.Level * 3
    
    return value
end

function SCR_GET_DownFall_Ratio(skill)
    local value = 3 + skill.Level * 0.5;
    return value;
end

function SCR_GET_DownFall_Ratio2(skill)
    local value = 0.2
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Mergen14")
    if abil ~= nil and TryGetProp(abil, "ActiveState") == 1 then
        value = 0.3
    end
    
    return value;
end

function SCR_GET_HakkaPalle_Ratio(skill)
    local value = 50 * skill.Level
    
    return value;
end

function SCR_GET_HakkaPalle_Ratio2(skill)
    local value = 5 + skill.Level
    
    return value
end

function SCR_GET_HakkaPalle_Ratio3(skill)
    local value = skill.Level * 5
    
    return value
end

function SCR_GET_SnipersSerenity_Ratio(skill)
    local value = 4 - ((skill.Level - 1) * 0.4)
    if value < 0.4 then
        value = 0.4
    end
    
    return value;
end

function SCR_GET_NonInvasiveArea_Bufftime(skill)
    local value = 10;
    return value
end

function SCR_GET_NonInvasiveArea_Ratio(skill)
    local value = 5 + (skill.Level * 2)
    
    return value
end

function SCR_GET_NonInvasiveArea_Ratio2(skill)
    local value = 42 + skill.Level * 2
    return value;
end

function SCR_Get_SkillFactor_RamMuay(skill)
    local pc = GetSkillOwner(skill);
    local value = 0
    local RamMuaySkill = GetSkill(pc, "NakMuay_RamMuay")
    if RamMuaySkill ~= nil then
        value = RamMuaySkill.SkillFactor;
    end
    return math.floor(value)
end

function SCR_GET_Rammuay_Ratio(skill)
    local value = skill.Level * 20
    
    return value;
end

function SCR_GET_SokChiang_Time(skill)
    local pc = GetSkillOwner(skill);
    local value = 5 + skill.Level * 1
    
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value * 0.5; 
    end

    return value;
end

function SCR_GET_GroovingMuzzle_BuffTime(skill)
    local value = 15 + skill.Level;
    
    return value
end

function SCR_GET_Sabbath_Ratio(skill)
    local value = 40
    value = value + (TryGetProp(skill, "Level") * 4)
    return value
end

function SCR_GET_SubweaponCancel_Ratio(skill)
    local value = 105;
    return value;
end

function SCR_GET_FishingNetsDraw_Ratio(skill)
    local value = 5 * skill.Level;
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value;
end

function SCR_GET_FishingNetsDraw_Ratio2(skill)
    local value = 3 + skill.Level;
    return value;
end

function SCR_GET_FishingNetsDraw_Ratio3(skill)
    local skillLv = TryGetProp(skill, "Level");
    local value = skillLv * 2;
    return value;
end

function SCR_GET_ThrowingFishingNet_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 2.5 + skill.Level * 0.5;
    
    return value;
end

function SCR_GET_ThrowingFishingNet_Ratio2(skill)
    return 3 + skill.Level;
end

function SCR_GET_ThrowingFishingNet_Ratio3(skill)
    local value = 100
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value
end


function SCR_GET_DaggerGuard_Ratio(skill)
    local value = skill.Level * 10;
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value;
end

function SCR_GET_DaggerGuard_Ratio2(skill)
    return 15;
end

function SCR_GET_DaggerGuard_Ratio3(skill)
    local value = 10 + TryGetProp(skill, "Level");
    return value;
end

function SCR_Get_SkillFactor_FireFoxShikigami_Summon(skill)
    local value = 0
    local fireFox = GetSkillOwner(skill);
    local owner = GetOwner(fireFox)
    if owner ~= nil then
        local skillFireFoxShikigami = GetSkill(owner, "Onmyoji_FireFoxShikigami")
        if skillFireFoxShikigami ~= nil then
            value = skillFireFoxShikigami.SkillFactor
        end
    end
    
    return math.floor(value)
end

function SCR_Get_SkillFactor_FireFoxShikigami2_Summon(skill)
    local value = skill.SklFactor
    local fireFox = GetSkillOwner(skill);
    local owner = GetOwner(fireFox)
    if owner ~= nil then
        local skillFireFoxShikigami = GetSkill(owner, "Onmyoji_FireFoxShikigami")
        if skillFireFoxShikigami ~= nil then
            value = skillFireFoxShikigami.SkillFactor
        end
    end
    
    return math.floor(value)
end

function SCR_GET_FireFoxShikigami_Ratio(skill)
    local value = 20 + skill.Level * 5
    return value
end

function SCR_GET_WhiteTigerHowling_Ratio(skill)
    local value = 4 + skill.Level
    return value
end

function SCR_GET_GenbuArmor_Ratio(skill)
    local pc = GetSkillOwner(skill);
	local SPValue = 10
	if IsPVPField(pc) == 1 then
		SPValue = 5
	end
    local value = 100 - ((skill.Level - 1) * SPValue)
    
    local abilOnmyoji12 = GetAbility(pc, "Onmyoji12")
    if abilOnmyoji12 ~= nil and TryGetProp(abilOnmyoji12, "ActiveState", 0) == 1 then
        value = value - (value * abilOnmyoji12.Level * 0.01)
    end
    
    return value
end

function SCR_GET_GenbuArmor_Ratio2(skill)
    local value = 60
    
    return value
end

function SCR_GET_VitalProtection_Ratio(skill)
    local value = 10 + skill.Level * 2
    return value;
end

function SCR_GET_Retiarii_EquipDesrption_Ratio(skill)
    local value = 25;
    return value;
end

function SCR_GET_Retiarii_EquipDesrption_Ratio2(skill)
    local value = 5;
    return value;
end

function SCR_GET_Kraujas_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = pc.RHP;
    if pc ~= nil then
        value = pc.RHP * 10;
    end
    
    return value;
end

function SCR_GET_Rykuma_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 20
    if pc ~= nil then
        local isDragonPower = GetExProp(pc, 'ITEM_DRAGON_POWER')
        if tonumber(isDragonPower) >= 1 then
            value = 30
        end  
    end
    
    return value;
end

function SCR_GET_Apsauga_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 25
    if pc ~= nil then
        local isDragonPower = GetExProp(pc, 'ITEM_DRAGON_POWER')
        if tonumber(isDragonPower) >= 1 then
            value = value + 25
        end  
    end
    
    return value;
end

function SCR_GET_Bendrinti_Time(skill)
    local value = 30
    return value;
end

function SCR_GET_Bendrinti_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 25
    if pc ~= nil then
        local isDragonPower = GetExProp(pc, 'ITEM_DRAGON_POWER')
        if tonumber(isDragonPower) >= 1 then
            value = value + 15
        end  
    end
    
    return value;
end

function SCR_GET_Goduma_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local casterMHP = TryGetProp(pc, "MHP", 0) - TryGetProp(pc, "MHP_BM", 0)
    local value = math.floor(casterMHP / (2000 * PC_MAX_LEVEL) * 100)
    
    return value
end

function SCR_GET_Gymas_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 25
    if pc ~= nil then
        local isDragonPower = GetExProp(pc, 'ITEM_DRAGON_POWER')
        if tonumber(isDragonPower) >= 1 then
            value = value + 25
        end  
    end
    
    return value;
end

function SCR_GET_Smugis_Ratio(skill)
    local value = 20
    return value;
end

function SCR_GET_LatentVenom_Ratio(skill)

    local value = 3

    return value;
end


function SCR_GET_LatentVenom_Ratio2(skill)

    local value = 100

    return value;
end


function SCR_GET_Dissonanz_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 5
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = value / 2
    end
    
    return value;
end


function SCR_GET_Wiegenlied_Ratio(skill)
    local value = 5 + skill.Level
    
    return value;
end


function SCR_GET_Wiegenlied_Ratio2(skill)
    local value = 5 + (skill.Level * 2)
    
    return value;
end


function SCR_GET_HypnotischeFlete_Ratio(skill)
    local value = 3 + skill.Level
    
    return value;
end


function SCR_GET_Friedenslied_Ratio(skill)
    local value = 4 + skill.Level
    
    return value;
end


function SCR_GET_Marschierendeslied_Ratio(skill)
    local value = 10 + skill.Level
    
    return value;
end


function SCR_GET_LiedDerWeltbaum_BuffTime(skill)
    local pc = GetSkillOwner(skill)
    local value = 10
    local abil = GetAbility(pc, "PiedPiper15")
    if abil ~= nil and TryGetProp(abil, "ActiveState") == 1 then
        value = value + TryGetProp(abil, "Level")
    end
    
    return value;
end

function SCR_GET_LiedDerWeltbaum_Ratio(skill)
    local value = 50 + (skill.Level * 10)
    
    return value;
end

function SCR_GET_LiedDerWeltbaum_Ratio2(skill)
    local value = 50 + (skill.Level * 10)
    
    return value;
end


function SCR_Get_Crescendo_Bane(skill)
    local value = 10 * skill.Level
    
    return value;
end

function SCR_Get_Crescendo_Bane2(skill)
    local value = skill.Level * 14
    
    return value;
end

function SCR_GET_WideMiasma_Bufftime(skill)
    local value = 10
    
    return value
end

function SCR_Get_SkillFactor_HamelnNagetier_Mouse(skill)
    local value = 0
    local piedPiper = GetSkillOwner(skill);
    local owner = GetOwner(piedPiper)
    if owner ~= nil then
        local skillHameln = GetSkill(owner, "PiedPiper_HamelnNagetier")
        if skillHameln ~= nil then   
            value = skillHameln.SkillFactor
        end
    end
    
    return math.floor(value)
end

function SCR_GET_Rubric_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 5;
    local abilExorcist2 = GetAbility(pc, "Exorcist2");
    if abilExorcist2 ~= nil and TryGetProp(abilExorcist2, "ActiveState") == 1 then
        value = value + abilExorcist2.Level;
    end
    
    return value;
end

function SCR_GET_Rubric_Ratio2(skill)
    local value = 5
    local pc = GetSkillOwner(skill);
    local abilExorcist3 = GetAbility(pc, "Exorcist3");
    if abilExorcist3 ~= nil and TryGetProp(abilExorcist3, "ActiveState") == 1 then
        value = 25
    end
    
    return value;
end

function SCR_GET_Rubric_Ratio3(skill)
    local value = 4
    local pc = GetSkillOwner(skill);
    local abilExorcist3 = GetAbility(pc, "Exorcist3");
    if abilExorcist3 ~= nil and TryGetProp(abilExorcist3, "ActiveState") == 1 then
        value = 2
    end
    
    return value;
end



function SCR_GET_Engkrateia_Ratio(skill)
    return skill.Level * 5
end

function SCR_GET_Engkrateia_Ratio2(skill)
    local pc = GetSkillOwner(skill);
    local value = 3;
    local abilExorcist8 = GetAbility(pc, "Exorcist8");
    if abilExorcist8 ~= nil and TryGetProp(abilExorcist8, "ActiveState") == 1 then
        value = value + abilExorcist8.Level;
    end

    return value;
end

function SCR_GET_TheTreeofSepiroth_Ratio(skill)
    local value = 36 + (skill.Level - 1) * 16.9
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value
end

function SCR_GET_TheTreeofSepiroth_Time(skill)
    local value = 10
    return value;
end

function SCR_GET_Koinonia_Ratio(skill)
    local value = 5 + 3 * skill.Level;
    return value;
end

function SCR_GET_Gregorate_Ratio(skill)
    local value = 3;
    local pc = GetSkillOwner(skill);
    local abilExorcist11 = GetAbility(pc, "Exorcist11");
    if abilExorcist11 ~= nil and TryGetProp(abilExorcist11, "ActiveState") == 1 then
        value = value + abilExorcist11.Level;
    end
    
    return value;
end

function SCR_GET_Gregorate_Ratio2(skill)
    local value = 2;
    local pc = GetSkillOwner(skill);
    value = skill.Level * value;
    return value;
end

function SCR_GET_FreezeBullet_BuffTime(skill)
    local value = 15 + skill.Level
    
    return value
end

function SCR_GET_OverReinforce_BuffTime(skill)
    local value = 45

    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Enchanter5')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + (abil.Level * 3)
    end
    
    return value
end

function SCR_GET_OverReinforce_Ratio(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_BreastRipper_Ratio(skill)
    local pc = GetSkillOwner(skill);
    local value = 5
    local STR = TryGetProp(pc, "STR")
    local strValue = STR / 50
    if strValue <= 0 then
        strValue = 0
    end
    value = value + strValue
    
    return math.floor(value)
end

function SCR_GET_InfernalShadow_Bufftime(skill)
    return 5 + skill.Level * 2;
end


function SCR_GET_InfernalShadow_CaptionRatio(skill)
    return 20 + (skill.Level -1) * 20;
end

function SCR_GET_EmphasisTrust_Ratio(skill)
    return 15 + skill.Level*2;
end

function SCR_GET_Hasisas_Ratio(skill)
    local value = 30 + skill.Level * 15
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value;
end

function SCR_GET_Hasisas_Ratio2(skill)
    local value = 10
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Assassin2')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value;
end

function SCR_GET_Hasisas_Ratio3(skill)
    local value = skill.Level * 2
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    local pc = GetSkillOwner(skill)
    local MHP = pc.MHP
    if info == nil then
        return 0
    end
    local stat = info.GetStat(session.GetMyHandle());
    local HP = stat.HP
    local HPRate = (1 - (HP / MHP)) * 100
    value = value + HPRate
    
    return value;
end

function SCR_GET_HallucinationSmoke_Ratio(skill)
    local value = 20
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    return value;
end

function SCR_GET_HallucinationSmoke_Time(skill)
    local value = 5 + skill.Level
    return value;
end

function SCR_GET_PiercingHeart_Time(skill)
    local value = 10;
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'Assassin13')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end 
    return value;
end

function SCR_GET_Bully_Ratio(skill)
    local value = 10 * skill.Level
    
    return value;
end

function SCR_GET_Bully_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local minSubPATK = TryGetProp(pc, "MINPATK_SUB")
    local maxSubPATK = TryGetProp(pc, "MAXPATK_SUB")
    local patkValue = math.floor((minSubPATK + maxSubPATK) / 2)
    local hateValue = patkValue * (skill.Level * 0.02)
    
    return math.floor(hateValue);
end

function SCR_GET_Aggress_Ratio(skill)
    local value = skill.Level * 3
    
    return value;
end

function SCR_GET_SiegeBurst_Ratio2(skill)
    local value = skill.Level * 0.1
    
    return value;
end

function SCR_GET_Algiz_Ratio(skill)
    local value = skill.Level * 2
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return value;
end

function SCR_GET_Algiz_Ratio2(skill)
    local value = 30;
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, 'RuneCaster11')
    if abil ~= nil and abil.ActiveState == 1 then
        value = 5
    end 
    return value;
end

function SCR_GET_SprinkleHPPotion_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local hpPotion = SCR_GET_SPEND_ITEM_Alchemist_SprinkleHPPotion(pc)
    local numberArg1 = TryGetProp(hpPotion, "NumberArg1", 0)
    local hpValue = numberArg1 * 7
    
    hpValue = hpValue * 8
    
    local sprinkleHP = hpValue * (skill.Level * 0.1)
    
    return sprinkleHP;
end

function SCR_GET_SprinkleSPPotion_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local spPotion = SCR_GET_SPEND_ITEM_Alchemist_SprinkleSPPotion(pc)
    local numberArg1 = TryGetProp(spPotion, "NumberArg1", 0)
    local spValue = numberArg1 * 7
    
    spValue = spValue * 8
    
    local sprinkleSP = spValue * (skill.Level * 0.1)
    
    return sprinkleSP;
end

function GET_SPENDSP_BY_LEVEL(sklObj, destLv)
    if destLv == nil or destLv == 0 then
        return math.floor(sklObj.SpendSP);
    end

    if destLv > 0 then
        local tempObj = CreateGCIESByID("Skill", sklObj.ClassID);
        if tempObj == nil then
            return 0;
        end
        tempObj.Level = destLv;
        return math.floor(tempObj.SpendSP);
    end

    --if upLv < 0 then return nil end;
    return nil;
end

function SCR_GET_Insurance_Ratio(skill)
    local value = skill.Level * 6
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value;
end

function SCR_GET_Insurance_Ratio2(skill)
    local value = skill.Level * 5
    return value;
end

function SCR_GET_Insurance_Ratio3(skill)
    local value = skill.Level * 5
    return value;
end

function SCR_GET_SwellHands_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local DEX = TryGetProp(pc, "DEX", 1)
    local value = 30 + ((skill.Level - 1) * 2) + ((skill.Level / 5) * ((DEX * 0.8) ^ 0.9))
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value;
end

function SCR_GET_Agility_Ratio(skill)
    local value = skill.Level * 1
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    return value;
end

function SCR_GET_EnchantGlove_Ratio(skill)
    local value = 10 + (skill.Level * 2)
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    return value;
end

function SCR_GET_KnifeThrowing_Ratio(skill)
    local value = 5 + (skill.Level * 1)
    
    return value;
end

function SCR_Get_TimeForward_Ratio(skill)
    local value = skill.Level * 3
    
    return value;
end

function SCR_Get_Howling_Ratio(skill)
    local value = skill.Level * 4
    
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
    
    return math.floor(value);
end


function SCR_GET_Immolation_Ratio(skill)
    local value = 0
    local pc = GetSkillOwner(skill)
    local abil = GetAbility(pc, "Zealot4")
    if abil ~= nil and abil.ActiveState == 1 then
        value = abil.Level * 300
    end
    
    return value
end

function SCR_GET_BeadyEyed_Ratio(skill)
    local value = skill.Level * 3
    
    return value
end

function SCR_GET_FanaticIllusion_Ratio2(skill)
    local value = skill.Level * 10
    
    return value
end

function SCR_GET_FreezeBullet_Ratio(skill)
    local value = 30
    local pc = GetSkillOwner(skill)
    if IsPVPServer(pc) == 1 then
        value = value / 2
    end
    
    return value
end

function SCR_GET_brutality_Ratio(skill)
    local value = (skill.Level * 4)
    
    return value
end

function SCR_GET_Bunshin_no_jutsu_Ratio3(skill)
    local value = 10 * skill.Level
    
    return value
end

function SCR_Get_DragonFear_Ratio(skill)
    local value = 10 + (skill.Level * 2)
    
    return value
end

function SCR_Get_DragonFear_Ratio2(skill)
    local value = skill.Level
    
    return value
end

function SCR_GET_MuayThai_Ratio(skill)
    local value = 10 + skill.Level
    
    return value;
end

function SCR_GET_MuayThai_Ratio2(skill)
    local value = skill.Level * 10
    
    return value;
end

function SCR_GET_Hallucination_Ratio(skill)
    local value = 25 + (skill.Level * 5)
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill))
    
    return value
end

function SCR_GET_HardShield_Ratio(skill)
    local value = 20 * skill.Level
    value = math.floor(value * SCR_REINFORCEABILITY_TOOLTIP(skill));
    
    return math.floor(value)
end

function SCR_GET_SR_LV_Hackapell_GrindCutter(skill)
    local pc = GetSkillOwner(skill);
    local value = pc.SR + skill.SklSR;
    
    if IsBuffApplied(pc, "CavalryCharge_Buff") == "YES" then
        value = value + 10
    end
    
    if value < 1 then
        value = 1
    end
    
    return value
end

function SCR_GET_SKL_COOLDOWN_Preparation(skill)
    local pc = GetSkillOwner(skill);
    local basicCoolDown = TryGetProp(skill, "BasicCoolDown", 0) - TryGetProp(skill, "Level", 0) * 1000;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    return math.floor(basicCoolDown);
end

function SCR_GET_SKL_COOLDOWN_KnifeThrowing(skill)
    local pc = GetSkillOwner(skill);
    local basicCoolDown = TryGetProp(skill, "BasicCoolDown", 0) - TryGetProp(skill, "Level", 0) * 1000;
    local abilAddCoolDown = GetAbilityAddSpendValue(pc, skill.ClassName, "CoolDown");
    
    basicCoolDown = basicCoolDown + abilAddCoolDown;
        
    local laimaCoolTime = GetExProp(pc, "LAIMA_BUFF_COOLDOWN")
    if laimaCoolTime ~= 0 then
        basicCoolDown = basicCoolDown * (1 - laimaCoolTime)
    elseif IsBuffApplied(pc, 'CarveLaima_Debuff') == 'YES' then
        basicCoolDown = basicCoolDown * 1.2;
    end
    
    if IsBuffApplied(pc, 'GM_Cooldown_Buff') == 'YES' then
        basicCoolDown = basicCoolDown * 0.9;
    end
    
    return math.floor(basicCoolDown);
end

function SCR_GET_Bully_Time(skill)
    local value = 60
    
    local pc = GetSkillOwner(skill);
    local Outlaw19_abil = GetAbility(pc, 'Outlaw19')
    if Outlaw19_abil ~= nil and 1 == Outlaw19_abil.ActiveState then
        value = 20
    end
    
    return value
end


function SCR_GET_LightningCharm_Ratio(skill)
	local value = 50
	value = value * SCR_REINFORCEABILITY_TOOLTIP(skill);
	
	return value
end

function SCR_Get_BloodCurse_ratio2(skill)
    local value = (1 + skill.Level * 0.1)
    
    return value
end

-- Matross_FireAndRun
function SCR_GET_FireAndRun_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 90;
    local abil = GetAbility(pc, "Matross2")
    if abil ~= nil and abil.ActiveState == 1 then
        value = 45
    end
    
    return value
end

-- Matross_Explosion
function SCR_GET_Explosion_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = math.floor(3 + skill.Level * 0.375);
    
    if IsBuffApplied(pc, "Bazooka_Buff") == "YES" then
        value = value * 2
    end
    
    return value
end

-- Matross_MenaceShot
function SCR_GET_MenaceShot_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 5;
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 2.5;
    end
    
    return value;
end

function SCR_GET_MenaceShot_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 3 + skill.Level;
    if IsPVPServer(pc) == 1 or IsPVPField(pc) == 1 then
        value = 3;
    end
    
    return value;
end

-- Matross_Roar
function SCR_GET_Roar_Time(skill)
    local value = 45
    return value
end

function SCR_GET_Roar_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = skill.Level * 6
    
    return value
end

-- Matross_CanisterShot
function SCR_GET_CanisterShot_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 5;
    local abil = GetAbility(pc, "Matross12")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + abil.Level
    end
    
    return value
end

function SCR_GET_CanisterShot_Ratio(skill)
    local value = 10
    return value
end

-- TigerHunter_PierceShot
function  SCR_GET_PierceShot_Ratio(skill)
    local value = 50
    return value
end

-- TigerHunter_Tracking
function SCR_GET_Tracking_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 11 + skill.Level * 0.6
    
    local abil = GetAbility(pc, "TigerHunter2");
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + 10;
    end
    
    return value;
end

function SCR_GET_Tracking_Ratio(skill)
    local value = 10 + (skill.Level * 6)
    return value
end

-- TigerHunter_RapidShot
function SCR_GET_RapidShot_Ratio(skill)
    local value = 20
    return value
end

-- TigerHunter_EyeofBeast
function SCR_GET_EyeofBeast_Time(skill)
    local value = 10
    return value
end

function SCR_GET_EyeofBeast_Ratio(skill)
    local value = skill.Level * 3
    return value
end

function SCR_GET_EyeofBeast_Ratio2(skill)
    local value = skill.Level * 5
    return value
end

-- TigerHunter_Blitz
function SCR_GET_Blitz_Ratio(skill)
    local value = skill.Level * 5
    return value
end

-- TigerHunter_HideShot
function SCR_GET_HideShot_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 10
    
    return value;
end

function SCR_GET_HideShot_Ratio(skill)
    local value = 50 - (skill.Level * 3)
    return value
end

-- Arditi_TreGranata
function SCR_GET_TreGranata_Time(skill)
    local value = 8
    return value
end

function SCR_GET_TreGranata_Ratio(skill)
    local value = 3
    return value
end

-- Arditi_Recupero
function SCR_GET_Recupero_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = skill.Level * 595
    value = value * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    local mhp = TryGetProp(pc, "MHP", 0)
    if value > mhp * 0.5 then
        value =  math.floor(mhp * 0.5)
    end    

    return value
end

function SCR_GET_Recupero_Ratio3(skill)
    local pc = GetSkillOwner(skill)
    local addHP = skill.Level * 535
    addHP = addHP * SCR_REINFORCEABILITY_TOOLTIP(skill)
    
    local mhp = TryGetProp(pc, "MHP", 0)
    
    local value = addHP - math.floor(mhp * 0.5)
    
    if value < 0 then
        value = 0;
    end

    return value
end

function SCR_GET_Recupero_Ratio2(skill)
    local value = skill.Level
    return value
end

-- Arditi_Taglio
function SCR_GET_Taglio_Time(skill)
    local value = 2
    return value
end

function SCR_GET_Taglio_Ratio(skill)
    local value = 10
    return value
end

-- Sheriff_Westraid
function SCR_GET_Westraid_Time(skill)
    local value = 30
    return value
end

function SCR_GET_Westraid_Ratio(skill)
    local value = math.floor(3 + skill.Level * 0.4)
    return value
end

-- Sheriff_Peacemaker
function SCR_GET_Peacemaker_Time(skill)
    local value = 3
    return value
end

function SCR_GET_Peacemaker_Time2(skill)
    local value = 3 + (skill.Level - 1) * 0.5
    return value
end

-- Sheriff_Redemption
function SCR_GET_Redemption_Time(skill)
    local pc = GetSkillOwner(skill)
    local value = 20
    local abil = GetAbility(pc, 'Sheriff6')
    if abil ~= nil and abil.ActiveState == 1 then
        value = 10;
    end
    
    return value
end

function SCR_GET_Redemption_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = skill.Level
    local abil = GetAbility(pc, 'Sheriff6')
    if abil ~= nil and abil.ActiveState == 1 then
        value = value * 2;
    end    
    return value
end

-- Sheriff_AimingShot
function SCR_GET_AimingShot_Ratio(skill)
    local pc = GetSkillOwner(skill)
    local value = 3
    local abil = GetAbility(pc, "Sheriff5")
    if abil ~= nil and abil.ActiveState == 1 then
        value = 1
    end

    return value
end

function SCR_GET_AimingShot_Ratio2(skill)
    local pc = GetSkillOwner(skill)
    local value = 50
    local abil = GetAbility(pc, "Sheriff5")
    if abil ~= nil and abil.ActiveState == 1 then
        value = 200
    end

    return value
end

function SCR_GET_Prevent_Bufftime(skill)
    local pc = GetSkillOwner(skill)
    local value = 2
    local abil = GetAbility(pc, "Lancer14")
    if abil ~= nil and abil.ActiveState == 1 then
        value = value + (abil.Level * 0.2)
    end

    return value
end

function SCR_GET_Methadone_Ratio(skill)
	local value = 20 - (skill.Level * 2)
	
	return value;
end

function SCR_GET_Prevent_Ratio(skill)
    local value = skill.Level * 3
    
    return value
end

function SCR_GET_JOLLYROGERFEVERTIME(pc)
	local bufftime = 10000
	if IsExistSkill(pc, 'Thaumaturge_SwellHands') ~= 0 then
		bufftime = bufftime + 25000
	end
	if IsExistSkill(pc, 'Linker_JointPenalty') ~= 0 then
		bufftime = bufftime + 25000
	end
	if IsExistSkill(pc, 'Enchanter_OverReinforce') ~= 0 then
		bufftime = bufftime + 25000
	end	

	return bufftime
end

function SCR_GET_SPRIMKLESANDSTIME(skill)
    local value = skill.Level * 0.2

    return value
end