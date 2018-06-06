--padskill.lua

function PAD_OWNER_ENTER_LOCK(self, skl, pad)
    SetUseableCheckFunc(pad, 'SCR_DONT_ENTER_PAD_OWNER');
end

function PAD_IS_PC_FULL_HP(self, skl, pad)
    SetUseableCheckFunc(pad, 'SCR_IS_PC_FULL_HP');
end

function SCR_DONT_ENTER_PAD_OWNER(owner, pad, target)

    if IsSameActor(owner, target) == "YES" then
        return 0;
    end

    return 1;
end

function PAD_CEHCK_OWNER_BUFF(self, skl, pad, buffName)
    if "YES" == IsBuffApplied(self, buffName) then
        return;
    end
    
    SKL_CANCEL_CANCEL(self, skl);
    AddPadLife(pad, 0);
    AddPadUseCount(pad, 0);
end

function PAD_USEABLE_RELATION_ENEMY(self, skl, pad)
    SetUseableCheckFunc(pad, "SCR_PAD_USEABLE_RELATION_ENEMY_CHECK");
end

function SCR_PAD_USEABLE_RELATION_ENEMY_CHECK(self, pad, target)
    local relationCheck = GetRelation(self, target);
    if relationCheck == "ENEMY" then
        return 1;
    end
    
    return 0;
end

function PAD_USEABLE_RELATION_FRIEND(self, skl, pad)
    SetUseableCheckFunc(pad, "SCR_PAD_USEABLE_RELATION_FRIEND_CHECK");
end

function SCR_PAD_USEABLE_RELATION_FRIEND_CHECK(self, pad, target)
    local relationCheck = GetRelation(self, target);
    if relationCheck == "FRIEND" then
        return 1;
    end
    
    return 0;
end

function PAD_USEABLE_FUNCNAME(self, skl, pad, funcName)
    SetUseableCheckFunc(pad, funcName);
end

function PAD_ADD_LIFE(self, skl, pad, lifeValue, useCount)

    AddPadLife(pad, lifeValue);
    AddPadUseCount(pad, useCount);
end

function PAD_OBJ_COPY_CHECK_ABIL(self, skl, pad, range, abilName, funcName)
    local abil = GetAbility(self, abilName)
    if nil == abil then
        return;
    end

    local x, y, z = GetPadPos(pad);
    RunScript('PAD_OBJ_COPY_CREATE', self, skl, x, y, z, funcName, abil.Level * 2, range);
end

function PAD_OBJ_COPY_CREATE(self, skl, x, y, z, funcName, maxCnt, range)
    local func = _G[funcName];
    local copyList, sklList, effList = func();
    local crateCnt = 0;

    DelExProp(self, 'COPY_MON_HANDLE_Sapper_StakeStockades');
    DelExProp(self, 'COPY_MON_HANDLE_Cryomancer_IceWall');


    for i = 1, #copyList do
        local list = SelectObjectByClassName(self,  x, y, z, range, copyList[i], 1);
        for j = 1, #list do
            local mon = list[j]
            if GetExProp_Str(mon, 'COPY_EFFECTNAME') == 'None' then
                SetExProp_Str(mon, 'COPY_EFFECTNAME', effList[i])
                SetTargetDuplication(mon, self);
                local sklLevel = GetExProp(mon, 'COPY_SKLLEVEL');
                if "QuarrelShooter_ScatterCaltrop" == sklList[i] or "Cryomancer_IceWall" ==  sklList[i] or "Inquisitor_PearofAnguish" ==  sklList[i] then
                    sklLevel = 1;
                end

                if 1 == MonsterUsePCSkill(mon, sklList[i], sklLevel, 1, nil, 0, 1) then
                    crateCnt = crateCnt + 1;
                    if "Sapper_StakeStockades" == sklList[i] or "Cryomancer_IceWall" ==  sklList[i] or "Kriwi_Aukuras" == sklList[i] then
                        SetExProp(self, 'COPY_MON_HANDLE_'..sklList[i], GetHandle(mon));
                    end
                    if crateCnt >= maxCnt then
                        return;
                    end
                else
                    DelExProp(self, 'COPY_MON_HANDLE_'..sklList[i]);
                    SetExProp_Str(mon, 'COPY_EFFECTNAME', 'None');
                    SetTargetDuplication(mon, nil);
                end
                sleep(500);
            end
        end
    end
end


function PAD_SET_ARG_NUMBER(self, skl, pad, argValue1, argValue2, argValue3)

    SetPadArgNumber(pad, 1, argValue1);
    SetPadArgNumber(pad, 2, argValue2);
    SetPadArgNumber(pad, 3, argValue3);
    
end

function PAD_DESTROY_EFFECT_BLENDTIME(self, skl, pad, blendTime)
    SetDestroyEffectBlendTime(pad, blendTime);
end

function PAD_CONCURRENT_USE_COUNT(self, skl, pad, useCount)
    SetConcurrentPadUseCount(pad, useCount);
end

function PAD_ADD_CHECKER(self, skl, pad, range1, time1, range2, time2)

    AddPadCheckerRange(pad, range1, time1, range2, time2);
end

function PAD_CHECKER_ADD_RANGE(self, skl, pad, range)
    ChangePadRange(pad, range)
end

function PAD_TGT_CHANGE_EFF(self, skl, pad, target, tgtRelation, effName, scale)

    if IS_APPLY_RELATION(self, target, tgtRelation) then
        ChangePadEffect(pad, effName,scale);
    end
end

