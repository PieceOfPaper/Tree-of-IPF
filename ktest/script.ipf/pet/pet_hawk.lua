---- pet_hawk.lua

g_default_hawk_Height = 80;

function HAWK_LOOP_AI(self)
    
    if 1 == GetExProp(self, "PET_EATING") then
        return 1;
    end

    if 1 == FLYING_PET_FEED_ANIM(self) then
        return 1;
    end

    if 1 == HAWK_SIT_ONTHEROOST(self) then
        PET_SET_ACT_FLAG(self);
        return 1;
    end

    local isHiding = IsHide(self);
    if isHiding == 1 then
        return 1;
    end

    if 1 == HAWK_FOLLOW_OWNER(self) then
        PET_SET_ACT_FLAG(self);
        return 1;
    end

    HAWK_REST_PROCESS(self);
    
    return 1;
end

function FLYING_PET_FEED_ANIM(self)
    local tryToEatTime = GetExProp(self, "NEED_TO_EAT");
    if tryToEatTime + 2 > imcTime.GetAppTime() then
        SetExProp(self, "NEED_TO_EAT", "0");
        SetExProp(self, "PET_EATING", "1");

        local owner = GetOwner(self);
        RunScript("FLYING_PET_UPDATE_PET_FOOD", owner, self); -- 별도의 스크립트로 실행하지 않으면 종종 어디선가 AI를 죽여서 중간에 끊긴다. --

        return 1;
    else
        return 0; 
    end
end

function INIT_HAWK_ROOST(self, owner, skl)

    local beforeRoost = GetExArgObject(owner, "HAWK_ROOST");
    if beforeRoost ~= nil then
        Dead(beforeRoost);
    end
	
    SetExArgObject(owner, "HAWK_ROOST", self);
    RunScript("CHECK_ROOST_AUTO_DESTROY", self);
end

function CHECK_ROOST_AUTO_DESTROY(self)

    local owner = GetOwner(self);
    local remainDist = 100;
    
    local Falconer1_abil = GetAbility(owner, "Falconer1");
    if Falconer1_abil ~= nil then
        remainDist = remainDist + Falconer1_abil.Level * 20
    end
	
    for i = 0 , 20 do
        if owner == nil then
        	RemovePad(owner, "buildRoost_pad")
            Dead(self);
            return;
        end
        
        local dist = GetDist2D(self, owner);
        if dist >= remainDist then
        	RemovePad(owner, "buildRoost_pad")
            Dead(self);
            return;
        end
		
        sleep(1000);
    end
end

function HAWK_UNHIDE(self, target)

    FlyMath(self, g_default_hawk_Height, 1, 1);
    local isFlyingAway = GetExProp(self, "FLYING_AWAY", 1);
    if isFlyingAway == 1 then
        SetExProp(self, "STOP_FLY_AWAY", 1);
--      UnHoldMonScp(self);
        SetHoldMonScp(self, 0);
        SetExProp(self, "FLYING_AWAY", 0);
    else
        -- completlyHided
        local x, y, z = GET_HAWK_FLY_RANDOM_POS(target, 250);
        SetPos(self, x, y, z);
        SetHide(self, 0);
    end

    LOCK_HAWK_ACTION(self, 0);  
    MoveToTarget(self, target, 1);
end

function HAWK_SIT_ONTHEROOST(self)
    local owner = GetOwner(self);
    if owner == nil then
        return 0;
    end

    local isInRoost = GetExProp(self, "IS_IN_ROOST");
    local roost = GetExArgObject(owner, "HAWK_ROOST");
    if roost == nil then
        if isInRoost == 1 then
            HAWK_UNREST(self);
        end
        return 0;
    end
    
    if IS_FLYING_AWAY(self) == 1 then
        HAWK_UNHIDE(self, roost);
    end

    local roostSitDist = 80;    
    local distFromRoost = GetDist2D(owner, roost);
    local isSitDist = true;
    if distFromRoost >= roostSitDist then
        isSitDist = false;
    end

    if false == isSitDist then
        if 1 == isInRoost then
            HAWK_UNREST(self);
        end

        return 0;
    end

    local restTarget = GetExArgObject(self, "REST_TARGET");
    if restTarget ~= nil then
        if 0 == IsSameObject(restTarget, roost) then
            return 0;
        end

        if isSitDist == true then
            return 1;
        else
            HAWK_UNREST(self);
            return 1;
        end
    end
    
    HAWK_REST_WITH_OWNER(self, roost, "Dummy_hawk", "IS_IN_ROOST");
    return 1;

end

function PET_HAWK_INIT(self)
    FlyMath(self, g_default_hawk_Height, 0, 1);
end

function PET_TOUCAN_INIT(self)
    if IsBuyCompanion(self) == 1 then
        sleep(1000)
        SetFlyMathOption(self, 1, 1, 1, 1);
        FlyMath(self, g_default_hawk_Height, 1, 1, 1, 1);
    else
        SetFlyMathOption(self, 1, 1, 1, 0);
        FlyMath(self, g_default_hawk_Height, 0, 1);
    end
end

function HAWK_FOLLOW_OWNER(self)
    local owner = GetOwner(self);
    local isOwnerMoving = HAWK_OWNER_IS_MOVING(owner);
    local parentRange;
    if isOwnerMoving == 1 then
        parentRange = 50;
    else
        parentRange = 150;
    end
	
    local ret = HAWK_PARENT_DIST_CHECK(self, parentRange)
    if ret == 1 then
        return 1;
    end
	
    return 0;
end

