--- hardskill_oobe.lua

function END_OOBE(dpc, detachSpd, animName, syncKey)

    local owner = GetOwner(dpc);
    local moveTime = 0.0;
    if owner ~= nil then
        local dist = GetDist2D(dpc, owner);
        moveTime = dist / detachSpd;
    end

    OOBE_RESET_OWNER(dpc, detachSpd, 0, animName, syncKey);
    
    if moveTime > 0 then
        sleep(moveTime * 1000 + 500);
    end

    SetZombie(dpc);
end

function OOBE_RESET_OWNER(dpc, detachSpd, movePC, animName, syncKey)
    local owner = GetOwner(dpc);
    if owner ~= nil then
        if detachSpd == nil then
            detachSpd = 0;
        end
        if movePC == nil then
            movePC = 0;
        end
        if syncKey == nil then
            syncKey = 0;
        end

        SetOOBEObject(owner, dpc, 0, 0, detachSpd, 1.0, movePC, 0, 0, 0, animName, "None", "None", syncKey, 0);
        SetOwner(dpc, nil);
        UpdateDummyPCList(owner);
    end
end

function CREATE_OOBE(self, skl, x, y, z, detachSpd, easing, addMSPD, atkRate, moveRange, animName, normalAtk, linkTexture, astdClone, isSadhuObb)

    local dpc = GetOOBEObject(self);
    if dpc ~= nil then
        return;
    end

    local sx, sy, sz = GetPos(self);
	
	if GetServerNation() == 'THI' then
		self.Name = ""
	end

    local dpc = CREATE_DUMMYPC(self, sx, sy, sz, GetDirectionByAngle(self), 0, 0, 1);
    if dpc == nil then
        return;
    end

    local name = ScpArgMsg("CorporealityOfS", "Auto_1", self.Name);
	dpc.Name = name;
    SetCurrentFaction(dpc, GetCurrentFaction(self));
    AddInstSkill(self, normalAtk);
    AddInstSkill(dpc, normalAtk);
    ChangeNormalAttack(dpc, normalAtk);
    dpc.MSPD_BM = addMSPD;
    dpc.MATK_BM = dpc.MAXMATK * atkRate;
    InvalidateMSPD(dpc);

    local zoneInsID = GetZoneInstID(self)
--  local oobeRange = 150;
    local oobeRange = 40;
    for i=1, 100 do
        local dist = i * 5;
        if dist > oobeRange then
            break;
        end

        local x2, y2, z2 = GetFrontPos(self, dist);
        local isValidPos = IsValidPos_Obb(zoneInsID, x2, y2 + 20, z2);
        if isValidPos == "YES" then
            x, z = x2, z2;
        else
            break;
        end
    end

    ObjectColorBlend(dpc, 100, 200, 255, 150, 1, 0.01, 1, 1);
    SetOwner(dpc, self, 1);
    UpdateDummyPCList(self);
    SetZombieScript(dpc, "OOBE_RESET_OWNER");
    SetOOBEObject(self, dpc, 0, 1, detachSpd, easing, 0, x, y, z, animName, linkTexture, astdClone, 0, moveRange);
    RunScript("OOBE_SETPOS", dpc, x, y, z, 300);
    RunScript("OOBE_CHECK_EXIST", self, skl.ClassName, moveRange + 20);
    SetTakeDamageScp(self, "OOBE_TAKE_DAMAGE");
    SetExProp_Str(self, "OOBE_SKL_NAME", skl.ClassName);
    SendDummyPCInfo(self, dpc);
    InvalidateMSPD(dpc);
    --BroadcastShape(dpc);

    if nil ~= isSadhuObb and 1 == isSadhuObb then
        SetSafe(dpc, 1);
    end
end

function OOBE_TAKE_DAMAGE(self, from, skl, damage)

    -- 스노우 롤링같은것에 걸릴경우 강제로 해제한다.
    if IsAttachedToObj(self) == 1 then
        OOBE_FORCE_RELEASE(self);
    end

    -- 피해를 입고 죽을것 같은 공격이면 유체상태가 해제된다.
    if self.HP - damage <= 0 then
        local sklName = GetExProp_Str(self, "OOBE_SKL_NAME");
        local oskl = GetSkill(self, sklName);
        ResetStdAnim(self);
        RemoveTakeDamageScp(self, "OOBE_TAKE_DAMAGE");
        RunSkillToolScript(self, oskl, 1);
    end
end


-- 유체상태를 강제로 해제함. (땡기지않음. 땡기면 땡겨지고나서 애니메이션이 이상해지는 문제가 있음)
function OOBE_FORCE_RELEASE(pc)
    RemoveTakeDamageScp(pc, "OOBE_TAKE_DAMAGE");
    local dpc = GetOOBEObject(pc);
    if dpc == nil then
        return;
    end
    OOBE_RESET_OWNER(dpc, 0, 0, 'None', 0);
    SetZombie(dpc);
