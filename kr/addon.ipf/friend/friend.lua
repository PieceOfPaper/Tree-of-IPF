
FRIEND_MINIMIZE_HEIGHT = 100;

function FRIEND_ON_INIT(addon, frame)
    -- open msg
	addon:RegisterOpenOnlyMsg("REMOVE_FRIEND", "ON_REMOVE_FRIEND");
	addon:RegisterOpenOnlyMsg("ADD_FRIEND", "ON_ADD_FRIEND");
	addon:RegisterOpenOnlyMsg("GAME_START", "FRIEND_GAME_START");
	addon:RegisterOpenOnlyMsg("UPDATE_FRIEND_LIST", "ON_UPDATE_FRIEND_LIST");
	addon:RegisterOpenOnlyMsg("FRIEND_SESSION_CHANGE", "ON_FRIEND_SESSION_CHANGE");	
	addon:RegisterOpenOnlyMsg("RELATED_SESSION_COUNT", "ON_UPDATE_FRIEND_LIST");	
	addon:RegisterOpenOnlyMsg("RELATED_HISTORY", "ON_UPDATE_FRIEND_LIST");
	addon:RegisterOpenOnlyMsg("TREE_NODE_RCLICK", "ON_TREE_NODE_RCLICK");

    -- common msg
	addon:RegisterMsg("FRIEND_NAME_CHANGED", "ON_UPDATE_FRIEND_LIST");
	addon:RegisterMsg("GAME_START_3SEC", "CHECK_FRIEND_NEW_INVITE");

	FRIEND_EXPAND_UNIT = 10;

	-- sort list
	local frame = ui.GetFrame('friend')
	local sortTypeList = GET_CHILD_RECURSIVELY(frame, 'sortTypeList')

	sortTypeList:AddItem("LOGIN", ScpArgMsg("SortByLogin"))
	sortTypeList:AddItem("RECENT", ScpArgMsg("SortByRecent"))
	sortTypeList:AddItem("TEAMNAME", ScpArgMsg("SortByTeamName"))
end

function ON_TREE_NODE_RCLICK(frame, msg, clickedGroupName, argNum)


	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);
		if nil == f then
			break;
		end

		local groupname = f:GetGroupName()
		if groupname == clickedGroupName then
			local context = ui.CreateContextMenu("GROUP_EDIT_CONTEXT", "", 0, 0, 0, 0);
			local groupDelScp = string.format("FRIEND_GROUP_CHANGE_NAME(\"%s\")", groupname);
			ui.AddContextMenuItem(context, ScpArgMsg("FriendGroupChangeName"), groupDelScp);

			local groupDelScp = string.format("FRIEND_GROUP_DELETE(\"%s\")", groupname);
			ui.AddContextMenuItem(context, ScpArgMsg("FriendGroupDelete"), groupDelScp);

			ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
			ui.OpenContextMenu(context);

			break;
		end
	end
end

function FRIEND_GROUP_CHANGE_NAME(groupname)

	local frame = ui.GetFrame('friend')
	frame:SetUserValue("CHANGE_GROUP_NAME", groupname);
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameToAddToGroup"), "EXED_FRIEND_CHANGE_GROUP_NAME", "",nil,nil,20); -- 최대 그룹 입력 제한 수
end

function EXED_FRIEND_CHANGE_GROUP_NAME(frame, groupname)
	
	local oldgroupname = frame:GetUserValue("CHANGE_GROUP_NAME");
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		

		if f ~= nil and oldgroupname == f:GetGroupName() then
			friends.RequestSetGroup(f:GetInfo():GetACCID(), groupname);
		end
	end

end

function FRIEND_GROUP_DELETE(groupname)

	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		

		if f ~= nil and  groupname == f:GetGroupName() then
			friends.RequestSetGroup(f:GetInfo():GetACCID(), '');
		end
	end

end

function FRIEND_GAME_START(frame)
	local normaltree = GET_CHILD_RECURSIVELY(frame, 'friendtree_normal','ui::CTreeControl')
	local requesttree = GET_CHILD_RECURSIVELY(frame, 'friendtree_request','ui::CTreeControl')

	normaltree:Clear();
	normaltree:EnableDrawTreeLine(false);
	normaltree:EnableDrawFrame(false);
    normaltree:EnableScrollBar(0);
	normaltree:SetFitToChild(true,100);
	normaltree:SetFontName("brown_18_b");
	normaltree:SetTabWidth(0);
	normaltree:OpenNodeAll();
    normaltree:SetUserValue('MAX_VISIBLE_INFO_COUNT', FRIEND_EXPAND_UNIT);

    local moreFriendBtn = GET_CHILD_RECURSIVELY(frame, 'moreFriendBtn');
    moreFriendBtn:SetEnable(1);

	requesttree:Clear();
	requesttree:EnableDrawTreeLine(false);
	requesttree:EnableDrawFrame(false);
    requesttree:EnableScrollBar(0);
	requesttree:SetFitToChild(true,100);
	requesttree:SetFontName("brown_18_b");
	requesttree:SetTabWidth(0);
	requesttree:OpenNodeAll();
    
    UPDATE_FRIEND_LIST_COMPLETE(frame, true);
