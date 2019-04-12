

function CHATPOPUP_MAIN_ON_INIT(addon, frame)

end




function RESIZE_MAIN_POPUP_CHAT(frame)	

	if frame == nil then
		return;
	end

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
						local txt = GET_CHILD(chatCtrl, "text", "ui::CRichText");
						local timeBox = GET_CHILD(chatCtrl, "time");
						RESIZE_CHAT_CTRL(frame, chatCtrl, label, txt, timeBox, offsetX)
							
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

function RESIZE_FRAME_MAIN_POPUP_CHAT_START(parent, ctrl)

	local frame = parent:GetTopParentFrame();

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_Y", frame:GetY());
	frame:SetUserValue("BEFORE_W", frame:GetWidth());
	frame:SetUserValue("BEFORE_H", frame:GetHeight());
	frame:StopUpdateScript("_PROCESS_MOVE_MAIN_POPUPCHAT_FRAME");
	frame:RunUpdateScript("_PROCESS_MOVING_RESIZE_FRAME",  0.01, 0.0, 0, 1);
	
	CHATGBOX_SET_SCROLLBAR(frame, 0);
	frame:Invalidate();
end


function CHATMAINPOPUP_OPEN(frame)
	
	g_chatmainpopoupframename[frame:GetName()] = "open"
end


function CHATMAINPOPUP_CLOSE(frame)
	local key = tonumber(string.sub(frame:GetName(), 11))
	session.chat.RemoveMainFramePopupConfig(key)
	ui.SaveChatConfig()

	g_chatmainpopoupframename[frame:GetName()] = nil
end

function DO_CLOSE_MAINCHATPOPUP(parent,ctrl)
	
	local frame = parent:GetTopParentFrame();	

	frame:ShowWindow(0)

end


function RESIZE_FRAME_MAIN_POPUP_CHAT_END(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
	RESIZE_MAIN_POPUP_CHAT(frame);

	local key = tonumber(string.sub(frame:GetName(), 11))
	session.chat.UpdateMainFramePopupConfig(key, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY(), CHAT_FRAME_GET_NOW_SELECT_VALUE(frame))
	ui.SaveChatConfig()
end

function CHATMAINPOPUP_RESIZE(frame)

	frame:CancelReserveScript("_CHATMAINPOPUP_RESIZE");
	frame:ReserveScript("_CHATMAINPOPUP_RESIZE", 0.3, 0, "");

end

function _CHATMAINPOPUP_RESIZE(frame)

	CHAT_SET_FONTSIZE_N_COLOR(frame)

	local key = tonumber(string.sub(frame:GetName(), 11))
	session.chat.UpdateMainFramePopupConfig(key, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY(), CHAT_FRAME_GET_NOW_SELECT_VALUE(frame))
	ui.SaveChatConfig()
		
end



function MOVE_FRAME_MAIN_POPUP_CHAT_START(parent, ctrl)

	local frame = parent:GetTopParentFrame();

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetX());
	frame:SetUserValue("BEFORE_H", frame:GetY());
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
	frame:RunUpdateScript("_PROCESS_MOVE_MAIN_POPUPCHAT_FRAME",  0.01, 0.0, 0, 1);
	
	CHATGBOX_SET_SCROLLBAR(frame, 0);
end


function MOVE_FRAME_MAIN_POPUP_CHAT_END(parent)

	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVE_MAIN_POPUPCHAT_FRAME");
	RESIZE_MAIN_POPUP_CHAT(frame);

	local key = tonumber(string.sub(frame:GetName(), 11))
	session.chat.UpdateMainFramePopupConfig(key, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY(), CHAT_FRAME_GET_NOW_SELECT_VALUE(frame))
	ui.SaveChatConfig()	
	
end

function _PROCESS_MOVE_MAIN_POPUPCHAT_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
        MOVE_FRAME_MAIN_POPUP_CHAT_END(frame)
		return 0;
	end
	
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local limitOffset = 10;
	local limitMaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth() - limitOffset;
	local limitMaxHeight = limitMaxWidth * ratio - limitOffset * 12;

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
	

	if width < limitOffset then
		width = limitOffset;
	end;

	if height < limitOffset then
		height = limitOffset;
	end;

	local wndW = frame:GetWidth();
	local wndH = frame:GetHeight() 

	if (width + wndW) > limitMaxWidth then
		width = limitMaxWidth - wndW;
	end;
	
	if (height + wndH) > limitMaxHeight then
		height = (limitMaxHeight - wndH) ;
	end;

	frame:SetOffset(width, height);

	return 1;
end
