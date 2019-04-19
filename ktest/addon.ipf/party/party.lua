
function PARTY_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START", "PARTY_MSG_GAMESTART");
	addon:RegisterMsg("PARTY_UPDATE", "PARTY_MSG_UPDATE");
    addon:RegisterMsg("PARTY_NAME_UPDATE", "ON_PARTY_NAME_UPDATE")
	addon:RegisterMsg("PARTY_INST_UPDATE", "ON_PARTY_INST_UPDATE");
	addon:RegisterMsg("PARTY_PROPERTY_UPDATE", "ON_PARTY_PROPERTY_UPDATE");
	addon:RegisterMsg("PARTY_PROPERTY_NOTE_UPDATE", "ON_PARTY_PROPERTY_UPDATE");
	addon:RegisterMsg("PVP_STATE_CHANGE", "PARTY_ON_PVP_STATE_CHANGE");
	addon:RegisterMsg("PARTY_OPTION_RESET", "ON_PARTY_OPTION_RESET");
	addon:RegisterMsg("PARTY_JOIN", "ON_PARTY_JOIN");	
end

function ON_PARTY_JOIN(frame)
	RESET_NAME_N_MEMO(frame)
end

function PARTY_MSG_GAMESTART(frame, msg, str, num)
	ON_PARTY_UPDATE(frame, msg, str, num);
end

function PARTY_MSG_UPDATE(frame, msg, str, num)	
	ON_PARTY_UPDATE(frame, msg, str, num);
	ON_PARTY_PROPERTY_UPDATE(frame, msg, str, num);
end

function ON_PARTY_INST_UPDATE(frame)
	
	local gbox = frame:GetChild("gbox");
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local memberlist = gbox:GetChild("memberlist");

	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);			
		if partyMemberInfo:GetMapID() > 0 then
			local partyInfoCtrlSet = memberlist:GetChild('PTINFO_'.. partyMemberInfo:GetAID());
			if partyInfoCtrlSet ~= nil then
				UPDATE_PARTY_INST_SET(partyInfoCtrlSet, partyMemberInfo);
			end
		end
	end	

	GBOX_AUTO_ALIGN(memberlist, 10, 0, 0, true, false);
	frame:Invalidate();
end

function PARTY_OPEN(frame)
	
	RESET_NAME_N_MEMO(frame)

end

function PARTY_CLOSE(frame)

end

function UI_TOGGLE_PARTY()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('party')
end

function TOGGLE_PARTY_PAT()
	ui.ToggleFrame('pet_list');
	ui.ToggleFrame('partylist');
end

function ON_PARTY_NAME_UPDATE(frame)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(memberlist, 'PTINFO_');
	end

	local partyNameText = GET_CHILD_RECURSIVELY(frame, 'partyName')
	local partyNameText_setting = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	
	if pcparty ~= nil then
		partyNameText:SetTextByKey("PartyName", pcparty.info.name)
		partyNameText_setting:SetText(pcparty.info.name)
		partyNameText:ShowWindow(1)
	end	
end

