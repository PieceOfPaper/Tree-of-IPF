



-- copyright : http://lua-users.org/wiki/SortedIteration

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end




function CHAT_GROUPLIST_ON_INIT(addon, frame)	

	addon:RegisterMsg("REMOVE_FRIEND", "SYNC_WITH_FRIEND_LIST");
	addon:RegisterMsg("ADD_FRIEND", "SYNC_WITH_FRIEND_LIST");
	addon:RegisterMsg("UPDATE_FRIEND_LIST", "SYNC_WITH_FRIEND_LIST");

	CHAT_GROUPLIST_SELECT_LISTTYPE(1)


    local groupListFrame = ui.GetFrame('chat_grouplist');
	if groupListFrame == nil then
		return;
	end

    local friendcnttext = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_friend");
	local whispercnttext = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_whisper");
	local groupcnttext = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_group");
	friendcnttext:ShowWindow(0)
	whispercnttext:ShowWindow(0)
	groupcnttext:ShowWindow(0)

	local friendcnttextbg = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_friend_bg");
	local whispercnttextbg = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_whisper_bg");
	local groupcnttextbg = GET_CHILD_RECURSIVELY(groupListFrame, "readcnt_group_bg");
	friendcnttextbg:ShowWindow(0)
	whispercnttextbg:ShowWindow(0)
	groupcnttextbg:ShowWindow(0)

end

function CHAT_GROUP_UPDATE(roomID)

	CHAT_CREATE_OR_UPDATE_GROUP_LIST(roomID);	
	UPDATE_GROUPLIST_TEXT("chatgbox_"..roomID);
	UPDATE_CHAT_MEMBERLIST(roomID)
	UPDATE_ROOM_READ_CNT(roomID)
end

function LISTBTN_FRIEND()
	CHAT_GROUPLIST_SELECT_LISTTYPE(1)
end

function LISTBTN_WHISPER()
	CHAT_GROUPLIST_SELECT_LISTTYPE(2)
end

function LISTBTN_GROUP()
	CHAT_GROUPLIST_SELECT_LISTTYPE(3)
end

function CHAT_GROUPLIST_SELECT_LISTTYPE(type) -- 1 : 친구 / 2 : 1:1 / 3 : 그룹

	local frame = ui.GetFrame('chat_grouplist');
	if frame == nil then
		return;
	end

	local chatlist_friend = GET_CHILD_RECURSIVELY(frame,"chatlist_friend")
	local chatlist_whisper = GET_CHILD_RECURSIVELY(frame,"chatlist_whisper")
	local chatlist_group = GET_CHILD_RECURSIVELY(frame,"chatlist_group")
	local createnewgroupchat = GET_CHILD_RECURSIVELY(frame,"createnewgroupchat")
	--local deleteallwhisper = GET_CHILD_RECURSIVELY(frame,"deleteallwhisper")

	if type == 1 then
		chatlist_friend:ShowWindow(1)
		chatlist_whisper:ShowWindow(0)
		chatlist_group:ShowWindow(0)
		createnewgroupchat:ShowWindow(0)
		--deleteallwhisper:ShowWindow(0)
	elseif type == 2 then
		chatlist_friend:ShowWindow(0)
		chatlist_whisper:ShowWindow(1)
		chatlist_group:ShowWindow(0)
		createnewgroupchat:ShowWindow(0)
		--deleteallwhisper:ShowWindow(1)
	elseif type == 3 then
		chatlist_friend:ShowWindow(0)
		chatlist_whisper:ShowWindow(0)
		chatlist_group:ShowWindow(1)
		createnewgroupchat:ShowWindow(1)
		--deleteallwhisper:ShowWindow(0)
	end


end


