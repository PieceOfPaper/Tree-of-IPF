function PLAYTIME_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START", "PLAYTIME_GAME_START");
end

function PLAYTIME_GAME_START(frame, msg, argStr, argNum)

	frame:ShowWindow(0);
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");

	local pc = GetMyPCObject();
	local curTime = pc.PlayTime;
	timer:SetValue(curTime);	
	timer:SetUpdateScript("PROCESS_PLAYTIME");
	timer:Start(0.01);
	
end

function GET_D_H_M(sec)

	local d = math.floor(sec / 86400);
	sec = sec - d * 86400;
	local h = math.floor(sec / 3600);
	sec = sec - h * 3600;
	local min = math.floor(sec / 60);
	return h, d, min;

end

function PROCESS_PLAYTIME(frame, timer, str, num, totalTime)

	local startTime = timer:GetValue();
	local totalTime = startTime + totalTime;
	local fm = GET_TIME_TXT_DHM(totalTime);
	frame:GetChild("txt"):SetTextByKey("time", fm);

end

