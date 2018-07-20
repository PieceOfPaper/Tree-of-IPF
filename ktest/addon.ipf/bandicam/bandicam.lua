function BANDICAM_ON_INIT(addon, frame)
	
	addon:RegisterMsg("BANDI_CAM", "ON_BANDI_CAM");

	bandi.ShowCapture();
end

function ON_BANDI_CAM(frame, msg, argStr, argNum)

	if USE_SHOW_BANDI_CAM_TEXT == 0 then

		if argNum == 1 then
			print('BANDI_CAM start ' .. argStr)
		else
			print('BANDI_CAM end ')
		end

		argNum = 0;
	end

	if argNum == 1.0 then
		local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("PROCESS_BANDI_TXT");
		timer:Start(0.01);
		frame:ShowWindow(1);
		frame:SetSValue(argStr);
	else
		local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
		timer:Stop();
		frame:ShowWindow(0);
		frame:SetSValue('None');
		frame:GetChild("bandi"):SetTextByKey("bandi", "");
	end

end

function PROCESS_BANDI_TXT(frame, timer, str, num, totalTime)

	local sec = math.floor(bandi.GetCaptureSec() / 1000);
	local size = bandi.GetCaptureSize() / (1024 * 1024);
	local timeTxt = GET_TIME_TXT(sec);
	local bandiTxt = "{a @OPEN_AVI}" .. ScpArgMsg("Auto_DongyeongSangKaepChyeo:(") .. timeTxt .."){nl}";
	bandiTxt = bandiTxt .. string.format("%.2f MB", size);
	frame:GetChild("bandi"):SetTextByKey("bandi", bandiTxt);

end

function OPEN_AVI(frame)

	local fullPath = frame:GetSValue();
	debug.OpenFileDir(frame:GetSValue());
	
end


