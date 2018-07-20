function OPEN_EARTH_TOWER_OPEN(msgStr, closeTime, isShowFloorText)
	
	local frame = ui.GetFrame("earth_tower_floor");
	ui.OpenFrame("earth_tower_floor");
	local floorCount = GET_CHILD(frame, "floorCount")
	floorCount:SetTextByKey("value", msgStr);
	
	local floorText = GET_CHILD(frame, "floor");
	
	local pic = GET_CHILD(frame, "pic_bg", "ui::CGroupBox");
	local pw = pic:GetOriginalWidth();
	local ph = pic:GetOriginalHeight();
	
	local tw = floorCount:GetWidth();
	local th = floorCount:GetHeight();

	local margin = 150;
	if tw > pw-margin then
		pic:Resize(tw+margin, ph);
		frame:Resize(tw+margin, ph);		
	else
		pic:Resize(pw, ph);
		frame:Resize(pw, ph);
	end
	if isShowFloorText ~= 1 or isShowFloorText == nil then
		floorText:ShowWindow(0);
	else
		floorText:ShowWindow(1);
	end
	
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