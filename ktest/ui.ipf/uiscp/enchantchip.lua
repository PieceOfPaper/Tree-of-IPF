-- ENCHANTCHIP.lua --

function CLIENT_ENCHANTCHIP(invItem)
	local mapCls = GetClass("Map", session.GetMapName());
	if nil == mapCls then
		return;
	end

	if 'City' ~= mapCls.MapType then
		ui.SysMsg(ClMsg("AllowedInTown"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if 0 == IS_ENCHANT_ITEM(obj) then
		return;
	end
	
	-- check life time of enchant item
	if TryGetProp(obj, "LifeTime") > 0 and TryGetProp(obj, "ItemLifeTimeOver") > 0 then
		return
	end

	HAIRENCHANT_UI_RESET();

	local enchantFrame = ui.GetFrame("hairenchant");
	local invframe = ui.GetFrame("inventory");
	invframe:ShowWindow(1);
	enchantFrame:ShowWindow(1);
	enchantFrame:SetMargin(0, 65, invframe:GetWidth(), 0);
	enchantFrame:SetUserValue("Enchant", invItem:GetIESID());
	local cnt = enchantFrame:GetChild("scrollCnt");
	cnt:SetTextByKey("value", tostring(invItem.count));
	
	ui.SetEscapeScp("CANCEL_ENCHANTCHIP()");

	SET_SLOT_APPLY_FUNC(invframe, "CHECK_ENCHANTCHIP_TARGET_ITEM", nil, "Equip");
	local tab = GET_CHILD_RECURSIVELY(invframe, "inventype_Tab");
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(1);

	SET_INV_LBTN_FUNC(invframe, "ENCHANTCHIP_LBTN_CLICK");
	ui.GuideMsg("SelectItem");
	CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_ENCHANTCHIP");
end


function CANCEL_ENCHANTCHIP()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	HAIRENCHANT_UI_RESET();
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	SET_INV_LBTN_FUNC(invframe, "None");
	RESET_MOUSE_CURSOR();
end

function CURSOR_CHECK_ENCHANTCHIP(slot)
	local item = GET_SLOT_ITEM(slot);
	if item == nil then
		return 0;
	end
	
	if nil ~= session.GetEquipItemByGuid(item:GetIESID()) then
		return 0;
	end

	local obj = GetIES(item:GetObject());
	return ENCHANTCHIP_ABLIE(obj);
end

function CHECK_ENCHANTCHIP_TARGET_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end

	local obj = GetIES(item:GetObject());
	if ENCHANTCHIP_ABLIE(obj) == 1 then
		slot:GetIcon():SetGrayStyle(0);
		slot:SetBlink(60000, 2.0, "FFFFFF00", 1);
	else
		slot:GetIcon():SetGrayStyle(1);
		slot:ReleaseBlink();
	end
end

function ENCHANTCHIP_LBTN_CLICK(frame, invItem)
	local enchantFrame = ui.GetFrame("hairenchant");
	local slot = enchantFrame:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	HAIRENCHANT_DRAW_HIRE_ITEM(slot, invItem);
end