function PAD_SKLEXP_EFFECT(self, skl, pad, buffName, sklExpEffectType, nodeName)

    local objList, cnt = GetPadObjectList(pad);
    for i = 1 , cnt do
        local target = objList[i];
        if IsBuffApplied(target, buffName) then
            PlaySklExpEffect(self, target, sklExpEffectType, nodeName);
        end
    end

end

function PAD_HEAL_FRIENDS_BY_POS(self, skl, pad, atkRate, consumeLife, useCount)
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    local list, cnt = SelectObject(self, 100, 'ALL', 1);
    local pvpCmd = nil; 
    if IsPVPServer(self) == 1 then
        pvpCmd = GetMGameCmd(self);
    end

    local damage = SCR_LIB_ATKCALC_RH(self, skl)
    local addHp = damage * atkRate;         

    for i = 1 , cnt do
        local target = list[i];
        if GetRelation(self, target) ~= "ENEMY" then
            Heal(target, addHp, 0);
            AddPadLife(pad, consumeLife);           
            AddPadUseCount(pad, useCount);

            if pvpCmd ~= nil and GetObjType(target) == OT_MONSTERNPC and target.ClassName == "GuildTower_PVP" then
                local teamID = GetExProp(target, "TEAM_ID");
                local hpPercent = GET_HP_PERCENT(target);
                pvpCmd:SetUserValue("TowerHP_" .. teamID, hpPercent, true);
                cmd:AddUserValue("TowerHPCount_" .. teamID, addHp, 0, false);
            end

            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end

        end
    end
end

function PAD_HEAL_FRIENDS(self, skl, pad, atkRate, consumeLife, useCount)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if GetRelation(self, target) ~= "ENEMY" then
            local damage = SCR_LIB_ATKCALC_RH(self, skl);           
            Heal(target, damage * atkRate, 0);
            AddPadLife(pad, consumeLife);           
            AddPadUseCount(pad, useCount);

            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end
    end

end

function PAD_DAMAGE_ENEMY_GRASSAREA(self, skl, pad, ratio, monCount, consumeLife, useCount, eft, eftScale, lifeTime, delay)

    local objList, objCnt = GetPadObjectList(pad);
    
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end
    
    if monCount == nil or monCount < 1 then
        monCount = 1;
    end
    
    if objCnt > monCount then
        objCnt = monCount;
    end
    
    local isAttack = 0;
    
    for i = 1 , objCnt do
        local target = objList[i];
        if GetRelation(self, target) == "ENEMY" and IsDead(target) == 0 and IsHideFromMon(target) ~= 1 then
            local x, y, z = GetPos(target)
            local isGrassArea = IsGrassSurface(target, x, y, z)
            if isGrassArea ~= nil and isGrassArea == 1 then
            
                local damage = SCR_LIB_ATKCALC_RH(self, skill)
                TakeDamage(self, target, skl.ClassName, damage);
                isAttack = 1;
                
                if eft ~= nil and eft ~= 'None' then
                    local x, y, z = GetPos(target);
                    PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
                end
            end
        end
    end
    
    if isAttack == 1 then
        AddPadLife(pad, consumeLife);
        AddPadUseCount(pad, useCount);
    end
--    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
--        break;
--    end
end

function PAD_DAMAGE_ENEMY(self, skl, pad, ratio, consumeLife, useCount, eft, eftScale, lifeTime, delay, enemy)

    local ignoreHideActor = 1;  
    local objList, cnt = GetPadObjectList(pad, enemy, ignoreHideActor);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end
    
    local sklType, sklName, sklLv = GetCreatedPadSkillInfo(pad);
    local damage = GET_SKL_DAMAGE(self, nil, sklName)
            
    if sklName == 'Mon_boss_molich_Skill_5' then
        ratio = skill.SkillFactor / 100;
    end

    for i = 1 , cnt do
        local target = objList[i];
        local targetOwner = target;
        if target.ClassName == "hidden_monster2" then
            local handle = GetExProp(target, 'CASTER_HANDLE');
            if handle ~= nil then
                targetOwner = GetByHandle(self, handle);
            end
        end

        if targetOwner ~= nil and GetRelation(self, targetOwner) == "ENEMY" and IsDead(targetOwner) == 0 and IsSafe(target) == 'NO' then        
            TakeDamage(self, target, sklName, damage * ratio);
            
            if eft ~= nil and eft ~= 'None' then
                local x, y, z = GetPos(target);
                PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
            end

            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);  
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                break;
            end
        end
    end
end

function PAD_SPLASH_DAMAGE_ENEMY(self, skl, pad, ratio, range, monCount, consumeLife, useCount, eft, eftScale, lifeTime, delay, attackEft, attackEftScale, enemy)
    
    local ignoreHideActor = 1;  
    local objList, cnt = GetPadObjectList(pad, enemy, ignoreHideActor);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end
    
    local sklType, sklName, sklLv = GetCreatedPadSkillInfo(pad);
    local damage = GET_SKL_DAMAGE(self, nil, sklName)
            
    if sklName == 'Mon_boss_molich_Skill_5' then
        ratio = skill.SkillFactor / 100;
    end

    for i = 1 , cnt do
        local target = objList[i];
        local targetOwner = target;
        if target.ClassName == "hidden_monster2" then
            local handle = GetExProp(target, 'CASTER_HANDLE');
            if handle ~= nil then
                targetOwner = GetByHandle(self, handle);
            end
        end
        
        if targetOwner ~= nil and GetRelation(self, targetOwner) == "ENEMY" and IsDead(targetOwner) == 0 then
            TakeDamage(self, target, sklName, damage * ratio);
            
            if eft ~= nil and eft ~= 'None' then
                local x, y, z = GetPos(target);
                PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
            end
            
            if attackEft ~= nil and attackEft ~= 'None' then
                PlayEffect(target, attackEft, attackEftScale);
            end
            
            local nearTarget, nearCnt = SelectObjectNear(self, target, range, "ENEMY");
            if nearCnt >= 1 then
                for j = 1, math.min(nearCnt, monCount - 1) do
