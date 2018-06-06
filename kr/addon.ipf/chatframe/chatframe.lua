function CHATFRAME_ON_INIT(addon, frame)

	addon:RegisterMsg("ON_GROUP_CHAT_LAST_TEN", "CHAT_LAST_TEN_UPDATED");
	addon:RegisterMsg("GROUP_CHAT_RECEIVED", "ON_GROUP_CHAT_RECEIVED");
	addon:RegisterMsg("GAME_START", "ON_GAME_START");

	CHAT_GROUPBOX_ALL_HIDE(frame)
	local total = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox')
	total:ShowWindow(1)
	chat.RefreshChatRooms();
	CHAT_SHOW_GROUP_BUTTON(frame, 0);
	CHAT_SET_FROM_TITLENAME('totalchat')
	CHAT_FRAME_NOW_BTN_SKN('totalchat')
	CHAT_FRAME_NOW_BTN_SKN('totalchat')
	

end

function ON_GAME_START(frame)
	
	frame:Resize(config.GetXMLConfig("ChatFrameSizeWidth"),config.GetXMLConfig("ChatFrameSizeHeight"))
	frame:Invalidate()
end
 
 function ON_GROUP_CHAT_RECEIVED(frame)

	if frame:GetUserIValue("REFRESH") == 1 then
		return;
	end

	frame:SetUserValue("REFRESH", 1);

	local chatType = ui.GetLastChatEditFocusType();
	local chatArgStr = ui.GetLastChatTypeArgStr();
	CHAT_SET_FOCUS_TYPE(frame, chatType, chatArgStr)

 end

 function CHAT_GROUPBOX_ALL_HIDE(frame)	
	HIDE_CHILD_BYNAME(frame, 'chat_');
end

function CHATFRAME_OPEN(frame)
end

function CHATFRAME_CLOSE(frame)
end

function CHAT_LAST_TEN_ON_BTN_UP()
	ui.GetGroupChatLastTen();
end

function CHATFRAME_RESIZE(frame)
	
	config.ChangeXMLConfig("ChatFrameSizeWidth", frame:GetWidth()); 
	config.ChangeXMLConfig("ChatFrameSizeHeight", frame:GetHeight()); 

end

function CHAT_FRAME_NOW_BTN_SKN(type)

	local frame = ui.GetFrame('chatframe')

	local btn_total = GET_CHILD_RECURSIVELY(frame,'btn_total')
	local btn_general = GET_CHILD_RECURSIVELY(frame,'btn_general')
	local btn_shout = GET_CHILD_RECURSIVELY(frame,'btn_shout')
	local btn_party = GET_CHILD_RECURSIVELY(frame,'btn_party')
	local btn_guild = GET_CHILD_RECURSIVELY(frame,'btn_guild')
	local btn_whisper = GET_CHILD_RECURSIVELY(frame,'btn_whisper')

	local btn_total_pic = GET_CHILD_RECURSIVELY(frame,'btn_total_pic')
	local btn_general_pic = GET_CHILD_RECURSIVELY(frame,'btn_general_pic')
	local btn_shout_pic = GET_CHILD_RECURSIVELY(frame,'btn_shout_pic')
	local btn_party_pic = GET_CHILD_RECURSIVELY(frame,'btn_party_pic')
	local btn_guild_pic = GET_CHILD_RECURSIVELY(frame,'btn_guild_pic')
	local btn_whisper_pic = GET_CHILD_RECURSIVELY(frame,'btn_whisper_pic')

	btn_total_pic:ShowWindow(0)
	btn_general_pic:ShowWindow(0)
	btn_shout_pic:ShowWindow(0)
	btn_party_pic:ShowWindow(0)
	btn_guild_pic:ShowWindow(0)
	btn_whisper_pic:ShowWindow(0)

	btn_total:ShowWindow(1)
	btn_general:ShowWindow(1)
	btn_shout:ShowWindow(1)
	btn_party:ShowWindow(1)
	btn_guild:ShowWindow(1)
	btn_whisper:ShowWindow(1)

	if type == 'totalchat' then
		btn_total_pic:ShowWindow(1)
		btn_total:ShowWindow(0)
	end
	if type == 'generalchat' then
		btn_general_pic:ShowWindow(1)
		btn_general:ShowWindow(0)
	end
	if type == 'shoutchat' then
		btn_shout_pic:ShowWindow(1)
		btn_shout:ShowWindow(0)
	end
	if type == 'partychat' then
		btn_party_pic:ShowWindow(1)
		btn_party:ShowWindow(0)
	end
	if type == 'guildchat' then
		btn_guild_pic:ShowWindow(1)
		btn_guild:ShowWindow(0)
	end
	if type == 'whisperchat' or type == 'groupchat' then
		btn_whisper_pic:ShowWindow(1)
		btn_whisper:ShowWindow(0)
	end
	

	frame:Invalidate()


