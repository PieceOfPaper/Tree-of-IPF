function TIME_ON_INIT(addon, frame)

	addon:RegisterMsg('REAL_TIME_UPDATE', 'TIEM_ON_MSG');
end

function TIEM_ON_MSG(frame, msg, argStr, argNum)
	
	if frame:IsVisible() == 1 then
		local textObject = frame:GetChild("timeText");
		local timeRichText = tolua.cast(textObject,"ui::CRichText");
		local textObject = frame:GetChild("ampmText");
		local ampmRichText = tolua.cast(textObject,"ui::CRichText");

		local timeText
		local ampmText

		local hourNum = math.floor(argNum / 100)

		if hourNum >= 12 then
			hourNum = math.floor(hourNum - 12)
			
			if hourNum == 0 then
				hourNum = 12
			end
			ampmText = "pm"
		else
			if hourNum == 0 then
				hourNum = 12
			end
			ampmText = "am"
		end

		local hour = string.format("%02d", hourNum)
		local minute = string.format("%02d", argNum % 100)

		timeRichText:SetTextByKey("hour", hour);
		timeRichText:SetTextByKey("minute", minute);

		ampmRichText:SetTextByKey("ampm", ampmText);
	end


end