end

function UI_TOGGLE_FRIEND()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('friend')

end

function CHECK_FRIEND_NEW_INVITE(frame)
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_REQUESTED);
	if cnt > 0 then
		if 1 == ui.IsFrameVisible("new_friend_msg") then
			return;
		end

		local scpString = "{a OPEN_FRIEND_FRAME}";
		local viewText = ScpArgMsg("NewFriendInvitationExist");
		local helpBalloon = MAKE_BALLOON_FRAME(scpString .. viewText, 0, 0, nil, "new_friend_msg", "{#050505}{s16}{b}", 1);
		helpBalloon:ShowWindow(1);
		local sysFrame = ui.GetFrame("sysmenu");
		local friendBtn = sysFrame:GetChild("friend");
        local margin = friendBtn:GetMargin();
        local x = margin.right;
        local y = margin.bottom;        
		x = x + (friendBtn:GetWidth() / 2);
		y = y + friendBtn:GetHeight() + 5;
        helpBalloon:SetGravity(ui.RIGHT, ui.BOTTOM);
        helpBalloon:SetMargin(0, 0, x, y);

		helpBalloon:SetDuration(5);
	else
		ui.CloseFrame("new_friend_msg");
	end
end

function FRIEND_OPEN(frame)

end

function ON_UPDATE_FRIEND_LIST(frame, msg, argStr, argNum)
	UPDATE_FRIEND_LIST(frame);
	CHECK_FRIEND_NEW_INVITE(frame);
end

function FRIEND_GET_GROUPNAME(type)
	if type == FRIEND_LIST_COMPLETE then
		return "FriendList"
	elseif type == FRIEND_LIST_REQUESTED then
		return "InvitedList"
	elseif type == FRIEND_LIST_REQUEST then
		return "InviteList"
	elseif type == FRIEND_LIST_REJECTED then
		return "InvitationRejectedList"
	elseif type == FRIEND_LIST_BLOCKED then
		return "InviteBlockList"
	end

	return nil
end

function ENABLE_SHOW_ONLY_ONLINE_FRIEND(parent, ctrl)

	local frame = ui.GetFrame("friend");
	UPDATE_FRIEND_LIST(frame)

end

function SEARCH_FRIEND()
	local frame = ui.GetFrame("friend")
	UPDATE_FRIEND_LIST(frame)
end

function SELECT_FRIEND_LIST_SORT_TYPE()
	local frame = ui.GetFrame("friend")
	UPDATE_FRIEND_LIST(frame)
end

function UPDATE_FRIEND_LIST(frame)

	local showOnlyOnline = config.GetXMLConfig("Friend_ShowOnlyOnline")
	
	local normaltree = GET_CHILD_RECURSIVELY(frame, 'friendtree_normal','ui::CTreeControl')
	local requesttree = GET_CHILD_RECURSIVELY(frame, 'friendtree_request','ui::CTreeControl')

	normaltree:Clear();
	requesttree:Clear();

    local moreFriendBtn = GET_CHILD_RECURSIVELY(frame, 'moreFriendBtn');
    moreFriendBtn:SetEnable(1);
	
	local groupnamelist = {}
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		
		local groupname = f:GetGroupName()

		if groupname ~= nil and groupname ~= "" and groupname ~= "None" and groupnamelist[groupname] == nil then
			
			if showOnlyOnline == 0 or (showOnlyOnline == 1 and f.mapID ~= 0) then
				table.insert(groupnamelist,groupname)
			end
		end
	end

	for k, customgroupname in pairs(groupnamelist) do
		BUILD_FRIEND_LIST(frame, FRIEND_LIST_COMPLETE, customgroupname, "custom");
	end

	BUILD_FRIEND_LIST(frame, FRIEND_LIST_COMPLETE, FRIEND_GET_GROUPNAME(FRIEND_LIST_COMPLETE));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REQUESTED, FRIEND_GET_GROUPNAME(FRIEND_LIST_REQUESTED));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REQUEST, FRIEND_GET_GROUPNAME(FRIEND_LIST_REQUEST));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REJECTED, FRIEND_GET_GROUPNAME(FRIEND_LIST_REJECTED));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_BLOCKED, FRIEND_GET_GROUPNAME(FRIEND_LIST_BLOCKED));

end

