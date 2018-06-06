
ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT = {};

function ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT.ACHIEVE_LIST()
	local list = GetAdventureBookClassIDList(ABT_ACHIEVE);    
    table.sort(list, SORT_BY_TIME_RECENTLY);
	return list;
end

function SORT_BY_TIME_RECENTLY(a, b)
    local data1 = GetAdventureBookInstByClassID(ABT_ACHIEVE, a);
    local data2 = GetAdventureBookInstByClassID(ABT_ACHIEVE, b);
	if data1 == nil or data2 == nil then
		return false;
	end
	data1 = tolua.cast(data1, "ADVENTURE_BOOK_CONTENTS_DATA");
    data2 = tolua.cast(data2, "ADVENTURE_BOOK_CONTENTS_DATA");

	local timeValue1 = imcTime.ImcTimeToSysTime(data1.timeValue);
    local timeValue2 = imcTime.ImcTimeToSysTime(data2.timeValue);
    local timeInt1 = tonumber(string.format('%04d%02d%02d', timeValue1.wYear, timeValue1.wMonth, timeValue1.wDay));
    local timeInt2 = tonumber(string.format('%04d%02d%02d', timeValue2.wYear, timeValue2.wMonth, timeValue2.wDay));    
	return timeInt1 > timeInt2;
end

function ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT.ACHIEVE_CLEAR_TIME(achieveClsID)
	local data = GetAdventureBookInstByClassID(ABT_ACHIEVE, achieveClsID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_CONTENTS_DATA");
	local timeValue = imcTime.ImcTimeToSysTime(data.timeValue);
	return timeValue;
end

function ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT.ACHIEVE_INFO(achieveClsID)
	local cls = GetClassByType("Achieve", achieveClsID);
	local time = ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT.ACHIEVE_CLEAR_TIME(achieveClsID);

	local isValidAchieve = 0;
	if cls ~= nil then
		if TryGetProp(cls, "Journal") ~= nil and cls.Journal == "True" then
			isValidAchieve = 1;
		end
	end

	local retTable = {}
	retTable['is_valid_achieve'] = isValidAchieve
	retTable['name'] = TryGetProp(cls, "DescTitle");
	retTable['year'] = time.wYear
	retTable['month'] = time.wMonth
	retTable['day'] = time.wDay
	return retTable;
end