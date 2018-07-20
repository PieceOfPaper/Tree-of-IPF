CHAT_TAB_TYPE_NORMAL = 1
CHAT_TAB_TYPE_SHOUT = 2
CHAT_TAB_TYPE_PARTY = 4
CHAT_TAB_TYPE_GUILD = 8
CHAT_TAB_TYPE_WHISPER = 16
CHAT_TAB_TYPE_GROUP = 32
CHAT_TAB_TYPE_SYSTEM = 64
CHAT_TAB_TYPE_BATTLE = 128
CHAT_TAB_TYPE_COUNT = 8

MAX_CHAT_CONFIG_VALUE = 2^CHAT_TAB_TYPE_COUNT - 1;

function CHATFRAME_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "ON_GAME_START");
    addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'CHATFRAME_ON_RESOLUTION_CHANGE');

	CREATE_DEF_CHAT_GROUPBOX(frame)

	chat.RefreshChatRooms();
	
	local frameholdbtn = GET_CHILD_RECURSIVELY(frame,"frameholdbtn")
	local IsHoldMainChatFrame = config.GetXMLConfig("HoldMainChatFrame")
	
	if IsHoldMainChatFrame == 1 then
		frameholdbtn:SetImage("chat_lock_btn2");
		frame:EnableResize(0)
	else
		frameholdbtn:SetImage("chat_lock_btn");
		frame:EnableResize(1)
	end

        local chatframe = ui.GetFrame("chatframe")

    local allreadcounttext = GET_CHILD_RECURSIVELY(frame, "readcnt_all") 
	allreadcounttext:ShowWindow(0)
	local allreadcounttextbg = GET_CHILD_RECURSIVELY(frame, "readcnt_all_bg") 
	allreadcounttextbg:ShowWindow(0)

end

function CHATFRAME_ON_RESOLUTION_CHANGE()

    ui.ReDrawAllChatMsg()

    local frame = ui.GetFrame('chatframe');
    if frame ~= nil then
        frame:SetUserConfig('NEED_REDRAW', 'TRUE');
    end
end


function CHATFRAME_OPEN()

    local frame = ui.GetFrame('chatframe');
    if frame ~= nil then
        local needDraw = frame:GetUserConfig('NEED_REDRAW');

        if needDraw == "TRUE" then
            ui.ReDrawAllChatMsg()
            frame:SetUserConfig('NEED_REDRAW', 'FALSE');
        end

    end
    

end


function CHATFRAME_CLOSE()

	local frame = ui.GetFrame('chat_grouplist');
	frame:ShowWindow(0)
	
end

function _ADD_NEW_CHAT_GBOX(frame, groupboxname)

	local gboxleftmargin = frame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = frame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = frame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = frame:GetUserConfig("GBOX_BOTTOM_MARGIN")

	frame:RemoveChild(groupboxname)
	local newgroupbox = frame:CreateControl("groupbox", groupboxname, frame:GetWidth() - (gboxleftmargin + gboxrightmargin), frame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);


	if frame:GetName() == "chatframe" then
		frame:RemoveChild("bottomlockbtn")
		local bottomlockbtn = frame:CreateControl("button", "bottomlockbtn", 22, 26, ui.LEFT, ui.BOTTOM, 0, 0, 0, 0);
		bottomlockbtn = tolua.cast(bottomlockbtn, "ui::CButton");
		bottomlockbtn:SetEventScript(ui.LBUTTONUP, 'TOGGLE_BOTTOM_CHAT');
		bottomlockbtn:SetTextTooltip(ScpArgMsg("SetScrollBarBottom"));
		local IsBottomChat = config.GetXMLConfig("ToggleBottomChat")
		if IsBottomChat == 0 then
			bottomlockbtn:SetImage("chat_down_btn");
		else
			bottomlockbtn:SetImage("chat_down_btn2");
		end
	end

	return newgroupbox

end




function CHAT_TABSET_BTN_CLICK()

	local frame = ui.GetFrame("chatframe")

	local index = tonumber(frame:GetUserValue("BTN_INDEX"))
	if index == nil then
		return
	end

	index = index + 1
	if index > 2 then 
		index = 0
	end

	CHAT_TABSET_SELECT(index)
