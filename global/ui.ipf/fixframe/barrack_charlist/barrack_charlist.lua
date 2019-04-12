-- barrack_charlist.lua

function BARRACK_CHARLIST_ON_INIT(addon, frame)
	addon:RegisterMsg("BARRACK_ADDCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_CREATECHARACTER_BTN", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_DELETECHARACTER", "SELECTCHARINFO_DELETE_CTRL");
	addon:RegisterMsg("BARRACK_SELECTCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_SELECT_BTN", "SELECTTEAM_ON_MSG");
	
	addon:RegisterMsg("BARRACK_NAME", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("SET_BARRACK_MODE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("UPDATE_SELECT_BTN_TITLE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("NOT_HANDLED_ENTER", "SELECTTEAM_OPEN_CHAT");
	
	addon:RegisterMsg("BARRACK_NAME_CHANGE_RESULT", "SELECTTEAM_ON_MSG");


	frame:SetUserValue("BarrackMode", "Barrack");
	SET_CHILD_USER_VALUE(frame, "upgrade", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "setting", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "delete_character", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "deleteall_character", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "start_game", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "barrackname", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "barrackVisit", "Barrack", "YES");

	SET_CHILD_USER_VALUE(frame, "barrackname", "Visit", "YES");
	SET_CHILD_USER_VALUE(frame, "returnHome", "Visit", "YES");

	SET_CHILD_USER_VALUE(frame, "end_preview", "Preview", "YES");
	SET_CHILD_USER_VALUE(frame, "upgrade", "Preview", "YES");

	SET_CHILD_USER_VALUE(frame, "barrackname", "Visit_Normal", "YES");
	SET_CHILD_USER_VALUE(frame, "returnHome", "Visit_Normal", "YES");
	SET_CHILD_USER_VALUE(frame, "goto_normalgame", "Visit_Normal", "YES");


	CHAR_LIST_CLOSE_HEIGHT = 105;
	CHAR_LIST_OPEN_HEIGHT = 420;
	CUR_SELECT_GUID = 'None';	
end

function INIT_BARRACK_NAME(frame)
	local charlist = ui.GetFrame("barrack_charlist");
	local pccount = charlist:GetChild("pccount");
	pccount:ShowWindow(1);
	pccount:SetTextByKey("curpc", '0');
	pccount:SetTextByKey("maxpc", '4');
	local myaccount = session.barrack.GetMyAccount();
	if nil == myaccount then
		return;
	end

	local myCharCont = myaccount:GetPCCount() + myaccount:GetPetCount();
	local buySlot = session.loginInfo.GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	pccount:SetTextByKey("maxpc", tostring(barrackCls.BaseSlot + buySlot));

	local accountObj = GetMyAccountObj();
	local richtext = frame:GetChild("free");
	richtext:SetTextByKey("value", accountObj.Medal);
	richtext = frame:GetChild("event");
	richtext:SetTextByKey("value", accountObj.GiftMedal);
	richtext = frame:GetChild("tp");
	richtext:SetTextByKey("value", accountObj.PremiumMedal);
	CHAR_N_PET_LIST_LOCKMANGED(1);
end

function SET_CHILD_USER_VALUE(frame, childName, name, value)
	local ctrl = frame:GetChild(childName);
	if ctrl ~= nil then
		ctrl:SetUserValue(name, value);
		ctrl:SetUserValue("ModeCtrl", "YES");
	end
end

function SELECTTEAM_NEW_CTRL(frame, actor)
	local account = session.barrack.GetCurrentAccount();
	local myaccount = session.barrack.GetMyAccount();
	local barrackMode = frame:GetUserValue("BarrackMode");

	if "Visit" == barrackMode 
		and account == myaccount then
		local scrollBox = frame:GetChild("scrollBox");
		scrollBox:RemoveAllChild();
		return;
	end

	local barrackName = ui.GetFrame("barrack_name");
	local teamlevel = barrackName:GetChild("teamlevel");
	teamlevel:SetTextByKey("value", account:GetTeamLevel());
	local buySlot = session.loginInfo.GetBuySlotCount();
	local myCharCont = myaccount:GetPCCount() + myaccount:GetPetCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());

	local pccount = frame:GetChild("pccount");
	pccount:ShowWindow(1);
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	pccount:SetTextByKey("maxpc", tostring(barrackCls.BaseSlot + buySlot));

	local accountObj = GetMyAccountObj();
	local richtext = barrackName:GetChild("free");
	richtext:SetTextByKey("value", accountObj.Medal);
	richtext = barrackName:GetChild("event");
	richtext:SetTextByKey("value", accountObj.GiftMedal);
	richtext = barrackName:GetChild("tp");
	richtext:SetTextByKey("value", accountObj.PremiumMedal);

	if actor ~= nil then
		CREATE_SCROLL_CHAR_LIST(frame, actor);
	end
	

end

function CREATE_SCROLL_CHAR_LIST(frame, actor)
	local barrackMode = frame:GetUserValue("BarrackMode");
	local name = actor:GetName();
	local brk = GetBarrackSystem(actor);
	local key = brk:GetCID();
	local bpc = barrack.GetBarrackPCInfoByCID(key);
	if bpc == nil then
		return;
	end

	local scrollBox = frame:GetChild("scrollBox");
	local charCtrl = scrollBox:CreateOrGetControlSet('barrack_charlist', 'char_'..key, 10, 0);
	charCtrl:SetUserValue("CID", key);
	local mainBox = GET_CHILD(charCtrl,'mainBox','ui::CGroupBox');
	local btn = mainBox:GetChild("btn");
	btn:SetSkinName('character_off');

	btn:SetSValue(name);
	btn:SetOverSound('button_over');
	btn:SetClickSound('button_click_2');
	btn:SetEventScript(ui.LBUTTONUP, "SELECT_CHARBTN_LBTNUP");
	btn:SetEventScriptArgString(ui.LBUTTONUP, key);

	if session.barrack.GetMyAccount():GetByStrCID(key) ~= nil 
		and "Barrack" == barrackMode then
			btn:SetEventScript(ui.LBUTTONDBLCLICK, "BARRACK_TO_GAME");
			btn:SetEventScriptArgString(ui.LBUTTONDBLCLICK, key);
	end
		
	btn:ShowWindow(1);
	btn:SetUserValue("MY_CTRL", "YES");

	local apc = bpc:GetApc();

	local gender					= apc:GetGender();
	local jobid						= apc:GetJob();
	local pic = GET_CHILD(mainBox, "char_icon", "ui::CPicture");
	local headIconName = ui.CaptureModelHeadImageByApperance(apc);
	pic:SetImage(headIconName);

	local delCtrl = GET_CHILD(mainBox, "delete_btn", "ui::CButton");
	delCtrl:SetImage('button_C_delete');
	if myaccount ==  myaccount and barrackMode == "Barrack" then
		delCtrl:SetEventScript(ui.LBUTTONUP, "DELETE_CHAR_SCROLL");
		delCtrl:SetEventScriptArgString(ui.LBUTTONUP, key);
	end
	delCtrl:ShowWindow(0);

	local nameCtrl = GET_CHILD(mainBox, "name", "ui::CRichText");
	nameCtrl:SetText("{@st42b}{b}".. name);
	local jobCls = GetClassByType("Job", jobid);
	local jobName 					= jobCls.Name;
	local jobCtrl = GET_CHILD(mainBox, "job", "ui::CRichText");
	jobCtrl:SetText("{@st42b}".. jobName);
	local levelCtrl = GET_CHILD(mainBox, "level", "ui::CRichText");
	levelCtrl:SetText("{@st42b}Lv.".. actor:GetLv());

	local detail = GET_CHILD(charCtrl,'detailBox','ui::CGroupBox');
	local mapNameCtrl				= GET_CHILD(detail,'mapName','ui::CRichText');	
	local mapCls = GetClassByType("Map", apc.mapID);
	local mapName 					= mapCls.Name;
	mapNameCtrl:SetText("{@st66b}".. mapName);
	
	local isDraw = 0;
	for i = 0 , item.GetEquipSpotCount() - 1 do
		local eqpObj = bpc:GetEquipObj(i);
		local esName = item.GetEquipSpotName(i);
		
		local eqpSlot = GET_CHILD(detail, esName, "ui::CSlot");
		if eqpSlot ~= nil then
			eqpSlot:EnableDrag(0);
			if eqpObj == nil then
				CLEAR_SLOT_ITEM_INFO(eqpSlot);
			else
				local obj = GetIES(eqpObj);
				local refreshScp = obj.RefreshScp;
				if refreshScp ~= "None" then
					refreshScp = _G[refreshScp];
					refreshScp(obj);
				end	

				if 0 == item.IsNoneItem(obj.ClassID) then
					SET_SLOT_ITEM_OBJ(eqpSlot, obj, gender, 1);
					if obj.ItemType == 'Equip' and obj.DBLHand == 'YES' then
						local LhSlot = GET_CHILD(detail, 'LH', "ui::CSlot");
						if nil ~= LhSlot then
							LhSlot:EnableDrag(0);
							SET_SLOT_ITEM_OBJ(LhSlot, obj, gender, 1);
							isDraw = 1;
						end
					end
				else
					if 'LH' == esName and 1 == isDraw then
					else
						CLEAR_SLOT_ITEM_INFO(eqpSlot);
					end
				end
			end
		end
	end

	detail:ShowWindow(0);
	charCtrl:Resize(charCtrl:GetWidth(), CHAR_LIST_CLOSE_HEIGHT);

	if barrackMode == "Barrack" then
		CREATE_SCROLL_NEW_CHAR(frame);
--
	end

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);

end

function CREATE_SCROLL_NEW_CHAR(frame)

	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveChild('char_add');

	local charCtrl = scrollBox:CreateOrGetControlSet('barrack_newchar', 'char_add', 10, 0);
	charCtrl = tolua.cast(charCtrl, "ui::CControlSet");
	local btn = charCtrl:GetChild("btn");
	btn:SetOverSound('button_over');
	btn:SetClickSound('button_click_2');
	btn:SetEventScript(ui.LBUTTONUP, "BARRACK_GO_CREATE");
	btn:ShowWindow(1);
	btn:SetUserValue("MY_CTRL", "YES");
	local text = charCtrl:GetChild("text");
	text:SetText("{@st42b}{b}" .. ClMsg("CreateNewCharacter"));

	if argStr == 'Hide' then
		charCtrl:Resize(charCtrl:GetWidth(), 1);
	else
		charCtrl:Resize(charCtrl:GetWidth(), CHAR_LIST_CLOSE_HEIGHT);
	end

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);
end

