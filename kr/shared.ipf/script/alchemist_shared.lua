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
	
	local cehckLookitem = TryGetProp(lookItem, 'StringArg')
	if cehckLookitem == nil then
	    return;
	end
	
	if cehckLookitem == 'WoodCarving' then
	    price = 0;
	end
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

			if IS_NEED_APPRAISED_ITEM(lookMatItem) == true or IS_NEED_RANDOM_OPTION_ITEM(lookMatItem) == true then
				return false;
			end

			containCoreItem = true;
		end
	end
	
	return true, containDummyItem, containCoreItem;
end

function IS_VALID_BRIQUETTING_TARGET_ITEM(targetItem)	
	if targetItem == nil then
		return false;
	end

	if IS_NEED_APPRAISED_ITEM(targetItem) == true or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true then
		return false;
	end

	if targetItem.LifeTime > 0 then
		return false;
	end

	if targetItem.StringArg == 'WoodCarving' then
		return false;
	end
	
	if TryGetProp(targetItem, 'BriquetingAble') ~= 'Yes' then
        return false;
    end

	local enableClassType = {'Sword', 'THSword', 'Staff', 'THBow', 'Bow', 'Mace', 'THMace', 'Musket', 'Spear', 'THSpear', 'Dagger', 'THStaff', 'Pistol', 'Rapier', 'Cannon', 'Shield'};
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
	if lookItem == nil then
		return false;
	end

	if IS_NEED_APPRAISED_ITEM(lookItem) == true or IS_NEED_RANDOM_OPTION_ITEM(lookItem) == true then
		return false;
	end

	if lookItem.LifeTime > 0 then
		return false;
	end

    if TryGetProp(lookItem, 'BriquettingIndex') ~= nil then
    	if (lookItem.UseLv >= 360 and lookItem.ItemGrade >= 5) or lookItem.BriquettingIndex ~= 0 then
    		return false;
    	end
    end
    
    if TryGetProp(lookItem, 'BriquetingAble') ~= 'Yes' then
        return false;
    end
    
	return true;
end

function IS_VALID_ITEM_TO_REGISTER(itemID)	
	local itemCls = GetClassByType('Item', itemID);
	if itemCls == nil then
		return nil;
	end	
	
	if TryGetProp(itemCls, 'LifeTime', 0) > 0 then
		return nil;
	end
	return itemCls;
end

function IS_VALID_ALCHEMY_WORKSHOP_COMBUSTION(itemID)
	local itemCls = IS_VALID_ITEM_TO_REGISTER(itemID);
	if itemCls == nil then
		return false;
	end

	if TryGetProp(itemCls, 'GroupName') == 'Premium' then
		return false;
	end

	if IS_EQUIP(itemCls) == true then
		return false;
	end

	if TryGetProp(itemCls, 'Destroyable') == 'YES' then
		return true;
	end
	return false;
end

function IS_VALID_ALCHEMY_WORKSHOP_SPRINKLE_HP(itemID)
	local itemCls = IS_VALID_ITEM_TO_REGISTER(itemID);
	if itemCls == nil then
		return false;
	end
	local MAX_ALCHE_POTION_LV = 15;
	for i = 1, MAX_ALCHE_POTION_LV do
		local alchePotionName = 'Drug_Alche_HP';
		if i > 1 then
			alchePotionName = alchePotionName..tostring(i);
		end
		if itemCls.ClassName == alchePotionName then
			return true;
		end
	end
	return false;
end

function IS_VALID_ALCHEMY_WORKSHOP_SPRINKLE_SP(itemID)
	local itemCls = IS_VALID_ITEM_TO_REGISTER(itemID);
	if itemCls == nil then
		return false;
	end
	local MAX_ALCHE_POTION_LV = 15;
	for i = 1, MAX_ALCHE_POTION_LV do
		local alchePotionName = 'Drug_Alche_SP';
		if i > 1 then
			alchePotionName = alchePotionName..tostring(i);
		end
		if itemCls.ClassName == alchePotionName then
			return true;
		end
	end
	return false;
end

function SCR_GET_SPEND_ITEM_Alchemist_Combustion(pc)	
	local etc = nil;
	if IsServerObj(pc) == 1 then
		etc = GetETCObject(pc);
	else
		etc = GetMyEtcObject();
	end
	if etc == nil then
		return 0;
	end
	local savedID = etc.AlcheWorkshopItemID_Combustion;	
	return GetClassByType('Item', savedID), savedID;
end

function SCR_GET_SPEND_ITEM_Alchemist_SprinkleHPPotion(pc)
	local etc = nil;
	if IsServerObj(pc) == 1 then
		etc = GetETCObject(pc);
	else
		etc = GetMyEtcObject();
	end
	if etc == nil then
		return 0;
	end
	local savedID = etc.AlcheWorkshopItemID_SprinkleHP;
	return GetClassByType('Item', savedID), savedID;
end

function SCR_GET_SPEND_ITEM_Alchemist_SprinkleSPPotion(pc)
	local etc = nil;
	if IsServerObj(pc) == 1 then
		etc = GetETCObject(pc);
	else
		etc = GetMyEtcObject();
	end
	if etc == nil then
		return 0;
	end
	local savedID = etc.AlcheWorkshopItemID_SprinkleSP;
	return GetClassByType('Item', savedID), savedID;
end

function IS_ENABLE_GIVE_HIDDEN_PROP_ITEM(item)
	local star = TryGetProp(item, 'ItemStar', -1);
	if star < 0 then
		return false;		
	end
	
	return true;
end