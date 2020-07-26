﻿-- util
function GET_MON_STAT(self, lv, statStr)
    -- Sum MaxStat --
    local allStatMax = 10 + (lv * 2);
    
    local raceType = TryGetProp(self, "RaceType", "None");
    if GetExProp(self, "EXPROP_SHADOW_INFERNAL") == 1 then
        raceType = GetExProp_Str(self, "SHADOW_INFERNAL_RACETYPE");
        if raceType == nil then
            raceType = "None";
        end
    end
    
    local raceTypeClass = GetClass("Stat_Monster_Race", raceType);
    if raceTypeClass == nil then
        return 1;
    end
    
    -- Select Stat Rate --
    local statRate = 100;
    statRate = TryGetProp(raceTypeClass, statStr, statRate);
    
    if statRate < 0 then
        statRate = 0;
    end
    
    -- All Stat Rate --
    local totalStatRate = 0;
    local statRateList = { 'STR', 'INT', 'CON', 'MNA', 'DEX' };
    
    for i = 1, #statRateList do
        local statRateTemp = TryGetProp(raceTypeClass, statRateList[i], 0);
        if statRateTemp == nil then
            statRateTemp = 0;
        end
        
        totalStatRate = totalStatRate + statRateTemp;
    end
    
    -- Calc Stat --
    local value = allStatMax * (statRate / totalStatRate);
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function GET_MON_ITEM_STAT(self, lv, statStr)
    return 0;
end

function SCR_GET_MON_ADDSTAT(self, stat)
    return 0;
end

function SCR_Get_MON_STR(self)
    local statString = "STR";
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local byStat = GET_MON_STAT(self, lv, statString);
    if byStat == nil or byStat < 0 then
        byStat = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_INT(self)
    local statString = "INT";
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local byStat = GET_MON_STAT(self, lv, statString);
    if byStat == nil or byStat < 0 then
        byStat = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_CON(self)
    local statString = "CON";
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local byStat = GET_MON_STAT(self, lv, statString);
    if byStat == nil or byStat < 0 then
        byStat = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_MNA(self)
    local statString = "MNA";
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local byStat = GET_MON_STAT(self, lv, statString);
    if byStat == nil or byStat < 0 then
        byStat = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_DEX(self)
    local statString = "DEX";
    
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local byStat = GET_MON_STAT(self, lv, statString);
    if byStat == nil or byStat < 0 then
        byStat = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byBuff;
    
    return math.floor(value);
end


function SCR_Get_MON_MHP(self)
    local monHPCount = TryGetProp(self, "HPCount", 0);
    if monHPCount > 0 then
        return math.floor(monHPCount);
    end
    
    local fixedMHP = TryGetProp(self, "FIXMHP_BM", 0);
    if fixedMHP > 0 then
        return math.floor(fixedMHP);
    end
    
    local lv = TryGetProp(self, "Lv", 1);
    
    
    
    local standardMHP = math.max(30, lv);
    local byLevel = (standardMHP / 4) * lv;
    
    local stat = TryGetProp(self, "CON", 1);
    
    local byStat = (byLevel * (stat * 0.0015)) + (byLevel * (math.floor(stat / 10) * 0.005));
    
    local value = standardMHP + byLevel + byStat;
    
    local statTypeRate = 100;
    local statType = TryGetProp(self, "StatType", "None");
    if statType ~= nil and statType ~= 'None' then
        local statTypeClass = GetClass("Stat_Monster_Type", statType);
        if statTypeClass ~= nil then
            statTypeRate = TryGetProp(statTypeClass, "MHP", statTypeRate);
        end
    end
    
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MHP");
    value = value * raceTypeRate;
    
--    value = value * JAEDDURY_MON_MHP_RATE;      -- JAEDDURY
    
    local byBuff = TryGetProp(self, "MHP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    value = value + byBuff;
    
	local monClassName = TryGetProp(self, "ClassName", "None");
	local monOriginFaction = TryGetProp(GetClass("Monster", monClassName), "Faction");
    if monOriginFaction == "Summon" then
        value = value + 5000;   -- PC Summon Monster MHP Add
    end
    
    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity = infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,'HPRate')
    end

    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_MSP(self)

    local mna = self.MNA;   
    local lv = self.Lv;
    local byBuff = self.MSP_BM;
    local byLevel = math.floor((lv -1) * 6.7);
    local byStat = math.floor(mna * 13);

    local value = byLevel + byStat + byBuff;

    if value < 1 then
        value = 1;
    end
    return math.floor(value);
end

-- monster only
function SCR_GET_MON_EXP(self)
    if TryGetProp(self, "GiveEXP", "NO") ~= "YES" then
        return 0;
    end
    
    local level = TryGetProp(self, "Lv", 1);
    local exPropLevel = GetExProp(self, "LEVEL_FOR_EXP")
    if exPropLevel ~= nil and exPropLevel ~= 0 then
        level = exPropLevel;
    end
    
    local cls = GetClassByType("Stat_Monster", level);
    local value = TryGetProp(cls, "EXP_BASE", 0);
    
    local expValue = 100;
    local monStatType = TryGetProp(self, "StatType", "None");
    if monStatType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", monStatType);
        if cls2 ~= nil then
            expValue = TryGetProp(cls2, "EXP", 0);
        end
    end
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "EXP");
    
    value = value * (expValue / 100) * raceTypeRate;
    
    return math.floor(value);
end

function SCR_GET_MON_JOBEXP(self)
    if TryGetProp(self, "GiveEXP", "NO") ~= "YES" then
        return 0;
    end
    
    local level = TryGetProp(self, "Lv", 1);
    
    local cls = GetClassByType("Stat_Monster", level);
    local value = TryGetProp(cls, "JEXP_BASE", 0);
    
    local jexpValue = 100;
    local monStatType = TryGetProp(self, "StatType", "None");
    if monStatType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", monStatType);
        if cls2 ~= nil then
            jexpValue = TryGetProp(cls2, "JEXP", 0);
        end
    end
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "JEXP");
    
    value = value * (jexpValue / 100) * raceTypeRate;
    
    return math.floor(value);
end

