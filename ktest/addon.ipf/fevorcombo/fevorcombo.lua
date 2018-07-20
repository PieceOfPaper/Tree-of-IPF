
function FEVORCOMBO_ON_INIT(addon, frame)
	
	addon:RegisterMsg('MAXFEVERTIME', 'MAXFEVERTIME');		-- Ŭ���� maxFever�����ϰ� �������� �˷���
end

function FEVORCOMBO_OPEN(frame)

	frame:SetDuration(10);
end

function FEVOR_UPDATE_DIGIT_COLOR(frame, cnt, digit1, digit2, digit3)

	local configName = "";
	if cnt <= 60 then
		configName = "Color_0_9";
	elseif cnt <= 120 then
		configName = "Color_10_29";
	elseif cnt <= 180 then
		configName = "Color_30_49";
	elseif cnt <= 240 then
		configName = "Color_50_99";
	else
		configName = "Color_100";
	end
	
	local colorTone = frame:GetUserConfig(configName);
	
	digit1:SetColorTone(colorTone);
	digit2:SetColorTone(colorTone);
	digit3:SetColorTone(colorTone);

end

function GET_FEVORCOMBO_COLOR_STYLE(cnt)

	if cnt <= 60 then
		return 0;
	elseif cnt <= 120 then
		return 1;
	elseif cnt <= 180 then
		return 2;
	elseif cnt <= 240 then
		return 3;
	end
	
	return 4;

end

function SET_FEVORCOMBO_CNT(cnt, time, maxCnt)

	local frame = ui.GetFrame("fevorcombo");
	local feverPic = frame:GetChild("feverPic");
	if cnt > maxCnt then
		if feverPic:IsVisible() then
			feverPic:PlayEvent("COMBO");
end
		return;
	end
	
	frame:SetUserValue("CNT", cnt);

	if cnt < 1 then
		frame:ShowWindow(0);
		return;
	else
		frame:ShowWindow(1);
	end
	
	frame:ForceOpen();
	frame:SetDuration(time);
	local hundredDigit = math.floor(cnt / 100);
	local hundredRem = cnt % 100;
	local tenDigit = math.floor(hundredRem / 10);
	local oneDigit = cnt % 10;
	
	local curTime = imcTime.GetDWTime();
	local playEft = 1;	
	if curTime - frame:GetValue() <= 10 then
		playEft = 0;
	end
	
	frame:SetValue(curTime);
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetValue(imcTime.GetDWTime() + time);
	
		
	local digit1 = GET_CHILD(frame, "digit1", "ui::CPicture");
	local digit2 = GET_CHILD(frame, "digit2", "ui::CPicture");
	local digit3 = GET_CHILD(frame, "digit3", "ui::CPicture");
		
	local colStyle  = GET_FEVORCOMBO_COLOR_STYLE(cnt);
	if colStyle ~= frame:GetValue2() then
		FEVOR_UPDATE_DIGIT_COLOR(frame, cnt, digit1, digit2, digit3);
		frame:SetValue2(colStyle);
	end
	
	if hundredDigit > 0 then
		FEVORCOMBO_DIGIT_SET(digit1, hundredDigit, playEft);
		FEVORCOMBO_DIGIT_SET(digit2, tenDigit, playEft);
	else
		if tenDigit > 0 then
			FEVORCOMBO_DIGIT_SET(digit2, tenDigit, playEft);
		else
			digit2:ShowWindow(0);
		end
		digit1:ShowWindow(0);
	end
	
	FEVORCOMBO_DIGIT_SET(digit3, oneDigit, playEft);	
	if cnt >= 1 then
		FEVORTIME_GUAGE_START(frame, 5);
	else
		frame:GetChild("combo_gauge_right"):ShowWindow(0);
		frame:GetChild("fever_gauge"):ShowWindow(0);
	end

	local comboPic = frame:GetChild("comboPic");
	if cnt >= maxCnt then
		feverPic:ShowWindow(1);
	
		comboPic:ShowWindow(0);		
		digit1:ShowWindow(0);
		digit2:ShowWindow(0);
		digit3:ShowWindow(0);
	else
		comboPic:ShowWindow(1);
		comboPic:PlayEvent("COMBO");

		feverPic:ShowWindow(0);
	end
end

function MAXFEVERTIME()
	local frame = ui.GetFrame("fevorcombo");
	frame:SetDuration(10);
	FEVORTIME_GUAGE_START(frame, 10);
end

function FEVORCOMBO_DIGIT_SET(digitCtrl, cnt, playEft)
	digitCtrl:SetImage(tostring(cnt) .. '_1');
	if playEft == 1 then
		digitCtrl:PlayEvent("COMBO_C");
	end
	digitCtrl:ShowWindow(1);
end

function FEVORTIME_GUAGE_START(frame, time)

	local comboGauge = GET_CHILD(frame, "combo_gauge_right", "ui::CGauge");
	local feverGauge = GET_CHILD(frame, "fever_gauge", "ui::CGauge");
	
	if time > 5 then
		feverGauge:SetPoint(time, time);
		feverGauge:SetPointWithTime(0, time);
	else
		comboGauge:SetPoint(time, time);
		comboGauge:SetPointWithTime(0, time);
	end

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();
	timer:SetUpdateScript("UPDATE_FEVOR_TIME");
	timer:Start(0.01, 0);
	frame:SetValue(time);

	local animpic = GET_CHILD_RECURSIVELY(frame, "animpic");
	if time > 5 then
		feverGauge:ShowWindow(1);		
		comboGauge:ShowWindow(0);
		
		animpic:ShowWindow(1);
		animpic:SetUserValue("LINKED_GAUGE", 0);
		LINK_OBJ_TO_GAUGE(frame, animpic, feverGauge, 0);
	else
		comboGauge:ShowWindow(1);		
		feverGauge:ShowWindow(0);
		animpic:ShowWindow(0);
	end
end

function UPDATE_FEVOR_TIME(frame, timer, str, num, time)
	
	local totalTime = frame:GetValue();
	if time >= totalTime then
		frame:ShowWindow(0);
		timer:Stop();
		return;
	end
end
