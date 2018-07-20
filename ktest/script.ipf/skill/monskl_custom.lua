-- monskl_custom.lua

function TOOLSKILL_SLEEP(msec)
    if 0 < msec then
        sleep(msec);
    end
    SleepSkillThread(msec);
end

function SKL_KD(mon, skl, power, vangle, angle, bounce)
    KnockDown(mon, mon, power, angle, vangle, bounce);
end

function SKL_KD_NEAR(mon, skl, range, power, vangle, bounce)
    
    local objList, objCount = SelectObject(mon, 100, 'ALL');
    for i = 2, objCount do
        local obj = objList[i];
        if obj ~= nil then
            local angle = GetAngleTo(mon, obj);
            KnockDown(obj, mon, power, angle, vangle, bounce);
        end
    end 

end



function SKL_BUFF_MYZOMBIE(mon, skl, buffName, lv, arg2, applyTime, over, rate)

    local objList, cnt = GetZombieSummonList(mon);
    for i = 1 , cnt do
        local target = objList[i];
        ADDBUFF(mon, target, buffName, lv, arg2, applyTime, over, rate, skl.ClassID);
    end
end

function SKL_BUFF_REMOVE_MYZOMBIE(mon, skl, buffName)
    local objList, cnt = GetZombieSummonList(mon);
    for i = 1 , cnt do
        local target = objList[i];
        RemoveBuff(target, buffName);
    end
end

function SKL_BUFF_FOR_MONSTER(mon, skl, buffName, lv, arg2, applyTime, over, rate, withPartyMember)
    if GetObjType(mon) ~= OT_MONSTERNPC then
        return;
    end

    lv = 1;
    SKL_BUFF(mon, skl, buffName, lv, arg2, applyTime, over, rate, withPartyMember)
end

function SKL_BUFF(mon, skl, buffName, lv, arg2, applyTime, over, rate, withPartyMember)
    if IS_REAL_PC(mon) == "NO" and GetExProp(mon, "BUNSIN") == 1 then
        return
    end
    
    if nil == withPartyMember then
        withPartyMember = 0;
    end

    if GetObjType(mon) == OT_PC and 0 < withPartyMember then
        local list, cnt = nil, 0;

        if withPartyMember == 1 then 
             list, cnt = GET_PARTY_ACTOR_BY_SKILL(mon, 0);
        elseif withPartyMember == 2 then 
            list, cnt = SelectObject(mon, 200, "ALL");
            ADDBUFF(mon, mon, buffName, lv, arg2, applyTime, over, rate);
        else
            return;
        end

        if cnt == 0 then
            return;
        end

        for i=0, cnt do
            local partyActor = list[i];
            if partyActor ~= nil and GetObjType(partyActor) == OT_PC and IS_APPLY_RELATION(mon, partyActor, "ENEMY") == false then
                -- 파티원버프는 거리 200. 모이기 귀찮으니 걍 멀리서 받으셈
                local dist = GetDistance(mon, partyActor);
                if dist <= 200 then
                    ADDBUFF(mon, partyActor, buffName, lv, arg2, applyTime, over, rate);
                end
            end
        end
        return;
    end

    -- 내자신 버프.... 이걸 다른사람들에게는?
    local buff = ADDBUFF(mon, mon, buffName, lv, arg2, applyTime, over, rate, skl.ClassID);
        
    -- 버프공유 링크 걸려있으면 전달
    if buff ~= nil and withPartyMember ~= 1 and buff.LinkBuff == 'YES' then
        local linkBuff = GetBuffByName(mon, 'Link_Party');
        if linkBuff ~= nil then
            local linkCaster =  GetBuffCaster(linkBuff);
            if linkCaster ~= nil then
                local objList = GetLinkObjects(linkCaster, mon, 'Link_Party');      
                if objList ~= nil then
                    for i = 1, #objList do
                        local partyMember = objList[i];
                        ADDBUFF(mon, partyMember, buffName, lv, arg2, applyTime, over, rate);
                    end
                end
            end
        end
    end
end

function SKL_BUFF_ABIL(mon, skl, abilName, buffName, lv, arg2, applyTime, over, rate, withPartyMember)
    
    local abil = GetAbility(mon, abilName);
    if abil ~= nil then
        if withPartyMember == 1 and GetObjType(mon) == OT_PC then
            local list, cnt = GET_PARTY_ACTOR_BY_SKILL(mon, 0);
            
            if cnt > 0 then
                for i=0, cnt do
                    local partyActor = list[i];
                    if partyActor ~= nil then

                        -- 파티원버프는 거리 200. 모이기 귀찮으니 걍 멀리서 받으셈
                        local dist = GetDistance(mon, partyActor);
                        if dist <= 200 then
                            ADDBUFF(mon, partyActor, buffName, lv, arg2, applyTime, over, rate);
                        end
                    end
                end
                return;
            end
        end

        -- 내자신 버프.... 이걸 다른사람들에게는?
        local buff = ADDBUFF(mon, mon, buffName, lv, arg2, applyTime, over, rate, skl.ClassID);
        
        -- 버프공유 링크 걸려있으면 전달
        if buff ~= nil and withPartyMember ~= 1 and buff.LinkBuff == 'YES' then
            local linkBuff = GetBuffByName(mon, 'Link_Party');
            if linkBuff ~= nil then
                local linkCaster =  GetBuffCaster(linkBuff);
                if linkCaster ~= nil then
                    local objList = GetLinkObjects(linkCaster, mon, 'Link_Party');      
                    if objList ~= nil then
                        for i = 1, #objList do
                            local partyMember = objList[i];
                            ADDBUFF(mon, partyMember, buffName, lv, arg2, applyTime, over, rate);
                        end
                    end
                end
            end
        end
    end
end


function SKL_BUFF_TARGET(mon, skl, buffName, lv, arg2, applyTime, over, rate, target, range)

    local list, cnt = SelectObject(mon, 100, 'All');
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == target then
                AddBuff(list[i], list[i], 'Fear', 0, 0, 5000, 1);
            end
        end
    end

    return 1;

end

function SKL_TARGET_BUFF_SETTING_REMOVE(mon, skl, relation, buffGroup, buffCnt, buffLv)
    local tgtList = GetHardSkillTargetList(mon);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if IS_APPLY_RELATION(mon, target, relation) == true then    
            for j = 1, buffCnt do
                REMOVE_BUFF_COUNT_BY_LEVEL(target, buffGroup, buffLv);
            end
        end
    end
end

function SKL_BUFF_REMOVE(mon, skl, buffName)
    RemoveBuff(mon, buffName);
end

function SKL_BUFF_REMOVE_AFTER_TIME(mon, skl, buffName, time)
	RunScript('_SKL_BUFF_REMOVE_AFTER_TIME', mon, skl, buffName, time)
end

function _SKL_BUFF_REMOVE_AFTER_TIME(mon, skl, buffName, time)
	if time == nil then
		time = 0;
	end
	
	if time < 0 then
		time = 0;
	end
	
	sleep(time);
	
	if mon ~= nil and IsDead(mon) == 0 then
	    RemoveBuff(mon, buffName);
	end
end

function SKL_SET_IMMUNE_STATE(self, skl, buffName, rate)
	rate = rate * 100;
	AddBuff(self, self, buffName, 1, math.floor(rate), 0, 1);
end

function SKL_SET_IMMUNE_STATE_REMOVE(self, skl, buffName, time)
	if time == nil then
		time = 0;
	end
	
	if time < 0 then
		time = 0;
	end
	
	sleep(time);
	
	if self ~= nil and IsDead(self) == 0 then
		if IsBuffApplied(self, buffName) == 'YES' then
			local buffOver = GetBuffOver(self, buffName);
			if buffOver == nil or buffOver <= 1 then
				RemoveBuff(self, buffName);
				return;
			end
		end
	    
		AddBuff(self, self, buffName, 1, 0, 0, -1);
	end
end

function SKL_RESET_COOLTIME(self, skl, sklName)
    ResetSkillCoolDown(self, sklName);
end

