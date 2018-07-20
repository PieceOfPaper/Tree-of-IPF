function IS_KEY_ITEM(item)		
	if STARTS_WITH(TryGetProp(item, 'EquipXpGroup'), "KQ_token_hethran") then
		return true
	else
		return false
	end
end

function STARTS_WITH(str, pattern)
	if str:find(pattern) == 1 then		
		return true
	else
		
		return false
	end
end

function IS_KEY_MATERIAL(item)
	if TryGetProp(item, 'Reinforce_Type') == 'Hethran' and TryGetProp(item, 'EquipXpGroup') == 'hethran_material' then
		return true
	else
		return false;
	end
end