-- quickslotnexpbar.lua

function QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(frame)
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot 			= frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString 	= 'QuickSlotExecute'..(i+1);
		local text 			= hotKeyTable.GetHotKeyString(slotString);
		
		for i = 0, 9 do
		    if text == 'NUMPAD'..i then
		        text = 'NUM'..i
		        break;
		    end
		end
		
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', ui.LEFT, ui.TOP, 2, 1);
		QUICKSLOT_MAKE_GAUGE(slot);
	end
end
