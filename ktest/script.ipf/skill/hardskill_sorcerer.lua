--- hardskill_sorcerer.lua


function SORCER_ATTACH_EFFECT(self, skl, eft, eftScale, countPerNode)

    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        return;
    end

    local tgt = tgtList[1]; 
    EffectToBones(tgt, eft, eftScale, countPerNode);
end


function ORDER_HOLD_ATTACK(self, x, y, z)
    if TryGetProp(self, 'MoveType') == 'Holding' then
        return;
    end
    
    SkillCancel(self);
    HoldMonScp(self);
    while 1 do
        local isMovingToDest = false;
        if IsMoving(self) == 1 then
            local dx, dz = GetMoveToPos(self);
            local destDist  = math.dist(dx, dz, x, z);
            if destDist <= 10 then
                isMovingToDest = true;
            end
        end

        if false == isMovingToDest then
            local cx, cy, cz = GetPos(self);
            local distToDest = math.dist(cx, cz, x, z);         
            if distToDest <= 5 then
                break;
            end

            MoveEx(self, x, y, z, 1);
        end

        sleep(500);
    end
    
    local skill = GetNormalSkill(self);
    local skillName = skill.ClassName;
    
    while 1 do
        local objList, objCount = SelectObject(self, 100, 'ENEMY');
        if objCount > 0 then
            local target = objList[1];          

            SAI_CHECK_OWNER_BATTLE_STATE(self, 60);
            if GetExProp(self, 'NOT_ALLOW_ATTACK') == 0 then
                UseMonsterSkillOnHold(self, target, skillName);
            end
            sleep(500);
            
            local cx, cy, cz = GetPos(self);
            local dist = math.dist(cx, cz, x, z);
            if dist > 3 then
                MoveEx(self, x, y, z, 1);
            end
        end

        sleep(200);
    end
end


function SAI_PARENT_POS_SORCERER_SUMMONING(self, range) -- Simpla AI of Sorcerer summoning for Command Update
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
    
    return 1;
end

function ORDER_ATTACK_GROUND(self, x, y, z, range)
    if TryGetProp(self, 'MoveType') == 'Holding' then
        return;
    end
    
    local maxWaitingTime = 20;
    local waitingTime = 0;
    
    local skill = GetNormalSkill(self);
    local skillName = skill.ClassName;
    while 1 do
        local usingSkill = GetUsingSkill(self);
        while waitingTime < maxWaitingTime and usingSkill ~= nil do -- Will wait time until finishing skill when get off from summoned one
            sleep(500);
            waitingTime = waitingTime + 0.5;
            usingSkill = GetUsingSkill(self);           
        end
        
        SkillCancel(self);
        HoldMonScp(self);
        local cx, cy, cz = GetPos(self);
        local objList, objCount = SelectObject(self, range, 'ENEMY');
        if objCount > 0 then
            local target = objList[1];
            StopMove(self);
            UseMonsterSkill(self, target, skillName);
            sleep(500);
            while 1 do              
                if IS_CHASING_SKILL(self) == 1 then
                    sleep(500);
                else
                    break;
                end
            end
        end

        local isMovingToDest = false;
        if IsMoving(self) == 1 then
            local dx, dz = GetMoveToPos(self);
            local destDist  = math.dist(dx, dz, x, z);
            if destDist <= 10 then
                isMovingToDest = true;
            end
        end

        if false == isMovingToDest then
            local distToDest = math.dist(cx, cz, x, z);
            if distToDest <= 5 then
                SetHoldMonScp(self, 0);
                return;
            end
            MoveEx(self, x, y, z, 1);
        end
        sleep(200);
    end

end

function SORCER_ORDER_HOLD(self, skl, x, y, z)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        return;
    end

    for i = 1 , #tgtList do
        local tgt = tgtList[i];

        local runScriptName = GetExProp_Str(tgt, 'ORDER_SCRIPT');
        if runScriptName ~= 'None' then         
            StopRunScript(tgt, runScriptName);
        end
        SetExProp_Str(tgt, 'ORDER_SCRIPT', "ORDER_HOLD_ATTACK");
        RunScript("ORDER_HOLD_ATTACK", tgt, x, y, z);
    end
end

