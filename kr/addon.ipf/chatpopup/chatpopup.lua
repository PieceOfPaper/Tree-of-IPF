

g_chatpopoupframename = {}

function RESIZE_POPUP_CHAT(frame)	

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

    local roomid = string.sub(frame:GetName(), 11)
    chat.EnableUpdateReadFlag(roomid)
    UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomid)
end


function CHATPOPUP_OPEN(frame)
	local roomname = string.sub(frame:GetName(), 11)
	session.chat.SetShowPopup(roomname, 1)
	ui.SaveChatConfig()

	g_chatpopoupframename[frame:GetName()] = "open"
end


function CHATPOPUP_CLOSE(frame)
	local roomname = string.sub(frame:GetName(), 11)
	session.chat.SetShowPopup(roomname, 0)
	ui.SaveChatConfig()

	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe == nil then
		return
	end

	memlistframe:ShowWindow(0)

	g_chatpopoupframename[frame:GetName()] = nil
	
end

function DO_CLOSE_CHATPOPUP(frame)
	
	frame:ShowWindow(0)

end


function RESIZE_FRAME_POPUP_CHAT_END(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
	RESIZE_POPUP_CHAT(frame);

	local roomname = string.sub(frame:GetName(), 11)
	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end
	
	session.chat.SetRoomConfigPos(roomname, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY())
	ui.SaveChatConfig()
end


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
end


function _PROCESS_MOVING_RESIZE_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
		frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME");
		CHATGBOX_SET_SCROLLBAR(frame, 1);
		RESIZE_POPUP_CHAT(frame);
		return 0;
	end
	
	local ratio = option.GetClientHeight()/option.GetClientWidth();
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

	local limitOffset = 10;
	local limitMinWidth = frame:GetOriginalWidth() + 10;
	local limitMinHeight = frame:GetOriginalHeight() + 10;
	local limitMaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth() - limitOffset;
	local limitMaxHeight = limitMaxWidth * ratio  - limitOffset * 12;
	
	if limitMinWidth > width then
		width = limitMinWidth;
	end

	if limitMinHeight > height then
		height = limitMinHeight;
		wndY = frame:GetY();
	end
		
	if wndX < limitOffset then
		wndX = limitOffset;
	end;

	if wndY < limitOffset then
		wndY = limitOffset;
	end;
	
	if (width + wndX) > limitMaxWidth then
		width = limitMaxWidth - wndX;
	end;

	if (height + wndY) > limitMaxHeight then
		height = limitMaxHeight - wndY;
	end;

	if width > 800 then
		width = 800
	end

	if height > 600 then
		height = 600
	end
		
	frame:Resize(wndX, wndY, width, height);

	local roomname = string.sub(frame:GetName(), 11)
	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end

	
	local roomname = string.sub(frame:GetName(), 11)
	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end

	return 1;
end

function CHATPOPUP_FOLD_BY_SIZE(frame)
	

	local edit_bg = GET_CHILD_RECURSIVELY(frame,"edit_bg")
	local mainchat =  GET_CHILD_RECURSIVELY(frame,"mainchat")
	local roomid = string.sub(frame:GetName(), 11)
	local gbox =  GET_CHILD_RECURSIVELY(frame,"chatgbox_" .. roomid)

    if gbox == nil then
        return;
    end

	local reheight =  GET_CHILD_RECURSIVELY(frame,"reheight")
	
	local gboxscroolbar =  GET_CHILD_RECURSIVELY(gbox,"_SCR")
	
	local limitMinWidth = frame:GetOriginalWidth();
	local limitMinHeight = frame:GetOriginalHeight();

	local isfold = false

	if frame:GetWidth() == limitMinWidth and frame:GetHeight() == limitMinHeight then
		isfold = true
		edit_bg:SetMargin(0,0,0,edit_bg:GetHeight())
		edit_bg:ShowWindow(0)
		edit_bg:EnableHitTest(0);
		mainchat:SetMargin(0,0,0,edit_bg:GetHeight())
		mainchat:ShowWindow(0)
		mainchat:EnableHitTest(0);
		gboxscroolbar:ShowWindow(0)
		gbox:SetScrollPos(99999);
		reheight:ShowWindow(0)

		

		local count = gbox:GetChildCount();
		if count > 2 then
			SHOW_CHILD_BYNAME(gbox, "cluster_", 0);
			local cset = gbox:GetChildByIndex(count-1);
			cset:ShowWindow(1)
		end

	else
		SHOW_CHILD_BYNAME(gbox, "cluster_", 1);
		edit_bg:SetMargin(0,0,0,0)
		edit_bg:ShowWindow(1)
		edit_bg:EnableHitTest(1);
		mainchat:SetMargin(0,0,0,0)
		mainchat:ShowWindow(1)
		mainchat:EnableHitTest(1);
		reheight:ShowWindow(1)
	end



	RESIZE_POPUP_CHAT(frame)
	gbox:UpdateData();
	frame:Invalidate();

	if isfold == true then
        gboxscroolbar:ShowWindow(0)
        gbox:EnableHitTest(0)
    else
        gbox:EnableHitTest(1)
    end

    local memlistframe = ui.GetFrame("chatmem_" .. roomid)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end
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

    local roomid = string.sub(frame:GetName(), 11)
    chat.EnableUpdateReadFlag(roomid)
	UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomid)