function UPDATE_SELECT_CHAR_SCROLL(frame)
	local acc = session.barrack.GetMyAccount();

	local scrollBox = frame:GetChild("scrollBox");
	for i=0, scrollBox:GetChildCount()-1 do
		local child = scrollBox:GetChildByIndex(i);
		if string.find(child:GetName(), 'char_') ~= nil then		
			local guid = child:GetUserValue("CID");
			if CUR_SELECT_GUID == guid then
				child:Resize(child:GetWidth(), CHAR_LIST_OPEN_HEIGHT);
				local detail = GET_CHILD(child,'detailBox','ui::CGroupBox');
				detail:ShowWindow(1);
				local mainBox = GET_CHILD(child,'mainBox','ui::CGroupBox');
				local btn = mainBox:GetChild("btn");
				btn:SetSkinName('character_on');
				local delCtrl = GET_CHILD(mainBox, "delete_btn", "ui::CButton");
				delCtrl:ShowWindow(1);
			elseif child:GetName() ~= 'char_add' then
				child:Resize(child:GetWidth(), CHAR_LIST_CLOSE_HEIGHT);
				local detail = GET_CHILD(child,'detailBox','ui::CGroupBox');
				detail:ShowWindow(0);
				local mainBox = GET_CHILD(child,'mainBox','ui::CGroupBox');
				local btn = mainBox:GetChild("btn");
				btn:SetSkinName('character_off');
				local delCtrl = GET_CHILD(mainBox, "delete_btn", "ui::CButton");
				delCtrl:ShowWindow(0);
			end
		end
	end
	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);