--                    local nearTargetOwner = nearTarget[j];
--                    if nearTarget[j].ClassName == "hidden_monster2" then
--                        local handle = GetExProp(nearTarget[j], 'CASTER_HANDLE');
--                        if nearHandle ~= nil then
--                            nearTargetOwner = GetByHandle(self, nearHandle);
--                        end
--                    end
                    
--                    if nearTargetOwner ~= nil and GetRelation(self, nearTargetOwner) == "ENEMY" and IsDead(nearTargetOwner) == 0 and IsSameObject(nearTarget[j], target) == 0 then
                    if GetRelation(self, nearTarget[j]) == "ENEMY" and IsDead(nearTarget[j]) == 0 and IsSameObject(nearTarget[j], target) == 0 then
                        TakeDamage(self, nearTarget[j], sklName, damage * ratio);
                    end
--                    end
                end
            end

            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);  
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                break;
            end
        end
    end
end

function PAD_DAMAGE_ENEMY_SAMETIME_COUNT(self, skl, pad, atkCount, ratio, consumeLife, useCount, eft, eftScale, lifeTime, delay)

    local objList, cnt = GetPadObjectList(pad);
    local padUpdateTerm = GetPadUpateTerm(pad) / 1000;  

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end

    
    local damage = GET_SKL_DAMAGE(self, skill, skill.ClassName)

    for i = 1 , cnt do
        local target = objList[i];
        if GetRelation(self, target) == "ENEMY" and IsDead(target) == 0 and IsHideFromMon(target) ~= 1 then

            local index = GetExProp(target, 'PADHIT_INDEX_'..skill.ClassName);
            local time = GetExProp(target, 'PADHIT_TIME_'..skill.ClassName);
            
            if time + padUpdateTerm < imcTime.GetAppTime() then
                
                if index < atkCount then
                    TakeDamage(self, target, skill.ClassName, (damage * ratio) + skill.SkillAtkAdd);
                    
                    SetExProp(target, 'HIT_PAD_'..skill.ClassName, imcTime.GetAppTime());
                    SetExProp(target, 'PADHIT_INDEX_'..skill.ClassName, index + 1);
                    if eft ~= nil and eft ~= 'None' then
                        local x, y, z = GetPos(target);
                        PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
                    end
                    
                    if target.Size == "S" then
                        useCount = -1
                    elseif target.Size == "M" then
                        useCount = -2
                    else
                        useCount = -3
                    end
                    
                    if target.Attribute == "Ice" then
                      useCount = -100
                    end

                    AddPadLife(pad, consumeLife);
                    AddPadUseCount(pad, useCount);  
                    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                        break;
                    end
                else
                    SetExProp(target, 'PADHIT_TIME_'..skill.ClassName, imcTime.GetAppTime());
                    SetExProp(target, 'PADHIT_INDEX_'..skill.ClassName, 0);
                end
            end                     
        end
    end
end

function PAD_DAMAGE_ENEMY_ONETIME_COUNT(self, skl, pad, atkCount, ratio, consumeLife, useCount, eft, eftScale, lifeTime, delay)
    local objList, cnt = GetPadObjectList(pad);
    if cnt == nil or cnt == 0 then
        return;
    end
    
    local padUpdateTerm = GetPadUpateTerm(pad) / 1000;
    
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end
    
    local damage = GET_SKL_DAMAGE(self, skill, skill.ClassName);
    
    local isAttack = 0;
    local index = 0;
    for i = 1 , cnt do
        local target = objList[i];
        if GetRelation(self, target) == "ENEMY" and IsDead(target) == 0 and IsHideFromMon(target) ~= 1 then
            local time = GetExProp(target, 'PADHIT_TIME_'..skill.ClassName);
            local handle = GetExProp(target, 'PADHIT_HANDLE_'..skill.ClassName);
            if time + padUpdateTerm <= imcTime.GetAppTime() or handle == GetHandle(self) then
                if index < atkCount then
                    TakeDamage(self, target, skill.ClassName, (damage * ratio) + skill.SkillAtkAdd);
                    isAttack = 1;
                    index = index + 1;
                    
                    SetExProp(target, 'PADHIT_TIME_'..skill.ClassName, imcTime.GetAppTime());
                    SetExProp(target, 'PADHIT_HANDLE_'..skill.ClassName, GetHandle(self));
                    
                    if eft ~= nil and eft ~= 'None' then
                        local x, y, z = GetPos(target);
                        PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
                    end
                else
                    break;
                end
            end
        end
    end
    
    if isAttack == 1 then
        
        AddPadLife(pad, consumeLife);
        AddPadUseCount(pad, useCount);
    end
end

