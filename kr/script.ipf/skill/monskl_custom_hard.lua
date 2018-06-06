-- monskl_custom_hard.lua

function SKL_SET_TARGET_CLIENT_TARGETTING(self, skl)

    ClearHardSkillTarget(self);
    local target = GetSkillTarget(self);
    if target == nil then
        CancelMonsterSkill(self);
        return;
    end

    AddHardSkillTarget(self, target);
end

function SKL_SET_TARGET_CIRCLE(self, skl, x, y, z, range, maxCount, relation, drawArea, exceptBoss, exceptCompa)

    if relation == nil then
        relation = "ENEMY";
    end

    if exceptCompa == nil then
        exceptCompa = 0;
    end

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectPos(self, x, y, z, range, relation, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;

    if IsPVPServer(self) == 1 and skl.ClassName == "Priest_Revive" then
        for i = 1, cnt do
            local obj = list[i];
            local count = GetExProp(obj, "REVIVE_COUNT")
            
            if count > 0 then
                if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                    AddHardSkillTarget(self, obj);
                    addedCnt = addedCnt + 1;
                end
            end

            if addedCnt >= allowedCnt then
                break;
            end
        end
    else
        for i = 1, cnt do
            local obj = list[i];

            if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                AddHardSkillTarget(self, obj);
                addedCnt = addedCnt + 1;
            end

            if addedCnt >= allowedCnt then
                break;
            end
        end
    end

end

function SKL_SET_TARGET_CIRCLE_BOSSCHECK_BYABIL(self, skl, x, y, z, range, maxCount, relation, drawArea, abil, exceptCompa, exceptFixedMon)

    if relation == nil then
        relation = "ENEMY";
    end
    
    if exceptCompa == nil then
        exceptCompa = 0;
    end
    
    local exceptBoss = 1;
    local checkAbil = GetAbility(self, abil);
    if checkAbil ~= nil and TryGetProp(checkAbil, "ActiveState") == 1 then
        exceptBoss = 0;
    end
    
    if exceptFixedMon == nil then
        exceptFixedMon = 0;
    end

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectPos(self, x, y, z, range, relation, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;

    for i = 1, cnt do
        local obj = list[i];
        if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
            if exceptBoss == 0 or TryGetProp(obj, "MonRank") ~= 'Boss' then
                if exceptFixedMon == 0 or TryGetProp(obj, "MoveType") ~= "Holding" then
                    AddHardSkillTarget(self, obj);
                    addedCnt = addedCnt + 1;
                end
            end
        end
        if addedCnt >= allowedCnt then
            break;
        end
    end
end

function SKL_SET_DEAD_PC_CIRCLE(self, skl, x, y, z, range, maxCount, drawArea, exceptCompa)

    if relation == nil then
        relation = "ENEMY";
    end

    if exceptCompa == nil then
        exceptCompa = 0;
    end

    ClearHardSkillTarget(self);
    local list, cnt = SelectDeadObjectPos(self, x, y, z, range, 5, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;
    
    if IsPVPServer(self) == 1 then
        for i = 1, cnt do
            local obj = list[i];
            local count = GetExProp(obj, "RESURRECTION_COUNT")
            
            if count > 0 then
                if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                    AddHardSkillTarget(self, obj);
                    addedCnt = addedCnt + 1;
                end
            end

            if addedCnt >= allowedCnt then
                break;
            end
        end
    else
        for i = 1, cnt do
            local obj = list[i];
            if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                AddHardSkillTarget(self, obj);
                addedCnt = addedCnt + 1;
            end
            if addedCnt >= allowedCnt then
                break;
            end
        end
    end

end

function SKL_SET_TARGET_SQUARE(self, skl, x, y, z, angle, dist, width, maxCount, relation, drawArea, exceptCompa, randomTargetList)
    
    local myangle = GetDirectionByAngle(self)
    angle = angle + myangle;
    if relation == nil then
        relation = "ENEMY";
    end

    if exceptCompa == nil then
        exceptCompa = 0;
    end

    ClearHardSkillTarget(self);
    local ex, ey, ez = GetAroundPosByPos(x, y, z, angle, dist);
    local list, cnt = SelectObjectBySquareCoor(self, relation, x, y, z, ex, ey, ez, width, 50, 0, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;
	
	if randomTargetList ~= nil and randomTargetList == 1 then
		list = SCR_ARRAY_SHUFFLE(list);
	end
	
    for i = 1, cnt do
        local obj = list[i];
        if IsPVPServer(self) == 1 and (skl.ClassName == 'Druid_Telepath' or skl.ClassName == 'Oracle_DeathVerdict') then
            if obj.ClassName ~= "GuildTower_PVP" and obj.ClassName ~= "Guardian_HighBube_Spear" then
                if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                    AddHardSkillTarget(self, obj);
                    addedCnt = addedCnt + 1;
                end
                if addedCnt >= allowedCnt then
                    break;
                end
            end
        else
            if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
                AddHardSkillTarget(self, obj);
                addedCnt = addedCnt + 1;
            end
            if addedCnt >= allowedCnt then
                break;
            end
        end
    end
end

function SKL_SET_TARGET_FAN(self, skl, x, y, z, angle, dist, maxCount, relation, drawArea, exceptCompa)

    if relation == nil then
        relation = "ENEMY";
    end

    if exceptCompa == nil then
        exceptCompa = 0;
    end

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectByFan(self, relation, x, y, z, dist, angle, -1, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;

    for i = 1, cnt do
        local obj = list[i];
        if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
            AddHardSkillTarget(self, obj);
            addedCnt = addedCnt + 1;
        end
        if addedCnt >= allowedCnt then
            break;
        end
    end
end


function SKL_SET_TARGET_FAN_BOSSCHECK(self, skl, x, y, z, angle, dist, maxCount, relation, drawArea, exceptCompa, exceptBoss, exceptFixedMon)

    if relation == nil then
        relation = "ENEMY";
    end

    if exceptCompa == nil then
        exceptCompa = 0;
    end
    
    if exceptBoss == nil then
        exceptBoss = 0;
    end
    
    if exceptFixedMon == nil then
        exceptFixedMon = 0;
    end
    
    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectByFan(self, relation, x, y, z, dist, angle, -1, drawArea);
    local allowedCnt = math.min(maxCount, cnt);
    local addedCnt = 0;
    
    for i = 1, cnt do
        local obj = list[i];
        if exceptCompa == 0 or TryGetProp(obj, 'Faction') ~= 'Pet' then
            if exceptBoss == 0 or TryGetProp(obj, "MonRank") ~= "Boss" then
                if exceptFixedMon == 0 or TryGetProp(obj, "MoveType") ~= "Holding" then
                    AddHardSkillTarget(self, obj);
                    addedCnt = addedCnt + 1;
                end
            end
        end
        
        if addedCnt >= allowedCnt then
            break;
        end
    end
end

function SKL_SET_TGT_EMPTY_TO_ME(self, skl)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        AddHardSkillTarget(self, self);
    end
end

function SKL_SET_TARGET_BY_SCP(self, skl, x, y, z, range, maxCount, relation, drawArea, pointScp)

    if relation == nil then
        relation = "ENEMY";
    end

    ClearHardSkillTarget(self);
    local tgt = SelectByPointPos(self, x, y, z, range, pointScp, relation, drawArea);
    if tgt ~= nil then
        AddHardSkillTarget(self, tgt);
    end

end

function SKL_EXCEPT_TARGET_BY_SCRIPT(self, skl, funcName)

    ExceptHardSkillTargetByScript(self, skl, funcName);

end

function SKL_EXCEPT_TARGET_LIST_BY_SCRIPT(self, skl, funcName, maxCnt)
    local tgtList = GetHardSkillTargetList(self);
    if tgtList ~= nil then
        if #tgtList >= 1 then
            ClearHardSkillTarget(self);
            local checkScp = _G[funcName];
            local cnt = 0;
            if maxCnt == nil or maxCnt < 0 then
                maxCnt = 0;
            end
            
            for i = 1 , #tgtList do
                local target = tgtList[i];
                if checkScp(self, skl, target) == 1 then
                    AddHardSkillTarget(self, target);
                    cnt = cnt + 1;
                    if maxCnt ~= 0 and cnt >= maxCnt then
                        break;
                    end
                end
            end
        end
    end
end

function SKL_SET_TGT_PAD_SUMMON(self, skl, padName, monName)
    ClearHardSkillTarget(self);
    local padList = GetMyPadList(self, padName);    
    for i = 1 , #padList do
        local pad = padList[i];
        local objList, cnt = GetPadMonsterList(pad);
        for j = 1, cnt do
            local obj = objList[j];
            if obj ~= nil then
                if monName == "ALL" or obj.ClassName == monName then
                    AddHardSkillTarget(self, obj);                  
                end
            end
        end
    end
end

function SKL_SET_TGT_SUMMON(self, skl, monName1, monName2, monName3, monName4, monName5, monName6)
    ClearHardSkillTarget(self);
    local list , cnt  = GetAliveFolloweList(self);
    for i = 1 , cnt do
        local obj = list[i];
        if monName == "ALL" or obj.ClassName == monName1 or obj.ClassName == monName2 or obj.ClassName == monName3 or obj.ClassName == monName4 or obj.ClassName == monName5 or obj.ClassName == monName6 then
            AddHardSkillTarget(self, obj);
        end
    end
end

function SKL_SET_TGT_SUMMON_RECENT(self, skl, monName)
    ClearHardSkillTarget(self);
    local list , cnt  = GetAliveFolloweList(self);
    local minAge = -1;
    local minObj = nil;
    for i = 1 , cnt do
        local obj = list[i];
        if monName == "ALL" or obj.ClassName == monName then
            local age = GetAge(obj);
            if age < minAge or minAge == -1 then
                minAge = age;
                minObj = obj;
            end
        end
    end

    if minObj ~= nil then
        AddHardSkillTarget(self, minObj);
    end
end

function SKL_SET_TGT_EXPROP_RECENT(self, skl, propName, propValue)
if nil == self then
    return;
end
    ClearHardSkillTarget(self);
    local list , cnt  = GetAliveFolloweList(self);
    local minAge = -1;
    local minObj = nil;
    for i = 1 , cnt do
        local obj = list[i];
        if GetExProp(obj, propName) == propValue then
            local age = GetAge(obj);
            if age < minAge or minAge == -1 then
                minAge = age;
                minObj = obj;
            end
        end
    end

    if minObj ~= nil then
        AddHardSkillTarget(self, minObj);
    end
end

function SKL_SET_TGT_ATTACHED_TO_SUMMON(self, skl, monName, relationBit)    
    ClearHardSkillTarget(self);
    local list , cnt  = GetAliveFolloweList(self);
    for i = 1 , cnt do
        local obj = list[i];
        if monName == "ALL" or obj.ClassName == monName then
            local attachedObjList = GetAttachedObjList(obj);
            for j = 1 , #attachedObjList do 
                local tgtObj = attachedObjList[j];
                if IsApplyRelation(self, tgtObj, relationBit) == 1 then
                    AddHardSkillTarget(self, tgtObj);
                    DetachFromObject(tgtObj, self);
                end
            end

            return;         
        end
    end
end

function SKL_SET_TGT_ARGOBJ(self, skl, objName)
    ClearHardSkillTarget(self);
    local obj = GetExArgObject(self, objName);
    if obj ~= nil then
        AddHardSkillTarget(self, obj);
    end
end

function SKL_SET_TARGET_WANT(self, skl, objName, x, y, z, range, maxCount, relation, drawArea)

    if relation == nil then
        relation = "ENEMY";
    end

    local objNameList = TokenizeByChar(objName, "/");

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectPos(self, x, y, z, range, relation, drawArea);
    cnt = math.min(maxCount, cnt);
    
    for i = 1, #objNameList do
        for j = 1, cnt do
            local obj = list[j];
            if objNameList[i] == obj.ClassName then
                AddHardSkillTarget(self, obj);
            end
        end
    end

end

function SKL_SET_TGT_COMPANION(self, skl, needJobID)
    ClearHardSkillTarget(self);

    local pet = GetSummonedPet(self, needJobID);
    if pet ~= nil then
        AddHardSkillTarget(self, pet);
    end

    --local list = GetSummonedPetList(self);
    --for i = 1 , #list do
    --  AddHardSkillTarget(self, list[i]);
    --end
end

function SKL_TARGET_RESET(self, skl)
    ClearHardSkillTarget(self);
end

function SKL_SET_TGT_CHAIN_EXTEND(self, skl, range, extendCount)
    local tgt = GetHardSkillFirstTarget(self);
    if tgt == nil then
        return;
    end

    ClearHardSkillTarget(self);
    local list = SelectObjectByChain(self, tgt, range, extendCount);
    AddHardSkillTarget(self, tgt);
    for i = 1 , #list do
        AddHardSkillTarget(self, list[i]);
    end
end

function SKL_CANCEL_IF_NOTARGET(self, skl)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        CancelMonsterSkill(self);
    end
end

function SKL_RUNSCRIPT_IF_NOTARGET(self, skl, funcName)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        local func = _G[funcName];
        func(self, skl);
    end
end

function SKL_SET_TGT_FIELDMON(self, skl, maxCount)
    ClearHardSkillTarget(self);
    local list = GetFreeFieldMonster(self, maxCount);
    for i = 1 , #list do
        AddHardSkillTarget(self, list[i]);
    end
    
end


function SKL_TGTLIST_EXPEFFECT(self, skl, skillExpEffectType)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        PlaySklExpEffect(self, obj, skillExpEffectType, 'None');
    end
end


function SKL_TGTLIST_SHOCKWAVE(self, skl, time, power, freq)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        ActorVibrate(obj, time, power, freq, 1);
    end
end

function SKL_TGTLIST_RUNFROM(self, skl, isOn)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if isOn == 1 then
            SetRunFromObject(obj, self);
        else
            SetRunFromObject(obj, nil);
        end
    end
end

function SKL_TGT_ATTACH_FORCE(self, skl, time, easing, eft, eftoffset, eftScale, finEft, finEftScale)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        AttachForce(self, obj, time, easing, eft, eftScale, eftoffset, finEft, finEftScale);
    end
end

function SKL_TGT_GETBACK_FORCE(self, skl, time, easing, eft, eftScale)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        GetBackForce(self, obj, time, easing, eft, eftScale);
    end
end

function SKL_TGT_REMOVE_FORCE(self, skl, time)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        RemoveForce(self, obj, time);
    end
end

function SKL_TGT_COLOR(self, skl, r, g, b, a, setChangeObjMon)
    local tgtList = GetHardSkillTargetList(self);   
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if obj ~= nil then
            if GetExProp(obj, "LEGEND_CARD") == 1 then
                r = 128
                g = 96
                b = 96
            end
            ObjectColorBlend(obj, r, g, b, a, 1, 0, 0, 0, setChangeObjMon);
        end
    end
end

function SKL_TGT_EFFECT(self, skl, eftName, scl, sorcerer)
    if sorcerer == 1 then
        local list , cnt  = GetFollowerList(self);
        local etc = GetETCObject(self);
        for i = 1, #list do
            local obj = list[i];
            if etc.Sorcerer_bosscardName1 == obj.ClassName 
            or etc.Sorcerer_bosscardName2 == obj.ClassName then
                PlayEffect(obj, eftName, scl, 0, 'BOT');
            end
        end

        return;
    end

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        PlayEffect(obj, eftName, scl, 0, 'BOT');
    end
end

function SKL_TGT_EFFECT_SORCERER(self, skl, eftName, scl)
    local tgtList = GetHardSkillTargetList(self); 
    local etc = GetETCObject(self);
    for i = 1, #tgtList do
        local obj = tgtList[i];
        if GetExProp(obj, "LEGEND_CARD") == 1 then
            if etc.Sorcerer_bosscardName1 == obj.ClassName 
            or etc.Sorcerer_bosscardName2 == obj.ClassName then
                PlayEffect(obj, eftName, scl, 0, 'BOT');
            end
        end
    end

    return;
end

function SKL_TGT_EFFECT_CLIENT_TARGETTING(self, skl, eftName, scl)
    ClearHardSkillTarget(self);
    local target = GetSkillTarget(self);
    
    if target ~= nil then
        AddHardSkillTarget(self, target);    
        local tgtList = GetHardSkillTargetList(self);
        for i = 1 , #tgtList do
            local obj = tgtList[i];
            PlayEffect(obj, eftName, scl, 0, 'BOT');
        end
    end
end

function SKL_TGT_ANIMATION(self, skl, anim, spd, fix)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        PlayAnim(obj, anim, fix, 0, 0, spd);
    end
end

function SKL_SYNC_START(self, skl)
    local key = GenerateSyncKey(self);
    StartSyncPacket(self, key);
    SetExProp(self, "SKL_SYNC_KEY", key);
end

function SKL_SYNC_END(self, skl, delay)
    local key = GetExProp(self, "SKL_SYNC_KEY");
    EndSyncPacket(self, key, delay);
    ExecSyncPacket(self, key);
end

function SKL_SYNC_SAVE(self, skl, delay)
    local key = GetExProp(self, "SKL_SYNC_KEY");
    EndSyncPacket(self, key, delay);
    AddSkillSyncKey(self, key);
end

function SKL_SYNC_EXEC(self, skl)
    ExecSkillSyncKeys(self, key);
end

function SKL_TGT_DMG_ADD_USERPROP(self, skl, damRate, addRate, propName)
    local curValue = GetExProp(skl, propName);
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local damage = SCR_LIB_ATKCALC_RH(self, skl);       
        damage = damage * damRate;

        retTable = {}

        retTable.skill = skl
        retTable.damage = damage
        retTable.hitResult = HIT_BASIC

        if ret ~= nil then
            
        end
        
        TakeDamage(self, target, skl.ClassName, damage);
        curValue = curValue + damage * addRate;
    end

    SetExProp(skl, propName, curValue);
end

function SKL_TGT_DMG(self, skl, dmgRate, attackerHitdelay, hitDelay)
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local damage = SCR_LIB_ATKCALC_RH(self, skl);               
        damage = damage * dmgRate;
        local result = TakeDamage(self, target, skl.ClassName, damage);
        if result == 1 then
            SetExProp(target, "NO_HIT", 1);
        end
    end
end

function SKL_TGT_SPLASH_DMG_WITH_SR(self, skl, attackRange, scpName)
    local tgtList = GetHardSkillTargetList(self);
    if tgtList == nil or #tgtList == 0 then
    	return;
    end
    
    local skillSR = TryGetProp(skl, 'SkillSR');
    if skillSR == nil then
    	skillSR = 0;
    end
    
    for i = 1 , #tgtList do
        local target = tgtList[i];
        
    	skillSR = SKL_TGT_SPLASH_DMG_WITH_SR_TAKE_DAMAGE(self, skl, target, skillSR);
    	
	    if scpName ~= nil and scpName ~= 'None' then
	        local func = _G[scpName];
	        func(self, skl, target);
	    end
    	
	    if skillSR <= 0 then
	    	return;
	    end
        
        local nearTargetList, nearTargeCount = SelectObjectNear(self, target, attackRange / 2, 'ENEMY');
        if nearTargeCount >= 1 then
        	for j = 1, nearTargeCount do
	        	local nearTarget = nearTargetList[j];
	        	if IsSameActor(target, nearTarget) == 'NO' then
		        	skillSR = SKL_TGT_SPLASH_DMG_WITH_SR_TAKE_DAMAGE(self, skl, nearTarget, skillSR);
		        	
				    if skillSR <= 0 then
				    	return;
				    end
				end
			end
        end
    end
end

function SKL_TGT_SPLASH_DMG_WITH_SR_TAKE_DAMAGE(self, skl, target, skillSR)
    local atk = SCR_LIB_ATKCALC_RH(self, skl);
	
    local result = TakeDamage(self, target, skl.ClassName, atk);
    if result == 1 then
        SetExProp(target, "NO_HIT", 1);
    end
    
    local targetSDR = TryGetProp(target, 'SDR');
    if targetSDR == nil then
    	targetSDR = 1;
    end
    
    skillSR = skillSR - targetSDR;
    
    return skillSR;
end

-- 스노우롤링에서 붙었다가 점감으로 인해 떨어지고 바로 붙으면 안되기 때문에, 처음에 걸렸었던 스노롤링의 남은 지속시간 동안 면역을 건다.
-- 이 면역 버프를 체크해서 다시 붙일지를 SKL_TGT_ATTACHMON 에서 체크
-- 넉백을 시킬지 말지 SKL_TGT_KNOCKDOWN 에서 체크
local function CHECK_SNOWROLLING_IMMUNE_STATUS(player)
    if player ~= nil then
        local ret = GetBuffByName(player, "SnowRollingTemporaryImmune")
        if ret ~= nil then
            return true -- 면역상태
        else
            return false
        end    
    else
       return false
    end    
end

local function IS_PC_RELATION(caster, target)
    if caster ~= nil and target ~= nil then
        if GetObjType(caster) == OT_PC and GetObjType(target) == OT_PC then
            return true
        else
            return false
        end
    else
        return false
    end    
end

function SKL_TGT_KNOCKDOWN(self, skl, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)        
    local Monk8_abil = GetAbility(self, "Monk8")
    if Monk8_abil ~= nil then
        return;
    end
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if GetExProp(target, "NO_HIT") ~= 1 then
            if skl.ClassName == "Cryomancer_SnowRolling" then   -- 스노우롤링이면 면역 상태인지 확인하자.
                local immune = CHECK_SNOWROLLING_IMMUNE_STATUS(target)
                if immune == false then
                    SKL_TOOL_KD(self, target, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
                    DelExProp(target, "NO_HIT")
                else
                    -- 넉다운 면역
                    PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("SHOW_GUNGHO"))
                end
                if IS_PC_RELATION(self, target) == true then
                    RemoveBuff(target, "SnowRollingAttach") -- 스노우롤링이 끝이 났기 때문에 지워준다.
                end
            else
                SKL_TOOL_KD(self, target, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
                DelExProp(target, "NO_HIT")
            end
        end
    end
end

function SKL_TGT_ATTACHMON(self, skl, monName, nodeName, nodeRandom, attachAnim, attachSec, holdAI)        
    local mon = GET_FOLLOW_BY_NAME(self, monName)
    if mon == nil then
        --  return; ??
    end
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];        
        if target.Size ~= "XL" and TryGetProp(target, "MoveType") ~= "Holding" then
            if target.MonRank ~= "MISC" and target.MonRank ~= "NPC" and target.MonRank ~= "Boss" then
                if GetExArgObject(target, "CONTROLLER") == nil and IsAttachedToObj(target) == 0 then                    
                    if nodeRandom == 0 then                                                    
                        AttachToObject(target, mon, nodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim)                                                    
                    else
                        if skl.ClassName == "Cryomancer_SnowRolling" then   -- 스노우롤링이면 면역 상태인지 확인하자.
                            local immune = CHECK_SNOWROLLING_IMMUNE_STATUS(target)
                            if immune == false then
                                local rNodeName = nodeName .. IMCRandom(1, nodeRandom);
                                if IS_PC_RELATION(self, target) == true then    -- 점감 적용을 위한 버프는 pc일때만 걸어주자.
                                    local time = 3 + skl.Level
                                    AddBuff(self, target, "SnowRollingAttach", skl.Level, 1, 1000 * time, 1)                                    
                                end
                                local checkBuff = GetBuffByName(target, "SnowRollingAttach")
                                if checkBuff ~= nil then
                                    AttachToObject(target, mon, rNodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim)
                                end

                                if GetObjType(target) == OT_MONSTERNPC then
                                    AttachToObject(target, mon, rNodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim)
                                end                                
                            else
                                PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("SnowRolling_Immune")) -- attach 면역                                
                            end                    
                        else
                            local rNodeName = nodeName .. IMCRandom(1, nodeRandom);
                            AttachToObject(target, mon, rNodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim)                                                        
                        end
                    end
                end
            end
        end
    end
end

function SKL_TGT_AI_HOLD(self, skl, holdMS)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        HoldScpForMS(target, holdMS);
    end
end

function SKL_TARGET_SET_3DPOS(self, skl, x, y, z)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        SetPosInServer(target, x, y, z);
    end
end

function SKL_TGT_ATTACH_CL_MON(self, skl, monName, nodeName, nodeRandom, attachAnim, attachSec, attachStartDist, attachStartSec)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        AttachToClientMon(target, self, monName, nodeName, nodeRandom, attachAnim, attachSec, attachStartDist, attachStartSec);
    end
end

function SKL_TGT_ATTACH_TO_NODE(self, skl, nodeName, nodeRandom, attachAnim, attachSec, holdAI)

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if nodeName == "None" then
            AttachToObject(target, nil, nodeName, "None", 2, attachSec, 0, holdAI, 0, attachAnim);
        else
            if nodeRandom == 0 then
                AttachToObject(target, self, nodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim);
            else
                local rNodeName = nodeName .. IMCRandom(1, nodeRandom);
                AttachToObject(target, self, rNodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim);
            end
        end
    end
end

function TARGET_CHECK_HIDEFROM_MON(self, skl, target)

    if IsHideFromMon(target) == 1 then
        return 0;
    end
    
    if IsPVPServer(self) == 1 and skl.ClassName == "Hunter_Retrieve" and target.ClassName == "GuildTower_PVP" then
        return 0;
    end
    
    return 1;

end

function TARGET_CHECK_IS_PC(self, skl, target)
    if IS_PC(target) == true then
        return 1;
    end
    
    return 0;
end

function IS_NOT_ATTACHED_TO_OBJ(self, skl, target)

    if IsAttachedToObj(target) == 1 then
        return 0;
    end

    return 1;
    
end

function SKL_TGT_ATTACH_TO_WEAPON_ITEM_NODE(self, skl, nodeName, nodeRandom, attachAnim, attachSec, holdAI)

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
            if nodeName ~= "None" and IsBuffApplied(target, 'Impaler_Debuff') == 'YES' then
                if nodeRandom == 0 then
                    AttachToItem(target, self, nodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim);               
                else
                    local rNodeName = nodeName .. IMCRandom(1, nodeRandom);
                    AttachToItem(target, self, rNodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim);
                end
            end
        end
    end

function SKL_THROW_TGT_OBJECT(self, skl, endEftName, endScale, x, y, z, posRandom, range, flyTime, delayTime, gravity, easing, dcDelay, dcEft, dcEftScale)
    
    local tgtList = GetHardSkillTargetList(self);
    
    if #tgtList == 0 then
        return ;
    end
    
    local skillName = skl.ClassName;
    if dcEft ~= "None" then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
    end

    if dcDelay > 0 then
        TOOLSKILL_SLEEP(dcDelay);
    end

    for i = 1 , #tgtList do
        local target = tgtList[i];
        local rx, ry, rz;
        if posRandom == 0 then
            rx, ry, rz = x, y, z;
        else
            rx, ry, rz = GetRandomPos(self, x, y, z, posRandom);
        end 

        rx, ry, rz = GetUnobstructedPos(self, rx, ry, rz);

        ThrowActor(target, rx, ry, rz, flyTime, delayTime, gravity, easing, endEftName, endScale, eftMoveDelay);
    end
    
    OP_DOT_DAMAGE(self, skillName, x, y, z, flyTime + delayTime, range, 1000, 1, "None", 1.0, 0);
    
end

function SKL_FORWARD_EQUIP_OBJECT(self, skl, xacHeadName, handType, x, y, z, endEftName, endScale, range, flyTime, delayTime, throwType)
    if GetBuffByName(self, 'Warrior_ThrowItem_Debuff_'..handType) ~= nil then
        CancelMonsterSkill(self);
        return;
    end
    
    local equipItem = GetEquipItem(self, handType);
    if equipItem == nil then
        CancelMonsterSkill(self);
        return;
    end

    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        CancelMonsterSkill(self);
        return;
    end

    for i = 1, #tgtList do
        local target = tgtList[i];
        if IsDead(target) ~= 1 and IsZombie(target) ~= 1 then
            local buffTime = 5000;
            if target.Size == 'XL' then
                buffTime = 15000;
            end
            local buff = AddBuff(self, self, 'Warrior_ThrowItem_Debuff_'..handType, 0, 0, buffTime, 1); 
            if buff == nil then
                CancelMonsterSkill(self);
                return;
            end
        
            SetExProp(buff, 'IS_DETHRONE_SKIL', 1);
            SetExProp(buff, 'DETHRONE_SKIL_CHECkTIME', imcTime.GetAppTime() + 3);

            local midOffset = 0;
            local cls = GetClass("ModelFormData", target.SET);
            if nil ~= cls then
                if cls.HitEffectNode ~= 'None' then
                    midOffset = cls.MidOffset;
                    midOffset = midOffset * -1;
                else
                    midOffset = cls.MidOffset;
                    midOffset = midOffset * 0.1;
                end
            end
    
            local dirX, dirY = GetDirection(self)
            local angle = 100
            if dirX > 0 and dirY < 0 then
                angle = 180
            elseif dirX > 0 and dirY > 0.9 then
                angle = 270;
            elseif dirX > 0 and dirY > 0 then
                angle = 270;
            elseif dirX < 0 and dirY > 0 then
                angle = 30;
            elseif dirX < 0 and dirY < 0 then
                angle = 90;
            end
            
            ItemAttachToMonsterNode(target, xacHeadName, handType, equipItem.ClassID, equipItem.ClassName, 1, angle, -midOffset);
            SetExProp_Str(target, "EQUIP_NAME", equipItem.ClassName);
            SetExArgObject(self, "THROW_ITEM_OBJ_"..handType, target);
            return;
        end
    end
    
end

function SKL_THROW_EQUIP_OBJECT(self, skl, xacHeadName, handType, x, y, z, endEftName, endScale, range, flyTime, delayTime, gravity, easing, throwType)
    local equipItem = GetEquipItem(self, handType);
    if equipItem == nil then
        CancelMonsterSkill(self);
        return;
    end
    
    if GetBuffByName(self, 'Warrior_ThrowItem_Debuff_'..handType) ~= nil then
        CancelMonsterSkill(self);
        return;
    end
    
--  if skl.ClassName == "Hoplite_ThrouwingSpear" then
--      RunScript('OP_DOT_DAMAGE',self, skl.ClassName, x, y, z, (flyTime + delayTime) /1, range, 0, 3, "None", 1.0, 0); 
--    elseif skl.ClassName == "Peltasta_ShieldLob" then
--        RunScript('OP_DOT_DAMAGE',self, skl.ClassName, x, y, z, (flyTime + delayTime) /1, range, 0, 2, "None", 1.0, 0);
--    else
--        RunScript('OP_DOT_DAMAGE',self, skl.ClassName, x, y, z, (flyTime + delayTime) /1, range, 0, 1, "None", 1.0, 0);   
--    end
    local damage = GET_SKL_DAMAGE(self, nil, skl.ClassName);
    if damage == nil or damage < 1 then
        damage = 0;
    end
    
    if skl.ClassName == "Hoplite_ThrouwingSpear" then
        RunScript('OP_DOT_DAMAGE_FOR_THROW_EQUIP_OBJECT', self, skl.ClassName, damage, x, y, z, (flyTime + delayTime) /1, range, 0, 3, "None", 1.0, 0);
    else
        RunScript('OP_DOT_DAMAGE_FOR_THROW_EQUIP_OBJECT', self, skl.ClassName, damage, x, y, z, (flyTime + delayTime) /1, range, 0, 1, "None", 1.0, 0);
    end
    
    local buff = AddBuff(self, self, 'Warrior_ThrowItem_Debuff_'..handType, 0, 0, 30000, 1);
    local abil_Draoon17 = GetAbility(self, "Dragoon17")
    if skl.ClassName ~= "Hoplite_ThrouwingSpear" then
        if skl.ClassName == "Dragoon_Gae_Bulg" and abil_Draoon17 == nil then
            if buff == nil then
                CancelMonsterSkill(self);
                return;
            end
        end
    end
        
    local monObj = CreateGCIES('Monster', 'skill_equip_object');
    monObj.Name = "skill_equip_object" .. tostring(GetHandle(self))
    
    local angle = GetAngleToPos(self, x, z);
    local mon = CreateMonster(self, monObj, x, y, z, angle - 90, 0, 0, GetLayer(self));
    if mon == nil then
        CancelMonsterSkill(self);
        RemoveBuff(self, 'Warrior_ThrowItem_Debuff_'..handType);
        return;
    end
    
    SetExArgObject(self, "THROW_ITEM_OBJ_"..handType, mon);
    ChangeThrowItemBodyPT(mon, self, xacHeadName, handType);
    DelayEnterWorld(mon, 1);

    local startRotateBillboard = 0;
    local endRotateBillboard = 0;
    if throwType == 'Shield' then

    elseif throwType == 'Spear' then
        local isReverse = false;
        local dirAngle = GetDirectionByAngle(self);
        startRotateBillboard = dirAngle + 270
        endRotateBillboard = dirAngle + 135  + 60;

        if dirAngle > -50 and dirAngle < 120 then
            isReverse = true;
        end

        if isReverse == true then
            local tmp = startRotateBillboard
            startRotateBillboard = endRotateBillboard
            endRotateBillboard = tmp
        end
    end
    
    ThrowItem(self, mon, xacHeadName, handType, x, y, z, flyTime, delayTime, gravity, easing, endEftName, endScale, startRotateBillboard, endRotateBillboard);
    
    KnockDown(mon, self, 30, angle, 70, 3);
    
    if skl.ClassName == "Dragoon_Gae_Bulg" then
        local GaeBulgSkill = GetSkill(self, "Dragoon_Gae_Bulg")
        if GaeBulgSkill == nil then
            return
        end
        
        local Dragoon6_abil = GetAbility(self, "Dragoon6")
        if Dragoon6_abil ~= nil and GaeBulgSkill.Level >= 5 then
            RunPad(self, "Dragoon_Gae_Bulg_defabil", skl, x, y, z, 1, 1);
        end
        
        local Dragoon7_abil = GetAbility(self, "Dragoon7")
        if Dragoon7_abil ~= nil and GaeBulgSkill.Level >= 5 then
            RunPad(self, "Dragoon_Gae_Bulg_atkabil", skl, x, y, z, 1, 1);
        end
    end
    
    if skl.ClassName ~= "Hoplite_ThrouwingSpear" then
        AddEffect(mon, 'F_item_drop_white_loop', 2.0, 1, 'BOT')
    elseif skl.ClassName == "Dragoon_Gae_Bulg" and abil_Draoon17 == nil then
        AddEffect(mon, 'F_item_drop_white_loop', 2.0, 1, 'BOT')
    else
        Kill(mon);
    end

	if abil_Draoon17 ~= nil then
		Kill(mon)
	end
end

function SKL_TGT_BUFF(self, skl, buffName, lv, arg2, applyTime, over, rate, checkBuff)        
    if nil == checkBuff then
        checkBuff = 0;
    end
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local addbuff = true;
        if checkBuff == 1 and IsBuffApplied(target, buffName) == 'YES' then
            addbuff = false;
        end

        if true == addbuff then
            local buff = ADDBUFF(self, target, buffName, lv, arg2, applyTime, over, rate);
            if buff ~= nil then
                CHECK_SHAREBUFF_BUFF(target, buff, lv, arg2, applyTime, over, rate);
            else
				if target.ClassName ~= "hidden_monster2" then
	                SkillCancel(self)
				end
            end
        end
    end
end

function SKL_TGT_BUFFREMOVE(self, skl, buffName)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];        
        RemoveBuff(target, buffName);
    end
end

function SKL_TGT_BUFF_ABIL(self, skl, abilName, buffName, lv, arg2, applyTime, addAbilTime, over, rate)
    local abil = GetAbility(self, abilName);
    if abil ~= nil then
        local tgtList = GetHardSkillTargetList(self);
        for i = 1 , #tgtList do
            local target = tgtList[i];
            if arg2 == -1 then
                arg2 = abil.Level;
            end
            ADDBUFF(self, target, buffName, lv, arg2, applyTime + addAbilTime * abil.Level, over, rate);
        end
    end
end

function SKL_TGT_BUFF_IF_NOBUFF(self, skl, appliedBuff, buffName, lv, arg2, applyTime, over, rate, checkBuff)
    if nil == checkBuff then
        checkBuff = 0;
    end
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local addbuff = true;
        if checkBuff == 1 and IsBuffApplied(target, buffName) == 'YES' then
            addbuff = false;
        end
        
        if IsBuffApplied(target, appliedBuff) == "YES" then
            addbuff = false;
        end

        if true == addbuff then
            local buff = ADDBUFF(self, target, buffName, lv, arg2, applyTime, over, rate);
            if buff ~= nil then
                CHECK_SHAREBUFF_BUFF(target, buff, lv, arg2, applyTime, over, rate);
            else
                local cancelSkill = true;
                local alreadyBuff = GetBuffByName(self, buffName);
                if alreadyBuff ~= nil then
                    local fromWho = BuffFromWho(alreadyBuff);
                    if fromWho == BUFF_FROM_AUTO_SELLER then
                        cancelSkill = false;
                    end
                end

                if cancelSkill == true then
                    SkillCancel(self)
                end
            end
        end
    end
end

function SKL_BUFF_MONRANK_SET_TIME(self, skl, buffName, monRank, time)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        
        local targetMonRank = TryGetProp(target, "MonRank");
        if targetMonRank ~= nil then
            if targetMonRank == monRank then
                SetBuffRemainTime(target, buffName , time);
            end
        end
    end
end

function SKL_TGT_ATTRACT_SQUARE(self, skl, x, y, z, angle, dist, width, time, easing, minDelay, maxDelay)
    
    local ex, ey, ez = GetAroundPosByPos(x, y, z, angle, dist);
    local tgtList = GetHardSkillTargetList(self);
    local tgtList2 = {};
    local cnt = 1
    for i = 1 , #tgtList do
        local target = tgtList[i];
        tgtList2[cnt] = tgtList[i];
        cnt = cnt + 1;
    end
    
    for i = 1 , #tgtList2 do
        local target = tgtList2[i];
        local delay = IMCRandomFloat(minDelay, maxDelay);
        local moveType = TryGetProp(target, "MoveType");
        if TryGetProp(target, "Size") ~= "XL" and moveType ~= "Holding" then
            if TryGetProp(target, "MonRank") ~= "MISC" and TryGetProp(target, "MonRank") ~= "NPC" then
            	if IS_PC(target) == false then
	                if delay == 0 then
	                    InsertHate(target, self, 1);
	                    AttractBySquare(self, target, skl.ClassID, x, y, z, ex, ey, ez, width, time, easing);
	                else
	                    RunScript("RUN_ATTACT_SQUARE", delay * 1000, self, target, skl.ClassID, x, y, z, ex, ey, ez, time, easing);
	                end
	            end
            end
        end
		
        local Psychokino5_abil = GetAbility(self, 'Psychokino5');
        if Psychokino5_abil ~= nil then
            AddBuff(self, target, 'GravityPole_Def_Debuff', 1, Psychokino5_abil.Level, (time + 1) * 1000, 1);
        end
    end
end

function RUN_ATTACT_SQUARE(sleepMsec, self, target, sklID, x, y, z, ex, ey, ez, time, easing)
    sleep(sleepMsec);
    InsertHate(target, self, 1);
    ActorVibrate(target, 0.5, 0.75, 30, 1);
    AttractBySquare(self, target, sklID, x, y, z, ex, ey, ez, width, time, easing);
end

function SKL_TGT_INSERTHATE(self, skl, hatePoint)
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if target ~= nil then
            InsertHate(self, target, hatePoint);
        end
    end
end

function SKL_TGT_MOVEATTACK(self, skl, range, maxMoveRange, kdType, speed, accel, anim)

    local tgt = GetHardSkillFirstTarget(self);
    if tgt == nil then
        return;
    end
    
    MovingAttackToTarget(self, skl, tgt, range, maxMoveRange, kdType, speed, accel, anim);
        
end

function TGT_IS_NORMAL_MONSTER(self, skl)
    
    local tgtList = GetHardSkillTargetList(self);
    if IsPVPServer(self) then
        return;
    end
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if IsNormalMonster(obj) == 0 then
            CancelMonsterSkill(self);
            return;
        end
    end
end

function SKL_FLOAT_MONSTER(self, skl, maxHeight, raiseTime, easing, shockPower, shockTime, shockFreq)
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if maxHeight > 0 then
            local delay = IMCRandomFloat(0.2, 0.5);
            local key = GenerateSyncKey(obj);
            StartSyncPacket(obj, key);
            FlyMath(obj, maxHeight, raiseTime, easing);
            EndSyncPacket(obj, key, delay);
            ExecSyncPacket(obj, key);
        else
            FlyMath(obj, maxHeight, raiseTime, easing);
        end     
    end

    if maxHeight == 0 then
        local key = GenerateSyncKey(self);
        StartSyncPacket(self, key);
        BroadcastShockWave(self, 2, 999, shockPower, shockTime, shockFreq, 0);
        EndSyncPacket(self, key, raiseTime);
        ExecSyncPacket(self, key);
    end
end

function SKL_TGT_LAND(self, skl, time, easing)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];

    end
end


function SKL_SET_TARGET_CIRCLE_SIZEMON(self, skl, x, y, z, range, maxCount, monSize)

    ClearHardSkillTarget(self);
    local list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY');
    local propToken = StringSplit(monSize, "/");
    local smallMonList = {};

    local index = 1;
    for i = 1, cnt do
        local obj = list[i];
        for j = 1, #propToken do
            if obj.Size == propToken[j] then
                smallMonList[index] = obj;
                index = index + 1;
            end
        end
    end

    cnt = math.min(maxCount, #smallMonList);
    for i = 1, cnt do
        local obj = smallMonList[i];
        
        

        
        if IS_PC(obj) == true then
            AddHardSkillTarget(self, obj);
            CancelMonsterSkill(obj);
        end
        
        if IS_PC(obj) == false and obj.Faction == 'Monster' and obj.MoveType ~= "Holding" then
        if obj.MonRank ~= "MISC" and obj.MonRank ~= "NPC" then 
        AddHardSkillTarget(self, obj);
        CancelMonsterSkill(obj);
        end
        end
        
        
        
    end
end



function SKL_SET_TARGET_SQUARE_SIZEMON(self, skl, x, y, z, angle, dist, width, maxCount, monSize)

    ClearHardSkillTarget(self);
    local ex, ey, ez = GetAroundPosByPos(x, y, z, angle, dist);
    local list, cnt = SelectObjectBySquareCoor(self, "ENEMY", x, y, z, ex, ey, ez, width, 50);
    
    local smallMonList = {};
    local index = 1;
    for i = 1, cnt do
        local obj = list[i];
        if obj.Size == monSize then
            smallMonList[index] = obj;
            index = index + 1;
        end
    end

    cnt = math.min(maxCount, #smallMonList);
    for i = 1, cnt do
        local obj = smallMonList[i];
        AddHardSkillTarget(self, obj);
    end
end

function SKL_TGT_DMG_BUFF(self, skl, dmgRate, buffName)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if GetBuffByName(target, buffName) ~= nil then
            local damage = SCR_LIB_ATKCALC_RH(self, skl);           
            damage = damage * dmgRate;
            TakeDamage(self, target, skl.ClassName, damage);
        end
    end
end

--function SKL_TGT_DMG_BUFF_BONUS_HIT_INDEX(self, skl, dmgRate, bonusHitIndex, bonusDmgRate, buffName)
--    local tgtList = GetHardSkillTargetList(self);
--    for i = 1 , #tgtList do
--        local target = tgtList[i];
--        local buff = GetBuffByName(target, buffName);
--        if buff ~= nil then
--            local damage = SCR_LIB_ATKCALC_RH(self, skl);
--            local rate = dmgRate;
--            local propName = buffName..'_'..tostring(GetHandle(self));
--            local hitCount = GetExProp(buff, propName);
--            if hitCount + 1 >= bonusHitIndex then
--                rate = rate + bonusDmgRate;
--                SetExProp(buff, propName, 0);
--            else
--                SetExProp(buff, propName, hitCount + 1);
--            end
--            
--            damage = damage
--            TakeDamage(self, target, skl.ClassName, (damage + skl.SkillAtkAdd) * rate, "Dark", "Magic", "Magic", HIT_DARK, HITRESULT_BLOW, 0, 0);
--            
--            local Bokor2_abil = GetAbility(self, "Bokor2")
--            if Bokor2_abil ~= nil and IsBuffApplied(target, 'Hexing_Debuff') == 'YES' and IMCRandom(1,9999) < Bokor2_abil.Level * 500 then
--                AddBuff(self, target, 'Blind', 1, 0, 5000, 1);
--            end
--        end
--    end
--end

function GET_SCP_TARGET_ANGLE(self)
    local tgt = GetHardSkillFirstTarget(self);
    if tgt == nil then
        return 0;
    end

    local tgtAngle = GetDirectionByAngle(tgt);
    local myAngle = GetDirectionByAngle(self);
    return tgtAngle - myAngle;
end


-- Cleric Zombie Hover
function SCR_ZOMBIE_HOVER_START(self, zombieMon)

    --local bokor5_abil = GetAbility(self, 'Bokor5');
    --if bokor5_abil ~= nil then
    --  AddBuff(self, zombieMon, 'Cleric_Bwakaylman_ZombieDef', bokor5_abil.Level, 0, 0, 1);
    --end
end

function SCR_ZOMBIE_HOVER_END(self, zombieMon)

    --RemoveBuff(zombieMon, 'Cleric_Bwakaylman_ZombieDef');
end

function SKL_TGT_PUSH_ANGLE(self, skl, tgtRelation, angle, speed, keyName)
    
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then    
            PushActorByAngle(target, angle, speed, keyName);
        end
    end
end

function SKL_TGT_PUSH_POS(self, skl, tgtRelation, x, y, z, inoutdir, speed, keyName)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if IS_APPLY_RELATION(self, target, tgtRelation) then    
            PushActorByPos(target, x, y, z, inoutdir, speed, keyName);
        end
    end
end

function SKL_TGT_PUSH_END(self, skl, tgtRelation, keyName)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];      
        PushActorEnd(target, keyName);
    end 
end


function SKL_TGT_MSL_THROW(self, skl, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, range, flyTime, delayTime, gravity, spd, hitTime, hitCount, dcEft, dcEftScale, dcDelay, eftMoveDelay, kdPower, knockType, vAngle, innerRange)

    local x, y, z = GetFrontPos(self, 150);
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList > 0 then
        x, y, z = GetPos(tgtList[1]);   
    end

    if kdPower == nil then
        kdPower = 0;
    end
    
    if knockType == nil then
        knockType = 1
    end

    if vAngle == nil then
        vAngle = 0;
    end

    if innerRange == nil then
        innerRange = 0;
    end

    SetExProp(skl, "SET_TOOL_VANGLE", vAngle)

    local skillName = skl.ClassName;
    if dcDelay ~= nil and dcDelay > 0 then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
        TOOLSKILL_SLEEP(dcDelay);
    end

    if eftMoveDelay == nil then
        eftMoveDelay = 0;
    end

    MslThrow(self, eftName, eftScale, x, y + 10, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay);
    
    if eftMoveDelay ~= nil and eftMoveDelay > 0 then
        eftMoveDelay = eftMoveDelay * 1000;
        TOOLSKILL_SLEEP(eftMoveDelay);
    end

    SetExProp(self, "CHECK_SKL_KD_PROP", 1);
    OP_DOT_DAMAGE(self, skillName, x, y, z, flyTime + delayTime, range, hitTime, hitCount, dotEffect, dotScale, kdPower, KnockType, innerRange);
    
end

function SKL_TGT_BUFF_PCBUFFTIME(self, skl, buffName, lv, arg2, buffTime, buffTimePC, over, rate, checkBuff)        
    if nil == checkBuff then
        checkBuff = 0;
    end
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local addbuff = true;
        if checkBuff == 1 and IsBuffApplied(target, buffName) == 'YES' then
            addbuff = false;
        end

        if true == addbuff then
            if IS_PC(target) == true then
                buffTime = buffTimePC
            end
            
            local buff = ADDBUFF(self, target, buffName, lv, arg2, buffTime, over, rate);
            if buff ~= nil then
                CHECK_SHAREBUFF_BUFF(target, buff, lv, arg2, buffTime, over, rate);
            else
                local cancelSkill = true;
                local alreadyBuff = GetBuffByName(self, buffName);
                if alreadyBuff ~= nil then
                    local fromWho = BuffFromWho(alreadyBuff);
                    if fromWho == BUFF_FROM_AUTO_SELLER then
                        cancelSkill = false;
                    end
                end

                if cancelSkill == true then
                    SkillCancel(self)
                end
            end
        end
    end
end
