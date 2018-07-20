-- briquetting.lua
function BRIQUETTING_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_BRIQUETTING', 'BRIQUETTING_REFRESH_INVENTORY_ICON');
end

function BRIQUETTING_UI_OPEN(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN('BRIQUETTING_INVENTORY_RBTN_CLICK');
	BRIQUETTING_UI_RESET(frame);
	ui.OpenFrame('inventory');
end

function BRIQUETTING_UI_CLOSE()
	INVENTORY_SET_CUSTOM_RBTNDOWN('None');
	ui.CloseFrame('inventory');
	local inventory = ui.GetFrame('inventory');	
	INVENTORY_UPDATE_ICONS(inventory);	
end

function BRIQUETTING_SLOT_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_RESET(frame);
end

function BRIQUETTING_SLOT_SET(richtxt, item)
	if nil == item then
		richtxt:SetTextByKey("guid", "");
		richtxt:SetTextByKey("itemtype", "");
		return;
	end
	richtxt:SetTextByKey("guid", item:GetIESID());
	richtxt:SetTextByKey("itemtype", item.type);
end

function BRIQUETTING_SLOT_DROP(parent, ctrl)	
	local frame = parent:GetTopParentFrame();
	local invItem, invSlot = BRIQUETTING_SLOT_ITEM(parent, ctrl);
	if nil == invItem or nil == ctrl or nil == invItem:GetObject() then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local invItemObj = GetIES(invItem:GetObject());
	if invItemObj == nil then
		return;
	end

	local slot = tolua.cast(ctrl, 'ui::CSlot');
	BRIQUETTING_SET_TARGET_SLOT(frame, invItemObj, invSlot, slot, invItem:GetIESID());
end

function BRIQUETTING_SET_TARGET_SLOT(frame, invItemObj, invSlot, targetSlot, invItemGuid)	
	local invItem = session.GetInvItemByGuid(invItemGuid);
	if invItem == nil then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if invItemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');
	if lookItemGuid == invItemGuid then
		return;
	end	
	if lookItem ~= nil and invItemObj.ClassType ~= lookItem.ClassType then
		ui.SysMsg(ClMsg('NeedSameEquipClassType'));
		return;
	end

	if IS_VALID_BRIQUETTING_TARGET_ITEM(invItemObj) == false then
		ui.SysMsg(ScpArgMsg('InvalidTargetFor{CONTENTS}', 'CONTENTS', ClMsg('Briquetting')));
		return;
	end

	if targetSlot:GetUserValue('SELECTED_INV_GUID') ~= 'None' then
		BRIQUETTING_SELECT_INVENTORY_ITEM(targetSlot, 0);
	end

	BRIQUETTING_SELECT_INVENTORY_ITEM(invSlot, 1);
	targetSlot:SetUserValue('SELECTED_INV_GUID', invItemGuid);
    
	-- 슬롯 박스에 이미지를 넣고
	SET_SLOT_ITEM_IMAGE(targetSlot, invItem);

	local bodyGBox = frame:GetChild("bodyGbox");
	local slotNametext = bodyGBox:GetChild("slotName");
	bodyGBox:RemoveChild('tooltip_only_pr');
	local nowPotential = bodyGBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 40, 290);
	local nowPotentialStr = GET_CHILD_RECURSIVELY(frame, 'nowPotentialStr');
	tolua.cast(nowPotential, "ui::CControlSet");	
	local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(invItemObj.PR, invItemObj.MaxPR);	
	local pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
    local labelline = nowPotential:GetChild('labelline');
	pr_txt:SetVisible(0);
    labelline:SetVisible(0);
    nowPotentialStr:ShowWindow(1);

	-- 이름을 표시한다.
	slotNametext:SetTextByKey("txt", invItemObj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);
	BRIQUETTING_REFRESH_MATERIAL(frame);
end

function BRIQUETTING_SELECT_INVENTORY_ITEM(slot, isSelect)
	slot = AUTO_CAST(slot);
	if isSelect == 1 then
		slot:SetSelectedImage('socket_slot_check');
		slot:Select(1);
	else
		local guid = slot:GetUserValue('SELECTED_INV_GUID');
		if guid == 'None' then
			return;
		end

		local invSlot = GET_SLOT_BY_ITEMID(nil, guid);
		if invSlot == nil then
			return;
		end
		invSlot:Select(0);
	end