function IS_APPLY_RELATION(self, target, tgtRelation)

    if tgtRelation == "ALL" then
            return true;
    end
    
    if tgtRelation == "PARTY" then
        local owner = GetOwner(self);
        local partyMember = self;
        if owner ~= nil then
             partyMember = owner;
        else
            local saveObj = GetExArgObject(self, "SaveOwner");
            if nil ~= saveObj then
                partyMember = saveObj;
            end
        end

        local list, cnt = GET_PARTY_ACTOR_BY_SKILL(partyMember, 0)
        local index;
                
        if cnt > 0 then
            for index = 1, cnt do
                if IsSameActor(target,list[index]) == 'YES' and 
                GetRelation(partyMember, list[index]) ~= "ENEMY" then
                    return true;
                end
            end
        end

        return false;

    end

    if tgtRelation == "FRIEND" then
        if target.ClassName == "PC" and GetRelation(self, target) ~= "ENEMY" then
            return true;
        end

        return false; -- ???????? ?????? ????????? ????? ???? ?????? ???. ???? ???.
    end

    if tgtRelation == "NEUTRAL"  then
        if GetRelation(self, target) == "ENEMY" then
            return false;
        end

        return true;
    end

    if tgtRelation == "GUILD" then
        local owner = GetOwner(self);
        local partyMember = self;
        if owner ~= nil then
             partyMember = owner;
        else
            local saveObj = GetExArgObject(self, "SaveOwner");
            if nil ~= saveObj then
                partyMember = saveObj;
            end
        end
        if IsPVPServer(self) == 1 then  
            local partyMemberEtc = GetETCObject(partyMember);
            local targetEtc = GetETCObject(target);
            if nil ~= partyMemberEtc and nil ~= targetEtc and partyMemberEtc.Team_Mission == targetEtc.Team_Mission then
                return true;
            end
        end

        local list, cnt = GET_GUILD_ACTOR_BY_SKILL(partyMember, 0)
        local index;
                
        if cnt > 0 then
            for index = 1, cnt do
                if IsSameActor(target,list[index]) == 'YES' then
                    return true;
                end
            end
        end

        return false;

    end

    if tgtRelation == "ENEMY" and GetObjType(self) == OT_PC and GetObjType(target) == OT_PC and GetRelation(self, target) == tgtRelation then
        return true;
    end

    if GetRelation(self, target) == tgtRelation and IsHideFromMon(target) ~= 1 then
        return true;
    end

    return false;
end


function IS_APPLY_RELATION_MON(self, target, tgtRelation)

    if tgtRelation == "ALL" then
        return true;
    end
    
    if tgtRelation == "FRIEND" then
        if GetCurrentFaction(target) == "Monster" then
            return true;
        end

        return false; -- ???????? ?????? ????????? ????? ???? ?????? ???. ???? ???.
    end

    if tgtRelation == "NEUTRAL" then
        if GetRelation(self, target) == "ENEMY" then
            return false;
        end

        return true;
    end

    if GetRelation(self, target) == tgtRelation then
        return true;
    end

    return false;


end

function PAD_CHECK_ABLI_AND_RUNSCRIP(self, skl, pad, abilName, scpName, argNum1, argNum2, argNum3, argNum4)
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    local abil = GetAbility(self, abilName)
    if nil == abil then
        return;
    end

    local fuc = _G[scpName];
    -- 아군에게
    fuc(self, skl, pad, argNum1, abil.Level * argNum2, argNum3, abil.Level * argNum4);
end

function PAD_DECREASE_LIFE_TIME(self, skl, pad, relationBit, addTime, range, padCount)
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    local x, y, z = GetPadPos(pad);
    local list = SelectPad(self, 'ALL', x, y, z, range, "ALL", relationBit);
    if #list == 0 then
        return;
    end

    local maxCnt = math.min(#list, padCount);

    for i = 1, maxCnt do
        local padCls = list[i];
        if GetPadUserValue(padCls, skl.ClassName) == 0 then
            AddPadLife(padCls, addTime);
            SetPadUserValue(padCls, skl.ClassName, 1);
        end
    end
end

function PAD_BUFF_GRASS_AREA(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

    local objList, cnt = GetPadObjectList(pad);
    
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then
            
            local x, y, z = GetPos(target)
            local isGrassArea = IsGrassSurface(target, x, y, z)
            if isGrassArea == 1 then
            
                ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);               
                AddPadLife(pad, consumeLife);
                AddPadUseCount(pad, useCount);
                if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                    return;
                end
            end
        end
    end

end


function PAD_BUFF_CHECK_BUFF_ENEMY(self, skl, pad, tgtRelation, consumeLife, useCount, checkBuffName, buffName, lv, arg2, applyTime, over, rate)
    local objList, cnt = GetPadObjectList(pad);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then
            if IsBuffApplied(target, checkBuffName) == "NO" then
                ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);           
                AddPadLife(pad, consumeLife);
                AddPadUseCount(pad, useCount);
                if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                    return;
                end
            end
        end
    end
end

function PAD_BUFF_ENEMY(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)    
    local objList, cnt = GetPadObjectList(pad);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
     
    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then            
            if buffName == 'SadhuBind_Debuff' then
                local immune = IsBuffApplied(target, 'SadhuPossessionTemporaryImmune')
                local isAppliedBuff = IsBuffApplied(target, buffName)
                if isAppliedBuff == "NO" and immune == "NO" then
                    local elapsedTime = (imcTime.GetAppTimeMS() - GetExProp(skl, 'Sadhu_Bind_StartTime')) / 1000
                    applyTime = 6500 - elapsedTime
                    ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);                                        
                end
                if immune == "YES" then
                   PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("SHOW_GUNGHO")) 
                end
            else
                ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
            end
                       
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end
    end
end

