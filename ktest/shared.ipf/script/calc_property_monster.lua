-- util
function GET_MON_STAT(self, lv, statStr)
    local allStatMax = 10 + lv;
    local statRate = TryGetProp(self, statStr .. "_Rate");
    if statRate == nil then
        statRate = 0;
    end
    
    local totalStatRate = 0;
    local statRateList = { 'STR', 'INT', 'CON', 'MNA', 'DEX' };
    
    for i = 1, #statRateList do
        local statRateTemp = TryGetProp(self, statRateList[i] .. "_Rate")
        if statRateTemp == nil then
            statRateTemp = 0;
        end
        totalStatRate = totalStatRate + statRateTemp;
    end
    
    local value = allStatMax * (statRate / totalStatRate) + math.floor(lv / 10);
    
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
    local isHPCount = TryGetProp(self, "HPCount");
    if isHPCount ~= nil then
        if isHPCount > 0 then
            return isHPCount;
        end
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = 30 * lv;
    
    local stat = TryGetProp(self, "CON")
    if stat == nil then
        stat = 1;
    end
    
--    local byOwner = 0;
--    local myOwner = GetTopOwner(self);
--    if myOwner ~= nil then
--        if myOwner.ClassName == 'PC' then
--            local ownerMNA = TryGetProp(myOwner, "MNA");
--            if ownerMNA == nil then
--                ownerMNA = 1;
--            end
--            stat = stat + ownerMNA;
--        end
--    end
    
    local byStat = (byLevel * (stat * 0.005)) + (byLevel * (math.floor(stat / 10) * 0.015));
    
    local value = byLevel + byStat
    
    local byMHPRate = TryGetProp(self, "MHPRate");
    if byMHPRate == nil then
        byMHPRate = 100;
    end
    
    byMHPRate = byMHPRate / 100;
    
    local statTypeRate = 100;
    local statType = TryGetProp(self, "StatType");
    if statType ~= nil and statType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", "type"..statType);
        if cls2 ~= nil then
            local clsHP = TryGetProp(cls2, "HP");
            statTypeRate = clsHP;
        end
    end
    
    statTypeRate = statTypeRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MHP");
    local sizeTypeRate = SCR_SIZE_TYPE_RATE(self, "MHP");
    
--    if TryGetProp(self, "Faction") == "Summon" then
--        local ratio = 0.2;
--        if TryGetProp(self, "MonRank") == "Boss" then
--            ratio = 1.0;
--        end
--        value = math.floor(value * ratio);
--    end
    
    value = value * (byMHPRate * statTypeRate * raceTypeRate * sizeTypeRate);
    
    value = value * JAEDDURY_MON_MHP_RATE;      -- JAEDDURY
    
    local byBuff = TryGetProp(self, "MHP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    value = value + byBuff;
    
    if "Summon" == TryGetProp(self, "Faction") then
        value = value + 5000;   -- PC Summon Monster MHP Add
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
    if self.EXP_Rate + self.JEXP_Rate == 0 then
        return 0;
    end
    
    local level = GetExProp(self, "LEVEL_FOR_EXP");
    if level == 0 then
        level = self.Lv;
    end
    
    local multipleValue = 0;
    
    local cls = GetClassByType("Stat_Monster", level);
    local value = cls.EXP_BASE;    
    
    local expValue = 100;
    if self.StatType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
        if cls2 ~= nil then
            expValue = cls2.EXP;
        end
    end
    
    value = value * (expValue / 100) * (self.EXP_Rate / 100);
    
    return math.floor(value);
end

function SCR_GET_MON_JOBEXP(self)
    if self.EXP_Rate + self.JEXP_Rate == 0 then
        return 0;
    end
    
    local level = self.Lv;
    local multipleValue = 0;    
    
    local cls = GetClassByType("Stat_Monster", level);
    local value = cls.JEXP_BASE;
    
    local jexpValue = 100;
    if self.StatType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
        if cls2 ~= nil then
            jexpValue = cls2.JEXP;
        end
    end
    
--    if self.EXP_Rate ~= 0 then
--        local mul = (self.EXP_Rate + self.JEXP_Rate) / 2;       
--        mul = (mul - 100) / 3 + 100;
--        value = value * self.JEXP_Rate / mul;
--    end
    
    value = value * (jexpValue / 100) * (self.JEXP_Rate / 100);
    
    return math.floor(value);
end

function SCR_Get_MON_DEF(self)
    local fixedDEF = TryGetProp(self, "FixedDefence");
    if fixedDEF ~= nil and fixedDEF > 0 then
        return fixedDEF;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local byItem = SCR_MON_ITEM_ARMOR_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceArmor;
            byReinforce = SCR_MON_ITEM_REINFORCE_ARMOR_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendArmor;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    byItem = math.floor(byItem * byTranscend) + byReinforce;
    
    local value = byLevel + byItem;
    
    local byDEFRate = TryGetProp(self, "DEFRate")
    if byDEFRate == nil then
        byDEFRate = 100;
    end
    
    byDEFRate = byDEFRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "DEF");
    
    value = value * (byDEFRate * raceTypeRate);
    
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
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value)
end



