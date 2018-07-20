-- simpleai.lua

function SAI_HOMEPOS(self, range)

    local dist = GetMyHomeDistance(self);
    if dist <= range then
        return 0;
    end

    CancelMonsterSkill(self);
    ResetHate(self);

    while 1 do
        ChangeMoveSpdType(self, "RUN");
        MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);      
        if GetMyHomeDistance(self) <= 15 then
            return 1;
        end

        sleep(500);
    end

    return 1;

end

function SAI_PARENT_POS_NOSLEEP(self, range)

    local _isMoving = IsMoving(self);
    local owner = GetOwner(self);
    local dist = GetDistance(self, owner);
    if dist <= range then
        return 0;
    end

    CancelMonsterSkill(self);
    ResetHate(self);
    ChangeMoveSpdType(self, "RUN");
    if owner == nil then
        return 0;
    end

    local distance = 50;
    MoveToOwner(self, distance);
    return 1;

end


function SAI_FOLLOW_POS(self, range)
    local _pc = GetOwner(self)
    if _pc ~= nil then
        local x, y, z = GetPos(_pc)
        local opt, x1, y1, z1 = GetTacticsArgFloat(self)
        if opt == 1 then
            if IsNearFrom(_pc, x1, z1, range) == 'YES' then
                return 1
            else
                MoveEx(self, x1, z1, 1)
                local x2, y2, z2 = GetPos(_pc)
                SetTacticsArgFloat(self, 1, x2, y2, z2)
                return 0
            end
        else
            SetTacticsArgFloat(self, 1, x, y, z)
            return 1
        end
    else
        Kill(self)
    end
    return 0
end

function SAI_PARENT_POS_FOR_HOMUNCLUS(self, range)
    if IsChasingSkill(self) == 1 then
        sleep(1500);
        return 1;
    end
    
    if GetBuffByName(self, 'Pet_Dead') ~= nil then
        sleep(1000);
        return 1;
    end

    local owner = GetOwner(self);
    if owner == nil then
        return 0;
    end

    local dist = GetDistance(self, owner);
    if dist <= range then
        sleep(1500);
        return 0;
    end

    ResetHate(self);

    local moveType = TryGetProp(self, "MoveType");
    while 1 do
        ChangeMoveSpdType(self, "RUN");
        owner = GetOwner(self);
        if owner == nil then
            return 0;
        end

        if moveType ~= nil and moveType ~= 'Holding' then
            MoveToOwner(self, 30);
        end

        local distance = GetDistance(self, owner);
        if distance <= 30 then
            return 1;
        elseif distance >= 300 then
            StopMove(self);
            local x,y,z = GetActorRandomPos(owner, 30);
            SetPos(self, x, y, z);
            CancelMonsterSkill(self)
            return 1;
        end

        sleep(500);
    end

    return 1;
end

function SAI_PARENT_POS(self, range)

    local owner = GetOwner(self);
    if owner == nil then
        return 0;
    end

    local dist = GetDistance(self, owner);
    if dist <= range then
        return 0;
    end

    CancelMonsterSkill(self);
    ResetHate(self);


    local moveType = TryGetProp(self, "MoveType");
    while 1 do
        ChangeMoveSpdType(self, "RUN");
        owner = GetOwner(self);
        if owner == nil then
            return 0;
        end

        if moveType ~= nil and moveType ~= 'Holding' then
            MoveToOwner(self, 30);
        end

        local distance = GetDistance(self, owner);
        if distance <= 30 then
            return 1;
        elseif distance >= 300 then
            StopMove(self);
            local x,y,z = GetActorRandomPos(owner, 30);
            SetPos(self, x, y, z);
            CancelMonsterSkill(self)
            return 1;
        end

        sleep(500);
    end


    return 1;
end

function SAI_PARENT_POS_WARP(self, range, warp_range)

    local _isMoving = IsMoving(self);
    local owner = GetOwner(self);
    if owner == nil then
        return 0;
    end
    local dist = GetDistance(self, owner);
    if dist <= range then
        return 0;
    end

    CancelMonsterSkill(self);
    ResetHate(self);
    ChangeMoveSpdType(self, "RUN");

    if dist >= warp_range then
        local x, y, z = GetPos(owner);
        local rx, ry, rz = GetRandomPos(owner, x, y, z, 10);
        SetPos(self, rx, ry, rz);
    end

    MoveToOwner(self, 50);
    return 1;

end

function S_AI_ATTACK_POINT(self, range, pointScp)
    
    local target = SelectByPoint(self, pointScp, "ENEMY");
    local owner = GetOwner(self)
    local dist = -1
    if target ~= nil and owner ~= nil then
        dist = GetDistance(owner, target);
    end
    
    if IsChasingSkill(self) == 1 then
        if IsSameObject(GetSkillTarget(self), target) == 1 and (dist > 0 and dist < range) then
            return 1;
        end
    end

    if range > 0 then
        SetTendencysearchRange(self, range);
    end

    --SetTendency(self, 'Attack')
    if target == nil then
        return 0;
    end

    ChangeMoveSpdType(self, "RUN");
    
    local selectedSkill = SelectMonsterSkillByRatio(self);
    if selectedSkill == "None" then
        return 0;
    end
    
    if IsDead(target) == 0 and (dist > 0 and dist < range) then
        UseMonsterSkill(self, target, selectedSkill);
    end
    
    return 1;