function ON_PARTY_UPDATE(frame, msg, str, num)
	local partyTab = GET_CHILD_RECURSIVELY(frame, 'itembox')
	local nowtab = partyTab:GetSelectItemIndex();

	local gbox = frame:GetChild("gbox");

	local list = session.party.GetPartyMemberList(PARTY_NORMAL);

	local memberlist = gbox:GetChild("memberlist");

	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(memberlist, 'PTINFO_');
	end

	local createPartyBtn = GET_CHILD_RECURSIVELY(frame, 'createPartyBtn', 'ui::CButton')
	local outPartyBtn = GET_CHILD_RECURSIVELY(frame, 'outPartyBtn', 'ui::CButton')
	local partyNameText = GET_CHILD_RECURSIVELY(frame, 'partyName')
	local partyNameText_setting = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	
	if pcparty ~= nil then
		local partyObj = GetIES(pcparty:GetObject());
		local GainType = "ExpGainType_" .. partyObj["ExpGainType"];
		local expGainType = GET_CHILD_RECURSIVELY(gbox, GainType, "ui::CRadioButton")
		expGainType:Select();
		partyNameText:ShowWindow(1)
	else
		partyNameText_setting:SetText("")
		partyNameText:ShowWindow(0)
		local GainType = "ExpGainType_" .. PARTY_DEFAULT_EXP_TYPE;
		local expGainType = GET_CHILD_RECURSIVELY(gbox, GainType, "ui::CRadioButton")
		expGainType:Select();

	end

	local partyinvitelink = gbox:GetChild("partyinvitelink");
	if pcparty == nil then
		local quest_gbox = GET_CHILD(gbox, "quest_gbox");
		quest_gbox:RemoveAllChild();
		createPartyBtn:ShowWindow(1)
		outPartyBtn:ShowWindow(0)
		if partyinvitelink ~= nil and nowtab == 0 then
			partyinvitelink:ShowWindow(0);
		end

		local questinfo2frame = ui.GetFrame('questinfoset_2');
		QUEST_PARTY_MEMBER_PROP_UPDATE(questinfo2frame)		

		--파티보스 소환관련해서 남아있으면 지워보자.
		session.minimap.RemoveIconInfo("PartyQuest_FieldBossRaid");

		return;
	end

	if partyinvitelink ~= nil and nowtab == 0 then
		partyinvitelink:ShowWindow(1);
	end

	local partyInfo = pcparty.info;
    local partyID = partyInfo:GetPartyID();

	local memberIndex = 0;
	local count = list:Count();
	
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		local ret = nil;
		local iconinfo = partyMemberInfo:GetIconInfo();		
		-- 접속중 파티원
		if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then
			ret = SET_PARTYINFO_ITEM(memberlist, msg, partyMemberInfo, memberIndex, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType, true, partyID);
		-- 접속안한 파티원
		else
			ret = SET_LOGOUT_PARTYINFO_ITEM(memberlist, msg, partyMemberInfo, memberIndex, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType, partyID);
		end
		if ret ~= nil then
			memberIndex = memberIndex + 1;
		end
	end

	for i = 0 , memberlist:GetChildCount() - 1 do
		local ctrlSet = memberlist:GetChildByIndex(i);
		if nil ~= ctrlSet then
			local ctrlSetName = ctrlSet:GetName();
			if string.find(ctrlSetName, "PTINFO_") ~= nil then
				local aid = string.sub(ctrlSetName, 8, string.len(ctrlSetName));
				local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, aid);
				if memberInfo == nil then
					memberlist:RemoveChildByIndex(i);
					i = i - 1;
				end
			end
		end
	end	

	if nowtab == 0 then
		if count > 0 then
			createPartyBtn:ShowWindow(0)
			outPartyBtn:ShowWindow(1)
		else
			createPartyBtn:ShowWindow(1)
			outPartyBtn:ShowWindow(0)
		end
	end

	GBOX_AUTO_ALIGN(memberlist, 10, 0, 0, true, false)
	frame:Invalidate();
	frame:ResizeByResolutionRecursively(0);

end

function CREATE_PARTY_BTN(control)

	local partyName = nil
	local partyNameCls = GetClass("DefPartyName", config.GetServiceNation());
	if partyNameCls ~= nil then
		partyName = partyNameCls.CMM_DefPartyName;
	end

	if partyName == nil then
		partyNameCls = GetClass("DefPartyName", "GLOBAL");
		partyName = partyNameCls.CMM_DefPartyName;
	end

	if partyName ~= nil then
		local partyName = dictionary.ReplaceDicIDInCompStr(partyName); 
		party.ReqPartyMake(partyName);
	end

end

function HIDE_PARTY_CREATE_BTN()
	local partyframe = ui.GetFrame('party') -- 일단 버튼을 없에고 나중에 업데이트
	local createPartyBtn = GET_CHILD_RECURSIVELY(partyframe, 'createPartyBtn', 'ui::CButton')
	createPartyBtn:ShowWindow(0)
end

function OUT_PARTY_BTN(control)
	
	OUT_PARTY()

end

function ON_PARTY_OPTION_RESET(frame, msg, argStr, argNum)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return;
	end
	local partyObj = GetIES(pcparty:GetObject());

	local curValue = partyObj[argStr];
	local gbox = frame:GetChild("gbox");	

	local curButton = GET_CHILD(gbox, argStr .. "_" .. curValue, "ui::CRadioButton");
	if nil == curButton then
		return;
	end

	curButton:Select();
	ui.SysMsg(ScpArgMsg("CannotChagePropertyThisServer"));
end

function SET_PARTY_PROPERTY_RADIO_BUTTON(gbox, partyObj, propName, maxValue, isLeader)

	for i = 0 , maxValue do
		local ctrl = gbox:GetChild(propName .. "_" .. i);
		ctrl:SetEnable(isLeader);
	end

	local curValue = partyObj[propName];
	local curButton = GET_CHILD(gbox, propName .. "_" .. curValue, "ui::CRadioButton");
	curButton:Select();
	MSG_CHANGE_RADIO(gbox, propName, curValue, curButton)