end

function SELECT_CHARBTN_LBTNUP(parent, ctrl, cid, argNum)

	local pcPCInfo = session.barrack.GetMyAccount():GetByStrCID(cid);
	if pcPCInfo == nil then
		return;
	end

	local lbtnupScp = barrack.GetLBtnDownScript();
	if lbtnupScp == "COMPANION_SELECT_PC" then
		barrack.SetLBtnDownScript("None");
		local selActor = barrack.GetPCByID(cid);
		COMPANION_SELECT_PC(selActor);
		return;
	end
	
	local mainBox = parent:GetParent();
	barrack.SelectCharacterByCID(cid);
	CUR_SELECT_GUID = cid;

	local parentFrame = mainBox:GetTopParentFrame();
	UPDATE_SELECT_CHAR_SCROLL(parentFrame);
	UPDATE_PET_BTN_SELECTED();
end

function DELETE_CHAR_SCROLL(ctrl, btn, cid, argNum)

	-- 스크롤 캐릭터 삭제 버튼
	local acc = session.barrack.GetMyAccount();
	local petVec = acc:GetPetVec();

	if petVec:size() ~= 0 then
		for i = 0 , petVec:size() -  1 do
			local pet = petVec:at(i);
			local pcID = pet:GetPCID()
			if pcID == cid then
				ui.SysMsg(ScpArgMsg("BeTogetherWithCompanionReallyDelete"));
				return
			end
		end
	end

	local bpc = barrack.GetBarrackPCInfoByCID(cid);
	if bpc == nil then
		return;
	end

	if 0 < bpc:GetDummyPCZoneID() then 
		ui.MsgBox(ScpArgMsg("CanDelChrBecauseDummyPC"));
		return;
	end

	if IsFinalRelease() == true then
		local isHaveEquipItem = 0		
		for i = 0 , item.GetEquipSpotCount() - 1 do
			local eqpObj = bpc:GetEquipObj(i);
			if eqpObj ~= nil then
				local obj = GetIES(eqpObj);			
				if 0 == item.IsNoneItem(obj.ClassID) then
					--착용중인 아이템이 있음	
					isHaveEquipItem = 1;
					break;
				end
			end	
		end
		

		if isHaveEquipItem == 1 then
			ui.MsgBox(ScpArgMsg("CantDelCharBecauseHaveEquipItem"));
			return;
		end
	end

	
	
	barrack.SelectCharacterByCID(cid);
	local jobName = barrack.GetSelectedCharacterJob();
	local charName = barrack.GetSelectedCharacterName();
	ui.MsgBox("{nl} {nl}{s22}"..jobName.." {@st43}"..charName..ScpArgMsg("Auto_{/}{nl}{s22}KaeLigTeoLeul_SagJeHaKessSeupNiKka?"), 'SELECTCHARINFO_DELETECHARACTER', 'SELECTCHARINFO_DELETECHARACTER_CANCEL');
