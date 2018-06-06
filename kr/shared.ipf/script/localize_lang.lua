



-- Time text can be variable between nations

function GET_TIME_TXT(sec)

	sec = math.floor(sec)

	local d, h, m, s = GET_DHMS(sec);
	local ret = "";
	local started = 0;
	if d > 0 then
		ret = ret .. ScpArgMsg("{Day}","Day",d) .. " ";
		started = 1;
	end
	
	if h > 0 then
		ret = ret .. ScpArgMsg("{Hour}","Hour",h) .. " ";
		started = 1;
	end

	if m >= 0 then
		ret = ret .. ScpArgMsg("{Min}","Min",m) .. " ";
		started = 1;
	end
	
--if s == 0 and ret ~= "" then
--	return string.sub(ret, 1, string.len(ret) - 1);
--end

	ret = ret .. ScpArgMsg("{Sec}","Sec",s);
	return ret;
	
end

function GET_TIME_TXT_TWO_FIGURES(sec)

	sec = math.floor(sec)

	local d, h, m, s = GET_DHMS(sec);
	local ret = "";
	
	if s > 0 then
	ret = ret .. ScpArgMsg("{Sec}","Sec",s);
	end 

	if m > 0 then
		ret = ScpArgMsg("{Min}","Min",m) .. ret;
	end

	if h > 0 then
		ret = ScpArgMsg("{Hour}","Hour",h) .. ret;
	return ret;
	end

	return ret;
	
end

function GET_TIME_TXT_DHM(sec)

	local d, h, m, s = GET_DHMS(sec);
	local ret = "";
	local started = 0;
	if d > 0 then
		ret = ret .. ScpArgMsg("{Day}","Day",d) .. " ";
		started = 1;
	end
	
	if h > 0 or started == 1 then
		ret = ret .. ScpArgMsg("{Hour}","Hour",h) .. " ";
		started = 1;
	end
	
	ret = ret .. ScpArgMsg("{Min}","Min",m);
	return ret;
	
end

--[[
struct SYSTEMTIME
{
    int wYear;
    int wMonth;
    int wDayOfWeek;
    int wDay;
    int wHour;
    int wMinute;
    int wSecond;
    int wMilliseconds;
};
]]

function GET_DATE_TXT_DAY(time)

	return ScpArgMsg("{Month}{Day}","Month",time.wMonth,"Day",time.wDay)	
end

function GET_DATE_TXT(time)

	return ScpArgMsg("{Year}{Month}{Day}{Hour}{Min}{Sec}","Year",time.wYear,"Month",time.wMonth,"Day",time.wDay,"Hour",time.wHour,"Min",time.wMinute,"Sec",time.wSecond)	
end

function GET_YMDHM_BY_SYSTIME(time)

	local strhour = string.format("%02d",time.wHour)
	local strmin = string.format("%02d",time.wMinute)
	return ScpArgMsg("{Year}.{Month}.{Day}. {Hour}:{Min}","Year",time.wYear,"Month",time.wMonth,"Day",time.wDay,"Hour",strhour,"Min",strmin)
end

function SofS(thing, owner)

	return ScpArgMsg("{Auto_1}_of_{Auto_2}", "Auto_1", owner,"Auto_2", thing);
	
end

function GET_DIFF_TIME_TXT(nowtime, beforetime)

	if beforetime.wYear < nowtime.wYear then
		return ScpArgMsg("{Year}Ago", "Year", nowtime.wYear - beforetime.wYear)
	end

	if beforetime.wMonth < nowtime.wMonth then
		return ScpArgMsg("{Month}Ago", "Month", nowtime.wMonth - beforetime.wMonth)
	end

	if beforetime.wDay < nowtime.wDay then
		return ScpArgMsg("{Day}Ago", "Day", nowtime.wDay - beforetime.wDay)
	end

	if beforetime.wHour < nowtime.wHour then
		return ScpArgMsg("{Hour}Ago", "Hour", nowtime.wHour - beforetime.wHour)
	end

	if beforetime.wMinute < nowtime.wMinute then
		return ScpArgMsg("{Min}Ago", "Min", nowtime.wMinute - beforetime.wMinute)
	end

	return ScpArgMsg("JustBefore")
end
