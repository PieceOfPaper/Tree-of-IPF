-- time.lua


function GET_XM_HM_BY_SYSTIME(sysTime)

	if sysTime == nil then
		sysTime = geTime.GetServerSystemTime();
	end

	local timeStr = "AM";
	local hour = sysTime.wHour;
	if hour > 12 then
		hour = hour - 12;
		timeStr = "PM";
	elseif hour == 12 then
		hour =12;
		timeStr = "PM";
	end

	if hour == 24 then
		hour = 0;
		timeStr = "AM";
	end
	return string.format("%s %d:%02d", timeStr, hour, sysTime.wMinute);

end