function SCR_Get_MON_DEF(self)
    local fixedDEF = TryGetProp(self, "FixedDefence");
    if fixedDEF ~= nil and fixedDEF > 0 then
        return fixedDEF;
    end
    
    local originDef = GetExProp(self, "MON_ORIGIN_DEF");

    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = 0;
    local className = TryGetProp(self, "ClassName");
    if className ~= nil and (className == "pcskill_skullsoldier" or className == "pcskill_skullarcher" or className == "pcskill_skullwizard") then
        byItem = SCR_MON_OWNERITEM_ARMOR_CALC(self);
    else
        byItem = SCR_MON_ITEM_ARMOR_DEF_CALC(self);
    end 
    
    local value = byLevel + byStat + byItem;
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "DEF")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "DEF");
    
    value = value * raceTypeRate;
    
    local byBuff = TryGetProp(self, "DEF_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "DEF_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
--    value = value * JAEDDURY_MON_DEF_RATE;      -- JAEDDURY
    
    value = value + byBuff + byRateBuff;

    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,"DefRate")
    end

    if value < 0 then
        value = 0;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceDefLimit = math.floor(originDef * 0.85);
        if originDef == 0 then
            SetExProp(self, "MON_ORIGIN_DEF", math.floor(value));
        elseif value < reduceDefLimit then
            value = reduceDefLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceDefLimit = math.floor(originDef * 0.75);
        if originDef == 0 then
            SetExProp(self, "MON_ORIGIN_DEF", math.floor(value));
        elseif value < reduceDefLimit then
            value = reduceDefLimit;
        end
    end
    
    return math.floor(value)
end



function SCR_Get_MON_MDEF(self)
    local fixedDEF = TryGetProp(self, "FixedDefence");
    if fixedDEF ~= nil and fixedDEF > 0 then
        return fixedDEF;
    end

    local originDef = GetExProp(self, "MON_ORIGIN_MDEF");
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = 0;
    local className = TryGetProp(self, "ClassName");
    if className ~= nil and (className == "pcskill_skullsoldier" or className == "pcskill_skullarcher" or className == "pcskill_skullwizard") then
        byItem = SCR_MON_OWNERITEM_ARMOR_CALC(self);
    else
        byItem = SCR_MON_ITEM_ARMOR_MDEF_CALC(self);
    end 
    
    local value = byLevel + byStat + byItem;
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "MDEF")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MDEF");
    
    value = value * raceTypeRate;
    
    local byBuff = TryGetProp(self, "MDEF_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "MDEF_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
--    value = value * JAEDDURY_MON_DEF_RATE;      -- JAEDDURY
    
    value = value + byBuff + byRateBuff;
    
    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,"DefRate")
    end
    
    if value < 0 then
        value = 0;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceDefLimit = math.floor(originDef * 0.85);
        if originDef == 0 then
            SetExProp(self, "MON_ORIGIN_MDEF", math.floor(value));
        elseif value < reduceDefLimit then
            value = reduceDefLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceDefLimit = math.floor(originDef * 0.75);
        if originDef == 0 then
            SetExProp(self, "MON_ORIGIN_MDEF", math.floor(value));
        elseif value < reduceDefLimit then
            value = reduceDefLimit;
        end
    end
    
    return math.floor(value)
end



function SCR_Get_MON_HR(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "HR");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "HR")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "HR_BM", 0);
    
    local byRateBuff = TryGetProp(self, "HR_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_DR(self)
    if self.HPCount > 0 then
        return 0;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "DR");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "DR")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "DR_BM", 0);
    
    local byRateBuff = TryGetProp(self, "DR_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_MHR(self)
    local value = 0;    
    value = value + self.MHR_BM;
    
    return math.floor(value);   
end



function SCR_Get_MON_CRTHR(self)
    local lv = TryGetProp(self, "Lv", 1);
    local byLevel = lv * 1.0;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "CRTHR");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "CRTHR")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "CRTHR_BM", 0);
    
    local byRateBuff = TryGetProp(self, "CRTHR_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_CRTDR(self)
    local originCrtDR = GetExProp(self, "MON_ORIGIN_CRTDR")
    local lv = TryGetProp(self, "Lv", 1);
    local byLevel = lv * 1.0;

    if lv > 420 and TryGetProp(self, "MonRank", "None") ~= "Summon" then
        byLevel = lv * 4
    end
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "CRTDR");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "CRTDR")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "CRTDR_BM", 0);
	
    local byRateBuff = TryGetProp(self, "CRTDR_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
	
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceCrtDrLimit = math.floor(originCrtDR * 0.85);
        if originCrtDR == 0 then
            SetExProp(self, "MON_ORIGIN_CRTDR", math.floor(value));
        elseif value < reduceCrtDrLimit then
            value = reduceCrtDrLimit;
        end
    end
    
    return math.floor(value);
end

function SCR_Get_MON_CRTATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "DEX");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local value = byLevel + byStat;
    
    return math.floor(value);
end

function SCR_Get_MON_CRTMATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "MNA");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local value = byLevel + byStat;
    
    return math.floor(value);
end

