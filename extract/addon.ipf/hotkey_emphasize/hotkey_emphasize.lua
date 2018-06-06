function HOTKEY_EMPHASIZE_ON_INIT(addon, frame)
	addon:RegisterMsg("START_HOTKEY_EMPHASIZE", "ON_START_HOTKEY_EMPHASIZE");
end

function ON_START_HOTKEY_EMPHASIZE(frame, msg, iconName, num)

	local key_img = frame:GetChild("icon_img");
	tolua.cast(key_img, "ui::CPicture");
	key_img:SetImage(iconName);

	frame:ShowWindow(1);
end

function UPDATE_HOTKEY_EMPHASIZE(frame, key, str, cnt)
	local key_img = frame:GetChild("icon_img");
	local x = key_img:GetOffsetX();
	local y = key_img:GetOffsetY();

	if cnt == 1 then
		key_img:SetOffset(x, y - 5);			
	else
		key_img:SetOffset(x, y + 5);
	end
	
end