end

function BRIQUETTING_REFRESH_MATERIAL(frame)
	local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText');

	local icon = targetSlot:GetIcon();
	if icon == nil then
		priceText:SetTextByKey('price', 0);
	else
		local targetItem = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
		local lookItem = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');		
		local price = 0;		
		if targetItem ~= nil and lookItem ~= nil then
			price = GET_BRIQUETTING_PRICE(targetItem, lookItem, BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame));			

			local prCheck = GET_CHILD_RECURSIVELY(frame, 'prCheck');
			if prCheck:IsChecked() == 0 then
				price = 0;
			end
		end
		priceText:SetTextByKey('price', GetCommaedString(price));

		local moneyItem = GetClass('Item', MONEY_NAME);
		local myMoney = session.GetInvItemCountByType(moneyItem.ClassID);		
		if myMoney < price then
			local NOT_ENOUGH_PRICE_STYLE = frame:GetUserConfig('NOT_ENOUGH_PRICE_STYLE');
			priceText:SetTextByKey('style', NOT_ENOUGH_PRICE_STYLE);
		else
			local ENOUGH_PRICE_STYLE = frame:GetUserConfig('ENOUGH_PRICE_STYLE');
			priceText:SetTextByKey('style', ENOUGH_PRICE_STYLE);
		end
	end
end

function BRIQUETTING_SPEND_DROP(parent, ctrl)
	local invItem, invSlot = BRIQUETTING_SLOT_ITEM(parent, ctrl);	
	local slot = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return;
	end

	BRIQUETTING_SET_LOOK_ITEM(parent:GetTopParentFrame(), obj, invSlot, slot, invItem:GetIESID());
end

g_invSlot = nil;
function BRIQUETTING_SET_LOOK_ITEM(frame, itemObj, invSlot, lookSlot, invItemGuid)
	local invItem = session.GetInvItemByGuid(invItemGuid);
	if invItem == nil then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	local targetItem, targetItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
	if targetItemGuid == invItemGuid then
		return;
	end

	if targetItem ~= nil and targetItem.ClassType ~= itemObj.ClassType then
		ui.SysMsg(ClMsg('NeedSameEquipClassType'));
		return;
	end

	if itemObj.BriquettingIndex > 0 then
		ui.SysMsg(ClMsg('CannotBriquettingBecauseAlready'));
		return;
	end

	if IS_VALID_LOOK_ITEM(itemObj) == false then
		ui.SysMsg(ScpArgMsg('InvalidTargetFor{CONTENTS}', 'CONTENTS', ClMsg('Briquetting')));
		return;
	end

	g_invSlot = invSlot;
	if IS_ENCHANTED_ITEM(itemObj) == true then
		local yesscp = string.format('_BRIQUETTING_SET_LOOK_ITEM("%s")', invItemGuid);
		ui.MsgBox(ClMsg('EnchantedItemForBriquetting'), yesscp, 'None');
		return;
	end
	_BRIQUETTING_SET_LOOK_ITEM(invItemGuid);
end

function _BRIQUETTING_SET_LOOK_ITEM(invItemGuid)
	local invItem = session.GetInvItemByGuid(invItemGuid);
	if invItem == nil or invItem:GetObject() == nil or invItem.isLockState == true then
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if itemObj == nil then
		return;
	end

	local frame = ui.GetFrame('briquetting');
	local lookSlot = GET_CHILD_RECURSIVELY(frame, 'lookSlot');
	if lookSlot:GetUserValue('SELECTED_INV_GUID') ~= 'None' then
		BRIQUETTING_SELECT_INVENTORY_ITEM(lookSlot, 0);
	end

	local invSlot = g_invSlot;

	-- 슬롯 박스에 이미지를 넣고
	BRIQUETTING_SELECT_INVENTORY_ITEM(invSlot, 1);	
	lookSlot:SetUserValue('SELECTED_INV_GUID', invItemGuid);

	SET_SLOT_ITEM_IMAGE(lookSlot, invItem);
	local slotNametext = GET_CHILD_RECURSIVELY(frame, "spendName");
	local matInfoText = GET_CHILD_RECURSIVELY(frame, 'matInfoText');
	matInfoText:ShowWindow(1);

	-- 이름을 표시한다.
	slotNametext:SetTextByKey("txt", itemObj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);
	BRIQUETTING_REFRESH_MATERIAL(frame);
	BRIQUETTING_INIT_LOOK_MATERIAL_LIST(frame, itemObj);