end

function SORT_BY_COOLDOWN(a, b)
    return a.CoolDown < b.CoolDown
end

function S_AI_ATTACK_NEAR_FOR_HOMUNCLUS(self, range)
    if IsChasingSkill(self) == 1 then
        if IsSameObject(GetSkillTarget(self), GetNearTopHateEnemy(self)) == 1  then
            return 1;
        end
    end

    if GetBuffByName(self, 'Pet_Dead') ~= nil then
        sleep(1000);
        return 1;
    end

    local cnt = GetScpHoldCount(self);
    if cnt > 0 then
        return 1;
    end
    
    local currentTime = math.floor(imcTime.GetAppTime());
    local delayTime = GetExProp(self, "COOLTIME");
    if currentTime < delayTime then
        return 1;
    end
    
    local owner = GetOwner(self);
    if nil == owner then
        return 0;
    end

    local target = GetNearTopHateEnemy(owner);
    if target == nil then
        return 0;
    end
    
    local buff = GetBuffByName(owner, 'Homunculus_Skill_Buff');
    if nil == buff then
        return 0;
    end

    local sklList = {};
    for i = 1, 4 do
        local sklName = GetExProp_Str(self, 'SKL_NAME_'..i)
        if sklName ~= 'None' then
            local skl = GetSkill(owner, sklName);
            if nil ~= skl then
                sklList[#sklList+1] = skl;
            end
        end
    end

    local sklLen = #sklList;
    if 0 >= sklLen then
        return;
    end
    
    local rateCls = {40, 30, 20, 10};
    local value = 80 + (sklLen -1) * (-10);
    local totalRate = (sklLen * value) / 2;

    table.sort(sklList, SORT_BY_COOLDOWN);

    local ratio = IMCRandom(1, totalRate)
    local useSkl = nil;
    for i = sklLen, 1, -1 do
        local skl = sklList[i];
        ratio = ratio - rateCls[i];
        if 0 >= ratio then
            useSkl = skl
            break;
        end
    end

    if nil == useSkl then
        return;
    end
    
    SetTendency(self, 'Attack')
    SetTendencysearchRange(self, range);
    LookAt(self, target);
    
    StopMove(self); 
    local usecnt = 1;
    if useSkl.ClassName == 'Cryomancer_SubzeroShield' then
        usecnt = 2;
    end
    MonsterUsePCSkill(self, useSkl.ClassName, useSkl.Level, usecnt, nil, 1);
    SetExProp(self, 'COOLTIME', math.floor(currentTime + 20));
    sleep(500);
    PlayAnim(self, 'TK')
end

function SAI_CHECK_OWNER_BATTLE_STATE(self, allowedTime)
    local owner = GetOwner(self);
    if owner == nil then
        return 0;
    end

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
    return 0;
end

function S_AI_ATTACK_NEAR(self, range)
    if GetExProp(self, 'NOT_ALLOW_ATTACK') == 1 then
        return 0;
    end

    if IsChasingSkill(self) == 1 then
        return 1;
    end

    if range > 0 then
        SetTendencysearchRange(self, range);
    end

    --SetTendency(self, 'Attack')
    local target = GetNearTopHateEnemy(self);
    if target == nil then
        return 0;
    end

    ChangeMoveSpdType(self, "RUN");

    if self.MonRank == "Boss" then
        if 1 == BT_SHOOT_MISSILE(self, target) then
            return 1;
        end

        local summons = self.Summons;
        if summons ~= "None" then
            if 1 == BT_BOSS_SUMMON(self, target, summons) then
                return 1;
            end
        end
    end

    local selectedSkill = SelectMonsterSkillByRatio(self);
    if selectedSkill == "None" then
        return 0;
    end
    
    UseMonsterSkill(self, target, selectedSkill);
    return 1;
end

function S_AI_ATTACK_NEAR_HEIGHT(self, range)
    if IsChasingSkill(self) == 1 then
        if IsSameObject(GetSkillTarget(self), GetNearTopHateEnemy(self)) == 1  then
            return 1;
        end
    end

    if range > 0 then
        SetTendencysearchRange(self, range);
    end

    --SetTendency(self, 'Attack')
    local target = GetNearTopHateEnemy(self);
    if target == nil then
        return 0;
    end
    
    
    
    ChangeMoveSpdType(self, "RUN");

    if self.MonRank == "Boss" then
        if 1 == BT_SHOOT_MISSILE(self, target) then
            return 1;
        end

        local summons = self.Summons;
        if summons ~= "None" then
            if 1 == BT_BOSS_SUMMON(self, target, summons) then
                return 1;
            end
        end
    end

    local selectedSkill = SelectMonsterSkillByRatio(self);
    if selectedSkill == "None" then
        return 0;
    end
    
    local tX,tY,tZ = GetPos(target)
    local mX,mY,mZ = GetPos(self)
    
    local skillRange = GetClassNumber('Skill', selectedSkill, 'SklSplRange')
    local skillHeight = GetClassNumber('Skill', selectedSkill, 'SplHeight')
    local dist = GetDistance(self, target)
    local distheight = math.abs(tY - mY)
    if distheight > skillHeight and dist > skillRange then
        ChangeMoveSpdType(self, "RUN");
        MoveToTarget(self, target, skillRange)
        return 0
    end
    
    UseMonsterSkill(self, target, selectedSkill);
    return 1;
end

function S_AI_ATTACK_SKILL(self, range, skillName)

    local target = GetNearTopHateEnemy(self);   
    if target == nil then
        return 0;
    end
    
    UseMonsterSkill(self, target, skillName);
    return 1;
end

function S_AI_ATTACK_SKILL_FRONT(self, skillName)

    UseMonsterSkillToFront(self, skillName);
    return 1;
end

function S_AI_HITATTACK_SKILL_FRONT(self, from, skill, damage, ret, skillName)

    UseMonsterSkillToFront(self, skillName);
    return 1;
end

function S_AI_HITATTACK_SKILL_ATKER_DIR(self, from, skill, damage, ret, skillName, atkerType)

    if atkerType == 2 then
        if IS_PC(from) == false then
            return;
        end
    elseif atkerType == 3 then
        if target.GroupName ~= 'Monster' then
            return;
        end
    end

    local x, y = GetDirection(from);
    UseMonsterSkillToDir(self, skillName, x, y);
    return 1;
end

function S_AI_DAMAGE_ADDHATE(self, from, skill, damage, ret, hate_point)
    if hate_point ~= nil then
        InsertHate(self, from, hate_point)
    else
        InsertHate(self, from, 1)
    end
    return 1;
end

function S_AI_SET_TENDENCY(self, tendency)
    SetTendency(self, tendency);
    return 0;
end

function S_AI_SET_MGAME_OWNER(self, objListPtr, dieWhenOwnerDie)
    if GetOwner(self) ~= nil then
        return 0;
    end

    local objList = GetGameObjListByPtr(self, objListPtr);
    if #objList == 0 then
        return 0;
    end

    SetOwner(self, objList[1], dieWhenOwnerDie);
    return 0;
end

function S_AI_SET_MGAME_PC_OWNER(self, dieWhenOwnerDie)
    if GetOwner(self) ~= nil then
        return 0;
    end

    if GetLayer(self) ~= 0 then
        local list, cnt = GetLayerPCList(self);
        if cnt == 0 then
            return 0;
        end
        SetOwner(self, list[1], dieWhenOwnerDie);
    else
        return 0;
    end
    return 0;
end




function S_AI_MINIMAP(self)
    EnableMonMinimap(self, 1);
end

function S_AI_INDICATOR(self)
    EnableMonIndicate(self);
end

function S_AI_DISABLE_TARGETSELECT(self)
    SetEnableTargetSelect(self, 0);
end

function S_AI_SET_FACTION(self, faction)
    SetCurrentFaction(self, faction);
    return 0;
end

function S_AI_ATTACH_TO_PC(self, range, nodeName, msgText, actorScp)
    local curOwner = GetOwner(self);
    if curOwner ~= nil then
        return 0;
    end
        
    local list, cnt = SelectObjectByClassName(self, range, 'PC');

    for i = 1  ,cnt do
        local pc = list[i];
        if IsDead(pc) == 0 then
            SET_ATTACH_OWNER(self, pc, nodeName);
            if msgText ~= "" then
                CHARICON_MSG(pc, msgText);
            end

            if actorScp ~= "None" then
                RunActorScp(pc, actorScp);
            end

            return 0;
        end
    end

    return 0;
end

function S_AI_ATTACK_PHASE(self)

    while 1 do
        local btRet = BT_BOSS_ATTACK_PHASE(self);
        if btRet == BT_FAILED then
            return 0;
        elseif  btRet == BT_SUCCESS then
            return 1;
        end

        sleep(1000);
    end

end

function S_AI_PHASE_RMOVE(self)
    BT_BOSS_READY(self);
    return 1;
end

function SAI_R_MOVE(self)

    if self.MoveType ~= 'Holding' then
        SCR_RANDOM_MOVE(self);
    end
    return 0;
end

function S_AI_MOVE_TO_ENEMY(self, searchDist)
    local target = GetNearTopHateEnemy(self);
    if target == nil then
        local list, cnt = SelectObject(self, searchDist, 'ENEMY');
        if cnt > 0 then
            target = list[1];
            InsertHate(self, target, 1);            
        else
            return 0;
        end
    end
    
    local dist = GetDistance(self, target);
    if dist >= searchDist then
        StopMove(self);
        return 0;
    end
    
    MoveToTarget(self, target, 1);
    return 1;
end

function SAI_LOOKAT(self)
    if GetOwner(self) ~= nil then
        LookAt(self, GetOwner(self))
        return 0
    else
        return 0
    end
end

function S_AI_MOVE_RALLY_SELF(self, aiCls, index, x, y, z)

    if 1 == aiCls:IsIndexEnded(index) then
        return 1;
    end

    local userPos = aiCls:GetUserPos(index);
    if userPos == nil then
        aiCls:SetUserPos(index, x, y, z);
        userPos = aiCls:GetUserPos(index);
        aiCls:SetExtraArgPushed(index);
    end

    local isMovingToDest = false;
    if IsMoving(self) == 1 then
        local dx, dz = GetMoveToPos(self);
        local destDist  = math.dist(dx, dz, userPos.x, userPos.z);
        if destDist <= 10 then
            isMovingToDest = true;
        end
    end

    if false == isMovingToDest then
        local cx, cy, cz = GetPos(self);
        local distToDest = math.dist(cx, cz, userPos.x, userPos.z);
        if distToDest <= 5 then
            aiCls:SetIndexEnded(index);
            return 0;
        end
        
        MoveEx(self, userPos.x, userPos.y, userPos.z, 1);
        return 1;
    end

    if isMovingToDest == true then
        local dist = GetDistFromMoveDest(self);
        if dist <= 10 then
            aiCls:SetIndexEnded(index);
            return 0;
        else
            return 1;
        end
    end
    
    return 0;
end
    
function S_AI_MOVE_RALLY(self, aiCls, index, x, y, z)

    if 1 == aiCls:IsIndexEnded(index) then
        return 1;
    end

    local userPos = aiCls:GetUserPos(index);
    if userPos == nil then
        aiCls:SetUserPos(index, x, y, z);
        userPos = aiCls:GetUserPos(index);
        aiCls:SetExtraArgPushed(index);
    end

    local isMovingToDest = false;
    if IsMoving(self) == 1 then
        local dx, dz = GetMoveToPos(self);
        local destDist  = math.dist(dx, dz, userPos.x, userPos.z);
        if destDist <= 10 then
            isMovingToDest = true;
        end
    end

    if false == isMovingToDest then
        local cx, cy, cz = GetPos(self);
        local distToDest = math.dist(cx, cz, userPos.x, userPos.z);
        if distToDest <= 5 then
            aiCls:SetIndexEnded(index);
            return 0;
        end
        
        MoveEx(self, userPos.x, userPos.y, userPos.z, 1);
        return 1;
    end

    if isMovingToDest == true then
        local dist = GetDistFromMoveDest(self);
        if dist <= 10 then
            aiCls:SetIndexEnded(index);
            return 0;
        else
            return 1;
        end
    end
    
    return 0;
end

function S_AI_RESET_RALLY(self, aiCls, index)
    aiCls:ClearRallyInsts();
    return 0;
end

function SAI_COND_POS(self, x, y, z, range)

    if GetDistFromPos(self, x, y, z) <= range then
        return 1;
    end
    
    return 0;

end


function SAI_COND_BALLISTA(self)

    local dx, dz =  GetDirection(self)

    if GetExProp(self, "SetPos") == 0 then
        local owner = GetOwner(self);
        local ownerX, ownerY, ownerZ = GetPos(owner)
        SetExProp_Pos(self, "OwnerPos", ownerX, ownerY, ownerZ);
        SetExProp(self, "SetPos", 1)
    end

--[[
local backRangeX, backRangeY

if dx > 0 then
    backRangeX = -20;
elseif dx == 0 then
    backRangeX = 0
else
    backRangeX = 20;
end

if dz > 0 then
    backRangeY = -20;
elseif dx == 0 then
    backRangeY = 0
else
    backRangeY = 20;
end
]]--

    local x, y, z = GetExProp_Pos(self, "OwnerPos")

    local list, cnt = SelectObjectPos(self, x, y, z, 15, "FRIEND", 1, 0)
    if cnt > 0 then
        return 0
    end

return 1

end



function SAI_COND_BUFF_OVER(self, buffName, buffOver)

    local buf = GetBuffByName(self, buffName);
    if buf == nil then
        return 0;
    end

    if GetOver(buf) >= buffOver then
        return 1;
    end

    return 0;

end

function SAI_COND_EVERYTIME_EXEC(self, sec)
    local lastTime = GetExProp(self, "_SAI_TIME");
    local curTime = imcTime.GetAppTime();
    if lastTime == 0 or curTime > lastTime + sec then
        SetExProp(self, "_SAI_TIME", curTime);
        return 1;
    end

    return 0;
end

function SAI_COND_EVERYTIME(self, sec)
    local lastTime = GetExProp(self, "_SAI_TIME");
    local curTime = imcTime.GetAppTime();
    if lastTime == 0 then
        SetExProp(self, "_SAI_TIME", curTime);
        return 0;
    end
    
    if curTime > lastTime + sec then
        SetExProp(self, "_SAI_TIME", curTime);
        return 1;
    end

    return 0;
end

function S_AI_RUN_SIMPLEAI(self, aiName, stopAllAI)
    if stopAllAI == 1 then
        RunSimpleAIOnly(self, aiName);
    else
        RunSimpleAI(self, aiName);
    end
    return 1;
end

function S_AI_STOP_THIS_AI(self)
    return -1;
end

function S_AI_HOLD(self, holdMS)
    HoldScpForMS(self, holdMS);
end

function S_AI_SLEEP(self, sleepSec)

    sleep(sleepSec);
    return 0;

end

function S_AI_DIALOG_ROTATE(self, rotate)
    SetDialogRotate(self, rotate)
    return 0;
end

function S_AI_SET_BTREE(self, bt)
    local btree
    if bt == 1 then
        btree = 'BT_Dummy';
    elseif bt == 2 then
        btree = 'BasicBoss';
    elseif bt == 3 then
        btree = 'BasicBoss_Field';
    elseif bt == 4 then
        btree = 'BasicMonster';
    elseif bt == 5 then
        btree = 'TrackWaitMonster';
    else
        btree = 'None';
    end
    
    SetBTree(self, CreateBTree(btree))
    return 0;
end

function S_AI_SET_BTREE_ENTER(self, bt)
    local btree = bt
    SetBTree(self, CreateBTree(btree))
    return 0;
end

function S_AI_SOBJ_ADD(self, tgtType, sObjName, propName, propValue)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    if tgt == nil then
        return;
    end

    ACTORSCP_SOBJ(tgt, sObjName, propName, propValue);
end

function S_AI_UI_FORCE(self, tgtType, forceName, image, imgSize, addon, child, cnt)

    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    if tgt == nil then
        return;
    end

    PlayUIForce(tgt, nil, forceName, image, imgSize, addon, child, cnt);
    return 0;
end


function SAI_ACTORSCP(self, tgtType, scpName)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    RunActorScp(tgt, scpName);
    return 0;
end

function S_AI_EFFECT(self, tgtType, eftName, scl, offset)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    PlayEffect(tgt, eftName, scl, offset);
    return 0;
end

function S_AI_EFFECT_NODE(self, tgtType, eftName, scl,  node)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    PlayEffectNode(tgt, eftName, scl, node)
    return 0;
end

function S_AI_CHANGE_COLOR(self, r, g, b, a, s)
    ObjectColorBlend(self, r, g, b, a, s);
    return 0;
end

function S_AI_EFFECT_ATTACH(self, tgtType, eftName, scl, offset)

    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    AttachEffect(tgt, eftName, scl, offset);
    return 0;
end

function S_AI_EFFECT_DEATCH(self, tgtType, scl, eftName)

    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    DetachEffect(tgt, eftName);
    return 0;
end

function S_AI_BUFF(self, tgtType, buffName, lv, arg2, applyTime, over, rate)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    ADDBUFF(self, tgt, buffName, lv, arg2, applyTime, over, rate);
    return 0;
end

function S_AI_ADD_HATE_AROUND(self, range, hatevalue, MaxCnt)
    if range <= 0 then
        range = 50
    end
    if hatevalue <= 0 then
        hatevalue = 1
    end
    
    if MaxCnt == 0 then
        local list, cnt = SelectObject(self, range, 'ENEMY')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                InsertHate(self, list[i], hatevalue)
            end
        end
    else
        local list, cnt = SelectObject(self, range, 'ENEMY')
        if cnt > 0 then
            if MaxCnt > cnt then
                MaxCnt = cnt
            end
            local i
            for i = 1, MaxCnt do
                InsertHate(self, list[i], hatevalue)
            end
        end
    end
    return 0;

end

function S_AI_ADD_HATE(self, MGameObj)
    if MGameObj ~= nil then
    
        for i = 1 , #MGameObj do
            InsertHate(self, MGameObj[i], 9999)
        end
    end

    return 0;

end

function S_AI_REMOVE_BUFF(self, tgtType, buffName)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    RemoveBuff(tgt, buffName);
    return 0;
end

function S_AI_CHAT(self, tgtType, msg, lifeTime)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    Chat(tgt, msg, lifeTime);
    return 0;
end

 
function S_AI_CHAT_DRT(self, script, quest_name, quest_state)
    local _func = _G[script]
    return _func(self, quest_name, quest_state)
end


function S_AI_KILL_FOL(self, tgtType)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    SCR_KILL_ALL_FOLLOWER(tgt);
    return 0;
end

function S_AI_SAFE_HIDE(self, tgtType, isOn)

    local tgt = GET_SAI_TARGET(self, nil, tgtType); 
    if isOn == 1 then
        SET_INVIN(tgt, nil, 1);
        ShowModel(tgt, 0);
    else
        SET_INVIN(tgt, nil, 0);
        ShowModel(tgt, 1);
    end

    return 0;
        
end

function S_AI_SPIN(self, delay, count, spinPerSec, acceltime)

    SpinObject(self,delay,count,spinPerSec,acceltime);

    return 0;
        
end


function S_AI_SETPOS(self, tgtType, x, y, z)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    SetPos(tgt, x, y, z);
    return 0;
end

function S_AI_SETPOS_SERV(self, tgtType, x, y, z)
    local tgt = GET_SAI_TARGET(self, nil, tgtType);
    SetPosInServer(tgt, x, y, z);
    return 0;
end

function GET_SAI_TARGET(self, attacker, tgtType)
    if tgtType == 0 then
        return self;
    elseif tgtType == 1 then
        return GetNearTopHateEnemy(self);
    elseif  tgtType == 2 then
        return GetOwner(self);
    elseif tgtType == 3 then
        return attacker;
    end

    return self;
end

function SAI_CK_MVALUE_RUN(self, valueName, value, script)
    local val = GetMGameValue(self, valueName);
    if val ~= nil then
        if val == value then
            RunScript(script, self, valueName, value)
        end
    end
    return 0;
end

function SAI_ONLY_MVALUE_RUN(self, valueName, script)
    local val = GetMGameValue(self, valueName);
    if val ~= nil then
        RunScript(script, self, valueName)
    end
    return 0;
end

function SAI_ADD_MGAME_V_TAKEDMG(self, from, skill, damage, ret, valueName, value)
    local val = GetMGameValue(self, valueName);
    SetMGameValue(self, valueName, val + value);
    return 0;
end

function SAI_ADD_MGAME_V(from, valueName, value)
    local val = GetMGameValue(from, valueName);
    SetMGameValue(from, valueName, val + value);
    return 0;
end

function SAI_SET_MGAME_V(self, valueName, value)
    SetMGameValue(self, valueName, value);
    return 0;
end

function S_AI_PROVOKE_NEAR(self, range, provokeEffect, effectScale)

    local list, cnt = SelectObject(self, range, 'ENEMY');
    for i = 1, cnt do
        local target = list[i];
        if GetObjType(target) == OT_MONSTERNPC and target.MonRank ~= 'Boss' and target.MonRank ~= 'NPC' then
            
            local topAttacker = GetTopHatePointChar(target)
            if topAttacker ~= nil then
            
                local atkerHate = GetHate(target, topAttacker);
                local myHate = GetHate(target, self);
                
                if atkerHate > myHate then
                    local addHate = atkerHate * 3 + (atkerHate - myHate);
                    InsertHate(target, self, addHate);                  
                end
            else                
                InsertHate(target, self, 100);
            end
            
            if provokeEffect ~= 'None' then
                PlayEffect(target, provokeEffect, effectScale);
            end
        end
    end

    return 0;

end



function S_AI_PART_UNHIDE(self, times)
    ObjectColorBlend(self, 255, 255, 255, 50, 1);
    CreateSessionObject(self, 'SSN_S_AI_PART_UNHIDE', 1)
    local add_ssn = GetSessionObject(self, 'SSN_S_AI_PART_UNHIDE')
    add_ssn.NumArg1 = 0
    add_ssn.Count = 205/times
end





function SCR_CREATE_SSN_S_AI_PART_UNHIDE(self, sObj)

end

function SCR_REENTER_SSN_S_AI_PART_UNHIDE(self, sObj)

end

function SCR_DESTROY_SSN_S_AI_PART_UNHIDE(self, sObj)
end



function S_AI_SERCH_OBJ_PLAY(self, range, obj_class, script)
    local list, Cnt = SelectObjectByClassName(self, range, obj_class)
    local i
    for i = 1 , Cnt do
        if Cnt >= 1 then
            RunScript(script, self, list[i])
            return 0;            
        end
        break
    end
    return 0;
end



function S_AI_SERCH_OBJ_ALL(self, range, obj_class, script)
    local list, Cnt = SelectObjectByClassName(self, range, obj_class)
    local i
    for i = 1 , Cnt do
        if Cnt >= 1 then
            RunScript(script, self, list[i])
        end
        break
    end
    return 0;
end



function S_AI_SSN_LAYER_ACTOR(self, sObj_name, script)

    local list, cnt = GetLayerPCList(self);
    local i
    for i = 1, cnt do
        local quest_ssn = GetSessionObject(list[i], sObj_name)
        if quest_ssn ~= nil then
            RunScript(script, list[i], quest_ssn)
        end
    end
    return 0;
end

function S_AI_FUNC_LAYER_ACTOR(self, script)

    local list, cnt = GetLayerPCList(self);
    local i
    for i = 1, cnt do
        RunScript(script, self, list[i])
    end
    return 0;
end
    


function THORN_GOTO_CENTER_01(self, tgt_obj)
    local obj_ssn = GetSessionObject(tgt_obj, 'SSN_S_AI_PART_UNHIDE')
    if self.NumArg1 == 0 then
        if obj_ssn ~= nil then
            ADD_S_AI_PART_UNHIDE(tgt_obj)
            self.NumArg1 = 1
        end
    end
    return 0;
end

function ADD_S_AI_PART_UNHIDE(self)
    local add_ssn = GetSessionObject(self, 'SSN_S_AI_PART_UNHIDE')
    add_ssn.NumArg1 = add_ssn.NumArg1 + add_ssn.Count
    if add_ssn.NumArg1 >= 205 then
        ObjectColorBlend(self, 255, 255, 255, 255, 1);
        local tobt = CreateBTree('BasicBoss')
        SetBTree(self, tobt)
        SetTendencysearchRange(self, 200)
        SetTendency(self, 'Attack')
    else
        ObjectColorBlend(self, 255, 255, 255, 50 + add_ssn.NumArg1, 1);
        PlayEffect(self, 'F_warrior_whirlwind_shot_spin')
    end
    return 0;
end



function S_AI_FIXED_ANI(self, anim_name)
    SetFixAnim(self, anim_name)
    return 0;
end



function SAI_FUNC_DIRECT(self, script)
    RunScript(script, self)
    return 0;
end

function SAI_FUNC2_DIRECT(self, script)
    local _func = _G[script]
    if _func == nil then
        IMC_LOG('ERROR_LUA_SCRIPT', 'SAI_FUNC2_DIRECT: Not Exist func['..script..']');
        return;
    end
    return _func(self)
end

function SAI_FUNC2_DIRECT_SLEEP(self, script)
    local _func = _G[script]
    return _func(self)
end

function SAI_ATK_OWNERS_ENEMY(self, range, custom_name, basic_faction, faction)
    local owner = GetOwner(self);
    
    local follower = GetScpObjectList(owner, custom_name)
    if follower[1] ~= nil then
        if IsChasingSkill(self) == 1 then
            if IsSameObject(GetSkillTarget(self), follower[1]) == 1  then
                return 1;
            end
        end
    end
    
    if range > 0 then
        SetTendencysearchRange(self, range);
    end

    SetTendency(self, 'Attack')
    
    local target = follower[1]
    if target == nil then
        if basic_faction ~= 'None' then
            SetCurrentFaction(self, basic_faction)
        end
        return 0;
    end
    
    SetCurrentFaction(self, faction)
    ChangeMoveSpdType(self, "RUN");
    
    local selectedSkill = SelectMonsterSkillByRatio(self);
    if selectedSkill == "None" then
        return 0;
    end

    UseMonsterSkill(self, target, selectedSkill);
    return 0;


end



function SAI_CREATE_MON_RND(self, range, className, monProp, angle_select, lifeTime, simpleAi)
    local mon1obj = CreateGCIES('Monster', className);
    if mon1obj == nil then
        print(className..ScpArgMsg("Auto__BulLeooKi_SilPae!"))
        return nil;
    end
    ApplyPropList(mon1obj, monProp);
    
    local x, y, z = GetPos(self)
    
    local angle
    if angle_select == 0 then
        angle = 0
    elseif angle_select == 45 then
        angle = 45
    elseif angle_select == 90 then
        angle = 90
    elseif angle_select == 135 then
        angle = 135
    elseif angle_select == 180 then
        angle = 180
    elseif angle_select == 225 then
        angle = -135
    elseif angle_select == 270 then
        angle = -90
    elseif angle_select == 315 then
        angle = -45
    elseif angle_select == 1000 then
        local list, cnt = SelectObjectByClassName(self, 250, 'PC')
        local i
        if cnt > 0 then
            for i = 1, cnt do
                angle = GetLookAngle(self, list[i])
                break
            end
        end
    elseif angle_select == 2000 then
        angle = GetAngleToPos(self, x, z)
    end
    
    local layer = GetLayer(self);
    local mon1 = CreateMonster(self, mon1obj, x, y, z, angle, range, 0, layer);
    if mon1 == nil then
        print(className..ScpArgMsg("Auto__MonSeuTeo_SaengSeong_SilPae!"))
        return nil;
    end
    
    SetOwner(mon1, mon, 1);
    if lifeTime > 0 then
        SetLifeTime(mon1, lifeTime);
    end

    if simpleAi ~= nil and simpleAi ~= "None" then
        RunSimpleAI(mon1, simpleAi);
    end

    DelayEnterWorld(mon1);
    EnterDelayedActor(mon1);
    return 0;
end



function SAI_LINK_OBJ(self, targetList, linkEft, fromNode, toNode)

    local objList = GetGameObjListByPtr(self, targetList);
    if #objList == 0 then
        return 0;
    end

    for i = 1 , #objList do
        local target = objList[i];
        LinkObject(self, target, linkEft, fromNode, toNode)
    end
end



function MOVE_WITH_CELL(self, range, cell, position)
    local _isMoving = IsMoving(self);
    local owner = GetOwner(self);
    local dist = GetDistance(self, owner);
    if dist <= range then
        return 0;
    end
    
    CancelMonsterSkill(self);
    ResetHate(self);
    ChangeMoveSpdType(self, "RUN");
    if owner == nil then
        return 0;
    end
    local list = GetCellCoord(owner, cell,  position)
    MoveEx(self, list[1], list[2], list[3], 15)
--  MoveToOwner(self, 50);
    return 1;
end



function MOVE_WITH_CELL(self, range, cell, position)

    local _isMoving = IsMoving(self);
    local owner = GetOwner(self);
    local dist = GetDistance(self, owner);
    if dist <= range then
        return 0;
    end
    
    CancelMonsterSkill(self);
    ResetHate(self);
    ChangeMoveSpdType(self, "RUN");
    if owner == nil then
        return 0;
    end
    local list = GetCellCoord(owner, cell,  position)
    MoveEx(self, list[1], list[2], list[3], 15)
--  MoveToOwner(self, 50);
    return 1;
end

function S_AI_CEHCK_LIFE_TIME_AND_REMOVE_PAD(self, updateMS, padName)
    if 0 >= GetRemainLieftTime(self) - updateMS then
        RemovePad(self, padName);   
    end
end

function S_AI_CRE_PAD(self, x, y, z, angle, padName)
    RunPad(self, padName, nil, x, y, z, angle, 1);
end

function S_AI_REMOVE_PAD(self, padName)
    RemovePad(self, padName);
end


function S_AI_PLAYANI(self, ani_name)
    PlayAnim(self, ani_name)
end

function S_AI_PLAYANI_OP(self, ani_name, freezeanim, skipIfExist, readyTime, animSpd)
    PlayAnim(self, ani_name, freezeanim, skipIfExist, readyTime, animSpd)
end

function SAI_SETRENDER(self, opt)
    if opt == 0 then
        SetRenderOption(self, "Freeze", 1);
    elseif opt == 1 then
        SetRenderOption(self, "Stonize", 1);
    end
end


function SAI_SETRENDER_REMOVE(self, opt)
    if opt == 0 then
        SetRenderOption(self, "Freeze", 0);
    elseif opt == 1 then
        SetRenderOption(self, "Stonize", 0);
    end
end


function S_AI_CUSTOM_SCRIPT(self, script, argNum)

    local func = _G[script];
    return func(self, argNum);

end



function S_AI_ZONEOBJ_VALUE(self, classname, value)
    local zoneObj = GetLayerObject(self);
    if zoneObj[classname] == nil and zoneObj[classname] ~= 0 then
        return 0
    else
        zoneObj[classname] = value
    end
    return 0
end

function S_AI_ZONEOBJ_VALUE_ADD(self, classname, value)
    local zoneObj = GetLayerObject(self);
    if zoneObj.classname == nil and zoneObj.classname ~= 0 then
        return 0
    else
        zoneObj.classname = zoneObj.classname + value
    end
    return 0
end


function S_AI_ZONEOBJ_SETEX_VALUE(self, classname, value)
    
    local zone_Obj = GetLayerObject(self);
    if classname == nil then
        return 0
    else
        SetExProp(zone_Obj, classname, value)
    end
    return 0
end

function S_AI_ZONEOBJ_SETEX_VALUE_ADD(self, classname, value)
    local zone_Obj = GetLayerObject(self);
    SetExProp(zone_Obj, 'FTOWER611_TYPE_AW_01_CK', 0)
    if classname == nil then
        return 0
    else
        local get_exObj = GetExProp(zone_Obj, classname)
        local add_value = get_exObj + value
        if add_value >= 0 then
            SetExProp(zone_Obj, classname, add_value)
        else
            SetExProp(zone_Obj, classname, 0)
        end
    end
    return 0
end



function SAI_CREATE_POS(self)
    local angle = GetDirectionByAngle(self)
    SetTacticsArgFloat(self, self.CreateX, self.CreateY, self.CreateZ, angle)
    return 0
end


function S_AI_PAD_REVERSI(self, radius)

    local x, y, z = GetPos(self)
    local list = SelectPad(self, 'ALL', x, y, z, radius);
    for i = 1 , #list do
        local pad = list[i];
        if IsSameObject(GetPadOwner(pad), self) ~= 1 and GetRelation(self, GetPadOwner(pad)) == "ENEMY" then 
            SetPadParent(pad, self, 1);     
        end
    end

end




function S_AI_GTOWER_DM(self, MgameClassName, valuecnt, txt, icon, time)
    
    if time <= 0 then
        time = 1
    end
    
    local msg_int = "NOTICE_Dm_"..icon;
    
    if MgameClassName == 'DIRECT' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0  then
            local i
            for i = 1, cnt  do
                SendAddOnMsg(list[i], msg_int, txt, time)
            end
        end
    end
    
    if MgameClassName == 'None' or MgameClassName == nil then
        print('Cant find MgameClassName')
        return
    end
    
    
    local val = GetMGameValue(self, MgameClassName)
    
    if val <= 0 then
        return
    end
    if val >= valuecnt then
        return
    end
    local list, cnt = GetLayerPCList(self)
    
    if cnt > 0  then
        local i
        for i = 1, cnt  do
            SendAddOnMsg(list[i], msg_int, txt..'{nl}( '..val..' / '..valuecnt..' )', time)
        end
    end
end


function S_AI_GTOWER_D_DM(self, MgameClassName, valName, valuecnt, txt, icon, time)
    
    if time <= 0 then
        time = 1
    end
    
    local msg_int = "NOTICE_Dm_"..icon;
    
    if MgameClassName == 'DIRECT' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0  then
            local i
            for i = 1, cnt  do
                SendAddOnMsg(list[i], msg_int, txt, time)
            end
        end
    end
    
    if MgameClassName == 'None' or MgameClassName == nil then
        print('Cant find MgameClassName')
        return
    end
    
    local val = GetMGameValueByMGameName(self, MgameClassName, valName)
    if val <= 0 then
        return
    end
    if val >= valuecnt then
        return
    end
    local list, cnt = GetLayerPCList(self)
    
    if cnt > 0  then
        local i
        for i = 1, cnt  do
            SendAddOnMsg(list[i], msg_int, txt..'{nl}( '..val..' / '..valuecnt..' )', time)
        end
    end
end



function S_AI_ATTACK_NEAR_MAXHATECOUNT_CHECK(self, range)
    local topHatePC = GetTopHatePointChar(self);
    if topHatePC == nil then
        local list, cnt = SelectObject(self, range, "ENEMY")
        if cnt >= 1 then
            ResetHate(self)
            local zoneName = GetZoneName(self);
            local classList = GetClassList('Map');
            if classList ~= nil then
                local class = GetClassByNameFromList(classList, zoneName);
                if class ~= nil then
                    local maxHatePC = 1;
                    if class.MaxHateCount ~= nil then
                        maxHatePC = class.MaxHateCount;
                    end
                    
                    for i = 1, cnt do
                        if GetHatedCount(list[i]) < maxHatePC then
                            InsertHate(self, list[i], 1);
                            break;
                        end
                    end
                end
            end
        end
    else
        if IsDead(topHatePC) == 1 then
            ResetHated(self)
        else
            S_AI_ATTACK_NEAR(self, range);
        end
    end
end