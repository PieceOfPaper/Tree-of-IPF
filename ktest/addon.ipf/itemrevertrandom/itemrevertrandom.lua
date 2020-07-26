-- 장인의 돋보기
function ITEMREVERTRANDOM_ON_INIT(addon, frame)
	addon:RegisterMsg("MSG_SUCCESS_REVERT_RANDOM_OPTION", "SUCCESS_REVERT_RANDOM_OPTION");
end

local isCloseable = 1
local propNameList = nil
local propValueList = nil

function OPEN_REVERT_RANDOM(invItem)
	local frame = ui.GetFrame('itemrevertrandom');    
    if frame ~= nil and frame:IsVisible() == 1 then
        ui.SysMsg(ClMsg('AlreadyProcessing'));
        return;
	end
	
	for i = 1, #revertrandomitemlist do
		local frame = ui.GetFrame(revertrandomitemlist[i]);
		if frame ~= nil and frame:IsVisible() == 1 and revertrandomitemlist[i] ~= "itemrevertrandom" then
			return;
		end
	end

	local item = GetIES(invItem:GetObject());
	frame:SetUserValue('REVERTITEM_GUID', invItem:GetIESID());
	frame:SetUserValue("CLASS_ID", item.ClassID);

	local richtext_1 = GET_CHILD_RECURSIVELY(frame, "richtext_1");
	richtext_1:SetTextByKey("value", item.Name);	

	local text_needmaterial = GET_CHILD_RECURSIVELY(frame, "text_needmaterial");
	text_needmaterial:SetTextByKey("name", item.Name);

	isCloseable = 1;

	frame:ShowWindow(1);	
	ui.OpenFrame('inventory');
end

