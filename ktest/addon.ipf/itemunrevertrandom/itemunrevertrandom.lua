-- itemunrevertrandom.lua
function ITEMUNREVERTRANDOM_ON_INIT(addon, frame)
	addon:RegisterMsg("MSG_SUCCESS_UNREVERT_RANDOM_OPTION", "SUCCESS_UNREVERT_RANDOM_OPTION");
end

function OPEN_UNREVERT_RANDOM(invItem)
	 local frame = ui.GetFrame('itemunrevertrandom');
	 frame:SetUserValue('REVERTITEM_GUID', invItem:GetIESID());
	 frame:ShowWindow(1);
end

function ITEM_UNREVERT_RANDOM_OPEN(frame)	
	SET_UNREVERT_RANDOM_RESET(frame);
	CLEAR_ITEM_UNREVERT_RANDOM_UI()
	ui.OpenFrame("inventory")
	local tab = GET_CHILD_RECURSIVELY(ui.GetFrame("inventory"), "inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(0);

	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEM_UNREVERT_RANDOM_INV_RBTN")	

end

function ITEM_UNREVERT_RANDOM_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
 end

function UNREVERT_RANDOM_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemunrevertrandom");
	UPDATE_UNREVERT_RANDOM_ITEM(frame);
	UPDATE_UNREVERT_RANDOM_RESULT(frame, isSuccess);
end

function CLEAR_ITEM_UNREVERT_RANDOM_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemunrevertrandom");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(0)

	local do_unrevertrandom = GET_CHILD_RECURSIVELY(frame, "do_unrevertrandom")
	do_unrevertrandom:ShowWindow(1)

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(1)

--	local text_beforereset = GET_CHILD_RECURSIVELY(frame, "text_beforereset")
--	text_beforereset:ShowWindow(1)
--	local text_afterreset = GET_CHILD_RECURSIVELY(frame, "text_afterreset")
--	text_afterreset:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(1)
		
	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText("")

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1)
	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0)
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();

	UPDATE_REMAIN_MYSTIC_GLASS_COUNT(frame)
end

function SENDOK_ITEM_UNREVERT_RANDOM_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemunrevertrandom");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	slot:ClearIcon();
	
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(0)

	local do_unrevertrandom = GET_CHILD_RECURSIVELY(frame, "do_unrevertrandom")
	do_unrevertrandom:ShowWindow(1)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(1)

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1)
	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0)
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();

	ITEM_UNREVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID())
end

function ITEM_UNREVERT_RANDOM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	CLEAR_ITEM_UNREVERT_RANDOM_UI()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_UNREVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end;
end;

function ITEM_UNREVERT_RANDOM_REG_TARGETITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return;
	end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)

	if TryGetProp(itemCls, "NeedRandomOption") == nil or itemCls.NeedRandomOption ~= 1 then
		ui.SysMsg(ClMsg("NotAllowedRandomReset"));
		return;
	end

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if IS_NEED_APPRAISED_ITEM(obj) == true or IS_NEED_RANDOM_OPTION_ITEM(obj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end
		
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end


	local invframe = ui.GetFrame("inventory");

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(0)


	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText(obj.Name)

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

			local gBox = GET_CHILD_RECURSIVELY(frame:GetTopParentFrame(), "bodyGbox1_1")
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, i * pos_y)
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo)
		end
	end

	local isAbleExchange = 1;
	if obj.MaxDur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET or obj.Dur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET then
		isAbleExchange = -2;
	end



	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	SET_UNREVERT_RANDOM_RESET(frame);	
end



function SET_UNREVERT_RANDOM_RESET(frame)
--	reg:ShowWindow(0);
end;


function ITEM_UNREVERT_RANDOM_EXEC(frame)

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);

	if invItem == nil then
		return
	end

	local clmsg = ScpArgMsg("DoUnrevertRandomReset")
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEM_UNREVERT_RANDOM_EXEC", "_ITEM_UNREVERT_RANDOM_CANCEL");
end

function _ITEM_UNREVERT_RANDOM_CANCEL()
	local frame = ui.GetFrame("itemunrevertrandom");
end;

function _ITEM_UNREVERT_RANDOM_EXEC()

	local frame = ui.GetFrame("itemunrevertrandom");
	if frame:IsVisible() == 0 then
		return;
	end
	
	local isAbleExchange = frame:GetUserIValue("isAbleExchange")

	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return
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

	session.ResetItemList();
	session.AddItemID(frame:GetUserValue('REVERTITEM_GUID'));
	session.AddItemID(invItem:GetIESID());
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("REVERT_ITEM_OPTION", resultlist);

--	SUCCESS_UNREVERT_RANDOM_OPTION(frame)
	return

end

function SUCCESS_UNREVERT_RANDOM_OPTION(frame, msg, argStr, argNum)
	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
--		pic_bg:PlayActiveUIEffect();
pic_bg:PlayUIEffect(RESET_SUCCESS_EFFECT_NAME, EFFECT_SCALE, 'RESET_SUCCESS_EFFECT');

	local do_unrevertrandom = GET_CHILD_RECURSIVELY(frame, "do_unrevertrandom")
		do_unrevertrandom:ShowWindow(0)

		ui.SetHoldUI(true);

	ReserveScript("_SUCCESS_UNREVERT_RANDOM_OPTION()", EFFECT_DURATION)
end

function _SUCCESS_UNREVERT_RANDOM_OPTION()
ui.SetHoldUI(false);
	local frame = ui.GetFrame("itemunrevertrandom");
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


	local item = GetIES(invItem:GetObject());

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local gbox = frame:GetChild("gbox");
	invItem = GET_SLOT_ITEM(slot);
	local invItemGUID = invItem:GetIESID()
	local resetInvItem = session.GetInvItemByGuid(invItemGUID)
	local obj = GetIES(resetInvItem:GetObject());

	local refreshScp = obj.RefreshScp
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end


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

			local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_1")
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, i * pos_y)
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo)
		end
	end

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(0)
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(1)

	UPDATE_REMAIN_MYSTIC_GLASS_COUNT(frame)

	return
end

function UPDATE_REMAIN_MYSTIC_GLASS_COUNT(frame)
	local itemHaveCount = 0
	local invItemList = session.GetInvItemList()
	local invItemCount = session.GetInvItemList():Count()
	for i = 0, invItemCount - 1 do
		local invItem = invItemList:Element(i)
		if invItem ~= nil and invItem:GetObject() ~= nil then
			local obj = GetIES(invItem:GetObject())
			if obj ~= nil then
				local stringArg = TryGetProp(obj, "StringArg")
				if stringArg == "Mystic_Glass" then
					local pc = GetMyPCObject();
					itemHaveCount = itemHaveCount + GetInvItemCount(pc, obj.ClassName)
				end
			end
		end
	end
	local text_havematerial = GET_CHILD_RECURSIVELY(frame, "text_havematerial")
	text_havematerial:SetTextByKey("count", itemHaveCount)
end


function REMOVE_UNREVERT_RANDOM_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEM_UNREVERT_RANDOM_UI()
end

function ITEM_UNREVERT_RANDOM_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("itemunrevertrandom");
	if frame == nil then
		return
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	
	CLEAR_ITEM_UNREVERT_RANDOM_UI()

	ITEM_UNREVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID()); 
end