function SCR_REFRESH_card_Gaigalas(item)

	local class = GetClassByType('Item', item.ClassID);
	INIT_WEAPON_PROP(item, class);

	item.Level = GET_ITEM_LEVEL(item);
end

function GET_ITEM_LHAND_SKILL(item)
	local lhandSkill = TryGetProp(item, "LHandSkill");
	if lhandSkill == "None" or lhandSkill== nil then
		return nil;
	end

	return GetClass("Skill", lhandSkill);
end

