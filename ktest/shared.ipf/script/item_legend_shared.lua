function IS_ENABLE_EXTRACT_OPTION(item)
    if TryGetProp(item,'Extractable', 'No') ~= 'Yes' or TryGetProp(item,'LifeTime', 1) ~= 0 then
        return false;
    end

    if IS_LEGEND_GROUP_ITEM(item) == false and item.NeedRandomOption == 1 then
        return false;    
    end

    return true;
end

function IS_LEGEND_GROUP_ITEM(item)
    if TryGetProp(item, 'LegendGroup', 'None') == 'None' then
        return false;
    end
    return true;
end

function GET_OPTION_EXTRACT_KIT_LIST()
    return {'Extract_kit', 'Extract_kit_Sliver', 'Extract_kit_Gold', 'Extract_kit_Gold_NotFail', 'Extract_kit_Gold_NotFail_Rand', 'Extract_kit_Gold_NotFail_Recipe'};
end

function IS_VALID_OPTION_EXTRACT_KIT(itemCls)
    local list = GET_OPTION_EXTRACT_KIT_LIST();
    for i = 1, #list do
        if list[i] == itemCls.StringArg and tonumber(TryGetProp(itemCls, "ItemLifeTimeOver", 0)) == 0 then
            return true;
        end
    end
    return false;
end

function GET_OPTION_EXTRACT_MATERIAL_NAME()
    return 'misc_ore23'; 
end

function GET_OPTION_EXTRACT_NEED_MATERIAL_COUNT(item)
    return math.floor(item.UseLv / (3 * (5 - item.ItemGrade)));
end

function IS_ENABLE_NOT_TAKE_MATERIAL_KIT(kitCls)
    if kitCls.StringArg == 'Extract_kit_Sliver' or kitCls.StringArg == 'Extract_kit_Gold_NotFail' or kitCls.StringArg == 'Extract_kit_Gold_NotFail_Recipe' or kitCls.StringArg == 'Extract_kit_Gold_NotFail_Rand' then 
        return true;
    end
    return false;
end

-- 아이커 연성 재료 정보 관련 내용
function GET_OPTION_LEGEND_EXTRACT_KIT_LIST()
    return {'Dirbtumas_kit', 'Dirbtumas_kit_Sliver'};
end

function IS_VALID_OPTION_LEGEND_EXTRACT_KIT(itemCls)
    local list = GET_OPTION_LEGEND_EXTRACT_KIT_LIST();
    for i = 1, #list do
        if list[i] == itemCls.StringArg and tonumber(TryGetProp(itemCls, "ItemLifeTimeOver", 0)) == 0 then
            return true;
        end
    end
    return false;
end

function GET_OPTION_LEGEND_EXTRACT_MATERIAL_NAME()
    return 'misc_ore23'; 
end

function GET_OPTION_LEGEND_EXTRACT_NEED_MATERIAL_COUNT(item)
    return math.floor(item.UseLv * (item.ItemGrade + 3) / (3 * (5 - item.ItemGrade)));
end

function IS_ENABLE_NOT_TAKE_MATERIAL_KIT_LEGEND_EXTRACT(kitCls)
    if kitCls.StringArg == 'Dirbtumas_kit_Sliver' then 
        return true;
    end
    return false;
end
--------------------------------

function IS_ENABLE_NOT_TAKE_POTENTIAL_BY_EXTRACT_OPTION(kitCls)
    if kitCls.StringArg == 'Extract_kit_Gold' then 
        return true;
    end
    return false;
end

function GET_OPTION_EXTRACT_TARGET_ITEM_NAME(inheritanceItemName)
    if inheritanceItemName.GroupName == 'Armor' then
        return 'Armor_icor';
    end
    return 'Weapon_icor';
end

function GET_OPTION_EQUIP_NEED_MATERIAL_COUNT(item)
    return 0;
end

function GET_OPTION_EQUIP_CAPITAL_MATERIAL_NAME() 
    return 'misc_BlessedStone';
end

function GET_OPTION_EQUIP_NEED_CAPITAL_COUNT(item)
    return 0;
end

