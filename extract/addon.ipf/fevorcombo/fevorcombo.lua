
function FEVORCOMBO_ON_INIT(addon, frame)
	
	addon:RegisterMsg('MAXFEVERTIME', 'MAXFEVERTIME');		-- 클라에서 maxFever계산안하고 서버에서 알려줌
end

function FEVORCOMBO_OPEN(frame)

	frame:SetDuration(10);

end

function FEVOR_UPDATE_DIGIT_COLOR(frame, cnt, digit1, digit2, digit3)

	local configName = "";
	if cnt <= 4 then
		configName = "Color_0_9";
	elseif cnt <= 6 then
		configName = "Color_10_29";
	elseif cnt <= 8 then
		configName = "Color_30_49";
	elseif cnt <= 10 then
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

	if cnt <= 4 then
		return 0;
	elseif cnt <= 6 then
		return 1;
	elseif cnt <= 8 then
		return 2;
	elseif cnt <= 10 then
		return 3;
	end
	
	return 4;

end

function FEVORCOMBO_EX_RECODE(comboCount, comboTime, maxComboCount)

	if comboCount > maxComboCount then
		return;
	end

	local frame = ui.GetFrame("fevorcombo");
	local digitFont = frame:GetUserConfig("Ex_DigitFont");
	local xFont = frame:GetUserConfig("Ex_XFont");
	local exComboFont = frame:GetUserConfig("Ex_TextFont");
	local txt = "";
		
	local pushTxt = string.format("%s%d{/}%s X {/}%s%s{/}", digitFont, comboCount, xFont, exComboFont, txt);
	FEVORCOMBO_PUSH_EXRECODE(frame, comboCount, pushTxt, comboTime);
	

end

function FEVORCOMBO_PUSH_EXRECODE(frame, comboCount, pushTxt, comboTime)

	local exrecode = frame:GetChild("exrecode");
	exrecode:ShowWindow(1);

	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	
	timer:SetValue(imcTime.GetDWTime() + comboTime);
	
	timer:SetUpdateScript("PROCESS_FEVORCOMBO_EXRECODE");
	timer:Start(0.01);

	exrecode:SetValue(comboCount);
	
	local ex1 = exrecode:GetChild("ex1");	
	ex1:SetText(pushTxt);

end

function PROCESS_FEVORCOMBO_EXRECODE(frame, timer)

	local exrecode = frame:GetChild("exrecode");
	if timer:GetValue() == 0 then
		return;
	end
	
	if imcTime.GetDWTime() >= timer:GetValue() then
		exrecode:ShowWindow(0);
		timer:SetValue(0);
		timer:Stop();
		frame:ForceOpen();
	end	
	
end

function SET_FEVORCOMBO_CNT(cnt, time, maxCnt)

	if cnt > maxCnt then
		return;
	end

	local frame = ui.GetFrame("fevorcombo");
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
	
	digit3:SetImage(tostring(oneDigit));
	if playEft == 1 then
		digit3:PlayEvent("ITEM_GET");
	end

	local text = frame:GetChild("text");
	if text:GetCommandCount() <= 1 then
		--frame:GetChild("text"):PlayEvent("COMBO_TEXT");
	end
	
	--local curcombo = frame:GetChild("curcombo");
	local expBonus = frame:GetChild("expBonus");

	if cnt >= 1 then
		-- 콤보당 공증 5		
		--local setStr = string.format("%d", cnt*5);
		--expBonus:SetTextByKey("bonusexp", setStr);
		expBonus:ShowWindow(0);

		--curcombo:SetTextByKey("comboCnt", cnt * 5);
		FEVORTIME_GUAGE_START(frame, 5);
		--curcombo:ShowWindow(1);

	else
		frame:GetChild("combo_gauge_right"):ShowWindow(0);
		--frame:GetChild("combo_gauge_left"):ShowWindow(0);
		--curcombo:ShowWindow(0);
		expBonus:ShowWindow(0);
	end
end

function MAXFEVERTIME()
	-- maxCombo일때는 게이지 10초로 셋팅
	local frame = ui.GetFrame("fevorcombo");
	FEVORTIME_GUAGE_START(frame, 10);
end

function FEVORCOMBO_DIGIT_SET(digitCtrl, cnt, playEft)
	digitCtrl:SetImage(tostring(cnt));
	if playEft == 1 then
		digitCtrl:PlayEvent("ITEM_GET");
	end
	digitCtrl:ShowWindow(1);
end

function FEVORTIME_GUAGE_START(frame, time)

	local rightGauge = GET_CHILD(frame, "combo_gauge_right", "ui::CGauge");
	rightGauge:ShowWindow(1);
	
	rightGauge:SetPoint(time, time);
	rightGauge:SetPointWithTime(0, time);

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_FEVOR_TIME");
	timer:Start(0.01, 0);
	frame:SetValue(time);

end

function UPDATE_FEVOR_TIME(frame, timer, str, num, time)
	
	local totalTime = frame:GetValue();
	if time >= totalTime then
		frame:ShowWindow(0);
		timer:Stop();
		return;
	end


	local remainTime = totalTime - time;
	local timeframe = frame:GetChild("combotime");
	if remainTime <=  10 then
		remainTime = math.floor(remainTime);
		remainTime = remainTime + 1;
		if remainTime > totalTime then
			remainTime = totalTime;
		end
		timeframe:SetTextByKey("curTime", remainTime);
		timeframe:ShowWindow(1);
	else
		timeframe:ShowWindow(0);
	end
end