function MSL_THROW(self, skl, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, flyTime, delayTime, gravity, spd, hitTime, hitCount, dcEft, dcEftScale, dcDelay, eftMoveDelay, kdPower, knockType, vAngle, innerRange)
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

    MslThrow(self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay);

    if eftMoveDelay > 0 then
        eftMoveDelay = eftMoveDelay * 1000;
        TOOLSKILL_SLEEP(eftMoveDelay);
    end
    
    SetExProp(self, "CHECK_SKL_KD_PROP", 1);
    OP_DOT_DAMAGE(self, skillName, x, y, z, flyTime + delayTime, range, hitTime, hitCount, dotEffect, dotScale, kdPower, knockType, innerRange);
    
end

function FORCE_THROW(self, skl, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, 
    speed, accel, dcEft, dcEftScale, dcDelay)
    
    local skillName = skl.ClassName;
    if dcDelay > 0 then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
        TOOLSKILL_SLEEP(dcDelay);
    end

    local flyTime = 0.1;
    local delayTime = 0.2;


    ShootForce(self, x, y, z, eftName, eftScale, endEft, endEftScale, speed, accel);
    
    if eftMoveDelay ~= nil and eftMoveDelay > 0 then
        eftMoveDelay = eftMoveDelay * 1000;
        TOOLSKILL_SLEEP(eftMoveDelay);
    end

    
    SetExProp(self, "CHECK_SKL_KD_PROP", 1);
    OP_DOT_DAMAGE(self, skillName, x, y, z, flyTime + delayTime, range, 0, 1, dotEffect, dotScale, 0);
end

function MSL_PAD_THROW(self, skl, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, flyTime, delayTime, gravity, spd, hitTime, hitCount, dcEft, dcEftScale, dcDelay, eftMoveDelay, padAngle, padName)
    
    local skillName = skl.ClassName;
    if dcDelay > 0 then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
        TOOLSKILL_SLEEP(dcDelay);
    end

    MslThrow(self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay);

    if eftMoveDelay ~= nil and eftMoveDelay > 0 then
        eftMoveDelay = eftMoveDelay * 1000;
        TOOLSKILL_SLEEP(eftMoveDelay);
    end
    

    if hitCount > 0 then
        SetExProp(self, "CHECK_SKL_KD_PROP", 1);
        OP_DOT_DAMAGE(self, skillName, x, y, z, flyTime + delayTime, range, hitTime, hitCount, dotEffect, dotScale, 0);
    else
        
        local sleepMS = (flyTime + delayTime) * 1000;
        if sleepMS > 0 then
            TOOLSKILL_SLEEP(sleepMS);
        end
    end

    RunPad(self, padName, skl, x, y, z, padAngle, 1);   
end

function EFT_AND_HIT(self, skl, x, y, z, dcEft, dcEftScale, posDelay, eftName, eftScale, range, kdPower, delay, hitCount, hitDuration, casterEftName, casterEftScale, casterNodeName, knockType, vAngle, innerRange)
    
    if vAngle == nil then
        vAngle = 60
    end

    --이걸 여기서 셋팅해주는 이유는 컴포넌트에서 도는 넉다운은 따로 넉다운 함수를 실행하고 있는데
    --거기서 vAngle 값을 고정으로 넣고 있음. 그래서 조절이 불가능한 상태
    --vAngle 값을 거기까지 들고가기엔 소스가 너무 더러워질거 같아서 여기서 이 처리를 함.
    SetExProp(skl, "SET_TOOL_VANGLE", vAngle)
    if knockType == nil then
        knockType = 1;
    end
    
    if dcEft ~= "None" then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
    end

    if posDelay > 0 then
        TOOLSKILL_SLEEP(posDelay);
    end

    local skillName = GetCurrentSkill(self);
    PlayEffectToGround(self, eftName, x, y, z, eftScale, 0.0);  

    if casterEftName ~= nil and casterEftName ~= 'None' then        
        if casterNodeName ~= nil and casterNodeName ~= 'None' then
            PlayEffectNode(self, casterEftName, casterEftScale, casterNodeName);
        else
            PlayEffect(self, casterEftName, casterEftScale);
        end
    end

    OP_DOT_DAMAGE(self, skl.ClassName, x, y, z, delay * 0.001, range, hitDuration, hitCount, "None", 1.0, kdPower, knockType, innerRange);
        
end

function EFT_AND_HIT_ARROW(self, skl, sx, sy, sz, ex, ey, ez, arEft, arEftScale, arSpace, arSpaceTime, arLifeTime, posDelay, hitEft, hitEftScale
, range, kdPower, delay, hitEftSpace, hitTimeSpace, eftHitCount, hitDuration, knockType, vAngle)

    if knockType == nil then
        knockType = 1
    end

    PlayArrowEffect(self, sx, sy, sz, ex, ey, ez, arEft, arEftScale, arSpace, arSpaceTime, arLifeTime);
    
    if posDelay > 0 then
        TOOLSKILL_SLEEP(posDelay);
    end

    local dist = GetDist(sx, sz, ex, ez);
    local hitCount = 1;
    
    if hitEftSpace ~= 0 then
        hitCount = math.floor(dist / hitEftSpace);
    end

    if vAngle == nil then
        vAngle = 60
    end

    SetExProp(skl, "SET_TOOL_VANGLE", vAngle)
    
    for i = 0 , (hitCount - 1) do
        local dx = sx + (ex - sx) * i / hitCount;
        local dy = sy + (ey - sy) * i / hitCount;
        local dz = sz + (ez - sz) * i / hitCount;
        
        PlayEffectToGround(self, hitEft, dx, dy, dz, hitEftScale, 0.0, hitTimeSpace * i); 
    end 

    TOOLSKILL_SLEEP(delay);
    for i = 0 , (hitCount - 1) do
        local dx = sx + (ex - sx) * i / hitCount;
        local dy = sy + (ey - sy) * i / hitCount;
        local dz = sz + (ez - sz) * i / hitCount;

        OP_DOT_DAMAGE(self, skl.ClassName, dx, dy, dz, hitTimeSpace, range, hitDuration, eftHitCount, "None", 1.0, kdPower, knockType);
    end     

end

function SHOCKWAVE_ATK(self, skill, range, power, kdPower)

    local skillName = skill.ClassName;
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    for i = 1 , objCount do
        local target = objList[i]; 
        if IsJumping(target) == 0 then
            local damage = SCR_LIB_ATKCALC_RH(self, skill);         
            damage = damage * power;
            TAKE_SCP_DAMAGE(self, target, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName);
        end
    end

end

function OP_DOT_DAMAGE(self, skillName, x, y, z, delayTime, range, hitTime, hitCount, dotEffect, dotEftScale, kdPower, knockType, innerRange)

    y = y + 1;  
    local sleepMS = delayTime * 1000;
    if sleepMS > 0 then
        TOOLSKILL_SLEEP(sleepMS);
    end

    local sleepDelay = hitTime / hitCount;
    if IsDead(self) == 1 then
        return ;
    end

    for i = 1, hitCount do
        SPLASH_DAMAGE(self, x, y, z, range, skillName, kdPower, false, knockType, innerRange);
        if i < hitCount then
            TOOLSKILL_SLEEP(sleepDelay);
        end
    end 
end

function OP_DOT_DAMAGE_FOR_THROW_EQUIP_OBJECT(self, skillName, damage, x, y, z, delayTime, range, hitTime, hitCount, dotEffect, dotEftScale, kdPower, knockType, innerRange)

    y = y + 1;  
    local sleepMS = delayTime * 1000;
    if sleepMS > 0 then
        TOOLSKILL_SLEEP(sleepMS);
    end

    local sleepDelay = hitTime / hitCount;
    if IsDead(self) == 1 then
        return ;
    end

    for i = 1, hitCount do
        SPLASH_DAMAGE_FOR_THROW_EQUIP_OBJECT(self, damage, x, y, z, range, skillName, kdPower, false, knockType, innerRange);
        if i < hitCount then
            TOOLSKILL_SLEEP(sleepDelay);
        end
    end 
end

