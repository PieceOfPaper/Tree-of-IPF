function CHALLENGE_MODE_ON_INIT(addon, frame)
	addon:RegisterMsg("UI_CHALLENGE_MODE_TOTAL_KILL_COUNT", "ON_CHALLENGE_MODE_TOTAL_KILL_COUNT");
end

function DIALOG_ACCEPT_CHALLENGE_MODE(handle)
	ui.MsgBox(ClMsg("AcceptChallengeMode"), "ACCEPT_CHALLENGE_MODE(" .. tostring(handle) .. ")", "None");
end

function DIALOG_ACCEPT_CHALLENGE_MODE_RE_JOIN(handle)
	ui.MsgBox(ClMsg("AcceptChallengeMode_ReJoin"), "ACCEPT_CHALLENGE_MODE(" .. tostring(handle) .. ")", "None");
end

function ACCEPT_CHALLENGE_MODE(handle)
	packet.AcceptChallengeMode(handle);
end

function DIALOG_ACCEPT_NEXT_LEVEL_CHALLENGE_MODE(handle)
	ui.MsgBox(ClMsg("AcceptNextLevelChallengeMode"), "ACCEPT_NEXT_LEVEL_CHALLENGE_MODE(" .. tostring(handle) .. ")", "None");
end

function ACCEPT_NEXT_LEVEL_CHALLENGE_MODE(handle)
	packet.AcceptNextLevelChallengeMode(handle);
end

function DIALOG_ACCEPT_STOP_LEVEL_CHALLENGE_MODE(handle)
	ui.MsgBox(ClMsg("AcceptStopLevelChallengeMode"), "ACCEPT_STOP_LEVEL_CHALLENGE_MODE(" .. tostring(handle) .. ")", "None");
end

function DIALOG_COMPLETE_CHALLENGE_MODE(handle)
	ui.MsgBox(ClMsg("CompleteChallengeMode"), "ACCEPT_STOP_LEVEL_CHALLENGE_MODE(" .. tostring(handle) .. ")", "None");
end

function ACCEPT_STOP_LEVEL_CHALLENGE_MODE(handle)
	packet.AcceptStopLevelChallengeMode(handle);
end

function ON_CHALLENGE_MODE_TOTAL_KILL_COUNT(frame, msg, str, arg)
	local msgList = StringSplit(str, '#');
	if #msgList < 1 then
		return;
	end

	if msgList[1] == "SHOW" then
		ui.OpenFrame("challenge_mode");
		frame:ShowWindow(1);
		
		local level = tonumber(msgList[2]);
		local progressGauge = GET_CHILD(frame, "challenge_gauge_lv", "ui::CGauge");
		progressGauge:SetSkinName("challenge_gauge_lv1");
		progressGauge:SetMaxPointWithTime(0, 1, 0.1, 0.5);
		
		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture");
		picMax:ShowWindow(0);
		picMax:StopUpdateScript("MAX_PICTURE_FADEINOUT");
		
		local picLevel = GET_CHILD(frame, "challenge_pic_lv", "ui::CPicture");
		picLevel:SetImage("challenge_gauge_no" .. level);

		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture");
		textTimer:SetTextByKey('time', "00:00");

	elseif msgList[1] == "HIDE" then
		frame:ShowWindow(0);
		
		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture");
		picMax:ShowWindow(0);
		picMax:StopUpdateScript("MAX_PICTURE_FADEINOUT");
		
		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture");
		textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER");

	elseif msgList[1] == "GAUGERESET" then
		frame:ShowWindow(1);

		local level = tonumber(msgList[2]);
		local progressGauge = GET_CHILD(frame, "challenge_gauge_lv", "ui::CGauge");
		progressGauge:SetSkinName("challenge_gauge_lv" .. math.floor((level - 1) / 2) + 1);
		progressGauge:SetMaxPointWithTime(0, 1, 0.1, 0.5);

		local picLevel = GET_CHILD(frame, "challenge_pic_lv", "ui::CPicture");
		picLevel:SetImage("challenge_gauge_no" .. level);
		
		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture");
		picMax:ShowWindow(0);
		picMax:StopUpdateScript("MAX_PICTURE_FADEINOUT");

		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture");
		textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER");
	elseif msgList[1] == "START_CHALLENGE_TIMER" then
		frame:ShowWindow(1);

		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture");
		textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER");
		textTimer:RunUpdateScript("CHALLENGE_MODE_TIMER");

		textTimer:SetUserValue("CHALLENGE_MODE_START_TIME", tostring(imcTime.GetAppTimeMS()));
		textTimer:SetUserValue("CHALLENGE_MODE_LIMIT_TIME", msgList[2]);
	elseif msgList[1] == "REFRESH" then
		frame:ShowWindow(1);

		local killCount = tonumber(msgList[2]);
		local targetKillCount = tonumber(msgList[3]);
		local progressGauge = GET_CHILD(frame, "challenge_gauge_lv", "ui::CGauge");
		progressGauge:SetMaxPointWithTime(killCount, targetKillCount, 0.1, 0.5);
		progressGauge:ShowWindow(1);
	elseif msgList[1] == "MONKILLMAX" then
		frame:ShowWindow(1);
		
		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture");
		picMax:ShowWindow(1);
		picMax:RunUpdateScript("MAX_PICTURE_FADEINOUT", 0.01);
	end
end

function MAX_PICTURE_FADEINOUT(picMax)
	local alpha = (math.sin(imcTime.GetAppTime() * 5) * 0.5 + 0.5) * 100;

	picMax:SetAlpha(alpha);

	return 1;
end

function CHALLENGE_MODE_TIMER(textTimer)
	local startTime = textTimer:GetUserValue("CHALLENGE_MODE_START_TIME");
	if startTime == nil then
		return 0;
	end

	local limitTime = textTimer:GetUserValue("CHALLENGE_MODE_LIMIT_TIME");
	if limitTime == nil then
		return 0;
	end

	limitTime = limitTime / 1000;

	local nowTime = imcTime.GetAppTimeMS();

	local diffTime = (nowTime - startTime) / 1000;
	local remainTime = tonumber(limitTime) - diffTime;
	if remainTime < 0 then
		textTimer:SetTextByKey('time', "00:00");
		return 0;
	end

	local remainMin = math.floor(remainTime / 60);
	local remainSec = remainTime % 60;
	local remainTimeStr = string.format('%d:%02d', remainMin, remainSec);
	textTimer:SetTextByKey('time', remainTimeStr);
	return 1;
end

function UPDATE_CHALLENGE_MODE_MINIMAP_MARK(x, y, z, isAlive)
	if isAlive == 1 then
		session.minimap.AddIconInfo("ChallengeModePortalMark", "trasuremapmark", x, y, z, ClMsg("ChallengeModePortalMark"), true, nil, 1.5);
	else
		session.minimap.RemoveIconInfo("ChallengeModePortalMark");
	end
end