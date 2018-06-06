---- hardskill_druid.lua

function BEFORE_TRANSMON_TRANSFORM(self, skl, buffName, buffTime, eft, eftScale)

    local etc = GetETCObject(self);
    if etc == nil then
        return;
    end

    if etc.Druid_Transform_MonID == 0 then
        return;
    end

    local monCls = GetClassByType('Monster', etc.Druid_Transform_MonID);
    if monCls.MonRank ~= "Normal" then
        SendSysMsg(self, "DruidTransformFailed");
        return;
    end
    
    if monCls == nil then
        return;
    end

    if 1 ~= TransformToMonster(self, monCls.ClassName, buffName) then
        return;
    end

    if GetAbility(self, "Druid13") ~= nil then
        local diffMSPD = 0;
        if monCls.WlkMSPD > self.MSPD then
            diffMSPD = monCls.WlkMSPD - self.MSPD
        end
        SetExProp(self, 'ADD_TRANSFOM_MSPD', diffMSPD);
    end

    AddBuff(self, self, buffName, 1, 1, buffTime);
    PlayEffect(self, eft, eftScale, 0, "MID");
end

function TRANSFORM_BY_MONNAME(self, skl, buffName, buffTime, monName)
    local monCls = GetClass('Monster', monName);
    if monCls == nil then
        return;
    end
    
    if 1 == TransformToMonster(self, monName, buffName) then
        AddBuff(self, self, buffName, 1, 1, buffTime);
    end
end

function TGT_TRANSFORM(self, skl, buffName, buffTime, eft, eftScale)

    local tgt = GetHardSkillFirstTarget(self);
    if tgt == nil then
        return;
    end

    if tgt.RaceType == 'Klaida' or tgt.RaceType == 'Forester' or tgt.RaceType == 'Widling' then
        if IsNormalMonster(tgt) ~= 1 then 
            return;
        end

        if 1 ~= TransformToMonster(self, tgt.ClassName, buffName) then
            return;
        end

        local etc = GetETCObject(self);
        if etc ~= nil then
            etc.Druid_Transform_MonID = tgt.ClassID;
        end
                
        if GetAbility(self, "Druid13") ~= nil then
            local diffMSPD = 0;
            local wikMSPD = TryGetProp(tgt, "WlkMSPD");
            if wikMSPD ~= nil and wikMSPD > self.MSPD then
                diffMSPD = wikMSPD - self.MSPD
            end
            SetExProp(self, 'ADD_TRANSFOM_MSPD', diffMSPD);
        end
    AddBuff(self, self, buffName, 1, 1, buffTime);
    PlayEffect(self, eft, eftScale, 0, "MID");
    PlayEffect(tgt, eft, eftScale, 0, "MID");
    end
end

function SCR_BUFF_ENTER_transform(self, buff, arg1, arg2, over)
    AddLockSkillList(self, 'Druid_Telepath');
    local size = nil
    local racetype = nil
    
    local etc = GetETCObject(self);
    if etc ~= nil then
        local monCls = GetClassByType('Monster', etc.Druid_Transform_MonID);
        if monCls ~= nil then
            size = monCls.Size
            racetype = monCls.RaceType
        end
    end
    
    local adddr = 0;
    local addsmallatk = 0;
    local addmiddleatk = 0;
    local addlargeatk = 0;
    local addmhp = 0;
    local addcrthr = 0;
    local addrhp = 0;
    local addrsp = 0;
    local adddef = 0;
    local addmdef = 0;
    local addMspd = GetExProp(self, 'ADD_TRANSFOM_MSPD');
    DelExProp(self, 'ADD_TRANSFOM_MSPD');
--    local addpatk = 0
--    local addmatk = 0
    
    local isHengeStone = GetExProp(self, 'HENGE_STONE_SATE');
    if isHengeStone > 0 then