end

function BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, type)
	local targetSlot = GET_CHILD_RECURSIVELY(frame, type..'Slot');
	if targetSlot:GetIcon() == nil then
		return nil;
	end

	local invItem = session.GetInvItemByGuid(targetSlot:GetIcon():GetInfo():GetIESID());
	if invItem == nil or invItem:GetObject() == nil then
		return nil;
	end

	return GetIES(invItem:GetObject()), invItem:GetIESID();
end

function BRIQUETTING_SPEND_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_RESET(frame);
end

function BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return nil;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return nil;
	end
	
	if iconInfo == nil or invItem == nil then
		return nil;
	end
    
	return invItem, liftIcon:GetParent();
end

function BRIQUETTING_UI_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot = bodyGBox:GetChild("targetSlot");
	slot = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();
	BRIQUETTING_SELECT_INVENTORY_ITEM(slot, 0);
	
	local slotName = bodyGBox:GetChild("slotName");
	slotName:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotName);

	bodyGBox:RemoveChild('tooltip_only_pr');
	local nowPotentialStr = GET_CHILD_RECURSIVELY(frame, 'nowPotentialStr');
	nowPotentialStr:ShowWindow(0);

	local lookSlot = GET_CHILD_RECURSIVELY(frame, 'lookSlot');
	BRIQUETTING_SELECT_INVENTORY_ITEM(lookSlot, 0);

	BRIQUETTING_INIT_LOOK_MATERIAL_LIST(frame);
	BRIQUETTING_UI_SPEND_RESET(frame);
	BRIQUETTING_REFRESH_MATERIAL(frame, "");
	BRIQUETTING_INIT_PR_CHECK(frame);	
end 

function BRIQUETTING_UI_SPEND_RESET(frame)
	local slot = GET_CHILD_RECURSIVELY(frame, "lookSlot");
	slot = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local slotNametext = GET_CHILD_RECURSIVELY(frame, "spendName");
	slotNametext:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotNametext);

	frame:SetUserValue('SELECT', 'None');

	local matInfoText = GET_CHILD_RECURSIVELY(frame, 'matInfoText');
	matInfoText:ShowWindow(0);
end

function BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame)	
	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local materialList = {};
	local materialGuidList = {};
	local slotCnt = lookMatItemSlotset:GetSlotCount();	
	for i = 0, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		local guid = slot:GetUserValue('SELECTED_INV_GUID');
		if slot:IsVisible() == 1 and guid ~= 'None' then
			local invItem = session.GetInvItemByGuid(guid);
			if invItem ~= nil and invItem:GetObject() ~= nil then
				materialList[#materialList + 1] = GetIES(invItem:GetObject());
				materialGuidList[#materialGuidList + 1] = guid;
			else
				ui.SysMsg(ClMsg('InvalidItemRegisterStep'));
				ui.CloseFrame('briquetting');
				return nil, nil, false;
			end
		end
	end

	return materialList, materialGuidList, true;
end

function BRIQUETTING_DROP_LOOK_MATERIAL_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	local invItem, invSlot = BRIQUETTING_SLOT_ITEM(parent, ctrl);	
	if invItem == nil or invItem:GetObject() == nil then
		return;
	end

	local invItemObj = GetIES(invItem:GetObject());
	BRIQUETTING_ADD_LOOK_MATERIAL_ITEM(frame, invItemObj, invSlot, invItem:GetIESID(), ctrl);
end

function BRIQUETTING_ADD_LOOK_MATERIAL_ITEM(frame, invItemObj, invSlot, invItemGuid, lookMatSlot)		
	local invItem = session.GetInvItemByGuid(invItemGuid);
	if invItem == nil then
		return;
	end

	local targetItem = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
	if targetItem == nil then
		ui.SysMsg(ClMsg('DropTargetItemFirst'));
		return;
	end

	local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');
	if lookItem == nil then
		ui.SysMsg(ClMsg('DropLookItemFirst'));
		return;
	end

	local materialList, materialGuidList = BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame);	
	local needLookMatItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(lookItem);
	if #materialList >= needLookMatItemCnt then
		ui.SysMsg(ClMsg('AlreadyEnoughLookMatItem'));
		return;
	end

	if invItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	if invItemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	if lookItemGuid == invItemGuid then
		ui.SysMsg(ClMsg('AlreadyEqualItemRegistered'));
		return;
	end

	for i = 1, #materialGuidList do
		if materialGuidList[i] == invItemGuid then
			ui.SysMsg(ClMsg('AlreadyEqualItemRegistered'));
			return;
		end
	end

    local result, containDummyItem, containCoreItem = IS_VALID_LOOK_MATERIAL_ITEM(lookItem, {invItemObj});
	if result == false then		
		ui.SysMsg(ClMsg('WrongLookMaterialItem'));
		return;
	end

	g_invSlot = invSlot;
	if IS_ENCHANTED_ITEM(invItemObj) == true then
		local yesscp = string.format('_BRIQUETTING_ADD_LOOK_MATERIAL_ITEM("%s", "%s", ', lookMatSlot:GetName(), invItemGuid, containCoreItem);
		if containCoreItem == true then
			yesscp = yesscp..'true)';
		else
			yesscp = yesscp..'false)';
		end
		ui.MsgBox(ClMsg('EnchantedItemForBriquetting'), yesscp, 'None');
		return;
	end
	_BRIQUETTING_ADD_LOOK_MATERIAL_ITEM(lookMatSlot:GetName(), invItemGuid, containCoreItem);
end

function _BRIQUETTING_ADD_LOOK_MATERIAL_ITEM(lookMatSlotName, invItemGuid, containCoreItem)
	local frame = ui.GetFrame('briquetting');
	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local lookMatSlot = GET_CHILD(lookMatItemSlotset, lookMatSlotName);
	local invSlot = g_invSlot;
	local invItem = session.GetInvItemByGuid(invItemGuid);
	if invItem == nil or invItem:GetObject() == nil or invItem.isLockState == true then
		return;
	end

	if lookMatSlot:GetUserValue('SELECTED_INV_GUID') ~= 'None' then
		BRIQUETTING_SELECT_INVENTORY_ITEM(lookMatSlot, 0);
	end

	BRIQUETTING_SELECT_INVENTORY_ITEM(invSlot, 1);
	lookMatSlot:SetUserValue('SELECTED_INV_GUID', invItemGuid);

	if containCoreItem == true then
		BRIQUETTING_SET_CORE_ITEM(frame, invItem);
		return;
	end

	SET_SLOT_ITEM_IMAGE(lookMatSlot, invItem);
	lookMatSlot:SetUserValue('SELECTED_INV_GUID', invItemGuid);
	BRIQUETTING_REFRESH_MATERIAL(frame);
end

function BRIQUETTING_SET_CORE_ITEM(frame, coreItem)
	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local firstSlot = lookMatItemSlotset:GetSlotByIndex(0);
	BRIQUETTING_SELECT_INVENTORY_ITEM(firstSlot, 0);
	SET_SLOT_ITEM_IMAGE(firstSlot, coreItem);
	firstSlot:SetUserValue('SELECTED_INV_GUID', coreItem:GetIESID());
	BRIQUETTING_REFRESH_MATERIAL(frame);

	local slotCnt = lookMatItemSlotset:GetSlotCount();
	for i = 1, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		BRIQUETTING_SELECT_INVENTORY_ITEM(slot, 0);
		slot:SetUserValue('SELECTED_INV_GUID', 'None');
		slot:ClearIcon();
		slot:ShowWindow(0);		
	end
end

function BRIQUETTING_POP_LOOK_MATERIAL_ITEM(parent, ctrl)
	ctrl:ClearIcon();
	BRIQUETTING_SELECT_INVENTORY_ITEM(ctrl, 0);
	ctrl:SetUserValue('SELECTED_INV_GUID', 'None');

	if parent ~= nil then
		local frame = parent:GetTopParentFrame();
		local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');
		if lookItem ~= nil then
			BRIQUETTING_INIT_LOOK_MATERIAL_LIST(frame, lookItem);
		end
		BRIQUETTING_REFRESH_MATERIAL(frame);
	end
end

function BRIQUETTING_SKILL_EXCUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local targetItem, targetItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
	if targetItem == nil then
		local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
		if targetSlot:GetIcon() ~= nil then
			ui.SysMsg(ClMsg('InvalidItemRegisterStep'));
			ui.CloseFrame('briquetting');
		else
			ui.SysMsg(ClMsg('PleaseRegisterBriquettingTarget'));			
		end
		return;
	end

	local prCheck = GET_CHILD_RECURSIVELY(frame, 'prCheck');
	if prCheck:IsChecked() == 0 and targetItem.PR < 1 then
		ui.SysMsg(ClMsg('NoMorePotential'));
		return;
	end

	local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');
	if lookItem == nil then
		local lookSlot = GET_CHILD_RECURSIVELY(frame, 'lookSlot');
		if lookSlot:GetIcon() ~= nil then
			ui.SysMsg(ClMsg('InvalidItemRegisterStep'));
			ui.CloseFrame('briquetting');
		else
			ui.SysMsg(ClMsg('PleaseRegisterBriquettingLook'));
		end
		return;
	end

	local needLookMatItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(lookItem);
	local lookMatItemList, lookMatItemGuidList, validate = BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame);
	if validate == false then
		return;
	end

	local result, containDummyItem, containCoreItem = IS_VALID_LOOK_MATERIAL_ITEM(lookItem, lookMatItemList);
	if result == false then
		ui.SysMsg(ClMsg('WrongLookMaterialItem'));
		return;
	end

	if containDummyItem == false then -- 제물 재료 필요한 경우
		if containCoreItem == true then			
			if #lookMatItemList ~= 1 then
				ui.SysMsg(ScpArgMsg('MustRegister{COUNT}LookMatItem', 'COUNT', needLookMatItemCnt));
				return;
			end
		else
			if #lookMatItemList ~= needLookMatItemCnt then
				ui.SysMsg(ScpArgMsg('MustRegister{COUNT}LookMatItem', 'COUNT', needLookMatItemCnt));
				return;
			end
		end
	else
		if #lookMatItemList ~= 0 then
			return;
		end
	end

	local moneyItem = GetClass('Item', MONEY_NAME);
	local myMoney = session.GetInvItemCountByType(moneyItem.ClassID);
	local price = GET_BRIQUETTING_PRICE(targetItem, lookItem, lookMatItemList);
	if prCheck:IsChecked() == 0 then
		price = 0;
	end
	if myMoney < price then
		ui.SysMsg(ClMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	frame:SetUserValue('BRIQUETTING_TARGET_GUID', targetItemGuid);
	frame:SetUserValue('BRIQUETTING_LOOK_GUID', lookItemGuid);
	local clmsg = '';
	if prCheck:IsChecked() == 0 and containCoreItem == false then
		clmsg = ScpArgMsg('ReallyBriquetting', 'BEFORE', targetItem.Name, 'AFTER', lookItem.Name);
	else
		clmsg = ScpArgMsg('BriquettingResult', 'BEFORE', targetItem.Name, 'AFTER', lookItem.Name);
	end
	WARNINGMSGBOX_FRAME_OPEN(clmsg, 'IMPL_BRIQUETTING_SKILL_EXCUTE', 'None');
end

function IMPL_BRIQUETTING_SKILL_EXCUTE()
	local frame = ui.GetFrame('briquetting');
	_BRIQUETTING_SKILL_EXCUTE(frame:GetUserValue('BRIQUETTING_TARGET_GUID'), frame:GetUserValue('BRIQUETTING_LOOK_GUID'));
end

function _BRIQUETTING_SKILL_EXCUTE(targetItemGuid, lookItemGuid)
	local frame = ui.GetFrame('briquetting');	
	local prCheck = GET_CHILD_RECURSIVELY(frame, 'prCheck');
	local lookMatItemList, lookMatItemGuidList = BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame);	

 	session.shop.ClearBriquetting();
	session.shop.AddBriquettingGuid(targetItemGuid);
	session.shop.AddBriquettingGuid(lookItemGuid);
	for i = 1, #lookMatItemGuidList do
	 	session.shop.AddBriquettingGuid(lookMatItemGuidList[i]);	 	
	end

	session.shop.ExecuteBriquetting(prCheck:IsChecked());
	ui.CloseFrame('briquetting');