end

function SELECTCHARINFO_DELETECHARACTER(frame, obj, argStr, argNum)
	imcSound.PlaySoundEvent('button_click_big_2');
	barrack.DeleteCharacter();
	ui.GetFrame('selectcharmenu'):ShowWindow(0);
end

function SELECTCHARINFO_DELETECHARACTER_CANCEL(frame, obj, argStr, argNum)
	imcSound.PlaySoundEvent('button_click_big');
end

function SELECTTEAM_UPDATE_BTN_TITLE(frame)
	DESTROY_CHILD_BYNAME(frame, 'PET_ICON');

	local acc = session.barrack.GetMyAccount();
	local petVec = acc:GetPetVec();
	if petVec:size() == 0 then
		return;
	end

	for i = 0 , petVec:size() -  1 do
		local pet = petVec:at(i);
		local pcID = pet:GetPCID()
		local pcActor = barrack.GetPCByID(pcID);
		if pcActor ~= nil then
			local brk = GetBarrackSystem(pcActor);
			local btn = frame:GetChild("btn_" .. brk:GetCID());
			if btn ~= nil then
				local x = btn:GetX();
				local y  = btn:GetY();
				local pic = frame:CreateControl("picture", "PET_ICON_" ..pet:GetStrGuid(), x + btn:GetWidth() + 25, y + 3, 64, 64);
				pic = tolua.cast(pic, "ui::CPicture");
				pic:SetEnableStretch(1);

				local monCls = GetClassByType("Monster", pet:GetPetType());
				pic:SetImage(monCls.Icon);

				local tooltipText = "{@st42}" .. ScpArgMsg("BeTogetherWithCompanion[{Name}]", "Name", pet:GetName());
				pic:SetTextTooltip(tooltipText);
			end

		end
	end
	
end

