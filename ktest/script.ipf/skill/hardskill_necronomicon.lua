--- hardskill_necronomicon.lua

function S_R_NECRO_ADD_DEADPARTS(pc, mon, skill, ret)

    local addDPartsResult = NECRO_ADD_DEADPARTS(pc, mon.ClassID);

    if addDPartsResult == 1 then
        local key = 0;
        if ret ~= nil then
            key = GetSkillSyncKey(pc, ret);
            StartSyncPacket(pc, key);
        end
        
            PlayDeadPartsGather(pc, mon);

        if ret ~= nil then
            EndSyncPacket(pc, key);
        end
    end
end

function NECRO_ADD_DEADPARTS(pc, monID, cnt)
    if nil == cnt then
        cnt = 1;
    end
    local totalCount = 300; 
    
    local abil = GetAbility(pc, 'Necromancer21')
    if abil ~= nil then
        totalCount = totalCount + abil.Level * 100
    end

    local etc = GetETCObject(pc);
    if etc == nil then
        return 0;
    end

    local curPartsCnt = 0;
    local monCls = GetClassByType("Monster", monID);
    if monCls == nil then
        return 0;
    end
    
    curPartsCnt = etc.Necro_DeadPartsCnt + cnt

    if curPartsCnt > totalCount then
        return 0;
    end

    etc["NecroDParts_"..curPartsCnt] = monID
    etc.Necro_DeadPartsCnt = etc.Necro_DeadPartsCnt + cnt;
    
    SendProperty(pc, etc);
    SendAddOnMsg(pc, "UPDATE_NECRONOMICON_UI");
    return 1;
end

function SCR_NECRO_DISINTER(pc, skl, range)
    local list, cnt = SelectNecroWaitingZombie(pc, range, 'ALL');
    for i = 1 , cnt do
        local mon = list[i];        
        if 1 == IsZombieWating(mon) then
            local monID = mon.ClassID;
            local addDPartsResult = NECRO_ADD_DEADPARTS(pc, monID);
            if addDPartsResult == 1 then
                
                local abil = GetAbility(pc, 'Necromancer17');
                if abil ~= nil then
                    NECRO_ADD_DEADPARTS(pc, monID);
                end

                PlayDeadPartsGatherZombie(pc, mon);     
                PlaySound(pc, 'skl_eff_disinter_partscapture');     
            end
        end
    end
    
end

function NECRO_DPARTS_HOVER(self, skl, cnt, radius, angleSpd, lifeTime, damRate, damCount, isSendPacket, soundName, padName)
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local ret = DPartsHover(self, skl, cnt, radius, angleSpd, lifeTime, damRate, damCount, isSendPacket, soundName, padName);

    if ret == 1 then
        SendAddOnMsg(self, "UPDATE_NECRONOMICON_UI");
        --F_wizard_dirtywall_shot#Bip01
    end
end

function NECRO_DPARTS_SHOOT_GROUND_ABIL(self, skl, x, y, z, range, waitTime)

    sleep(waitTime * 1000)

    local caster = GetSkillOwner(skl);
    local Necromancer1_abil = GetAbility(caster, 'Necromancer1');
    if Necromancer1_abil ~= nil then
        local list, cnt = SelectObjectPos(self, x,y,z, range, 'ENEMY')
        for i = 1 , cnt do
            if Necromancer1_abil.Level * 1000 > IMCRandom(0,9999) then
                local Necromancer16_abil = GetAbility(caster, 'Necromancer16')
                if Necromancer16_abil == nil then
                    AddBuff(caster, list[i], "DirtyWall_Debuff", Necromancer1_abil.Level, 0, 15000, 1);
                else
                    AddBuff(caster, list[i], "HigherRotten_Debuff", Necromancer1_abil.Level, 0, 15000, 1);
                end
            end
        end
    end

end

function NECRO_DPARTS_SHOOT_GROUND(self, skl, x, y, z, range, waitTime, spd, easing, damRate, damSec, soundName)

    local waitTime, time = DPartsShootGround(self, x, y, z, range, waitTime, spd, easing, damSec, soundName);
    if waitTime == 0 then
        return;
    end
    
    RunScript("NECRO_DPARTS_SHOOT_GROUND_ABIL", self, skl, x, y, z, range, waitTime+time)
    
    local hitCount = damSec * 8;
    OP_DOT_DAMAGE(self, skl.ClassName, x, y, z, waitTime + time, range, damSec * 1000, hitCount, "None", 1, 0);

end

function NECRO_DPARTS_HOVER_TO_MON(self, skl, spd, easing, delay)
    local tgtList = GetHardSkillTargetList(self);   
    if #tgtList == 0 then
        return;
    end

    DPartsAttachHardSkillList(self, spd, easing, delay);
end


