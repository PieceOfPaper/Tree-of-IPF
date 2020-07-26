
function COMPOSITION_VIBORA_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_COMPOSITION_VIBORA", "ON_OPEN_DLG_COMPOSITION_VIBORA");
	addon:RegisterMsg("COMPOSITION_VIBORA_SUCCESS", "COMPOSITION_VIBORA_SUCCESS");
end

function ON_OPEN_DLG_COMPOSITION_VIBORA()
	ui.OpenFrame("composition_vibora");
end

function COMPOSITION_VIBORA_OPEN(frame)
    COMPOSITION_VIBORA_UI_RESET();
	
	INVENTORY_SET_CUSTOM_RBTNDOWN("COMPOSITION_VIBORA_INV_RBTNDOWN");
	ui.OpenFrame("inventory");
end

function COMPOSITION_VIBORA_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	control.DialogOk();

    frame:ShowWindow(0);
end

function COMPOSITION_VIBORA_SLOT_RESET(slot, slotIndex)	
	if IS_CHECK_COMPOSITION_VIBORA_RESULT() == true then
		return;
	end

	slot:SetUserValue("CLASS_NAME", "None");
	slot:SetUserValue("GUID", "None");
	slot:ClearIcon();
	
	local slot_img = GET_CHILD(slot, 'slot_img_'..slotIndex);
	slot_img:ShowWindow(1);
end

function COMPOSITION_VIBORA_UI_RESET()
	local frame = ui.GetFrame("composition_vibora");
	
	local reinfResultBox = GET_CHILD(frame, "reinfResultBox");
	reinfResultBox:ShowWindow(0);

	local do_composition = GET_CHILD(frame, "do_composition");
	do_composition:ShowWindow(1);

	local resetBtn = GET_CHILD(frame, "resetBtn");
	resetBtn:ShowWindow(0);

    local need_count = GET_COMPOSITION_VIROBA_SOURCE_COUNT();
	for i = 1, need_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		COMPOSITION_VIBORA_SLOT_RESET(slot, i);
	end
end

function COMPOSITION_VIBORA_SAME_ITEM_CHECK(guid)
	local frame = ui.GetFrame("composition_vibora");
    local need_count = GET_COMPOSITION_VIROBA_SOURCE_COUNT()
	for i = 1, need_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() ~= nil and guid == slot:GetUserValue("GUID") then
			return false;
		end
	end

	return true;
end

function COMPOSITION_VIBORA_ITEM_REG(guid, ctrl, slotIndex)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	if IS_CHECK_COMPOSITION_VIBORA_RESULT() == true then
		return;
	end

	local invItem = session.GetInvItemByGuid(guid);
	if invItem == nil then
		return;
    end
    
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

    local itemObj = GetIES(invItem:GetObject());
	local ret, ret_classname = IS_COMPOSABLE_VIRORA(itemObj);
    if ret == false or ret_classname == 'None' then
        return;
	end
	
	if COMPOSITION_VIBORA_SAME_ITEM_CHECK(guid) == false then
		return;
	end

	SET_SLOT_ITEM(ctrl, invItem);
	ctrl:SetUserValue("CLASS_NAME", ret_classname);
	ctrl:SetUserValue("GUID", guid);
	
	local slot_img = GET_CHILD(ctrl, 'slot_img_'..slotIndex);
	slot_img:ShowWindow(0);
end

function COMPOSITION_VIBORA_INV_RBTNDOWN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("composition_vibora");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
    local need_count = GET_COMPOSITION_VIROBA_SOURCE_COUNT()
	for i = 1, need_count do 
		local ctrl = GET_CHILD(frame, "slot_"..i);
		if ctrl:GetIcon() == nil then
			local iconInfo = icon:GetInfo();
			COMPOSITION_VIBORA_ITEM_REG(iconInfo:GetIESID(), ctrl, i);
			return;
		end
	end

end

function COMPOSITION_VIBORA_ITEM_DROP(parent, ctrl, argStr, slotIndex)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		COMPOSITION_VIBORA_ITEM_REG(iconInfo:GetIESID(), ctrl, slotIndex);
	end
end

function COMPOSITION_VIBORA_ITEM_POP(parent, ctrl, argStr, slotIndex)
	if ui.CheckHoldedUI() == true then
		return;
	end

	COMPOSITION_VIBORA_SLOT_RESET(ctrl, slotIndex);
end

function COMPOSITION_VIBORA_BTN_CLICK(parent, ctrl)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = parent:GetTopParentFrame();

	session.ResetItemList();
    local need_count = GET_COMPOSITION_VIROBA_SOURCE_COUNT();
	for i = 1, need_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() == nil then
			return;
		end

		local invItem = GET_SLOT_ITEM(slot);
		local itemobj = GetIES(invItem:GetObject());
		if IS_COMPOSABLE_VIRORA(itemobj) == false then
			return;
		end

		local guid = slot:GetUserValue("GUID");
		session.AddItemID(guid, 1);
	end

	local COMPOSITON_SLOT_EFFECT = frame:GetUserConfig("COMPOSITON_SLOT_EFFECT");
	local need_count = GET_COMPOSITION_VIROBA_SOURCE_COUNT();
	for i = 1, need_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		slot:PlayUIEffect(COMPOSITON_SLOT_EFFECT, 4.2, "COMPOSITON_SLOT_EFFECT", true);
	end

	ui.SetHoldUI(true);
	ReserveScript("COMPOSITION_VIBORA_UNFREEZE()", 3);

	local resultlist = session.GetItemIDList();
	item.DialogTransaction("COMPOSITION_VIBORA", resultlist);
end

function COMPOSITION_VIBORA_UNFREEZE()	
	ui.SetHoldUI(false);
end

function COMPOSITION_VIBORA_SUCCESS(frame, msg, guid)
	local frame = ui.GetFrame("composition_vibora");

	local reinfResultBox = GET_CHILD(frame, "reinfResultBox");
	reinfResultBox:ShowWindow(1);

	local do_composition = GET_CHILD(frame, "do_composition");
	do_composition:ShowWindow(0);

	local resetBtn = GET_CHILD(frame, "resetBtn");
	resetBtn:ShowWindow(1);

	local invItem = session.GetInvItemByGuid(guid);
	local successItem = GET_CHILD_RECURSIVELY(frame, "successItem");
	SET_SLOT_ITEM(successItem, invItem);	

	local RESULT_EFFECT = frame:GetUserConfig("RESULT_EFFECT");
	local successItem = GET_CHILD_RECURSIVELY(reinfResultBox, "successItem");
	successItem:PlayUIEffect(RESULT_EFFECT, 5, "RESULT_EFFECT", true);	
end

function IS_CHECK_COMPOSITION_VIBORA_RESULT()
	local frame = ui.GetFrame("composition_vibora");

	local resetBtn = GET_CHILD(frame, "resetBtn");
	if resetBtn:IsVisible() == 1 then
		return true;
	end

	return false;
end