function PAD_BUFF_ENEMY_BOSSCHECK(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, bossCheck)
    if bossCheck == nil then
        bossCheck = 0;
    end
    
    local objList, cnt = GetPadObjectList(pad);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then            
            if bossCheck == 0 or TryGetProp(target, "MonRank") ~= 'Boss' then
                if buffName == 'SadhuBind_Debuff' then
                    local immune = IsBuffApplied(target, 'SadhuPossessionTemporaryImmune')
                    local isAppliedBuff = IsBuffApplied(target, buffName)
                    if isAppliedBuff == "NO" and immune == "NO" then
                        local elapsedTime = (imcTime.GetAppTimeMS() - GetExProp(skl, 'Sadhu_Bind_StartTime')) / 1000
                        applyTime = 6500 - elapsedTime
                        ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);                                        
                    end
                    if immune == "YES" then
                       PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("SHOW_GUNGHO")) 
                    end
                else
                    ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
                end
                           
                AddPadLife(pad, consumeLife);
                AddPadUseCount(pad, useCount);
                if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                    return;
                end
            end
        end
    end
end


function PAD_BUFF_ENEMY_MON(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
                    
            ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end
    end

end


function PAD_REMOVEBUFF_ENEMY(self, skl, pad, tgtRelation, consumeLife, useCount, buffName)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then
            
            RemoveBuff(target, buffName);
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end
    end

end

function PAD_REMOVEBUFF_ENEMY_MON(self, skl, pad, tgtRelation, consumeLife, useCount, buffName)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
            
            RemoveBuff(target, buffName);
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end
    end

end

function PAD_CRE_MON(self, skl, pad, className, x, y, z, angle, lvFix, lifeTime, monProp, eft, eftScale, own, simpleAi, initScript, isPadSelect, scpName)
    local copingHandle = GetExProp(self, 'COPY_MON_HANDLE_'..skl.ClassName)
    if 0 < copingHandle then
        local copingMon = GetByHandle(self, copingHandle)
        if nil ~= copingMon then
            self = copingMon;
        end
    end

    local mon1obj = CreateGCIES('Monster', className);
    if mon1obj == nil then
        return nil;
    end
    
    local lv = self.Lv;
    lv = lv + lvFix;
    mon1obj.Lv = lv;

    local range = 1;
    local layer = GetLayer(self);

    ApplyPropList(mon1obj, monProp, self, skl);

    local mon1 = CreateMonster(self, mon1obj, x, y, z, angle, range, 0, layer);
    if mon1 == nil then
        return nil;
    end

    if own == 1 then
        SetOwner(mon1, self, 1);
        SetCurrentFaction(mon1, GetCurrentFaction(self));
    else
        SetExProp(mon1, 'OWNER_HANDLE', GetHandle(self));
    end

    SetExProp(mon1, 'COPY_SKLLEVEL', skl.Level);

    if simpleAi ~= nil and simpleAi ~= "None" then
        RunSimpleAI(mon1, simpleAi);
    end

    if lifeTime > 0 then
        SetLifeTime(mon1, lifeTime);
    end

    if eft ~= "None" then
        AttachEffect(mon1, eft, eftScale);
    end

    AddPadMonster(pad, mon1);
    local padID = GetPadID(pad);
    SetExProp(mon1, 'PAD_ID', padID);
    SetExArgObject(mon1,"SUMMONER",self);

    -- 졸리로저 깃발이 콤보 관리를 하기 위해서 깃발의 핸들을 저장시킴
    if skl.ClassName == 'Corsair_JollyRoger' then
        SetPadUserValue(pad, 'PAD_MON_HANDLE', GetHandle(mon1));
    end

    if initScript ~= "None" then
        initScript = _G[initScript];
        initScript(mon1);
    end

    if isPadSelect == 1 then
        SetHideFromMon(mon1, 1)
    end

    if mon1 ~= nil and scpName ~= nil then
        local func = _G[scpName];
        func(mon1, self, skl);
    end

    return mon1;
end

function PAD_REMOVEBUFF_G_ENEMY(self, skl, pad, tgtRelation, consumeLife, useCount, group1, group2, lv)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then
            
            RemoveBuffGroup(target, group1, group2, lv);
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end

    end
end

function PAD_REMOVEBUFF_G_ENEMY_MON(self, skl, pad, tgtRelation, consumeLife, useCount, group1, group2, lv)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
            
            RemoveBuffGroup(target, group1, group2, lv);
            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);
            if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                return;
            end
        end

    end
end






function PAD_TGT_ABIL_BUFF_REMOVE(self, skl, pad, target, abilName, tgtRelation, consumeLife, useCount, buffName)

    local abil = GetAbility(self, abilName);

    if abil == nil then
        return;
    end

    if IS_APPLY_RELATION(self, target, tgtRelation) then
        RemoveBuff(target, buffName);

        AddPadLife(pad, consumeLife);
        AddPadUseCount(pad, useCount);
    end
end





function PAD_CLEAR_LAPSED_TGT(self, skl, pad, target, tgtRelation, consumeLife)

    local pccount = GetExProp(self, skilName .. "_LAPSED_COUNT");
    
    for i = 1 , pccount do  
        ClearExArgObject(self, skilName .. "_LAPSED_OBJ_" .. i);
    end

    SetExProp(self, skilName .. "_LAPSED_COUNT", 0);

end


