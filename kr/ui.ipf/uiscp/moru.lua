-- moru.lua --

function CLIENT_MORU_UPGRADE(invItem)
	local frame = ui.GetFrame("upgradeitem_2");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromMoruSlot, invItem);
	ui.GuideMsg("SelectItem");

	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "_CHECK_MORU_TARGET_ITEM_UPGRADE");
	SET_INV_LBTN_FUNC(invframe, "MORU_LBTN_CLICK_UPGRADE");
end

function MORU_LBTN_CLICK_UPGRADE(frame, invItem)
	local upgradeitem_2 = ui.GetFrame("upgradeitem_2");
	local fromItemSlot = GET_CHILD(upgradeitem_2, "fromItemSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromItemSlot, invItem);
	upgradeitem_2:ShowWindow(1);
	UPGRADE2_UPDATE_TARGET(upgradeitem_2);
	UPGRADE2_UPDATE_MORU_COUNT(upgradeitem_2);
	
end

function _CHECK_MORU_TARGET_ITEM_UPGRADE(slot)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local obj = GetIES(item:GetObject());
		if IS_ITEM_EVOLUTIONABLE(obj) == 1 then
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end
	end
end


----- reinforce_131014

function CLIENT_MORU(invItem)
	local frame = ui.GetFrame("reinforce_131014");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromMoruSlot, invItem);
	ui.GuideMsg("SelectItem");

	local invframe = ui.GetFrame("inventory");
	local gbox = invframe:GetChild("inventoryGbox");
	local x, y = GET_GLOBAL_XY(gbox);
	x = x - gbox:GetWidth() * 0.7;
	y = y - 40;
	SET_MOUSE_FOLLOW_BALLOON(ClMsg("ClickItemToReinforce"), 0, x, y);
	ui.SetEscapeScp("_CANCEL_MORU()");

	SET_SLOT_APPLY_FUNC(invframe, "_CHECK_MORU_TARGET_ITEM");
	SET_INV_LBTN_FUNC(invframe, "MORU_LBTN_CLICK");

	CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_REINF");
end

function CURSOR_CHECK_REINF(slot)
	local item = GET_SLOT_ITEM(slot);
	if item == nil then
		return 0;
	end
	
	local obj = GetIES(item:GetObject());
	return REINFORCE_ABLE_131014(obj);
end

function _CANCEL_MORU()
	local frame = ui.GetFrame("reinforce_131014");
	CANCEL_MORU(frame);
end

function CANCEL_MORU(frame)
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	SET_INV_LBTN_FUNC(invframe, "None");
	RESET_MOUSE_CURSOR();
end

function MORU_LBTN_CLICK(frame, invItem)
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("ItemIsNotReinforcable"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if REINFORCE_ABLE_131014(obj) == 0 then
		ui.SysMsg(ClMsg("ItemIsNotReinforcable"));
		return;
	end

	CANCEL_MORU(frame);
	
	local upgradeitem_2 = ui.GetFrame("reinforce_131014");
	local fromItemSlot = GET_CHILD(upgradeitem_2, "fromItemSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromItemSlot, invItem);

	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(upgradeitem_2);

	upgradeitem_2:ShowWindow(1);
	REINFORCE_131014_UPDATE_MORU_COUNT(upgradeitem_2);


end

function _CHECK_MORU_TARGET_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local obj = GetIES(item:GetObject());
		if REINFORCE_ABLE_131014(obj) == 1 then
			slot:GetIcon():SetGrayStyle(0);
			slot:SetBlink(60000, 2.0, "FFFFFF00", 1);
		else
			slot:GetIcon():SetGrayStyle(1);
			slot:ReleaseBlink();
		end
	end
end
