function GET_ITEM_AWAKE_OPTION_RELOCATE_COST(itemUseLv)
    return itemUseLv * 1000;
end

function GET_ITEM_ENCHANT_OPTION_RELOCATE_COST(destLV, srcLV)
	local cost = 999999999;

	if destLV == srcLV then
		cost = 100000;
	elseif srcLV < destLV then
		cost = (destLV - srcLV) * 3000000;
	end

    return cost;
end

-- dest_Obj : 이전 받을 아이템, src_Obj : 이전 할 아이템
-- 각성 이전 조건 확인
function IS_ENABLE_AWAKE_OPTION_RELOCATE(dest_Obj, src_Obj)
	-- 동일한 레벨, 동일한 부위, 동일한 등급
    local dest_guid = GetIESID(dest_Obj);
    local src_guid = GetIESID(src_Obj);

	if dest_guid == src_guid then
		return false, 'Same';
	end
	
	if TryGetProp(dest_Obj, "ClassType", 9999) ~= TryGetProp(src_Obj, "ClassType", 9999) then
		return false, 'Type';
	end

	if TryGetProp(dest_Obj, "UseLv", 9999) ~= TryGetProp(src_Obj, "UseLv", 9999) then
		return false, 'Level';
	end

	if TryGetProp(dest_Obj, "ItemGrade", 9999) ~= TryGetProp(src_Obj, "ItemGrade", 9999) then
		return false, 'Grade';
	end

	return true;
end

-- dest_Obj : 이전 받을 아이템, src_Obj : 이전 할 아이템
-- 인챈트 이전 조건 확인
function IS_ENABLE_ENCHANT_OPTION_RELOCATE(dest_Obj, src_Obj)	
    local dest_guid = GetIESID(dest_Obj);
    local src_guid = GetIESID(src_Obj);

	if dest_guid == src_guid then
		return false, 'Same';
	end

	-- dest의 레벨이 src의 레벨보다 낮은 경우에는 불가
	if TryGetProp(dest_Obj, "UseLv", 9999) < TryGetProp(src_Obj, "UseLv", 9999) then
		return false, 'Level';
	end

	if IS_OPTION_RELOCATE_ENABLE_MARKET_TRADE_ITEM(dest_Obj) ~= false and IS_OPTION_RELOCATE_ENABLE_MARKET_TRADE_ITEM(src_Obj) == false then
		return false, 'TradeOption';
	end	

	return true;
end

-- 마켓 거래 가능 여부 확인
function IS_OPTION_RELOCATE_ENABLE_MARKET_TRADE_ITEM(itemObj)
	if TryGetProp(itemObj, "BelongingCount", 1) == 1 then
		return false;
	end

	if TryGetProp(itemObj, "PR", 9999) <= 0 then
		return false;
	end

	if TryGetProp(itemObj, "MarketTrade", "NO") == "NO" then
		return false;
	end

	return true;
end

-- 각성 가능 아이템인지 확인
function IS_ENABLE_AWAKE_OPTION_RELOCATE_ITEM(itemObj)
	if TryGetProp(itemObj, 'ItemStar', -1) < 0 then
		return false, 'Type';
	end

	if 0 < TryGetProp(itemObj , 'LifeTime') or 0 < TryGetProp(itemObj , 'ItemLifeTimeOver') then
		return false, 'LimitTime';
	end

	if IS_NEED_APPRAISED_ITEM(itemObj) == true or IS_NEED_RANDOM_OPTION_ITEM(itemObj) == true then 
		return false, 'NeedRandomOption';
	end	

	return true;
end

-- 인챈트 쥬얼 가능 아이템인지 확인
-- IS_ENABLE_APPLY_JEWELL() 참고
function IS_ENABLE_ENCHANT_OPTION_RELOCATE_ITEM(itemObj)
	if TryGetProp(itemObj, 'ItemStar', -1) < 0 then
		return false, 'Type';
	end

	if 0 < TryGetProp(itemObj , 'LifeTime') or 0 < TryGetProp(itemObj , 'ItemLifeTimeOver') then
		return false, 'LimitTime';
	end
	
	if CHECK_JEWELL_COMMON_CONSTRAINT(itemObj) == false then		
		return false, 'Type';
	end

	if IS_NEED_APPRAISED_ITEM(itemObj) == true or IS_NEED_RANDOM_OPTION_ITEM(itemObj) == true then 
		return false, 'NeedRandomOption';
	end	

	local woodCarvingCheck = TryGetProp(itemObj , 'StringArg')
	if woodCarvingCheck == 'WoodCarving' then
	    return false, 'WoodCarving';
	end
	
	if TryGetProp(itemObj , 'UseLv') < 100 then
		return false, 'minLv';
	end

	return true;
end