end


function CREATE_DEF_CHAT_GROUPBOX(frame)

	DESTROY_CHILD_BYNAME(frame, 'chatgbox_');

	local gbox = _ADD_NEW_CHAT_GBOX(frame, "chatgbox_TOTAL")

	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)
	
	gbox:ShowWindow(1)
	frame:Invalidate()
end


function _ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

	gbox = AUTO_CAST(gbox)
	
	local parentframe = gbox:GetParent()

	
	gbox:SetLeftScroll(1)
	gbox:SetSkinName("chat_window")
	gbox:EnableVisibleVector(true);
	gbox:EnableHitTest(1);
	gbox:EnableHittestGroupBox(true);
	gbox:LimitChildCount(500);
	gbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
	gbox:EnableAutoResize(true,true);

	if string.find(parentframe:GetName(),"chatpopup_") == nil then
		gbox:ShowWindow(0)
		gbox:SetScrollBarBottomMargin(26)
	else
		gbox:SetScrollBarBottomMargin(0)
		gbox:ShowWindow(1)
	end

    local opacity = session.chat.GetChatUIOpacity()
	local colorToneStr = string.format("%02X", opacity);				
	colorToneStr = colorToneStr .. "FFFFFF";

	CHAT_SET_CHAT_FRAME_OPACITY(parentframe, colorToneStr)

end

function CHAT_GBOX_LBTN_DOWN(parent, ctrl, str, num)

    chat.EnableUpdateReadFlag(str)
	UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. str)

end


function SCROLL_CHAT(parent, ctrl, str, wheel)

    if ctrl:IsVisible() == 0 then
		return;
	end

	local gboxname = ctrl:GetName()
	local gboxtype = string.sub(gboxname,string.len("chatgbox_") + 1)
	local tonumberret = tonumber(gboxtype)

    if tonumberret ~= nil and tonumberret > (2^CHAT_TAB_TYPE_COUNT) - 1 then
        chat.EnableUpdateReadFlag(gboxtype)
		UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. gboxtype)
	end

	if wheel == 0 then

		if gboxtype == "TOTAL" then
			chat.ReqPartyChatHistory();
			chat.ReqGuildChatHistory();
		else
			if tonumberret ~= nil and tonumberret > 0 and tonumberret < (2^CHAT_TAB_TYPE_COUNT) - 1 then
				if IMCAnd(CHAT_TAB_TYPE_PARTY, tonumberret) ~= 0  then
					chat.ReqPartyChatHistory();
				elseif IMCAnd(CHAT_TAB_TYPE_GUILD, tonumberret) ~= 0  then
					chat.ReqGuildChatHistory();
				end
			end
		end
	end
	
end

function CHATFRAME_RESIZE(frame)

	frame:CancelReserveScript("_CHATFRAME_RESIZE");
	frame:ReserveScript("_CHATFRAME_RESIZE", 0.3, 0, "");

end

function _CHATFRAME_RESIZE(frame)

	CHAT_SET_FONTSIZE_N_COLOR(frame)

	local beforewidth = config.GetXMLConfig("ChatFrameSizeWidth")
	if frame:GetWidth() + 10 >= beforewidth then
	
	end

	config.ChangeXMLConfig("ChatFrameSizeWidth", frame:GetWidth()); 
	config.ChangeXMLConfig("ChatFrameSizeHeight", frame:GetHeight()); 	
		
end

function RESIZE_CHAT_CTRL(groupbox, chatCtrl, label, txt, timeBox, offsetX)

	local chatWidth = groupbox:GetWidth();
    txt:SetTextMaxWidth(groupbox:GetWidth() - 100);
    txt:SetText(txt:GetText())
	label:Resize(chatWidth - offsetX, txt:GetHeight());
	chatCtrl:Resize(chatWidth, label:GetHeight());
	
	
end;


