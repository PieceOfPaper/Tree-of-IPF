function SCR_SIERA_MATERIAL(item)

	local itemLv = TryGetProp(item, "UseLv")
	if itemLv == nil then
		return;
	end

	local sieraCount =  math.floor((1 + (math.floor(itemLv/75) * math.floor(itemLv/75))* 5) * 0.5)
    
    --EVENT_1903_WEEKEND
    local isServer = false
    
    if IsServerSection(item) == 1 then
        isServer = true
    end
	if SCR_EVENT_1903_WEEKEND_CHECK('ITEMRANDOMRESET', isServer) == 'YES' then
	    sieraCount = math.floor(sieraCount/2)
	end
    	
	return sieraCount
end

function SCR_NEWCLE_MATERIAL(item)

 	local itemGradeRatio = {75, 50, 35, 20, 20};
    local itemMaxRatio = {1.4, 1.5, 1.8, 2, 2};

	local itemLv = TryGetProp(item, "UseLv")
	if itemLv == nil then
		return;
	end
 	itemGrade = TryGetProp(item, 'ItemGrade')
	if itemGrade == nil then
		return;
	end
	
	local newcleCount = math.floor(math.floor(1 + (itemLv/itemGradeRatio[itemGrade])) * itemMaxRatio[itemGrade] * 20)
    
	--EVENT_1903_WEEKEND
	local isServer = false

	if IsServerSection(item) == 1 then
		isServer = true
	end
	if SCR_EVENT_1903_WEEKEND_CHECK('ITEMRANDOMRESET', isServer) == 'YES' then
	    newcleCount = math.floor(newcleCount/2)
	end
	
	return newcleCount
end

function IS_EXIST_RANDOM_OPTION(item)
	local maxRandomOptionCnt = 6;
	for i = 1, maxRandomOptionCnt do
		if item['RandomOption_'..i] ~= 'None' then
			return true;
		end
	end
	return false;
end

function IS_ENCHANT_JEWELL_ITEM(item)
	if TryGetProp(item, 'StringArg', 'None') == 'EnchantJewell' then
		return true;
	end
	return false;
end

function CHECK_JEWELL_COMMON_CONSTRAINT(item)
	if item == nil then
		return false;
	end
	
    local classType = TryGetProp(item, 'ClassType');
	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon', 'Musket', 'Shirt', 'Pants', 'Boots', 'Gloves', 'Shield'};
	for i = 1, #enableClassType do
		if enableClassType[i] == classType then
			return true;
		end
	end
	return false;
end

function IS_ENABLE_EXTRACT_JEWELL(item)
    if item == nil then
		return false;
	end
	
	local classType = TryGetProp(item, 'ClassType');
	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon', 'Musket', 'Shirt', 'Pants', 'Boots', 'Gloves', 'Shield', 'Neck','Ring'};
	for i = 1, #enableClassType do
		if enableClassType[i] == classType then
			return true;
		end
	end
	return false;
end

function IS_ENABLE_APPLY_JEWELL(jewell, targetItem)
	if jewell == nil or targetItem == nil then		
		return false, 'Type'; -- return false with clmsg
	end

	if CHECK_JEWELL_COMMON_CONSTRAINT(targetItem) == false then		
		return false, 'Type';
	end

	if jewell.Level < targetItem.UseLv then
		return false, 'LEVEL';
	end

	if targetItem.ItemLifeTimeOver > 0 or tonumber(targetItem.LifeTime) > 0 then
		return false, 'LimitTime';
	end

	if IS_NEED_APPRAISED_ITEM(targetItem) == true or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true then 
		return false, 'NeedRandomOption';
	end
	
	local woodCarvingCheck = TryGetProp(targetItem , 'StringArg')
	
	if woodCarvingCheck == 'WoodCarving' then
	    return false, 'WoodCarving';
	end

	return true;
end

function CHECK_NEED_RANDOM_OPTION(item)
	if item == nil then
		return false;
	end

	if TryGetProp(item, 'NeedRandomOption', 0) == 0 then
		return false;
	end

	for i = 1, 6 do
		if item['RandomOption_'..i] ~= 'None' then
			return false;
		end

		if item['RandomOptionGroup_'..i] ~= 'None' then
			return false;
		end

		if item['RandomOptionValue_'..i] ~= 0 then
			return false;
		end
	end

	return true;
end

function IS_HAVE_RANDOM_OPTION(item)
	if item == nil then
		return false;
	end

	for i = 1, 6 do
		if TryGetProp(item, 'RandomOption_'..i, 'None') ~= 'None' then			
			return true;
		end

		if TryGetProp(item, 'RandomOptionGroup_'..i, 'None') ~= 'None' then			
			return true;
		end

		if TryGetProp(item, 'RandomOptionValue_'..i, 0) ~= 0 then
			return true;
		end
	end

	return false;
end