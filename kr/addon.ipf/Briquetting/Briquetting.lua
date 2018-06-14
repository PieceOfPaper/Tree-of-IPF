-- briquetting.lua
function BRIQUETTING_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_BRIQUETTING', 'BRIQUETTING_REFRESH_INVENTORY_ICON');
end

function BRIQUETTING_UI_OPEN(frame)
	BRIQUETTING_UI_RESET(frame);
	ui.OpenFrame('inventory');
end

function BRIQUETTING_UI_CLOSE()
	ui.CloseFrame('inventory');
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
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl);
	local slot = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot or nil == invItem:GetObject() then
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

	if invItemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	if invItemObj.PR < 1 then
		ui.SysMsg(ClMsg('NoMorePotential'));
		return;
	end

	local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(parent:GetTopParentFrame(), 'look');
	if lookItemGuid == invItem:GetIESID() then
		return;
	end
	if lookItem ~= nil and invItemObj.ClassType ~= lookItem.ClassType then
		ui.SysMsg(ClMsg('NeedSameEquipClassType'));
		return;
	end
    
	-- 슬롯 박스에 이미지를 넣고
	SET_SLOT_ITEM_IMAGE(slot, invItem);

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

function BRIQUETTING_REFRESH_MATERIAL(frame)
	local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
	local materiaIimage = GET_CHILD_RECURSIVELY(frame, 'materiaIimage');
	local materialItemNameText = GET_CHILD_RECURSIVELY(frame, 'materialItemNameText');
	local materiaICount = GET_CHILD_RECURSIVELY(frame, 'materiaICount');
	local spendCount = GET_CHILD_RECURSIVELY(frame, 'spendCount');
	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText');

	local icon = targetSlot:GetIcon();
	if icon == nil then
		materiaIimage:SetTextByKey('txt', '');
		materialItemNameText:SetTextByKey('name', '');
		materiaICount:SetTextByKey('txt', 0);
		spendCount:SetTextByKey('txt', 0);
		priceText:SetTextByKey('price', 0);
	else
		local targetItem = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
		if targetItem == nil then
			return;
		end
		local needItemName, needItemCnt = GET_BRIQUETTING_NEED_MATERIAL_LIST(targetItem);		
		local needItemCls = GetClass('Item', needItemName);		
		materiaIimage:SetTextByKey('txt', string.format('{img %s 60 60}', needItemCls.Icon));
		materialItemNameText:SetTextByKey('name', needItemCls.Name);
		spendCount:SetTextByKey('txt', needItemCnt);

		local myNeedItemCount = session.GetInvItemCountByType(needItemCls.ClassID);
		materiaICount:SetTextByKey('txt', myNeedItemCount);

		local lookItem = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');		
		local price = 0;
		if targetItem ~= nil and lookItem ~= nil then
			price = GET_BRIQUETTING_PRICE(targetItem, lookItem, BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame));
		end
		priceText:SetTextByKey('price', price);
	end
end

function BRIQUETTING_SPEND_DROP(parent, ctrl)
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl);	
	local slot = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return;
	end

	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	local targetItem, targetItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(parent:GetTopParentFrame(), 'target');
	if targetItemGuid == invItem:GetIESID() then
		return;
	end

	if targetItem ~= nil and targetItem.ClassType ~= obj.ClassType then
		ui.SysMsg(ClMsg('NeedSameEquipClassType'));
		return;
	end

	-- 슬롯 박스에 이미지를 넣고
	SET_SLOT_ITEM_IMAGE(slot, invItem);
	local frame = parent:GetTopParentFrame();
	local slotNametext = GET_CHILD_RECURSIVELY(frame, "spendName");

	-- 이름을 표시한다.
	slotNametext:SetTextByKey("txt", obj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);
	BRIQUETTING_REFRESH_MATERIAL(frame);
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

function BRIQUETTING_SPEND_POP(parent)
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
    
	return invItem;
end

function BRIQUETTING_UI_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot = bodyGBox:GetChild("targetSlot");
	slot = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();
	
	local slotName = bodyGBox:GetChild("slotName");
	slotName:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotName);

	bodyGBox:RemoveChild('tooltip_only_pr');
	local nowPotentialStr = GET_CHILD_RECURSIVELY(frame, 'nowPotentialStr');
	nowPotentialStr:ShowWindow(0);

	local materialItemNameText = GET_CHILD_RECURSIVELY(frame, 'materialItemNameText');
	materialItemNameText:SetText('');

	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local slotCnt = lookMatItemSlotset:GetSlotCount();
	for i = 0, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		BRIQUETTING_POP_LOOK_MATERIAL_ITEM(nil, slot);
	end
	lookMatItemSlotset:ClearIconAll();

	BRIQUETTING_UI_SPEND_RESET(frame);
	BRIQUETTING_REFRESH_MATERIAL(frame, "");
