function ALRAMNOTICE_ON_INIT(addon, frame)
	addon:RegisterMsg("HELP_MSG_ADD", "ON_ALRAMNOTICE_MSG");
	addon:RegisterMsg("GAME_START", "ON_ALRAMNOTICE_MSG");
end

function ON_ALRAMNOTICE_MSG(frame, msg, argStr, argNum)
	if msg == "HELP_MSG_ADD" then
		ALRAMNOTICE_ADD_HELP(frame, argNum);
	elseif msg == "GAME_START" then
		ALRAMNOTICE_LIST_HELP(frame);
	end
end

function ALRAMNOTICE_ADD_HELP(frame, argNum)
	local helpNoticeCtrl = GET_CHILD(frame, "help", "ui::CPicture");
	helpNoticeCtrl:ShowWindow(1);
	helpNoticeCtrl:SetEventScript(ui.LBUTTONUP, "HELP_ALRAMNOTICE_LBTNUP");
	helpNoticeCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, argNum);

	helpNoticeCtrl:Emphasize("helpicon_ef", 10.0, 0.3, "FFFFFFFF");

end

function ALRAMNOTICE_LIST_HELP(frame)
--	local helpCount = session.GetHelpVecCount();
--	for i=0, helpCount -1 do
--		local isHelpRead = session.GetHelpReadByIndex(i);
--		if isHelpRead == 0 then
--			local helpType = session.GetHelpTypeByIndex(i);
--
--			local helpNoticeCtrl = GET_CHILD(frame, "help", "ui::CPicture");
--			helpNoticeCtrl:ShowWindow(1);
--			helpNoticeCtrl:SetEventScript(ui.LBUTTONUP, "HELP_ALRAMNOTICE_LBTNUP");
--			helpNoticeCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, helpType);
--			helpNoticeCtrl:Emphasize("helpicon_ef", 10.0, 0.3, "FFFFFFFF");
--		end
--	end
end

function HELP_ALRAMNOTICE_LBTNUP(frame, ctrl, argStr, argNum)
	ctrl:ShowWindow(0);
	frame:Invalidate();

	packet.ReqHelpReadType(argNum);
end