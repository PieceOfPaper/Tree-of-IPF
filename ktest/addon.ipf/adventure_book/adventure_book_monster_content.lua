ADVENTURE_BOOK_MONSTER_CONTENT = {};

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_LIST_ALL()
	local historyList = ADVENTURE_BOOK_MONSTER_CONTENT.HISTORY_MONSTER_LIST()
	local notFoundList = ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_LIST_EXCEPT_HISTORY()
	local newRet = {};
	for i=1, #historyList do
		newRet[#newRet+1] = historyList[i]
	end

	for i=1, #notFoundList do
		newRet[#newRet+1] = notFoundList[i]
	end
	return newRet;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.IS_PREVIEW_MONSTER(cls)
	if cls == nil then
		return 0;
	end

	if TryGetProp(cls, "Journal") == nil or cls.Journal == "" or cls.Journal == "None" then
		return 0;
	end

	return 1;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_LIST_EXCEPT_HISTORY()
	local list, cnt = GetClassList("Monster");

	local retTable = {};
	for i=0, cnt-1 do
		local cls = GetClassByIndexFromList(list, i);
		local clsID = TryGetProp(cls, "ClassID");
		if ADVENTURE_BOOK_MONSTER_CONTENT.IS_PREVIEW_MONSTER(cls) == 1 then
			if ADVENTURE_BOOK_MONSTER_CONTENT.EXIST_IN_HISTORY(clsID) == 0 then
				retTable[#retTable + 1] = clsID;
			end
		end
	end

	return retTable;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.HISTORY_MONSTER_LIST()
	local retTable = {};
	local monlist_kc = GetAdventureBookClassIDList(ABT_MON_KILL_COUNT)
	local monlist_di = GetAdventureBookClassIDList(ABT_MON_DROP_ITEM)
	
	for i = 1, #monlist_kc do
		local monID = monlist_kc[i]
		if GetClassByType("Monster", monID) ~= nil then
			retTable[#retTable + 1] = monID
		end
	end
	for i = 1, #monlist_di do
		local exist_c = GetAdventureBookInstByClassID(ABT_MON_KILL_COUNT, monlist_di[i])
		if exist_c == nil or exist_c == 0 then
			local monID = monlist_di[i]
			if GetClassByType("Monster", monID) ~= nil then
				retTable[#retTable + 1] = monID
			end
		end
	end

	table.sort(retTable);
	return retTable;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.EXIST_IN_HISTORY(monClsID)
	local data_kc = GetAdventureBookInstByClassID(ABT_MON_KILL_COUNT, monClsID)
	local data_di = GetAdventureBookInstByClassID(ABT_MON_DROP_ITEM, monClsID)
	if data_kc == nil and data_di == nil then
		return 0;
	else
		return 1;
	end
end

function ADVENTURE_BOOK_MONSTER_CONTENT.KILL_COUNT_MONSTER_LIST()
	local monlist = GetAdventureBookClassIDList(ABT_MON_KILL_COUNT)
	return monlist;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.DROP_ITEM_MONSTER_LIST()
	local monlist = GetAdventureBookClassIDList(ABT_MON_DROP_ITEM)
	return monlist;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_KILL_COUNT(monClsID)
	local data = GetAdventureBookInstByClassID(ABT_MON_KILL_COUNT, monClsID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_COUNTABLE_DATA");
	return data.count;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_DROP_ITEM(monClsID)
	local list = GetItemListFromAdventureBookMonData(monClsID);
	if list == nil then
		return;
	end

	local retTable = {};
	for i=1,#list do
		local data = tolua.cast(list[i], "ADVENTURE_BOOK_COUNTABLE_DATA");
		retTable[#retTable+1] = {}
		retTable[#retTable]["item_id"] = data:GetCountableID();
		retTable[#retTable]["count"] = data.count;
		local itemCls = GetClassByType("Item", data:GetCountableID())
		retTable[#retTable]["icon"] = TryGetProp(itemCls, "Icon")
	end
	return retTable;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_PLACES(monClsID)
	local mapNameList = {}

    local monCls = GetClassByType("Monster", monClsID)
	local zoneStr = TryGetProp(monCls, "Boss_UseZone")
	
	if zoneStr ~= nil then
		local zoneList = StringSplit(zoneStr, '/');
		for i=1, #zoneList do
			local mapCls = GetClass("Map", zoneList[i])
			local mapName = TryGetProp(mapCls, "Name")
			if mapName ~= nil then
				mapNameList[#mapNameList + 1] = mapName
			end
		end
	end
	return mapNameList;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_INFO(monClsID)
	local monCls = GetClassByType("Monster", monClsID);
	local retTable = {}
	local attr = TryGetProp(monCls, "Attribute")

	retTable['name'] = TryGetProp(monCls, "Name");
	retTable['icon'] = TryGetProp(monCls, "Icon");
	retTable['race_type'] = TryGetProp(monCls, "RaceType");
	retTable['attribute'] = "MonInfo_Attribute_";
	if attr ~= nil then 
		retTable['attribute'] = retTable['attribute'] .. attr;
	end
	retTable['armor_material'] = TryGetProp(monCls, "ArmorMaterial");
	retTable['desc'] = TryGetProp(monCls, "Desc");
	retTable['kill_count'] = ADVENTURE_BOOK_MONSTER_CONTENT.MONSTER_KILL_COUNT(monClsID)
	retTable['is_found']=ADVENTURE_BOOK_MONSTER_CONTENT.EXIST_IN_HISTORY(monClsID)
	return retTable;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Monster', 'Name', a, b)
end

function ADVENTURE_BOOK_MONSTER_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Monster', 'Name', b, a)
end

function ADVENTURE_BOOK_MONSTER_CONTENT.SORT_DEFAULT(a, b)
	local exist_func = ADVENTURE_BOOK_MONSTER_CONTENT['EXIST_IN_HISTORY']
	if exist_func(a) == 1 and exist_func(b) == 0 then
		return true;
	elseif  exist_func(a) == 0 and exist_func(b) == 1 then
		return false;
	end
	return a < b;
end

function ADVENTURE_BOOK_MONSTER_CONTENT.FILTER_LIST(list, sortOption, gradeOption, raceOption, searchText)
	if gradeOption == 1 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "MonRank", "Normal")
	elseif gradeOption == 2 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "MonRank", "Elite")
	elseif gradeOption == 3 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "MonRank", "Boss")
	end

	if raceOption == 1 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "RaceType", "Paramune")
	elseif raceOption == 2 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "RaceType", "Widling")
	elseif raceOption == 3 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "RaceType", "Velnias")
	elseif raceOption == 4 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "RaceType", "Forester")
	elseif raceOption == 5 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "RaceType", "Klaida")
	end

	list = ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FROM_LIST(list, "Monster", "Name", searchText)

	if sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_MONSTER_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 2 then
        table.sort(list, ADVENTURE_BOOK_MONSTER_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	else
		table.sort(list, ADVENTURE_BOOK_MONSTER_CONTENT['SORT_DEFAULT']);
	end
	return list;
end
