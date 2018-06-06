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

	local cardGroupName = item.CardGroupName
--	local itemGrade = 0
--	itemGrade = math.floor(item.ItemGrade)
		
--	local maxIndex = GetTotalJobCount(pc)
--	if maxIndex > JOB_CHANGE_MAX_RANK then
--		maxIndex = JOB_CHANGE_MAX_RANK
--	end

	local pcEtc = GetETCObject(pc);

	if pcEtc == nil then
		return 0;
	end

	local tempCount = 0


	for i = 1, 12 do
		if pcEtc["EquipCardID_Slot" ..i] ~= 0 then
			local cardID = pcEtc["EquipCardID_Slot" ..i]
			local equipCard = GetClassByType('Item', cardID)
			if cardGroupName == equipCard.CardGroupName then
				tempCount = tempCount + 1
			end
		end
	end

	return tempCount;
end


