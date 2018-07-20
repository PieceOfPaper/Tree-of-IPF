

function SPCI_HEAL_PARTY_HP_BY_DEM(self, item, target, damage, skill, ret, ratio)
    
    if GetObjType(target) == OT_PC then
        local list, cnt = GET_PARTY_ACTOR_BY_SKILL(target,0);
        if cnt > 0 then
            for i=0, cnt do
                local partyActor = list[i];
                if partyActor ~= nil then

                    local healValue = damage * ratio;
                    Heal(partyActor, healValue, 0);

                end
            end
            
        end
    end

end

function SPCI_SET_STAMINA(self, item, target, damage, skill, ret, value)
    
    AddStamina(self,value);
    InvalidateStates(self);
end

function SPCI_SET_HP(self, item, target, damage,skill, ret, value)
    self.HP = value;
    InvalidateStates(self);
end

function SPCI_VAMP(self, item, target, damage,skill, ret, ratio)

    local healValue = damage * ratio;
    Heal(self, healValue, 0, ret);

    SkillTextEffect(nil, self, from, "VAMP_HP", healValue, item);

end

function SPCI_MP_VAMP(self, item, target, damage,skill, ret, ratio)

    local healValue = damage * ratio;
    HealSP(self, healValue, 0, ret);

    SkillTextEffect(nil, self, from, "VAMP_SP", healValue, item);
end

function SPCI_MP_HEAL(self, item, target, damage, skill, ret, healValue)

    HealSP(self, healValue, 0, ret);

    SkillTextEffect(nil, self, from, "VAMP_SP", healValue, item);
end


function SPCI_HIT_DAM_RATE(self, obj, target, damage, skill, ret, raceType, ratio)

    if TryGetProp(target, "RaceType") == raceType then
        local dam = GetExProp(self, "SPCI_RATE_DAM");
        SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
    end
end

function SPCI_HIT_SKILL_ADD(self, obj, target, damage, skill, ret, sklName, addValue)
    if skill.ClassName == sklName then
        if addValue < 0 then
            addValue = 0;
        end
        local skillowner = GetSkillOwner(skill)
        local dam = GetExProp(skillowner, "SPCI_FACTOR_ADD_DAM");
        SetExProp(skillowner, "SPCI_FACTOR_ADD_DAM", addValue + dam);
    end
end

function SPCI_HIT_SKILL(self, obj, target, damage, skill, ret, sklName, ratio)
    if skill.ClassName == sklName then
        if ratio < 0 then
            ratio = 0;
        end
        local skillowner = GetSkillOwner(skill)
        local dam = GetExProp(skillowner, "SPCI_RATE_DAM");
        SetExProp(skillowner, "SPCI_RATE_DAM", ratio + dam);
    end
end

function SPCI_HIT_BUFF_S(self, obj, target, damage, skill, ret, buffName, ratio)
    local buf = GetBuffByName(self, buffName);
    if buf == nil or buf.ElapsedTime == 0 then
        return;
    end
    
    if ratio < 0 then
        ratio = 0;
    end
    local dam = GetExProp(self, "SPCI_RATE_DAM");
    SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
end

function SPCI_HIT_BUFF_T(self, obj, target, damage, skill, ret, buffName, ratio)
    local buf = GetBuffByName(target, buffName);
    if buf == nil or buf.ElapsedTime == 0 then
        return;
    end
    
    if ratio < 0 then
        ratio = 0;
    end
    local dam = GetExProp(self, "SPCI_RATE_DAM");
    SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
end

function SPCI_HIT_SKILL_BUFF_S(self, obj, target, damage, skill, ret, sklName, buffName, ratio)
    if skill.ClassName ~= sklName then
        return;
    end

    local buf = GetBuffByName(self, buffName);
    if buf == nil or buf.ElapsedTime == 0 then
        return;
    end
    
    if ratio < 0 then
        ratio = 0;
    end
    local dam = GetExProp(self, "SPCI_RATE_DAM");
    SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
end


