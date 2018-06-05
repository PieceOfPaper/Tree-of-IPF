CHAT_LINE_HEIGHT = 100;

function CHAT_ON_INIT(addon, frame)	

	local chatEditCtrl = GET_CHILD_RECURSIVELY(frame,'mainchat');
	chatEditCtrl:SetColorTone('FFFFFFFF')
	CHAT_SET_TO_TITLENAME('generalchat')

end

function GET_GROUP_TITLE(info)

	local memberString = "";

	--[[
	if info:GetMemberCount() > 2 then
		memberString = ScpArgMsg('TargetNameandOthers','TargetName',info:GetMember(0),'Count',info:GetMemberCount()-1)
		return memberString;
	end
	]]

	for i = 0 , info:GetMemberCount() - 1 do
		if memberString ~= "" then
			memberString = memberString .. ", ";
		end

		memberString = memberString .. info:GetMember(i);
	end

	return memberString;
end

function CHAT_CREATE_ROOM(frame, roomID, createInQueue)

	local info = session.chat.GetByStringID(roomID);
	if createInQueue == true then
		local group = GET_CHILD(frame, 'chat_whisper', 'ui::CGroupBox')
		local queue = GET_CHILD(group, 'queue', 'ui::CQueue')
		local btn = queue:CreateOrGetControlSet("chatlist", 'btn_'..roomID, 0, 0);
		tolua.cast(btn, "ui::CControlSet");
		local newMsgCount = info:GetNewMessageCount();
		local text = GET_CHILD(btn, "text", "ui::CRichText");
		if newMsgCount > 0 then
			text:SetTextByKey("newmsg", string.format("(%d) ", newMsgCount)); -- 이거 좀 예쁘게 빨간원으로 빼던가 해보자.
		else
			text:SetTextByKey("newmsg", "");
		end

		local memberString = GET_GROUP_TITLE(info);
		text:SetTextByKey("title", memberString);
		btn:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_TARGET_ON_BTN_UP');
		btn:SetEventScriptArgString(ui.LBUTTONUP, roomID);

		local btn_invite = btn:GetChild("btn_invite");
		btn_invite:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_INVITE');
		btn_invite:SetEventScriptArgString(ui.LBUTTONUP, roomID);

		local btn_exit = btn:GetChild("btn_exit");
		btn_exit:SetEventScript(ui.LBUTTONUP, 'CHAT_WHISPER_LEAVE');
		btn_exit:SetEventScriptArgString(ui.LBUTTONUP, roomID);
	end
		
	local total = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
	local chatroom = frame:GetChild('chat_'..roomID);
	if chatroom == nil then
		chatroom = ui.CloneAndInsertAfter(total, 'chat_'..roomID);
		chatroom:SetUserValue("CHAT_ID", roomID);
		chatroom:SetEventScript(ui.SCROLL, "SCROLL_CHAT");

		CHAT_GROUP_INIT_OPTION(chatroom);
	end

	--그룹 전체 noticecount표시
	local whisper_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper") 
	SET_COUNT_NOTICE(whisper_btn, session.chat.GetAllGroupChatNotReadMsgCount() );
	frame:Invalidate();

	return chatroom;
end

function CHAT_WHISPER_INVITE(ctrl, ctrlset, roomID, artNum)
	ctrl:SetUserValue("ROOM_ID",roomID)
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER2", "",nil,roomID,20);
end

function EXED_GROUPCHAT_ADD_MEMBER2(text,frame)
	
	local roomID = inputframe:GetUserValue("ArgString");
	ui.GroupChatInviteSomeone(roomID, text)
end

function CHAT_WHISPER_LEAVE(ctrl, ctrlset, argStr, artNum)
	ui.LeaveGroupChat(argStr);
end

function SCROLL_CHAT(parent, ctrl, str, wheel)

	if ctrl:IsVisible() == 0 then
		return;
	end

	if wheel == 0 then
		local roomID = ctrl:GetUserValue("CHAT_ID");
		chat.CheckNewMessage(roomID);
	end
	
end