function UPDATE_FRIEND_LIST_COMPLETE(frame, isFirst)
    local showOnlyOnline = config.GetXMLConfig("Friend_ShowOnlyOnline");	
	local normaltree = GET_CHILD_RECURSIVELY(frame, 'friendtree_normal','ui::CTreeControl');
    if isFirst == true then
	    normaltree:Clear();
        local moreFriendBtn = GET_CHILD_RECURSIVELY(frame, 'moreFriendBtn');
        moreFriendBtn:SetEnable(1);
    end
	
	local groupnamelist = {};
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		
		local groupname = f:GetGroupName();
		if groupname ~= nil and groupname ~= "" and groupname ~= "None" and groupnamelist[groupname] == nil then			
			if showOnlyOnline == 0 or (showOnlyOnline == 1 and f.mapID ~= 0) then
				table.insert(groupnamelist,groupname);
			end
		end
	end

	for k, customgroupname in pairs(groupnamelist) do
		BUILD_FRIEND_LIST(frame, FRIEND_LIST_COMPLETE, customgroupname, "custom");
	end
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_COMPLETE, FRIEND_GET_GROUPNAME(FRIEND_LIST_COMPLETE));
end

function UPDATE_FRIEND_LIST_REQUEST(frame, isFirst)
	local requesttree = GET_CHILD_RECURSIVELY(frame, 'friendtree_request','ui::CTreeControl')
    if isFirst == true then
        local topFrame = frame:GetTopParentFrame();
        topFrame:SetUserValue('FIRST_LOAD_SUCCESS', 'YES');
	    requesttree:Clear();
    end
	
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REQUESTED, FRIEND_GET_GROUPNAME(FRIEND_LIST_REQUESTED));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REQUEST, FRIEND_GET_GROUPNAME(FRIEND_LIST_REQUEST));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_REJECTED, FRIEND_GET_GROUPNAME(FRIEND_LIST_REJECTED));
	BUILD_FRIEND_LIST(frame, FRIEND_LIST_BLOCKED, FRIEND_GET_GROUPNAME(FRIEND_LIST_BLOCKED));
end

function BUILD_FRIEND_LIST(frame, listType, groupName, iscustom)

	local showOnlyOnline = config.GetXMLConfig("Friend_ShowOnlyOnline")

	local treename = 'friendtree_normal';
	local treegboxname = 'friendtree_normal_gbox';
    local isNormalTree = true;

	if listType ~= FRIEND_LIST_COMPLETE then
		treename = 'friendtree_request'
		treegboxname = 'friendtree_request_gbox'
        isNormalTree = false;
	end

	local tree = GET_CHILD_RECURSIVELY(frame, treename,'ui::CTreeControl')
	local treegbox = GET_CHILD_RECURSIVELY(frame, treegboxname,'ui::CTreeControl')
    local visibleInfoCnt = 100000000; -- default
    if isNormalTree == true then
        visibleInfoCnt = tree:GetUserIValue('MAX_VISIBLE_INFO_COUNT');
    end

	local slotWidth = ui.GetControlSetAttribute(GET_FRIEND_CTRLSET_NAME(listType), 'width');
	local slotHeight = ui.GetControlSetAttribute(GET_FRIEND_CTRLSET_NAME(listType), 'height');

	local friendListGroup = tree:FindByValue(groupName);
	if tree:IsExist(friendListGroup) == 0 then
		if iscustom == "custom" and listType == FRIEND_LIST_COMPLETE then
			local grouptext = tree:CreateOrGetControl('richtext',groupName,0,0,200,30)
			friendListGroup = tree:Add(groupName, groupName);
		else
			friendListGroup = tree:Add(ScpArgMsg(groupName), groupName);
		end
		tree:SetNodeFont(friendListGroup,"brown_16_b")
	end

	local pageCtrlName = "PAGE_" .. groupName;

	local page = tree:GetChild(pageCtrlName);
	
	if page == nil then
		page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, treegbox:GetWidth()-35, 0);

		tolua.cast(page, 'ui::CPage')
		page:SetSkinName('None');

		if listType == FRIEND_LIST_COMPLETE then
			slotHeight = FRIEND_MINIMIZE_HEIGHT
		end

		page:SetSlotSize(slotWidth, slotHeight)
		page:SetFocusedRowHeight(-1, slotHeight); -- 연구 필요.
		page:SetFitToChild(true, 10);
		page:SetSlotSpace(0, 0)
		page:SetBorder(5, 0, 0, 0)
		
		
		tree:Add(friendListGroup, page);
	end

	if listType == FRIEND_LIST_COMPLETE then
		FRIEND_MINIMIZE_FOCUS(page);
	end
	tolua.cast(page, 'ui::CPage')
	page:RemoveAllChild();
	page:SetFocusedRow(-1);

	local sortTypeList = GET_CHILD_RECURSIVELY(frame, "sortTypeList")

	local showCnt = 0;
	local sortType = sortTypeList:GetSelItemKey();
	local friendList = SORTED_FRIEND_LIST(sortType, listType);
	for i = 1, #friendList do
		local friendInfo = session.friends.GetFriendByIndex(listType, friendList[i]);
        if isNormalTree == false or showCnt < visibleInfoCnt then
		    if (showOnlyOnline == 0) or 
            (showOnlyOnline == 1 and friendInfo.mapID ~= 0) or
            (showOnlyOnline == 1 and FRIEND_LIST_COMPLETE ~= listType) then

			    local ismakenewset = false;
			    if listType == FRIEND_LIST_COMPLETE then

				    local eachGroupName = friendInfo:GetGroupName();
				    if iscustom == "custom" then
					    if eachGroupName == groupName then
						    ismakenewset = true;
					    end
				    else
					    if eachGroupName == nil or eachGroupName == "" or eachGroupName == "None" then
						    ismakenewset = true;
					    end
				    end

				    if ismakenewset == true then
					    --검색 기능
					    local edit = GET_CHILD_RECURSIVELY(frame, "friendSearch");
					    local cap = edit:GetText();
					    if string.len(cap) > 0 and ui.FindWithChosung(cap, friendInfo:GetInfo():GetFamilyName()) == false then
						    ismakenewset = false;
					    end 
				    end
			    else
				    ismakenewset = true;
			    end

			    if ismakenewset == true then
                    local ctrlSetName = GET_FRIEND_CTRLSET_NAME(listType);
                    if listType == FRIEND_LIST_COMPLETE and friendInfo.mapID == 0 then
                        ctrlSetName = ctrlSetName .. '_not_online';
                    end
				    local ctrlSet = page:CreateOrGetControlSet(ctrlSetName, "FR_" .. listType .. "_" .. friendInfo:GetInfo():GetACCID(), 0, 0, 0);
				    if listType == FRIEND_LIST_COMPLETE and friendInfo.mapID > 0 then
					    ctrlSet:Resize(ctrlSet:GetOriginalWidth(), FRIEND_MINIMIZE_HEIGHT);
				    end                    
				    UPDATE_FRIEND_CONTROLSET(ctrlSet, listType, friendInfo);
                    showCnt = showCnt + 1;
			    end
		    end
        end
	end
	
	tree:OpenNodeAll();

