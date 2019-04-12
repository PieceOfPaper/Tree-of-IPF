
function ITEMTRANSCENDRESULT_ON_INIT(addon, frame)

endfunction ITEMTRANSCEND_RESULT_CLOSE()	ui.SetHoldUI(false);		local frame = ui.GetFrame("itemtranscend");	local slotTemp = GET_CHILD(frame, "slotTemp");	slotTemp:ShowWindow(0);	slotTemp:StopActiveUIEffect();		local text_itemtranscend = frame:GetChild("text_itemtranscend");	text_itemtranscend:StopColorBlend();	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");	return 1;end