end


function MOVE_FRAME_POPUP_CHAT_END(parent, ctrl)

	local frame = parent:GetTopParentFrame();	
	CHATGBOX_SET_SCROLLBAR(frame, 1);
	frame:StopUpdateScript("_PROCESS_MOVE_POPUPCHAT_FRAME");
	RESIZE_POPUP_CHAT(frame);

	local roomname = string.sub(frame:GetName(), 11)
	
	if frame:GetWidth() == frame:GetOriginalWidth() and frame:GetHeight() == frame:GetOriginalHeight() then
		session.chat.SetRoomConfigFoldPos(roomname, frame:GetX(), frame:GetY())
	else
		session.chat.SetRoomConfigPos(roomname, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY())
	end

	ui.SaveChatConfig()	

	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end
	
end

function _PROCESS_MOVE_POPUPCHAT_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
		MOVE_FRAME_POPUP_CHAT_END(frame)
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

	local roomname = string.sub(frame:GetName(), 11)
	local memlistframe = ui.GetFrame("chatmem_" .. roomname)
	if memlistframe ~= nil then
		memlistframe:SetOffset(frame:GetX() + frame:GetWidth(), frame:GetY())
	end

	return 1;
end


function POPUPCHAT_EDITCTRL_LDOWN(parent, ctrl)

	ui.CloseFrame('chat')

	local frame = parent:GetTopParentFrame();
	local roomid = string.sub(frame:GetName(), 11)
	
    chat.EnableUpdateReadFlag(roomid)
	UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomid)

end



function SEND_POPUP_FRAME_CHAT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local guid = string.sub(parent:GetName() , 11, string.len(parent:GetName() ))


	local info = session.chat.GetByStringID(guid);

	if info == nil then
		return;
	end

	local sendText = ""
	local text = ctrl:GetText();

	if text == "" then
		return;
	end

	if info:GetRoomType() == 0 then

		local target = info:GetWhisperTargetName()
		sendText = "/w " .. target .. " " .. text;

        ui.SetWhisperTargetName(target)
		
	elseif info:GetRoomType() == 3 then

		sendText = "/f " .. guid .. " " .. text;

        ui.SetGroupChatTargetID(guid)

	else

		ctrl:SetText("");
		return

	end

	ctrl:SetText("");
	ui.Chat(sendText);

end


function GROUPCHAT_SHOW_MEMBER_LIST(parent)

	local frame = parent:GetTopParentFrame();

	local roomname = string.sub(frame:GetName(), 11)
	local memlistframe = ui.GetFrame("chatmem_" .. roomname)

	if memlistframe == nil then
		return
	end

	if memlistframe:IsVisible() == 1 then
		memlistframe:ShowWindow(0)
	else
		memlistframe:ShowWindow(1)
	end