function SELECTTEAM_ON_MSG(frame, msg, argStr, argNum, ud)

	if msg == "BARRACK_ADDCHARACTER" then
		SELECTTEAM_NEW_CTRL(frame, ud);

	elseif msg == "BARRACK_NEWCHARACTER" then
		SELECTTEAM_NEW_CTRL(frame, ud);

	elseif msg == "BARRACK_SELECT_BTN" then
		local argStr = frame:GetUserValue("BarrackMode");
		if argStr ~= "Barrack" then
			return;
		end

		local account = session.barrack.GetMyAccount();
		local bpc = account:GetBySlot(argNum);
		local gameStartFrame = ui.GetFrame('barrack_gamestart')
		if argNum == 0 or bpc == nil then
			gameStartFrame:ShowWindow(0);
		else
			START_GAME_SET_MAP(gameStartFrame, argNum, bpc:GetApc().mapID, bpc:GetApc().channelID);
			gameStartFrame:ShowWindow(1);
		end
		
	elseif msg == "BARRACK_CREATECHARACTER_BTN" then
		CREATE_SCROLL_NEW_CHAR(frame);

	elseif msg == "BARRACK_SELECTCHARACTER" then
		ON_CLOSE_BARRACK_SELECT_MONSTER();
		CUR_SELECT_GUID = argStr;
		UPDATE_SELECT_CHAR_SCROLL(frame);
		UPDATE_PET_BTN_SELECTED();
		SELCOMPANIONINFO_ON_SELECT_CHAR(argStr);
	elseif msg == "BARRACK_NAME" then
		local barrack_name_frame = ui.GetFrame('barrack_name')
		local nameCtrl = GET_CHILD(barrack_name_frame, "barrackname");
		nameCtrl:SetText("{@st43}{#ffcc33}"..argStr..ScpArgMsg("BarrackNameMsg").."{/}");

	elseif msg == "SET_BARRACK_MODE" then
		SET_BARRACK_MODE(frame, argStr);

	elseif msg == "UPDATE_SELECT_BTN_TITLE" then
		SELECTTEAM_UPDATE_BTN_TITLE(frame);	
	elseif msg == "BARRACK_NAME_CHANGE_RESULT" then
		
		-- tp표시갱신
		SELECTTEAM_NEW_CTRL(frame, ud);
		BARRACK_THEMA_UPDATE(ui.GetFrame("barrackthema"))
	end

	SELECTCHAR_RE_ALIGN(frame);
	--frame:Invalidate();
	
end

function BARRACK_GO_CREATE()
	barrack.GoCreate();
	ui.CloseFrame("inputstring");
	ui.CloseFrame("barrackthema");
end

function SELECT_COMPANION_BTNUP(parent, ctrl, argStr, argNum, selectBarrackChar)
	
	local btn = parent:GetChild("btn");
	local mainBox = parent:GetParent();

	local petID = mainBox:GetUserValue("PET_ID");
	CUR_SELECT_PET_ID = petID;
	if selectBarrackChar ~= 0 then	
		barrack.SelectPetByGuid(petID);
	end

end

function SELECTCHAR_RE_ALIGN(frame)
	local btnCtn = 0;
	local height = 70;
	for i=0, frame:GetChildCount()-1 do
		local child = frame:GetChildByIndex(i);
		if child ~= nil then
			if string.find(child:GetName(), 'btn_') ~= nil then
				local xPos = 10;
				local yPos = (btnCtn * (height+4)) + 30;
				child:SetOffset(xPos, yPos);
				btnCtn = btnCtn + 1;
				child:ShowWindow(1);
			end
		end
	end
end

function SELECTCHARINFO_DELETE_CTRL(frame, obj, argStr, argNum)
	local parentFrame = frame:GetTopParentFrame();
	local scrollBox = parentFrame:GetChild("scrollBox");
	local deleteCtrl = scrollBox:GetChild('char_'..argStr);
	if deleteCtrl ~= nil then
		scrollBox:RemoveChild('char_'..argStr);
	end
	UPDATE_SELECT_CHAR_SCROLL(parentFrame);
	UPDATE_PET_BTN_SELECTED();
	frame:Invalidate();

	local myaccount = session.barrack.GetMyAccount();
	local barrackName = ui.GetFrame("barrack_charlist");
	local pccount = barrackName:GetChild("pccount");
	pccount:ShowWindow(1);
	local buySlot = session.loginInfo.GetBuySlotCount();
	local myCharCont = myaccount:GetPCCount() + myaccount:GetPetCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	pccount:SetTextByKey("maxpc", tostring(barrackCls.BaseSlot + buySlot));

	local barrackName = ui.GetFrame("barrack_name");
	local teamlevel = barrackName:GetChild("teamlevel");
	local account = session.barrack.GetCurrentAccount();
	teamlevel:SetTextByKey("value", account:GetTeamLevel());
