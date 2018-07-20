

function CHATFRAME_ON_INIT(addon, frame)

	--addon:RegisterMsg("ON_GROUP_CHAT_LAST_TEN", "CHAT_LAST_TEN_UPDATED");
	addon:RegisterMsg("GAME_START", "ON_GAME_START");

	CREATE_DEF_CHAT_GROUPBOX(frame)

	chat.RefreshChatRooms();
	CHAT_SHOW_GROUP_BUTTON(frame, 0);

	local opacity = config.GetConfigInt("CHAT_OPACITY", 255);
	CHAT_SET_OPACITY(opacity);

end

function ON_GAME_START(frame)
	
	frame:Resize(config.GetXMLConfig("ChatFrameSizeWidth"),config.GetXMLConfig("ChatFrameSizeHeight"))
	frame:Invalidate()
end

function CHATFRAME_RESIZE(frame)
	
	config.ChangeXMLConfig("ChatFrameSizeWidth", frame:GetWidth()); 
	config.ChangeXMLConfig("ChatFrameSizeHeight", frame:GetHeight()); 

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

function _ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)


	gbox = AUTO_CAST(gbox)

	local parentframe = gbox:GetParent()

	--gbox:SetLeftScroll(1)
	gbox:SetSkinName("chat_window")
	gbox:EnableVisibleVector(true);
	gbox:EnableHitTest(1);
	gbox:EnableHittestGroupBox(true);
	gbox:LimitChildCount(500);

	if string.find(parentframe:GetName(),"chatpopup_") == nil then
		gbox:EnableAutoResize(false,true);
		gbox:ShowWindow(0)
	else
		gbox:EnableAutoResize(true,true);
		gbox:ShowWindow(1)
	end


end