function SORCER_ORDER_ATTACK(self, skl, x, y, z, range)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        return;
    end
    
    for i = 1 , #tgtList do
        local tgt = tgtList[i];

        local runScriptName = GetExProp_Str(tgt, 'ORDER_SCRIPT');
        if runScriptName ~= 'None' then         
            StopRunScript(tgt, runScriptName);
        end

        SetExProp_Str(tgt, 'ORDER_SCRIPT', "ORDER_ATTACK_GROUND");
        RunScript("ORDER_ATTACK_GROUND", tgt, x, y, z, range);
    end 
end

function SORCER_CONTROL_START(self, skl, uiName, updateScript)
    local tgt = nil;
    local tgtList = GetAliveFolloweList(self);
    if #tgtList == 0 then
        return;
    end

    local etc = GetETCObject(self);
    for i = 1, #tgtList do
    local obj = tgtList[i];
        if etc.Sorcerer_bosscardName1 == obj.ClassName or etc.Sorcerer_bosscardName2 == obj.ClassName then
            tgt = obj;
            break;
        end
    end

    if nil == tgt then
        return;
    end

    local runScriptName = GetExProp_Str(tgt, 'ORDER_SCRIPT');
    if runScriptName ~= 'None' then     
        StopRunScript(tgt, runScriptName);
    end
    
    SkillCancel(tgt);  -- To avoid cancellation skills when riding a summoned thing, make a comment this line
    ControlObject(self, tgt, 1, 0, 0, 'Summoning_Buff', updateScript);
    --ControlObject(self, tgt, 1, 0, 0, uiName, updateScript);
    
    if skl.ClassName == 'Sorcerer_Obey' then
        AddBuff(self, tgt, 'Sorcerer_Obey_Status_Buff', 1, 0, 0, 1)
        AddBuff(self, self, 'Sorcerer_Obey_PC_DEF_Buff', 1, 0, 0, 1)
    end

    DontUseEventHandler(tgt, "handler_eat_heal");
    DontUseEventHandler(tgt, "handler_hp_runaway");

    if updateScript ~= "None" then
        RunScript(updateScript, self, skl, tgt);
    end
end

function SORCER_SET_EXPROP_SEND(self, skl, propName, saveHandle)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList == 0 then
        return;
    end
    for i = 1, #tgtList do 
        local tgt = tgtList[i];
        if GetExProp(tgt, propName) == 1 then
    SetExPropSend(tgt, propName);
    if 1 == saveHandle then
        SetExProp(self, propName, GetHandle(tgt));
    end
            break;
        end
    end
end

function SKL_CHECK_EXPROP_OBJ_RANGE(self, skl, propName, propValue, range)  
    return 1;
end

function SKL_CHECK_BY_SCRIPT(self, skl, funcName)
    local func = _G[funcName];
    return func(self, skl);

end

function SORCERER_SPEND_SP(self, skl, tgt)  
    local sn = imcTime.GetAppTime();
    local cnt = 0;
    while 1 do
        local ctrlTarget = GetControlTarget(self);
        if ctrlTarget == nil or IsSameObject(ctrlTarget,tgt) == 0 then
            return;
        end

--      local sp = self.SP;
--      local spendSP = 1;
--      if sp < spendSP then
--          ControlObject(self, nil, 1, 1, 1, "None", "None");
--          return;
--      end
--      AddSP(self, -spendSP);
        sleep(100);
    end

end

function SORCERER_EQUIP_BOSSCARD_CHECK(self, skl)
    local etc = GetETCObject(self);
    if etc == nil then
        SkillCancel(self);
        return;
    end

    if etc.Sorcerer_bosscardName1 == 'None' or etc.Sorcerer_bosscard1 == 0 then
        SkillCancel(self);
        SendSysMsg(self, "DropCartToSlot"); 
        return;
    end

    local carditemcnt = GetInvItemCountByType(self, etc.Sorcerer_bosscard1)
    
    if carditemcnt < 1 then
        SkillCancel(self);
        etc["Sorcerer_bosscard1"] = 0
        etc["Sorcerer_bosscardName1"] = 'None'
        SendSysMsg(self, "NoCardAvailable");    
        SendProperty(self, etc);
        SendAddOnMsg(self, "UPDATE_GRIMOIRE_UI", "", 0);
        return;
    end

    local mapCls = GetMapProperty(self);
    if mapCls == nil then
        SkillCancel(self);
        return;
    end
    
    if 'City' == mapCls.MapType then
        SkillCancel(self);
        SendSysMsg(self, "DonCreateMonThisAria");
        return;
    end

