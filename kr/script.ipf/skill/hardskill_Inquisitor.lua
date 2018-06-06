--hardskill_Inquisitor.lua

function BREAKING_WHEEL_SUMMON_MON(mon, owner, skl)
    PlayAnim(mon, 'LOOP');

    SetExProp(mon, 'OWNER_HANDLE', GetHandle(owner));
    local abil = GetAbility(owner, 'Inquisitor8')
    if nil == abil then
        ClearSimpleAI(mon, 'INQUISITOR_WHEEL_SUMMON');
    end
end

function SCR_SUMMON_WHEEL(mon, self, skl)
    mon.Faction = 'IceWall'
    mon.StatType = 1
    mon.HPCount = 15;
end

function SCR_WHEEL_SEND_JUST_EFFECT(self, from, ret)
    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key);
    PlayEffectNode(self, 'F_cleric_BreakingWheel_hit_ground', 2.5, 'Dummy_effect_smoke')
    EndSyncPacket(from, key, 0);
end

function SCR_WHEEL_SUMMON_HIT(self, from, skill, damage, ret)

    if IS_PC(from) == false then
        ret.Damage = 0
        RunScript('SCR_WHEEL_SEND_JUST_EFFECT', self, from, ret);
        return;
    end

    if skill.ClassType ~= 'Melee' then
        ret.Damage = 0
        RunScript('SCR_WHEEL_SEND_JUST_EFFECT', self, from, ret);
        return;
    end
	
    RunScript('_SCR_WHEEL_SUMMON_HIT', self, from, skill, damage, ret)
end

