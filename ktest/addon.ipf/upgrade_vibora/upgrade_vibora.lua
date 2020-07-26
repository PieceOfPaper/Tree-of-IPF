
function UPGRADE_VIBORA_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_UPGRADE_VIBORA", "ON_OPEN_DLG_UPGRADE_VIBORA");
	addon:RegisterMsg("UPGRADE_VIBORA_SUCCESS", "UPGRADE_VIBORA_SUCCESS");
end

function ON_OPEN_DLG_UPGRADE_VIBORA()
	ui.OpenFrame("upgrade_vibora");
end

function UPGRADE_VIBORA_OPEN(frame)
    UPGRADE_VIBORA_UI_RESET();
	
	INVENTORY_SET_CUSTOM_RBTNDOWN("UPGRADE_VIBORA_INV_RBTNDOWN");
	ui.OpenFrame("inventory");
end

function UPGRADE_VIBORA_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	control.DialogOk();

    frame:ShowWindow(0);
end

function UPGRADE_VIBORA_SLOT_RESET(slot, slotIndex)	
	if IS_CHECK_UPGRADE_VIBORA_RESULT() == true then
		return;
	end

	slot:SetUserValue("CLASS_NAME", "None");
	slot:SetUserValue("GUID", "None");
	slot:ClearIcon();
	
	local slot_img = GET_CHILD(slot, 'slot_img_'..slotIndex);
	slot_img:ShowWindow(1);
end

function UPGRADE_VIBORA_UI_RESET()
	local frame = ui.GetFrame("upgrade_vibora");
	
	local reinfResultBox = GET_CHILD(frame, "reinfResultBox");
	reinfResultBox:ShowWindow(0);

	local doBtn = GET_CHILD(frame, "doBtn");
	doBtn:ShowWindow(1);

	local resetBtn = GET_CHILD(frame, "resetBtn");
	resetBtn:ShowWindow(0);

	local result_gb = GET_CHILD(frame, "result_gb");
	result_gb:ShowWindow(0);

    local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	for i = 1, slot_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		UPGRADE_VIBORA_SLOT_RESET(slot, i);
	end

	UPGRADE_VIBORA_MATERIAL_UI_RESET();
end

function UPGRADE_VIBORA_MATERIAL_UI_RESET()	
	if IS_CHECK_UPGRADE_VIBORA_RESULT() == true then
		return;
	end

	local frame = ui.GetFrame("upgrade_vibora");
	
	local matrial_slot = GET_CHILD_RECURSIVELY(frame, "matrial_slot");
	matrial_slot:ClearIcon();

	local matrial_name = GET_CHILD_RECURSIVELY(frame, "matrial_name");
	matrial_name:ShowWindow(0);
	
	local matrial_count = GET_CHILD_RECURSIVELY(frame, "matrial_count");
	matrial_count:ShowWindow(0);

	UPGRADE_VIBORA_MATERIAL_INIT();
end

function UPGRADE_VIBORA_SAME_ITEM_CHECK(guid, classname)
	local frame = ui.GetFrame("upgrade_vibora");
	for i = 1, 2 do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() ~= nil then
			if guid == slot:GetUserValue("GUID") then
				return false;
			end
			
			if classname ~= slot:GetUserValue("CLASS_NAME") then
				return false;
			end
		end
	end

	return true;
end

function UPGRADE_VIBORA_ITEM_REG(guid, ctrl, slotIndex)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	if IS_CHECK_UPGRADE_VIBORA_RESULT() == true then
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
	local ret, ret_classname, cur_lv = CAN_UPGRADE_VIBORA(itemObj);
    if ret == false or ret_classname == 'None' or cur_lv == 0 then
        return;
	end
	
	local result_item_classname = GET_UPGRADE_VIBORA_ITEM_NAME(itemObj);
	local cls = GetClass('Item', result_item_classname)
	if cls == nil then
		return;
	end

	if UPGRADE_VIBORA_SAME_ITEM_CHECK(guid, ret_classname) == false then
		return;
	end

	SET_SLOT_ITEM(ctrl, invItem);
	ctrl:SetUserValue("CLASS_NAME", ret_classname);
	ctrl:SetUserValue("GUID", guid);
	
	local slot_img = GET_CHILD(ctrl, 'slot_img_'..slotIndex);
	slot_img:ShowWindow(0);

	UPGRADE_VIBORA_RESULT_ITEM_INIT(result_item_classname);
	UPGRADE_VIBORA_MATERIAL_INIT();
