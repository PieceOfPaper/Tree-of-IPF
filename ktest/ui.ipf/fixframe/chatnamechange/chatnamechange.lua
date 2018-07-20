function CHATNAMECHANGE_ON_INIT(addon, frame)

end

function CHATNAMECHANGE_ON_MSG(frame, msg, argStr, argNum)

end

function CHATNAMECHANGE_ON_LOAD(frame, obj, argStr, argNum)

end

function CLEAR_CHATNAME_INPUT(frame, obj, argStr, argNum)	
	local editctrl = frame:GetChild('input');
	editctrl:SetText('');
end

function CHANGE_CHAT_NAME(frame, obj, argStr, argNum)
	local editctrl = frame:GetChild('input');
	local chatName = editctrl:GetText();
	
	if chatName ~= '' then
		local chatFrame = ui.GetFrame(argStr);
		local chatTabCtrl = chatFrame:GetChild('chatbox');
		tolua.cast(chatTabCtrl, "ui::CTabControl");
		chatTabCtrl:SetSelectedName(chatName);
		ui.CloseFrame('chatnamechange');
	end
end