end

function MSG_CHANGE_RADIO(gbox,propName,curValue, button)
	local preValue = tonumber(gbox:GetUserValue(propName.."Pre"))
	if preValue == nil then
		gbox:SetUserValue(propName.."Pre", curValue)
		return
	end

	if preValue ~= curValue then
		if propName == "ItemRouting" then
			ui.SysMsg(ScpArgMsg("{Change}ItemRouting", "Change", button:GetText()))
		elseif propName == "ExpGainType" then
			ui.SysMsg(ScpArgMsg("{Change}ExpGainType", "Change", button:GetText()))
		elseif propName == "IsQuestShare" then
			ui.SysMsg(ScpArgMsg("{Change}IsQuestShare", "Change", button:GetText()))
		end
		gbox:SetUserValue(propName.."Pre", curValue)
	end
end

function SAVE_PARTY_NAME_AND_MEMO(parent)

	local pcparty = session.party.GetPartyInfo();
	local partyObj = GetIES(pcparty:GetObject());
	local nowPartyName = pcparty.info.name;
	local nowPartyNote = partyObj["Note"];

	local frame = parent:GetTopParentFrame();

	local partyNameText_setting = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	local partyName = partyNameText_setting:GetText()
	local partynoteText = GET_CHILD_RECURSIVELY(frame,"partynote");
	local partyNote = partynoteText:GetText()


	local badword = IsBadString(partyName);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end

	badword = IsBadString(partyNote);
	if badword ~= nil then
		--ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		--return;
	end
	
	if partyName ~= nil and nowPartyName ~= partyName then
		party.ReqPartyNameChange(PARTY_NORMAL, PARTY_STRING_NAME, partyName, session.loginInfo.GetAID());
	end

	if partyNote ~= nil and nowPartyNote ~= partyNote then
		party.ReqChangeStrProperty(PARTY_NORMAL, "Note", partyNote);
	end

	partyNameText_setting:ReleaseFocus()
	partynoteText:ReleaseFocus()
end

function RESET_NAME_N_MEMO(frame)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		local outPartyBtn = GET_CHILD_RECURSIVELY(frame, 'outPartyBtn');
		outPartyBtn:ShowWindow(0);
		return;
	end
	local partyObj = GetIES(pcparty:GetObject());
	local nowPartyName = pcparty.info.name;
	local nowPartyNote = partyObj["Note"];	
	
	local partynoteText = GET_CHILD_RECURSIVELY(frame,"partynote");
	partynoteText:SetText(nowPartyNote)
	local partyNameText_setting = GET_CHILD_RECURSIVELY(frame, 'partyname_edit')
	partyNameText_setting:SetText(nowPartyName)
	local partyNameText = GET_CHILD_RECURSIVELY(frame, 'partyName')
	partyNameText:SetTextByKey("PartyName", nowPartyName);
	
	local createPartyBtn = GET_CHILD_RECURSIVELY(frame, 'createPartyBtn');
	createPartyBtn:ShowWindow(0);
end


function ON_PARTY_PROPERTY_UPDATE(frame, msg, str, num)
	local gbox = frame:GetChild("gbox");
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		gbox:SetUserValue("ItemRoutingPre", "None")
		gbox:SetUserValue("ExpGainTypePre", "None")
		gbox:SetUserValue("IsQuestSharePre", "None")
		return;
	end
	local partyObj = GetIES(pcparty:GetObject());
	
	local isLeader = 0;
	if session.loginInfo.GetAID() == pcparty.info:GetLeaderAID() then
		isLeader = 1;
	end

	SET_PARTY_PROPERTY_RADIO_BUTTON(gbox, partyObj, "ItemRouting", 2, isLeader);
	SET_PARTY_PROPERTY_RADIO_BUTTON(gbox, partyObj, "ExpGainType", 2, isLeader);
	SET_PARTY_PROPERTY_RADIO_BUTTON(gbox, partyObj, "IsQuestShare", 1, isLeader);

	local partynote = GET_CHILD_RECURSIVELY(frame,"partynote");
	if msg == "PARTY_PROPERTY_NOTE_UPDATE" then
		partynote:SetText(str);
	end

	local savePartyNameAndMemo = GET_CHILD_RECURSIVELY(frame,"savePartyNameAndMemo")
	savePartyNameAndMemo:SetEnable(isLeader)
end

