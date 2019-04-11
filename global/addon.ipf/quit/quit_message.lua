-- quit_message.lua

function ON_MEDAL_RECEIVED(frame, msg, name, medalCnt)

	local msg = ScpArgMsg( "Received{Count}MedalFrom{Giver}", "Count", medalCnt, "Giver", name);
	ui.SysMsg("{#FFFF00}" .. msg);

	local sysframe = ui.GetFrame("sysmenu");
	local btn = sysframe:GetChild("status");
	local ix, iy = GET_UI_FORCE_POS(btn);
	local x = ui.GetClientInitialWidth() / 2;
	local y = ui.GetClientInitialHeight() / 2;
	UI_FORCE("inv_notify", x, y, ix, iy, 0.0, "medal");	
	

end

function ON_MEDAL_PRESENTED(frame, msg, name, medalCnt)

	local msg = ScpArgMsg( "Presented{Count}MedalTo{Receiver}", "Count", medalCnt, "Receiver", name);
	ui.SysMsg("{#FFFF00}" .. msg);

end
