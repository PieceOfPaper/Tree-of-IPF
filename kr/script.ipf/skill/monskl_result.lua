

function S_R_TGTBUFF(self, target, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    --local buff = AddSkillBuff(self, target, ret, buffName, lv, arg2, bfTime, over);
    
    if ret ~= nil then

        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        
        local buff = AddBuff(self, target, buffName, lv , arg2, bfTime, over);
        
        if updateTime ~= nil and updateTime ~= -1 then
            SetBuffUpdateTime(buff, updateTime);
        end
        EndSyncPacket(self, key);
    else
        local buff = AddBuff(self, target, buffName, lv , arg2, bfTime, over);
        
        if updateTime ~= nil and updateTime ~= -1 then
            SetBuffUpdateTime(buff, updateTime);
        end
    end     
        
end

function S_R_SELFBUFF(self, target, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    if IS_REAL_PC(self) == "NO" and GetExProp(self, "BUNSIN") == 1 then
        return
    end
    
    if percent < 100 and IMCRandom(1, 100) > percent then
        return;
    end

    local buff = AddSkillBuff(self, self, ret, buffName, lv, arg2, bfTime, over);
    if updateTime ~= nil and updateTime ~= -1 then
        SetBuffUpdateTime(buff, updateTime);
    end
end

function S_R_SET_SCP_TARGET(self, target, tgtTime)
    SetExArgObject(self, "SCP_TARGET", target);
end

function SCR_KD_SPLASH_DAMAGE(self, attacker, skillName, range, dmgRate, sr)
    local skill = GetSkill(attacker, skillName);
    if skill ~= nil then
        local objList, objCount = SelectObjectNear(attacker, self, range, 'ENEMY'); 
        for i = 1, objCount do
            local obj = objList[i];
            if IsSameActor(obj, self) == "NO" then
                local damage = SCR_LIB_ATKCALC_RH(attacker, skill);
                
                -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
                if dmgRate < 0 then
                    dmgRate = 0;
                end
                
                dmgRate = dmgRate - 1;
                
                local spciRate = GetExProp(attacker, "SPCI_RATE_DAM");
                SetExProp(attacker, "SPCI_RATE_DAM", spciRate + dmgRate);
                
                TakeDamage(attacker, obj, skillName, damage, skill.Attribute, skill.AttackType, skill.ClassType, HIT_BASIC, HITRESULT_BLOW);
                sr = sr - obj.SDR;
            end
            if sr <= 0 then
                return;
            end
        end
    end
end

function S_R_EXPLODE_DAMAGE(self, target, skill, ret, eft, eftScale, searchRange, damRate, delaySec)

    local objList, cnt = SelectObjectNear(self, target, searchRange, "ENEMY", 0, 0);

    if skill.ClassName == "Mergen_TrickShot" and cnt > 3 then
        cnt = 3
    end
    
    SetExProp(target, 'S_R_EXPLODE_DAMAGE', 1);
    local damage = ret.Damage;
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    for i = 1 , cnt do  
        local obj = objList[i];
        SetExProp(obj, 'S_R_EXPLODE_DAMAGE', 1);
        TakeDamage(self, obj, 'None', damage * damRate);
        DelExProp(obj, 'S_R_EXPLODE_DAMAGE');
    end

    PlayEffect(target, eft, eftScale);
    EndSyncPacket(self, key, delaySec); 
    DelExProp(target, 'S_R_EXPLODE_DAMAGE');
end

function S_R_EXPLODE_KNOCKDOWN(self, target, skill, ret, knockType, range, power, vangle, bounce)


    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);

    local objList, objCount = SelectObject(target, range, 'ALL');
    for i = 2, objCount do
        local obj = objList[i];
        if obj ~= nil then
            local angle = GetAngleTo(mon, obj);

            if knockType == 4 then
                KnockDown(obj, mon, power, angle, vangle, bounce);
            elseif knockType == 3 then
                KnockBack(obj, mon, power, angle, vangle, bounce);
            end
        end
    end 

    EndSyncPacket(self, key, delaySec); 
end

function S_R_EXPLODE_DAMAGE_AR(self, target, skill, ret, eft, eftScale, dist, width, maxCount, damRate, delaySec, randomTargetList)
    if GetVisitIndex(ret) ~= 0 then
        return;
    end
    
    local damage = SCR_LIB_ATKCALC_RH(self, skill);
    
    -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
    if damRate < 0 then
        damRate = 0;
    end
    
    damRate = damRate - 1;
    
    SetExProp(target, 'S_R_EXPLODE_DAMAGE', 1);
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    
    local x, y, z = GetPos(target);
    local angle = { 0, 90, 180, 270 }
    
    AddScpObjectList(self, "SCP_S_R_EXPLODE_DAMAGE_AR_LIST", target);
    for j = 1 , #angle do
        SKL_SET_TARGET_SQUARE(self, skill, x, y, z, angle[j], dist, width, maxCount, "ENEMY", 0, 0, 0)
        local tgtList = GetHardSkillTargetList(self);
        if #tgtList >= 1 then
            for k = 1, #tgtList do
                local tgt = tgtList[k];
                AddScpObjectList(self, "SCP_S_R_EXPLODE_DAMAGE_AR_LIST", tgt);
            end
        end
        ClearHardSkillTarget(self);
    end
    
    local objList = GetScpObjectList(self, "SCP_S_R_EXPLODE_DAMAGE_AR_LIST");
    local cnt = #objList;
    if cnt > maxCount then
        cnt = maxCount;
    end
    
    if cnt >= 1 then
        if randomTargetList ~= nil and randomTargetList == 1 then
		    objList = SCR_ARRAY_SHUFFLE(objList);
	    end
        for i = 1 , cnt do
            local obj = objList[i];
            local spciRate = GetExProp(self, "SPCI_RATE_DAM");
            SetExProp(self, "SPCI_RATE_DAM", spciRate + damRate);
            SetExProp(obj, 'S_R_EXPLODE_DAMAGE', 1);
            TakeDamage(self, obj, skill.ClassName, damage, skill.Attribute, "Melee", skill.ClassType, skill.HitType, HITRESULT_NO_HITSCP);
            DelExProp(obj, 'S_R_EXPLODE_DAMAGE');
        end
    end
    
    local x, y, z = GetPos(target);
    
    PlayEffectToGround(self, eft, x, y, z, eftScale, 0.0, 0.0, GetDirectionByAngle(self));
    EndSyncPacket(self, key, delaySec); 
    DelExProp(target, 'S_R_EXPLODE_DAMAGE');
    
    ClearScpObjectList(self, "SCP_S_R_EXPLODE_DAMAGE_AR_LIST");
end

-- ??스 반사
function S_R_SET_FORCE_REFLECT(self, target, skill, ret, damage, searchRange, delaySec, splitCnt, reflectRelation)
    
    if IsSameActor(self, target) == 'YES' then
        return;
    end

    -- ??단?? UseType??로 FORCE / FORCE_GROUND ??것????스????식.
    if skill.UseType == 'FORCE' or skill.UseType == 'FORCE_GROUND' then

        local forceDamage = ret.Damage + damage;
        ret.Damage = 0;
        ret.HitType = HIT_NOHIT;    
        ret.ResultType = HITRESULT_INVALID;
        ret.HitDelay = 0;

        local objList, cnt = SelectObjectNear(target, target, searchRange, reflectRelation, 0, 0);
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
                
        PlayAnim(target, "SKL_WARDIZATION_SHOT", 1)

        for i = 1 , math.min(cnt, splitCnt) do
            ForceReflect(self, skill, objList[i], target, forceDamage);         
        end

        EndSyncPacket(self, key, delaySec); 
    end
end

-- 근접공격??반사
function S_R_SET_MELEE_REFLECT(self, target, skill, ret, damage, searchRange, delaySec, splitCnt, reflectRelation)

    if IsSameActor(self, target) == 'YES' then
        return;
    end

    if skill.UseType == 'MELEE_GROUND' or skill.UseType == 'TARGET_GROUND' then

        local reflectDamage = ret.Damage + damage;
        ret.Damage = 0;
        ret.HitType = HIT_NOHIT;
        ret.ResultType = HITRESULT_INVALID;
        ret.HitDelay = 0;

        local objList, cnt = SelectObjectNear(target, target, searchRange, reflectRelation, 0, 0);
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);

        PlayAnim(target, "SKL_WARDIZATION_SHOT", 1)
        for i = 1 , math.min(cnt, splitCnt) do          
            TakeDamage(target, objList[i], 'None', reflectDamage);
        end

        EndSyncPacket(self, key, delaySec); 
    end
