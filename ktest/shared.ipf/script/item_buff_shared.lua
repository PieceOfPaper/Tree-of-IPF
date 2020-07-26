--item_buff.lua

function GET_ITEM_PROPERT_STR(item, basicTooltipProp)
    if item.GroupName == "Weapon" then
        if basicTooltipProp == "ATK" then
            return ClMsg("MAXATK"), ClMsg("MINATK");
        elseif basicTooltipProp == "MATK" then
            return ClMsg("Magic_Atk"), "";
        end
    elseif item.GroupName == "SubWeapon" then
        if basicTooltipProp == "ATK" then
            return ClMsg("MAXATK"), ClMsg("MINATK");
        elseif basicTooltipProp == "DEF" then
            return ClMsg("MELEEDEF"), "";
        end
    else
        if basicTooltipProp == "DEF" then
            return ClMsg("MELEEDEF"), "";
        elseif basicTooltipProp == "MDEF" then
            return ClMsg("MDEF"), "";
        elseif  basicTooltipProp == "HR" then
            return ClMsg("ADD_HR"), "";
        elseif  basicTooltipProp == "DR" then
            return ClMsg("ADD_DR"), "";
        elseif  basicTooltipProp == "CRTMATK" then
            return ClMsg("CRTMATK"), "";
        elseif  basicTooltipProp == "ADD_FIRE" then
            return ClMsg("ADD_FIRE"), "";
        elseif  basicTooltipProp == "ADD_ICE" then
            return ClMsg("ADD_ICE"), "";
        elseif  basicTooltipProp == "ADD_LIGHTNING" then
            return ClMsg("ADD_LIGHTNING"), "";
        else
        return "";
        end
    end
end

function ITEMBUFF_CHECK_Squire_EquipmentTouchUp(self, item)
    if false == IS_EQUIP(item) then
        return 0;
    end

    if item.GroupName == "Weapon" then
        return 1;
    end

    if item.GroupName == 'SubWeapon' and CHECK_ITEM_BASIC_TOOLTIP_PROP_EXIST(item, 'ATK') then
        return 1;
    end

    if item.GroupName == "Armor" then
        if item.ClassType == "Shield" or
           item.ClassType == "Shirt" or
           item.ClassType == "Pants" or
           item.ClassType == "Gloves" or
           item.ClassType == "Boots" then
                return 1;
        end
    end

    return 0;
end

function CHECK_ITEM_BASIC_TOOLTIP_PROP_EXIST(item, propertyName)
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        if basicTooltipPropList[i] == propertyName then
            return true;
        end
    end
    return false;
end

function ITEMBUFF_CHECK_Enchanter_EnchantArmor(self, item)
    if false == IS_EQUIP(item) then
        return 0;
    end

    if item.GroupName == "Armor" then
        if item.ClassType == "Shield" or
           item.ClassType == "Shirt" or
           item.ClassType == "Pants" then
                return 1;
        end
        return 0;
    end
    return 0;
end

function ITEMBUFF_NEEDITEM_Enchanter_EnchantArmor(self, item)   
    return "misc_emptySpellBook", 1;
end

function ITEMBUFF_NEEDITEM_Squire_EquipmentTouchUp(self, item)
--  local needCount = item.ItemStar + item.ItemStar * (item.ItemGrade - 1) / 2;
    
    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local useLv = TryGetProp(item,"UseLv");
    if useLv == nil then
        return 0;
    end
    
    local itemLv = TryGetProp(item,"ItemLv");
    if itemLv == nil then
        return 0;
    end
    
    local lv = math.max(useLv, itemLv);
    lv = lv / 30
        if lv < 1 then
           lv = 1;
        end
    
    local needCount = lv + lv * (item.ItemGrade - 1) / 2;
    needCount = math.max(1, needCount);
    return "misc_whetstone", math.floor(needCount);
end

function ITEMBUFF_NEEDITEM_Squire_Repair(self, item)
--  local needCount = item.ItemStar + item.ItemStar * (item.ItemGrade - 1) / 2;
    local reinforceCount = TryGetProp(item, "Reinforce_2");
       if reinforceCount == nil then
           return 0;
   end

   local transcendCount = TryGetProp(item, "Transcend");
       if transcendCount == nil then
           return 0;
   end

   local UseLv = item.UseLv / 30
   if UseLv < 1 then
       UseLv = 1;
   end
      
   local grade = TryGetProp(item, "ItemGrade");
   if grade == nil then
    return 0;
   end
   
   local repairPriceRatio = TryGetProp(item,"RepairPriceRatio");   
   if repairPriceRatio == nil then
    return 0;
   end
   
   repairPriceRatio = repairPriceRatio / 100;
--   local needCount = (UseLv + UseLv * (item.ItemGrade - 1) / 2) * (1 + (((grade-1) * 0.1) + (reinforceCount * 0.05) + (transcendCount * 0.2)));
    local needCount = (UseLv + UseLv * (grade - 1) / 2) * (1 + (((grade-1) * 0.1) + (reinforceCount * 0.05) + (transcendCount * 0.2))) * repairPriceRatio;
    needCount = math.max(1, needCount);
    return "misc_repairkit_1", math.floor(needCount);
end