--      addpatk = self.MINPATK - self.PATK_BM;
--      addmatk = self.MINMATK - self.MATK_BM;
--        addpatk = 0.05;
--        addmatk = 0.05;
        addcrthr = 100
        SetExProp(buff, "WITH_HENGE_STONE", 1)
        addmhp = 1;
    end
    
    local Druid2_abil = GetAbility(self, "Druid2")
    local Druid3_abil = GetAbility(self, "Druid3")
    local Druid4_abil = GetAbility(self, "Druid4")
    local Druid5_abil = GetAbility(self, "Druid5")
    local Druid6_abil = GetAbility(self, "Druid6")
    local Druid7_abil = GetAbility(self, "Druid7")
    
    if size == 'S' and Druid2_abil ~= nil then
        adddr = math.floor(50 * Druid2_abil.Level)
    elseif size == 'M' and Druid3_abil ~= nil then
        addsmallatk = Druid3_abil.Level * 22;
        addmiddleatk = Druid3_abil.Level * 22;
        addlargeatk = Druid3_abil.Level * 22;
    elseif size == 'L' and Druid4_abil ~= nil then
        addmhp = addmhp + 0.15 * Druid4_abil.Level
    end
    
    if racetype == 'Widling' and Druid5_abil ~= nil then
        addcrthr = math.floor(40 * Druid5_abil.Level)
    elseif racetype == 'Forester' and Druid6_abil ~= nil then
        addrhp = math.floor(self.RHP * 0.1 * Druid6_abil.Level)
        addrsp = math.floor(self.RSP * 0.1 * Druid6_abil.Level)
    elseif racetype == 'Klaida' and Druid7_abil ~= nil then
        adddef = 0.08 * Druid7_abil.Level
        addmdef = 0.08 * Druid7_abil.Level
    end
    
    self.DR_BM = self.DR_BM + adddr;
    self.SmallSize_Atk_BM = self.SmallSize_Atk_BM + addsmallatk;
    self.MiddleSize_Atk_BM = self.MiddleSize_Atk_BM + addmiddleatk;
    self.LargeSize_Atk_BM = self.LargeSize_Atk_BM + addlargeatk;
    self.MHP_RATE_BM = self.MHP_RATE_BM + addmhp;
    self.CRTHR_BM = self.CRTHR_BM + addcrthr;
    self.RHP_BM = self.RHP_BM + addrhp;
    self.RSP_BM = self.RSP_BM + addrsp;
    self.DEF_RATE_BM = self.DEF_RATE_BM + adddef;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + addmdef;
    self.MSPD_BM = self.MSPD_BM + addMspd;
--    self.PATK_RATE_BM = self.PATK_RATE_BM + addpatk;
--    self.MATK_RATE_BM = self.MATK_RATE_BM + addmatk;
    
    SetExProp(buff, "ADD_DR", adddr)
    SetExProp(buff, "ADD_SMALLSIZE", addsmallatk)
    SetExProp(buff, "ADD_MIDDLESIZE", addmiddleatk)
    SetExProp(buff, "ADD_LARGESIZE", addlargeatk)
    SetExProp(buff, "ADD_MHP", addmhp)
    SetExProp(buff, "ADD_CRTHR", addcrthr)
    SetExProp(buff, "ADD_RHP", addrhp)
    SetExProp(buff, "ADD_RSP", addrsp)
    SetExProp(buff, "ADD_DEF", adddef)
    SetExProp(buff, "ADD_MDEF", addmdef)
    SetExProp(buff, 'ADD_TRANSFOM_MSPD', diffMSPD);
--    SetExProp(buff, "ADD_PATK", addpatk)
--    SetExProp(buff, "ADD_MATK", addmatk)
    
end

function SCR_BUFF_LEAVE_transform(self, buff, arg1, arg2, over, isLastEnd)
    ClearLimitationSkillList(self);
    TransformToMonster(self, "None", "None");
    PlayEffect(self, "F_cleric_ShapeShifting_shot_smoke3", 0.5, 0, "MID");
    
    local adddr = GetExProp(buff, "ADD_DR")
    local addsmallatk = GetExProp(buff, "ADD_SMALLSIZE")
    local addmiddleatk = GetExProp(buff, "ADD_MIDDLESIZE")
    local addlargeatk = GetExProp(buff, "ADD_LARGESIZE")
    local addmhp = GetExProp(buff, "ADD_MHP")
    local addcrthr = GetExProp(buff, "ADD_CRTHR")
    local addrhp = GetExProp(buff, "ADD_RHP")
    local addrsp = GetExProp(buff, "ADD_RSP")
    local adddef = GetExProp(buff, "ADD_DEF")
    local addmdef = GetExProp(buff, "ADD_MDEF")
    local addMspd = GetExProp(buff, 'ADD_TRANSFOM_MSPD');