end


function S_R_SET_MANA_SHIELD(self, target, skill, ret, damage)
    
    if IsSameActor(self, target) == 'YES' then
        return;
    end

    damage = ret.Damage;
    
    if target.SP >= damage then
        AddSP(target, -damage);
        ret.Damage = 0;
        ret.HitType = HIT_SHIELD;   
        ret.ResultType = HITRESULT_INVALID;
        ret.HitDelay = 0;
    else
        ret.Damage = damage - self.SP
        AddSP(target, -target.SP)
    end
end

local function contains(table, val)
   for i=1, #table do
      if table[i] == val then 
         return true
      end
   end
   return false
end


function S_R_SET_FORCE_DAMAGE(self, target, skill, ret, damageRate, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, collRange, createLength, radiusSpd, searchType, searchRange, delaySec, splitCnt, checkAngle)
    -- 리밸런싱으로 인해 ForceSkillDamage를 쓰게 되면서, None이 아니라 스킬값으로 연산식에 들어감 --
    -- 그로 인하여 Hit Script 가 무한 루프에 빠지게 되는 문제가 있음 --
    -- 해결하기 위해 어차피 Hit Script 에서 도는 기능이니 resultType을 HITRESULT_NO_HITSCP 로 고정 --
    resultType = HITRESULT_NO_HITSCP;
    -- 이거 절대로 지우면 안 됨. 무한루프 돌음. --
    local item = GetEquipItem(self, "RH");
    if skill.ClassID == 30005 and item.ClassType == "Musket" then
        eft = "I_archer_musket_atk";
    end
    
    local damage = SCR_LIB_ATKCALC_RH(self, skill);
