
ADVENTURE_BOOK_ITEM_CONTENT = {};

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_LIST_ALL()
	local historyList = ADVENTURE_BOOK_ITEM_CONTENT.HISTORY_ITEM_LIST()
	local notFoundList = ADVENTURE_BOOK_ITEM_CONTENT.ITEM_LIST_EXCEPT_HISTORY()
	local newRet = {};
	
	for i=1, #historyList do
		newRet[#newRet+1] = historyList[i]
	end
	for i=1, #notFoundList do
		newRet[#newRet+1] = notFoundList[i]
	end

	return newRet;
end

function ADVENTURE_BOOK_ITEM_CONTENT.IS_PREVIEW_ITEM(cls)
	if cls == nil then
		return 0;
	end
	
	if TryGetProp(cls, "Journal") ~= "TRUE" then
		return 0;
	end

	if TryGetProp(cls, "ItemType") == nil or TryGetProp(cls, "GroupName") == nil then
		return 0;
	end
	
	if cls.ItemType == "Equip" then
		return 1;
	end
	
	if cls.GroupName == "Gem" or cls.GroupName == "Card" then
		return 1;
	end

	return 0;
end

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_LIST_EXCEPT_HISTORY()
	local list, cnt = GetClassList("Item");

	local retTable = {};
	for i=0, cnt-1 do
		local cls = GetClassByIndexFromList(list, i);
		local clsID = TryGetProp(cls, "ClassID");
		if ADVENTURE_BOOK_ITEM_CONTENT.EXIST_IN_HISTORY(clsID) == 0 then
			if ADVENTURE_BOOK_ITEM_CONTENT.IS_PREVIEW_ITEM(cls) == 1 then
			    retTable[#retTable+1] = clsID;
			end
		end
	end

	return retTable;
end

function ADVENTURE_BOOK_ITEM_CONTENT.HISTORY_ITEM_LIST()
	local itemlist_c = GetAdventureBookClassIDList(ABT_ITEM_COUNTABLE)
	local itemlist_p = GetAdventureBookClassIDList(ABT_ITEM_PERMANENT)

	local retTable = {};
	local hash_table = {};
	for i = 1, #itemlist_c do
	    local cls = GetClassByNumProp("Item", "ClassID", itemlist_c[i]);
	    if cls ~= nil and (cls.Journal == "TRUE" or cls.Journal == "true") then
		    retTable[#retTable + 1] = itemlist_c[i]
		end
	end
	for i = 1, #itemlist_p do
		local cls = GetClassByNumProp("Item", "ClassID", itemlist_p[i]);
	    if cls ~= nil and (cls.Journal == "TRUE" or cls.Journal == "true") then
    		local exist_c = GetAdventureBookInstByClassID(ABT_ITEM_COUNTABLE, itemlist_p[i])
    		if exist_c == nil or exist_c == 0 then
    			retTable[#retTable + 1] = itemlist_p[i]
    		end
		end
	end

	table.sort(retTable);
	return retTable;
end

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_HISTORY_COUNT(itemClsID)
	local data = GetAdventureBookInstByClassID(ABT_ITEM_COUNTABLE, itemClsID)
	if data == nil then
		return 0, 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_ITEM_COUNTABLE_DATA");
	return data.obtainCount, data.consumeCount;
end

function ADVENTURE_BOOK_ITEM_CONTENT.EXIST_IN_HISTORY(itemClsID)
	local data_p = GetAdventureBookInstByClassID(ABT_ITEM_PERMANENT, itemClsID)
	local data_c = GetAdventureBookInstByClassID(ABT_ITEM_COUNTABLE, itemClsID)
	if data_p == nil and data_c == nil then
		return 0;
	else
		return 1;
	end
end

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_PROP_LIST(itemClsID)
	local list = GetPropListFromAdventureBookItemData(itemClsID);
	if list == nil then
		return;
	end

	local retTable = {};
	for i=1, #list do
		local data = tolua.cast(list[i], "ADVENTURE_BOOK_PROPERTY_DATA");
		retTable[#retTable+1] = {}
		retTable[#retTable]["prop_name"] = data:GetPropName();
		retTable[#retTable]["prop_value"] = data.propValue;
	end
	return retTable;
end

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_PLACE_LIST(itemClsID)
	local list = GetMonListFromAdventureBookItemData(itemClsID);
	if list == nil then
		return;
	end

	local retTable = {};
	for i=1, #list do
		local monCls = GetClassByType("Monster", list[i])
		if monCls ~= nil then
			retTable[#retTable+1] = {}
			retTable[#retTable]["monster_id"] = list[i]
			retTable[#retTable]["icon"] = TryGetProp(monCls, "Icon")
		end
	end
	return retTable;
end

function ADVENTURE_BOOK_ITEM_CONTENT.GET_OUTER_ICON(itemCls)
	local tooltipImageName = TryGetProp(itemCls, "TooltipImage");
	local gender = 0;
	if GetMyPCObject() ~= nil then
		local pc = GetMyPCObject();
		gender = pc.Gender;
	else
		gender = barrack.GetSelectedCharacterGender();
	end

	local retName = tooltipImageName;
	local tempiconname = string.sub(tooltipImageName,string.len(tooltipImageName)-1);
	if tempiconname ~= "_m" and tempiconname ~= "_f" then
		if gender == 1 then
			retName = tooltipImageName .. "_m"
		else
			retName = tooltipImageName .. "_f"
		end
	end
	return retName
end

function ADVENTURE_BOOK_ITEM_CONTENT.ITEM_INFO(itemClsID)
	local optainCount, consumeCount = ADVENTURE_BOOK_ITEM_CONTENT.ITEM_HISTORY_COUNT(itemClsID)

	local itemCls = GetClassByType("Item", itemClsID);
	local needAppraisal = TryGetProp(itemCls, "NeedAppraisal");
	local needRandomOption = TryGetProp(itemCls, "NeedRandomOption")
	local grade = TryGetProp(itemCls, "ItemGrade");
	local retTable = {}
	retTable['class_id'] = itemClsID
	retTable['name'] = TryGetProp(itemCls, "Name");
	retTable['desc'] = TryGetProp(itemCls, "Desc");
	retTable['type'] = TryGetProp(itemCls, "ItemType");
	retTable['group'] = TryGetProp(itemCls, "GroupName");
	retTable['icon'] = TryGetProp(itemCls, "TooltipImage");
	if TryGetProp(itemCls, "ClassType") == 'Outer' then
		retTable['icon'] = ADVENTURE_BOOK_ITEM_CONTENT.GET_OUTER_ICON(itemCls)
	end
	retTable['card_icon'] = TryGetProp(itemCls, "TooltipImage");
	retTable['count'] = optainCount
	retTable['consumed_count'] = consumeCount
	retTable['is_found'] = ADVENTURE_BOOK_ITEM_CONTENT.EXIST_IN_HISTORY(itemClsID)	
	if retTable['type'] == 'Equip' then
		retTable['bg'] = GET_ITEM_BG_PICTURE_BY_GRADE(grade, needAppraisal, needRandomOption)
	end

	retTable['trade_shop'] = 0
	retTable['trade_market'] = 0
	retTable['trade_team'] = 0
	retTable['trade_user'] = 0

	if TryGetProp(itemCls, "TeamTrade") == "YES" then
		retTable['trade_shop'] = 1
	end
	if TryGetProp(itemCls, "MarketTrade") == "YES" then
		retTable['trade_market'] = 1
	end
	if TryGetProp(itemCls, "TeamTrade") == "YES" then
		retTable['trade_team'] = 1
	end
	if TryGetProp(itemCls, "UserTrade") == "YES" then
		retTable['trade_user'] = 1
	end

	local propTable = ADVENTURE_BOOK_ITEM_CONTENT.ITEM_PROP_LIST(itemClsID);
	for i=1, #propTable do
		local prop = propTable[i];
		local propName = prop['prop_name']
		local propValue = prop['prop_value']
		retTable[propName] = propValue;
	end

	if retTable['group'] == 'Card' then
		if retTable['CardLevel'] == nil then
			retTable['CardLevel'] = 1
		end
	elseif retTable['group'] == 'Gem' then
		if retTable['GemLevel'] == nil then
			retTable['GemLevel'] = 1
		end
	end

	retTable['grade'] = ''
	local rank = 0;
	if retTable['type'] == 'Equip' then
		rank=retTable['Transcend'];
	elseif retTable['group'] == 'Card' then
		rank=retTable['CardLevel'];
	elseif retTable['group'] == 'Gem' then
		rank=retTable['GemLevel'];
	end
	if rank ~= nil and rank > 0 then
		for i=1, tonumber(rank) do
		 	retTable['grade'] = retTable['grade']..'{img star_mark 20 20}'
		 end
	end
	return retTable;
end

function ADVENTURE_BOOK_ITEM_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Item', 'Name', a, b)
end

function ADVENTURE_BOOK_ITEM_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Item', 'Name', b, a)
end

function ADVENTURE_BOOK_ITEM_CONTENT.FILTER_LIST(list, sortOption, categoryOption, subCategoryOption, searchText)
	if categoryOption == 1 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Weapon")
	elseif categoryOption == 2 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Armor")
	elseif categoryOption == 3 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "SubWeapon")
	elseif categoryOption == 4 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Drug")
	elseif categoryOption == 5 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Material")
	elseif categoryOption == 6 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Gem")
	elseif categoryOption == 7 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "GroupName", "Card")
	end

	if categoryOption == 1 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Sword")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "THSword")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Staff")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "THStaff")
		elseif subCategoryOption == 5 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "THBow")
		elseif subCategoryOption == 6 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Bow")
		elseif subCategoryOption == 7 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Mace")
		elseif subCategoryOption == 8 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "THMace")
		elseif subCategoryOption == 9 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Spear")
		elseif subCategoryOption == 10 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "THSpear")
		elseif subCategoryOption == 11 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Rapier")
		elseif subCategoryOption == 12 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Musket")
		end
	elseif categoryOption == 2 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Shirt")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Pants")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Boots")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Gloves")
		elseif subCategoryOption == 5 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Neck")
		elseif subCategoryOption == 6 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Ring")
		elseif subCategoryOption == 7 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Shield")
		elseif subCategoryOption == 8 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Outer")
		elseif subCategoryOption == 9 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Hat")
		end
	elseif categoryOption == 3 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Dagger")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Pistol")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Cannon")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Item", "ClassType", "Artefact")
		end
	end

	list = ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FROM_LIST(list, "Item", "Name", searchText)

	if sortOption == 0 then
        table.sort(list, ADVENTURE_BOOK_ITEM_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_ITEM_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	end
	return list;
end
