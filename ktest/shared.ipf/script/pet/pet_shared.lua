--- pet_shared.lua

PET_ACTIVATE_COOLDOWN = 5;


function PET_STR(self)
    local ret = GetSumOfPetEquip(self, "STR") + GET_MON_STAT(self, self.Lv, "STR");
    return math.floor(ret);
end

function PET_DEX(self)
    local ret = GetSumOfPetEquip(self, "DEX") + GET_MON_STAT(self, self.Lv, "DEX");
    return math.floor(ret);
end

function PET_CON(self)
    local ret = GetSumOfPetEquip(self, "CON") + GET_MON_STAT(self, self.Lv, "CON");
    return math.floor(ret);
end

function PET_INT(self)
    local ret = GetSumOfPetEquip(self, "INT") + GET_MON_STAT(self, self.Lv, "INT");
    return math.floor(ret);
end

function PET_MNA(self)
    local ret = GetSumOfPetEquip(self, "MNA") + GET_MON_STAT(self, self.Lv, "MNA");
    return math.floor(ret);
end

function PET_GET_MOUNTPATK(self)
    local ret = GetSumOfPetEquip(self, "MountPATK");
    return ret;
end

function PET_GET_MOUNTMATK(self)
    local ret = GetSumOfPetEquip(self, "MountMATK");
    return ret;
end

function PET_GET_MOUNTDEF(self)
    return math.floor(self.DEF * 0.1);
end
 
function PET_GET_MOUNTDR(self)
    return math.floor(self.DR * 0.08);
end
 
function PET_GET_MOUNTMHP(self)
    
    local value = math.floor(self.MHP * 0.25);
    return value;
end

function PET_GET_MOUNTMSPD(self)
    return 0;
end

function PET_MHP_BY_ABIL(statValue)
    return statValue * 27;
end

function PET_GET_MHP(self)
    local owner = self
    if IsZombie(self) ~= 1 then
        owner = GetTopOwner(self)
    end
    
    local lv = TryGetProp(owner, "Lv", 1);
    local standardMHP = lv * 10;
    local byLevel = (standardMHP / 4) * lv;
    local stat = TryGetProp(self, "CON", 1);
    local byStat = (byLevel * (stat * 0.0015)) + (byLevel * (math.floor(stat / 10) * 0.005));
    local value = standardMHP + byLevel + byStat + GetSumOfPetEquip(self, "MHP");
    return math.floor(value);
end

function PET_GET_MHP_C(self, addAbil)
    if addAbil == nil then
        addAbil = 0;
    end
--    local lv = self.Lv;
--    local addLv = self.Level;
--    local ret = (addLv + lv) * 17 + self.CON * 34 + GetSumOfPetEquip_C(self, "MHP") + PET_MHP_BY_ABIL(self.Stat_MHP + addAbil);
--    return math.floor(ret);
    
    local owner = self
    if IsZombie(self) ~= 1 then
        owner = GetTopOwner(self)
    end
    
    local lv = TryGetProp(owner, "Lv", 1);
    local standardMHP = lv * 10;
    local byLevel = (standardMHP / 4) * lv;
    local stat = TryGetProp(self, "CON", 1);
    local byStat = (byLevel * (stat * 0.0015)) + (byLevel * (math.floor(stat / 10) * 0.005));
    local value = standardMHP + byLevel + byStat + GetSumOfPetEquip_C(self, "MHP") + PET_MHP_BY_ABIL(self.Stat_MHP + addAbil);
    return math.floor(value);
end

function PET_GET_RHP(self)
    local baseMHP = self.MHP;
    local lv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip(self, "RHP");
    local value = (lv + addLv) * 0.5 + self.CON + self.RHP_BM + byItem;

    if value < 1 then
        value = 1;
    end

    return math.floor(value);
end

function PET_GET_RHPTIME(self)
    local byItem = GetSumOfPetEquip(self, 'RHPTIME');
    local value = 10000 - byItem;
    return value;
end

function PET_ATK_BY_ABIL(statValue)
    return statValue;
end

function PET_ATK(self)
    local addLv = self.Level;
    local atk = self.Lv + self.STR + addLv + PET_ATK_BY_ABIL(self.Stat_ATK) + self.Stat_ATK_BM;

    local average = GetSumOfPetEquip(self, "MINATK") + GetSumOfPetEquip(self, "MAXATK");
    if average ~= 0 then
        average = average / 2;
        average = average + GetSumOfPetEquip(self, "PATK");
    end

    return math.floor(atk + average);
end