function MSL_FALL(self, skl, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, delayTime, flyTime, height, easing, hitTime, hitCount, hitStartFix, startEasing, dcEft, dcEftScale, kdPower, knockType, vAngle)
    
    if kdPower == nil then
        kdPower = 0;
    end
    
    if knockType == nil then
        knockType = 1
    end

    if vAngle == nil then
        vAngle = 0;
    end

    SetExProp(skl, "SET_TOOL_VANGLE", vAngle)

    MslFall(self, skl.ClassName, eftName, eftScale, x, y, z, range, delayTime, flyTime, height, easing, endEftName, endScale, startEasing, dcEft, dcEftScale);
    
    if delayTime ~= nil and delayTime > 0 then
        PlayEffectToGround(self, dcEft, x, y, z, dcEftScale, 0.0);  
    end
    
    SetExProp(self, "CHECK_SKL_KD_PROP", 1);
    OP_DOT_DAMAGE(self, skl.ClassName, x, y, z, (flyTime + delayTime + hitStartFix), range, hitTime, hitCount, dotEffect, dotEftScale, kdPower, knockType);

end

function HORM_MSL(self, skl, eft, eftScale, finishEft, finishScl, mslSpd, lifeTime, x, y, z, tx, ty, tz, hormingType)

    local skillName = GetCurrentSkill(self);
    local mon1obj = CreateGCIES('Monster', "Missile");
    mon1obj.Lv = self.Lv;
    mon1obj.FIXMSPD_BM = mslSpd;
    local range = 1;
    local gol = CreateMonster(self, mon1obj, x, y, z, 0, range, 0, GetLayer(self));
    SetLifeTime(gol, lifeTime);
    SetOwner(gol, self, 1);
    SetExProp(gol, "MSL_SKL", skillName);   

    local tgt = GetNearTopHateEnemy(self);
    SCR_INIT_MISSILE(gol, tgt, eft, eftScale, finishEft, finishScl);

    MoveEx(gol, tx, ty, tz, 1);

end

function MONSKL_SET_COLDMG(self, skl, onFlag, dmgRate)

    local skillName;
    if onFlag == 0 then
        skillName = "None";
    else
        skillName = GetCurrentSkill(self);
    end

    SetCollDamage(self, skillName, dmgRate);


end

function SKL_SELFHEAL(self, skl, healPercent)

    local healValue = self.MHP * healPercent / 100;
    Heal(self, healValue, 0);

end

function SKL_CONSUME_SP(self, skl, sp)
    local curSp = self.SP;
    if sp > curSp then
        CancelMonsterSkill(self);

        if OT_PC == GetObjType(self) then
            CancelDynamicSkill(self);
        end
    else
        AddSP(self, -sp);
    end
    
end

function SKL_CONSUME_HP(self, skl, hp)
    local curHp = self.HP;
    if hp > curHp then
        AddHP(self, -curHp);

        CancelMonsterSkill(self);

        if OT_PC == GetObjType(self) then
            CancelDynamicSkill(self);
        end

        Dead(self);
    else
        AddHP(self, -hp);
    end
    
end


function SKL_LIMITATION(self, skl)
    
    AddLimitationSkillList(self, skl.ClassName);
end

function SKL_LIMITATION_CLEAR(self, skl)
    
    ClearLimitationSkillList(self);
end

function SKL_CHECK_CHARGETIME(self, skl, timeplus, timeratio)
    if timeplus == nil then
        timeplus = 0;
    end
    
    if timeratio == nil or timeratio < 0 then
        timeratio = 1;
    end
    
    local flowTime, chargeTime = GetDynamicCastingFlowTime(self);
    
    local addTime = (chargeTime * (timeratio - 1)) + timeplus;
    
    if (chargeTime + addTime) <= 0 then
        CancelMonsterSkill(self);
        ClearLimitationSkillList(self);
        return;
    end

    if flowTime > (chargeTime + addTime) then
        CancelMonsterSkill(self);
        ClearLimitationSkillList(self);
    end
    
    
    
--  local flowTime, chargeTime = GetDynamicCastingFlowTime(self);
--  if chargeTime <= 0 then
--      CancelMonsterSkill(self);
--      ClearLimitationSkillList(self);
--      return;
--  end
--
--  if flowTime > chargeTime then       
--      CancelMonsterSkill(self);
--      ClearLimitationSkillList(self);
--  end
end

function SKL_CHECK_LOOPING_COUNT_INIT(self, skl, count)

    SetExProp(skl, 'SKL_SCR_LOOPING_MAXCOUNT', count);
    SetExProp(skl, 'SKL_SCR_LOOPING_COUNT', 1);
end

function SKL_CHECK_LOOPING_COUNT(self, skl)
    
    local checkCount = tonumber( GetExProp(skl, 'SKL_SCR_LOOPING_COUNT') );
    local maxCount = tonumber( GetExProp(skl, 'SKL_SCR_LOOPING_MAXCOUNT') );

    if maxCount <= checkCount then
        CancelMonsterSkill(self);
        return;
    end

    SetExProp(skl, 'SKL_SCR_LOOPING_COUNT', checkCount + 1);
end


function SKL_LOOK_TGT(self, skl)

    local target = GET_BT_TOPHATE(self);
    if target ~= nil then
        LookAt(self, target);
    end

end

function SKL_INVIN(self, skl, sec)
    SetInvincibleSec(self, sec);
end

function SKL_HATE_RESET(self)
    local hateCount = GetHatedCount(self);
    for i = 0, hateCount-1 do
        local mon = GetHatedChar(self, i);
        if mon ~= nil then

            if GetObjType(mon) == OT_MONSTERNPC and mon.MonRank ~= 'Boss' then
                RemoveHate(mon, self);
                SkillCancel(mon);
            end
        end
    end
end

function SET_INVIN(self, skl, isOn)
    if isOn == 1 then
        AddBuff(self, self, 'Invincible');
    else
        RemoveBuff(self, 'Invincible');
    end
end

function SET_SHOW_MODEL(self, skl, isOn)
    ShowModel(self, isOn);
end

function SKL_SET_SILMIDO(self, skl, isOn, blendTime)
    SET_SILMIDO(self, isOn, blendTime);
end

function SET_SILMIDO(self, isOn, blendTime)
    if isOn == 1 then

        AddBuff(self, self, 'Born', 1, 1, 0);
        ShowModel(self, 0, blendTime);
        Fly(self, 400, 1);
        HoldMonScp(self);
    else

        Fly(self, 0, 1);
        RemoveBuff(self, 'Born');
        ShowModel(self, 1, blendTime);
        UnHoldMonScp(self);
    end
end

function SKL_SETPOS(self, skl, x, y, z, dcEffect, dcScale, slowCamera)

    if dcEffect ~= nil and dcEffect ~= 'None' then
        PlayEffectToGround(self, dcEffect, x, y, z, dcScale, 0.0);  
    end

    if slowCamera == nil then
        slowCamera = 0;
    end

    SetPos(self, x, y, z, slowCamera);
end

function SKL_SETPOS_TARGET(self, skl, dcEffect, dcScale, angle, distance, enableDistance)
    if enableDistance == nil then
        enableDistance = 0
    end
    
    local tgtList = GetHardSkillTargetList(self);
    local target = nil;    
    for i = 1 , #tgtList do
        target = tgtList[i];
        if target ~= nil then
            break;
        end
    end
    if target == nil then
        return;
    end
    
    if enableDistance > 0 and GetDistance(target, self) > enableDistance then
        return;
    end
    
    local x, y, z = GetPosByAngleDistance(target, angle, distance);
    if dcEffect ~= nil and dcEffect ~= 'None' then
        PlayEffectToGround(self, dcEffect, x, y, z, dcScale, 0.0);  
    end
    
    if slowCamera == nil then
        slowCamera = 0;
    end
    
    SetPos(self, x, y, z, slowCamera);
    LookAt(self, target);
end

