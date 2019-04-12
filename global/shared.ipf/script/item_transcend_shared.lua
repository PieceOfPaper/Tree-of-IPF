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

function GET_TRANSCEND_BREAK_ITEM()
	return "Premium_itemDissassembleStone";
end

function GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj)

	return math.floor(itemObj.Transcend_MatCount * 0.4);

end

function GET_TRANSCEND_BREAK_SILVER(itemObj)
	return GET_TRANSCEND_BREAK_ITEM_COUNT(itemObj) * 10000;
end

function GET_TRANSCEND_SUCCESS_RATIO(cls, itemCount)

	local maxItemCls = cls.ItemCount;
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

