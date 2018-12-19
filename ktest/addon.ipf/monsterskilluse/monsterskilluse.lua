
function MONSTERSKILLUSE_ON_INIT(addon, frame)

	
end

function MON_PC_SKILL_BALLOON(title, handle, castTimeMS, isBoss, changeColor)
	local frame = nil;
	local offsetY;
	if isBoss == 0 then
		frame = ui.CreateNewFrame("monsterskilluse_normalmon", "MON_PCSKILL_" .. handle);
		if changeColor == 1 then
			offsetY= -50;			
		else
			offsetY = -100;	
		end  
	else
		frame = ui.CreateNewFrame("monsterskilluse", "MON_PCSKILL_" .. handle);
		offsetY = -200;
	end

	if frame == nil then
		return nil;
	end

	local castTimeSec = castTimeMS * 0.001;
	
	local text = frame:GetChild("text");
	if changeColor ~= 0 then
		text:SetTextByKey("value", '{@st41_yellow}'..title);
	else
		text:SetTextByKey("value", title);
	end
	local gauge = frame:GetChild("gauge");
	if gauge ~= nil then
		AUTO_CAST(gauge);
		gauge:SetPoint(0, 100);
		gauge:SetPointWithTime(100, castTimeSec);
		local animpic = GET_CHILD_RECURSIVELY(frame, "animpic");
		animpic:SetUserValue("LINKED_GAUGE", 0);
		LINK_OBJ_TO_GAUGE(frame, animpic, gauge, 1);
	end

	frame:ShowWindow(1);
	if castTimeSec <= 0 then
		castTimeSec =1;
	end

	frame:SetDuration(castTimeSec);
	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, offsetY, 3, 1);

end

function MONSTER_SAY_BALLOON(handle, msg, isBoss, showTime)

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

	local text = frame:GetChild("text");
	text:SetTextByKey("value", title);
	local gauge = frame:GetChild("gauge");
	if gauge ~= nil then
		AUTO_CAST(gauge);
		gauge:SetPoint(0, 100);
		gauge:SetPointWithTime(100, showTime);
	end

	frame:ShowWindow(1);
	frame:SetDuration(showTime);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, offsetY, 3, 1);

end