function CHAT_GROUP_CREATE(roomID, autoFocusToRoom, controlName)
	
	local createInQueue = true;
	if controlName ~= "" then
		createInQueue = false;
	end

	local frame = ui.GetFrame('chatframe');
	if frame == nil then
		return;
	end

	if autoFocusToRoom == 1 then
		-- focus to room 
		local room = CHAT_CREATE_ROOM(frame, roomID, createInQueue)
		SHOW_ROOM_BY_ID(frame, roomID);
	else
		local room = frame:GetChild("chat_" .. roomID);
		if room == nil then
			-- create with hidden state
			room = CHAT_CREATE_ROOM(frame, roomID, createInQueue);
			room:ShowWindow(0);
		else
			-- only update room ui
			CHAT_CREATE_ROOM(frame, roomID, createInQueue);

			-- if room is visibie, update title
			if room:IsVisible() == 1 and controlName ~='party' then
				local name = frame:GetChild("group_titlebar"):GetChild("name");
				local info = session.chat.GetByStringID(roomID);
				local memberString = GET_GROUP_TITLE(info);
				name:SetTextByKey("title", "From " .. memberString);

			end
		end
	end
end

function CHAT_GROUP_REMOVE(roomID)

	local frame = ui.GetFrame('chatframe');
	local child = frame:GetChild('chat_'..roomID);
	local visible = child:IsVisible();
	frame:RemoveChild('chat_'..roomID);
	local group = GET_CHILD(frame, 'chat_whisper', 'ui::CGroupBox')
	local queue = GET_CHILD(group, 'queue', 'ui::CQueue')
	queue:RemoveChild('btn_'..roomID);

	if visible == 1 then
		CHAT_WHISPER_ON_BTN_UP()
	end
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

function CHAT_FOCUS_ROOM(roomID)
	local frame = ui.GetFrame('chatframe');
	chat.CheckNewMessage(roomID);
	SHOW_ROOM_BY_ID(frame, roomID);
end

function SHOW_ROOM_BY_ID(frame, roomID)

	CHAT_FRAME_NOW_BTN_SKN('whisperchat')

	frame:SetUserValue("ROOM_ID", roomID);
	local room = GET_CHILD(frame, 'chat_'..roomID, 'ui::CGroupBox');
	if room == nil then
		return;
	end

	HIDE_CHILD_BYNAME(frame, 'chat_');
	ui.SetRoomID(roomID);
	room:ShowWindow(1)

	local name = frame:GetChild("group_titlebar"):GetChild("name");
	local info = session.chat.GetByStringID(roomID);
	local memberString = GET_GROUP_TITLE(info);

	name:SetTextByKey("title", "From. " .. memberString);
	
	CHAT_SHOW_GROUP_BUTTON(frame, 1);
end

function CHAT_BAL_CLICK(frame, ctrl, roomID)
	frame:ShowWindow(0);
	frame = ui.GetFrame('chatframe');
	SHOW_ROOM_BY_ID(frame, roomID);
	chat.UpdateReadFlag(roomID);
end

function CHATFRAME_RESIZE(frame)

end

function CHAT_BAL_TEXT(frame, viewText, roomID)
	
	local scpString = "{a @CHAT_BAL_CLICK " .. roomID .. "}";
	local helpBalloon = MAKE_BALLOON_FRAME(scpString .. viewText, 0, 0, nil, "chat_help", "{#050505}{s16}{b}", 1);
	helpBalloon:ShowWindow(1);
	helpBalloon:SetDuration(5);
	local x, y = GET_GLOBAL_XY(frame);
	y = y + 100;
	helpBalloon:SetOffset(x, y);

end

