function RAREOPTION_ON_INIT(addon, frame)
	addon:RegisterMsg('FAIL_ENCHANT_JEWELL', 'ON_FAIL_ENCHANT_JEWELL');
	addon:RegisterMsg('SUCESS_ENCHANT_JEWELL', 'ON_SUCESS_ENCHANT_JEWELL');
end

local function _RAREOPTION_SET_JEWELL_ITEM(frame, jewellItem)	
	if jewellItem == nil then
		local curSettedLv = frame:GetUserIValue('JEWELL_LEVEL');
		if curSettedLv == 0 then
			return;
		end

		local haveCount, itemList = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = 'StringArg', Value ='EnchantJewell'}, {Name = 'Level', Value = frame:GetUserIValue('JEWELL_LEVEL')}});
		if haveCount < 1 then
			ui.MsgBox(ScpArgMsg('UseUp{LEVEL}Jewell', 'LEVEL', curSettedLv), 'ui.CloseFrame("rareoption")', 'None');
			return;
		end
		for i = 1, #itemList do
			local itemObj = GetIES(itemList[i]:GetObject());
			if itemObj.Level == curSettedLv then
				jewellItem = itemList[i];
				break;
			end
		end
	end
	local jewellObj = GetIES(jewellItem:GetObject());
	local margin = frame:GetMargin();	
	frame:SetUserValue('JEWELL_GUID', jewellItem:GetIESID());
	frame:SetUserValue('JEWELL_LEVEL', jewellObj.Level);
end

function OPEN_RARE_OPTION(invItem)
	local indun_reward_hud = ui.GetFrame('indun_reward_hud');
	if info.HasHoldItemBuff() == true or session.world.IsIntegrateServer() == true or IsPVPServer() == 1 or session.world.IsDungeon() == true then
		ui.SysMsg(ClMsg('CannotUseThieInThisMap'));		
		return;
	end

	local rareoption = ui.GetFrame('rareoption');
	_RAREOPTION_SET_JEWELL_ITEM(rareoption, invItem);
	rareoption:ShowWindow(1);
end

function OPEN_RAREOPTION(frame)	
	ui.CloseFrame('itemoptionextract');
	ui.CloseFrame('itemoptionadd');
	RAREOPTION_INIT(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN('RAREOPTION_INVENTORY_RBTN_CLICK');
end

function CLOSE_RAREOPTION(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN('None');
end

-- region: local functions for only rareoption ui
local function GET_JEWELL_ITEM_OBJECT_BY_FRAME(frame)
	local jewellItem = session.GetInvItemByGuid(frame:GetUserValue('JEWELL_GUID'));
	if jewellItem == nil or jewellItem:GetObject() == nil then
		return nil;
	end
	return GetIES(jewellItem:GetObject()), jewellItem;
end

local function SET_TARGET_SLOT(frame, targetItem)
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, 'slot_bg_image');
	local text_putonitem = GET_CHILD_RECURSIVELY(frame, 'text_putonitem');
	local text_itemname = GET_CHILD_RECURSIVELY(frame, 'text_itemname');

	if targetItem ~= nil then
		local targetItemObj = GetIES(targetItem:GetObject());
		SET_SLOT_ITEM(slot, targetItem);		
		text_itemname:SetText(targetItemObj.Name);		
		slot_bg_image:ShowWindow(0);
		text_putonitem:ShowWindow(0);
	else
		slot:ClearIcon();
		text_itemname:SetText('');
		slot_bg_image:ShowWindow(1);
		text_putonitem:ShowWindow(1);
	end
end

local function GET_TARGET_SLOT_ITEM(frame)
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local icon = slot:GetIcon();
	if icon == nil then
		return nil;
	end
	return session.GetInvItemByGuid(icon:GetInfo():GetIESID());
end

local function ADD_RARE_OPTION_CTRLSET(box, itemID)
	box:RemoveAllChild();
	local targetItem = session.GetInvItemByGuid(itemID);
	if targetItem == nil then
		targetItem = session.GetEquipItemByGuid(itemID);
	end
	if targetItem ~= nil and targetItem:GetObject() ~= nil then
		local targetItemObj = GetIES(targetItem:GetObject());
		local rareOptionText = GET_RANDOM_OPTION_RARE_CLIENT_TEXT(targetItemObj);
		if rareOptionText ~= nil then
			local rareOptionCtrl = box:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_RARE', 0, 0);
			rareOptionCtrl = AUTO_CAST(rareOptionCtrl);
			rareOptionCtrl:Move(0, 30);
			local propertyList = GET_CHILD_RECURSIVELY(rareOptionCtrl, "property_name", "ui::CRichText");
			propertyList:SetOffset(30, propertyList:GetY());
			propertyList:SetText(rareOptionText);
			
			local width = propertyList:GetWidth();
			local frame = box:GetTopParentFrame();
			local fixwidth = tonumber(frame:GetUserConfig('FIX_WIDTH'));

			if fixwidth < width then
				propertyList:SetTextFixWidth(1);
				propertyList:SetTextMaxWidth(fixwidth);
			end			
		end
	end
end

local function RAREOPTION_UPDATE_BEFORE_OPTION(frame, targetItem)	
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0);

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();
	bodyGbox1:ShowWindow(1);

	if targetItem ~= nil then
		ADD_RARE_OPTION_CTRLSET(bodyGbox1_1, targetItem:GetIESID());
	end
