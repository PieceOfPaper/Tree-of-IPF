
ADVENTURE_BOOK_CRAFT_CONTENT = {};

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_LIST_ALL()
	local historyList = ADVENTURE_BOOK_CRAFT_CONTENT.HISTORY_CRAFT_LIST()
	local notFoundList = ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_LIST_EXCEPT_HISTORY()
	local newRet = {};
	
	for i=1, #historyList do
		newRet[#newRet+1] = historyList[i]
	end
	for i=1, #notFoundList do
		newRet[#newRet+1] = notFoundList[i]
	end

	return newRet;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.IS_PREVIEW_CRAFT(recipeCls, checkRecipeJournal)
	if recipeCls == nil then 
		return 0;
	end 

	if checkRecipeJournal == true then
		if TryGetProp(recipeCls, "Journal") ~= "TRUE" then
			return 0;
		end
	end

	local targetItemClsName = TryGetProp(recipeCls, "TargetItem")

	local targetItemCls = GetClass("Item", targetItemClsName)
	if targetItemCls == nil then
		return 0;
	end
	
	local targetItemClsID = TryGetProp(targetItemCls, "ClassID")
	if targetItemClsID == nil then
		return 0;
	end

	if TryGetProp(targetItemCls, "Journal") ~= "TRUE" then
		return 0;
	end

	return 1;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_LIST_EXCEPT_HISTORY()
	local targetList = {}
	local recipeClsList, recipeClsCnt = GetClassList("Recipe");
	local recipeSkillClsList, recipeSkillClsCnt = GetClassList("Recipe_ItemCraft");
 	for i = 0, recipeClsCnt - 1 do 
		local recipeCls = GetClassByIndexFromList(recipeClsList, i);
		if ADVENTURE_BOOK_CRAFT_CONTENT.IS_PREVIEW_CRAFT(recipeCls, true) == 1 then
			local targetItemClsName = TryGetProp(recipeCls, "TargetItem")
			local targetItemCls = GetClass("Item", targetItemClsName)
			local targetItemClsID = TryGetProp(targetItemCls, "ClassID")
			if targetItemClsID ~= nil then
				if ADVENTURE_BOOK_CRAFT_CONTENT.EXIST_IN_HISTORY(targetItemClsID) == 0 then
					targetList[#targetList+1] = {}
					targetList[#targetList]['target'] = targetItemClsName
					targetList[#targetList]['recipe'] = TryGetProp(recipeCls, "ClassName")
				end
			end
		end
	end
	
	for j = 0, recipeSkillClsCnt - 1 do 
		local recipeCls = GetClassByIndexFromList(recipeSkillClsList, j);
		if ADVENTURE_BOOK_CRAFT_CONTENT.IS_PREVIEW_CRAFT(recipeCls, false) == 1 then
			local targetItemClsName = TryGetProp(recipeCls, "TargetItem")
			local targetItemCls = GetClass("Item", targetItemClsName)
			local targetItemClsID = TryGetProp(targetItemCls, "ClassID")
			if targetItemClsID ~= nil then
				if ADVENTURE_BOOK_CRAFT_CONTENT.EXIST_IN_HISTORY(targetItemClsID) == 0 then
					targetList[#targetList+1] = {}
					targetList[#targetList]['target'] = targetItemClsName
					targetList[#targetList]['recipe'] = TryGetProp(recipeCls, "ClassName")
				end
			end
		end
	end
	
	return targetList	
end

function ADVENTURE_BOOK_CRAFT_CONTENT.HISTORY_CRAFT_LIST()
	local targetItemClsIDList = GetAdventureBookClassIDList(ABT_CRAFT)
	local recipeClsList, recipeClsCnt = GetClassList("Recipe");
	local recipeSkillClsList, recipeSkillClsCnt = GetClassList("Recipe_ItemCraft");
	local recipeRetList = {}

	for i=1, #targetItemClsIDList do
		local targetItemClsID = targetItemClsIDList[i]
		local targetItemCls = GetClassByType("Item", targetItemClsID)
		local targetItemClsName = TryGetProp(targetItemCls, "ClassName")
		if targetItemClsName ~= nil then	
			local exist = false;	
			for j = 0, recipeClsCnt - 1 do 
				local recipeCls = GetClassByIndexFromList(recipeClsList, j);
				if ADVENTURE_BOOK_CRAFT_CONTENT.IS_RECIPE_TARGET(TryGetProp(recipeCls, "ClassName"), targetItemClsName) then
					recipeRetList[#recipeRetList+1]={}
					recipeRetList[#recipeRetList]['target'] = targetItemClsName
					recipeRetList[#recipeRetList]['recipe'] = TryGetProp(recipeCls, "ClassName")
					exist = true;
				end
			end
			if exist == false then
				for j = 0, recipeSkillClsCnt - 1 do 
					local recipeCls = GetClassByIndexFromList(recipeSkillClsList, j);
					if ADVENTURE_BOOK_CRAFT_CONTENT.IS_RECIPE_TARGET(TryGetProp(recipeCls, "ClassName"), targetItemClsName) then
						recipeRetList[#recipeRetList+1]={}
						recipeRetList[#recipeRetList]['target'] = targetItemClsName
						recipeRetList[#recipeRetList]['recipe'] = TryGetProp(recipeCls, "ClassName")
						exist = true;
					end
				end
			end
		end
	end
	return recipeRetList;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_COUNT(targetItemClsID)
	local data = GetAdventureBookInstByClassID(ABT_CRAFT, targetItemClsID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_COUNTABLE_DATA");
	return data.count;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.EXIST_IN_HISTORY(targetItemClsID)
	local data = GetAdventureBookInstByClassID(ABT_CRAFT, targetItemClsID)
	if data == nil then
		return 0;
	else
		return 1;
	end
end

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_TARGET_INFO(targetItemClsName)
	local targetItemCls = GetClass("Item", targetItemClsName);
	if targetItemCls == nil then
		return;
	end

	local retTable = {}
	local needAppraisal = TryGetProp(targetItemCls, "NeedAppraisal");
	local needRandomOption = TryGetProp(targetItemCls, "NeedRandomOption");
	local grade = TryGetProp(targetItemCls, "ItemGrade");

	retTable['class_id'] = TryGetProp(targetItemCls, "ClassID")
	retTable['class_name'] = TryGetProp(targetItemCls, "ClassName")
	retTable['name'] = TryGetProp(targetItemCls, "Name");
	retTable['icon'] = TryGetProp(targetItemCls, "TooltipImage");
	retTable['bg'] = GET_ITEM_BG_PICTURE_BY_GRADE(grade, needAppraisal, needRandomOption)

	retTable['card_icon'] = TryGetProp(targetItemCls, "TooltipImage");
	retTable['desc'] = TryGetProp(targetItemCls, "Desc");
	retTable['type'] = TryGetProp(targetItemCls, "ItemType");
	retTable['group'] = TryGetProp(targetItemCls, "GroupName");

	retTable['count'] = optainCount
	retTable['consumed_count'] = consumeCount
	retTable['is_found'] = ADVENTURE_BOOK_CRAFT_CONTENT.EXIST_IN_HISTORY(retTable['class_id'])
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

	return retTable;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.IS_RECIPE_TARGET(recipeClsName, targetItemClsName)
	local recipeCls = GetClass("Recipe", recipeClsName)
	if recipeCls == nil then
		recipeCls = GetClass("Recipe_ItemCraft", recipeClsName)
	end
	if recipeCls == nil then
		return false;
	end

	local targetItemCls = GetClass("Item", targetItemClsName);
	if targetItemCls == nil then
		return false;
	end

 	local targetItemPropValue = TryGetProp(recipeCls, "TargetItem") 
	if targetItemPropValue == nil or string.find(targetItemClsName, targetItemPropValue) == nil then
		return false;
	end
	return true;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_RECIPE_INFO(recipeClsName, targetItemClsName) -- 이건 CRAFT_RECPIE_INFO 로 교체하고., CRAFT_TARGET_INFO 생성. 그거뺴노코, 레시피 정보.
	local recipeCls = GetClass("Recipe", recipeClsName)
	if recipeCls == nil then
		recipeCls = GetClass("Recipe_ItemCraft", recipeClsName)
	end

	local targetItemCls = GetClass("Item", targetItemClsName);
	if targetItemCls == nil then
		return;
	end

	if ADVENTURE_BOOK_CRAFT_CONTENT.IS_RECIPE_TARGET(recipeClsName, targetItemClsName) == false then
		return;
	end

	local retTable = {}
	local needAppraisal = TryGetProp(targetItemCls, "NeedAppraisal");
	local needRandomOption = TryGetProp(targetItemCls, "NeedRandomOption")
	local grade = TryGetProp(targetItemCls, "ItemGrade");

	retTable['recipe_class_id'] =  TryGetProp(recipeCls, "ClassID")
	retTable['recipe_class_name'] = recipeClsName

	retTable['class_id'] = TryGetProp(targetItemCls, "ClassID")
	retTable['class_name'] = TryGetProp(targetItemCls, "ClassName")
	retTable['name'] = TryGetProp(targetItemCls, "Name");
	retTable['icon'] = TryGetProp(targetItemCls, "TooltipImage");
	retTable['bg'] = GET_ITEM_BG_PICTURE_BY_GRADE(grade, needAppraisal, needRandomOption)

	retTable['card_icon'] = TryGetProp(targetItemCls, "TooltipImage");
	retTable['desc'] = TryGetProp(targetItemCls, "Desc");
	retTable['type'] = TryGetProp(targetItemCls, "ItemType");
	retTable['group'] = TryGetProp(targetItemCls, "GroupName");

	retTable['count'] = optainCount
	retTable['consumed_count'] = consumeCount
	retTable['is_found'] = ADVENTURE_BOOK_CRAFT_CONTENT.EXIST_IN_HISTORY(retTable['class_id'])
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

	return retTable;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.CRAFT_MATERIAL_INFO(recipeClsName)
	local recipeCls = GetClass("Recipe", recipeClsName);
	if  recipeCls == nil then
		recipeCls = GetClass("Recipe_ItemCraft", recipeClsName);
	end

	local retTable = {}
	for i=1, 5 do
		local materialClassName = TryGetProp(recipeCls, "Item_"..i.."_1")
		local materialCount = TryGetProp(recipeCls, "Item_"..i.."_1_Cnt")
		if materialClassName ~= nil and materialClassName ~= "None" then 
			retTable[#retTable+1] = {class_name=materialClassName, max_count=materialCount, count=0} 
		end
	end

	for i=1, #retTable do
		if retTable[i]['class_name'] ~= "None" then
			local itemCls = GetClass('Item', retTable[i]['class_name']);
			if itemCls ~= nil then
				local itemType = TryGetProp(itemCls, 'ClassID');
				retTable[i]['icon'] = TryGetProp(itemCls, 'Icon');

				local invItem = GET_PC_ITEM_BY_TYPE(itemType);
				if invItem ~= nil then
					retTable[i]['count'] = invItem.count
				end
			end
		end
	end
	return retTable;
end

function ADVENTURE_BOOK_CRAFT_CONTENT.SORT_CLASSNAME_BY_CLASSNAME_ASC(recipeA, recipeB)
	local recipeClsA = GetClass("Recipe", recipeA)
	local recipeClsB = GetClass("Recipe", recipeB)

	local byExistInRecipe = nil;
	if recipeClsA == nil and recipeClsB ~= nil then
		byExistInRecipe = false;
	end

	if recipeClsA ~= nil and recipeClsB == nil then
		byExistInRecipe = true;
	end

	if recipeClsA == nil then
		recipeClsA = GetClass("Recipe_ItemCraft", recipeA)
	end
	if recipeClsB == nil then
		recipeClsB = GetClass("Recipe_ItemCraft", recipeB)
	end

	local targetItemClsNameA = TryGetProp(recipeClsA, "TargetItem")
	local targetItemClsNameB = TryGetProp(recipeClsB, "TargetItem")

	local targetItemClsA = GetClass("Item", targetItemClsNameA)
	local targetItemClsB = GetClass("Item", targetItemClsNameB)

	local targetItemClsIDA = TryGetProp(targetItemClsA, "ClassID")
	local targetItemClsIDB = TryGetProp(targetItemClsB, "ClassID")
	
	local exist_func = ADVENTURE_BOOK_CRAFT_CONTENT['EXIST_IN_HISTORY']
	if exist_func(targetItemClsIDA) == 1 and exist_func(targetItemClsIDB) == 0 then
		return true;
	elseif  exist_func(targetItemClsIDA) == 0 and exist_func(targetItemClsIDB) == 1 then
		return false;
	end

	if byExistInRecipe ~= nil then
		return byExistInRecipe
	end

	return targetItemClsIDA < targetItemClsIDB
end

function ADVENTURE_BOOK_CRAFT_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	if a == nil or a['target'] == nil then
		return true;
	end
	if b == nil or b['target'] == nil then
		return false;
	end

	local targetItemClsA = GetClass("Item", a['target'])
	local targetItemClsB = GetClass("Item", b['target'])

	local targetItemClsIDA = TryGetProp(targetItemClsA, "ClassID")
	local targetItemClsIDB = TryGetProp(targetItemClsB, "ClassID")
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Item', 'Name', targetItemClsIDA, targetItemClsIDB)
end

function ADVENTURE_BOOK_CRAFT_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_CRAFT_CONTENT.SORT_NAME_BY_CLASSID_ASC(b, a)
end

function ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_TARGET_ITEM_FUNC(craftPair, propName, targetPropValue)
	local targetItemCls = GetClass("Item", craftPair['target'])

	local prop = TryGetProp(targetItemCls, propName);
	if prop == targetPropValue then
		return true
	else
		return false
	end
end

function ADVENTURE_BOOK_CRAFT_CONTENT.SEARCH_PROP_BY_TARGET_ITEM_FUNC(craftPair, propName, searchText)
    if searchText == nil or searchText == '' then
		return true;
	end

	local targetItemCls = GetClass("Item", craftPair['target'])

	local prop = TryGetProp(targetItemCls, propName);
	if prop == nil then
		return false;
	end

	if propName == "Name" then
		if config.GetServiceNation() ~= "KOR" then
			prop = dic.getTranslatedStr(prop);				
		end
	end
    
	prop = string.lower(prop);
	searchText = string.lower(searchText);
	
	if string.find(prop, searchText) == nil then
		return false;
	else
		return true;
	end
end

function ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, propName, targetPropValue)
	return ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_CRAFT_CONTENT['EQUAL_PROP_BY_TARGET_ITEM_FUNC'], propName, targetPropValue)
end
function ADVENTURE_BOOK_CRAFT_CONTENT.SEARCH_PROP_BY_CLASSID_FROM_LIST(list, propName, targetPropValue)
	return ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_CRAFT_CONTENT['SEARCH_PROP_BY_TARGET_ITEM_FUNC'], propName, targetPropValue)
end


function ADVENTURE_BOOK_CRAFT_CONTENT.FILTER_LIST(list, sortOption, categoryOption, subCategoryOption, searchText)
	if categoryOption == 1 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "Weapon")
	elseif categoryOption == 2 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "Armor")
	elseif categoryOption == 3 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "SubWeapon")
	elseif categoryOption == 4 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "Drug")
	elseif categoryOption == 5 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "Material")
	elseif categoryOption == 6 then
		list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "GroupName", "Cube")
	end

	if categoryOption == 1 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Sword")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "THSword")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Staff")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "THStaff")
		elseif subCategoryOption == 5 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "THBow")
		elseif subCategoryOption == 6 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Bow")
		elseif subCategoryOption == 7 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Mace")
		elseif subCategoryOption == 8 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Spear")
		elseif subCategoryOption == 9 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "THSpear")
		elseif subCategoryOption == 10 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Rapier")
		elseif subCategoryOption == 11 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Musket")
		end
	elseif categoryOption == 2 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Shirt")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Pants")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Boots")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Gloves")
		elseif subCategoryOption == 5 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Neck")
		elseif subCategoryOption == 6 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Ring")
		elseif subCategoryOption == 7 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Shield")
		elseif subCategoryOption == 8 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Outer")
		elseif subCategoryOption == 9 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Hat")
		end
	elseif categoryOption == 3 then
		if subCategoryOption == 1 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Dagger")
		elseif subCategoryOption == 2 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Pistol")
		elseif subCategoryOption == 3 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Cannon")
		elseif subCategoryOption == 4 then
			list = ADVENTURE_BOOK_CRAFT_CONTENT.EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "ClassType", "Artefact")
		end
	end

	list = ADVENTURE_BOOK_CRAFT_CONTENT.SEARCH_PROP_BY_CLASSID_FROM_LIST(list, "Name", searchText)

	if sortOption == 0 then
        table.sort(list, ADVENTURE_BOOK_CRAFT_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_CRAFT_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	end
	return list;
end
