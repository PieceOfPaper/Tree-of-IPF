function MINIMIZED_GODPROTECTION_BUTTON_ON_INIT(addon, frame)
	frame:ShowWindow(0);
	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_START', 'MINIMIZED_GODPROTECTION_START');	
	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_END', 'MINIMIZED_GODPROTECTION_END');
end

function MINIMIZED_GODPROTECTION_START(frame)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
    if IS_GODPROTECTION_MAP(mapCls) == false then
        frame:ShowWindow(0);
    else
    	frame:ShowWindow(1);
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	local font = frame:GetUserConfig("TIME_FONT_NOMAL");
	time:SetFormat(font.."%s:%s");
	time:ReleaseBlink();

	-- 남은 시간 설정
	MINIMIZED_GODPROTECTION_REMAIN_TIME(frame)
end

function MINIMIZED_GODPROTECTION_END(frame)
	frame:ShowWindow(0);
end

function MINIMIZED_GODPROTECTION_REMAIN_TIME(frame)
	local endtime = session.GodProtection.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	time:RunUpdateScript("UPDATE_MINIMIZED_GODPROTECTION_REMAIN_TIME", 0.1);
	UPDATE_MINIMIZED_GODPROTECTION_TIME_CTRL(time, remainsec)
end

function UPDATE_MINIMIZED_GODPROTECTION_REMAIN_TIME(ctrl)
	local endtime = session.GodProtection.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end

	UPDATE_MINIMIZED_GODPROTECTION_TIME_CTRL(ctrl, remainsec)	

	return 1;
end

function UPDATE_MINIMIZED_GODPROTECTION_TIME_CTRL(ctrl, remainsec)
	local min = math.floor(remainsec/60)
	local sec = math.floor(remainsec%60)

	ctrl:SetTextByKey('min', min);
	ctrl:SetTextByKey('sec', sec);

end

function MINIMIZED_GODPROTECTION_BUTTON_CLICK(parent, ctrl)
	GODPROTECTION_DO_OPEN()
end

function IS_GODPROTECTION_MAP(mapCls)
	if mapCls == nil then
		return false;
	end

	local mapName = mapCls.ClassName;	
	if mapName == 'c_fedimian' or mapName == 'c_Klaipe' or mapName == 'c_orsha' or mapName == 'c_barber_dress' then
		return true;
	end

	return false;
end