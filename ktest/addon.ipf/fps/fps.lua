function FPS_ON_INIT(addon, frame)

	addon:RegisterMsg('FPS_UPDATE', 'FPS_ON_MSG');
	addon:RegisterMsg('SERVER_FPS', 'FPS_ON_MSG');

	local textObject = frame:GetChild('serverfpstext');
	textObject:ShowWindow(0);
end

function FPS_ON_MSG(frame, msg, argStr, argNum)

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