function SKL_TELEPORTATION_POS(self, skl, range)

    if self == nil then
        return;
    end
    
    local randomRange = IMCRandom(math.floor(range/3), range);
    local angle = IMCRandom(0, 359);
    -- 욜랭 아까우니까 5번정도 돌려주자, 5번 돌렸는데도 네비메쉬없으면 그냥 제자리에서 나와라
    for i = 0, 5 do
        local x, y, z = GetFrontPosByAngle(self, angle, randomRange, 1);
        
        -- 방향키 누른상태에서 스킬쓰면 바라보는 방향으로 직진 이동
        local inputX, inputY = 0;

        if GetObjType(self) == OT_PC then
            inputX, inputY = GetInputKeyDirOnSkill(self);
        end
        if inputX ~= 0 or inputY ~= 0 then
            x, y, z = GetFrontPos(self, randomRange);
        end
        if IsValidPos(self, x,y,z) == "YES" then
            SetPos(self, x, y, z);
            return;
        end
    end
    x, y, z = GetPos(self, x, y, z);
    SetPos(self, x, y, z);
end


function SKL_SET_RANDOM_POS(self, skl, range)
    
    local angle = IMCRandom(0, 359);
    for i = 1, 20 do
        local x, y, z = GetFrontPosByAngle(self, angle, range, 1);
        local dist = Get2DDistFromPos(self, x, z);
        if dist > range / 3 and range > dist then
            SetPos(self, x, y, z);
            return;
        end

        angle = angle + 20;
    end
end

function SKL_SWAP_POS(self, skl, x, y, z, dcEffect, dcScale, searchRange, swapCount, relation)
    local objList, objCnt = nil, nil;
    objList, objCnt = SelectObjectPos(self, x, y, z, searchRange, relation);
    
    local swapCount = math.min(swapCount, objCnt);
    if swapCount > 0 then
    
        local px, py, pz = GetPos(self);
        for i = 1, objCnt do
            local obj = objList[i];
            if IsBuffApplied(obj, "GuildColony_InvincibleBuff") == "NO" then
                if IS_PC(obj) == false then
                    if obj.MoveType ~= 'Holding' then
                        if obj.MonRank ~= "MISC" and obj.MonRank ~= "NPC" then
                            RunScript('SWAP_POS_AFTER', self, obj, skl, x, y, z, px, py, pz)
                        end
                    end
                else
                    RunScript('SWAP_POS_AFTER', self, obj, skl, x, y, z, px, py, pz)
                end
            
                swapCount = swapCount - 1;
                if swapCount <= 0 then
                    break;
                end
            end
        end

        if dcEffect ~= nil then
            PlayEffectToGround(self, dcEffect, x, y, z, dcScale, 0.0);
            PlayEffectToGround(self, dcEffect, px, py, pz, dcScale, 0.0);
        end
    end
end

function SWAP_POS_AFTER(self, obj, skl, x, y, z, px, py, pz)
    SetPos(obj, px, py, pz);
    SetPos(self, x, y, z);
    
    if IsPVPServer(self) == 1 or GetAbility(self, "Psychokino9") and IMCRandom(1, 10000) < 2000 + skl.Level * 200 then
        AddBuff(self, obj, 'Swap_Debuff', 1, 1, 2000, 1);
    end
    
end

function SKL_MOVESTOP(self, skl)
    StopMove(self);
end

function SKL_FLY(self, skl, height)
    Fly(self, height);
end

function SKL_FLY_MATH(self, skl, height, time, easing)
    FlyMath(self, height, time, easing);
end

function SKL_JMP(self, skl, jumpPower)
    Jump(self, jumpPower);
end

function SKL_MOVE(self, skl, x, y, z, easing, moveTime, delay, eft, eftScale, eftLifeTime)

    if delay == 0.0 then
        if eft ~= "None" then
            PlayEffectToGround(self, eft, x, y, z, eftScale, eftLifeTime);  
        end
        MoveToMath(self, x, y, z, easing, moveTime);
    else
        SetDirectionToPos(self, x, z);
        TOOLSKILL_SLEEP(delay)
        
        if eft ~= "None" then
            PlayEffectToGround(self, eft, x, y, z, eftScale, eftLifeTime);  
        end
        
        MoveToMath(self, x, y, z, easing, moveTime);
    end

end

function SKL_MOVE_AR(self, skl, x, y, z, easing, moveTime, delay, eft, eftScale, eftSpace, eftSpaceTime, lifeTime)

    local bx, by, bz = GetPos(self);
    SetDirectionToPos(self, x, z);

    PlayArrowEffect(self, bx, by, bz, x, y, z, eft, eftScale, eftSpace, eftSpaceTime, lifeTime);
    TOOLSKILL_SLEEP(delay);

    MoveToMath(self, x, y, z, easing, moveTime);

end

