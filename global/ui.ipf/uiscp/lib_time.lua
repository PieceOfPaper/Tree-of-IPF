-- lib_time.lua --

function GET_QUEST_MIN_SEC(time)

	local min = math.floor(time / 60);
	local sec = math.floor(time - min * 60);
	return min, sec;
end


function SET_QUESTINFO_TIME_TO_PIC(numMMtime, numSStime, min1, min2, sec1, sec2)

		if numMMtime > 9 then
			local numM1time = math.floor(numMMtime / 10);		
			local numM2time = numMMtime % 10;
			
			min1:SetImage("time_"..tostring(numM1time));		
			min2:SetImage("time_"..tostring(numM2time));
		else 		
			local numM2time = numMMtime % 10;
			
			min1:SetImage("time_0");			
			min2:SetImage("time_"..tostring(numM2time));
		end
		
		if numSStime > 9 then
			local numS1time = math.floor(numSStime / 10);
			local numS2time = numSStime % 10;
			
			sec1:SetImage("time_"..tostring(numS1time));
			sec2:SetImage("time_"..tostring(numS2time));		
		else		
			local numS2time = numSStime % 10;
			
			sec1:SetImage("time_0");
			sec2:SetImage("time_"..tostring(numS2time));		
		end		

end

function GET_DAYOFWEEK_STR(dayOfWeek)
	if dayOfWeek == -1 then
		return "";
	elseif dayOfWeek == 0 then
		return "SUN";
	elseif dayOfWeek == 1 then
		return "MON";
	elseif dayOfWeek == 2 then
		return "TUE";
	elseif dayOfWeek == 3 then
		return "WED";
	elseif dayOfWeek == 4 then
		return "THU";
	elseif dayOfWeek == 5 then
		return "FRI";
	elseif dayOfWeek == 6 then
		return "SAT";
	end

	return "";
end

function START_TIMER_CTRLSET_BY_SEC(ctrlSet, remainSec)

	ctrlSet:SetUserValue("TIMER_START", imcTime.GetAppTime());
	ctrlSet:SetUserValue("REMAIN_SEC", remainSec);

	UPDATE_TIMER_CTRLSET_BY_SEC(ctrlSet);
	ctrlSet:RunUpdateScript("UPDATE_TIMER_CTRLSET_BY_SEC", 0.3, 0, 0, 1);
end

function UPDATE_TIMER_CTRLSET_BY_SEC(ctrlSet)

	local elapsed = imcTime.GetAppTime() - ctrlSet:GetUserIValue("TIMER_START");
	local remainSec = ctrlSet:GetUserIValue("REMAIN_SEC");
	remainSec = remainSec - elapsed;

	if 0 > remainSec then
		local mgameInfo = session.mission.GetMGameInfo();
		if mgameInfo ~= nil and mgameInfo:GetUserValue("ToEndBattle") > 0 then
			ctrlSet:StopUpdateScript("UPDATE_TIMER_CTRLSET_BY_SEC");
			return 0;
		end
	end

	local min, sec = GET_QUEST_MIN_SEC(remainSec);	
	local m1time = GET_CHILD(ctrlSet, "m1time");
	local m2time = GET_CHILD(ctrlSet, "m2time");
	local s1time = GET_CHILD(ctrlSet, "s1time");
	local s2time = GET_CHILD(ctrlSet, "s2time");

	SET_QUESTINFO_TIME_TO_PIC(min, sec, m1time, m2time, s1time, s2time);			
	return 1;

end