function TEST_DPDP(self)

    local etc = GetETCObject(self);

    for i = 1, 50 do
        etc["NecroDParts1_" .. i] = 400001; 
        etc["NecroDParts2_" .. i] = 400063; 
        etc["NecroDParts3_" .. i] = 400342;
    end
    etc.Necro_foresterCnt = 50; 
    etc.Necro_widlingCnt = 50;  
    etc.Necro_paramuneCnt = 50; 
    SendProperty(self, etc);
    SendAddOnMsg(self, "UPDATE_NECRONOMICON_UI");
end

function SKL_CHECK_BOSS_CARD(self, skl)
    if GetObjType(self) ~= OT_PC then
        return 0;
    end

    local etc = GetETCObject(self);
    if etc == nil then
        return 0;
    end

    local bosscardCount = 0;
    for i = 1, 4 do
        local cardGUID = etc["Necro_bosscardGUID" .. i];
        local invItem = nil;
        
        if cardGUID ~= 'None' and cardGUID ~= "" then
            invItem = GetInvItemByGuid(self, cardGUID);
        end

        if invItem ~= nil then
            bosscardCount = bosscardCount + 1;
        end
    end

    if bosscardCount < 1 then
        SendSysMsg(self, "DropCartToSlot"); 
        return 0;
    end

    local mapCls = GetMapProperty(self);
    if mapCls == nil then
        return 0;
    end
    
    if 'City' == mapCls.MapType then
        SendSysMsg(self, "DonCreateMonThisAria");
        return 0;
    end

    return 1;
end

function SKL_CHECK_DPARTS_COUNT(self, skl, count)
    if GetObjType(self) ~= OT_PC then
        return 0;
    end

    if skl.ClassName == "Necromancer_RaiseSkullarcher" or skl.ClassName == "Necromancer_RaiseDead" then
        local mapCls = GetMapProperty(self);
        if mapCls == nil then
            return 0;
        end
    
        if 'City' == mapCls.MapType then
            SendSysMsg(self, "DonCreateMonThisAria");
            return 0;
        end
    end

    local etc = GetETCObject(self);
    if etc == nil then
        return 0;
    end
    
    local haveParts = 0;
    haveParts = etc["Necro_DeadPartsCnt"];

    if haveParts < count then
        SendSysMsg(self, "Auto_SuLyangi_BuJogHapNiDa.");
        return 0;
    end

    return 1;
end

function SCR_SUMMON_DIRTYWALL(mon, self, skl)
    mon.Lv = self.Lv
  mon.HPCount = 30 + skl.Level * 2;
    mon.Faction = 'IceWall'
    mon.StatType = 1
end

function INIT_DIRTYWALL_MONSTER(self)
    EnableIgnoreOBB(self, 1);
    SetHideFromMon(self, 1);
end 

function SCR_DIRTYWALL_HIT(self, from, skill, damage, ret)

    if IS_PC(from) == false then
        ret.Damage = 0
        return;
    end

    if skill.ClassType ~= 'Melee' then
        ret.Damage = 0
        return;
    end

    local ownerHandle = GetExProp(self, 'OWNER_HANDLE')
    local owner = GetByHandle(self, ownerHandle);
    if owner == nil then
        ret.Damage = 0
        return;
    end

    -- 더티폴:파편
    local Necromancer18 = GetAbility(owner, 'Necromancer18')
    if nil == Necromancer18 then
        ret.Damage = 0
        return;
    end

    local x, y = GetDirection(from);
    UseMonsterSkillToDir(self, 'Mon_pcskill_deadparts_Skill_1', x, y);
end

function NECROMANCER_ABIL(self, padName)
    local x, y, z = GetPos(self);
    sleep(2000)
    RunPad(self, padName, nil, x, y, z, 0, 1);
end

function NECRO_SHOGGOTH_MON(self, parent, skl)
    local etc_pc = GetETCObject(parent);
    local cardGuid = etc_pc.Necro_bosscardGUID1;
    local card = GetInvItemByGuid(parent, cardGuid);
    if card == nil then
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
    
    SCR_NECRO_SUMMON_SHOGGOTH_CALC(self, caster, skl, card);
    SetLifeTime(self, 900)
    local abil = GetAbility(caster, "Necromancer3")
    if abil ~= nil then
        RunScript("NECROMANCER_ABIL", self, 'Necromancer_CreateShoggoth_abil');
    end
end


function NECRO_CORPS_MON(self, parent, skl)

    SetExProp(self, "NECRO_SUMMONCORPS", 1)
    local caster = GetOwner(self);  
    if caster == nil then
        Kill(self);
        return;     
    end
    self.Lv = caster.Lv;
--    self.StatType = 4001;
    
    SCR_NECRO_SUMMON_CORPS_CALC(self, caster, skl);
end


------------------


