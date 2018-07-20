-- lib_slotlist.lua --

function APPLY_TO_ALL_ITEM_SLOT(slotSet, func, ...)
	if slotSet == nil then
		return;
	end
	
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i );
		func(slot, ...);
	end
end

function GET_FROM_ALL_ITEM_SLOT(slotSet, func, ...)
	
	local ret = 0;
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i );
		ret = ret + func(slot, ...);
	end

	return ret;
end

function APPLY_TO_ALL_ITEM_SLOT_ITEM(slotSet, func, ...)

	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i );
		local item = GET_SLOT_ITEM(slot);
		if item ~= nil then
			func(item, ...);
		end
	end

end

function GET_FROM_SLOT(slotSet, func, ...)

	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if func(slot, ...) == true then
			return slot;
		end
	end

	return nil;

end

function _CHECK_EMPY_TYPE(slot)
	local icon = slot:GetIcon();
	if icon == nil or icon:GetTooltipNumArg() == 0 then
		return true;
	end

	return false;
end

function GET_EMPTY_SLOT(slotSet)
	return GET_FROM_SLOT(slotSet, _CHECK_EMPY_TYPE);
end

function _CHECK_SLOT_TYPE(slot, type)
	local icon = slot:GetIcon();
	if icon == nil then
		return false;
	end
	
	local iconInfo = icon:GetInfo();
	if iconInfo.type == type then
		return true;
	end

	return false;
end

function GET_SLOT_BY_TYPE(slotSet, type)
	return GET_FROM_SLOT(slotSet, _CHECK_SLOT_TYPE, type);
end

function _CHECK_SLOT_UV(slot, vName, vValue)
	if slot:GetUserValue(vName) == vValue or slot:GetUserIValue(vName) == vValue then
		return true;
	end

	return false; 
end

function GET_SLOT_BY_USERVALUE(slotSet, vName, vValue)
	return GET_FROM_SLOT(slotSet, _CHECK_SLOT_UV, vName, vValue);
end

function CLEAR_SLOTSET(slotSet)
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		CLEAR_SLOT_ITEM_INFO(slot);
	end
end

function _CHECK_SLOT_IESID(slot, iesID)
	local icon = slot:GetIcon();
	if icon == nil then
		return false;
	end
	
	local iconInfo = icon:GetInfo();
	if iconInfo:GetIESID() == iesID then
		return true;
	end

	return false;
end

function GET_SLOT_BY_IESID(slotSet, iesID)
	return GET_FROM_SLOT(slotSet, _CHECK_SLOT_IESID, iesID);
end