end

function _IS_SEPARATE(a_left, a_right, a_top, a_bottom, b_left, b_rigtht, b_top, b_bottom)
	
	return a_right < b_left or a_left > b_rigtht or a_top > b_bottom or a_bottom < b_top

end

g_defpopupx = 150
g_defpopupy = 150

function CHAT_POPUP_GET_EMPTY_PLACE(framename, width, height)

	local retx = 0
	local rety = 0

	someotherframes = {}
	someotherframes["headsupdisplay"] = "somevalue"
	someotherframes["chatframe"] = "somevalue"
	someotherframes["questinfoset_2"] = "somevalue"
	someotherframes["minimap"] = "somevalue"

	local ret = false

	for x = 30, 1600 - width, 10 do	

		for y = 30, 1000 - height, 10 do		

			ret = true

			local left = x
			local right = x + width
			local top = y
			local bottom = y + height
			
			for k,v in pairs(someotherframes) do
	
				local chatframe = ui.GetFrame(k)
				if ret == true and chatframe ~= nil and k ~= framename then
					
					if _IS_SEPARATE(left, right, top, bottom, chatframe:GetX(), chatframe:GetX() + chatframe:GetWidth(), chatframe:GetY(), chatframe:GetY() + chatframe:GetHeight() ) == false then
						ret = false
					end
				end
			end
			
			for k,v in pairs(g_chatmainpopoupframename) do
	
				local chatframe = ui.GetFrame(k)
				if ret == true and chatframe ~= nil and chatframe:IsVisible() == 1 and k ~= framename  then

					if _IS_SEPARATE(left, right, top, bottom, chatframe:GetX(), chatframe:GetX() + chatframe:GetWidth(), chatframe:GetY(), chatframe:GetY() + chatframe:GetHeight() ) == false then
						ret = false
					end
				end
			end

			for k,v in pairs(g_chatpopoupframename) do
	
				local chatframe = ui.GetFrame(k)

				if ret == true and chatframe ~= nil and chatframe:IsVisible() == 1 and k ~= framename then
					if _IS_SEPARATE(left, right, top, bottom, chatframe:GetX(), chatframe:GetX() + chatframe:GetWidth(), chatframe:GetY(), chatframe:GetY() + chatframe:GetHeight() ) == false then
						ret = false
					end
				end
			end

			if ret == true then
				
				retx = x
				rety = y
				break;
			end
	
		end

		if ret == true then
			break;
		end
	end

	if retx == 0 and rety == 0 then
		retx = g_defpopupx
		rety = g_defpopupy

		g_defpopupx = g_defpopupx + 40
		g_defpopupy = g_defpopupy + 20
	end

	return retx, rety;
	
end

function DO_FOLD_ROOM(key, x, y)

	local popupframe = ui.GetFrame('chatpopup_'..key);

	if popupframe ~= nil then

		popupframe:Resize(popupframe:GetOriginalWidth(), popupframe:GetOriginalHeight())
		popupframe:SetOffset(x, y)

		CHATPOPUP_FOLD_BY_SIZE(popupframe)
		session.chat.SetShowPopup(key, 2)
		ui.SaveChatConfig()

	end
end


function DO_UNFOLD_ROOM(key, x, y, width, height)

	local popupframe = ui.GetFrame('chatpopup_'..key);

	if popupframe ~= nil then

		popupframe:Resize(width, height)
		popupframe:SetOffset(x, y)

		CHATPOPUP_FOLD_BY_SIZE(popupframe)
		session.chat.SetShowPopup(key, 1)
		ui.SaveChatConfig()

	end
end

function MOVE_FRAME_POPUP_CHAT_LBTNDBLCLICK(parent, ctrl)
	
	local frame = parent:GetTopParentFrame();

	local roomname = string.sub(frame:GetName(), 11)
	
	if frame:GetWidth() == frame:GetOriginalWidth() and frame:GetHeight() == frame:GetOriginalHeight() then
		session.chat.DoUnFoldRoom(roomname)
	else
		session.chat.DoFoldRoom(roomname)
	end

end