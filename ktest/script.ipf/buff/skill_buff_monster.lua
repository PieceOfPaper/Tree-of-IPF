-- skill_buff_monster.lua

-- UC_stun
function SCR_BUFF_ENTER_UC_stun(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_stun', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_UC_stun(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_stun')
end

-- mon_pollution_zone
function SCR_BUFF_ENTER_mon_pollution_zone(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_mon_pollution_zone(self, buff, arg1, arg2, RemainTime, ret, over)
    local damage = self.MHP * 0.05;
    damage = math.floor(damage)

    if damage < 1 then
        damage = 1
    end

    local caster = GetBuffCaster(buff);

    if caster ~= nil then
        TakeDamage(caster, self, "None", damage, "Poison", "Magic", "TrueDamage", "HIT_POISON", "HITRESULT_BLOW", 0, 0);
    end
end

function SCR_BUFF_LEAVE_mon_pollution_zone(self, buff, arg1, arg2, over)

end

-- mon_PopFlower
function SCR_BUFF_ENTER_mon_PopFlower(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_mon_PopFlower(self, buff, arg1, arg2, over)

    if IsBuffApplied(self, 'mon_PopFlower') == 'NO' and self.HP > 0 then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local damage = (caster.MINMATK + caster.MAXMATK)/2
            
--            local key = GenerateSyncKey(self)
--            StartSyncPacket(self, key);
            
            PlayEffect(self, 'F_explosion113_leaf', 1);
            TakeDamage(caster, self, "None", damage, "Melee", "Strike", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
            local angle = GetAngleFromPos(caster, x, z);
            if GetPropType(self, 'KDArmor') ~= nil and self.KDArmor < 900 then
                KnockDown(self, caster, 150, angle, 60, 3)
            end
            
--            EndSyncPacket(self, key, 0);
--            ExecSyncPacket(self, key);
        end
    end
end


-- UC_bound
function SCR_BUFF_ENTER_UC_bound(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_bound', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_UC_bound(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_bound')
end


-- UC_sleep
function SCR_BUFF_ENTER_UC_sleep(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_sleep', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local lv = arg1;
    
    if lv < 1 then
        lv = 1;
    elseif lv >= 15 then
        lv = 15;
    end
    
    SetExProp(buff, "UC_sleep_COUNT", 1 + lv);
end

function SCR_BUFF_LEAVE_UC_sleep(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_sleep')
    DelExProp(buff, "UC_sleep_COUNT");
end



--monster_GungHo
function SCR_BUFF_ENTER_Monster_GungHo(self, buff, arg1, arg2, over)
    local defadd = (2.5 + (1 * arg1))
    local defrate = (0.005 * arg1)
    local atkadd = (8.2 + (2 * arg1))
    local atkrate = (0.01 * arg1)

    if defadd > self.DEF then
        defadd = self.DEF;
    end

    defadd = math.floor(defadd)
    atkadd = math.floor(atkadd)
    
    self.DEF_BM = self.DEF_BM - defadd;
    self.PATK_BM = self.PATK_BM + atkadd;
    self.PATK_RATE_BM = self.PATK_RATE_BM + atkrate
    self.DEF_RATE_BM = self.DEF_RATE_BM - defrate
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_ATK", atkadd);
    SetExProp(buff, "ADD_ATK2", atkrate);
    SetExProp(buff, "ADD_DEF2", defrate);
end

function SCR_BUFF_UPDATE_Monster_GungHo(self, buff, arg1, arg2, RemainTime, ret, over)

end

function SCR_BUFF_LEAVE_Monster_GungHo(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    local atkadd = GetExProp(buff, "ADD_ATK");
    local atkrate = GetExProp(buff, "ADD_ATK2");
    local defrate = GetExProp(buff, "ADD_DEF2");
    
    self.DEF_BM = self.DEF_BM + defadd;
    self.PATK_BM = self.PATK_BM - atkadd;
    self.PATK_RATE_BM = self.PATK_RATE_BM - atkrate
    self.DEF_RATE_BM = self.DEF_RATE_BM + defrate

end



-- UC_freeze
function SCR_BUFF_ENTER_UC_freeze(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_freeze', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.INT, 0, 0);
    end
end

function SCR_BUFF_UPDATE_UC_freeze(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterINT = GetBuffArgs(buff);

    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end

    local dot = casterINT * 0.2;
    TakeDamage(from, self, "None", dot, "Ice", "Strike", "Magic", HIT_ICE, HITRESULT_BLOW);
    
    return 1;
end

function SCR_BUFF_LEAVE_UC_freeze(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_freeze')
    
end


-- UC_immobilize
function SCR_BUFF_ENTER_UC_immobilize(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_immobilize', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    local defencedBM = 1;

    SetExProp(buff, 'DEFENCED_BM', defencedBM);

    self.MaxDefenced_BM = self.MaxDefenced_BM + defencedBM;

end

function SCR_BUFF_LEAVE_UC_immobilize(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_immobilize')

    local defencedBM = GetExProp(buff, 'DEFENCED_BM');

    self.MaxDefenced_BM = self.MaxDefenced_BM - defencedBM;

end

-- UC_petrify
function SCR_BUFF_ENTER_UC_petrify(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_petrify', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);    
end

function SCR_BUFF_LEAVE_UC_petrify(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_petrify')
end


-- UC_silence
function SCR_BUFF_ENTER_UC_silence(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_silence', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_UC_silence(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_silence')
end

-- UC_silence_normalAttack
function SCR_BUFF_ENTER_UC_silence_normalAttack(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_UC_silence_normalAttack(self, buff, arg1, arg2, over)

end

--UC_confuse
function SCR_BUFF_ENTER_UC_confuse(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_confuse', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    if GetObjType(self) ~= OT_MONSTERNPC then
        return;
    end

    local curFaction = GetCurrentFaction(self);
    SetExProp_Str(self, '_PREV_FACTION', curFaction);
    SetCurrentFaction(self, 'CrazyMonster');

    SetTendency(self, "Attack")

    
    local list, cnt = SelectObject(self, 100, "ENEMY");
    for i = 1, cnt do
        local obj = list[i];
        if IS_PC(obj) == false then
            if obj.MonRank ~= 'Boss' and obj.Faction ~= "Neutral" then
                ResetHateAndAttack(obj);
			    InsertHate(obj, self, 10000);
            end
        end
    end
end

function SCR_BUFF_LEAVE_UC_confuse(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_confuse')
    local prevFaction = GetExProp_Str(self, '_PREV_FACTION');
    SetCurrentFaction(self, prevFaction);

    if IS_PC(self) == false then
        local list, cnt = SelectObject(self, 100, "FRIEND");
        for i = 1, cnt do
            local obj = list[i];
            if IS_PC(obj) == false then
                RemoveHate(obj, self)
            end
        end
        ResetHateAndAttack(self);
        InsertHate(self, GetBuffCaster(buff), 1);
    end
end


--UC_bleed
function SCR_BUFF_ENTER_UC_bleed(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_bleed', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local dot = 1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        dot = dot + caster.STR + arg1 + arg2
    end
    
    SetExProp(self, 'BLEED_DOT', dot)

end

function SCR_BUFF_UPDATE_UC_bleed(self, buff, arg1, arg2, RemainTime, ret, over)

    local dot = GetExProp(self, 'BLEED_DOT');
    
    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end
    
    local useHitTypeOverride = 1;
    TakeDamage(from, self, "None", dot, "Melee", "Aries", "TrueDamage", HIT_BLEEDING, HITRESULT_BLOW);
    
    return 1;
end

function SCR_BUFF_LEAVE_UC_bleed(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_bleed')
    DelExProp(self, 'BLEED_DOT')
end

--UC_hemorrhage
function SCR_BUFF_ENTER_UC_hemorrhage(self, buff, arg1, arg2, over)
    
    --ShowEmoticon(self, 'I_emo_bleed', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local dot = 10;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        dot = dot + caster.STR + arg1 + arg2
    end
    
    SetExProp(self, 'BLEED_DOT', dot)

end

function SCR_BUFF_UPDATE_UC_hemorrhage(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local dot = GetExProp(self, 'BLEED_DOT');
    
    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end
    
    TakeDamage(from, self, "None", dot, "Melee", "Aries", "TrueDamage", HIT_BLEEDING, HITRESULT_BLOW);
    
    return 1;
end

function SCR_BUFF_LEAVE_UC_hemorrhage(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_bleed')
    DelExProp(self, 'BLEED_DOT')
end

-- UC_poison
function SCR_BUFF_ENTER_UC_poison(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MAXPATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_UC_poison(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMAXPATK, casterMAXMATK = GetBuffArgs(buff);

    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end

    local damage = (casterMAXPATK + casterMAXMATK) / 4;
    TakeDamage(from, self, "None", damage , "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
    return 1;
    
end

function SCR_BUFF_LEAVE_UC_poison(self, buff, arg1, arg2, over)

end

--function SCR_BUFF_ENTER_UC_poison(self, buff, arg1, arg2, over)
--
--    --ShowEmoticon(self, 'I_emo_poison', 0)
--    SkillTextEffect(ret, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
--
--    local totalDamage = math.floor((self.MHP * 0.3) + arg1 + arg2);
--    local dot = totalDamage / 10
--    local curDamage = 0
--    
--    SetExProp(self, 'POISON_TOTAL', totalDamage)
--    SetExProp(self, 'POISON_DOT', dot)
--    SetExProp(self, 'POISON_CURRENT', curDamage)
--    
--end
--
--function SCR_BUFF_UPDATE_UC_poison(self, buff, arg1, arg2, RemainTime, ret, over)
--
--    local totalDamage = GetExProp(self, 'POISON_TOTAL');
--    local dot = GetExProp(self, 'POISON_DOT');
--    local curDamage = GetExProp(self, 'POISON_CURRENT')
--    
--    local from = GetBuffCaster(buff);
--    if from == nil then
--        from = self;
--    end
--
--    TakeDamage(from, self, "None", dot, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
--    
--    curDamage = curDamage + dot
--    SetExProp(self, 'POISON_CURRENT', curDamage)
--    
--    if curDamage > totalDamage then
--        return 0;
--    end
--    
--    return 1;
--end
--
--function SCR_BUFF_LEAVE_UC_poison(self, buff, arg1, arg2, over)
--    --HideEmoticon(self, 'I_emo_poison')
--    
--    DelExProp(self, 'POISON_TOTAL')
--    DelExProp(self, 'POISON_DOT')
--    DelExProp(self, 'POISON_CURRENT')
--end

-- UC_poison_Weak
function SCR_BUFF_ENTER_UC_poison_Weak(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_poison', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local totalDamage = math.floor((self.MHP * 0.01) * arg1 + arg2);
    local dot = totalDamage / 10
    local curDamage = 0
    
    SetExProp(self, 'POISON_TOTAL', totalDamage)
    SetExProp(self, 'POISON_DOT', dot)
    SetExProp(self, 'POISON_CURRENT', curDamage)
    
end

function SCR_BUFF_UPDATE_UC_poison_Weak(self, buff, arg1, arg2, RemainTime, ret, over)

    local totalDamage = GetExProp(self, 'POISON_TOTAL');
    local dot = GetExProp(self, 'POISON_DOT');
    local curDamage = GetExProp(self, 'POISON_CURRENT')
    
    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end

    TakeDamage(from, self, "None", dot, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
    
    curDamage = curDamage + dot
    SetExProp(self, 'POISON_CURRENT', curDamage)
    
    if curDamage > totalDamage then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_UC_poison_Weak(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_poison')
    
    DelExProp(self, 'POISON_TOTAL')
    DelExProp(self, 'POISON_DOT')
    DelExProp(self, 'POISON_CURRENT')
end


--UC_flame
function SCR_BUFF_ENTER_UC_flame(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_flame', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.INT, 0, 0);
    end
end

function SCR_BUFF_UPDATE_UC_flame(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end

    local dot = GetBuffArgs(buff);
    if dot > 0 then
        TakeDamage(from, self, "None", dot + arg2, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_UC_flame(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_flame')
end


--UC_curse
function SCR_BUFF_ENTER_UC_curse(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_curse', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_UC_curse(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_curse')
end


--UC_debrave
function SCR_BUFF_ENTER_UC_debrave(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_debrave', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local buffover = over;
    if buffover <= 0 then
        buffover = 1
    end
    
    local patkadd = buffover * 0.03
    local matkadd = buffover * 0.03
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
end

function SCR_BUFF_LEAVE_UC_debrave(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_debrave')
    
    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
end

--UC_deprotect
function SCR_BUFF_ENTER_UC_deprotect(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_deprotect', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    local buffover = over;
    if buffover <= 0 then
        buffover = 1
    end
    
    local defadd = math.floor(self.DEF * 0.05 * buffover)
    
    self.DEF_BM = self.DEF_BM - defadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
end

function SCR_BUFF_UPDATE_UC_deprotect(self, buff, arg1, arg2, RemainTime, ret, over)
    if over >= 10 then
        return 0;
    end
    return 1;
end

function SCR_BUFF_LEAVE_UC_deprotect(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_deprotect')
    local defadd = GetExProp(buff, "ADD_DEF");
    
    self.DEF_BM = self.DEF_BM + defadd;
    
    Invalidate(self, "DEF");
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    if over >= 10 then
        AddBuff(caster, self, 'UC_armorbreak', 1, 0, 10000, 1);
    end
end

--UC_deprotect_Mon
function SCR_BUFF_ENTER_UC_deprotect_Mon(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_deprotect', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local defadd = 0.5
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_LEAVE_UC_deprotect_Mon(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_deprotect')

    local defadd = GetExProp(buff, "ADD_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;

end

--UC_armorbreak
function SCR_BUFF_ENTER_UC_armorbreak(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    --ShowEmoticon(self, 'I_emo_armorbreak', 0)
    
    local defadd = 0.5;
    local mdefadd = 0.5;
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_UC_armorbreak(self, buff, arg1, arg2, over)
  --  HideEmoticon(self, 'I_emo_armorbreak')
    
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
end


--UC_infection
function SCR_BUFF_ENTER_UC_infection(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_infection', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_UC_infection(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_infection')

end


--UC_slowdown
function SCR_BUFF_ENTER_UC_slowdown(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_slowdown', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    local mspdadd = self.MSPD * 0.7

    self.MSPD_BM = self.MSPD_BM - mspdadd;

    SetExProp(buff, "ADD_MSPD", mspdadd);
    
end


function SCR_BUFF_LEAVE_UC_slowdown(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_slowdown')

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

end


--UC_fear
function SCR_BUFF_ENTER_UC_fear(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_fear', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    if IS_PC(self) == false then
        AddBuff(caster, self, 'Stun', 1, 0, 1000, 1); 
    end
    
    local patkadd = 0.3
    local matkadd = 0.3
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
end

function SCR_BUFF_LEAVE_UC_fear(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_fear')

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
end



--UC_shrinkbody
function SCR_BUFF_ENTER_UC_shrinkbody(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_size_shrink', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end


function SCR_BUFF_LEAVE_UC_shrinkbody(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_size_shrink')
end


--UC_swellbody
function SCR_BUFF_ENTER_UC_swellbody(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_size_swell', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end


function SCR_BUFF_LEAVE_UC_swellbody(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_size_swell')
end


--UC_skew
function SCR_BUFF_ENTER_UC_skew(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_stitch', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_UC_skew(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_stitch')

end


--UC_shock
function SCR_BUFF_ENTER_UC_shock(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_lmpact', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    local intadd = math.floor(self.INT * 0.5)
    local mnaadd = math.floor(self.MNA * 0.5)

    self.INT_BM = self.INT_BM - intadd;
    self.MNA_BM = self.MNA_BM - mnaadd;

    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);
    
end


function SCR_BUFF_LEAVE_UC_shock(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_lmpact')

    local intadd = GetExProp(buff, "ADD_INT");
    local mnaadd = GetExProp(buff, "ADD_MNA");
    
    self.INT_BM = self.INT_BM + intadd;
    self.MNA_BM = self.MNA_BM + mnaadd;

end


--UC_blind
function SCR_BUFF_ENTER_UC_blind(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_blind', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    if self.ClassName ~= 'PC' then
        CancelMonsterSkill(self);
        StopMove(self);
        SetTendencysearchRange(self, 30);   
    end
end


function SCR_BUFF_LEAVE_UC_blind(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_blind')

    if self.ClassName ~= 'PC' then
        SetTendencysearchRange(self, 0)
    end
end

--UC_rotten
function SCR_BUFF_ENTER_UC_rotten(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    SetExProp(buff, "MAX_HP", self.MHP)
    SetExProp(buff, "REMOVE_MHP", 0)
end

function SCR_BUFF_UPDATE_UC_rotten(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.ClassName == 'PC' then
        return 0;
    end
	local addMHP = GetExProp(buff, "MAX_HP") * 0.01
    if addMHP < 1 then
        addMHP = 1
    end
    
    if self.MHP > 10 then
        self.MHP_BM = self.MHP_BM - addMHP;
        local before = GetExProp(buff, "REMOVE_MHP");
        SetExProp(buff, "REMOVE_MHP", before + addMHP);
        
		Invalidate(self, "MHP");
		if self.MHP < self.HP then
			AddHP(self, self.HP - self.MHP);
		end
    end
    
    return 1

end

function SCR_BUFF_LEAVE_UC_rotten(self, buff, arg1, arg2, over)
    local before = GetExProp(buff, "REMOVE_MHP");
    self.MHP_BM = self.MHP_BM + before;
    Invalidate(self, "MHP");
	local tmp = self.MHP;	-- ??거지?°면??됨.
end

function SCR_BUFF_ENTER_Burrow(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 100;

end

function SCR_BUFF_UPDATE_Burrow(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local healHP = self.MHP * 0.25
    
    Heal(self, math.floor(healHP) , 0);
    return 1;

end

function SCR_BUFF_LEAVE_Burrow(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM - 100;

end

function SCR_BUFF_ENTER_Confuse(self, buff, arg1, arg2, over)
  SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
   -- ShowEmoticon(self, 'I_emo_confuse', 0)
    
    if GetObjType(self) ~= OT_MONSTERNPC then
        return;
    end

    local curFaction = GetCurrentFaction(self);
    SetExProp_Str(self, '_PREV_FACTION', curFaction);

    SetCurrentFaction(self, 'CrazyMonster');
    SetTendency(self, "Attack")

    
    local list, cnt = SelectObject(self, 100, "ENEMY");
    for i = 1, cnt do
        local obj = list[i];
        if IS_PC(obj) == false then
            if obj.MonRank ~= 'Boss' and obj.Faction ~= "Neutral" then
                ResetHateAndAttack(obj);
                InsertHate(self, obj, 10000);
            end
        end
    end
end

function SCR_BUFF_LEAVE_Confuse(self, buff, arg1, arg2, over)

   -- HideEmoticon(self, 'I_emo_confuse')

    local prevFaction = GetExProp_Str(self, '_PREV_FACTION');
    SetCurrentFaction(self, prevFaction);
    
    if IS_PC(self) == false then
        local list, cnt = SelectObject(self, 100, "FRIEND");
        for i = 1, cnt do
            local obj = list[i];
            if IS_PC(obj) == false then
                RemoveHate(obj, self)
            end
        end
        ResetHateAndAttack(self);
        InsertHate(self, GetBuffCaster(buff), 1);
    end
end


-- buff_range
function SCR_BUFF_ENTER_Rage(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM + 50;
    self.DEF_BM = self.DEF_BM + 50;
end

function SCR_BUFF_LEAVE_Rage(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM - 50;
    self.DEF_BM = self.DEF_BM - 50;
end


-- MoveSpeed
function SCR_BUFF_ENTER_MoveSpeed(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM + 50 * arg1;
    InvalidateStates(self);

end

function SCR_BUFF_LEAVE_MoveSpeed(self, buff, arg1, arg2, RemainTime)

    self.MSPD_BM = self.MSPD_BM - 50 * arg1;
    InvalidateStates(self);

end

-- Rage

function SCR_BUFF_ENTER_Mon_Rage(self, buff, arg1, arg2, over)

    buff.Value = self.MAXPATK;
    self.PATK_BM = self.PATK_BM + buff.Value;   

end

function SCR_BUFF_LEAVE_Mon_Rage(self, buff, arg1, arg2, over)

    self.PATK_BM = self.PATK_BM - buff.Value;   

end


function SCR_BUFF_ENTER_MoveSpeedFix(self, buff, arg1, arg2, over)

    self.FIXMSPD_BM = arg1;
    InvalidateStates(self);

end

function SCR_BUFF_LEAVE_MoveSpeedFix(self, buff, arg1, arg2, RemainTime)

    self.FIXMSPD_BM = 0;
    InvalidateStates(self);

end

-- MoveSpeed_Always
function SCR_BUFF_ENTER_MoveSpeed_Always(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM + 10 * arg1;
    InvalidateStates(self);

end


function SCR_BUFF_LEAVE_MoveSpeed_Always(self, buff, arg1, arg2, RemainTime)

    self.MSPD_BM = self.MSPD_BM - 10 * arg1;
    InvalidateStates(self);

end

-- FastMove
function SCR_BUFF_ENTER_FastMoveMon_Always(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - 500 * arg1;
    InvalidateStates(self);

end


function SCR_BUFF_LEAVE_FastMoveMon_Always(self, buff, arg1, arg2, RemainTime)

    self.MSPD_BM = self.MSPD_BM - 50 * arg1;
    InvalidateStates(self);

end

-- Invincible
function SCR_BUFF_ENTER_Invincible(self, buff, arg1, arg2, over)

    --SetSafe(self, 1);
    SetNoDamage(self, 1);

end

function SCR_BUFF_LEAVE_Invincible(self, buff, arg1, arg2, RemainTime)

    --SetSafe(self, 0);
    SetNoDamage(self, 0);
end


-- After_Invincible
function SCR_BUFF_ENTER_After_Invincible(self, buff, arg1, arg2, over)

    local defadd = 0.5
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_LEAVE_After_Invincible(self, buff, arg1, arg2, RemainTime)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
end


-- 

-- MonReturn
function SCR_BUFF_ENTER_MonReturn(self, buff, arg1, arg2, over)
    if self.RaceType ~= 'Item' then
        SetNoDamage(self, 1);
        HoldMonScp(self)
        self.MSPD_BM = self.MSPD_BM + 50
        CancelMonsterSkill(self)
        ResetHate(self)
        SetTendency(self, "None")
        local range = 50;
        local count = 1 + arg1;     --arg1 == skill.Level
    
        MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);

        InvalidateMSPD(self);
    end
end
function SCR_BUFF_UPDATE_MonReturn(self, buff, arg1, arg2, RemainTime, ret, over)
    local posX, posY, posZ = GetPos(self)
    if SCR_POINT_DISTANCE(self.CreateX, self.CreateZ, posX, posZ) < 50 then
        return 0;
    end
    
    return 1;
end
function SCR_BUFF_LEAVE_MonReturn(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0);
    UnHoldMonScp(self)
    self.MSPD_BM = self.MSPD_BM - 50;
    InvalidateMSPD(self);
end


--Rage_Abomi

function SCR_BUFF_ENTER_Rage_Abomi(self, buff, arg1, arg2, over)

  local defadd = 0.6
  
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Rage_Abomi(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;

end

-- Rage_helga
function SCR_BUFF_ENTER_Rage_helga(self, buff, arg1, arg2, over)

  local defadd = 0.5
  
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Rage_helga(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;

end

-- Rage_Ryta
function SCR_BUFF_ENTER_Rage_Ryta(self, buff, arg1, arg2, over)

  local defadd = 0.5
  
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Rage_Ryta(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;

end


-- Death_eye
function SCR_BUFF_ENTER_Death_eye(self, buff, arg1, arg2, over)

    ObjectColorBlend(self, 100, 100, 100, 255, 1)

end

function SCR_BUFF_LEAVE_Death_eye(self, buff, arg1, arg2, over)

    ObjectColorBlend(self, 255, 255, 255, 255, 1)

    TakeTrueDamage(self, self, 'None', self.HP-1, HIT_BASIC, HITRESULT_BLOW)
    --PlayAnim(self, "KNOCKDOWN", 1, 1, 0, 1); -- ??????? kd????????????

end


-- Mole_Buff
function SCR_BUFF_ENTER_Mole_Buff(self, buff, arg1, arg2, over)

    local atkadd = 0.5
    local defsub = 0.3
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + atkadd
    self.DEF_RATE_BM = self.DEF_RATE_BM - defsub

    SetExProp(buff, "ADD_ATK", atkadd);
    SetExProp(buff, "ADD_DEF", defsub);
    
--    local rand = IMCRandom(1, 5);
--    SetExProp(buff, "RAND", rand);
--    --print("rand : " + rand);
--
--    local rand_val = IMCRandom(0.01, 0.05);
--    SetExProp(buff, "RAND_VAL", rand_val);
--  
--    if rand == 1 then
--        --print("self.DEF : " + self.DEF + "  ");
--      self.DEF = self.DEF + (self.DEF * rand_val)
--      --print("self.DEF : " + self.DEF);
--    else if rand == 2 then
--        --print("self.DEF : " + self.DEF + "  ");
--        self.ATK = self.DEF - (self.DEF * rand_val)
--        --print("self.DEF : " + self.DEF);
--    else if rand == 3 then
--        --print("NULL");
--    else if rand == 4 then
--        --print("NULL");
--    else if rand == 5 then
--        --print("NULL");
--    end

end

function SCR_BUFF_LEAVE_Mole_Buff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_ATK");
    local defsub = GetExProp(buff, "ADD_DEF");

    self.PATK_RATE_BM = self.PATK_RATE_BM - atkadd;
    self.DEF_RATE_BM = self.DEF_RATE_BM - defsub;

end


-- Kubas_Buff
function SCR_BUFF_ENTER_Kubas_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local val = IMCRandom(1, 3);
    
    if val == 1 then
        AddBuff(self, self, 'Kubas_Buff_Flame', 0, 0, 12000, 1);
    elseif val == 2 then
        AddBuff(self, self, 'Kubas_Buff_Water', 0, 0, 12000, 1);
    elseif val ==3 then
        AddBuff(self, self, 'Kubas_Buff_Tempest', 0, 0, 12000, 1);
    end
end

function SCR_BUFF_LEAVE_Kubas_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

end


-- Kubas_Buff_Flame
function SCR_BUFF_ENTER_Kubas_Buff_Flame(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = 10
    
    self.Fire_Def_BM = self.Fire_Def_BM + regadd

    SetExProp(buff, "ADD_REG", regadd);

end

function SCR_BUFF_LEAVE_Kubas_Buff_Flame(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = GetExProp(buff, "ADD_REG");

    self.Fire_Def_BM = self.Fire_Def_BM - regadd
    
end


-- Kubas_Buff_Water
function SCR_BUFF_ENTER_Kubas_Buff_Water(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = 10
    
    self.Ice_Def_BM = self.Ice_Def_BM + regadd

    SetExProp(buff, "ADD_REG", regadd);

end

function SCR_BUFF_LEAVE_Kubas_Buff_Water(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = GetExProp(buff, "ADD_REG");

    self.Ice_Def_BM = self.Ice_Def_BM - regadd
    
end


-- Kubas_Buff_Tempest
function SCR_BUFF_ENTER_Kubas_Buff_Tempest(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = 10
    
    self.Lightning_Def_BM = self.Lightning_Def_BM + regadd

    SetExProp(buff, "ADD_REG", regadd);

end

function SCR_BUFF_LEAVE_Kubas_Buff_Tempest(self, buff, arg1, arg2, RemainTime, ret, over)

    local regadd = GetExProp(buff, "ADD_REG");

    self.Lightning_Def_BM = self.Lightning_Def_BM - regadd

end


-- Mon_Shield
function SCR_BUFF_ENTER_Mon_Shield(self, buff, arg1, arg2, over)
    local shieldValue = self.MHP / 10
    GIVE_BUFF_SHIELD(self, buff, shieldValue)
end

function SCR_BUFF_LEAVE_Mon_Shield(self, buff, arg1, arg2, over)
    TAKE_BUFF_SHIELD(self, buff)
end


-- Mon_Def_down
function SCR_BUFF_ENTER_Mon_Def_down(self, buff, arg1, arg2, over)

  local defadd = 0.5
  
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Mon_Def_down(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;

end



-- Mon_Golden_Bell_Shield_Buff

function SCR_BUFF_ENTER_Mon_Golden_Bell_Shield_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM  = 1;
    SetExProp(self, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;

end

function SCR_BUFF_LEAVE_Mon_Golden_Bell_Shield_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM = GetExProp(self, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end


-- Magic_Shield
function SCR_BUFF_ENTER_Magic_Shield(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Magic_Shield(self, buff, arg1, arg2, over)

end

--Mon_Magic_Shield


function SCR_BUFF_ENTER_Mon_Magic_Shield(self, buff, arg1, arg2, over)

  local mdefadd = 0.5
  
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd
    
    SetExProp(buff, "ADD_MDEF", mdefadd);

end

function SCR_BUFF_LEAVE_Mon_Magic_Shield(self, buff, arg1, arg2, over)

    local mdefadd = GetExProp(buff, "ADD_MDEF");

    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;

end


--Mon_Magic_Shield_Debuff


function SCR_BUFF_ENTER_Mon_Magic_Shield_Debuff(self, buff, arg1, arg2, over)
    
    local mdefadd = 100 + arg1 * 5
    self.MDEF_BM = self.MDEF_BM - mdefadd;
    SetExProp(buff, 'ADD_MDEF_BM', mdefadd);

end

function SCR_BUFF_LEAVE_Mon_Magic_Shield_Debuff(self, buff, arg1, arg2, over)

    local mdefadd = GetExProp(buff, 'ADD_MDEF_BM');
    self.MDEF_BM = self.MDEF_BM + mdefadd;

end



--Poison_Mon
function SCR_BUFF_ENTER_Poison_Mon(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MAXPATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Poison_Mon(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMAXPATK, casterMAXMATK = GetBuffArgs(buff);

    local from = GetBuffCaster(buff);
    if from == nil then
        from = self;
    end

    local damage = (casterMAXPATK + casterMAXMATK) / 2;
    TakeDamage(from, self, "None", damage / 5, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
    return 1;
    
end

function SCR_BUFF_LEAVE_Poison_Mon(self, buff, arg1, arg2, over)

end


-- Melee_charging
function SCR_BUFF_ENTER_Melee_charging(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Melee_charging(self, buff, arg1, arg2, over)

end

-- Magic_charging
function SCR_BUFF_ENTER_Magic_charging(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Magic_charging(self, buff, arg1, arg2, over)

end


-- HammerImpact
function SCR_BUFF_ENTER_HammerImpact(self, buff, arg1, arg2, over)
    
    if self.ClassName == 'Bomb' then
        local x, y, z = GetPos(self)
        PlayEffectToGround(self, "F_explosion012", x, y, z, 1.8);
        SELF_DESTRUCT(self, 30, 50, 250)
    end
    
end

function SCR_BUFF_LEAVE_HammerImpact(self, buff, arg1, arg2, over)

end


-- Sticky_Bubble

function SCR_BUFF_ENTER_Sticky_Bubble(self, buff, arg1, arg2, over)

    if GetPropType(self, "Runnable") ~= nil then
        if self.Runnable == 1 then
            self.Runnable = self.Runnable - 1;
        end
    end

    local mspdadd = self.MSPD * (0.15 * over)
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_LEAVE_Sticky_Bubble(self, buff, arg1, arg2, over)
    
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    if GetPropType(self, "Runnable") ~= nil then
        if self.Runnable == 0 then
            self.Runnable = self.Runnable + 1;
        end
    end
    
end


-- Scald

function SCR_BUFF_ENTER_Scald(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.Lv, 0, 0);
    end
end

function SCR_BUFF_UPDATE_Scald(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    local casterLv = GetBuffArgs(buff);
    local dmg = casterLv * 2 / 5;
    TakeDamage(caster, self, "None", dmg, "Fire", "None", "Melee", HIT_FIRE, HITRESULT_BLOW);
    return 1;

end

function SCR_BUFF_LEAVE_Scald(self, buff, arg1, arg2, over)

end


-- Bind_Debuff

function SCR_BUFF_ENTER_Bind_Debuff(self, buff, arg1, arg2, over)

    ObjectColorBlend(self, 100, 100, 100, 255, 1)

end

function SCR_BUFF_LEAVE_Bind_Debuff(self, buff, arg1, arg2, over)

    ObjectColorBlend(self, 255, 255, 255, 255, 1)
    
end

-- Monster_Haste

function SCR_BUFF_ENTER_Monster_Haste_Buff(self, buff, arg1, arg2, over)

    local lv = arg1;
    local mspdadd = self.MSPD * 2;
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return;
    end
    
    local Name = GetName(caster);
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_HASTE", buff.ClassID, nil, Name);
    end 
end

function SCR_BUFF_LEAVE_Monster_Haste_Buff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM - mspdadd;

end





----- Monster_Slow
function SCR_BUFF_ENTER_Monster_Slow(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_slowdown', 0)

    local lv = arg1;

    local mspdadd = self.MSPD * (0.85 + lv * 0.02);
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_Monster_Slow(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_slowdown')

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;


end



function SCR_BUFF_ENTER_BLK_UP(self, buff, arg1, arg2, over)

  local defadd = self.BLK * 0.6 * arg1
    
    self.BLK_BM = self.BLK_BM + defadd
    
    SetExProp(buff, "ADD_BLK", defadd);

end

function SCR_BUFF_LEAVE_BLK_UP(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_BLK");

    self.BLK_BM = self.BLK_BM - defadd;

end


function SCR_BUFF_ENTER_Mon_Scud(self, buff, arg1, arg2, over)

    local lv = arg1;

    local mspdadd = self.MSPD * 0.8;
    
    --AddStamina(self, 3000);
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    

end

function SCR_BUFF_LEAVE_Mon_Scud(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;

end






-- Dot_Fire
function SCR_BUFF_ENTER_Dot_Fire(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_Dot_Fire(self, buff, arg1, arg2, RemainTime, ret, over)

    local dotDmg = math.floor(((caster.MINMATK + caster.MAXMATK) / 2 - self.DEF) * 0.5);

    if dotDmg < 1 then
        dotDmg = 1;
    end
    
    TakeDamage(buff, self, "None", dotDmg, "Fire", "None", "None", HIT_FIRE, HITRESULT_BLOW);
    
    return 1;

end

function SCR_BUFF_LEAVE_Dot_Fire(self, buff, arg1, arg2, over)

end



--Mon_FireWall
function SCR_BUFF_ENTER_Mon_FireWall(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_Mon_FireWall(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    
    if caster ~= nil then
        local skl = GetSkill(caster, "Mon_pc_summon_Fireload_Skill_3")
        
        if skl ~= nil then
            local atk = GET_SKL_DAMAGE(caster, self, "Mon_pc_summon_Fireload_Skill_3");
            TakeDamage(caster, self, skl.ClassName, atk, "Fire", "None", "Magic", HIT_FIRE, HITRESULT_BLOW); 
        end
        return 1;
    end
    return 0;
  
end

function SCR_BUFF_LEAVE_Mon_FireWall(self, buff, arg1, arg2, over)


end




-- Mon_cure_Debuff
function SCR_BUFF_ENTER_Mon_cure_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Mon_cure_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    local baseAtk = ((casterMINMATK + casterMAXMATK) / 2 - self.DEF) * (0.15 + (lv - 1) * 0.015);
    local addAtk = lv * 1.5;
    
    if baseAtk < 1 then
        baseAtk = 1;
    end
    
    if lv > 5 then
        addAtk = addAtk + (lv - 5) * 3.2;
    end
    
    local resultDmg = math.floor(baseAtk + addAtk);
    TakeDamage(caster, self, "None", resultDmg, "Holy", "None", "Magic", HIT_HOLY, HITRESULT_BLOW);
    
    return 1;
end

function SCR_BUFF_LEAVE_Mon_cure_Debuff(self, buff, arg1, arg2, over)


end


-- Mon_FirePilla


function SCR_BUFF_ENTER_Mon_FirePilla(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Mon_FirePilla(self, buff, arg1, arg2, RemainTime, ret, over)


    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    local baseAtk = ((casterMINMATK + casterMAXMATK) / 2 - self.DEF) * (0.74 + (lv - 1) * 0.074);
    local addAtk = lv * 5.94;
    
    if baseAtk < 1 then
        baseAtk = 1;
    end
    
    if self.ClassName == 'PC' then
        addAtk = 0;
    end
    TakeDamage(caster, self, "None", math.floor(baseAtk + addAtk), "Fire", "None", "Magic", HIT_FIRE, HITRESULT_BLOW);  

    return 1;
end

function SCR_BUFF_LEAVE_Mon_FirePilla(self, buff, arg1, arg2, over, isLastEnd)

    
end




-- Mon_Fire_buff


function SCR_BUFF_ENTER_Mon_Fire_buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Mon_Fire_buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    local damage = GetFinalAtk(casterMINMATK, casterMAXMATK);
    TakeDamage(caster, self, "None", damage*arg1/100, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);

    return 1;

end


function SCR_BUFF_LEAVE_Mon_Fire_buff(self, buff, arg1, arg2, over)

end



-- Mon_Heal_Buff
function SCR_BUFF_ENTER_Mon_Heal_Buff(self, buff, arg1, arg2, over)

    local lv = arg1;
    local bonusValue = arg2;
    Heal(self, (self.MHP * 0.01 * lv) + bonusValue, 0);
    
end

function SCR_BUFF_LEAVE_Mon_Heal_Buff(self, buff, arg1, arg2, over)


end


-- Mon_Heal_Debuff
function SCR_BUFF_ENTER_Mon_Heal_Debuff(self, buff, arg1, arg2, over)

    local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local baseAtk = ((caster.MINMATK + caster.MAXMATK) / 2 - self.DEF) * (1.1 + (lv - 1) * 0.11);
        local addAtk = lv * 3.5;
    
        if caster.ClassName ~= 'PC' then
            baseAtk = ((caster.MINMATK + caster.MAXMATK) / 2.5 - self.DEF)
        end
    
        if baseAtk < 1 then
            baseAtk = 1;
        end
    
        if lv > 5 then
            addAtk = addAtk + (lv - 5) * 7;
        end
    
        local resultDmg = math.floor(baseAtk + addAtk);
    
        if IsBuffApplied(self, 'Cleric_Bless_Debuff') == 'YES' then
            resultDmg = resultDmg * 2;
        end
    
        TakeDamage(caster, self, "None", resultDmg, "Melee", "None", "Magic", HIT_BASIC, HITRESULT_BLOW);   
    end
    
    return 1;

end

function GET_HEAL_CLERIC_VALUE_BUFF(lv)

    return lv * 0.005;
    
end

function GET_HEAL_CLERIC_VALUE_DEBUFF(lv)

    return lv * 0.05;
    
end

function SCR_BUFF_LEAVE_Mon_Heal_Debuff(self, buff, arg1, arg2, over)


end



-- Mon_Atk_up

function SCR_BUFF_ENTER_Mon_Atk_up(self, buff, arg1, arg2, over)

    local atkadd = 0.5
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + atkadd
    
    SetExProp(buff, "ADD_ATK", atkadd);

end

function SCR_BUFF_LEAVE_Mon_Atk_up(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_ATK");

    self.PATK_RATE_BM = self.PATK_RATE_BM - atkadd;

end





-- Mon_Atk_down


function SCR_BUFF_ENTER_Mon_Atk_down(self, buff, arg1, arg2, over)
    if IS_PC(self) == false then
        return;
    end

    local patkadd = 0.2
    local matkadd = 0.2
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);

end

function SCR_BUFF_LEAVE_Mon_Atk_down(self, buff, arg1, arg2, over)

    if IS_PC(self) == false then
        return;
    end

    local patkadd = GetExProp(buff, "ADD_PATK")
    local matkadd = GetExProp(buff, "ADD_MATK");

    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd

end

function SCR_BUFF_ENTER_Mon_Aggressor_Buff(self, buff, arg1, arg2, over)
    local dradd = (self.DR * 1) - (self.DR * (arg1 * 0.1))
    local hradd = self.DR * (0.2 * arg1)
    
    self.DR_BM = self.DR_BM - dradd
    self.HR_BM = self.HR_BM + hradd
    
    SetExProp(buff, "ADD_DR", dradd);
    SetExProp(buff, "ADD_HR", hradd);

end


function SCR_BUFF_LEAVE_Mon_Aggressor_Buff(self, buff, arg1, arg2, over)

    local dradd = GetExProp(buff, "ADD_DR");
    local hradd = GetExProp(buff, "ADD_HR");

    self.DR_BM = self.DR_BM + dradd;
    self.HR_BM = self.HR_BM - hradd;


end



--Mon_Transpose_Buff
function SCR_BUFF_ENTER_Mon_Transpose_Buff(self, buff, arg1, arg2, over)

    local con = self.CON;
    local str = self.STR;

    SetExProp(buff, 'BEFORE_CON', con);
    SetExProp(buff, 'BEFORE_STR', str);

    self.CON_BM = self.CON_BM - con + str;
    self.STR_BM = self.STR_BM - str + con;

end

function SCR_BUFF_LEAVE_Mon_Transpose_Buff(self, buff, arg1, arg2, over)

    local con = GetExProp(buff, 'BEFORE_CON');
    local str = GetExProp(buff, 'BEFORE_STR');

    self.CON_BM = self.CON_BM - str + con;
    self.STR_BM = self.STR_BM - con + str;
end


-- Mon_Throw
function SCR_BUFF_ENTER_Mon_Throw(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 0, 0, 0, 0, 1)
end

function SCR_BUFF_LEAVE_Mon_Throw(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1)
end

function SCR_BUFF_ENTER_NewFireWall_Monster_Debuff(self, buff, arg1, arg2, over)

    local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GetFinalAtk(caster.MINMATK, caster.MAXMATK);
        TakeDamage(caster, self, "None", damage * arg1 / 100 , "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
    end
end

function SCR_BUFF_LEAVE_NewFireWall_Monster_Debuff(self, buff, arg1, arg2, over)


end

function SCR_BUFF_ENTER_Wound_mon(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MAXMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Wound_mon(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local damage = GetFinalAtk(casterMINMATK, casterMAXMATK);   
    TakeDamage(caster, self, "None", damage * arg1 / 100, "Wound", "None", "None", HIT_BASIC, HITRESULT_BLOW);

    return 1;

end


function SCR_BUFF_LEAVE_Wound_mon(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_HPLock(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_HPLock(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_CantLevelDown(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_MONSTERNPC then
        return
    end

    local beforeLv = self.Lv;       
    SetExProp(self, "LEVEL_FOR_DROP", beforeLv);
    
    local newLv = beforeLv - arg1;
    self.Lv = math.max(1, newLv);
    InvalidateStates(self);
    BroadcastLevel(self);
    
end

function SCR_BUFF_LEAVE_CantLevelDown(self, buff, arg1, arg2, over)

    local originalLv = GetExProp(self, "LEVEL_FOR_DROP");

    self.Lv = originalLv
    InvalidateStates(self);
    BroadcastLevel(self);

    ShowUnicodeValueDigit(self, "", 0); 
    ShowDigitValue(self, -255, arg2);

end





-- Mon_FirePilla


function SCR_BUFF_ENTER_Mon_PoisonPilla(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MAXMATK, caster.MAXMATK, 0);
    end

end

function SCR_BUFF_UPDATE_Mon_PoisonPilla(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    local lv = arg1;
    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local baseAtk = ((casterMINMATK + casterMAXMATK) / 2 - self.DEF) * (0.74 + (lv - 1) * 0.074);
    local addAtk = lv * 5.94;
    
    if baseAtk < 1 then
        baseAtk = 1;
    end
    
    if self.ClassName == 'PC' then
        addAtk = 0;
    end
    TakeDamage(caster, self, "None", math.floor(baseAtk + addAtk), "Poison", "Magic", "Magic", HIT_POISON, HITRESULT_BLOW); 

    return 1;
end

function SCR_BUFF_LEAVE_Mon_PoisonPilla(self, buff, arg1, arg2, over, isLastEnd)

    
end





    -- Mon_ReflectShied


function SCR_BUFF_ENTER_Mon_ReflectShield(self, buff, arg1, arg2, over)

    local buffLv = arg1;
    local damratio = 50;
    self.DamReflect = self.DamReflect + damratio;
    SetExProp(buff, "ADD_DAMREFLCET", damratio);
    AttachEffect(self, "I_sphere007_mash", 3, "BOT");
end

function SCR_BUFF_LEAVE_Mon_ReflectShield(self, buff, arg1, arg2, over)

    local damratio = GetExProp(buff, "ADD_DAMREFLCET");
    
    self.DamReflect = self.DamReflect - damratio;

    DetachEffect(self, 'I_sphere007_mash');
    AttachEffect(self, "F_wizard_reflect_shot_light", 2, "BOT");

end

-- Marionette_bound
function SCR_BUFF_ENTER_Marionette_bound(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 100, 100, 100, 255, 1);

    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINPATK, 0, 0);
    end
end

function SCR_BUFF_UPDATE_Marionette_bound(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINPATK = GetBuffArgs(buff)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    local dot = math.floor(casterMINPATK * 0.05)
    TakeDamage(caster, self, "None", dot, "Melee", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
        
    return 1;
end

function SCR_BUFF_LEAVE_Marionette_bound(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1)
end




-- Anim Change Hp
function SCR_BUFF_ENTER_AniChangeHP(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_AniChangeHP(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local hp = GetHpPercent(self) * 100
    
    local change = GetClass("ChangeAnim", self.ClassName)
    
    if hp < change.Percent_2 and GetExProp(self, "Ani0" ) == 0  then
        PlayAnim(self, change.Anim_2, 1)
        SetExProp(self, "Ani0", 1 )
        
    elseif hp < change.Percent_1 and GetExProp(self, "Ani1" ) == 0 then
        PlayAnim(self, change.Anim_1, 1)
        SetExProp(self, "Ani1", 1 )
        
    elseif hp < change.Percent_0 and GetExProp(self, "Ani2" ) == 0 then
        PlayAnim(self, change.Anim_0, 1)
        SetExProp(self, "Ani2", 1 )
        
    end


    return 1
end

function SCR_BUFF_LEAVE_AniChangeHP(self, buff, arg1, arg2, over)
    DelExProp(self, "Ani0")
    DelExProp(self, "Ani1")
    DelExProp(self, "Ani2")
end

-- Anim Change Time
function SCR_BUFF_ENTER_AniChangeTime(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_AniChangeTime(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local change = GetClass("ChangeAnim", self.ClassName)

    local time = GetAge(self)
    if time > change.Time_0 and GetExProp(self, "Ani0" ) == 0  then
        PlayAnim(self, change.Anim_0, 1)
        SetExProp(self, "Ani0", 1 )
    elseif time > change.Time_1 and GetExProp(self, "Ani1" ) == 0 then
        PlayAnim(self, change.Anim_1, 1)
        SetExProp(self, "Ani1", 1 )
    elseif time > change.Time_2 and GetExProp(self, "Ani2" ) == 0 then
        PlayAnim(self, change.Anim_2, 1)
        SetExProp(self, "Ani2", 1 )
    end

    return 1
end

function SCR_BUFF_LEAVE_AniChangeTime(self, buff, arg1, arg2, over)
    DelExProp(self, "Ani0")
    DelExProp(self, "Ani1")
    DelExProp(self, "Ani2")
end


function SCR_BUFF_ENTER_SuperExp(self, buff, arg1, arg2, over)
    SetExProp(self, "SuperDrop", 1);

end

function SCR_BUFF_LEAVE_SuperExp(self, buff, arg1, arg2, over)

end






-- UC_mspblood

function SCR_BUFF_ENTER_UC_mspblood(self, buff, arg1, arg2, over)

    local mspdadd = self.MSPD * 0.3
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
end

function SCR_BUFF_UPDATE_UC_mspblood(self, buff, arg1, arg2, RemainTime, ret, over)

    AddSP(self, -self.MSP * 0.2)

    return 1;

end

function SCR_BUFF_LEAVE_UC_mspblood(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

end

--Mon_SpDrain--
function SCR_BUFF_ENTER_Mon_SpDrain(self, buff, arg1, arg2, over)

    local mspdadd = self.MSPD * 0.05
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
end

function SCR_BUFF_UPDATE_Mon_SpDrain(self, buff, arg1, arg2, RemainTime, ret, over)

    AddSP(self, -self.MSP * 0.05)
    
    return 1;

end

function SCR_BUFF_LEAVE_Mon_SpDrain(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

end
--Mon_SpDrain--

-- Mon_joint_MagicShield
function SCR_BUFF_ENTER_Mon_joint_MagicShield(self, buff, arg1, arg2, over)

    local mdefadd = self.MDEF + arg1 * 5
  
    self.MDEF_BM = self.MDEF_BM + mdefadd
    
    SetExProp(buff, "ADD_MDEF", mdefadd);

end

function SCR_BUFF_ENTER_EliteMonsterBuff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        return;
    end

    local monRank = TryGetProp(self, "MonRank");
    if monRank == nil then
        return;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if debuffRank == nil then
        return;
    end

    local size = TryGetProp(self, "Size");
    if size == "S" then
        self.Size = "L";
        ChangeScale(self, 2.0, 1.0);        
    elseif size == "M" then
        self.Size = "L";
        ChangeScale(self, 1.5, 1.0);
    end

    if monRank == "Normal" then
        self.MonRank = "Elite";
    end

    if debuffRank == "None" then
        self.DebuffRank = "Normal";
    end

    local addmhp = math.floor(self.MHP - self.MHP_BM);
    local addpatk = math.floor(self.MAXPATK - self.PATK_BM);
    local addmatk = math.floor(self.MAXMATK - self.MATK_BM);
    local adddef = math.floor(self.DEF - self.DEF_BM);
    local addmdef = math.floor(self.MDEF - self.MDEF_BM);
    local addMSPD = math.floor((self.MSPD - self.MSPD_BM) * 0.75);
    
    self.MHP_BM = self.MHP_BM + addmhp;
    self.PATK_BM = self.PATK_BM + addpatk;
    self.MATK_BM = self.MATK_BM + addmatk;
    self.DEF_BM = self.DEF_BM + adddef;
    self.MDEF_BM = self.MDEF_BM + addmdef;
    self.MSPD_BM = self.MSPD_BM + addMSPD;

    InvalidateStates(self);
    AddHP(self, self.MHP);

    local eliteMonSkillCapacity = 2;

    local holdingSkillCount = IMCRandom(0, eliteMonSkillCapacity);
    if holdingSkillCount > 0 then
        local holdingSkillList = GetEliteMonSkillList("Holding", holdingSkillCount);
        SetExProp(self, "EliteMonHoldingSkillCount", #holdingSkillList);
        for i = 1, #holdingSkillList do
            SetExProp_Str(self, "EliteMonHoldingSkill_" .. i, holdingSkillList[i]);
        end
    end

    local debuffSkillCount = IMCRandom(0, eliteMonSkillCapacity);
    if debuffSkillCount > 0 then
        local debuffSkillList, cnt = GetEliteMonSkillList("Debuff", debuffSkillCount);
        SetExProp(self, "EliteMonDebuffSkillCount", #debuffSkillList);
        for i = 1, #debuffSkillList do
            SetExProp_Str(self, "EliteMonDebuffSkill_" .. i, debuffSkillList[i]);
        end
    end

    local buffSkillCount = IMCRandom(0, eliteMonSkillCapacity);
    if buffSkillCount > 0 then
        local buffSkillList = GetEliteMonSkillList("Buff", buffSkillCount);
        SetExProp(self, "EliteMonBuffSkillCount", #buffSkillList);
        for i = 1, #buffSkillList do
            SetExProp_Str(self, "EliteMonBuffSkill_" .. i, buffSkillList[i]);
        end
    end

    local summonSkillCount = IMCRandom(0, eliteMonSkillCapacity);
    if summonSkillCount > 0 then
        local summonSkillList = GetEliteMonSkillList("Summon", summonSkillCount);
        SetExProp(self, "EliteMonSummonSkillCount", #summonSkillList);
        for i = 1, #summonSkillList do
            SetExProp_Str(self, "EliteMonSummonSkill_" .. i, summonSkillList[i]);
        end
    end
    
    local bornSkillCount = IMCRandom(0, eliteMonSkillCapacity);
    if bornSkillCount > 0 then
        local bornSkillList = GetEliteMonSkillList("Born", bornSkillCount);
        SetExProp(self, "EliteMonBornSkillCount", #bornSkillList);
        for i = 1, #bornSkillList do
            SetExProp_Str(self, "EliteMonBornSkill_" .. i, bornSkillList[i]);
        end
    end
    
    local eliteMonBornSkillCount = GetExProp(self, "EliteMonBornSkillCount");
    if eliteMonBornSkillCount > 0 then
        local rnd = IMCRandom(0, eliteMonBornSkillCount);
        if rnd > 0 then
            local skillFunc = GetExProp_Str(self, "EliteMonBornSkill_" .. rnd);
            if skillFunc ~= "None" then
                local func = _G[GetExProp_Str(self, "EliteMonBornSkill_" .. rnd)];
                if func ~= nil then
                   func(self);
                end
            end
        end
    end
end

function SCR_BUFF_UPDATE_EliteMonsterBuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local topHater = GetNearTopHateEnemy(self);
    if topHater ~= nil then
        local dist = GetDist2D(self, topHater);
        if dist < 100 then
            local eliteMonHoldingSkillCount = GetExProp(self, "EliteMonHoldingSkillCount");
            if eliteMonHoldingSkillCount > 0 then
                local rnd = IMCRandom(0, 99);
                if rnd < 25 then
                    if GetExProp(self, "EliteMonSkillDelay") < imcTime.GetAppTime() then
                        local x, y, z = GetPos(self);
                        RunPad(self, "Mon_Elite_Holding", nil, x, y, z, 0, 1);

                        SetExProp(self, "EliteMonSkillDelay", imcTime.GetAppTime() + 15);
                    end
                end
            end
        end

        local eliteMonSummonSkillCount = GetExProp(self, "EliteMonSummonSkillCount");
        if eliteMonSummonSkillCount > 0 then
            if GetExProp(self, "EliteMonSkillDelay") < imcTime.GetAppTime() then
                local rnd = IMCRandom(1, eliteMonSummonSkillCount);
                local skillFunc = GetExProp_Str(self, "EliteMonSummonSkill_" .. rnd);
                if skillFunc ~= "None" then
                    local func = _G[GetExProp_Str(self, "EliteMonSummonSkill_" .. rnd)];
                    if func ~= nil then
                        func(self);
                    end
                end

                SetExProp(self, "EliteMonSkillDelay", imcTime.GetAppTime() + 5);
            end
        end
    end

    return 1;
end

function SCR_BUFF_ENTER_EliteMonsterSummonBuff(self, buff, arg1, arg2, over)
    local addmhp = math.floor(self.MHP - self.MHP_BM);
    local addpatk = math.floor(self.MAXPATK - self.PATK_BM);
    local addmatk = math.floor(self.MAXMATK - self.MATK_BM);
    local adddef = math.floor(self.DEF - self.DEF_BM);
    local addmdef = math.floor(self.MDEF - self.MDEF_BM);
    
    self.MHP_BM = self.MHP_BM - (addmhp / 2);
    self.PATK_BM = self.PATK_BM - (addpatk / 2);
    self.MATK_BM = self.MATK_BM - (addmatk / 2);
    self.DEF_BM = self.DEF_BM - (adddef / 2);
    self.MDEF_BM = self.MDEF_BM - (addmdef / 2);

    InvalidateStates(self);
    AddHP(self, self.MHP);
end

function SCR_BUFF_ENTER_Mon_ResistElements_Buff(self, buff, arg1, arg2, over)
    local resiceadd = 0;
    local resfireadd = 0;
    local reslightadd = 0;
    local resposadd = 0;
    local researthadd = 0;
    
    if IS_PC(self) == false then
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local pad = GetPadByBuff(caster, buff);
            if pad ~= nil then
                lv = GetPadArgNumber(pad, 1);
            end
        end
        
        local resadd = 24 + 6.3 * (lv - 1)
        
        resiceadd = math.floor(resadd + self.Ice_Def * 0.2)
        resfireadd = math.floor(resadd + self.Fire_Def * 0.2)
        reslightadd = math.floor(resadd + self.Lightning_Def * 0.2)
        resposadd = math.floor(resadd + self.Poison_Def * 0.2)
        researthadd = math.floor(resadd + self.Earth_Def * 0.2)
        
        self.Ice_Def_BM = self.Ice_Def_BM + resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM + resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM + reslightadd
        self.Poison_Def_BM = self.Poison_Def_BM + resposadd
        self.Earth_Def_BM = self.Earth_Def_BM + researthadd
    end
    
    SetExProp(buff, "ADD_ICE", resiceadd);
    SetExProp(buff, "ADD_FIRE", resfireadd);
    SetExProp(buff, "ADD_LIGHT", reslightadd);
    SetExProp(buff, "ADD_POS", resposadd);
    SetExProp(buff, "ADD_EARTH", researthadd);
end

function SCR_BUFF_LEAVE_ResistElements_Buff(self, buff, arg1, arg2, over)

    local resiceadd = GetExProp(buff, "ADD_ICE");
    local resfireadd = GetExProp(buff, "ADD_FIRE");
    local reslightadd = GetExProp(buff, "ADD_LIGHT");
    local resposadd = GetExProp(buff, "ADD_POS");
    local researthadd = GetExProp(buff, "ADD_EARTH");

    if IS_PC(self) == false then
        self.Ice_Def_BM = self.Ice_Def_BM - resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM - resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM - reslightadd
        self.Poison_Def_BM = self.Poison_Def_BM - resposadd
        self.Earth_Def_BM = self.Earth_Def_BM - researthadd
    end

end

function SCR_BUFF_UPDATE_EliteMonsterSummonBuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local owner = GetOwner(self);
    if owner == nil then
        Dead(self, 0.2);
    end

    local topHater = GetNearTopHateEnemy(self);
    if topHater == nil then
        topHater = GetNearTopHateEnemy(owner);
        if topHater ~= nil then
            local hateValue = GetHate(self, topHater);
            InsertHate(self, topHater, hateValue);
        end
    end

    return 1;
end

-- Kerberos_Buff
function SCR_BUFF_ENTER_Kerberos_Buff(self, buff, arg1, arg2, over)

    local atkadd = 0.01 * arg1
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + atkadd
    
    SetExProp(buff, "ADD_ATK", atkadd);

end

function SCR_BUFF_LEAVE_Mon_Kerberos_Buff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_ATK");

    self.PATK_RATE_BM = self.PATK_RATE_BM - atkadd;

end


--blk down debuff --
function SCR_BUFF_ENTER_Blk_Down(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Blk_Down(self, buff, arg1, arg2, over)

end


--Boss_Reflect_attack--
function SCR_BUFF_ENTER_Boss_Reflect_attack(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Boss_Reflect_attack(self, buff, arg1, arg2, over)

end


--ID_Whitetrees1_Debuff--
function SCR_BUFF_ENTER_ID_Whitetrees1_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_ID_Whitetrees1_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local damage = 200 

    local caster = GetBuffCaster(buff);

    if caster ~= nil then
        TakeDamage(caster, self, "None", damage, "Poison", "Magic", "TrueDamage", "HIT_POISON", "HITRESULT_BLOW", 0, 0);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_ID_Whitetrees1_Debuff(self, buff, arg1, arg2, over)

end

--Boss_kucarry_blazermancer_Debuff--
function SCR_BUFF_ENTER_Boss_kucarry_blazermancer_Debuff(self, buff, arg1, arg2, over)
    local damage = 100;
    local maxOverBonus = 0;
    
    if over >= 100 then
       over = 100;
       maxOverBonus = 7;
    end
    
    local damage = (7 * (over - 1)) + damage + maxOverBonus;
    SetExProp(buff, 'DAMAGE', damage);


end

function SCR_BUFF_UPDATE_Boss_kucarry_blazermancer_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local damage = GetExProp(buff, 'DAMAGE');
    local caster = GetBuffCaster(buff);
    if over == 100 then
        if IsBuffApplied(self, 'ID_WHITETREES1_GIMMICK3_BUFF') == 'YES' then
            RemoveBuff(self, 'ID_WHITETREES1_GIMMICK3_BUFF')
            return 0;
        end
    end
        
    if caster ~= nil then
        if IsBuffApplied(self, 'ID_WHITETREES1_GIMMICK3_BUFF') == 'NO' then
            TakeDamage(caster, self, "None", damage, "Poison", "Magic", "TrueDamage", HIT_BASIC_NOT_CANCEL_CAST, HITRESULT_BLOW, 0, 0);
        end
    else
        return 0;
    end
    return 1; 

end

function SCR_BUFF_LEAVE_Boss_kucarry_blazermancer_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_UC_Cloaking_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_UC_Cloaking_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_UC_Diffusion_Curse_DeBuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_UC_Diffusion_Curse_DeBuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local objList, objCount = SelectObjectNear(caster, self, 60, 'ENEMY');
        if objCount > 0  and IMCRandom(1, 10000) < 9000  then
            local rand = IMCRandom(1, objCount)
            AddBuff(caster, objList[rand], 'UC_Diffusion_Curse', arg1, arg2, RemainTime, over);
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_UC_Diffusion_Curse_DeBuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_GM_Invincible_Buff(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1);
end

function SCR_BUFF_UPDATE_GM_Invincible_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    return 1;

end

function SCR_BUFF_LEAVE_GM_Invincible_Buff(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0);
end

function SCR_BUFF_ENTER_UC_Focusing_Buff(self, buff, arg1, arg2, over)
    
    local lv = arg1
    local addHR = lv * 100
    local addCRT = lv * 100
    
    self.HR_BM = self.HR_BM + addHR
    self.CRTHR_BM = self.CRTHR_BM + addCRT
    
    SetExProp(buff, "ADD_CRIHR", addCRT);
    SetExProp(buff, "ADD_HR", addHR);
    
end

function SCR_BUFF_LEAVE_UC_Focusing_Buff(self, buff, arg1, arg2, over)
    
    local addCRT = GetExProp(buff, "ADD_CRIHR");
    local addHR = GetExProp(buff, "ADD_HR");

    self.HR_BM = self.HR_BM - addHR
    self.CRTHR_BM = self.CRTHR_BM - addCRT

end

function SCR_BUFF_ENTER_FIELD_BOSS_AWAKE_UP(self, buff, arg1, arg2, over)
    local addATKRate = 1.5
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + addATKRate
    
    SetExProp(buff,'addATKRate', addATKRate)
end

function SCR_BUFF_UPDATE_FIELD_BOSS_AWAKE_UP(self, buff, arg1, arg2, RemainTime, ret, over)
    local maxHP = self.MHP
    local nowHP = self.HP
    local healHP = maxHP * 0.15
    local prop = GetExProp(buff, 'useHeal')
    
    if prop ~= 1 then
        if nowHP < maxHP then
            Heal(self, math.floor(healHP) , 0);
            return 1;
        end
        SetExProp(buff, 'useHeal', 1)
    end
    return 1;
end

function SCR_BUFF_LEAVE_FIELD_BOSS_AWAKE_UP(self, buff, arg1, arg2, over)
    addATKRate = GetExProp(buff, 'addATKRate')
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - addATKRate
end

function SCR_FIELD_BOSS_AWAKE_SIMPLE(self)
    local nowHP = self.HP
    local maxHP = self.MHP
    local awakeCnt = GetExProp(self, "AWAKE_COUNT")
    if awakeCnt < 1 and awakeCnt == 0 then
        if maxHP * 0.1 >= nowHP then
            AddBuff(self, self, 'FIELD_BOSS_AWAKE_UP', 1, 0, 0, 1)
            AddBuff(self, self, 'GM_Invincible_Buff', 1, 0, 5000, 1)
            SetExProp(self, "AWAKE_COUNT", 1)
        end
    end
end

function SCR_BUFF_ENTER_FIELD_BOSS_AWAKE_UP_VERSION_TWO(self, buff, arg1, arg2, over)
    local addATKRate = 1.5
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + addATKRate
    SetExProp(buff,'addATKRate', addATKRate)
end

function SCR_BUFF_UPDATE_FIELD_BOSS_AWAKE_UP_VERSION_TWO(self, buff, arg1, arg2, RemainTime, ret, over)
    local maxHP = self.MHP
    local nowHP = self.HP
    local healHP = maxHP * 0.15
    local prop = GetExProp(buff, 'useHeal')
    if prop ~= 1 then
        if nowHP < maxHP then
            Heal(self, math.floor(healHP) , 0);
            return 1;
        end
        SetExProp(buff, 'useHeal', 1)
    end
    return 1;
end

function SCR_BUFF_LEAVE_FIELD_BOSS_AWAKE_UP_VERSION_TWO(self, buff, arg1, arg2, over)
    addATKRate = GetExProp(buff, 'addATKRate')
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - addATKRate
end

function SCR_FIELD_BOSS_AWAKE_VERSION_TWO_SIMPLE(self)
    local nowHP = self.HP
    local maxHP = self.MHP
    local awakeCnt = GetExProp(self, "AWAKE_COUNT")
    if awakeCnt < 1 and awakeCnt == 0 then
        if maxHP * 0.1 >= nowHP then
            AddBuff(self, self, 'FIELD_BOSS_AWAKE_UP_VERSION_TWO', 1, 0, 0, 1)
            AddBuff(self, self, 'GM_Invincible_Buff', 1, 0, 5000, 1)
            SetExProp(self, "AWAKE_COUNT", 1)
        end
    end
end

-- 벨코퍼 쫄 소환용 버프.

function SCR_BUFF_ENTER_Raid_buff_Velcoffer_Summon(self, buff, arg1, arg2, over)
    local x, y, z = GetPos(self)
    local followerList, followercnt = GetFollowerList(self);
    local limitCnt = 4;
    if followercnt == 0 then
        for i = 1, limitCnt do
            RunScript("SCR_Raid_buff_Velcoffer_Summon_Time", self, x, y, z)
        end
    end
end

function SCR_BUFF_UPDATE_Raid_buff_Velcoffer_Summon(self, buff, arg1, arg2, over)
    local followerList, followercnt = GetFollowerList(self);
    if followerList == nil or followercnt == 0 then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Raid_buff_Velcoffer_Summon(self, buff, arg1, arg2, over)
    
end

function SCR_Raid_buff_Velcoffer_Summon_Time(self, x, y, z)
   local time = IMCRandom(0, 1000);
   sleep(time);
   local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 50, 100)
   local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
   local summonMon = CREATE_MONSTER_EX(self, 'velcoffer_guard_mini', dPos['x'], y, dPos['z'], angle, 'Monster', nil);
   DisableBornAni(summonMon)
   PlayEffect(summonMon, 'F_buff_basic027_navy_line', 0.5, 'BOT');
   SetOwner(summonMon,self,0)
end


------------------RAID_VELCOFFER_GIMMICK_BUFF----
function SCR_BUFF_ENTER_RAID_VELCOFFER_GIMMICK_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic025_white_line_event', 0.5, 'BOT');
end

function SCR_BUFF_LEAVE_RAID_VELCOFFER_GIMMICK_BUFF(self, buff, arg1, arg2, over)

end
--------
function SCR_BUFF_ENTER_VELCOPFFER_GIMMICK_TIMER_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_VELCOPFFER_GIMMICK_TIMER_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local remainderTime = math.floor(RemainTime/1000)
    local timer = remainderTime + 1
    SetTitle(self, timer)
    return 1;
end

function SCR_BUFF_LEAVE_VELCOPFFER_GIMMICK_TIMER_BUFF(self, buff, arg1, arg2, over)
    SetTitle(self, "")
end
--------
function SCR_BUFF_ENTER_VELCOPFFER_GIMMICK_SACRIFICE_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_VELCOPFFER_GIMMICK_SACRIFICE_BUFF(self, buff, arg1, arg2, over)

end
------------------RAID_VELCOFFER_GIMMICK_BUFF----

function SCR_BUFF_ENTER_INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS(self, buff, arg1, arg2, over)

end

------------RAID_VELCOFFER_MINIGAME DEBUFF------------
function SCR_BUFF_ENTER_Raid_Velcofer_Curse_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    local StageProgress = GetMGameValue(self, 'StageProgress')
    if over >= 1 then
    end
    
    if over >=2 then
    end
    
    if over >=3 then
        if StageProgress == 0 then
            if IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') == 'YES' then
                RemoveBuff(self, 'Raid_Velcofer_Cnt_Debuff')
            end
        end
        local objList, objCount = SelectObject(self, 40, 'PC');
        PlayEffect(self, 'F_burstup012_violet', 1);
        for i = 1, objCount do
            local obj = objList[i];
            if obj.ClassName == 'PC' then
                local angle = GetAngleTo(self, obj);
                TakeDamage(caster, obj, "None", 9999 , "Dark", "Magic", "Magic", HIT_DARK, HITRESULT_BLOW);
                KnockDown(obj, self, 150, angle, 60, 1);
            end
        end
    end
    
    if over >=4 then
    end
  
end

function SCR_BUFF_UPDATE_Raid_Velcofer_Curse_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local buffCount = GetBuffArgs(buff)
    local caster = GetBuffCaster(buff)
    
    if caster == nil then
        local casterHandler = GetMGameValue(self, 'casterHandle')
        local zoneInst = GetZoneInstID(self)
        caster = GetByHandle(zoneInst, casterHandler)
    end
    
    SetBuffArgs(buff, buffCount + 1)

    ---------2단계 HP 감소 관련 시작-----------
    if over >= 2 then
        if  buffCount%5 == 0 and buffCount ~= 0 then
            local hpDmg = (2500 * ( over - 1 ))-1
            local hpCheck = self.HP - hpDmg
            if hpCheck >= 1 and IsBuffApplied(self, 'RAID_VELCOFFER_GIMMICK_BUFF') == 'NO' then
                TakeDamage(caster, self, "None", hpDmg , "Dark", "Magic", "TrueDamage", HIT_BASIC_NOT_CANCEL_CAST, HITRESULT_BLOW)
            end
        end
    end
    ---------2단계 HP 감소 관련 끝-----------
    
    --------- 디버프 스택 MAX 처리 시작 ---------
    local StageProgress = GetMGameValue(self, "StageProgress")
    if StageProgress == 1 then
        if IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') == 'NO' then
            if over < 5 then
               AddBuff(caster, self, 'Raid_Velcofer_Cnt_Debuff', 1, 0, 0, 1)
               return 1;
            end
        elseif IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') == 'YES' then
            if over >= 5 then
                RemoveBuff(self, 'Raid_Velcofer_Cnt_Debuff')
            end
        end
    elseif IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') == 'YES' and over >= 3 then
        RemoveBuff(self, 'Raid_Velcofer_Cnt_Debuff')
    elseif IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') == 'NO' and over < 3 then
        AddBuff(caster, self, 'Raid_Velcofer_Cnt_Debuff', 1)
    end
    --------- 디버프 스택 MAX 처리 끝 ---------
    
    --------- 4단계 이후 전염 시작 -------
    if over >= 4 then
        if buffCount == 10 then
            local objList, objCount = SelectObject(self, 100, 'PC');
            if objCount == nil or objCount ~= 0 then
                for i = 1, objCount do
                    local obj = objList[i]
                    if obj.ClassName == 'PC' then
                        if IsBuffApplied(obj, 'Raid_Velcofer_Curse_Debuff') == 'YES' then
                            local overCharge = GetBuffOver(obj, 'Raid_Velcofer_Curse_Debuff')
                            if overCharge >= 2 then
                                return 1;
                            end
                        end
                        AddBuff(caster, obj, 'Raid_Velcofer_Curse_Debuff', 1, 0, 0, 2)
                    end
                end
            end
        end
    end

    --------- 4단계 이후 전염 종료 -------

    if over >= 5 then
        AddBuff(caster, self, 'Raid_Velcofer_Last_Curse_Debuff', 1, 0, 30000, 1)
        RemoveBuff(self, 'Raid_Velcofer_Curse_Debuff')
    end

    if buffCount >= 10 then
        SetBuffArgs(buff, 0)
    end
    return 1;
end

function SCR_BUFF_LEAVE_Raid_Velcofer_Curse_Debuff(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_Raid_Velcofer_Cnt_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Raid_Velcofer_Cnt_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        local casterHandler = GetMGameValue(self, 'casterHandle')
        local zoneInst = GetZoneInstID(self)
        caster = GetByHandle(zoneInst, casterHandler)
    end
    
    local curseCharge = over

    if curseCharge >= 100 then
        AddBuff(caster, self, 'Raid_Velcofer_Curse_Debuff', 1, 0, 0, 1)
        RemoveBuff(self, 'Raid_Velcofer_Cnt_Debuff')
    end
    AddBuff(caster, self, 'Raid_Velcofer_Cnt_Debuff', 1, 0, 0, 1)
    return 1;
end

function SCR_BUFF_LEAVE_Raid_Velcofer_Cnt_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Raid_Velcofer_Awake_Buff(self, buff, arg1, arg2, over)
    local lv = arg1
    local blkbreakAdd = 50 * lv
    local hrAdd = 50 * lv

    self.HR_BM = self.HR_BM + hrAdd
    self.BLK_BREAK_BM = self.BLK_BREAK_BM + blkbreakAdd
    
    SetExProp(buff, "ADD_HR", hrAdd);
    SetExProp(buff, "ADD_BLKBREAK", blkbreakAdd);
end

function SCR_BUFF_LEAVE_Raid_Velcofer_Awake_Buff(self, buff, arg1, arg2, over)
    local blkbreakAdd = GetExProp(buff, "ADD_BLKBREAK");
    local hrAdd = GetExProp(buff, "ADD_HR");
    
    self.HR_BM = self.HR_BM - hrAdd
    self.BLK_BREAK_BM = self.BLK_BREAK_BM - blkbreakAdd
end

function SCR_BUFF_ENTER_Raid_Velcofer_Last_Curse_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Raid_Velcofer_Last_Curse_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local buffCount = GetBuffArgs(buff)
    SetBuffArgs(buff, buffCount + 1)
    
    if  buffCount == 10 then
        local buffSelect = IMCRandom(1, 4)
        if buffSelect == 1 then
            AddBuff(caster, self, 'Mon_raid_stun', 1, 0, 3000, 1)
        elseif buffSelect == 2 then
            AddBuff(caster, self, 'UC_petrify', 1, 0, 3000, 1)
        elseif buffSelect == 3 then
            AddBuff(caster, self, 'UC_silence', 1, 0, 3000, 1)
        elseif buffSelect == 4 then
            AddBuff(caster, self, 'UC_blind', 1, 0, 3000, 1)
        end
    end
    if buffCount >= 10 then
        SetBuffArgs(buff, 0)
    end
    return 1;
end

function SCR_BUFF_LEAVE_Raid_Velcofer_Last_Curse_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_Raid_Cloaking_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Raid_Cloaking_Buff(self, buff, arg1, arg2, over)

end

--UC_UnrecoverableHP
function SCR_BUFF_ENTER_UC_UnrecoverableHP(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_UC_UnrecoverableHP(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Monster_Stop_Debuff(self, buff, arg1, arg2, over)

    local defencedBM = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        defencedBM = 1;
    end
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    SetExProp(buff, 'DEFENCED_BM', defencedBM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + defencedBM;

end

function SCR_BUFF_UPDATE_Monster_Stop_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    return 1;

end

function SCR_BUFF_LEAVE_Monster_Stop_Debuff(self, buff, arg1, arg2, over)

    local defencedBM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - defencedBM;
    
end
