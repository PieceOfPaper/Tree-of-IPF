
ADVENTURE_BOOK_INDUN_CONTENT = {};

function ADVENTURE_BOOK_INDUN_CONTENT.INDUN_LIST()
	local list = GetAdventureBookClassIDList(ABT_INDUN)

	for i=1, #list do
	end
	return list;
end

function ADVENTURE_BOOK_INDUN_CONTENT.INDUN_CLEAR_COUNT(indunClsID)
	local data = GetAdventureBookInstByClassID(ABT_INDUN, indunClsID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_COUNTABLE_DATA");
	return data.count;
end

function ADVENTURE_BOOK_INDUN_CONTENT.INDUN_INFO(indunClsID)
	local indunCls = GetClassByType("Indun", indunClsID);
	local retTable = {}
	retTable['name'] = TryGetProp(indunCls, "Name");
	retTable['level'] = TryGetProp(indunCls, "Level");
	retTable['location'] = '';
	local startMapClsNames = TryGetProp(indunCls, "StartMap")
	local startMapClsNameList = StringSplit(startMapClsNames, "/");
	for i = 1, #startMapClsNameList do
		local startMapCls = GetClass("Map", startMapClsNameList[i]);
		local startMapName = TryGetProp(startMapCls, "Name")
		retTable['location'] = retTable['location'] .. startMapName;
		if i ~= #startMapClsNameList then
			retTable['location'] = retTable['location'] .. " / ";
		end
	end
	
	retTable['difficulty'] = ''
	local indunLevel  = TryGetProp(indunCls, "Level")
	if indunLevel ~= nil then
		local rank = math.floor(indunLevel / 100)
		for i=0, rank do
			retTable['difficulty'] = retTable['difficulty']..'{img star_mark 20 20}'
		end
	end
	retTable['count'] = ADVENTURE_BOOK_INDUN_CONTENT.INDUN_CLEAR_COUNT(indunClsID)
	return retTable;
end

function ADVENTURE_BOOK_INDUN_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Indun', 'Name', a, b)
end

function ADVENTURE_BOOK_INDUN_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Indun', 'Name', b, a)
end

function ADVENTURE_BOOK_INDUN_CONTENT.FILTER_LIST(list, sortOption, categoryOption, searchText)
	if categoryOption == 1 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunDungeon'))
	elseif categoryOption == 2 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunMission'))
	elseif categoryOption == 3 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunGroundTower'))
	elseif categoryOption == 4 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category",  ClMsg('IndunNunnery'))
	elseif categoryOption == 5 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunUpHill'))
	elseif categoryOption == 6 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunFantasyLib'))
	elseif categoryOption == 7 then
		list = ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Category", ClMsg('IndunRaid'))
	end

	list = ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FROM_LIST(list, "Indun", "Name", searchText)

	if sortOption == 0 then
        table.sort(list, ADVENTURE_BOOK_INDUN_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_INDUN_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	end
	return list;
end