function HAWK_UNREST(self)
    local exPropName = GetExProp_Str(self, "REST_TYPE")
    if exPropName == "None" then
        return;
    end
    
    AutoDetachWhenTargetMove(self, 0, "SIT");
    AttachToObject(self, nil, "None", "None", 1);
    FlyMath(self, g_default_hawk_Height, 1, 1.5);
    PlayAnim(self, "SIT_TO_ASTD");
    SetExArgObject(self, "REST_TARGET", nil);
    SetExProp(self, exPropName, 0);
    SetExProp_Str(self, "REST_TYPE", "None");
    sleep(1000);
    AttachToObject(self, nil, "None", "None", 1);
    if self.ClassName ~= "pet_hawk" then --비행형은 모두 적용시켜도 문제 없을 것으로 보이지만, 대형 커밋이라 일단 매를 제외한 컴패니언만 처리.--
        SetFlyMathOption(self, 1, 1, 1, 0); --RisingProcess/FallingProcess on
    end

        -- PET_SET_ACT_FLAG(self);
end

function HAWK_OWNER_IS_MOVING(owner)
    if 1 == IsMoving(owner) then
        return 1;
    end

    if IsUsingSkill(owner) == 1 then
        return 1;
    end

    return 0;
end

function HAWK_REST_WITH_OWNER(self, owner, sitNodeName, successExPropName)
    LOCK_HAWK_ACTION(self, 1, 'HAWK_REST_WITH_OWNER');
    for i = 0 , 20 do
        local dist = GetDist2D(self, owner);
        if dist >= 10 then
            if 0 == MoveToTarget(self, owner, 1) then
                break;
            end
        else
            break;
        end

        sleep(500);
    end

    FlyMath(self, 1, 1, 1.5, 0);
    sleep(1000);
    PlayAnim(self, "ASTD_TO_SIT", 1, 0);
    local isOwnerMoving = HAWK_OWNER_IS_MOVING(owner);

    if isOwnerMoving == 1 then
        LOCK_HAWK_ACTION(self, 0);
        HAWK_UNREST(self);
        return;
    end

    local playAttachAnimWhenCompletelyAttached = 1;
    local angle = GetDirectionByAngle(owner);
    SetDirectionByAngle(self, angle);
    AttachToObject(self, owner, sitNodeName, "None", 1, 1, 0, 0, 0, "SIT", playAttachAnimWhenCompletelyAttached);
    
    if self.ClassName ~= "pet_hawk" then --비행형은 모두 적용시켜도 문제 없을 것으로 보이지만, 대형 커밋이라 일단 매를 제외한 컴패니언만 처리. --
        SetFlyMathOption(self, 1, 1, 0, 0); --RisingProcess/FallingProcess off (안그러면 네비 메시를 벗어나 먹이 줄 경우 문제 발생)-- 
    end

    if sitNodeName == 'Dummy_hawk' then
        AddAttachAnimList(self, 2, 'SIT_IDLE','SIT_IDLE2');
    else
        AddAttachAnimList(self, 0);
    end

    sleep(1000);
    AutoDetachWhenTargetMove(self, 1, "SIT");
    PlayEffectNode(owner, 'F_smoke109_2', 1, sitNodeName)
    PlayEffectNode(owner, 'F_archer_hawk_fether_sit', 1, sitNodeName)
    SetExProp(self, successExPropName, 1);
    SetExProp_Str(self, "REST_TYPE", successExPropName);
    SetExArgObject(self, "REST_TARGET", owner);
    if successExPropName == "IS_RESTING" then
        SetExProp_Pos(owner, "REST_OWNER_POS", GetPos(owner));
    end
    LOCK_HAWK_ACTION(self, 0);

    local actTime = imcTime.GetAppTime() + IMCRandom(15, 25);
    SetExProp(self, "LAST_PET_ACT", actTime);
    SetExProp(self, "LAST_SIT_TIME", actTime );
end

function HAWK_REST_PROCESS(self)

    local isResting = GetExProp(self, "IS_RESTING");
    local owner = GetOwner(self);
    if owner ~= nil and IsRunningScript(self, 'SCR_HAWK_FIRSTSTRKIE') == 1 then
        if isResting == 0 then
            local distFromOwner = GetDist2D(self, owner);
            if distFromOwner >= 15 then
                LookAt(self, owner);
                if IsRunningScript(self, 'SCR_HAWK_FIRSTSTRKIE') == 1 then -- 선제공격 때문에 Hovering 끝나고 바로 회전하면 STD로 돌아가지 못한다. 땜빵 처리. --
                    PlayAnim(self, "RUN", 1, 0);
                end
            end
        end
    end

    local isOwnerMoving = HAWK_OWNER_IS_MOVING(owner);
    
    local isResting = GetExProp(self, "IS_RESTING") 
     if isResting == 1 then
        --is_Moving으로만 검사하면 업데이트 간격 사이에 움직이면 false라서 부정확하다. --
        if isOwnerMoving == 1 or GetExProp_Pos(owner, "REST_OWNER_POS") ~= GetPos(owner) then
            HAWK_UNREST(self);
            return 1;
        end
     end

    local lastPetActTime = GetExProp(self, "LAST_PET_ACT");
    local timeFromLastAction = imcTime.GetAppTime() - lastPetActTime;
    if isResting == 1 then
        if timeFromLastAction > 10 then
            HAWK_UNREST(self);
        end
    else
        if timeFromLastAction > 10 then
            PET_SET_ACT_FLAG(self);
            
            if isOwnerMoving == 0 then

                    local lastSitTime = GetExProp(self, "LAST_SIT_TIME");
                    local timeFromLastSit = imcTime.GetAppTime() - lastSitTime;
                    if timeFromLastSit < 40 then

                    local range = 50;
                    local x, y, z = GetPos(owner);
                    local angle = IMCRandom(0, 360);
                    angle = DegToRad(angle);
                    x = x + math.cos(angle) * range;
                    z = z + math.sin(angle) * range;

                    MoveEx(self, x, y, z, 1);
                    LOCK_HAWK_ACTION(self, 0);
                    local actTime = imcTime.GetAppTime() - IMCRandom(2, 7);
                    SetExProp(self, "LAST_PET_ACT", actTime);
                else
                    HAWK_REST_WITH_OWNER(self, owner, "Dummy_pet_hawk_R", "IS_RESTING");                    
                end
            end
        end
    end

    return 1;
    
end