end

function OOBE_CHECK_EXIST(self, sklName, moveRange)

    while 1 do
        local mon = GET_FOLLOW_BY_NAME(self, "PC");
        if mon == nil then
            break;
        elseif IsZombie(mon) == 1 then
            break;
        else
			-- ���� Ʈ������ ���� ���°Ŵ�, ��ȯ�� �͵� �˾Ƽ� ������ ����.
            if GetLayer(mon) == 0 and GetDist2D(self, mon) > moveRange then
                break;
            end
        end

        sleep(100);
    end

    ResetStdAnim(self);
    RemoveTakeDamageScp(self, "OOBE_TAKE_DAMAGE");
    local skl = GetSkill(self, sklName);
    RunSkillToolScript(self, skl, 1);
end

function OOBE_SETPOS(dpc, x, y, z, time)
    sleep(time);
    SetPosInServer(dpc, x, y, z);
end

function PULL_OOBE(pc, skl, detachSpd, animName, sumEft, sumEftScale)
    
    RemoveTakeDamageScp(pc, "OOBE_TAKE_DAMAGE");
    local dpc = GetOOBEObject(pc);
    if dpc == nil then
        return;
    end

    StopRunScript(pc, "OOBE_CHECK_EXIST");
    local syncKey = GenerateSyncKey(pc);
    StartSyncPacket(pc, syncKey);
    PlayEffect(pc, sumEft, sumEftScale);
    EndSyncPacket(pc, syncKey);
    RunScript("END_OOBE", dpc, detachSpd, animName, syncKey);

end

function _WARP_TO_OOBE(dpc, detachSpd, animName)

    local owner = GetOwner(dpc);
    local moveTime = 0.0;
    if owner ~= nil then
        local dist = GetDist2D(dpc, owner);
        moveTime = dist / detachSpd;
    end
    
    OOBE_RESET_OWNER(dpc, detachSpd, 1, animName);
    
    if moveTime > 0 then
        sleep(moveTime * 1000 + 500);
    end
    
    local Sadhu4_abil = GetAbility(owner, "Sadhu4")
    if Sadhu4_abil ~= nil then
        local addhp = owner.MHP * 0.05 * Sadhu4_abil.Level
        Heal(owner, addhp, 0);
    end

    SetZombie(dpc);

end

function WARP_TO_OOBE(pc, skl, detachSpd, animName)
    
    local dpc = GetOOBEObject(pc);
    if dpc == nil then
        return;
    end
    
    StopRunScript(pc, "OOBE_CHECK_EXIST");
    RunScript("_WARP_TO_OOBE", dpc, detachSpd, animName);
end

function OOBE_COLLISION(pc, skl, range, damRatio, eft, eftScale)
    local dpc = GetOOBEObject(pc);
    if dpc == nil then
        return;
    end

    RemoveTakeDamageScp(pc, "OOBE_TAKE_DAMAGE");
    StopRunScript(pc, "OOBE_CHECK_EXIST");
    local skill = GetSkill(pc, 'Sadhu_AstralBodyExplosion');
    if skill == nil then
        return;
    end
    
    local x, y, z = GetPos(dpc);
    local kdPower = 0;
    
    local abil = GetAbility(pc, "Sadhu3")
    if abil ~= nil then
        kdPower = kdPower + 150
    end

    PlayEffectToGround(pc, eft, x, y, z, eftScale);
    SKL_TAKEDAMAGE_CIRCLE(pc, skill, x, y, z, range, damRatio, kdPower);    
    OOBE_RESET_OWNER(dpc, 0, 0, 'None', 0);
    SetZombie(dpc);
end

function SADHU_START_SPIRIT_SEAL(self, skl)

    StartDrawingSealArea(self, skl, "I_laser005_blue", 500, 10, "F_cleric_OOBE_shot_explosion", 1);

end

function SPIRIT_AREA_HIT(self, skl, eft, eftScale, x, y, z, objList)

    local sklName = skl.ClassName;
    for i = 1 , #objList do
        local tgt = objList[i];
        TakeDamage(self, tgt, sklName, 1.0);
        KD_SELFDIR(self, tgt, 150);
    end

    PlayEffectToGround(self, eft, x, y, z, eftScale);
    BroadcastShockWave(self, 2, 99999, 7, 0.5, 50, 0);

end

function SCR_SADHU_ASTRAL_BODY_EXPLOSION_ADD_DEBUFF(self, target, skill, ret)
    local damage = ret.Damage;
    if damage <= 0 then
        return;
    end
    
    AddBuff(self, target, "AstralBodyExplosion_Debuff", skill.Level, damage, 5000, 1);
end