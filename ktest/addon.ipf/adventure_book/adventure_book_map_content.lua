
ADVENTURE_BOOK_MAP_CONTENT = {};

function ADVENTURE_BOOK_MAP_CONTENT.IS_VISIBLE_MAP(cls)
	if cls == nil then
		return 0;
	end

	if TryGetProp(cls, "ClassID") == nil or TryGetProp(cls, "MapType") == nil or TryGetProp(cls, "CategoryName") == nil or TryGetProp(cls, "Journal") == nil then
		return 0;
	end

	if cls.Journal ~= "TRUE" then
		return 0;
	end

	if cls.MapType == "City" or cls.MapType == "Field" or cls.MapType == "Dungeon" then
		return 1;
	end

	return 0;
end

function ADVENTURE_BOOK_MAP_CONTENT.REGION_LIST()
	local mapList, mapCnt = GetClassList("Map");
	local hashList = {};
	local cateList = {};
	for i = 0, mapCnt-1 do
		local cls = GetClassByIndexFromList(mapList, i);
		if ADVENTURE_BOOK_MAP_CONTENT.IS_VISIBLE_MAP(cls) == 1 then
			hashList[cls.CategoryName] = 1;
		end
	end
	
	for key, value in pairs(hashList) do
		cateList[#cateList+1]=key;
	end

	return cateList;
end

function ADVENTURE_BOOK_MAP_CONTENT.MAP_LIST()
	local mapList, mapCnt = GetClassList("Map");
	local retList = {};
	for i = 0, mapCnt-1 do
		local cls = GetClassByIndexFromList(mapList, i);
		if ADVENTURE_BOOK_MAP_CONTENT.IS_VISIBLE_MAP(cls) == 1 then
			retList[#retList + 1] = cls.ClassID;
		end
	end
	
	return retList;
end

function ADVENTURE_BOOK_MAP_CONTENT.MAP_LIST_BY_REGION_NAME(regionName)
	local mapList = ADVENTURE_BOOK_MAP_CONTENT.MAP_LIST()
	local retList = {};
	for i = 1, #mapList do
		local cls = GetClassByType("Map", mapList[i])
		if TryGetProp(cls, "CategoryName") == regionName then
			retList[#retList + 1] = mapList[i]
		end
	end
	return retList;
end

function ADVENTURE_BOOK_MAP_CONTENT.MAP_REVEAL_RATE(mapClsID)
	local mapCls = GetClassByType("Map", mapClsID)
	local mapName = TryGetProp(mapCls, "ClassName")

	local accObj = GetMyAccountObj();
	local isVisited = TryGetProp(accObj, 'HadVisited_' .. mapClsID);

	local mapRevealRate = session.GetMapFogRevealRate(mapName)
	if  mapRevealRate == nil then
		return 0;
	end
	if TryGetProp(mapCls, "UseMapFog") == 0 then
		return 100;
	end
	return math.floor(mapRevealRate)
end

function ADVENTURE_BOOK_MAP_CONTENT.TOTAL_MAP_REVEAL_RATE()
 	local mapList = ADVENTURE_BOOK_MAP_CONTENT.MAP_LIST()
	 local totalRate = 0;
	 for i=1, #mapList do
	 	local mapClsID = mapList[i]
	 	totalRate = totalRate + ADVENTURE_BOOK_MAP_CONTENT.MAP_REVEAL_RATE(mapClsID);
	 end

	 if #mapList <= 0 then
	 	return 0;
	end
	local ret = totalRate / (#mapList)
	return string.format("%.2f", ret)
end

function ADVENTURE_BOOK_MAP_CONTENT.REGION_INFO(regionName)
	local mapList = ADVENTURE_BOOK_MAP_CONTENT.MAP_LIST_BY_REGION_NAME(regionName)

	local retTable = {};
	retTable['name'] = regionName
	return retTable;
end


function ADVENTURE_BOOK_MAP_CONTENT.MAP_INFO(mapClsID)
	local mapCls = GetClassByType("Map", mapClsID);
	local mapRank = TryGetProp(mapCls, "MapRank")
	
	local retTable = {};
	retTable['name'] = TryGetProp(mapCls, "Name") .. " " .. ScpArgMsg("ExploreRate")
	retTable['level'] = TryGetProp(mapCls, "QuestLevel")
	retTable['rate'] = ADVENTURE_BOOK_MAP_CONTENT.MAP_REVEAL_RATE(mapClsID)
	retTable['is_visited'] = 0;
	retTable['rate_text'] = '?'
	if retTable['rate'] > 0 then
		retTable['is_visited'] = 1; 
		retTable['rate_text'] = tostring(retTable['rate']) .. '%'
	end

	retTable['difficulty'] = ''
	if mapRank ~= nil then
		for i=1, tonumber(mapRank) do
		 	retTable['difficulty'] = retTable['difficulty']..'{img star_mark 20 20}'
		 end
	end

	return retTable;
end

function ADVENTURE_BOOK_MAP_CONTENT.IS_COMPLETE(mapClsID)
	if ADVENTURE_BOOK_MAP_CONTENT.MAP_REVEAL_RATE(mapClsID) == 100 then
		return true;
	end
	return false;
end
function ADVENTURE_BOOK_MAP_CONTENT.IS_NOT_COMPLETE(mapClsID)
	if ADVENTURE_BOOK_MAP_CONTENT.IS_COMPLETE(mapClsID) == 1 then
		return false;
	elseif ADVENTURE_BOOK_MAP_CONTENT.IS_NOT_DETECTED(mapClsID) == 1 then
		return false;
	else
		return true;
	end
end
function ADVENTURE_BOOK_MAP_CONTENT.IS_NOT_DETECTED(mapClsID)
	if ADVENTURE_BOOK_MAP_CONTENT.MAP_REVEAL_RATE(mapClsID) <= 0 then
		return true;
	end
	return false;
end
function ADVENTURE_BOOK_MAP_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Map', 'Name', a, b)
end
function ADVENTURE_BOOK_MAP_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Map', 'Name', b, a)
end
function ADVENTURE_BOOK_MAP_CONTENT.FILTER_LIST(list, sortOption, stateOption, searchText)
	if stateOption == 1 then -- 완성
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_MAP_CONTENT['IS_COMPLETE'])
	elseif stateOption == 2 then -- 미확인
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_MAP_CONTENT['IS_NOT_DETECTED'])
	elseif stateOption == 3 then -- 미완성
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_MAP_CONTENT['IS_NOT_COMPLETE'])
	end
	
	list = ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FROM_LIST(list, "Map", "Name", searchText)

	if sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_MAP_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 2 then
        table.sort(list, ADVENTURE_BOOK_MAP_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	else
		table.sort(list, ADVENTURE_BOOK_SORT_ASC);
	end
	return list;
end