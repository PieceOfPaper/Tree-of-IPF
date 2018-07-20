-- calc_battle_lib.lua

HIT_BASIC = 0;
HIT_MOTION = 1;
HIT_NOMOTION = 2;
HIT_KNOCKBACK = 3;
HIT_KNOCKDOWN = 4;

HIT_GUARD = 5;
HIT_FORCE = 6;
HIT_HEAL = 7;
HIT_HEALNOEFT = 8;
HIT_SHIELD = 9;
HIT_SAFETY = 10;
HIT_TELEK = 11;
HIT_POISON = 12;
HIT_STABDOLL = 13;
HIT_BLOCK = 14;
HIT_DODGE = 15;
HIT_ICE = 16;
HIT_COUNTDOWN = 19;
HIT_FIRE = 21;
HIT_JANGPANHIT = 22;
HIT_JANGPANHIT_BLESS = 23;
HIT_JANGPANHIT_CURE = 24;
HIT_JANGPANHIT_HEAL = 25;
HIT_POISON_GREEN = 26;
HIT_REFLECT = 27;
HIT_NOEFFECT = 28;
HIT_ENDURE = 29;
HIT_POISON_VIOLET = 30;
HIT_LIGHTNING = 31;
HIT_PLANTGUARD = 32;
HIT_HOLY = 33;
HIT_DARK = 34;
HIT_BLEEDING = 35;
HIT_CONCENTRATE = 36;
HIT_EARTH = 37;
HIT_RETREAT = 38;
HIT_SOUL = 39;
HIT_BASIC_NOT_CANCEL_CAST = 40;
HIT_NOHIT = 100;
HIT_MAGIC= 1001;
HIT_MELEE= 1002;
HIT_WUGU_BLOOD = 1003;
HIT_WUGU_POISON = 1004;
HIT_TWINKLESTAR = 2001;


HITRESULT_NONE = 0
HITRESULT_DODGE = 1;
HITRESULT_BLOCK = 2;
HITRESULT_BLOW = 3;
HITRESULT_CRITICAL = 4;
HITRESULT_DODGE_REDUCE = 5;
HITRESULT_MISS = 6;
HITRESULT_INVALID = 7;
HITRESULT_NO_HITSCP = 8;
HITRESULT_NO_HITSCP_CRI = 9;

HITEFT_NO = 0;
HITEFT_BAD = 1;
HITEFT_NORMAL = 2;
HITEFT_NICE = 3;
HITEFT_EXCEL = 4;
HITEFT_COUNTER = 5;
HITEFT_SAFETY = 6;

DEFAULT_SKILL_CLASSID = 100;


function GET_HIT_TYPE_NUMBER(hitTypeString)
    
    if hitTypeString == "Dark" then
        return HIT_DARK;
    elseif hitTypeString == "Poison" then
        return HIT_POISON;
    elseif hitTypeString == "Fire" then
        return HIT_FIRE;
    elseif hitTypeString == "Ice" then
        return HIT_ICE;
    elseif hitTypeString == "Lightning" then
        return HIT_LIGHTNING;
    elseif hitTypeString == "Holy" then
        return HIT_HOLY;
    elseif hitTypeString == "Earth" then
        return HIT_EARTH;
    elseif hitTypeString == "Soul" then
        return HIT_SOUL;
    else
        return HIT_BASIC;
    end
end



function SET_RATE_TABLE()
    local rateTable = {};   
    rateTable.AttributeRate = 0.0;  -- skill_attribute.xml
    rateTable.AttackTypeRate = 0.0; -- skill_attribute.xml
    
    rateTable.AddAtkDamage = 0.0;
    rateTable.DamageRate = 0.0;
    rateTable.DamageReductionRate = { };    -- 피해 감소, AddDamageReductionRate(rateTable, value)로 사용
    rateTable.MultipleHitDamageRate = 0.0;
    rateTable.addDamageRate = 0.0;  -- DamageRate를 바꾸는 것이 아니라, True대미지나, 속성 대미지와 같은 고정 대미지를 줄이는 기능 --
    rateTable.AddTrueDamage = 0.0;
    rateTable.AddAttributeDamageFire = 0;
    rateTable.AddAttributeDamageIce = 0;
    rateTable.AddAttributeDamageLightning = 0;
    rateTable.AddAttributeDamageEarth = 0;
    rateTable.AddAttributeDamagePoison = 0;
    rateTable.AddAttributeDamageDark = 0;
    rateTable.AddAttributeDamageHoly = 0;
    rateTable.AddAttributeDamageSoul = 0;
    
    rateTable.AddDefence = 0.0;
    
    rateTable.IgnoreDamage = 0.0;   -- HITRESULT_MISS
    rateTable.NoneDamage = 0.0;     -- ret.Damage = 0
    rateTable.NotCalculated = 0.0;
    rateTable.AddJobAtkRate = 1.0;  -- job.xml
    rateTable.JobDefRate = 1.0; -- job.xml
    
    rateTable.ChargingRate = 1.0;
    
    rateTable.BoosterAtk = 0.0;
    
    --miss
    rateTable.missRating = 0;
    rateTable.missResult = 0;
    
    -- dodge
    rateTable.EnableDodge = 1;
    rateTable.FixedDodgeRate = 0;
    rateTable.dodgeDefRatio = 0;
    rateTable.DodgeRate = 1.0;
    rateTable.EnableMagicDodge = 0;
    rateTable.MagicDodgeRate = 1.0;
    
    -- blk
    rateTable.EnableBlock = 1;
    rateTable.blkResult = 0;
    rateTable.blkAdd = 0;
    rateTable.BlockRate = 1.0;
    rateTable.abilityBuffShield = 0;
    rateTable.EnableMagicBlock = 0;
    rateTable.MagicBlockRate = 1.0;
    
    -- cri
    rateTable.EnableCritical = 1;
    rateTable.crtRatingAdd = 0;
    rateTable.AddCrtHR = 0;
    rateTable.AddCrtAtk = 0;
    rateTable.AddCrtAtkRate = 0.0;
    rateTable.AddCrtDamageRate = 0.0;
    
    -- Ignore Defenses
    rateTable.AddIgnoreDefenses = 0;
    rateTable.AddIgnoreDefensesRate = 0.0;
    
    -- Skill Factor
    rateTable.AddSkillFator = 0;
    
    return rateTable;
end


function RESET_RATE_TABLE(rateTable)
    rateTable.AttributeRate = 0.0;
    rateTable.AttackTypeRate = 0.0;
    
    rateTable.AddAtkDamage = 0.0;
    rateTable.DamageRate = 0.0;
    rateTable.DamageReductionRate = { };    -- 피해 감소, AddDamageReductionRate(rateTable, value)로 사용
    rateTable.MultipleHitDamageRate = 0.0;
    rateTable.addDamageRate = 0.0;  -- DamageRate를 바꾸는 것이 아니라, True대미지나, 속성 대미지와 같은 고정 대미지를 줄이는 기능 --
    rateTable.AddTrueDamage = 0.0;
    rateTable.AddAttributeDamageFire = 0;
    rateTable.AddAttributeDamageIce = 0;
    rateTable.AddAttributeDamageLightning = 0;
    rateTable.AddAttributeDamageEarth = 0;
    rateTable.AddAttributeDamagePoison = 0;
    rateTable.AddAttributeDamageDark = 0;
    rateTable.AddAttributeDamageHoly = 0;
    rateTable.AddAttributeDamageSoul = 0;
    
    rateTable.AddDefence = 0.0;
    
    rateTable.IgnoreDamage = 0.0;
    rateTable.NoneDamage = 0.0;
    rateTable.NotCalculated = 0.0;
    rateTable.AddJobAtkRate = 1.0;
    rateTable.JobDefRate = 1.0;
    rateTable.ChargingRate = 1.0;
    
    rateTable.BoosterAtk = 0.0;
    
    --miss
    rateTable.missRating = 0;
    rateTable.missResult = 0;
    
    -- dodge
    rateTable.EnableDodge = 1;
    rateTable.FixedDodgeRate = 0;
    rateTable.dodgeDefRatio = 0;
    rateTable.DodgeRate = 1.0;
    rateTable.EnableMagicDodge = 0;
    rateTable.MagicDodgeRate = 1.0;
    
    -- blk
    rateTable.EnableBlock = 1;
    rateTable.blkResult = 0;
    rateTable.blkAdd = 0;
    rateTable.BlockRate = 1.0;
    rateTable.abilityBuffShield = 0;
    rateTable.EnableMagicBlock = 0;
    rateTable.MagicBlockRate = 1.0;
    
    -- cri
    rateTable.EnableCritical = 1;
    rateTable.crtRatingAdd = 0;
    rateTable.AddCrtHR = 0;
    rateTable.AddCrtAtk = 0;
    rateTable.AddCrtAtkRate = 0.0;
    rateTable.AddCrtDamageRate = 0.0;
    
    -- Ignore Defenses
    rateTable.AddIgnoreDefenses = 0;
    rateTable.AddIgnoreDefensesRate = 0.0;
    
    -- Skill Factor
    rateTable.AddSkillFator = 0;
end

function AddDamageReductionRate(rateTable, value)
    if rateTable == nil then
        return;
    end
    
    table.insert(rateTable.DamageReductionRate, value);
end

function IS_PC(actor)
    if IsDummyPC(actor) ~= 1 then
        return GetObjType(actor) == OT_PC;
    else
        return 0;
    end
end
 
function IS_KD(hitType)
    
    return hitType >= HIT_KNOCKBACK and hitType <= HIT_KNOCKDOWN;
end

function PLAY_ABILITY_EFFECT(pc, ret, effectName, effectScale, delaySec)

    local key = GetSkillSyncKey(pc, ret);
    StartSyncPacket(pc, key);
    PlayEffect(pc, effectName, effectScale, 1, 'TOP');
    EndSyncPacket(pc, key, delaySec);
end

function SCR_LIB_GET_DICE(dices, sides, bonus)
    local total = 0;
    for i = 1, dices do
        total = total + IMCRandom(1, sides);
    end
    total = total + bonus;
    return total;
end

function ADDBUFF(from, target, name, arg1, arg2, time, over, rate, sklID, fromWho)
    if name == 'Impaler_Debuff' and IsBuffApplied(target, 'Impaler_Buff') == 'YES' then
        return nil;
    end
    
    if IsBuffApplied(target, 'Skill_NoDamage_Buff') == 'YES' then
        local buffClass = GetClass('Buff', name);
        if buffClass ~= nil then
            local buffGroup1 = TryGetProp(buffClass, 'Group1');
            local buffLv = TryGetProp(buffClass, 'Lv');
            
            if buffGroup1 == 'Debuff' and buffLv < 99 then
                return nil;
            end
        end
    end
    
    -- 버프상점은 BUFF_FROM_AUTO_SELLER 으로 데이터를 넘깁니다.
    if fromWho == nil then
        if IsSameActor(from, target) == "YES" then
            fromWho = BUFF_FROM_SELF;
        else
            fromWho = BUFF_FROM_OTHER;
        end
    end
    
    local buff = nil;
    
    if rate == nil then
        buff = AddBuff(from, target, name, arg1 , arg2, time, over, sklID, fromWho);
    elseif rate >= IMCRandom(1, 100) then
        buff = AddBuff(from, target, name, arg1 , arg2, time, over, sklID, fromWho);
    end
    
    return buff;
end


function ADDPADBUFF(from, target, pad, name, arg1, arg2, time, over, rate, fromWho)
    if IsBuffApplied(target, 'Skill_NoDamage_Buff') == 'YES' then
        local buffClass = GetClass('Buff', name);
        if buffClass ~= nil then
            local buffGroup1 = TryGetProp(buffClass, 'Group1');
            local buffLv = TryGetProp(buffClass, 'Lv');
            
            if buffGroup1 == 'Debuff' and buffLv < 99 then
                return nil;
            end
        end
    end
    
-- 버프상점은 BUFF_FROM_AUTO_SELLER 으로 데이터를 넘깁니다.    
    if fromWho == nil then
        if IsSameActor(from, target) == "YES" then
            fromWho = BUFF_FROM_SELF;
        else
            fromWho = BUFF_FROM_OTHER;
        end
    end
    local buff = nil;        
    if rate == nil then
        buff = AddPadBuff(from, target, pad, name, arg1 , arg2, time, over, fromWho);
    elseif rate >= IMCRandom(1, 100) then        
        buff = AddPadBuff(from, target, pad, name, arg1 , arg2, time, over, fromWho);        
    end

    -- 졸리로저 깃발이 콤보 관리하기 위해 깃발의 핸들을 버프가 arg3에 저장할 거임
    local padMonHandle = GetPadUserValue(pad, 'PAD_MON_HANDLE');
    if padMonHandle > 0 and buff ~= nil then
        SetBuffArgs(buff, padMonHandle, 0, 0);
    end
        
    return buff;
end


function GET_SPLASH_DAM_RATE(hitCount, chainHitCount)

    local rate = math.pow( 4/5, hitCount ); 
    
    if chainHitCount > 0 then
        rate = rate * math.pow( 3/4, chainHitCount );   
    end

    if rate < 0.3 then
        rate = 0.3;
    end

    return rate;

end

function SCR_LIB_CHECK_CRT(self, from, skill, ret, rateTable)
    if rateTable.EnableCritical == 0 then
        return 0;
    end
    
    if skill.ClassType == 'Magic' or skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
        return 0;
    end
    
    local isHPCount = TryGetProp(self, "HPCount");
    if isHPCount ~= nil and isHPCount > 0 then
        return 0;
    end

    local addCrtRating = GetExProp(from, "ABIL_CRTHR_ADD");
    
    local crt_rating = (from.CRTHR + rateTable.AddCrtHR) - self.CRTDR;
--    local crt_rating = from.CRTHR - self.CRTDR;
    if crt_rating < 0 then
        crt_rating = 0;
    end
    
    crt_rating = (crt_rating ^ 0.6) * 100;
    
--  crt_rating = crt_rating * 10000;
    
    if from.ClassName == "PC" then
        if from.CRTHR_FIXED > 0 then
            crt_rating = from.CRTHR_FIXED;
        end
    end
    
    if addCrtRating > 0 then
        crt_rating = crt_rating + addCrtRating * 100
    end
    
    crt_rating = crt_rating + rateTable.crtRatingAdd;
    
    if crt_rating < 0 then
        crt_rating = 0 ;
    end
    
    local isCritical = 0;
    if GetExProp(from, "IS_CRITICAL") == 1 or GetExProp(self, "IS_TAKE_CRITICAL") == 1 then
        DelExProp(from, "IS_CRITICAL"); -- 공격자 기준 강제로 크리티컬 공격 --
        DelExProp(self, "IS_TAKE_CRITICAL");    -- 방어자 기준 강제로 크리티컬 피격 --
        isCritical = 1;
    end
    
    if crt_rating > 0 or isCritical == 1 then
        local random = IMCRandom(0, 9999);
        if random < crt_rating or isCritical == 1 then
            if skill.ClassName == "Rogue_Backstab" then
                local angle = 120
                local attackerx, attackerz = GetDir(from)
                local targetx, targetz = GetDir(self)
                
                local attackerDir = GetAngleTo(from, self)
                local targetDir = DirToAngle(targetx, targetz)
                
                local relativeAngle = attackerDir - targetDir
                local revAngle = angle * -1

                if GetExProp(from, "IS_BACKATTACK") == 1 or (angle/2 >= relativeAngle and 0 <= relativeAngle) or (revAngle/2 <= relativeAngle and 0 >= relativeAngle) then
                    rateTable.DamageRate = rateTable.DamageRate + 1;
                end
                
            end
            
            ret.ResultType = HITRESULT_CRITICAL;
            SkillTextEffect(nil, self, from, "SHOW_DMG_CRI", nil, nil);