end

function SORTED_FRIEND_LIST(sortType, listType)
	local list = {}

	local cnt = session.friends.GetFriendCount(listType)
	for i = 0, cnt-1 do
		list[#list+1] = i
	end

	if sortType == "TEAMNAME" then
		table.sort(list, function(a, b)
			local friendInfoA = session.friends.GetFriendByIndex(listType, a)
			local friendInfoB = session.friends.GetFriendByIndex(listType, b)
		
			local friendNameA = friendInfoA:GetInfo():GetFamilyName()
			local friendNameB = friendInfoB:GetInfo():GetFamilyName()

			if friendNameA == nil or friendNameA == "" then
				return false
			end

			if friendNameB == nil or friendNameB == "" then
				return true
			end

			return friendNameA < friendNameB
		end)
	end

	if sortType == "LOGIN" then
		table.sort(list, function(a, b)
			local friendInfoA = session.friends.GetFriendByIndex(listType, a)
			local friendInfoB = session.friends.GetFriendByIndex(listType, b)

			local loginStateA = friendInfoA.mapID ~= 0
			local loginStateB = friendInfoB.mapID ~= 0

			-- 둘 다 접속중이면 이름순으로
			if loginStateA and loginStateB then
				local friendNameA = friendInfoA:GetInfo():GetFamilyName()
				local friendNameB = friendInfoB:GetInfo():GetFamilyName()

				if friendNameA == nil or friendNameA == "" then
					return false
				end
	
				if friendNameB == nil or friendNameB == "" then
					return true
				end
	
				return friendNameA < friendNameB
			end

			if loginStateA and loginStateB == false then
				return true
			end

			if loginStateB and loginStateA == false then
				return false
			end
		
			local logoutTimeA = imcTime.GetDiffSecFromNow(friendInfoA:GetInfo().logoutTime)
			local logoutTimeB = imcTime.GetDiffSecFromNow(friendInfoB:GetInfo().logoutTime)

			return logoutTimeA < logoutTimeB
		end)
	end

	if sortType == "RECENT" then
		table.sort(list, function(a, b)
			return a > b
		end)
	end

	return list
end

function CONFIRM_FRIEND_STATE(parent, ctrl, str, num)
	local aid = parent:GetUserValue("AID");
	if tonumber(aid) > 0 then
		friends.RequestDelete(aid);
	end	
end

function ACCEPT_FRIEND(parent, ctrl, str, num)
	local aid = parent:GetUserValue("AID");

	if tonumber(aid) > 0 then
		friends.AcceptInvite(aid);
	end	
end

function REJECT_FRIEND(parent, ctrl, str, num)
	local aid = parent:GetUserValue("AID");
	if tonumber(aid) > 0 then
		friends.RejectInvite(aid);
	end	
end

function GET_INTERACTION_BADGE_IMAGENAME_BY_TYPE(type) -- 나중에는 카운트에 따라서 뱃지 이미지가 바뀔지도 모른다.
	
	if type == PC_INTERACTION_PLAYWITH then
		return 'friend_play'
	elseif type == PC_INTERACTION_PARTY then
		return 'friend_party'
	elseif type == PC_INTERACTION_TRADE then
		return 'friend_deal'
	end
	
end

function GET_INTERACTION_BADGE_TOOLTIPSTR_BY_TYPE(type,count) -- 나중에는 카운트에 따라서 뱃지 이미지가 바뀔지도 모른다.
	
	if type == PC_INTERACTION_PLAYWITH then
		return ScpArgMsg('BadgeTooltipSTR_PLAYWITH',"Count",count)
	elseif type == PC_INTERACTION_PARTY then
		return ScpArgMsg('BadgeTooltipSTR_PARTY',"Count",count)
	elseif type == PC_INTERACTION_TRADE then
		return ScpArgMsg('BadgeTooltipSTR_TRADE',"Count",count)
	end
	
end

function UPDATE_FRIEND_CONTROLSET_BY_PCINFO(ctrlSet, mapID, channel, info, drawNameWhenLogout)

	local jobportrait_bg = GET_CHILD(ctrlSet, "jobportrait_bg", "ui::CPicture");
	local jobportrait = GET_CHILD(ctrlSet, "jobportrait", "ui::CPicture");
	local team_name_text = ctrlSet:GetChild("team_name_text");
	local pc_name_text = ctrlSet:GetChild("pc_name_text");
	local job_text = ctrlSet:GetChild("job_text");
	local map_name_text = ctrlSet:GetChild("map_name_text");
	local map_name_channel_text = ctrlSet:GetChild("map_name_channel_text");
	local level_text = GET_CHILD(ctrlSet, "level_text", "ui::CRichText");
	
	team_name_text:SetTextByKey("name", info:GetFamilyName());	
	if mapID == 0 then

		team_name_text:SetColorTone("FF1f100b");		

		local sysTime = geTime.GetServerSystemTime();
		
		if map_name_text ~= nil then
			map_name_text:SetColorTone("FF1f100b");
			local diffsec = imcTime.GetDiffSecFromNow(info.logoutTime)

			if diffsec < 0 or diffsec > 315360000 then
				map_name_text:ShowWindow(0)
			else
				map_name_text:SetTextByKey("name", GET_DIFF_TIME_TXT(diffsec));
				map_name_text:ShowWindow(1)
			end

			

			map_name_channel_text:ShowWindow(0)
			map_name_text:ShowWindow(1)
		end

		if pc_name_text ~= nil then
			pc_name_text:ShowWindow(0);
		end
		if jobportrait ~= nil then
			jobportrait:ShowWindow(0);
		end
		if level_text ~= nil then
			level_text:ShowWindow(0);
		end
		if job_text ~= nil then
			job_text:ShowWindow(0);
		end

	else

		team_name_text:SetColorTone(0);		

		if level_text ~= nil then
			level_text:SetTextByKey("lv", info.lv);
			level_text:ShowWindow(1);
		end

		if job_text ~= nil then
			local jobid = info:GetIconInfo().job;
			local gender = info:GetIconInfo().gender;
			local jobCls = GetClassByType("Job", jobid);
			job_text:SetText(GET_JOB_NAME(jobCls, gender));
			job_text:ShowWindow(1);
		end

		local mapCls = GetClassByType("Map", mapID);
		if map_name_channel_text ~= nil and mapCls ~= nil then
			map_name_channel_text:SetColorTone(0);
			map_name_channel_text:SetTextByKey("name", mapCls.Name)
			map_name_channel_text:SetTextByKey("channel", channel+1)

			map_name_channel_text:ShowWindow(1)
			map_name_text:ShowWindow(0)
		end

		if pc_name_text ~= nil then
			pc_name_text:SetTextByKey("name", info:GetPCName());
			pc_name_text:ShowWindow(1);
		end

		if jobportrait ~= nil then
			jobportrait = tolua.cast(jobportrait, "ui::CPicture");
			local imgName = ui.CaptureModelHeadImage_IconInfo(info:GetIconInfo());
			jobportrait:SetImage(imgName);			
			jobportrait:ShowWindow(1);
		end

	end

end

function GET_FRIEND_CTRLSET_NAME(listType)
	if listType == FRIEND_LIST_COMPLETE then return "friend" ;
	elseif listType == FRIEND_LIST_REQUESTED then return "friend_yesorno";
	elseif listType == FRIEND_LIST_REQUEST then return "friend_not";
	elseif listType == FRIEND_LIST_REJECTED then return "friend_not";
	elseif listType == FRIEND_LIST_BLOCKED then return "friend_not";
	else return "friend" end
end

function FRIEND_MINIMIZE_FOCUS(page)

	page = tolua.cast(page, "ui::CPage");

	local curFocus = page:GetFocusedRow();
	local beforeFocus = page:GetObjectByRow(curFocus);	

	if beforeFocus ~= nil then
		FREIND_PAGE_SET_DETAIL(beforeFocus, 0);
	end
end

function FRIEND_PAGE_FOCUS(ctrlSet, button)

	local page = ctrlSet:GetParent();

	page = tolua.cast(page, "ui::CPage");
	local row = page:GetObjectRow(ctrlSet);
	local curFocus = page:GetFocusedRow();
	local minimized = page:GetUserIValue("minimized");
	local slotHeight = FRIEND_MINIMIZE_HEIGHT    

	if ctrlSet:GetHeight() > FRIEND_MINIMIZE_HEIGHT then
		page:SetFocusedRowHeight(-1, slotHeight);
		page:SetUserValue("minimized", 1);
		FREIND_PAGE_SET_DETAIL(ctrlSet, 0);
		button:SetText(ScpArgMsg('DownButtonText'))
	else
		
		FRIEND_MINIMIZE_FOCUS(page);
		page:SetUserValue("minimized", 0);
		page:SetFocusedRow(row);
		local resultHeight = FREIND_PAGE_SET_DETAIL(ctrlSet, 1);

		if resultHeight ~= 0 then

			--page:SetFocusedRowHeight(slotHeight, resultHeight, 0.15, 0.7, 5);
			page:SetFocusedRowHeight(slotHeight, resultHeight);
		end

		button:SetText(ScpArgMsg('UpButtonText'))

		for i = 0, page:GetChildCount() - 1 do
			local otherctrlset = page:GetChildByIndex(i);
			local otherbtn = GET_CHILD(otherctrlset,'viewdetailbtn','ui::CButton')
			if otherbtn ~= nil and otherbtn ~= button then
				otherbtn:SetText(ScpArgMsg('DownButtonText'))
			end
		end
	end

end

function FREIND_PAGE_SET_DETAIL(ctrlset, detailMode)

	local curMode = ctrlset:GetUserIValue("DETAILMODE");
	if curMode == detailMode then
		return 0;
	end

	ctrlset:SetUserValue("DETAILMODE", detailMode);

	if detailMode == 0 then    
		ctrlset:Resize(ctrlset:GetOriginalWidth(), FRIEND_MINIMIZE_HEIGHT);
		return 0;
	else
		ctrlset:Resize(ctrlset:GetOriginalWidth(), ctrlset:GetOriginalHeight() );
		return ctrlset:GetOriginalHeight();
	end
	
	return 0;
end

function ON_REMOVE_FRIEND(frame, msg, aid, listType)
	ON_UPDATE_FRIEND_LIST(frame)
end

function ON_ADD_FRIEND(frame, msg, aid, listType)
	ON_UPDATE_FRIEND_LIST(frame);	
end

function ON_FRIEND_SESSION_CHANGE(frame, msg, aid, listType)

	local f = session.friends.GetFriendByAID(listType, aid);
	if nil == f then
		return;
	end
	local showOnlyOnline = config.GetXMLConfig("Friend_ShowOnlyOnline")

	if showOnlyOnline == 1 or f.mapID == 0 then
		ON_UPDATE_FRIEND_LIST(frame);
		return;
	end
	local treename = 'friendtree_normal'

	if listType ~= FRIEND_LIST_COMPLETE then
		treename = 'friendtree_request'
	end

	local tree = GET_CHILD_RECURSIVELY(frame, treename,'ui::CTreeControl')
	
	local pageCtrlName = "PAGE_" .. FRIEND_GET_GROUPNAME(listType);
	if f:GetGroupName() ~= nil and f:GetGroupName() ~= "" then
		pageCtrlName = "PAGE_" .. f:GetGroupName();
	end
	local page = tree:GetChild(pageCtrlName);
	
	if page == nil then
		BUILD_FRIEND_LIST(frame, listType, f:GetGroupName(), "custom")
		page = tree:GetChild(pageCtrlName);
		if page == nil then
			page = tree:GetChild("PAGE_" .. FRIEND_GET_GROUPNAME(listType));
		end
	end
	local childName = "FR_" .. listType .. "_" .. f:GetInfo():GetACCID();

	local ctrlSet = page:GetChild(childName);
	if ctrlSet ~= nil then
		page:RemoveChild(childName);
	end
	if f.mapID == 0 and ctrlSet:GetChild('logoutText') == nil then
		ctrlSet = page:CreateOrGetControlSet('friend_not_online', childName, 0, 0);
		
	else --온라인상태
		ctrlSet = page:CreateOrGetControlSet(GET_FRIEND_CTRLSET_NAME(listType), childName, 0, 0);
		ctrlSet:Resize(ctrlSet:GetOriginalWidth(), FRIEND_MINIMIZE_HEIGHT);
	end
	
	UPDATE_FRIEND_CONTROLSET(ctrlSet, listType, f);
	
end

function OPEN_FRIEND_FRAME()
	ui.ToggleFrame("friend");
end

function FRIEND_REGISTER(parent)
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameToAddToFriend"), "EXED_FRIEND_REGISTER", "",nil,nil,20);
end

function FRIEND_BLOCK(parent)
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameToBlock"), "EXED_FRIEND_BLOCK", "",nil,nil,20); -- 최대 그룹 입력 제한 수
end

function EXED_FRIEND_REGISTER(frame, friendName)
	if friendName ~= nil then
		friendName = string.gsub(friendName, ' ', ''); -- 이름에 공백 안됨
	end

    if friendName == nil or friendName == '' then        
        return;
    end
	friends.RequestRegister(friendName);
end

function EXED_FRIEND_BLOCK(frame, friendName)
	friends.RequestBlock(friendName);
end

function FRIEND_SET_MEMO(aid)
	local frame = ui.GetFrame('friend')
	frame:SetUserValue("AID", aid);
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameToAddToMemo"), "EXED_FRIEND_SET_MEMO", "",nil,nil,30); -- 최대 입력 제한 수
end

function EXED_FRIEND_SET_MEMO(frame, memo)

	local aid = frame:GetUserValue("AID");
	friends.RequestSetMemo(aid,memo);
end

function FRIEND_SET_GROUP(aid)
	local frame = ui.GetFrame('friend')
	frame:SetUserValue("AID", aid);
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputTeamNameToAddToGroup"), "EXED_FRIEND_SET_GROUP", "",nil,nil,20); -- 최대 그룹 입력 제한 수
end

function EXED_FRIEND_SET_GROUP(frame, groupname)
	
	local aid = frame:GetUserValue("AID");
	friends.RequestSetGroup(aid,groupname);
end


function UPDATE_FRIEND_CONTROLSET(ctrlSet, listType, friendInfo)
	local info = friendInfo:GetInfo();    
	ctrlSet:SetUserValue("AID", info:GetACCID());

    -- 접속 안한 친구는 별도 컨트롤셋 적용
    if listType == FRIEND_LIST_COMPLETE and friendInfo.mapID == 0 then
        local logoutText = ctrlSet:GetChild('logoutText');
        local logoutTime = imcTime.GetDiffSecFromNow(info.logoutTime);
                
		logoutText:SetTextByKey('name', info:GetFamilyName());
		if logoutTime < 0 or logoutTime > 31536000 then
			logoutText:SetTextByKey('time', ScpArgMsg("LogoutLongTime"));
		else
			logoutText:SetTextByKey('time', GET_DIFF_TIME_TXT(logoutTime));
		end
		ctrlSet:SetEventScript(ui.RBUTTONUP, "POPUP_FRIEND_COMPLETE_CTRLSET");
        return;
    end

	local memo = friendInfo:GetMemo();
	if memo == 'None' then
		memo = ''
	end
	local frame = ctrlSet:GetTopParentFrame();
	
	if listType == FRIEND_LIST_COMPLETE then	
		ctrlSet:SetEventScript(ui.RBUTTONUP, "POPUP_FRIEND_COMPLETE_CTRLSET");
	elseif listType == FRIEND_LIST_REJECTED or listType == FRIEND_LIST_BLOCKED or listType == FRIEND_LIST_REQUEST then
		ctrlSet:SetEventScript(ui.RBUTTONUP, "POPUP_FRIEND_DELETE_CTRLSET");
	end

	local memortext = GET_CHILD(ctrlSet,'memo','ui::CRichText')
	if memortext ~= nil then
		memortext:SetTextByKey('memo',memo);
	end

	UPDATE_FRIEND_CONTROLSET_BY_PCINFO(ctrlSet,  friendInfo.mapID, friendInfo.channel, info, true);
	
end

function POPUP_FRIEND_DELETE_CTRLSET(parent, ctrlset)

	local aid = ctrlset:GetUserValue("AID");
	
	if tonumber(aid) == 0 then
		return;
	end

	local f = nil;
	local listtype = nil;
	for i = 0, FRIEND_LIST_COUNT do
		f = session.friends.GetFriendByAID(i, aid);
		listtype = i;
		if f ~= nil then 
			break;
		end
	end

	if f == nil then
		return;
	end

	local info = f:GetInfo();
	local context = ui.CreateContextMenu("FRIEND_DELETE_CONTEXT", "", 0, 0, 0, 0);

	local deleteScp = string.format("friends.RequestDelete('%s')", aid);

	if listtype == FRIEND_LIST_BLOCKED then
		ui.AddContextMenuItem(context, ScpArgMsg("ReleaseBlock"), deleteScp);
	else
		ui.AddContextMenuItem(context, ScpArgMsg("FriendDelete"), deleteScp);
	end

	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function FRIEND_EXEC_DELETE(aid)

	local yesScp = string.format("friends.RequestDelete('%s')",aid); 
	ui.MsgBox(ScpArgMsg('AreYouWantDeleteFriend'), yesScp, "None");

end

function POPUP_FRIEND_COMPLETE_CTRLSET(parent, ctrlset)

	local aid = ctrlset:GetUserValue("AID");
	if aid == "" then
		return;
	end

	local f = session.friends.GetFriendByAID(FRIEND_LIST_COMPLETE, aid);

	if f == nil then
		return;
	end

	local info = f:GetInfo();
	local context = ui.CreateContextMenu("FRIEND_CONTEXT", "", 0, 0, 0, 0);

	if f.mapID ~= 0 then
		local partyinviteScp = string.format("PARTY_INVITE(\"%s\")", info:GetFamilyName());
		ui.AddContextMenuItem(context, ScpArgMsg("PARTY_INVITE"), partyinviteScp);
		
		--메모 추가
		local memoScp = string.format("FRIEND_SET_MEMO(\"%s\")",aid);
		ui.AddContextMenuItem(context, ScpArgMsg("FriendAddMemo"), memoScp);
	end

	local whisperScp = string.format("ui.WhisperTo('%s')", info:GetFamilyName());
	ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), whisperScp);

	
	local groupnamelist = {}
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local allfriend = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		
		local groupname = allfriend:GetGroupName()

		if groupname ~= nil and groupname ~= "" and groupname ~= "None" and groupname ~= f:GetGroupName() and groupnamelist[groupname] == nil then
			
			table.insert(groupnamelist,groupname)
			
		end
	end

	local subcontext = ui.CreateContextMenu("SUB", "", 0, 0, 0, 0);
	--그룹 설정
	
	for k, customgroupname in pairs(groupnamelist) do
		local groupScp = string.format("FRIEND_SET_GROUPNAME('%d',\"%s\")",tonumber(aid), customgroupname);
		ui.AddContextMenuItem(subcontext, customgroupname, groupScp);
	end

	local nowgroupname = f:GetGroupName()
	if nowgroupname ~= nil and nowgroupname ~= "" and nowgroupname ~= "None"  then
		local groupScp = string.format("FRIEND_SET_GROUPNAME('%s','%s')",aid, '');
		ui.AddContextMenuItem(subcontext, ScpArgMsg(FRIEND_GET_GROUPNAME(FRIEND_LIST_COMPLETE)), groupScp);
	end
	
	local groupScp = string.format("FRIEND_SET_GROUP(\"%s\")",aid);
	ui.AddContextMenuItem(subcontext, ScpArgMsg("FriendAddNewGroup"), groupScp);

	local groupScp = string.format("POPUP_FRIEND_GROUP_CONTEXTMENU(\"%s\")",aid);
	ui.AddContextMenuItem(context, ScpArgMsg("FriendAddGroup"), groupScp , nil, 0,1, subcontext);

	local blockScp = string.format("friends.RequestBlock('%s')",info:GetFamilyName() );
	ui.AddContextMenuItem(context, ScpArgMsg("FriendBlock"), blockScp)

	local deleteScp = string.format("FRIEND_EXEC_DELETE(\"%s\")", aid);
	ui.AddContextMenuItem(context, ScpArgMsg("FriendDelete"), deleteScp);
	
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function FRIEND_SET_GROUPNAME(aid, groupname)
	
	friends.RequestSetGroup(aid,groupname);
	ui.CloseAllContextMenu()

