function SCR_SIERA_MATERIAL(item)

	local itemLv = TryGetProp(item, "UseLv")
	if itemLv == nil then
		return;
	end

	local sieraCount =  math.floor((1 + (math.floor(itemLv/75) * math.floor(itemLv/75))* 5) * 0.5)

	return sieraCount
end

function SCR_NEWCLE_MATERIAL(item)

 	local itemGradeRatio = {75, 50, 35, 20};
    local itemMaxRatio = {1.4, 1.5, 1.8, 2};

	local itemLv = TryGetProp(item, "UseLv")
	if itemLv == nil then
		return;
	end
 	itemGrade = TryGetProp(item, 'ItemGrade')
	if itemGrade == nil then
		return;
	end
	
	local newcleCount = math.floor(math.floor(1 + (itemLv/itemGradeRatio[itemGrade])) * itemMaxRatio[itemGrade] * 20)

	return newcleCount
end

function IS_EXIST_RANDOM_OPTION(item)
	local maxRandomOptionCnt = 6;
	for i = 1, maxRandomOptionCnt do
		if item['RandomOption_'..i] ~= 'None' then
			return true;
		end
	end
	return false;
end

function CHECK_NEED_RANDOM_OPTION(item)
	if item == nil then
		return false;
	end

	if TryGetProp(item, 'NeedRandomOption', 0) == 0 then
		return false;
	end

	for i = 1, 6 do
		if item['RandomOption_'..i] ~= 'None' then
			return false;
		end

		if item['RandomOptionGroup_'..i] ~= 'None' then
			return false;
		end

		if item['RandomOptionValue_'..i] ~= 0 then
			return false;
		end
	end

	return true;
end