end

function CHAT_LAST_TEN_UPDATED(frame, msg, argStr, argNum)
	
	local frame = ui.GetFrame('chatframe')
	local group = GET_CHILD(frame, 'chat_'..argStr, 'ui::CGroupBox')
	local queue = GET_CHILD(group, 'queue', 'ui::CQueue')
	queue:SortByName()
	queue:Invalidate();
	
end

function CHAT_LEAVE_ON_BTN_UP()
	ui.LeaveGroupChat();
end

function CHAT_SET_FOCUS_TYPE(frame, type, childKey)

	if childKey == "" then
		childKey = nil;
	end

	HIDE_CHILD_BYNAME(frame, 'chat_');
	local uiKey = "total";
	if type == CT_TOTAL then
		uiKey = "total";	
	elseif type == CT_GENERAL then
		uiKey = "general";
	elseif type == CT_SHOUT then
		uiKey = "shout";
	elseif type == CT_PARTY then
		uiKey = "party";
	elseif type == CT_GUILD then
		uiKey = "guild";
	elseif type == CT_WHISPER then
		uiKey = "whisper";
	end

	local chatgbox;
	if childKey == nil then
		chatgbox = GET_CHILD(frame, "chat_" .. uiKey);
	else
		chatgbox = GET_CHILD(frame, "chat_" .. childKey);
	end

	if chatgbox ~= nil then
		chatgbox:ShowWindow(1);
	end

	if type == CT_WHISPER then
		if childKey ~= nil then 
			SHOW_ROOM_BY_ID(frame, childKey);
		else
			ui.SetRoomID(0);
		end
	end

	CHAT_SET_FROM_TITLENAME(uiKey.. "chat");
	ui.ChatEditFocus(type, childKey);

	if childKey ~= nil then
		chat.CheckNewMessage(childKey);
		chat.UpdateReadFlag(childKey);
	end

end

function CHAT_TOTAL_ON_BTN_UP()
	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_TOTAL);
	chat.UpdateAllReadFlag();
end

function CHAT_GENERAL_ON_BTN_UP()
	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_GENERAL);
end

function CHAT_SHOUT_ON_BTN_UP()
	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_SHOUT);
end

function CHAT_PARTY_ON_BTN_UP()
	
	local partyRoom = session.chat.GetByControlName("party");
	if partyRoom == nil then
		ui.SysMsg(ScpArgMsg('HadNotMyParty'));
		return;
	end

	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_PARTY, partyRoom:GetGuid());

end

function CHAT_GUILD_ON_BTN_UP()
	
	local partyRoom = session.chat.GetByControlName("guild");
	if partyRoom == nil then
		ui.SysMsg(ScpArgMsg('HadNotMyGuild'));
		return;
	end

	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_GUILD, partyRoom:GetGuid());

end

function CHAT_WHISPER_ON_BTN_UP()

	chat.RefreshChatRooms();
	local frame = ui.GetFrame('chatframe')
	CHAT_SET_FOCUS_TYPE(frame, CT_WHISPER);

end

function GROUPCHAT_ADD_MEMBER(parent)
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER", "",nil,nil,20);
end

function EXED_GROUPCHAT_ADD_MEMBER(frame, friendName)
	local roomID = frame:GetUserValue("ROOM_ID");
	ui.GroupChatInviteSomeone(roomID, friendName)
end