end

function SORCERER_EQUIP_SUBCARD_CHECK(self, skl)
    local etc = GetETCObject(self);
    if etc == nil then
        SkillCancel(self);
        return;
    end

    if etc.Sorcerer_bosscardName2 == 'None' or etc.Sorcerer_bosscard2 == 0 then
        SkillCancel(self);
        SendSysMsg(self, "DropCartToSlot"); 
        return;
    end
    
    local list , cnt  = GetAliveFolloweList(self);
    local createMainMon = 0;
    for i = 1 , cnt do
        local obj = list[i];
        if obj.ClassName == etc.Sorcerer_bosscardName1 then
            createMainMon = 1;
        end
    end

    if 0 == createMainMon then
        SkillCancel(self);
        return;
    end
    local carditemcnt= GetInvItemCountByType(self, etc.Sorcerer_bosscard2)

    if carditemcnt < 1 then
        SkillCancel(self);
        etc["Sorcerer_bosscard2"] = 0
        etc["Sorcerer_bosscardName2"] = 'None'
        SendSysMsg(self, "NoCardAvailable");    
        SendProperty(self, etc);
        SendAddOnMsg(self, "UPDATE_GRIMOIRE_UI", "", 0);
        return;
    end
	
    local mapCls = GetMapProperty(self);
    if mapCls == nil then
        SkillCancel(self);
        return;
    end
    
    if 'City' == mapCls.MapType then
        SkillCancel(self);
        SendSysMsg(self, "DonCreateMonThisAria");
        return;
    end
end

function SORCERER_SUMMONING_MON(self, parent, skl)
    SetExProp(self, 'SORCERER_SUMMONING', 1);
    local etc_pc = GetETCObject(parent);
    local cardGuid = etc_pc.Sorcerer_bosscardGUID1;
    local card = GetInvItemByGuid(parent, cardGuid);
    
    if nil == card then
        Kill(self);
        return;
    end

    local caster = GetOwner(self);
    if caster == nil then
        Kill(self);
        return;     
    end
    self.Lv = caster.Lv;
--    self.StatType = 2001;
    
    SCR_SORCERER_SUMMON_STATE_CALC(self, caster, skl, card);
    
    local summoningInfo = GetSkill(caster, 'Sorcerer_Summoning');
    local scale;
    
    if summoningInfo ~= nil then
        scale = 0.7 + (summoningInfo.Level/15) * 0.3;
    else
        scale = 0.7 + (skl.Level/15) * 0.3;
    end

    ChangeScale(self, scale, 0, 1, 1);
    DontUseEventHandler(self, "handler_eat_heal");
    DontUseEventHandler(self, "handler_hp_runaway");
    SetLifeTime(self, 900)
end

function SORCERER_EVOCATION(self, parent, skl)
    local etc_pc = GetETCObject(parent);
    local itemGuid = etc_pc.Sorcerer_bosscardGUID2;
    local item = GetInvItemByGuid(parent, itemGuid);
    if nil == item then
        Kill(self)
        return;
    end

    local caster = GetOwner(self);
    if caster == nil then
        Kill(self)
        return;     
    end
        
    local summoningInfo = GetSkill(caster, 'Sorcerer_Evocation');
    local scale;
    
    if summoningInfo ~= nil then
        scale = 0.7 + (summoningInfo.Level/15) * 0.3;
    else
        scale = 0.7 + (skl.Level/15) * 0.3;
    end

    ChangeScale(self, scale, 0, 1);

    RunScript('SORCERER_EVOCATION_DEAD', self)

end

function SORCERER_EVOCATION_DEAD(self)
    
    sleep(100)
    
    PlayAnim(self, "dead")
    sleep(2000)

    local owner = GetOwner(self);
    if owner ~= nil then
    local x, y, z = GetPos(self, x, y, z);
    local skill = GetSkill(owner, "Sorcerer_Evocation");
        if skill ~= nil then
    local range = 30 + 5 * skill.Level;
    SPLASH_DAMAGE(owner, x, y, z, range, skill.ClassName, 1, false, 1, 0);
        end
    end
    
    Dead(self)
end

function SORCERER_SALOON(self, parent, skl)
    local caster = GetOwner(self);  
    if caster == nil then
        Kill(self);
        return;     
    end
    
    self.Lv = caster.Lv;
