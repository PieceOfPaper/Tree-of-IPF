
function CELLSELECT_ON_INIT(addon, frame)
	addon:RegisterMsg('CELL_CASTING_START', 'ON_CELL_CASTING_START');
	addon:RegisterMsg('CELL_REMAIN_COUNT', 'ON_CELL_REMAIN_COUNT');	addon:RegisterMsg('DYNAMIC_CAST_END', 'ON_CELL_CAST_END');	
endfunction ON_CELL_CAST_END(frame, msg, str, arg)	frame:ShowWindow(0);endfunction ON_CELL_CASTING_START(frame, msg, str, maxTime)	local timeGauge = GET_CHILD(frame, "timeGauge", "ui::CGauge");	timeGauge:SetPoint(0, 100);	timeGauge:SetPointWithTime(100, maxTime);	frame:ShowWindow(1);	frame:SetDuration(maxTime);endfunction ON_CELL_REMAIN_COUNT(frame, msg, str, cellCount)	local cellText = GET_CHILD(frame, "cellText", "ui::CRichText");	cellText:SetTextByKey("remainCell", cellCount);end


