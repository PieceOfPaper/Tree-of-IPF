

function EVENTTIMER_ON_INIT(addon, frame)

	addon:RegisterMsg("EVENT_TXT", "ON_EVENT_TXT");
	
end

function EVENTTIMER_CREATE(addon, frame)

	CREATE_TIMER_CTRLS(frame, 10, 10);
	
end

function ON_EVENT_TXT(frame, msg, str, num)
	
	frame:GetChild("txt"):SetTextByKey("txt", str);

end

function START_EVENT_TIMER(sec, msg)

	local frame = ui.GetFrame("eventtimer");
	TIMER_SET_EVENTTIMER(frame, sec);
	frame:ShowWindow(1);
	frame:SetTextByKey("title", msg);

end