--          DelExProp(from, "IS_CRITICAL");
            return 1;           
        end
    end

    return 0;
end

function GetMinMaxATK(self, skill)
    local skillOwner = self;
--    if IsBuffApplied(self, 'Bunshin_Buff') == 'YES' then -- 시노비 분신의 경우 주인의 최대/최소 공격력을 따라가게
--    end
    
    if skill.ClassType == 'Melee' or skill.ClassType == 'Missile'  then
        return skillOwner.MINPATK , skillOwner.MAXPATK;
    else
        return skillOwner.MINMATK , skillOwner.MAXMATK + skillOwner.MHR;
    end
end

function SCR_LIB_CHECK_MISS(self, from, ret, skill, rateTable)
--    -- MISSION_SURVIVAL_EVENT2
--    if GetZoneName(self) == 'f_pilgrimroad_41_1_event' then
--        return 0
--    end
    
    if GetObjType(self) == OT_PC then
        local enchantcnt = CountEnchantItemEquip(self, 'ENCHANTARMOR_BLESSING');
        if enchantcnt > 0 and IMCRandom(1, 10000) < enchantcnt * 100 then
            ret.Damage = 0;
            ret.ResultType = HITRESULT_MISS;
            ret.HitType = HIT_DODGE;
            ret.EffectType = HITEFT_NO;
            ret.HitDelay = 0;
            return 1;
        end
    end

    local missRatioLimit = 3000;

    if rateTable.missRating > missRatioLimit then
        rateTable.missRating = missRatioLimit;
    end
    
    if (self.RaceType == "Item" and IsUsingNormalSkill(from) ~= 1) or rateTable.missRating > IMCRandom(1, 10000) or rateTable.missResult == 1 then
        ret.Damage = 0;
        ret.ResultType = HITRESULT_MISS;
        ret.HitType = HIT_DODGE;
        ret.EffectType = HITEFT_NO;
        ret.HitDelay = 0;
        return 1;
    end

    return 0;

end



function SCR_LIB_CHECK_DODGE(self, from, ret, skill, rateTable)
    local defRatio = 0;
    local defRatioLimit = 5000;
    local baseHR = from.HR;
    local baseDR = self.DR;
    
    if rateTable.EnableDodge == 0 then
        return 0;
    end
    
    if from.ClassName == "boss_honeyspider" or from.ClassName == "Head_fish" or from.ClassName == "GMevent_honeyspider" or from.ClassName == "Treasure_Goblin" then
        return 0;
    end
    
    -- 마법 공격 체크 --
    local checkMagic = 1;
    if skill.ClassType == "Magic" then
        checkMagic = 0;
        
        if rateTable.EnableMagicDodge == 1 then
            checkMagic = 1;
        end
    end
    
    -- 트루 대미지 체크 --
    local checkTrue = 1;
    if skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
        checkTrue = 0;
    end
    
    
    
    
    if checkMagic == 0 or checkTrue == 0 then
        return 0;
    end
    
    
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    defRatio = (math.max(0, baseDR - baseHR) ^ 0.65) * 100;
    
    local addhr = GetExProp(from, "ABIL_HR_ADD")
    
    defRatio = defRatio + rateTable.dodgeDefRatio - addhr;
    
    if defRatio > defRatioLimit then
        defRatio = defRatioLimit;
    end
    
    defRatio = defRatio * rateTable.DodgeRate;
    if skill.ClassType == "Magic" then
        defRatio = defRatio * rateTable.MagicDodgeRate;
    end
    
    if rateTable.FixedDodgeRate > 0 then
        defRatio = rateTable.FixedDodgeRate;
    end
    
    local randVal = IMCRandom(0, 10000);
--    if rateTable.dodgeRandVal > 0 then
--        randVal = rateTable.dodgeRandVal;
--    end
    
    if randVal < defRatio and ret ~= nil then
        ret.Damage = 0;
        ret.ResultType = HITRESULT_DODGE;
        ret.HitType = HIT_DODGE;
        ret.EffectType = HITEFT_NO;
        ret.HitDelay = 0;
        if IsBuffApplied(self, 'Evasion_Buff') == 'YES' then
            SkillTextEffect(nil, self, from, 'SHOW_SKILL_EFFECT', 0, nil, 'skl_Evasion');
        end
        return 1;
    end
    return 0;
end



function GetBoosterDamage(self, from, ret)
    if self ~= nil and from ~= nil and ret ~= nil then
        return GetJungtanDamage(self, from, ret);
    end
    return 0;
end

function GetFinalAtk(min, max)
    local atk = IMCRandom(min, max);
    return atk;
end


function CALC_FINAL_DAMAGE(atk, def, skill, self, from, crtResult, rateTable, ret, isDadak, factorCalcValue)
    if IS_PC(from) == true and 0 == IsDummyPC(from) then
        local jobAtkRate = GetPCJobAtkRate(from);
        if jobAtkRate ~= nil then
            rateTable.AddJobAtkRate = jobAtkRate;
        end
    end

    if IS_PC(self) == true then
        local JobDefRate = GetPCJobDefRate(self);
        if rateTable.JobDefRate ~= nil then
            rateTable.JobDefRate = JobDefRate;
        end
    end
    
    local sklFactor = skill.SkillFactor / 100.0;
    
    if IS_PC(from) ~= true and IsDummyPC(from) == 0 then
        sklFactor = sklFactor * from.SkillFactorRate / 100.0;
    end
    
    if factorCalcValue ~= nil and factorCalcValue > 0 then
        sklFactor = factorCalcValue / 100.0;
    end
    
--    sklFactor = SCR_ABIL_DAMAGE_CALC(sklFactor, self, from, skill, rateTable, ret)
--    local abilFactor = SCR_ABIL_DAMAGE_CALC(self, from, skill, rateTable, ret)
    
    -- Factor가 상수로 증가--
    local itemAddFactor = GetExProp(from, "SPCI_FACTOR_ADD_DAM");
    if itemAddFactor == nil then
        itemAddFactor = 0;
    end
    
    local addSklFactor = SCR_ADD_PC_SKLFACTOR_CALC(self, from, skill, rateTable, ret)
    
--    local sumAddFactor = abilFactor + itemAddFactor + addSklFactor + (rateTable.AddSkillFator / 100.0);
    local sumAddFactor = itemAddFactor + addSklFactor + (rateTable.AddSkillFator / 100.0);
    
    local reinforceAtk = 0;
    
    if IS_PC(from) == true then
        reinforceAtk = skill.ReinforceAtk;
    end
    
    local addCriticalATK = 0;
    local addCriticalDamageRate = 1.0;
    if crtResult == 1 then
        addCriticalATK = from.CRTATK + (from.CRTATK * rateTable.AddCrtAtkRate) + rateTable.AddCrtAtk;
        addCriticalDamageRate = 1.5 + rateTable.AddCrtDamageRate;
    end

    -- ★개편 공식 --
    -- 캐릭터의 기본 퍼뎀 공격력(스태이터스 창에 보이는 공격력) --
    local attackerPercentageATK = atk * rateTable.AddJobAtkRate;
    
    -- 캐릭터의 기본 고뎀 공격력(스킬의 공격력) --
    local attackerSkillATK = 0;
    
    local addAttributeATK = SCR_ADD_ATTACK_CALC(self, from, skill, rateTable);
    
    -- 추가되는 공격력 총 합 --
    local sumAddATK = addAttributeATK + rateTable.AddAtkDamage + rateTable.BoosterAtk + SCR_LIB_COMPANION_ATTACK(from, skill);
    
    local attackerATK = 0;
    local factorRate = 1;
    if sklFactor == 0 then
        factorRate = 1 + sumAddFactor;
        
        attackerATK = attackerSkillATK + sumAddATK;
    else
        factorRate = sklFactor + sumAddFactor;
        
        attackerATK = attackerPercentageATK + attackerSkillATK + sumAddATK;
    end
    
    --ISBUNSHIN == "YES"--
    if GetExProp(from, "BUNSIN") == 1 then
        local attackerTopOwner = GetTopOwner(from);
        local bunsinMaxAtk = TryGetProp(attackerTopOwner, "MAXPATK", 0);
        local bunsinMinAtk = TryGetProp(attackerTopOwner, "MINPATK", 0);
        local bunsinMaxAtkSub = TryGetProp(attackerTopOwner, "MAXPATK_SUB", 0) - TryGetProp(attackerTopOwner, "PATK_SUB_BM", 0) - TryGetProp(attackerTopOwner, "MAXPATK_SUB_BM", 0);
        local bunsinMinAtkSub = TryGetProp(attackerTopOwner, "MINPATK_SUB", 0) - TryGetProp(attackerTopOwner, "PATK_SUB_BM", 0) - TryGetProp(attackerTopOwner, "MINPATK_SUB_BM", 0);
        
        if TryGetProp(skill, "UseSubweaponDamage") == "YES" then
            bunsinMaxAtk = bunsinMaxAtkSub;
            bunsinMinAtk = bunsinMinAtkSub;
        elseif TryGetProp(skill, "UseSubweaponDamage") == "NO" and TryGetProp(attackerTopOwner, "PATK_MAIN_BM") ~= 0 then
            bunsinMaxAtk = bunsinMaxAtk - TryGetProp(attackerTopOwner, "PATK_MAIN_BM", 0);
            bunsinMinAtk = bunsinMinAtk - TryGetProp(attackerTopOwner, "PATK_MAIN_BM", 0);
        end
        
        bunsinMaxAtk = bunsinMaxAtk - TryGetProp(attackerTopOwner, "PATK_BM", 0);
        bunsinMinAtk = bunsinMinAtk - TryGetProp(attackerTopOwner, "PATK_BM", 0);
        bunsinMaxAtkSub = bunsinMaxAtkSub - TryGetProp(attackerTopOwner, "PATK_BM", 0);
        bunsinMinAtkSub = bunsinMinAtkSub - TryGetProp(attackerTopOwner, "PATK_BM", 0);
        
        if TryGetProp(attackerTopOwner, "PATK_RATE_BM") ~= 0 then
            bunsinMaxAtk = bunsinMaxAtk/(1 + TryGetProp(attackerTopOwner, "PATK_RATE_BM", 0));
            bunsinMinAtk = bunsinMinAtk/(1 + TryGetProp(attackerTopOwner, "PATK_RATE_BM", 0));
            bunsinMaxAtkSub = bunsinMaxAtkSub/(1 + TryGetProp(attackerTopOwner, "PATK_RATE_BM", 0));
            bunsinMinAtkSub = bunsinMinAtkSub/(1 + TryGetProp(attackerTopOwner, "PATK_RATE_BM", 0));
        end
        
        bunsinMaxAtk, bunsinMinAtk = SCR_DUALHAND_ATK_CALC(from, attackerTopOwner, skill, bunsinMaxAtk, bunsinMinAtk, bunsinMaxAtkSub, bunsinMinAtkSub)
        attackerATK = IMCRandom(bunsinMinAtk, bunsinMaxAtk);
    end
    
    --기본 물공에 여러가지 더해진 값
    local adjustedAttackerATK = attackerATK * factorRate;
    
    -- 캐릭터의 방어력
    local defenderDEF = def * (1 + (-1 * rateTable.AttackTypeRate))
    
    local addAttributeDEF = SCR_ADD_DEFENCE_CALC(self, from, skill, rateTable);
    defenderDEF = (defenderDEF + rateTable.AddDefence) * rateTable.JobDefRate + addAttributeDEF;
--    local defenderDEF = (def + rateTable.AddDefence) * rateTable.JobDefRate + addAttributeDEF;
    
    -- 방어무시 연산
    -- 방어무시 효과는 현재 방어력의 최대 50% 까지만 적용 --
    local IgnoreDEF = rateTable.AddIgnoreDefenses + (defenderDEF * rateTable.AddIgnoreDefensesRate);
    if IgnoreDEF > math.floor(defenderDEF / 2) then
        IgnoreDEF = math.floor(defenderDEF / 2);
    end
    
    defenderDEF = defenderDEF - IgnoreDEF;
    
    if defenderDEF < 0 then
        defenderDEF = 0;
    end
    
--    local atkDefResult = adjustedAttackerATK * math.min(1, math.log10(math.sqrt(attackerATK / (defenderDEF + 1)) + 1));
    local atkDefResultTemp = { };
    atkDefResultTemp[1] = 0;
    atkDefResultTemp[2] = 0;
    local adjustedATKList = { };
    adjustedATKList[1] = adjustedAttackerATK;
    adjustedATKList[2] = addCriticalATK * factorRate;
--    local attackerATKList = { };
--    attackerATKList[1] = attackerATK;
--    attackerATKList[2] = attackerATK + addCriticalATK;
    
    for i = 1, #atkDefResultTemp do
--        atkDefResultTemp[i] = adjustedATKList[i] * math.min(1, math.log10(math.sqrt(attackerATK / (defenderDEF + 1)) + 1));
        atkDefResultTemp[i] = adjustedATKList[i] * math.min(1, math.log10((attackerATK / (defenderDEF + 1)) ^ 0.9 + 1));
--        print(math.min(1, math.log10(math.sqrt(attackerATK / (defenderDEF + 1)) + 1)))
    end
    
    
    
--    -- 테스트용 시작 --
--    
--    local thisIsPC = nil
--    if IS_PC(from) == true then
--        thisIsPC = from;
--    elseif IS_PC(self) == true then
--        thisIsPC = self;
--    end
--    
--    if thisIsPC ~= nil then
--        local atkdefRatio = math.min(1, math.log10((attackerATK / (defenderDEF + 1)) ^ 0.9 + 1));
--        atkdefRatio = math.floor(atkdefRatio * 100) / 100;
--        ChatLocal(from, thisIsPC, "공격력 : "..atk.."("..attackerATK..") 공방비 : "..atkdefRatio, 0)
--        ChatLocal(self, thisIsPC, "방어력 : "..def.."("..defenderDEF..") 공방비 : "..atkdefRatio, 0)
--    end
--    
--    -- 테스트용 끝--
    
    
    
    local atkDefResult = (atkDefResultTemp[1] * addCriticalDamageRate) + atkDefResultTemp[2];
    -- ★ 여기까지 --
    
    local addDamage = 0;   
    if skill.ClassType == 'TrueDamage' then
        if atk < 1 then
            atkDefResult = 0;
        else
            local trueRateSum = 1 + rateTable.AttributeRate + rateTable.AttackTypeRate;
            
            -- 상태이상에 따른 기본 증댐 처리 --
            local conditionRate = SCR_CONDITION_RATE_CALC(self, form, skill);
            
            -- 속성상성 증/감댐과 상태이상에 따른 증/감댐이 복리 연산 --
            local attributeConditionRate = trueRateSum * conditionRate;
            if attributeConditionRate > 2 then
                attributeConditionRate = 2; -- 속성상성과 상태이상 증/감댐은 복리지만 최대 200% 제한 --
            end
            
            if attributeConditionRate < 0.5 then
                attributeConditionRate = 0.5    -- 속성상성과 상태이상 증/감댐은 복리지만 최소 50% 제한 --
            end
            
            atkDefResult = atk * attributeConditionRate;
            
            addDamage = addDamage + rateTable.AddTrueDamage;
        end
    else
        if atkDefResult < 1 then
            atkDefResult = 0;
        else
            local multipleHitCountRate = 1 + rateTable.MultipleHitDamageRate;
            atkDefResult = atkDefResult * multipleHitCountRate;
            
            local armorAbilRate = 0.0;
            
            if IS_PC(self) == true then
                local ironArmorCount = GetExProp(self, "IRON_ARMOR_COUNT");
                local clothArmorCount = GetExProp(self, "CLOTH_ARMOR_COUNT");
                
                if skill.ClassType == "Melee" then
                    if ironArmorCount == 3 then
                        armorAbilRate = armorAbilRate - 0.05;
                    elseif ironArmorCount == 4 then
                        armorAbilRate = armorAbilRate - 0.1;
                    end
                elseif skill.ClassType == "Magic" then
                    if clothArmorCount == 3 then
                        armorAbilRate = armorAbilRate - 0.05;
                    elseif clothArmorCount == 4 then
                        armorAbilRate = armorAbilRate - 0.1;
                    end
                end
            end
            
            local abilRateDamage = SCR_ABIL_DAMAGE_CALC(self, from, skill, rateTable, ret)
            
            -- Damage가 비율로 증가 (구 MUL_DAM) --
            local itemRateDamage = GetExProp(from, "SPCI_RATE_DAM");
            if itemRateDamage == nil then
                itemRateDamage = 0;
            end
            
            if IsBuffApplied(self, 'item_magicAmulet_2') == 'YES' then
                itemRateDamage = itemRateDamage + 0.2;
            end
            
            -- Damage가 상수로 증가 (구 ADD_DAM) --
            local itemAddDamage = GetExProp(from, "SPCI_ADD_DAM");
            if itemAddDamage == nil then
                itemAddDamage = 0;
            end
            
            if imcTime.GetAppTime() < GetExProp(skill, "SPC_DIVINEMIGHT_ENDTIME") then
                itemAddDamage = itemAddDamage + GetExProp(skill, "SPC_DIVINEMIGHT_SKL_ADD");
            end
            
            local cardDamageRateBM = GetExProp(from, "CARD_DAMAGE_RATE_BM") / 100
