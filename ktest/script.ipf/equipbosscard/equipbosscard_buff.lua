--[[ 
function SCR_BUFF_ENTER_(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_(self, buff, arg1, arg2, over)
end

function SCR_BUFF_GIVEDMG_(self, buff, sklID, damage, target, ret)
    return 1;
end

function SCR_BUFF_TAKEDMG_(self, buff, sklID, damage, attacker)
    return 1;
end


function SCR_BUFF_RATETABLE_(self, from, skill, atk, ret, rateTable, buff)
end
]]--



function SCR_BUFF_ENTER_card_Devilglove(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_card_Devilglove(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_card_Devilglove(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'card_Devilglove') == 'YES' then
        local arg1, arg2 = GetBuffArg(buff)

        if TryGetProp(self, 'RaceType') == "Paramune" then
            rateTable.DamageRate = rateTable.DamageRate + arg2
        end
    end
end

function SCR_BUFF_ENTER_card_AddDamageMonSize(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_card_AddDamageMonSize(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_card_AddDamageMonSize(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'card_AddDamageMonSize') == 'YES' then
        local arg1, arg2 = GetBuffArg(buff)

        if TryGetProp(self, 'Size') == arg2 then
            rateTable.DamageRate = rateTable.DamageRate + arg1
        end
    end
end

function SCR_BUFF_ENTER_card_AddDamageMonRank(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_card_AddDamageMonRank(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_card_AddDamageMonRank(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'card_AddDamageMonRank') == 'YES' then
        local arg1, arg2 = GetBuffArg(buff)

        if TryGetProp(self, 'MonRank') == arg2 then
            rateTable.DamageRate = rateTable.DamageRate + arg1
        end
    end
end

function SCR_BUFF_ENTER_card_AddDamageMonRace(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_card_AddDamageMonRace(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_card_AddDamageMonRace(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'card_AddDamageMonRace') == 'YES' then
        local arg1, arg2 = GetBuffArg(buff)

        if TryGetProp(self, 'RaceType') == arg2 then
            rateTable.DamageRate = rateTable.DamageRate + arg1
        end
    end
end

function SCR_BUFF_ENTER_card_AddDamageMonAttribute(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_card_AddDamageMonAttribute(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_card_AddDamageMonAttribute(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'card_AddDamageMonAttribute') == 'YES' then
        local arg1, arg2 = GetBuffArg(buff)

        if TryGetProp(self, 'Attribute') == arg2 then
            rateTable.DamageRate = rateTable.DamageRate + arg1
        end
    end
end

function SCR_BUFF_ENTER_card_ATK(self, buff, arg1, arg2, over)
--    SetExProp(self, "card_PATK", arg1);
--    self.PATK_BM = self.PATK_BM + arg1;
    
    if TryGetProp(self, "PATK_RATE_BM") ~= nil then
        local cardPATK = arg1 / 100;
        SetExProp(buff, "card_PATK", cardPATK);
        self.PATK_RATE_BM = self.PATK_RATE_BM + cardPATK;
    end
end

function SCR_BUFF_LEAVE_card_ATK(self, buff, arg1, arg2, over)
--    DelExProp(self, "card_PATK");
--    self.PATK_BM = self.PATK_BM - arg1;
    
    if TryGetProp(self, "PATK_RATE_BM") ~= nil then
        local cardPATK = GetExProp(buff, "card_PATK");
        self.PATK_RATE_BM = self.PATK_RATE_BM - cardPATK;
    end
end

function SCR_BUFF_ENTER_card_DEF(self, buff, arg1, arg2, over)
--  SetExProp(self, "card_DEF", arg1);
--  self.DEF_BM = self.DEF_BM + arg1;
    
    if TryGetProp(self, "DEF_RATE_BM") ~= nil then
        local cardDEF = arg1 / 100;
        SetExProp(buff, "card_DEF", cardDEF);
        self.DEF_RATE_BM = self.DEF_RATE_BM + cardDEF;
    end
end

function SCR_BUFF_LEAVE_card_DEF(self, buff, arg1, arg2, over)
--    DelExProp(self, "card_DEF");
--    self.DEF_BM = self.DEF_BM - arg1;
    
    if TryGetProp(self, "DEF_RATE_BM") ~= nil then
        local cardDEF = GetExProp(buff, "card_DEF");
        self.DEF_RATE_BM = self.DEF_RATE_BM - cardDEF;
    end
end

function SCR_BUFF_ENTER_card_MATK(self, buff, arg1, arg2, over)
--    SetExProp(self, "card_MATK", arg1);
--    self.MATK_BM = self.MATK_BM + arg1;
    
    if TryGetProp(self, "MATK_RATE_BM") ~= nil then
        local cardMATK = arg1 / 100;
        SetExProp(buff, "card_MATK", cardMATK);
        self.MATK_RATE_BM = self.MATK_RATE_BM + cardMATK;
    end
end

function SCR_BUFF_LEAVE_card_MATK(self, buff, arg1, arg2, over)
--    DelExProp(self, "card_MATK");
--    self.MATK_BM = self.MATK_BM - arg1;
    
    if TryGetProp(self, "MATK_RATE_BM") ~= nil then
        local cardMATK = GetExProp(buff, "card_MATK");
        self.MATK_RATE_BM = self.MATK_RATE_BM - cardMATK;
    end
end

function SCR_BUFF_ENTER_card_MDEF(self, buff, arg1, arg2, over)
--    SetExProp(self, "card_MDEF", arg1);
--    self.MDEF_BM = self.MDEF_BM + arg1;
    
    if TryGetProp(self, "MDEF_RATE_BM") ~= nil then
        local cardMDEF = arg1 / 100;
        SetExProp(buff, "card_MDEF", cardMDEF);
        self.MDEF_RATE_BM = self.MDEF_RATE_BM + cardMDEF;
    end
end

function SCR_BUFF_LEAVE_card_MDEF(self, buff, arg1, arg2, over)
--    DelExProp(self, "card_MDEF");
--    self.MDEF_BM = self.MDEF_BM - arg1;
    
    if TryGetProp(self, "MDEF_RATE_BM") ~= nil then
        local cardMDEF = GetExProp(buff, "card_MDEF");
        self.MDEF_RATE_BM = self.MDEF_RATE_BM - cardMDEF;
    end
end

function SCR_BUFF_ENTER_card_MSPD(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + arg1;
end

function SCR_BUFF_LEAVE_card_MSPD(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - arg1;
end

function SCR_BUFF_ENTER_card_Dark_Atk(self, buff, arg1, arg2, over)
    self.Dark_Atk_BM = self.Dark_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Dark_Atk(self, buff, arg1, arg2, over)
    self.Dark_Atk_BM = self.Dark_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Earth_Atk(self, buff, arg1, arg2, over)
    self.Earth_Atk_BM = self.Earth_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Earth_Atk(self, buff, arg1, arg2, over)
    self.Earth_Atk_BM = self.Earth_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Fire_Atk(self, buff, arg1, arg2, over)
    self.Fire_Atk_BM = self.Fire_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Fire_Atk(self, buff, arg1, arg2, over)
    self.Fire_Atk_BM = self.Fire_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Holy_Atk(self, buff, arg1, arg2, over)
    self.Holy_Atk_BM = self.Holy_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Holy_Atk(self, buff, arg1, arg2, over)
    self.Holy_Atk_BM = self.Holy_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Ice_Atk(self, buff, arg1, arg2, over)
    self.Ice_Atk_BM = self.Ice_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Ice_Atk(self, buff, arg1, arg2, over)
    self.Ice_Atk_BM = self.Ice_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Lightning_Atk(self, buff, arg1, arg2, over)
    self.Lightning_Atk_BM = self.Lightning_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Lightning_Atk(self, buff, arg1, arg2, over)
    self.Lightning_Atk_BM = self.Lightning_Atk_BM - arg1;
end

function SCR_BUFF_ENTER_card_Poison_Atk(self, buff, arg1, arg2, over)   
    self.Poison_Atk_BM = self.Poison_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_card_Poison_Atk(self, buff, arg1, arg2, over)
    self.Poison_Atk_BM = self.Poison_Atk_BM - arg1;
end


function SCR_BUFF_ENTER_card_ginklas(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_ginklas(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_ginklas(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_Denoptic(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_Denoptic(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_Denoptic(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_Rajatoad(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_Rajatoad(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_Rajatoad(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_mineloader(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_mineloader(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_mineloader(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_stone_whale(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_stone_whale(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_stone_whale(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)
        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_Abomination(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_Abomination(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_Abomination(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_card_Mandara(self, buff, arg1, arg2, over)
end
function SCR_BUFF_LEAVE_card_Mandara(self, buff, arg1, arg2, over)
end
function SCR_BUFF_AFTERCALC_HIT_card_Mandara(self, from, skill, atk, ret, buff)
    if IsBuffApplied(from, 'todal_shield') == 'NO' and IsSameActor(self, from) == "NO" and ret.Damage > 0 then
        local attribute = GetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..buff.ClassName)
        local damageRate = GetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..buff.ClassName)

        if attribute == skill.Attribute then
            local rate = GetExProp(self, "CARD_REFLECT_RATE"..buff.ClassName);
        
            if rate >= IMCRandom(1, 100) then

                local dmg = ret.Damage;
                dmg = dmg * ( damageRate / 100 );
                if dmg < 1 then
                    dmg = 1
                end
                dmg = math.floor(dmg);

                ret.Damage = 1;

                ret.KDPower = 0;
                ret.HitType = HIT_SAFETY;
                ret.HitDelay = 0;
                SetExProp(from, "CHECK_SKL_KD_PROP", 1);
            
                RunScript("CARD_REFLECT_SYNC", self, from, skill, dmg, ret)
            end
        end
    end
end

function SCR_BUFF_ENTER_CARD_CON(self, buff, arg1, arg2, over)
    if TryGetProp(self, "CON_ITEM_BM") ~= nil then
        local cardCON = arg1;
        SetExProp(buff, "CARD_CON", cardCON);
        self.CON_ITEM_BM = self.CON_ITEM_BM + cardCON;
    end
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_CARD_CON(self, buff, arg1, arg2, over)
    if TryGetProp(self, "CON_ITEM_BM") ~= nil then
        local cardCON = arg1;
        SetExProp(buff, "CARD_CON", cardCON);
        self.CON_ITEM_BM = self.CON_ITEM_BM - cardCON;
    end
    InvalidateStates(self)
end


function SCR_BUFF_ENTER_CARD_MNA(self, buff, arg1, arg2, over)
    if TryGetProp(self, "MNA_ITEM_BM") ~= nil then
        local cardMNA = arg1;
        SetExProp(buff, "CARD_MNA", cardMNA);
        self.MNA_ITEM_BM = self.MNA_ITEM_BM + cardMNA;
    end
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_CARD_MNA(self, buff, arg1, arg2, over)
    if TryGetProp(self, "MNA_ITEM_BM") ~= nil then
        local cardMNA = arg1;
        SetExProp(buff, "CARD_MNA", cardMNA);
        self.MNA_ITEM_BM = self.MNA_ITEM_BM - cardMNA;
    end
    InvalidateStates(self)
end

function SCR_BUFF_ENTER_CARD_Wound(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_bleed', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local dot = 1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        dot = dot + caster.STR + arg1 + arg2
    end
    
    SetExProp(self, 'BLEED_DOT', dot)

end

function SCR_BUFF_UPDATE_CARD_Wound(self, buff, arg1, arg2, RemainTime, ret, over)

    local dot = GetExProp(self, 'BLEED_DOT');
    
    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end
    
    local useHitTypeOverride = 1;
    TakeDamage(from, self, "None", dot, "Melee", "Aries", "TrueDamage", HIT_BLEEDING, HITRESULT_BLOW);
    
    return 1;
end

function SCR_BUFF_LEAVE_CARD_Wound(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_bleed')
    DelExProp(self, 'BLEED_DOT')
end

function SCR_BUFF_ENTER_CARD_ExpUP(self, buff, arg1, arg2, over)
    local buffCls = GetClass('Buff', 'CARD_ExpUP');
    local ExpUP = TryGetProp(buffCls, 'BuffExpUP');
    print(arg2)
    local addExpUP = math.floor(arg2/100)
    ExpUP = addExpUP 
end

function SCR_BUFF_UPDATE_CARD_ExpUP(self, buff, arg1, arg2, RemainTime, ret, over)
    local buffCls = GetClass('Buff', key);
    local ExpUP = TryGetProp(buffCls, 'BuffExpUP');
end

function SCR_BUFF_LEAVE_CARD_ExpUP(self, buff, arg1, arg2, over)
    local buffCls = GetClass('Buff', key);
    local ExpUP = TryGetProp(buffCls, 'BuffExpUP');
end

function SCR_BUFF_ENTER_CARD_MON_DMG_Rate_Down_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_CARD_MON_DMG_Rate_Down_Buff(self, buff, arg1, arg2, over)

end
