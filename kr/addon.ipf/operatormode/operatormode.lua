function OPERATORMODE_ON_INIT(addon, frame)
end

function OPERATORMODE_ZONE_USER_NAME_AND_POS(handle, nameStr, mapName)
	ui.OpenFrame("operatormode");
	
	local frame = ui.GetFrame("operatormode");
	if nil == frame then
		return;
	end

	local bgBox = frame:GetChild("bg");
	if nil == bgBox then

		return;
	end
	
	local rich = bgBox:GetChild("userStr");
	rich:SetTextByKey("txt", nameStr);

	mg.MakeTextFile(mapName, nameStr);
end

function OPERATORMODE_UI_CLOSE()
	ui.CloseFrame("operatermode");
end