function PET_ATK_C(self, addAbil)
    local addLv = self.Level;
    local atk = self.Lv + self.STR + addLv + PET_ATK_BY_ABIL(self.Stat_ATK + addAbil) + self.Stat_ATK_BM;

    local average = GetSumOfPetEquip_C(self, "MINATK") + GetSumOfPetEquip_C(self, "MAXATK");
    if average ~= 0 then
        average = average / 2;
        average = average + GetSumOfPetEquip_C(self, "PATK");
    end

    return math.floor(atk + average);
end

function PET_MINPATK(self)
    local byStat = self.ATK;
    local byBuff = self.PATK_BM
    local value = byStat + byBuff;
    return math.floor(value);
end

function PET_MAXPATK(self)
    local byStat = self.ATK;
    local byBuff = self.PATK_BM
    local value = byStat + byBuff;
    return math.floor(value);
end

function PET_MINMATK(self)
    local byStat = self.ATK;
    local byItem = GetSumOfPetEquip(self, "MATK") + GetSumOfPetEquip(self, "MINATK");
    local byBuff = self.PATK_BM
    local value = byStat + byItem + byBuff;
    return math.floor(value);
end

function PET_MAXMATK(self)
    local byStat = self.ATK;
    local byItem = GetSumOfPetEquip(self, "MATK") + GetSumOfPetEquip(self, "MAXATK");
    local byBuff = self.PATK_BM
    local value = byStat + byItem + byBuff;
    return math.floor(value)
end

function PET_SR(self)
    local value = SCR_Get_MON_SR(self) + GetSumOfPetEquip(self, "SR");
    return value;
end

function PET_MHR(self)
    local value = 0;
    local itemStat = GetSumOfPetEquip(self, "MHR")

    value = itemStat + self.MHR_BM;
    return math.floor(value);
end