function GET_OPTION_EQUIP_NEED_SILVER_COUNT(item)
    return item.UseLv * 30000;
end

function OVERRIDE_INHERITANCE_PROPERTY(item)
    if item == nil or (item.InheritanceItemName == 'None' and item.InheritanceRandomItemName == 'None') then
        return;
    end

    local inheritanceItem = GetClass('Item', item.InheritanceItemName);
    if inheritanceItem == nil then
        inheritanceItem = GetClass('Item', item.InheritanceRandomItemName);
        
        if inheritanceItem == nil then
            return;
        end
    end

    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    local basicTooltipPropTable = {};
    for i = 1, #basicTooltipPropList do
        basicTooltipPropTable[basicTooltipPropList[i]] = true;
    end

    local commonPropList = GET_COMMON_PROP_LIST();
    for i = 1, #commonPropList do
        local propName = commonPropList[i];
        if basicTooltipPropTable[propName] == nil then
            item[propName] = item[propName] + inheritanceItem[propName];
        end
    end
end

function SCR_VELLCOFFER_MATCOUNT(pc)
    local matCount = 2;
    
    for i = 5, 7 do
        local rndCount = IMCRandom(1, i)
        if rndCount == 1 then
            matCount = matCount + 1
        else
            break;
        end
    end
    
    return matCount;
end

function SCR_SEVINOSE_MATCOUNT(pc)
    local matCount = 1;
    
    for i = 10, 12 do
        local rndCount = IMCRandom(1, i)
        if rndCount == 1 then
            matCount = matCount + 1
        else
            break;
        end
    end
    
    return matCount;
end

function IS_100PERCENT_SUCCESS_EXTRACT_ICOR_ITEM(item)
    if item == nil then
        return false;
    end

    return item.StringArg == 'Extract_kit_Gold_NotFail' or item.StringArg == 'Extract_kit_Gold_NotFail_Rand' or item.StringArg == 'Extract_kit_Gold_NotFail_Recipe';
end

-- 아이커 장착 해제 조건 체크, 고정옵션(InheritanceItemName), 랜덤옵션(InheritanceRandomItemName)
function IS_ENABLE_RELEASE_OPTION(item)   
    if TryGetProp(item, 'ItemType', 'None') == 'Equip' then
        if TryGetProp(item, 'InheritanceItemName', 'None') ~= 'None' or TryGetProp(item, 'InheritanceRandomItemName', 'None') ~= 'None' then
            return true        
        end
    end
    
    return false;
end;

function GET_OPTION_RELEASE_COST(item, taxRate)
    if item == nil then
        return 0;
    end;

    local price = TryGetProp(item, 'UseLv');
    price = price * 100;
    if taxRate ~= nil then
        price = tonumber(CALC_PRICE_WITH_TAX_RATE(price, taxRate));
    end;
    
    return SyncFloor(price);
end;

-- 아이커가 가능한 랜덤 레전드 아이템인가?
function IS_ICORABLE_RANDOM_LEGEND_ITEM(item)    
    if TryGetProp(item, 'NeedRandomOption', 0) == 1 and TryGetProp(item, 'LegendGroup', 'None') ~= 'None' then
        return true
    else
        return false
    end
end
function GET_ICOR_MULTIPLE_MAX_COUNT()
    local max_count = 6
    
    return max_count
end

function GET_COMPOSITION_VIROBA_SOURCE_COUNT()
    local max_count = 3
    
    return max_count
end
-- Lv1 바이보라 장비 또는 아이커
function IS_COMPOSABLE_VIRORA(item)
    local group_name = TryGetProp(item, 'GroupName', 'None')
    if group_name == 'None' then
        return false, 'None'
    end

    if group_name == 'Icor' then
        local class_name = TryGetProp(item, 'InheritanceItemName', 'None')
        local cls = GetClass('Item', class_name)
        if cls ~= nil then
            if TryGetProp(cls, 'StringArg', 'None') == 'Vibora' and TryGetProp(cls, 'NumberArg1', 0) == 1 then
                return true, TryGetProp(cls, 'ClassName', 'None')
            end
        end
    else    
        if TryGetProp(item, 'StringArg', 'None') == 'Vibora' and TryGetProp(item, 'NumberArg1', 0) == 1 then
            return true, TryGetProp(item, 'ClassName', 'None')
        end
    end

    return false, 'None'