function CHAT_GROUP_ADD(roomID, msgInfo, pushToBack, playEft, controlName)

	if pushToBack == nil then
		pushToBack = 1;
	end

	msgInfo = session.chat.CastChatMsg(msgInfo);

	local chatID = msgInfo:GetID();
	local fromName = msgInfo:GetFrom();
	local msg = msgInfo:GetMsg();
	local msgID = msgInfo:GetID();
	local msgTime = msgInfo:GetTime();
	local frame = ui.GetFrame('chatframe');
	local room = GET_CHILD(frame, 'chat_'..roomID, 'ui::CGroupBox')	
	local iconInfo = msgInfo:GetIconInfo();
	local notReadCount = msgInfo.notReadCount;

	if room == nil then
		return;
	end

	local myName = GETMYFAMILYNAME();

	local myColor, toColor = GET_CHAT_COLOR(frame, 'Group_'..roomID);

	if myName == fromName then
		
		CHAT_ADD(frame, room, 'Group_'..roomID , msg, fromName, iconInfo, myColor, toColor, pushToBack, GET_XM_HM_BY_SYSTIME(msgTime), playEft, msgID, notReadCount);
		
		if room:IsVisible() ~= 0 then
			HIDE_CHILD_BYNAME(frame, 'chat_');
			room:ShowWindow(1)
		end

	else
		
		CHAT_ADD(frame, room, 'Group_'..roomID, msg, fromName, iconInfo, myColor, toColor, pushToBack, GET_XM_HM_BY_SYSTIME(msgTime), playEft, msgID, notReadCount);
		if room:IsVisible() == 0 then
		--[[
			if controlName == "" then
				local viewText = fromName .. " : " .. msg;
				CHAT_BAL_TEXT(frame, viewText, roomID);
			end
			]]
		else
			if pushToBack == 1 then
				chat.UpdateReadFlag(roomID);
			end
		end
	end
			
	--CHAT_TOTAL(fromName, msg, iconInfo, myColor, toColor, pushToBack, GET_XM_HM_BY_SYSTIME(msgTime), playEft, nil, notReadCount);
	local totalroom = GET_CHILD(frame, 'chat_total')	
	if totalroom:IsVisible() == 0 then
		--[[if controlName == "" then
			local viewText = fromName .. " : " .. msg;
			CHAT_BAL_TEXT(frame, viewText, roomID);
		end]]
	else
		if pushToBack == 1 then
			chat.UpdateReadFlag(roomID);
		end
	end
	

end

function SET_COUNT_NOTICE(ctrl, count)
	
	if count <= 0 then
		ctrl:RemoveChild("COUNTNOTICE");
		return;
	end

	local ctrlSet = ctrl:CreateOrGetControlSet('countnotice', "COUNTNOTICE", 0, 0);
	ctrlSet:GetChild("count"):SetTextByKey("value", count);
end

function CHAT_ROOM_UPDATE(roomID)

	local frame = ui.GetFrame('chatframe');
	local info = session.chat.GetByStringID(roomID);
	local group = GET_CHILD(frame, 'chat_whisper', 'ui::CGroupBox')
	local queue = GET_CHILD(group, 'queue', 'ui::CQueue')

	local controlName = info:GetControlName();
	if controlName ~= "" then
		local group_btn = frame:GetChild("group_btn");
		local leftbtn = group_btn:GetChild("btn_" .. controlName);
		SET_COUNT_NOTICE(leftbtn, info:GetNewMessageCount());
	end

	local newMsgCount = info:GetNewMessageCount();
	
	local btn = GET_CHILD(queue, 'btn_'..roomID, "ui::CControlSet");
	if btn == nil then
		return;
	end

	local text = GET_CHILD(btn, "text", "ui::CRichText");
	local newMsgCount = info:GetNewMessageCount();

	if newMsgCount > 0 then
		text:SetTextByKey("newmsg", string.format("(%d) ", newMsgCount));
	else
		text:SetTextByKey("newmsg", "");
	end

	--그룹 전체 noticecount표시
	local whisper_btn = GET_CHILD_RECURSIVELY(frame,"btn_whisper") 
	SET_COUNT_NOTICE(whisper_btn, session.chat.GetAllGroupChatNotReadMsgCount() );

	frame:Invalidate();

end

function CHAT_ROOM_READ(roomID, msgID, notReadCount)

	
	local frame = ui.GetFrame('chatframe');
	local room = GET_CHILD(frame, 'chat_'..roomID, 'ui::CGroupBox')	
	if room == nil then
		return;
	end	
	
	local ctrlset = room:GetChild(msgID);
	if ctrlset == nil then
		return;
	end

	local notread = ctrlset:GetChild("bg"):GetChild("notread");
	if notReadCount <= 0 then
		notread:ShowWindow(0);
	else
		notread:SetTextByKey("count", notReadCount)
	end
	
	if roomID ~= 'total' then
		CHAT_ROOM_READ('total', msgID, notReadCount)
	end
end