function PAD_SAVE_LAPSED_TGT(self, skl, pad, target, tgtRelation, consumeLife, useCount)

    if IS_APPLY_RELATION(self, target, tgtRelation) then

        local skilName = skl.ClassName;

        local pccount = GetExProp(self, skilName .. "_LAPSED_COUNT");

        if pccount ~= nil then
            SetExArgObject(self, skilName .. "_LAPSED_OBJ_" .. pccount, target);
            SetExProp(self, skilName .. "_LAPSED_COUNT", pccount+1);
        else
            pccount = 0;
            SetExArgObject(self, skilName .. "_LAPSED_OBJ_" .. pccount, target);
            SetExProp(self, skilName .. "_LAPSED_COUNT", pccount+1);
        end

        AddPadLife(pad, consumeLife);
        AddPadUseCount(pad, useCount);
    end
    
end



function PAD_TGT_BUFF_BASED_ON_SURROUNDED_PAD(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

    local tempbool = UpdateSurroundedPadPos(self,skl);

    if tempbool == 1 then
        local fndList, fndCount = SelectObject(self, 300, 'ALL');
        if fndCount > 0 then
            
            for i = 1, fndCount do
                if IS_APPLY_RELATION(self, fndList[i], tgtRelation) then
                    local x, y, z = GetPos(fndList[i]);
                    
                    local resu = IsInSurroundedPadArea(self, skl, x, y, z);
            
                    if IsInSurroundedPadArea(self, skl, x, y, z) == 1 then
                        ADDPADBUFF(self, fndList[i], pad, buffName, lv, arg2, applyTime, over, rate);
                        AddPadLife(pad, consumeLife);
                        AddPadUseCount(pad, useCount);
                        if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
                            return;
                        end
                    end
                end
            end
        end
    end

end

function PAD_CONTROL(self, skl, pad, tgtRelation, x, y, z, radius, padReverse)
    local list = SelectPad(self, 'ALL', x, y, z, radius);

    for i = 1 , #list do
        local pad = list[i];
        local padOwner = GetPadOwner(pad);
        if padOwner ~= nil then
            if GetRelation(self, padOwner) == tgtRelation then
                local skillID, skillName, SkillLv = GetCreatedPadSkillInfo(pad);
                local padSkill = GetSkill(self, skillName);
                if padSkill == nil then
                    AddInstSkill(self, skillName);
                    padSkill = GetSkill(self, skillName);
                    if padSkill ~= nil then
                        SetPadParent(pad, self, 1);
                    end
                else
                    SetPadParent(pad, self, 1); 
                end
            end
        end
    end
    return
end

function PAD_MOVE_NEAR_ENEMY(self, skl, pad, tgtRelation, searchRange, speed, accel, destroyArrival)

    local objList, objListCount = SelectObjectByPad(pad, tgtRelation, searchRange);
    for i = 0 , objListCount do 
        local target = objList[i];
        if target ~= nil then       
            local x, y, z = GetPos(target);
            SetPadDestPos(pad, x, y, z, speed, accel, destroyArrival);
            return;
        end
    end
end


function PAD_MOVE_NEAR_TARGET(self, skl, pad, abilName, tgtRelation, searchRange, speed, addSpeed, accel)

    local abil = GetAbility(self, abilName);
    if abil ~= nil then
        local objList, objListCount = SelectObjectByPad(pad, tgtRelation, searchRange);
        for i = 1 , objListCount do 
            local target = objList[i];
            if target ~= nil then
                SetPadDestTarget(pad, target, speed + addSpeed * abil.Level, accel);                
                return;
            end
        end
    end
end

function PAD_CREATE_OBSTACLE(self, skl, pad, sizeX, sizeY)

    CreatePadObstacle(pad, sizeX, sizeY);
end


function PAD_END_MONSTER_WALL(self)
    EndMonsterWall(self);
end

function PAD_REMOVE_ALL_CHILDMON(self, skl, pad)
    RemoveAllPadMonster(pad);
end






function PAD_SET_JUMP_ROPE(self, skl, pad, eft, eftScale, radius, width, ropeCount, readySec, loopCount, loopSec, height)

    local px, py, pz = GetPadPos(pad);
    local padGuid = GetPadID(pad);
    RunJumpRope(self, eft, eftScale, radius, width, ropeCount, readySec, loopCount, loopSec, height, px, py, pz, padGuid);

end

function PAD_SET_PROMINENCE(self, skl, pad, eft, eftScale, maxHeight, coreCount, hitRange, onGroundTime, prominenceCount, moveCount, attackTime, jumpMin, jumpMax, maxMoveRange, preEft, preEftScale, preEftSecond)
    local px, py, pz = GetPadPos(pad);
    local padGuid = GetPadID(pad);

    if GetAbility(self, 'Elementalist3') ~= nil then
        maxMoveRange = 30;
    end
    
    for i = 1, prominenceCount do
        RunProminence(self, px, py, pz, eft, eftScale, preEft, preEftScale, preEftSecond, maxHeight, coreCount, hitRange, onGroundTime, moveCount, attackTime, maxMoveRange, jumpMin, jumpMax, padGuid);
    end
end
  
 function GET_PAD_GRASS_POS(self, x, y, z, padName, range)
    local list = SelectPad(self, padName, x, y, z, range, 'ALL');
    if #list < 1 then
        return 0, 0, 0
    end

    local pad = list[1];
    local px, py, pz = GetPadPos(pad);
    return px, py, pz;
end

function PAD_SET_CUSTOM_SQUARE(self, skl, pad, x1, y1, z1, x2, y2, z2, width)
    SetCustomSquareChecker(pad, x1, y1, z1, x2, y2, z2, width);
end

 function PAD_PLANT_ATTACK(self, skl, pad)
    EnableCheckPlant(pad);
 end

function PAD_MSL_FALL(self, skl, pad, fallRate, fallRange, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, range, delayTime, flyTime, height, easing, hitTime, hitCount, hitStartFix, startEasing, dcEft, dcEftScale)
    
    if fallRate <= IMCRandom(0, 100) then
        return;
    end
    
    local x, y, z = GetPadPos(pad);
    x, y, z = GetRandomPos(self, x, y, z, fallRange);

    MslFall(self, skl.ClassName, eftName, eftScale, x, y, z, range, delayTime, flyTime, height, easing, endEftName, endScale, startEasing, dcEft, dcEftScale);
    
    if delayTime ~= nil and delayTime > 0 then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
    end
    
    SetExProp(self, "CHECK_SKL_KD_PROP", 1);

    local delayTime = flyTime + delayTime + hitStartFix;
    
    -- ??????????. TakeDamage()??공격?????????SetExProp ????. sleep?????delayTime???????처리.
    local addValue = GetPadArgNumber(pad, 1);
    if addValue > 0 then
        SetExProp(skl, "SPC_DIVINEMIGHT_ENDTIME", imcTime.GetAppTime() + delayTime + 0.1);
        SetExProp(skl, "SPC_DIVINEMIGHT_SKL_ADD", addValue);
    end

    --???????????값이 100 ????????보스??????맛이가???????????   --RunScript('OP_DOT_DAMAGE', self, skl.ClassName, x, y, z, delayTime, range, hitTime, hitCount, dotEffect, dotEftScale, 100);
    RunScript('OP_DOT_DAMAGE', self, skl.ClassName, x, y, z, delayTime, range, hitTime, hitCount, dotEffect, dotEftScale, 0);   
end



function PAD_FUNC_UPDATE_DIRECT(self, skill, pad, script)
    local _func = _G[script]
    return _func(self, skill, pad)
end

function PAD_FUNC_UPDATE_RUNSCRIPT(self, skill, pad, script)    
    RunScript(script, self, skill, pad);
end

function PAD_MY_FOLLOWING_CASTER(self, skl, pad, monName, consumeLife, useCount, frontDist)

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    local objList, cnt = GetAliveFolloweList(self); -- BwaKayiman   
    local index = 1;
    
    local monList = {};
    for i = 1 , cnt do
        local target = objList[i];
        if string.find(target.ClassName, monName) ~= nil then
            monList[#monList + 1] = target;
        end
    end

    for i = 1, #monList do
    local target = monList[i];
        AddBuff(self, target, 'Sabbath_Fluting');
        if i == 1 then
            local x, y, z = GetFrontPos(self, -frontDist/2);
            MoveEx(target, x, y, z, 10)
            index = i;
        else
            local frontTarget = monList[index];
            local x, y, z = GetFrontPos(frontTarget, -frontDist/2);
            MoveEx(target, x, y, z, 10)
            index = i;
        end
    end
end

function PAD_REMOVEBUFF_FOLLMON(self, skl, pad, monName, buffName)

    local objList, cnt = GetPadObjectList(pad);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    local objList, cnt = GetAliveFolloweList(self); -- BwaKayiman   
    for i = 1 , cnt do
        local target = objList[i];
        if string.find(target.ClassName, monName) ~= nil then
            RemoveBuff(target, buffName);
        end
    end

end

function PAD_MYZOMBIE_FOLLOWING_CASTER(self, skl, pad, consumeLife, useCount, frontDist)

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    local objList, cnt = GetZombieSummonList(self); -- BwaKayiman   
    local index = 1;
    for i = 1 , cnt do
        local target = objList[i];
        if i == 1 then
            local x, y, z = GetFrontPos(self, -frontDist/2);
            MoveEx(target, x, y, z, 3)
            SetExProp(target, 'FRONT_ZOMBIE', GetHandle(self))
            index = i;
        else
            local frontTarget = objList[index];
            local x, y, z = GetFrontPos(frontTarget, -frontDist);
            MoveEx(target, x, y, z, 3)
            SetExProp(target, 'FRONT_ZOMBIE', GetHandle(frontTarget))
            index = i;
        end
    end
end


function PAD_TGT_FOLLOWING_CASTER(self, skl, pad, tgtRelation, consumeLife, useCount, frontDist)

    local objList, cnt = GetSortedPadObjectList(pad, self);

    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local index = 1;
    for i = 1 , cnt do
        local target = objList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then

            if index == 1 then
                local x, y, z = GetFrontPos(self, -frontDist/2);
                MoveEx(target, x, y, z, 3)              
                index = i;
            else
                local frontTarget = objList[index];
                local x, y, z = GetFrontPos(frontTarget, -frontDist);
                MoveEx(target, x, y, z, 3)
                index = i;
            end
        end
    end
end

function PAD_DAMAGE_ENEMY_DESTROYEVENT(self, skl, pad, ratio, consumeLife, useCount, eft, eftScale, lifeTime, delay)

    local objList, cnt = GetPadObjectList(pad);
    if GetPadUseCount(pad) <= 0 then
        return;
    end
    
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);
    end

    for i = 1 , cnt do
        local target = objList[i];
        if GetRelation(self, target) == "ENEMY" and IsDead(target) == 0 and IsHideFromMon(target) ~= 1 then
            
            local damage = SCR_LIB_ATKCALC_RH(self, skill)          
            
            if skill.ClassName == 'Mon_boss_molich_Skill_5' then
                ratio = skill.SkillFactor / 100;
            end
            
            TakeDamage(self, target, skl.ClassName, (damage * ratio) + skill.SkillAtkAdd);
            
            if eft ~= nil and eft ~= 'None' then
                local x, y, z = GetPos(target);
                PlayEffectToGround(self, eft, x, y, z, eftScale, lifeTime, delay, 0);
            end

            AddPadLife(pad, consumeLife);
            AddPadUseCount(pad, useCount);  
            if GetPadUseCount(pad) <= 0 then
                break;
            end
        end
    end

end

function PAD_SET_LINK_TEXTURE(self, skl, pad, x1, y1, z1, x2, y2, z2, linkTexture, edgeMonster)

    y1 = y1 + 20;
    y2 = y2 + 20;
    
    SetLinkEffectApperance(pad, x1, y1, z1, x2, y2, z2, linkTexture, edgeMonster);
        
end


function SCR_RESET_SHIELDCHARGE(self, skil, pad)
--    pad:SetUserValue("TgtKDCount" .. GetPadID(pad), 0);
--    pad:SetUserValue("TgtDamageCount" .. GetPadID(pad), 0);
    SetPadUserValue(pad, "TgtKDCount"..GetPadID(pad), 0);
    SetPadUserValue(pad, "TgtDamageCount"..GetPadID(pad), 0);
end


function PAD_SELECT_PADKILL(self, skl, pad, padName, searchRange)

    local x, y, z = GetPadPos(pad);
    local list = SelectPad(self, padName, x, y, z, searchRange);        
    for i = 1 , #list do
        local targetPad = list[i];
        if targetPad ~= nil then
            KillPad(targetPad);
        end
    end

end

function PAD_SELECT_MONKILL(self, skl, pad, tgtRelation, monName, searchRange)

    local objList, objListCount = SelectObjectByPad(pad, tgtRelation, searchRange);
    for i = 1 , objListCount do 
        local target = objList[i];
        if target ~= nil then
            if target.ClassName == monName then
                Kill(target);
            end
        end
    end
end

function PAD_DESTROY_BY_USECOUNT(self, skil, pad)
    local count = GetPadUseCount(pad);
    if count <= 0 then
        KillPad(pad);
    end
end
function SCR_PAD_ENTER_ELITE_MON_HOLDING(self, skl, pad, target, tgtRelation, consumeLife, useCount, lv, arg2, applyTime, over, rate)
    local eliteMonHoldingSkillCount = GetExProp(self, "EliteMonHoldingSkillCount");
    local eliteMonHoldingSkillName = GetExProp_Str(self, "EliteMonHoldingSkill_" .. IMCRandom(1, eliteMonHoldingSkillCount));

    PAD_TGT_BUFF_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, eliteMonHoldingSkillName, lv, arg2, applyTime, over, rate);