--    local addpatk = GetExProp(buff, "ADD_PATK")
--    local addmatk = GetExProp(buff, "ADD_MATK")
    
    self.DR_BM = self.DR_BM - adddr;
    self.SmallSize_Atk_BM = self.SmallSize_Atk_BM - addsmallatk;
    self.MiddleSize_Atk_BM = self.MiddleSize_Atk_BM - addmiddleatk;
    self.LargeSize_Atk_BM = self.LargeSize_Atk_BM - addlargeatk;
    self.MHP_RATE_BM = self.MHP_RATE_BM - addmhp;
    self.CRTHR_BM = self.CRTHR_BM - addcrthr;
    self.RHP_BM = self.RHP_BM - addrhp;
    self.RSP_BM = self.RSP_BM - addrsp;
    self.DEF_RATE_BM = self.DEF_RATE_BM - adddef;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - addmdef;
    self.MSPD_BM = self.MSPD_BM - addMspd;
--    self.PATK_RATE_BM = self.PATK_RATE_BM - addpatk;
--    self.MATK_RATE_BM = self.MATK_RATE_BM - addmatk;
        
    DelExProp(self, "TRANSFORM_MON_SIZE")
    DelExProp(self, "TRANSFORM_MON_RACETYPE")
end

function SCR_BUFF_ENTER_Lycanthropy_Buff(self, buff, arg1, arg2, over)
    AddLockSkillList(self, 'Druid_Telepath');
    
    local addCrt = 100;
    local addmhp = 0;
    
    local isHengeStone = GetExProp(self, 'HENGE_STONE_SATE');
    if isHengeStone > 0 then
        addCrt = 200;
        addmhp = self.MHP - self.MHP_BM;
        SetExProp(buff, "WITH_HENGE_STONE", 1)
    end
    
    self.CRTHR_BM = self.CRTHR_BM + addCrt;
    self.MHP_BM = self.MHP_BM + addmhp;
    
    SetExProp(buff, "ADD_CRTHR", addCrt);
    SetExProp(buff, "ADD_MHP", addmhp);
end

function SCR_BUFF_UPDATE_Lycanthropy_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local consumeSP = 70;
    
    if self.SP > consumeSP then
        AddSP(self, -consumeSP)
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_Lycanthropy_Buff(self, buff, arg1, arg2, over, isLastEnd)
    ClearLimitationSkillList(self);
    TransformToMonster(self, "None", "None");
    PlayEffect(self, "F_cleric_ShapeShifting_shot_smoke3", 0.5, 0, "MID");
    
    local addCrt = GetExProp(buff, "ADD_CRTHR");
    local addmhp = GetExProp(buff, "ADD_MHP");
    
    self.CRTHR_BM = self.CRTHR_BM - addCrt;
    self.MHP_BM = self.MHP_BM - addmhp;
end

function SCR_BUFF_AFTERCALC_HIT_Lycanthropy_Buff(self, from, skill, atk, ret, buff)
    ret.KDPower = 0;
    ret.ResultType = HITRESULT_BLOW;
    ret.HitType = HIT_ENDURE;
    ret.HitDelay = 0;
end

function SCR_BUFF_RATETABLE_Lycanthropy_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'Lycanthropy_Buff') == 'YES' then
        local addDamageRate = 0.1;
        local isHengeStone = GetExProp(buff, "WITH_HENGE_STONE");
        if isHengeStone > 0 then 
            addDamageRate = 0.3;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end