--            local rateSum = 1 + rateTable.AttributeRate + rateTable.DamageRate + armorAbilRate + abilRateDamage + itemRateDamage + cardDamageRateBM;
            local rateSum = 1 + rateTable.DamageRate + armorAbilRate + abilRateDamage + itemRateDamage + cardDamageRateBM;
            if rateSum < 0.1 then
                rateSum = 0.1;
            end
            
            atkDefResult = atkDefResult * rateSum;  -- 기본 증댐 처리 --
            
            if rateTable.DamageReductionRate ~= nil and #rateTable.DamageReductionRate > 0 then
                for i = 1, #rateTable.DamageReductionRate do
                    atkDefResult = atkDefResult - (atkDefResult * rateTable.DamageReductionRate[i]);    -- 감댐 복리 계산 --
                    
                    if atkDefResult < 1 then
                        atkDefResult = 0;
                    end
                end
            end
            
            -- 상태이상에 따른 기본 증댐 처리 --
            local conditionRate = SCR_CONDITION_RATE_CALC(self, form, skill);
            
            -- 속성상성 증/감댐과 상태이상에 따른 증/감댐이 복리 연산 --
            local attributeConditionRate = (1 + rateTable.AttributeRate) * conditionRate;
            if attributeConditionRate > 2 then
                attributeConditionRate = 2; -- 속성상성과 상태이상 증/감댐은 복리지만 최대 200% 제한 --
            end
            
            if attributeConditionRate < 0.5 then
                attributeConditionRate = 0.5    -- 속성상성과 상태이상 증/감댐은 복리지만 최소 50% 제한 --
            end
            
            atkDefResult = atkDefResult * attributeConditionRate;
            
            addDamage = addDamage + rateTable.AddTrueDamage + itemAddDamage;
        end
    end
    
    addDamage = addDamage + SCR_ADD_DAMAGE_CALC(self, from, skill, rateTable);
    
    local finalDamage = atkDefResult + (addDamage * (1 + rateTable.addDamageRate));
    
    if finalDamage < 1 then
        finalDamage = 1;
    end
    
    if skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
        if skill.ClassType == 'AbsoluteDamage' then
            finalDamage = atk;
        end
        
        if IS_PC(self) ~= true and IsDummyPC(self) ~= 1 and self.HPCount > 0 then
            finalDamage = 1;
        elseif ret.HitType == HIT_REFLECT then
            return;
        end
    elseif skill.ClassType == 'PhysicalLink' then        
        return
    end
    
    if rateTable.IgnoreDamage == 1 then         
        finalDamage = 0;
        ret.Damage = 0;
        ret.HitType = HIT_NOMOTION; 
        ret.ResultType = HITRESULT_MISS;
    end
    
    if rateTable.NoneDamage == 1 then
        finalDamage = 0;
        ret.Damage = 0;
    end
    
    RESET_RATE_TABLE(rateTable);
    
    --safety zone 
    if self.MaxDefenced_BM > 0 or (IsBuffApplied(self, 'CounterSpell_Buff') == 'YES' and skill.ClassType == 'Magic') then
        ret.Damage = 0;
        finalDamage = 0
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_SAFETY;
        ret.KDPower = 0;
        ret.EffectType = HITEFT_BAD;
    end
    
    --퀘스트 용이니 다른 곳에서 처리하도록 빼자!--
    if from.ClassName == 'boss_gesti' and from.NumArg1 == 1553 then
        local take_hp
        if self.HP < (self.MHP*0.5) then
            take_hp = 1
        else
            take_hp = (self.HP - self.MHP*0.5)
        end
       finalDamage = take_hp
    end
    --여기까지--
    
    ret.Damage = math.floor(finalDamage);
    
    --TOP오너가 PC 일 때, 팩션 체크해서 데미지 반타작해주자    
    local attackerTopOwner = GetTopOwner(from);
    local TopOwner = GetTopOwner(self);
    
    if IS_PC(attackerTopOwner) == true and IS_PC(TopOwner) == true then
        if IsSameActor(self, from) == 'NO' then
            if skill.ClassType ~= 'AbsoluteDamage' then
                local reducedDamageRateByPC = 0.8;
                local cardReductionRate = GetExProp(self, "DAMAGE_REDUCTION_RATE_FROM_PC");
                if cardReductionRate == nil then
                    cardReductionRate = 0;
                end
                
                reducedDamageRateByPC = (1 - reducedDamageRateByPC) * (1 - (cardReductionRate/100));
                finalDamage = math.ceil(finalDamage * reducedDamageRateByPC);
                ret.Damage = math.floor(finalDamage);
            end
        end
    end
    
    
    -- 테스트용 -----------------------------------
--    Chat(from, ret.Damage)
end

function SCR_ABIL_DAMAGE_CALC(self, from, skill, rateTable, ret)
    local abilRateDamage = 0;
    
    local Archer5_abil = GetAbility(from, "Archer5")
    if Archer5_abil ~= nil and IS_PC(self) == false then
        local rItem  = GetEquipItem(from, 'RH');
        if rItem.AttachType == "THBow" and self.MoveType == "Flying" then
            abilRateDamage = abilRateDamage + (Archer5_abil.Level * 0.1)
        end
    end
    
    local Fencer1_abil = GetAbility(from, "Fencer1")
    if Fencer1_abil ~= nil then
        local rItem  = GetEquipItem(from, 'RH');
        local lItem  = GetEquipItem(from, 'LH');
        if rItem.AttachType == "Rapier" and lItem.ClassType ~= "Shield" and skill.ClassID > 10000 then
            abilRateDamage = abilRateDamage + (Fencer1_abil.Level * 0.03)
        end
    end
    
    local Schwarzereiter2_abil = GetAbility(from, "Schwarzereiter2")
    if Schwarzereiter2_abil ~= nil and IS_PC(self) == false then
        if (skill.ClassName == "Pistol_Attack" or skill.ClassName == "Pistol_Attack2") and self.RaceType == "Paramune" then
            abilRateDamage = abilRateDamage + (Schwarzereiter2_abil.Level * 0.1)
        end
    end
    
    local Warlock1_abil = GetAbility(from, "Warlock1")
    if Warlock1_abil ~= nil then
        if skill.Attribute == "Dark" then
            abilRateDamage = abilRateDamage + (Warlock1_abil.Level * 0.01)
        end
    end
    
    local Dragoon10_abil = GetAbility(from, "Dragoon10")
    if Dragoon10_abil ~= nil then
        local rItem  = GetEquipItem(from, 'RH');
        if rItem.AttachType == "THSpear" and self.Size == "L" then
            abilRateDamage = abilRateDamage + (Dragoon10_abil.Level * 0.04)
        elseif rItem.AttachType == "THSpear" and self.Size == "XL" then
            abilRateDamage = abilRateDamage + (Dragoon10_abil.Level * 0.02)
        end
    end
    
    local Hoplite27_abil = GetAbility(from, "Hoplite27")
    if Hoplite27_abil ~= nil then
        local rItem  = GetEquipItem(from, 'RH');
        if rItem.AttachType == "Spear" and self.Size == "M" and skill.ClassID > 10000 then
            abilRateDamage = abilRateDamage + (Hoplite27_abil.Level * 0.04)
        end
    end
    
    local Spear_abil = GetAbility(from, "Spear")
    if Spear_abil ~= nil then
        local rItem = GetEquipItem(from, 'RH');
        if rItem ~= nil and rItem.ClassType == "Spear" then
            local size = TryGetProp(self, "Size");
            if size == "M" or size == "L" then
                abilRateDamage = abilRateDamage + 0.05;
            end
        end
    end
    
    local Matador10_abil = GetAbility(from, "Matador10")
    if Matador10_abil ~= nil then
        if IS_PC(self) == true then -- PC 대상 --
            local buffList, buffCount = GetBuffListByProp(self, 'Keyword', 'Provoke');
            if buffList ~= nil and buffCount >= 1 then
                for i = 1, buffCount do
                    local checkBuff = buffList[i];
                    local buffCaster = GetBuffCaster(checkBuff);
                    if buffCaster ~= nil and IsSameActor(from, buffCaster) then
                        abilRateDamage = abilRateDamage + 0.1;
                    end
                end
            end
        else    -- 몬스터 대상 --
            local topHate = GetTopHatePointChar(self);
            if topHate ~= nil then
                if IsSameActor(from, topHate) == 'YES' then
                    abilRateDamage = abilRateDamage + 0.1;
                end
            end
        end
    end
    
    local Matador11_abil = GetAbility(from, "Matador11")
    if Matador11_abil ~= nil then
        local rItem = GetEquipItem(from, 'RH');
        if rItem ~= nil and rItem.ClassType == "Rapier" then
            if IS_PC(self) == true then -- PC 대상 --
                local buffList, buffCount = GetBuffListByProp(self, 'Keyword', 'Provoke');
                if buffList ~= nil and buffCount >= 1 then
                    for i = 1, buffCount do
                        local checkBuff = buffList[i];
                        local buffCaster = GetBuffCaster(checkBuff);
                        if buffCaster ~= nil and IsSameActor(from, buffCaster) then
                            abilRateDamage = abilRateDamage + 0.2;
                        end
                    end
                end
            else    -- 몬스터 대상 --
                local topHate = GetTopHatePointChar(self);
                if topHate ~= nil then
                    topHate = GetTopOwner(topHate);
                    if IsSameActor(from, topHate) == 'YES' then
                        abilRateDamage = abilRateDamage + 0.2;
                    end
                end
            end
        end
    end
    
    local abilPyromancer8 = GetAbility(from, "Pyromancer8")
    if abilPyromancer8 ~= nil then
        local rItem = GetEquipItem(from, 'RH');
        if rItem ~= nil and rItem.ClassType == "THStaff" then
            local attribute = TryGetProp(skill, "Attribute");
            if attribute == "Fire" then
                local abilAddDamage = abilPyromancer8.Level * 0.05
                abilRateDamage = abilRateDamage + abilAddDamage;
            end
        end
    end
    
    local abilCryomancer5 = GetAbility(from, "Cryomancer5")
    if abilCryomancer5 ~= nil then
        local rItem = GetEquipItem(from, 'RH');
        if rItem ~= nil and rItem.ClassType == "Staff" then
            local attribute = TryGetProp(skill, "Attribute");
            if attribute == "Ice" then
                local abilAddDamage = abilCryomancer5.Level * 0.05
                abilRateDamage = abilRateDamage + abilAddDamage;
            end
        end
    end
    
    
    return abilRateDamage;
end


function SCR_LIB_COMPANION_ATTACK(from, skill)
    if IS_PC(from) == false then
        return 0;
    end
    
    local needID = 0;
    local rate = 0;
    if skill.HitType == 'Companion' then --헌터쪽
    local Hunter13_abil = GetAbility(from, 'Hunter13');
        if Hunter13_abil ~= nil then
            local abilrate = Hunter13_abil.Level;
            rate = abilrate * 0.01;
        end
    elseif skill.HitType == 'Companion_Flying' then --응사
        needID  = 3014;
        local Falconer15_abil = GetAbility(from, 'Falconer15');
        if Falconer15_abil ~= nil then
            local abilrate = Falconer15_abil.Level;
            rate = abilrate * 0.01;
        end
    end
    
    local attackCom = GetSummonedPet(from, needID);
    if nil == attackCom then
        return 0;
    end
    return attackCom.ATK * rate;
end

function SCR_LIB_ATKCALC_RH(from, skill)
-- RH, LH 혼용으로 사용하고 있어서 문제가 되어있었다.
-- 스킬의 핸드타입을 체크하여, 맞는 녀석을 호출하도록 하자.
	if TryGetProp(skill, "Job") == "Wugushi" then
		local abilWugushi22 = GetAbility(from, "Wugushi22")
		if abilWugushi22 ~= nil and abilWugushi22.ActiveState == 1 then
			skill.UseSubweaponDamage = "YES"
		else
			skill.UseSubweaponDamage = "NO"
		end
	end
	
	if TryGetProp(skill, "Job") == "Sapper" then
--		local owner = GetOwner()
		local abilSapper37 = GetAbility(from, "Sapper37")
		if abilSapper37 ~= nil and abilSapper37.ActiveState == 1 then
			skill.UseSubweaponDamage = "YES"
		else
			skill.UseSubweaponDamage = "NO"
		end
	end
    
    if IS_PC(from) == true and skill.UseSubweaponDamage == "YES" then
        return SCR_LIB_ATKCALC_LH(from, skill)
    end
	
    local minAtk, maxAtk = GetMinMaxATK(from, skill);
    
    if IS_PC(from) == true then
        minAtk = minAtk + from.BonusDmg_BM;
        maxAtk = maxAtk + from.BonusDmg_BM;
    end
	
    local atk = GetFinalAtk(minAtk, maxAtk);
    return atk;

end

function SCR_LIB_ATKCALC_LH(from, skill)
-- RH, LH 혼용으로 사용하고 있어서 문제가 되어있었다.
-- 스킬의 핸드타입을 체크하여, 맞는 녀석을 호출하도록 하자.
    
    if IS_PC(from) == true and skill.UseSubweaponDamage == "NO" then
        return SCR_LIB_ATKCALC_RH(from, skill)
    end
    
    local minAtk = 1;
    local maxAtk = 1;
    
    if skill.ClassType == 'Melee' or skill.ClassType == 'Missile'  then
        minAtk = from.MINPATK_SUB;
        maxAtk = from.MAXPATK_SUB;
    end

    if IS_PC(from) == true then
        minAtk = minAtk + from.BonusDmg_BM;
        maxAtk = maxAtk + from.BonusDmg_BM;
    end
	
    local atk = GetFinalAtk(minAtk, maxAtk);
    return atk;

end