--    self.StatType = 4001;
    
    SCR_SORCERER_SUMMON_STATE_CALC(self, caster, skl);
    
    SetExProp(self, "SORCERER_SUMMONSALOON", 1)
    SetExPropSend(self, "SORCERER_SUMMONSALOON");
    SetExProp(caster, "SORCERER_SUMMONSALOON", GetHandle(self));
    SetLifeTime(self, 300)
    DontUseEventHandler(self, "handler_eat_heal");
    DontUseEventHandler(self, "handler_hp_runaway");
end

function SORCERER_SERVANT(self, parent, skl)
    SetExProp(self, "SORCERER_SUMMONSERVANT", 1)
    SetExProp(parent, "SORCERER_SERVANTSKILLLV", skl.Level)
    local caster = GetOwner(self);  
    if caster == nil then
        Dead(self);
        return;     
    end
    self.Lv = caster.Lv;
    self.StatType = 1
    --self.HP = skl.Level;
    SetExProp(self, "SKL_LEVEL", skl.Level);
    InvalidateStates(self);
    
    DontUseEventHandler(self, "handler_eat_heal");
    DontUseEventHandler(self, "handler_hp_runaway");

    RunScript("SERVANT_CREATEPAD", self, skl);
end

function SERVANT_CREATEPAD(self, skl)
    if nil == self then
        return;
    end
    local sleepTime = 5
    
    local owner = GetSkillOwner(skl)
    local skill = GetSkill(owner, "Sorcerer_SummonServant")
    if skill == nil then
        return
    end
    
    local abil = GetAbility(owner, "Sorcerer13")
    if abil ~= nil and skill.Level >= 3 then
        sleepTime = 2.5
    end
    
    sleep(sleepTime * 1000);
    
    local buffList = {"servantpad_SR","servantpad_SP","servantpad_STA","servantpad_MDEF","servantpad_DARKATK"};
    local maxCount = GetExProp(self, "SKL_LEVEL");
    
    if #buffList < maxCount then
        maxCount = #buffList;
    end
    
    for i = 1, maxCount do
        sleep(500)
        local x,y,z = GetPos(self);
        PlayAnim(self, "SKL", 1)
        RunPad(self, buffList[i], nil, x, y, z, 0, 1);
        sleep(sleepTime * 1000);
    end
    
    local parent = GetOwner(self)
    Dead(self);
    
    DelExProp(parent, "SORCERER_SERVANTSKILLLV")
end

function SCR_BUFF_ENTER_sorcerer_bat(self, buff, arg1, arg2, over)
    local skillLv = arg1;
    SetExProp(buff, 'SORCERER_BAT_COUNT', skillLv);
    local skl = GetSkill(self, 'Sorcerer_SummonFamiliar');
    local simpleAi = 'follow_bat';

    for i=1, skillLv do
        local x, y, z = GetFrontRandomPos(self, 20, 10);
        local mon = MONSKL_CRE_MON(self, skl, 'pcskill_summon_Familiar', x, y, z, IMCRandom(1, 359), '', '', 1, 0, simpleAi, nil);
        if mon ~= nil then
            EnableAIOutOfPC(mon);
            HoldScpForMS(mon, 800);
            SetOwner(mon, self, 1);
            SetExProp(buff, 'SORCERER_BAT_' .. i, GetHandle(mon));
            SetExProp(buff, 'SORCERER_USABLE_BAT_' .. i, 1);
            DontUseEventHandler(mon, "handler_eat_heal");
            DontUseEventHandler(mon, "handler_hp_runaway");
        end
    end
end
function SCR_BUFF_UPDATE_sorcerer_bat(self, buff, arg1, arg2, RemainTime, ret, over)
    local count = GetExProp(buff, 'SORCERER_BAT_COUNT');
    local zoneInst = GetZoneInstID(self);
    for i=1, count do
    
        local monHandle = GetExProp(buff, 'SORCERER_BAT_' .. i);
        local mon = GetByHandle(zoneInst, monHandle);
        if mon ~= nil then
            return 1;
        end
    end
    SetExProp(buff, 'SORCERER_BAT_COUNT', 0);
    RemoveBuff(self, buff.ClassName);
    return 0;
end