function SCR_BUFF_RATETABLE_transform(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(from, 'transform') == 'YES' then
        local addDamageRate = 0;
        local isHengeStone = GetExProp(buff, "WITH_HENGE_STONE");
        if isHengeStone > 0 then 
            addDamageRate = 0.2;
        end
        
        rateTable.DamageRate = rateTable.DamageRate + addDamageRate;
    end
end

function SCR_BUFF_ENTER_telepath(self, buff, arg1, arg2, over)
    
    if IsBuffApplied(self, 'Event_Transform_GM') == 'YES' then
        return;
    end
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    ConnectLinkTexture(caster, self, "Druid_Telepath", 1);
    AddBuff(self, caster, "telepath_control", arg1, arg2, 0);
    CancelMonsterSkill(self);
    StopMove(self);

    local diffMSPD = 0;
    if GetAbility(caster, "Druid13") ~= nil then
        if self.WlkMSPD > self.MSPD then
            diffMSPD = self.WlkMSPD - self.MSPD
        end
        self.MSPD_BM = self.MSPD_BM + diffMSPD
        SetExProp(buff, 'ADD_TRANSFOM_MSPD', diffMSPD);
    end

    if IS_PC(self) == false then
        local druidAbil = GetAbility(caster, "Druid12")
        if druidAbil ~= nil then
            local addCount = -1;
            local list, cnt = SelectObjectNear(caster, self, 100, "ENEMY");
            for i = 1, cnt do
                local obj = list[i];
                if IS_PC(obj) == false and IsNormalMonster(obj) == 1 then
                    if 1 == AddTelepathFollow(self, obj) then
                        CancelMonsterSkill(obj);
                        StopMove(obj);
                        addCount = addCount + 1;
                        obj.MSPD_BM = obj.MSPD_BM + diffMSPD
                    end
                end
				
                if addCount >= druidAbil.Level then
                    break;
                end
            end
        end
    end
    
    local originFaction = GetCurrentFaction(self);
    SetExProp_Str(buff, 'ORIGIN_FACTION', originFaction);
    
    SetCurrentFaction(self, 'Monster_Telepath');
	
--    local originOwner = GetOwner(self);
--    if originOwner ~= nil then
--        SetExProp(self, 'TELEPATH_ORIGIN_OWNER_HANDLE', GetHandle(originOwner));
--    end
--    SetOwner(self, caster);
end

function SCR_BUFF_LEAVE_telepath(self, buff, arg1, arg2, over, isLastEnd)
    local caster = GetBuffCaster(buff);
    ConnectLinkTexture(caster, self, "Druid_Telepath", 0);
    RemoveBuffByCaster(caster, self, "telepath_control");
	
	local originFaction = GetExProp_Str(buff, 'ORIGIN_FACTION');
	SetCurrentFaction(self, originFaction);
	
--    local originOwnerHandle = GetExProp(self, 'TELEPATH_ORIGIN_OWNER_HANDLE');
--    local originOwner = GetByHandle(self, originOwnerHandle);
--    SetOwner(self, originOwner);
    
    local addmspd = GetExProp(buff, 'ADD_TRANSFOM_MSPD')
    self.MSPD_BM = self.MSPD_BM - addmspd
	
    if IS_PC(self) == false then
        local list, cnt = SelectObject(self, 200, "FRIEND");
        for i = 1, cnt do
            local obj = list[i];
            if IS_PC(obj) == false and IsBuffApplied(obj, 'telepath_follow') == 'YES' then
                RemoveHate(obj, self)
                obj.MSPD_BM = obj.MSPD_BM - addmspd
            end
        end
        
        ResetHateAndAttack(self);
        ClearTelepathFollow(self);
    end
end

function SCR_BUFF_ENTER_telepath_control(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    ControlObject(self, caster, 2, 0, 0, buff.ClassName, "None");
end

function SCR_BUFF_LEAVE_telepath_control(self, buff, arg1, arg2, over, isLastEnd)
    local caster = GetBuffCaster(buff);
    RemoveBuffByCaster(caster, self, "telepath");
    ControlObject(self, nil, 1, 1, 1, "None", "None");
end


function SCR_BUFF_ENTER_plantguard(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_plantguard(self, buff, arg1, arg2, over, isLastEnd)

end

function TAKE_DAMAGE_PLANTGUARD(self, item, target, damage, skill, ret)

    local angle = GetAngleTo(self, target);
    angle = DegToRad(angle);
    local x, y, z = GetPos(self);
    local dist = 8;
    
    local gx = x + math.cos(angle) * dist;
    local gz = z + math.sin(angle) * dist;
    
    local isGrassCell = IsGrassSurface(self, gx, y, gz);
    if 1 ~= isGrassCell then
        return;
    end

    ret.Damage = 0;
    ret.HitType = HIT_BLOCK;
    ret.ResultType = HITRESULT_BLOCK;

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    GrassPause(self, 0.15);
    EndSyncPacket(self, key);

end