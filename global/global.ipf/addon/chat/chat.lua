--채팅타입에 따라 '채팅바의 입력기' 위치와 크기 설정. 

function CHAT_SET_TO_TITLENAME(chatType, targetName, count)	
	local frame = ui.GetFrame('chat');
	local chatEditCtrl = frame:GetChild('mainchat');
	local titleCtrl = GET_CHILD(frame,'edit_to_bg');
	local editbg = GET_CHILD(frame,'edit_bg');
	local name  = GET_CHILD(titleCtrl,'title_to');		
	local btn_ChatType = GET_CHILD(frame,'button_type');

	-- 귓속말 ctrl의 시작위치는 type btn 뒤쪽에.
	titleCtrl:SetOffset(btn_ChatType:GetOriginalWidth(), titleCtrl:GetOriginalY());
	local offsetX = btn_ChatType:GetOriginalWidth(); -- 시작 offset은 type btn 넓이 다음으로.
	local titleText = '';
	local isVisible = 0;
	-- 귓말과 그룹채팅에 따른 상대를 표시해야 할 경우 
	if chatType == 'whisperchat' or chatType == 'whisperFromchat' or chatType == 'whisperTochat' then
		isVisible = 1;
		titleText = ScpArgMsg('WhisperChat','Who',targetName);
	elseif chatType == 'groupchat' then
		if count > 1 then
			titleText = ScpArgMsg('GroupChat','Who',targetName,'Count',count-1);
		else
			titleText = ScpArgMsg('WhisperChat','Who',targetName);
		end
		isVisible = 1;
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
	chatEditCtrl:Resize(width, chatEditCtrl:GetOriginalHeight())
	chatEditCtrl:SetOffset(offsetX, chatEditCtrl:GetOriginalY());			
end
