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

	local groupName = target.GroupName;
	if groupName == "Weapon" or groupName == "SubWeapon" then
		return "Premium_itemUpgradeStone_Weapon";
	elseif groupName == "Armor" then
	    local clsType = target.ClassType;
		if clsType ~= "Neck" and clsType ~= "Ring" then
			return "Premium_itemUpgradeStone_Armor";
		else
			return "Premium_itemUpgradeStone_Acc";
		end
	end

	return "";
end

function GET_TRANSCEND_MATERIAL_COUNT(targetItem, transcendCls)
    if targetItem.GroupName == "Armor" then
	    local clsType = targetItem.ClassType;
	    if clsType == "Boots" or clsType == "Gloves" then
	    	return transcendCls.SubArmorItemCount;
    	elseif clsType ~= "Neck" and clsType ~= "Ring" then
	    	return transcendCls.ArmorItemCount;
    	else
	    	return transcendCls.AccesoryItemCount;
    	end
    end
	return transcendCls.WeaponItemCount;
end

function GET_TRANSCEND_BREAK_ITEM()
	return "Premium_itemDissassembleStone";
end

function GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj)
	if 1 ~= IS_TRANSCEND_ABLE_ITEM(itemObj) then
		return;
	end

--return math.floor(itemObj.Transcend_MatCount * 0.4);
    local transcendClsList = GetClassList("ItemTranscend");
    local cnt = 0;
    local transcend = itemObj.Transcend;
        for i = 0, transcend - 1 do
    	local cls = GetClassByIndexFromList(transcendClsList, i);
	    if nil ~= cls then
		    local clsCnt = GET_TRANSCEND_MATERIAL_COUNT(itemObj, cls);
    		cnt = cnt + GET_TRANSCEND_MATERIAL_COUNT(itemObj, cls);
	    end
    end

    local itemCls = GetClass("Item", itemObj.ClassName);
    if itemCls == nil then
		return 0;
	end
	
    local itemMPR = TryGetProp(itemObj, "MaxPR")
	if itemMPR == nil or itemMPR == 0 then
		return 0;
	end

    local itemPR = TryGetProp(itemObj, "PR")
    if nil == itemPR then
	    itemPR = itemMPR;
    end
	
    local giveCnt = cnt * (0.2 + ((itemPR / itemMPR) * 0.7))
		giveCnt = math.floor(giveCnt);
        if giveCnt <= 0 then
        	giveCnt = 1;
        end
    
    if itemObj.Transcend == 1 then
        giveCnt = 0;
    end
    
    return giveCnt;
	end

function GET_TRANSCEND_BREAK_SILVER(itemObj)
	return GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj) * 10000;
end

function GET_TRANSCEND_SUCCESS_RATIO(itemObj, cls, itemCount)

	local maxItemCls = GET_TRANSCEND_MATERIAL_COUNT(itemObj, cls);
	return math.floor(itemCount * 100 / maxItemCls);

end

function GET_ITEM_TRANSCENDED_PROPERTY(itemObj)

	local baseProp = itemObj.BasicTooltipProp;

	local retPropType = {};
	local retPropValue = {};

	if baseProp == "ATK" or baseProp == "MATK" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_ATK_RATIO(itemObj);
		retPropType[#retPropType + 1] = "ATK";
	elseif baseProp == "DEF" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_DEF_RATIO(itemObj);
		retPropType[#retPropType + 1] = "DEF";
	elseif baseProp == "HR" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_HR_RATIO(itemObj);
		retPropType[#retPropType + 1] = "HR";
	elseif baseProp == "DR" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_DR_RATIO(itemObj);
		retPropType[#retPropType + 1] = "DR";
	elseif baseProp == "MHR" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_MHR_RATIO(itemObj);
		retPropType[#retPropType + 1] = "MHR";
	elseif baseProp == "MDEF" then
		retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_MDEF_RATIO(itemObj);
		retPropType[#retPropType + 1] = "MDEF";
	end

	if itemObj.GroupName == "Armor" then
		local clsType = itemObj.ClassType;
		if clsType ~= "Neck" and clsType ~= "Ring" and clsType ~= "Outer" then
			retPropValue[#retPropValue + 1] = GET_UPGRADE_ADD_MHP_RATIO(itemObj);
			retPropType[#retPropType + 1] = "MHP";
		end
	end

	return retPropType, retPropValue;
end

function GET_UPGRADE_ADD_ATK_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.AtkRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_DEF_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.DefRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_MDEF_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.MdefRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_HR_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.HrRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_DR_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.DrRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_MHR_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.MhrRatio;
    	return value;
    end
    return 0;
end

function GET_UPGRADE_ADD_MHP_RATIO(item)
    if item.Transcend > 0 then
        local class = GetClassByType('ItemTranscend', item.Transcend);
    	local value = class.MhpRatio;
    	return value;
    end
    return 0;
end

function GET_TRANSCEND_REMOVE_ITEM()
	return "Premium_deleteTranscendStone";
end

