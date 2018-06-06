-- mgame_rank.lua

function RAID_RANK_SCP(zoneObj, mGame, pcList)
    local PCCount = #pcList
    local maxLv = 0
    local accLv = 0
    local minLv
    for i = 1, PCCount do
        accLv = accLv + pcList[i].Lv
        if maxLv < pcList[i].Lv then
            maxLv = pcList[i].Lv
        end
        
        if minLv == nil then
            minLv = pcList[i].Lv
        elseif minLv > pcList[i].Lv then
            minLv = pcList[i].Lv
        end
    end
    SetExProp(zoneObj, "MinLv", minLv);
    SetExProp(zoneObj, "AveLv", accLv/PCCount);
	SetExProp(zoneObj, "MaxLv", maxLv);
	SetExProp(zoneObj, "PCCOUNT", PCCount);
end

function GET_MON_RANK_LV_1(self, zoneObj)
	local minLv = GetExProp(zoneObj, "MinLv");
	return minLv;
end

function GET_MON_RANK_CUST_MHP_GAGU(self, zoneObj)
	local PCCount = GetExProp(zoneObj, "PCCOUNT");
	return self.MHP * 30 * (PCCount - 1);
end

function GET_MON_RANK_CUST_MHP_BOSS1(self, zoneObj)
	local PCCount = GetExProp(zoneObj, "PCCOUNT");
--	print("Boss : "..self.MHP * PCCount)
	return self.MHP * PCCount;
end

function GET_MON_RANK_CUST_MHP_CATACOMB(self, zoneObj)
	local PCCount = GetExProp(zoneObj, "PCCOUNT");
	return self.MHP * (PCCount - 1);
end

function GET_MON_RANK_CUST_ATK_BOSS1(self, zoneObj)
	return 0;
end

function GET_MON_RANK_CUST_DEF_BOSS1(self, zoneObj)
	return 0;
end

function GET_MON_RANK_LV_NORMAL1(self, zoneObj)
	local maxLv = GetExProp(zoneObj, "MaxLv");
	local minLv = GetExProp(zoneObj, "MinLv");
	local aveLv = GetExProp(zoneObj, "AveLv");
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	local ret = aveLv
	if pcCount > 1 then
	    ret = aveLv - math.floor((maxLv - minLv)*(1/(pcCount+7)))
	end
	
	if ret > maxLv then
	    ret = maxLv
	end
	math.floor(ret)
	
	if maxLv - 30 > ret then
	    ret = maxLv - 30
	end
	return ret;
end

function GET_MON_RANK_LV_BOSS1(self, zoneObj)
    local maxLv = GetExProp(zoneObj, "MaxLv");
	local minLv = GetExProp(zoneObj, "MinLv");
	local aveLv = GetExProp(zoneObj, "AveLv");
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	local ret = aveLv
	if pcCount > 1 then
	    ret = aveLv + math.floor((maxLv - aveLv) * (pcCount/30))
	end
	
	if ret > maxLv then
	    ret = maxLv
	end
	math.floor(ret)
	
	if maxLv - 30 > ret then
	    ret = maxLv - 30
	end
	
	return ret;
end

function GET_MON_RANK_LV_LASTBOSS1(self, zoneObj)
    local maxLv = GetExProp(zoneObj, "MaxLv");
	local minLv = GetExProp(zoneObj, "MinLv");
	local aveLv = GetExProp(zoneObj, "AveLv");
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	local ret = aveLv
	if pcCount > 1 then
	    ret = aveLv + ((maxLv - aveLv) * (pcCount/30))
	end
	
	if ret > maxLv then
	    ret = maxLv
	end
	ret = ret + 3
	math.floor(ret)
	
	if maxLv - 30 > ret then
	    ret = maxLv - 30
	end
	
	return ret;
end

function GET_MON_RANK_DropItem_NORMAL1(self, zoneObj)
    local monLV = GET_MON_RANK_LV_NORMAL1(self, zoneObj)
    local ret = "None"
    if monLV <= 119 then
        ret = "PartyMon_A_119"
    elseif monLV <= 144 then
        ret = "PartyMon_A_144"
    elseif monLV <= 169 then
        ret = "PartyMon_A_169"
    elseif monLV <= 194 then
        ret = "PartyMon_A_194"
    else
        ret = "PartyMon_A_219"
    end
    
    return ret