function CHAT_SYSTEM(msg)
	session.ui.GetChatMsg():AddSystemMsg(msg);
end

function CHAT_TOTAL(targetName, msg, iconInfo, myColor, targetColor, pushToBack, msgTime, playEft, msgID, notReadCount)

	local frame = ui.GetFrame('chatframe');
	local total = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox')

	CHAT_ADD(frame, total, 'Total', msg, targetName, iconInfo, myColor, targetColor, pushToBack, msgTime, playEft, msgID, notReadCount);
	
end

function CHAT_NORMAL(targetName, msg, iconInfo, msgTimeStr)

	local frame = ui.GetFrame('chatframe');
	local color_my = frame:GetUserConfig("COLOR_NORMAL_MY");
	local color_other = frame:GetUserConfig("COLOR_NORMAL");
	
	local normal = GET_CHILD(frame, 'chat_general', 'ui::CGroupBox')
	CHAT_ADD(frame, normal, 'Normal', msg, targetName, iconInfo, color_my, color_other, nil, msgTimeStr);
end

function CHAT_SHOUT(targetName, msg, iconInfo, msgTimeStr)

	local frame = ui.GetFrame('chatframe');
	local color_my = frame:GetUserConfig("COLOR_SHOUT_MY");
	local color_other = frame:GetUserConfig("COLOR_SHOUT");
	local shout = GET_CHILD(frame, 'chat_shout', 'ui::CGroupBox');

	CHAT_ADD(frame, shout, 'Shout', msg, targetName, iconInfo, color_my, color_other, nil, msgTimeStr);	
end

function CHAT_WHISPER_TARGET_ON_BTN_UP(ctrl, ctrlset, argStr, artNum)

	local frame = ui.GetFrame('chatframe')

	CHAT_SET_FOCUS_TYPE(frame, CT_WHISPER, argStr);

end

function ADJUST_TOP_MARGIN(ctrl, moveValue)
	local rect = ctrl:GetMargin();
	ctrl:SetMargin(rect.left, rect.top + moveValue, rect.right, rect.bottom);
end

function SET_TOP_MARGIN(ctrl, moveValue)

	local rect = ctrl:GetMargin();
	ctrl:SetMargin(rect.left, moveValue, rect.right, rect.bottom);
			
end

function CHAT_ADD(frame, groupbox, chatType, msg, targetName, iconInfo, myColor, targetColor, pushToBack, msgTime, playEft, msgID, notReadCount)

	if pushToBack == nil then
		pushToBack = 1;
	end

	groupbox = tolua.cast(groupbox, "ui::CGroupBox");

	groupbox:LimitChildCount(500);

	local chatCtrlName = 'chatu';
	local childCount = groupbox:GetChildCount();
	local ypos = 50;

	local myName = GETMYFAMILYNAME();
	if myName == targetName then
		chatCtrlName = 'chati';
	end
	
	local chatTime = GET_XM_HM_BY_SYSTIME( geTime.GetServerSystemTime() );
	if msgTime ~= nil then
		chatTime = msgTime;
	end
	
	local addMsg = false;
	local isSameTime = false;
	if childCount >= 1 then
		local lastChild = groupbox:GetChildByIndex(childCount-1);
		if pushToBack == 1 then
			ypos = lastChild:GetY() + lastChild:GetHeight();
		else
			ypos = lastChild:GetY();
		end

	
		local lastTime = lastChild:GetUserValue("MSGTIME");
		if lastTime == chatTime then
			isSameTime = true;
		end
		lastChild:SetUserValue("MSGTIME", chatTime);

		local lastTargetName = groupbox:GetUserValue("LAST_TARGETNAME");
		groupbox:SetUserValue("LAST_TARGETNAME", targetName);

		if groupbox:GetName() == 'chat_total' then
			if frame:GetUserValue('LAST_GROUPBOX') ~= chatType then
				isSameTime = false;
			end			
		end
		frame:SetUserValue('LAST_GROUPBOX', chatType);

		if isSameTime == true and lastTargetName == targetName then
			addMsg = true;
			ypos = lastChild:GetY();
		end
	end

	local msgIndex = groupbox:GetUserIValue("MSG_INDEX");
	if addMsg == false then
		msgIndex = msgIndex + 1;
		groupbox:SetUserValue("MSG_INDEX", msgIndex);	
	end

	local controlSetName = targetName..tostring(msgIndex);	

	-- 이것이 있는 이유는 무엇일까요. 이 하나때문에 말풍선이 겹칩니다.
	-- 디폴트 값인 AAA가 출력되고.... ??> ? ? ? ?? 