function ITEM_REVERT_RANDOM_OPEN(frame)
	local slot = GET_CHILD_RECURSIVELY(frame, "slot")
	local icon = slot:GetIcon()
	if icon ~= nil then
		isCloseable = 0
	else
		isCloseable = 1
	end

	ui.OpenFrame("inventory")
	local tab = GET_CHILD_RECURSIVELY(ui.GetFrame("inventory"), "inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(0);
	
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEM_REVERT_RANDOM_INV_RBTN");
end

function ITEM_REVERT_RANDOM_CLOSE(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN('None');
	
	if ui.CheckHoldedUI() == true then
		return;
	end

	if frame == nil then
		return
	end

	if isCloseable == 0 then
		ui.SysMsg(ClMsg("CannotCloseRandomReset"));
		return
	end

	CLEAR_ITEM_REVERT_RANDOM_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
 end

function REVERT_RANDOM_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemrevertrandom");
	UPDATE_REVERT_RANDOM_ITEM(frame);
	UPDATE_REVERT_RANDOM_RESULT(frame, isSuccess);
end

function CLEAR_ITEM_REVERT_RANDOM_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemrevertrandom");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(0)

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom")
	do_revertrandom:ShowWindow(1)

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(1)

	local text_beforereset = GET_CHILD_RECURSIVELY(frame, "text_beforereset")
	text_beforereset:ShowWindow(1)
	local text_afterreset = GET_CHILD_RECURSIVELY(frame, "text_afterreset")
	text_afterreset:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(1)
		
	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText("")

	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();

	local select_before = GET_CHILD_RECURSIVELY(frame, "select_before")
	select_before:ShowWindow(0)
	local select_after = GET_CHILD_RECURSIVELY(frame, "select_after")
	select_after:ShowWindow(0)

	isCloseable = 1

	UPDATE_REMAIN_MASTER_GLASS_COUNT(frame)
end

function ITEM_REVERT_RANDOM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	if isCloseable == 0 then
		ui.SysMsg(ClMsg("CannotCloseRandomReset"));
		return
	end

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	CLEAR_ITEM_REVERT_RANDOM_UI()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_REVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end;
end;

function ITEM_REVERT_RANDOM_REG_TARGETITEM(frame, itemID, reReg)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', obj.ClassID)

	if TryGetProp(itemCls, 'NeedRandomOption') ~= 1 then
		ui.SysMsg(ClMsg("NotAllowedRandomReset"));
		return;
	end
	
	if IS_NEED_APPRAISED_ITEM(obj) == true or IS_NEED_RANDOM_OPTION_ITEM(obj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end

	if isCloseable == 0 then
		ui.SysMsg(ClMsg("CannotCloseRandomReset"));
		return
	end

	if invItem.isLockState == true and (reReg == nil or reReg == 0) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(0)

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText(obj.Name)
    
	local gBox = GET_CHILD_RECURSIVELY(frame:GetTopParentFrame(), "bodyGbox1_1");
    local ypos = 0;
	for i = 1 , MAX_RANDOM_OPTION_COUNT do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None'
		
		if obj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif obj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif obj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if obj[propValue] ~= 0 and obj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(obj[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, obj[propValue], 0);
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, i * pos_y)
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo);
            ypos = i * pos_y + propertyList:GetHeight() + 5;
		end
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");	
	SET_SLOT_ITEM(slot, invItem);
end

function ITEM_REVERT_RANDOM_EXEC(frame)
	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then		
		return;
	end

	local text_havematerial = GET_CHILD_RECURSIVELY(frame, "text_havematerial")
	local materialCnt = text_havematerial:GetTextByKey("count")
	if materialCnt == '0' then
		ui.SysMsg(ClMsg("LackOfRevertRandomMaterial"));
		return
	end
	
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local clmsg = ScpArgMsg("DoRevertRandomReset")
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEM_REVERT_RANDOM_EXEC", "None");
end

function _ITEM_REVERT_RANDOM_EXEC()
	local frame = ui.GetFrame("itemrevertrandom");
	if frame:IsVisible() == 0 then
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then		
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', itemObj.ClassID)

	if itemCls.NeedRandomOption ~= 1 then
		ui.SysMsg(ClMsg("NotAllowedRandomReset"));
		return;
	end

	if ui.GetFrame("apps") ~= nil then
		ui.CloseFrame("apps")
	end

	local revertItemGUID = frame:GetUserValue('REVERTITEM_GUID');
	local revertItem = session.GetInvItemByGuid(revertItemGUID);
	if revertItem == nil then
		revertItemGUID = GET_NEXT_ITEM_GUID_BY_CLASSID(frame:GetUserValue("CLASS_ID"));
	end
	
	session.ResetItemList();
	session.AddItemID(revertItemGUID);	
	session.AddItemID(invItem:GetIESID());
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("REVERT_ITEM_OPTION", resultlist);
end

function SUCCESS_REVERT_RANDOM_OPTION(frame)
	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	pic_bg:PlayUIEffect(RESET_SUCCESS_EFFECT_NAME, EFFECT_SCALE, 'RESET_SUCCESS_EFFECT');

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom")
	do_revertrandom:ShowWindow(0)

	ui.SetHoldUI(true);

	ReserveScript("_SUCCESS_REVERT_RANDOM_OPTION()", EFFECT_DURATION)
end

function _SUCCESS_REVERT_RANDOM_OPTION()
	ui.SetHoldUI(false);
	local frame = ui.GetFrame("itemrevertrandom");
	if frame:IsVisible() == 0 then
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg:StopUIEffect('RESET_SUCCESS_EFFECT', true, 0.5);

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local text_beforereset = GET_CHILD_RECURSIVELY(frame, "text_beforereset")
	text_beforereset:ShowWindow(1)
	local text_afterreset = GET_CHILD_RECURSIVELY(frame, "text_afterreset")
	text_afterreset:ShowWindow(1)

	local invItemGUID = invItem:GetIESID()
	local resetInvItem = session.GetInvItemByGuid(invItemGUID)
	local obj = GetIES(resetInvItem:GetObject());

	local refreshScp = obj.RefreshScp
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_1");
    local ypos = 0;
	for i = 1 , MAX_RANDOM_OPTION_COUNT do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None'
		
		if obj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif obj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif obj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'			
		elseif obj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end
		
		if obj[propValue] ~= 0 and obj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(obj[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, obj[propValue], 0);
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, i * pos_y)
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo);
            ypos = i * pos_y + propertyList:GetHeight() + 5;
		end
	end
    
	UPDATE_REMAIN_MASTER_GLASS_COUNT(frame)
end

function UPDATE_REMAIN_MASTER_GLASS_COUNT(frame)
	local classID = frame:GetUserValue("CLASS_ID");
	local itemHaveCount = GET_INV_ITEM_COUNT_BY_CLASSID(classID);

	local text_havematerial = GET_CHILD_RECURSIVELY(frame, "text_havematerial")
	text_havematerial:SetTextByKey("count", itemHaveCount)
end

function REMOVE_REVERT_RANDOM_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	if isCloseable == 0 then
		ui.SysMsg(ClMsg("CannotCloseRandomReset"));
		return
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEM_REVERT_RANDOM_UI()
end

function ITEM_REVERT_RANDOM_SEND_OK()
	local frame = ui.GetFrame("itemrevertrandom")

	if frame:GetUserValue("REVERTITEM_GUID") == nil or frame:GetUserValue("REVERTITEM_GUID") == "None" then
		ui.CloseFrame("itemrevertrandom")
		return
	end

	CLEAR_ITEM_REVERT_RANDOM_UI()
end

function ITEM_REVERT_RANDOM_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("itemrevertrandom");
	if frame == nil then
		return
	end

	if isCloseable == 0 then
		ui.SysMsg(ClMsg("CannotCloseRandomReset"));
		return
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	
	CLEAR_ITEM_REVERT_RANDOM_UI()

	ITEM_REVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID()); 
