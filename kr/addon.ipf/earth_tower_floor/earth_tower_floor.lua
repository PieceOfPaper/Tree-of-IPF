function OPEN_EARTH_TOWER_OPEN(floor, closeTime)
	
	local frame = ui.GetFrame("earth_tower_floor");
	ui.OpenFrame("earth_tower_floor");
	local floorCount = GET_CHILD(frame, "floorCount")
	floorCount:SetTextByKey("value", floor);
	
	frame:SetUserValue("CLOSE_TIME", imcTime.GetAppTime() + closeTime);
	frame:RunUpdateScript("UPDATE_EARTH_TOWER_FLOOR", 1);
	--UPDATE_EARTH_TOWER_FLOOR(frame)
	
end


function UPDATE_EARTH_TOWER_FLOOR(frame, elapsedTime)

	if imcTime.GetAppTime() > frame:GetUserIValue("CLOSE_TIME") then
		ui.CloseFrame("earth_tower_floor")
		frame:ShowWindow(0);
		return 0;
	end

	return 1;
end