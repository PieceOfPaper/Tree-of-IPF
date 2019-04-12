--- item_reinforce_by_mix.lua

function SCR_CHECK_CARD_MATERIAL(reinfItem, matItem)
	if TryGetProp(matItem, "Reinforce_Type") == "Card" and 0 == IsSameObject(reinfItem, matItem) then
		return 1;
	end
	return 0;
end

function SCR_CHECK_REINFORCE_CARD_MATERIAL(reinfItem, matItem)
	if TryGetProp(matItem, "Reinforce_Type") == "Card" and 0 == IsSameObject(reinfItem, matItem) then
		return 1;
	end
	return 0;
end

function SCR_CHECK_LEGEND_CARD_MATERIAL(reinfItem, matItem)
	if TryGetProp(matItem, "GroupName") == "Card" and 0 == IsSameObject(reinfItem, matItem) then
		return 1;
	end
	return 0;
end

function SCR_CHECK_HETHRAN_MATERIAL(reinfItem, matItem)
	if TryGetProp(matItem, "Reinforce_Type") == "Hethran" and 0 == IsSameObject(reinfItem, matItem) then
		return 1;
	end
	return 0;
end


function SCR_CHECK_GEM_MATERIAL(reinfItem, matItem)

	if 1 == IsSameObject(reinfItem, matItem) then
		return 0;
	end
	
	if TryGetProp(matItem , "ItemLifeTimeOver") == 1 then
	    return 0;
	end
	
	if TryGetProp(matItem, "Reinforce_Type") == "Gem" then
		return 1;
	end

	-- 카드합성 재료는 젬에 못쓰게--
	if TryGetProp(matItem, "Reinforce_Type") == "Card" then
		return 0
	end

	if GET_MIX_MATERIAL_EXP(matItem) == 0 then
		return 0;
	end

	if matItem.ItemType == "Quest" then
		return 0;
	end

	if matItem.EquipXpGroup == "None" then
		return 0;
	end

	if TryGetProp(matItem, "Reinforce_Type") == "Hethran" then
		return 0;
	end

	return 1;

end