function TOGGLE_HOLD_BTN()

	local IsHoldMainChatFrame = config.GetXMLConfig("HoldMainChatFrame")
	local frame = ui.GetFrame("chatframe")
	local frameholdbtn = GET_CHILD_RECURSIVELY(frame,"frameholdbtn")

	if IsHoldMainChatFrame == 1 then
		config.ChangeXMLConfig("HoldMainChatFrame",0)
		frameholdbtn:SetImage("chat_lock_btn");
		frame:EnableResize(1)
	else
		config.ChangeXMLConfig("HoldMainChatFrame",1)
		frameholdbtn:SetImage("chat_lock_btn2");
		frame:EnableResize(0)
	end
end

function ON_GAME_START(frame)
	
	frame:Resize(config.GetXMLConfig("ChatFrameSizeWidth"),config.GetXMLConfig("ChatFrameSizeHeight"))
	frame:Invalidate()
end

function DRAW_CHAT_MSG_ROOM(groupboxname, startindex)

	if startindex < 0 then
		return;
	end

	local popupframename = "chatpopup_" ..string.sub(groupboxname, 10, string.len(groupboxname))
	
	local popupframe = ui.GetFrame(popupframename)
	if popupframe == nil then
		return
	end

	if DRAW_CHAT_MSG(groupboxname, startindex, popupframe) ~= 1 then
		ReserveScript( string.format("DRAW_CHAT_MSG_ROOM(\"%s\",\"%d\")", groupboxname, -1) , 3);
	end

	CHATPOPUP_FOLD_BY_SIZE(popupframe)

end

g_chatmainpopoupframename = {}

function DRAW_CHAT_MSG_DEF(groupboxname, startindex)

	if startindex < 0 then
		return;
	end

	local chatframe = ui.GetFrame("chatframe")
	if chatframe == nil then
		return
	end

	if DRAW_CHAT_MSG(groupboxname, startindex, chatframe) ~= 1 then
		ReserveScript( string.format("DRAW_CHAT_MSG_DEF(\"%s\",\"%d\")", groupboxname,-1) , 3);
		return;
	end

 
	
	for k,v in pairs(g_chatmainpopoupframename) do
	
		local chatframe = ui.GetFrame(k)
		
		if chatframe ~= nil then
			DRAW_CHAT_MSG(groupboxname, startindex, chatframe)
		end
		
	end
	
end


