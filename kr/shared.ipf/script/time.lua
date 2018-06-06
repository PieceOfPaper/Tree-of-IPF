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

function TW_NO_TOKEN_CONNECT_ABLE() -- 대만 통행증 체크 함수

	if "06/24/16 15:00:00" <= os.date() and os.date() < "06/24/16 21:00:00" then
		return 1
	end

	if "06/25/16 00:00:00" <= os.date() and os.date() < "07/12/16 23:59:59" and os.date("%H") == "20" then
		return 1
	end

	return 0

end