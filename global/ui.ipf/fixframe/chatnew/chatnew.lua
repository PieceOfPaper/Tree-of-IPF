function CHATNEW_ON_INIT(addon, frame)

end

function CHATNEW_ON_MSG(frame, msg, argStr, argNum)

end

function CHATNEW_ON_LOAD(frame, obj, argStr, argNum)

end

function CLEAR_CHATNEW(frame, obj, argStr, argNum)	
	local editctrl = frame:GetChild('input');
	editctrl:SetText('');
end

function CHATNEW_NAME(frame, obj, argStr, argNum)
	local editctrl = frame:GetChild('input');
	local chatName = editctrl:GetText();
	
	if chatName ~= '' then
		local chatFrame = ui.GetFrame(argStr);
		local chatTabCtrl = chatFrame:GetChild('chatbox');
		tolua.cast(chatTabCtrl, "ui::CTabControl");
		chatTabCtrl:AddItem(chatName);
		--ui.CreateNewChat(chatFrame, chatName);
		frame:ShowWindow(0);
	end
end

function CLOSE_CHATNEW(frame, obj, argStr, argNum)	
	frame:ShowWindow(0);	
end