end

function BRIQUETTING_REFRESH_INVENTORY_ICON(frame, msg, guid, argNum)
	BRIQUETTING_UI_RESET(frame);

	local inventory = ui.GetFrame('inventory');
	if inventory == nil or inventory:IsVisible() ~= 1 then
		return;
	end

    local invItem = session.GetInvItemByGuid(guid);
    if invItem == nil then
    	return;
    end

    local itemSlot = INV_GET_SLOT_BY_ITEMGUID(mainGuid, inventory);
	if itemSlot ~= nil then
		INV_SLOT_UPDATE(inventory, invItem, itemSlot);
	end	
end

function BRIQUETTING_INIT_LOOK_MATERIAL_LIST(frame, lookItem)
	local needLookMatItemCnt = 0;
	if lookItem ~= nil then
		needLookMatItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(lookItem);		
	end

	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local slotCnt = lookMatItemSlotset:GetSlotCount();
	for i = 0, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		BRIQUETTING_POP_LOOK_MATERIAL_ITEM(nil, slot);

		if i < needLookMatItemCnt then
			slot:ShowWindow(1);
		else
			slot:ShowWindow(0);
		end
	end
	lookMatItemSlotset:ClearIconAll();		
end

function BRIQUETTING_INIT_PR_CHECK(frame)
	local prCheck = GET_CHILD_RECURSIVELY(frame, 'prCheck');
	prCheck:SetCheck(1);
	frame:SetUserValue('BEFORE_CHECK_VALUE', 1);