function DRAW_CHAT_MSG(groupboxname, startindex, chatframe)
	local mainchatFrame = ui.GetFrame("chatframe");
	local groupbox = GET_CHILD(chatframe, groupboxname);
	local size = session.ui.GetMsgInfoSize(groupboxname);	
	if groupbox == nil then
		return 1;
	end

	if groupbox:IsVisible() == 0 or chatframe:IsVisible() == 0 then
		return 1;
	end

	if startindex == 0 then
		DESTROY_CHILD_BYNAME(groupbox, "cluster_");
	end

	local marginLeft = 20;
	local marginRight = 0;	
	local ypos = 0;
	for i = startindex , size - 1 do
		if i ~= 0 then
			local clusterinfo = session.ui.GetChatMsgInfo(groupboxname, i-1)
			if clusterinfo ~= nil then
				local beforechildname = "cluster_"..clusterinfo:GetMsgInfoID()
				local beforechild = GET_CHILD(groupbox, beforechildname);
				if beforechild ~= nil then
					ypos = beforechild:GetY() + beforechild:GetHeight();
				end
			end
			if ypos == 0 then
				return DRAW_CHAT_MSG(groupboxname, 0, chatframe);
			end
		end
		
		local clusterinfo = session.ui.GetChatMsgInfo(groupboxname, i);
		if clusterinfo == nil then
			return 0;
		end
		local clustername = "cluster_"..clusterinfo:GetMsgInfoID();
		local msgType = clusterinfo:GetMsgType();
		local commnderName = clusterinfo:GetCommanderName();

		local colorType = session.chat.GetRoomConfigColorType(clusterinfo:GetRoomID())
		local colorCls = GetClassByType("ChatColorStyle", colorType)

		local fontSize = GET_CHAT_FONT_SIZE();	
		local tempfontSize = string.format("{s%s}", fontSize);
		local offsetX = chatframe:GetUserConfig("CTRLSET_OFFSETX");		
        
		local chatCtrl = groupbox:CreateOrGetControlSet('chatTextVer', clustername, ui.LEFT, ui.TOP, marginLeft, ypos , marginRight, 1);
		chatCtrl:EnableHitTest(1);
		chatCtrl:EnableAutoResize(true,false);
		
		if commnderName ~= GETMYFAMILYNAME() then
			chatCtrl:SetSkinName("")
		end
		local commnderNameUIText = commnderName .. " : "

		local label = chatCtrl:GetChild('bg');
		local txt = GET_CHILD(chatCtrl, "text");	
		local timeCtrl = GET_CHILD(chatCtrl, "time");

		local msgFront = "";
		local msgString = "";	
		local fontStyle = nil;
		
		label:SetAlpha(0);

		if msgType == "friendmem" then

			fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
			msgFront = "#86E57F";

		elseif msgType == "guildmem" then

			fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
			msgFront = "#A566FF";
		elseif msgType == "Battle" then
			fontStyle = '';			
		elseif msgType ~= "System" then

        
            chatCtrl:SetEventScript(ui.RBUTTONDOWN, 'CHAT_RBTN_POPUP');
			chatCtrl:SetUserValue("TARGET_NAME", commnderName);

			txt:SetEventScript(ui.RBUTTONDOWN, 'CHAT_RBTN_POPUP');
			txt:SetUserValue("TARGET_NAME", commnderName);
					
			if msgType == "Normal" then

				fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_NORMAL");
				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_1"), commnderNameUIText);	

			elseif msgType == "Shout" then

				fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SHOUT");
				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_2"), commnderNameUIText);	

			elseif msgType == "Party" then

				fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_PARTY");
				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_3"), commnderNameUIText);	
					
			elseif msgType == "Guild" then

				fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_GUILD");
				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_4"), commnderNameUIText);	

			elseif msgType == "Notice" then

				fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_NOTICE");	
				msgFront = string.format("[%s]", ScpArgMsg("ChatType_8"));		

			elseif msgType == "Whisper" then

				chatCtrl:SetEventScript(ui.LBUTTONDOWN, 'CHAT_GBOX_LBTN_DOWN');
				chatCtrl:SetEventScriptArgString(ui.LBUTTONDOWN, clusterinfo:GetRoomID());

				txt:SetUserValue("ROOM_ID", clusterinfo:GetRoomID());
			
				if colorCls ~= nil then
					fontStyle = "{#"..colorCls.TextColor.."}{ol}"
				end

				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_5"), commnderNameUIText);	

			elseif msgType == "Group" then

				chatCtrl:SetEventScript(ui.LBUTTONDOWN, 'CHAT_GBOX_LBTN_DOWN');
				chatCtrl:SetEventScriptArgString(ui.LBUTTONDOWN, clusterinfo:GetRoomID());

				txt:SetUserValue("ROOM_ID", clusterinfo:GetRoomID());
		
				if colorCls ~= nil then
					fontStyle = "{#"..colorCls.TextColor.."}{ol}"
				end

				msgFront = string.format("[%s]%s", ScpArgMsg("ChatType_6"), commnderNameUIText);	
			else
				chatCtrl:SetEventScript(ui.LBUTTONDOWN, 'CHAT_GBOX_LBTN_DOWN');
				chatCtrl:SetEventScriptArgString(ui.LBUTTONDOWN, clusterinfo:GetRoomID());

				txt:SetUserValue("ROOM_ID", clusterinfo:GetRoomID());
			
				if colorCls ~= nil then
					fontStyle = "{#"..colorCls.TextColor.."}{ol}"
				end

				msgFront = commnderNameUIText;
			end

		elseif msgType == "System" then
			fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
			local colorOverride = clusterinfo:GetColor();
			if colorOverride ~= '' then
				fontStyle = string.gsub(fontStyle, '{#%x+}', '{#'..colorOverride..'}');				
			end

			msgFront = string.format("[%s]", ScpArgMsg("ChatType_7"));			
		end	

		local tempMsg = clusterinfo:GetMsg()
		if msgType == "friendmem" or  msgType == "guildmem" then
			msgString = string.format("{%s}%s{nl}",msgFront, tempMsg);		
		else			
			msgString = string.format("%s%s{nl}", msgFront, tempMsg);		
		end

		msgString = string.format("%s{/}", msgString);	
		txt:SetTextByKey("font", fontStyle);				
		txt:SetTextByKey("size", fontSize);				
		txt:SetTextByKey("text", CHAT_TEXT_LINKCHAR_FONTSET(mainchatFrame, msgString));
		timeCtrl:SetTextByKey("time", clusterinfo:GetTimeStr());	

								
		local slflag = string.find(clusterinfo:GetMsg(),'a SL%a')
		if slflag == nil then
			txt:EnableHitTest(0)
		else
			txt:EnableHitTest(1)
		end
		
		RESIZE_CHAT_CTRL(groupbox, chatCtrl, label, txt, timeCtrl, offsetX);				
		
	end


	local scrollend = false
	if groupbox:GetLineCount() == groupbox:GetCurLine() + groupbox:GetVisibleLineCount() then
		scrollend = true;
	end

	local beforeLineCount = groupbox:GetLineCount();	
	groupbox:UpdateData();
	
	local afterLineCount = groupbox:GetLineCount();
	local changedLineCount = afterLineCount - beforeLineCount;
	local curLine = groupbox:GetCurLine();

	if (config.GetXMLConfig("ToggleBottomChat") == 1) or (scrollend == true) then
		groupbox:SetScrollPos(99999);
	else 
		groupbox:SetScrollPos(curLine + changedLineCount);
	end

	local gboxtype = string.sub(groupboxname,string.len("chatgbox_") + 1)
	local tonumberret = tonumber(gboxtype)

    if tonumberret ~= nil and tonumberret > MAX_CHAT_CONFIG_VALUE then
		UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. gboxtype)
	end

	return 1;