function PARTY_TAB_CHANGE(frame, ctrl, argStr, argNum)	

	local partyTab = GET_CHILD_RECURSIVELY(frame, 'itembox')
	local nowtab = partyTab:GetSelectItemIndex();

	local pcparty = session.party.GetPartyInfo();
	local createPartyBtn = GET_CHILD_RECURSIVELY(frame, 'createPartyBtn')
	local outPartyBtn = GET_CHILD_RECURSIVELY(frame, 'outPartyBtn')

	if nowtab == 0 then

		if pcparty ~= nil then
			
			createPartyBtn:ShowWindow(0)
			outPartyBtn:ShowWindow(1)
		else
			
			createPartyBtn:ShowWindow(1)
			outPartyBtn:ShowWindow(0)
		end
	else
		createPartyBtn:ShowWindow(0)
		outPartyBtn:ShowWindow(0)

	end

	RESET_NAME_N_MEMO(frame)

end

function PARTY_OPTION_ITEM(frame, ctrl, str, num)
	party.ReqChangeProperty(PARTY_NORMAL, "ItemRouting", num);
end

function PARTY_OPTION_EXP(frame, ctrl, str, num)
	party.ReqChangeProperty(PARTY_NORMAL, "ExpGainType", num);
end

function PARTY_OPTION_QUEST(frame, ctrl, str, num)
	party.ReqChangeProperty(PARTY_NORMAL, "IsQuestShare", num);
end

function UPDATE_PARTYQUEST_REMAIN_TIME(ctrlSet)

	local remainSec = ctrlSet:GetUserIValue("REMAIN_SEC");
	local startSec = ctrlSet:GetUserIValue("REMAIN_SEC_START");
	local curTime = imcTime.GetAbsoluteTime();
	local elapsedSec = curTime - startSec;
	remainSec = remainSec - elapsedSec;
	remainSec = math.floor(remainSec);
	if remainSec < 0 then
		remainSec = 0;
	end

	local autoresetSec = ctrlSet:GetUserIValue("AUTORESET_SEC");
	if autoresetSec ~= -1 then
		autoresetSec = autoresetSec - elapsedSec;
		autoresetSec = math.floor(autoresetSec);
		if autoresetSec < 0 then
			autoresetSec = 0;
		end	
	end

	local lastUpdatedSec = ctrlSet:GetUserIValue("LAST_SEC");
	local lastUpdatedAutoSec = ctrlSet:GetUserIValue("LASTAUTO_SEC");
	if lastUpdatedSec == remainSec and lastUpdatedAutoSec == autoresetSec then
		return 1;
	end
		
	ctrlSet:SetUserValue("LAST_SEC", remainSec);
	ctrlSet:SetUserValue("LASTAUTO_SEC", autoresetSec);
	local time_title = GET_CHILD(ctrlSet, "time_title");
	if remainSec == 0 and autoresetSec == -1 then
		time_title:SetTextByKey("value", ClMsg("NowQuestIsAble"));
		time_title:SetTextByKey("time", "");
	else
		local timeString = GET_DHMS_STRING(remainSec);
		time_title:SetTextByKey("time", timeString);
	end

	local waitTime = ctrlSet:GetUserIValue("TOTAL_SEC");
	local gauge = GET_CHILD(ctrlSet, "gauge");
	gauge:SetPoint(waitTime - remainSec, waitTime);
	
	if autoresetSec ~= -1 then
		local autoResetString = GET_DHMS_STRING(autoresetSec);

		local title = GET_CHILD(ctrlSet, "title");
		local playerCnt = ctrlSet:GetUserIValue("PLAYER_CNT");
		local count = session.party.GetAlivePartyMemberList();
		local countStr = string.format("(%d/%d)", count, playerCnt);
		local str = string.format(" : %s - %s", ClMsg("NotEnoughPartyMember"), countStr);
		title:SetTextByKey("state", str .. " " .. ClMsg("ReconnectionReadyTime") .. " : " .. autoResetString);
		
	else
		if remainSec == 0 then
			if ctrlSet:GetUserValue("IS_ACCEPTED") ~= "YES" then
				session.bindFunc.AddPushMsg("PartyQuest", ClMsg("PartyQuestIsAbleToStart"), "OPEN_PARTY_QUEST_UI", 5);
				ctrlSet:GetChild("btn_start"):SetEnable(1);
			end
		end		
	end

	return 1;
end

function OPEN_PARTY_QUEST_UI(msgInfo)

	local frame = ui.GetFrame("party");
	frame:ShowWindow(1);
	local gbox = frame:GetChild("gbox");
	local itembox = GET_CHILD(gbox, "itembox");
	local tabIndex = itembox:GetIndexByName("quest");
	itembox:SelectTab(tabIndex);
		

