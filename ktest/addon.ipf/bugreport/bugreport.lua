function BUGREPORT_ON_INIT(addon, frame)

	frame = ui.GetFrame("bugreport");
	if config.GetServiceNation() == "KOR" then
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end	

end

function REPORT_REPLAY(frame)

	ui.OpenFrame("bugreportbox");

end

function EXEC_REPORT_REPLAY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local txt = frame:GetChild("inputtext"):GetText();
	local ret = debug.SendReplayReport(txt);
	if ret == true then
		ui.MsgBox(ClMsg("TransferSuccess"));
	else
		ui.MsgBox(ClMsg("TransferFailed"));
	end

	frame:ShowWindow(0);
end

