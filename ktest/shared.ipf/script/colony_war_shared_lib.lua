function GET_COLONY_MAP_GRADE_AND_PERCENTAGE(mapLevel)

--Beta에서는 해당 로직 이용
    if mapLevel < 100 then
        return 'B', 8;
    elseif mapLevel < 200 then
        return 'A', 9;
    end
    return 'S', 10;
end

function GET_COLONY_MAP_CITY(colonyMapClsName)
    local colonyCls = GET_COLONY_CLASS(colonyMapClsName)
    return colonyCls.TaxApplyCity
end

function GET_COLONY_WAR_DAY_OF_WEEK()
    local dayOfWeek = 0
    dayOfWeek = GetColonyDayOfWeek();
    return dayOfWeek;
end

function GET_COLONY_REWARD_ITEM()
    local guild_colony_rule = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    local rewardItem = TryGetProp(guild_colony_rule, 'RewardItem');
    if rewardItem == nil then
        return 'None';
    end
    return rewardItem;
end

function IS_COLONY_SPOT(mapClassName)
    local cls = GetClass("SharedConst", "COLONY_WAR_OPEN");
    local curValue = TryGetProp(cls, "Value")
    if curValue == 0 then
        return false;
    end
    local colonyClsList, cnt = GetClassList('guild_colony');    
    for i = 0, cnt - 1 do
        local colonyCls = GetClassByIndexFromList(colonyClsList, i);
        local mapClsName = TryGetProp(colonyCls, 'ZoneClassName');
        local check_word = "GuildColony_"
        if mapClsName ~= nil and mapClsName == check_word..mapClassName then
            --콜로니전 미개최 지역은 이미지 표시 안뜨도록 처리(ID 값이 0인 경우)
            if TryGetProp(colonyCls, "ID") ~= 0 then
                return true;
            end
        end
    end
    return false;
end

function IS_COLONY_MONSTER(monID)
    local monCls = GetClass('Monster', GET_COLONY_MONSTER_CLASS_NAME());
    if monCls ~= nil and monCls.ClassID == monID then
        return true;
    end
    return false;
end

function IS_COLONY_ENHANCER(monID)
    local monCls = GetClass('Monster', GET_COLONY_ENHANCER_CLASS_NAME());
    if monCls ~= nil and monCls.ClassID == monID then
        return true;
    end
    return false;
end

function GET_COLONY_CLASS(zoneName)
    local clsList, cnt = GetClassList('guild_colony');
    for i = 0, cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        if cls.ZoneClassName == zoneName then
            return cls;
        end
    end
    return nil;
end

function GET_COLONY_TOWER_RANGE(zoneName)
    local colonyCls = GET_COLONY_CLASS(zoneName);
    if colonyCls == nil then
        return 0;
    end
    return colonyCls.TowerRange;
end

function GET_COLONY_MONSTER_CLASS_NAME()
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    return ruleCls.GuildColonyBossClassName;
end

function GET_COLONY_TOWER_CLASS_NAME()
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    return ruleCls.GuildColonyTowerClassName;
end

function GET_COLONY_ENHANCER_CLASS_NAME()
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    return ruleCls.GuildColonyEnhancerClassName;
end

function GET_COLONY_MARKET_PERCENTAGE_LIST()
    local grade_A = COLONY_TAX_MARKET_RATE_A
    local grade_B = COLONY_TAX_MARKET_RATE_B

    local gradeList = { {"A", grade_A}, {"B", grade_B} }
    local clslist, cnt = GetClassList('guild_colony');
    local list = {}
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
        if cls.ID == 1 then
            local zoneGrade = TryGetProp(cls, "ZoneGrade")
            for j = 1, #gradeList do
                local grade = table.find(gradeList[j], zoneGrade)
                if grade ~= 0 then
                    local percent = gradeList[j][2]
                    list[#list + 1] = {Zone=cls.ZoneClassName, MapName=TryGetProp(GetClass('Map', cls.ZoneClassName), 'Name'), Percent=percent, CityName=TryGetProp(GetClass('Map', cls.TaxApplyCity), 'Name')} --memo
                end
            end
        end
    end
    return list;
end

--콜로니전 사용 제한 관련 스크립트
function SCR_GUILD_COLONY_RESTRICTION_CHECK_CLIENT(self, restriction_group)
    local restrictionList = {}
    local list, cnt = GetClassList("pvp_use_restrict")
    for i = 0, cnt-1 do
        local restrictionCls = GetClassByIndexFromList(list, i);
        if TryGetProp(restrictionCls, "GroupName") == restriction_group then
            table.insert(restrictionList, restrictionCls)
        end
    end

    if restriction_group == "GuildColony_Restricted_Item_CoolDown" then
        local list = {}
        for i = 1, #restrictionList do
            local name = TryGetProp(restrictionList[i], "Name")
            local coolTime = TryGetProp(restrictionList[i], "SetCoolTime")
            local itemName = TryGetProp(restrictionList[i], "ItemName")
            if itemName == "ALL" then
                list[#list+1] = {name, coolTime}
            else
                list[#list+1] = {name, coolTime, itemName}
            end
        end
        return list, #list
    end

end

function GET_COLONY_LEAGUE(mapClassName)
    local colonyClsList, cnt = GetClassList('guild_colony');    
    for i = 0, cnt - 1 do
        local colonyCls = GetClassByIndexFromList(colonyClsList, i);
        local mapClsName = TryGetProp(colonyCls, 'ZoneClassName');
        local check_word = "GuildColony_"
        if mapClsName ~= nil and mapClsName == check_word..mapClassName then
            local colonyLeague = TryGetProp(colonyCls, 'ColonyLeague');
        print(colonyLeague)
            return colonyLeague;
        end
    end
    return nil;
end