end

function ITEM_OPTION_SELECT_BEFORE(frame)
	local frame = ui.GetFrame("itemrevertrandom");
	local slot = GET_CHILD_RECURSIVELY(frame, "slot")
	local icon = slot:GetIcon()
	if icon == nil then
		return ""
	end

	local iconInfo = icon:GetInfo();
	if iconInfo == nil then
		return ""
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return ""
	end

	local obj = GetIES(invItem:GetObject());
	if obj == nil then
		return ""
	end

	local clmsg = ScpArgMsg("ChangeRevertRandomOption{ItemName}", "ItemName", obj.Name)
	local yesScp = string.format("ITEMREVERTRANDOM_SEND_ANSWER");
	REVERTRANDOM_AGREEBOX_FRAME_OPEN(clmsg, obj, yesScp, "No")
end

function ITEM_OPTION_SELECT_AFTER(frame)

	local frame = ui.GetFrame("itemrevertrandom");
	local slot = GET_CHILD_RECURSIVELY(frame, "slot")
	local icon = slot:GetIcon()
	if icon == nil then
		return ""
	end

	local iconInfo = icon:GetInfo();
	if iconInfo == nil then
		return ""
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return ""
	end

	local obj = GetIES(invItem:GetObject());
	if obj == nil then
		return ""
	end

	local clmsg = ScpArgMsg("ChangeRevertRandomOption{ItemName}", "ItemName", obj.Name)
	local yesScp = string.format("ITEMREVERTRANDOM_SEND_ANSWER");
	REVERTRANDOM_AGREEBOX_FRAME_OPEN(clmsg, obj, yesScp, "Yes");
end

function ITEM_OPTION_SELECT_GETNAME()
	local frame = ui.GetFrame("itemrevertrandom");
	local slot = GET_CHILD_RECURSIVELY(frame, "slot")
	local icon = slot:GetIcon()
	if icon == nil then
		return ""
	end

	local iconInfo = icon:GetInfo();
	if iconInfo == nil then
		return ""
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return ""
	end

	local obj = GetIES(invItem:GetObject());
	if obj == nil then
		return ""
	end

	return obj.Name
end

function SHOW_REVERT_ITEM_RESULT(itemGuid, _propNameList, _propValueList)
	local frame = ui.GetFrame('itemrevertrandom');
	if frame == nil then
		return
	end

	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	
	if frame:GetUserIValue("IS_PLAYED_EFFECT") ~= 1 then
		pic_bg:PlayUIEffect(RESET_SUCCESS_EFFECT_NAME, EFFECT_SCALE, 'RESET_SUCCESS_EFFECT');
		frame:SetUserValue("IS_PLAYED_EFFECT", 1)
	end

	ui.SetHoldUI(true);
	propNameList = _propNameList
	propValueList = _propValueList

	local scp = string.format("_SHOW_REVERT_ITEM_RESULT(\"%s\")", itemGuid)
	ReserveScript(scp, EFFECT_DURATION)
end