function SCR_BUFF_LEAVE_sorcerer_bat(self, buff, arg1, arg2, over, isLastEnd)
    local skillLv = GetExProp(buff, 'SORCERER_BAT_COUNT');  
    local zoneInst = GetZoneInstID(self);
    for i=1, skillLv do
    
        local monHandle = GetExProp(buff, 'SORCERER_BAT_' .. i);
        local mon = GetByHandle(zoneInst, monHandle);
        if mon ~= nil then
            Dead(mon);
        end
    end
end

function RESET_SORCERER_BAT_AI(self, buff, index)
    StopMove(self);
    SetExProp(buff, 'SORCERER_USABLE_BAT_' .. index, 1);
    UnHoldMonScp(self);
end

function ATTACK_SORCERER_BAT_AI(self, target, buff, index)
    while 1 do
        if target == nil or IsDead(target) == 1 or (target.ClassName == 'pcskill_icewall' or target.ClassName == 'hidden_monster2') then
            RESET_SORCERER_BAT_AI(self, buff, index);
            return;
        end
        
        local x, y, z = GetPos(target);
        local cx, cy, cz = GetPos(self);        
        local distToDest = math.dist(cx, cz, x, z);
        if distToDest <= 20 then
            break;
        end
        
        MoveEx(self, x, y, z, 1);
        sleep(500);
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil or target == nil then
        return;
    end
    
    if IsSameActor(caster, target) == 'YES' then
        return;
    end
    
    if GetRelation(caster, target) ~= "ENEMY" then
        return;
    end
    
    local skl = GetSkill(caster, 'Sorcerer_SummonFamiliar');
    local damage = GET_SKL_DAMAGE(caster, target, 'Sorcerer_SummonFamiliar');
    local abilResultfail = false;
    
    local key = GenerateSyncKey(self)
    StartSyncPacket(self, key);
    local Sorcerer1_abil = GetAbility(caster, "Sorcerer1")
    if Sorcerer1_abil ~= nil and skl.Level >= 3 then
        if Sorcerer1_abil.Level * 100 > IMCRandom(0,9999) then
            local objList, objCount = SelectObject(self, 50, 'ENEMY');
            for i = 1 , objCount do
                if objList[i] ~= target then
                    local result = TakeDamage(caster, objList[i], skl.ClassName, damage);
                    if nil == result and abilResultfail == false then
                         abilResultfail = true
                    end
                end
            end
        end
    else
        abilResultfail = true;
    end
    
    local result = TakeDamage(caster, target, skl.ClassName, damage);
    
    if nil ~= result or abilResultfail == false then
    PlayEffect(self, "I_explosion012_dark", 0.5, 0, "TOP")
    Dead(self);
    else
        RESET_SORCERER_BAT_AI(self, buff, index);
    end
    
    EndSyncPacket(self, key, 0);
    ExecSyncPacket(self, key);
end

function ATTACK_SORCERER_BAT(self, buff, tgt)
    local count = GetExProp(buff, 'SORCERER_BAT_COUNT');
    local zoneInst = GetZoneInstID(self);
    for i=1, count do
    
        local usable = GetExProp(buff, 'SORCERER_USABLE_BAT_' .. i);
        if usable == 1 then
            local monHandle = GetExProp(buff, 'SORCERER_BAT_' .. i);
            local mon = GetByHandle(zoneInst, monHandle);       
            if mon ~= nil then
                SetExProp(buff, 'SORCERER_USABLE_BAT_' .. i, 0);
                HoldMonScp(mon);
                RunScript("ATTACK_SORCERER_BAT_AI", mon, tgt, buff, i);
                return
            end
        end
    end
end



-- self : Monster
-- caster : PC
-- skil : Skill
-- card : if use Card..
function SCR_SORCERER_SUMMON_STATE_CALC(self, caster, skl, card)
    local bySkillLevel = 0.05 + (skl.Level * 0.03);
    local bycardLevel = 0
    if card ~= nil then
        bySkillLevel = 0.05 + (skl.Level * 0.02);
        bycardLevel = card.Level * 0.05;
    end
    
    self.PATK_BM = self.MINPATK * (bySkillLevel + bycardLevel);
    self.MATK_BM = self.MINMATK * (bySkillLevel + bycardLevel);
    
    self.DEF_BM = self.DEF * (bySkillLevel + bycardLevel);
    self.MDEF_BM = self.MDEF * (bySkillLevel + bycardLevel);
    
    InvalidateStates(self);
end