function SPCI_HIT_SKILL_BUFF_T(self, obj, damage, target, skill, ret, sklName, buffName, ratio)
    if skill.ClassName ~= sklName then
        return;
    end

    local buf = GetBuffByName(target, buffName);
    if buf == nil or buf.ElapsedTime == 0 then
        return;
    end
    
    if ratio < 0 then
        ratio = 0;
    end
    local dam = GetExProp(self, "SPCI_RATE_DAM");
    SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
end

function SPCI_HIT_SKILL_RACE(self, obj, damage, target, skill, ret, sklName, raceType, ratio)
    if skill.ClassName ~= sklName then
        return;
    end

    if TryGetProp(target, "RaceType") ~= raceType then
        return;
    end
        
    if ratio < 0 then
        ratio = 0;
    end
    local dam = GetExProp(self, "SPCI_RATE_DAM");
    SetExProp(self, "SPCI_RATE_DAM", ratio + dam);
end

function SPCI_FIX_DAM(self, item, target, damage, skill, ret, damage)

    ret.Damage = damage;

end

function SPCI_CRTHR(self, item, target, damage, skill, ret, ratio)

    SetExProp(self, "ABIL_CRTHR_ADD", ratio)
end

function SPCI_CRITICAL(self, item, target, damage, skill, ret)

    SetExProp(self, "IS_CRITICAL", 1)

end

function SPCI_CRTATK(self, item, target, damage,skill, ret, damage)

    self.CRTATK_BM = self.CRTATK + damage;

end

function SPCI_ADD_DAM(self, item, target, damage,skill, ret, addDam)

    local dam = GetExProp(self, "SPCI_ADD_DAM");
    SetExProp(self, "SPCI_ADD_DAM", addDam + dam);

end

