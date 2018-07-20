--- item_transcend_shared.lua

function IS_TRANSCENDING_STATE()
    local frame = ui.GetFrame("itemtranscend");
    if frame ~= nil then
        if frame:IsVisible() == 1 then
            return true;
        end
    end

    frame = ui.GetFrame("itemtranscend_remove");
    if frame ~= nil then
        if frame:IsVisible() == 1 then
            return true;
        end
    end

    frame = ui.GetFrame("itemtranscend_break");
    if frame ~= nil then
        if frame:IsVisible() == 1 then
            return true;
        end
    end

    return false;
end

function IS_TRANSCEND_ABLE_ITEM(obj)
    if TryGetProp(obj, "Transcend") == nil then
        return 0;
    end
    
    if TryGetProp(obj, "BasicTooltipProp") == nil then
        return 0;
    end

    if TryGetProp(obj, "ItemStar") == nil or TryGetProp(obj, "ItemStar") < 1 then
        return 0;
    end
    
    local afterNames, afterValues = GET_ITEM_TRANSCENDED_PROPERTY(obj);
    if #afterNames == 0 then
        return 0;
    end
    
    local itemCls = GetClass("Item", obj.ClassName);
    if itemCls == nil then
        return 0;
    end

    local itemMaxPR = TryGetProp(itemCls, "MaxPR")
    if itemMaxPR == nil or itemMaxPR == 0 then
        return 0;
    end

    local itemMPR = TryGetProp(itemCls, "PR")
    if itemMPR == nil or itemMPR == 0 then
        return 0;
    end

    return 1;
end

function IS_TRANSCEND_ITEM(obj)
    local value = TryGetProp(obj, "Transcend");
    if value ~= nil then
        if value ~= 0 then
            return 1;
        end
    end

    return 0;
end

function GET_TRANSCEND_MATERIAL_ITEM(target)

    local groupName = TryGetProp(target, "GroupName");
    if groupName == nil then
        return 0;
    end
    
    return "Premium_item_transcendence_Stone";
end

function GET_TRANSCEND_MATERIAL_COUNT(targetItem, Arg1)

    local lv = TryGetProp(targetItem , "UseLv");
    
    if lv == nil then
        return 0;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(targetItem, 0);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end

    local transcendCount = TryGetProp(targetItem, "Transcend");

    if transcendCount == nil then
        return 0;
    end
    
    if Arg1 ~= nil then
        transcendCount = Arg1;
    end
    
    
    local grade = TryGetProp(targetItem, "ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "TranscendCostRatio")
    
    local needMatCount;
    
    local classType = TryGetProp(targetItem , "ClassType");
    
    if classType == nil then
        return 0;
    end

    local slot = TryGetProp(targetItem, "DefaultEqpSlot");
    
    if slot == nil then
        return 0;
    end

    local equipTypeRatio;
    
    local groupName = TryGetProp(targetItem, "GroupName");
    if groupName == nil then
        return 0;
    end

    if groupName == 'Weapon' then
        if classType == 'Sword' or classType == 'Staff' or classType =='Rapier' or classType =='Spear' or classType =='Bow' or classType =='Mace' then
            equipTypeRatio = 0.8;
        elseif slot == 'RH' then
        --Twohand Weapon-- 
            equipTypeRatio = 1;
        else
            return 0;
        end
    elseif groupName == 'SubWeapon' then
            equipTypeRatio = 0.6;
    elseif groupName == 'Armor' or classType == 'Shield' then
        --Amor/Shield/Acc--
            equipTypeRatio = 0.33;
    else
        return 0;
    end
    
    --Need Material Count --
    needMatCount = math.floor(((1 + (transcendCount + lv ^ (0.2 + ((math.floor(transcendCount / 3) * 0.03)) + (transcendCount * 0.05))) * equipTypeRatio) * gradeRatio));
    return SyncFloor(needMatCount);
end

function GET_TRANSCEND_BREAK_ITEM()
    return "Premium_itemDissassembleStone";
end

function GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj)
    if 1 ~= IS_TRANSCEND_ABLE_ITEM(itemObj) then
        return;
    end
    
    local transcend = TryGetProp(itemObj,"Transcend");
    if transcend == nil then
        return 0;
    end
    
    local useMatCount = TryGetProp(itemObj,"Transcend_SucessCount");
    if useMatCount == nil then
        return 0;
    end
    
    local giveCnt = math.floor(useMatCount * 0.9);
    
    if transcend <= 1 then
        giveCnt = 0;
    end
    
    return SyncFloor(giveCnt);
end

function GET_TRANSCEND_BREAK_SILVER(itemObj)
    return GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj) * 10000;
end

function GET_TRANSCEND_SUCCESS_RATIO(itemObj, cls, itemCount)

    local maxItemCls = GET_TRANSCEND_MATERIAL_COUNT(itemObj, nil);
    if maxItemCls == nil or maxItemCls == 0 then
    
        return 0;
    
    end 
    
    return math.floor(itemCount * 100 / maxItemCls);