function HAWK_PARENT_DIST_CHECK(self, range)
    
    local owner = GetOwner(self);   
    if owner == nil then
        return 0;
    end

    local dist = GetDistance(self, owner);  
    if dist <= range then
        return 0;
    end
    
    if dist >= 300 then
        local x, y, z = GET_HAWK_FLY_RANDOM_POS(owner, 250);
        SetPos(self, x, y, z);
    end
    
    local isResting = GetExProp(self, "IS_RESTING");
    if isResting == 1 then
        sleep(800);
    end

    CancelMonsterSkill(self);
    ResetHate(self);
    ChangeMoveSpdType(self, "RUN");
    if owner == nil then
        return 0;
    end

    local rangeFromOwner = 20;
    for i = 0 , 20 do
        local dist = GetDist2D(self, owner);
        if dist < rangeFromOwner then
            return 0;
        end

        MoveToOwner(self, 1);
        PET_SET_ACT_FLAG(self);
        sleep(200); 
    end
    
    return 0;

end

function HAWK_WAIT_MOVE_TO(self, x, y, z)
    
    for i = 0 , 20 do
        local dist = Get2DDistFromPos(self, x, z);
        if dist <= 5 then
            return;
        end

        MoveEx(self, x, y, z, 1);
        sleep(500);
    end
end