function ITEMBUFF_STONECOUNT_Squire_EquipmentTouchUp(invItemList)
    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_whetstone'}
    }, false, invItemList);
    return "misc_whetstone", count;
end

function ITEMBUFF_STONECOUNT_Squire_Repair(invItemList)
    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_repairkit_1'}
    }, false, invItemList);
    return "misc_repairkit_1", count;
end

function ITEMBUFF_STONECOUNT_Enchanter_EnchantArmor(invItemList)
    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_emptySpellBook'}
    }, false, invItemList);
    return "misc_emptySpellBook", count;
end

function ITEMBUFF_VALUE_Squire_EquipmentTouchUp(self, item, skillLevel)
    
--  local value = item.ItemStar + skillLevel * item.ItemStar;
    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local useLv = TryGetProp(item,"UseLv");
    if useLv == nil then
        return 0;
    end
    
    local itemLv = TryGetProp(item,"ItemLv");
    if itemLv == nil then
        return 0;
    end
    
    local lv = math.max(useLv, itemLv);
    
    local pcBangItemLevel = CALC_PCBANG_GROWTH_ITEM_LEVEL(item);
    if pcBangItemLevel ~= nil then
        lv = pcBangItemLevel;
    end
    
    local itemstring = TryGetProp(item, 'StringArg','None')
    if itemstring == 'Growth_Item' then
        local grothItem = CALC_GROWTH_ITEM_LEVEL(item);
        if grothItem ~= nil then
            lv = grothItem;
        end
    end

    if item.GroupName == 'Armor' then -- 방어구 손질
        local def = TryGetProp(item, "DEF", 0)
        local mdef = TryGetProp(item, "MDEF", 0)

        local value = math.floor(((def + mdef) / 2) * (skillLevel * 0.007));
        local count = math.floor(500 + skillLevel * 50 + ((self.DEX + self.STR) * 0.1))
        local sec = 3600;        
        local Squire4 = GetAbility(self, 'Squire4');
    
        if Squire4 ~= nil then
            count = count + Squire4.Level * 5
        end

        return value, sec, count;
    end
    
    -- 무기 손질
    local minatk = TryGetProp(item, "MINATK", 0)
    local maxatk = TryGetProp(item, "MAXATK", 0)

    local value = math.floor(((minatk + maxatk) / 2) * (skillLevel * 0.007));
    local count = math.floor(2500 + skillLevel * 250 + ((self.DEX + self.STR) * 0.5))
    local sec = 3600;
    local Squire3 = GetAbility(self, 'Squire3');
    if Squire3 ~= nil then
        count = count + Squire3.Level * 20
    end
    return value, sec, count;
    
end

function ITEMBUFF_VALUE_Squire_Repair(self, item, skill)

    local sklValue = skill.Level * 100;
    
    local owner = GetSkillOwner(skill);
    local abil = GetAbility(owner, "Squire10")
    if abil ~= nil then
        if IMCRandom(1, 9999) < abil.Level * 500 then
            sklValue = sklValue * 2 
        end
    end
    
    local value = (item.MaxDur - item.Dur) + sklValue
    
    value = item.Dur + value;
    return value;
end


function ITEMBUFF_STONECOUNT_Alchemist_Roasting(invItemList, frame)
    frame:SetUserValue("STORE_GROUP_NAME", 'GemRoasting');

    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_catalyst_1'}
    }, false, invItemList);
    return "misc_catalyst_1", count;
end


function ITEMBUFF_NEEDITEM_Alchemist_Roasting(self, item)
    local needCount = 1;
    return "misc_catalyst_1", needCount;
end


function ITEMBUFF_CHECK_Alchemist_Roasting(self, item)
    
    if item.GroupName == "Gem" then
        return 1;
    end

    return 0;
end

function ITEMBUFF_STONECOUNT_Appraiser_Apprise(invItemList, frame)
    if frame ~= nil then
        frame:SetUserValue("STORE_GROUP_NAME", 'Appraise');
    end

    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_0507'}
    }, false, invItemList);
    return "misc_0507", count;
end

function ITEMBUFF_NEEDITEM_Appraiser_Apprise(self, item) -- 스킬 이름 바뀌면 여기 수정
    local needCount =GET_APPRAISAL_PRICE(item, nil) / 200;
    return "misc_0507", math.floor(needCount); -- 재료 이름 바뀌면 여기 수정
end

function ITEMBUFF_STONECOUNT_Sage_PortalShop(invItemList)
    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='misc_portalstone'}
    }, false, invItemList);
    return "misc_portalstone", count; -- 포탈 상점 재료 이름 써주세요
end

function ITEMBUFF_NEEDITEM_Sage_PortalShop(target, destZoneName)
    local warpCost = CalcWarpCost(GetZoneName(target), destZoneName);
    local needCount = 1 --  -- 포탈 상점 재료 공식 써주세요. 지금은 워프 비용 / 10 했음.
    needCount = math.max(1, needCount); --  최소 1 보장
    
    return "misc_portalstone", math.floor(needCount); -- 포탈 상점 재료 이름 써주세요
end

function GET_MAX_ENABLE_REGISTER_PORTAL_CNT(seller, portalShopSkillObj)
    local portalCNT = 3

    return portalCNT -- 포탈 상점 최대 등록 가능한 포탈 개수
end