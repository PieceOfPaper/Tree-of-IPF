function EVENT_STAMP_IS_VALID_WEEK(week)
	local startTime = imcTime.GetSysTime(2020,4,16,6)
	local week_startTime = imcTime.AddSec(startTime,(week-1)*7*24*60*60)

	local currentDateLua = os.date("*t")
	local currentDate = imcTime.GetSysTime(currentDateLua['year'],currentDateLua['month'],currentDateLua['day'],currentDateLua['hour'])
	if imcTime.GetDifSec(week_startTime,currentDate) < 0 then
		return true
	end
	return false
end

function EVENT_STAMP_IS_VALID_WEEK_SUMMER(week, time)
	local startTime = imcTime.GetSysTime(2020,7,9,6)
	local week_startTime = imcTime.AddSec(startTime,(week-1)*7*24*60*60)

	local currentDateLua = os.date("*t")
	local currentDate = imcTime.GetSysTime(currentDateLua['year'],currentDateLua['month'],currentDateLua['day'],currentDateLua['hour'])
	if time ~= nil then
		currentDate = time
	end
	if imcTime.GetDifSec(week_startTime,currentDate) <= 0 then
		return true
	end
	return false
end

function EVENT_STAMP_GET_INFO(num)
	local row = math.floor((num-1)/3)+1
	local col = math.floor(num%3)
	if col == 0 then
		col = 3
	end
	local cls = EVENT_STAMP_GET_CURRENT_MISSION("REGULAR_EVENT_STAMP_TOUR",row-1)
	local prop = TryGetProp(cls,"CheckProp"..col)
	local propName,count = unpack(StringSplit(prop,'/'))
	count = tonumber(count)
	local week = TryGetProp(cls,"ArgNum"..col)
	return propName,count,week
end

function EVENT_STAMP_GET_INFO_SUMMER(num)
	local row = math.floor((num-1)/3)+1
	local col = math.floor(num%3)
	if col == 0 then
		col = 3
	end
	local cls = EVENT_STAMP_GET_CURRENT_MISSION("EVENT_STAMP_TOUR_SUMMER",row-1)
	local prop = TryGetProp(cls,"CheckProp"..col)
	local propName,count = unpack(StringSplit(prop,'/'))
	count = tonumber(count)
	local week = TryGetProp(cls,"ArgNum"..col)
	return propName,count,week
end

function EVENT_STAMP_GET_CURRENT_MISSION(groupName,currentpage)	
	local clsList, allmissionCnt = GetClassList('note_eventlist');
	local cnt = 0
	local missionCls = nil
	for i = 0,allmissionCnt-1 do
		missionCls = GetClassByIndexFromList(clsList, i);
		if missionCls.Group == groupName then
			if currentpage == cnt then
				break
			end
			cnt = cnt  + 1
		end
	end
	return missionCls
end

--EVENT_2007_TOS_VACANCE
function EVENT_STAMP_IS_HIDDEN_SUMMER(aObj,num)
	if num <= 12 then
		return false
	end
	local start = num - 12 - (num-1)%3
	for i = start,start+2 do
		local propName,count,week = EVENT_STAMP_GET_INFO_SUMMER(i)
		local nowCount = tonumber(TryGetProp(aObj,propName))
		if nowCount==nil or nowCount<count then
			return true
		end
	end
	return false
end
