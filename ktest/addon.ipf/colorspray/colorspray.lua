local RollbackBriquettingUI = {
	-- vars
	_frame = nil,
	_targetItemGuid = '0',

	-- functions
	SetFrame = function(self, frame)
		self._frame = frame;
	end,
	Reset = function(self)
		local frame = self._frame;
		local beforeSlot = GET_CHILD_RECURSIVELY(frame, 'beforeSlot');
		local afterSlot = GET_CHILD_RECURSIVELY(frame, 'afterSlot');
		if beforeSlot:GetIcon() ~= nil then
			local beforeSlotItemGuid = beforeSlot:GetIcon():GetInfo():GetIESID();
			SELECT_INV_SLOT_BY_GUID(beforeSlotItemGuid, 0);
		end
		beforeSlot:ClearIcon();
		afterSlot:ClearIcon();

		local beforeNameText = GET_CHILD_RECURSIVELY(frame, 'beforeNameText');
		local afterNameText = GET_CHILD_RECURSIVELY(frame, 'afterNameText');
		beforeNameText:ShowWindow(0);
		afterNameText:ShowWindow(0);
	end,
	IsEmpty = function(self)
		local frame = self._frame;		
		local beforeSlot = GET_CHILD_RECURSIVELY(frame, 'beforeSlot');
		return beforeSlot:GetIcon() == nil;
	end,
	SetTargetSlot = function(self, invSlot, itemGuid)
		local invItem = session.GetInvItemByGuid(itemGuid);
		if invItem == nil then
			return;
		end
		if invItem.isLockState == true then
			ui.SysMsg(ClMsg('WebService_45'));
			return;
		end

		local frame = self._frame;
		local itemobj = GetIES(invItem:GetObject());
		if TryGetProp(itemobj, 'BriquettingIndex', 0) == 0 then
			ui.SysMsg(ClMsg('OnlyBriquettingItem'));
			return;
		end

		local beforeSlot = GET_CHILD_RECURSIVELY(frame, 'beforeSlot');
		imcSlot:SetItemInfo(beforeSlot, invItem, 1);

		local afterSlot = GET_CHILD_RECURSIVELY(frame, 'afterSlot');
		local modifiedString = GET_MODIFIED_PROPERTIES_STRING(itemobj);
		local linkInfo = session.link.CreateOrGetGCLinkObject(itemobj.ClassID, modifiedString);
		local virtualObj = GetIES(linkInfo:GetObject());
		virtualObj.BriquettingIndex = 0;

		local icon = afterSlot:GetIcon();
		if icon == nil then
			icon = CreateIcon(afterSlot);
		end

		APPRAISER_FORGERY_SET_TOOLTIP(icon, virtualObj);
		icon:SetImage(itemobj.Icon);

		local beforeNameText = GET_CHILD_RECURSIVELY(frame, 'beforeNameText');
		beforeNameText:SetTextByKey('name', itemobj.Name);
		beforeNameText:ShowWindow(1);

		local afterNameText = GET_CHILD_RECURSIVELY(frame, 'afterNameText');
		afterNameText:SetTextByKey('name', itemobj.Name);
		afterNameText:ShowWindow(1);

		invSlot:SetSelectedImage('socket_slot_check');
		invSlot:Select(1);
	end,
	SetTargetItemGuid = function(self, guid)
		self._targetItemGuid = guid;
	end,
	GetTargetItemGuid = function(self)
		return self._targetItemGuid;
	end,
	GetTargetEquipItemGuid = function(self)
		local frame = self._frame;
		local beforeSlot = GET_CHILD_RECURSIVELY(frame, 'beforeSlot');
		local icon = beforeSlot:GetIcon();
		if icon == nil then	
			return nil;
		end
		return icon:GetInfo():GetIESID();
	end,
};

function USE_ROLLBACK_BRIQUETTING_ITEM(invItem)
	RollbackBriquettingUI:SetTargetItemGuid(invItem:GetIESID());
	ui.OpenFrame('colorspray');
end

function OPEN_ROLLBACK_BRIQUETTING(frame)
	RollbackBriquettingUI:SetFrame(frame);
	RollbackBriquettingUI:Reset();	
	INVENTORY_SET_CUSTOM_RBTNDOWN('ROLLBACK_BRIQUETTING_INV_RBTN_CLICK');
	INVENTORY_SET_ICON_SCRIPT('ROLLBACK_BRIQUETTING_ICON_SCP');
end

function CLOSE_ROLLBACK_BRIQUETTING(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN('None');
	RESET_INVENTORY_ICON();
end

function DROP_ROLLBACK_BRIQUETTING_TARGET(parent, ctrl)	
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local itemGuid = iconInfo:GetIESID();
	local invSlot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	RollbackBriquettingUI:SetTargetSlot(invSlot, itemGuid);
end

function POP_ROLLBACK_BRIQUETTING_TARGET(parent, ctrl)
	RollbackBriquettingUI:Reset();
end

function IMPL_EXEC_ROLLBACK_BRIQUETTING(rollbackItemGuid, equipItemGuid)
	session.ResetItemList();
	session.AddItemID(rollbackItemGuid, 1);
	session.AddItemID(equipItemGuid, 1);
    local resultlist = session.GetItemIDList();
	item.DialogTransaction('EXECUTE_ROLLBACK_BRIQUETTING', resultlist);

	ui.CloseFrame('colorspray');
	ui.CloseFrame('inventory');	
end

function EXEC_ROLLBACK_BRIQUETTING(parent, ctrl)
	local rollbackItemGuid = RollbackBriquettingUI:GetTargetItemGuid();
	local equipItemGuid = RollbackBriquettingUI:GetTargetEquipItemGuid();
	if rollbackItemGuid == nil or equipItemGuid == nil then
		ui.SysMsg(ClMsg('DropTargetItemFirst'));
		return;
	end

	local rollbackInvItem = session.GetInvItemByGuid(rollbackItemGuid);
	local equipInvItem = session.GetInvItemByGuid(equipItemGuid);
	if rollbackInvItem == nil or rollbackInvItem.isLockState == true or equipInvItem == nil or equipInvItem.isLockState == true then
		return;
	end

	if TryGetProp(GetIES(equipInvItem:GetObject()), 'Rebuildchangeitem', 0) > 0 then
		ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), 'IMPL_EXEC_ROLLBACK_BRIQUETTING("'..rollbackItemGuid..'", "'..equipItemGuid..'")', 'None');
		return;
	end

	IMPL_EXEC_ROLLBACK_BRIQUETTING(rollbackItemGuid, equipItemGuid);
end

function ROLLBACK_BRIQUETTING_INV_RBTN_CLICK(itemObj, invSlot, invItemGuid)
	if RollbackBriquettingUI:IsEmpty() == false then
		return;
	end
	RollbackBriquettingUI:SetTargetSlot(invSlot, invItemGuid);
end

function ROLLBACK_BRIQUETTING_ICON_SCP(slot, reinfItemObj, invItem, itemobj)	
	local icon = slot:GetIcon();
	if itemobj ~= nil then
		if TryGetProp(itemobj, 'BriquettingIndex', 0) ~= 0 then
			icon:SetColorTone("FFFFFFFF");
		else
			icon:SetColorTone("33000000");
		end
		return;
	end		
	
	if icon ~= nil then
		icon:SetColorTone("AA000000");
	end
end