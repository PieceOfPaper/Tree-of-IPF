function GET_ITEM_OPTION_RELOCATE_COST(itemUseLv)
    return itemUseLv * 1000;
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
	-- 부위 제한이 없음. 동일한 레벨, 동일한 등급
    local dest_guid = GetIESID(dest_Obj);
    local src_guid = GetIESID(src_Obj);

	if dest_guid == src_guid then
		return false, 'Same';
	end
	
	if TryGetProp(dest_Obj, "UseLv", 9999) ~= TryGetProp(src_Obj, "UseLv", 9999) then
		return false, 'Level';
	end

	if TryGetProp(dest_Obj, "ItemGrade", 9999) ~= TryGetProp(src_Obj, "ItemGrade", 9999) then
		return false, 'Grade';
	end

	return true;
end