function SCR_SKILL_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable)

    local funcName =  'SCR_SKILL_RATETABLE_'.. skill.ClassName;
    if IsFunc(funcName) == 1 then
        local func = _G[funcName];
        func(self, from, skill, atk, ret, rateTable);
    end
end

function IsFunc(funcName)    
    local funcPtr = _G[funcName];
    if funcPtr == nil then
        return 0
    end
    return 1
end

function SCR_BUFF_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable)
    local buffList, listCnt = GetBuffList(self);
    for i=1, listCnt do
        local buff = buffList[i];
        local funcName =  'SCR_BUFF_RATETABLE_'.. buff.ClassName;
        if IsFunc(funcName) == 1 then
            local func = _G[funcName];
            func(self, from, skill, atk, ret, rateTable, buff);
        end
    end

    buffList, listCnt = GetBuffList(from);
    for i=1, listCnt do
        local buff = buffList[i];
        local funcName =  'SCR_BUFF_RATETABLE_'.. buff.ClassName;
        if funcName ~= nil and IsFunc(funcName) == 1 then
            local func = _G[funcName];
            func(self, from, skill, atk, ret, rateTable, buff);
        end
    end
end

function SCR_BUFF_IMMUNE_RATE_UPDATE(self, buffName, buffLv, rate)
    local buffList, listCnt = GetBuffList(self);
    for i=1, listCnt do
        local buff = buffList[i];
        local funcName =  'SCR_BUFF_IMMUNE_'.. buff.ClassName;
        if IsFunc(funcName) == 1 then
            local func = _G[funcName];
            rate = rate + (func(self, buffName, buffLv, rate));
        end
    end

    return rate;
end

function SCR_SKILL_AFTERCALC_UPDATE(self, from, skill, atk, ret)

    local funcName =  'SCR_SKILL_AFTERCALC_HIT_'.. skill.ClassName;
    if IsFunc(funcName) == 1 then
        local func = _G[funcName];
        func(self, from, skill, atk, ret);
    end
end

function SCR_BUFF_AFTERCALC_UPDATE(self, from, skill, atk, ret)
    local buffList, listCnt = GetBuffList(self);
    for i=1, listCnt do
        local buff = buffList[i];
        local funcName =  'SCR_BUFF_AFTERCALC_HIT_'.. buff.ClassName;
        if IsFunc(funcName) == 1 then
            local func = _G[funcName];
            func(self, from, skill, atk, ret, buff);
        end
    end

    buffList, listCnt = GetBuffList(from);
    for i=1, listCnt do
        local buff = buffList[i];
        local funcName =  'SCR_BUFF_AFTERCALC_ATK_'.. buff.ClassName;
        if IsFunc(funcName) == 1 then
            local func = _G[funcName];
            func(self, from, skill, atk, ret, buff);
        end
    end
end

function FINAL_DAMAGECALC(self, from, skill, atk, ret, fixHitType, isDadak)
    -- TakeDamage 등에서 넘겨오는 atk 값을 Factor(% 대미지)로 사용하기 위한 처리 시작 --
    local factorCalcValue = 0;
    if skill.ClassType == "FactorCalcMelee" or skill.ClassType == "FactorCalcMagic" then
        if skill.ClassType == "FactorCalcMelee" then
            skill.ClassType = "Melee";
        elseif skill.ClassType == "FactorCalcMagic" then
            skill.ClassType = "Magic";
        else
            return 0, ret;
        end
        
        factorCalcValue = atk;
        atk = SCR_LIB_ATKCALC_RH(from, skill);
    end
     -- TakeDamage 등에서 넘겨오는 atk 값을 Factor(% 대미지)로 사용하기 위한 처리 끝 --
    
    ret.Damage = atk;
    
    if IsBuffApplied(self, 'Stop_Debuff') == 'YES' then
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_NOMOTION;
        ret.EffectType = HITEFT_NO;
        ret.Damage = 0
        return 0, ret;
    end
    

    local Hitscp = false;
    if ret.ResultType == HITRESULT_NO_HITSCP or ret.ResultType == HITRESULT_NO_HITSCP_CRI then
        Hitscp = true;
    end

    local rateTable = SET_RATE_TABLE();
    SCR_BUFF_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable);
    SCR_SKILL_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable);
    
    -- Not calculated
    if rateTable.NotCalculated == 1 then
        ret.ResultType = HITRESULT_NONE;
        ret.HitType = HIT_NOHIT;
        ret.EffectType = HITEFT_NO;
        return 0, ret;
    end
    
    -- MISS
    local missResult = SCR_LIB_CHECK_MISS(self, from, ret, skill, rateTable)
    if missResult == 1 then
        return 0, ret;
    end
    
    -- DODGE
    local dodgeResult = SCR_LIB_CHECK_DODGE(self, from, ret, skill, rateTable);
    if dodgeResult == 1 then
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        return 0, ret;
    end

    -- BLOCK
    local blkResult = SCR_LIB_CHECK_BLK(self, from, ret, skill, rateTable);
    if blkResult == 1 then
        ret.Damage = 0;
        ret.EffectType = HITEFT_BAD
        ret.HitDelay = skill.HitDelay
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        return 0, ret;
    end
    
    -- CRITICAL
    local crtResult = SCR_LIB_CHECK_CRT(self, from, skill, ret, rateTable);
    if crtResult ~= 1 then
        ret.ResultType = HITRESULT_BLOW;
        ret.HitType = HIT_BASIC;
        ret.EffectType = HITEFT_NORMAL;
        ret.HitDelay = skill.HitDelay
    end
    
--    --HitDelay for Attack Speed
--    local attackSpeed = GetExProp(from, 'NORMAL_ATK_SPD')
--    if attackSpeed < 0 and ret.HitDelay > 10 then
--        local nomalAttackSpeedRate = SCR_SKILL_SPDRATE_NORMAL_ATK(skill);
--        nomalAttackSpeedRate = math.floor(ret.HitDelay / nomalAttackSpeedRate);
--        if nomalAttackSpeedRate < 10 then
--            nomalAttackSpeedRate = 10;
--        end
--        ret.HitDelay = nomalAttackSpeedRate;
--    end
    
    SCR_SKILLHIT_COMMON(self, from, ret, skill, rateTable, fixHitType);
    SetExProp(from, "CHECK_SKL_KD_PROP", 0);
    
    rateTable.BoosterAtk  = GetJungtanDamage(self, from, ret);
    
    local def = TryGetProp(self, "DEF");
    
    if skill.ClassType == 'Magic' then
        def = TryGetProp(self, "MDEF");
    end
    
    if skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
        def = 0;
    end
    
    if def == nil then
        def = 0
    end
        
    --indunTheEnd
    if skill.ClassName == "indunTheEnd" then
        ret.Damage = self.MHP;
        return ret.Damage, ret;
    end
    
    -- calc damage
    CALC_FINAL_DAMAGE(atk, def, skill, self, from, crtResult, rateTable, ret, isDadak, factorCalcValue);
    
    --mackangdal 
    if GetExProp(self, "isMackangdal_Buff") == 1 then
        SetExProp(self, "DamageConut", GetExProp(self, "DamageConut") + ret.Damage)
        ret.Damage = 0
    end
    
    SCR_BUFF_AFTERCALC_UPDATE(self, from, skill, atk, ret);
    SCR_SKILL_AFTERCALC_UPDATE(self, from, skill, atk, ret);
    
    if IS_PC(from) == true then
        local normalSkl = GetNormalSkill(from);
        if normalSkl ~= nil and skill.ClassName == normalSkl.ClassName then
            local weapon = GetEquipItem(from, 'RH')
            if weapon.ClassName == 'STF04_103' then
                ret.HitType = HIT_TWINKLESTAR;
            end
        end
    end
    
    SCR_EQUIP_AFTERCALC_UPDATE(self, skill, ret);

    if Hitscp == true then
        if ret.ResultType == HITRESULT_CRITICAL then
            ret.ResultType = HITRESULT_NO_HITSCP_CRI;
        else
            ret.ResultType = HITRESULT_NO_HITSCP;
        end
    end
    
--HP카운터 처리 여기서 한번 더 해준다.

    if IS_PC(self) ~= true and IsDummyPC(self) ~= 1 and self.HPCount > 0 then
        ret.Damage = 1;
    end
    
--HP카운터 처리 여기서 한번 더 해준다.
    if ret.Damage > 0 then
        local multiHitCount = GetMultipleHitCount(ret);
        if ret.Damage < multiHitCount then
            ret.Damage = multiHitCount;
        end
    end
	
    local limitDamage = GET_LIMIT_MAX_DAMAGE(self, from, skill, ret);
    if limitDamage > 0 and ret.Damage > limitDamage then
    	if IS_PC(self) == true and IS_PC(from) == false then
    		local pcBuffString = '';
    		local pcBuffList, pcBuffCount = GetBuffList(self);
    		if pcBuffCount >= 1 then
	    		for i = 1, pcBuffCount do
	    			pcBuffString = pcBuffString .. ', ' .. pcBuffList[i].ClassName;
	    		end
	    	else
	    		pcBuffString = 'None';
	    	end
	    	
    		local monBuffString = '';
    		local monBuffList, monBuffCount = GetBuffList(from);
    		if monBuffCount >= 1 then
	    		for i = 1, monBuffCount do
	    			monBuffString = monBuffString .. ', ' .. monBuffList[i].ClassName;
	    		end
	    	else
	    		monBuffString = 'None';
	    	end
	    	
		    IMC_LOG('INFO_SKILL_PASS_DECREASED_TIME', 'Attacker : ' .. TryGetProp(from, 'Name', 'Name') .. '(' .. TryGetProp(from, 'ClassName', 'ClassName') .. ')' .. ' / AttackerBuff : ' .. monBuffString .. ' / Defender : ' .. TryGetProp(self, 'Name', 'Name') .. '(' .. TryGetProp(self, 'ClassName', 'ClassName') .. ')' .. ' / DefenderBuff : ' .. pcBuffString)
--		    print('Attacker : ' .. TryGetProp(from, 'Name', 'Name') .. '(' .. TryGetProp(from, 'ClassName', 'ClassName') .. ')' .. ' / AttackerBuff : ' .. monBuffString .. ' / Defender : ' .. TryGetProp(self, 'Name', 'Name') .. '(' .. TryGetProp(self, 'ClassName', 'ClassName') .. ')' .. ' / DefenderBuff : ' .. pcBuffString)
		end
        ret.Damage = limitDamage
    end
    
    
    -- 0 / 0 같은 멍청한 짓을 하면 이런게 나온다. 혹시나 이런게 나오면 대미지가 터지기 때문에 최후의 방어선 --
    if tostring(ret.Damage) == tostring(0 / 0) then
        IMC_LOG('FATAL_ASSERT', 'It is nan value');
        ret.Damage = 0;
    end
    
--    if not(ret.Damage > 0) and not(ret.Damage < 0) and not(ret.Damage == 0) then
--        ret.Damage = 0;
--    end
    
    if ret.Damage < 0 then
        ret.Damage = 0;
    end

    -- FullDraw 상태일 때, 꿰임 상태인 몬스터에게 순수 atk가 아닌 데미지 연산이 끝난 atk가 넘어온다. 
    -- 둘이 같은 데미지를 받아야 하기 때문에, 꿰임 상태에서 맞은지를 체크(hardskill_linker.lua, TAKE_DMG_LINK())해서 ret.Damage에 넘어온 atk를 그대로 세팅한다.    
    if GetExProp(self, 'FulldrawLinkState') == 1 then
        ret.Damage = atk
        SetExProp(self, 'FulldrawLinkState', 0)
    end
    
    return ret.Damage, ret;
end


function GET_LIMIT_MAX_DAMAGE(self, attacker, skill, ret)
    -- PC : 777,777, 오라클의 트위스트 오브 페이트는 1,555,555
    -- MON : 777,777
    
    if GetExProp(self, 'UNLIMIT_MAX_DAMAGE') == 1 then
        return 2147483647;  -- 표현 가능한 최대값 인트 범위 --
    end
    
    local defaultMaxDamage = 777777;
    local overMaxDamage = 1555555;
    
    local multipleHitCount = GetMultipleHitCount(ret);
    if multipleHitCount ~= nil and multipleHitCount ~= 0 then
        defaultMaxDamage = math.floor(defaultMaxDamage * multipleHitCount);
        overMaxDamage = math.floor(overMaxDamage * multipleHitCount);
    end
    
    local checkPC = false;
    if IS_PC(attacker) then
        checkPC = true;
    else
        local attackerTopOwner = GetTopOwner(attacker);
        if attackerTopOwner ~= nil and IS_PC(attackerTopOwner) then
            checkPC = true;
            attacker = attackerTopOwner;
        end
    end
    
    if checkPC == true then
        if (skill ~= nil and skill.ClassName == 'Oracle_TwistOfFate') or IsBuffApplied(self, 'Kabbalist_GEVURA') == 'YES' then
            return overMaxDamage;
        end
        
        return defaultMaxDamage;
    else
        return defaultMaxDamage;
    end
    
    return -1;
end


function SCR_EQUIP_AFTERCALC_UPDATE(self, skill, ret)
    if IS_PC(self) == false then
        return;
    end

    if skill.ClassType ~= "Melee" and skill.ClassType ~= "Magic" then
        return;
    end
    
    local atkReductionRatio = 0.0;
    local matkReductionRatio = 0.0;

    local spotCount = item.GetEquipSpotCount() - 1;
    for i = 0 , spotCount do
        local es = item.GetEquipSpotName(i);
        local equipItem = GetEquipItem(self, es);
        if equipItem ~= nil then
            atkReductionRatio = atkReductionRatio + equipItem.DefRatio;
            matkReductionRatio = matkReductionRatio + equipItem.MDefRatio;
        end
    end

    if skill.ClassType == "Melee" then
        ret.Damage = ret.Damage * (1.0 - atkReductionRatio * 0.01);
    elseif skill.ClassType == "Magic" then
        ret.Damage = ret.Damage * (1.0 - matkReductionRatio * 0.01);
    end
end

function SCR_LIB_CHECK_StunRate(self, from, damage, ret, resultType)

    local stun_rate = from.StunRate

    if stun_rate > IMCRandom(1, 10000) then
        AddBuff(from, self, 'Stun', 1, 0, 5000, 1);
    end

end

function GET_HP_PERCENT(self)

    return self.HP * 100 / self.MHP;

end

function GET_HP_RATE(self)
    return self.HP / self.MHP;
end

