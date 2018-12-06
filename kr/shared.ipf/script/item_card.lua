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

function IS_ENABLE_EQUIPPED_CARD(pc, item)
	if item == nil then
		return 0;
	end

	if item.CardGroupName == 'None' then
		return 0;
	end

	local cardGroupName = item.CardGroupName;
	local tempCount = 0;
	for i = 1, MAX_NORMAL_MONSTER_CARD_SLOT_COUNT + LEGEND_CARD_SLOT_COUNT do
		local equipCard = nil;
		if IsServerObj(pc) == 1 then
			local cardName = GetEquipCardInfo(pc, i);
			if cardName ~= nil then
				equipCard = GetClass('Item', cardName);
			end
		else
			local cardInfo = equipcard.GetCardInfo(i);
			if cardInfo ~= nil then
				equipCard = GetClassByType('Item', cardInfo:GetCardID());
			end
		end
		if cardGroupName == TryGetProp(equipCard, 'CardGroupName') then
			tempCount = tempCount + 1
		end
	end

	return tempCount;
end