function SPCI_BUFF_ITEM(self, item, damage, target, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end
    
    local from = GetSkillOwner(skill)
    if self == nil or from == nil then
        return;
    end
    
    local buff = AddBuff(from, self, buffName, lv, arg2, bfTime, over);
    --SkillTextEffect(ret, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, item);

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end

function SPCI_BUFF_EQUIPITEM(self, item, buffName, lv, arg2, bfTime, over, percent, updateTime)
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    if self == nil then
        return;
    end

    local buff = AddBuff(self, self, buffName, lv, arg2, bfTime, over);

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end

function SPCI_BUFF(self, item, target, damage, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    if target == nil then
        target = self;
    end

    local buff = AddBuff(target, self, buffName, lv, arg2, bfTime, over);
    --SkillTextEffect(ret, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, item);

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end



function SPCI_USE_SKILL_BUFF(self, item, target, damage, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)


if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    AddBuff(self, target, buffName, lv, arg2, bfTime, over);

if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end

function SPCI_SUMMON_TRANSE_ADD_STATUS(self, item, buffName, lv, bfTime, addMhpRate, addDefRate, limitMHP, limitDEF, limitMDEF, updateTime)

    local buff = AddBuff(self, self, buffName, addMhpRate, addDefRate, bfTime, 1);
    SetBuffArgs(buff, limitMHP, limitDEF, limitMDEF);
    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end

function SPCI_AROUND_BUFF(self, item, target, damage,skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime, distance, maxcount)

    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end
    
    
    local objList, objCount = SelectObject(self, distance, 'ENEMY');

    for i = 1, objCount do

        local obj = objList[i];

        local buff;
        if ret ~= nil then
            buff = AddSkillBuff(obj, self, ret, buffName, lv, arg2, bfTime, over);
        else
            buff = AddBuff(obj, self, buffName, lv, arg2, bfTime, over);
        end

        if updateTime ~= -1 then
            SetBuffUpdateTime(buff, updateTime);
        end

        
    end

    

end


function SPCI_REMOVE_BUFF(self, item, target, damage,skill, ret, buffName)
    RemoveBuff(self, buffName);
end


function SPCI_REMOVE_BUFF_UNEQUIP(self, item, buffName)
    RemoveBuff(self, buffName);
end


--[[
function SPCI_UPDOWNBUFF(self, item, target, damage,skill, ret, buffName, who, opertype, value, bfTime, over, percent, updateTime)

    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    local buff;
    if ret ~= nil then
        buff = AddSkillBuff(target, self, ret, buffName, who, value, bfTime, over);
    else
        buff = AddBuff(target, self, buffName, who, value, bfTime, over);
    end

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end
]]--




function SPCI_BUFF2(target, item, self, damage, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    if target == nil then
        return;
    end

    local buff;
    if ret ~= nil and ret.ClassName == "SkillResult" then
        buff = AddSkillBuff(target, target, ret, buffName, lv, arg2, bfTime, over);
    else
        buff = AddBuff(target, target, buffName, lv, arg2, bfTime, over);
    end

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end

end

function SPCI_BUFF_WITH_COOLDOWN(target, item, self, damage, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime, cooldownGroup, cooldownTime)
    if GetCoolDown(self, cooldownGroup) > 0 then
        return;
    end
    
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end
    
    if target == nil then
        return;
    end
    
    local buff;
    if ret ~= nil and ret.ClassName == "SkillResult" then
        buff = AddSkillBuff(target, target, ret, buffName, lv, arg2, bfTime, over);
    else
        buff = AddBuff(target, target, buffName, lv, arg2, bfTime, over);
    end
    
    AddCoolDown(self, cooldownGroup, cooldownTime);
    
    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end
end

function SPCI_BUFF_WITH_SELFBUFF(target, item, self, damage, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime, selfBuffName, lv2, arg2_2, bfTime2, over2, updateTime2)
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    if target == nil then
        return;
    end

    local buff;
    if ret ~= nil and ret.ClassName == "SkillResult" then
        buff = AddSkillBuff(target, target, ret, buffName, lv, arg2, bfTime, over);
        selfBuff = AddSkillBuff(self, self, ret, selfBuffName, lv2, arg2_2, bfTime2, over2);
    else
        buff = AddBuff(target, target, buffName, lv, arg2, bfTime, over);
        selfBuff = AddSkillBuff(self, self, ret, selfBuffName, lv2, arg2_2, bfTime2, over2);
    end

    if updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
        SetBuffUpdateTime(selfBuff, updateTime2);
    end

end


function SPCI_TGT_EFT(self, item, target, damage,skill, ret, eft, eftScl, x, y, z, lifeTime)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    PlayEffectToGround(self, eft, x, y, z, eftScl, lifeTime);
    EndSyncPacket(self, key);

end

function SPCI_ADD_HIT(self, item, target, damage,skill, ret, addDam, kdPower)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    TAKE_SCP_DAMAGE(self, target, addDam, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName);
    EndSyncPacket(self, key);
    SkillTextEffect(nil, target, self, "SHOW_DMG_SHIELD", addDam, item);

end

function SPCI_DAGGER_MULTIPLE_HIT(self, item, target, damage, skill, ret, hitCount)

    SetMultipleHitCount(ret, hitCount);
    if ret.Damage < hitCount then
        ret.Damage = hitCount;
    end
end

function SPCI_REPEATLY_HIT(self, item, target, damage, skill, ret, repeatName, repeatLevel)
    SetRepeatlyHit(ret, repeatName, repeatLevel);
end

function SPCI_MULTIPLE_HIT(self, item, target, damage, skill, ret, hitCount, inter)
    
    ret.HitDelay = ret.HitDelay / hitCount

    SetMultipleHitCount(ret, hitCount);
    if ret.Damage < hitCount then
        ret.Damage = hitCount;
    end
--[[
    
    sleep(150)
    local tempDamage = ret.Damage / hitCount;
    --local key = GetSkillSyncKey(self, ret);
        
    for i = 1, hitCount do
    --StartSyncPacket(self, key);
    TAKE_SCP_DAMAGE(self, target, tempDamage, HIT_BASIC, HITRESULT_BLOW, 0, skill.ClassName);
    --EndSyncPacket(self, key);
    sleep(inter)
    end
    --SkillTextEffect(ret, target, self, "SHOW_DMG_SHIELD", addDam, item);
    ]]
end


function SPCI_SET_TGT_CIRCLE(self, item, target, damage, skill, ret, relation, x, y, z, range, maxCnt)
    
    ClearScpTarget(self);
    local list, cnt = SelectObjectPos(self, x, y, z, range, relation);
    cnt = math.min(maxCnt, cnt);
    for i = 1, cnt do
        local obj = list[i];
        AddScpTarget(self, obj);
    end

end

function SPCI_TGT_KB(self, item, target, damage, skill, ret, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)

    local key = GenerateSyncKey(self);

    StartSyncPacket(self, key);
    
    SKL_TOOL_KD(target, self, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);

    EndSyncPacket(self, key);
    SyncPacketByHit(self, key);
    
    --[[
    StartSyncPacket(self, key);
    
    local tgtList = GetScpTargetList(target);
    
    for i = 1 , #tgtList do

        local tgt = tgtList[i];
    SKL_TOOL_KD(target, self, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
        SKL_TOOL_KD(self, tgt, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
    end

    EndSyncPacket(self, key);
    SyncPacketByHit(self, key);
    ]]
end

-- ?????? ???? ????
function SPCI_SET_ITEM_COOLTIME(self, obj, damage, target, skill, ret, cdGroup, time)

    SetCoolDown(self, cdGroup, time);
    
end

-- ?????? ???? ????
function SPCI_REDUCE_ITEM_COOLTIME(self, obj, damage, target, skill, ret, cdGroup, time)


    AddCoolDown(self, cdGroup, -time);
    SkillTextEffect(nil, self, target, "COOL_DOWN_HP", time/1000, obj);
    
end


-- ???? ?????? ???? ??? ????
function SPCI_SET_POTION_ITEM_COOLTIME(self, obj, damage, target, skill, ret, time)

    local get_item = GetInvItemList(self);

    for i = 1, #get_item do
        if get_item[i].ClassID > 190000 and get_item[i].ClassID < 200000 then
            SetItemCoolTime(pc, get_item[i], time);
        end
    end
    
end

--??? ??????? ????
function SPCI_REDUCE_OVERHEAT(self, obj, damage, target, skill, ret, time)

    local list, cnt = GetPCSkillList(self);

    for i = 1, cnt do
        if list[i].ClassID > 10000 then

            skill = list[i];

            if skill.UseOverHeat > 0 then
                RequestReduceOverHeat(self, skill.OverHeatGroup, -time, skill.CoolDownGroup, 0.0); --0.0 : ??ⓒª ????.
            end
        end
    end
end





-- ???? ??
function SPCI_SET_TIMER(self, item, target, damage, skill, ret, sec, timeKey)

    SetExProp(item, timeKey, imcTime.GetAppTime() + sec);

end

-- ???? ????
function SPCI_ADD_SKILL_RANGE(self, item, skill, arg1, arg2, arg3, range, width)

    local beforeAddRange = GetExProp(self, "SPCI_SKILL_RANGE");
    local beforeAddWidth = GetExProp(self, "SPCI_SKILL_WIDTH");
    SetExProp(self, "SPCI_SKILL_RANGE", beforeAddRange + range);
    SetExProp(self, "SPCI_SKILL_WIDTH", beforeAddWidth + width);
end

function SPCI_DAM_REFLECT(self, obj, damage, target, skill, ret, ratio)
    
    self.DamReflect = 100;
    local dmg = damage * ratio;
    if damReflect > 0 then
        dmg = damReflect * 0.01 
    end
    TakeDamage(self, target, 'None', dmg);
end



function SPCI_TGT_EXPLOSION(self, item, target, damage, skill, ret, boomDamage ,knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)

    local objList, objCount = SelectObjectByFaction(self, 1000, 'Monster')
    local key = GenerateSyncKey(self);

    StartSyncPacket(self, key);
    PlayEffect(self, 'F_buff_explosion_burst');

    if objCount ~= nil or objList ~= nil then
        for i = 1, objCount do
            local obj = objList[i];
            TakeDamage(target, obj, 'None', boomDamage);
            SKL_TOOL_KD(obj, obj, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
        end
    end

    EndSyncPacket(self, key);
    SyncPacketByHit(self, key);

end


function SPCI_ATTACKER_SET_EXPROP_NUM(self, item, target, damage, skill, ret, exPropName, value)

    SetExProp(self, exPropName, value);
end

function SPCI_TARGET_SET_EXPROP_NUM(self, item, target, damage, skill, ret, exPropName, value)

    SetExProp(target, exPropName, value);
end

function SPCI_ATTACKER_SET_EXPROP_STR(self, item, target, damage, skill, ret, exPropName, value)

    SetExProp_Str(self, exPropName, value);
end

function SPCI_TARGET_SET_EXPROP_STR(self, item, target, damage, skill, ret, exPropName, value)

    SetExProp_Str(target, exPropName, value);
end

function SPCI_TARGET_RUNSCP(self, item, target, damage, skill, ret, scpName)
    local func = _G[scpName];
    func(self, item, target, damage, skill, ret);
end

function SPCI_TGT_KB_BOUNCE(self, item, target, damage, skill, ret)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    SetUseKbBounceCalc(target, 1);
    EndSyncPacket(self, key, 0);
end

function SPCI_TGT_KB_ADD_DAMAGE(self, item, target, damage, skill, ret, kbDamage, hitType, resultType)

    if IS_PC(target) ~= true and (target.HPCount > 0 or target.KDArmor > 900) then
        return ;
    end

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    TakeKBDamage(self, target, kbDamage, hitType, resultType, 1);
    EndSyncPacket(self, key, 0);
end

function SPCI_TGT_KB_COLL_DAMAGE(self, item, target, damage, skill, ret, kbDamage, hitType, resultType, searchRange, splashDamage, sr)
    
    if IS_PC(target) ~= true and (target.HPCount > 0 or target.KDArmor > 900) then
        return ;
    end
    
    --local checkTime = GetExProp(target, 'KB_COLL_DAMAGE_TIME');
    --local curTime = imcTime.GetAppTime();
    --if checkTime < curTime then       
        --SetExProp(target, 'KB_COLL_DAMAGE_TIME', curTime + 0.1);

        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        AddCollisionDamage(self, target, kbDamage, hitType, resultType, skill.ClassName);
        EndSyncPacket(self, key, 0);
    --end
end

function SPCI_TGT_KD_COLL_DAMAGE(self, item, target, damage, skill, ret, kdDamage, hitType, resultType, searchRange, splashDamage, sr)

    if IS_PC(target) ~= true and (target.HPCount > 0 or target.KDArmor > 900) then
        return;
    end
    
    --local checkTime = GetExProp(target, 'KD_COLL_DAMAGE_TIME');
    --local curTime = imcTime.GetAppTime();
    --if checkTime < curTime then       
        --SetExProp(target, 'KD_COLL_DAMAGE_TIME', curTime + 0.1);

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    AddKDDamage(self, target, kdDamage, hitType, resultType);
        
    SetKDSplashDamage(self, target, skill.ClassName, searchRange, splashDamage, sr);
    EndSyncPacket(self, key, 0);
    --end
end

function SPCI_SKILLUP(self, item, skill, addLv)
    local skl = GetSkill(self, skill);

    if nil == skl then
        return;
    end

    skl.Level_BM = skl.Level_BM + addLv;
    if 0 > skl.Level_BM then
        skl.Level_BM = skl.Level_BM - addLv;
    end

    InvalidateSkill(self, skill);
end

function SPCI_GEM_SKILLUP(self, item, skillName, addLv)

    local skl = GetSkill(self, skillName);
    if nil == skl then
        return;
    end

    skl.GemLevel_BM = skl.GemLevel_BM + addLv;
    if 0 > skl.GemLevel_BM then
        skl.GemLevel_BM = 0;
    end

    InvalidateSkill(self, skillName);
end

function ITEM_S_R_TGT_PAD(self, item, target, damage, skl, ret, targetType, angle, padName, percent)
    local checkValue = item.ClassName;
    local active = GetExProp(self, checkValue);
    
    if active > 0 or active == nil then
        return;
    end
    
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    local x, y, z;
    if targetType == "Target" then
        x, y, z = GetPos(target);
    elseif targetType == "Self" then
        x, y, z = GetPos(self);
    else
        return;
    end

    RunPad(self, padName, skl, x, y, z, angle, 1);
    
    SetExProp(self, 1, checkValue)
    
end