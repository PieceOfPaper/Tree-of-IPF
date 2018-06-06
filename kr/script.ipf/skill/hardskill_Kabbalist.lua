--- hardskill_Kabbalist.lua


function TEST_MAKE_WORD(pc, time)

    local cls = GetClass("Monster", "Bokchoy");
    local engText = TrimString(cls.Name);
    SetExProp_Str(pc, "CAVAL_TEXT", engText);

    ShowUnicodeValueDigit(pc, engText, time);

end

function TEST_CALCULATE_WORD_PART(pc, oper, time, delayTime, indexList)

    local engText = GetExProp_Str(pc, "CAVAL_TEXT");

    local uniCodeList = SplitToUnicodeValue(engText);
    local resultValue = 0;
    if oper == "*" then
        resultValue = 1;
    end

    for i = 1 , #uniCodeList do
        local iValue = uniCodeList[i];
        local existInTable = false;
        for j = 1 , #indexList do
            if i == indexList[j] then
                existInTable = true;
                break;
            end
        end

        if existInTable == true then
            if oper == "+" then
                resultValue = resultValue + iValue;
            else
                resultValue = resultValue * iValue;
            end

            resultValue = math.mod(resultValue, 10);
        end
    end

    local val = math.mod(resultValue, 10);
    SetExProp(pc, "CAVAL_VALUE", val);
    SetExProp(pc, "CAVAL_TIME", imcTime.GetAppTime() + time);
    CalculateUnicodeValueDigit(pc, engText, oper, resultValue, time, delayTime, indexList);

end

function TEST_CALCULATE_WORD(pc, oper, time, delayTime)

    local engText = GetExProp_Str(pc, "CAVAL_TEXT");

    local uniCodeList = SplitToUnicodeValue(engText);
    local resultValue = 0;
    if oper == "*" then
        resultValue = 1;
    end

    for i = 1 , #uniCodeList do
        local iValue = uniCodeList[i];
        if oper == "+" then
            resultValue = resultValue + iValue;
        else
            resultValue = resultValue * iValue;
        end

        resultValue = math.mod(resultValue, 10);
    end

    local val = math.mod(resultValue, 10);
    SetExProp(pc, "CAVAL_VALUE", val);
    SetExProp(pc, "CAVAL_TIME", imcTime.GetAppTime() + time);
    CalculateUnicodeValueDigit(pc, engText, oper, resultValue, time, delayTime);

end

function GET_DIGIT_VALUE(obj)
    local val = GetExProp(obj, "CAVAL_VALUE");
    local endTime = GetExProp(obj, "CAVAL_TIME");
    if endTime == 0 then
        return -1;
    end

    if imcTime.GetAppTime() > endTime then
        return -1;
    end

    SetExProp(obj, "CAVAL_TIME", 0);
    return val;
end

function KABAL_SET_DIGIT(self, skl)

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];

        local name = GET_NAME_TO_DIGITIZE(obj);
        local engText = TrimString(name);
        SetExProp_Str(obj, "CAVAL_TEXT", engText);
        ShowUnicodeValueDigit(obj, engText, 10);
        
    end

end

function GET_NAME_TO_DIGITIZE(obj)
    if IS_PC(obj) == true then
        return obj.Name;
    else
        return obj.SET;
    end

end

function KABAL_SET_DIGIT_AND_CALC_PLUS(self, skl)

    local tgtList = GetHardSkillTargetList(self);
    local delayTime = 2;
    if GetAbility(self, 'Kabbalist13') ~= nil then
        delayTime = 0;
    end
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if GetExProp(obj, 'KABAL_COPIED') == 0 then
            local name = GET_NAME_TO_DIGITIZE(obj);
            local engText = TrimString(name);
            SetExProp_Str(obj, "CAVAL_TEXT", engText);
            ShowUnicodeValueDigit(obj, engText, 10, delayTime);
            PlayEffect(obj, "F_cleric_Gematria_buff", 0.6)
            TEST_CALCULATE_WORD(obj, "+", 100, delayTime);
        end
    end

end