end

function PARTY_QUEST_WAITING_START()
	session.bindFunc.AddPushMsg("PartyQuestWaitingStart", ClMsg("PartyQuestMemberSatisfied_QuestWillBeEnabledAfterAWhile"), "OPEN_PARTY_QUEST_UI", 10);
end

function SHOW_PARTY_QUEST_MAP_UI(ctrl)
	
	local clsName = ctrl:GetUserValue("CLSNAME");
	local pcparty = session.party.GetPartyInfo();
	local locInfo = geClientPartyQuest.GetPartyQuestLocaionInfo(pcparty, clsName);
	local pos = geClientPartyQuest.GetLocInfoPos(locInfo);

	local mapprop = session.GetCurrentMapProp();
	if locInfo.mapID == mapprop.type then
		ui.OpenFrame("map");
		return;
	end
	local mapCls = GetClassByType("Map", locInfo.mapID);
	SCR_SHOW_LOCAL_MAP(mapCls.ClassName, true, pos.x, pos.z);
	
end

function DELETE_PARTY_EVENT(parent, ctrl)
	local clsName = parent:GetUserValue("CLSNAME");

	local yesScp = string.format("DELETE_PARTY_EVENT_YES(\"%s\")", clsName);
	ui.MsgBox(ScpArgMsg("IfYouCancel_TicketIsLost_Continue?"), yesScp, "None");

end

function LINK_PARTY_INVITE(parent, ctrl)

	local myPartyInfo = session.party.GetPartyInfo();	
	if myPartyInfo == nil then
		ui.SysMsg(ClMsg("NotBelongsToParty"));
		return;
	end

	local partyID = myPartyInfo.info:GetPartyID();	
	local linkstr = string.format("{a SLP %s}{#0000FF}{img link_party 24 24}%s{/}{/}{/}", partyID, myPartyInfo.info.name);
	SET_LINK_TEXT(linkstr);

	local partyObj = GetIES(myPartyInfo:GetObject());	
	if partyObj.AllowLinkJoin == 0 then
		party.ReqChangeProperty(PARTY_NORMAL, "AllowLinkJoin", 1);
	end

end

function PARTY_ON_PVP_STATE_CHANGE(frame, msg, pvpType)

	local gbox = frame:GetChild("gbox");
	local quest_gbox = GET_CHILD(gbox, "quest_gbox");
	DESTROY_CHILD_BY_USERVALUE(quest_gbox, "PVP_CTRL", "YES");
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_NONE then
		return;
	end

	local cls = GetClassByType("WorldPVPType", pvpType);
	if cls.Party == 0 then
		return;
	end

	local pcparty = session.party.GetPartyInfo();
	local partyObj = GetIES(pcparty:GetObject());
	local ctrlSet = quest_gbox:CreateOrGetControlSet("party_ticket", "QUEST", ui.LEFT, ui.TOP, 0, 0, 0, 0);
	ctrlSet:SetUserValue("PVP_CTRL", "YES");

	local questCls = GetClass("PartyQuest", "BattleField");
	local desc = GET_CHILD(ctrlSet, "desc");
	desc:SetTextByKey("value", questCls.Desc);
	local title = GET_CHILD(ctrlSet, "title");
	title:SetTextByKey("value", questCls.Name);

	local stateText = GetPVPStateText(state);
	local viewText = ClMsg( "PVP_State_".. stateText );
	local btn_start = GET_CHILD(ctrlSet, "btn_start");
	btn_start:SetTextByKey("value", viewText);
	btn_start:SetTooltipType("None");
	btn_start:SetEventScript(ui.LBUTTONDOWN, "PARTY_CANCEL_PVP_JOIN");
	btn_start:SetUserValue("PVPTYPE", pvpType);

	GBOX_AUTO_ALIGN(quest_gbox, 20, 3, 10, true, false);


end

function PARTY_CANCEL_PVP_JOIN(parent, ctrl)

	local pvpType = ctrl:GetUserIValue("PVPTYPE");
	local yesScp = string.format("EXEC_PARTY_CANCEL_PVP_JOIN(%d)", pvpType);
	ui.MsgBox(ScpArgMsg("IfYouCancelGame_TicketIsLost_Continue?"), yesScp, "None");

end

function EXEC_PARTY_CANCEL_PVP_JOIN(pvpType)
	worldPVP.ReqJoinPVP(pvpType, PVP_STATE_NONE);
end

