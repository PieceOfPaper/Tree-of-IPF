-- ENCHANTCHIP.lua --

enchantGuid = "";

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
	
	ui.GuideMsg("SelectItem");
	local invframe = ui.GetFrame("inventory");
	local gbox = invframe:GetChild("inventoryGbox");
	local x, y = GET_GLOBAL_XY(gbox);
	x = x - gbox:GetWidth() * 0.7;
	y = y - 40;
	SET_MOUSE_FOLLOW_BALLOON(ClMsg("ClickItemToReinforce"), 0, x, y);
	ui.SetEscapeScp("CANCEL_ENCHANTCHIP()");

	enchantGuid = invItem:GetIESID();
	SET_SLOT_APPLY_FUNC(invframe, "CHECK_ENCHANTCHIP_TARGET_ITEM");
	SET_INV_LBTN_FUNC(invframe, "ENCHANTCHIP_LBTN_CLICK");

	CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_ENCHANTCHIP");
end

function ENCHANTCHIP_SUCEECD()
	imcSound.PlaySoundEvent("premium_enchantchip");
end

function CANCEL_ENCHANTCHIP()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	enchantGuid = "";
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
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if ENCHANTCHIP_ABLIE(obj) == 0 then
		ui.SysMsg(ClMsg("ItemIsNotEnchantable1"));
		return;
	end

	local itemIES = invItem:GetIESID();
	if nil ~= session.GetEquipItemByGuid(itemIES) then
		ui.SysMsg(ClMsg("CantRegisterEquipItemToEnchant"));
		return;
	end

	local str = ScpArgMsg("RealyDoEnchant");
	local yesScp = string.format("DO_ITEM_ENCHANT(\'%s\')", itemIES) 
	ui.MsgBox(str, yesScp, "CANCEL_ENCHANTCHIP()");
end

function DO_ITEM_ENCHANT(itemIES)
	if enchantGuid == "" or itemIES == "" then
		CANCEL_ENCHANTCHIP();
		return;
	end

	item.DoPremiumItemEnchantchip(itemIES, enchantGuid);
	CANCEL_ENCHANTCHIP();
end