---- chat.lua


function WHISPER_CHAT(commname)

	local	setText = string.format("\"%s ", commname);
	SET_CHAT_TEXT(setText);

end

function GET_CHAT_TEXT()

	local chatFrame = ui.GetFrame('chat');
	local edit = chatFrame:GetChild('mainchat');

	return edit:GetText();

end

function GET_CHATFRAME()

	local chatFrame = ui.GetFrame("chat");
	if chatFrame == nil then
		return nil;
	end

	return chatFrame;
end

function CHAT_MAXLEN_MSG(frame, ctrl, maxLen)
	ui.SysMsg( ScpArgMsg("ChatMsgLimitedBy{Max}Byte_EmoticonCanTakeLotsOfByte","Max", maxLen));
end

function SET_CHAT_TEXT(txt)
	local chatFrame = GET_CHATFRAME();
	local edit = chatFrame:GetChild('mainchat');

	chatFrame:ShowWindow(1);
	edit:ShowWindow(1);

	local editCtrl 	= tolua.cast(edit, "ui::CEditControl");
	edit:SetText(txt);
	editCtrl:AcquireFocus();
end


g_uiChatHandler = nil;

function UI_CHAT(msg)
		
		ui.Chat(msg);

	if g_uiChatHandler ~= nil then
		local func = _G[g_uiChatHandler];
		if func ~= nil then
			func(msg);
		end
	end
end


