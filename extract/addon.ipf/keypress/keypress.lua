

function KEYPRESS_ON_INIT(addon, frame)


end

function START_KEY_PRESS(keyName)
	local frame = ui.GetFrame("keypress");
	local keytext = frame:GetChild("keytext");
	keytext:SetTextByKey("key", keyName);
	frame:ShowWindow(1);
	
end

function END_KEY_PRESS(frame, key, str, cnt)
	local myActor = GetMyActor();
	geSkillControl.KeyPress(GetMyActor(), 0, 0, 0, 0, 0);
end

function UPDATE_KEY_PRESS(frame, key, str, cnt)
	local keytext = frame:GetChild("keytext");
	local x = keytext:GetOffsetX();
	local y = keytext:GetOffsetY();

	if cnt == 1 then
		keytext:SetOffset(x, y - 5);			
	else
		keytext:SetOffset(x, y + 5);
	end
	
end
