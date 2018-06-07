--- hardskill_bokor.lua

function BOKOR_MAKE_CAPSULE(self, skl)

    local zombieList, listCnt = GetZombieSummonList(self);
    if listCnt == 0 then
        return;
    end

    local stringList = {};
    local propString = "";
    local cnt = 0;
    local capsulizeCount = 0;
    for i = 1 , listCnt do
        local mon = zombieList[i];
        local capsulize = GetExProp(mon, "CAPSULIZE");
        if capsulize == 0 then
          capsulizeCount = capsulizeCount + 1;
            SetExProp(mon, "CAPSULIZE", 1);
            local monsterProp = string.format( "%d#%d#%d#%d", GetExProp(mon, 'ZOMBIE_TARGET_MONID'), mon.Lv, GET_SUMMON_ZOMBIE_TYPE(mon.ClassName), math.floor(GET_HP_PERCENT(mon)) );
            if propString ~= "" then
                propString = propString .. "@";
            end
        
            propString = propString  .. monsterProp;
            cnt = cnt + 1;
            if cnt >= 5 then
                stringList[#stringList + 1] = propString;
                cnt = 0;
                propString = "";
            end
        end
    end

    if propString ~= "" then
        stringList[#stringList + 1] = propString;
    end
    
    if capsulizeCount > 0 then
    local tx = TxBegin(self);
    local cmdIdx = TxGiveItem(tx, "Zombie_Capsule", 1, "ZombieCalsule");    

    for i = 1 , #stringList do
        local propString = stringList[i];
        TxAppendProperty(tx, cmdIdx, GET_KEYWORD_PROP_NAME(i), propString);
    end
    
    local ret = TxCommit(tx);
    
    if ret == "SUCCESS" then
        for i = 1 , listCnt do
            local mon = zombieList[i];
            Dead(mon);
        end
    end
  end
end

function SCR_SUMMON_ZOMBIE(self, caster, x, y, z)
    sleep(1000);
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(caster, GetExProp(self, "SkillLv"));
    
    local zombieList, listCnt = GetZombieSummonList(caster);
    if listCnt >= maxZombieCount then
    local lowHpZombie = nil;
    local hp = zombieList[1].HP;
    for i = 1, listCnt do
        if zombieList[i].HP <= hp then
            lowHpZombie = zombieList[i];
        end
    end
    Kill(lowHpZombie)
    end
    
--  Bokor21 Bokor22 --
    local skill = GetSkill(caster, "Bokor_Zombify")
    if skill == nil then
        return
    end
    
    local zombieType = 1;
    if self.Size == "L" then
        local bokor21_abil = GetAbility(caster, 'Bokor21');
        if bokor21_abil ~= nil and skill.Level >= 2 then
            if IMCRandom(1, 100) <= bokor21_abil.Level then
                zombieType = 2;
            end
        end
    else
        local bokor22_abil = GetAbility(caster, 'Bokor22');
        if bokor22_abil ~= nil and skill.Level >= 3 then
            if IMCRandom(1, 100) <= bokor22_abil.Level then
                zombieType = 3;
            end
        end
    end
    
    local zombieClassName = GET_SUMMON_ZOMBIE_NAME(zombieType)
    local MonList, cnt = GetClassList("Monster");
    local iesObj = CreateGCIES('Monster', zombieClassName); 
    
    if iesObj ~= nil then
        iesObj.Lv = self.Lv
        local x, y, z = GetExProp_Pos(self, "ZOMBIE_VEC3")
        
        local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
        
        SetBroadcastOwner(iesObj); -- broadcast owner for excepting targeting --
        SetOwner(iesObj, caster, 0)
        SetHookMsgOwner(iesObj, caster)
        iesObj.Faction = 'Summon'
        
        -- CalcUserControlMonsterStat(mon, caster, self.STR, self.CON, self.INT, self.MNA, self.DEX) --
        
        SCR_BOKOR_SUMMON_STATE_CALC(self, caster, mon, zombieType);
        
        SetExProp(mon, 'ZOMBIE_TARGET_MONID', self.ClassID);
        AddZombieSummon(caster, mon, self.ClassID, zombieType);
        
        DontUseEventHandler(mon, "handler_eat_heal");
        DontUseEventHandler(mon, "handler_hp_runaway");
        
        BroadcastRelation(iesObj);
    end
end

function GET_MAX_ZOMBIE_COUNT(self, sklLevel)

    local maxZombieCount = 8
--  local bookor8_abil = GetAbility(self, 'Bokor8');
--  if bookor8_abil ~= nil then
--      maxZombieCount = maxZombieCount + bookor8_abil.Level;
--  end

    if maxZombieCount > BOKOR_MAX_ZOMBIE_COUNT then
        maxZombieCount = BOKOR_MAX_ZOMBIE_COUNT;
    end

    return maxZombieCount;

end

function SCR_HEXING_SUMMON_ZOMBIE(self, caster)
    local x, y, z = GetPos(self)
    
    local skl = GetSkill(caster, "Bokor_Zombify");
    if skl == nil then
        return;
    end
    
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(caster, skl.Level);
    
    local zombieList, listCnt = GetZombieSummonList(caster);
    if listCnt >= maxZombieCount then
    local lowHpZombie = nil;
    local hp = zombieList[1].HP;
        for i = 1, listCnt do
            if zombieList[i].HP <= hp then
                lowHpZombie = zombieList[i];
            end
        end
        Kill(lowHpZombie)
    end
    
    local zombieType = 1;
    if self.Size == "L" then
        local bokor21_abil = GetAbility(caster, 'Bokor21');
        if bokor21_abil ~= nil then
            --????? ?????o?.
            if IMCRandom(1, 100) <= bokor21_abil.Level then
                zombieType = 2;
            end
        end 
    else
        local bokor22_abil = GetAbility(caster, 'Bokor22');
        if bokor22_abil ~= nil then
        --????? ?????o?.
            if IMCRandom(1, 100) <= bokor22_abil.Level then
                zombieType = 3;
            end
        end
    end
    
    local zombieClassName = GET_SUMMON_ZOMBIE_NAME(zombieType);
    
    local MonList, cnt = GetClassList("Monster");
    local iesObj = CreateGCIES('Monster', zombieClassName);
    iesObj.Lv = self.Lv
    
    if iesObj ~= nil then
        --local x, y, z = GetExProp_Pos(self, "ZOMBIE_VEC3")
        
        local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
        SetOwner(iesObj, caster, 0)
        SetHookMsgOwner(iesObj, caster)
        iesObj.Faction = 'Summon'
        --RunSimpleAI(iesObj, 'alche_summon');
        
        --CalcUserControlMonsterStat(mon, caster, self.STR, self.CON, self.INT, self.MNA, self.DEX)
        
        SCR_BOKOR_SUMMON_STATE_CALC(self, caster, mon, zombieType)
        
        SetExProp(mon, 'ZOMBIE_TARGET_MONID', self.ClassID);
        AddZombieSummon(caster, iesObj, self.ClassID, zombieType);
        
        BroadcastRelation(iesObj);
    end
end

function SCR_SUMMON_ZOMBIE_BY_INFO(self, monID, zombieType, lv) --캡슐은 여기
    local zombieClassName = GET_SUMMON_ZOMBIE_NAME(zombieType);
    
    local iesObj = CreateGCIES('Monster', zombieClassName);
    iesObj.Lv = lv;
    
    local x, y, z = GetPos(self);
    local rx, ry, rz = GetRandomPosInRange(self, x, y, z, 15, 30);
    if rx == nil then
        rx = x;
        ry = y;
        rz = z;
    end
    
    local mon = CreateMonster(self, iesObj, rx, ry+20, rz, 0, 0);
    SetBroadcastOwner(mon);
    SetOwner(iesObj, self, 0)
    SetHookMsgOwner(iesObj, self)
    iesObj.Faction = 'Summon'
    --RunSimpleAI(iesObj, 'alche_summon');
    
    local obj = CreateGCIESByID('Monster', monID)
    
    SCR_BOKOR_SUMMON_STATE_CALC(obj, self, mon, zombieType);
    
    SetExProp(mon, 'ZOMBIE_TARGET_MONID', obj.ClassID);
    AddZombieSummon(self , mon, obj.ClassID, zombieType);
    BroadcastRelation(iesObj);
    DestroyIES(obj);
    
    return mon;
end

function SCR_SUMMON_ZOMBIE_BY_ETC(self)

    --{º?½º?¸| º????§? ??

    --아가리오 던전 예외처리
    if GetZoneName(self) == "d_castle_agario" then
        return;
    end

    local list, cnt = GetZombieSummonList(self)
    
    local etcObj = GetETCObject(self);
    if etcObj == nil then
        return;
    end

    local skl = GetSkill(self, "Bokor_Zombify");
    if skl == nil then
        return;
    end

    local createCount = cnt;
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(self, skl.Level);

    for i = 1, BOKOR_MAX_ZOMBIE_COUNT do
    if maxZombieCount < createCount then
        return;
    end
        local monID = etcObj['ZombiebyMonID_'..i];      
        if monID ~= 0 then
            local zombieType = etcObj['ZombiebyMonType_'..i]
            
            if maxZombieCount > createCount  then
                
                local lv = etcObj['ZombiebyMonLv_'..i];
                
                etcObj['ZombiebyMonID_'..i] = 0;
                etcObj['ZombiebyMonLv_'..i] = 0;
                etcObj['ZombiebyMonType_'..i] = 0;

                SCR_SUMMON_ZOMBIE_BY_INFO(self, monID, zombieType, lv)
                
                createCount = createCount + 1;
            end
        end
    end
end

function SCR_MOVE_ZONE_SUMMON_ZOMBIE(self)
    sleep(1000);
    SCR_SUMMON_ZOMBIE_BY_ETC(self);
    SORT_SUMMON_ZOMBIE_ETCPROP(self);
end

function SORT_SUMMON_ZOMBIE_ETCPROP(self)

    local etcObj = GetETCObject(self);
    if etcObj == nil then
        return;
    end

    local maxZombieCount = BOKOR_MAX_ZOMBIE_COUNT;
    for i= 1, maxZombieCount do
        etcObj['ZombiebyMonID_'..i] = 0
        etcObj['ZombiebyMonLv_'..i] = 0
        etcObj['ZombiebyMonType_'..i] = 0
    end

    local zombieList, listCnt = GetZombieSummonList(self);
    for i = 1, listCnt do
        local mon = zombieList[i];
        etcObj['ZombiebyMonID_'..i] = GetExProp(mon, 'ZOMBIE_TARGET_MONID');
        etcObj['ZombiebyMonLv_'..i] = mon.Lv;
        etcObj['ZombiebyMonType_'..i] = GET_SUMMON_ZOMBIE_TYPE(mon.ClassName);      
    end
end

function SCR_SUMMON_ZOMBIE_CAPSULE_SAVE(self)
        
    
    local zombieList, listCnt = GetZombieSummonList(self);
    for i = 1, listCnt do
        local mon = zombieList[i];
        Kill(mon);
    end
end

function SCR_USE_ZOMBIECAPSULE(self, argObj, argstring, argnum1, argnum2, itemClassID, itemObj)
    
    if itemObj.ClassName ~= 'Zombie_Capsule' then
        return;
    end

    local skl = GetSkill(self, "Bokor_Zombify");
    if skl == nil then
        return;
    end
    
    local list, cnt = GetZombieSummonList(self)
    local createCount = cnt;
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(self, skl.Level);
    if cnt >= maxZombieCount then
        return;
    end
    
    local tx = TxBegin(self);
    local zombie = SCR_SUMMON_ZOMBIE_BY_INFO(self, 400001, 1, self.Lv);
    if zombie == nil then
        _TxRollBack(tx)
        return;
    end
    local ret = TxCommit(tx);
end


-- self : Dead Monster
-- caster : PC
-- mon : Zombie
function SCR_BOKOR_SUMMON_STATE_CALC(self, caster, mon, zombieType)
    mon.STR = self.STR - self.STR_BM;
    mon.CON = self.CON - self.CON_BM;
    mon.INT = self.INT - self.INT_BM;
    mon.MNA = self.MNA - self.MNA_BM;
    mon.DEX = self.DEX - self.DEX_BM;
    
--    self.StatType = 4002;
    
    local casterMNA = TryGetProp(caster, "MNA");
    if casterMNA == nil then
        casterMNA = 1;
    end
    
    local casterINT = TryGetProp(caster, "INT");
    if casterINT == nil then
        casterINT = 1;
    end
    
    local casterStat = casterMNA + casterINT;
    
    mon.DEF_RATE_BM = mon.DEF_RATE_BM + 0.3;
    local addCON = casterStat;
    if zombieType == 2 then
        addCON = (mon.CON + addCON) * 2;
    elseif zombieType == 3 then
        mon.DEX_BM = mon.DEX_BM + (mon.DEX * 2);
    end
    
    mon.CON_BM = mon.CON_BM + addCON;
    mon.STR_BM = mon.STR_BM + math.floor(casterStat / 2);
    
    local atkRange = TryGetProp(self, 'ATK_RANGE');
    if atkRange == nil then
        atkRange = 120;
    end
    
    mon.ATK_RANGE = atkRange;
    AddBuff(caster, mon, 'Cleric_Zombie_Debuff', 0, 0, 0, 1);
    
    InvalidateStates(mon);
    
    AddHP(mon, mon.MHP);
    
--    SetLifeTime(mon, 60)
end