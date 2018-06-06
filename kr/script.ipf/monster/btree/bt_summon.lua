
--/**
--* @Function       BT_FOLLOW_SUMMONER
--* @Type           Cond
--* @NumArg         따라가기 시작하는 거리
--* @NumArg2        멈추는 거리
--* @Description    주인을 따라감
--**/
function BT_FOLLOW_SUMMONER(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
    local range = GetDistance(self, owner);
    local followRange = GetLeafNumArg(prop);
    local stopRange = GetLeafNumArg2(prop);

    if IsMoving(self) == 1 and GetDistFromTargetMoveDest(self, owner) <= stopRange then
        if range <= stopRange then
            ChangeMoveSpdType(self, "WLK");
            return BT_SUCCESS;
        end
        
        return BT_RUNNING;
    end
    
    
    if range <= followRange then
        return BT_FAILED;
    end
    ChangeMoveSpdType(self, "RUN");
    MoveToTarget(self, owner, stopRange);
    return BT_SUCCESS;
end

function BT_CHECK_SUMMONER_STATE(self, state, btree, prop)

    local owner = GetOwner(self);
    if owner == nil then
        Kill(self);
        return BT_FAILED;
    end
    

    local objList, objCount = SelectObject(self, 300, 'ENEMY');
    if objCount == 0 then
        return BT_FAILED;
    else    
        
        if IsSkillUsing(self) == 0 then 
            for i=1, objCount do
                
                -- ?º?¸??¡¼­ ¾?L ¼??≫?°¡ V8¸???°?
                local hate = GetHate(objList[i], owner);
                if hate > 0 then                                    
                    local ret = LIB_BT_ATTACK(self, objList[i]);
                    return ret;
                end
            end
        end 
    end

    return BT_FAILED;

end

function BT_SUMMON_ATTACK_POINT(self, state, btree, prop)
    local target;
    local objList, objCount = SelectObject(self, 300, 'ENEMY');
    
    if objCount == 0 then
        return BT_FAILED;
    else
        local target = objList[1];
        return LIB_BT_ATTACK(self, target);
    end
    
end




function BT_PC_SUMMON_INIT(self)
    SetTendency(self, 'Attack');
    EnableAIOutOfPC(self);
    
--    RunScript("BT_PC_SUMMON_INIT_RUN", self);
end

function BT_PC_SUMMON_INIT_RUN(self)
--    sleep(1000);
--    local owner = GetOwner(self);
--    if owner ~= nil then
--        local ownerMSPD = TryGetProp(owner, "MSPD");
--        local myMSPD = TryGetProp(self, "MSPD");
--        self.MSPD_BM = self.MSPD_BM + 30;
--        InvalidateMSPD(self);
--    end
end



--/**
--* @Function       BT_ATTACK_NEAR
--* @Type           Cond
--* @NumArg         검색 범위
--* @Description    주변 범위안의 적을 검색해서 SkillByRatio 스킬 공격
--**/
function BT_ATTACK_NEAR(self, state, btree, prop)
    
    if GetExProp(self, "SUMMON_FOLLOW_STATE") == 1 then
        return BT_SUCCESS;
    end
    
    if GetExProp(self, 'NOT_ALLOW_ATTACK') == 1 then
        return BT_SUCCESS;
    end
    
    if IsChasingSkill(self) == 1 then
        SetExProp(self, "SUMMON_BATTLE_STATE", 1);
        return BT_FAILED;
    end
    
    local range = GetLeafNumArg(prop);
    if range > 0 then
        SetTendencysearchRange(self, range);
    end
    
--    local target = GetNearEnemyFromFunc(self, "SCR_BT_SUMMON_ENEMY_CHECK");    
--    if target == nil then
--        return BT_SUCCESS;
--    end
    
    local target = SCR_BT_SUMMON_OWNER_FORCED_TARGET(self, range);
    if target == nil then
        target = GetNearEnemyFromFunc(self, "SCR_BT_SUMMON_ENEMY_CHECK");
        if target == nil then
            return BT_SUCCESS;
        end
    end
    
    ChangeMoveSpdType(self, "RUN");
    
    local selectedSkill = SelectMonsterSkillByRatio(self);
    
    if selectedSkill == "None" then
        return BT_SUCCESS;
    end
    
    UseMonsterSkill(self, target, selectedSkill);
    SetExProp(self, "SUMMON_BATTLE_STATE", 1);
    return BT_FAILED;
end

function SCR_BT_SUMMON_ENEMY_CHECK(self, target)
--    local ownerTarget = SCR_BT_SUMMON_OWNER_FORCED_TARGET(self);
--    if ownerTarget ~= nil then
--        if IsSameObject(ownerTarget, target) == 1 and GetRelation(self, target) == "ENEMY" then
--            return 1;
--        end
--        return 0;
--    end
    
    local targetOwner = GetTopOwner(target);
    if targetOwner ~= nil then
        if IS_PC(targetOwner) == true then
            target = targetOwner;
        end
    end
    
    if TryGetProp(target, "Faction") == "RootCrystal" then
        return 0;
    end
    
    if GetRelation(self, target) ~= "ENEMY" then
        return 0;
    end
    
    return 1;
end

function SCR_BT_SUMMON_OWNER_FORCED_TARGET(self, range)
    local owner = GetOwner(self);
    if owner == nil then
        return nil;
    end
    
    if range == nil then
        range = 100;
    end
    
    local ownerTarget = GetExArgObject(owner, "OWNER_FORCED_TARGET");
    
    if ownerTarget ~= nil then
        if IsDead(ownerTarget) == 0 then
            if GetDistance(self, ownerTarget) <= range or GetDistance(owner, ownerTarget) <= range then
                return ownerTarget;
            end
        end
    end
    
    return nil;
end



--/**
--* @Function       BT_FOLLOW_SUMMONER_BATTLE
--* @Type           Cond
--* @NumArg         따라가기 시작하는 거리
--* @NumArg2        멈추는 거리
--* @Description    주인 따라가기
--**/
function BT_FOLLOW_SUMMONER_BATTLE(self, state, btree, prop)
    -- 소서러 버그 임시 처리 --
    if TryGetProp(self, 'BornScript') == "MON_BORN_ATTRIBUTE_PC_SummonBoss" then
        local monClassID = TryGetProp(self, 'ClassID');
        if monClassID >= 800001 and monClassID <= 800081 then
            if GetExProp(self, 'SORCERER_SUMMONING') ~= 1 then
                Kill(self);
            end
        end
    end
    -- 소서러 버그 임시 처리 끝 --
    
    if TryGetProp(self, "MoveType") == "Holding" then
        return BT_SUCCESS;
    end
    
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
    local range = GetDistance(self, owner);
    local followRange = GetLeafNumArg(prop);
    local stopRange = GetLeafNumArg2(prop);
    
    -- 만약 거리가 300을 넘게 벌어지면 그냥 SetPos --
    if range > 300 then
        local x, y, z = GetPos(owner);
        local randomX, randomY, randomZ = GetRandomPos(self, x, y, z, stopRange);
        SetPos(self, randomX, randomY, randomZ);
        return BT_FAILED;
    end
    
    if IsMoving(self) == 1 and GetDistFromTargetMoveDest(self, owner) <= stopRange then
        if range <= stopRange then
            ChangeMoveSpdType(self, "WLK");
            ResetHate(self);
            SetExProp(self, "SUMMON_FOLLOW_STATE", 0);
            return BT_SUCCESS;
        end
        return BT_RUNNING;
    elseif IsMoving(self) == 0 and GetExProp(self, "SUMMON_BATTLE_STATE") == 0 then
        ChangeMoveSpdType(self, "WLK");
        ResetHate(self);
        SetExProp(self, "SUMMON_FOLLOW_STATE", 0);
    end
    
    
    if range <= followRange then
        return BT_SUCCESS;
--        return BT_FAILED;
    end
    
    CancelMonsterSkill(self);
    
    ChangeMoveSpdType(self, "RUN");
    MoveToTarget(self, owner, stopRange);
    SetExProp(self, "SUMMON_FOLLOW_STATE", 1);
    
--    return BT_SUCCESS;
    return BT_FAILED;
end



function BT_IS_BATTLE_STATE_CHECK(self, state, btree, prop)
    local isBattleState = GetExProp(self, "SUMMON_BATTLE_STATE");
    local check = GetLeafNumArg(prop);
    if check == isBattleState then
        return BT_SUCCESS;
    end
    
    return BT_FAILED;
end



function BT_SET_BATTLE_STATE(self, state, btree, prop)
    local battleState = GetLeafNumArg(prop);
    SetExProp(self, "SUMMON_BATTLE_STATE", battleState);
    if battleState == 0 then
        ClearExArgObject(self, "TARGET_FROM_OWNER");
    end
    
    return BT_SUCCESS;
end



function BT_CHECK_OWNER_BATTLE_STATE(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
    local allowedTime = GetLeafNumArg(prop);
    
    local curTime = math.floor(imcTime.GetAppTime());
    local prevTime = GetExProp(self, 'PREV_TIME');
    if prevTime == 0 then
        prevTime = curTime;
        SetExProp(self, 'PREV_TIME', curTime);
    end
    
    local diff = curTime - prevTime;
    local nonBattleTime = GetExProp(self, 'NON_BATTLE_TIME');
    if diff > 0 then
        nonBattleTime = nonBattleTime + diff;
        if IsAttackState(owner) == 1 then
            nonBattleTime = 0;
        end
        SetExProp(self, 'NON_BATTLE_TIME', nonBattleTime);
        if nonBattleTime > allowedTime then
            SetExProp(self, 'NOT_ALLOW_ATTACK', 1);
        else
            SetExProp(self, 'NOT_ALLOW_ATTACK', 0);
        end
        SetExProp(self, 'PREV_TIME', curTime);
    end
    
    return BT_SUCCESS;
end

function BT_CHECK_OWNER_AROUND(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
    local range = GetDistance(self, owner);
    local stopRange = GetLeafNumArg(prop);
    if stopRange <= range then
        return BT_FAILED;
    end
   
    return BT_SUCCESS;
end

--/**
--* @Function       BT_CHECK_OWNER_MOVESTATE
--* @Type           Act
--* @Description    소환자가 이동시 따라가는 기능
--**/
function BT_CHECK_OWNER_MOVESTATE(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
	if GetMoveState(owner) == "MS_MOVE_DIR" then
		PlayAnim(self, 'run', 1, 1, 0, 1)
   	else
   		PlayAnim(self, 'astd', 1, 1, 0, 1)
   	end
	
    return BT_SUCCESS;
end

--/**
--* @Function       BT_CHECK_OWNER_HATE
--* @Type           Act
--* @Description    소환자가 공격중인 적을 최우선으로 공격
--**/
function BT_CHECK_OWNER_HATE(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
    
	local enemy = GetNearTopHateEnemy(owner)
	if enemy == nil then
		return BT_FAILED;
	else
		SetReservedTarget(btree, enemy);
		return BT_SUCCESS;
	end
	
    return BT_SUCCESS;
end

--/**
--* @Function       BT_COND_IS_OWNER_ABILITY
--* @Type           Cond
--* @NumArg         RandomNum
--* @Description        확률 설정해서 특성 사용하기(불여우 식신령: 여우불 추가 전용)
--**/
function BT_COND_IS_OWNER_ABILITY(self, state, btree, prop)
    local owner = GetOwner(self);
    if owner == nil then
        return BT_FAILED;
    end
	
    local numArg = GetLeafNumArg(prop)
    local abilName = GetAbility(owner, "Onmyoji17"); 
    
    if abilName == nil then
        return BT_FAILED;
    end
	
    if IMCRandom(1, 100) < abilName.Level * 5 then
        return BT_SUCCESS;
    end
	
    return BT_FAILED;
end