end 

function BRIQUETTING_UI_SPEND_RESET(frame)
	local slot = GET_CHILD_RECURSIVELY(frame, "lookSlot");
	slot = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local slotNametext = GET_CHILD_RECURSIVELY(frame, "spendName");
	slotNametext:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotNametext);

	frame:SetUserValue('SELECT', 'None');
end

function BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame)	
	local lookMatItemSlotset = GET_CHILD_RECURSIVELY(frame, 'lookMatItemSlotset');
	local materialList = {};
	local materialGuidList = {};
	local slotCnt = lookMatItemSlotset:GetSlotCount();	
	for i = 0, slotCnt - 1 do
		local slot = lookMatItemSlotset:GetSlotByIndex(i);
		local guid = slot:GetUserValue('LOOK_MAT_ITEM_GUID');
		if guid ~= 'None' then
			local invItem = session.GetInvItemByGuid(guid);
			if invItem ~= nil and invItem:GetObject() ~= nil then
				materialList[#materialList + 1] = GetIES(invItem:GetObject());
				materialGuidList[#materialGuidList + 1] = guid;
			end
		end
	end

	return materialList, materialGuidList;
end

function BRIQUETTING_DROP_LOOK_MATERIAL_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
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

	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl);
	if invItem == nil or invItem:GetObject() == nil then
		return;
	end

	local materialList, materialGuidList = BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame);	
	local needLookMatItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(targetItem);
	if #materialList >= needLookMatItemCnt then
		ui.SysMsg(ClMsg('AlreadyEnoughLookMatItem'));
		return;
	end

	if invItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	local invItemObj = GetIES(invItem:GetObject());
	if invItemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
		return;
	end

	if lookItemGuid == invItem:GetIESID() then
		ui.SysMsg(ClMsg('AlreadyEqualItemRegistered'));
		return;
	end

	for i = 1, #materialGuidList do
		if materialGuidList[i] == invItem:GetIESID() then
			ui.SysMsg(ClMsg('AlreadyEqualItemRegistered'));
			return;
		end
	end

	if IS_VALID_LOOK_MATERIAL_ITEM(lookItem, {invItemObj}) == false then
		ui.SysMsg(ClMsg('WrongLookMaterialItem'));
		return;
	end

	SET_SLOT_ITEM_IMAGE(ctrl, invItem);
	ctrl:SetUserValue('LOOK_MAT_ITEM_GUID', invItem:GetIESID());
end

function BRIQUETTING_POP_LOOK_MATERIAL_ITEM(parent, ctrl)
	ctrl:SetUserValue('LOOK_MAT_ITEM_GUID', 'None');
	ctrl:ClearIcon();
end

function BRIQUETTING_SKILL_EXCUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local targetItem, targetItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'target');
	if targetItem == nil then
		return;
	end

	local lookItem, lookItemGuid = BRIQUETTING_GET_SLOT_ITEM_OBJECT(frame, 'look');
	if lookItem == nil then
		return;
	end

	local needLookMatItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(targetItem);
	local lookMatItemList, lookMatItemGuidList = BRIQUETTING_GET_LOOK_MATERIAL_LIST(frame);
	if #lookMatItemList ~= needLookMatItemCnt then		
		ui.SysMsg(ScpArgMsg('MustRegister{COUNT}LookMatItem', 'COUNT', needLookMatItemCnt));
		return;
	end

	if IS_VALID_LOOK_MATERIAL_ITEM(lookItem, lookMatItemList) == false then
		ui.SysMsg(ClMsg('WrongLookMaterialItem'));
		return;
	end

	local moneyItem = GetClass('Item', MONEY_NAME);
	local myMoney = session.GetInvItemCountByType(moneyItem.ClassID);
	local price = GET_BRIQUETTING_PRICE(targetItem, lookItem, lookMatItemList);
	if myMoney < price then
		ui.SysMsg(ClMsg('Auto_SilBeoKa_BuJogHapNiDa'));
		return;
	end

	local materiaICount = GET_CHILD_RECURSIVELY(frame, 'materiaICount');
	local needItemName, needItemCnt = GET_BRIQUETTING_NEED_MATERIAL_LIST(targetItem);
	if tonumber(materiaICount:GetTextByKey('txt')) < needItemCnt then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end

	 session.shop.ClearBriquetting();
	 session.shop.AddBriquettingGuid(targetItemGuid);
	 session.shop.AddBriquettingGuid(lookItemGuid);
	 for i = 1, #lookMatItemGuidList do
	 	session.shop.AddBriquettingGuid(lookMatItemGuidList[i]);
	 end
	 session.shop.ExecuteBriquetting();
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