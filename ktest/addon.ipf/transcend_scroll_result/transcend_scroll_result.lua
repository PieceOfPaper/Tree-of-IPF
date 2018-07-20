

function TRANSCEND_SCROLL_RESULT_ON_INIT(addon, frame)


end

function TRANSCEND_SCROLL_RESULT_CLOSE()
	local frame = ui.GetFrame("transcend_scroll");
	local slot_temp = GET_CHILD(frame, "slot_temp");
	slot_temp:ShowWindow(0);
	slot_temp:StopActiveUIEffect();
	
	frame:StopUpdateScript("TIMEWAIT_STOP_TRANSCEND_SCROLL");
	return 1;
end