function S_R_COLL_DPARTS(self, tgt, skl, ret)

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    local r = DPartsDetachOne(self);
    
    if r ~= 1 then
        NO_HIT_RESULT(ret);
        HoldMonScp(self);
        RunScript("SUMMON_KILL_SELF", self, 1500);
    end

    EndSyncPacket(self, key);

end



function SCR_SUMMON_SKULL_SOLDIER(self, skl, monName)
    
    local sklLv = skl.Level;

    local maxSkullCount = sklLv
    if maxSkullCount >= 5 then
         maxSkullCount = 5
    end

    local createbleCnt = maxSkullCount;
    
    if GetObjType(self) == OT_PC then
        local list, listCnt = GetSkullSoldierSummonList(self, skl.ClassName);
        if listCnt >= maxSkullCount then
            for i = 1, listCnt do
                local obj = list[i];
                local sklName = GetExProp_Str(obj, "SKLNAME");
                if sklName == skl.ClassName then
                    local objMHP = list[i].MHP;
                    local objHP = list[i].HP;
                    if objHP <= objMHP * 0.2 or GetExProp(mon, 'COPY_SKLLEVEL') == 0 then
                        DeleteSkullSoldierSummon(self, obj)
                        Kill(list[i])
                    else 
                        createbleCnt = createbleCnt - 1;
                    end
                end
            end
        else
            createbleCnt = maxSkullCount - listCnt
        end

        list, listCnt = GetSkullSoldierSummonList(self, skl.ClassName);
        if listCnt == maxSkullCount then -- 지워진게 없으면 리턴.
            return;
        end
    else
        createbleCnt = 1; -- 몬스터는 한마리만인가?
    end
    
    if createbleCnt >= 5 then
        createbleCnt = 5;
    end

    if createbleCnt > sklLv then
        reatebleCnt = sklLv;
    end
    
    for i = 1, createbleCnt do
        local iesObj = CreateGCIES('Monster', monName);
        if iesObj ~= nil then
            iesObj.Lv = self.Lv;
--            iesObj.StatType = 4001
            iesObj.Faction = 'Summon'
            
            local x, y, z = GetFrontRandomPos(self, 30, 30);
            local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
            SetExProp_Str(mon, "SKLNAME", skl.ClassName);
            
            SCR_NECRO_SUMMON_SKULL_CALC(mon, self, skl)
            
            SetBroadcastOwner(mon); -- broadcast owner for excepting targeting
            SetOwner(mon, self, 0)
            SetHookMsgOwner(mon, self)
--            RunSimpleAI(mon, 'follow_mon_sleep');
            SetDeadScript(mon, "SKULL_SOLDIER_DEAD");

            DontUseEventHandler(mon, "handler_eat_heal");
            DontUseEventHandler(mon, "handler_hp_runaway");

            BroadcastRelation(mon);
            if GetObjType(self) == OT_PC then
                AddSkullSoldierSummon(self, mon)
            end
            SetExProp(mon, 'COPY_SKLLEVEL', skl.Level);
            SetLifeTime(mon, 300)
        end
    end
end

function SKULL_SOLDIER_DEAD(mon)
    local owner = GetOwner(mon)
    DeleteSkullSoldierSummon(owner, mon)
end

function START_SHOGGOTH_EXPLOSION(shoggoth, owner, ability, range, eftName, eftScale, lifeTime)
    
    local objList, objCount = SelectObject(shoggoth, range, 'ENEMY');
    for i = 1, objCount do
        local damage = GET_SKL_DAMAGE(owner, objList[i], 'Necromancer_FleshStrike');
        TakeDamage(owner, objList[i], "None", damage)
        local Necromancer16_abil = GetAbility(owner, 'Necromancer16')
        if Necromancer16_abil == nil then
            AddBuff(owner, objList[i], "DirtyWall_Debuff", 1, 0, 5000 * ability.Level, 1);
        else
            AddBuff(owner, objList[i], "HigherRotten_Debuff", 1, 0, 5000 * ability.Level, 1);
        end
    end
    
    HoldMonScp(shoggoth)
    CancelMonsterSkill(shoggoth)
    local x, y, z = GetPos(shoggoth)

    PlayEffectToGround(shoggoth, eftName, x, y, z, eftScale, lifeTime)
    PlayAnim(shoggoth, 'DEAD2');
    Kill(shoggoth)
end

function ENTER_SHOGGOTH_EXPLOSION(self, skl, pad, target)
    
    local owner = nil;
    if target.ClassName == "pcskill_shogogoth" then
        owner = GetOwner(target)
    end
    
    if owner ~= nil and IsSameActor(self, owner) then
        local Necromancer19_abil = GetAbility(owner, 'Necromancer19')
        
        if Necromancer19_abil == nil then
            return;
        end

        RunScript("START_SHOGGOTH_EXPLOSION", target, owner, Necromancer19_abil, 60, "I_wizard_shogogoth_dead_mash", 0.7, 4.0)
    end
