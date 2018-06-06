function KEYPAD_ON_INIT(addon, frame)
	
end

function KEYPAD_ON_MSG(frame, msg, argStr, argNum)

end

function KEYPAD_OPEN(frame, ctrl, argStr, argNum)
	frame:SetSValue("");
end

function KEYPAD_CLOSE(frame, ctrl, argStr, argNum)
	frame:SetSValue("");
end

function KEYPAD_LBTN_UP(frame, ctrl, argStr, argNum)
	local linkEditCtrl = frame:GetLinkObject();
	tolua.cast(linkEditCtrl, 'ui::CEditControl');
	
	if argNum == -1 then
		local number = frame:GetSValue();
		
		if string.len(number) > 0 then		
			number = string.sub(number, 1, string.len(number) - 1);
			frame:SetSValue(number);
			linkEditCtrl:SetText(number);
		end
	else
		local number = frame:GetSValue()..argStr;	
		frame:SetSValue(number);	
		linkEditCtrl:SetText(number);
	end	
end