function SCR_Get_MON_MDEF(self)
    local fixedDEF = TryGetProp(self, "FixedDefence");
    if fixedDEF ~= nil and fixedDEF > 0 then
        return fixedDEF;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 1.0;
    
    local byItem = SCR_MON_ITEM_ARMOR_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceArmor;
            byReinforce = SCR_MON_ITEM_REINFORCE_ARMOR_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendArmor;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    byItem = math.floor(byItem * byTranscend) + byReinforce;
    
    local value = byLevel + byItem;
    
    local byMDEFRate = TryGetProp(self, "MDEFRate")
    if byMDEFRate == nil then
        byMDEFRate = 100;
    end
    
    byMDEFRate = byMDEFRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "MDEF");
    
    value = value * (byMDEFRate * raceTypeRate);
    
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
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value)
end



function SCR_Get_MON_HR(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "STR");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local monHitRate = TryGetProp(self, "HitRate")
    if monHitRate == nil then
        monHitRate = 100;
    end
    
    monHitRate = monHitRate / 100;
    
    local byBuff = self.HR_BM
    
    local value = ((byLevel + byStat) * monHitRate) + byBuff;
    
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
    
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "DEX");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local monDodgeRate = TryGetProp(self, "DodgeRate")
    if monDodgeRate == nil then
        monDodgeRate = 100;
    end
    
    monDodgeRate = monDodgeRate / 100;
    
    local byBuff = self.DR_BM
    
    local value = ((byLevel + byStat) * monDodgeRate) + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_MHR(self)
    local value = 0;    
    --local lv = self.Lv;

    --local lvValue = lv;
    --local monStatValue = self.INT;
    
    --value = lvValue + (lvValue + 4);
    --value = value + monStatValue;
--  local itemStat = GET_MON_ITEM_STAT(self, self.Lv, "HR")

    value = value + self.MHR_BM;
    return math.floor(value);   
end



function SCR_Get_MON_CRTHR(self)
    local lv = self.Lv;
    local byLevel = lv * 0.5;
    
    local monCRTHitRate = TryGetProp(self, "CRTHitRate")
    if monCRTHitRate == nil then
        monCRTHitRate = 100;
    end
    
    monCRTHitRate = monCRTHitRate / 100;
    
    local byBuff = self.CRTHR_BM;
    
    local value = (byLevel * monCRTHitRate) + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_CRTDR(self)
--  local lv = self.Lv;
--    local byLevel = lv * 0.5;
--    
--  local monCRTDodgeRate = TryGetProp(self, "CRTDodgeRate")
--  if monCRTDodgeRate == nil then
--      monCRTDodgeRate = 100;
--  end
--  
--  monCRTDodgeRate = monCRTDodgeRate / 100;
--  
--  local byBuff = self.CRTDR_BM;
--    
--    local value = (byLevel * monCRTDodgeRate) + byBuff;
--    
--  return math.floor(value);

    local lv = self.Lv;
    local byLevel = lv * 0.5;
    
    local byBuff = self.CRTDR_BM;
    
    local value = byLevel + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_CRTATK(self)
    local stat = TryGetProp(self, "DEX");
    if stat == nil then
        stat = 1;
    end
    
    local value = (stat * 2) + (math.floor(stat / 10) * 5);
    
    return math.floor(value);
