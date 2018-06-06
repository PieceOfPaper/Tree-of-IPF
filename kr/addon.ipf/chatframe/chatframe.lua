function CHATFRAME_ON_INIT(addon, frame)

	addon:RegisterMsg("ON_GROUP_CHAT_LAST_TEN", "CHAT_LAST_TEN_UPDATED");
	addon:RegisterMsg("GROUP_CHAT_RECEIVED", "ON_GROUP_CHAT_RECEIVED");
	addon:RegisterMsg("GAME_START", "ON_GAME_START");

	CHAT_GROUPBOX_ALL_HIDE(frame)
	local total = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox')
	total:ShowWindow(1)
	chat.RefreshChatRooms();
	CHAT_SHOW_GROUP_BUTTON(frame, 0);
	
	CHAT_FRAME_NOW_BTN_SKN()

	local chatroom = frame:GetChild("chat_tabs");
	if chatroom == nil then
		chatroom = ui.CloneAndInsertAfter(total, "chat_tabs");
		chatroom:SetUserValue("CHAT_ID", "TABS");
		chatroom:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
		CHAT_GROUP_INIT_OPTION(chatroom);
	end

	
	local opacity = config.GetConfigInt("CHAT_OPACITY", 255);
	CHAT_SET_OPACITY(opacity);

end

function CHAT_SET_FROM_TITLENAME(chatType, targetName, roomid)

	--CHAT_FRAME_NOW_BTN_SKN()

	local frame = ui.GetFrame('chat');
	local chatFrame = ui.GetFrame('chatframe');

	local chatEditCtrl = frame:GetChild('mainchat');
	
	local titleFont = '{@st61}';
	local titleText = "";
	
	CHAT_SHOW_GROUP_BUTTON(chatFrame, 0);
	
	if chatType == 'totalchat' then
		titleText = titleText .. ScpArgMsg('AllChat');
	elseif chatType == 'generalchat' then
		titleText = titleText..ScpArgMsg('Auto_ilBan_DaeHwa');
	
	elseif chatType == 'partychat' then
		titleText = titleText..ScpArgMsg('Auto_PaTi_DaeHwa');
	elseif chatType == 'guildchat' then
		titleText = titleText..ScpArgMsg('GuildChatting');
	elseif chatType == 'shoutchat' then
		titleText = titleText..ScpArgMsg('Auto_oeChiKi');
	elseif chatType == 'whisperchat' or chatType == 'whisperFromchat' or chatType == 'whisperTochat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
		if roomid ~= nil and roomid ~= "" then
			
			local frame = ui.GetFrame('chatframe')
			local info = session.chat.GetByStringID(roomid);
			local memberString = GET_GROUP_TITLE(info);
			titleText = 'From. '..memberString;

		end		
		
	elseif chatType == 'groupchat' then
		local info = session.chat.GetByStringID(roomid);
		local memberString = GET_GROUP_TITLE(info);
		titleText = 'From. '..memberString;	
	elseif chatType == 'groupchatinvite' then
		titleText = titleText..ScpArgMsg('Auto_DaeHwa_ChoDae');
	elseif chatType == 'tradechat' then
		titleText = titleText..ScpArgMsg('Auto_KeoLae');
	elseif chatType == 'systemchat' then
		titleText = titleText..ScpArgMsg('Auto_SiSeuTem');
	elseif chatType == 'grouplist' then
		titleText = titleText..ScpArgMsg('GroupChatList');
	end

	local name = chatFrame:GetChild("group_titlebar"):GetChild("name");

	name:SetTextByKey("title", titleText);

end

function CHAT_SHOW_GROUP_BUTTON(frame, isVisible)
	local group_titlebar = frame:GetChild("group_titlebar");
	--local btn_leave = group_titlebar:GetChild("btn_leave");
	--local btn_invite = group_titlebar:GetChild("btn_invite");
	local btn_leave = frame:GetChild("btn_leave");
	local btn_invite = frame:GetChild("btn_invite");
	btn_leave:ShowWindow(isVisible);
	btn_invite:ShowWindow(isVisible);
end

function CHAT_GROUP_INIT_OPTION(group)

	local opacity = config.GetConfigInt("CHAT_OPACITY", 255);
	local colorToneStr = string.format("%02X", opacity);				
	colorToneStr = colorToneStr .. "FFFFFF";
	group:SetColorTone(colorToneStr);

end

function ON_GAME_START(frame)
	
	CHAT_SET_FROM_TITLENAME('totalchat')

	frame:Resize(config.GetXMLConfig("ChatFrameSizeWidth"),config.GetXMLConfig("ChatFrameSizeHeight"))
	frame:Invalidate()
end
 
 function ON_GROUP_CHAT_RECEIVED(frame)

	if frame:GetUserIValue("REFRESH") == 1 then
		return;
	end

	frame:SetUserValue("REFRESH", 1);

	--local chatType = ui.GetLastSetChatGroupBoxType();
	--local chatArgStr = ui.GetLastChatTypeArgStr();
	--CHAT_SET_FOCUS_TYPE(frame, chatType, chatArgStr, 1)

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