--	if msgID ~= nil then
	--	controlSetName = msgID;
--	end
	local horzGravity = ui.LEFT;
	local OTHERS_BALLON_LEFT_MARGIN = frame:GetUserConfig("OTHERS_BALLON_LEFT_MARGIN")
	local marginLeft = OTHERS_BALLON_LEFT_MARGIN;
	
	local marginRight = 0;
	if chatCtrlName == 'chati' then
		horzGravity = ui.RIGHT;
		marginLeft = 0;
		marginRight = 25;
	end
	
	if pushToBack ~= 0 and notDrawTime == true then
		local beforeControl = groupbox:GetChildByIndex(groupbox:GetChildCount() - 1);
		if beforeControl ~= nil and beforeControl:GetClassName() == "controlset" then
			AUTO_CAST(beforeControl);
			if beforeControl:GetControlSetName() == chatCtrlName then
				local lastChild = groupbox:GetChildByIndex(childCount-1);

				local label = lastChild:GetChild('bg');
				local txt = GET_CHILD(label, "text", "ui::CRichText");
				local beforeText = txt:GetTextByKey("text");
				if string.len(beforeText) <= 4000 then
					beforeText = beforeText .. "{nl}" .. msg;
					txt:SetTextByKey("text", beforeText);
				
					label:Resize(txt:GetWidth() + 40, txt:GetHeight() + 20);
					lastChild:Resize(lastChild:GetWidth(), label:GetY() + label:GetHeight());

					local timeBox = GET_CHILD(lastChild, "timebox", "ui::CGroupBox");
					if chatCtrlName == 'chati' then
						timeBox:SetOffset(label:GetX() - timeBox:GetWidth() + 20, timeBox:GetY());
					else
						timeBox:SetOffset(label:GetX() + label:GetWidth() - 20, timeBox:GetY());
					end

					groupbox:UpdateData();
					groupbox:SetScrollPos(groupbox:GetLineCount() + groupbox:GetVisibleLineCount());
					return;
				end
			end
		end
	end
	local chatCtrl = nil;
	if targetName == 'SYSTEM' then
		chatCtrl = groupbox:CreateOrGetControlSet(chatCtrlName, controlSetName, horzGravity, ui.TOP, marginLeft-20, ypos, marginRight, 0);
	else
		chatCtrl = groupbox:CreateOrGetControlSet(chatCtrlName, controlSetName, horzGravity, ui.TOP, marginLeft, ypos, marginRight, 0);

		chatCtrl:EnableHitTest(1);
		chatCtrl:SetEventScript(ui.RBUTTONDOWN, 'CHAT_RBTN_POPUP');
		chatCtrl:SetUserValue("TARGET_NAME", targetName);
	end

	chatCtrl:SetUserValue("MSGTIME", chatTime);

	if pushToBack == 0 then
		groupbox:MoveChildBefore(chatCtrl, 1);
	end	

	local label = chatCtrl:GetChild('bg');
	local txt = GET_CHILD(label, "text", "ui::CRichText");
	local notread = GET_CHILD(label, "notread", "ui::CRichText");
	local timeBox = GET_CHILD(chatCtrl, "timebox", "ui::CGroupBox");
	local timeCtrl = GET_CHILD(timeBox, "time", "ui::CRichText");
	local nameText = GET_CHILD(chatCtrl, "name", "ui::CRichText");
	

	if addMsg == true then
		if pushToBack == 1 then
			msg = txt:GetText() .. "{nl}" .. msg;
		else
			msg = msg .. "{nl}" .. txt:GetText();
		end
	end


	txt:SetTextByKey("text", msg);

	local labelMarginX = tonumber(frame:GetUserConfig("BalloonMarginWidth"));
	local labelMarginY = tonumber(frame:GetUserConfig("BalloonMarginHeight"));

	if chatCtrlName == 'chati' then
		label:SetSkinName('textballoon_i');
		label:SetColorTone(myColor);
	else
		label:SetColorTone(targetColor);
		nameText:SetText('{@st61}'..targetName..'{/}');

		local iconPicture = GET_CHILD(chatCtrl, "iconPicture", "ui::CPicture");
		if iconInfo == nil then
			iconPicture:ShowWindow(0);
		else
			--local iconName = ui.CaptureModelHeadImage_IconInfo(iconInfo);
			--iconPicture:SetImage(iconName);
			iconPicture:ShowWindow(0);
		end
	end
		
	timeCtrl:SetTextByKey("time", chatTime);
		
	if notReadCount == nil or notReadCount <= 0 then
		notread:ShowWindow(0);
	else
		notread:SetTextByKey("count", notReadCount)
	end

	local slflag = string.find(msg,'a SL')
	if slflag == nil then
		label:EnableHitTest(0)
	else
		label:EnableHitTest(1)
	end
		
	local lablWidth = txt:GetWidth() + 40;
	local chatWidth = chatCtrl:GetWidth();
	label:Resize(lablWidth, txt:GetHeight() + 20);
	if targetName == 'SYSTEM' and chatWidth < 480 then
		chatWidth = 480;
	end

	chatCtrl:Resize(chatWidth, label:GetY() + label:GetHeight() + 10);

	if chatCtrlName == 'chati' then
		local offsetX = label:GetX() + txt:GetWidth() - 60;
		if 35 > offsetX then
			offsetX = offsetX + 40;
		end
		if label:GetWidth() < timeBox:GetWidth() + 20 then		
			offsetX = math.min(offsetX, label:GetX() - timeBox:GetWidth()/2);
		end
		timeBox:SetOffset(offsetX, label:GetY() + label:GetHeight() - 10);
	else
		
		local offsetX = label:GetX() + txt:GetWidth() - 60;
		if 35 > offsetX then
			offsetX = offsetX + 40;
		end
		timeBox:SetOffset(offsetX, label:GetY() + label:GetHeight() - 10);
	end

	local beforeLineCount = groupbox:GetLineCount();	
	if pushToBack == 0 then

		GBOX_AUTO_ALIGN(groupbox, 0, 0, 0, true, false);
		--[[
		local newCtrlHeight = chatCtrl:GetHeight();
		ADJUST_TOP_MARGIN(chatCtrl, -chatCtrl:GetHeight());
		

		for i = 2 , groupbox:GetChildCount() - 1 do
			local underCtrl = groupbox:GetChildByIndex(i);
			ADJUST_TOP_MARGIN(underCtrl, newCtrlHeight);
		end]]
	end

	groupbox:UpdateData();

	if pushToBack == 1 then
		groupbox:SetScrollPos(groupbox:GetLineCount() + groupbox:GetVisibleLineCount());
	else
		local afterLineCount = groupbox:GetLineCount();
		local changedLineCount = afterLineCount - beforeLineCount;
		local curLine = groupbox:GetCurLine();
		groupbox:SetScrollPos(curLine + changedLineCount);
	end

	if playEft ~= 0 then
		if chatCtrlName == 'chati' then
			UI_PLAYFORCE(chatCtrl, "chat_eft_right", 0, 0);
		else
			UI_PLAYFORCE(chatCtrl, "chat_eft_left", 0, 0);
		end
	end

	return chatTime;
