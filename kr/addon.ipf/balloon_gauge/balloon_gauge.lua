
function BALLOON_GAUGE_ON_INIT(addon, frame)

	
end

function MAKE_GAUGE_BALLOON(handle, startTime, maxTime, isReverse, skinName)
	if maxTime <= 0 then
		ui.DestroyFrame("GAUGE_BALLOON_" .. handle);
		return;
	end
		
	local frame = ui.CreateNewFrame("balloon_gauge", "GAUGE_BALLOON_" .. handle);
	if frame == nil then
		return nil;
	end

	if startTime < 0 then
		startTime = 0;
	end

	local gaugeTime = maxTime - startTime;
	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetSkinName(skinName);

	if isReverse == 1 then
		gauge:SetPoint(maxTime, maxTime);
		gauge:SetPointWithTime(startTime, maxTime - startTime, 1);
	else
		gauge:SetPoint(startTime, maxTime);
		gauge:SetPointWithTime(maxTime, maxTime - startTime, 1);
	end
	frame:ShowWindow(1);
	frame:SetDuration(gaugeTime);
	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, 30, 3, 1);
end

