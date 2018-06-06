


function MCY_BUYITEM_ON_INIT(addon, frame)


		
end

function MCY_COIN_SET_TXT(frame, ctrlName, propValue)

	local dhl = frame:GetChild(ctrlName);
	if dhl:GetValue() ~= propValue then
		frame:GetChild("COIN_icon"):PlayEvent("ITEM_GET");
	end
	
	dhl:SetValue(propValue);
	dhl:SetTextByKey("value", propValue);

end

function INIT_UI_mission_test()
	
	session.SetLayerSObj("ssn_mission");
	local frame = ui.GetFrame("mcy_buyitem");
	frame:ShowWindow(1);	
	
	frame = ui.GetFrame("map_aos");
	frame:ShowWindow(1);
	
	frame = ui.GetFrame("mcy_killer");
	frame = ui.GetFrame("mcy_killmsg");

end

function SCR_MCY_BUY(frame, button, str, num)

	if button:IsGrayStyle() == 1 then
		return;
	end	
	
	ui.DisableForTime(button, 1000, 1);
	control.CustomCommand("MCY_BUY_ITEM", num);

end

