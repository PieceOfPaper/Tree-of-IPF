function GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(targetItem)	
	if targetItem.StringArg == 'WoodCarving' then
		return 0;
	end

	local needItem = 6 - targetItem.ItemGrade	
	return needItem;
end

function GET_BRIQUETTING_PRICE(targetItem, lookItem, lookMaterialItemList)
	if IS_BRIQUETTING_DUMMY_ITEM(lookItem) == true then		
		return 0;
	end

	for i = 1, #lookMaterialItemList do
		if IS_BRIQUETTING_DUMMY_ITEM(lookMaterialItemList[i]) == true then			
			return 0;
		end
	end
	
	local lv = TryGetProp(targetItem , 'UseLv')
	if lv == nil then
	    return;
	end
	
	local grade = TryGetProp(targetItem, 'ItemGrade')
	if grade == nil then
	    return;
	end
	
	local price = (lv * 100) +  SyncFloor((lv^1.6*grade) * (lv/(6-grade)))
	return price;
end

function IS_BRIQUETTING_DUMMY_ITEM(item)
	if item.StringArg == 'WoodCarving_Core' then -- 소재 무기 대신임
	    return true;
	end
	
	return false;
end

function IS_VALID_LOOK_MATERIAL_ITEM(lookItem, lookMatItemList)
	if lookMatItemList == nil then
		return false;
	end
	local containDummyItem = false;
	local containCoreItem = false;
	if #lookMatItemList == 0 then
		if lookItem.StringArg ~= 'WoodCarving' then
			return false;
		end
		containDummyItem = true;
	end

	for i = 1, #lookMatItemList do
		local lookMatItem = lookMatItemList[i];
		if lookItem.ClassName ~= lookMatItem.ClassName then
			if IS_BRIQUETTING_DUMMY_ITEM(lookMatItem) == false then
				return false;
			end
			
			containCoreItem = true;
		end
	end
	
	return true, containDummyItem, containCoreItem;
end

function IS_VALID_BRIQUETTING_TARGET_ITEM(targetItem)
	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Musket', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon'};
	local targetItemClassType = TryGetProp(targetItem, 'ClassType', 'None');
	if targetItemClassType ~= 'None' then
		for i = 1, #enableClassType do
			if enableClassType[i] == targetItemClassType then
				return true;
			end
		end	
	end
	return false;
end

function IS_VALID_LOOK_ITEM(lookItem)
	if lookItem.UseLv >= 360 and lookItem.ItemGrade >= 5 then
		return false;
	end
	return true;
end