end

local function CHECK_EXECUTE_ENCHNAT_JEWELL(frame, targetItemID)	
	local targetItem = session.GetInvItemByGuid(targetItemID);
	if targetItem == nil or targetItem:GetObject() == nil then		
		return false;
	end

	if targetItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return false;
	end

	local jewellObj = GET_JEWELL_ITEM_OBJECT_BY_FRAME(frame);
	local targetItemObj = GetIES(targetItem:GetObject());
	local enable, reason = IS_ENABLE_APPLY_JEWELL(jewellObj, targetItemObj);
	if enable == false then
		ui.SysMsg(ScpArgMsg('CannotApplyJewellBecause{REASON}', 'REASON', ClMsg(reason)));
		return false;
	end
	return true;
end

local function RAREOPTION_UPDATE_JEWELL_COUNT(frame)	
	local text_havematerial = GET_CHILD_RECURSIVELY(frame, 'text_havematerial');
	local haveCount = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = 'StringArg', Value ='EnchantJewell'}, {Name = 'Level', Value = frame:GetUserIValue('JEWELL_LEVEL')}});
	text_havematerial:SetTextByKey('count', haveCount);
	return haveCount;
end

-- endregion

function ENABLE_CONTROL_WITH_UI_HOLD(hold)	
	ui.SetHoldUI(hold);
	local value = 0;
	if hold == false then
		value = 1;
	end
	control.EnableControl(value, value);
end

function RAREOPTION_INVENTORY_RBTN_CLICK(itemObj, invSlot, invItemGuid)
	local frame = ui.GetFrame('rareoption');
	if invSlot:IsSelected() == 1 then
		RAREOPTION_INIT(frame);
	else
		RAREOPTION_REGISTER_ITEM(frame, invItemGuid);
	end
end

function RAREOPTION_INIT(frame, clearTarget)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	RAREOPTION_UPDATE_JEWELL_COUNT(frame);

	local do_unrevertrandom = GET_CHILD_RECURSIVELY(frame, 'do_unrevertrandom');	
	local send_ok = GET_CHILD_RECURSIVELY(frame, 'send_ok');
	do_unrevertrandom:ShowWindow(1);
	send_ok:ShowWindow(0);

	local richtext_1 = GET_CHILD_RECURSIVELY(frame, 'richtext_1');
	local jewellItem = GET_JEWELL_ITEM_OBJECT_BY_FRAME(frame);
	if jewellItem ~= nil then
		richtext_1:SetTextByKey('value', GET_ENCHANT_JEWELL_ITEM_NAME_STRING(jewellItem));
	end

	if clearTarget ~= false then
		SET_TARGET_SLOT(frame, nil);
	end
	RAREOPTION_UPDATE_BEFORE_OPTION(frame, nil);
end