end

function CHAT_RBTN_POPUP(frame, chatCtrl)

	local targetName = chatCtrl:GetUserValue("TARGET_NAME");
	local myName = GETMYFAMILYNAME();
	if myName == targetName then
		return;
	end

	local context = ui.CreateContextMenu("CONTEXT_CHAT_RBTN", targetName, 0, 0, 170, 100);
	ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", targetName));	
	local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", targetName);
	ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
	local partyinviteScp = string.format("PARTY_INVITE(\"%s\")", targetName);
	ui.AddContextMenuItem(context, ScpArgMsg("PARTY_INVITE"), partyinviteScp);

	local blockScp = string.format("CHAT_BLOCK_MSG('%s')", targetName );
	ui.AddContextMenuItem(context, ScpArgMsg("FriendBlock"), blockScp)

	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function CHAT_BLOCK_MSG(targetName)

	local strScp = string.format("friends.RequestBlock(\"%s\")", targetName);
	ui.MsgBox(ScpArgMsg("ReallyBlock?"), strScp, "None");

end


function CHAT_SET_FROM_TITLENAME(chatType, targetName, roomid)

	CHAT_FRAME_NOW_BTN_SKN(chatType)

	local frame = ui.GetFrame('chat');
	local chatFrame = ui.GetFrame('chatframe');

	local chatEditCtrl = frame:GetChild('mainchat');
	
	local titleFont = '{@st61}';
	local titleText = "";
	
	CHAT_SHOW_GROUP_BUTTON(chatFrame, 0);
	
	if chatType == 'totalchat' then
		titleText = titleText .. ScpArgMsg('AllChat');
	elseif chatType == 'generalchat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
		
		HIDE_CHILD_BYNAME(frame, 'chat_');
		local chat = GET_CHILD(frame, 'chat_general', 'ui::CGroupBox');
		titleText = titleText..ScpArgMsg('Auto_ilBan_DaeHwa');
		chat:ShowWindow(1)
		

		
	elseif chatType == 'partychat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
					
		local partyRoom = session.chat.GetByControlName("party");
		if partyRoom == nil then
			ui.SysMsg(ScpArgMsg('HadNotMyParty'));
			return;
		end

		local frame = ui.GetFrame('chatframe')
		HIDE_CHILD_BYNAME(frame, 'chat_');

		local chatCtrl = GET_CHILD(frame, 'chat_' .. partyRoom:GetGuid(), 'ui::CGroupBox');
		titleText = titleText..ScpArgMsg('Auto_PaTi_DaeHwa');
		chatCtrl:ShowWindow(1)

	elseif chatType == 'guildchat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
					
		local partyRoom = session.chat.GetByControlName("guild");
		if partyRoom == nil then
			ui.SysMsg(ScpArgMsg('HadNotMyGuild'));
			return;
		end

		local frame = ui.GetFrame('chatframe')
		HIDE_CHILD_BYNAME(frame, 'chat_');

		local chatCtrl = GET_CHILD(frame, 'chat_' .. partyRoom:GetGuid(), 'ui::CGroupBox');
		titleText = titleText..ScpArgMsg('GuildChatting');
		chatCtrl:ShowWindow(1)

	elseif chatType == 'shoutchat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
		
			
		HIDE_CHILD_BYNAME(frame, 'chat_');
		local chatgbox = GET_CHILD(frame, 'chat_shout', 'ui::CGroupBox');
		titleText = titleText..ScpArgMsg('Auto_oeChiKi');
		chatgbox:ShowWindow(1)
				
	elseif chatType == 'whisperchat' or chatType == 'whisperFromchat' or chatType == 'whisperTochat' then

		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
		if roomid ~= nil and roomid ~= "" then
			
			local frame = ui.GetFrame('chatframe')
			HIDE_CHILD_BYNAME(frame, 'chat_');
			SHOW_ROOM_BY_ID(frame, roomid);

			local info = session.chat.GetByStringID(roomid);
			local memberString = GET_GROUP_TITLE(info);
			titleText = 'From. '..memberString;

		end		
		
	elseif chatType == 'groupchat' then

	
		local frame = ui.GetFrame('chatframe')
		local totalchat = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox');
	
			
		local frame = ui.GetFrame('chatframe')
		HIDE_CHILD_BYNAME(frame, 'chat_');
		SHOW_ROOM_BY_ID(frame, roomid);

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