end

function GET_MON_RANK_DropItem_BOSS1(self, zoneObj)
    local monLV = GET_MON_RANK_LV_BOSS1(self, zoneObj)
    local ret = "None"
    if monLV <= 119 then
        ret = "PartyBoss_A_119"
    elseif monLV <= 144 then
        ret = "PartyBoss_A_144"
    elseif monLV <= 169 then
        ret = "PartyBoss_A_169"
    elseif monLV <= 194 then
        ret = "PartyBoss_A_194"
    else
        ret = "PartyBoss_A_219"
    end
    
    return ret
end

function GET_MON_RANK_FIX_MHP_FLAG1(self, zoneObj)
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	
	local mhp =  pcCount * 300 + 100
	
	return math.floor(mhp)
end

function GET_UPHILL_MONCLASSNAME(self, zoneObj)
    local tb = {"Onion","Goblin_Spear"}
    return "Onion"
end

function GET_UPHILL_LV_NORMAL1(self, zoneObj, arg2, zone, layer)
	
	local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    local step = 1
    
	if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	step = cmd:GetUserValue("UphillStep")
	end
	
	local maxLv = GetExProp(zoneObj, "MaxLv");
	local minLv = GetExProp(zoneObj, "MinLv");
	local aveLv = GetExProp(zoneObj, "AveLv");
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	
	local ret = aveLv
	if pcCount > 1 then
	    ret = math.floor(maxLv) --aveLv - math.floor((maxLv - minLv)*(1/(pcCount+7))) -- change standard (2018.04.04)
	end
	
	if ret > maxLv then
	    ret = maxLv
	end
	math.floor(ret)
	
	local addlv = 0
	if step > 0 then
    	if step < 30 then
    	    addlv = math.floor((step -1)/3)
    	else
    	    addlv = 10
    	end
    end
    
    ret = ret + addlv
    
--	if maxLv - 30 > ret then  -- change standard (2018.04.04)
--	    ret = maxLv - 30
--	end
	
	return ret + addlv;
end

function GET_UPHILL_MHP_DEFF1(self, zoneObj, arg2, zone, layer)
    local maxLv = GetExProp(zoneObj, "MaxLv"); 
    
	local value = 91433
	if maxLv > 120 then
	    value = value + (maxLv - 120) * 919
	end
	return value
end

function GET_PROPERTY_TEST(self, zoneObj, arg2, zone, layer)
    return 44
end