function _SCR_WHEEL_SUMMON_HIT(self, from, skill, damage, ret)
    local list, cnt = SelectObject(from, 100, 'ENEMY');
    cnt = math.min(cnt,10); 
	
    local targetList = {};
	
    for i = 1, cnt do
        if IsSameActor(self, list[i]) == "NO" then
            targetList[#targetList + 1] = list[i];
        end
    end
    
    if #targetList == 0 then
        ret.Damage = 0
        RunScript('SCR_WHEEL_SEND_JUST_EFFECT', self, from, ret);
        return;
    end
	
	local ownerHandle = GetExProp(self, 'OWNER_HANDLE')
    local owner = GetByHandle(self, ownerHandle);
    
    local atk = GET_SKL_DAMAGE(from, skill, skill.ClassName)
    
    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key);
    
    local totalCnt = math.min(10, #targetList)
    for i = 1, totalCnt do
        local attacker = self;
        local obj = targetList[i];
        if obj.ClassName ~= "pcskill_Breaking_wheel" then
	        if nil ~= owner then
	            local ownerSkill = GetSkill(owner, skill.ClassName);
	            if ownerSkill ~= nil then
	                attacker = owner;
	            else
	                AddInstSkill(owner, skill.ClassName);
	                ownerSkill = GetSkill(owner, skill.ClassName);
	                if ownerSkill ~= nil then
	                    attacker = owner;
	                end
	            end
	        end
	        
			RunScript('_SCR_WHEEL_SUMMON_HIT_TAKE_DAMAGE', attacker, obj, skill, atk);
		end
    end
    
    PlayEffectNode(self, 'F_cleric_BreakingWheel_hit_ground', 2.5, 'Dummy_effect_smoke')
    EndSyncPacket(from, key, 0);
end

function _SCR_WHEEL_SUMMON_HIT_TAKE_DAMAGE(attacker, obj, skill, atk)
	TakeDamage(attacker, obj, skill.ClassName, atk);
end



function SCR_BRAKINGWHEEl_DEAD(mon)
    RemoveAllPad(mon)
end

function BRAKINGWHEEl_FIND_MAGIC_ATTACK_ENEMY(self, skl, pad, range)
    if IsDead(self) == 1 or IsZombie(self) == 1 then
        KillPad(pad)
        return;
    end
    local skill = skl;
    if skill == nil then
        skill = GetNormalSkill(self);

    end
    local list, cnt = SelectObject(self, range, 'ENEMY');
    local damage = GET_SKL_DAMAGE(self, skill, skill.ClassName)
    cnt = math.min(cnt,10); 

    local targetList = {};
    for i = 1, cnt do
        if IsSameActor(self, list[i]) == "NO" then
            targetList[#targetList + 1] = list[i];
        end
    end

    for i = 1, #targetList do
        local obj = targetList[i];
        local sklName, sklLv = GetCurrentSkill(obj);
        if 'None' ~= sklName then
            local pCls = GetClass("Skill", sklName)
            if nil ~= pCls and pCls.ClassType == "Magic"and GetExProp(obj, 'WHEEL_ATTACK') == 0 then
                RunScript('BRAKINGWHEEl_TARGET_DAMAGE', self, obj, skill.ClassName, damage);
                --TakeDamage(self, obj, skill.ClassName, damage);
            end
        end
    end
end

function BRAKINGWHEEl_TARGET_DAMAGE(self, target, sklName, damage)
    if IsDead(target) == 1 or IsZombie(target) == 1  then
        return;
    end

    SetExProp(target, 'WHEEL_ATTACK', 1)

    while 1 do

        if IsDead(self) == 1 or IsZombie(self) == 1 or IsDead(target) == 1 or IsZombie(target) == 1  then
            break;
        end
        if IsSkillUsing(target) == 1 then
            TakeDamage(self, target, sklName, damage);
            break;
        end

        sleep(1000);
    end

    if IsDead(target) == 1 or IsZombie(target) == 1  then
        return;
    end
    DelExProp(target, 'WHEEL_ATTACK', 1)
end

function ININ_SUMMON_PEAROFANGUISH(mon, owner, skl)
    RunScript('SUMMON_PEAROFANGUISH_ATK_AROUND', mon, skl, 150)
end

function SUMMON_PEAROFANGUISH_ATK_AROUND(self, skl, range)    
    --local skill = GetNormalSkill(self);
    SetHideFromMon(self, 1);
    self.MSPD = 200;

    while 1 do
        if IsDead(self) == 1 or IsZombie(self) == 1 then
            return;
        end
        local list, cnt = SelectObject(self, range, 'ENEMY');        
        for i = 1, cnt do
            local obj = list[i];
            local sklName, sklLv = GetCurrentSkill(obj);            
            if 'None' ~= sklName and IsSameActor(self, obj) == "NO" then
                local pCls = GetClass("Skill", sklName)
                if nil ~= pCls and pCls.ClassType == "Magic" then
                    local x,y,z = Get3DPos(obj);
                    if MoveAni(self,x,y,z,5,'ATK') == 'YES' then
                        LookAt(self, obj);
                        Fly(self, 30, 2);                        
                        RunScript('SUMMON_PEAROFANGUISH_DEAD_DELAT', self, obj,skl, 1);
                        return;
                    end
                end
            end
        end
        sleep(1000)
    end
end

function SUMMON_PEAROFANGUISH_DEAD_DELAT(self, target, skl, flyAttack)
    local isCalled = GetExProp(self, 'isCalled')
    if isCalled == 0 then
        SetExProp(self, 'isCalled', 1)
    elseif isCalled == 1 then
        return
    end
    
    local reactRange = 17
    local firstDistance = GetDistance(self, target)
        
    sleep(100)    
    local secondDistance = GetDistance(self, target)
    
    if flyAttack == 1 or secondDistance <= reactRange then
        if IsDead(self) == 1 or IsZombie(self) == 1 or IsDead(target) == 1 or IsZombie(target) == 1 then
            return
        end   
    
        local owner = GetOwner(self)
        if IsZombie(owner) == 1 then
            return;
        end
    
        local damage = GET_SKL_DAMAGE(owner, skl, skl.ClassName)
        SetExProp(target, 'FLY_ATTACk', flyAttack);    
        TakeDamage(owner, target, skl.ClassName, damage);
        SetExProp(self, 'isCalled', 0)
        Dead(self);
    else
        SetExProp(self, 'isCalled', 0)
    end    
end

function SCR_BUFF_AFTERCALC_HIT_MalleusMaleficarum_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if ret.Damage ~= 0 then
        if self.MAXMATK < 0 then
            self.MAXMATK = 0;
        end
        ret.Damage = ret.Damage + self.MAXMATK;
    end
end


function EXCLUDE_FROM_IRONMAIDEN_TARGET(self, skl, target)
    local monsterSize = TryGetProp(target, "Size")
    if monsterSize == 'S' or monsterSize == 'M' then
        return 1;
    end
    
    return 0;

end