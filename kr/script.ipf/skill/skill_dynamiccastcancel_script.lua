-- dynamiccastcancel_script.lua
-- return 1 : hit cancel, return 0 : hit not cancel


-- COMMON_POST_BEATTACKED 함수의 인자와 같음. 
-- 피격시에 여기로 넘어옴. 
-- return 0 : 캐스팅 안끊어짐
-- return 1 : 캐스팅 끊어짐
-- return 2 : 이로직 무시 (최초 캐스팅 시작할때 설정된 값따라감)
-- 주의 : 소드맨계열이어도 여기서 1리턴하면 캐스팅이 끊어진다.
function CHECK_DYNCAST_CANCEL(pc, from, damage, skill, ret) 
    
    return 2;
end

-------------------- skill(어빌) 관련설정 시작 ------------------------
-- self : pc (CFdPc)
-- skill : skill obj (CSkill)

function SCR_DYNCAST_SKILL_PunjiStake(self, skill)
    if IS_PC(self) == false then
        return 1;
    end

    local abil = GetAbility(self, 'Sapper36');
    if abil ~= nil and abil.ActiveState then
        return 0;
    end

    return 1;
end

function SCR_DYNCAST_SKILL_Musketeer_SnipersSerenity(self, skill)
    return 0;
end

function SCR_DYNCAST_SKILL_Psychokino_PsychicPressure(self, skill)
    if IS_PC(self) == false then
        return 1;
    end

    local abil = GetAbility(self, 'Psychokino10');
    if abil ~= nil and abil.ActiveState then
        return 0;
    end

    return 1;
end

function SCR_DYNCAST_SKILL_Psychokino_GravityPole(self, skill)
    if IS_PC(self) == false then
        return 1;
    end

    local abil = GetAbility(self, 'Psychokino20');
    if abil ~= nil and abil.ActiveState then
        return 0;
    end

    return 1;
end

function SCR_DYNCAST_SKILL_Cannoneer_SiegeBurst(self, skill)
    if IS_PC(self) == false then
        return 1;
    end

    local abil = GetAbility(self, 'Cannoneer13');
    if abil ~= nil and abil.ActiveState then
        return 0;
    end

    return 1;
end

function SCR_DYNCAST_SKILL_Sadhu_Possession(self, skill)
    if IS_PC(self) == false then
        return 1;
    end

    if IsPVPServer(self) == 1 then
        return 1;
    end

    return 0;
end

function SCR_DYNCAST_SKILL_Paladin_Sanctuary(self, skill)
    return 0;
end

function SCR_DYNCAST_SKILL_Paladin_Demolition(self, skill)
    return 0;
end

function SCR_DYNCAST_SKILL_Pyromancer_HellBreath(self, skill)
    return 0;
end
function SCR_DYNCAST_SKILL_Exorcist_Rubric(self, skill)
    return 0;
end


-------------------------- Buff 관련 설정 시작 --------------------------
-- self : pc (CFdPc)
-- skill : skill obj (CSkill)
-- buff : buff obj (CBuff) - 해당 PC에 해당 버프가 걸려있을때 넘겨주는것이라 그대로 활용해도 무방.

function SCR_DYNCAST_BUFF_Surespell(self, skill, buff)
    if IS_PC(self) == false then
        return 1;
    end

    return 0;
end

function SCR_DYNCAST_BUFF_Methadone(self, skill, buff)
    if IS_PC(self) == false then
        return 1;
    end
    
    return 0;
end

function SCR_DYNCAST_BUFF_Algiz(self, skill, buff)
    if IS_PC(self) == false then
        return 1;
    end
    
    local algizAbil = GetAbility(self, "RuneCaster6")
    if algizAbil ~= nil and TryGetProp(algizAbil, "ActiveState") == 1 then
        return 0;
    end
    
    return 1;
end