function SCR_Get_MON_MINPATK(self)
    
    local originMinPatk = GetExProp(self, "MON_ORIGIN_MINPATK");

    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "STR");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self);
    
    local value = byLevel + byStat + byItem;
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "ATK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (2.0 - range / 100.0);
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "PATK");
	
    value = value * raceTypeRate;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MINPATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local rateBuffList = {'PATK_RATE_BM', 'MINPATK_RATE_BM' };
    local byRateBuff = 0;
    for i = 1, #rateBuffList do
        local rateBuff = TryGetProp(self, rateBuffList[i]);
        if rateBuff ~= nil then
            byRateBuff = byRateBuff + rateBuff;
        end
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;

    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,'AtkRate')
    end

    if value < 1 then
        value = 1;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceAtkLimit = math.floor(originMinPatk * 0.85);
        if originMinPatk == 0 then
            SetExProp(self, "MON_ORIGIN_MINPATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceAtkLimit = math.floor(originMinPatk * 0.75);
        if originMinPatk == 0 then
            SetExProp(self, "MON_ORIGIN_MINPATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    end

    return math.floor(value);
end

function SCR_Get_MON_MAXPATK(self)

    local originMaxPatk = GetExProp(self, "MON_ORIGIN_MAXPATK");

    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "STR");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self);
    
    local value = byLevel + byStat + byItem
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "ATK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (range / 100.0)
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "PATK");
    
    value = value * raceTypeRate;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MAXPATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local rateBuffList = {'PATK_RATE_BM', 'MAXPATK_RATE_BM' };
    local byRateBuff = 0;
    for i = 1, #rateBuffList do
        local rateBuff = TryGetProp(self, rateBuffList[i]);
        if rateBuff ~= nil then
            byRateBuff = byRateBuff + rateBuff;
        end
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;

    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,'AtkRate')
    end

    if value < 1 then
        value = 1;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceAtkLimit = math.floor(originMaxPatk * 0.85);
        if originMaxPatk == 0 then
            SetExProp(self, "MON_ORIGIN_MAXPATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceAtkLimit = math.floor(originMaxPatk * 0.75);
        if originMaxPatk == 0 then
            SetExProp(self, "MON_ORIGIN_MAXPATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    end

    return math.floor(value);
end

function SCR_Get_MON_MINMATK(self)
    
    local originMinMatk = GetExProp(self, "MON_ORIGIN_MINMATK"); 

    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "INT");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self);
    
    local value = byLevel + byStat + byItem;
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "ATK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (2.0 - range / 100.0);
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MATK");
    
    value = value * raceTypeRate;
    
    local byBuff = 0;
    local byBuffList = { "MATK_BM", "MINMATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local rateBuffList = {'MATK_RATE_BM', 'MINMATK_RATE_BM' };
    local byRateBuff = 0;
    for i = 1, #rateBuffList do
        local rateBuff = TryGetProp(self, rateBuffList[i]);
        if rateBuff ~= nil then
            byRateBuff = byRateBuff + rateBuff;
        end
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;

    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,'AtkRate')
    end

    if value < 1 then
        value = 1;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceAtkLimit = math.floor(originMinMatk * 0.85);
        if originMinMatk == 0 then
            SetExProp(self, "MON_ORIGIN_MINMATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceAtkLimit = math.floor(originMinMatk * 0.75);
        if originMinMatk == 0 then
            SetExProp(self, "MON_ORIGIN_MINMATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    end

    return math.floor(value);
end

function SCR_Get_MON_MAXMATK(self)

    local originMaxMatk = GetExProp(self, "MON_ORIGIN_MAXMATK"); 

    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "INT");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * (byLevel * 0.05));
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self);
    
    local value = byLevel + byStat + byItem;
    --아이템 계산 후 배율로 올려준다--
    local statTypeRate = SCR_MON_STAT_RATE(self, "ATK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (range / 100.0);
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MATK");
    
    value = value * raceTypeRate;
    
    local byBuff = 0;
    local byBuffList = { "MATK_BM", "MAXMATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local rateBuffList = {'MATK_RATE_BM', 'MAXMATK_RATE_BM' };
    local byRateBuff = 0;
    for i = 1, #rateBuffList do
        local rateBuff = TryGetProp(self, rateBuffList[i]);
        if rateBuff ~= nil then
            byRateBuff = byRateBuff + rateBuff;
        end
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;

    local infoCls = GetClass("Ancient_Info",self.ClassName)
    if infoCls ~= nil then
        local rarity= infoCls.Rarity
        local starrank = GetExProp(self,'STARRANK',99)
        value = value * SCR_ANCIENT_INFO_RATE_CALC(rarity,starrank,'AtkRate')
    end

    if value < 1 then
        value = 1;
    end

    local debuffRank = TryGetProp(self, "DebuffRank");
    if IsBuffApplied(self, "Tenacity_Buff") == "YES" then
        local reduceAtkLimit = math.floor(originMaxMatk * 0.85);
        if originMaxMatk == 0 then
            SetExProp(self, "MON_ORIGIN_MAXMATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    elseif debuffRank == "LegendRaidBoss" or debuffRank == "WorldRaid" or debuffRank == "FieldBoss" or debuffRank == "WeeklyBoss" then
        local reduceAtkLimit = math.floor(originMaxMatk * 0.75);
        if originMaxMatk == 0 then
            SetExProp(self, "MON_ORIGIN_MAXMATK", math.floor(value));
        elseif value < reduceAtkLimit then
            value = reduceAtkLimit;
        end
    end

    return math.floor(value);
end

function SCR_Get_MON_BLKABLE(self)
    if self.HPCount > 0 then
        return 0;
    end
    
    local value = TryGetProp(self, 'Blockable', 0);
    
    return value;
end

function SCR_Get_MON_BLK(self)
    if TryGetProp(self, "BLKABLE", 0) == 0 then
        return 0;
    end
    
    local lv = self.Lv;
    
    local byLevel = lv * 1.0;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "BLK");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "BLK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "BLK_BM", 0);
	
    local byRateBuff = TryGetProp(self, "BLK_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_BLK_BREAK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "BLK_BREAK");
    
    local value = byLevel * raceTypeRate;
    --Statbase_monster_type--
    local statTypeRate = SCR_MON_STAT_RATE(self, "BLK_BREAK")
    statTypeRate = statTypeRate / 100;
    value = value * statTypeRate;
    
    local byBuff = TryGetProp(self, "BLK_BREAK_BM", 0);
    
    local byRateBuff = TryGetProp(self, "BLK_BREAK_RATE_BM", 0);
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    if value < 0 then
    	value = 0;
    end
    
    return math.floor(value);
end


-- old

function SCR_Get_MON_KDArmorType(self)
    if self.HPCount > 0 then
        return 9999;
    end
    
    local value = self.KDArmor;
    local buffList = { "Safe", "PainBarrier_Buff", "Lycanthropy_Buff", "Marschierendeslied_Buff", "Methadone_Buff", "Mon_PainBarrier_Buff", "SkullFollowPainBarrier_Buff" };
    for i = 1, #buffList do
        if IsBuffApplied(self, buffList[i]) == 'YES' then
            value = 9999;
        end
    end
    
    return value;
end

function SCR_GET_MON_RHPTIME(self)
    return 10000;
end

function SCR_GET_COMPANION_RHPTIME(self)
    return 5000;
end

function SCR_GET_MON_MSHIELD(self)
    
    return self.ShieldRate/100 * self.MHP;

end

-- Regenerate HP
function SCR_Get_MON_RHP(self)
    if self.HPCount > 0 then
        return 0;
    end
    
    if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
        return 0;
    end
    
    local value = TryGetProp(self, "RHP_BM");
    
    return value;
end

-- Attack damage


--function GET_MON_TABLE_VALUE(self, propName)
--  local lv = self.Lv;
--  local cls = GetClassByType("Stat_Monster", lv);

--  local value = cls[propName] + self[propName .. "_BM"];
--  return math.floor(value);
--end



-- Critical defence
function SCR_Get_MON_CRTDEF(self)

    local value = self.Lv;
    value = value + self.CRTDEF_BM;
    return math.floor(value);
end

-- Dodge rating reduce
function SCR_Get_MON_DRR(self)

    local value = 25;
    value = value + self.DRR_BM;
    return math.floor(value);
end

-- Threatening
function SCR_Get_MON_TR(self)

    local value = 10;
    value = value + self.TR_BM;
    return math.floor(value);
end

-- Add
function SCR_GET_MON_FIRE_ATK(self)
    local attributeName = "Fire";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_ICE_ATK(self)
    local attributeName = "Ice";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_POISON_ATK(self)
    local attributeName = "Poison";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_LIGHTNING_ATK(self)
    local attributeName = "Lightning";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_SOUL_ATK(self)
    local attributeName = "Soul";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_EARTH_ATK(self)
    local attributeName = "Earth";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_HOLY_ATK(self)
    local attributeName = "Holy";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_DARK_ATK(self)
    local attributeName = "Dark";
    local value = SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_ATTRIBUTE_ATK_CALC(self, attributeName)
--    local lv = TryGetProp(self, "Lv", 1);
--    local byLevel = lv * 1.5;
--    
--    local byBuff = TryGetProp(self, attributeName .. "_Atk_BM", 0);
--    
--    local value = byLevel + byBuff;
--    
--    return math.floor(value);
    
    local value = TryGetProp(self, attributeName .. "_Atk_BM", 0);
    
    return math.floor(value);
end


function SCR_Get_MON_HitRange(self)

    local value = 10;
    return math.floor(value);
end

function SCR_Get_MON_ASPD(self)

    local value = 0;
    value = self.AniASPD * 1.25;
    value = value * (100 - self.ASPD_BM) / 100;
    if value < 500 then
        value = 500;
    elseif value > 10000 then
        value = 10000;
    end
    return math.floor(value);
end

function SCR_GET_SKL_CAST_MON(skill)

    return skill.BasicCast;

end

function SCR_Get_MON_MSPD(self)
 
    local fixMSPD = TryGetProp(self, "FIXMSPD_BM");
    if fixMSPD ~= nil and fixMSPD > 0 then
        return fixMSPD;
    end
    
    local wlkMSPD = TryGetProp(self, "WlkMSPD", 0);
    if wlkMSPD == 0 then
        return 0;
    end
    
    local byBuff = TryGetProp(self, "MSPD_BM", 0);
    
    local byBuffOnlyTopValue = 0;
    if IsServerSection(self) == 1 then
        local byBuffOnlyTopList = GetMSPDBuffInfoTable(self)
        if byBuffOnlyTopList ~= nil then
            for k, v in pairs(byBuffOnlyTopList) do
                if byBuffOnlyTopValue < byBuffOnlyTopList[k] then
                    byBuffOnlyTopValue = byBuffOnlyTopList[k];
                end
            end
        end
    end

    if (IsRaidField(self) == 1 and TryGetProp(self, "MonRank", "None") == "Boss") or TryGetProp(self, "StrArg1", nil) == "PartyFieldBoss" or TryGetProp(self, "StatType", nil) == "WorldRaidBoss" then
        byBuff = 0;
        byBuffOnlyTopValue = 0;
    end
    
    local moveType = GetExProp(self, 'MOVE_TYPE_CURRENT');
    if moveType ~= 0 then
        local runMSPD = TryGetProp(self, "RunMSPD", 0);
        
        local moveSpd = wlkMSPD + byBuff + byBuffOnlyTopValue;
        if moveType == 2 then
            moveSpd = runMSPD + byBuff + byBuffOnlyTopValue;
        elseif moveType == 3 then
            moveSpd = wlkMSPD + runMSPD + byBuff + byBuffOnlyTopValue;
        end
        
        return moveSpd;
    end
    
    local value = wlkMSPD + byBuff + byBuffOnlyTopValue;
    if value < 0 then
        value = 0;
    end
    
    value = value * SERV_MSPD_FIX;
    
    return math.floor(value);
end


function SCR_Get_MON_minRange(self)

    local value = TryGetProp(self, "MinR", 0);
    return math.floor(value);
end

function SCR_Get_MON_maxRange(self)

    local value = TryGetProp(self, "MaxR", 0);
    
    local byBuff = TryGetProp(self, "maxRange_BM", 0);
    value = value + byBuff;
    
    local minRange = TryGetProp(self, "MinR", 0);
    if value < (minRange + 2) then
        value = minRange + 2;
    elseif value > 300 then
        value = 300;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_KDPow(self)

    local value = 0;
    
    local byBuff = TryGetProp(self, "KDPow_BM", 0);
    value = value + byBuff;
    
    local monKDRank = TryGetProp(self, "KDRank", 1);
    value = value * monKDRank;
    
    return math.floor(value);
end

---------------------------------KnockDown-------------------------
function SCR_GET_MON_KDBONUS(self)
    local defaultValue = 120;
    
    local lv = TryGetProp(self, "Lv", 1);
    local byLevel = lv * 10;
    
    local byBuff = TryGetProp(self, "KDBonus_BM", 0);
    
    local value = defaultValue + byLevel + byBuff;
    
    return math.floor(value);
end

function SCR_GET_MON_KDDEFENCE(self)
    local defaultValue = 80;
    
    local lv = TryGetProp(self, "Lv", 1);
    local byLevel = lv * 10;
    
    local byBuff = TryGetProp(self, "KDBonus_BM", 0);
    
    local value = defaultValue + byLevel + byBuff;
    
    return math.floor(value);
end
---------------------------------------------------------------------

function SCR_Get_MON_MGP(self)
    return 65535;
end

function SCR_Get_MON_SR(self)
    local value = 50;
    
    local monSize = TryGetProp(self, 'Size', "S");
    
    if monSize == 'S' then
        value = 8;
    elseif monSize == 'M' then
        value = 16;
    elseif monSize == 'L' then
        value = 24;
    elseif monSize == 'XL' then
        value = 50;
    end
    
    local byBuff = TryGetProp(self, "SR_BM", 0);
    
    value = value + byBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value)
end

function SCR_Get_MON_SDR(self)
    local fixedSDR = TryGetProp(self, 'FixedMinSDR_BM');
    if fixedSDR ~= nil and fixedSDR ~= 0 then
        return 1;
    end
    
    local value = 5;
    
    local monSDR = TryGetProp(self, 'MonSDR', 1);
    
    local monSize = TryGetProp(self, 'Size', "S");
    
    if monSize == 'S' then
        value = 1;
    elseif monSize == 'M' then
        value = 2;
    elseif monSize == 'L' then
        value = 3;
    elseif monSize == 'XL' then
        value = 5;
    end
    
    local byBuff = TryGetProp(self, 'SDR_BM', 0);
    
    value = value + byBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_MONSKL_COOL(skill)
    local value = TryGetProp(skill, "BasicCoolDown", 0);
    
    return value;
end

function SCR_GET_MONSKL_SKIACLIPSE_METEOR_COOL(skill)
    local value = TryGetProp(skill, "BasicCoolDown", 0);
    
    return value;
end

function SCR_MON_COMBOABLE(mon)
    if TryGetProp(mon, "GroupName") == "Monster" then
        return 1;
    end
    
    return 0;
end

function SCR_GET_MON_RES_FIRE(self)
    local attributeName = "Fire";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_ICE(self)
    local attributeName = "Ice";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_POISON(self)
    local attributeName = "Poison";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_LIGHTNING(self)
    local attributeName = "Lightning";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_SOUL(self)
    local attributeName = "Soul";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_EARTH(self)
    local attributeName = "Earth";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_HOLY(self)
    local attributeName = "Holy";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_DARK(self)
    local attributeName = "Dark";
    local value = SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName);
    
    return math.floor(value);
end

function SCR_GET_MON_RES_ATTRIBUTE_CALC(self, attributeName)
    local lv = TryGetProp(self, "Lv", 1);
    local fixedFigure = 30;
    local byLevel = math.floor(((lv / 3) ^ 2) / fixedFigure) + fixedFigure 
    
    local byBuff = TryGetProp(self, "Res" .. attributeName .. "_BM", 0);
    
    local byStatType = 0;
    local statType = TryGetProp(self, "StatType", "None");
    if statType ~= nil then
        local statTypeClass = GetClass("Stat_Monster_Type", statType);
        if statTypeClass ~= nil then
            byStatType = TryGetProp(statTypeClass, "ResAttributeRate", 100)*0.01;
        end
    end
    
    local value = (byLevel * byStatType) + byBuff;
    
    return math.floor(value);
end

function SCR_GET_MON_LIMIT_BUFF_COUNT(self)
    local value = 999;  -- 2017/9/13 --
    
--    local byBuff = TryGetProp(self, "LimitBuffCount_BM", 0);
--    if byBuff > 0 then
--      value = byBuff;
--    end
    
    return value;
end

function CLIENT_SORCERER_SUMMONING_MON(self, caster, skl, item)

    if nil == self then
        return;
    end

    if nil == caster then
        return;
    end

    if nil == skl then
        return;
    end

    self.Lv = caster.Lv;
    --self.StatType = 30
        
    -- local monDef = self.DEF;
    -- local monMDef = self.MDEF;

    -- local sklbonus = 1 + skl.Level * 0.1
    -- local itembonus = 1 + item.Level * 0.1
    -- self.MATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
    -- self.PATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
    
    -- self.DEF_BM = (monDef / 2  + (caster.MNA * sklbonus)) * itembonus
    -- self.MDEF_BM = (monMDef / 2 + (caster.MNA * sklbonus)) * itembonus

    -- calculating is changed(it depends on owner's status)
    local ownerMATK = math.floor((caster.MINMATK + caster.MAXMATK) / 2);
    local sklRate = 0;
    local mhpRate = 0;
    local atkRate = 0;
    local defRate = 0;
    if skl.ClassName == 'Sorcerer_Summoning' then
        sklRate = 0.16 + skl.Level * 0.056;
        mhpRate = 1.5;
        atkRate = 1;
        defRate = 1;
    elseif skl.ClassName == 'Necromancer_CreateShoggoth' then
        sklRate = skl.Level * 0.2;
        
        local MAX_CARD_COUNT = 4;
        local cardCnt = 0;
        local etc = nil;
        if IsServerSection(caster) == 1 then
            etc = GetETCObject(caster);
        else
            etc = GetMyEtcObject();
        end
        
        for i = 1, MAX_CARD_COUNT do
            local cardGuid = etc['Necro_bosscardGUID' .. i];
            local invCard = nil;
            if cardGuid ~= nil and cardGuid ~= 'None' then
                if IsServerSection(caster) == 1 then
                    invCard = GetInvItemByGuid(caster, cardGuid);
                else
                    invCard = session.GetInvItemByGuid(cardGuid);
                end
            end

            if invCard ~= nil then
                cardCnt = cardCnt + 1;
            end
        end

        mhpRate = 1 + cardCnt * 0.1;
        atkRate = 1;
        defRate = 1;
    end
    
    self.MHP_BM = self.MHP_BM + math.floor(caster.MHP * mhpRate * sklRate - self.MHP);
    self.MINPATK_BM = self.MINPATK_BM + math.floor(ownerMATK * 0.9 * atkRate * sklRate - self.MINPATK);
    self.MAXPATK_BM = self.MAXPATK_BM + math.floor(ownerMATK * 1.1 * atkRate * sklRate - self.MAXPATK);
    self.MATK_BM = self.MATK_BM + math.floor(ownerMATK * atkRate * sklRate - (self.MINMATK + self.MAXMATK) / 2);
    self.DEF_BM = self.DEF_BM + math.floor(caster.DEF * defRate * sklRate - self.DEF);
    self.MDEF_BM = self.MDEF_BM + math.floor(caster.MDEF * defRate * sklRate - self.MDEF);

    if skl.ClassName == 'Necromancer_CreateShoggoth' then
        self.CON = self.CON + math.floor(caster.MNA * 0.1);
    end
end

function SCR_GET_MON_SKILLFACTORRATE(self)
    local value = 100;
    
    local byBuff = TryGetProp(self, "SkillFactorRate_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "SkillFactorRate_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;
    
    return value;
end

function SCR_Get_MON_HEAL_PWR(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local stat = TryGetProp(self, "MNA");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 1) + (math.floor(stat / 10) * (byLevel * 0.03));
    
    local value = byLevel + byStat;
    
    local byBuff = 0;
    
    local byBuffTemp = TryGetProp(self, "HEAL_PWR_BM");
    if byBuffTemp ~= nil then
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;

    local byRateBuffTemp = TryGetProp(self, "HEAL_PWR_RATE_BM");
    if byRateBuffTemp ~= nil then
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuffTemp);
    
    value = value + byBuff + byRateBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end


function SCR_Get_MON_Slash_Res(self)
    local value = 0;

    local Slash_Res = TryGetProp(self, "Slash_Res")
    if Slash_Res == nil then
        Slash_Res = 0;
    end
    
    local Slash_Def_BM = TryGetProp(self, "Slash_Def_BM")
    if Slash_Def_BM == nil then
        Slash_Def_BM = 0;
    end
    
    value = value + Slash_Res + Slash_Def_BM;
    return value;
end

function SCR_Get_MON_Aries_Res(self)
    local value = 0;
    
    local Aries_Res = TryGetProp(self, "Aries_Res")
    if Aries_Res == nil then
        Aries_Res = 0;
    end
    
    local Aries_Def_BM = TryGetProp(self, "Aries_Def_BM")
    if Aries_Def_BM == nil then
        Aries_Def_BM = 0;
    end
    
    value = value + Aries_Res + Aries_Def_BM;
    return value;
end

function SCR_Get_MON_Strike_Res(self)
    local value = 0;
    
    local Strike_Res = TryGetProp(self, "Strike_Res")
    if Strike_Res == nil then
        Strike_Res = 0;
    end
    
    local Strike_Def_BM = TryGetProp(self, "Strike_Def_BM")
    if Strike_Def_BM == nil then
        Strike_Def_BM = 0;
    end
    
    value = value + Strike_Res + Strike_Def_BM;
    return value;
end

function SCR_Get_MON_Magic_Res(self)
    local value = 0;
    
    local magicRes = TryGetProp(self, "Magic_Res")
    if magicRes == nil then
        magicRes = 0;
    end

    local magicDefBM = TryGetProp(self, "Magic_Def_BM")
    if magicDefBM == nil then
        magicDefBM = 0;
    end

    value = value + magicRes + magicDefBM;

    return value;
end

function SCR_Get_MON_Arrow_Res(self)
    local value = 0;
    
    local Arrow_Res = TryGetProp(self, "Arrow_Res")
    if Arrow_Res == nil then
        Arrow_Res = 0;
    end
    
    local Arrow_Def_BM = TryGetProp(self, "Arrow_Def_BM")
    if Arrow_Def_BM == nil then
        Arrow_Def_BM = 0;
    end
    
    value = value + Arrow_Res + Arrow_Def_BM;
    return value;
end

function SCR_Get_MON_Gun_Res(self)
    local value = 0;
    
    local Gun_Res = TryGetProp(self, "Gun_Res")
    if Gun_Res == nil then
        Gun_Res = 0;
    end
    
    local Gun_Def_BM = TryGetProp(self, "Gun_Def_BM")
    if Gun_Def_BM == nil then
        Gun_Def_BM = 0;
    end
    
    value = value + Gun_Res + Gun_Def_BM;
    return value;
end

function SCR_Get_MON_Cannon_Res(self)
    local value = 0;
    
    local Cannon_Res = TryGetProp(self, "Cannon_Res")
    if Cannon_Res == nil then
        Cannon_Res = 0;
    end
    
    local Cannon_Def_BM = TryGetProp(self, "Cannon_Def_BM")
    if Cannon_Def_BM == nil then
        Cannon_Def_BM = 0;
    end
    
    value = value + Cannon_Res + Cannon_Def_BM;
    return value;
end

function SCR_Get_MON_Aries_Atk(self)
    local byBuff = TryGetProp(self, "Aries_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Slash_Atk(self)
    local byBuff = TryGetProp(self, "Slash_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Strike_Atk(self)
    local byBuff = TryGetProp(self, "Strike_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Arrow_Atk(self)
    local byBuff = TryGetProp(self, "Arrow_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Cannon_Atk(self)
    local byBuff = TryGetProp(self, "Cannon_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Gun_Atk(self)
    local byBuff = TryGetProp(self, "Gun_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Melee_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Melee_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Fire_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Fire_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Ice_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Ice_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Lightning_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Lightning_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Earth_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Earth_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Poison_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Poison_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Dark_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Dark_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Holy_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Holy_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_Get_MON_Magic_Soul_Atk(self)
    local byBuff = TryGetProp(self, "Magic_Soul_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
	
    return math.floor(value);
end

function SCR_RACE_TYPE_RATE(self, prop)
    -- RaceType --
    local raceTypeRate = 100;
    
    local raceType = TryGetProp(self, "RaceType", "None");
    if GetExProp(self, "EXPROP_SHADOW_INFERNAL") == 1 then
        raceType = GetExProp_Str(self, "SHADOW_INFERNAL_RACETYPE");
        if raceType == nil then
            raceType = "None";
        end
    end
    
    local raceTypeClass = GetClass("Stat_Monster_Race", raceType);
    if raceTypeClass ~= nil then
        raceTypeRate = TryGetProp(raceTypeClass, prop, raceTypeRate);
        --방어력, 마법방어력 평균치 적용--
        if prop == "DEF" or prop == "MDEF" then
            local statType = TryGetProp(self, "StatType", "None");
            if statType ~= nil and statType ~= 'None' then
                local statTypeClass = GetClass("Stat_Monster_Type", statType);
                if statTypeClass ~= nil then
                    local averge_def = TryGetProp(statTypeClass, "AVERAGE_DEF", nil);
                    if averge_def ~= nil and averge_def ~= 0 then
                        local defTypeList = {"DEF", "MDEF"}
                        local raceTypeRateTable = {};
                        for i = 1, #defTypeList do
                            raceTypeRateTable[#raceTypeRateTable + 1] = TryGetProp(raceTypeClass, defTypeList[i], raceTypeRate);
                        end
                
                        if averge_def == 1 then
                            if raceTypeRateTable[1] >= raceTypeRateTable[2] then
                                raceTypeRate = raceTypeRateTable[2];
                            else
                                raceTypeRate = raceTypeRateTable[1];
                            end
                        elseif averge_def == 2 then
                            if raceTypeRateTable[1] >= raceTypeRateTable[2] then
                                raceTypeRate = raceTypeRateTable[1];
                            else
                                raceTypeRate = raceTypeRateTable[2];
                            end
                        end
                    end
                end
            end
        end
    end
    
    raceTypeRate = raceTypeRate / 100;
    
    if raceTypeRate < 0 then
        raceTypeRate = 0;
    end
    
    
    
    -- Size --
    local sizeTypeRate = 100;
    
    local sizeType = TryGetProp(self, "Size", "None");
    if GetExProp(self, "EXPROP_SHADOW_INFERNAL") == 1 then
        sizeType = GetExProp_Str(self, "SHADOW_INFERNAL_SIZE");
        if sizeType == nil then
            sizeType = "None";
        end
    end
    
    if sizeType ~= nil then
        local sizeTypeClass = GetClass("Stat_Monster_Race", sizeType);
        if sizeTypeClass ~= nil then
            sizeTypeRate = TryGetProp(sizeTypeClass, prop, sizeTypeRate);
        end
    end
    
    sizeTypeRate = sizeTypeRate / 100;
    
    if sizeTypeRate < 0 then
        sizeTypeRate = 0;
    end
    
    
    
    -- MonRank --
    local rankTypeRate = 100;
    
    local rankType = TryGetProp(self, "MonRank", "None");
    
    if rankType ~= nil then
        local rankTypeClass = GetClass("Stat_Monster_Race", rankType);
        if rankTypeClass ~= nil then
            rankTypeRate = TryGetProp(rankTypeClass, prop, rankTypeRate);
        end
    end
    
    rankTypeRate = rankTypeRate / 100;
    
    if rankTypeRate < 0 then
        rankTypeRate = 0;
    end
    
    local value = raceTypeRate * sizeTypeRate * rankTypeRate;
    
    return value;
end



function SCR_MON_ITEM_WEAPON_CALC(self)
	local monClassName = TryGetProp(self, "ClassName", "None");
	local monOriginFaction = TryGetProp(GetClass("Monster", monClassName), "Faction");
    if monOriginFaction == "Summon" then
        return 0;
    end
    
    local lv = TryGetProp(self, "Lv", 1);
    lv = math.max(1, lv - 30);
    
    local value = 20 + (lv * 5);
    
    local defList = { };
    defList["Cloth"] = 1.0;
    defList["Leather"] = 1.5 ;
    defList["Iron"] = 1.0;
    
    local armorMaterial = TryGetProp(self, "ArmorMaterial", "None");
    if defList[armorMaterial] ~= nil then
        value = value * defList[armorMaterial];
    end
    
    local byReinforce = 0;
    local byTranscend = 0;
    
    local statType = TryGetProp(self, "StatType", "None");
    if statType ~= nil then
        local statTypeClass = GetClass("Stat_Monster_Type", statType);
        if statTypeClass ~= nil then
            local itemGrade = TryGetProp(statTypeClass, "WeaponGrade", "Normal")
            local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, itemGrade);
            value = math.floor(value * basicGradeRatio);
            
            local reinforceValue = TryGetProp(statTypeClass, "ReinforceWeapon", 0);
            byReinforce = SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local itemTranscend = TryGetProp(statTypeClass, "TranscendWeapon", 0);
            local transcendValue = SCR_MON_ITEM_TRANSCEND_CALC(self, itemTranscend);
            byTranscend = math.floor(value * transcendValue);
        end
    end
    
    value = value + byReinforce + byTranscend;
    
    return math.floor(value);
end

function SCR_MON_ITEM_ARMOR_DEF_CALC(self)
    return SCR_MON_ITEM_ARMOR_CALC(self, "DEF");
end

function SCR_MON_ITEM_ARMOR_MDEF_CALC(self)
    return SCR_MON_ITEM_ARMOR_CALC(self, "MDEF");
end


function SCR_MON_ITEM_ARMOR_CALC(self, defType)
    local lv = TryGetProp(self, "Lv", 1);
    lv = math.max(1, lv - 30);

    local value = (40 + (lv * 8));
    local statType = TryGetProp(self, "StatType", "None");
    local statTypeClass = nil;
    if statType ~= nil then
        statTypeClass = GetClass("Stat_Monster_Type", statType);
    end
    
    if defType ~= nil then
        local defClass = GetClass("item_grade", "armorMaterial_" .. defType);
        local armorMaterial = TryGetProp(self, "ArmorMaterial", "None");
        local defRatio = TryGetProp(defClass, armorMaterial, 1);
        -- 물리 방어력, 마법 방어력 평균치 적용 --
        if statTypeClass ~= nil then
            local averge_def = TryGetProp(statTypeClass, "AVERAGE_DEF", nil);
            if averge_def ~= nil and averge_def ~= 0 then
                local defTypeList = {"DEF", "MDEF"}
                local defRatioTable = {};
                for i = 1, #defTypeList do
                    local defClassType = GetClass("item_grade", "armorMaterial_" .. defTypeList[i]);
                    defRatioTable[#defRatioTable + 1] = TryGetProp(defClassType, armorMaterial, 1);
                end
                
                if averge_def == 1 then
                    if defRatioTable[1] >= defRatioTable[2] then
                        defRatio = defRatioTable[2];
                    else
                        defRatio = defRatioTable[1];
                    end
                elseif averge_def == 2 then
                    if defRatioTable[1] >= defRatioTable[2] then
                        defRatio = defRatioTable[1];
                    else
                        defRatio = defRatioTable[2];
                    end
                end
            end
        end
        
        if defRatio ~= nil then
            value = value * defRatio;
        end
    end
    
    local byReinforce = 0;
    local byTranscend = 0;

    if statType ~= nil then
        if statTypeClass ~= nil then
            local itemGrade = TryGetProp(statTypeClass, "ArmorGrade", "C")
            local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, itemGrade);
            value = math.floor(value * basicGradeRatio);
            
            local reinforceValue = TryGetProp(statTypeClass, "ReinforceArmor", 0);
            byReinforce = SCR_MON_ITEM_REINFORCE_ARMOR_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local itemTranscend = TryGetProp(statTypeClass, "TranscendArmor", 0);
            local transcendValue = SCR_MON_ITEM_TRANSCEND_CALC(self, itemTranscend);
            byTranscend = math.floor(value * transcendValue);
        end
    end
    
    value = value + byReinforce + byTranscend;
    
    return math.floor(value);
end

function SCR_MON_ITEM_GRADE_RATE(self, itemGrade)
    if itemGrade == nil then
        itemGrade = "Normal";
    end

--    if GetExProp(self, "EXPROP_SHADOW_INFERNAL") == 1 then
--        monRank = GetExProp_Str(self, "SHADOW_INFERNAL_MONRANK");
--    end
    
    local gradeList = { "Normal", "Magic", "Rare", "Unique", "Legend" };
    local gradeIndex = table.find(gradeList, itemGrade);

    if gradeIndex == 0 then
        gradeIndex = 1;
    end

    local basicGradeRatio = SCR_GET_ITEM_GRADE_RATIO(gradeIndex, "BasicRatio");
    local reinforceGradeRatio = SCR_GET_ITEM_GRADE_RATIO(gradeIndex, "ReinforceRatio");

    return basicGradeRatio, reinforceGradeRatio;
end

function SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio)
    local value = 0;
    
    value = math.floor((reinforceValue + (math.max(1, lv - 50) * (reinforceValue * (0.08 + (math.floor((math.min(21, reinforceValue) - 1) / 5) * 0.015 ))))));
    value = math.floor(value * reinforceGradeRatio);
    
    return value;
end

function SCR_MON_ITEM_REINFORCE_ARMOR_CALC(self, lv, reinforceValue, reinforceGradeRatio)
    local value = 0;
    value = math.floor((reinforceValue + (math.max(1, lv - 50) * (reinforceValue * (0.12 + (math.floor((math.min(21, reinforceValue) - 1) / 5) * 0.0225 ))))) * 1.25);
    value = math.floor(value * reinforceGradeRatio);
    
    value = value * 2;  -- 방어구는 무기의 2배 --
    
    return value;
end

function SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue)
    local value = transcendValue * 0.1;
    
    return value;
end

function SCR_MON_OWNERITEM_ARMOR_CALC(self, defType)
    local lv = TryGetProp(self, "Lv", 1);
    lv = math.max(1, lv - 30);
    
    local value = (40 + (lv * 8));
    if defType ~= nil then
        local defClass = GetClass("item_grade", "armorMaterial_" .. defType);
        local armorMaterial = TryGetProp(self, "ArmorMaterial", "None");
        local defRatio = TryGetProp(defClass, armorMaterial, 1);
        if defRatio ~= nil then
            value = value * defRatio;
        end
    end

    local owner = GetOwner(self);
    if owner == nil then 
        return;
    end

    local itemSpotList = { "SHIRT", "PANTS", "GLOVES", "BOOTS" };
    local listCnt = #itemSpotList;
    local total_grade = 0;
    local total_reinfroce = 0;
    local total_transcend = 0;
    
    for i = 1, listCnt do
        local item = GetEquipItem(owner, itemSpotList[i]);
        if item == nil then return end;

        local item_grade = TryGetProp(item, "ItemGrade", 1);
        local item_reinforce = TryGetProp(item, "Reinforce_2", 0);
        local item_transcend = TryGetProp(item, "Transcend", 0);

        -- owner item grade
        local byGrade = 0;
        local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(item_grade, "BasicRatio");
        local reinforcegradeRatio = SCR_GET_ITEM_GRADE_RATIO(item_grade, "ReinforceRatio");
        value = value * gradeRatio
        byGrade = gradeRatio;
        
        -- owner item reinforce
        local byReinforce = SCR_MON_ITEM_REINFORCE_ARMOR_CALC(owner, lv, item_reinforce, reinforcegradeRatio);

        -- owner item transcend
        local byTranscend = 0; 
        local transcendValue = SCR_MON_ITEM_TRANSCEND_CALC(owner, item_transcend);
        byTranscend = math.floor(value * transcendValue);

        total_grade = total_grade + byGrade;
        total_reinfroce = total_reinfroce + byReinforce;
        total_transcend = total_transcend + byTranscend;
    end

    total_grade = total_grade / listCnt;
    total_reinfroce = total_reinfroce / listCnt;
    total_transcend = total_transcend / listCnt;

    value = (value * total_grade) + total_reinfroce + total_transcend;
    
    return math.floor(value);
end

function SCR_MON_STAT_RATE(self, prop)
    local statType = TryGetProp(self, "StatType", "None");
    local statTypeRate = 0;
    if statType ~= nil and statType ~= 'None' then
        local statTypeClass = GetClass("Stat_Monster_Type", statType);
        if statTypeClass ~= nil then
            statTypeRate = TryGetProp(statTypeClass, prop, statTypeRate);
            --주간 보스 레이드 25주차 임시 처리--
            if (prop == "DEF" or prop == "MDEF") and statType == "Weekly_Boss" and GetExProp(self, "Weekly_Num") <= 25 then
                statTypeRate = 148;
            end
        end
    end
    
    if statTypeRate == nil or statTypeRate == 0 then
        statTypeRate = 100;
    end
    
    return statTypeRate;
end

function SCR_ANCIENT_INFO_RATE_CALC(rarity, starrank, propName)
    local starrankCls = GetClassByNumProp('Ancient_Rarity','Rarity',rarity)
    local rarityCls = GetClassByNumProp('Ancient_Rank','Rank',starrank)
    return TryGetProp(starrankCls,propName,1) * TryGetProp(rarityCls,propName,1)
end

function SCR_GET_MON_ADD_Damage_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'ADD_Damage_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Widling_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Widling_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Paramune_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Paramune_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Forester_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Forester_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Velnias_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Velnias_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Klaida_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Klaida_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Cloth_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Cloth_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Leather_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Leather_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Chain_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Chain_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Iron_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Iron_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_Ghost_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'Ghost_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_SmallSize_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'SmallSize_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_MiddleSize_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'MiddleSize_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_LargeSize_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'LargeSize_Atk_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end

function SCR_GET_MON_BOSS_ATK(self)
    local value = 0

    local byBuff = TryGetProp(self, 'BOSS_ATK_BM', 0)

    value = value + byBuff

    return math.floor(byBuff)
end