end


function SELECTTEAM_OPEN_BARRACK_SETTING(frame, btnCtrl, argStr, argNum)

	if frame == nil then
		frame = ui.GetFrame("barrack_name");
		btnCtrl = frame:GetChild("setting");
	end

	local newframe = ui.GetFrame("inputstring");
	newframe:SetUserValue("InputType", "Family_Name");
	
	local acc = session.barrack.GetMyAccount();
	INPUT_STRING_BOX(ClMsg("Family Name"), "BARRACK_SETTING_SAVE", acc:GetFamilyName(), 0, 16);
end

function BARRACK_VISIT_MSGBOX(frame)

	INPUT_STRING_BOX_CB(frame, ScpArgMsg("Auto_aiDiLeul_ipLyeogHaSeyo"), "EXEC_VISIT_BARRACK");

end

function EXEC_VISIT_BARRACK(frame, str)
	if str == "" then
		return;
	end
	barrackVisit.Visit(str);
end

function EXEC_GO_HOME_BARRACK(frame, btnCtrl, argStr, argNum)

	barrackVisit.GoHome();

end

function SELECTTEAM_OPEN_CHAT(frame)

	local frame = ui.GetFrame("barracksimplechat");
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
		BARRACK_CHAT_ACQUIRE_FOCUS(frame, 0.1);
	end
end

function UPDATE_BARRACK_MODE(frame)

	local argStr = frame:GetUserValue("BarrackMode");

	SHOW_CHILD_BY_USERVALUE(frame, "ModeCtrl", "YES", 0);
	SHOW_CHILD_BY_USERVALUE(frame, argStr, "YES", 1);
	if argStr == "Barrack" then
		SELECTCHAR_RE_ALIGN(frame);

	elseif argStr == "Visit" then
		-- 다른 숙소 방문할땐 캐릭생성관련 버튼은 숨긴다.
		SHOW_CHILD_BY_USERVALUE(frame, "MY_CTRL", "YES", 0);
		SHOW_CHILD_BY_USERVALUE(frame, "Barrack", "YES", 0);
		local barrack_nameUI = ui.GetFrame("barrack_name");
		barrack_nameUI:ShowWindow(0);

		local pccount = frame:GetChild("pccount");
		pccount:ShowWindow(0);

		local barrack_exit = ui.GetFrame("barrack_exit");
		local postbox = barrack_exit:GetChild("postbox");
		if nil == postbox then
			return;
		end

		local postbox_new = GET_CHILD(barrack_exit, "postbox_new");
		postbox:ShowWindow(0);
		postbox_new:ShowWindow(0);
	end
end

function SET_BARRACK_MODE(frame, argStr)

	frame:SetUserValue("BarrackMode", argStr);
	UPDATE_BARRACK_MODE(frame);
	if argStr == "Preview" then
		ui.OpenFrame("barrackthema");
	end

	local scrollBox = frame:GetChild("scrollBox");
	if argStr == "Barrack" then
		CREATE_SCROLL_NEW_CHAR(frame);
	else
		scrollBox:RemoveChild('char_add');
	end

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);

	frame:Invalidate();

	local gameStartUI = ui.GetFrame("barrack_gamestart");
	local start_game = GET_CHILD(gameStartUI, "start_game");	
	
	local create_info = gameStartUI:GetChild("create_info");
	local zone = gameStartUI:GetChild("zone");
	local channels = gameStartUI:GetChild("channels"); 

	if argStr == "Barrack" then
		start_game:SetTextByKey("value", ClMsg("StartGame"));
		create_info:ShowWindow(1);
		zone:ShowWindow(1);
		channels:ShowWindow(1);
	else
		start_game:SetTextByKey("value", ClMsg("Return"));
		create_info:ShowWindow(0);
		zone:ShowWindow(0);
		channels:ShowWindow(0);
	end
	
	
end