end

function SCR_PAD_ENTER_ELITE_MON_DEBUFF(self, skl, pad, target, tgtRelation)
    local eliteMonDebuffSkillCount = GetExProp(self, "EliteMonDebuffSkillCount");
    local eliteMonDebuffSkillName = GetExProp_Str(self, "EliteMonDebuffSkill_" .. IMCRandom(1, eliteMonDebuffSkillCount));

    PAD_TGT_BUFF_MON(self, skl, pad, target, tgtRelation, 0, 0, eliteMonDebuffSkillName, 1, 0, 4000, 1, 100);
end

function SCR_PAD_UPDATE_ELITE_MON_DEBUFF(self, skl, pad, tgtRelation)
    local objList, cnt = GetPadObjectList(pad, enemy, 1);
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
        return;
    end

    for i = 1 , cnt do
        local target = objList[i];

        local eliteMonDebuffSkillCount = GetExProp(self, "EliteMonDebuffSkillCount");
        local eliteMonDebuffSkillName = GetExProp_Str(self, "EliteMonDebuffSkill_" .. IMCRandom(1, eliteMonDebuffSkillCount));

        PAD_TGT_BUFF_MON(self, skl, pad, target, tgtRelation, 0, 0, eliteMonDebuffSkillName, 1, 0, 4000, 1, 100);
    end