function _SHOW_REVERT_ITEM_RESULT(itemGuid)
	ui.SetHoldUI(false);

	local frame = ui.GetFrame('itemrevertrandom');
	isCloseable = 0
	frame:EnableHide(0);
	if frame:IsVisible() == 0 then		
		CLEAR_ITEM_REVERT_RANDOM_UI();
		ITEM_REVERT_RANDOM_REG_TARGETITEM(frame, itemGuid, 1);

		local itemrandomreset = ui.GetFrame('itemrandomreset');
		if itemrandomreset ~= nil and itemrandomreset:IsVisible() == 1 then
			return;
		end

		local itemunrevertrandom = ui.GetFrame('itemunrevertrandom');
		if itemunrevertrandom ~= nil and itemunrevertrandom:IsVisible() == 1 then
			return;
		end

		frame:ShowWindow(1);
		ui.OpenFrame('inventory');
	end

	if itemGuid == nil or itemGuid == 0 then		
		return
	end

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg:StopUIEffect('RESET_SUCCESS_EFFECT', true, 0.5);

	local text_beforereset = GET_CHILD_RECURSIVELY(frame, "text_beforereset")
	text_beforereset:ShowWindow(1)
	local text_afterreset = GET_CHILD_RECURSIVELY(frame, "text_afterreset")
	text_afterreset:ShowWindow(1)

	local select_before = GET_CHILD_RECURSIVELY(frame, "select_before")
	select_before:ShowWindow(1)
	local select_after = GET_CHILD_RECURSIVELY(frame, "select_after")
	select_after:ShowWindow(1)

	local gbox = frame:GetChild("gbox");
	local resetInvItem = session.GetInvItemByGuid(itemGuid)
	if resetInvItem == nil then
		resetInvItem = session.GetEquipItemByGuid(itemGuid)
	end
	local obj = GetIES(resetInvItem:GetObject());
	local refreshScp = obj.RefreshScp
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end

	local optionIndex = 1
	local clientMessage = {}
	local opName = {}
	local strInfo = {}
	local opValue = {}

	for i = 1 , #propNameList do
		local propGroupName = "RandomOptionGroup_";
		local propName = "RandomOption_";
		local propValue = "RandomOptionValue_";
		
		local startGroupName, propGroupNameIndex = string.find(propNameList[i], propGroupName)
		local startName, propNameIndex = string.find(propNameList[i], propName)
		local startValue, propValueIndex = string.find(propNameList[i], propValue)

		if propGroupNameIndex ~= nil then
			-- ATK, STAT 등 옵션 그룹일때
			local propIndexStr = string.sub(propNameList[i], propGroupNameIndex + 1, propGroupNameIndex + 1)
			local propIndex = 1
			if propIndexStr ~= nil and propIndexStr ~= "" then
				propIndex = tonumber(propIndexStr)
			end

			if propValueList[i] == 'ATK' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupATK'
			elseif propValueList[i] == 'DEF' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupDEF'
			elseif propValueList[i] == 'UTIL_WEAPON' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupUTIL'
			elseif propValueList[i] == 'UTIL_ARMOR' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupUTIL'			
			elseif propValueList[i] == 'UTIL_SHILED' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupUTIL'
			elseif propValueList[i] == 'STAT' then
			    clientMessage[propIndex] = 'ItemRandomOptionGroupSTAT'
			end
		elseif propNameIndex ~= nil then
			-- ADD_PARAMUNE, DEX 등 옵션 명
			if propValueList[i] ~= nil and propValueList[i] ~= "None" then
				local propIndexStr = string.sub(propNameList[i], propNameIndex + 1, propNameIndex + 1)
				local propIndex = 1
				if propIndexStr ~= nil and propIndexStr ~= "" then
					propIndex = tonumber(propIndexStr)
				end
				opName[propIndex] = propValueList[i];	
			end
		elseif propValueIndex ~= nil then
			-- 실제 숫자 값
			if propValueList[i] ~= nil and propValueList[i] ~= "" then
				local propIndexStr = string.sub(propNameList[i], propValueIndex + 1, propValueIndex + 1)
				local propIndex = 1
				if propIndexStr ~= nil and propIndexStr ~= "" then
					propIndex = tonumber(propIndexStr)
				end
				opValue[propIndex] = propValueList[i];
			end
		end
	end
    
	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_1");
    local ypos = 0;
	for i = 1 , #propNameList do
		if clientMessage[optionIndex] ~= nil and opName[optionIndex] ~= nil and opValue[optionIndex] ~= nil then
			local temp = string.format("%s %s", ClMsg(clientMessage[optionIndex]), ScpArgMsg(opName[optionIndex]));	
			strInfo[optionIndex] = ABILITY_DESC_NO_PLUS(temp, tonumber(opValue[optionIndex]), 0);

			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..optionIndex, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, optionIndex * pos_y)
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo[optionIndex]);
            ypos = optionIndex * pos_y + propertyList:GetHeight() + 5;
			optionIndex = optionIndex + 1
		end
	end

	UPDATE_REMAIN_MASTER_GLASS_COUNT(frame)
	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom")
	do_revertrandom:ShowWindow(0);
end

function ITEMREVERTRANDOM_SEND_ANSWER(parent, ctrl, argStr, argNum)
	local frame = ui.GetFrame("itemrevertrandom")
	if frame == nil then 
		return
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local icon = slot:GetIcon()
	if icon == nil then		
		return
	end

	local iconInfo = icon:GetInfo();
	if iconInfo == nil then
		return
	end

	session.inventory.SendLockItem(iconInfo:GetIESID(), 0)

	local resultlist = session.GetItemIDList();
	local stringArgList = '';
	local deleteGBoxName = "bodyGbox1_1"
	if argStr == "No" then
		deleteGBoxName = "bodyGbox2_1"
		stringArgList = '0';
	else
		stringArgList = '1';
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, deleteGBoxName)
	DESTROY_CHILD_BYNAME(gBox, "PROPERTY_CSET_")

	local select_before = GET_CHILD_RECURSIVELY(frame, "select_before")
	select_before:ShowWindow(0)
	local select_after = GET_CHILD_RECURSIVELY(frame, "select_after")
	select_after:ShowWindow(0)

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom")
	do_revertrandom:ShowWindow(0)
	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok")
	send_ok:ShowWindow(1)

	frame:SetUserValue("IS_PLAYED_EFFECT", 0)

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());
	item.DialogTransaction("ANSWER_REVERT_ITEM_OPTION", resultlist, stringArgList);
	ui.CloseFrame("revertrandomagreebox")
	isCloseable = 1
	frame:EnableHide(1);
end