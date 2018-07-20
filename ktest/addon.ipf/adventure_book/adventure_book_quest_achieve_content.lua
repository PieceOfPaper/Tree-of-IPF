
ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT = {};

function ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT.ACHIEVE_LIST()
	local list = GetAdventureBookClassIDList(ABT_ACHIEVE)
	return list;
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
		local nowpoint = GetAchievePoint(GetMyPCObject(), TryGetProp(cls, "NeedPoint"))
		local isHasAchieve = 0;
		if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 and TryGetProp(cls, "NeedCount") ~= nil and nowpoint >= cls.NeedCount then
			isHasAchieve = 1;
		end
		if isHasAchieve == 1 and TryGetProp(cls, "Name") == nil and cls.Name=="" and cls.Name=="None" then
			isValidAchieve = 1;
		end
	end

	local retTable = {}
	retTable['is_valid_achieve']=isValidAchieve
	retTable['name']=TryGetProp(cls, "Name")
	retTable['year']=time.wYear
	retTable['month']=time.wMonth
	retTable['day']=time.wDay
	return retTable;
end