end



-- self : Monster
-- caster : PC
-- skil : Skill
-- card : if use Card..
function SCR_NECRO_SUMMON_SKULL_CALC(mon, self, skl)
    local bySkillLevel = 0.1 + (skl.Level * 0.05);
    
    local abilMasterLevel = 0
    local abilLevel = 0;
    if mon.ClassName == "pcskill_skullarcher" then
        abilLevel = GET_ABIL_LEVEL(self, "Necromancer10");
    elseif mon.ClassName == "pcskill_skullsoldier" then
        abilLevel = GET_ABIL_LEVEL(self, "Necromancer7");
    end
    
    if abilLevel == 100 then
    	abilMasterLevel = 0.1
    end
    
    local byAbilLevel = (abilLevel * 0.005) + abilMasterLevel;
    
    local addAbilHP = 0
    local Necromancer20_abil = GetAbility(self, 'Necromancer20')
    if Necromancer20_abil ~= nil then
        addAbilHP = math.floor(mon.MHP * Necromancer20_abil.Level * 0.01)
    end
    
    local addPATK = mon.MINPATK * bySkillLevel;
    local addMATK = mon.MINMATK * bySkillLevel;
    
    mon.PATK_BM = addPATK + (addPATK * byAbilLevel);
    mon.MATK_BM = addMATK + (addMATK * byAbilLevel);
    
    mon.MHP_BM = mon.MHP_BM + addAbilHP;
    
    Invalidate(mon, "MHP");
    AddHP(mon, addHP);
    
    InvalidateStates(mon);
end



function SCR_NECRO_SUMMON_CORPS_CALC(self, caster, skl)
    self.HPCount = 30 + skl.Level * 10;
    
    local bySkillLevel = 0.1 + (skl.Level * 0.04);
    
    local abilMasterLevel = 0
    local byAbilLevel = 0;
    local abil = GetAbility(caster, "Necromancer6")
    if abil ~= nil then
	    if abil.Level == 100 then
	    	abilMasterLevel = 0.1
	    end
		
        byAbilLevel = (abil.Level * 0.005) + abilMasterLevel;
    end
    
    local monPATK = self.MINPATK * bySkillLevel;
    local monMATK = self.MINMATK * bySkillLevel;
    
    self.PATK_BM = monPATK + (monPATK * byAbilLevel);
    self.MATK_BM = monMATK + (monMATK * byAbilLevel);
    
    InvalidateStates(self);
end



-- self : Monster
-- caster : PC
-- skil : Skill
-- card : if use Card..
function SCR_NECRO_SUMMON_SHOGGOTH_CALC(self, caster, skl, card)
    local bySkillLevel = 0.1 + (skl.Level * 0.05);
    local bycardLevel = 0
    if card ~= nil then
        bycardLevel = card.Level * 0.05;
    end
    
    local byAbilLevel = 0;
    local byAbilMasterLevel = 0;
    local Necromancer5_abil = GetAbility(caster, "Necromancer5")
    
    if Necromancer5_abil ~= nil then
        if TryGetProp(Necromancer5_abil,"Level") == 100 then
            byAbilMasterLevel = 0.1;
        end
        
        byAbilLevel = (Necromancer5_abil.Level * 0.005) + byAbilMasterLevel;
    end
    
    local monPATK = self.MINPATK * (bySkillLevel + bycardLevel);
    local monMATK = self.MINMATK * (bySkillLevel + bycardLevel);
    local monDEF = self.DEF * (bySkillLevel + bycardLevel);
    local monMDEF = self.MDEF * (bySkillLevel + bycardLevel);
    
    self.PATK_BM = monPATK * (1 + byAbilLevel);
    self.MATK_BM = monMATK * (1 + byAbilLevel);
    
    self.DEF_BM = monDEF * (1 + byAbilLevel);
    self.MDEF_BM = monMDEF * (1 + byAbilLevel);
    
    DontUseEventHandler(self, "handler_eat_heal");
    DontUseEventHandler(self, "handler_hp_runaway");

    local Necromancer8_abil = GetAbility(caster, "Necromancer8")
    if Necromancer8_abil ~= nil and skl.Level >= 2 then
        if IMCRandom(1, 10000) <  Necromancer8_abil.Level * 100 then
            local scale = 1 + Necromancer8_abil.Level * 0.01;
            self.MHP_BM = self.MHP_BM + math.floor(self.MHP * (Necromancer8_abil.Level * 0.01));
            ChangeScale(self, scale, 0, 1);
        end
    end
    
    InvalidateStates(self);
    
    AddHP(self, self.MHP);
end
