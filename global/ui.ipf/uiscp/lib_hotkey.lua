--- lib_hotkey.lua

function GET_HOTKEY(category, type)

	local frame = ui.GetFrame("quickslotnexpbar");
	local selectedSlot = nil;
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD(frame, "slot"..i+1, "ui::CSlot");
		local icon = slot:GetIcon();
		if icon ~= nil then
			local info = icon:GetInfo();
			if info:GetCategory() == category and type == info.type then
				local slotString 	= 'QuickSlotExecute'..(i+1);
				return hotKeyTable.GetHotKeyString(slotString);	
			end
		end	
	end

	return nil;

end