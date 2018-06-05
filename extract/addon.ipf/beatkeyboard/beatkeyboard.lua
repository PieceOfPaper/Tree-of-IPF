
function BEATKEYBOARD_ON_INIT(addon, frame)

	addon:RegisterMsg('BEAT_KEYBOARD', 'ON_BEAT_KEYBOARD');

end

function BEATKEYBOARD_TEST(frame)

	local startAnim = GET_CHILD(frame, 'start_anim', 'ui::CAnimPicture');
	startAnim:PlayAnimation();	

end

function END_BEAT(frame)

	frame:ShowWindow(0);

end

function ON_BEAT_KEYBOARD(frame, msg, beatCnt, second)
	
	if second == 0 then
		END_BEAT(frame);
		return;
	end

	frame:ForceOpen();
	GET_CHILD(frame, 'right', 'ui::CAnimPicture'):PlayAnimation();
	GET_CHILD(frame, 'left', 'ui::CAnimPicture'):PlayAnimation();

	local endTime = imcTime.GetAppTime() + second;
	frame:SetValue(endTime);
	beatCnt = tonumber(beatCnt);
	frame:SetUserValue("BEATCOUNT", beatCnt);
	frame:SetUserValue("LAST_INPUT", -1);
	frame:SetUserValue("CUR_BEAT_CNT", 0);
	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_BEAT_KEYBOARD");
	timer:Start(0.01);

end

function UPDATE_BEAT_KEYBOARD(frame)

	local endTime = frame:GetValue();
	local curTime = imcTime.GetAppTime();
	if curTime > endTime then
		END_BEAT(frame);
		return;
	end

	frame:SetValue(endTime);
	local isBeat = 0;

	local last_input = frame:GetUserIValue("LAST_INPUT");
	local input_l = keyboard.IsKeyDown("LEFT");
	local input_r = keyboard.IsKeyDown("RIGHT");
	
	if input_l == 1 then
		if last_input ~= 1 then
			isBeat = 1;
			frame:SetUserValue("LAST_INPUT", 1);
		end
	elseif input_r == 1 then
		if last_input ~= 2 then
			isBeat = 1;
			frame:SetUserValue("LAST_INPUT", 2);
		end
	end

	if isBeat == 1 then
		local curBeat = frame:GetUserIValue("CUR_BEAT_CNT");
		curBeat = curBeat + 1;
		frame:SetUserValue("CUR_BEAT_CNT", curBeat);
		local maxBeatCnt = frame:GetUserIValue("BEATCOUNT");
		if curBeat >= maxBeatCnt then
			packet.SendKeyboardBeat();
		end
	end

end









