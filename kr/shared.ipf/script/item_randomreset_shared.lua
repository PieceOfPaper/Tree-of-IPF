function SCR_SIERA_MATERIAL(item)

	local itemLv = TryGetProp(item, "UseLv")
	if itemLv == nil then
		return;
	end

	local sieraCount =  math.floor((1 + (math.floor(itemLv/75) * math.floor(itemLv/75))* 5) * 0.5)

	local ItemGrade = TryGetProp(item, "ItemGrade");
	if ItemGrade == 3 then
		if 430 <= itemLv then
			sieraCount = math.floor(sieraCount * 0.25);
		else
			return 0;
		end
	end
    
    --EVENT_1903_WEEKEND
    local isServer = false
    
    if IsServerSection(item) == 1 then
        isServer = true
    end

    --burning_event
    local pc = GetItemOwner(item)
    if IsBuffApplied(pc, "Event_Reappraisal_Discount_50") == "YES" then
        sieraCount = math.floor(sieraCount/2)
    end

--	if SCR_EVENT_1903_WEEKEND_CHECK('ITEMRANDOMRESET', isServer) == 'YES' then
--	    sieraCount = math.floor(sieraCount/2)
--	end
    	
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
	
	local ItemGrade = TryGetProp(item, "ItemGrade");
	if ItemGrade == 3 then
		if 430 <= itemLv then
			newcleCount = math.floor(newcleCount * 1.25);
		end
	end

	--EVENT_1903_WEEKEND
	local isServer = false

	if IsServerSection(item) == 1 then
		isServer = true
	end

    --burning_event
    local pc = GetItemOwner(item)
    if IsBuffApplied(pc, "Event_Reappraisal_Discount_50") == "YES" then
        newcleCount = math.floor(newcleCount/2)
    end

--	if SCR_EVENT_1903_WEEKEND_CHECK('ITEMRANDOMRESET', isServer) == 'YES' then
--	    newcleCount = math.floor(newcleCount/2)
--	end
	
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
	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon', 'Musket', 'Shirt', 'Pants', 'Boots', 'Gloves', 'Shield', 'Trinket'};
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
	
	-- 440레벨 이상 레전드 장비는 쥬얼 지급 안함
	if TryGetProp(item, "UseLv", 1) >= 440 and TryGetProp(item, "ItemGrade", 1) >= 5 then
	    return false;
	end
	
	local classType = TryGetProp(item, 'ClassType');
	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon', 'Musket', 'Shirt', 'Pants', 'Boots', 'Gloves', 'Shield', 'Neck','Ring', 'Trinket'};
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

	local number_arg1 = TryGetProp(jewell, 'NumberArg1', 0)
	
	if TryGetProp(jewell, 'Level', 1) < targetItem.UseLv and number_arg1 < targetItem.UseLv then
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
	
	local itemStarCheck = TryGetProp(targetItem , 'ItemStar')
	
	if itemStarCheck < 0 then
	    return false, 'Type';
	end

	return true;
end

-- 아이템 툴팁 인챈트 불가 표시
function IS_ENABLE_APPLY_JEWELL_TOOLTIPTEXT(targetItem)

	local itemStarCheck = TryGetProp(targetItem , 'ItemStar')
	if itemStarCheck < 0 then
	    return false, 'Type';
	end
	
	if IS_NEED_APPRAISED_ITEM(targetItem) == true or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true then 
		return false, 'NeedRandomOption';
	end
	
	local woodCarvingCheck = TryGetProp(targetItem , 'StringArg')
	if woodCarvingCheck == 'WoodCarving' then
	    return false, 'WoodCarving';
	end
	
	if targetItem.ItemLifeTimeOver > 0 or tonumber(targetItem.LifeTime) > 0 then
		return false, 'LimitTime';
	end
		
    local classType = TryGetProp(targetItem, 'ClassType');
    local classList = {'Seal', 'Ark','Ring' , 'Neck'}
    for i = 1, #classList do
        if classList[i] == classType then
	        return false, 'Type';
	    end
	end
	
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

function GET_RANDOM_OPTION_COUNT(itemObj)
	if itemObj == nil then
		return 0;
	end

	local optionCnt = 0;
    for i = 1, MAX_RANDOM_OPTION_COUNT do
        local itemOptionGroup = TryGetProp(itemObj, 'RandomOptionGroup_'..i)
        if itemOptionGroup ~= nil and itemOptionGroup ~= 'None' then
            optionCnt = optionCnt + 1;
        end
	end

	return optionCnt;
end

revertrandomitemlist = {'itemrandomreset', 'itemrevertrandom', 'itemunrevertrandom', 'itemsandrarevertrandom', 'itemsandraoneline_revert_random', 'itemsandra_4line_revert_random', 'itemsandra_6line_revert_random'};

-- 산드라의 완벽한 돋보기 사용 가능 아이템 확인
function IS_ENABLE_4LINE_REVERT_RANDOM_ITEM(itemObj)
	local icor = TryGetProp(itemObj, 'GroupName', 'None')
    local Lv = TryGetProp(itemObj, 'UseLv', 1)
    
	if icor == 'Icor' then
		local item_name = TryGetProp(itemObj, 'InheritanceRandomItemName', 'None')
		if item_name ~= 'None' then
			local cls = GetClass('Item', item_name)			
			if cls == nil then 
				return false, 'None'
			end
            
            Lv = TryGetProp(cls, "UseLv", 1)
		    if Lv < 430 then
				return false, 'Level';
			end
			
			if 4 < GET_RANDOM_OPTION_COUNT(itemObj) then
				return false, 'Count';
			end	
		else
			return false, 'NoRandom'
		end		
	else
		if Lv < 430 then
			return false, 'Level';
		end
	
		if 4 < GET_RANDOM_OPTION_COUNT(itemObj) then
			return false, 'Count';
		end
	end

	return true;
end

-- 산드라의 궁극의 돋보기 사용 가능 아이템 확인
function IS_ENABLE_6LINE_REVERT_RANDOM_ITEM(itemObj)
	local icor = TryGetProp(itemObj, 'GroupName', 'None')
    local Lv = TryGetProp(itemObj, 'UseLv', 1)

	if icor == 'Icor' then
		local item_name = TryGetProp(itemObj, 'InheritanceRandomItemName', 'None')
		if item_name ~= 'None' then
			local cls = GetClass('Item', item_name)
			if cls == nil then 
				return false, 'None'
			end
            
            Lv = TryGetProp(cls, "UseLv", 1)
			if Lv < 430 then				
				return false, 'Level';
			end
			
			if 6 < GET_RANDOM_OPTION_COUNT(itemObj) then
				return false, 'Count';
			end	
		else
			return false, 'NoRandom'
		end		
	else		
		if Lv < 430 then
			return false, 'Level';
		end
		
		if 6 < GET_RANDOM_OPTION_COUNT(itemObj) then
			return false, 'Count';
		end
	end
	
	return true;
end