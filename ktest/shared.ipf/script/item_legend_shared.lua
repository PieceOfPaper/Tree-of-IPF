function IS_ENABLE_EXTRACT_OPTION(item)
    if TryGetProp(item,'Extractable', 'No') ~= 'Yes' then
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
    return {'Extract_kit', 'Extract_kit_Sliver', 'Extract_kit_Gold', 'Extract_kit_Gold_NotFail'};
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
    if kitCls.StringArg == 'Extract_kit_Sliver' or kitCls.StringArg == 'Extract_kit_Gold_NotFail' then 
        return true;
    end
    return false;
end

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

function GET_OPTION_EQUIP_LIMIT_LEVEL(targetItem)
    local limitLevel = targetItem.UseLv - 40;    
    return math.max(limitLevel, 360);
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
    if item == nil or item.InheritanceItemName == 'None' then
        return;
    end

    local inheritanceItem = GetClass('Item', item.InheritanceItemName);
    if inheritanceItem == nil then
        return;
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

function IS_100PERCENT_SUCCESS_EXTRACT_ICOR_ITEM(item)
    if item == nil then
        return false;
    end

    return item.StringArg == 'Extract_kit_Gold_NotFail';
end