--  damage = (damage + skill.SkillAtkAdd) * skill.SkillFactor/100 * damageRate;
    local otherTarget = nil;
    
    -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
    if damageRate < 0 then
        damageRate = 0;
    end
    
    damageRate = damageRate - 1;
    
    -- 1. pc ??? ????/ 2. ??? ??? ????/ 3 ??????? / 4 ????????? ???? / 5 ????????? ??????
    if searchType == 1 then
        
        local objList, cnt = SelectObject(self, searchRange, 'ENEMY');
        if cnt < 2 then         
            return;         
        end
    
        for i = 1 , cnt do
            local obj = objList[i];
            if IsSameObject(obj, target) == 0 then
                otherTarget = obj;
                break;
            end
        end
        
        -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
        local spciRate = GetExProp(self, "SPCI_RATE_DAM");
        SetExProp(self, "SPCI_RATE_DAM", spciRate + damageRate);
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
--        ForceDamage(self, skill, otherTarget, target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
        ForceSkillDamage(self, skill.ClassName, otherTarget, target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
        
        EndSyncPacket(self, key, delaySec); 
    elseif searchType == 2 then
        local objList, cnt = SelectObjectNear(self, target, searchRange, "ENEMY", 0, 0);
        if cnt < 1 then
            return;
        end
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        
        -- TargetObject List에서 고유한 오브젝트를 뽑는다.
        local randomList = {}
        local goalCount = math.min(cnt, splitCnt)
        local limitStopWhileCount = 200     -- anti 무한 루프
        local loopCount = 0
        while #randomList < goalCount do
            if loopCount >= limitStopWhileCount then
                break
            end     
            local rand = IMCRandom(1, cnt)
            local ret = contains(randomList, rand)
            if ret == false then
                randomList[#randomList + 1] = rand
            end
            loopCount = loopCount + 1
        end
        
        for i = 1, #randomList do
            -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
            local spciRate = GetExProp(self, "SPCI_RATE_DAM");
            SetExProp(self, "SPCI_RATE_DAM", spciRate + damageRate);
            
--            ForceDamage(self, skill, objList[randomList[i]], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
            ForceSkillDamage(self, skill.ClassName, objList[randomList[i]], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
        end
                
        EndSyncPacket(self, key, delaySec); 
    elseif searchType == 3 or searchType == 4 or  searchType == 5 then
        local objList, cnt = SelectObjectNear(self, target, searchRange, "ENEMY", 0, 1);
        if cnt < 1 then
            return;         
        end
                
        local skillAngle = GetSkillDirByAngle(self) + 360;

        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);

        local forceCount = 0;
        for i = 1 , cnt do
            local angle = GetAngleTo(target, objList[i])  + 360;
            
            -- ??킬진행방향. ??몹뒤??+- checkAngle각도??내????들
            if searchType == 3 then
                if skillAngle + checkAngle >= angle and skillAngle - checkAngle <= angle then                   
                    -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
                    local spciRate = GetExProp(self, "SPCI_RATE_DAM");
                    SetExProp(self, "SPCI_RATE_DAM", spciRate + damageRate);
                    
--                    ForceDamage(self, skill, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    ForceSkillDamage(self, skill.ClassName, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    forceCount = forceCount + 1;
                end

            -- ??킬진행방향????쪽 +- checkAngle각도??내????들,          
            elseif searchType == 4 then
                if skillAngle + checkAngle +90 >= angle and skillAngle - checkAngle +90 <= angle then
                    -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
                    local spciRate = GetExProp(self, "SPCI_RATE_DAM");
                    SetExProp(self, "SPCI_RATE_DAM", spciRate + damageRate);
                    
--                    ForceDamage(self, skill, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    ForceSkillDamage(self, skill.ClassName, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    forceCount = forceCount + 1;
                end

            -- ??킬진행방향????른?? +- checkAngle각도??내????들
            elseif searchType == 5 then
                if skillAngle + checkAngle -90 >= angle and skillAngle - checkAngle -90 <= angle then
                    -- 리밸런싱 스킬 계수화로 인한 대미지 비율 처리 변경 --
                    local spciRate = GetExProp(self, "SPCI_RATE_DAM");
                    SetExProp(self, "SPCI_RATE_DAM", spciRate + damageRate);
                    
--                    ForceDamage(self, skill, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    ForceSkillDamage(self, skill.ClassName, objList[i], target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
                    forceCount = forceCount + 1;
                end
            end
            

            if forceCount >= splitCnt then
                break;
            end
        end

        EndSyncPacket(self, key, delaySec); 

    end

end

function SKL_TOOL_KD(self, target, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)

    if isInverseAngle == 1 then
    hAngle = GetAngleTo(target, self);
    elseif isInverseAngle == 2 then
        hAngle = GetSkillDirByAngle(self);
    elseif isInverseAngle == 3 then
        hAngle = IMCRandom(0, 360);
    else
        hAngle = GetAngleTo(self, target);
    end

    -- ??다??면역 --        
    local kdDEF = target.KDArmorType; -- 몬스??의 ??다??아????급
    if kdRank > kdDEF then

        if knockType == 4 then
            KnockDown(target, self, power, hAngle, vAngle, bound);
        elseif knockType == 3 then
            KnockBack(target, self, power, hAngle, vAngle, bound);
        end     
    end
end

function S_R_DAMAGE_ADJUST(self, target, skill, ret, rate)
    local index = GetStructIndex(ret);
    index = index - skill.Level + 1;
    if index < 0 then
        index = 0;
    end

    local multiplyRatio = math.pow(rate, index);
    ret.Damage = ret.Damage * multiplyRatio;
end

function S_R_SPC_DEF_MULTI_DAMAGE(self, target, skill, ret, specialDef, count, delay)

    --local damage = SCR_LIB_ATKCALC_RH(self, skill);
    --local damage = ret.Damage
    local attribute = skill.Attribute
    local attackType = skill.AttackType
    local hitType = ret.HitType
    local resultType = ret.ResultType
    local skillName = skill.ClassName

    local damage = GET_SKL_DAMAGE(self, tgt, skillName);

    if damage == 0 then
        damage = SCR_LIB_ATKCALC_RH(self, skill);
    end

    
    if target.SpecialDefType == specialDef then
        if resultType == HITRESULT_BLOW then
            for i = 1, count do
                SetExProp(self, str, 1)         
                sleep(delay)
                TakeDamage(self, target, skill.ClassName, damage, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_NO_HITSCP);
                if i == count then
                    DelExProp(self, str)
                end
            end
        end
    end
end

function S_R_KNOCK_TARGET(self, target, skill, ret, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)

-- ret가 ??어???? ??는????기??ret????용??려????러가 ??

    if ret ~= nil then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        SKL_TOOL_KD(self, target, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
        EndSyncPacket(self, key, 0.1);  
    else
        SKL_TOOL_KD(self, target, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
    end
end

function S_R_SUPER_KNOCKBACK(self, target, skill, ret, kbPower, anim, spd, space, kbActorCount)
    
    SetKnockBackAttach(target, self, kbPower, anim, spd, space, kbActorCount);      
end

function S_R_SUPER_KNOCKBACK_ENDBUFF(self, target, skill, ret, buffName, lv, arg2, bfTime, over, percent, updateTime)
    
    SetKnockBackAttachEndBuff(target, self, buffName, lv, arg2, bfTime, over, percent, updateTime); 
end

function S_R_SUPER_KNOCKBACK_ENDLINK(self, target, skill, ret, linkBuffName, maxTime, linkTexture, linkingTime, linkEft, linkEftScale, linkSound)
    
    SetKnockBackAttachEndLink(target, self, linkBuffName, maxTime, linkTexture, linkingTime, linkEft, linkEftScale, linkSound); 
end

function S_R_KB_EFFECT(self, target, skill, ret, eft, scale, sound, eftSpace)
    SetKnockBackEffect(target, eft, scale, sound, eftSpace);
end

function S_R_KB_ANIM(self, target, skill, ret, anim, spd, space)
    SetKnockBackAnimation(target, anim, spd, space);
end

-- pc내앞으로 땡기기
function S_R_PULL_TARGET(self, target, skill, ret, frontDist, speed, accel, ignoreHoldMove, pullDelay, pulEft, pulEftScale)

    local targetType = GetObjType(target);
    if targetType == OT_MONSTERNPC and target.MonRank == 'Boss' then
        return;
    end
    if targetType == OT_MONSTERNPC and target.MoveType == 'Holding' then
        return
    end

    CancelMonsterSkill(target);
    StopMove(target);
    HOLD_MON_SCP(target, skill.ShootTime + 500);

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(target, key);

    local x, y, z = GetFrontPos(self, frontDist);

    if targetType == OT_MONSTERNPC then
        Move3D(target, x, y+5, z, speed, accel, ignoreHoldMove);

    elseif targetType == OT_PC then
        Move3D(target, x, y+5, z, speed, accel, ignoreHoldMove, 1);

    end
    EndSyncPacket(target, key, pullDelay);

end

function S_R_PULL_TARGET_CENTER(self, target, skill, ret, frontDist, speed, accel, ignoreHoldMove, pullDelay, pulEft, pulEftScale)
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(target, key);
    local list, cnt = SelectObjectNear(self, target, 100, "ENEMY");
    if cnt > 0 or cnt ~= nil then
        if cnt >= 8 then
            cnt = 8;
        end
        
        for i = 1, cnt do
            local targetMonRank = TryGetProp(list[i], "MonRank");
            local targetMoveType = TryGetProp(list[i], "MoveType");
            local x, y, z = GetFrontPos(target, frontDist);
            
            if targetMonRank ~= "Boss" then
                if targetMoveType ~= "Holding" then
                    CancelMonsterSkill(list[i]);
                    StopMove(list[i]);
                    HOLD_MON_SCP(list[i], 800);
                    Move3D(list[i], x, y, z, speed, accel, ignoreHoldMove);
                end
            elseif IS_PC(list[i]) == true then
                Move3D(list[i], x, y, z, speed, accel, ignoreHoldMove);
            end
        end
    end
    
    EndSyncPacket(target, key, pullDelay);
end

-- 광역 ??발 (몬스??의 ????????아??
function S_R_PROVOKE_TOPHATE(self, target, skill, ret, hateType, searchType, searchRange)

    local provoker = self;
    if hateType == 1 then
        -- 1 : ??신??게 ??????기
        provoker = self;
    elseif hateType == 2 then
        -- 2 : ??킬맞?? ??겟에????????기
        provoker = target;
    end

    local list, cnt = SelectObject(provoker, searchRange, searchType);
    
    for i = 1, cnt do
        local obj = list[i];
        
        if obj ~= provoker and obj ~= self and IS_PC(obj) ~= 1 then

        -- 몬스??의 ??어글???? ??아??후??그놈보다 120%????????팅??다
            
            local topAttacker = GetTopHatePointChar(obj);
            if topAttacker ~= nil then
                        
                local atkerHate = GetHate(obj, topAttacker);
                local myHate = GetHate(obj, provoker);
                
                if atkerHate > myHate then
                    local addHate = atkerHate * 0.2 + (atkerHate - myHate) + 100;
                    InsertHate(obj, provoker, addHate);
                end
            else                
                InsertHate(obj, provoker, 100);
            end
        end
    end
    
end

-- 몬스??faction 바꾸??
function S_R_CHANGE_MON_FACTION(self, target, skill, ret, changeFaction)

    if GetObjType(target) ~= OT_MONSTERNPC then
        return;
    end

    SetCurrentFaction(target, changeFaction);
end

-- ???? 증??/감소
function S_R_ADD_HATEPOINT(self, target, skill, ret, addHatePoint, resetHateType)

    -- ???? 리셋??는??보스??테????먹??도????둠.
    if target.MonRank ~= 'Boss' and resetHateType ~= 0 then

        
        if resetHateType == 1 then
            RemoveHate(target, self);
            return;

        elseif resetHateType == 2 then
            ResetHate(target);
            return;

        elseif resetHateType == 3 then          
            ResetHateAndAttack(target);
            return;
        end
    end

    InsertHate(target, self, addHatePoint);
end


--??이????랍
function S_R_ADD_DROP_ITEM(self, target, skill, ret, itemName, itemCount, probability)

    if probability == nil or probability > 100 then
        probability = 100
    end
    
    for i = 1 , itemCount do
        local random_item = IMCRandom(0, 100)
        if random_item <= probability then
            CREATE_DROP_ITEM(self, itemName, self)
        end
    end

end

function S_R_ADD_DROP_WOOD(self, target, skill, ret, itemCount, probability)

    if probability == nil or probability > 100 then
        probability = 100
    end
    
    for i = 1 , itemCount do
        local random_item = IMCRandom(0, 100)
        if random_item <= probability then
            local itemName = "wood_06";
            
            CREATE_DROP_ITEM(self, itemName, self)
        end
    end

end


function S_R_RANDOM_GUARD(self, target, skill, ret, maxRandom, baseRate, skillName, skillRate)

    if IsSameActor(self, target) == 'YES' then
        return;
    end

    local random = IMCRandom(0, maxRandom);
    local rate = baseRate;

    if skillName ~= 'None' then
        local haveSkill = GetSkill(target, skillName);
        if haveSkill ~= nil then
            rate = rate + haveSkill.Level * skillRate;
        end
    end

    -- ??율????어가??가??로 ??팅
    if rate > random then
        ret.Damage = 0;
        ret.HitType = HIT_GUARD;
        ret.ResultType = HITRESULT_BLOCK;
        ret.HitDelay = 0;
    end
    
end

function S_R_BEATTACKED_COUNT_REMOVE_BUFF(self, target, skill, ret, baseCount, skillName, skillRate, removeBuffName)

    if IsSameActor(self, target) == 'YES' then
        return;
    end
    
    -- 버프??으??무시
    local haveBuff  = GetBuffByName(target, removeBuffName);
    if haveBuff == nil then
        return;
    end

    -- 기?? ??격카운??
    local count = baseCount;
    local haveSkill = GetSkill(target, skillName);
    if haveSkill ~= nil then
        count = count + haveSkill.Level * skillRate;
    end
    
        
    -- 공격??한 카운??
    local attackedCount = tonumber( GetExProp(haveBuff, "ATTACKED_COUNT_"..removeBuffName) );
    SetExProp(haveBuff, "ATTACKED_COUNT_"..removeBuffName, attackedCount + 1);
    
    -- 버프??거 체크
    if count <= attackedCount + 1 then
        RemoveBuff(target, removeBuffName);
    end
end



-- pc??으??몬스????혼 ??겨??기
function S_R_PULL_TARGET_OOBE(self, target, skill, ret)


    local isMonOOBE = GetExProp(target, 'MON_OOBE');    
    if isMonOOBE == 1 then
        return;
    end
        
    local monObj = CreateGCIES('Monster', target.ClassName);
    if monObj == nil then
        return;
    end

    monObj.BTree = "None";
    monObj.Name = target.Name;
    monObj.Lv = target.Lv;
    local layer = GetLayer(target); 
    local x, y, z = GetPos(target);
    local angle = GetAngleTo(target, self);
    local mon = CreateMonster(self, monObj, x, y+2, z, angle, 1, 0, layer);
    if mon == nil then
        return;
    end
    
    -- ??단?? ????체??뽑으??죽을??까지 ??체??탈????태????도??????mon??체모두 flag 1????팅
    SetExProp(target, 'MON_OOBE', 1);
    SetExProp(mon, 'MON_OOBE', 1);

    ObjectColorBlend(mon, 100, 200, 255, 100, 1, 0.1);
    SetCurrentFaction(mon, GetCurrentFaction(target));
    
    SetMonOwnerOOBE(mon, target);   -- ??미?? ??을??본체??테 ??달??주??flag??팅 

    x, y, z = GetFrontPos(self, 10);
    local speed = 0;
    local accel = 300;
    Move3D(mon, x, y+3, z, speed, accel, 1);
    
    

end

function S_R_SET_TARGET(self, target, skill, ret)
    ClearHardSkillTarget(self);
    AddHardSkillTarget(self, target);
end

function S_R_SET_TARGET_RANGE(self, target, skill, ret, range, maxCount)

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectNear(self, target, range, 'ENEMY');
    cnt = math.min(maxCount, cnt);
    for i = 1, cnt do
        local obj = list[i];
        AddHardSkillTarget(self, obj);
    end

end


function S_R_TGT_BUFF(self, target, skill, ret, buffName, lv, arg2, applyTime, over, rate)
    local tgtList = GetHardSkillTargetList(self);
    --print(self, target, skill)
    if #tgtList > 0 then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        for i = 1 , #tgtList do
            local target = tgtList[i];
            ADDBUFF(self, target, buffName, lv, arg2, applyTime, over, rate);
        end

        EndSyncPacket(self, key, 0);
    end
end

function S_R_KB_ADD_DAMAGE(self, target, skill, ret, dmgRate, hitType, resultType)
    
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);

    local damage = SCR_LIB_ATKCALC_RH(self, skill);
    damage = damage * dmgRate;

    TakeKBDamage(self, target, damage, hitType, resultType, 1);
    EndSyncPacket(self, key, 0);
end

function S_R_KB_COLL_DAMAGE(self, target, skill, ret, dmgRate, hitType, resultType, searchRange, splashDamage, sr)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);

    local damage = SCR_LIB_ATKCALC_RH(self, skill);
    damage = damage * dmgRate;
    AddCollisionDamage(self, target, damage, hitType, resultType, skill.ClassName);
    EndSyncPacket(self, key, 0);
end

function S_R_KD_COLL_DAMAGE(self, target, skill, ret, dmg, hitType, resultType, searchRange, splashDmgRate, sr)

    if IS_PC(target) ~= true and (target.HPCount > 0 or target.KDArmor > 900) then
        return ;
    end

    local key = GetSkillSyncKey(self, ret); 
    StartSyncPacket(self, key); 
    AddKDDamage(self, target, dmg, hitType, resultType);
    SetKDSplashDamage(self, target, skill.ClassName, searchRange, splashDmgRate, sr);
    EndSyncPacket(self, key, 0);
end

function S_R_KB_BOUNCE(self, target, skill, ret)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    SetUseKbBounceCalc(target, 1);
    EndSyncPacket(self, key, 0);
end

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function S_R_SPIN_OBJECT(self, target, skill, ret, spinDelay, spinCount, rotSecond, velocityChangeTerm, sleepTime, buff)    
    if target.Size ~= "XL" then        
        if skill.ClassName == 'Musketeer_HeadShot' then
            spinCount = spinCount * 1000;
            spinCount = GetDiminishingMSTime(target, self, spinCount, 0, skill.ClassID, 0)
            spinCount = toint(spinCount / 1000)
            if spinCount == 0 then
                PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("HeadShot_Spin_Immune"))
            end
        end

        if spinCount ~= 0 then            
            CancelMonsterSkill(target);
            local key = GetSkillSyncKey(self, ret);
            StartSyncPacket(self, key);       

            SpinObject(target, spinDelay, spinCount, rotSecond, velocityChangeTerm);
            if target.ClassName ~= 'PC' then
                HoldMonScp(target);
            end
            EndSyncPacket(self, key, 0);
        
            sleep(sleepTime);
        
            AddBuff(self, target, buff);
            
            if target.ClassName ~= 'PC' then
                UnHoldMonScp(target);
            end
        end
    end
end


function S_R_TGT_PAD(self, target, skl, ret, targetType, angle, padName, percent)
    
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
end

function S_R_HP_VAMP(self, target, skl, ret, ratio)
    local healValue = ret.Damage * ratio;
    
    local Featherfoot1_abil = GetAbility(self, "Featherfoot1")
    if Featherfoot1_abil ~= nil and skl.Level >= 3 then
        healValue = healValue + Featherfoot1_abil.Level
    end
    
    healValue = math.floor(healValue)
    
    Heal(self, healValue, 0, ret);
    
    SkillTextEffect(nil, self, target, "VAMP_HP", healValue, item);
end

function S_R_TGT_COMBINATION(self, target, skl, ret)

    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
        return;
    end
    
    RunScript("_HAWK_COMBINATION", hawk, self, target, skl);
end



function S_R_SPEND_SP(self, target, skl, ret, spendSP, abilName, func)
    if abilName ~= nil and abilName ~= 'None' and abilName ~= '' then
        if GetAbility(self, abilName) == nil then
            return;
        end
    end
    
    if spendSP > TryGetProp(self, 'SP') then
        if func ~= nil and func ~= 'None' and func ~= '' then
            _G[func](self, target, skl, ret, spendSP, abilName);
        end
        return;
    end
    
    AddSP(self, -spendSP);
end

function S_R_MOVE_JUMP(self, target, skl, ret, jumpHeight, distance, angle, spdChangeRate, time1, easing1, time2, easing2)
	SKL_MOVE_JUMP(self, skl, jumpHeight, distance, angle, spdChangeRate, time1, easing1, time2, easing2)
end