function START_GAME_SET_MAP(frame, slotID, mapID, channelID)

	local zone = frame:GetChild("zone");
	local channels = GET_CHILD(frame, "channels", "ui::CDropList");
	local mapCls = GetClassByType("Map", mapID);
	zone:SetTextByKey("value", mapCls.Name);
	frame:SetUserValue("SLOT_ID", slotID);

	local zoneInsts = session.serverState.GetMap(mapID);
	if zoneInsts == nil then
		-- RequestMapState();
	else
	
		channels:ClearItems();
		
		local cnt = zoneInsts:GetZoneInstCount();
		for i = 0  , cnt - 1 do
			local zoneInst = zoneInsts:GetZoneInstByIndex(i);
			local str, gaugeString = GET_CHANNEL_STRING(zoneInst);
			channels:AddItem(zoneInst.channel, str, 0, nil, gaugeString);
		end

		channels:SelectItemByKey(channelID);
	end

end

function SELECT_GAMESTART_CHANNEL(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local channels = GET_CHILD(frame, "channels", "ui::CDropList");

	local slotID = frame:GetUserIValue("SLOT_ID");
	local acc = session.barrack.GetMyAccount();
	local pc = acc:GetBySlot(slotID);

	local key = channels:GetSelItemKey();
	pc:GetApc():SetChannelID(key);

end

function BARRACK_TO_GAME()
	
	local bpc = barrack.GetGameStartAccount();
	local apc = bpc:GetApc();

	local jobid	= apc:GetJob();
	local level = apc:GetLv();
	
	local JobCtrlType = GetClassString('Job', jobid, 'CtrlType');

	config.SetConfig("LastJobCtrltype", JobCtrlType);
	config.SetConfig("LastPCLevel", level);

	local frame = ui.GetFrame("barrack_gamestart")
	local channels = GET_CHILD(frame, "channels", "ui::CDropList");
	local key = channels:GetSelItemIndex();
	app.BarrackToGame(key);
	
end

function UPDATE_BARRACK_PET_BTN_LIST()
	
	local account = session.barrack.GetCurrentAccount();
	local petVec = account:GetPetVec();

	local frame = ui.GetFrame("barrack_charlist");
	local scrollBox = frame:GetChild("scrollBox");

	for i = 0 , scrollBox:GetChildCount() -1 do
		local charCtrl = scrollBox:GetChildByIndex(i);
		DESTROY_CHILD_BYNAME(charCtrl, "attached_pet_");
		charCtrl:SetUserValue("PET_COUNT", 0);
	end	
	
	local offsetX = 120;
	for i = 0 , petVec:size() - 1 do
		local pet = petVec:at(i);
		local pcID = pet:GetPCID();
		local bpc = account:GetByStrCID(pcID);
		if bpc ~= nil then
			local charCtrl = scrollBox:GetChild("char_" .. pcID);
			if charCtrl ~= nil then
				
				local bpcPetCount = charCtrl:GetUserValue("PET_COUNT");
				local posX = 400 + bpcPetCount * offsetX;
				charCtrl:SetUserValue("PET_COUNT", bpcPetCount + 1);
				local petCtrl = charCtrl:CreateOrGetControlSet('barrack_pet_mini', 'attached_pet_'..pet:GetStrGuid(), posX, 0);
				UPDATE_PET_BTN(petCtrl, pet, true);
			end
		end
	end
	UPDATE_PET_LIST()	
end

function UPDATE_PET_BTN_SELECTED()
	
	local frame = ui.GetFrame("barrack_petlist");
	local bg = frame:GetChild("bg");
	for i = 0 , bg:GetChildCount() - 1 do
		local petCtrl = bg:GetChildByIndex(i);
		local mainBox = GET_CHILD(petCtrl,'mainBox','ui::CGroupBox');
		if mainBox ~= nil then
			local btn = mainBox:GetChild("btn");
			local petID = petCtrl:GetUserValue("PET_ID");
			if petID == CUR_SELECT_GUID then
				btn:SetSkinName('companion_on');
			else
				btn:SetSkinName('companion_off');
			end		
		end

	end
end

function UPDATE_PET_BTN(petCtrl, petInfo, useDetachBtn)

	local account = session.barrack.GetCurrentAccount();
	local myaccount = session.barrack.GetMyAccount();

	local mainBox = GET_CHILD(petCtrl,'mainBox','ui::CGroupBox');
	
	local obj = GetIES(petInfo:GetObject());
	local name = mainBox:GetChild("name");
	name:SetTextByKey("value", petInfo:GetName());
	local level = mainBox:GetChild("level");
	level:SetTextByKey("value", obj.Lv);
	mainBox:SetUserValue("PET_ID", petInfo:GetStrGuid());
	petCtrl:SetUserValue("PET_ID", petInfo:GetStrGuid());
	
	local char_icon = GET_CHILD(mainBox, "char_icon", "ui::CPicture");
	--char_icon:SetImage(obj.Icon);


	local revive_btn = GET_CHILD(mainBox, "revive_btn", "ui::CButton");
	if revive_btn ~= nil then
		revive_btn:ShowWindow(0);
	end

	if useDetachBtn == false  then
		
		char_icon:SetImage(obj.Icon);
		local btn = mainBox:GetChild("btn");
		btn:SetEventScript(ui.LBUTTONUP, "SELECT_COMPANION_BTNUP");
		btn:SetSkinName('companion_on');
	
		local job = mainBox:GetChild("job");
		job:SetTextByKey("value", obj.Name);

		local detach_btn = GET_CHILD(mainBox, "detach_btn", "ui::CButton");
		if account ~= myaccount then
			detach_btn:ShowWindow(0);
			return;
		end

			detach_btn:SetImage('button_C_delete');
			detach_btn:SetEventScript(ui.LBUTTONUP, "REQUEST_DELETE_PET");
			if obj.OverDate == 10 then
				if revive_btn ~= nil then
					revive_btn:ShowWindow(1);
					revive_btn:SetEventScript(ui.LBUTTONUP, "REQUEST_PET_REVIVE");
				end
			end
		
		
	elseif useDetachBtn == true then


		local moncls = GetClass("Monster", obj.ClassName);

		local iconName = 'test_companion_01';
		
		if moncls ~= nil then
			iconName =	moncls.IconImage
		end

		char_icon:SetImage(iconName);
		
		local detach_btn = GET_CHILD(mainBox, "detach_btn", "ui::CButton");
		if account ~= myaccount then
			detach_btn:ShowWindow(0);
			return;
		end
		
		detach_btn:SetImage('button_cc_delete');
		detach_btn:SetEventScript(ui.LBUTTONUP, "DETACH_PET_FROM_PC");		
	end	
end

function DETACH_PET_FROM_PC(parent, ctrl)

	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");

	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);
	brkSystem:SetPetPC(nil);
	
