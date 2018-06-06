function ITEMDIVISION_ON_INIT(addon, frame)
		
end


function ITEMDIVISION_ON_MSG(frame, msg, argStr, argNum)

end

function SHOW_ITEMDIVISION_FRAME(invitem, x, y)	
	local frame = ui.GetFrame('itemdivision');
	local itemCountEditBox = frame:GetChild('itemcount');
	tolua.cast(itemCountEditBox, "ui::CEditControl");
	itemCountEditBox:SetText('0');
	itemCountEditBox:SetMaxNumber(invitem.count);
	itemCountEditBox:SetValue(invitem.invIndex);
	
	frame:MoveFrame(x - frame:GetWidth(), y);	
	frame:ShowWindow(1);
end

function ITEMDIVISITON_OKBTN(frame, ctrl)
	local itemCountEditBox = frame:GetChild('itemcount');
	local itemCountStr = itemCountEditBox:GetText();
	local itemCount = tonumber(itemCountStr);
	
	if itemCount > 0 then
		item.InvItemDivision(itemCountEditBox:GetValue(), itemCount);
	end
end
