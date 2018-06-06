-- monskl_custom_summon.lua


function MONSKL_CRE_MON(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp)
    if 'None' == className then
        return nil;
    end

    local mon1obj = CreateGCIES('Monster', className);
    
    local a, b = GetDirectionByAngle(mon);

    if mon1obj == nil then
        return nil;
    end

    if name ~= "" and name ~= mon1obj.Name then
        mon1obj.Name = name;
    end

    if btName ~= "" then
        mon1obj.BTree = btName;
    end
    
    mon1obj.EXP_Rate = 0;
    mon1obj.JEXP_Rate = 0;
    
    local lv = 0;
    
    if IS_PC(mon) == 1 then
        lv = mon.Level + lvFix;
    else 
        lv = mon.Lv + lvFix;
    end

    if lv <= 0 then
        mon1obj.Lv = 1;
    else
        mon1obj.Lv = lv;
    end
    
    if mon1obj~= nil and monProp ~= nil then
        ApplyPropList(mon1obj, monProp, mon, skl);
    end


    local range = 1;
    local layer = GetLayer(mon);
    if angle > -1 and angle < 44 then
        angle = 5
    end
    local mon1 = CreateMonster(mon, mon1obj, x, y, z, angle, range, 0, layer);
    if mon1 == nil then
        return nil;
    end

    SetExProp(mon1, 'COPY_SKLLEVEL', skl.Level);
    if skl.ClassName == "Cryomancer_SubzeroShield" then
        SetExArgObject(mon, "Cryomancer_SubzeroShield", mon1);
    end

    SetBroadcastOwner(mon1);
    SetOwner(mon1, mon, 1);
    SetHookMsgOwner(mon1, mon);
    SetCurrentFaction(mon1, GetCurrentFaction(mon));    
    if lifeTime > 0 then
        SetLifeTime(mon1, lifeTime);
    end

    if simpleAi ~= nil and simpleAi ~= "None" then
        RunSimpleAI(mon1, simpleAi);
    end

    DelayEnterWorld(mon1);
    EnterDelayedActor(mon1);
    SetExProp_Str(mon1, "CREATED_SKILL", skl.ClassName);

    return mon1;

end

