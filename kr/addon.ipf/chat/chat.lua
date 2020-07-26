

CHAT_LINE_HEIGHT = 100;
g_emoticonTypelist = {"Normal", "Motion"}

function CHAT_ON_INIT(addon, frame)	
	
	-- 마우스 호버링을 위한 마우스 업할때 닫기 이벤트 설정 부분.
	local btn_emo = GET_CHILD(frame, "button_emo");
	btn_emo:SetEventScript(ui.MOUSEMOVE, "CHAT_OPEN_EMOTICON");
	btn_emo:SetEventScript(ui.LBUTTONUP, "CHAT_OPEN_EMOTICON_GROUP");

	local btn_type = GET_CHILD(frame, "button_type");
	btn_type:SetEventScript(ui.MOUSEMOVE, "CHAT_OPEN_TYPE");	

end

function CHAT_OPEN_INIT()
	--'채팅 타입'에 따른 채팅바의 '채팅타입 버튼 목록'이 결정된다.
	if config.GetServiceNation() == "GLOBAL_JP" or config.GetServiceNation() == "GLOBAL" or config.GetServiceNation() == "IDN" then
		local frame = ui.GetFrame('chat');	
		local chatEditCtrl = frame:GetChild('mainchat');
		local btn_emo = GET_CHILD(frame, "button_emo");
		local titleCtrl = GET_CHILD(frame,'edit_to_bg');	
		chatEditCtrl:Resize((chatEditCtrl:GetOriginalWidth()- 23) - btn_emo:GetWidth() - titleCtrl:GetWidth() - 28, chatEditCtrl:GetOriginalHeight());
	end
end;

function CHAT_CLOSE_SCP()
	CHAT_CLICK_CHECK();
end;

function CHAT_WHISPER_INVITE(ctrl, ctrlset, roomID, artNum)
	ctrl:SetUserValue("ROOM_ID",roomID)
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER2", "",nil,roomID,20);
end

function CHAT_NOTICE(msg)
	session.ui.GetChatMsg():AddNoticeMsg(ScpArgMsg("NoticeFrameName"), msg, true); 
end

function CHAT_SYSTEM(msg, color)
	session.ui.GetChatMsg():AddSystemMsg(msg, true, 'System', color);
end


--채팅타입에 따라 '채팅바의 입력기' 위치와 크기 설정. 
function CHAT_SET_TO_TITLENAME(chatType, targetName)
	local frame = ui.GetFrame('chat');
	local chatEditCtrl = frame:GetChild('mainchat');
	local titleCtrl = GET_CHILD(frame,'edit_to_bg');
	local editbg = GET_CHILD(frame,'edit_bg');
	local name  = GET_CHILD(titleCtrl,'title_to');		
	local btn_ChatType = GET_CHILD(frame,'button_type');

	-- 귓속말 ctrl의 시작위치는 type btn 뒤쪽에.
	if config.GetServiceNation() == "GLOBAL" then
		titleCtrl:SetOffset(btn_ChatType:GetOriginalWidth() + 20, titleCtrl:GetOriginalY());
	else
		titleCtrl:SetOffset(btn_ChatType:GetOriginalWidth(), titleCtrl:GetOriginalY());
	end
	local offsetX = btn_ChatType:GetOriginalWidth(); -- 시작 offset은 type btn 넓이 다음으로.
	local titleText = '';
	local isVisible = 0;

	-- 귓말과 그룹채팅에 따른 상대를 표시해야 할 경우 
	if chatType == CT_WHISPER then

		isVisible = 1;
		titleText = ScpArgMsg('WhisperChat','Who',targetName);

	elseif chatType == CT_GROUP then
		
		isVisible = 1;
		titleText = session.chat.GetRoomConfigTitle(targetName)
		if titleText == "" or titleText == nil then
			return
		end

	end
		
	-- 이름을 먼저 설정해줘야 크기와 위치 설정이 이루어진다.
	name:SetText(titleText);	
	if titleText ~= '' then
		titleCtrl:Resize(name:GetWidth() + 20, titleCtrl:GetOriginalHeight())
	else
		titleCtrl:Resize(name:GetWidth(), titleCtrl:GetOriginalHeight())
	end
		
	if isVisible == 1 then
		titleCtrl:SetVisible(1);
		offsetX = offsetX + titleCtrl:GetWidth();
	else
		titleCtrl:SetVisible(0);
	end;
		
	local width = chatEditCtrl:GetOriginalWidth() - titleCtrl:GetWidth() - btn_ChatType:GetWidth();
	chatEditCtrl:Resize(width, chatEditCtrl:GetOriginalHeight());
	
	if config.GetServiceNation() == "GLOBAL" then
	chatEditCtrl:SetOffset(offsetX+20, chatEditCtrl:GetOriginalY());	
	else
			chatEditCtrl:SetOffset(offsetX, chatEditCtrl:GetOriginalY());	
	end		
	