function SYNC_WITH_FRIEND_LIST()
	
	local frame = ui.GetFrame('chat_grouplist');
	if frame == nil then
		return;
	end

	local friendgbox = GET_CHILD_RECURSIVELY(frame,"chatlist_friend")
	
	local friendcount = friendgbox:GetChildCount();
	for  i = 0, friendcount-1 do 
		local cset  = friendgbox:GetChildByIndex(i);

		if cset ~= nil then
			local childName = cset:GetName();

			if string.sub(childName, 1, 4) == "btn_" then
			
				local roomID = string.sub(childName, string.len("btn_") + 1)
				local info = session.chat.GetByStringID(roomID);
	
				if info ~= nil	then
					if info:IsFriendWhisperRoom() == false then
                        friendgbox:RemoveChild (cset:GetName ());
                        CHAT_GROUP_UPDATE(roomID)
					end
				end
			end
		end

		
	end

	local whispergbox = GET_CHILD_RECURSIVELY(frame,"chatlist_whisper")
	
	local whispercount = whispergbox:GetChildCount();
	for  i = 0, whispercount-1 do 
		local cset  = whispergbox:GetChildByIndex(i);
		if cset ~= nil then
			local childName = cset:GetName();

			if string.sub(childName, 1, 4) == "btn_" then
			
				local roomID = string.sub(childName, string.len("btn_") + 1)
				local info = session.chat.GetByStringID(roomID);
				
				if info ~= nil	then
					if info:IsFriendWhisperRoom() == true then
                        whispergbox:RemoveChild (cset:GetName ());
                        CHAT_GROUP_UPDATE(roomID)
					end
				end
			end
		end
		
	end

	
	frame:Invalidate();
end

function CHAT_CREATE_OR_UPDATE_GROUP_LIST(roomID)

	local frame = ui.GetFrame('chat_grouplist');
	if frame == nil then
		return;
	end
	local info = session.chat.GetByStringID(roomID);
	
	if info == nil	then
		return;
	end

	local gbox = nil

	if info:GetRoomType() == 0 then

		if info:IsFriendWhisperRoom() == true then
			gbox = GET_CHILD_RECURSIVELY(frame, "chatlist_friend");
		else
			gbox = GET_CHILD_RECURSIVELY(frame, "chatlist_whisper");
		end

	elseif info:GetRoomType() == 3 then
		gbox = GET_CHILD_RECURSIVELY(frame, "chatlist_group");
	end

	if gbox == nil then
		return
	end


	local eachcset = GET_CHILD_RECURSIVELY(gbox, 'btn_'..roomID)
	
	if eachcset == nil then
	
		eachcset = gbox:CreateControlSet("chatlist", 'btn_'..roomID, 0, 0);
		tolua.cast(eachcset, "ui::CControlSet");

        GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, false);
    end

	eachcset:SetEventScript(ui.LBUTTONDOWN, 'MAKE_POPUP_CHAT');
	eachcset:SetEventScriptArgString(ui.LBUTTONDOWN, roomID);
	eachcset:SetUserValue("ROOMID",roomID)

	local title = ""
	if info:GetRoomType() == 3 then
		title = session.chat.GetRoomConfigTitle(roomID)
		if title == "" then
			title = info:GetRoomName()
		end
		if title == "" then
            title = session.chat.GetNewGroupChatDefName();
        end
	else
		title = ScpArgMsg("ChatWith{Name}","Name",info:GetWhisperTargetName())
	end

	local initx, inity = CHAT_POPUP_GET_EMPTY_PLACE("chatpopup_" .. roomID, 450, 280)

	session.chat.InsertRoomConfig(roomID, title, 0, 450, 280, initx, inity, IMCRandom(100, 109), info:GetRoomType(), initx, inity )

	if info:GetRoomType() == 3 then
		title = ScpArgMsg("GroupChatTitleWithMemCnt","Text",title,"Cnt",tostring(info:GetMemberCount()));
	end

	local titletext = GET_CHILD(eachcset, "title");
	titletext:SetText(title)
	
	local btn_invite = GET_CHILD(eachcset, "btn_invite");
	local btn_tag = GET_CHILD(eachcset, "btn_tag");

	if info:GetRoomType() == 3 then
		btn_invite:ShowWindow(1)
		btn_tag:ShowWindow(1)
	else
		btn_invite:ShowWindow(0)
		btn_tag:ShowWindow(0)
	end
	
	local btn_config = GET_CHILD(eachcset, "btn_config");
	btn_config:SetEventScript(ui.LBUTTONUP, 'CHAT_GROUPLIST_SET_OPTION');
	btn_config:SetEventScriptArgString(ui.LBUTTONUP, roomID);

	frame:Invalidate();
	
end