function CHAT_SET_TO_TITLENAME(chatType, targetName, count)
	local frame = ui.GetFrame('chat');
	local chatEditCtrl = frame:GetChild('mainchat');
	local titleCtrl = GET_CHILD(frame,'edit_to_bg');
	local editbg = GET_CHILD(frame,'edit_bg');

	--[[
	if 1==1 then -- 길용과장님과 협의 하에 봉인. 150323 다시 해제.
		titleCtrl:ShowWindow(0)
		return; 
	end]]

	local titleText = ''
	
	if chatType == 'generalchat' then
		titleText = ScpArgMsg('NormalChat');
	elseif chatType == 'partychat' then
		titleText = ScpArgMsg('PartyChat');
	elseif chatType == 'guildchat' then
		titleText = ScpArgMsg('guild');
	elseif chatType == 'shoutchat' then
		titleText = ScpArgMsg('Auto_oeChiKi');
	elseif chatType == 'whisperchat' or chatType == 'whisperFromchat' or chatType == 'whisperTochat' then
		titleText = ScpArgMsg('WhisperChat','Who',targetName);
	elseif chatType == 'groupchat' then
		if count > 1 then
			titleText = ScpArgMsg('GroupChat','Who',targetName,'Count',count-1);
		else
			titleText = ScpArgMsg('WhisperChat','Who',targetName);
		end
	end

	local name  = GET_CHILD(titleCtrl,'title_to');

	name:SetText(titleText);
	
	titleCtrl:Resize(name:GetWidth() + 20,titleCtrl:GetOriginalHeight())
	chatEditCtrl:Resize(chatEditCtrl:GetOriginalWidth() - titleCtrl:GetWidth(), chatEditCtrl:GetOriginalHeight())
	chatEditCtrl:SetOffset(chatEditCtrl:GetOriginalX() + titleCtrl:GetWidth(), chatEditCtrl:GetOriginalY())

