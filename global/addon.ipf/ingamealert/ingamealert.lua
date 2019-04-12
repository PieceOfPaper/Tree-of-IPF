function INGAMEALERT_ON_INIT(addon, frame)
	addon:RegisterMsg("INGAME_PRIVATE_ALERT", "INGAMEALERT_SHOW");
	
end

function INGAMEALERT_SHOW(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('ingamealert');
	local mainBox = frame:GetChild('mainGbox');
	local text = GET_CHILD(mainBox, 'text');
	text:SetText(argStr);

	local chatFrame = ui.GetFrame('chatframe');
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, chatFrame:GetHeight() + 20);
	end
	frame:ShowWindow(1);
end

function OPEN_INGAMEALERT(frame)
end