end


-- 채팅창의 이모티콘선택창과 옵션창의 Open 스크립트
--{
function CHAT_OPEN_OPTION(frame)
	CHAT_SET_OPEN(frame, 1);
end

function CHAT_OPEN_EMOTICON(frame)
	CHAT_SET_OPEN(frame, 0);
end
--}

-- 이모티콘 타입 선택 : 일반, 모션
function CHAT_OPEN_EMOTICON_GROUP(frame)
	local context = ui.CreateContextMenu("EMOTICON_GROUP", "", 0, 0, 80, 60);
	local scpScp = "";
	
	local chat_emoticon = ui.GetFrame("chat_emoticon")
	if chat_emoticon == nil then
		return
	end

	for i = 0, #g_emoticonTypelist - 1 do
		scpScp = string.format("CHAT_OPEN_EMOTICON_GROUP_CHANGE(\"%s\")", g_emoticonTypelist[ i + 1 ]);
		ui.AddContextMenuItem(context, ClMsg("emoticon_"..g_emoticonTypelist[ i + 1 ]), scpScp);
	end

	ui.OpenContextMenu(context);
end

function CHAT_OPEN_EMOTICON_GROUP_CHANGE(argStr)
	local frame = ui.GetFrame("chat");
	if frame == nil then
		return;
	end

	local emo_frame = ui.GetFrame('chat_emoticon');
	if emo_frame == nil then
		return;
	end
	
	emo_frame:ShowWindow(0);
	emo_frame:SetUserValue("EMOTICON_GROUP", argStr);
	CHAT_SET_OPEN(frame, 0);
end

-- 채팅창의 이모티콘선택창과 옵션창이 열려있을 경우에 다른 곳 클릭시 해당 창들을 Close
function CHAT_CLICK_CHECK(frame)
	local type_frame = ui.GetFrame('chattypelist');
	local emo_frame = ui.GetFrame('chat_emoticon');
	local opt_frame = ui.GetFrame('chat_option');
	emo_frame:ShowWindow(0);
	opt_frame:ShowWindow(0);
	type_frame:ShowWindow(0);
end;

--이모티콘선택창과 옵션창의 위치를 채팅바에 따라 교정하고 Open 관리
function CHAT_SET_OPEN(frame, numFrame)
	local opt_frame = ui.GetFrame('chat_option');
	opt_frame:SetPos(frame:GetX() + frame:GetWidth() - 35, frame:GetY() - opt_frame:GetHeight());

	local emo_frame = ui.GetFrame('chat_emoticon');
	emo_frame:SetPos(frame:GetX() + 35, frame:GetY() - emo_frame:GetHeight());

	if numFrame == 0 then	
		opt_frame:ShowWindow(0);
		emo_frame:ShowWindow(1);
	elseif numFrame == 1 then
		opt_frame:ShowWindow(1);
		emo_frame:ShowWindow(0);
	end;
end;

-- 채팅창의 '타입 목록 열기 버튼'을 클릭시 '타입 목록'의 위치를 채팅바에 따라 교정하고 Open
function CHAT_OPEN_TYPE()
	local chatFrame = ui.GetFrame('chat');
	local frame = ui.GetFrame('chattypelist');
	frame:SetPos(chatFrame:GetX() + 3, chatFrame:GetY() - frame:GetHeight());	
	frame:ShowWindow(1);	
	frame:SetDuration(3);
end;