function KABAL_SET_DIGIT_AND_CALC_FIRSTEND(self, skl)

    local tgtList = GetHardSkillTargetList(self);
    local delayTime = 2;
    if GetAbility(self, 'Kabbalist13') ~= nil then
        delayTime = 0;
    end
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        if GetExProp(obj, 'KABAL_COPIED') == 0 then
            local name = GET_NAME_TO_DIGITIZE(obj);
            local engText = TrimString(name);
            SetExProp_Str(obj, "CAVAL_TEXT", engText);
            ShowUnicodeValueDigit(obj, engText, 10, delayTime);
            PlayEffect(obj, "F_cleric_Notarikon_buff", 0.6)
            
            local uniCodeList = SplitToUnicodeValue(engText);
            local stringLen = #uniCodeList;
            local indexList = {};
            indexList[#indexList + 1] = 1;
            indexList[#indexList + 1] = stringLen;
            TEST_CALCULATE_WORD_PART(obj, "+", 100, delayTime, indexList);
        end
    end

end

function KABAL_EXEC_MONSTER_COPY(self, skl)
    local tgtList = GetHardSkillTargetList(self);
    if #tgtList <= 0 then
        return;
    end
    
    local obj = tgtList[1];
    if GetObjType(obj) ~= OT_MONSTERNPC or GetExProp(obj, 'KABAL_COPY') == 1 or GetExProp(obj, 'KABAL_COPIED') == 1 then
        return;
    end

    if obj.MonRank ~= "Normal" and obj.MonRank ~= "Special" then
        return;
    end

    if IsBuffApplied(obj, "SamsaraAfter_Buff") == "YES" then
        return 0;
    end

    local val = GET_DIGIT_VALUE(obj);
    if val == - 1 then
        return;
    end

    PlayEffect(obj, 'F_cleric_Clone_shot', 0.7, 0, 'MID');
    local layer =  GetWorldLayer(self);
    local curTime = imcTime.GetAppTime();
    local lifeTime = val + skl.Level;
    for i = 1, val do
        local x, y, z = GetActorRandomPos(obj, 50);
        local mon1obj = CreateGCIES('Monster', obj.ClassName);
        mon1obj.Lv = obj.Lv;
        local mon = CreateMonster(self, mon1obj, x, y, z, 0, 0, 0, layer);
        mon.EXP = 0;
        mon.JobEXP = 0;
        SetCurrentFaction(mon, GetCurrentFaction(obj));
        SetLifeTime(mon, lifeTime, 1);
        SetExProp(mon, 'KABAL_COPIED', 1);
    end
    
    PlaySound(self, "skl_eff_clone_shot")
    SetExProp(obj, 'KABAL_COPY', 1);
    ShowUnicodeValueDigit(obj, "", 0);
end

function KABAL_EXEC_LEVEL_DOWN(self, skl)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        local val = GET_DIGIT_VALUE(obj);
        local diffLv = val + skl.Level;
        if val ~= -1 then
            if GetObjType(obj) == OT_MONSTERNPC and IsBuffApplied(obj, 'CantLevelDown') == 'NO' then
                if obj.MonRank ~= 'Boss' then
                    PlayEffect(obj, "F_cleric_Reduce_Level_buff", 0.6)
                    ShowUnicodeValueDigit(obj, -255, 0);
                    ShowDigitValue(obj, '-'..diffLv, skl.ClassID);
                    local buff = AddBuff(obj, obj, 'CantLevelDown', diffLv, skl.ClassID, 10000 + skl.Level * 1000)
                    if nil ~= buff then
                        RemoveBuff(obj, 'Kabbalist_Multiple_hits');
                        RemoveBuff(obj, 'Kabbalist_GEVURA');
                    end
                end
            else

            --local beforeLv = obj.Lv;              
            --SetExProp(obj, "LEVEL_FOR_DROP", beforeLv);
            --SetExProp(obj, "LEVEL_FOR_EXP", beforeLv);
            --
            --local newLv = beforeLv - diffLv;
            --obj.Lv = math.max(1, newLv);
            --InvalidateStates(obj);
            --BroadcastLevel(obj);

            end
        end
    end
end

function KABAL_EXEC_MULTIPLY_DAMAGE(self, skl)

    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        local val = GET_DIGIT_VALUE(obj);
        
        val = SCR_CALC_ABIL_Kabbalist19(self, val);
        
        if val > 0 and IsBuffApplied(obj, 'Kabbalist_Multiple_hits') == 'NO' and IsBuffApplied(obj, 'CantLevelDown') == 'NO' and IsBuffApplied(obj, 'Kabbalist_GEVURA') == 'NO' then
            ShowUnicodeValueDigit(obj, -255, 0);
            ShowDigitValue(obj, val, skl.ClassID);
            local buff = AddBuff(self, obj, 'Kabbalist_Multiple_hits', skl.Level, skl.ClassID, 30000, 1);
            if nil ~= buff then
                RemoveBuff(obj, 'CantLevelDown');
                RemoveBuff(obj, 'Kabbalist_GEVURA');
            end
        end
    end

end

function SCR_KABBALLIST_MULTIPLE_HITS_DAMAGE(self, from, skl, damage, ret)
    if ret == nil then
        return;
    end
    
    if damage == 0 then
        return;
    end

    if IsBuffApplied(self, 'Link_Enemy') == 'YES' then -- 조인트 패널티 걸린애ㄴㄴ
        return;
    end

    if IsRunningScript(self, 'SCR_KABBAL_MUTIL_DAMAGE') == 1 then
        return;
    end

    local buff = GetBuffByName(self, 'Kabbalist_Multiple_hits');
    if buff == nil then
        return;
    end
    local arg1, arg2 = GetBuffArg(buff);
    
    arg1 = arg1 * 0.1;
    
    ret.Damage = 0;
    local val = GetExProp(self, "CAVAL_VALUE");
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        val = SCR_CALC_ABIL_Kabbalist19(caster, val);
    end
    
    DelExProp(self, "CAVAL_VALUE");
    
    RunScript('SCR_KABBAL_MUTIL_DAMAGE', self, from, (arg1 * damage), val);

end
function SCR_KABBAL_MUTIL_DAMAGE(self, attacker, damage, val)
    if IsZombie(attacker) == 1 then
        return;
    end
    
    damage = math.floor(damage);
    for i = 1, val do
        sleep(100);
        if IsZombie(attacker) == 1 or IsZombie(self) == 1 or IsDead(self) == 1 then
            return;
        end

        TakeDamage(attacker, self, "None", damage, "None", "None", "TrueDamage");
    end
end

function SCR_BUFF_TAKEDMG_Kabbalist_Multiple_hits(self, buff, sklID, damage, attacker, ret)
    -- 조인트 페널티 버프걸릴때는 일단 못하게 하자
    if IsBuffApplied(self, 'Link_Enemy') == 'YES' then
        return 1;
    end

    if IsRunningScript(self, 'SCR_KABBAL_MUTIL_DAMAGE') == 1 then
        return 0;
    end

    return 0;
end

function SCR_BUFF_ENTER_Kabbalist_Multiple_hits(self, buff, arg1, arg2, over)
    SetTakeDamageScp(self, 'SCR_KABBALLIST_MULTIPLE_HITS_DAMAGE')
end

function SCR_BUFF_LEAVE_Kabbalist_Multiple_hits(self, buff, arg1, arg2, over)
    RemoveTakeDamageScp(self, 'SCR_KABBALLIST_MULTIPLE_HITS_DAMAGE');
    --PlayEffect(self, "F_cleric_Reduce_Level_buff", 0.6)
    ShowUnicodeValueDigit(self, "", 0); 
    ShowDigitValue(self, -255, arg2);
end

function KABBAL_MERKABAH(self, skill)

    RunScript("_KABBAL_MERKABAH", self, skill.ClassName);
end

function SUMMON_KABBAL_CART(pc, cartCnt, sklLv)
    
    if GetObjType(pc) == OT_PC then
        DELETE_CARTS(pc);
    
        if cartCnt == nil or cartCnt == 0 then
            cartCnt = 3;
        end
    else
        cartCnt = 1
    end

    local cartList = {};
    local x, y, z = GetPos(pc);
    local angle = DegToRad(GetDirectionByAngle(pc) + 180);
    local lookAtObj = pc;
    for i = 1 , cartCnt do

        local attachDist = 30 + (i - 1) * 40;
        local nx = x + math.cos(angle) * attachDist;
        local nz = z + math.sin(angle) * attachDist;

        local gol1 = CREATE_MONSTER(pc, "pcskill_merkabah", nx, y, nz, GetDirectionByAngle(pc), GetCurrentFaction(pc), GetLayer(pc), 15);

        DisableBornAni(gol1);
        SetRideNodeList(gol1, "Bone_box_01");
        SetOwner(gol1, pc, 1);
        SetExProp(gol1, "CART", 1);
        lookAtObj = gol1;
        
        local sx, sy, sz = GetPos(gol1)
        local Kabbalist12_abil = GetAbility(pc, 'Kabbalist12')
        RunPad(gol1, "Kabbalist_Merkabah_abil", nil, sx, sy, sz, 1, 1);
        
        cartList[#cartList + 1] = gol1;
        if nil ~= sklLv then
            SetExProp(gol1, 'COPY_SKLLEVEL', sklLv);
        end
    end 

    StopRunScript(pc, "CONSUME_CART_SP");
    RunScript("CONSUME_CART_SP", pc);
    return cartList;

end



function _KABBAL_MERKABAH(self, skillName)
    sleep(1);
    local skill = GetSkill(self, skillName);
    local summonCount = skill.Level;
    local x, y, z = GetGizmoPos(self);
    

    ----------------- modify here ----------------
    local runSpeed = 150;
    local runDelay = 3;
    local splashRange = 100;
    local kdPower = 150;
    
    local Kabbalist11_abil = GetAbility(self, 'Kabbalist11')
    
    if Kabbalist11_abil ~= nil then
        runSpeed = 18;
    end
    -----------------------------------------------
    
    local cartList = SUMMON_KABBAL_CART(self, summonCount, skill.Level);
    local timeList = {};
        
    for i = 1 , #cartList do
        local mon = cartList[i];
        mon.FIXMSPD_BM = runSpeed;
        InvalidateMSPD(mon);
        local dist = GetDistFromPos(mon, x, y, z);
        timeList[i] = dist / runSpeed
    end

    sleep(runDelay * 1000);
    for i = 1 , #cartList do
        local mon = cartList[i];
        MoveEx(mon, x, y, z, 1);
        PlayAnim(mon, 'RUN', 0, 0, 0, 0.5)
        RunScript("KABAL_CART_DESTROY", mon, skillName, x, y, z, splashRange, kdPower, timeList[i]);
    end

end

function KABAL_CART_DESTROY(mon, skillName, x, y, z, splashRange, kdPower, waitTime)
    
    local endTime = imcTime.GetAppTime() + waitTime;
    while 1 do
        sleep(100); 
        local dist = GetDistFromPos(mon, x, y, z);
        if dist < 10 or imcTime.GetAppTime() > endTime then
            break;
        end
    end
        
    ----------------- modify here ----------------
    PlayEffect(mon, 'F_archer_caltrop_hit_explosion');
    -----------------------------------------------

    local riderCount = GetCartRiderCount(mon);
    PlayAnim(mon, 'CART_BOOM')
    UnRIdeAll(mon);
    Dead(mon);

    local owner = GetOwner(mon);
    local skill = GetSkill(owner, skillName);
    SetExProp(skill, "RIDERCOUNT", riderCount);
    SPLASH_DAMAGE(owner, x, y, z, splashRange, skillName, kdPower, false, HIT_KNOCKDOWN);
    RemovePad(mon, "Kabbalist_Merkabah_abil");

end



function SCR_PAD_ENTER_heal(pc, skill, pad)
    if pc ~= nil then
        if pad ~= nil then
            local addHeal = 0;
            local Ayin_sof_buff = GetBuffByName(pc, 'Ayin_sof_Buff');
            if Ayin_sof_buff ~= nil then
                addHeal = GetBuffArgs(Ayin_sof_buff);
            end
            
            SetExProp(pad, 'AYINSOF_HEAL_ADD', addHeal)
            
            return;
        end
    end
end


function SCR_KABAL_CART_ENTER_DMG(cart, skill, pad, target)


    --Enter Function
    local owner = GetOwner(cart);
    if owner == nil then
        return;
    end
    
    local _Merkabah = GetSkill(owner, 'Kabbalist_Merkabah');
    if _Merkabah == nil then
        return;
    end
    
    local cart_enter_cnt = GetExProp(cart, 'MERKABAH_ENTER_CNT');
    if cart_enter_cnt == nil then
        cart_enter_cnt = 0;
    end
    
    local cart_enter_limit = 1;
    if _Merkabah.Level ~= nil then
        cart_enter_limit = _Merkabah.Level * 10;
    end
    
    if cart_enter_cnt >= cart_enter_limit then
        return;
    end
    
    if IS_APPLY_RELATION(owner, target, 'ENEMY') then
        
--        local damage = GET_SKL_DAMAGE(owner, target, _Merkabah.ClassName);
--        TakeDamage(owner, target, _Merkabah.ClassName, damage, "Holy", "Magic", 'Magic', HIT_HOLY, HITRESULT_BLOW);
        local damage = SCR_LIB_ATKCALC_RH(owner, _Merkabah);
        TakeDamage(owner, target, 'None', damage, "Holy", "Magic", 'Magic', HIT_HOLY, HITRESULT_BLOW);
        AddScpObjectList(cart, 'MERKABAH_ENTER_DMG', target)
        
        SetExProp(cart, 'MERKABAH_ENTER_CNT', cart_enter_cnt + 1);
    end


--    --Update Function
--    local owner = GetOwner(cart);
--    if owner == nil then
--        return;
--    end
--    
--    local _Merkabah = GetSkill(owner, 'Kabbalist_Merkabah');
--    if _Merkabah == nil then
--        return;
--    end
--    
--    local cart_enter_cnt = GetExProp(cart, 'MERKABAH_ENTER_CNT');
--    if cart_enter_cnt == nil then
--        cart_enter_cnt = 0;
--    end
--    
--    if cart_enter_cnt >= 20 then
--        return;
--    end
--    
--    local list, cnt = SelectObject(cart, 20, 'ENEMY')
--    if cnt >= 1 then
--        for i = 1, cnt do
--            local target = list[i];
--            local enter_list = GetScpObjectList(cart, 'MERKABAH_ENTER_DMG')
--            
--            if #enter_list >= 1 then
--                for j = 1, #enter_list do
--                    if IsSameActor(target, enter_list[j]) == 'YES' then
--                        return;
--                    end
--                end
--            end
--            
--            local damage = GET_SKL_DAMAGE(owner, target, _Merkabah.ClassName);
--            TakeDamage(owner, target, _Merkabah.ClassName, damage, "Holy", "Magic", 'Magic', HIT_HOLY, HITRESULT_BLOW);
--            AddScpObjectList(cart, 'MERKABAH_ENTER_DMG', target)
--            
--            cart_enter_cnt = cart_enter_cnt + 1;
--            if cart_enter_cnt >= 20 then
--                break;
--            end
--        end
--        SetExProp(cart, 'MERKABAH_ENTER_CNT', cart_enter_cnt);
--    end
    
end

function KABAL_GEVURA(self, skl)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local obj = tgtList[i];
        local val = GET_DIGIT_VALUE(obj);
        
        local abil_Kabbalist20 = GetAbility(self, "Kabbalist20");
        if abil_Kabbalist20 ~= nil and abil_Kabbalist20.ActiveState == 1 then
            if val < 3 then
                val = 3;
            end
        end
        
        SetExProp(obj, "GEVURA_COUNT", val)
        
        if val > 0 and IsBuffApplied(obj, 'Kabbalist_Multiple_hits') == 'NO' and IsBuffApplied(obj, 'CantLevelDown') == 'NO' and IsBuffApplied(obj, 'Kabbalist_GEVURA') == 'NO' then
            ShowUnicodeValueDigit(obj, -255, 0);
            ShowDigitValue(obj, val, skl.ClassID);
            local buffTime = 30000
            local buff = AddBuff(self, obj, 'Kabbalist_GEVURA', skl.Level, skl.ClassID, buffTime, 1);
            if nil ~= buff then
                RemoveBuff(obj, 'CantLevelDown');
                RemoveBuff(obj, 'Kabbalist_Multiple_hits');
            end
        end
    end
end

function SCR_BUFF_TAKEDMG_Kabbalist_GEVURA(self, buff, sklID, damage, attacker, ret)
    if damage <= 0 then
        return 1;
    end
    if buff == nil then
        return 0;
    end
    
    if IsBuffApplied(self, 'Link_Enemy') == 'YES' then -- 議곗씤???⑤꼸??嫄몃┛?졼꽩??--
        return 1;
end
    if IsZombie(self) == 1 or IsZombie(attacker) == 1 or IsDead(self) == 1 then
        return 1;
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    local gevuraCount = GetExProp(self, "GEVURA_COUNT")
    
        gevuraCount = gevuraCount - 1
        SetExProp(self, "GEVURA_COUNT", gevuraCount)
        if gevuraCount <= 0 then
            return 0;
        end
        
        return 1;
    end
    
function SCR_BUFF_ENTER_Kabbalist_GEVURA(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Kabbalist_GEVURA(self, buff, arg1, arg2, over)
    --PlayEffect(self, "F_cleric_Reduce_Level_buff", 0.6)
    ShowUnicodeValueDigit(self, "", 0);
    ShowDigitValue(self, -255, arg2);
    
    DelExProp(self, "GEVURA_COUNT");
end

function SCR_BUFF_RATETABLE_Kabbalist_GEVURA(self, from, skill, atk, ret, rateTable, buff)
    local caster = GetBuffCaster(buff)
    local skl = GetSkill(caster, "Kabbalist_Gevura")
    
    if skl ~= nil and caster ~= nil and IsBuffApplied(self, "Kabbalist_GEVURA") == "YES" then
        local damageRate = TryGetProp(skl, "Level") * 0.2
        rateTable.DamageRate = rateTable.DamageRate + damageRate
    end
end



function SCR_CALC_ABIL_Kabbalist19(self, val)
    local abil_Kabbalist19 = GetAbility(self, "Kabbalist19");
    if abil_Kabbalist19 ~= nil and abil_Kabbalist19.ActiveState == 1 then
        if val < 3 then
            val = 3;
        end
    end
    
    return val;
end