end

function UPDATE_READ_FLAG_BY_GBOX_NAME(groupboxname)

	local gboxname = groupboxname
	local gboxtype = string.sub(gboxname,string.len("chatgbox_") + 1)

	if gboxtype == "TOTAL" then
		chat.UpdateAllReadFlag();
	else
		local tonumberret = tonumber(gboxtype)
	
		if tonumberret ~= nil and tonumberret > 0 and tonumberret < (2^CHAT_TAB_TYPE_COUNT) - 1 then
			chat.UpdateGroupChatReadFlags( IMCAnd(CHAT_TAB_TYPE_WHISPER, tonumberret) ~= 0, IMCAnd(CHAT_TAB_TYPE_GROUP, tonumberret) ~= 0 )
        else
            chat.UpdateReadFlag(gboxtype);
		end
	end

    

    ui.SaveChatConfig()

end


function CHAT_RBTN_POPUP(frame, chatCtrl)

	if session.world.IsIntegrateServer() == true then
		ui.SysMsg(ScpArgMsg("CantUseThisInIntegrateServer"));
		return;
	end

	local targetName = chatCtrl:GetUserValue("TARGET_NAME");
	if targetName == "" or GETMYFAMILYNAME() == targetName then
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

	ui.AddContextMenuItem(context, ScpArgMsg("Report_AutoBot"), string.format("REPORT_AUTOBOT_MSGBOX(\"%s\")", targetName));

	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end


function CHAT_BLOCK_MSG(targetName)

	local strScp = string.format("friends.RequestBlock(\"%s\")", targetName);
	ui.MsgBox(ScpArgMsg("ReallyBlock?"), strScp, "None");

end


function POPUP_CHAT_SET_FONTSIZE_N_COLOR(framename)

	local frame = ui.GetFrame(framename)
	
	if frame == nil then
		return
	end

	CHAT_SET_FONTSIZE_N_COLOR(frame)

	
	local roomID = string.sub(framename, 11)
	local titleText = session.chat.GetRoomConfigTitle(roomID)
	if titleText ~= "" then
		local name = GET_CHILD_RECURSIVELY(frame, "name")
		name:SetTextByKey("title", titleText);
	end
end


