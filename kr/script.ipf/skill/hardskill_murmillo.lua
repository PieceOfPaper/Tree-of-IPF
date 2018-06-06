-- hardskill_murmillo.lua

FLOAT_EPSILON = 0.0001;

function IS_ZERO(value)
    if math.abs(value) < FLOAT_EPSILON then
        return true;
    end
    return false;
end

function SKL_KONCKBACK_IN_STRAIGHT_LINE(self, skl, distance, speed, enableDiminish, drawLine)    
    -- 내 위치와 방향을 기준으로 타겟들이 위치해야 할 직선을 구함
    local x, y, z = GetPos(self);
    local dx, dz = GetDirection(self);
    
    -- 직각 직선의 기울기: ax + bz = 0
    -- 우리겜 어차피 8방향이니까 굳이 정확하게 계산 때릴 필요 ㄴㄴ해(캐릭터 볼 때 우하:+x, 우상:+z 축임)
    local a = 1;
    local b = 0;
    local myangle = GetDirectionByAngle(self);
    if myangle > 0 then
        if IS_ZERO(myangle - 45) == true then
            a = 1;
            b = 1;            
        elseif IS_ZERO(myangle - 90) == true then
            a = 0;
            b = -1;
            dx = 0;
            dz = 1;
        elseif IS_ZERO(myangle - 135) == true then
            a = 1;
            b = -1;            
        elseif IS_ZERO(myangle - 180) == true then
            a = 0;
            b = -1;
        end
    elseif myangle < 0 then
        if IS_ZERO(myangle + 45) == true then
            a = 1;
            b = -1;
        elseif IS_ZERO(myangle + 90) == true then
            a = 0;
            b = 1;
            dx = 0;
            dz = -1;
        elseif IS_ZERO(myangle + 135) == true then
            a = 1;
            b = 1;
        end
    end

    local destPosX = x + dx * distance;
    local destPosZ = z + dz * distance;
    
    if drawLine == 1 then
        local ex, ey, ez = GetAroundPosByPos(destPosX, y, destPosZ, myangle, 1);
        DrawSquare(self, destPosX, y, destPosZ, ex, ey, ez, 60);
    end

    -- ax + by - constant = 0
    local constant = a * destPosX + b * destPosZ;
    local tgtList = GetHardSkillTargetList(self);
    local atk = GET_SKL_DAMAGE(self, target, skl.ClassName);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local tx, ty, tz = GetPos(target);
        
        -- 타겟의 위치에서 직선 방정식까지의 거리를 구함        
        local numerator = math.abs(a * tx + b * tz - constant);
        local denominator = math.sqrt(a * a + b * b);
        local targetDist = numerator / denominator;
        local targetDestX = tx + dx * targetDist;
        local targetDestZ = tz + dz * targetDist;

        local power = targetDist * 4.7; -- 넉백 파워 구하기 위해 상수 곱해줌
        KnockBack(target, self, power, myangle, 10, speed, enableDiminish);
        TakeDamage(self, target, skl.ClassName, atk);
    end
end

function SKL_KONCKBACK_TO_ONE_POINT(self, skill, distance, speed, enableDiminish)
    local tgtList = GetHardSkillTargetList(self);
    local atk = GET_SKL_DAMAGE(self, target, skill.ClassName);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local x, y, z = GetFrontPos(self, distance);
        local angle = GetAngleToPos(target, x, z);
        local dist = GetDistance(self, target);
        local power = dist * 3.5;
        
        KnockBack(target, self, power, angle, 10, speed, enableDiminish);
        TakeDamage(self, target, skill.ClassName, atk);
        AddBuff(self, target, "ShieldTrain_Debuff", 0, 0, 500, 1);
    end
end