function HAWK_CIRCLING(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
--    if IsRunningScript(hawk, '_HAWK_CIRCLING') == 1 then
--        return;
--    end
    
    local x, y, z = Get3DPos(hawk);
    local skill = GetSkill(self, 'Falconer_Circling');
    local pad = RunPad(hawk, 'Falconer_Circling', skill, x, 0, z, 0, 1)
    if nil == pad then
        return;
    end
    
    local padID = GetPadID(pad);
    SetExProp(hawk, 'CIRCLING_PAD_ID', padID);
    
    RunScript('_HAWK_CIRCLING', hawk, self, pad, skill, padID)
end

function _HAWK_CIRCLING(self, owner, pad, skl, padID)
    sleep(1000);
    HAWK_UNREST(self);
    
    local abilFalconer11 = GetAbility(owner, "Falconer11")
    if abilFalconer11 ~= nil then
        local buffApplyTime = 10000 + TryGetProp(abilFalconer11, "Level") * 1000
        AddBuff(owner, owner, "CirclingIncreaseSR_Buff", 1, 0, buffApplyTime, 1)
    end
    
	AddPadEffect(pad, 'F_archer_circling_ground', 1.7);
    
    local hoverTime = GetPadLife(pad);
    local startTime = imcTime.GetAppTimeMS();
    while 1 do
        if IsZombie(self) == 1 or IsDead(self) == 1 or IsZombie(owner) == 1 or IsDead(owner) == 1 then  
            return;
        end
		
        if imcTime.GetAppTimeMS() - startTime > hoverTime then
            break;
        end
		
        if nil == pad then
            break;
        end
        
    	local nowPadID = GetExProp(self, 'CIRCLING_PAD_ID');
    	if nowPadID ~= padID then
    		KillPad(pad);
    		return;
    	end
        
        if GetPadLife(pad) <= 1000 then
            break;
        end
        sleep(1000);
    end
end

function LOCK_HAWK_ACTION(self, isLock, funName)
    SetExProp(self, "USING_HAWK_SKILL", isLock);
    if nil == funName then
        funName = 'None'
    end
    SetExProp_Str(self, "USING_HAWK_FUNNAME", funName);
end

function IS_LOCK_HAWK_ACTION(self)
    return GetExProp(self, "USING_HAWK_SKILL");
end

function _HAWK_START_BEFOR_STOP(hawk, self, skl, funcName, stopFunc)
    local beforepheasant = GetExArgObject(self, "HAWK_PHEASANT");
    if beforepheasant ~= nil then
        Dead(beforepheasant);
    end
    
    if GetExProp(self, "FLYING_AWAY") == 1 then
        return;
    end

    if 'None' ~= stopFunc then
        StopRunScript(hawk, stopFunc);
        LOCK_HAWK_ACTION(hawk, 0);
        if stopFunc ~= 'HAWK_REST_WITH_OWNER' then
            if stopFunc == '_HAWK_HOVERING' or stopFunc == '_HAWK_CIRCLING' then
                StopHoverPosition(hawk);
            end
--          UnHoldMonScp(hawk);
            SetHoldMonScp(hawk, 0);
        end
    end

    FlyMath(hawk, g_default_hawk_Height, 10, 1);
    SetHide(hawk, 1);
    MoveToTarget(hawk, self, 1)
    local dist = GetDistance(hawk, self)
    sleep(dist * 10);
    RunScript(funcName, hawk, self, skl);
end

function HAWK_BLISTERINGTHRASH(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
        local scp = GetExProp_Str(hawk, 'USING_HAWK_FUNNAME');
        RunScript('_HAWK_START_BEFOR_STOP', hawk, self, skl, '_HAWK_BLISTERINGTHRASH', scp);
        return;
    end
    
    RunScript("_HAWK_BLISTERINGTHRASH", hawk, self, skl);
end

function _HAWK_BLISTERINGTHRASH(self, owner, skill, target, firstStrike)
    
    LOCK_HAWK_ACTION(self, 1, '_HAWK_BLISTERINGTHRASH');
--  HoldMonScp(self);
    SetHoldMonScp(self, 1);
    HAWK_UNREST(self)

    local cx, cy, cz  = GetPos (owner);
    local x, y, z = GetGizmoPos(owner);
    if nil ~= target then
        cx, cy, cz = GetPos(target);
        x, y, z = cx + 5, cy, cz + 5;
    end

    local syncKey = GenerateSyncKey(self);
    StartSyncPacket(self, syncKey);
    local damage = SCR_LIB_ATKCALC_RH(owner, skill);
    local splashRange = 30;
    local kdPower = 250;
    local knockType = 4;
    local innerRange = 0;
	
	
	if firstStrike == 1 then
		SCR_FIRSTSTRIKE_ADD_DAMAGE_SET(owner);
	end
	
    SPLASH_DAMAGE(owner, x, y, z, splashRange, skill.ClassName, kdPower, false, knockType, innerRange, SET_HAWK_MULTIPLE_DAMAGE, self);
	
    BroadcastShockWave(self, 2, 99999, 7, 0.5, 50, 0)
    EndSyncPacket(self, syncKey);
	
    local goTime = 0.7;
    local backTime = 0.5;
    
    local dx = 2 * x - cx;
    local dy = cy + g_default_hawk_Height;
    local dz = 2 * z - cz;
    PenetratePosition(self, dx, dy, dz, 10, syncKey, "HOVERING_SHOT", goTime, 7.0, backTime, 0.7, 30);
    SetPosInServer(self, dx, dy, dz);
    
    sleep( (goTime + backTime) * 1000 );
    
    PET_SET_ACT_FLAG(self);
    HAWK_FLY_AWAY(self);
--  UnHoldMonScp(self);
    SetHoldMonScp(self, 0);
end

function SET_HAWK_MULTIPLE_DAMAGE(arg)
    
    arg:SetMultipleHitCount(6);
    --arg:SetAttackerHitDelay(1);
    arg:SetFixHitDelay(0.1);

end

function _HAWK_COMBINATION(self, owner, target, skill)
    
    LOCK_HAWK_ACTION(self, 1, '_HAWK_COMBINATION');
--  HoldMonScp(self);
    SetHoldMonScp(self, 1);
    HAWK_UNREST(self)

    local cx, cy, cz  = GetPos(owner);
    local x, y, z = GetPos(target);

    local syncKey = GenerateSyncKey(self);
    StartSyncPacket(self, syncKey);
    
    local damage = SCR_LIB_ATKCALC_RH(owner, skill);
    local kdPower = 250;
    TAKE_SCP_DAMAGE(owner, target, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName, 0, 0, self);
    
    EndSyncPacket(self, syncKey);
    
    local goTime = 0.5;
    local backTime = 0.5;
    
    local dx = 2 * x - cx;
    local dy = cy + g_default_hawk_Height;
    local dz = 2 * z - cz;
    PenetratePosition(self, dx, dy, dz, 10, syncKey, "HOVERING_SHOT", goTime, 7.0, backTime, 0.7, 30);
    
    sleep( (goTime + backTime) * 1500 );

    local cx, cy, cz  = GetPos(self);
    local x, y, z = GetPos(owner);

    local syncKey = GenerateSyncKey(self);
    StartSyncPacket(self, syncKey);

    TAKE_SCP_DAMAGE(owner, target, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName, 0, 0, self);
    
    EndSyncPacket(self, syncKey);

    PenetratePosition(self, x, dy, z, 10, syncKey, "HOVERING_SHOT", goTime, 7.0, backTime, 0.7, 30);

    sleep( (goTime + backTime) * 1000 );

    LOCK_HAWK_ACTION(self, 0);
--    UnHoldMonScp(self);
    SetHoldMonScp(self, 0);
end

function HAWK_HOVERING(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
        local scp = GetExProp_Str(hawk, 'USING_HAWK_FUNNAME');
        RunScript('_HAWK_START_BEFOR_STOP', hawk, self, skl, '_HAWK_HOVERING', scp);
        return;
    end

    RunScript("_HAWK_HOVERING", hawk, self, skl);
end

function _HAWK_HOVERING(self, owner, skill, target, firstStrike)
    LOCK_HAWK_ACTION(self, 1, '_HAWK_HOVERING');
    SetHoldMonScp(self, 1);
    sleep(1000);
    HAWK_UNREST(self)
    
    local x, y, z = GetGizmoPos(owner);
    if nil ~= target then
        x, y, z = Get3DPos(target);
    end
    
    SetMoveAniType(self, "HOVERING_READY");
    HAWK_WAIT_MOVE_TO(self, x, y, z);
    SetMoveAniType(self, "None");
    
    local hoverRadius = 50;
    local hoverSpeed = 0.25;
    HoverPosition(self, x, y + g_default_hawk_Height, z, hoverRadius, hoverSpeed, "HOVERING_LOOP"); 
    sleep(1500);
    local hoverTime = 10000;
    
    local time_abil = GetAbility(owner, "Falconer3")
    if time_abil ~= nil then
        hoverTime = hoverTime + time_abil.Level * 3000
    end
    
    local goTime = 0.7;
    local backTime = 0.5;
    local aftersleepTime = 2;
    if GetAbility(owner, "Falconer4") ~= nil and skill.Level >= 3 then
        goTime = 0.35
        backTime = 0.3
        aftersleepTime = 1.2
    end
    
    local startTime = imcTime.GetAppTimeMS();
    while 1 do
        if IsZombie(self) == 1 or IsDead(self) == 1 or IsZombie(owner) == 1 or IsDead(owner) == 1 then  
            return;
        end
        
        if imcTime.GetAppTimeMS() - startTime > hoverTime then
            break;
        end
        
        local list, cnt = SelectObjectPos(self, x, y, z, hoverRadius * 2.0, 'ENEMY');
        if cnt > 0 then
            local enemy = list[1];
            PauseHovering(self, 1);
            AddEffect(enemy, "I_sys_target001_circle", 1.5, "BOT");
            local beforeSleepTime = 0.5;
            local totalTime = goTime + backTime + 0.5 + 1;
            LookAt(self, enemy);
            RunScript('_HAWK_HOVERING_LINK_EFFECT', self, enemy, beforeSleepTime, goTime, backTime)
            
            sleep(beforeSleepTime * 1000);
            
            local syncKey = GenerateSyncKey(self);
            StartSyncPacket(self, syncKey);
            local damage = SCR_LIB_ATKCALC_RH(owner, skill);
            
			if firstStrike == 1 then
				SCR_FIRSTSTRIKE_ADD_DAMAGE_SET(owner);
			end
            
            TAKE_SCP_DAMAGE(owner, enemy, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName, 0, 0, nil, self);
            
            local kdPower = 250;
            local hAngle = GetAngleTo(self, enemy);
            
            if GetPropType(enemy, 'KDArmor') ~= nil and enemy.KDArmor < 900 then
                KnockDown(enemy, self, kdPower, hAngle, 80, 1);
            end
            
            BroadcastShockWave(self, 2, 99999, 7, 0.5, 50, 0)
            EndSyncPacket(self, syncKey);
            
            CollisionAndBack(self, enemy, syncKey, "HOVERING_SHOT", goTime, 7.0, backTime, 0.7, 0, 1);
            sleep( (goTime + backTime) * 1000 );
            RemoveEffect(enemy, 'I_sys_target001_circle', 1)
            PauseHovering(self, 0);
            sleep(aftersleepTime * 1000);
            if target ~= nil then
                break;
            end
        end
        sleep(200);
    end
    
    StopHoverPosition(self);
    
    PET_SET_ACT_FLAG(self);
    HAWK_FLY_AWAY(self);
    SetHoldMonScp(self, 0);
end

function _HAWK_HOVERING_LINK_EFFECT(self, enemy, beforeSleepTime, goTime, backTime)
    MakeLinkEftToTarget(self, enemy, "SpikeShooter", "Bip001 HeadNub", "None", 0, 1)
    sleep((beforeSleepTime + goTime + backTime) * 1000);
    RemoveLinkEftToTarget(self, enemy);
end

function HAWK_HANGINGSHOT(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end

    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
        return;
    end
    
    RunScript("_HAWK_HANGINGSHOT", hawk, self, skl);
end


function _HAWK_HANGINGSHOT(self, owner, skill)
    
    EnableControl(owner, 0, "HANGINGSHOT");
    AddBuff(self, owner, "HangingShot", 1, 0, 0, 1);
    LOCK_HAWK_ACTION(self, 1, '_HAWK_HANGINGSHOT');
--  HoldMonScp(self);
    SetHoldMonScp(self, 1);
    sleep(1000);
    HAWK_UNREST(self)
    
    local goTime = 1;
    local backTime = 1;
    local syncKey = 0;
    CollisionAndBack(self, owner, syncKey, "HANGINGSHOT", goTime, 7.0, backTime, 0.7, 20, 0);

    local syncKey = GenerateSyncKey(self);
    StartSyncPacket(self, syncKey);
    ControlObject(owner, self, 0, 0, 0, "None", "None", 1);
    FlyWithObject(owner, self, "Bip001 Spine", -42);
    ChangeNormalAttack(owner, "Bow_Hanging_Attack");
    SetMoveAniType(self, "ASTD");
    
    if GetEquipItem(owner, 'RH').ClassType2 == 'Gun' then
        RemoveBuff(owner, "HangingShot");
        ControlObject(owner, nil, 1, 1, 1, "None", "None");
        FlyWithObject(owner, nil, "None", 0);
        ChangeNormalAttack(owner, "None");
        SetMoveAniType(self, "None");
        PET_SET_ACT_FLAG(self);
        HAWK_FLY_AWAY(self);
    end
    EndSyncPacket(self, syncKey, goTime);
    ExecSyncPacket(self, syncKey);
    
    sleep(1000)
    EnableControl(owner, 1, "HANGINGSHOT");

    local hoverTime = 14000 + skill.Level * 1000;
    local startTime = imcTime.GetAppTimeMS();
    for i = 0 , 20 do
        if imcTime.GetAppTimeMS() - startTime > hoverTime or GetEquipItem(owner, 'RH').ClassType2 == 'Gun' then
            break;
        end

        if IsBuffApplied(owner, 'HangingShot') =='NO' then
            break;
        end
        
        sleep(1000);
    end
    
    ControlObject(owner, nil, 1, 1, 1, "None", "None");
    FlyWithObject(owner, nil, "None", 0);
    ChangeNormalAttack(owner, "None");
    SetMoveAniType(self, "None");
    RemoveBuff(owner, "HangingShot");
    PET_SET_ACT_FLAG(self);
    HAWK_FLY_AWAY(self);
end

function INIT_HAWK_PHEASANT(self, owner, skl)
    
    local beforepheasant = GetExArgObject(owner, "HAWK_PHEASANT");
    if beforepheasant ~= nil then
        Dead(beforepheasant);
    end
    
    local hawk = GetSummonedPet(owner, PET_HAWK_JOBID);
    if hawk == nil then
        Dead(self);
        return;
    end
    
    if IS_LOCK_HAWK_ACTION(hawk) == 1 then
--      Dead(self);
        local scp = GetExProp_Str(hawk, 'USING_HAWK_FUNNAME');
        RunScript('_HAWK_START_BEFOR_STOP_PHEASANT', hawk, owner, self, skl, '_HAWK_PHEASANT', scp);
        return;
    end
    
    SetExArgObject(owner, "HAWK_PHEASANT", self);
    RunScript("CHECK_ROOST_AUTO_DESTROY", self);
    
    local x, y, z = GetGizmoPos(owner);
    ThrowActor(self, x, y, z, 0.5, 0, 900, 1, "F_smoke109_2", 1.5, 0);
    
    local hawk = GetSummonedPet(owner, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
--  RunScript("_HAWK_PHEASANT", hawk, owner, self, skl, x, y, z);
    RunScript("_HAWK_PHEASANT", hawk, owner, self, skl);

end


function _HAWK_START_BEFOR_STOP_PHEASANT(hawk, self, pheasant, skl, funcName, stopFunc)
    local beforepheasant = GetExArgObject(self, "HAWK_PHEASANT");
    if beforepheasant ~= nil then
        Dead(beforepheasant);
    end
    
    if GetExProp(self, "FLYING_AWAY") == 1 then
        return;
    end

    if 'None' ~= stopFunc then
        StopRunScript(hawk, stopFunc);
        LOCK_HAWK_ACTION(hawk, 0);
        if stopFunc ~= 'HAWK_REST_WITH_OWNER' then
            if stopFunc == '_HAWK_HOVERING' or stopFunc == '_HAWK_CIRCLING' then
                StopHoverPosition(hawk);
            end
--          UnHoldMonScp(hawk);
            SetHoldMonScp(hawk, 0);
        end
    end

    FlyMath(hawk, g_default_hawk_Height, 10, 1);
--  SetHide(hawk, 1);
    MoveToTarget(hawk, self, 1)
--  local dist = GetDistance(hawk, self)
--  sleep(dist * 10);
    RunScript(funcName, hawk, self, pheasant, skl);
end


function _HAWK_PHEASANT(self, owner, pheasant, skill)

    SetExArgObject(owner, "HAWK_PHEASANT", pheasant);
    RunScript("CHECK_ROOST_AUTO_DESTROY", pheasant);

    local x, y, z = GetGizmoPos(owner);
    ThrowActor(pheasant, x, y, z, 0.5, 0, 900, 1, "F_smoke109_2", 1.5, 0);

    local hawk = GetSummonedPet(owner, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end



    LOCK_HAWK_ACTION(self, 1, '_HAWK_PHEASANT');
--  HoldMonScp(self);
    SetHoldMonScp(self, 1);
    sleep(1000);
    HAWK_UNREST(self)
    
    local goTime = 1;
    local backTime = 1;
    local syncKey = GenerateSyncKey(self);
    
    CollisionAndBack(self, pheasant, syncKey, "HOVERING_SHOT", goTime, 7.0, backTime, 0.7, 20, 1);
	
    sleep(1000)
	
--    StartSyncPacket(self, syncKey);
	
    local damageRange = 100;
    local list, cnt = SelectObjectPos(owner, x, y, z, damageRange, 'ENEMY');
    if cnt > 15 then
    	cnt = 15
    end
    
    for i = 1, cnt do
        local damageTarget = list[i];
        local damage = SCR_LIB_ATKCALC_RH(owner, skill);
        TAKE_SCP_DAMAGE(owner, damageTarget, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName, 0, 0, nil, self);
        local Falconer12_abil = GetAbility(owner, "Falconer12")
        if Falconer12_abil ~= nil then
            local stun_ratio = IMCRandom(1, 100)
            if stun_ratio <= Falconer12_abil.Level * 10 then
                AddBuff(self, damageTarget, 'Stun', 1, 0, 3000, 1);
            end
        end
        
        local kdPower = 150;
        local hAngle = GetAngleFromPos(damageTarget, x, z);
        local abilFalconer18hAngle = GetAngleToPos(damageTarget, x, z);
        local abilFalconer18 = GetAbility(owner, "Falconer18")
        if GetPropType(damageTarget, 'KDArmor') ~= nil and damageTarget.KDArmor < 900 then
        	if abilFalconer18 ~= nil and abilFalconer18.ActiveState == 1 then
        		KnockDown(damageTarget, self, kdPower, abilFalconer18hAngle, 80, 1);
        	elseif Falconer12_abil == nil or Falconer12_abil.ActiveState ~= 1 then
            	KnockDown(damageTarget, self, kdPower, hAngle, 80, 1);
            end
        end
    end

    PlayEffectToGround(self, "F_archer_caltrop_hit_explosion", x, y, z, 1.0);
    BroadcastShockWave(self, 2, 99999, 7, 0.5, 50, 0)
--    EndSyncPacket(self, syncKey);

    sleep(goTime * 1000);
    Dead(pheasant);
    sleep( backTime * 1000 + 500);
    
--  SetHide(self, 0)
    
    PET_SET_ACT_FLAG(self);
    HAWK_FLY_AWAY(self);
    
--  SetHoldMonScp(self, 0);
end

function HAWK_FLY_AWAY(self)

    local owner = GetOwner(self);
    local roost = GetExArgObject(owner, "HAWK_ROOST");
    if roost ~= nil then
--      UnHoldMonScp(self);
        SetHoldMonScp(self, 0);
        LOCK_HAWK_ACTION(self, 0);
        return;
    end
	
    if IsRunningScript(self, 'SCR_HAWK_FIRSTSTRKIE') == 1 then
        LOCK_HAWK_ACTION(self, 0);
        return;
    end
	
    local flyingAway = GetExProp(self, "FLYING_AWAY");
    if flyingAway == 1 then
        return;
    end
    
    local abilFalconer20 = GetAbility(owner, "Falconer20")
    if abilFalconer20 ~= nil and abilFalconer20.ActiveState == 1 then
        SetHoldMonScp(self, 0);
        LOCK_HAWK_ACTION(self, 0);
        return;
    end
	
    local x, y, z = GET_HAWK_FLY_RANDOM_POS(owner, 300);
    MoveEx(self, x, y, z, 1);   
    FlyMath(self, g_default_hawk_Height + 200, 10, 1);
    SetExProp(self, "FLYING_AWAY", 1);
    sleep(5000);
    local stopFlyAway = GetExProp(self, "STOP_FLY_AWAY");
    if stopFlyAway == 1 then
        SetExProp(self, "STOP_FLY_AWAY", 0);
        return;
    end

    flyingAway = GetExProp(self, "FLYING_AWAY");
    if flyingAway == 1 then
        SetHide(self, 1);
--      UnHoldMonScp(self);
        SetHoldMonScp(self, 0);
        SetExProp(self, "FLYING_AWAY", 0);
    end
    
end

function IS_FLYING_AWAY(self)
    local flyingAway = GetExProp(self, "FLYING_AWAY");
    if flyingAway == 1 then
        return 1;
    end

    return IsHide(self);
end

function GET_HAWK_FLY_RANDOM_POS(owner, range)
    local x, y, z = GetPos(owner);
    local angle = IMCRandom(0, 360);
    angle = DegToRad(angle);
    x = x + math.cos(angle) * range;
    z = z + math.sin(angle) * range;
    x, y, z = GetRandomPos(owner, x, y, z, 1);
    return x, y, z;
end

function FALOCONER2_ABIL(self, hawk, rewardList, sklName)
    sleep(3000)
    local x, y, z = GetPos(self);
    PlayEffectNode(self, 'F_item_drop_light_violet', 1, 'Bip01 Head')
    GIVE_REWARD(self, rewardList, sklName);
end

function HAWK_CALLING(self, skl)

    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
    
    if IS_FLYING_AWAY(hawk) == 1 then
        local _height = GetFlyHeight(hawk)
        local stopFlyAway = GetExProp(hawk, "STOP_FLY_AWAY");
        if stopFlyAway == 1 then
            local x, y, z = GetPos(hawk);
            SetPos(hawk, x, y+_height, z);
        end
        
        HAWK_UNHIDE(hawk, self);
        
        local abil = GetAbility(self, "Falconer2")
        if abil ~= nil and IMCRandom(1,9999) < 5000 then
            RunScript("FALOCONER2_ABIL", self, hawk, "SKILL_FALCONER_CALLING_ABIL", skl.ClassName);
        end
        
        return;
    end

end

function SCR_HAWK_FIRSTSTRKIE(self, owner)
	sleep(2000)
    while 1 do
        if IsZombie(self) == 1 or IsDead(self) == 1 or IsZombie(owner) == 1 or IsDead(owner) == 1 then  
            return;
        end
		
        if IS_LOCK_HAWK_ACTION(self) ~= 1 then
            local target = GetNearTopHateEnemy(owner)
            if nil ~= target and IsBattleState(owner) == 1 and IsRunningScript(self, '_HAWK_BLISTERINGTHRASH') == 0 then
                -- 주인이 공격한 적에게는 음속타 --
                local skl = GetSkill(owner, 'Falconer_BlisteringThrash');
                local Falconer14_abil = GetAbility(owner, "Falconer14");
                if nil ~= skl and nil == Falconer14_abil then
                    RunScript("_HAWK_BLISTERINGTHRASH", self, owner, skl, target, 1);
                    local sleepdist = GetDistance(self, target);
                    sleep(sleepdist * 50);
                end
            end

            if IsRunningScript(self, '_HAWK_HOVERING') ~= 1 and IsRunningScript(self, '_HAWK_BLISTERINGTHRASH') == 0 then
                local list, cnt = SelectObject(owner, 100, "ENEMY")
                if cnt > 0 then
                    local obj = list[1];
                    local attacker = GetNearTopHateEnemy(obj)
                    -- 주인 근처로 오는 적은 호버링 --
                    local skl = GetSkill(owner, 'Falconer_Hovering');
                    local Falconer13_abil = GetAbility(owner, "Falconer13");
                    if nil ~= skl and nil == Falconer13_abil and nil ~= attacker and GetHandle(attacker) == GetHandle(owner) then
                        RunScript("_HAWK_HOVERING", self, owner, skl, obj, 1);
                        local sleepdist = GetDistance(self, obj);
                        sleep(sleepdist * 50);
                    end
                end 
            end
        end
        sleep(1000);
    end
end

function SCR_FIRSTSTRIKE_ADD_DAMAGE_SET(pc)
	local firstStrikeBuff = GetBuffByName(pc, 'FirstStrike_Buff');
	if firstStrikeBuff ~= nil then
		local firstStrikeAddRate = 0;
		local firstStrikeSkill = GetSkill(pc, 'Falconer_FirstStrike');
		if firstStrikeSkill ~= nil then
			local firstStrikeLevel = TryGetProp(firstStrikeSkill, 'Level');
			if firstStrikeLevel == nil then
				firstStrikeLevel = 0;
			end
			
			SetExProp(firstStrikeBuff, 'FIRSTSTRIKE_LEVEL', firstStrikeLevel);
		end
	end
end

function SCR_BUFF_ENTER_FirstStrike_Buff(self, buff, arg1, arg2, over)

    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
	
    StopRunScript(hawk, 'SCR_HAWK_FIRSTSTRKIE');
    RunScript('SCR_HAWK_FIRSTSTRKIE', hawk, self);
end

function SCR_BUFF_UPDATE_FirstStrike_Buff(self, buff, arg1, arg2, over)
	local skill = GetSkill(self, "Falconer_FirstStrike")
	if skill == nil then
		return
	end
	
	local spendSP = 30 + (skill.Level * 3)
	local sp = TryGetProp(self, "SP")
	local abilFalconer19 = GetAbility(self, "Falconer19")
	if abilFalconer19 ~= nil and abilFalconer19.ActiveState == 1 then
		spendSP = spendSP + 5
	end
	
	if sp < spendSP then
		return 0;
	end
	
	AddSP(self, -spendSP)
	
	return 1;
end

function SCR_BUFF_LEAVE_FirstStrike_Buff(self, buff, arg1, arg2, over)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end
	
    StopRunScript(hawk, 'SCR_HAWK_FIRSTSTRKIE');
end

function SCR_BUFF_RATETABLE_FirstStrike_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'FirstStrike_Buff') == 'YES' then
		if skill.ClassName == 'Falconer_Hovering' or skill.ClassName == 'Falconer_BlisteringThrash' then
			local firstStrikeLevel = GetExProp(buff, 'FIRSTSTRIKE_LEVEL');
			if firstStrikeLevel ~= nil then
				rateTable.DamageRate = rateTable.DamageRate + (firstStrikeLevel * 0.1);
	            DelExProp(buff, 'FIRSTSTRIKE_LEVEL');
			end
		end
		
		local hp = TryGetProp(self, 'HP')
		local mhp = TryGetProp(self, 'MHP')
		local hpValue = hp / mhp
		local abilFalconer19 = GetAbility(from, 'Falconer19')
		if abilFalconer19 ~= nil and abilFalconer19.ActiveState == 1 then
			local addCrtRate = abilFalconer19.Level * 1000
			if hpValue == 1 then
				rateTable.crtRatingAdd = rateTable.crtRatingAdd + addCrtRate;
			end
		end
    end
end

function HAWK_AIMING(self, skl)
    local hawk = GetSummonedPet(self, PET_HAWK_JOBID);
    if hawk == nil then
        return;
    end

--    if IsRunningScript(hawk, '_HAWK_AIMING') == 1 then
--		return;
--    end
    
    local x, y, z= Get3DPos(hawk);
    local skill = GetSkill(self, 'Falconer_Aiming');
    local pad = RunPad(hawk, 'Falconer_Aiming', skill, x, y, z, 0, 1)
    if nil == pad then
        return;
    end
    
    local padID = GetPadID(pad);
    SetExProp(hawk, 'AIMING_PAD_ID', padID);
    
    RunScript('_HAWK_AIMING', hawk, self, pad, skill, padID)
end

function _HAWK_AIMING(self, owner, pad, skl, padID)
    
    sleep(1000);
    HAWK_UNREST(self)
	local hoverTime = GetPadLife(pad);
    local startTime = imcTime.GetAppTimeMS();
    while 1 do
        if IsZombie(self) == 1 or IsDead(self) == 1 or IsZombie(owner) == 1 or IsDead(owner) == 1 then  
            return;
        end

        if imcTime.GetAppTimeMS() - startTime > hoverTime then
            break;
        end
		
        if nil == pad then
            break;
        end
        
    	local nowPadID = GetExProp(self, 'AIMING_PAD_ID');
    	if nowPadID ~= padID then
    		KillPad(pad);
    		return;
    	end
		
        if GetPadLife(pad) <= 1000 then
            break;
        end
        sleep(1000);
    end
end


function FLYING_PET_UPDATE_PET_FOOD(owner, compa)
    if compa == nil then
        return;
    end
    
    local startTime = imcTime.GetAppTime() + 1;
    --1초간 스킬 사용 중인지 확인. 사용중이라면 애니 안보여주고 종료 --
    while imcTime.GetAppTime() < startTime do
        if IS_LOCK_HAWK_ACTION(compa) == 1 or IsMoving(owner) == 1 or IsSkillUsing(owner) == 1 then
            SetExProp(compa, "PET_EATING", "0");
            return;
        end
        sleep(100);
    end
    
    LOCK_HAWK_ACTION(compa, 1);
    SetHoldMonScp(compa, 1);

    local aniType = GET_PET_FOOD_ANIM_TYPE(owner, compa);
    local feedCls = GET_PET_FOOD_ANIM_CLASS(owner, compa, aniType);
    if nil == feedCls then
        IMC_LOG("INFO_NORMAL", "CompanionFeedAnim data is nil className is " .. compa.ClassName);
        SetExProp(compa, "PET_EATING", "0");
        SetHoldMonScp(compa, 0);
        LOCK_HAWK_ACTION(compa, 0);
        return;
    end
    
    PlayAnim(owner, feedCls.PCAnim, 1, 0);

    local useEquipAni = PET_FOOD_USE_EQUIP_ANIM(feedCls);
    local feedMonster = PET_FOOD_CREATE_FEED_AS_MONSTER(owner, feedCls);
        
    if useEquipAni == true then
        PlayEquipItem(owner, "RH", feedCls.ClassName, 1);
    end

    sleep(500);


    if compa ~= nil and GetNearTopHateEnemy(compa) == nil then
                
        local isResting = GetExProp(compa, "IS_IN_ROOST");

        if aniType == "Shoulder" then
            local angle = GetDirectionByAngle(owner);
            SetDirectionByAngle(compa, angle);
        elseif isResting ~= 1 then
            LookAt(compa, owner);
        end
                    
        PET_FOOD_SHOW_EMOTION(compa);

        if  isResting == 1 then
            HAWK_UNREST(compa);
            sleep(500);
        end
                    
        local needToFlyUp = false;

        if aniType == "Shoulder" then
            ForcePlayAttachedAnim(compa, feedCls.ComAnim);
        else
            UPDATE_PET_FOOD_FOLLOW_FEED_FLYING(owner, compa, startTime);
            needToFlyUp = true;
            sleep(1000);
            PlayAnim(compa, feedCls.ComAnim, 1, 0);
        end
                
        if feedMonster ~= nil then
            local feedAnim = TryGetProp(feedCls, "FeedAnim");
            if feedAnim ~= nil or feedAnim ~= "None" then
                PlayAnim(feedMonster, feedAnim, 1, 0);
            end
        end

        sleep(500);

        if useEquipAni == true then
            PlayEquipItem(owner, "RH", feedCls.ClassName, 0);
        end
        if feedMonster ~= nil then
            SetLifeTime(feedMonster, 2, 1);
            feedMonster = nil;
        end

        if needToFlyUp == true then
            sleep(3000);
            StopAnim(compa);
            FlyMath(compa, g_default_hawk_Height, 1, 1, 1);
        end
                    
        if aniType == "Shoulder" then
            sleep(1100);
            ForcePlayAttachedAnim(compa, "SIT");
        end

        StopAnim(owner);
                
        --컴패니언 어깨에 앉아있으면 애니 끝날때까지 주인도 움직이지 못하도록--
        if aniType == "Shoulder" then
            sleep(feedCls.Sleep);
            UPDATE_PET_LAST_ACT_TIME(compa);
        else
            sleep(feedCls.Sleep);
            PET_SET_ACT_FLAG(compa);
        end
    end

    StopAnim(owner);
    StopAnim(compa);
    if useEquipAni == true then
        PlayEquipItem(owner, "RH", feedCls.ClassName, 0);
    end
    if feedMonster ~= nil then
        SetLifeTime(feedMonster, 2, 1);
    end
    PlayAnim(compa, "STD", 1, 0);
    
    SetExProp(compa, "PET_EATING", "0");
--  UnHoldMonScp(compa);
    SetHoldMonScp(compa, 0);
    LOCK_HAWK_ACTION(compa, 0);
end