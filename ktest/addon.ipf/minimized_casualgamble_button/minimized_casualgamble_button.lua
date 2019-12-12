function MINIMIZED_CASUALGAMBLE_BUTTON_ON_INIT(addon, frame)
	frame:ShowWindow(0);

	addon:RegisterMsg('CASUAL_GAMBLE_START', 'MINIMIZED_CASUAL_GAMBLE_START');	
	addon:RegisterMsg('CASUAL_GAMBLE_END', 'MINIMIZED_CASUAL_GAMBLE_END');
end

function MINIMIZED_CASUAL_GAMBLE_START(frame)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);
	frame:ShowWindow(1);
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	local font = frame:GetUserConfig("TIME_FONT_NOMAL");
	time:SetFormat(font.."%s:%s");
	time:ReleaseBlink();

	-- 남은 시간 설정
	MINIMIZED_CASUAL_GAMBLE_REMAIN_TIME(frame)
end

function MINIMIZED_CASUAL_GAMBLE_END(frame)
	frame:ShowWindow(0);
end

function MINIMIZED_CASUAL_GAMBLE_REMAIN_TIME(frame)
    local endtime = session.Casual_Gamble.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	time:RunUpdateScript("UPDATE_MINIMIZED_CASUAL_GAMBLE_REMAIN_TIME", 0.1);
	UPDATE_MINIMIZED_CASUAL_GAMBLE_REMAIN_TIME(time)
end

function UPDATE_MINIMIZED_CASUAL_GAMBLE_REMAIN_TIME(ctrl)
	local endtime = session.Casual_Gamble.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end

	local min = math.floor(remainsec/60)
	local sec = math.floor(remainsec%60)

	ctrl:SetTextByKey('min', min);
	ctrl:SetTextByKey('sec', sec);

	return 1;
end

function MINIMIZED_CASUAL_GAMBLE_BUTTON_CLICK(parent, ctrl)
	CASUAL_GAMBLE_DO_OPEN()
end