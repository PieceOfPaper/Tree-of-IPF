
function RESIZE_POPUP_CHAT(frame)	
	local textVer = IS_TEXT_VER_CHAT();	
	local offsetX = frame:GetUserConfig("CTRLSET_OFFSETX");
	local count = frame:GetChildCount();
	for  i = 0, count-1 do 
		local groupBox  = frame:GetChildByIndex(i);
		local childName = groupBox:GetName();
		if string.sub(childName, 1, 9) == "chatgbox_" then
			if groupBox:GetClassName() == "groupbox" then
				groupBox = AUTO_CAST(groupBox);
				local beforeHeight = 1;
				local lastChild = nil;
				local ctrlSetCount = groupBox:GetChildCount();
				for j = 0 , ctrlSetCount - 1 do
					local chatCtrl = groupBox:GetChildByIndex(j);
					if chatCtrl:GetClassName() == "controlset" then
							local label = chatCtrl:GetChild('bg');
							if textVer == 0 then
								--풍선 버젼
								local txt = GET_CHILD(label, "text", "ui::CRichText");
								RESIZE_CHAT_CTRL(frame, chatCtrl, label, txt, 0, offsetX)				
							else
								--간략화 버젼
								local txt = GET_CHILD(chatCtrl, "text", "ui::CRichText");
								RESIZE_CHAT_CTRL(frame, chatCtrl, label, txt, 1, offsetX)
							end;
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
	frame:Invalidate();
end;

function RESIZE_FRAME_POPUP_CHAT_START(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_Y", frame:GetY());
	frame:SetUserValue("BEFORE_W", frame:GetWidth());
	frame:SetUserValue("BEFORE_H", frame:GetHeight());
	frame:StopUpdateScript("_PROCESS_MOVE_POPUPCHAT_FRAME");
	frame:RunUpdateScript("_PROCESS_MOVING_RESIZE_FRAME",  0.01, 0.0, 0, 1);
	
	CHATGBOX_SET_SCROLLBAR(frame, 0);
	frame:Invalidate();
end;

function RESIZE_FRAME_POPUP_CHAT_END(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
	RESIZE_POPUP_CHAT(frame);
	ui.SaveChatConfig()
end;

function CHATGBOX_SET_SCROLLBAR(frame, bYes)
	local count = frame:GetChildCount();
	for  i = 0, count-1 do 
		local groupBox  = frame:GetChildByIndex(i);
		local childName = groupBox:GetName();
		if string.sub(childName, 1, 9) == "chatgbox_" then
			if groupBox:GetClassName() == "groupbox" then
				groupBox = AUTO_CAST(groupBox);
				groupBox:EnableHitTest(bYes);
			end				
		end
	end
	frame:Invalidate();
end;

function _PROCESS_MOVING_RESIZE_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
		frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
		CHATGBOX_SET_SCROLLBAR(frame, 1);
		RESIZE_POPUP_CHAT(frame);
		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);
	
	local wndX = frame:GetX();
	local wndY = frame:GetUserIValue("BEFORE_Y");
	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height - dy;
	wndY = wndY + dy;

	local limitMinWidth = frame:GetOriginalWidth();
	local limitMinHeight = frame:GetOriginalHeight();

	if limitMinWidth > width then
		width = limitMinWidth;
	end
	
	if limitMinHeight > height then
		height = limitMinHeight;
		wndY = frame:GetY();
	end

	if wndX < 10 then
		wndX = 10;
	end;

	if wndY < 10 then
		wndY = 10;
	end;
	
	local limitMaxWidth = ui.GetClientInitialWidth() - 10;
	local limitMaxHeight = ui.GetClientInitialHeight() - 10;

	if (width + wndX) > limitMaxWidth then
		width = limitMaxWidth - wndX;
	end;

	if (height + wndY) > limitMaxHeight then
		height = limitMaxHeight - wndY;
	end;
		
	frame:Resize(wndX, wndY, width, height);
	return 1;
end


function MOVE_FRAME_POPUP_CHAT_START(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetX());
	frame:SetUserValue("BEFORE_H", frame:GetY());
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
	frame:RunUpdateScript("_PROCESS_MOVE_POPUPCHAT_FRAME",  0.01, 0.0, 0, 1);
	
	CHATGBOX_SET_SCROLLBAR(frame, 0);
end

function MOVE_FRAME_POPUP_CHAT_END(parent, ctrl)

	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVE_POPUPCHAT_FRAME");
	RESIZE_POPUP_CHAT(frame);
	ui.SaveChatConfig()	
end

function _PROCESS_MOVE_POPUPCHAT_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
		frame:StopUpdateScript("_PROCESS_MOVE_POPUPCHAT_FRAME");
		CHATGBOX_SET_SCROLLBAR(frame, 1);
		RESIZE_POPUP_CHAT(frame);
		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);

	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height + dy;
	
	if width < 10 then
		width = 10;
	end;

	if height < 10 then
		height = 10;
	end;
	
	local limitMaxWidth = ui.GetClientInitialWidth() - 10;
	local limitMaxHeight = ui.GetClientInitialHeight() - 10;
	local wndX = frame:GetWidth();
	local wndY = frame:GetHeight();

	if (width + wndX) > limitMaxWidth then
		width = limitMaxWidth - wndX;
	end;

	if (height + wndY) > limitMaxHeight then
		height = limitMaxHeight - wndY;
	end;
	
	frame:SetOffset(width, height);

	return 1;
end