function CHAT_SET_FONTSIZE_N_COLOR(chatframe) 

	if chatframe == nil then
		return;
	end

	local offsetX = chatframe:GetUserConfig("CTRLSET_OFFSETX");
	local targetSize = GET_CHAT_FONT_SIZE();
	local count = chatframe:GetChildCount();
	for  i = 0, count-1 do 
		local groupBox  = chatframe:GetChildByIndex(i);
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
						local msgString = CHAT_TEXT_CHAR_RESIZE(txt:GetTextByKey("text"), targetSize);
						
						
						local roomid = txt:GetUserValue("ROOM_ID")

						if roomid ~= "None" then

							local colorType = session.chat.GetRoomConfigColorType(roomid)
							local colorCls = GetClassByType("ChatColorStyle", colorType)

							if colorCls ~= nil then
								fontStyle = "{#"..colorCls.TextColor.."}{b}{ol}"
								txt:SetTextByKey("font", fontStyle);
							end
						end

						txt:SetTextByKey("text", msgString);
						txt:SetTextByKey("size", targetSize);	
						local timeBox = GET_CHILD(chatCtrl, "time");
						RESIZE_CHAT_CTRL(chatframe, chatCtrl, label, txt, timeBox, offsetX)
							
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

    if string.find(chatframe:GetName(),"chatpopup") ~= nil then
           CHATPOPUP_FOLD_BY_SIZE(chatframe)
    end

	chatframe:Invalidate();

end



--스크롤바 강제 하단 이동 관련 설정 확인 함수
function TOGGLE_BOTTOM_CHAT()
	local IsBottomChat = config.GetXMLConfig("ToggleBottomChat")

	local frame = ui.GetFrame("chatframe")
	local bottomlockbtn = GET_CHILD_RECURSIVELY(frame,"bottomlockbtn")

	if IsBottomChat == 1 then
		config.ChangeXMLConfig("ToggleBottomChat",0)
		bottomlockbtn:SetImage("chat_down_btn");
	else
		config.ChangeXMLConfig("ToggleBottomChat",1)
		bottomlockbtn:SetImage("chat_down_btn2");
	end
end



--메세지의 폰트 크기 변경함수 (메세지에 폰트크기변경토큰이 있어야 한다.)
function CHAT_TEXT_CHAR_RESIZE(msg, fontSize)
	if msg == nil then 
		return;
	end;

	local tempfontSize = string.format("{s%s}", fontSize);
	local resultStr = string.gsub(msg, "({s%d+})", tempfontSize);
	return resultStr;
end


function CHAT_TEXT_LINKCHAR_FONTSET(frame, msg)
	if msg == nil then 
		return;
	end;
	
	local fontStyle = frame:GetUserConfig("TEXTCHAT_FONTSTYLE_LINK");
	local resultStr = string.gsub(msg, "({#%x+}){img", fontStyle .. "{img");

	return resultStr;
end

function CHAT_TEXT_IS_MINE_AND_SETFONT(msgIsMine, fontName)

	local chatframe = ui.GetFrame("chatframe")

	local result;
	if true == msgIsMine then
		result = fontName .. "_MY";
		return chatframe:GetUserConfig(result);
	end
	return chatframe:GetUserConfig(fontName);
end

function UPDATE_CHATTYPE_VISIBLE_PIC(parent, value)
	
	local btn_general_pic = GET_CHILD_RECURSIVELY(parent,"btn_general_pic")
	local btn_shout_pic = GET_CHILD_RECURSIVELY(parent,"btn_shout_pic")
	local btn_party_pic = GET_CHILD_RECURSIVELY(parent,"btn_party_pic")
	local btn_guild_pic = GET_CHILD_RECURSIVELY(parent,"btn_guild_pic")
	local btn_whisper_pic = GET_CHILD_RECURSIVELY(parent,"btn_whisper_pic")
	local btn_group_pic = GET_CHILD_RECURSIVELY(parent,"btn_group_pic")

	if value == 0 then

		btn_general_pic:ShowWindow(1)
		btn_shout_pic:ShowWindow(1)
		btn_party_pic:ShowWindow(1)
		btn_guild_pic:ShowWindow(1)
		btn_whisper_pic:ShowWindow(1)
		btn_group_pic:ShowWindow(1)

	else
	
		if IMCAnd(CHAT_TAB_TYPE_NORMAL, value) ~= 0 then
			btn_general_pic:ShowWindow(1)
		else
			btn_general_pic:ShowWindow(0)
		end

		if IMCAnd(CHAT_TAB_TYPE_SHOUT, value) ~= 0 then
			btn_shout_pic:ShowWindow(1)
		else
			btn_shout_pic:ShowWindow(0)
		end

		if IMCAnd(CHAT_TAB_TYPE_PARTY, value) ~= 0 then
			btn_party_pic:ShowWindow(1)
		else
			btn_party_pic:ShowWindow(0)
		end

		if IMCAnd(CHAT_TAB_TYPE_GUILD, value) ~= 0 then
			btn_guild_pic:ShowWindow(1)
		else
			btn_guild_pic:ShowWindow(0)
		end

		if IMCAnd(CHAT_TAB_TYPE_WHISPER, value) ~= 0 then
			btn_whisper_pic:ShowWindow(1)
		else
			btn_whisper_pic:ShowWindow(0)
		end

		if IMCAnd(CHAT_TAB_TYPE_GROUP, value) ~= 0 then
			btn_group_pic:ShowWindow(1)
		else
			btn_group_pic:ShowWindow(0)
		end
	end
	