end

function POPUP_FRIEND_GROUP_CONTEXTMENU(aid)

	local groupnamelist = {}
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);

	for i = 0 , cnt - 1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);		
		if nil ~= f then
			local groupname = f:GetGroupName()

			if groupname ~= nil and groupname ~= "" and groupname ~= "None" and groupnamelist[groupname] == nil then
				table.insert(groupnamelist,groupname)
			end
		end
	end

	if aid == 0 then
		return;
	end


	local context = ui.CreateContextMenu("FRIEND_SET_GROUP_CONTEXT", "", 100, 100, 100, 100);

	--그룹 설정
	
	for k, customgroupname in pairs(groupnamelist) do
		local groupScp = string.format("FRIEND_SET_GROUPNAME('%d','%s')",tonumber(aid), customgroupname);
		ui.AddContextMenuItem(context, customgroupname, groupScp);
	end

	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);

end

function FRIEND_TAB_CHANGE_REQUEST(parent, groupbox)
    local topFrame = parent:GetTopParentFrame();
    local isFirst = true;
    if topFrame:GetUserValue('FIRST_LOAD_SUCCESS') == 'YES' then
        isFirst = false;
    end
    UPDATE_FRIEND_LIST_REQUEST(topFrame, isFirst);
end

function FRIEND_MORE_FRIEND_CLICK(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local normalTree = GET_CHILD_RECURSIVELY(topFrame, 'friendtree_normal');
    local currentCnt = normalTree:GetUserIValue('MAX_VISIBLE_INFO_COUNT');
    normalTree:SetUserValue('MAX_VISIBLE_INFO_COUNT', currentCnt + FRIEND_EXPAND_UNIT);
    UPDATE_FRIEND_LIST_COMPLETE(topFrame, false);
    DISABLE_BUTTON_DOUBLECLICK(topFrame:GetName(), ctrl:GetName(), 2);
end