function CHAT_FRAME_GROUPBOXES_VISIBLE(targetID)

	local frame = ui.GetFrame('chatframe')
	HIDE_CHILD_BYNAME(frame, 'chat_');
	local cnt = ui.GetSelectedChatTabCount();
	if cnt == 1 then
		local enumValue = ui.GetSelectedChatTabByIndex(0);
		local key = CHAT_ENUM_TO_UI_KEY(enumValue);
		local guid = 0;
		if key == "whisper" then
			if targetID ~= "" then
				guid = targetID;
			end
		else
			local partyRoom = session.chat.GetByControlName(key);
			if partyRoom ~= nil then
				guid = partyRoom:GetGuid();
			end
		end

		local childName;
		if guid == 0 then
			childName = "chat_" ..key;
		else
			childName = "chat_" ..guid;
		end

		local chatBox = frame:GetChild(childName);
		if chatBox ~= nil then
			chatBox:ShowWindow(1);
		end
		
	else
		local chatroom = frame:GetChild("chat_tabs");
		chatroom:ShowWindow(1);

		for i = 0 , cnt - 1 do
			local enumValue = ui.GetSelectedChatTabByIndex(i);
			local key = CHAT_ENUM_TO_UI_KEY(enumValue);
			local partyRoom = session.chat.GetByControlName(key);
			if partyRoom ~= nil then 
				chat.CheckNewMessage(partyRoom:GetGuid());
			end
		end
	end
	

end

function CHAT_FRAME_NOW_BTN_SKN()

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

	local cnt = ui.GetSelectedChatTabCount();
	for i = 0 , cnt - 1 do
		local enumValue = ui.GetSelectedChatTabByIndex(i);
		local type = CHAT_ENUM_TO_UI_KEY(enumValue) .. "chat";
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

function CHAT_ENUM_TO_UI_KEY(type)

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

	return uiKey;

end

function CHAT_SET_FOCUS_TYPE(frame, type, childKey, runByPacket)
	
	if childKey == "" then
		childKey = nil;
	end

	-- HIDE_CHILD_BYNAME(frame, 'chat_');
	local uiKey = CHAT_ENUM_TO_UI_KEY(type);
	
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

	if runByPacket ~= 1 then
		runByPacket = 0;
	end

	ui.SetChatGroupBox(type, childKey, runByPacket);

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

function CHAT_SET_OPACITY(num)
	local chatFrame = ui.GetFrame("chatframe");
	if chatFrame == nil then
		return;
	end

	local count = chatFrame:GetChildCount();
	for  i = 0, count-1 do 
		local child = chatFrame:GetChildByIndex(i);
		local childName = child:GetName();
		if string.sub(childName, 1, 5) == "chat_" then
			if child:GetClassName() == "groupbox" then
				child = tolua.cast(child, "ui::CGroupBox");
				local colorToneStr = string.format("%02X", num);				
				colorToneStr = colorToneStr .. "FFFFFF";
				child:SetColorTone(colorToneStr);
			end
		end
	end

end

function CHAT_SET_FONTSIZE(num)
	local chatFrame = ui.GetFrame("chatframe");
	if chatFrame == nil then
		return;
	end

	local targetSize = GET_CHAT_FONT_SIZE();
	local count = chatFrame:GetChildCount();
	for  i = 0, count-1 do 
		local groupBox  = chatFrame:GetChildByIndex(i);
		local childName = groupBox:GetName();
		if string.sub(childName, 1, 5) == "chat_" then
			if groupBox:GetClassName() == "groupbox" then
				groupBox = AUTO_CAST(groupBox);
				local beforeHeight = 1;
				local lastChild = nil;
				local ctrlSetCount = groupBox:GetChildCount();
				for j = 0 , ctrlSetCount - 1 do
					local chatCtrl = groupBox:GetChildByIndex(j);
					if chatCtrl:GetClassName() == "controlset" then
						local label = chatCtrl:GetChild('bg');
						local txt = GET_CHILD(label, "text");
						txt:SetTextByKey("size", targetSize);
						local timeBox = GET_CHILD(chatCtrl, "timebox");
						RESIZE_CHAT_CTRL(chatCtrl, label, txt, timeBox)
						beforeHeight = chatCtrl:GetY() + chatCtrl:GetHeight();
						lastChild = chatCtrl;
					end
				end

				GBOX_AUTO_ALIGN(groupBox, 0, 0, 0, true, false);
				if lastChild ~= nil then
					local afterHeight = lastChild:GetY() + lastChild:GetHeight();					
					local heightRatio = afterHeight / beforeHeight;
					
					groupBox:UpdateData();
					groupBox:SetScrollPos(groupBox:GetCurLine() * (heightRatio * 1.1));
				end
			end
		end
	end



	chatFrame:Invalidate();
end