end

function SCR_Get_MON_ATKRATIO(self)
    local atkRatio = 100;
    if self.StatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..self.StatType);
        if cls ~= nil then
            atkRatio = cls.ATK;
        end
    end
    
    atkRatio = atkRatio / 100;
    return atkRatio;
end


function SCR_Get_MON_MINPATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local stat = TryGetProp(self, "STR");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * 5);
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceWeapon;
            byReinforce = SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendWeapon;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    
    byItem = math.floor(byItem * byTranscend) + math.floor(byReinforce);
    
    local value = byLevel + byStat + byItem;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (2.0 - range / 100.0);
    
    local byATKRate = TryGetProp(self, "ATKRate")
    if byATKRate == nil then
        byATKRate = 100;
    end
    
    byATKRate = byATKRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "ATK");
    
    value = value * (byATKRate * raceTypeRate);
    
    local byBuff = TryGetProp(self, "PATK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "PATK_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_MAXPATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local stat = TryGetProp(self, "STR");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * 5);
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceWeapon;
            byReinforce = SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendWeapon;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    byItem = math.floor(byItem * byTranscend) + math.floor(byReinforce);
    
    local value = byLevel + byStat + byItem
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (range / 100.0)
    
    local byATKRate = TryGetProp(self, "ATKRate")
    if byATKRate == nil then
        byATKRate = 100;
    end
    
    byATKRate = byATKRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "ATK");
    
    value = value * (byATKRate * raceTypeRate);
    
    local byBuff = TryGetProp(self, "PATK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "PATK_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_MINMATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local stat = TryGetProp(self, "INT");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * 5);
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceWeapon;
            byReinforce = SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendWeapon;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    byItem = math.floor(byItem * byTranscend) + math.floor(byReinforce);
    
    local value = byLevel + byStat + byItem;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (2.0 - range / 100.0);
    
    local byATKRate = TryGetProp(self, "ATKRate")
    if byATKRate == nil then
        byATKRate = 100;
    end
    
    byATKRate = byATKRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "ATK");
    
    value = value * (byATKRate * raceTypeRate);
    
    local byBuff = TryGetProp(self, "MATK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "MATK_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_MAXMATK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local stat = TryGetProp(self, "INT");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 10) * 5);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local byItem = SCR_MON_ITEM_WEAPON_CALC(self, lv);
    local basicGradeRatio, reinforceGradeRatio = SCR_MON_ITEM_GRADE_RATE(self, lv);
    
    local byReinforce = 0;
    local byTranscend = 1;
    
    local monStatType = TryGetProp(self, "StatType");
    if monStatType ~= nil and monStatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..monStatType);
        if cls ~= nil then
            local reinforceValue = cls.ReinforceWeapon;
            byReinforce = SCR_MON_ITEM_REINFORCE_WEAPON_CALC(self, lv, reinforceValue, reinforceGradeRatio);
            
            local transcendValue = cls.TranscendWeapon;
            byTranscend = SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue);
        end
    end
    
    byItem = math.floor(byItem * basicGradeRatio);
    byItem = math.floor(byItem * byTranscend) + math.floor(byReinforce);
    
    local value = byLevel + byStat + byItem;
    
    local monAtkRange = TryGetProp(self, "ATK_RANGE");
    if monAtkRange == nil then
        monAtkRange = 100;
    end
    
    local range = MinMaxCorrection(monAtkRange, 100, 200);
    
    value = value * (range / 100.0);
    
    local byATKRate = TryGetProp(self, "ATKRate")
    if byATKRate == nil then
        byATKRate = 100;
    end
    
    byATKRate = byATKRate / 100;
    
    local raceTypeRate = SCR_RACE_TYPE_RATE(self, "ATK");
    
    value = value * (byATKRate * raceTypeRate);
    
    local byBuff = TryGetProp(self, "MATK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "MATK_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
    value = value + byBuff + byRateBuff;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MON_BLKABLE(self)
    if self.HPCount > 0 then
        return 0;
    end

    return self.Blockable;
end

function SCR_Get_MON_BLK(self)
    if self.Blockable == 0 then
        return 0;
    end
    
    local lv = self.Lv;
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local monBlockRate = TryGetProp(self, "BlockRate");
    if monBlockRate == nil then
        monBlockRate = 100;
    end
    
    monBlockRate = (byLevel + byStat) * (monBlockRate * 0.01);
    
    local byBuff = TryGetProp(self, "BLK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + monBlockRate + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MON_BLK_BREAK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "DEX");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local byBuff = TryGetProp(self, "BLK_BREAK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + byBuff;
    
    return math.floor(value);
end


-- old

function SCR_Get_MON_KDArmorType(self)
    if self.HPCount > 0 then
        return 9999;
    end


    local value = self.KDArmor;
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

    local value = 0;
    value = value + self.RHP_BM;
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
function SCR_Get_MON_ADD_FIRE(self)

    local value = 0;
    value = value + self.ADD_FIRE_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_ICE(self)

    local value = 0;
    value = value + self.ADD_ICE_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_POISON(self)

    local value = 0;
    value = value + self.ADD_POISON_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_LIGHTNING(self)

    local value = 0;
    value = value + self.ADD_LIGHTNING_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_SOUL(self)

    local value = 0;
    value = value + self.ADD_SOUL_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_EARTH(self)

    local value = 0;
    value = value + self.ADD_EARTH_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_HOLY(self)

    local value = 0;
    value = value + self.ADD_HOLY_BM;
    return math.floor(value);
end

function SCR_Get_MON_ADD_DARK(self)

    local value = 0;
    value = value + self.ADD_DARK_BM;
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
 
    local fixMspd = self.FIXMSPD_BM;

    if fixMspd ~= 0.0 then
        return math.max(0, fixMspd);
    end

    local wlkMspd = self.WlkMSPD;
    if wlkMspd == 0 then
        return 0;
    end

    local moveType = GetExProp(self, 'MOVE_TYPE_CURRENT');
    
    if moveType ~= 0 then
        local moveSpd = wlkMspd + self.MSPD_BM;
        if moveType == 2 then
            moveSpd = self.RunMSPD + self.MSPD_BM;
        elseif moveType == 3 then
            moveSpd = wlkMspd + self.RunMSPD + self.MSPD_BM;
        end
    
        return moveSpd;
    end
    
    local value = 0;
    value = wlkMspd + self.MSPD_BM;
    if value < 0 then
        value = 0;
    end

    local mspdValue = 100;
    if self.StatType ~= 'None' then
        local cls2 = GetClass("Stat_Monster_Type", "type"..self.StatType);
        if cls2 ~= nil then
            mspdValue = cls2.MoveSpeed;
        end
    end
    
    value = value * mspdValue / 100;
    
    value = value * (100 + self.SPD_BM) / 100;
    
    value = value * SERV_MSPD_FIX;
    return math.floor(value);
end


function SCR_Get_MON_minRange(self)

    local value = 0;
    value = self.MinR;
    return math.floor(value);
end

function SCR_Get_MON_maxRange(self)

    local value = 0;
    value = self.MaxR;
    value = value + self.maxRange_BM;
    if value < (self.MinR + 2) then
        value = self.MinR + 2;
    elseif value > 300 then
        value = 300;
    end
    return math.floor(value);
end

function SCR_Get_MON_KDPow(self)

    local value = 0;
    value = value + self.KDPow_BM;
    value = value * self.KDRank;
    return math.floor(value);
end

---------------------------------KnockDown-------------------------
function SCR_GET_MON_KDBONUS(self)
    local basestat = 120;
    local byStat = basestat;
    local byLevel = 10 * self.Lv;
    local byBuff = self.KDBonus_BM;
    value = byStat + byLevel + byBuff;
    return value;
end

function SCR_GET_MON_KDDEFENCE(self)
    local basestat = 80;
    local byStat = basestat;
    local byLevel = 10 * self.Lv;
    local byBuff = self.KDBonus_BM;
    value = byStat + byLevel + byBuff;
    return value;
end
---------------------------------------------------------------------

function SCR_Get_MON_MGP(self)

    return 65535;

end

function SCR_Get_MON_SR(self)
    local value = self.MonSR + self.SR_BM;
    return math.floor(value)
end

function SCR_Get_MON_SDR(self)
    local value = 5;
    
    if self.MonSDR < 0 then -- ?º??
        return -1;
    elseif self.Size == 'S' then
        value = 1;
    elseif self.Size == 'M' then
        value = 2;
    elseif self.Size == 'L' then
        value = 3;
    end
    
    return value + self.SDR_BM;
end

function SCR_GET_MONSKL_COOL(skill)
    return skill.BasicCoolDown;
end

function SCR_MON_COMBOABLE(mon)

    if mon.GroupName == "Monster" then
        return 1;
    end
    
    return 0;

end

function SCR_GET_MON_FIRE_DEF(self)
    local value = 0;
    value = self.Fire_Def_BM;
    return value;
end

function SCR_GET_MON_ICE_DEF(self)
    local value = 0;
    value = self.Ice_Def_BM;
    return value;
end

function SCR_GET_MON_POISON_DEF(self)
    local value = 0;
    value = self.Poison_Def_BM;
    return value;
end

function SCR_GET_MON_LIGHTNING_DEF(self)
    local value = 0;
    value = self.Lightning_Def_BM;
    return value;
end

function SCR_GET_MON_SOUL_DEF(self)
    local value = 0;
    value = self.Soul_Def_BM;
    return value;
end

function SCR_GET_MON_EARTH_DEF(self)
    local value = 0;
    value = self.Earth_Def_BM;
    return value;
end

function SCR_GET_MON_HOLY_DEF(self)
    local value = 0;
    value = self.Holy_Def_BM;
    return value;
end

function SCR_GET_MON_DARK_DEF(self)
    local value = 0;
    value = self.Dark_Def_BM;
    return value;
end

function SCR_GET_MON_LIMIT_BUFF_COUNT(self)
    
    local count = 10;
    count = count + self.LimitBuffCount_BM;
    return count;
end

-- hardskill_sorcerer.lua ?? ???????? shared?? ?????? ?????... ????? ?????? ???? ????
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
    self.StatType = 30
        
    local monDef = self.DEF;
    local monMDef = self.MDEF;

    local sklbonus = 1 + skl.Level * 0.1
    local itembonus = 1 + item.Level * 0.1
    self.MATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
    self.PATK_BM = (500 + (caster.INT * sklbonus)) * itembonus
    
    self.DEF_BM = (monDef / 2  + (caster.MNA * sklbonus)) * itembonus
    self.MDEF_BM = (monMDef / 2 + (caster.MNA * sklbonus)) * itembonus
end

function SCR_GET_MON_SKILLFACTORRATE(self)
    local value = 100;
    if self.StatType ~= 'None' then
        local cls = GetClass("Stat_Monster_Type", "type"..self.StatType);
        if cls ~= nil then
            value = cls.SkillFactorRate;
        end
    end
    
--    local byOwner = 0;
--    local myOwner = GetTopOwner(self);
--    if myOwner ~= nil then
--        if myOwner.ClassName == 'PC' then
--            local ownerLv = TryGetProp(myOwner, "Lv");
--            if ownerLv == nil then
--                ownerLv = 1;
--            end
--            
--            local ownerMNA = TryGetProp(myOwner, "MNA");
--            if ownerMNA == nil then
--                ownerMNA = 1;
--            end
--            
--            byOwner = math.floor(value * (ownerMNA / (ownerLv + 1)));
--            if byOwner < 0 then
--                byOwner = 0;
--            end
--        end
--    end
    
    local byBuff = TryGetProp(self, "SkillFactorRate_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "SkillFactorRate_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = value * byRateBuff;
    
--    value = value + byOwner;
    
    value = value + byBuff + byRateBuff;
    
    return value;
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



function SCR_RACE_TYPE_RATE(self, prop)
    local raceTypeRate = 1.0;
    
    local raceList = { "Widling", "Forester", "Paramune", "Velnias", "Klaida" };
    local raceRateList = { };
    
    -- ?￢기??????로?¼티뱿raceTypeList --
    raceRateList["ATK"] = { 1.0, 1.0, 1.0, 1.0, 1.0 };
    raceRateList["DEF"] = { 0.95, 0.8, 1, 0.9 , 0.85 };
    raceRateList["MDEF"] = { 0.85, 1, 0.8, 0.9, 0.95 };
    raceRateList["MHP"] = { 1.0, 1.0, 1.0, 1.0, 1.0 };
    
    if raceRateList[prop] == nil then
        return 1.0;
    end
    
    raceRateList = raceRateList[prop];
    
    for i = 1, #raceList do
        local raceType = TryGetProp(self, "RaceType");
        if raceType == raceList[i] then
            if raceRateList[i] ~= nil and raceRateList[i] > 0 then
                raceTypeRate = raceRateList[i];
            end
            
            break;
        end
    end
    
    return raceTypeRate;
end



function SCR_SIZE_TYPE_RATE(self, prop)
    local sizeTypeRate = 1.0;
    
    local sizeList = { "S", "M", "L", "XL" };
    local sizeRateList = { };
    
--  기존 raceTypeList --
--    sizeRateList["ATK"] = { 1.0, 1.0, 1.0, 1.0, 1.0 };
--    sizeRateList["DEF"] = { 1.6, 0.72, 2.0, 1.2, 0.8 };
--    sizeRateList["MDEF"] = { 1.0, 1.0, 1.0, 1.0, 1.0 };
    sizeRateList["MHP"] = { 0.8, 1, 1.25, 1.5 };
    
    if sizeRateList[prop] == nil then
        return 1.0;
    end
    
    sizeRateList = sizeRateList[prop];
    
    for i = 1, #sizeList do
        local sizeType = TryGetProp(self, "Size");
        if sizeType == sizeList[i] then
            if sizeRateList[i] ~= nil and sizeRateList[i] > 0 then
                sizeTypeRate = sizeRateList[i];
            end
            
            break;
        end
    end
    
    return sizeTypeRate;
end



function SCR_MON_ITEM_WEAPON_CALC(self, lv)
    local value = 20 + (math.max(1, lv - 50) * 3);
    local value = value * 1.0;
    return math.floor(value);
end

function SCR_MON_ITEM_ARMOR_CALC(self, lv)
    local value = 20 + (math.max(1, lv - 50) * 3);
    value = value * 1.0;
    return math.floor(value);
end

function SCR_MON_ITEM_GRADE_RATE(self, lv)
    local monRank = TryGetProp(self, "MonRank");
    if monRank == nil then
        monRank = "Normal";
    end
    
    local basicGradeRatio = 1;
    local reinforceGradeRatio = 1;
    
    if monRank == "Normal" or monRank == "Material" then
        basicGradeRatio = 0.9;  --normal
        reinforceGradeRatio = 1.0;
    elseif monRank == "Special" then
        basicGradeRatio = 1.0;  --rare
        reinforceGradeRatio = 1.2;
    elseif monRank == "Elite" then
        basicGradeRatio = 1.1;  --rare
        reinforceGradeRatio = 1.5;
    elseif monRank == "Boss" then
        basicGradeRatio = 1.25;  --unique
        reinforceGradeRatio = 2.0;
    end
    
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
    value = math.floor((reinforceValue + (math.max(1, lv - 50) * (reinforceValue * (0.12 + (math.floor((math.min(21, reinforceValue) - 1) / 5) * 0.0225 ))))));
    value = math.floor(value * reinforceGradeRatio);
    
    return value;
end

function SCR_MON_ITEM_TRANSCEND_CALC(self, transcendValue)
    local value = 0;
    value = 1 + (transcendValue * 0.2);
    
    return value;
end