function SKL_MOVE_PC_POS(self, skl, range, easing, moveTime, delay)
    local objList, objCount = SelectObject(self, range, 'ALL');

    local pcList = {};
    local count = 0;

    if objList ~= nil then
        for i = 1, objCount do
            if GetRelation(objList[i], self) == "ENEMY" then
                pcList[#pcList+1] = objList[i]
            end
        end
    end

    local selectPc = nil;

    local x, y, z = GetRandomPos(self, x, y, z, range)  
    if #pcList >= 1 then
        local index = IMCRandom(1, #pcList)
        selectPc = pcList[index]
        if selectPc ~= nil then
            x, y, z = GetPos(selectPc)
        end
    end

    --local bx, by, bz = GetPos(self);
    SetDirectionToPos(self, x, z);

    --PlayArrowEffect(self, bx, by, bz, x, y, z, eft, eftScale, eftSpace, eftSpaceTime, lifeTime);
    TOOLSKILL_SLEEP(delay);
    --MoveToMath(self, x, y, z, easing, moveTime);
    MoveToMath(self, x, y, z, 1, moveTime);
end

function SKL_MOVE_JUMP(self, skill, jumpHeight, distance, angle, spdChangeRate, time1, easing1, time2, easing2)
    local x, y, z = GetActorByDirAnglePos(self, angle, distance);
    JumpByArc(self, x, y, z, jumpHeight, spdChangeRate, time1, easing1, time2, easing2);
end

function SKL_TGT_MOVE(self, skill, jumpHeight, distance, angle, spdChangeRate, time1, easing1, time2, easing2, usedByTarget)
    local targetList = GetHardSkillTargetList(self)
    local x, y, z = GetActorByDirAnglePos(self, angle, distance);
    local distRate = 1
    
    if usedByTarget == 1 then
        if #targetList ~= 0 then
            for i = 1, #targetList do
                local target = targetList[i]
                x, y, z = GetPos(targetList[i])
                local dist = GetDistance(self, targetList[i])
                distRate = dist/distance
                SetExProp(target, "CHARGE_DIST", distRate)
            end
        end
    end
    
    spdChangeRate = spdChangeRate * distRate
    time1 = time1 * distRate
    time2 = time2 * distRate
    JumpByArc(self, x, y, z, jumpHeight, spdChangeRate, time1, easing1, time2, easing2);
end

function CRE_MON_MAGNETIC(mon, skl, x, y, z, monName, attachEffect, effectScale, lifeTime, Damage, attrRange)
    local self = GetSkillOwner(skl);
    local x, y, z = GetSkillTargetPos(self);    
    local mon1 = CREATE_SUMMON(self, monName, x, y, z, 0, self.Lv, "MON_ATTRACT_MAGNETIC");
    if mon1 == nil then
        return;
    end
    
    SetOwner(mon1, self, 0);    
    SetLifeTime(mon1, lifeTime);
    SetHittable(mon1, 0);
    
    PlayEffectToGround(mon1, attachEffect, x, y, z, effectScale, lifeTime);

    SetExArgObject(mon1, "SKILL_OWNER", self);
    SetExProp(mon1, "DAMAGE", Damage);  
    SetExProp(mon1, "SKILL_LV", skl.Level);
    SetExProp(mon1, "SKILL_SR", skl.SkillSR);
    SetExProp(mon1, "LIFE_TIME", lifeTime); 
    SetExProp(mon1, "ATTR_RANGE", attrRange);
    SetExProp(mon1, "TICK_COUNT", 0);
    BroadcastRelation(mon1);
end

function CRE_PICK_ITEM(self, from, itemName, itemCount, where)                       
    --where 0 = 모두
    --where 1 = 필드
    --where 2 = 마을

    if where == 0 then --모두
        local tx = TxBegin(self);
        TxEnableInIntegrate(tx);
        TxGiveItem(tx, itemName, itemCount, "PickItem");
        local ret = TxCommit(tx);
    elseif where == 1 then -- 필드
        if IsVillage(self) == "NO" then
            local tx = TxBegin(self);
            TxGiveItem(tx, itemName, itemCount, "PickItem");
            local ret = TxCommit(tx);
        end
    elseif where == 2 then -- 마을
        if IsVillage(self) == "YES" then
            local tx = TxBegin(self);
            TxGiveItem(tx, itemName, itemCount, "PickItem");
            local ret = TxCommit(tx);
        end
    end
end


function SCR_MON_ATTRACT_MAGNETIC_TS_BORN_UPDATE(self)
    ---------------- 점감 때문에 추가함 ---------------
    local updateCount = GetExProp(self, "TICK_COUNT")
    local buffTime = (6 - updateCount) * 500    -- 마그네틱포스는 총 6틱을 돈다. 매 틱마다 0.5초(스킬의 남은 시간을 계산한다)
    updateCount = updateCount + 1
    SetExProp(self, "TICK_COUNT", updateCount)
    ------------------------------------------------

    local handle = GetHandle(self);
    local timePropName = "ATTRBY" .. handle;
    local acPropName = "ATTR_ACT_" .. handle;

    local skill_Lv = GetExProp(self, "SKILL_LV");
    local caster = GetExArgObject(self, "SKILL_OWNER");
    
    local damage = GetExProp(self, "DAMAGE");
    local range = GetExProp(self, "ATTR_RANGE");
    local lifeTime = GetExProp(self, "LIFE_TIME");
    local tickTime = 1;
    local tickCount = lifeTime / tickTime;
    
    local objList, objCount = SelectObjectNear(GetOwner(self), self, range, 'ENEMY', 0, 1, 1);
    for i = 1, 10 do
        local obj = objList[i];
		if obj == nil then
			return
		end
		
		if IsBuffApplied(obj, "GuildColony_InvincibleBuff") == "YES" then
		    return
		end
		
        -- 보스는 끌려들어가지 않게 처리
        if obj.MonRank ~= 'Boss' then       
          local moveType = "None";

          if IS_PC(obj) == false then
               moveType = obj.MoveType
          end

          if moveType ~= 'Holding' then
            if IS_PC(obj) == true then                
                if GetBuffByName(obj, "MagneticForce_Debuff_Hold") == nil and GetBuffByName(obj, "MagneticForceTemporaryImmune") == nil then                   
                    if buffTime ~= 0 then
                        AddBuff(obj, obj, "MagneticForce_Debuff_Hold", 5, 5, buffTime); -- 원래 매번 짧게 걸고 있었지만, 틱을 계산해서 스킬이 끝나는 시간까지 buffTime을 걸도록 수정함                        
					    local angle = GetAngleTo(self, obj);
					    local dist = 5;
					    local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                        Move3D(obj, x, y+5, z, 0, 1000, 1, 0);                                            
                    end					
                end
                if GetBuffByName(obj, "MagneticForceTemporaryImmune") ~= nil then                    
                    PlayTextEffect(obj, "I_SYS_Text_Effect_Skill", ScpArgMsg("Hold_Immune"))                    
                    SendSyncPos(obj)
				end
			else
				AddBuff(obj, obj, 'MagneticForce_Debuff_Hold', 5, 5, 300);
			end

            local atRank = GET_ATTRACT_RANK(self, obj, range);
            local sizeRank = obj.SizeRank;
            atRank = atRank + sizeRank;

--            if atRank <= 4 then
                local attrTime = GET_ELAPSED_TIME(obj, timePropName);
                local attractAccel = 0.0;
                
                SkillCancel(obj);
                if 0 == attrTime then
                    ActorVibrate(obj, lifeTime/2, 0.5, 30, 0.1);
                end
            
                for j=1, tickCount do                    
                    if 1 == WHEN_FIRST_TIME(obj, acPropName, j * tickTime) then
                        attractAccel = 500;
                        
                        ActorVibrate(obj, lifeTime/2, 0.5, 30, 0.1);

                        if j * tickTime == lifeTime - tickTime then
                            
                            local angle = GetAngleTo(self, obj);
                            local dist = 5;
                            local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                            Move3D(obj, x, y+5, z, 0, 3000, 1, 0);

                            if objCount > 1 then
                                AddBuff(caster, obj, 'MagneticForce_Debuff', damage, HIT_BASIC, 300);
                            end
                        end
                    end
                end
--            end
                
          end
        end
    end 
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

function CRE_MON_ATTRACT(mon, skl, x, y, z, monName, attachEffect, effectScale, lifeTime, tickDamage, tickTime, attrRange)
    local self = GetSkillOwner(skl);    
    if skl.ClassName == 'Cryomancer_FrostPillar' then
        local now = toint(imcTime.GetAppTime())                
        SetExProp(self, 'Cryomancer_FrostPillar_startTime', now)        
    end
    local x, y, z = GetSkillTargetPos(self);    
    local mon1 = CREATE_SUMMON(self, monName, x, y, z, 0, self.Lv, "MON_ATTRACT");
    if mon1 == nil then
        return;
    end

    PlayAnim(mon1, 'Born', 1, 1);

    SetOwner(mon1, self, 0);    
    SetLifeTime(mon1, lifeTime);
    if attachEffect ~= 'None' then
        AttachEffect(mon1, attachEffect, effectScale);      
    end
    SetHittable(mon1, 0);
        
    --SetExProp(mon1, "DAMAGE", tickDamage);    -- 틱데미지는 업데이트에서 따로 계산하도록 변경함.
    SetExArgObject(mon1, "SKILL_OWNER", self);
    SetExProp(mon1, "SKILL_LV", skl.Level);
    SetExProp(mon1, "TICK_TIME", tickTime); 
    SetExProp(mon1, "LIFE_TIME", lifeTime); 
    SetExProp(mon1, "ATTR_RANGE", attrRange);
    SetExProp_Str(mon1, "ATTACK_EFFECT", attachEffect);
    BroadcastRelation(mon1);

    
    local x, y, z = GetPos(mon1);
    PlayEffectToGround(mon1, 'F_wizard_attractpillar_shot_levitation', x, y, z, 0.6, lifeTime);
    PlayEffectToGround(mon1, 'F_wizard_attractpillar_shot_spread_in', x, y, z, 0.7, lifeTime-1.5);

    -- 없어질때 이펙트 (데드 애니에 붙혀서 여기는 필요 없을듯)
    
end


function SCR_MON_ATTRACT_TS_BORN_UPDATE(self)   
    local handle = GetHandle(self);
    local timePropName = "ATTRBY" .. handle;
    local acPropName = "ATTR_ACT_" .. handle;
    
    --local tickDamage = GetExProp(self, "DAMAGE");
    local skill_Lv = GetExProp(self, "SKILL_LV");
    local caster = GetExArgObject(self, "SKILL_OWNER");
    
    local range = GetExProp(self, "ATTR_RANGE");
    local lifeTime = GetExProp(self, "LIFE_TIME");
    local tickTime = GetExProp(self, "TICK_TIME");
    local tickCount = lifeTime / tickTime;
    
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    local pvpServer = IsPVPServer(self);
    for i = 1, objCount do
        local obj = objList[i];
        
        -- 보스는 끌려들어가지 않게 처리
        if obj.MonRank ~= 'Boss' then
            local atRank = GET_ATTRACT_RANK(self, obj, range);
            local sizeRank = obj.SizeRank;
            atRank = atRank + sizeRank;
            if atRank <= 4 then
                local attrTime = GET_ELAPSED_TIME(obj, timePropName);
                local attractAccel = 0.0;
                
                if TryGetProp(obj, "MoveType") == 'Holding' or TryGetProp(obj, "MonRank") == 'MISC' or TryGetProp(obj, "MonRank") == 'NPC' then
                    ActorVibrate(obj, lifeTime - 5, 1, 30, 0.1);
                else
                    if 0 == attrTime then                    
                        ActorVibrate(obj, lifeTime, 1, 30, 0.1);
                        local angle = GetAngleTo(self, obj);
                        local dist = 30;
                        local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                        InsertHate(obj, caster, caster.MAXMATK);
                        SkillCancel(obj);
                        Move3D(obj, x, y+5, z, 0, 10, 1);
                    end
                    
                    for j=1, tickCount do
                        if 1 == WHEN_FIRST_TIME(obj, acPropName, j * tickTime) then
                            attractAccel = 500;
                            
                            if j * tickTime == lifeTime - tickTime then
                                --print(ScpArgMsg('Auto_iKe_MagTigim'))
                                SCR_MON_ATTRACT_DEAD(self);
                            end
                        end
                    end
                    
                    attractAccel = attractAccel - math.max(0, atRank - 3) * 50;
                    if attractAccel > 0 then
                        local angle = GetAngleTo(self, obj);
                        local dist = 30;
                        local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                        local RT = set_LI(skill_Lv, 10, 90)
                        Move3D(obj, x, y+5, z, 5, attractAccel, 1);
                        
                        if RT > IMCRandom(1, 100) then
                            local buffTime = 5000
                            if pvpServer == 1 then
                                buffTime = 2500;
                            end                            
                            AddBuff(caster, obj, 'Cryomancer_FrostPillar', 1, 0, buffTime, 1);                            
                        end
--                        AddBuff(self, obj, 'FrostPillar_Debuff', 1, 0, 0, 1);
                    end
                end
            end
        end
        
        AddBuff(self, obj, 'FrostPillar_Debuff', 1, 0, 0, 1);
    end
end

function SCR_MON_ATTRACT_DEAD(self)        

    local handle = GetHandle(self);
    local range = GetExProp(self, "ATTR_RANGE");
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        local atRank = GET_ATTRACT_RANK(self, obj, range);
        local sizeRank = obj.SizeRank;
        atRank = atRank + sizeRank;
        if atRank <= 4 then
            ActorVibrate(obj, 0.0, 0.0, 0.0, 0.0);
        end     
    end
    
    local attachEffect = GetExProp_Str(self, "ATTACK_EFFECT");
    
    if attachEffect ~= 'None' then      
        DetachEffect(self, attachEffect)
    end
    
    SetZombie(self);
end

function GET_ATTRACT_RANK(self, target, range)

    local dist = GetDistance(self, target);
    local rate = dist / range;
    if rate <= 0.4 then
        return 1;
    elseif rate <= 0.7 then
        return 2;
    elseif rate <= 1.0 then
        return 3;
    end
    
    return 4;
end

function CRE_MON_ABIL_ATTRACT(mon, skl, abilName, x, y, z, monName, attachEffect, effectScale, lifeTime, tickDamage, tickTime, attrRange)
	local self = GetSkillOwner(skl);
	
    if skl.ClassName == 'Onmyoji_GreenwoodShikigami' then
        local now = toint(imcTime.GetAppTime())                
        SetExProp(self, 'Onmyoji_GreenwoodShikigami_startTime', now)        
    end
    local x, y, z = GetSkillTargetPos(self);    
    local mon1 = CREATE_SUMMON(self, monName, x, y, z, 0, self.Lv, "MON_ABIL_ATTRACT");
    if mon1 == nil then
        return;
    end
    
	local range = GetExProp(self, "ATTR_RANGE");
    PlayAnim(mon1, 'Born', 1, 1);
	
    SetOwner(mon1, self, 0);    
    SetLifeTime(mon1, lifeTime);
    if attachEffect ~= 'None' then
        AttachEffect(mon1, attachEffect, effectScale);      
    end
    SetHittable(mon1, 0);
    SetExProp(mon1, "LIFE_TIME", lifeTime);
    BroadcastRelation(mon1);
    
    local abil = GetAbility(self, abilName)
    if abil == nil then
    	return
    end
    
    SetExProp(mon1, "ATTR_RANGE", attrRange);
    SetExProp(mon1, "TICK_TIME", tickTime); 
    
    local x, y, z = GetPos(mon1);
    local objList, objCount = SelectObject(mon1, attrRange, 'ENEMY');
    for i = 1, objCount do
    	local obj = objList[i];
        if obj.MonRank ~= 'Boss' then
            local attractAccel = 0.0;
            if TryGetProp(obj, "MoveType") == 'Holding' or TryGetProp(obj, "MonRank") == 'MISC' or TryGetProp(obj, "MonRank") == 'NPC' then
                ActorVibrate(obj, lifeTime - 5, 1, 30, 0.1);
            else                
                ActorVibrate(obj, lifeTime, 1, 30, 0.1);
                local angle = GetAngleTo(self, obj);
                local dist = 30;
                local x, y, z = GetActorByDirAnglePos(mon1, angle, dist);
                SkillCancel(obj);
                Move3D(obj, x, y + 5, z, 0, 60, 1);
            end
        end
	end
end




function SCR_MON_ABIL_ATTRACT_TS_BORN_UPDATE(self)

    local handle = GetHandle(self);
    local timePropName = "ATTRBY" .. handle;
    local acPropName = "ATTR_ACT_" .. handle;
    
    --local tickDamage = GetExProp(self, "DAMAGE");
    local skill_Lv = GetExProp(self, "SKILL_LV");
    local caster = GetExArgObject(self, "SKILL_OWNER");
    
    local range = GetExProp(self, "ATTR_RANGE");
    local lifeTime = GetExProp(self, "LIFE_TIME");
    local tickTime = GetExProp(self, "TICK_TIME");
    local tickCount = lifeTime / tickTime;
    
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    local pvpServer = IsPVPServer(self);
    for i = 1, objCount do
        local obj = objList[i];
        
        -- 보스는 끌려들어가지 않게 처리
        if obj.MonRank ~= 'Boss' then
            local atRank = GET_ATTRACT_RANK(self, obj, range);
            local sizeRank = obj.SizeRank;
            atRank = atRank + sizeRank;
            if atRank <= 4 then
                local attrTime = GET_ELAPSED_TIME(obj, timePropName);
                local attractAccel = 0.0;
                
                if TryGetProp(obj, "MoveType") == 'Holding' or TryGetProp(obj, "MonRank") == 'MISC' or TryGetProp(obj, "MonRank") == 'NPC' then
                    ActorVibrate(obj, lifeTime - 5, 1, 30, 0.1);
                else
                    if 0 == attrTime then                    
                        ActorVibrate(obj, lifeTime, 1, 30, 0.1);
                        local angle = GetAngleTo(self, obj);
                        local dist = 30;
                        local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                        SkillCancel(obj);
                        Move3D(obj, x, y+5, z, 0, 10, 1);
                    end
                    
                    for j=1, tickCount do
                        if 1 == WHEN_FIRST_TIME(obj, acPropName, j * tickTime) then
                            attractAccel = 500;
                            
                            if j * tickTime == lifeTime - tickTime then
                                --print(ScpArgMsg('Auto_iKe_MagTigim'))
                                SCR_MON_ABIL_ATTRACT_DEAD(self);
                            end
                        end
                    end
                    
                    attractAccel = attractAccel - math.max(0, atRank - 3) * 50;
                    if attractAccel > 0 then
                        local angle = GetAngleTo(self, obj);
                        local dist = 30;
                        local x, y, z = GetActorByDirAnglePos(self, angle, dist);
                        local RT = set_LI(skill_Lv, 10, 90)
                        Move3D(obj, x, y+5, z, 5, attractAccel, 1);
                    end
                end
            end
        end
    end
end

function SCR_MON_ABIL_ATTRACT_DEAD(self)        
    local handle = GetHandle(self);
    local range = GetExProp(self, "ATTR_RANGE");
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        local atRank = GET_ATTRACT_RANK(self, obj, range);
        local sizeRank = obj.SizeRank;
        atRank = atRank + sizeRank;
        if atRank <= 4 then
            ActorVibrate(obj, 0.0, 0.0, 0.0, 0.0);
        end     
    end
    
    local attachEffect = GetExProp_Str(self, "ATTACK_EFFECT");
    
    if attachEffect ~= 'None' then      
        DetachEffect(self, attachEffect)
    end
    
    SetZombie(self);
end


function SKL_TOGGLE_AUTO_OFF_MON(self, skl, monName, index)

    local sklName = skl.ClassName;
    while 1 do

        skl = GetSkill(self, sklName);
        if GetExProp(skl, "TOGGLED") == 0 then
            return;
        end

        local mon = GET_FOLLOW_BY_NAME(self, monName);
        if mon == nil then
            RunSkillToolScript(self, skl, index);
            return;
        end

        TOOLSKILL_SLEEP(100);
    end

end

function SKL_TOGGLE_ON(self, skl, isOn)

    if GetExProp(skl, "TOGGLED") == 1 then

        SetExProp(skl, "TOGGLED", 0);

    SetToggledSkillID(self, skl.ClassID, 0);

    end

    SetExProp(skl, "TOGGLED", isOn);
    SetToggledSkillID(self, skl.ClassID, isOn);
        
    
end

function SKL_HIT_SQUARE(self, skl, dist1, angle1, height1, dist2, angle2, height2, width, getTarget)

    if getTarget == nil then
        getTarget = 0;
    end

    if getTarget == 0 then
        local x, y, z = GetPos(self);
        local sx, sz = GetAroundPos(self, math.deg(angle1), dist1);
        local ex, ez = GetAroundPos(self, math.deg(angle2), dist2);
        local list, cnt = SelectObjectBySquareCoor(self, "ENEMY", sx, y, sz, ex, y, ez, width, 50);
    
        for i = 1, cnt do
            local obj = list[i];
            local damage = GET_SKL_DAMAGE(self, obj, skl.ClassName);

            TakeDamage(self, obj, skl.ClassName, damage);
        end
    
    elseif getTarget == 1 then
        
        local tgtList = GetHardSkillTargetList(self);
        for i = 1 , #tgtList do
            local tgt = tgtList[i];
            local damage = GET_SKL_DAMAGE(self, tgt, skl.ClassName);

            TakeDamage(self, tgt, skl.ClassName, damage);
        end 
    end

end

function SKL_TAKEDAMAGE_CIRCLE(self, skl, x, y, z, range, damRate, kdPower, damageFunc)

    if damageFunc ~= nil and damageFunc ~= "None" then
        damageFunc = _G[damageFunc];
    else
        damageFunc = nil;
    end 
    
    local remainSR = 1
    if skl ~= nil then
        InvalidateObjectProp(skl, "SkillSR");
        remainSR = skl.SkillSR
    end

    local list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY');
    for i = 1, cnt do
        local target = list[i];
        local damage = SCR_LIB_ATKCALC_RH(self, skl);
        damage = damage * damRate;
        if damageFunc ~= nil then
            damage = damageFunc(self, target, damage);
        end

        TakeDamage(self, target, skl.ClassName, damage);
        if kdPower > 0 then
            local angle = GetAngleFromPos(target, x, z);
            KnockDown(target, target, kdPower, angle, 45.0, 2, 1, 1);
        end
        
        remainSR = remainSR - target.SDR;
        
        if remainSR <= 0 then
            break;
        end
    end

    if cnt > 0 and skl.ClassName == 'Barbarian_StompingKick' then
        CanLoopJump(self);
    end
end

function SKL_HIT_CIRCLE(self, skl, x, y, z, range)
    local list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY');
    for i = 1, cnt do
        local obj = list[i];
        local damage = SCR_LIB_ATKCALC_RH(self, skl);
        TakeDamage(self, obj, skl.ClassName, damage);
    end
end

function SKL_CONSUME_SKILL_COOLDOWN(self, skl)
    StartCoolTimeAndSpendSP(self, skl.ClassName);
end

function SKL_CANCEL_CANCEL(self, skl)
    CancelMonsterSkill(self);
end

function SKL_FOCRE_CANCEL(self, skl)
    SkillCancel(self);
end
function SKL_SET_CELL_SIZE(self, skl, size)
    SetSklCellSize(self, size);
end

function SKL_PLAY_SOUND(self, skl, soundName, loop, male_soundName)


    if GetObjType(self) ~= 2 or male_soundName == nil then -- pc가 아니면
        return;
    else
        if self.Gender == 1 then
            PlaySound(self, male_soundName, loop);
        else
            PlaySound(self, soundName, loop);
        end
    end
end

function SKL_STOP_SOUND(self, skl, soundName, male_soundName)

    if GetObjType(self) ~= 2 or male_soundName == nil then -- pc가 아니면
        StopSound(self, soundName);
    else
        if self.Gender == 1 then
            StopSound(self, male_soundName);
        else
            StopSound(self, soundName);
        end
    end

end

function SKL_RUN_SCRIPT_SLEEP(self, skl, funcName)
    local func = _G[funcName];
    func(self, skl);
end

function SKL_RUN_SCRIPT(self, skl, funcName)
    local func = _G[funcName];
    func(self, skl);
end

function MONSKL_NOTICE(self, skl, msgStr)
    BroadcastAddOnMsg(self, "NOTICE_Dm_!", msgStr, 3);
end

function SKL_RESET_USER_PROP(self, skl, propName)
    SetExProp(skl, propName, 0);
end

function SKL_END_AT_TIME(self, skl, timeStr)
    ReserveSkillCancel(self, timeStr);
end

function SKL_RESET_SHOOTTIME(self, skl)
    ResetShootTime(skl);
end

function SKL_ENABLE_C_DAMAGE(self, skl, enable, damRate)
    if 1 == enable then
        EnableClientAttack(self, skl.ClassID, damRate);
    else
        EnableClientAttack(self, 0, 0);
    end
end

function SKL_ARC_JUMP(self, skl, x, y, z, height, spdChangeRate, time1, easing1, time2, easing2)
    JumpByArc(self, x, y, z, height, spdChangeRate, time1, easing1, time2, easing2);
end

function SKL_COLL_TO_GROUND(self, skl, x, y, z, spd, anim, animSec, easing, castEft, castEftScale, eft, eftScale, atkRange, kdPower, damageFunc)
    local dist = GetDistFromPos(self, x, y, z);
    local flyTime = dist / spd;
    PlayEffectToGround(self, castEft, x, y, z, castEftScale, flyTime);
    SetPosInServer(self, x, y, z);
    local key = GenerateSyncKey(self);
    StartSyncPacket(self, key);
    PlayEffectToGround(self, eft, x, y, z, eftScale);
    BroadcastShockWave(self, 2, 999, 7, 1, 60, 0);

    SKL_TAKEDAMAGE_CIRCLE(self, skl, x, y, z, atkRange, 1.0, kdPower, damageFunc);
    EndSyncPacket(self, key);
    CollToGround(self, x, y, z, spd, easing, key, anim, animSec);
    
end

function SKL_HAND_LASER(self, skl, x, y, z, eft, eftScale)
    PlayConnectEffect(self, x, y, z, eft, eftScale);
end

function S_SHOCKWAVE(self, skl, power, time, freq, range)
    BroadcastShockWave(self, 2, range, power, time, freq, 0);   
end

function SKL_ZOMBIE_HOVER(self, skl, x, y, z, radius, angleSpd)
    
    EndHoverZombieSummon(self);
    HoverZombieSummon(self, x, y, z, radius, angleSpd);
    
end

function SKL_ZOMBIE_MOVEPOS(self, skl, x, y, z, radius)
    
    EndHoverZombieSummon(self);
    MoveZombieSummon(self, x, y, z, radius);
end

function SKL_ZOMBIE_Buff(self, skl, buffName, lv, arg2, applyTime, over)

    local list, listCnt = GetZombieSummonList(self);
    for i = 1, listCnt do
        local zombieSummon = list[i];
        ADDBUFF(self, zombieSummon, buffName, lv, arg2, applyTime, over, 100);
    end
end

function BACKMASKING_START(self, skl, range)
    ExecBackMasking(self, range);
end


function  SKL_CHANGE_SKLSUBANIM(self, skl, skillName, changeAnim)

    ChangeSkillAniName(self, skillName, changeAnim);
end

function  SKL_CHANGE_SKLSUBANIM_BY_JOB_HISTORY(self, skl, skillName, jobName, changeAnim)
    local jobCls = GetClass("Job", jobName);
    if jobCls == nil then
        return;
    end

    local jobExist = false;
	local jobHistoryList = GetJobHistoryList(self);
    for i = 1, #jobHistoryList do
        if jobHistoryList[i] == jobCls.ClassID then
            jobExist = true;
        end
    end

    if jobExist == true then
        ChangeSkillAniName(self, skillName, changeAnim);
    end
end

function SKL_EFFECT_POS(self, skl, eftName, eftScale, x, y, z, lifeTime)
    PlayEffectToGround(self, eftName, x, y, z, eftScale, lifeTime);
end

function TGT_SKL_KILL(self, skl)

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        if target.Name ~= self.Name then
            Dead(target);
        end
    end
end

function TGT_SKL_SHOWMONINFO(self, skl, showParamCount, showTime, isShuffle)

    local paramList = {}

    paramList[#paramList + 1] = "MoveType" -- 이동 속성
    paramList[#paramList + 1] = "MonRank" --등급
    paramList[#paramList + 1] = "RaceType" -- 몬스터 종족
    paramList[#paramList + 1] = "Size" -- 크기
    paramList[#paramList + 1] = "ArmorMaterial" -- 방어 종류
    paramList[#paramList + 1] = "Attribute" -- 원소 속성
    paramList[#paramList + 1] = "EffectiveAtkType" -- 유효한 공격 속성

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        ShowMonInfoBySKill(target, paramList, showParamCount, showTime, isShuffle)
    end
end



function SKL_MON_RACETYPE_KILL(self, skl, raceType, range, rate, limitCount, deadDelay)

    if limitCount <= 0 then
        return;
    end

    local objList, objCount = SelectObject(self, range, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        if obj.RaceType == raceType then

            if  limitCount <= 0 then
                return;
            end

            local random = IMCRandom(1, 100);
            if random < rate then
                Dead(obj, deadDelay);
            end

            limitCount = limitCount - 1;
        end
    end 
end


function CAMERA_ZOOM_OUT_IN(self, target, viewDest, time)

    SetDistValue(self, viewDest);
    
    sleep(time)
    
    SetDistValue(self, 460);
    
end

function SKL_USE_PCSKILL(self, scpTarget, actor, target, obj, ret, damage, skillName)

    MonsterUsePCSkill(self, skillName, 1, 1, nil);
 --     SH_USE_PCSKILL

end

function SKL_USE_PCSKILL_BALLON(self, skl, sklID, chargTime)

    MonsterSendPCskillBalloon(self, sklID, chargTime);
 --     SH_USE_PCSKILL

end

function SKL_DYNAMICCAST_COUNTERATTACK(self, skl, reserveSkillName, range, allHitType, hitType1, hitType2, hitType3, hitType4, hitType5, hitType6, hitType7, hitType8, hitType9 )
    local hitTypeList = { hitType1, hitType2, hitType3, hitType4, hitType5, hitType6, hitType7, hitType8, hitType9 };
    local reserveSkillID = geSkillTable.GetSkillID(reserveSkillName);
    if allHitType == 1 then
        for i = 1, 9 do
            hitTypeList[i] = i;
        end
    end
    
    SetDynamicCastCounterAttackInfo(self, reserveSkillID, range, hitTypeList[1], hitTypeList[2], hitTypeList[3], hitTypeList[4], hitTypeList[5], hitTypeList[6], hitTypeList[7], hitTypeList[8], hitTypeList[9]);
end



function SKL_PAD_DESTRUCTION_RELATION(self, skl, x, y, z, padCount, range, padStyle, relation, eft, eftScale, hitRange, damRate, kdPower, relationBit)
    local allPadList = SelectPad(self, 'ALL', x, y, z, range, padStyle, relationBit);
    if #allPadList == 0 then
        return;
    end
    
    local list = { };
    if relation ~= 'ALL' then
        for i = 1, #allPadList do
            local pad = allPadList[i]
            local padOwner = GetPadOwner(pad);
            if padOwner ~= nil then
                if GetRelation(self, padOwner) == relation then
                    list[#list + 1] = pad;
                end
            end
        end
    else
        list = allPadList;
    end
    
    if #list == 0 then
        return;
    end
    
    local loopCnt = math.min(#list, padCount);
    
    local padPosX = {};
    local padPosY = {};
    local padPosZ = {};
    for i = 1 , loopCnt do
        local pad = list[i];
        
        local px, py, pz = GetPadPos(pad);
        padPosX[i] = px;
        padPosY[i] = py;
        padPosZ[i] = pz;
        KillPad(pad);
    end
    
    for i = 1 , loopCnt do
        local px = padPosX[i];
        local py = padPosY[i];
        local pz = padPosZ[i];
        PlayEffectToGround(self, eft, px, py, pz, eftScale, 0.0);  
        OP_DOT_DAMAGE(self, skl.ClassName, px, py, pz, 0, hitRange, 0, 1, "None", 1.0, kdPower);
    end
end


function CUSTOM_CREATE_DUMMYPC_FOR_EXPROP(self, skl, exPropName, x, y, z)
    CREATE_DUMMYPC_FOR_EXPROP(self, exPropName, x, y, z)
end

function CUSTOM_CLEAR_DUMMYPC_FOR_EXPROP(self, skl, exPropName)
    CLEAR_DUMMYPC_FOR_EXPROP(self,exPropName)
end

function CUSTOM_BUFF_DUMMYPC_FOR_EXPROP(self, skl, exPropName, buffName, buffTime)
   BUFF_DUMMYPC_FOR_EXPROP(self,  exPropName, buffName, buffTime)
end

function CUSTOM_KNOCKBACK_DUMMYPC_FOR_EXPROP(self, skl, exPropName, inversAngle, power, speed)
   KNOCKBACK_DUMMYPC_FOR_EXPROP(self, exPropName, inversAngle, power, speed)
end

function CUSTOM_PLAYANIM_DUMMYPC_FOR_EXPROP(self, skl, exPropName, aniName)
   PLAYANIM_DUMMYPC_FOR_EXPROP(self, exPropName, aniName)
end

function CUSTOM_COLORTON_DUMMYPC_FOR_EXPROP(self, skl, exPropName, r, g, b, a)
   COLORTON_DUMMYPC_FOR_EXPROP(self,  exPropName, r, g, b, a)
end

function CUSTOM_SET_HP_DUMMYPC_FOR_EXPROP(self, skl, exPropName, hpPercent)
   
   local mhp = TryGetProp(self, "MHP");
   if mhp == nil and hpPercent ~= nil and hpPercent > 0 then
        mhp = mhp * ( hpPercent/100)
        SET_HP_DUMMYPC_FOR_EXPROP(self,  exPropName, mhp, mhp)
   end
end



-- shadowmancer Hollucination
function CREATE_HOLLUCINATION(self, skl, exPropName, x, y, z, hpPercent, r, g, b, a, inversAngle, power, speed, aniName, buffName, buffTime)
    
    CLEAR_DUMMYPC_FOR_EXPROP(self, exPropName) -- 한번에 하나만 존재하도록 한다.
    local dpc = CREATE_DUMMYPC_FOR_EXPROP(self,exPropName, x, y , z) -- 더미를 생성한다.
    if dpc ~= nil then
        _COLORTON_DUMMYPC(self, dpc, r, g, b, a) -- 컬러톤 설정
        _KNOCKBACK_DUMMYPC(self, dpc, inversAngle, power, speed) -- 넉백
        _PLAYANIM_DUMMYPC(self, dpc, aniName) -- 애님고정.
        _BUFF_DUMMYPC(self, dpc, buffName, buffTime)

         local mhp = TryGetProp(self, "MHP");
         if mhp ~= nil and hpPercent ~= nil and hpPercent > 0 then
            mhp = mhp * (hpPercent/100);
            _SET_HP_DUMMYPC(self, dpc, mhp, mhp);
         end
    end
end

