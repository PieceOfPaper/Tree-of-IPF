
function MANAGEGEM_ON_INIT(addon, frame)
	addon:RegisterMsg("MSG_REMOVE_GEM", "MANAGEGEM_MSG");
	addon:RegisterMsg("DO_OPEN_MANAGE_GEM_UI", "MANAGEGEM_MSG");
	addon:RegisterMsg("MSG_MAKE_ITEM_SOCKET", "MANAGEGEM_MSG");
end

function MANAGEGEM_MSG(frame, msg, argStr, argNum)
	if msg == "MSG_REMOVE_GEM" or msg == "MSG_MAKE_ITEM_SOCKET" then
		CLEAR_MANAGEGEM_UI()
		UPDATE_MANAGEGEM_UI_BY_MSG(frame)
	elseif msg == "DO_OPEN_MANAGE_GEM_UI" then
		frame:ShowWindow(1)
	end
end

function MANAGEGEM_OPEN(frame)
	ui.OpenFrame("inventory")
	INVENTORY_SET_CUSTOM_RBTNDOWN("MANAGEGEM_INV_RBTN");
	CLEAR_MANAGEGEM_UI()
end

function MANAGEGEM_CLOSE(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
end

function MANAGEGEM_DROP(frame, icon, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	frame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
		local invItem = GET_ITEM_BY_GUID(guid);

		local obj = GetIES(invItem:GetObject());
		ADD_ITEM_TO_MANAGEGEM_FROM_INV(obj);
	end
end

function MANAGEGEM_INV_RBTN(itemobj, slot)

	CLEAR_MANAGEGEM_UI()
	ADD_ITEM_TO_MANAGEGEM_FROM_INV(itemobj)

end

function CLEAR_MANAGEGEM_UI()

	local frame = ui.GetFrame("managegem");

	local select_item_pic = GET_CHILD_RECURSIVELY(frame, "select_item_pic", "ui::CPicture");
	select_item_pic:SetImage('socket_slot_bg')

	local select_item_text = GET_CHILD_RECURSIVELY(frame, "select_item_text", "ui::CRichText");
	select_item_text:SetText(ScpArgMsg('DropItemPlz'))

	local gauge_potential = GET_CHILD_RECURSIVELY(frame, 'gauge_potential', "ui::CGauge");
	gauge_potential:SetPoint(0, 1);
	
	local bodyGbox_midle = GET_CHILD_RECURSIVELY(frame, 'bodyGbox_midle');
	bodyGbox_midle:RemoveAllChild();

	local richtext_howmuch = GET_CHILD_RECURSIVELY(frame, 'richtext_howmuch', 'ui::CRichText')
	richtext_howmuch:SetTextByKey("add",'--')
	richtext_howmuch:SetTextByKey("remove",'--')

	frame:SetUserValue("NOW_SELECT_INDEX",0);

	local button_remove_gem = GET_CHILD_RECURSIVELY(frame, 'button_remove_gem', 'ui::CButton')
	button_remove_gem:SetEventScriptArgString(ui.LBUTTONUP, "None");	

	local button_make_socket = GET_CHILD_RECURSIVELY(frame, 'button_make_socket', 'ui::CButton')
	button_make_socket:SetEventScriptArgString(ui.LBUTTONUP, "None");	

end

function UPDATE_MANAGEGEM_UI_BY_MSG(frame)

	local tempiesid = frame:GetUserValue("TEMP_IESID");
	
	if tempiesid == nil then
		return;
	end

	local item = GetObjectByGuid(tempiesid);
	ADD_ITEM_TO_MANAGEGEM_FROM_INV(item)

end


function ADD_ITEM_TO_MANAGEGEM_FROM_INV(item)

	local itemClass = GetClassByType("Item", item.ClassID);
	

	if item.ItemType ~= 'Equip' then
		ui.MsgBox(ScpArgMsg("IMPOSSIBLE_ITEM"))
		return;
	end

	if item.MaxSocket <= 0 then
		ui.MsgBox(ScpArgMsg("IMPOSSIBLE_ITEM"))
		return;
	end

	local id = GetIESID(item);
	local invItem = session.GetInvItemByGuid(id);
	if invItem == nil then
		invItem = session.GetEquipItemByGuid(id);
	end

	if invItem == nil then
		return
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local frame = ui.GetFrame("managegem");
	local STAR_SIZE = frame:GetUserConfig("STAR_SIZE")
	local NEGATIVE_COLOR = frame:GetUserConfig("NEGATIVE_COLOR")
	local POSITIVE_COLOR = frame:GetUserConfig("POSITIVE_COLOR")

	local select_item_pic = GET_CHILD_RECURSIVELY(frame, "select_item_pic", "ui::CPicture");
	select_item_pic:SetImage(item.Icon)

	local select_item_text = GET_CHILD_RECURSIVELY(frame, "select_item_text", "ui::CRichText");
	select_item_text:SetText(item.Name)

	local gauge_potential = GET_CHILD_RECURSIVELY(frame, 'gauge_potential', "ui::CGauge");
	gauge_potential:SetPoint(item.PR, item.MaxPR);
	
	local bodyGbox_midle = GET_CHILD_RECURSIVELY(frame, 'bodyGbox_midle');
	frame:SetUserValue('MAX_SOCKET_CNT', item.MaxSocket);
	local nowusesocketcount = 0;
	for i = 0, item.MaxSocket - 1 do
		local nowsockettype = item['Socket_' .. i]
		local nowsocketitem = item['Socket_Equip_' .. i]
		local nowsocketitemexp = item['SocketItemExp_' .. i]

		if nowsockettype ~= 0 then
			nowusesocketcount = nowusesocketcount + 1
		end
		
		local subClassCtrl = bodyGbox_midle:CreateOrGetControlSet('eachsocket_in_managesocket', 'SOCKET_CSET_'..i , 0, i*90);
		local socket_icon = GET_CHILD_RECURSIVELY(subClassCtrl,"socket_icon","ui::CPicture");
		local socket_questionmark = GET_CHILD_RECURSIVELY(subClassCtrl,"socket_questionmark","ui::CPicture");
		local socket_name = GET_CHILD_RECURSIVELY(subClassCtrl,"socket_name","ui::CRichText");
		local socket_property = GET_CHILD_RECURSIVELY(subClassCtrl,"socket_property","ui::CRichText");
		local gradetext = GET_CHILD_RECURSIVELY(subClassCtrl,"grade","ui::CRichText");

		gradetext:ShowWindow(1)
		socket_property:ShowWindow(1)
		subClassCtrl:SetUserValue('SOCKET_NUMBER', i);

		local socketname = ScpArgMsg('NotDecidedYet')
		
		local socketicon = 'question_mark'
		socket_icon:ShowWindow(1)
		socket_questionmark:ShowWindow(0)
		
		if nowsockettype ~= 0 then
			local socketCls = GetClassByType("Socket", nowsockettype);
			
			if nowsocketitem == 0 then
				socketname = socketCls.Name .. ' '.. ScpArgMsg("JustSocket")

				local socketCls = GetClassByType("Socket", nowsockettype);
				socketicon = socketCls.SlotIcon

				gradetext:ShowWindow(0)
				socket_property:ShowWindow(0)
				
				local radioBtn = subClassCtrl:GetChild('radioBtn');
				radioBtn:ShowWindow(0)
			else
			    local socketItemCls = GetClassByNumProp('Item', 'ClassID', nowsocketitem)
			    socketname = socketItemCls.Name;

				local socketCls = GetClassByType("Item", nowsocketitem);
				socketicon = socketCls.Icon;

				local radioBtn = GET_CHILD(subClassCtrl, 'radioBtn', 'ui::CRadioButton');
				radioBtn:SetCheck(false);
				radioBtn:ShowWindow(1)

				local level = GET_ITEM_LEVEL_EXP(socketCls,nowsocketitemexp)
				gradetext:SetText(GET_STAR_TXT(STAR_SIZE,level))

				local prop = geItemTable.GetProp(nowsocketitem);
				local desc = "";
				local socketProp = prop:GetSocketPropertyByLevel(level);
				local type = item.ClassID;
				local cnt = socketProp:GetPropCountByType(type);

				for i = 0 , cnt - 1 do
					local addProp = socketProp:GetPropAddByType(type, i);
					
					local tempvalue = addProp.value
					local plma_mark = POSITIVE_COLOR .. '+{/}'
					if tempvalue < 0 then
						plma_mark = NEGATIVE_COLOR .. '-{/}'
						tempvalue = tempvalue * -1
					end
					if addProp:GetPropName() == "OptDesc" then
						desc = addProp:GetPropDesc();
					else
					desc = desc .. ScpArgMsg(addProp:GetPropName()) .. " : ".. plma_mark .. tempvalue.."{nl}";
				end
				end

				socket_property:SetText(desc)
				socket_property:ShowWindow(1)
			end
		else
			local radioBtn = subClassCtrl:GetChild('radioBtn');
			radioBtn:ShowWindow(0)
			gradetext:ShowWindow(0)
			socket_property:ShowWindow(0)
			socket_icon:ShowWindow(0)
			socket_questionmark:ShowWindow(1)
		end

		socket_icon:SetImage(socketicon)
		socket_name:SetText(socketname)

		local socket_icon = GET_CHILD_RECURSIVELY(subClassCtrl,"socket_icon","ui::CPicture");

	end

	local richtext_howmuch = GET_CHILD_RECURSIVELY(frame, 'richtext_howmuch', 'ui::CRichText')
	local curcnt = GET_SOCKET_CNT(item);
	local lv = TryGetProp(item,"UseLv");
	if lv == nil then
	    return 0;
	end
	local grade = TryGetProp(item,"ItemGrade");
	if grade == nil then
	    return 0;
	end
richtext_howmuch:SetTextByKey("add",GET_COMMAED_STRING(GET_MAKE_SOCKET_PRICE(lv,grade ,curcnt)));
	richtext_howmuch:SetTextByKey("remove",GET_COMMAED_STRING(GET_REMOVE_GEM_PRICE(lv)));
	richtext_howmuch:ShowWindow(1)
	frame:SetUserValue("TEMP_IESID",id);
	
	local button_remove_gem = GET_CHILD_RECURSIVELY(frame, 'button_remove_gem', 'ui::CButton')
	button_remove_gem:SetEventScriptArgString(ui.LBUTTONUP, item.Name);	

	local button_make_socket = GET_CHILD_RECURSIVELY(frame, 'button_make_socket', 'ui::CButton')
	button_make_socket:SetEventScriptArgString(ui.LBUTTONUP, item.Name);
end

function CLICK_REMOVEGEM_RADIOBTN(parent)
	local frame = ui.GetFrame("managegem");
	local radioBtn = parent:GetChild('radioBtn');
	local MAX_SOCKET_CNT = frame:GetUserIValue('MAX_SOCKET_CNT');

	for i = 0, MAX_SOCKET_CNT -1 do
		local ctrlset = GET_CHILD_RECURSIVELY(frame, 'SOCKET_CSET_'..i);
		local _radioBtn = GET_CHILD(ctrlset, 'radioBtn', 'ui::CRadioButton');
		if _radioBtn ~= radioBtn then
			_radioBtn:SetCheck(false);
		else
			radioBtn:SetCheck(true);
			frame:SetUserValue('NOW_SELECT_INDEX', i + 1);
		end
	end
end

function CLICK_REMOVE_GEM_BUTTON(frame, slot, argStr, argNum)
	if "None" == argStr then
		ui.MsgBox(ScpArgMsg("SelectSomeItemPlz"))
		return;
	end
	local itemname = argStr;
	local yesScp = string.format("EXEC_REMOVE_GEM()");
	
	ui.MsgBox( "'"..itemname ..ScpArgMsg("Auto_'_SeonTaeg")..ScpArgMsg("ReallyRemoveGem"), yesScp, "None");
end

function EXEC_REMOVE_GEM()

	local frame = ui.GetFrame("managegem");
	local tempiesid = frame:GetUserValue("TEMP_IESID");
	local selectedNum = tonumber(frame:GetUserValue("NOW_SELECT_INDEX"));
	local MAX_SOCKET_CNT = frame:GetUserIValue('MAX_SOCKET_CNT');

	if selectedNum == nil or selectedNum < 1 or selectedNum > MAX_SOCKET_CNT then
		ui.MsgBox(ScpArgMsg("WRONG_INDEX"))
		return;
	end
	
	local ctrlset = GET_CHILD_RECURSIVELY(frame, 'SOCKET_CSET_'..selectedNum-1);
	local radioBtn = ctrlset:GetChild('radioBtn');
	if tempiesid == 0 then
		return;
	end

	local itemobj = GetObjectByGuid(tempiesid);

	local nowusesocketcount = 0

	for i = 0, itemobj.MaxSocket - 1 do
		local nowsockettype = itemobj['Socket_' .. i]

		if nowsockettype ~= 0 then
			nowusesocketcount = nowusesocketcount + 1
		end
	end
    
    local lv = TryGetProp(itemobj , "UseLv");
    
    if lv == nil then
        return 0;
    end

	local price = GET_REMOVE_GEM_PRICE(lv)

	if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	session.ResetItemList();
	session.AddItemID(tempiesid);
	
	local resultlist = session.GetItemIDList();

	item.DialogTransaction("REMOVE_GEM", resultlist, selectedNum-1);

end

function CLICK_MAKE_SOCKET_BUTTON(frame, slot, argStr, argNum)
	if "None" == argStr then
		ui.MsgBox(ScpArgMsg("SelectSomeItemPlz"))
		return;
	end
	local itemname = argStr;
	local yesScp = string.format("EXEC_MAKE_NEW_SOCKET()");
	
	ui.MsgBox( "'"..itemname ..ScpArgMsg("Auto_'_SeonTaeg")..ScpArgMsg("ReallyMakeSocket"), yesScp, "None");
end

function EXEC_MAKE_NEW_SOCKET()

	local frame = ui.GetFrame("managegem");
	local tempiesid = frame:GetUserValue("TEMP_IESID");

	if tempiesid == 0 then
		return;
	end
	
	local itemobj = GetObjectByGuid(tempiesid);

	local nowusesocketcount = 0

	for i = 0, itemobj.MaxSocket - 1 do
		local nowsockettype = itemobj['Socket_' .. i]

		if nowsockettype ~= 0 then
			nowusesocketcount = nowusesocketcount + 1
		end
	end

	-- ��ȭ �Ұ���
	if IS_REINFORCEABLE_ITEM(itemobj) == 0 then
		ui.MsgBox(ScpArgMsg("IT_ISNT_REINFORCEABLE_ITEM"))
		return;
	end

	-- ���� ���ټ�
	if itemobj.PR <= 0 then
		ui.MsgBox(ScpArgMsg('NoMorePotential'))
		return;
	end

	-- ���� �ƽ� ����
	if itemobj.MaxSocket - nowusesocketcount <= 0 then
		ui.MsgBox(ScpArgMsg('NoMoreSocket'))
		return;
	end
    local curcnt = GET_SOCKET_CNT(itemobj);
   	local lv = TryGetProp(itemobj,"UseLv");
	if lv == nil then
		return 0;
	end

	local grade = TryGetProp(itemobj,"ItemGrade");
	if grade == nil then
		return 0;
	end

	local price = GET_MAKE_SOCKET_PRICE(lv, grade, curcnt)

	if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	session.ResetItemList();
	session.AddItemID(tempiesid);
	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("MAKE_SOCKET", resultlist);

end