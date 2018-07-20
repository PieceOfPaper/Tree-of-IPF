

function CHAT_GROUPLIST_OPTION_ON_INIT(addon, frame)



end

function CHAT_GROUPLIST_SELECT_COLOR(parent, ctrl, strarg, numarg)

	local frame = ui.GetFrame("chat_grouplist_option")
	frame:SetUserValue("SelectedColor",tostring(numarg))

	CHAT_GROUPLIST_OPTION_DRAW_CHECKMARK(numarg)
end

function CHAT_GROUPLIST_OPTION_DO_OPEN(frame)

	for i = 0, 9 do

		local colorCls = GetClass("ChatColorStyle", "Class"..i)
	
		if colorCls ~= nil then

			local objname = "color" .. i
			local obj = GET_CHILD_RECURSIVELY(frame, objname)
			obj:SetEventScript(ui.LBUTTONDOWN, 'CHAT_GROUPLIST_SELECT_COLOR');
			obj:SetEventScriptArgNumber(ui.LBUTTONDOWN, i + 100);
			obj:SetColorTone("FF"..colorCls.TextColor)
			obj:SetTextTooltip(colorCls.Name)
			
		end
	end


	frame:SetUserValue("SelectedColor","0")


	local roomid = frame:GetUserValue("ROOMID")

	local info = session.chat.GetByStringID(roomid);
	
	if info == nil	then
		return;
	end

	local titleedit = GET_CHILD_RECURSIVELY(frame,"groupname_edit")
	local title = session.chat.GetRoomConfigTitle(roomid)
	titleedit:SetText(title)

	if info:GetRoomType() == 3 then
		titleedit:SetEnable(1)
	else
		titleedit:SetEnable(0)
	end

	local colorType = session.chat.GetRoomConfigColorType(roomid)
	
	CHAT_GROUPLIST_OPTION_DRAW_CHECKMARK(colorType)

	frame:Invalidate();
	frame:ShowWindow(1);
end

function CHAT_GROUPLIST_OPTION_DRAW_CHECKMARK(colorType)

	local clslist, cnt  = GetClassList("ChatColorStyle");

	local frame = ui.GetFrame("chat_grouplist_option")
	local vmark = GET_CHILD_RECURSIVELY(frame,"vmark")

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if cls.ClassID == colorType then
		    vmark:SetOffset(i * 25, vmark:GetY())
		end
	end

end

function CHAT_GROUPLIST_OPTION_OK(frame)

	local roomid = frame:GetUserValue("ROOMID")
	local selectedColor = frame:GetUserValue("SelectedColor")

	local info = session.chat.GetByStringID(roomid);
	
	if info == nil then
		frame:ShowWindow(0)
		return;
	end

	if info:GetRoomType() == 3 then
		
		local titleedit = GET_CHILD_RECURSIVELY(frame,"groupname_edit")
		local newtitle = titleedit:GetText()
		session.chat.SetRoomConfigTitle(roomid, newtitle)

        local chatframe = ui.GetFrame("chat")
	    
        if chatframe ~= nil and chatframe:GetUserValue("CHAT_TYPE_SELECTED_VALUE") == 6 then
		    CHAT_SET_TO_TITLENAME(CT_GROUP, ui.GetGroupChatTargetID() )
        end
	
	end

	if selectedColor ~= "0" then
		session.chat.SetRoomConfigColorType(roomid, tonumber(selectedColor))
	end

	
	ui.SaveChatConfig()
	

	CHAT_CREATE_OR_UPDATE_GROUP_LIST(roomid);
	UPDATE_GROUPLIST_TEXT("chatgbox_"..roomid);
	UPDATE_CHAT_MEMBERLIST(roomid)

	local chatFrame = ui.GetFrame("chatframe");
	CHAT_SET_FONTSIZE_N_COLOR(chatFrame);

	for k,v in pairs(g_chatmainpopoupframename) do
		
		local chatframe = ui.GetFrame(k)
		
		if chatframe ~= nil then
			CHAT_SET_FONTSIZE_N_COLOR(chatframe)
		end
	end

	session.chat.ChangeFontToAllPopupFrame();

	frame:ShowWindow(0)
end


function CHAT_GROUPLIST_OPTION_OUT(frame)
	
	local roomid = frame:GetUserValue("ROOMID")

	ui.LeaveGroupOrWhisperChat(roomid);
	ui.SaveChatConfig()
	frame:ShowWindow(0)
end