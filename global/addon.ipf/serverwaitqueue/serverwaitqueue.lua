

function ENTER_SERVER_WAIT_QUEUE(count)

	local frame = ui.GetFrame("serverwaitqueue");
	if count == -1 then
		frame:ShowWindow(0);
		return;
	end

	local currentCount = frame:GetChild("currentCount");
	currentCount:SetTextByKey("count", count);
	frame:ShowWindow(1);

end



function CANCEL_SERVER_WAIT_QUEUE()
	barrack.CancelWaitQueue();
end