end


-- 바이보라 업그레이드
function GET_UPGRADE_VIROBA_SOURCE_COUNT()
    local max_count = 2;
    
    return max_count
end

-- 가능여부, ClassName, NumberArg1
function CAN_UPGRADE_VIBORA(item)
    local group_name = TryGetProp(item, 'GroupName', 'None')
    if group_name == 'None' then
        return false, 'None', 0
    end

    if group_name == 'Icor' then
        local class_name = TryGetProp(item, 'InheritanceItemName', 'None')
        local cls = GetClass('Item', class_name)
        if cls ~= nil then
            if TryGetProp(cls, 'StringArg', 'None') == 'Vibora' then
                return true, TryGetProp(cls, 'ClassName', 'None'), TryGetProp(cls, 'NumberArg1', 0)
            end
        end
    else    
        if TryGetProp(item, 'StringArg', 'None') == 'Vibora' then
            return true, TryGetProp(item, 'ClassName', 'None'), TryGetProp(item, 'NumberArg1', 0)
        end
    end
    return false, 'None', 0
end

-- 바이보라 연성제인가?
function IS_UPGARDE_VIBORA_MISC(item, goal_lv)
    if TryGetProp(item, 'StringArg', 'None') == 'UpgadeVibora' and TryGetProp(item, 'NumberArg1', 0) == goal_lv then
        return true
    end
    return false
end

function GET_REQUIRED_VIBORA_MISC_COUNT(goal_lv)
    if goal_lv == 2 then
        return 20
    end
    return 20
end

-- 연성된 결과로 얻을 아이템 ClassName를 가져온다.
function GET_UPGRADE_VIBORA_ITEM_NAME(item)
    local group_name = TryGetProp(item, 'GroupName', 'None')
    if group_name == 'None' then
        return 'None'
    end

    if group_name == 'Icor' then
        local class_name = TryGetProp(item, 'InheritanceItemName', 'None')
        local cls = GetClass('Item', class_name)
        if cls ~= nil then
            item = cls            
        end    
    end

    if TryGetProp(item, 'StringArg', 'None') ~= 'Vibora' then
        return 'None'
    end

    local lv = TryGetProp(item, 'NumberArg1', 0)
    if lv < 1 then
        return 'None'
    end

    local class_name = TryGetProp(item, 'ClassName', 'None')

    local vibora_name = ''
    local token = StringSplit(class_name, '_')
    local end_count = #token - 1

    local goal_lv = lv + 1;
    if goal_lv == 2 then
        end_count = end_count + 1
    end

    local i = 1
    for i = 1, end_count do
        vibora_name = vibora_name .. token[i] .. '_'
    end
    
    vibora_name = vibora_name .. 'Lv' .. tostring(goal_lv)

    return vibora_name
end

-- 리스트 중 check_count 까지 모두 동일한 아이템인가? 같은 종류 아이커/장비, NumberArg1 수치
 function IS_VALID_UPGRADE_VIBORA_ITEM_LIST(list, check_count)
    if #list < check_count or check_count < 1 then
        return false, 'None', 0
    end

    local dic_name = {}
    local dic_lv = {}
    local level = 0
    local class_name = ''
    
    for i = 1, check_count do
        local ret, name, lv = CAN_UPGRADE_VIBORA(list[i])
        
        if ret == false then            
            return false, 'None', 0
        end
        
        dic_name[name] = 1        
        dic_lv[lv] = 1
        if level == 0 then
            level = lv
        end
        if class_name == '' then
            class_name = name
        end
    end

    local name_count = 0
    local lv_count = 0

    for k, v in pairs(dic_name) do        
        name_count = name_count + 1
    end

    for k, v in pairs(dic_lv) do
        lv_count = lv_count + 1
    end

    if name_count ~= 1 or lv_count ~= 1 then
        return false, 'None', 0
    end

    return true, class_name, level
 end