function UPDATE_ROOM_READ_CNT(roomID)

	local grouplistframe = ui.GetFrame('chat_grouplist');
	if grouplistframe == nil then
		return;
	end

	local chatframe = ui.GetFrame('chatframe');
	if chatframe == nil then
		return;
	end

	
	
    -- 1. 그룹리스트의 각 방의 리드카운트 갱신
    local info = session.chat.GetByStringID(roomID);
	if info ~= nil	then

		local eachcset = GET_CHILD_RECURSIVELY(grouplistframe, 'btn_'..roomID)

	    if eachcset ~= nil then

		    local newmsgcntbg = GET_CHILD(eachcset, "newmsgcntbg");
		    local newmsgcnttext = GET_CHILD(eachcset, "newmsgcnt");
		    local newmsgcnt = info:GetNewMessageCount();
		    newmsgcnttext:ShowWindow(0)
		    newmsgcntbg:ShowWindow(0)

		    if newmsgcnt > 0 then
			    newmsgcnttext:SetText(tostring(newmsgcnt))
			    if newmsgcnt > 99 then
				    newmsgcnttext:SetText("99+")
			    end
			    newmsgcnttext:ShowWindow(1)
			    newmsgcntbg:ShowWindow(1)
		    end
	    end

	end

	


	-- 2. 그룹리스트 왼쪽 탭의 타입별 리드 카운트 갱신
	local grouplistframegbox = nil
	local typereadcnt = 0
	local friendcnttext = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_friend");
	local whispercnttext = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_whisper");
	local groupcnttext = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_group");
	friendcnttext:ShowWindow(0)
	whispercnttext:ShowWindow(0)
	groupcnttext:ShowWindow(0)

	local friendcnttextbg = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_friend_bg");
	local whispercnttextbg = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_whisper_bg");
	local groupcnttextbg = GET_CHILD_RECURSIVELY(grouplistframe, "readcnt_group_bg");
	friendcnttextbg:ShowWindow(0)
	whispercnttextbg:ShowWindow(0)
	groupcnttextbg:ShowWindow(0)


	local friendreadcnt = session.chat.GetGroupChatNotReadMsgCount("friend")
			
	if friendreadcnt > 0 then
		friendcnttext:SetText(tostring(friendreadcnt))
		if friendreadcnt > 99 then
			friendcnttext:SetText("99+")
		end
		friendcnttext:ShowWindow(1)
		friendcnttextbg:ShowWindow(1)
	end


	local whisperreadcnt = session.chat.GetGroupChatNotReadMsgCount("whisper")
			
	if whisperreadcnt > 0 then
		whispercnttext:SetText(tostring(whisperreadcnt))
		if whisperreadcnt > 99 then
			whispercnttext:SetText("99+")
		end
		whispercnttext:ShowWindow(1)
		whispercnttextbg:ShowWindow(1)
	end


	local groupreadcnt = session.chat.GetGroupChatNotReadMsgCount("group")
			
	if groupreadcnt > 0 then
		groupcnttext:SetText(tostring(groupreadcnt))
		if groupreadcnt > 99 then
			groupcnttext:SetText("99+")
		end
		groupcnttext:ShowWindow(1)
		groupcnttextbg:ShowWindow(1)
	end


	-- 3. chatframe 그룹채팅 버튼쪽에 전체 리드 카운트 갱신
	local allreadcounttext = GET_CHILD_RECURSIVELY(chatframe, "readcnt_all") 
	allreadcounttext:ShowWindow(0)
	local allreadcounttextbg = GET_CHILD_RECURSIVELY(chatframe, "readcnt_all_bg") 
	allreadcounttextbg:ShowWindow(0)
	local allcnt = session.chat.GetGroupChatNotReadMsgCount("all")

	if allcnt > 0 then
		allreadcounttext:SetText(tostring(allcnt))
		if allcnt > 99 then
			allreadcounttext:SetText("99+")
		end
		allreadcounttext:ShowWindow(1)
		allreadcounttextbg:ShowWindow(1)
	end


	-- 4. 각 팝업 프레임 및 팝업 프레임의 폴드 프레임에 대한 리드 카운트 갱신
	
	grouplistframe:Invalidate()

	
end