function RAREOPTION_DROP_ITEM(parent, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local fromFrame = liftIcon:GetTopParentFrame();
	local toFrame = parent:GetTopParentFrame();
	if fromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		RAREOPTION_REGISTER_ITEM(toFrame, iconInfo:GetIESID());		
	end
end

function RAREOPTION_REGISTER_ITEM(frame, invItemID)	
	if ui.CheckHoldedUI() == true then
		return;
	end

	local jewellItem = GET_JEWELL_ITEM_OBJECT_BY_FRAME(frame);	
	if jewellItem ==nil then
		local curSettedLv = frame:GetUserIValue('JEWELL_LEVEL');
		ui.MsgBox(ScpArgMsg('UseUp{LEVEL}Jewell', 'LEVEL', curSettedLv), 'ui.CloseFrame("rareoption")', 'None');
		return;
	end
	if CHECK_EXECUTE_ENCHNAT_JEWELL(frame, invItemID) == false then
		return;
	end	

	local targetItem = session.GetInvItemByGuid(invItemID);
	SET_TARGET_SLOT(frame, targetItem);	
	RAREOPTION_UPDATE_BEFORE_OPTION(frame, targetItem);
end

function RAREOPTION_EXECUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local icon = slot:GetIcon();
	if icon == nil or icon:GetInfo() == nil then
		ui.SysMsg(ClMsg('NotExistTargetItem'));
		return;
	end

	local jewellItemObj, jewellItem = GET_JEWELL_ITEM_OBJECT_BY_FRAME(frame);
	if jewellItem == nil then
		local curSettedLv = frame:GetUserIValue('JEWELL_LEVEL');
		ui.MsgBox(ScpArgMsg('UseUp{LEVEL}Jewell', 'LEVEL', curSettedLv), 'ui.CloseFrame("rareoption")', 'None');
		return;
	end

	if jewellItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	local targetItemID = icon:GetInfo():GetIESID();
	if CHECK_EXECUTE_ENCHNAT_JEWELL(frame, targetItemID) == false then
		return;
	end

	local yesscp = string.format('_RAREOPTION_EXECUTE("%s", "%s")', targetItemID, jewellItem:GetIESID());
	ui.MsgBox(ClMsg('CommitEnchantOption'), yesscp, 'ENABLE_CONTROL_WITH_UI_HOLD(false)');
	ENABLE_CONTROL_WITH_UI_HOLD(true);
end

function _RAREOPTION_EXECUTE(targetItemID,  jewellItemID)
	local rareoption = ui.GetFrame('rareoption');
	if rareoption:IsVisible() == 0 then
		ENABLE_CONTROL_WITH_UI_HOLD(false);
		return;
	end

	local targetInvItem = session.GetInvItemByGuid(targetItemID);
	if targetInvItem == nil or targetInvItem.isLockState == true then
		ui.SysMsg(ClMsg('CannotEnchantOptionEquipItem'));
		RAREOPTION_INIT(rareoption);
		ENABLE_CONTROL_WITH_UI_HOLD(false);
		return;
	end

	session.ResetItemList();
    session.AddItemID(targetItemID, 1);
    session.AddItemID(jewellItemID, 1);
    local resultlist = session.GetItemIDList();
	item.DialogTransaction('EXECUTE_ENCHANT_JEWELL', resultlist);	
end

function ON_FAIL_ENCHANT_JEWELL(frame, msg, argStr, argNum)
	ENABLE_CONTROL_WITH_UI_HOLD(false);
	ui.SysMsg(ClMsg('FailEnchantJewell'));
	RAREOPTION_INIT(frame);
end

function ON_SUCESS_ENCHANT_JEWELL(frame, msg, argStr, argNum)	
	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	local do_unrevertrandom = GET_CHILD_RECURSIVELY(frame, "do_unrevertrandom");
	do_unrevertrandom:ShowWindow(0);

	pic_bg:StopUIEffect('RESET_SUCCESS_EFFECT', true, 0.5);
	pic_bg:PlayUIEffect(RESET_SUCCESS_EFFECT_NAME, EFFECT_SCALE, 'RESET_SUCCESS_EFFECT');
	ReserveScript("_SUCCESS_ENCHANT_JEWELL()", EFFECT_DURATION);
end

function _SUCCESS_ENCHANT_JEWELL()	
	ENABLE_CONTROL_WITH_UI_HOLD(false);
	local frame = ui.GetFrame('rareoption');
	RAREOPTION_UPDATE_JEWELL_COUNT(frame);

	local send_ok = GET_CHILD_RECURSIVELY(frame, 'send_ok');
	send_ok:ShowWindow(1);

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();
	bodyGbox2:ShowWindow(1);	

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(0);

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local icon = slot:GetIcon();	
	if icon ~= nil and icon:GetInfo() ~= nil then
		ADD_RARE_OPTION_CTRLSET(bodyGbox2_1, icon:GetInfo():GetIESID());
	end

	_RAREOPTION_SET_JEWELL_ITEM(frame, nil);
end

function RAREOPTION_INIT_EXCEPT_TARGET(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	RAREOPTION_INIT(frame, false);
	RAREOPTION_UPDATE_BEFORE_OPTION(frame, GET_TARGET_SLOT_ITEM(frame));
end