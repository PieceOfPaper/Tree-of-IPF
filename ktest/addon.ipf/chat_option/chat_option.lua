function CHAT_OPTION_ON_INIT()
end

function INIT_CHATTYPE_VISIBLE_PIC()

	local frame = ui.GetFrame("chat_option")
    if frame == nil then
        return
    end

	for index = 1, 3 do

		local value = session.chat.GetTabConfigValueByIndex(index-1);
		local tabgbox = GET_CHILD_RECURSIVELY(frame,"tabgbox"..index)

		UPDATE_CHATTYPE_VISIBLE_PIC(tabgbox, value)

	end

end

function CHAT_OPTION_TAB_BTN_CLICK(parent, ctrl)

	local name = ctrl:GetName()

	

	if string.find(name,"_pic") ~= nil then
		ctrl:ShowWindow(0)
	else
		local pic = GET_CHILD_RECURSIVELY(parent, name.."_pic")
		pic:ShowWindow(1)
	end

	local index = 0;

	if parent:GetName() == "tabgbox1" then
		index = 1
	elseif parent:GetName() == "tabgbox2" then
		index = 2
	elseif parent:GetName() == "tabgbox3" then
		index = 3
	end

	local retbit = CHAT_FRAME_GET_NOW_SELECT_VALUE(parent)

	if retbit == 0 then
		retbit = session.chat.GetTabConfigValueByIndex(index-1);
	end
	
	if retbit == 63 then
		retbit = 0
	end


	session.chat.SetTabConfigByIndex(index-1, retbit)
	local value = session.chat.GetTabConfigValueByIndex(index-1);
	
	local optionframe = ui.GetFrame("chat_option")
	local tabgbox = GET_CHILD_RECURSIVELY(optionframe,"tabgbox"..index)

	local frame = ui.GetFrame("chatframe")
	if index -1 == tonumber(frame:GetUserValue("BTN_INDEX")) then
		UPDATE_CHAT_FRAME_SELECT_CHATTYPE(frame, value)
	end

	UPDATE_CHATTYPE_VISIBLE_PIC(tabgbox, value)

end


function CHAT_OPTION_CREATE(addon, frame)
	local slide_opacity = GET_CHILD(frame, "slide_opacity");
	local opacity = session.chat.GetChatUIOpacity();

	slide_opacity:SetLevel(opacity);

	local slide_fontsize = GET_CHILD(frame, "slide_fontsize");
    local fontSize = session.chat.GetChatUIFontSize();
	slide_fontsize:SetLevel(fontSize);
end

function CHAT_OPTION_OPEN(frame)
	local beforeOpacity = session.chat.GetChatUIOpacity()
	frame:SetUserValue("BEFORE_OPACITY", beforeOpacity);	
end

function CHAT_OPTION_APPLY(frame)
	
	local slide_opacity = GET_CHILD(frame, "slide_opacity", "ui::CSlideBar");
    session.chat.SetChatUIOpacity(slide_opacity:GetLevel())
	CHAT_OPTION_OPEN(frame);
	frame:ShowWindow(0);
    ui.SaveChatConfig()

end

function CHAT_OPTION_CANCEL(frame)

	frame:ShowWindow(0);
end

function CHATOPTION_OPACITY(frame, slide, str, num)	
    session.chat.SetChatUIOpacity(num)
    ui.SaveChatConfig()
	CHAT_SET_OPACITY(num);
end

function CHATOPTION_FONTSIZE(frame, slide, str, num)	
    session.chat.SetChatUIFontSize(num);
    ui.SaveChatConfig()
	local chatFrame = ui.GetFrame("chatframe");
	CHAT_SET_FONTSIZE_N_COLOR(chatFrame);

	for k,v in pairs(g_chatmainpopoupframename) do
		
		local chatframe = ui.GetFrame(k)
		
		if chatframe ~= nil then
			CHAT_SET_FONTSIZE_N_COLOR(chatframe)
		end
	end

	session.chat.ChangeFontToAllPopupFrame();
end

function GET_CHAT_FONT_SIZE()

	local fontSize = session.chat.GetChatUIFontSize();

	local size = 16
	if fontSize < 100 then
		size = math.floor((fontSize * 3 / 100) + 13)
	else
		fontSize = fontSize - 100
		size = math.floor((fontSize * 8 / 100) + 16)
	end

	return size 
			
end


function CHAT_SET_OPACITY(num)

	local chatFrame = ui.GetFrame("chatframe");
	if chatFrame == nil then
		return;
	end

	local colorToneStr = string.format("%02X", num);				
	colorToneStr = colorToneStr .. "FFFFFF";

	CHAT_SET_CHAT_FRAME_OPACITY(chatFrame, colorToneStr)


	for k,v in pairs(g_chatmainpopoupframename) do
	
		local chatframe = ui.GetFrame(k)
		if chatframe ~= nil then
			CHAT_SET_CHAT_FRAME_OPACITY(chatframe, colorToneStr)
		end
	end

	for k,v in pairs(g_chatpopoupframename) do
	
		local chatframe = ui.GetFrame(k)
		if chatframe ~= nil then
			CHAT_SET_CHAT_FRAME_OPACITY(chatframe, colorToneStr)
		end
	end
end

function CHAT_OPTION_UPDATE_CHECKBOX(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local name = ctrl:GetName();
	if name == 'damageCheck' then
		local damageCheck_others = GET_CHILD_RECURSIVELY(frame, 'damageCheck_others');
		local damageCheck_my = GET_CHILD_RECURSIVELY(frame, 'damageCheck_my');
		if ctrl:IsChecked() == 0 then			
			damageCheck_others:SetCheck(0);
			damageCheck_my:SetCheck(0);
		else
			damageCheck_others:SetCheck(1);
			damageCheck_my:SetCheck(1);
		end
	elseif name == 'resurrectCheck' then
		local resurrectCheck_party = GET_CHILD_RECURSIVELY(frame, 'resurrectCheck_party');
		if ctrl:IsChecked() == 0 then
			resurrectCheck_party:SetCheck(0);
		end		
	end
end