function CHAT_GROUPLIST_SET_OPTION(frame, chatCtrl, roomid, argnum)

	local opt_frame = ui.GetFrame('chat_grouplist_option');
	
	if opt_frame == nil then
		return
	end

	if opt_frame:IsVisible() == 1 then
		opt_frame:ShowWindow(0)
		return;
	end

	

	opt_frame:SetUserValue("ROOMID",roomid)
	local x = chatCtrl:GetGlobalX() + chatCtrl:GetWidth()/2
	local y = chatCtrl:GetGlobalY() - opt_frame:GetHeight()

	if x < 10 then
		x = 10
	end

	if y < 10 then
		y = 10
	end

	opt_frame:SetPos(x,y);
	CHAT_GROUPLIST_OPTION_DO_OPEN(opt_frame)
end

function UPDATE_GROUPLIST_TEXT(groupboxname)

	local size = session.ui.GetMsgInfoSize(groupboxname)
	
	if size < 1 then
		return;
	end
	local lastmsginfo = session.ui.GetChatMsgInfo(groupboxname, size-1)
	local msgString = lastmsginfo:GetMsg()
	local timestr = lastmsginfo:GetTimeStr()
	local gboxtype = string.sub(groupboxname,string.len("chatgbox_") + 1)

    msgString = string.gsub(msgString, "({img )(.-)( %d+ %d+})", "%1%2"..string.format(" %d %d}",15,15))

	local btnname = 'btn_'.. gboxtype
	
	local frame = ui.GetFrame('chat_grouplist')
	local btn = GET_CHILD_RECURSIVELY(frame, btnname)

	if btn ~= nil then

		local colorType = session.chat.GetRoomConfigColorType(gboxtype)
		local colorCls = GetClassByType("ChatColorStyle", colorType)
	
		if colorCls ~= nil and string.find(msgString, "a SL") == nil then
			msgString = "{#"..colorCls.TextColor.."}{ol}"..msgString.."{/}"
		end

		local text = GET_CHILD_RECURSIVELY(btn,"text")
		text:SetText(msgString)

		local timetext = GET_CHILD_RECURSIVELY(btn, "time")
		timetext:SetText(timestr)
	end


	local tableforsort = {}

	local gbox = btn:GetParent()
	local btncnt = 0;
	local gboxcount = gbox:GetChildCount();
	for  i = 0, gboxcount-1 do 
		local cset  = gbox:GetChildByIndex(i);

		if cset ~= nil then

            local roomid = cset:GetUserValue("ROOMID")
            
            if roomid ~= "None" then

                local info = session.chat.GetByStringID(roomid);
            

                if info ~= nil then
                    tableforsort[tostring(info:GetLastestMsgTime()) .. info:GetGuid()]  = cset:GetName()
                    btncnt = btncnt + 1
                end
            end
        end
    end

       
	local y = ui.GetControlSetAttribute("chatlist", 'height') * (btncnt-1)
	for key, value in orderedPairs(tableforsort) do
	  
		local child = GET_CHILD_RECURSIVELY(gbox, value)
        child:SetOffset (child:GetX (), y);
        
        y = y - child:GetHeight()
	end



	frame:Invalidate()
		
end

function LINK_GROUPCHAT_INVITE(roomid)
	
	local title = session.chat.GetRoomConfigTitle(roomid)

	local linkstr = string.format("{a SLC %s}{#0000FF}{img link_whisper 24 24}%s{/}{/}{/}", session.loginInfo.GetAID().."@@@"..roomid, title);
	
	SET_LINK_TEXT(linkstr);

	ui.GroupChatAllowTagInvite(roomid)

end

function GROUPCHAT_ADD_MEMBER(parent, ctrl)
	
	local roomid = ""
	local index = string.find(parent:GetName(),"_") 
	if index ~= nil then
		roomid = string.sub(parent:GetName(), index + 1)
	else
		return ;
	end
	
	local frame = ui.GetFrame("chat_grouplist")
	frame:SetUserValue("ROOM_ID",roomid)
	
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("PlzInputInviteName"), "EXED_GROUPCHAT_ADD_MEMBER", "",nil,nil,20);
end

function EXED_GROUPCHAT_ADD_MEMBER(parent, name)

	local frame = ui.GetFrame("chat_grouplist")
	local roomID = frame:GetUserValue("ROOM_ID")

	ui.GroupChatInviteSomeone(roomID, name)