end


function UPDATE_CHAT_FRAME_SELECT_CHATTYPE(frame, value)	
	local groupboxname = "chatgbox_TOTAL"
	if value > 0 then
		groupboxname = "chatgbox_" ..tostring(value)
	end

	HIDE_CHILD_BYNAME(frame, 'chatgbox_');

	local showBox = GET_CHILD_RECURSIVELY(frame, groupboxname);	
	
	if showBox == nil then
			
		showBox = _ADD_NEW_CHAT_GBOX(frame, groupboxname)
		_ADD_GBOX_OPTION_FOR_CHATFRAME(showBox)
	end


	showBox:ShowWindow(1)
	DRAW_CHAT_MSG(groupboxname, 0, frame)

	UPDATE_CHATTYPE_VISIBLE_PIC(frame, value)

	frame:Invalidate()
	
end


function CHAT_TABSET_SELECT(index)
	local frame = ui.GetFrame("chatframe")
	if frame == nil then
		return
	end

	frame:SetUserValue("BTN_INDEX", index);

	local tabbtn = GET_CHILD_RECURSIVELY(frame, "tabsetbtn")
	tabbtn:SetText(tostring(index + 1))

	session.chat.SetTabIndex(index)
	ui.SaveChatConfig()
	
	local value = session.chat.GetTabConfigValueByIndex(index);
	
	UPDATE_CHAT_FRAME_SELECT_CHATTYPE(frame, value);


	local optionframe = ui.GetFrame("chat_option")
	local tabgbox = GET_CHILD_RECURSIVELY(optionframe,"tabgbox"..(index + 1))

	UPDATE_CHATTYPE_VISIBLE_PIC(tabgbox, value);
end


function CHAT_FRAME_GET_NOW_SELECT_VALUE(frame)

	if frame == nil then
		return 0;
	end
	
	local check_1 = GET_CHILD_RECURSIVELY(frame, "btn_general_pic");
	local check_2 = GET_CHILD_RECURSIVELY(frame, "btn_shout_pic");
	local check_3 = GET_CHILD_RECURSIVELY(frame, "btn_party_pic");
	local check_4 = GET_CHILD_RECURSIVELY(frame, "btn_guild_pic");
	local check_5 = GET_CHILD_RECURSIVELY(frame, "btn_whisper_pic");
	local check_6 = GET_CHILD_RECURSIVELY(frame, "btn_group_pic");
	local check_7 = GET_CHILD_RECURSIVELY(frame, "btn_system_pic");
	local check_8 = GET_CHILD_RECURSIVELY(frame, "btn_battle_pic");

	local retbit = 0;

	if check_1:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_NORMAL;
	end
	if check_2:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_SHOUT;
	end
	if check_3:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_PARTY;
	end
	if check_4:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_GUILD;
	end
	if check_5:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_WHISPER;
	end
	if check_6:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_GROUP;
	end
	if check_7:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_SYSTEM;
	end
	if check_8:IsVisible() == 1 then
		retbit = retbit + CHAT_TAB_TYPE_BATTLE;
	end

	return retbit;

end