end

function UPGRADE_VIBORA_ITEM_DROP(parent, ctrl, argStr, slotIndex)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		UPGRADE_VIBORA_ITEM_REG(iconInfo:GetIESID(), ctrl, slotIndex);
	end
end

function UPGRADE_VIBORA_ITEM_POP(parent, ctrl, argStr, slotIndex)
	if ui.CheckHoldedUI() == true then
		return;
	end

	UPGRADE_VIBORA_SLOT_RESET(ctrl, slotIndex);
	UPGRADE_VIBORA_MATERIAL_UI_RESET();

	local frame = ui.GetFrame("upgrade_vibora");
	local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	local nil_count = slot_count;
	for i = 1, slot_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() == nil then
			nil_count = nil_count - 1;
		end
	end

	if nil_count == 0 then
		local result_gb = GET_CHILD(parent, "result_gb");
		result_gb:ShowWindow(0);
	end	
end

function UPGRADE_VIBORA_RESULT_ITEM_INIT(classname)
	local frame = ui.GetFrame("upgrade_vibora");
	
	local result_gb = GET_CHILD(frame, "result_gb");
	result_gb:ShowWindow(1);
	
	local result_slot = GET_CHILD(result_gb, "result_slot");

	local itemCls = GetClass("Item", classname);
	SET_SLOT_ITEM_CLS(result_slot, itemCls);
end

function UPGRADE_VIBORA_MATERIAL_INIT()
	local frame = ui.GetFrame("upgrade_vibora");

	local count = 0;
    local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	for i = 1, slot_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() ~= nil then
			count = count + 1;
		end
	end

	if count == slot_count then
		local UPGRADE_MAT_DEFAULT = frame:GetUserConfig("UPGRADE_MAT_DEFAULT");
		local matrial_name = GET_CHILD_RECURSIVELY(frame, "matrial_name");
		matrial_name:SetTextByKey("value", UPGRADE_MAT_DEFAULT);
		matrial_name:ShowWindow(1);
	end
end

function UPGRADE_VIBORA_MATERIAL_REG(guid)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	if IS_CHECK_UPGRADE_VIBORA_RESULT() == true then
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

	local frame = ui.GetFrame("upgrade_vibora");
	local goal_lv = 0;
    local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	for i = 1, slot_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() == nil then
			return;
		else
			local slot_invItem = GET_SLOT_ITEM(slot);
			local slot_itemobj = GetIES(slot_invItem:GetObject());
			local ret, ret_classname, cur_lv = CAN_UPGRADE_VIBORA(slot_itemobj);
			goal_lv = cur_lv + 1; 
		end
	end

	local itemObj = GetIES(invItem:GetObject());
	if IS_UPGARDE_VIBORA_MISC(itemObj, goal_lv) == false then
		return;
	end
	
	local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = itemObj.ClassName}}, false);
	local need_count = GET_REQUIRED_VIBORA_MISC_COUNT(goal_lv);
	
	local matrial_name = GET_CHILD_RECURSIVELY(frame, "matrial_name");
	matrial_name:SetTextByKey("value", itemObj.Name);
	matrial_name:ShowWindow(1);

	local matrial_count = GET_CHILD_RECURSIVELY(frame, "matrial_count");
	matrial_count:ShowWindow(1);
	matrial_count:SetTextByKey("cur", curCnt);
	matrial_count:SetTextByKey("need", need_count);
		
	local matrial_slot = GET_CHILD_RECURSIVELY(frame, "matrial_slot");
	SET_SLOT_ITEM(matrial_slot, invItem);
