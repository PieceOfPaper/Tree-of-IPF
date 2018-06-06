
ADVENTURE_BOOK_FISHING_CONTENT = {};

function ADVENTURE_BOOK_FISHING_CONTENT.FISH_LIST()
	local fishlist = GetAdventureBookClassIDList(ABT_FISHING)
	return fishlist;
end

function ADVENTURE_BOOK_FISHING_CONTENT.TOTAL_FISH_COUNT()
	local fishlist = ADVENTURE_BOOK_FISHING_CONTENT.FISH_LIST()
	local count = 0;
	for i=1, #fishlist do
		count = count + ADVENTURE_BOOK_FISHING_CONTENT.FISH_COUNT(fishlist[i])
	end
	return count
end

function ADVENTURE_BOOK_FISHING_CONTENT.FISH_COUNT(itemClsID)
	local data = GetAdventureBookInstByClassID(ABT_FISHING, itemClsID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_COUNTABLE_DATA");
	return data.count;
end

function ADVENTURE_BOOK_FISHING_CONTENT.FISH_INFO(itemClsID)
	local itemCls = GetClassByType("Item", itemClsID);
	local retTable = {}
	retTable['name'] = TryGetProp(itemCls, "Name");
	retTable['icon'] = TryGetProp(itemCls, "Icon");
	retTable['desc'] = TryGetProp(itemCls, "Desc");
	retTable['weight'] = TryGetProp(itemCls, "Weight");
	retTable['type'] = ScpArgMsg(TryGetProp(itemCls, "GroupName"));

	retTable['count'] = ADVENTURE_BOOK_FISHING_CONTENT.FISH_COUNT(itemClsID)

	retTable['trade_shop'] = 0
	retTable['trade_market'] = 0
	retTable['trade_team'] = 0
	retTable['trade_user'] = 0

	if TryGetProp(itemCls, "ShopTrade") == "YES" then
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

function ADVENTURE_BOOK_FISHING_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Item', 'Name', a, b)
end

function ADVENTURE_BOOK_FISHING_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Item', 'Name', b, a)
end

function ADVENTURE_BOOK_FISHING_CONTENT.FILTER_LIST(list, sortOption)

	if sortOption == 0 then
        table.sort(list, ADVENTURE_BOOK_ITEM_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_ITEM_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	end
	return list;
end