end

function REQUEST_PET_REVIVE(parent, ctrl)

	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");
	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);
	local petInfo = brkSystem:GetPetInfo();
	local monCls = GetClassByType("Monster", petInfo:GetPetType());
	local obj = GetIES(petInfo:GetObject());

	local priceStr = PET_REVIVE_PRICE(obj) .. " " .. ScpArgMsg("NXP");
	local msg = ScpArgMsg("ReviveCompanion?{Price}WillBeConsumed", "Price", priceStr);
	local execScript = string.format("_EXEC_REVIVE_PET(\"%s\")", petGuid);
	ui.MsgBox(msg, execScript, "None");

end

function _EXEC_REVIVE_PET(petGuid)
	local selFrame = OPEN_BARRACK_SELECT_PC_FRAME("GIVE_PET_REVIVE_ITEM", "SelectCharacterToGetRevivedPetEgg");
	selFrame:SetUserValue("PET_GUID", petGuid);
end

function GIVE_PET_REVIVE_ITEM(pcName)
	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(0);

	local petGuid = selectFrame:GetUserValue("PET_GUID");
	local accountInfo = session.barrack.GetMyAccount();
	local pcInfo = accountInfo:GetByPCName(pcName);

	barrack.RequestReviveDeadPet(petGuid, pcInfo:GetCID());	
end

function REQUEST_DELETE_PET(parent, ctrl)
	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");
	DELETE_WARNING_BOX_ON_INIT(11, petGuid);
	CHAR_N_PET_LIST_LOCKMANGED(0);
end

function _EXEC_DELETE_PET(petGuid, charCID)
	barrack.RequestDeletePet(petGuid, charCID);
end

function CHAR_N_PET_LIST_LOCKMANGED(unlock)
	local charFrame = ui.GetFrame("barrack_charlist");
	local petFrame = ui.GetFrame("barrack_petlist");
	charFrame:SetEnable(unlock);
	petFrame:SetEnable(unlock);
end