end


function CREATE_NEW_GROUPCHAT()
	ui.ReqCreateGroupChat();
end


function CHAT_GROUP_REMOVE(roomID)

	local frame = ui.GetFrame('chat_grouplist');

	if frame == nil then
		return;
	end

	local cset = GET_CHILD_RECURSIVELY(frame, 'btn_'..roomID)
	if cset == nil then
		return
	end
	local gbox = cset:GetParent()
	gbox:RemoveChild('btn_'..roomID);

    GBOX_AUTO_ALIGN (gbox, 0, 0, 0, true, false);

    local popupframe = ui.GetFrame('chatpopup_'..roomID);
	if popupframe ~= nil then
		popupframe:ShowWindow(0)
	end
end





function MAKE_POPUP_CHAT_BY_XML(roomid, titleText, width, height, x, y, roomtype, popuptype, foldx, foldy)

	local newFrame = ui.CreateNewFrame("chatpopup", "chatpopup_" .. roomid);
	if popuptype == 2 then
        session.chat.SetShowPopup(roomid, 2)
        newFrame:Resize(newFrame:GetOriginalWidth(), newFrame:GetOriginalHeight())
		newFrame:SetOffset(foldx, foldy)
	else
        session.chat.SetShowPopup(roomid, 1)
        newFrame:Resize(width, height)
		newFrame:SetOffset(x, y)
	end
	newFrame:ShowWindow(1);

	local name = newFrame:GetChild("name");
	name:SetTextByKey("title", titleText);

	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", "chatgbox_" .. roomid, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

	local edit_bg = GET_CHILD_RECURSIVELY(newFrame, "edit_bg")
	local mainchat = GET_CHILD_RECURSIVELY(newFrame, "mainchat")
	local btn_memlist = GET_CHILD_RECURSIVELY(newFrame, "btn_memlist")
	local btn_invite = GET_CHILD_RECURSIVELY(newFrame, "btn_invite")
	local btn_config = GET_CHILD_RECURSIVELY(newFrame, "btn_config")


	edit_bg:ShowWindow(1)
	mainchat:ShowWindow(1)
	btn_memlist:ShowWindow(1)
	btn_config:ShowWindow(1)

	if roomtype == 3 then
		btn_invite:ShowWindow(1)
	else
		btn_invite:ShowWindow(0)
	end


	btn_config:SetEventScript(ui.LBUTTONUP, 'CHAT_GROUPLIST_SET_OPTION');
	btn_config:SetEventScriptArgString(ui.LBUTTONUP, roomid);

	DRAW_CHAT_MSG("chatgbox_" .. roomid, 0, newFrame)

	MAKE_POPUP_CHAT_MEMBER_LIST(roomid)
	CHATPOPUP_FOLD_BY_SIZE(newFrame)
end


function GROUPCHAT_COPY_TAG(parent, ctrl)

	if parent == nil then
		return
	end

	local roomID = string.sub(parent:GetName(), string.len("btn_") + 1)

    local info = session.chat.GetByStringID(roomID)
	if info == nil then
		return;
	end

    local cnt = info:GetMemberCount()

    if cnt >= GROUPCHAT_MAX_USER_CNT then
        ui.SysMsg(ScpArgMsg('LimitGroupChatMaxUserCnt'));
        return;
    end

	LINK_GROUPCHAT_INVITE(roomID)

end


function MAKE_POPUP_CHAT(parent, ctrl, roomid)
	
	local info = session.chat.GetByStringID(roomid);
	
	if info == nil then
		return;
	end

	local oldframe = ui.GetFrame("chatpopup_" .. roomid )

	if oldframe ~= nil then

		if oldframe:IsVisible() == 1 then	

			oldframe:ShowWindow(0)

		else
		
			oldframe:ShowWindow(1)

            DRAW_CHAT_MSG ("chatgbox_" .. roomid, 0, oldframe)
            chat.EnableUpdateReadFlag(roomid)
			UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomid)
		end



		return;
	end

	MAKE_POPUP_CHAT_BY_BTN(roomid)
end