end

function SCR_PAD_LEAVE_ELITE_MON_DEBUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName)
    if GetRelation(self, target) ~= "ENEMY" then
        return;
    end

    local eliteMonDebuffSkillCount = GetExProp(self, "EliteMonDebuffSkillCount");
    
    for i = 0, eliteMonDebuffSkillCount - 1 do
        local eliteMonDebuffSkillName = GetExProp_Str(self, "EliteMonDebuffSkill_" .. IMCRandom(1, eliteMonDebuffSkillCount));
        RemoveBuff(target, eliteMonDebuffSkillName);
    end
end

function SCR_PAD_ENTER_ELITE_MON_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, lv, arg2, applyTime, over, rate)
    local eliteMonBuffSkillCount = GetExProp(self, "EliteMonBuffSkillCount");
    local eliteMonBuffSkillName = GetExProp_Str(self, "EliteMonBuffSkill_" .. IMCRandom(1, eliteMonBuffSkillCount));

    PAD_TGT_BUFF_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, eliteMonBuffSkillName, lv, arg2, applyTime, over, rate);
end

function PAD_ALLOW_AROUND_FLYMON_ATTACK(self, skl, pad, x,y,z, range, padStyle, relationBit)
    AllowAroundFlyMonAttack(pad, x, y, z, range, padStyle, relationBit)
end

function PAD_DESTROY_BY_USECOUNT(self, skil, pad)
	local count = GetPadUseCount(pad);
	if count <= 0 then
		KillPad(pad);
	end
end