end

function GET_ITEM_TRANSCENDED_PROPERTY(itemObj, ignoreTranscend)
    if ignoreTranscend == nil then
        ignoreTranscend = 0;
    end

    local retPropType = {};
    local retPropValue = {};
    local basicTooltipPropList = StringSplit(itemObj.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local baseProp = basicTooltipPropList[i];
        if (baseProp == "ATK" or baseProp == "MATK") and CHECK_EXIST_ELEMENT_IN_LIST(retPropType, 'ATK') == false then
            retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_ATK_RATIO(itemObj, ignoreTranscend);
            retPropType[#retPropType + 1] = "ATK";
        elseif baseProp == "DEF" and CHECK_EXIST_ELEMENT_IN_LIST(retPropType, 'DEF') == false then
            retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_DEF_RATIO(itemObj, ignoreTranscend);
            retPropType[#retPropType + 1] = "DEF";
        elseif baseProp == "MDEF" and CHECK_EXIST_ELEMENT_IN_LIST(retPropType, 'MDEF') == false then
            retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_MDEF_RATIO(itemObj, ignoreTranscend);
            retPropType[#retPropType + 1] = "MDEF";
        end
    end

    return retPropType, retPropValue;
end

function CHECK_EXIST_ELEMENT_IN_LIST(list, element)
    for i = 1, #list do
        if list[i] == element then
            return true;
        end
    end
    return false;
end

function GET_UPGRADE_ADD_ATK_RATIO(item, ignoreTranscend)
    if item.Transcend > 0 and ignoreTranscend ~= 1 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
        local value = class.AtkRatio;
        local itemOwner = GetItemOwner(item)
        local checkPvp = IsPVPServer(itemOwner)
        if checkPvp == nil then
            checkPvp = 0;
        end
        
        if checkPvp == 1 then
            return value * 0.5
        else
            return value;
        end
    end
    return 0;
end

function GET_UPGRADE_ADD_DEF_RATIO(item, ignoreTranscend)
    if item.Transcend > 0  and ignoreTranscend ~= 1 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
        local value = class.DefRatio;
        return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_MDEF_RATIO(item, ignoreTranscend)
    if item.Transcend > 0 and ignoreTranscend ~= 1 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
        local value = class.MdefRatio;
        return value;
    end
    return 0;
end

function GET_TRANSCEND_REMOVE_ITEM()
    return "Premium_deleteTranscendStone";
end

function GET_TRANSCEND_SCROLL_TYPE(scrollObj)
    if IS_TRANSCEND_SCROLL_ITEM(scrollObj) ~= 1 then
        return;
    end

    local scrollType = scrollObj.StringArg;
    return scrollType;
end

function IS_TRANSCEND_SCROLL_ITEM(scrollObj)
	local scrollType = TryGetProp(scrollObj, "StringArg");
    local transcend = TryGetProp(scrollObj, "NumberArg1");
    local percent = TryGetProp(scrollObj, "NumberArg2");
    if scrollType == nil or transcend == nil or percent == nil then
        return 0;
    end

	if scrollType == "transcend_Set" then
		return 1;
	elseif scrollType == "transcend_Add" then
		return 1;
	end
	return 0;
end

function IS_TRANSCEND_SCROLL_ABLE_ITEM(itemObj, scrollType)
    if scrollType == "transcend_Set" then
        if IS_TRANSCEND_ITEM(itemObj) == 0 and IS_TRANSCEND_ABLE_ITEM(itemObj) == 1 then
            return 1;
        else
            return 0;
        end
    elseif scrollType == "transcend_Add" then
        if IS_TRANSCEND_ABLE_ITEM(itemObj) == 1 then
            return 1;
        else
            return 0;
        end
    end
    return 0;
end

function GET_ANTICIPATED_TRANSCEND_SCROLL_SUCCESS(itemObj, scrollObj)
    if IS_TRANSCEND_SCROLL_ITEM(scrollObj) ~= 1 then
        return;
    end
    local scrollType = scrollObj.StringArg;
    if IS_TRANSCEND_SCROLL_ABLE_ITEM(itemObj, scrollType) ~= 1 then
        return;
    end
    
    local transcend = scrollObj.NumberArg1;
    local percent = scrollObj.NumberArg2;
    if scrollType == nil or transcend == nil or percent == nil then
        return;
    end
    
    if scrollType == "transcend_Set" then
        return transcend, percent;
    elseif scrollType == "transcend_Add" then
        local curTranscend = 0;
        if IS_TRANSCEND_ITEM(itemObj) == 1 then
            curTranscend = itemObj.Transcend;
        end
        return curTranscend + transcend, percent;
    end
end