function MAKE_POPUP_CHAT_BY_BTN(roomid)
	
	local newFrame = ui.CreateNewFrame("chatpopup", "chatpopup_" .. roomid);
	newFrame:Resize(500,300)
	local initx, inity = CHAT_POPUP_GET_EMPTY_PLACE("chatpopup_" .. roomid, 500, 300)
	newFrame:SetOffset(initx, inity)
	newFrame:ShowWindow(1);

	local info = session.chat.GetByStringID(roomid);

	local title = ""
	if info:GetRoomType() == 3 then
		title = session.chat.GetRoomConfigTitle(roomid)
		if title == "" then
			title = info:GetRoomName()
		end
		if title == "" then
            title = session.chat.GetNewGroupChatDefName();
        end
	else
		title = ScpArgMsg("ChatWith{Name}","Name", info:GetWhisperTargetName())
	end
	local name = newFrame:GetChild("name");
	name:SetTextByKey("title", title);

	local gboxleftmargin = newFrame:GetUserConfig("GBOX_LEFT_MARGIN")
	local gboxrightmargin = newFrame:GetUserConfig("GBOX_RIGHT_MARGIN")
	local gboxtopmargin = newFrame:GetUserConfig("GBOX_TOP_MARGIN")
	local gboxbottommargin = newFrame:GetUserConfig("GBOX_BOTTOM_MARGIN")
	
	local gbox = newFrame:CreateControl("groupbox", "chatgbox_" .. roomid, newFrame:GetWidth() - (gboxleftmargin + gboxrightmargin), newFrame:GetHeight() - (gboxtopmargin + gboxbottommargin), ui.RIGHT, ui.BOTTOM, 0, 0, gboxrightmargin, gboxbottommargin);
	_ADD_GBOX_OPTION_FOR_CHATFRAME(gbox)

	
	local btn_invite = GET_CHILD_RECURSIVELY(newFrame, "btn_invite")
	local btn_config = GET_CHILD_RECURSIVELY(newFrame, "btn_config")

	if info:GetRoomType() == 3 then
		btn_invite:ShowWindow(1)
	else
		btn_invite:ShowWindow(0)
	end

	btn_config:SetEventScript(ui.LBUTTONUP, 'CHAT_GROUPLIST_SET_OPTION');
	btn_config:SetEventScriptArgString(ui.LBUTTONUP, roomid);

	DRAW_CHAT_MSG("chatgbox_" .. roomid, 0, newFrame)
	ui.SaveChatConfig();

    MAKE_POPUP_CHAT_MEMBER_LIST (roomid)
    chat.EnableUpdateReadFlag(roomid)
	UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomid)
	CHATPOPUP_FOLD_BY_SIZE(newFrame)
end


function MAKE_POPUP_CHAT_MEMBER_LIST(roomid)
	
	local popupframe = ui.GetFrame("chatpopup_" .. roomid)
	if popupframe == nil then
		return
	end

	local newFrame = ui.CreateNewFrame("chat_memberlist", "chatmem_" .. roomid);

	newFrame:EnableInstanceMode(0)
	newFrame:SetOffset(popupframe:GetX() + popupframe:GetWidth(), popupframe:GetY())
	newFrame:ShowWindow(0);

	UPDATE_CHAT_MEMBERLIST(roomid)
end




function EXED_GROUPCHAT_ADD_MEMBER2(text,frame)
	
	local roomID = frame:GetUserValue("ArgString");
	ui.GroupChatInviteSomeone(roomID, text)
end

function CHAT_WHISPER_LEAVE(ctrl, ctrlset, argStr, artNum)
	ui.LeaveGroupOrWhisperChat(argStr);
end



function OUT_ALL_WHISPER(parent, ctrl)

end

function GROUPCHAT_OUT(parent, ctrl)

	if parent == nil then
		return
	end

	local roomID = string.sub(parent:GetName(), string.len("btn_") + 1)

	ui.LeaveGroupOrWhisperChat(roomID);

    UPDATE_READ_FLAG_BY_GBOX_NAME("chatgbox_" .. roomID)
    UPDATE_ROOM_READ_CNT(roomID)

    local chatframe = ui.GetFrame("chat")	    
    if chatframe ~= nil and chatframe:GetUserValue("CHAT_TYPE_SELECTED_VALUE") == "6" then
        ui.SetChatType(0)
    end

end