function MONSKL_CRE_MON_PC(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp, track, count)

    local pcCount = GetLayerPCCount(GetZoneInstID(mon), GetLayer(mon));

    if nil == pcCount or 3 > pcCount then
        MONSKL_CRE_MON(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
    else
        local bos_x, bos_y, bos_z = GetPos(mon);
        local target_x, target_y, target_z;
        target_x = bos_x - x;
        target_y = bos_y - y;
        target_z = bos_z - z;

        local maxCount = (pcCount-2) + (count -1);
        for i = 0, maxCount do
            MONSKL_CRE_MON(mon, skl, className, x+(target_x*i), y+(target_y*i), z+(target_z*i), angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
        end
    end
end


function MONSKL_CRE_MON_SCR(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp, scpName)
    -- 11월 2일 9랭크 몬스터 생성 후 스크립트 관련 스킬 버그 임시 처리 --
--    local skillClassName = TryGetProp(skl, 'ClassName');
--    if skillClassName == 'Sorcerer_Summoning' or skillClassName == 'Sorcerer_Morph' then
--        scpName = 'SORCERER_SUMMONING_MON';
--    elseif skillClassName == 'Sapper_Claymore' then
--        scpName = 'INIT_SAPPER_TRAP';
--    end
    -- 11월 2일 9랭크 몬스터 생성 후 스크립트 관련 스킬 버그 임시 처리 끝 --
    local mon1 = MONSKL_CRE_MON(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
    if mon1 ~= nil then
        local func = _G[scpName];
        func(mon1, self, skl);
    end
end

function MONSKL_CRE_MON_CNT_SCR(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp, cnt, scpName)
    for i = 1 , cnt do
        local mon1 = MONSKL_CRE_MON(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
        if mon1 ~= nil then
            local func = _G[scpName];
            func(mon1, self, skl, i, cnt);
        end
    end
end

function DEL_MON_SKILL(self, skl)
    local monObj = GetExArgObject(self, skl.ClassName);
    if monObj ~= nil then
    Kill(monObj)
    end
end

function CRE_MON_CONTROL(self, skl, className, x, y, z, angle, name, lvFix, lifeTime, simpleAi, monProp, eft, eftScale, finEft, finEftScl, lookAtMon, raiseFromGround, stdAnim, changeScale)

    local mon1obj = CreateGCIES('Monster', className);
    if mon1obj == nil then
        return nil;
    end

    if name ~= "" and name ~= mon1obj.Name then
        mon1obj.Name = name;
    end

    mon1obj.Tactics = "None";
    mon1obj.BTree = "None";

    local lv = self.Lv;
    lv = lv + lvFix;
    mon1obj.Lv = lv;
    ApplyPropList(mon1obj, monProp, self, skl);

    local range = 1;
    local layer = GetLayer(self);
    local mon1 = CreateMonster(self, mon1obj, x, y, z, angle, range, 0, layer);
    if mon1 == nil then
        return nil;
    end

    SetOwner(mon1, self, 1);
    SetHookMsgOwner(mon1, self);
    SetCurrentFaction(mon1, GetCurrentFaction(self));
    if lifeTime > 0 then
        SetLifeTime(mon1, lifeTime);
    end

    if simpleAi ~= nil and simpleAi ~= "None" then
        RunSimpleAI(mon1, simpleAi);
    end

    AttachEffect(mon1, eft, eftScale, "BOT", 0, 10, 0);
    local lookControlPos = 0;
    if lookAtMon == 2 then
        lookControlPos = 1;
    end

    SetSkillEndDestroy(mon1, self);
    SetClientDeadScript(mon1, "MSL_DEAD_C", finEft, finEftScl);
    if lookAtMon == 1 then
        SetZombieScript(mon1, "RESET_OWNER_LOOKAT");
        SetLookAtObject(self, mon1);
    end

    if stdAnim ~= "None" then
        SetSTDAnim(mon1, stdAnim);
        SetMoveAniType(mon1, stdAnim);
    end

    if changeScale ~= 0 then
        ChangeScale(mon1, changeScale, 0);
    end
    
    DelayEnterWorld(mon1);
    EnterDelayedActor(mon1);

    if raiseFromGround ~= 0 then
        SetRaiseFromGround(mon1, raiseFromGround);
    end
    SetExProp(mon1, 'COPY_SKLLEVEL', skl.Level);
    ControlObject(self, mon1, lookControlPos, 1, 1, "None", "None");

    return mon1;

end

function SORCER_TGT_ATTACH_SELF_TO_TARGET(self, skl, node, attachSec, eft, eftScale, attachAnim)
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

    AttachToObject(self, tgt, node, "None", 1, attachSec, 0, 0, 0, attachAnim);
    if eft ~= "None" then
        PlayEffect(self, eft, eftScale);
        local x, y, z = GetPos(self);
        PlayEffectToGround(self, eft, x, y, z, eftScale);
    end
end

function TGT_DETACH_FROM_ALL_OBJECT(self, skl)
    DetachAllObject(self);
end

function ATTACH_TO_CREATED(self, skl, monName, node, attachSec, eft, eftScale, attachAnim)
    if monName == "None" then
        AttachToObject(self, nil, "None", "None", 1, attachSec, 0, 0, 0);
        return;
    end

    if attachAnim == nil then
        attachAnim = "None"
    end

    local mon = GET_FOLLOW_BY_NAME(self, monName);
    if mon == nil then
        return;
    end

    AttachToObject(self, mon, node, "None", 1, attachSec, 0, 0, 0, attachAnim);
    CancelMonsterSkill(mon);

    if eft ~= "None" then
        PlayEffect(self, eft, eftScale);
        local x, y, z = GetPos(self);
        PlayEffectToGround(self, eft, x, y, z, eftScale);
    end
end

function RESET_OWNER_LOOKAT(self)
    local owner = GetOwner(self);
    SetLookAtObject(owner, nil);
end

function MONSKL_CRE_MON_IM_NOT_OWNER(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp, scpName)

    local mon1obj = CreateGCIES('Monster', className);
    if mon1obj == nil then
        return nil;
    end

    if name ~= "" and name ~= mon1obj.Name then
        mon1obj.Name = name;
    end

    if btName ~= "" then
        mon1obj.BTree = btName;
    end

    local lv = 0;
    
    if IS_PC(mon) == 1 then
        lv = mon.Level + lvFix;
    else 
        lv = mon.Lv + lvFix;
    end
    
    if lv <= 0 then
        mon1obj.Lv = 1;
    else
        mon1obj.Lv = lv;
    end

    if mon1obj~= nil and monProp ~= nil then
        ApplyPropList(mon1obj, monProp, mon, skl);
    end
    
    local range = 1;
    local layer = GetLayer(mon);
    local mon1 = CreateMonster(mon, mon1obj, x, y, z, angle, range, 0, layer);
    if mon1 == nil then
        return nil;
    end

    SetExProp(mon1, 'COPY_SKLLEVEL', skl.Level);

    if lifeTime > 0 then
        SetLifeTime(mon1, lifeTime);
    end

    if simpleAi ~= nil and simpleAi ~= "None" then
        RunSimpleAI(mon1, simpleAi);
    end

    SetExArgObject(mon1,"SUMMONER",mon);    
    DelayEnterWorld(mon1);
    EnterDelayedActor(mon1);

    if scpName ~= nil and scpName ~= 'None' then
        local func = _G[scpName];
        func(mon1, mon, skl);
    end

    return mon1;

end

function MONSKL_KILL_FOL_EXPROP(self, skl, propName, propValue)
    
    local list , cnt  = GetFollowerList(self);
    for i = 1 , cnt do
        local fol = list[i];
        local handle = GetExProp(self, propName);
        if handle ~= 0 then
            if GetHandle(fol) == handle and
                GetExProp(fol, propName) == propValue then
                Dead(fol);
                SetExProp(self, propName, 0);
            end
        else
            if GetExProp(fol, propName) == propValue then
                Dead(fol);
            end
        end
    end
end

function MONSKL_KILL_FOL(self, skl, monClsName)
    local list , cnt  = GetFollowerList(self);
    for i = 1 , cnt do
        local fol = list[i];
        if fol.ClassName == monClsName then
            Dead(fol);
        end
    end
end

function CRE_MON_TIMEBOMB(mon, skl, monName, lvFix, x, y, z, throwTime, tEft, tEftScale, tFEft, tFEftScale, bombTime, bombModel, toScale, finEft, finEftScale)

    MslThrow(mon, tEft, tEftScale, x, y, z, 5.0, throwTime, 0, 1, 2.0, tFEft, tFEftScale);
    sleep(throwTime* 1000);
    local bomb = MONSKL_CRE_MON(mon, skl, "Missile", x, y, z, 0, "", "BT_TimeMon", 0, 0);
    if bomb == nil then
        return;
    end

    local lv = mon.Lv + lvFix;
    SetExProp_Str(bomb, "MonName", monName);
    SetExProp(bomb, "MonLv", lv);
    SetOwner(bomb, mon, 1);
    local curTime = imcTime.GetAppTime();
    SetExProp(bomb, "_B_DE_SECOND", curTime + bombTime + 1);
    
    if bombModel ~= "None" then
        ChangeModel(bomb, bombModel);
        ChangeScale(bomb, toScale, bombTime + 1);
    end

    SetExProp_Str(bomb, "DEADEFT", finEft);
    SetExProp(bomb, "DEADEFT_SCL", finEftScale);

end

function T_BOMB_MODEL(mon, skl, x, y, z, power, range, kdPower, throwTime, tEft, tEftScale, tFEft, tFEftScale, bombTime, modelMonName, toScale, finEft, finEftScale, mspd, kdAngle)

    MslThrow(mon, tEft, tEftScale, x, y, z, 5.0, throwTime, 0, 100, 2.0, tFEft, tFEftScale);
    sleep(throwTime* 1000);
    local bomb = MONSKL_CRE_MON(mon, skl, "Missile", x, y, z, 0, "", "BT_TimeBomb", 0, 0);
    if bomb == nil then
        return;
    end

    if kdAngle == nil then
        kdAngle = 0;
    end
    
    SetOwner(bomb, mon, 1);
    if bombTime > 0 then
        ChangeModel(bomb, modelMonName);
        ChangeScale(bomb, toScale, bombTime);
    end

    SetExProp_Str(bomb, "DEADEFT", finEft);
    SetExProp(bomb, "DEADEFT_SCL", finEftScale);

    local curTime = imcTime.GetAppTime();
    SetExProp(bomb, "_B_DE_SECOND", curTime + bombTime);
    SetExProp(bomb, "_B_POWER", power);
    SetExProp(bomb, "_B_RANGE", range);
    SetExProp(bomb, "_B_KDPOWER", kdPower);
    SetExProp(mon, "SET_TOOL_VANGLE", kdAngle)

    bomb.FIXMSPD_BM = mspd;
    if mspd > 0.0 then
        InvalidateMSPD(bomb);
    end

    return bomb
end

function T_BOMB_BUCK(mon, skl, x, y, z, power, range, kdPower, throwTime, tEft, tEftScale, tFEft, tFEftScale, bombTime, modelMonName, toScale, finEft, finEftScale, buckCnt, buckDelay, buckSpd, buckAccel, buckLife, buckEft, buckEftScale)

    local bomb = T_BOMB_MODEL(mon, skl, x, y, z, power, range, kdPower, throwTime, tEft, tEftScale, tFEft, tFEftScale, bombTime, modelMonName, toScale, finEft, finEftScale);
    if bomb ~= nil then
        SetExProp(bomb, "_BUCK_CNT", buckCnt);
        SetExProp(bomb, "_BUCK_DELAY", buckDelay);
        SetExProp(bomb, "_BUCK_SPD", buckSpd);
        SetExProp(bomb, "_BUCK_ACCEL", buckAccel);
        SetExProp(bomb, "_BUCK_LIFE", buckLife);
        SetExProp_Str(bomb, "_BUCK_EFT", buckEft);
        SetExProp(bomb, "_BUCK_EFT_SCALE", buckEftScale);
    end

end

function MSL_BUCK(mon, skl, x, y, z, angle, power, range, kdPower, kdAngle, shootAngle, shootCnt, shootDelay, spd, accel, lifeTime, eft, eftScale, direction, verticalRate, kdType)

    local angleList = {};           
    for i = 1 , shootCnt  do
        angleList[i] = angle + (i - 0.5) * shootAngle * direction / shootCnt - shootAngle * direction / 2;
    end

    if kdType == nil then
        kdType = 1;
    end

    SetExProp(skl, "SET_TOOL_VANGLE", kdAngle)

    skl.KDownPower = kdPower;
    skl.KnockDownHitType = kdType;

    shootDelay = shootDelay * 0.001;    

    local delayTime = 0.0;
    for i = 1 , shootCnt do
        ShootServerMsl(mon, delayTime, x, y, z, angleList[i], spd, accel, power, range, lifeTime, eft, eftScale, verticalRate);
        delayTime = delayTime + shootDelay;
    end
end

function CREATE_MINE(mon, skl, x, y, z, throwTime, tEft, tEftScale, tFEft, tFEftScale, modelName, mineType, bombEft, bombEftScl, resTime, power, range, kdPower, lifeSec, targetBuff, modelEft, modelEftScale, gravity, horEasing, scpName)
    
    if targetBuff == nil then
        targetBuff = 'None';
    end

    if scpName == nil then
        scpName = 'None';
    end

    local ox,oy,oz = GetPos(mon);

    local dist = (ox - x)*(ox - x) + (oy - y)*(oy - y) + (oz - z)*(oz - z);

    throwTime = math.sqrt(dist) / 100 * throwTime;
    
    if throwTime > 0 then
        MslThrow(mon, tEft, tEftScale, x, y, z, 5.0, throwTime, 0, gravity, horEasing, tFEft, tFEftScale);
        sleep(throwTime* 1000 + 280);
    end

    local monName = 'Missile'
    if  modelName == 'skill_New_caltrops' then
        monName = modelName;
    elseif  modelName == 'pcskill_pear_of_anquish' then
        monName = modelName;
    end

    local bomb = MONSKL_CRE_MON(mon, skl, monName, x, y, z, 0, "", "Mine", 0, 0);
    if bomb == nil then
        return;
    end

    local key = GenerateSyncKey(bomb);
    StartSyncPacket(bomb, key);

    if modelEft ~= "None" then
        AttachEffect(bomb, modelEft, modelEftScale);
    end

    if modelName ~= "None" then
        ChangeModel(bomb, modelName);
        local changeMonCls = GetClass("Monster", modelName);
        ChangeScale(bomb, changeMonCls.Scale);
    end

    if lifeSec > 0.0 then
        SetLifeTime(bomb, lifeSec);
    end
    EndSyncPacket(bomb, key, 0);

    SetExProp(bomb, "_RESTIME", resTime);
    SetExProp(bomb, "_POWER", power);
    SetExProp(bomb, "_RANGE", range);
    SetExProp(bomb, "_KDPOWER", kdPower);
    SetExProp_Str(bomb, "_EFT", bombEft);
    SetExProp(bomb, "_EFT_SCALE", bombEftScl);
    SetExProp_Str(bomb, "_TARGET_BUFF", targetBuff);

    if bomb ~= nil and scpName ~= nil and scpName ~= 'None' then
        local func = _G[scpName];
        func(bomb, self, skl);
    end

    
end

function MONSKL_CRE_MON_FORCE(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, throwTime, tEft, tEftScale, finEft, finEftScale, simpleAI)

    MslThrow(mon, tEft, tEftScale, x, y, z, 5.0, throwTime, 0, 200, 2.0, finEft, finEftScale);
    sleep(throwTime * 1000);
    MONSKL_CRE_MON(mon, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAI);

end

function SKL_DESTRUCT_FOL(self, skl, monClsName, anim, eft, eftScale, range, damRate)

    local list , cnt  = GetFollowerList(self);
    if cnt == 0 then
        return;
    end
    
    local skillName = skl.ClassName;
    for i = 1 , cnt do
        local fol = list[i];
        if fol.ClassName == monClsName then
            Dead(fol);
            PlayEffect(fol, eft, eftScale, 0, "MID");
            local objList, objCount = SelectObjectNear(self, fol, range, 'ENEMY');
            for j = 1 , objCount do
                local tgt = objList[j];
                local damage = SCR_LIB_ATKCALC_RH(self, skl);                       
                damage = damage * damRate;
                TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName);
            end
        end
    end 
end

function SKL_FOLL_SACRIFICE(self, skl, monClsName, time, ratio)

    local fol = GET_FOLL_BY_NAME(self, monClsName);
    if fol == nil then
        return;
    end

    if fol ~= nil then
        AddBuff(self, fol, "SoulDefence", 0, 0, time, time);
    end

end



function MONSKL_CRE_FIREBALL(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monBuff, eft, eftScale, monProp)

    local mon = MONSKL_CRE_MON_IM_NOT_OWNER(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
    if mon == nil then
        return;
    end
    
    AddScpObjectList(self, "PC_SKILL_FIREBALL", mon);
    local fireballList = GetScpObjectList(self, "PC_SKILL_FIREBALL");
    if #fireballList > 5 then
        Kill(fireballList[1]);
    end
    
    SetExProp(mon, "CASTER_HANDLE", GetHandle(self));
    AddHitScript(mon, "FIREBALL_MON_HIT");
    SetTakeDamageScp(mon, "FIREBALL_MON_TAKEDAMAGE");
    SetHideFromMon(mon, 1);

    if monBuff ~= 'None' then
        AddBuff(self, mon, monBuff, lvFix, 0, 0, 1);
    end

    if eft ~= 'None' then
        AttachEffect(mon, eft, eftScale);
    end
end

function FIREBALL_MON_HIT(self, from, skl, damage, ret)
    if ret ~= nil and skl ~= nil and true == IS_PC(from) then
        ret.Damage = 0;
        local caster = GetExProp(self, "CASTER_HANDLE");
        local pcHandle = GetHandle(from);
        
        if skl.ClassType == 'Melee' and caster == pcHandle then
            local x, y, z = GetFrontPos(from, 80);
            y = GetHeightAtPos(from, x, y, z);
            
            local key = GetSkillSyncKey(from, ret);
            StartSyncPacket(from, key);
            Move3D(self, x, y, z, 300, 0, 1, 1);
            EndSyncPacket(from, key);
            ret.HitDelay = 0;
        else
        
            if skl.ClassName == 'Psychokino_PsychicPressure' then
                local fireballBuff = GetBuffByName(self, 'FireBall_Buff');
                if fireballBuff ~= nil then
                    local fireballCaster =  GetBuffCaster(fireballBuff);
                    if fireballCaster ~= nil then
                        local x, y, z = GetPos(self);
                        local fireballSkl = GET_MON_SKILL(fireballCaster, 'Pyromancer_FireBall');                       
                        MONSKL_PAD_MSL_BUCK(fireballCaster, fireballSkl, x, y, z, 'Shootpad_Fireball', 0, 100, 9, 40, 500, 200, 0);

                        return;
                    end
                end
            end

            ret.ResultType = HITRESULT_INVALID;
            ret.HitType = HIT_NOHIT;
            ret.EffectType = HITEFT_NO;
            ret.HitDelay = 0;           
        end
    end
end
    
function FIREBALL_MON_TAKEDAMAGE(self, from, skl, damage, ret)
    damage = 0;
    if ret == nil then
        return;
    end

    ret.Damage = 0;
    
end

function SCR_SUMMON_SET_EXPROP(mon, self, skl, isPVP)
    local owner = GetOwner(mon);
    if nil == owner then
        local summoner = GetExArgObject(mon,"SUMMONER");
        if summoner ~= nil then
            owner = summoner;
        else
            if self ~= nil then
                owner = self;
            else
                Kill(mon);
                return;
            end
        end
    end
    
    if nil == isPVP then
        isPVP = 0;
    end

    if 1 == isPVP then
        if IsPVPServer(owner) == 1 then
            local cmd = GetMGameCmd(owner);
            if cmd ~= nil then
                local handle = GetHandle(owner)
                SetExProp(mon, 'OwnerHandle', handle);
                cmd:AddUserValue(mon.ClassName..handle, 1, 0, false)
            end
        end
    else
        local cnt = GetExProp(owner, mon.ClassName)        
        cnt = cnt + 1
        SetExProp(owner, mon.ClassName, cnt);
    end

    SetDeadScript(mon, 'SCR_SUMMON_DEAD_SCRIPT')
end

function SCR_SUMMON_DEAD_SCRIPT(mon)
    if IsPVPServer(mon) == 1 then
        local ownerHandle = GetExProp(mon, 'OwnerHandle')
        local cmd = GetMGameCmd(mon);
        if nil ~= cmd then
            cmd:AddUserValue(mon.ClassName..ownerHandle, -1, 0, false)
        end
    end

    local owner = GetOwner(mon);
    if nil == owner then
        owner = GetExArgObject(mon,"SUMMONER"); 
    end
    if nil == owner then
        return;
    end

    local cnt = GetExProp(owner, mon.ClassName)
    cnt = cnt - 1
    if cnt <= 0 then
        cnt = 0;
    end
    
--    if mon.ClassName == 'pcskill_wood_ausrine2' then
--        RemoveBuff(owner, 'Ausirine_Buff')
--        local objList, objCount = GetPartyMemberList(owner, PARTY_NORMAL, 500)
--        for i = 1, objCount do
--            RemoveBuff(objList[i], 'Ausirine_Buff')
--        end
--    end   
    
    SetExProp(owner, mon.ClassName, cnt);
end


function MONSKL_CRE_MON_TARGET(self, skl, className, angle, name, btName, lvFix, lifeTime, simpleAi, monBuff, splashRange, sr, eft, eftScale, monProp)
    local targetList = GetHardSkillTargetList(self)
    if #targetList == 0 then
        return;
    end
    
    for i = 1, #targetList do
        local x, y, z = GetPos(targetList[i])
        
        local mon = MONSKL_CRE_MON_IM_NOT_OWNER(self, skl, className, x, y, z, angle, name, btName, lvFix, lifeTime, simpleAi, monProp);
        if mon == nil then
            return;
        end
        
        SetHideFromMon(mon, 1);
        
        if monBuff ~= 'None' then
            AddBuff(self, mon, monBuff, lvFix, 0, lifeTime*1000, 1);
        end
        
        SetExProp(mon, "OBJECT_SPLASH_RANGE", splashRange)
        SetExProp(mon, "OBJECT_SR", sr)
        
        if eft ~= 'None' then
            AttachEffect(mon, eft, eftScale);
        end
    end
end
