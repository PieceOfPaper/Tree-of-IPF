
function MONSTERSKILLUSE_ON_INIT(addon, frame)

	
end

function MON_PC_SKILL_BALLOON(title, handle, castTimeMS, isBoss)

	local frame = nil;
	local offsetY;
	if isBoss == 0 then
		frame = ui.CreateNewFrame("monsterskilluse_normalmon", "MON_PCSKILL_" .. handle);
		offsetY = -100;
	else
		frame = ui.CreateNewFrame("monsterskilluse", "MON_PCSKILL_" .. handle);
		offsetY = -200;
	end

	if frame == nil then
		return nil;
	end

	local castTimeSec = castTimeMS * 0.001;

	local text = frame:GetChild("text");
	text:SetTextByKey("value", title);
	local gauge = frame:GetChild("gauge");
	if gauge ~= nil then
		AUTO_CAST(gauge);
		gauge:SetPoint(0, 100);
		gauge:SetPointWithTime(100, castTimeSec);
	end

	frame:ShowWindow(1);
	frame:SetDuration(castTimeSec);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, offsetY, 3, 1);

end