function CREATE_DEF_CHAT_GROUPBOX(frame)

	DESTROY_CHILD_BYNAME(frame, 'chatgbox_');

	local gboxleftmargin = frame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = frame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = frame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = frame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = frame:CreateControl("groupbox", "chatgbox_TOTAL", frame:GetWidth() - (gboxleftmargin + gboxrightmargin), frame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);

	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)
	gbox:SetUserValue("CHAT_ID", "partyguild");
	gbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
	gbox:ShowWindow(1)

	for i = 1 , 15 do 
		local gbox = frame:CreateControl("groupbox", "chatgbox_"..i, frame:GetWidth() - (gboxleftmargin + gboxrightmargin), frame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
		_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

		--루아 5.1 패치 했으면 좋겠다. 비트연산 좀 쓰자.
		if i >= 4 and i < 8 then
			gbox:SetUserValue("CHAT_ID", "party");
			gbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
		end
		if i >= 8 and i < 11 then
			gbox:SetUserValue("CHAT_ID", "guild");
			gbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
		end
		if i >= 11 then
			gbox:SetUserValue("CHAT_ID", "partyguild");
			gbox:SetEventScript(ui.SCROLL, "SCROLL_CHAT");
		end

	end

	local grouplist = GET_CHILD(frame,"grouplist");
	if grouplist ~= nil then
	grouplist:ShowWindow(0)
	end;
	frame:Invalidate()

end


function CHATFRAME_OPEN(frame)
end

function CHATFRAME_CLOSE(frame)
end

function CHAT_GROUP_REMOVE(roomID)

	local frame = ui.GetFrame('chatframe');
	local child = frame:GetChild('chatgbox_'..roomID);
	if child == nil then
		return;
	end
	local visible = child:IsVisible();
	frame:RemoveChild('chatgbox_'..roomID);

	local queue = GET_CHILD_RECURSIVELY(frame, 'queue')
	queue:RemoveChild('btn_'..roomID);

	local eachheight = ui.GetControlSetAttribute("chatlist", 'height');

	local queueparent = GET_CHILD_RECURSIVELY(frame, 'queueparent')
	queueparent:Resize(queueparent:GetWidth(), queue:GetChildCount() * eachheight)

	if visible == 1 then
		CHAT_WHISPER_ON_BTN_UP()
	end

	local popupframe = ui.GetFrame('chatpopup_'..roomID);

	if popupframe ~= nil then
		CLOSE_CHAT_POPUP(popupframe)
	end
end


function CLOSE_CHAT_POPUP(frame)

	frame:ShowWindow(0);
	ui.SaveChatConfig();

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
		if string.sub(childName, 1, 9) == "chatgbox_" then
			if child:GetClassName() == "groupbox" then
				child = tolua.cast(child, "ui::CGroupBox");
				local colorToneStr = string.format("%02X", num);				
				colorToneStr = colorToneStr .. "FFFFFF";
				child:SetColorTone(colorToneStr);
			end
		end
	end

end

function REMOVE_CHAT_CLUSTER(groupboxname, clusteridlist)

	if clusteridlist == nil then
		return
	end	

	local chatframe = ui.GetFrame("chatframe")

	if chatframe ~= nil then
		
		local groupbox = GET_CHILD(chatframe,groupboxname);


		local addpos = 0;

		for i = 1 , #clusteridlist do

			local clustername = "cluster_"..clusteridlist[i]

		local child = GET_CHILD(groupbox,clustername)
		if child ~= nil then
			local beforeLineCount = groupbox:GetLineCount();	

				addpos = addpos + child:GetHeight()
			 
			DESTROY_CHILD_BYNAME(groupbox, clustername);
			end
		end
		
		ADDYPOS_CHILD_BYNAME(groupbox, "cluster_", -addpos);
	end


	local popupframename = "chatpopup_" ..string.sub(groupboxname, 10, string.len(groupboxname))
	local popupframe = ui.GetFrame(popupframename)

	if popupframe ~= nil then
		
		local groupbox = GET_CHILD(popupframe,groupboxname);

		local addpos = 0;

		for i = 1 , #clusteridlist do

			local clustername = "cluster_"..clusteridlist[i]

		local child = GET_CHILD(groupbox,clustername)
		if child ~= nil then
				local beforeLineCount = groupbox:GetLineCount();	

				addpos = addpos + child:GetHeight()
			 
			DESTROY_CHILD_BYNAME(groupbox, clustername);
			end
		end

			ADDYPOS_CHILD_BYNAME(groupbox, "cluster_", -addpos);

	end

end

--채팅창 재생성 함수 
function REDRAW_CHAT_MSG(groupboxname, size, roomId)
	local framename = "chatframe";
	local chatframe = ui.GetFrame(framename)
	if chatframe == nil then
		return
	end

	if "chatgbox_TOTAL" == groupboxname then
		CREATE_DEF_CHAT_GROUPBOX(chatframe);
	end;

	if roomId ~= nil then
		framename = "chatpopup_" .. roomId;
		local chatpopup_frame = ui.GetFrame(framename);
		if chatpopup_frame ~= nil then
			CREATE_DEF_CHAT_GROUPBOX(chatpopup_frame);
		end;
	end;
	DRAW_CHAT_MSG(groupboxname, size, 0, framename);
end

--채팅창의 챗그룹들을 그려주는 함수 
function DRAW_CHAT_MSG(groupboxname, size, startindex, framename)
	if startindex < 0 then
		return;
	end

	if framename == nil then
		framename = "chatframe";

		local popupframename = "chatpopup_" ..string.sub(groupboxname, 10, string.len(groupboxname))
		DRAW_CHAT_MSG(groupboxname, size, startindex, popupframename);
	end

	local mainchatFrame = ui.GetFrame("chatframe")
	local chatframe = ui.GetFrame(framename)
	if chatframe == nil then
		return
	end

	local groupbox = GET_CHILD(chatframe,groupboxname);
	if groupbox == nil then

		local gboxleftmargin = chatframe:GetUserConfig("GBOX_LEFT_MARGIN")
		local gboxrightmargin = chatframe:GetUserConfig("GBOX_RIGHT_MARGIN")
		local gboxtopmargin = chatframe:GetUserConfig("GBOX_TOP_MARGIN")
		local gboxbottommargin = chatframe:GetUserConfig("GBOX_BOTTOM_MARGIN")
		
		groupbox = chatframe:CreateControl("groupbox", groupboxname, chatframe:GetWidth() - (gboxleftmargin + gboxrightmargin), chatframe:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);

		_ADD_GBOX_OPTION_FOR_CHATFRAME(groupbox)
		
	end

	if startindex == 0 then
		DESTROY_CHILD_BYNAME(groupbox, "cluster_");
	end

	local roomID = "Default";
	local marginLeft = 0;
	local marginRight = 25;
	local ypos = 0;
	local textVer = IS_TEXT_VER_CHAT();

	for i = startindex , size - 1 do

		-- 일단 이전 정보를 기반으로 ypos를 찾을 것.
		if i ~= 0 then
			local clusterinfo = session.ui.GetChatMsgClusterInfo(groupboxname, i-1)
			if clusterinfo ~= nil then
				local beforechildname = "cluster_"..clusterinfo:GetClusterID()
				local beforechild = GET_CHILD(groupbox, beforechildname);
				if beforechild ~= nil then
					ypos = beforechild:GetY() + beforechild:GetHeight();
					
				end
			end
			if ypos == 0 then
				DRAW_CHAT_MSG(groupboxname, size, 0, framename);
				return;
			end
		end

		local clusterinfo = session.ui.GetChatMsgClusterInfo(groupboxname, i)
		if clusterinfo == nil then
			return;
		end
		local clustername = "cluster_"..clusterinfo:GetClusterID();
		local msgType = clusterinfo:GetMsgType();
		local commnderName = clusterinfo:GetCommanderName();
		local fontSize = GET_CHAT_FONT_SIZE();	
		local tempfontSize = string.format("{s%s}", fontSize);
		local offsetX = chatframe:GetUserConfig("CTRLSET_OFFSETX");
		if textVer == 0 then
			-- 풍선 버젼 
		roomID = clusterinfo:GetRoomID();

			-- 컨트롤은 이미 만들어 놓은게 있을수도 있음. 있으면 그냥 가져다 씀			
		local cluster = GET_CHILD(groupbox, clustername);
			if cluster ~= nil then -- 있다면 업데이트
			
				local fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE");
				local label = cluster:GetChild('bg');

				if msgType == "System" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_SYSTEM");
				elseif msgType == "friendmem" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_MEMBER");
					cluster:RemoveChild("name");
				elseif msgType == "guildmem" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_MEMBER");
					cluster:RemoveChild("name");
				end;
			local txt = GET_CHILD(label, "text");
				local tempMsg = string.gsub(clusterinfo:GetMsg(), "({/}{/})", "%1" .. fontStyle .. tempfontSize);
				txt:SetTextByKey("text", tempMsg);

				
				local timeBox = GET_CHILD(cluster, "timebox");
				RESIZE_CHAT_CTRL(1, chatframe, cluster, label, txt, timeBox, offsetX);

			if cluster:GetHorzGravity() == ui.RIGHT then
					cluster:SetOffset( marginRight , ypos + 5); 
			else
					cluster:SetOffset( marginLeft , ypos + 5); 
			end

				local slflag = string.find(clusterinfo:GetMsg(),'a SL%a')
				if slflag == nil then				
					label:EnableHitTest(0)
				else
					label:EnableHitTest(1)
				end

			else -- 없다면 새로 그리기
			
			local chatCtrlName = 'chatu';
			if true == ui.IsMyChatCluster(clusterinfo) then
				chatCtrlName = 'chati';
			end
			local horzGravity = ui.LEFT;
			if chatCtrlName == 'chati' then
				horzGravity = ui.RIGHT;
			end

				local chatCtrl = groupbox:CreateOrGetControlSet(chatCtrlName, clustername, horzGravity, ui.TOP, marginLeft, ypos + 5, marginRight, 0);
			chatCtrl:EnableHitTest(1);
				
				local label = chatCtrl:GetChild('bg');
				local fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE");
				if msgType == "friendmem" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_MEMBER");
				elseif msgType == "guildmem" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_MEMBER");
				elseif msgType ~= "System" then
				chatCtrl:SetEventScript(ui.RBUTTONDOWN, 'CHAT_RBTN_POPUP');
					chatCtrl:SetUserValue("TARGET_NAME", commnderName);
				elseif msgType == "System" then
					fontStyle = mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_SYSTEM");
			end			

				local myColor, targetColor = GET_CHAT_COLOR(msgType);
			local txt = GET_CHILD(label, "text", "ui::CRichText");
				local timeBox = GET_CHILD(chatCtrl, "timebox", "ui::CGroupBox");
				local timeCtrl = GET_CHILD(timeBox, "time", "ui::CRichText");
			local nameText = GET_CHILD(chatCtrl, "name", "ui::CRichText");

				local tempMsg = string.gsub(clusterinfo:GetMsg(), "({/}{/})", "%1" .. fontStyle .. tempfontSize);
				txt:SetTextByKey("font", fontStyle);	
			txt:SetTextByKey("size", fontSize);
				txt:SetTextByKey("text", tempMsg);

			local labelMarginX = 0
			local labelMarginY = 0

			if chatCtrlName == 'chati' then
				label:SetSkinName('textballoon_i');
				label:SetColorTone(myColor);
			else
				label:SetColorTone(targetColor);
					if commnderName == "guildmem" or commnderName == "friendmem" then
						chatCtrl:RemoveChild("name");
					elseif commnderName == 'System' then
					nameText:SetText('{img chat_system_icon 65 18 }{/}');
				else
					nameText:SetText('{@st61}'..commnderName..'{/}');
				end

				local iconPicture = GET_CHILD(chatCtrl, "iconPicture", "ui::CPicture");
				iconPicture:ShowWindow(0);
					--[[ 캐릭터 얼굴 살릴거면 여기
				
				if iconInfo == nil then
					iconPicture:ShowWindow(0);
				else
					iconPicture:ShowWindow(0);
				end
				]]
			end
		
				timeCtrl:SetTextByKey("time", clusterinfo:GetTimeStr());

				local slflag = string.find(clusterinfo:GetMsg(),'a SL%a')
			if slflag == nil then
				label:EnableHitTest(0)
			else
				label:EnableHitTest(1)
			end
		
				RESIZE_CHAT_CTRL(1, chatframe, chatCtrl, label, txt, timeBox, offsetX);
			end;			
		elseif textVer == 1 then
			-- 간략화 버젼 
				local chatCtrlName = 'chatTextVer';
				local horzGravity = ui.LEFT;
				local chatCtrl = groupbox:CreateOrGetControlSet(chatCtrlName, clustername, horzGravity, ui.TOP, marginLeft, ypos -2 , marginRight, 0);						
				local itemCnt = clusterinfo:GetMsgItemCount();
				local label = chatCtrl:GetChild('bg');
				local txt = GET_CHILD(chatCtrl, "text", "ui::CRichText");	
				local timeCtrl = GET_CHILD(chatCtrl, "time", "ui::CRichText");
				local msgFront = "";
				local msgString = "";				
				local fontStyle = nil;
				local msgIsMine = false;
				
				chatCtrl:EnableHitTest(1);

				if true == ui.IsMyChatCluster(clusterinfo) then
					msgIsMine = true;
					label:SetColorTone("FF000000");
					label:SetAlpha(60);
				else
				label:SetAlpha(0);
				end;

				if msgType == "friendmem" then
					fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
					msgFront = "#86E57F";
				elseif msgType == "guildmem" then
					fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
					msgFront = "#A566FF";
				elseif msgType ~= "System" then
					chatCtrl:SetEventScript(ui.RBUTTONDOWN, 'CHAT_RBTN_POPUP');
					chatCtrl:SetUserValue("TARGET_NAME", commnderName);

					if msgType == "Normal" then
						msgFront = string.format("[%s]", commnderName);
						fontStyle = CHAT_TEXT_IS_MINE_AND_SETFONT(mainchatFrame, msgIsMine, "TEXTCHAT_FONTSTYLE_NORMAL");
					elseif msgType == "Shout" then
						fontStyle = CHAT_TEXT_IS_MINE_AND_SETFONT(mainchatFrame, msgIsMine, "TEXTCHAT_FONTSTYLE_SHOUT");
						msgFront = string.format("[%s][%s]", ScpArgMsg("ChatType_2"), commnderName);	
					elseif msgType == "Party" then
						fontStyle = CHAT_TEXT_IS_MINE_AND_SETFONT(mainchatFrame, msgIsMine, "TEXTCHAT_FONTSTYLE_PARTY");
						msgFront = string.format("[%s][%s]", ScpArgMsg("ChatType_3"), commnderName);		
					elseif msgType == "Guild" then
						fontStyle = CHAT_TEXT_IS_MINE_AND_SETFONT(mainchatFrame, msgIsMine, "TEXTCHAT_FONTSTYLE_GUILD");
						msgFront = string.format("[%s][%s]", ScpArgMsg("ChatType_4"), commnderName);	
					elseif msgType == "Notice" then		--공지
						fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_NOTICE");	
						msgFront = string.format("[%s]", ScpArgMsg("ChatType_6"));		
					else	--귓말
						fontStyle = CHAT_TEXT_IS_MINE_AND_SETFONT(mainchatFrame, msgIsMine, "TEXTCHAT_FONTSTYLE_WHISPER");
						msgFront = string.format("[%s][%s]", ScpArgMsg("ChatType_5"), commnderName);	
					end;
				elseif msgType == "System" then
					fontStyle = mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
					msgFront = string.format("[%s]", ScpArgMsg("ChatType_7"));		
					label:SetColorTone("FF000000");
					label:SetAlpha(80);
		end
				local timeMsg = "";
				for i = 1 , itemCnt do
					--local tempMsg = string.gsub(clusterinfo:GetMsgItembyIndex(i-1), "({img %a+_%d+%s)%d+%s%d+(}{/})", "%1" .. (fontSize * 3) .. " " .. (fontSize * 3) .. "%2".. fontStyle .. tempfontSize); --이미지의 크기도 변경시키는 코드
					local tempMsg = string.gsub(clusterinfo:GetMsgItembyIndex(i-1), "({/}{/})", "%1" .. fontStyle .. tempfontSize);
					local msgStingAdd = ' ';
					if msgType == "friendmem" or  msgType == "guildmem" then
						msgStingAdd = string.format("{%s}%s{nl}",msgFront, tempMsg);		
					else
						msgStingAdd = string.format("%s : %s{nl}", msgFront, tempMsg);		
					end																									
					msgString = msgString .. msgStingAdd;
					--timeMsg = string.format("%s{nl}%s", timeMsg, clusterinfo:GetTimeStr());	
				end;	
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
				timeCtrl:SetOffset(10, 10);
				RESIZE_CHAT_CTRL(0, chatframe, chatCtrl, label, txt, timeCtrl, offsetX);				
		end;
	end;


	local scrollend = false
	if groupbox:GetLineCount() == groupbox:GetCurLine() + groupbox:GetVisibleLineCount() then
		scrollend = true;
	end

	local beforeLineCount = groupbox:GetLineCount();	
	groupbox:UpdateData();
	
	local afterLineCount = groupbox:GetLineCount();
	local changedLineCount = afterLineCount - beforeLineCount;
	local curLine = groupbox:GetCurLine();

	if (IS_BOTTOM_CHAT() == 1) or (scrollend == true) then
		groupbox:SetScrollPos(99999);
	else 
	groupbox:SetScrollPos(curLine + changedLineCount);
	end

	if groupbox:GetName() == "chatgbox_TOTAL" and groupbox:IsVisible() == 1 then
		chat.UpdateAllReadFlag();
	end

	local parentframe = groupbox:GetParent()
	
	if string.find(parentframe:GetName(),"chatpopup_") == nil then
		if roomID ~= "Default" and groupbox:IsVisible() == 1 then
			chat.UpdateReadFlag(roomID);
		end
	else
	
		if roomID ~= "Default" and parentframe:IsVisible() == 1 then
			chat.UpdateReadFlag(roomID);
		end
	end
end

function RESIZE_CHAT_CTRL(isBallon, chatframe, chatCtrl, label, txt, timeBox, offsetX)

	if isBallon == 1  then
		-- 풍선버젼
	local lablWidth = txt:GetWidth() + 40;
	local chatWidth = chatCtrl:GetWidth();
	label:Resize(lablWidth, txt:GetHeight() + 20);

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
		end;

	else
		-- 간략화 버젼
		local lablWidth = txt:GetWidth() + 40;
		local chatWidth = chatframe:GetWidth();
		label:Resize(chatWidth - offsetX, txt:GetHeight());
		chatCtrl:Resize(chatWidth, label:GetHeight());

		txt:SetTextMaxWidth(chatWidth - (offsetX + 60));
		timeBox:SetOffset(label:GetWidth() - 60, 0);
	end;
end;

function GET_CHAT_COLOR(chatType)

	local frame = ui.GetFrame("chatframe")

	local myColor = frame:GetUserConfig("COLOR_WHI_MY");
	local targetColor = frame:GetUserConfig("COLOR_WHI_TO");
	
	if chatType == 'Normal' then

		myColor = frame:GetUserConfig("COLOR_NORMAL_MY");
		targetColor = frame:GetUserConfig("COLOR_NORMAL");

	elseif chatType == 'Shout' then

		myColor = frame:GetUserConfig("COLOR_SHOUT_MY");
		targetColor = frame:GetUserConfig("COLOR_SHOUT");

	elseif chatType == 'Party' then

		myColor = frame:GetUserConfig("COLOR_PARTY_MY");
		targetColor = frame:GetUserConfig("COLOR_PARTY");	
	
	elseif chatType == 'Guild' then

		myColor = frame:GetUserConfig("COLOR_GUILD_MY");
		targetColor = frame:GetUserConfig("COLOR_GUILD");	
	elseif chatType == "friendmem" then
		targetColor = frame:GetUserConfig("COLOR_PARTY_INFO");
	elseif chatType == "guildmem" then
		targetColor = frame:GetUserConfig("COLOR_GUILD_INFO");
	elseif chatType == "System" then
		
		myColor = frame:GetUserConfig("COLOR_NORMAL_MY"); -- 나중에 시스템 색 찾아서 바꿀 것
		targetColor = frame:GetUserConfig("COLOR_NORMAL");

	end

	return myColor, targetColor;

end


function UPDATE_NOT_READ_COUNT(gboxname, clusterID, newcount)

	local frame = ui.GetFrame("chatframe")
	if frame == nil then 
		return;
	end

	local gbox = GET_CHILD(frame,gboxname);
	if gbox == nil then 
		return;
	end

	local clustername = "cluster_" .. clusterID
	local cluster = GET_CHILD(gbox,clustername);
	if cluster == nil then 
		return;
	end

	gbox:UpdateData();
end


function CHAT_FRAME_GROUPBOXES_VISIBLE(groupboxname, roomID, fromstring)

	local frame = ui.GetFrame('chatframe')
	if frame == nil then
		return;
	end

	local showBox = GET_CHILD(frame, groupboxname);

	HIDE_CHILD_BYNAME(frame, 'chatgbox_');

	local grouplist = GET_CHILD(frame, "grouplist");
	grouplist:ShowWindow(0)


	if showBox ~= nil then
		showBox:ShowWindow(1)
	else
		local gboxleftmargin = frame:GetUserConfig("GBOX_LEFT_MARGIN")
		local gboxrightmargin = frame:GetUserConfig("GBOX_RIGHT_MARGIN")
		local gboxtopmargin = frame:GetUserConfig("GBOX_TOP_MARGIN")
		local gboxbottommargin = frame:GetUserConfig("GBOX_BOTTOM_MARGIN")
		
		local newgroupbox = frame:CreateControl("groupbox", groupboxname, frame:GetWidth() - (gboxleftmargin + gboxrightmargin), frame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
		_ADD_GBOX_OPTION_FOR_CHATFRAME(newgroupbox)
		newgroupbox:ShowWindow(1)
	end

	if groupboxname== "chatgbox_TOTAL" then
		chat.UpdateAllReadFlag();
	end
	if roomID ~= "" and roomID ~= nil then
		chat.UpdateReadFlag(roomID);
		chat.CheckNewMessage(roomID);
	end

	CHAT_SET_FROM_TITLENAME(fromstring, roomID)
end

function CHAT_SET_FROM_TITLENAME(targetName, roomid)

	local chatFrame = ui.GetFrame('chatframe');
	
	local titleFont = '{@st61}';
	local titleText = "";

	if targetName ~= "" and targetName ~= nil then

		titleText = titleText..targetName;

	elseif roomid ~= "" and roomid ~= nil then

		local info = session.chat.GetByStringID(roomid);
		local memberString = GET_GROUP_TITLE(info);
		titleText = 'From. '..memberString;

	end

	local name = chatFrame:GetChild("group_titlebar"):GetChild("name");
	name:SetTextByKey("title", titleText);


	-- popupframe의 제목도 같이 변경
	local popupframename = "chatpopup_" .. roomid
	local popupframe = ui.GetFrame(popupframename);
	if popupframe ~= nil and popupframe:IsVisible() == 1 then
		local name = GET_CHILD_RECURSIVELY(popupframe,"name")
	name:SetTextByKey("title", titleText);
end

end


-- chat.lib로 옮길것
function SCROLL_CHAT(parent, ctrl, str, wheel)

	if ctrl:IsVisible() == 0 then
		return;
	end

	if wheel == 0 then
		local roomID = ctrl:GetUserValue("CHAT_ID");

		if roomID == "party" then
			chat.CheckNewPartyMessage();
		elseif roomID == "guild" then
			chat.CheckNewGuildMessage();
		elseif roomID == "partyguild" then
			chat.CheckNewPartyMessage();
			chat.CheckNewGuildMessage();
		else
			chat.CheckNewMessage(roomID);
		end
	end
	
end






function CHAT_RBTN_POPUP(frame, chatCtrl) -- 이거 살릴 수도. 오늘 말고.

	if session.world.IsIntegrateServer() == true then
		ui.SysMsg(ScpArgMsg("CantUseThisInIntegrateServer"));
		return;
	end

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

	ui.AddContextMenuItem(context, ScpArgMsg("Report_AutoBot"), string.format("REPORT_AUTOBOT_MSGBOX(\"%s\")", targetName));

	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function CHAT_BLOCK_MSG(targetName)

	local strScp = string.format("friends.RequestBlock(\"%s\")", targetName);
	ui.MsgBox(ScpArgMsg("ReallyBlock?"), strScp, "None");

end

function CHAT_FRAME_NOW_BTN_SKN() -- 구 형태지만 아직은 쓴다.

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


function CHAT_LEAVE_ON_BTN_UP()
	ui.LeaveGroupChat();
end

function CHAT_TOTAL_ON_BTN_UP()

	ui.SetChatGroupBox(CT_TOTAL);
	chat.UpdateAllReadFlag();
end

function CHAT_GENERAL_ON_BTN_UP()

	ui.SetChatGroupBox(CT_GENERAL);
end

function CHAT_SHOUT_ON_BTN_UP()

	ui.SetChatGroupBox(CT_SHOUT);
end

function CHAT_PARTY_ON_BTN_UP()
	
	ui.SetChatGroupBox(CT_PARTY);

end

function CHAT_GUILD_ON_BTN_UP()

	ui.SetChatGroupBox(CT_GUILD);

end

function CHAT_WHISPER_ON_BTN_UP()

	ui.SetChatGroupBox(CT_WHISPER);

end

function GROUPCHAT_ADD_MEMBER(parent)
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER", "",nil,nil,20);
end

function EXED_GROUPCHAT_ADD_MEMBER(frame, friendName)
	local roomID = frame:GetUserValue("ROOM_ID");
	ui.GroupChatInviteSomeone(roomID, friendName)
end

function RESIZE_CHAT_MSG(roomId, num)
	local framename = "chatpopup_" .. roomId;
	local chatpopup_frame = ui.GetFrame(framename);
	if chatpopup_frame ~= nil then	
		CHAT_SET_FONTSIZE(chatpopup_frame, num);
	end;
end;

--실시간 폰트 크기 변경 함수
function CHAT_SET_FONTSIZE(chatframe, num) 
	if chatframe == nil then
		return;
	end

	local textVer = IS_TEXT_VER_CHAT();
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
							if textVer == 0 then
								--풍선 버젼
								local txt = GET_CHILD(label, "text", "ui::CRichText");

								if txt == nil then
									--개발 중간에 간혹 간략화버젼으로 찾을때가 있어서 예외처리해두었다. 고쳐졌을 수도 있다.
									txt = GET_CHILD(chatCtrl, "text", "ui::CRichText");
								end;	

								local msgString = CHAT_TEXT_CHAR_RESIZE(txt:GetTextByKey("text"), targetSize);
								txt:SetTextByKey("text", msgString);
						txt:SetTextByKey("size", targetSize);
								local timeBox = GET_CHILD(chatCtrl, "timebox");
								RESIZE_CHAT_CTRL(1, chatframe, chatCtrl, label, txt, timeBox, offsetX)				
							else
								--간략화 버젼
								local txt = GET_CHILD(chatCtrl, "text", "ui::CRichText");
								local msgString = CHAT_TEXT_CHAR_RESIZE(txt:GetTextByKey("text"), targetSize);
								txt:SetTextByKey("text", msgString);
								txt:SetTextByKey("size", targetSize);	
								local timeBox = GET_CHILD(chatCtrl, "time");
								RESIZE_CHAT_CTRL(0, chatframe, chatCtrl, label, txt, timeBox, offsetX)
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
	chatframe:Invalidate();
end

--간략화 버젼인지 확인 함수
function IS_TEXT_VER_CHAT()
	local IsTextVer = config.GetXMLConfig("ToggleTextChat")
	return IsTextVer;
end

--스크롤바 강제 하단 이동 관련 설정 확인 함수
function IS_BOTTOM_CHAT()
	local IsBottomChat = config.GetXMLConfig("ToggleBottomChat")
	return IsBottomChat;
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

function CHAT_TEXT_IS_MINE_AND_SETFONT(chatframe, msgIsMine, fontName)
	local result;
	if true == msgIsMine then
		result = fontName .. "_MY";
		return chatframe:GetUserConfig(result);
	end
	return chatframe:GetUserConfig(fontName);
end


--[[
function CHAT_LAST_TEN_UPDATED(frame, msg, argStr, argNum) -- 아직 정체 불명. 나중에 고치던가 할 것
	
	if 1 == 1 then
		return
	end

	local frame = ui.GetFrame('chatframe')
	local group = GET_CHILD(frame, 'chat_'..argStr, 'ui::CGroupBox')
	local queue = GET_CHILD(group, 'queue', 'ui::CQueue')
	queue:SortByName()
	queue:Invalidate();
	
end
]]