end

function CHAT_GROUP_INVITE(frame)
	local roomID = frame:GetUserValue("ROOM_ID");
	SHOW_INVITE_PARTY("EXEC_CHAT_INVITE", roomID);
end

function EXEC_CHAT_INVITE(list, idList, roomID)
	local nameList = NewStringList();
	for  i = 1 , #list do
		local str = list[i];
		nameList:Add(str);
	end

	if #list == 0 then
		return;
	end

	ui.SetInviteList(roomID, nameList);
	ui.ReqCreateGroupChat()
		
end

function CHAT_OPEN_OPTION(frame)
	ui.ToggleFrame("chat_option");
end

function CHAT_OPEN_EMOTICON(frame)
	ui.ToggleFrame("chat_emoticon");
end


function GET_CHAT_COLOR(frame, chatType)

	local myColor = frame:GetUserConfig("COLOR_NORMAL_MY");
	local targetColor = frame:GetUserConfig("COLOR_NORMAL");
	
	if string.find(chatType, 'Group') ~= nil then

		local id = string.sub(chatType, 7, string.len(chatType));
		local guildRoom = session.chat.GetByControlName("guild");
		local exist = false;
		if guildRoom ~= nil and guildRoom:GetGuid() == id then
			myColor = frame:GetUserConfig("COLOR_GUILD_MY");
			targetColor = frame:GetUserConfig("COLOR_GUILD");	
			exist = true;
		end
		
		if false == exist then
			local partyRoom = session.chat.GetByControlName("guild");
			if partyRoom ~= nil and partyRoom:GetGuid() == id then
				myColor = frame:GetUserConfig("COLOR_PARTY_MY");
				targetColor = frame:GetUserConfig("COLOR_PARTY");	
				exist = true;
			end
		end
		
		if false == exist then		
			myColor = frame:GetUserConfig("COLOR_WHI_MY");
			targetColor = frame:GetUserConfig("COLOR_WHI_TO");
		end

	elseif chatType == 'Shout' then
		myColor = frame:GetUserConfig("COLOR_SHOUT_MY");
		targetColor = frame:GetUserConfig("COLOR_SHOUT");

	elseif chatType == 'Party' then
		myColor = frame:GetUserConfig("COLOR_PARTY_MY");
		targetColor = frame:GetUserConfig("COLOR_PARTY");	
	
	elseif chatType == 'Guild' then
		myColor = frame:GetUserConfig("COLOR_GUILD_MY");
		targetColor = frame:GetUserConfig("COLOR_GUILD");	
	end

	return myColor, targetColor;

end

function CHAT_TOTAL_TEST(chatType, targetName, msg, iconInfo, msgTime)

	local frame = ui.GetFrame('chatframe');
	local total = GET_CHILD(frame, 'chat_total', 'ui::CGroupBox')
	
	local myColor, targetColor = GET_CHAT_COLOR(frame, chatType);
	
	local chatTime = CHAT_ADD(frame, total, chatType, msg, targetName, iconInfo, myColor, targetColor, nil, msgTime);	
	return tostring(chatTime);
end