function CHAT_TAB_OPTION_SAVE(frame)
	if frame == nil then
		return;
	end

	local index = tonumber(frame:GetUserValue("BTN_INDEX"))

	local retbit = CHAT_FRAME_GET_NOW_SELECT_VALUE(frame)

	if retbit == 0 then
		if frame:GetName() == "chatframe" then
			retbit = session.chat.GetTabConfigValueByIndex(index);
		else
			local key = tonumber(string.sub(frame:GetName(), 11))
			retbit = session.chat.GetMainFramePopupConfigValue(key);
		end
	end

	if retbit == MAX_CHAT_CONFIG_VALUE then
		retbit = 0
	end

	if frame:GetName() == "chatframe" then
		session.chat.SetTabConfigByIndex(index, retbit)
		CHAT_TABSET_SELECT(index)
	else
		local key = tonumber(string.sub(frame:GetName(), 11))
		session.chat.UpdateMainFramePopupConfig(key, frame:GetWidth(), frame:GetHeight(), frame:GetX(), frame:GetY(), retbit)
		UPDATE_CHAT_FRAME_SELECT_CHATTYPE(frame, retbit)
	end

	ui.SaveChatConfig();
end


function CHAT_TAB_BTN_CLICK(parent, ctrl)

	local name = ctrl:GetName()

	if string.find(name,"_pic") ~= nil then
		ctrl:ShowWindow(0)
	else
		local pic = GET_CHILD_RECURSIVELY(parent, name.."_pic")
		pic:ShowWindow(1)
	end

	local frame = parent:GetTopParentFrame();

	CHAT_TAB_OPTION_SAVE(frame)
end


function CHAT_ADD_MAINCHAT_POPUP(frame)

	if session.chat.GetMainFramePopupConfigsSize() >= 2 then
		return;
	end


	local framename = ""
	local tempguid = 0

	for i = 0, 1000 do
		tempguid = IMCRandom(1, 100000)
		framename = "chatpopup_" .. tostring(tempguid)
		if ui.GetFrame(framename) == nil then
			break;
		end
		tempguid = 0;
	end

	if tempguid == 0 then
		return
	end
	
	local gboxname = "chatgbox_TOTAL"
	local newFrame = ui.CreateNewFrame("chatpopup_main", framename);
	local initx, inity = CHAT_POPUP_GET_EMPTY_PLACE(framename, newFrame:GetWidth(), newFrame:GetHeight())
	newFrame:SetOffset(initx,inity)
	newFrame:ShowWindow(1);

	session.chat.AddMainFramePopupConfig(tempguid, newFrame:GetWidth(), newFrame:GetHeight(), newFrame:GetX(), newFrame:GetY(), 0);



	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", gboxname, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

	DRAW_CHAT_MSG(gboxname, 0, newFrame)

	newFrame:Invalidate()
	ui.SaveChatConfig()
end


function CHAT_ADD_MAINCHAT_POPUP_BY_XML(key, width, height, x, y, value)

	local framename = "chatpopup_" .. tostring(key)

	strvalue = tostring(value)
	
	if strvalue == "0" then
		strvalue = "TOTAL"
	end

	local gboxname = "chatgbox_" .. strvalue;

	if ui.GetFrame(framename) ~= nil then 
		return;
	end

	local newFrame = ui.CreateNewFrame("chatpopup_main", framename);
	newFrame:ShowWindow(1);
	newFrame:Resize(width, height)
    newFrame:SetOffset(x, y)


	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", gboxname, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

	
	DRAW_CHAT_MSG(gboxname, 0, newFrame)

	UPDATE_CHAT_FRAME_SELECT_CHATTYPE(newFrame, value)

	newFrame:Invalidate()
end


function CHAT_SET_CHAT_FRAME_OPACITY(chatFrame, colorToneStr)
	
	local count = chatFrame:GetChildCount();
	for  i = 0, count-1 do 
		local child = chatFrame:GetChildByIndex(i);
		local childName = child:GetName();
		if string.sub(childName, 1, 9) == "chatgbox_" then
			if child:GetClassName() == "groupbox" then
				child = tolua.cast(child, "ui::CGroupBox");
				
				child:SetColorTone(colorToneStr);
			end
		end
	end

end