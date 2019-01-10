function FPS_ON_INIT(addon, frame)

	addon:RegisterMsg('FPS_UPDATE', 'FPS_ON_MSG');
	addon:RegisterMsg('SERVER_FPS', 'FPS_ON_MSG');

	local textObject = frame:GetChild('serverfpstext');
	textObject:ShowWindow(0);

	local memoryTimer = GET_CHILD_RECURSIVELY(frame, "memoryTimer", "ui::CAddOnTimer");
	memoryTimer:SetUpdateScript("UPDATE_MEMORY_INFO");
	memoryTimer:Start(1);
end

function FPS_ON_MSG(frame, msg, argStr, argNum)
	local showFPS = config.GetXMLConfig("ShowPerformanceValue")
	local fpsFrame = ui.GetFrame("fps")
	fpsFrame:ShowWindow(showFPS)
	local perfType = config.GetAutoAdjustLowLevel()
	local nowLowOptionValue = config.GetUseLowOption();

	local nowLowOptionValueprt = "Low"
	if nowLowOptionValue == 1 then
		nowLowOptionValueprt = "Low"
	else
		nowLowOptionValueprt = "Not Low"
	end

	if perfType == 0 then

		if nowLowOptionValue == 0 then
			graphic.EnableLowOption(1);
		end

	elseif perfType == 1 then

		if argNum < 20 then
			if nowLowOptionValue == 0 then
				graphic.EnableLowOption(1);
			end
		elseif argNum > 40 then
			if nowLowOptionValue == 1 then
				graphic.EnableLowOption(0);
			end
		end

	elseif perfType == 2 then
		
		if nowLowOptionValue == 1 then
			graphic.EnableLowOption(0);
		end

	end

	if msg == 'FPS_UPDATE' then

		if frame:IsVisible() == 1 then
			local textObject = frame:GetChild('fpstext');
			local fpsRichText = tolua.cast(textObject,"ui::CRichText");

			local text = '{#ff9900}{s16}{ol}FPS : ' .. argStr;
			fpsRichText:SetText(text);
		end

	elseif msg == 'SERVER_FPS' then

		local textObject = frame:GetChild('serverfpstext');
		local fpsRichText = tolua.cast(textObject,"ui::CRichText");

		local text = '{#ff9900}{s16}{ol}SERVER FPS : ' .. argNum;
		fpsRichText:SetText(text);
		fpsRichText:ShowWindow(1);

	end
end

function UPDATE_MEMORY_INFO(frame)
	frame = ui.GetFrame('fps')
	if frame == nil or frame:IsVisible() == 0 then
		return
	end

	imcperf.UpdateMemoryInfo();
	local availableVirtualMemory = imcperf.GetAvailableVirtualMemoryMB();
	local availablePageFile = imcperf.GetAvailablePageFileMB();

	-- 페이징 파일과 가상메모리중 작은걸 기준으로 한다.
	local remainMemory = availableVirtualMemory;	
	if remainMemory > availablePageFile then
		remainMemory = availablePageFile;
	end
	
	remainMemory = remainMemory - 200; -- 200mb 정도를 OS에서 사용하므로 제외함
	if remainMemory < 0 then
		remainMemory = 0;
	end
	
	local imgRed = "{img memory_1 20 20}"
	local imgYellow = "{img memory_2 20 20}"
	local imgGreen = "{img memory_3 20 20}"

	local imgList = {
		first = imgYellow,
		second = imgYellow,
		third = imgYellow,
	}

	if remainMemory >= 1300 then
		imgList.first = imgGreen;
		imgList.second = imgGreen;
		imgList.third = imgGreen;
	elseif remainMemory >= 1100 then
		imgList.first = imgYellow;
		imgList.second = imgGreen;
		imgList.third = imgGreen;
	elseif remainMemory >= 750 then
		imgList.first = imgYellow;
		imgList.second = imgYellow;
		imgList.third = imgGreen;
	elseif remainMemory >= 550 then
		imgList.first = imgYellow;
		imgList.second = imgYellow;
		imgList.third = imgYellow;
	elseif remainMemory >= 350 then
		imgList.first = imgRed;
		imgList.second = imgYellow;
		imgList.third = imgYellow;
	elseif remainMemory >= 150 then
		imgList.first = imgRed;
		imgList.second = imgRed;
		imgList.third = imgYellow;
	else -- 150 미만
		imgList.first = imgRed;
		imgList.second = imgRed;
		imgList.third = imgRed;
	end

	
	local textObject = frame:GetChild('memoryText');
	local memoryText = tolua.cast(textObject,"ui::CRichText");

	local text = '{#ff9900}{s16}{ol}' .. 'Memory : ' .. imgList.first .. imgList.second .. imgList.third

	memoryText:SetText(text);
	memoryText:ShowWindow(1);
  
end

function SHOW_FPS_FRAME(flag)
	local frame = ui.GetFrame("fps")
	if frame == nil or flag == nil then
		return
	end

	frame:ShowWindow(flag)
end