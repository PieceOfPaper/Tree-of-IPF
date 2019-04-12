function SCR_GET_JOB_STR(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.STR;
    end
    
    return 1;
end

function SCR_GET_JOB_DEX(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.DEX;
    end
    
    return 1;
end

function SCR_GET_JOB_CON(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.CON;
    end
    
    return 1;
end

function SCR_GET_JOB_INT(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.INT;
    end
    
    return 1;
end

function SCR_GET_JOB_MNA(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.MNA;
    end
    
    return 1;
end

function SCR_GET_JOB_LUCK(pc)
    local jobObj = GetJobObject(pc);
    if jobObj ~= nil then
        return jobObj.LUCK;
    end
    
    return 1;
end

function SCR_Get_Const(self)
    local lv = TryGetProp(self, "Lv")
    if lv == nil then
        lv = 1;
    end
    
    local value = (lv + 5) / math.pi
    
    return value;
end

function GET_STAT_POINT(pc)
    local byLevel = TryGetProp(pc, "StatByLevel")
    if byLevel == nil then
        byLevel = 0;
    end
    
    local byBonus = TryGetProp(pc, "StatByBonus")
    if byBonus == nil then
        byBonus = 0;
    end
    
    local usedStat = TryGetProp(pc, "UsedStat")
    if usedStat == nil then
        usedStat = 0;
    end
    
    return math.floor(byLevel + byBonus - usedStat);
end

function SCR_GET_MAX_WEIGHT(pc)
    local defaultWeight = 8000;
    
    local byBonus = TryGetProp(pc, "MaxWeight_Bonus")
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byBuff = TryGetProp(pc, "MaxWeight_BM")
    if byBuff == nil then
        byBuff = 0
    end
    
    local byRateBuff = TryGetProp(pc, "MaxWeight_RATE_BM")
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = defaultWeight * byRateBuff;
    
    local rewardProperty = GET_REWARD_PROPERTY(pc, "MaxWeight")
    
    local value = defaultWeight + byBonus + byBuff + byRateBuff + rewardProperty;
    
    return math.floor(value);
end

function SCR_GET_NOW_WEIGHT(pc)
    return GetTotalItemWeight(pc);
end

function SCR_GET_ADDSTAT(self, stat)
    -- 스탯 올릴 때 보너스로 올라가는 스탯 --
    -- 2017년 3월 3일 리밸런싱으로 삭제 --
    
    local addStat = 0;
    
    return math.floor(addStat);
end

function SCR_GET_STR(self)
    -- self.STR_JOB : job.xml에 있는 "기본 스탯" --
    -- self.STR_STAT : pc.xml에 있는 "직접 투자한 스탯" --
    -- self.STR_Bonus : pc_battle.xml에 있지만 0 --
    -- self.STR_ADD : 장비, 버프 등 가변적인 스탯 --
    -- GetExProp(self, "STR_TEMP") : 임시로 지정한 추가 스탯 (아마도 PVP 보정용?) --
    -- rewardProperty : 퀘스트 등에서 보상으로 지급한 스탯 (현재는 지급되는 곳 없음?) --
    
    local statString = "STR";
    
    local byJob = TryGetProp(self, statString.."_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, statString.."_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byBonus = TryGetProp(self, statString.."_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byAdd = TryGetProp(self, statString.."_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local byTemp = GetExProp(self, statString.."_TEMP");
    if byTemp == nil then
        byTemp = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, statString);
    
    local value = byJob + byStat + byBonus + byAdd + byTemp + rewardProperty;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_ADDSTR(self)
    local statString = "STR";
    
    local byItem = GetSumOfEquipItem(self, statString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0
    end
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end

function SCR_GET_DEX(self)
    local statString = "DEX";
    
    local byJob = TryGetProp(self, statString.."_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, statString.."_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byBonus = TryGetProp(self, statString.."_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byAdd = TryGetProp(self, statString.."_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local byTemp = GetExProp(self, statString.."_TEMP");
    if byTemp == nil then
        byTemp = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, statString);
    
    local value = byJob + byStat + byBonus + byAdd + byTemp + rewardProperty;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_ADDDEX(self)
    local statString = "DEX";
    
    local byItem = GetSumOfEquipItem(self, statString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0
    end
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end


function SCR_GET_CON(self)
    local statString = "CON";
    
    local byJob = TryGetProp(self, statString.."_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, statString.."_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byBonus = TryGetProp(self, statString.."_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byAdd = TryGetProp(self, statString.."_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local byTemp = GetExProp(self, statString.."_TEMP");
    if byTemp == nil then
        byTemp = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, statString);
    
    local byEnchant = 0;
    local enchantCount = CountEnchantItemEquip(self, 'ENCHANTARMOR_VOLITIVE');
    if enchantCount > 0 then
        local enchantStatString = "MNA";
        
        local enchantByJob = TryGetProp(self, enchantStatString.."_JOB");
        local enchantByStat = TryGetProp(self, enchantStatString.."_STAT");
        local enchantByBonus = TryGetProp(self, enchantStatString.."_Bonus");
        local enchantByTemp = GetExProp(self, enchantStatString.."_TEMP");
        local enchantRewardProp = GET_REWARD_PROPERTY(self, statString);
        
        byEnchant = ((enchantByJob + enchantByStat + enchantByBonus + enchantByTemp + enchantRewardProp) / 20) * enchantCount;
    end
    
    local value = byJob + byStat + byBonus + byAdd + byTemp + rewardProperty + byEnchant;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_ADDCON(self)
    local statString = "CON";
    
    local byItem = GetSumOfEquipItem(self, statString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0
    end
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end

function SCR_GET_INT(self)
    local statString = "INT";
    
    local byJob = TryGetProp(self, statString.."_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, statString.."_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byBonus = TryGetProp(self, statString.."_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byAdd = TryGetProp(self, statString.."_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local byTemp = GetExProp(self, statString.."_TEMP");
    if byTemp == nil then
        byTemp = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, statString);
    
    local value = byJob + byStat + byBonus + byAdd + byTemp + rewardProperty;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_ADDINT(self)
    local statString = "INT";
    
    local byItem = GetSumOfEquipItem(self, statString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0
    end
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end

function SCR_GET_MNA(self)
    local statString = "MNA";
    
    local byJob = TryGetProp(self, statString.."_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, statString.."_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byBonus = TryGetProp(self, statString.."_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byAdd = TryGetProp(self, statString.."_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local byTemp = GetExProp(self, statString.."_TEMP");
    if byTemp == nil then
        byTemp = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, statString);
    
    local value = byJob + byStat + byBonus + byAdd + byTemp + rewardProperty;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_ADDMNA(self)
    local statString = "MNA";
    
    local byItem = GetSumOfEquipItem(self, statString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, statString.."_BM");
    if byBuff == nil then
        byBuff = 0
    end
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end

function SCR_GET_LUCK(self)
    local byJob = TryGetProp(self, "LUCK_JOB");
    if byJob == nil then
        byJob = 0;
    end
    
    local byStat = TryGetProp(self, "LUCK_STAT");
    if byStat == nil then
        byStat = 0;
    end
    
    local byAdd = TryGetProp(self, "LUCK_ADD");
    if byAdd == nil then
        byAdd = 0;
    end
    
    local value = math.floor(byJob + byStat + byAdd);
    
    return math.max(1, value);

end

function SCR_GET_ADDLUCK(self)
    local statString = "LUCK";
    
    local byItem = GetSumOfEquipItem(self, statString);
    local byBuff = TryGetProp(self, statString.."_BM");
    
    local byItemBuff = TryGetProp(self, statString.."_ITEM_BM");
    if byItemBuff == nil then
        byItemBuff = 0
    end
    
    local value = byItem + byBuff + byItemBuff;
    
    return math.floor(value);
end

function SCR_Get_RefreshHP(self)
    local valueMHP = TryGetProp(self, MHP)
    if valueMHP == nil then
        valueMHP = 1;
    end
    
    return valueMHP * 0.3;
end


function SCR_Get_MHP(self)
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return 1;
    end
    
    local jobRate = jobObj.JobRate_HP;
    local jobMHP = 400 * jobRate;
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byLevel = math.floor(jobMHP + ((lv - 1) * 80 * jobRate));
    local byStat = math.floor(((stat * 0.005) + (math.floor(stat / 10) * 0.015)) * byLevel);
    
    local byBonus = TryGetProp(self, "MHP_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local itemRatio = GetSumOfEquipItem(self, 'MHPRatio');
    if itemRatio == nil then
        itemRatio = 0;
    end
    
    local byItemRatio = (byLevel + byStat) * (itemRatio * 0.01);
    local byItem = GetSumOfEquipItem(self, 'MHP');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "MHP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, "MHP");
    
    local value = byLevel + byStat + byBonus + byItemRatio + byItem + byBuff + rewardProperty;
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_Get_MSP(self)
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return 1;
    end
    
    local jobRate = jobObj.JobRate_SP;
    local jobMSP = 200 * jobRate;
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local stat = TryGetProp(self, "MNA");
    if stat == nil then
        stat = 1;
    end
    
    local byLevel = math.floor(jobMSP + ((lv - 1) * 12 * jobRate));
    local byStat = math.floor(((stat * 0.005) + (math.floor(stat / 10) * 0.015)) * byLevel);
    
    local byBonus = TryGetProp(self, "MSP_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    local byItem = GetSumOfEquipItem(self, 'MSP');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "MSP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local rewardProperty = GET_REWARD_PROPERTY(self, "MSP");
    
    local value = byLevel + byStat + byBonus + byItem + byBuff + rewardProperty;
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MINPATK(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MINATK", "PATK", "ADD_MINATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local leftMinAtk = 0;
    local leftHand = GetEquipItemForPropCalc(self, 'LH');
    if leftHand ~= nil then
        leftMinAtk = leftHand.MINATK;
    end
    
    local throwItemMinAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and rightHand ~= nil then
        throwItemMinAtk = rightHand.MINATK;
    end
    
    value = value - leftMinAtk - throwItemMinAtk;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MINPATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "PATK_RATE_BM", "MINPATK_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    local maxPATK = TryGetProp(self, "MAXPATK");
    if value > maxPATK then
        value = maxPATK;
    end
    
    return math.floor(value);
end

function SCR_Get_MAXPATK(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MAXATK", "PATK", "ADD_MAXATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local leftMaxAtk = 0;
    local leftHand = GetEquipItemForPropCalc(self, 'LH');
    if leftHand ~= nil then
        leftMaxAtk = leftHand.MAXATK;
    end
    
    local throwItemMaxAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and rightHand ~= nil then
        throwItemMaxAtk = rightHand.MAXATK;
    end
    
    value = value - leftMaxAtk - throwItemMaxAtk;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MAXPATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "PATK_RATE_BM", "MAXPATK_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    return math.floor(value);
end

function SCR_Get_MINPATK_SUB(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MINATK", "PATK", "ADD_MINATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local rightMinAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if rightHand ~= nil then
        rightMinAtk = rightHand.MINATK;
    end
    
    value = value - rightMinAtk;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MINPATK_SUB_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "PATK_RATE_BM", "MINPATK_SUB_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    local maxPATK_SUB = TryGetProp(self, "MAXPATK_SUB");
    if value > maxPATK_SUB then
        value = maxPATK_SUB;
    end
    
    return math.floor(value);
end

function SCR_Get_MAXPATK_SUB(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MAXATK", "PATK", "ADD_MAXATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local rightMaxAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if rightHand ~= nil then
        rightMaxAtk = rightHand.MAXATK;
    end
    
    value = value - rightMaxAtk;
    
    local byBuff = 0;
    local byBuffList = { "PATK_BM", "MAXPATK_SUB_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "PATK_RATE_BM", "MAXPATK_SUB_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    return math.floor(value);
end

function SCR_Get_MINMATK(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MATK", "ADD_MATK", "ADD_MINATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local throwItemMinMAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and rightHand ~= nil then
        throwItemMinMAtk = rightHand.MATK;
    end
    
    value = value - throwItemMinMAtk;
    
    local byBuff = 0;
    local byBuffList = { "MATK_BM", "MINMATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "MATK_RATE_BM", "MINMATK_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    local maxMATK = TryGetProp(self, "MAXMATK");
    if value > maxMATK then
        value = maxMATK;
    end
    
    return math.floor(value);
end

function SCR_Get_MAXMATK(self)
    local defaultValue = 20;
    
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
    
    local byItem = 0;
    local byItemList = { "MATK", "ADD_MATK", "ADD_MAXATK" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local value = defaultValue + byLevel + byStat + byItem;
    
    local throwItemMaxMAtk = 0;
    local rightHand = GetEquipItemForPropCalc(self, 'RH');
    if IsBuffApplied(self, 'Warrior_RH_VisibleObject') == 'YES' and rightHand ~= nil then
        throwItemMaxMAtk = rightHand.MATK;
    end
    
    value = value - throwItemMaxMAtk;
    
    local byBuff = 0;
    local byBuffList = { "MATK_BM", "MAXMATK_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local byRateBuff = 0;
    local byRateBuffList = { "MATK_RATE_BM", "MAXMATK_RATE_BM" };
    for i = 1, #byRateBuffList do
        local byRateBuffTemp = TryGetProp(self, byRateBuffList[i]);
        if byRateBuffTemp == nil then
            byRateBuffTemp = 0;
        end
        
        byRateBuff = byRateBuff + byRateBuffTemp;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    return math.floor(value);
end

function SCR_Get_DEF(self)
    local defaultValue = 20;
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
--    local byLevel = lv * 1.5;
    local byLevel = lv * 1.0;
    
--    local rank = GetTotalJobCount(self)
--    if rank == nil or rank < 1 then
--        rank = 1;
--    end
--    
--    local byRank = math.floor(byLevel * ((rank - 1) * 0.1))
    
    local byItem = 0;
    local byItemList = { "DEF", "ADD_DEF" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local byBonus = TryGetProp(self, "MAXDEF_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
--    local value = byLevel + byRank + byItem + byBonus;
    local value = defaultValue + byLevel + byItem + byBonus;
    
    local byBuff = TryGetProp(self, "DEF_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "DEF_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byBuff + byRateBuff;
    
    local throwItemDef = 0;
    local leftHand = GetEquipItemForPropCalc(self, 'LH');
    if IsBuffApplied(self, 'Warrior_LH_VisibleObject') == 'YES' and leftHand ~= nil then
        throwItemDef = leftHand.DEF;
    end 
    
    value = value - throwItemDef;
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_MDEF(self)
    local defaultValue = 20;
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
--    local byLevel = lv * 1.5;
    local byLevel = lv * 1.0;
    
--    local rank = GetTotalJobCount(self)
--    if rank == nil or rank < 1 then
--        rank = 1;
--    end
--    
--    local byRank = math.floor(byLevel * ((rank - 1) * 0.1))
    
    local byItem = 0;
    local byItemList = { "MDEF", "ADD_MDEF" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
--    local value = byLevel + byRank + byItem;
    local value = defaultValue + byLevel + byItem;
    
    local byEnchant = 0;
    local enchantCount = CountEnchantItemEquip(self, 'ENCHANTARMOR_PROTECTIVE');
    if enchantCount > 0 then
        byEnchant = math.floor(value * (enchantCount * 0.05));
    end
    
    local byBuff = TryGetProp(self, "MDEF_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byRateBuff = TryGetProp(self, "MDEF_RATE_BM");
    if byRateBuff == nil then
        byRateBuff = 0;
    end
    
    byRateBuff = math.floor(value * byRateBuff);
    
    value = value + byEnchant + byBuff + byRateBuff;
    
    return math.floor(value);
end

function SCR_Get_BLKABLE(self)
    
    local isShield = GetSumOfEquipItem(self, 'BlockRate');
    if isShield > 0 then
        return 1;
    end
    
    local buffList = { "CrossGuard_Buff", "StoneSkin_Buff" };
    for i = 1, #buffList do
        if IsBuffApplied(self, buffList[i]) == 'YES' then
            return 2;
        end
    end
    
    return 0;
end

function SCR_Get_BLK(self)
    local enableBlock = TryGetProp(self, "BLKABLE");
    if enableBlock == nil or enableBlock == 0 then
        return 0;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local byItem = GetSumOfEquipItem(self, 'BLK');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBlockRate = GetSumOfEquipItem(self, 'BlockRate');
    if byBlockRate == nil then
        byBlockRate = 0;
    end
    
    byBlockRate = (byLevel + byStat) * (byBlockRate * 0.01);
    
    local value = byLevel + byStat + byItem + byBlockRate;
    
    local byAbil = 0;
    local abilList = { { 'Peltasta5', 0.05 } };
    for i = 1, #abilList do
        local abilTemp = GetAbility(self, abilList[i][1]);
        if abilTemp ~= nil then
            local abilLevel = abilTemp.Level;
            local abilRate = abilList[i][2];
            byAbil = byAbil + (abilLevel * abilRate);
        end
    end
    
    byAbil = value * byAbil;
    
    local byBuff = TryGetProp(self, "BLK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    value = value + byAbil + byBuff;
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_BLK_BREAK(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.25;
    
    local stat = TryGetProp(self, "DEX")
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 0.5) + (math.floor(stat / 15) * 3);
    
    local byItem = GetSumOfEquipItem(self, 'BLK_BREAK');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "BLK_BREAK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_HR(self)
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
    
    local byItem = 0;
    local byItemList = { "HR", "ADD_HR" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local byBuff = TryGetProp(self, "HR_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_DR(self)
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
    
    local byItem = 0;
    local byItemList = { "DR", "ADD_DR" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local byBuff = TryGetProp(self, "DR_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_MHR(self)
    local byItem = 0;
    local byItemList = { "MHR", "ADD_MHR" };
    for i = 1, #byItemList do
        local byItemTemp = GetSumOfEquipItem(self, byItemList[i]);
        if byItemTemp == nil then
            byItemTemp = 0;
        end
        
        byItem = byItem + byItemTemp;
    end
    
    local byBuff = TryGetProp(self, "MHR_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_CRTHR(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local byItem = GetSumOfEquipItem(self, 'CRTHR');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "CRTHR_BM");
    if byBuff == nil then
        byBuff = 1;
    end
    
    local value = byLevel + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_CRTDR(self)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * 0.5;
    
    local byItem = GetSumOfEquipItem(self, 'CRTDR');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "CRTDR_BM");
    if byBuff == nil then
        byBuff = 1;
    end
    
    local value = byLevel + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_CRTATK(self)
    local stat = TryGetProp(self, "DEX");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 4) + (math.floor(stat / 10) * 10);
    
    local byItem = GetSumOfEquipItem(self, "CRTATK");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "CRTATK_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byStat + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_CRTDEF(self)
    return 0;
end

function SCR_Get_RHP(self)
    if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
        return 0;
    end
    
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return 0;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * jobObj.JobRate_HP;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 5) * 3);
    
    local byItem = GetSumOfEquipItem(self, 'RHP');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "RHP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byStat + byItem + byBuff;
    
    if value < 0 then
        value = 0;
    end
    
    return math.floor(value);
end

function SCR_GET_RHPTIME(self)
    local defaultTime = 20000;
    
    local byItem = GetSumOfEquipItem(self, 'RHPTIME');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "RHPTIME_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultTime - byItem - byBuff;

    if IsBuffApplied(self, 'SitRest') == 'YES' then 
        value = value * 0.5;
    end
    
    if value < 1000 then
        value = 1000;
    end
    
    return math.floor(value);
end

function SCR_Get_RSP(self)
    local buffKeywordList = { "Curse", "Formation", "SpDrain" };
    for i = 1, #buffKeywordList do
        if GetBuffByProp(self, 'Keyword', buffKeywordList[i]) ~= nil then
            return 0;
        end
    end
    
--    if IsBuffApplied(self, 'Summoning_Buff') == 'YES' then  
--        value = 0;
--    end 
    
    local jobObj = GetJobObject(self);  -- job
    if jobObj == nil then
        return 0;
    end
    
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = lv * jobObj.JobRate_SP;
    
    local stat = TryGetProp(self, "MNA");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = (stat * 2) + (math.floor(stat / 5) * 3);
    
    local byItem = GetSumOfEquipItem(self, 'RSP');
    if byItem == nil then
        byItem = 0;
    end
    
    local value = byLevel + byStat + byItem;
    
    local baseMSP = self.MSP;
    local byAbil = 0
    
    -- 1번 인자 : 특성 ClassName --
    -- 2번 인자 : 기반으로 곱연산 할 값(MaxSP, 기본 회복량 등..), nil 인 경우 곱연산이 아닌 3번째 인자값으로 합연산 처리 --
    -- 3번 인자 : 2번 인자를 기반으로 곱연산 할 계수 --
    local abilList = { { "Meditaion", baseMSP, 0.01 } }
    for i = 1, #abilList do
        local AbilTemp = GetAbility(self, abilList[i][1]);
        if AbilTemp ~= nil then
            if abilList[i][2] == nil or abilList[i][2] == "None" then
                byAbil = byAbil + abilList[i][3];
            else
                byAbil = byAbil + (AbilTemp.Level * (abilList[i][2] * abilList[i][3]));
            end
        end
    end
    
    local byBuff = TryGetProp(self, "RSP_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    value = value + byAbil + byBuff
    
    if value < 1 then
        value = 1;
    end
    
    return math.floor(value);
end

function SCR_GET_RSPTIME(self)
    local defaultTime = 20000;
    
    local byItem = GetSumOfEquipItem(self, 'RSPTIME');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "RSPTIME_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultTime - byItem - byBuff;
    
    if IsBuffApplied(self, 'SitRest') == 'YES' then 
        value = value * 0.5;
    end
    
    if value < 1000 then
        value = 1000;
    end
    
    return math.floor(value);
end

function SCR_Get_StunRate(self)
    local byItem = GetSumOfEquipItem(self, "StunRate");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "StunRate_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end


function SCR_Get_Revive(self)
    local byItem = GetSumOfEquipItem(self, 'Revive');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "Revive_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end
 
function SCR_Get_HitCount(self)
    local byItem = GetSumOfEquipItem(self, "HitCount");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "HitCount_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_BackHit(self) 
    local byItem = GetSumOfEquipItem(self, "BackHit");
    if byItem == nil then
        byItem = 0;
    end
    
    local value = byItem;
    return math.floor(value);
end
 
function SCR_Get_Aries_Bonus(self)
    local attrString = "Aries";
    
    local byItem = GetSumOfEquipItem(self, attrString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, attrString.."_Bonus_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_Aries_Defence(self)
    local attrString = "Aries";
    
    local byItem = GetSumOfEquipItem(self, attrString.."DEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "Def"..attrString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_Slash_Bonus(self)
    local attrString = "Slash";
    
    local byItem = GetSumOfEquipItem(self, attrString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, attrString.."_Bonus_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_Slash_Defence(self)
    local attrString = "Slash";
    
    local byItem = GetSumOfEquipItem(self, attrString.."DEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "Def"..attrString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_Strike_Bonus(self)
    local attrString = "Strike";
    
    local byItem = GetSumOfEquipItem(self, attrString);
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, attrString.."_Bonus_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_Strike_Defence(self)
    local attrString = "Strike";
    
    local byItem = GetSumOfEquipItem(self, attrString.."DEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "Def"..attrString.."_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return math.floor(value);
end

function SCR_Get_TR(self)
    local defaultValue = 50;
    
    local byBuff = TryGetProp(self, "TR_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultValue + byBuff;
    
    return math.floor(value);
end

function SCR_Get_KDArmorType(self)
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return 0;
    end
    
    local value = 0;
    
    if jobObj.CtrlType == 'Warrior' then 
        value = 1;
    elseif jobObj.CtrlType == 'Wizard' then 
        value = 0;
    elseif jobObj.CtrlType == 'Archer' then 
        value = 0;
    elseif jobObj.CtrlType == 'Cleric' then 
        value = 1;
    end
    
    local buffList = { "Safe", "PainBarrier_Buff", "Lycanthropy_Buff" };
    for i = 1, #buffList do
        if IsBuffApplied(self, buffList[i]) == 'YES' then
            value = 99999;
        end
    end
    
    return value;
end


function SCR_Get_ASPD(self)
    local value = TryGetProp(self, "ASPD_BM");
    if value == nil then
        value = 0;
    end
    
    return value;
end


function SCR_Get_MSPD(self)
    local fixMSPDBuff = TryGetProp(self, "FIXMSPD_BM");
    if fixMSPDBuff ~= nil and fixMSPDBuff ~= 0 then
        return fixMSPDBuff;
    end
    
    local value = 30.0;
    
    if self.ClassName == 'PC' then
        local byItem = GetSumOfEquipItem(self, 'MSPD');
        if byItem == nil then
            byItem = 0;
        end
        
        local byBuff = TryGetProp(self, "MSPD_BM");
        if byBuff == nil then
            byBuff = 0;
        end
        
        value = value + byItem + byBuff;
        
        local byBuffRate = TryGetProp(self, "SPD_BM");
        if byBuffRate == nil then
            byBuffRate = 0;
        end
        
        byBuffRate = (100 + byBuffRate) * 0.01;
        
        value = value * byBuffRate;
        
        local nowWeight = 0;
        local maxWeight = 0;
        if IsServerSection(self) == 1 then
            nowWeight = TryGetProp(self, "NowWeight");
            if nowWeight == nil then
                nowWeight = 0;
            end
            
            maxWeight = TryGetProp(self, "MaxWeight");
            if maxWeight == nil then
                maxWeight = 8000;
            end
            
            if nowWeight >= maxWeight then
                value = value / 3;
            end
        else
            local pc = GetMyPCObject();
            
            nowWeight = TryGetProp(pc, "NowWeight");
            if nowWeight == nil then
                nowWeight = 0;
            end
            
            maxWeight = TryGetProp(pc, "MaxWeight");
            if maxWeight == nil then
                maxWeight = 8000;
            end
            
            if nowWeight >= maxWeight then
                value = value / 3;
            end
        end
    end
    
    local isDashRun = TryGetProp(self, "DashRun");
    if isDashRun == nil then
        isDashRun = 0;
    end
    
    if isDashRun > 0 then    -- 대시 런 --
        value = value + 10;
        if isDashRun == 2 then  -- 인보 특성이 있으면 속도 +1 --
            value = value + 1;
        end
    end
    
    -- 최대 이속 제한 --
    if value > 60 then
        value = 60;
    end
    
    local byBonus = TryGetProp(self, "MSPD_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    value = value + byBonus;
    
    value = value * SERV_MSPD_FIX;
    
    return math.floor(value);
end

function SCR_Get_MinR(self)
    return 0;
end

function SCR_Get_MaxR(self)
    local value = 5;
    local stance = GetCurrentStance(self);
    if stance ~= nil then
        if stance.ClassType == 'Force' then
--            value = 300;
            return;
        end
    end
    
    local rweapon = GetEquipItemForPropCalc(self, 'RH');
    if rweapon ~= nil then
        value = rweapon.MaxR;
    end
    
    return math.floor(value);
end

function SCR_Get_MaxRFwd(self)
    local value = TryGetProp(self, "MaxR")
    if value == nil then
        value = 0;
    end
    
    local stance = GetCurrentStance(self);
    if stance ~= nil then
        if stance.ClassType == 'Magic' then
            return value;
        end
    end
    
    value = value + 15;
    return math.floor(value);
end

function SCR_Get_SR(self)
    local defaultSR = 3;
    
    local jobObj = GetJobObject(self);
    if jobObj ~= nil then
        if jobObj.CtrlType == 'Warrior' then
            defaultSR = 4;
        end
        
        if jobObj.CtrlType == 'Archer' then
            defaultSR = 0;
        end
    end
    
    local byItem = GetSumOfEquipItem(self, "SR");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "SR_BM")
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultSR + byItem + byBuff;
    
    return math.floor(value);
end


function SCR_Get_SDR(self)
    local defaultSDR = 1;
    
    local byItem = GetSumOfEquipItem(self, "SDR");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "SDR_BM")
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultSDR + byItem + byBuff;
    
    return math.floor(value);
end

function SCR_Get_ForceVel(self)
    return 100;
end

-- KnockDown power
function SCR_GET_KDPOWER(self)
    local byBuff = TryGetProp(self, "KDPow_BM")
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byBuff;
    
    return math.floor(value);
end

function SCR_Get_MGP(self)
    local defaultMGP = 500;
    
    local byBuff = TryGetProp(self, "MGP_BM")
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultMGP + byBuff;
    
    return math.floor(value);
end

function SCR_Get_CAST(self)
    return 1;
end

function SCR_Get_BOOST(self)
    return 1;
end

function SCR_Get_JUMP(self)
    return 350;
end

function SCR_Get_AddSplCount(self)
    local byLevel = TryGetProp(self, "Lv");
    if byLevel == nil then
        byLevel = 1;
    end
    
    local byBuff = TryGetProp(self, "AddSplCount_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byLevel + byBuff;
    
    return math.floor(value);
end

function SCR_GET_MOVING_SHOT(pc)
    local PCJob = TryGetProp(pc, "Job");
    if PCJob ~= nil then
        local jobFunc = _G[ "MOVING_SHOT_" .. PCJob ]
        if jobFunc ~= nil then
            return jobFunc(pc);
        end
    end
    
    return 0;
end

function SCR_GET_JUMPING_SHOT(pc)
    local PCJob = TryGetProp(pc, "Job");
    if PCJob ~= nil then
        local jobFunc = _G[ "JUMPING_SHOT_" .. PCJob ]
        if jobFunc ~= nil then
            return jobFunc(pc);
        end
    end
    
    return 1;
end


function SCR_PC_MOVINGSHOTABLE(pc)
    local jobObj = GetJobObject(pc);
    if jobObj == nil then
        return 0;
    end
    
    if jobObj.CtrlType == 'Archer' then
        return 1;
    end
    
    local buffList = { "Warrior_EnableMovingShot_Buff", "Warrior_RushMove_Buff" }
    for i = 1, #buffList do
        if IsBuffApplied(pc, buffList[i]) == "YES" then
            return 1;
        end
    end
    
    return 0;
end

function SCR_MOVING_SHOT_SPEED(pc) -- archer moving shot
    local value = 0;
    local isEnableMovingShot = TryGetProp(pc, "MovingShotable");
    if isEnableMovingShot ~= nil and isEnableMovingShot ~= 0 then
        local jobObj = GetJobObject(pc);
        if jobObj ~= nil then
            if jobObj.CtrlType == 'Archer' then 
                value = 0.8;
            end
            
            local byBuff = TryGetProp(pc, "MovingShot_BM");
            if byBuff == nil then
                byBuff = 0;
            end
            
            value = value + byBuff;
        end
    end
    
    return value;
end

function SCR_Get_MSTA(self)
    local defaultMSTA = 25000;
    
    local stat = TryGetProp(self, "CON");
    if stat == nil then
        stat = 1;
    end
    
    local byStat = math.floor(stat / 20);
    
    byStat = byStat * 1000;
    
    local byItem = GetSumOfEquipItem(self, 'MSTA');
    if byItem == nil then
        byItem = 0;
    end
    
    byItem = byItem * 1000;
    
    local byBonus = TryGetProp(self, "MAXSTA_Bonus");
    if byBonus == nil then
        byBonus = 0;
    end
    
    byBonus = byBonus * 1000;
    
    local byBuff = TryGetProp(self, "MaxSta_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    byBuff = byBuff * 1000;
    
    
    local rewardProperty = GET_REWARD_PROPERTY(self, "MSTA")
    rewardProperty = rewardProperty * 1000;
    
    local value = defaultMSTA + byStat + byItem + byBonus + byBuff + rewardProperty;
    
    return math.floor(value);
end

function SCR_Get_Sta_RunStart(self)
    return 0;
end

function SCR_Get_Sta_Run(self)
    local consumptionSTA = 50;
    
    local isDashRun = TryGetProp(self, "DashRun");
    if isDashRun == nil then
        isDashRun = 0;
    end
    
    if isDashRun > 0 then
        local dashAmount = 500;
        if isDashRun == 2 then
            dashAmount = dashAmount * 0.9;  -- 인보 특성 있는 중에는 추가량 10% 감소
        end
        consumptionSTA = consumptionSTA + dashAmount;
    end
    
    local value = (250 * consumptionSTA / 100);
    
    return math.floor(value);
end

function SCR_Get_Sta_Recover(self)
    if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
        return 0;
    end
    
    local defaultRSTA = 400;
    
    local byBuff = 0;
    local byBuffList = { "REST_BM", "RSta_BM" };
    for i = 1, #byBuffList do
        local byBuffTemp = TryGetProp(self, byBuffList[i]);
        if byBuffTemp == nil then
            byBuffTemp = 0;
        end
        
        byBuff = byBuff + byBuffTemp;
    end
    
    local value = defaultRSTA + byBuff;
    
    if IsBuffApplied(self, 'SitRest') == 'YES' then 
        value = value * 2;
    end
    
    return math.floor(value);
end

function SCR_Get_Sta_R_Delay(self)
    return 1000;
end

function SCR_Get_Sta_Runable(self)
    return 250;
end

function SCR_Get_Sta_Jump(self)
    return 0;
end

function SCR_Get_Sta_Step(self)
    return 2500;
end

function SCR_Get_GuardImpactTime(self)
    local defaultValue = 1500;
    
    local byBuff = TryGetProp(self, "GuardImpactTime_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return defaultValue + byBuff;
end

function SCR_Get_PC_HitCount(pc)
    local RH = GetEquipItemForPropCalc(pc, 'RH');
    
    if RH == nil then
        return 1;
    end
    
    return RH.HitCount;
end

function SCR_GET_PC_SKLPOWER(self)
    local byItem = GetSumOfEquipItem(self, 'SkillPower');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "SkillPower_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_PC_HPDRAIN(pc)
    local defaultHPDRAIN = 2;
    
    local byADD = TryGetProp(pc, "HPDrain_ADD");
    if byADD == nil then
        byADD = 0;
    end
    
    local value = defaultHPDRAIN + byADD;
    
    return value;
end

function SCR_GET_PC_HPDRAIN_ADD(pc)
    local byBuff = TryGetProp(pc, "HPDrain_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_PC_PIERCE(pc)
    local byLevel = TryGetProp(pc, "Lv");
    if byLevel == nil then
        byLevel = 1;
    end
    
    local byADD = TryGetProp(pc, "PIE_ADD");
    if byADD == nil then
        byADD = 0;
    end
    
    local value = byLevel + byADD;
    
    return value;
end

function SCR_GET_PC_PIE_ADD(pc)
    local byBuff = TryGetProp(pc, "PIE_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_PC_KDHIT(pc)
    local byBuff = TryGetProp(pc, "KDHit_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_PC_KDBONUS(pc)
    local defaultKDBonus = 120;
    
    local lv = TryGetProp(pc, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = 10 * lv;
    
    local byItem = GetSumOfEquipItem(pc, 'KDBonus');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "KDBonus_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultKDBonus + byLevel + byItem + byBuff;
    
    return value;
end

function SCR_GET_PC_KDDEFENCE(pc)
    local defaultKDDefence = 30;
    
    local lv = TryGetProp(pc, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local byLevel = 10 * lv;
    
    local byItem = GetSumOfEquipItem(pc, 'KDDefence');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "KDBonus_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = defaultKDDefence + byLevel + byItem + byBuff;
    
    return value;
end


function SCR_GET_PC_GUARDABLE(pc)
    if IsBuffApplied(pc, "Impaler_Buff") == "YES" then
        return 0;
    end
    
    local isGuardSkill = GetStanceSkill(pc, "Warrior_Guard");
    if isGuardSkill == nil then
        return 0;
    end
    
    local itemLH  = GetEquipItemForPropCalc(pc, 'LH');
    if itemLH ~= nil then
        if itemLH.ClassType == "Shield" and itemLH.LHandSkill == "None" then
            return 1;
        end
    end
    
    return 0;
end

function SCR_PC_GUARD_ON(pc)
    local lv = TryGetProp(pc, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    -- Block --
    local blkAdd = 550;
    
    ----------
    
    
    
    -- Defence --
    local abil_Peltasta10 = GetAbility(pc, 'Peltasta10')
    local defAdd = 0;
    
    if abil_Peltasta10 ~= nil then
        local defenceValue = TryGetProp(pc, "DEF");
        if defenceValue == nil then
            defenceValue = 0;
        end
        
        defAdd = math.floor(defenceValue * 0.1 * abil_Peltasta10.Level);
    end
    
    ----------
    
    
    
    local blockBuff = TryGetProp(pc, "BLK_BM");
    if blockBuff ~= nil then
        pc.BLK_BM = pc.BLK_BM + blkAdd;
        
        SetExProp(pc, 'ADD_PC_GUARD_BLK', blkAdd);
    end
    
    local defenceBuff = TryGetProp(pc, "DEF_BM");
    if defenceBuff ~= nil then
        pc.DEF_BM = pc.DEF_BM + defAdd;
        
        SetExProp(pc, 'ADD_PC_GUARD_DEF', defAdd);
    end
    
    local enableJump = TryGetProp(pc, "Jumpable");
    if enableJump ~= nil then
        pc.Jumpable = pc.Jumpable - 1;
    end
    
    InvalidateStates(pc);
end

function SCR_PC_GUARD_OFF(pc)
    local blockBuff = TryGetProp(pc, "BLK_BM");
    if blockBuff ~= nil then
        local blkAdd = GetExProp(pc, 'ADD_PC_GUARD_BLK');
        
        pc.BLK_BM = pc.BLK_BM - blkAdd;
    end
    
    local defenceBuff = TryGetProp(pc, "BLK_BM");
    if defenceBuff ~= nil then
        local defAdd = GetExProp(pc, 'ADD_PC_GUARD_DEF');
        
        pc.DEF_BM = pc.DEF_BM - defAdd;
    end
    
    local enableJump = TryGetProp(pc, "Jumpable");
    if enableJump ~= nil then
        pc.Jumpable = pc.Jumpable + 1;
    end
    
    InvalidateStates(pc);
end

function SCR_Get_SkillAngle(self)
    local byItem = GetSumOfEquipItem(self, 'SkillAngle');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "SkillAngle_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return value;
 end

function SCR_Get_SkillRange(self)
    local byItem = GetSumOfEquipItem(self, 'SkillRange');
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(self, "SkillRange_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return value;
end

function SCR_Get_TrustRange(self)
    local byItem = GetSumOfEquipItem(self, "Aries_Range");
    if byItem == nil then
        byItem = 0;
    end
    
    return byItem;
end

function SCR_Get_SlashRange(self)
    local byItem = GetSumOfEquipItem(self, "Slash_Range");
    if byItem == nil then
        byItem = 0;
    end
    
    return byItem;
end

function SCR_Get_StrikeRange(self)
    local byItem = GetSumOfEquipItem(self, "Strike_Range");
    if byItem == nil then
        byItem = 0;
    end
    
    return byItem;
end

function SCR_Get_PostDelay(self)
    local byItem = GetSumOfEquipItem(self, "PostDelay");
    if byItem == nil then
        byItem = 0;
    end
    
    return byItem;
end

function SCR_GET_ADDFEVER(self)
    return 0;
end


function SCR_GET_FIRE_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_FIRE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Fire_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_ICE_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_ICE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Ice_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_POISON_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_POISON");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Poison_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_LIGHTNING_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LIGHTNING");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Lightning_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_SOUL_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_SOUL");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Soul_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_EARTH_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_EARTH");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Earth_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_HOLY_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_HOLY");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Holy_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_DARK_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_DARK");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Dark_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Widling_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_WIDLING");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Widling_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Paramune_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_PARAMUNE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Paramune_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Forester_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_FORESTER");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Forester_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Velnias_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_VELIAS");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Velnias_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Klaida_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_KLAIDA");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Klaida_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Cloth_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_CLOTH");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Cloth_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Leather_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LEATHER");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Leather_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Chain_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_CHAIN");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Chain_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Iron_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_IRON");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Iron_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_Ghost_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_GHOST");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "Ghost_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_SmallSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_SMALLSIZE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "SmallSize_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_MiddleSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_MIDDLESIZE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "MiddleSize_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_LargeSize_ATK(pc)
    local byItem = GetSumOfEquipItem(pc, "ADD_LARGESIZE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "LargeSize_Atk_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_BASE_WEAPON_DEF(pc)
    return 0;
end

function SCR_GET_DEF_ARIES(pc)
    local byItem = GetSumOfEquipItem(pc, "AriesDEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "DefAries_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_DEF_SLASH(pc)
    local byItem = GetSumOfEquipItem(pc, "SlashDEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "DefSlash_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_DEF_STRIKE(pc)
    local byItem = GetSumOfEquipItem(pc, "StrikeDEF");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "DefStrike_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_FIRE(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_FIRE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResFire_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_ICE(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_ICE");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResIce_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_POISON(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_POISON");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResPoison_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_LIGHTNING(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_LIGHTNING");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResLightning_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_EARTH(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_EARTH");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResEarth_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_HOLY(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_HOLY");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResHoly_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_DARK(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_DARK");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResDark_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_RES_SOUL(pc)
    local byItem = GetSumOfEquipItem(pc, "RES_SOUL");
    if byItem == nil then
        byItem = 0;
    end
    
    local byBuff = TryGetProp(pc, "ResSoul_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local value = byItem + byBuff;
    
    return math.floor(value);
end

function SCR_GET_SKL_ADD_COOLDOWN(pc)
    return 1;
end

function SCR_GET_ADDOVERHEAT(pc, skill)
    if skill ~= nil then
        local stat = TryGetProp(pc, "INT");
        if stat == nil then
            stat = 1;
        end
        
        local cls = GetClassByType('skill_oh_reduce', stat)
        if cls ~= nil then
            return math.floor( cls['Circle_'..skill.SklCircleLv] );
        end
    end
    
    return 0;
end

function SCR_GET_PC_LIMIT_BUFF_COUNT(self)
    local jobObj = GetJobObject(self)
    if jobObj == nil then
        return 0;
    end
    
    local count = 5;
    
    if 'Warrior' == jobObj.CtrlType or 'Cleric' == jobObj.CtrlType then
        count = 7;
    end
    
    if 1 == IsDummyPC(self) then
        return count;
    end
    
    local byAbil = 0;
    local abil = GetAbility(self, "AddBuffCount")
    if abil ~= nil then
        byAbil = 1;
    end
    
    local byBuff = TryGetProp(self, "LimitBuffCount_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    local byToken = 0;
    local isToken = IsPremiumState(self, ITEM_TOKEN);
    if isToken == 1 then
        byToken = 1;
    end
    
    count = count + byAbil + byBuff + byToken;
    
    return count;
end

function GET_MAXHATE_COUNT(self)
    local mapID = GetMapID(self);
    local cls = GetClassByType('Map', mapID);
    if cls ~= nil then
        local defaultMaxHateCount = cls.MaxHateCount;
        if defaultMaxHateCount == nil then
            defaultMaxHateCount = 100;
        end
        
        local byBuff = TryGetProp(self, "MaxHateCount_BM");
        if byBuff == nil then
            byBuff = 0;
        end
        
        local value = defaultMaxHateCount + byBuff;
        
        return math.floor(value);
    end
    
    return 100;
end

function GET_ArmorMaterial_ID(self)
    local armorMaterial = nil;
    local equipbodyItem = GetEquipItemForPropCalc(self, 'SHIRT');
    if equipbodyItem ~= nil then
        armorMaterial = TryGetProp(equipbodyItem, "Material");
    end
    
    if armorMaterial == nil then
        armorMaterial = "Cloth";
    end
    
    local armorMaterialList = { "Cloth", "Leather", "Iron", "Ghost", "Chain" };
    for i = 1, #armorMaterialList do
        if armorMaterial == armorMaterialList[i] then
            self.ArmorMaterial = armorMaterialList[i];
            return i;
        end
    end
    
    return 1;
    
--    if armorMaterial == 'Cloth' then
--        self.ArmorMaterial = 'Cloth';
--        return 1;
--    elseif armorMaterial == 'Leather' then
--        self.ArmorMaterial = 'Leather';
--        return 2;
--    elseif armorMaterial == 'Iron' then
--        self.ArmorMaterial = 'Iron';
--        return 3;
--    elseif armorMaterial == 'Ghost' then
--        self.ArmorMaterial = 'Ghost';
--        return 4;
--    elseif armorMaterial == 'Chain' then    
--        self.ArmorMaterial = 'Chain';
--        return 5;
--    end
end

function SCR_GET_ARIES_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "AriesAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_SLASH_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "SlashAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_STRIKE_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "StrikeAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_MISSILE_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "MissileAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_FIRE_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "FireAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_ICE_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "IceAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_LIGHTNING_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "LightningAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_SOUL_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "SoulAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_POISON_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "PoisonAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_EARTH_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "EarthAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_HOLY_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "HolyAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_DARK_ATKFACTOR_PC(self)
    local byBuff = TryGetProp(self, "DarkAtkFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_ARIES_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "AriesDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_SLASH_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "SlashDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_STRIKE_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "StrikeDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_MISSILE_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "MissileDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_FIRE_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "FireDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_ICE_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "IceDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_LIGHTNING_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "LightningDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_SOUL_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "SoulDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_POISON_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "PoisonDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_EARTH_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "EarthDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_HOLY_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "HolyDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function SCR_GET_DARK_DEFFACTOR_PC(self)
    local byBuff = TryGetProp(self, "DarkDefFactor_PC_BM");
    if byBuff == nil then
        byBuff = 0;
    end
    
    return byBuff;
end

function GET_REWARD_PROPERTY(self, propertyName)
    
    local sObj = GetSessionObject(self, 'ssn_klapeda')
    local rewardProperty = 0;

    if sObj == nil and IsServerObj(self) == 0 then
        local pc = GetMyPCObject()
        sObj = GetSessionObject(pc, 'ssn_klapeda')
    end

    if sObj ~= nil then
        local list, listCnt = GetClassList("reward_property");
        
        for i = 0, listCnt -1 do
            local cls = GetClassByIndexFromList(list, i);
            if cls ~= nil and TryGetProp(cls, "Property") == propertyName then
                if sObj[cls.ClassName] == 300 then
                    rewardProperty = rewardProperty + cls.Value
                end
            end
        end
    end

    return rewardProperty;
end



--function GetDefaultPropertyPC(self, property)
--    local value = TryGetProp(self, property);
--    if value == nil then
--        print(property.." is nil");
--        return 0;
--    end
--    
--    local valueBM = TryGetProp(self, property.."_BM");
--    
--    if "MINPATK" == property or "MAXPATK" == property then
--        valueBM = TryGetProp(self, "PATK_BM");
--    elseif "MINMATK" == property or "MAXMATK" == property then
--        valueBM = TryGetProp(self, "MATK_BM");
--    end
--    
--    if valueBM == nil then
--        print(property.."_BM is nil");
--        valueBM = 0;
--    end
--    
--    value = value - valueBM;
--    return math.floor(value);
--end