function PET_BLK(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byStat = self.CON;
    local byItem = GetSumOfPetEquip(self, 'BLK');
    
    local blkrate = (byLv + addLv) * 0.5 + byStat + byItem + self.BLK_BM;
    local value = blkrate;
    
    return math.floor(value);
end

function PET_BLK_BREAK(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byStat = self.MNA;
    local byItem = GetSumOfPetEquip(self, 'BLK_BREAK');
    
    local value = (byLv + addLv) * 0.5 + byStat + byItem + self.BLK_BREAK_BM;

    return math.floor(value);
end

function PET_CRTATK(self)
    local byStat = self.STR;
    local byItem = GetSumOfPetEquip(self, "CRTATK");
    local byBuff = self.CRTATK_BM;
    local value = byStat + byItem + byBuff;
    return math.floor(value);
end

function PET_CRTHR_BY_ABIL(statValue)
    return statValue;
end

function PET_CRTHR(self)
    local byStat = self.DEX;
    local byItem = GetSumOfPetEquip(self, "CRTHR");
    local value = byStat + byItem + PET_CRTHR_BY_ABIL(self.Stat_CRTHR) + self.CRTHR_BM + self.Stat_CRTHR_BM;
    return math.floor(value);
end

function PET_CRTHR_C(self, addAbil)
    local byStat = self.DEX;
    local byItem = GetSumOfPetEquip_C(self, "CRTHR");
    local value = byStat + byItem + PET_CRTHR_BY_ABIL(self.Stat_CRTHR + addAbil) + self.CRTHR_BM + self.Stat_CRTHR_BM;
    return math.floor(value);
end

function PET_CRTDR(self)
    local byStat = self.CON;
    local byItem = GetSumOfPetEquip(self, 'CRTDR');
    local value = byStat + byItem + self.CRTDR_BM;
    return math.floor(value);
end

function PET_DEF_BY_ABIL(statValue)
    return statValue;
end

function PET_DEF(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip(self, 'DEF');
    local ret = (byLv + addLv) / 2 + byItem + PET_DEF_BY_ABIL(self.Stat_DEF);
    return math.floor(ret);
end

function PET_DEF_C(self, addAbil)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip_C(self, 'DEF');
    local ret = (byLv + addLv) / 2 + byItem + PET_DEF_BY_ABIL(self.Stat_DEF + addAbil);
    return math.floor(ret);
end

function PET_MDEF_BY_ABIL(statValue)
    return statValue;
end

function PET_MDEF(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip(self, 'MDEF') + GetSumOfPetEquip(self, 'ADD_MDEF');
    local ret = (byLv + addLv) / 2 + byItem + PET_MDEF_BY_ABIL(self.Stat_MDEF);
    return math.floor(ret);
end

function PET_MDEF_C(self, addAbil)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip_C(self, 'MDEF') + GetSumOfPetEquip_C(self, 'ADD_MDEF');
    local ret = (byLv + addLv) / 2 + byItem + PET_MDEF_BY_ABIL(self.Stat_MDEF + addAbil);
    return math.floor(ret);
end

function PET_SDR(self)

    local value = SCR_Get_MON_SDR(self) + GetSumOfPetEquip(self, "SDR");
    
    return value;
end

function PET_DR_BY_ABIL(statValue)
    return statValue;
end

function PET_DR(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip(self, "DR")
    local ret = byLv + addLv + byItem + self.DEX + PET_DR_BY_ABIL(self.Stat_DR);
    return math.floor(ret);
end

function PET_DR_C(self, addAbil)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip_C(self, "DR")
    local ret = byLv + addLv + byItem + self.DEX + PET_DR_BY_ABIL(self.Stat_DR + addAbil);
    return math.floor(ret);
end

function PET_HR_BY_ABIL(statValue)
    return statValue;
end

function PET_HR(self)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip(self, "HR")
    local ret = byLv + addLv + byItem + self.DEX + PET_HR_BY_ABIL(self.Stat_HR) + self.Stat_HR_BM;
    return math.floor(ret);
end

function PET_HR_C(self, addAbil)
    local byLv = self.Lv;
    local addLv = self.Level;
    local byItem = GetSumOfPetEquip_C(self, "HR")
    local ret = byLv + addLv + byItem + self.DEX + PET_HR_BY_ABIL(self.Stat_HR + addAbil) + self.Stat_HR_BM;
    return math.floor(ret);
end

function GET_PET_STAT_PRICE(pc, pet, statName, val)
    local defPrice = 300;
    if statName  == "DEF" then
        defPrice = 600;
    end

    if val == nil then
        val = pet["Stat_" .. statName];
    end 
    return math.floor(defPrice * math.pow(1.08, val - 1));
end

--function PET_ADD_FIRE(self)
--    local value = GetSumOfPetEquip(self, "ADD_FIRE") + self.ADD_FIRE_BM;
--    return value;
--end
--
--function PET_ADD_ICE(self)
--    local value = GetSumOfPetEquip(self, "ADD_ICE") + self.ADD_ICE_BM;
--    return value;
--end
--
--function PET_ADD_LIGHTNING(self)
--    local value = GetSumOfPetEquip(self, "ADD_LIGHTNING") + self.ADD_LIGHTNING_BM;
--    return value;
--end
--
--function PET_ADD_EARTH(self)
--    local value = GetSumOfPetEquip(self, "ADD_EARTH") + self.ADD_EARTH_BM;
--    return value;
--end
--
--function PET_ADD_POISON(self)
--    local value = GetSumOfPetEquip(self, "ADD_POISON") + self.ADD_POISON_BM;
--    return value;
--end
--
--function PET_ADD_HOLY(self)
--    local value = GetSumOfPetEquip(self, "ADD_HOLY") + self.ADD_HOLY_BM;
--    return value;
--end
--
--function PET_ADD_DARK(self)
--    local value = GetSumOfPetEquip(self, "ADD_DARK") + self.ADD_DARK_BM;
--    return value;
--end
--
--function PET_Fire_Def(self)
--    local value = GetSumOfPetEquip(self, "Fire_Def") + self.Fire_Def_BM;
--    return value;
--end
--
--function PET_Ice_Def(self)
--    local value = GetSumOfPetEquip(self, "Ice_Def") + self.Ice_Def_BM;
--    return value;
--end
--
--function PET_Lightning_Def(self)
--    local value = GetSumOfPetEquip(self, "Lightning_Def") + self.Lightning_Def_BM;
--    return value;
--end
--
--function PET_Earth_Def(self)
--    local value = GetSumOfPetEquip(self, "Earth_Def") + self.Earth_Def_BM;
--    return value;
--end
--
--function PET_Poison_Def(self)
--    local value = GetSumOfPetEquip(self, "Poison_Def") + self.Poison_Def_BM;
--    return value;
--end
--
--function PET_Holy_Def(self)
--    local value = GetSumOfPetEquip(self, "Holy_Def") + self.Holy_Def_BM;
--    return value;
--end
--
--function PET_Dark_Def(self)
--    local value = GetSumOfPetEquip(self, "Dark_Def") + self.Dark_Def_BM;
--    return value;
--end

function PET_REVIVE_PRICE(obj)
    return 100;
end

function CHECK_PET_IS_DEAD(obj, petObj, serverSysTime)

    local lifeMin = petObj.LifeMin;
    local learnAbilTime = imcTime.GetSysTimeByStr(obj.AdoptTime);
    local difSec = imcTime.GetDifSec(serverSysTime, learnAbilTime);
    local difMin = difSec / 60;
    local overMinute = difMin - lifeMin;
    local overDate = GET_PET_OVER_DATE(overMinute);
    if overDate >= 10 then
        return 1;
    end

    return 0;

end

function GET_PET_OVER_DATE(overMinute)

    -- return math.floor(overMinute / 1440) + 1;
    return overMinute * 10;
end