-- quickslotnearbar_util.lua
-- 내 / 외부에서 사용하는 유틸들

function GET_QUICKSLOT_BY_CLASSID(frame, category, classID)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD(frame, "slot"..i+1, "ui::CSlot");
		local iconPt = slot:GetIcon();
		if iconPt  ~=  nil then
			local icon = tolua.cast(iconPt, 'ui::CIcon');
			local iconInfo = icon:GetInfo();
			if iconInfo.category == category and iconInfo.type == classID then
				return slot;
			end
		end
	end

	return nil;
end

function GET_QUICKSLOT_ITEM_BY_FUNC(frame, func, ...)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD(frame, "slot"..i+1, "ui::CSlot");
		local iconPt = slot:GetIcon();
		if iconPt  ~=  nil then
			local icon = tolua.cast(iconPt, 'ui::CIcon');
			local iconInfo = icon:GetInfo();
			if iconInfo.category == "Item" then
				local cls = GetClassByType("Item", iconInfo.type);
				if func(cls, ...) == true then
					return slot;
				end
			end
		end
	end

	return nil;
end

function GET_QUICKSLOT_SLOT_HOTKEY(frame, slot)
	local slotIndex = slot:GetSlotIndex();
	local slotString = 'QuickSlotExecute'..(slotIndex+1);
	return hotKeyTable.GetHotKeyString(slotString);
end