function IsHostileFaction(from, self) 

    local faction_f = GetCurrentFaction(from);
    local faction_s = GetCurrentFaction(self);
    local str = GetClassString('Faction', faction_f, 'HostileTo');

    local words = {};
    for w in string.gmatch(str, "[^;]+") do
        words[#words + 1] = w;
    end
    for i = 1, #words do
        if faction_s == words[i] then
            return 'YES';
        end
    end
    return 'NO';

end

function SCR_LIB_CHECK_ISGUARDING(self)
    local guard = IsGuarding(self);
    if guard == 1 then
        do return 'YES' end
    end

    guard = GetExProp(self, 'GuardFlag');
    if guard == 1 then
        do return 'YES' end
    end
    return 'NO';
end

function SCR_USEJUMP(pc)

    if IsBuffApplied(pc, 'Cloaking_Buff') == 'YES' then
        RemoveBuff(pc, 'Cloaking_Buff')
    end
    
    if IsBuffApplied(pc, 'ShinobiCloaking_Buff') == 'YES' then
        RemoveBuff(pc, 'ShinobiCloaking_Buff')
    end
    
    if IsBuffApplied(pc, 'WideMiasma_Buff') == 'YES' then
        RemoveBuff(pc, 'WideMiasma_Buff')
    end 

    if IsBuffApplied(pc, 'Archer_Kneelingshot') == 'YES' then
        RemoveBuff(pc, 'Archer_Kneelingshot')
        
        ChangeSkillAniNameImmediately(pc, "Bow_Attack", "None");
        ChangeSkillAniNameImmediately(pc, "CrossBow_Attack", "None");
        ChangeSkillAniNameImmediately(pc, "Pistol_Attack", "None");
        ChangeSkillAniNameImmediately(pc, "Musket_Attack", "None");

        SetToggledSkillID(pc, 30003, 0);
    end
    
end

function BEGONE_CONSUMEDUR(pc, enableDeadDurabilityConsume,deathPenaltyBuffLevel, isDeathByPC)
    if IsDummyPC(pc) == 1 then
        return;
    end

    if pc.Lv <= 20 or enableDeadDurabilityConsume ~= 1 or isDeathByPC ~= 0 then
        return;
    end

    local tx = TxBegin(pc);
    TxEnableInIntegrateIndun(tx);

    local spotCount = item.GetEquipSpotCount() - 1;
    for i = 0 , spotCount do
        local es = item.GetEquipSpotName(i);
        local equipWeapon = GetEquipItem(pc, es);
        if 0 == item.IsNoneItem(equipWeapon.ClassID) then
            local consumeDurability = equipWeapon.MaxDur * 0.2;

            if IsBuffApplied(pc, 'Double_pay_earn_Buff') == 'YES' then
                if GetAbility(pc, 'Doppelsoeldner1') ~= nil then
                    consumeDurability = equipWeapon.MaxDur * 0.4;
                else
                    consumeDurability = equipWeapon.MaxDur * 0.6;
                end
            end

            if deathPenaltyBuffLevel > 0 then
                consumeDurability = MITIGATEPENALTY_GET_DURABILITY(pc, consumeDurability, deathPenaltyBuffLevel);
            end
            
            if consumeDurability > 0 then
        
                local dur = equipWeapon.Dur - consumeDurability;
                dur = math.floor(dur)

                if dur < 0 then
                    dur = 0 
                end
                if equipWeapon.Dur ~= dur then
                    TxSetIESProp(tx, equipWeapon, 'Dur', dur);
                end

            end
        end
    end

    local ret = TxCommit(tx);           
end

function BEGONE_DROP_VIS(pc, deathPenaltyBuffLevel, silverDropRatio)
    if deathPenaltyBuffLevel > 0 then
        silverDropRatio = MITIGATEPENALTY_GET_MONEYDROPRATIO(pc, silverDropRatio, deathPenaltyBuffLevel);
    end

    local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
    if pcMoney == nil then
        return;
    end

    cnt  = math.floor(cnt * silverDropRatio / 100);
    if cnt <= 0 then
        return;
    end
    
    local tx = TxBegin(pc);
    TxEnableInIntegrateIndun(tx);
    TxTakeItem(tx, MONEY_NAME, cnt, 'BEGONE');
    local ret = TxCommit(tx);
    if ret == "SUCCESS" then
        SendSysMsg(pc, "YouDeadSoSomeSilverHasBeenLost");
    end
end

function BEGONE_DROP_INV_ITEM(pc, deathPenaltyBuffLevel, penaltyType)
    local get_item = GetInvItemList(pc);
    local someflag = 0
    local itemTemp = nil;
    local gemExpTemp = 0;
    local gemRoastingLv = 0;
    local belongingCount = 0;
------------ 170914 Dev #20081 ---------------------    
    
    if string.find(penaltyType, 'Gem') ~= nil then 
        local gemtable = {}
        local drop_gemtable = {}
        local gem_stringLen = string.len(penaltyType);
        local drop_gem_str = string.sub(penaltyType, 4, gem_stringLen);
        local drop_gem_num = tonumber(drop_gem_str)
        
        for i = 1 , #get_item do
            local someitem = get_item[i];
            if someitem.GroupName == "Gem" then
                table.insert(gemtable, 1 ,someitem);
            end    
        end

        if drop_gem_num >= #gemtable then
            drop_gem_num = #gemtable
        end

        while #drop_gemtable ~= drop_gem_num do
            local selectGem = IMCRandom(1, #gemtable);
            local drop_gem  = gemtable[selectGem];
            if drop_gem == nil then
                return 0;
            end
            table.insert(drop_gemtable, 1, drop_gem);
            table.remove(gemtable, selectGem)
        end
        get_item = drop_gemtable;
    end
-----------------------------------------------------
    
    for i = 1 , #get_item do
        local someitem = get_item[i];
        if 0 == item.IsNoneItem(someitem.ClassID) and IS_EQUIPED_CARD(pc, someitem) == false then
            local randomratio = IMCRandom(1, 100)
            local deathBreakRatio = someitem.DeadBreakRatio;
            deathBreakRatio = MITIGATEPENALTY_GET_GEMBREAKRATIO(pc, penaltyType, someitem, deathBreakRatio, deathPenaltyBuffLevel);
            if deathBreakRatio > randomratio then

                local cnt = 1
                itemTemp = someitem.ClassName;
                if someitem.MaxStack > 1 then
                ---------------------170914 Dev #20081--------------------
                    local stringLen = string.len(penaltyType);
                    local blessstone_dropRatio = string.sub(penaltyType, 11, stringLen);
                    
                    cnt = GetInvItemCount(pc, itemTemp) --조각이랑 축복석 다 떨궈야 한다는데?
                    if cnt ~= 0 or cnt == nil then
                        cnt = math.floor((cnt * blessstone_dropRatio / 100) + 0.5)
                        if cnt == 0 then
                             cnt = 1;
                        elseif cnt >=  GetInvItemCount(pc, itemTemp) then
                            cnt = GetInvItemCount(pc, itemTemp);
                        end
                    end
                -------------------------------------------------------------
                end

                belongingCount = TryGetProp(someitem, 'BelongingCount')
                if belongingCount ~= nil then
                    belongingCount = tonumber(belongingCount);
                else
                    belongingCount = 0
                end

                gemExpTemp = TryGetProp(someitem, 'ItemExp')
                if gemExpTemp ~= nil then
                    gemExpTemp = tonumber(gemExpTemp);
                else
                    gemExpTemp = 0
                end

                gemRoastingLv = TryGetProp(someitem, 'GemRoastingLv')
                if gemRoastingLv ~= nil then
                    gemRoastingLv = tonumber(gemRoastingLv);
                else
                    gemRoastingLv = 0;
                end

                local gemIESID = GetIESID(someitem);
                if gemIESID == nil then
                    gemIESID = '0';
                end

                local tx = TxBegin(pc);
                TxEnableInIntegrateIndun(tx);
                TxTakeItemByObject(tx, someitem, cnt, "DeadPenalty");
                local ret = TxCommit(tx);
            
                if ret == "SUCCESS" then
                    someflag = 1;
                    local rate = 100;
        ----------------170914 Dev #20081---------------
                    if string.find(penaltyType, 'Gem') == nil then 
                        rate = 0;                                           
                    end              
        -------------------------------------------------
        
                    if IMCRandom(1, 100) <= rate then
                        local x, y, z = GetPos(pc)
                        local itemObj = CreateGCIES('Monster', itemTemp);
                        
                        local item = CREATE_ITEM(pc, itemObj, pc, x, y, z, 0, 5, true);
                        SetIESID(item, gemIESID);
                        SetExProp(item, "isDromGem", 1);
                        SetExProp(item, "gemExpTemp", gemExpTemp);
                        SetExProp(item, "GemRoastingLv", gemRoastingLv);
                        SetExProp(item, "BelongingCount", belongingCount);
                        item.ItemCount = cnt;

                        SetOwner(item, pc, 0);

                        if item ~= nil then
                            SetDeathPenalty(item, gemExpTemp, gemRoastingLv, belongingCount);
                            ItemDropMongoLog(pc, pc, itemTemp, 1,0, item.UniqueName, item);
                            local self_layer = GetLayer(pc);
                            if self_layer ~= nil and self_layer ~= 0 then
                                SetLayer(item, self_layer);
                            end
                        end
                    end
                end
            end
        end
    end          

    if someflag > 0 then
        SendSysMsg(pc, "YouDeadSoSomeItemHasBeenBreak");
    end
end

function IS_EQUIPED_CARD(pc, cardObj)
    -- verify param
    if pc == nil or cardObj == nil then
        return false;
    end
    local etc = GetETCObject(pc);
    if etc == nil then
        return false;
    end
    if TryGetProp(cardObj, 'GroupName') ~= 'Card' then
        return false;
    end
    local cardGUID = GetItemGuid(cardObj);
    if cardGUID == nil then
        return false;
    end

    -- wugushi
    if TryGetProp(etc, 'Wugushi_bosscardGUID') == cardGUID then
        return true;
    end

    -- sorcerer
    for i = 1, 2 do -- 그리모어는 카드 2개
    if TryGetProp(etc, 'Sorcerer_bosscardGUID'..i) == cardGUID then
            return true;
        end
    end

    -- necromancer
    for i = 1, 4 do -- 네크로노미콘은 카드 4개
    if TryGetProp(etc, 'Necro_bosscardGUID'..i) == cardGUID then
            return true;
        end
    end

    return false;
end

function BEGONE(pc, enableDeadDurabilityConsume)    

    if IsInTeamBattlezone(pc) == 1 then
        return;
    end
    local mitigatePenalty = GetBuffByName(pc, "MitigatePenalty_Buff");
    local deathPenaltyBuffLevel = 0;
    if mitigatePenalty ~= nil then
        deathPenaltyBuffLevel = GetBuffArg(mitigatePenalty);
    end

    local isDeathByPC = 0;
    local killer = GetKiller(pc);
    if killer ~= nil then
        killer = GetTopOwner(killer);
        if IS_PC(killer) == true then
            isDeathByPC = 1;
        end
    end

    BEGONE_CONSUMEDUR(pc, enableDeadDurabilityConsume, deathPenaltyBuffLevel, isDeathByPC)

    local mapCls = GetMapProperty(pc);
    local deathPenalty = mapCls.DeathPenalty;

    if enableDeadDurabilityConsume ~= 1 or deathPenalty == "None" or isDeathByPC ~= 0 then
        return;
    end

    local penaltyList = TokenizeByChar(deathPenalty, "#");
    
    for i = 1, #penaltyList do
        local penaltyType = penaltyList[i];
        if string.find(penaltyType, 'Gem') ~= nil or
--            string.find(penaltyType, "Card") ~= nil or   
            string.find(penaltyType, "Blessstone") ~= nil then
            BEGONE_DROP_INV_ITEM(pc, deathPenaltyBuffLevel, penaltyType);

        elseif string.find(penaltyType, "Silver") ~= nil then
            local stringLen = string.len(penaltyType);
            local subString = string.sub(penaltyType, 7, stringLen);
            local silverDropRatio = tonumber(subString);
            BEGONE_DROP_VIS(pc, deathPenaltyBuffLevel, silverDropRatio);
        end
    end
end


--죽어서 떨어진 아이템 다시 먹었을 때, 복구는 여기서 해준다.
function DAED_DROP_ITEM_SET_EXP(pc, mon, obj)
    if pc == nil or mon == nil or obj == nil then
        return;
    end

    local gemRoastingLv = GetExProp(mon, "GemRoastingLv");
    local itemExp = GetExProp(mon, "gemExpTemp");
    local itemLv = GET_ITEM_LEVEL_EXP_BYCLASSID(obj.ClassID, itemExp);
    local belongingCount = GetExProp(mon, "BelongingCount");
    local itemLvPropName = 'GemLevel';
    if obj.GroupName == 'Card' then
        itemLvPropName = 'CardLevel';
    end
        
    if itemExp == 0 and gemRoastingLv == 0 and belongingCount == 0 then
        return;
    end

    local tx = TxBegin(pc); 
    if tx == nil then
        return;
    end
        
    TxEnableInIntegrateIndun(tx);

    if belongingCount > 0 then
        TxSetIESProp(tx, obj, 'BelongingCount', belongingCount);
    end

    if itemExp > 0 then
        TxSetIESProp(tx, obj, 'ItemExp', itemExp);
        TxSetIESProp(tx, obj, itemLvPropName, itemLv);
    end

    if gemRoastingLv > 0  then
        TxSetIESProp(tx, obj, 'GemRoastingLv', gemRoastingLv);
    end
        
    local ret = TxCommit(tx);
    InvalidateItem(obj);
end



function COMMON_POST_BEATTACKED(pc, from, damage, skill, ret)   

    
    if IsBuffApplied(pc, 'Double_pay_earn_Buff') == 'YES' then
        local Dpeskill = GetSkill(pc, 'Doppelsoeldner_Double_pay_earn')

        if GetAbility(pc, 'Doppelsoeldner1') ~= nil then
            ret.Damage = damage * 2
        else
            ret.Damage = damage * 3
        end
    end
    
    
    if IsBuffApplied(pc, 'Cleric_Flins_Buff') == 'YES' then
        local Flinsskill = GetSkill(pc, 'Cleric_Flins')
        local random = IMCRandom(1, 100)
        local flinsrandom = 100 + (Flinsskill.Level * 5)
        if random <= flinsrandom then 
            local Range = 100;
            local objList, objCount = SelectObjectNear(pc, pc, Range, 'ENEMY');
            for i = 1, objCount do
                local obj = objList[i];
                AddBuff(pc, obj, 'Cleric_Flins_Debuff', 0, 0, 0, 1);
                AttachEffect(pc, 'F_cleric_flins_spread_out', 5, 'BOT');
            end  
        end             
    end
        
    local Highlander8_abil = GetAbility(pc, "Highlander8")
    if Highlander8_abil ~= nil then
        if IsBuffApplied(pc, 'CrossGuard_Buff') == 'YES' then
            local heatListCount = GetHatListCount(pc)
            if heatListCount > 2 then
                ret.Damage = ret.Damage - (ret.Damage * (Highlander8_abil.Level * 0.1))
            end
        end
    end

        
    return ret.Damage;
    
end


function Reflect_Sync(self, from, skill, dmg, ret)
    sleep(250)
    DamageReflect(self, from, 'Wizard_ReflectShield', dmg, "Melee", "Magic", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW);
end

function CARD_REFLECT_SYNC(self, from, skill, dmg, ret)
    sleep(250)
    DamageReflect(self, from, "None", dmg, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
--    TakeDamage(self, from, "None", dmg, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
end


function Revenged_Sync(self, from, skill, dmg, ret, caster)
    sleep(250)
    PlayEffect(from, "F_wizard_RevengedSevenfold_Buff2", 0.3)
    for i = 1, 7 do
        sleep(50)
        DamageReflect(self, from, 'None', dmg, "Holy", "Magic", "Magic", HIT_REFLECT, HITRESULT_BLOW);
--        TakeDamage(self, from, 'None', dmg, "Holy", "Magic", "Magic", HIT_REFLECT, HITRESULT_BLOW);
    end
    
    if caster ~= nil then
        local abil = GetAbility(caster, "Kabbalist2");
        if abil ~= nil and IMCRandom(1, 9999) < abil.Level * 800 then
            AddBuff(caster, from, 'Hexing_Debuff', 1, 0, 4000, 1);
        end
    end
    
end


function SubzeroShield_sync(self, from, skill, dmg, ret, caster)

    sleep(400)
    TakeDamage(self, from, 'None', dmg, "Ice", "Magic", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW);
    local freezeTime = 3000
    local abil = GetAbility(self, "Cryomancer7")
    if abil ~= nil then
      freezeTime = freezeTime + abil.Level * 500
    end
    
    local realAttacker = GetExProp(from, 'REAL_ATTACKER_HANDLE');
    if 0 > realAttacker then -- B1238823 
        local pet = GetByHandle(from, realAttacker);
        if nil ~= pet then
            AddBuff(self, pet, "Cryomancer_Freeze", 1, 0, freezeTime, 1);
            return;
        end
    end

    AddBuff(self, from, "Cryomancer_Freeze", 1, 0, freezeTime, 1);
end

function SCR_COMMON_POST_KILL(self, from, skill, ret, over)
    
    local owner = nil
    
    if from.ClassName ~= 'PC' then
        if GetOwner(from) ~= nil and GetOwner(from).ClassName == 'PC' then
            from = GetOwner(from)
        else
            return;
        end
    end
    
    local War_abil3 = GetAbility(from, 'ruptureattack');
    if War_abil3 ~= nil and skill.AttackType == 'Strike' then
        local RandomRating = IMCRandom(0, 100)
        local abil13rating = War_abil3.Level * 5
        if abil13rating > RandomRating then
            PlayEffect(self, 'explosion_burst');
            
            local bombRange = 30;
            local bombDamage = (from.MINPATK + from.MAXPATK) / IMCRandomFloat(2, 2.5) * (1 + (War_abil3.Level * 0.2))
            local objList, objCount = SelectObjectNear(from, self, bombRange, 'ENEMY');
            
            for i = 1, objCount do
                local obj = objList[i];
                TakeDamage(from, obj, skill.ClassName, bombDamage, "None", "None", "Melee", HIT_REFLECT, HITRESULT_BLOW);
            end
        end
    end
    
    -- kill DivineStigma_Debuff monster
    if IsBuffApplied(self, 'DivineStigma_Debuff') == 'YES' and IS_PC(from) == true then
        local buff = GetBuffByName(self, 'DivineStigma_Debuff');        
        local sklLv, abilLv = GetBuffArgs(buff);
        local bufftime = 60000;
        if abilLv > 0 then
            bufftime = bufftime + abilLv * 6000;
        end
        
        if sklLv > 0 then
            AddBuff(from, from, 'DivineStigma_Buff', sklLv, 0, bufftime, 1);
            local objList, objCount = GetPartyMemberList(from, PARTY_NORMAL, 200)
            for i = 1, objCount do
                local obj = objList[i]; 
                if obj ~= nil then
                    AddBuff(from, obj, 'DivineStigma_Buff', sklLv, 0, bufftime, 1);
                else
                    AddBuff(from, from, 'DivineStigma_Buff', 1, 0, bufftime, 1);
                end
            end
        end
    end


    if skill.Attribute == 'Fire' and IMCRandom(1,9999) < 3000 then
    local Elementalist7_abil = GetAbility(from, "Elementalist7")
        if Elementalist7_abil ~= nil then
            local objList, objCount = SelectObjectByFaction(self, 40, 'Monster')
            
            if objCount > 10 then
                objCount = 10
            end
            
            local key = GenerateSyncKey(from)
            StartSyncPacket(from, key);
            PlayEffect(self, 'F_buff_explosion_burst', 1.3);
            
            if objCount ~= nil or objList ~= nil then
                for i = 1, objCount do
                    local obj = objList[i];
                    TakeDamage(from, obj, 'None', ret.Damage * 0.8, "Melee", "Magic", "Magic", HIT_REFLECT, HITRESULT_BLOW);
                end
            end
            
            EndSyncPacket(from, key, 0.4);
            ExecSyncPacket(from, key);
        end
    end
    
    if skill.Attribute == 'Ice' and IMCRandom(1,9999) < 5000 then
        local Elementalist8_abil = GetAbility(from, "Elementalist8")
        if Elementalist8_abil ~= nil then
            local objList, objCount = SelectObjectByFaction(self, 50, 'Monster')
            
            if objCount > 10 then
                objCount = 10
            end
            
            local key = GenerateSyncKey(from)
            StartSyncPacket(from, key);
            PlayEffect(self, 'F_buff_ice_spread', 1.0);
            
            if objCount ~= nil or objList ~= nil then
                for i = 1, objCount do
                    local obj = objList[i];
                    AddBuff(from, obj, 'UC_slowdown', 1, 0, 6000, 1);
                end
            end
            
            EndSyncPacket(from, key, 0.4);
            ExecSyncPacket(from, key);
        end
    end

    local Inquisitor1_abil = GetAbility(from, 'Inquisitor1');
    if TryGetProp(self, "RaceType") ~= "Item" then
        if Inquisitor1_abil ~= nil and IMCRandom(1,9999) < Inquisitor1_abil.Level * 100 then
            local key = GenerateSyncKey(from)
            StartSyncPacket(from, key);
            local px, py, pz = GetPos(self)
            RunPad(from, "Inquisitor_FireWall", nil, px, py, pz, 0, 1);
            EndSyncPacket(from, key, 0.3);
            ExecSyncPacket(from, key);
        end
    end
    
    if IsBuffApplied(self, 'GatherCorpse_Debuff') == 'YES' and IS_PC(self) == false then
        local buff = GetBuffByName(self, 'GatherCorpse_Debuff');
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            if IS_PC(caster) == true then
                local addDPartsResult = NECRO_ADD_DEADPARTS(caster, self.ClassID);
                if addDPartsResult == 1 then
                    local key = 0;
                    if ret ~= nil then
                        key = GetSkillSyncKey(caster, ret);
                        StartSyncPacket(caster, key);
                    end
                    
                    PlayDeadPartsGather(caster, self);
                    PlaySound(caster, "skl_eff_gathercorpse_whoosh")
                    PlaySound(caster, "skl_eff_partscapture_finish")
                    
                    if ret ~= nil then
                        EndSyncPacket(caster, key);
                    end
                end
            end
        end
    end
end

function SCR_COMMON_POST_HIT(self, from, skill, ret)

    if IsBuffApplied(self, 'Invincible') == 'YES' then 
        ret.HitType = HIT_SHIELD;
    end
    
    if IsBuffApplied(self, 'SafetyZone_Buff') == 'YES' or IsBuffApplied(self, 'StereaTrofh_Buff') == 'YES' then 
        ret.HitType = HIT_SAFETY;
    end
    
    if IsBuffApplied(self, 'Magic_Shield') == 'YES' and skill.ClassType == 'Magic' then
        ret.Damage = 0;
        ret.ResultType = HITRESULT_NONE;
        ret.KDPower = 0;
        ret.HitType = HIT_SAFETY;
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        SkillTextEffect(nil, self, from, "SHOW_GUNGHO", nil);
    end
    
    if IsBuffApplied(self, 'CounterSpell_Buff') == 'YES' and skill.ClassType == 'Magic' then
        ret.Damage = 0;
        ret.ResultType = HITRESULT_NONE;
        ret.KDPower = 0;
        ret.HitType = HIT_SAFETY;
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        SkillTextEffect(nil, self, from, "SHOW_GUNGHO", nil);
    end
    
    if skill.ClassName == 'Archer_Fulldraw' and self.ArmorMaterial == 'Leather' then
        local ratio = 50
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end
    
    if skill.ClassName == 'Archer_HeavyShot' and self.ArmorMaterial == 'Iron' then
        local ratio = 50
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end
    
    if skill.ClassName == 'QuarrelShooter_StoneShot' and self.ArmorMaterial == 'Iron' then
        local ratio = 50
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end

    if skill.ClassName == 'Ranger_TimeBombArrow' and self.ArmorMaterial == 'Iron' then
        local ratio = 50
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end

    if skill.ClassName == 'Fletcher_BodkinPoint' and self.ArmorMaterial == 'Leather' then
        local ratio = 50
        SkillTextEffect(nil, self,from,  'SHOW_SKILL_BONUS2', ratio, nil, skill.ClassID);
    end
end

function APPLY_DAMAGE_FIX_RATE(ret, damageFixRate)
    if damageFixRate < -100  then
        damageFixRate = -95;
    end

    ret.Damage = ret.Damage * (100 + damageFixRate) / 100;
end

function SCR_CASTLE_BATTLE_CALC(self, from, ret, skill)
    local damageFixRate = from.ATK_COMMON_BM - self.DEF_COMMON_BM;
    if damageFixRate ~= 0 then
        APPLY_DAMAGE_FIX_RATE(ret, damageFixRate);
    end
end

function SCR_ATTRIBUTE_DAMAGE_CALC(self, from, ret, skill, rateTable)
    local armorMaterial = 'None';
    if IS_PC(self) == false then
        armorMaterial = self.ArmorMaterial;
    else
        local equipbodyItem     = GetEquipItem(self, 'SHIRT');
        armorMaterial           = equipbodyItem.Material;       
    end
    
    local atkAttribute  = skill.Attribute;
    local atkType       = skill.AttackType;
    local clsType       = skill.ClassType;
    local size          = self.Size;
    
    if IsBuffApplied(from, 'Finestra_Buff') == 'YES' and skill.ClassName == 'Normal_Attack' then
        atkType = 'Aries';
    end 
    
    if IS_PC(from) == true and IsUsingNormalSkill(from) == 1 and IsNormalSKillBySkillID(from, skill.ClassID) == 1 then
        if GetJobObject(from).CtrlType ~= 'Wizard' then
            local equipWeapon = GetEquipItem(from, 'RH');
            if equipWeapon ~= nil and IS_NO_EQUIPITEM(equipWeapon) == 0 then
                --atkAttribute  = equipWeapon.Attribute;
                atkType         = equipWeapon.AttackType;
            end
        end
        
    end
    
    local addDamage = 0;
    local cls = GetClass('skill_attribute', atkAttribute);
    ret.AttributeType = cls.ClassID;
    
    
    if cls ~= nil and TryGetProp(cls, self.Attribute) ~= nil and cls[self.Attribute] ~= 0 then
        
        local clsRate = cls[self.Attribute]
        local rate = 0;
        
        rate = clsRate;
        
        if rate > 0 and IS_PC(self) then            
            rate = rate - (self['Res'..atkAttribute] / 2);
            if rate < 0 then
                rate = 0;
            end
        end
        
        if rate < 0 then
            local attributePenaltyReductionRate = GetExProp(from, 'CARD_ATTRIBUTE_PENALTY_REDUCTION');
            if attributePenaltyReductionRate == nil then
                attributePenaltyReductionRate = 0;
            end
            
            rate = rate - (rate * (attributePenaltyReductionRate / 100));
        end
        
        
        
        rateTable.AttributeRate = (rate / 100);
        addDamage = rate * ret.Damage / 100;
        if addDamage ~= 0 then
            SkillTextEffect(nil, self, from, 'SHOW_SKILL_ATTRIBUTE', rate, nil, atkAttribute);
        end
    end
    
    cls = GetClass('skill_attribute', atkType);
    ret.AtkType = cls.ClassID;
    if cls ~= nil and armorMaterial ~= 'None' and cls[armorMaterial] ~= 0 then
        local clsRate = cls[armorMaterial]
        local rate = 0;
        
        rate = clsRate;
        
        if rate > 0 then
            if IS_PC(self) then
                local atkTypeDefense = TryGetProp(self, 'Def'..atkType);
                if atkTypeDefense == nil then
                    atkTypeDefense = 0;
                end
                
                rate = rate - (atkTypeDefense / 2);
                if rate < 0 then
                    rate = 0;
                end
            end
        end
        rateTable.AttackTypeRate = (rate / 100);
        addDamage = (rate * ret.Damage / 100);
        
        if addDamage ~= 0 then
            SkillTextEffect(nil, self, from, 'SHOW_SKILL_ATTRIBUTE', rate, nil, atkType);
            ret.EffectType = HITEFT_NICE;
        end
    end
    
--    cls = GetClass('skill_attribute', clsType);
--    if cls ~= nil and size ~= 'None' and clsType == 'Missile' and clsType == 'Gun' and clsType == 'Cannon' and IS_PC(from) == true then
--        local clsRate = cls[size] 
--        local rate = 0;
--        cls2 = GetClass('skill_attribute', atkType);
--        local clsRate2 = cls2[armorMaterial]
--        rate = clsRate;
--        rateTable.AttackTypeRate = (rate / 100);
--        addDamage = (rate * ret.Damage / 100);
--    end
    
    return addDamage;
end

function SCR_CHAINSKILL_CALC(self, from, ret, skill)
    
    local bonus = ApplyChainBonus(from, self, skill, ret);
    if bonus > 1 then
        return ret.Damage * (bonus-1);
    end

    return 0;
end



function SCR_ADD_ATTACK_CALC(self, from, skill, rateTable)
    local raceAddATK = 0;
    local attackTypeAddATK = 0;
    local materialAddATK = 0;
    local sizeAddATK = 0;
    
    -- pc -> monster
    if IS_PC(from) == true and IS_PC(self) ~= true then
        
        -- RaceType
        local raceList = { "Widling", "Forester", "Paramune", "Velnias", "Klaida" };
        local defenderRaceType = TryGetProp(self, "RaceType");
        for i = 1, #raceList do
            if defenderRaceType == raceList[i] then
                raceAddATK = TryGetProp(from, raceList[i].."_Atk");
                if raceAddATK == nil then
                    raceAddATK = 0;
                end
                
                break;
            end
        end
        
        -- AttackType
        local attackTypeList = { "Aries", "Slash", "Strike" };
        local attackType = GET_SKILL_ATTACKTYPE(skill);
        for i = 1, #attackTypeList do
            if attackType == attackTypeList[i] then
                attackTypeAddATK = TryGetProp(from, attackTypeList[i].."_Atk");
                if attackTypeAddATK == nil then
                    attackTypeAddATK = 0;
                end
                
                break;
            end
        end
        
        -- ArmorMaterial
        local materialList = { "Cloth", "Leather", "Chain", "Iron", "Ghost" };
        local defenderMaterial = TryGetProp(self, "ArmorMaterial");
        for i = 1, #materialList do
            if defenderMaterial == materialList[i] then
                materialAddATK = TryGetProp(from, materialList[i].."_Atk");
                if materialAddATK == nil then
                    materialAddATK = 0;
                end
                
                if defenderMaterial == "Cloth" then
                    materialAddATK = materialAddATK + GetExProp(self, "ADD_FLARE_DAMAGE");
                elseif defenderMaterial == "Leather" then
                    materialAddATK = materialAddATK + GetExProp(self, "ADD_ICEBLAST_DAMAGE");
                end
                
                break;
            end
        end
        
        -- Size
        local sizeList = { { "S", "SmallSize_Atk" }, { "M", "MiddleSize_Atk" }, { "L", "LargeSize_Atk" }, { "XL", "LargeSize_Atk" } };
        local defenderSizeType = TryGetProp(self, "Size");
        for i = 1, #sizeList do
            if defenderSizeType == sizeList[i][1] then
                sizeAddATK = TryGetProp(from, sizeList[i][2]);
                if sizeAddATK == nil then
                    sizeAddATK = 0;
                end
                
                break;
            end
        end
    end
    
    local addAttributeATK = raceAddATK + attackTypeAddATK + materialAddATK + sizeAddATK;
    
    return addAttributeATK;
end



function SCR_ADD_DEFENCE_CALC(self, from, skill, rateTable)
    --AttackType
    local atkTypeDEF = 0;
    local atkType = TryGetProp(skill, "AttackType");
    if atkType == nil then
        return 0;
    end
    
    if IS_PC(from) == true then
        local jobObj = GetJobObject(from);
        if jobObj == nil then
            return 0;
        end
        
        if IsUsingNormalSkill(from) == 1 and IsNormalSKillBySkillID(from, skill.ClassID) == 1 and jobObj.CtrlType ~= 'Wizard' then
            local equipWeapon = GetEquipItem(from, 'RH');
            if equipWeapon ~= nil and IS_NO_EQUIPITEM(equipWeapon) == 0 then
                atkType = TryGetProp(equipWeapon, "AttackType");
                if atkType == nil then
                    return 0;
                end
            end
        end
    end
    
    if IS_PC(self) == true then
        atkTypeDEF = TryGetProp(self, "Def"..atkType);
        if atkTypeDEF == nil then
            atkTypeDEF = 0;
        end
    end
    
    --Attrubute
    local attributeDEF = 0;
    
    local atkAttribute = TryGetProp(skill, "Attribute")
    if atkAttribute ~= nil and atkAttribute ~= "None" and atkAttribute ~= "Melee" then
        if IS_PC(self) == true then
            attributeDEF = TryGetProp(self , "Res"..atkAttribute);
        else
            attributeDEF = TryGetProp(self , atkAttribute.."_Def");
        end
        
        if attributeDEF == nil then
            attributeDEF = 0;
        end
    end
    
    local addDEF = atkTypeDEF + attributeDEF;
    
    return addDEF;
end



function SCR_ADD_DAMAGE_CALC(self, from, skill, rateTable)
    local attrList = {'Fire', 'Ice', 'Lightning', 'Poison', 'Dark', 'Holy', 'Earth', 'Soul'}
    local capitalAttrList = {'FIRE', 'ICE', 'LIGHTNING', 'POISON', 'DARK', 'HOLY', 'EARTH', 'SOUL'}
    
    local attrResult = 0;
    
    for i = 1, #attrList do
        local attrAtk = 0;
        local attrRes = 0;
        local attrDamage = 0;
        
        if IS_PC(from) == true then
            attrAtk = TryGetProp(from , attrList[i].."_Atk");
            if attrAtk == nil then
                attrAtk = 0;
            end
        else
            attrAtk = TryGetProp(from , "ADD_"..capitalAttrList[i]);
            if attrAtk == nil then
                attrAtk = TryGetProp(from , string.upper("ADD_"..capitalAttrList[i]));
                if attrAtk == nil then
                    attrAtk = 0;
                end
            end
        end
        
        local addAttributeDamage = rateTable["AddAttributeDamage"..attrList[i]];
        
        attrAtk = attrAtk + addAttributeDamage;
        
        if attrAtk > 0 then
            if IS_PC(self) == true then
                attrRes = TryGetProp(self , "Res"..attrList[i]);
                
--                if attrAtk > 0 and attrRes > 0 then
--                    textEffect = "Res"..attrList[i].."_BM"
--                    SkillTextEffect(self, self, from, 'SHOW_ATTRIBUTE_RESIST', attrRes, nil, textEffect);
--                end
            else
                attrRes = TryGetProp(self , attrList[i].."_Def");
            end
            
            if attrRes == nil then
                attrRes = 0;
            end
            
            if attrRes < 0 then
                attrRes = 0;
            end
            
            attrDamage = attrAtk * math.min(1, math.log10((attrAtk / (attrRes + 1)) ^ 0.9 + 1));
            
            local defenderAttribute = TryGetProp(self, "Attribute");
            if defenderAttribute ~= 'Melee' and defenderAttribute ~= nil then
                local cls, cnt = GetClassList('skill_attribute');
                local attrCls = GetClassByNameFromList(cls, attrList[i]);
                local attrRate = TryGet(attrCls, defenderAttribute);
                
                if attrRate ~= nil and attrRate ~= 0 then
--                  SkillTextEffect(ret, self, from, 'SHOW_SKILL_ATTRIBUTE', attrRate * 100, nil, attrList[i]);
                    attrDamage = attrDamage + attrDamage * (attrRate / 100);
                end
            end
            
            if attrResult < 1 then
                attrResult = 0;
            end
            
            attrResult = attrResult + attrDamage;
        end
    end
    
    return attrResult;
end



function SCR_LIB_CHECK_BLK(self, from, ret, skill, rateTable)
    if rateTable.EnableBlock == 0 then
        return 0;
    end
    
    if IsKnockDownState(self) == 1 then
        return 0;
    end
    
    local abilMatador3 = GetAbility(self, "Matador3")
    if abilMatador3 ~= nil and abilMatador3.ActiveState == 1 then
        return 0;
    end
    
    if rateTable.blkResult == 1 then
        ret.Damage = 0;
        ret.HitType = HIT_BLOCK;
        ret.ResultType = HITRESULT_BLOCK;
        SetExProp(from, "CHECK_SKL_KD_PROP", 1);
        return 1;
    end
    
    if GetExProp(self, "NotRet") ~= 1 then
        -- 마법 공격 체크 --
        local checkMagic = 1;
        if skill.ClassType == "Magic" then
            checkMagic = 0;
            
            if rateTable.EnableMagicBlock == 1 then
                checkMagic = 1;
            end
            
            if GetExProp(self, "ABIL_KABBALIST22_ON") == 1 then
                checkMagic = 1;
                rateTable.MagicBlockRate = rateTable.MagicBlockRate - 0.5;
            end
        end
        
        -- 트루 대미지 체크 --
        local checkTrue = 1;
        if skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
            checkTrue = 0;
        end
        
        if checkMagic == 1 and checkTrue == 1 then
            local blkLimit = 6666;
            local blk = (math.max(0, self.BLK - from.BLK_BREAK) ^ 0.7) * 100;
            
            if IS_PC(self) == true then
                local state = GetActionState(self);
                
                if state == 'AS_GUARD' then
                    blkLimit = 9000;
                end
            end
            
            if blkLimit > 9000 then
                blkLimit = 9000;
            end
            
            local QuarrelShooter8_abil = GetAbility(self, "QuarrelShooter8")
            local lItem  = GetEquipItem(self, 'LH');
            if QuarrelShooter8_abil ~= nil and skill.ClassType == "Missile" and lItem.ClassType == "Shield" then
                blk = blk + 5000
            end
            
            local addBlkBreak = GetExProp(from, "ABIL_BLKBREAK_ADD")
            blk = blk + rateTable.blkAdd - addBlkBreak;
            
            local shieldrate = GetSumOfEquipItem(self, 'BlockRate');
            if shieldrate > 0 then
                blk = blk + (shieldrate * 100)
            end
            
            -- 블록 확률 최종값 비율 조정 --
            blk = blk * rateTable.BlockRate;
            
            if skill.ClassType == "Magic" then
                blk = blk * rateTable.MagicBlockRate;
            end
            
            blk = MinMaxCorrection(blk, 0, blkLimit)
            
            local blkRate = IMCRandom(1, 10000);
            if blkRate < blk or rateTable.abilityBuffShield == 1 then
                
                if QuarrelShooter8_abil ~= nil and skill.ClassType == "Missile" and lItem.ClassType == "Shield" then
                    AddBuff(self, self, 'QuarrelShooter8_Buff', QuarrelShooter8_abil.Level, lItem.DEF, 10000, 1);
                end
                
                -- Peltasta_UmboBlow
                if IS_PC(self) == true and GetSkill(self, 'Peltasta_UmboBlow') ~= nil then
                    AddBuff(self, from, 'Guard_Debuff', 1, 0, 4000, 1);
                end
                
                -- Highlander_CrossGuard
                if IsBuffApplied(self, 'CrossGuard_Buff') == 'YES' then
                    local time = 6000
                    local Highlander1_abil = GetAbility(self, "Highlander1")
                    if Highlander1_abil ~= nil then
                        time = time + Highlander1_abil.Level * 1000
                    end
                    AddBuff(self, from, 'CrossGuard_Debuff', 1, 0, time, 1);
                end
                
                -- Peltasta_Langort
                if IsBuffApplied(self, 'Langort_BlkAbil') == 'YES' then
                    AddBuff(self, from, 'UC_silence', 1, 0, 3000, 1);
                end

                ret.Damage = 0;
                ret.HitType = HIT_BLOCK;
                ret.ResultType = HITRESULT_BLOCK;

--              -- PhalanxFormation_Buff
--              local phalanxBuff = GetBuffByName(self, "PhalanxFormation_Buff");
--              if phalanxBuff ~= nil then
--                  local propValue = GetExProp(phalanxBuff, 'BLK_BM');
--                  if propValue > 0 then
--                      local key = GenerateSyncKey(from)
--                      StartSyncPacket(from, key);
--                      PlayEffect(self, 'F_buff_Warrior_PhalanxFomation_Buff', 0.5);
--                      EndSyncPacket(from, key, ret.HitDelay / 1000);
--                      ExecSyncPacket(from, key);
--                  end
--                  
--                  local abilLv = GetBuffArgs(phalanxBuff);
--                  if abilLv > 0 then
--                      AddBuff(self, from, 'UC_slowdown', 1, 0, abilLv * 4000, 1);
--                  end
--              end
                return 1;
            end
        end 
        DelExProp(self, "NotRet")
    end

    return 0;
end



function SCR_SKILLHIT_COMMON(self, from, ret, skill, rateTable, fixHitType)    
    
    SCR_CASTLE_BATTLE_CALC(self, from, ret, skill); 
    SCR_SKILL_SPECIAL_CALC(self, from, ret, skill, rateTable);  
    SCR_ATTRIBUTE_DAMAGE_CALC(self, from, ret, skill, rateTable);
    
    if GetShield(self) > 0 and ret.Damage > 0 then
        ret.HitType = HIT_SHIELD;
    end
    -- HitType
    if ret.HitType == HIT_BASIC or ret.HitType == HIT_BASIC_NOT_CANCEL_CAST then
    
        if skill.ClassType == "Effigy" then
            ret.HitType = HIT_STABDOLL;          
        elseif skill.ClassType == "CountDown" then
            ret.HitType = HIT_COUNTDOWN;
        elseif skill.ClassType == "Reflect" then
            ret.HitType = HIT_STABDOLL;
        elseif skill.ClassType == "Telekinesis" then
            ret.HitType = HIT_TELEK;
        elseif skill.ClassType == "NeuroToxin" then
            ret.HitType = HIT_POISON_VIOLET;
        else

            -- TakeDamage에서 고정으로 hitType사용하는것이 아니라면 속성에 따른 hitType 체크
            if fixHitType > 0 then
                ret.HitType = fixHitType;
            else
                if skill.Attribute == "Fire" then
                    ret.HitType = HIT_FIRE;
                elseif skill.Attribute == "Ice" then
                    ret.HitType = HIT_ICE;
                elseif skill.Attribute == "Poison" then
                    ret.HitType = HIT_POISON;
                elseif skill.Attribute == "Lightning" then
                    ret.HitType = HIT_LIGHTNING;
                elseif skill.Attribute == "Earth" then
                    ret.HitType = HIT_EARTH;
                elseif skill.Attribute == "Soul" then
                    ret.HitType = HIT_SOUL;
                elseif skill.Attribute == "Holy" then
                    ret.HitType = HIT_HOLY;
                elseif skill.Attribute == "Dark" then
                    ret.HitType = HIT_DARK;
                end
            end
        end
    end
    
    if self.MaxDefenced_BM > 0 then 
        ret.Damage = 0;
        ret.ResultType = HITRESULT_INVALID;
        ret.HitType = HIT_NOMOTION;
        ret.KDPower = 0;
        ret.EffectType = HITEFT_SAFETY;
    end
end

function SCR_SKILL_SPECIAL_CALC(self, from, ret, skill, rateTable)
    
    if IsBuffApplied(self, 'ShieldPush_Debuff') == 'YES' and ret.HitType == HIT_KNOCKDOWN then
        rateTable.DamageRate = rateTable.DamageRate + 0.5;
    end
    
    --  pc -> monster
    if skill.ClassType == 'Melee' and IsBuffApplied(self, 'Archer_BleedingToxin_Debuff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
        ret.HitType = HIT_WUGU_BLOOD;
    end
    
    if skill.ClassType == 'Magic' and IsBuffApplied(self, 'Archer_NeuroToxin_Debuff') == 'YES' then
        rateTable.DamageRate = rateTable.DamageRate + 0.3;
        ret.HitType = HIT_WUGU_POISON;
    end
    
    if IsBuffApplied(self, 'Cleric_Bless_Debuff') == 'YES' and skill.Attribute == 'Holy' then
        ret.Damage = ret.Damage + (ret.Damage * 0.4);
    end
    
    if self.ClassName == 'pavise' then
        ret.ResultType = HITRESULT_BLOCK;
        self.HPCount = self.HPCount - 1
        if self.HPCount <= 0 then 
            Dead(self);
        end
    end
    
    
    -- SafetyZone
    if IsBuffApplied(self, 'SafetyZone_Buff') == 'YES' then
        
        local buff = GetBuffByName(self, 'SafetyZone_Buff');
        local caster = GetBuffCaster(buff);
        local count = GetExProp(self, 'SAFETY_COUNT')
        if caster ~= nil then
            local pad = GetPadByBuff(caster, buff);
            if pad ~= nil then
                ret.HitType = HIT_SAFETY;
                AddPadUseCount(pad, -1);
            end
        end
    end
    
    if IsBuffApplied(self, 'StereaTrofh_Buff') == 'YES' then
        ret.HitType = HIT_SAFETY;
    end         
end


function SCR_KD_NEAR_DAMAGE(self, from, nearDmg)
    
    local range = GetExProp(from, "NEAR_RANGE");
    if range < 25 then
        range = 25;
    end

    local objList, objCount = SelectObject(self, range, 'ALL');
    for i = 1, objCount do
        local obj = objList[i];
        if GetRelation(obj, from) == "ENEMY" then
            TakeDamage(from, obj, "None", nearDmg);
        end 
        
    end
end

function SCR_KB_NEAR_DAMAGE(self, from, nearDmg)
    
    local range = GetExProp(from, "NEAR_RANGE");
    if range < 25 then
        range = 25;
    end
    local objList, objCount = SelectObject(self, range, 'ALL');
    for i = 1, objCount do
        local obj = objList[i];

        if GetRelation(obj, from) == "ENEMY" then
            
            if GetKBNearDamage(obj) == 0 then
                if GetKBNear(obj) == 0 then
                    TakeDamage(from, obj, "None", nearDmg);
                    local angle = GetAngleTo(self, obj);
                    KnockBack(obj, from, 5, angle, 45, 1);
                    SetKBNear(obj, 1);
                end
            end
        end
    end

end


function GET_NEAR_MONSTER_MINATK(self)
    
    local minDmg = 0;   
    local range = 50;   
    local objList, objCount = SelectObject(self, range, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        
        minDmg = minDmg + obj.MINPATK;
    end

    return minDmg;
end


function HITSCP_DUMMY(self, from, skill, splash, ret)
    NO_HIT_RESULT(ret);
end

function HITSCP_MOTION(self, from, skill, splash, ret)
    ret.Damage = 0;
    ret.ResultType = HITRESULT_BLOW;
    ret.HitType = HIT_MOTION;
    ret.EffectType = HITEFT_NORMAL;
    ret.HitDelay = 0;
end

function NO_HIT_RESULT(ret)
    ret.Damage = 0;
    ret.ResultType = HITRESULT_NONE;
    ret.HitType = HIT_NOHIT;
    ret.EffectType = HITEFT_NO;
    ret.HitDelay = 0;

end


function HOLD_MON_SCP(mon, second)
    HoldScpForMS(mon, second);
end



function GetLimitedLevelDiff(self, from, arg)

    local diff = from.Lv - self.Lv;
    local calc = math.min(math.max(diff, -1 * arg), arg);
    if self.Lv < 10 and from.Lv < 10 then
        calc = 0;
    end

    return calc;

end

function GetMinusSquare(arg)

    if arg < 0 then
        return arg^2 * -1;
    else
        return arg^2;
    end

end

function SKILL_KNOCKDOWN(ret, kdPower, kdAngle)

    ret.HitType = HIT_KNOCKDOWN;
    ret.KDPower = kdPower;
    ret.KDVAngle = kdAngle;
    ret.KDHAngle = 0;

end

function TUTO_PROPERTYBOOK_CK(self)
    
    local abilList, cnt = GetClassList('Ability');  
    if cnt == 0 then
        return;
    end

    local haveAbilCount = 0;
    for i=0, cnt-1 do
        local abil = GetClassByIndexFromList(abilList, i);
        local isHave = GetAbility(self, abil.ClassName);
        if isHave ~= nil then
            haveAbilCount = haveAbilCount + 1;
        end

    end

    return haveAbilCount;
end

function TUTO_SKILL_CK(self)
    local skillList, cnt = GetClassList('Skill');   
    if cnt == 0 then
        return 0;
    end
    local haveAbilCount = 0;
    for i=0, cnt-1 do
        local skill = GetClassByIndexFromList(skillList, i);
        if skill.ClassID > 10000 and skill.ClassID <= 49999 then
            local isHave = GetSkill(self, skill.ClassName);
            if isHave ~= nil then
                return 1;
            end
        end
    end
    return 0;
end

function CalcUserControlMonsterStat(mon, str, con, int, mna, dex)
    local allStat = str + int + dex + con + mna;
    
    mon.STR_Rate = str/allStat * 25;
    mon.CON_Rate = con/allStat * 25;
    mon.INT_Rate = int/allStat * 25;
    mon.MNA_Rate = mna/allStat * 25;
    mon.DEX_Rate = dex/allStat * 25;
end


-- FeverCombo
function SCR_FEVERCOMBO(self, pc)
    local feverCombo = GetFeverCombo(self) + 1; -- Add하기 전에 이 함수로 들어오기 때문에 실질적으로는 1을 더해줘야함
    local maxFeverCombo = GET_FEVER_MAXCOUNT(pc);
    
    if feverCombo > maxFeverCombo then
        return maxFeverCombo;
    end
    
    if feverCombo >= 1 and feverCombo >= maxFeverCombo then 
        if feverCombo >= maxFeverCombo and GetExProp(self, 'FEVER_BUFF') ~= 1 then
            local owner = GetOwner(self);
            SetFeverComboTerm(self, pc, feverCombo, 10, maxFeverCombo);
            if owner ~= nil then
                AddBuff(owner, pc, 'FeverTime', feverCombo, maxFeverCombo, 10000, 1);
            end
            SetExProp(self, 'FEVER_BUFF', 1);
        end
    else
        SetFeverComboTerm(self, pc, feverCombo, 5, maxFeverCombo);
    end

    return maxFeverCombo;
end

function GET_FEVER_MAXCOUNT(self)

    local maxCombo = 300;

    local list, cnt = GET_PARTY_ACTOR_BY_SKILL(self, 200)   
    if cnt > 0 then
        maxCombo = maxCombo + (cnt-1);
    end

    maxCombo = maxCombo + self.AddFever;
    return maxCombo;
end

-- 스킬의 AttackType을 받아오는 기능 --
-- 기본 공격일 경우 무기 종류를 받아 옴 --
function GET_SKILL_ATTACKTYPE(skill)
    local attackType = TryGetProp(skill, "AttackType");
    if attackType == nil then
        return nil;
    end
    
    local skillOwner = GetSkillOwner(skill)
    if IS_PC(skillOwner) == true and IsNormalSKillBySkillID(skillOwner, skill.ClassID) == 1 then
        if skill.AttackType ~= "Magic" then
            local hand = "RH";
            if TryGetProp(skill, "UseSubweaponDamage") == "YES" then
                hand = "LH";
            end
            
            local weapon = GetEquipItem(skillOwner, hand);
            attackType = TryGetProp(weapon, "AttackType");
        end
    end
    
    return attackType;
end

function SCR_LIB_BUFF_IMMUNE_RATIO(self, from, buffName)
--    -- MISSION_SURVIVAL_EVENT2
--    if GetZoneName(self) == 'f_pilgrimroad_41_1_event' then
--        return 0
--    end
    
    if self == nil or from == nil then
        return 0;
    end
    
    if buffName == 'MonReturn' then
        return 0;
    end

    if IsBuffApplied(self, 'PadImmune_Buff') == 'YES' then
        return 1;
    end

    if GetOwner(self) ~= nil then
        if IsSameActor(GetOwner(self), from) == "YES" then
            return 0;
        end
    end

    local buffCls = GetClass("Buff", buffName);
    local buffLv = 99;
    if buffCls ~= nil then
        local keyword = buffCls.Keyword;
        buffLv = buffCls.Lv
        if buffLv == 99 then
            return 0;
        end

        if string.find(keyword, "IgnoreImmune") ~= nil then
            return 0;
        end
    end
    
    if buffName == 'Raise_Debuff' and IsPVPServer(self) == 1 then
        buffLv = 1;
    end

--    local myMNA = self.MNA;
--    local fromMNA = from.MNA;
--    local myLv = self.Lv;
--    local fromLv = from.Lv;
--
--    local ratio = myMNA / (myLv + fromLv / 4 + 40);
--    ratio = ratio * 10000;
--    
--    if IS_PC(self) ~= true then
--        ratio = ratio / 2;
--    end
    
    local defenderLv = TryGetProp(self, "Lv");
    if defenderLv == nil then
        defenderLv = 1;
    end
    
    local attackerLv = TryGetProp(from, "Lv");
    if attackerLv == nil then
        attackerLv = 1;
    end
    
    local ratio = math.max(1, (defenderLv + 10) - attackerLv) ^ 0.7;
    ratio = math.floor(ratio * 100);
    
    local addRatio = 0;
    addRatio = SCR_BUFF_IMMUNE_RATE_UPDATE(self, buffName, buffLv, addRatio)
    addRatio = CALC_ADD_RATIO_BY_CARD(self, buffCls, addRatio)
    
    ratio = ratio + addRatio;
    
    -- 최대 50% 확률로 면역 --
    if ratio > 6000 then
        ratio = 6000;
    end
    
    if ratio < 0 then
        ratio = 0;
    end
    
    if IsBuffApplied(self, 'Fumigate_Buff_ImmuneAbil') == 'YES' and buffLv <= 3 then
        ratio = ratio + GetExProp(self, "ADD_DEBUFF_IMMUNE")
    end
    
    local rate = IMCRandom(1, 10000);
    if ratio > rate then
        SkillTextEffect(nil, self, from, 'SHOW_SKILL_EFFECT', 0, nil, 'Debuff_Resister');
        return 1;
    end
    
    return 0;
end

function CALC_ADD_RATIO_BY_CARD(self, buffCls, addRatio)
    if IS_PC(self) == true then
        local Keyword = TryGetProp(buffCls, "Keyword")
        --Stun
        local find = string.find(Keyword, "Stun")
        if find ~= nil then
            local res = TryGetProp(self, "Res_Stun_Debuff_BM")
            if nil ~= res then
                res = tonumber(res)
            else
                res = 0;
            end
            addRatio = addRatio + res
        end
        --Silence
        find = string.find(Keyword, "Silence")
        if find ~= nil then
            local res = TryGetProp(self, "Res_Silence_Debuff_BM")
            if nil ~= res then
                res = tonumber(res)
            else
                res = 0;
            end
            addRatio = addRatio + res
        end
        --Sleep
        find = string.find(Keyword, "Sleep")
        if find ~= nil then
            local res = TryGetProp(self, "Res_Sleep_Debuff_BM")
            if nil ~= res then
                res = tonumber(res)
            else
                res = 0;
            end
            addRatio = addRatio + res
        end
        --Bleed
        find = string.find(Keyword, "Bleed")
        if find ~= nil then
            local res = TryGetProp(self, "Res_Bleed_Debuff_BM")
            if nil ~= res then
                res = tonumber(res)
            else
                res = 0;
            end
            addRatio = addRatio + res
        end
        --Wound
        find = string.find(Keyword, "Wound")
        if find ~= nil then
            local res = TryGetProp(self, "Res_Wound_Debuff_BM")
            if nil ~= res then
                res = tonumber(res)
            else
                res = 0;
            end
            addRatio = addRatio + res
        end
    end
    return addRatio;
end

function SCR_LIB_CALC_HP_HEAL_RATIO(self, value, skillName)
    if GetBuffByProp(self, 'Keyword', 'UnrecoverableHP') ~= nil then
        return;
    end
    
    if skillName ~= "TheTreeOfSepiroth_Buff" then
        local stat = TryGetProp(self, "CON");
        if stat == nil then
            stat = 1;
        end
        
        local conRate = 0.005
        
        if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
            if skillName ~= nil then
                conRate = conRate * 0.5
            end
        end
        
        local byStat = 1 + (stat * conRate);
        
        value = value * byStat;
        
        -- Increase --
        local ratio = 1;
        
        local Featherfoot10_abil = GetAbility(self, "Featherfoot10")
        if Featherfoot10_abil ~= nil then
            ratio = ratio + Featherfoot10_abil.Level * 0.005;
        end
        
        local Ayin_sof_buff = GetBuffByName(self, 'Ayin_sof_Buff');
        if Ayin_sof_buff ~= nil then
            local healBonus = GetBuffArgs(Ayin_sof_buff);
            ratio = ratio + healBonus;
            if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) ==  1 then
                ratio = ratio * 0.7
            end
        end
        
        value = value * ratio;
        
        -- Decrease --
        if IsBuffApplied(self, "BayonetThrust_Debuff") == 'YES' then
            value = value / 3;
        end
    end
    
    return math.floor(value);
end

function SCR_LIB_CALC_SP_HEAL_RATIO(self, value, skillName)
    local stat = TryGetProp(self, "MNA");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = 1 + (stat * 0.005);
    
    value = value * byStat;

    -- Increase --
    local ratio = 1;
    
    local Featherfoot10_abil = GetAbility(self, "Featherfoot10")
    if Featherfoot10_abil ~= nil then
        ratio = ratio + Featherfoot10_abil.Level * 0.005;
    end
    
    value = value * ratio;
    
    -- Decrease --
    if IsBuffApplied(self, "BayonetThrust_Debuff") == 'YES' then
        value = value / 3;
    end

    return math.floor(value);
end

function SCR_ADD_PC_SKLFACTOR_CALC(self, from, skill, rateTable, ret)
    local addFactor = 0;
    if IS_PC(from) == true and IS_PC(self) == true then
        local clsType = skill.ClassType;
        if clsType == "Missile" then
            local atkFactor = TryGetProp(from , clsType.."AtkFactor_PC");
            if atkFactor == nil then
                atkFactor = 0;
            end
            
            local defFactor = TryGetProp(self , clsType.."DefFactor_PC");
            if defFactor == nil then
                defFactor = 0;
            end
            
            addFactor = addFactor + atkFactor - defFactor;
        elseif clsType == "Melee" then
            local atkType = skill.AttackType;
            if atkType ~= "None" and atkType ~= "Melee" then
                local atkFactor = TryGetProp(from , atkType.."AtkFactor_PC");
                if atkFactor == nil then
                    atkFactor = 0;
                end
                
                local defFactor = TryGetProp(self , atkType.."DefFactor_PC");
                if defFactor == nil then
                    defFactor = 0;
                end
                
                addFactor = addFactor + atkFactor - defFactor;
            end
        elseif clsType == "Magic" then
            local attr = skill.Attribute;
            if attr ~= "Melee" then
                local atkFactor = TryGetProp(from , attr.."AtkFactor_PC");
                if atkFactor == nil then
                    atkFactor = 0;
                end
                
                local defFactor = TryGetProp(self , attr.."DefFactor_PC");
                if defFactor == nil then
                    defFactor = 0;
                end
                
                addFactor = addFactor + atkFactor - defFactor;
            end
        end
    end
    
    return addFactor;
end

function SCR_CONDITION_RATE_CALC(self, form, skill)
    local conditionRate = 1.0;
    
    local attackType = GET_SKILL_ATTACKTYPE(skill);
    local attribute = TryGetProp(skill, 'Attribute');
    
    if GetBuffByProp(self, 'Keyword', 'Freeze') ~= nil or GetBuffByProp(self, 'Keyword', 'Frostbite') ~= nil then
        if attribute == 'Lightning' then
            conditionRate = conditionRate + 0.5;
        end
    end
    
    if GetBuffByProp(self, 'Keyword', 'Petrify') ~= nil then
        if attribute == 'Fire' then
            conditionRate = conditionRate + 0.5;
        end
    end
    
    if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
        if attribute == 'Dark' then
            conditionRate = conditionRate + 0.5;
        end
    end
    
    return conditionRate;
end

function SCR_RESET_SKILL_AFTER_HIT_PROP(attacker)
    DelExProp(attacker, "ABIL_CRTHR_ADD");
    DelExProp(attacker, "SPCI_FACTOR_ADD_DAM");
    DelExProp(attacker, "SPCI_RATE_DAM");
    DelExProp(attacker, "SPCI_ADD_DAM");
    DelExProp(attacker, "CARD_DAMAGE_RATE_BM");
    DelExProp(attacker, "IS_BACKATTACK")
end

function SCR_DUALHAND_ATK_CALC(from, attackerTopOwner, skill, bunsinMaxAtk, bunsinMinAtk, bunsinMaxAtkSub, bunsinMinAtkSub)
    local equipLH = GetEquipItem(attackerTopOwner, "LH");
    local equipRH = GetEquipItem(attackerTopOwner, "RH");
    local bunsinSkillName = TryGetProp(skill, "ClassName");
    
    if bunsinSkillName == "Peltasta_UmboBlow" or bunsinSkillName == "Peltasta_RimBlow" or bunsinSkillName == "Peltasta_ShieldLob" or bunsinSkillName == "Peltasta_UmboThrust" or
        bunsinSkillName == "Rodelero_TargeSmash" or bunsinSkillName == "Rodelero_ShieldCharge" or bunsinSkillName == "Rodelero_ShieldPush" or bunsinSkillName == "Rodelero_ShieldShoving" or
        bunsinSkillName == "Rodelero_ShieldBash" or bunsinSkillName == "Rodelero_Slithering" or bunsinSkillName == "Murmillo_ScutumHit" then
        if TryGetProp(equipLH, "AttachType") == "Shield" then
            local shieldDef = TryGetProp(equipLH, "DEF");
            bunsinMaxAtk = bunsinMaxAtk + shieldDef * 0.3;
            bunsinMinAtk = bunsinMinAtk + shieldDef * 0.3;
        end
    elseif bunsinSkillName == "Peltasta_ButterFly" or bunsinSkillName == "Rodelero_ShootingStar" then
        if TryGetProp(equipLH, "AttachType") == "Shield" then
            local shieldDef = TryGetProp(equipLH, "DEF");
            bunsinMaxAtk = bunsinMaxAtk + shieldDef;
            bunsinMinAtk = bunsinMinAtk + shieldDef;
        end
    elseif bunsinSkillName == "Corsair_DustDevil" or bunsinSkillName == "Corsair_HexenDropper" then
        if TryGetProp(equipLH, "GroupName") == "SubWeapon" and TryGetProp(equipLH, "ClassType") ~= "Artefact" then
            bunsinMaxAtk = bunsinMaxAtk * 0.8 + bunsinMaxAtkSub * 0.6;
            bunsinMinAtk = bunsinMinAtk * 0.8 + bunsinMinAtkSub * 0.6;
        end
    end
    
    return bunsinMaxAtk, bunsinMinAtk
end