end

function UPGRADE_VIBORA_MATERIAL_DROP(parent, ctrl)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		UPGRADE_VIBORA_MATERIAL_REG(iconInfo:GetIESID());
	end
end

function UPGRADE_VIBORA_MATERIAL_POP(parent, ctrl)
	UPGRADE_VIBORA_MATERIAL_UI_RESET();
end

function UPGRADE_VIBORA_INV_RBTNDOWN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("upgrade_vibora");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
    local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	for i = 1, slot_count do 
		local ctrl = GET_CHILD(frame, "slot_"..i);
		if ctrl:GetIcon() == nil then
			UPGRADE_VIBORA_ITEM_REG(iconInfo:GetIESID(), ctrl, i);
			return;
		end
	end

	UPGRADE_VIBORA_MATERIAL_REG(iconInfo:GetIESID())
end

function UPGRADE_VIBORA_BTN_CLICK(parent, ctrl)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = parent:GetTopParentFrame();

	session.ResetItemList();
	local goal_lv = 0;
	local slot_count = GET_UPGRADE_VIROBA_SOURCE_COUNT();
	for i = 1, slot_count do 
		local slot = GET_CHILD(frame, "slot_"..i);
		if slot:GetIcon() == nil then
			ui.SysMsg(ClMsg("NoEnoguhtItem"));
			return;
		end

		local slot_invItem = GET_SLOT_ITEM(slot);
		local slot_itemobj = GetIES(slot_invItem:GetObject());
		local ret, ret_classname, cur_lv = CAN_UPGRADE_VIBORA(slot_itemobj);
		if ret == false then
			return;
		end
		
		goal_lv = cur_lv + 1;

		local guid = slot:GetUserValue("GUID");
		session.AddItemID(guid, 1);
	end

	local matrial_slot = GET_CHILD_RECURSIVELY(frame, "matrial_slot");
	local matrial_slot_invItem = GET_SLOT_ITEM(matrial_slot);
	if matrial_slot_invItem == nil then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end

	local matrial_slot_itemobj = GetIES(matrial_slot_invItem:GetObject());
	local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = matrial_slot_itemobj.ClassName}}, false);
	local need_count = GET_REQUIRED_VIBORA_MISC_COUNT(goal_lv);
	if curCnt < need_count then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end

	session.AddItemID(matrial_slot_invItem:GetIESID(), need_count);

	local resultlist = session.GetItemIDList();
	item.DialogTransaction("UPGRADE_VIBORA", resultlist);
end

function UPGRADE_VIBORA_SUCCESS(frame, msg, guid)
	local frame = ui.GetFrame("upgrade_vibora");

	local reinfResultBox = GET_CHILD(frame, "reinfResultBox");
	reinfResultBox:ShowWindow(1);

	local doBtn = GET_CHILD(frame, "doBtn");
	doBtn:ShowWindow(0);

	local resetBtn = GET_CHILD(frame, "resetBtn");
	resetBtn:ShowWindow(1);

	local invItem = session.GetInvItemByGuid(guid);
	local successItem = GET_CHILD_RECURSIVELY(frame, "successItem");
	SET_SLOT_ITEM(successItem, invItem);	

	local RESULT_EFFECT = frame:GetUserConfig("RESULT_EFFECT");
	local successItem = GET_CHILD_RECURSIVELY(reinfResultBox, "successItem");
	successItem:PlayUIEffect(RESULT_EFFECT, 5, "RESULT_EFFECT", true);	
end

function IS_CHECK_UPGRADE_VIBORA_RESULT()
	local frame = ui.GetFrame("upgrade_vibora");

	local resetBtn = GET_CHILD(frame, "resetBtn");
	if resetBtn:IsVisible() == 1 then
		return true;
	end

	return false;
end