end

function BRIQUETTING_CLICK_PR_CHECK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local afterCheckValue = ctrl:IsChecked();
	if afterCheckValue == 0 then
		ctrl:SetCheck(1);
		ui.MsgBox(ClMsg('BriquettingAlert'), '_BRIQUETTING_CLICK_PR_CHECK()', 'None');
	else		
		BRIQUETTING_REFRESH_MATERIAL(frame);
	end
end

function _BRIQUETTING_CLICK_PR_CHECK()
	local frame = ui.GetFrame('briquetting');
	local prCheck = GET_CHILD_RECURSIVELY(frame, 'prCheck');
	prCheck:SetCheck(0);
	BRIQUETTING_REFRESH_MATERIAL(frame);
end

function BRIQUETTING_INVENTORY_RBTN_CLICK(itemObj, invSlot, invItemGuid)
	local frame = ui.GetFrame('briquetting');
	if invSlot:IsSelected() == 1 then
		BRIQUETTING_UI_RESET(frame);
	else
		if BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target') == nil then
			local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
			BRIQUETTING_SET_TARGET_SLOT(frame, itemObj, invSlot, targetSlot, invItemGuid);
		elseif BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look') == nil then
			local lookSlot = GET_CHILD_RECURSIVELY(frame, 'lookSlot');
			BRIQUETTING_SET_LOOK_ITEM(frame, itemObj, invSlot, lookSlot, invItemGuid);
		else
			local lookMatSlot = GET_BRIQUETTING_EMPTY_LOOK_MATERIAL_SLOT(frame);
			if lookMatSlot ~= nil then
				BRIQUETTING_ADD_LOOK_MATERIAL_ITEM(frame, itemObj, invSlot, invItemGuid, lookMatSlot)
			end
		end
	end
end

function GET_BRIQUETTING_EMPTY_LOOK_MATERIAL_SLOT(frame)
	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local slotCnt = lookMatItemSlotset:GetSlotCount();
	for i = 0, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		local guid = slot:GetUserValue('SELECTED_INV_GUID');
		if slot:IsVisible() == 1 and guid == 'None' then
			return slot;
		end		
	end
	return nil;
end

function IS_ENCHANTED_ITEM(item)
	if item ~= nil and (TryGetProp(item, 'Reinforce_2', 0) > 0 or TryGetProp(item, 'Transcend', 0) > 0) then
		return true;
	end
	return false;
end