function GET_UPHILL_STEP_REWARD_NAME(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    local step = 1
    
	if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	step = cmd:GetUserValue("UphillStep")
	end
    local name = ScpArgMsg('MISSION_UPHILL_STEP_REWARD_NAME','STEP',step-1)
    return name
end

function GET_UPHILL_MON_CHANGE_1_N(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_NORMAL_LIST
    	index = (index + step * 5)% #UPHILL_NORMAL_LIST
    	index = index + 1
    	return UPHILL_NORMAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_1_S(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_SPECIAL_LIST
    	index = (index + step * 5)% #UPHILL_SPECIAL_LIST
    	index = index + 1
    	return UPHILL_SPECIAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_1_E(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_ELITE_LIST
    	index = (index + step * 5)% #UPHILL_ELITE_LIST
    	index = index + 1
    	return UPHILL_ELITE_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_1_B(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_BOSS_LIST
    	index = (index + step * 5)% #UPHILL_BOSS_LIST
    	index = index + 1
    	return UPHILL_BOSS_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_2_N(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_NORMAL_LIST
    	index = (index + step * 7)% #UPHILL_NORMAL_LIST
    	index = index + 1
    	return UPHILL_NORMAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_2_S(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_SPECIAL_LIST
    	index = (index + step * 7)% #UPHILL_SPECIAL_LIST
    	index = index + 1
    	return UPHILL_SPECIAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_2_E(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_ELITE_LIST
    	index = (index + step * 7)% #UPHILL_ELITE_LIST
    	index = index + 1
    	return UPHILL_ELITE_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_2_B(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_BOSS_LIST
    	index = (index + step * 7)% #UPHILL_BOSS_LIST
    	index = index + 1
    	return UPHILL_BOSS_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_3_N(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_NORMAL_LIST
    	index = (index + step * 9)% #UPHILL_NORMAL_LIST
    	index = index + 1
    	return UPHILL_NORMAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_3_S(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_SPECIAL_LIST
    	index = (index + step * 9)% #UPHILL_SPECIAL_LIST
    	index = index + 1
    	return UPHILL_SPECIAL_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_3_E(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_ELITE_LIST
    	index = (index + step * 9)% #UPHILL_ELITE_LIST
    	index = index + 1
    	return UPHILL_ELITE_LIST[index]
	end
end

function GET_UPHILL_MON_CHANGE_3_B(self, zoneObj, arg2, zone, layer)
    local list, cnt = GetLayerPCList(zone, layer)

	local actor = nil;
    
    if cnt > 0 and list[1] ~= nil then
		actor =list[1]
    	local cmd = GetMGameCmd(actor)
    	local step = cmd:GetUserValue("UphillStep")
    	local changeType = cmd:GetUserValue("UphillMonChangeType1")
    	local index = changeType % #UPHILL_BOSS_LIST
    	index = (index + step * 9)% #UPHILL_BOSS_LIST
    	index = index + 1
    	return UPHILL_BOSS_LIST[index]
	end
end

function SCR_GET_ITEM_SUMMON_BOSS_RANDOM(groupName)
    local maxindex = GetClassCount('item_summonboss')
    local randomBossList = {}
    local maxRatio = 0
    for i = 0, maxindex -1 do
        if GetClassStringByIndex('item_summonboss', i, 'Group') == groupName then
            randomBossList[#randomBossList + 1] = {GetClassNumberByIndex('item_summonboss', i, 'Ratio'), GetClassStringByIndex('item_summonboss', i, 'MissionMonsterClassName')}
            maxRatio = maxRatio + GetClassNumberByIndex('item_summonboss', i, 'Ratio')
        end
    end
    
    local rand = IMCRandom(1, maxRatio)
    local addRatio = 0
    for i = 1, #randomBossList do
        addRatio = addRatio + randomBossList[i][1]
        if rand <= addRatio then
            return randomBossList[i][2]
        end
    end
end

function GET_raid_siauliai1_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
    local groupName = 'Blue'
    local randomBoss = SCR_GET_ITEM_SUMMON_BOSS_RANDOM(groupName)
    return randomBoss
end

function GET_REQUEST_MISSION_RANDOM_BOSS_DROP(self, zoneObj, arg2, zone, layer)
    local monClassName = self.ClassName
    local ret
    local maxindex = GetClassCount('item_summonboss')
    for i = 0, maxindex -1 do
        if GetClassStringByIndex('item_summonboss', i, 'MissionMonsterClassName') == monClassName then
            ret = GetClassStringByIndex('item_summonboss', i, 'MissionDropList')
            break
        end
    end
    return ret
end

function GET_MISSION_CMINE_01_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
    local groupName = 'Purple'
    local randomBoss = SCR_GET_ITEM_SUMMON_BOSS_RANDOM(groupName)
    return randomBoss
end

function GET_MISSION_HUEVILLAGE_01_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
    local groupName = 'Green'
    local randomBoss = SCR_GET_ITEM_SUMMON_BOSS_RANDOM(groupName)
    return randomBoss
end

function GET_catacomb_2_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
    local groupName = 'Red'
    local randomBoss = SCR_GET_ITEM_SUMMON_BOSS_RANDOM(groupName)
    return randomBoss
end



function GET_UPHILL_MON_CHANGE_GIMMICK(self, zoneObj, arg2, zone, layer)
    local summonMonsterIndex = IMCRandom(1,3)
	self.MHP = math.floor(self.MHP*0.60)
	self.DEF = math.floor(self.DEF*0.60)
	self.MDEF = math.floor(self.MDEF*0.60)
	return UPHILL_GIMMICK_MONSTER_LIST[summonMonsterIndex]
end
