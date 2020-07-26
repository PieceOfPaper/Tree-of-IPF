
function LEGEND_MISC_EXCHANGE_ON_INIT(addon, frame)
	addon:RegisterMsg('LEGEND_MISC_EXCHANGE_SUCCESS', 'LEGEND_MISC_EXCHANGE_RESULT');
end

function LEGEND_MISC_EXCHANGE_OPEN_DLG()
	ui.OpenFrame("legend_misc_exchange");
end

function LEGEND_MISC_EXCHANGE_OPEN(frame)
	LEGEND_MISC_EXCHANGE_CLEAR_UI()

	INVENTORY_SET_CUSTOM_RBTNDOWN("LEGEND_MISC_EXCHANGE_INV_RBTN")	
	ui.OpenFrame("inventory");
end

function LEGEND_MISC_EXCHANGE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then return; end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	ui.CloseFrame("inventory");
end

function LEGEND_MISC_EXCHANGE_CLEAR_UI()
	if ui.CheckHoldedUI() == true then return; end

	local frame = ui.GetFrame("legend_misc_exchange");
	LEGEND_MISC_EXCHANGE_TOGGLE_ITEM_UI(frame, 0);
end

function LEGEND_MISC_EXCHANGE_TOGGLE_ITEM_UI(frame, toggle)
	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	slot2:ShowWindow(toggle);

	local slot1_bg_image = GET_CHILD(slot1, "slot1_bg_image");
	slot1_bg_image:ShowWindow(1 - toggle);
	
	local droplist = GET_CHILD(frame, "droplist");
	droplist:ShowWindow(toggle);
	
	local arrowpic = GET_CHILD_RECURSIVELY(frame, "arrowpic");
	arrowpic:ShowWindow(toggle);

	local item_text_bg = GET_CHILD_RECURSIVELY(frame, "item_text_bg");
	item_text_bg:ShowWindow(1 - toggle);

	local issuccess_bg = GET_CHILD_RECURSIVELY(frame, "issuccess_bg");
	issuccess_bg:ShowWindow(0);

	local countbox = GET_CHILD(frame, "countbox");
	countbox:ShowWindow(toggle);

	local editCount = GET_CHILD(countbox, "count");
	editCount:SetText(0);

	local send_ok = GET_CHILD(frame, "send_ok");
	send_ok:ShowWindow(0);

	local do_change = GET_CHILD(frame, "do_change");

	if toggle == 0 then		
		slot1:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
		slot1:ClearIcon();

		local item_text = GET_CHILD(item_text_bg, "item_text");
		item_text:SetTextByKey('value', frame:GetUserConfig('ITEM_NAME_TEXT_1'));
		
		do_change:ShowWindow(1 - toggle);

		frame:SetUserValue("EXCHANGE_GROUP", "None");
		frame:SetUserValue("SRC_ITEM_CLASS_NAME", "None");
		frame:SetUserValue("SRC_ITEM_GUID", "None");
		frame:SetUserValue("DEST_ITEM_CLASS_NAME", "None");

		LEGEND_MISC_EXCHANGE_TOGGLE_MATERIAL_UI(frame, toggle);
	else
		slot1:SetGravity(ui.LEFT, ui.CENTER_VERT)
		slot2:ClearIcon();

		local guid = frame:GetUserValue("SRC_ITEM_GUID");
		local invItem = session.GetInvItemByGuid(guid);
		if invItem == nil then return; end
		SET_SLOT_ITEM(slot1, invItem);

		LEGEND_MISC_EXCHANGE_DROPLIST_INIT(frame);
		LEGEND_MISC_EXCHANGE_DROPLIST_SELECT(frame);
	end

end

function LEGEND_MISC_EXCHANGE_TOGGLE_MATERIAL_UI(frame, toggle)
	local gb = GET_CHILD(frame, "material_gb");
	gb:RemoveAllChild();

	if toggle == 0 then
		gb:ShowWindow(0);
	else
		gb:ShowWindow(1);

		local editCount = GET_CHILD_RECURSIVELY(frame, "count");
		if editCount == nil then return; end

		local changegroup = frame:GetUserValue("EXCHANGE_GROUP");
		local classnameList, needCntList = GET_LEGEND_MISC_EXCHANGE_MATERIAL_LIST(changegroup);
		local matCnt = #classnameList;

		local y = 0;
		for i = 1, matCnt do
			local itemClassName = classnameList[i];
			local itemCls = GetClass("Item", itemClassName);

			local needCnt = needCntList[i];
			local nowCnt = tonumber(editCount:GetText());
			local totalCnt = needCnt * nowCnt;

			local ctrlset = gb:CreateOrGetControlSet("ark_composition_material", "MAT_CTROLSET_"..i, 0, y);
			local nameCtrl = GET_CHILD(ctrlset, "mat_text");
			nameCtrl:SetTextByKey("value", itemCls.Name)
	
			local slotCtrl = GET_CHILD(ctrlset, "mat_slot");
			slotCtrl:SetText('{s18}{ol}{b} '..totalCnt, 'count', ui.RIGHT, ui.BOTTOM, -8, -6);
			SET_SLOT_ITEM_CLS(slotCtrl, itemCls);

			y = y + ctrlset:GetHeight();
		end
	end

end

function LEGEND_MISC_EXCHANGE_INV_RBTN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("legend_misc_exchange");
	if frame == nil then return; end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	LEGEND_MISC_EXCHANGE_REG_SRC_ITEM(frame, iconInfo:GetIESID());
end

function LEGEND_MISC_EXCHANGE_DROP_SRC_ITEM(ctrl, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("legend_misc_exchange");
	if frame == nil then return; end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		LEGEND_MISC_EXCHANGE_REG_SRC_ITEM(frame, iconInfo:GetIESID());
	end
end

function LEGEND_MISC_EXCHANGE_REMOVE_SRC_ITEM(ctrl, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("legend_misc_exchange");
	LEGEND_MISC_EXCHANGE_TOGGLE_ITEM_UI(frame, 0);
end

function LEGEND_MISC_EXCHANGE_REG_SRC_ITEM(frame, guid)
	local invItem = session.GetInvItemByGuid(guid);
	if invItem == nil then return false; end

	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if IS_LEGEND_MISC_EXCHANGE_ITEM(itemObj) ~= true then
		return false;
	end
	
	frame:SetUserValue("EXCHANGE_GROUP", itemObj.StringArg);
	frame:SetUserValue("SRC_ITEM_CLASS_NAME", itemObj.ClassName);
	frame:SetUserValue("SRC_ITEM_GUID", guid);
	LEGEND_MISC_EXCHANGE_TOGGLE_ITEM_UI(frame, 1);
end

function LEGEND_MISC_EXCHANGE_DROPLIST_INIT(frame)
	local ctrl = GET_CHILD(frame, "droplist");
    ctrl:ClearItems();

	local changegroup = frame:GetUserValue("EXCHANGE_GROUP");
	local itemclassname = frame:GetUserValue("SRC_ITEM_CLASS_NAME");
	local classnameList = GET_LEGEND_MISC_EXCHANGE_ITEM_LIST(changegroup);
	
	local itemCnt = #classnameList;
	for i = 1, itemCnt do
		if itemclassname ~= classnameList[i] then
			local itemObj = GetClass("Item", classnameList[i]);
            ctrl:AddItem(itemObj.ClassName, itemObj.Name);
		end
	end

end

function LEGEND_MISC_EXCHANGE_DROPLIST_SELECT(frame, ctrl, str, num)
	if ui.CheckHoldedUI() == true then return; end

	if ctrl == nil then
		ctrl = GET_CHILD(frame, "droplist");
	end

	local selectClassName = ctrl:GetSelItemKey();
	local itemCls = GetClass("Item", selectClassName);
	if itemCls == nil then
		LEGEND_MISC_EXCHANGE_TOGGLE_MATERIAL_UI(frame, 0);
		return; 
	end
	
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	SET_SLOT_ITEM_CLS(slot2, itemCls);
	
	frame:SetUserValue("DEST_ITEM_CLASS_NAME", selectClassName);

	LEGEND_MISC_EXCHANGE_TOGGLE_MATERIAL_UI(frame, 1);
end

function LEGEND_MISC_EXCHANGE_EDIT_TYPING(frame, ctrl)
	local frame = ui.GetFrame("legend_misc_exchange");
	local value = ctrl:GetText();
	if value == nil or value == "" then
		value = 0;
	end

	value = tonumber(value);
	local maxCnt = GET_LEGEND_MISC_EXCHANGE_ENABLE_MAX_ITEM_COUNT(frame);
	if maxCnt < value then
		value = maxCnt;
	end
	ctrl:SetText(value);

	LEGEND_MISC_EXCHANGE_CHANGE_ITEM_COUNT(frame, value);
end

function LEGEND_MISC_EXCHANGE_ITEM_COUNT_UP_BTN_CLICK(ctrl)
	if ui.CheckHoldedUI() == true then return; end
	
	local frame = ui.GetFrame("legend_misc_exchange");
	if frame == nil then return; end

	local send_ok = GET_CHILD(frame, "send_ok");
	if send_ok:IsVisible() == 1 then return; end

	local editCount = GET_CHILD_RECURSIVELY(frame, "count");
	if editCount == nil then return; end

	local nowCnt = tonumber(editCount:GetText());
	nowCnt = nowCnt + 1;

	local maxCnt = GET_LEGEND_MISC_EXCHANGE_ENABLE_MAX_ITEM_COUNT(frame);
	if maxCnt < nowCnt then
		nowCnt = maxCnt;
	end

	editCount:SetText(tostring(nowCnt));

	LEGEND_MISC_EXCHANGE_CHANGE_ITEM_COUNT(frame, nowCnt);
end

function LEGEND_MISC_EXCHANGE_ITEM_COUNT_DOWN_BTN_CLICK(ctrl)
	if ui.CheckHoldedUI() == true then return; end

	local frame = ui.GetFrame("legend_misc_exchange");
	if frame == nil then return; end
	
	local send_ok = GET_CHILD(frame, "send_ok");
	if send_ok:IsVisible() == 1 then return; end

	local editCount = GET_CHILD_RECURSIVELY(frame, "count");
	if editCount == nil then return; end

	local nowCnt = tonumber(editCount:GetText());
	nowCnt = nowCnt - 1;

	if nowCnt <= 0 then
		nowCnt = 0;
	end

	editCount:SetText(tostring(nowCnt));
	LEGEND_MISC_EXCHANGE_CHANGE_ITEM_COUNT(frame, nowCnt);
end

function LEGEND_MISC_EXCHANGE_ITEM_COUNT_MAX_BTN_CLICK(ctrl)
	if ui.CheckHoldedUI() == true then return; end

	local frame = ui.GetFrame("legend_misc_exchange");
	if frame == nil then return; end

	local send_ok = GET_CHILD(frame, "send_ok");
	if send_ok:IsVisible() == 1 then return; end

	local editCount = GET_CHILD_RECURSIVELY(frame, "count");
	if editCount == nil then return; end

	local nowCnt = GET_LEGEND_MISC_EXCHANGE_ENABLE_MAX_ITEM_COUNT(frame);
	
	editCount:SetText(tostring(nowCnt));
	LEGEND_MISC_EXCHANGE_CHANGE_ITEM_COUNT(frame, nowCnt);
end

function GET_LEGEND_MISC_EXCHANGE_ENABLE_MAX_ITEM_COUNT(frame)
	local maxenableCnt = 999999;

	local changegroup = frame:GetUserValue("EXCHANGE_GROUP");
	local pc = GetMyPCObject();

	local classnameList, needCntList = GET_LEGEND_MISC_EXCHANGE_MATERIAL_LIST(changegroup);
	local matCnt = #classnameList;

	for i = 1, matCnt do
		local itemClassName = classnameList[i];
		local needCnt = needCntList[i];
		
		local curcnt = GetInvItemCount(pc, itemClassName);

		local enableCnt = math.floor(curcnt / needCnt);
		if enableCnt < maxenableCnt then
			maxenableCnt = enableCnt;
		end
	end

	local src_ClassName = frame:GetUserValue("SRC_ITEM_CLASS_NAME");
	local curcnt = GetInvItemCount(pc, src_ClassName);
	if curcnt < maxenableCnt then
		maxenableCnt = curcnt;
	end
	
	return maxenableCnt;
end

function LEGEND_MISC_EXCHANGE_CHANGE_ITEM_COUNT(frame, nowCnt)
	local gb = GET_CHILD(frame, "material_gb");

	local changegroup = frame:GetUserValue("EXCHANGE_GROUP");
	local classnameList, needCntList = GET_LEGEND_MISC_EXCHANGE_MATERIAL_LIST(changegroup);
	local matCnt = #classnameList;

	for i = 1, matCnt do
		local ctrlset = GET_CHILD(gb, "MAT_CTROLSET_"..i);

		local needCnt = needCntList[i];
		local totalCnt = needCnt * nowCnt;

		local slotCtrl = GET_CHILD(ctrlset, "mat_slot");
		slotCtrl:SetText('{s18}{ol}{b} '..totalCnt, 'count', ui.RIGHT, ui.BOTTOM, -8, -6);
		SET_SLOT_ITEM_CLS(slotCtrl, itemCls);
	end
end

function LEGEND_MISC_EXCHANGE_BUTTON_CLICK(ctrl)
	if ui.CheckHoldedUI() == true then return; end

	local frame = ctrl:GetTopParentFrame();
	
	local src_guid = frame:GetUserValue("SRC_ITEM_GUID");
	if src_guid == "None" then return; end
	
	local dest_ClassName = frame:GetUserValue("DEST_ITEM_CLASS_NAME");
	if dest_ClassName == "None" then return; end

	local editCount = GET_CHILD_RECURSIVELY(frame, "count");
	local changeCnt = tonumber(editCount:GetText());

	if changeCnt <= 0 then return; end

    -- 전환 로직 호출 
	ui.SetHoldUI(true);
    local nameList = NewStringList();
    nameList:Add(dest_ClassName);
    session.ResetItemList();
    session.AddItemID(src_guid, changeCnt);
    local resultlist = session.GetItemIDList();

	item.DialogTransaction("LEGEND_MISC_EXCHANGE", resultlist, "", nameList)
	PLAY_LEGEND_MISC_EXCHANGE_EFFECT()
end

function PLAY_LEGEND_MISC_EXCHANGE_EFFECT()
	local frame = ui.GetFrame("legend_misc_exchange");

	local EXCHANGE_EFFECT_NAME = frame:GetUserConfig('EXCHANGE_EFFECT_NAME');
	local EXCHANGE_EFFECT_SCALE = tonumber(frame:GetUserConfig('EXCHANGE_EFFECT_SCALE'));
	local EXCHANGE_EFFECT_DURATION = tonumber(frame:GetUserConfig('EXCHANGE_EFFECT_DURATION'));

	local pic_bg = GET_CHILD(frame, 'pic_bg');
	pic_bg:ShowWindow(1);
	pic_bg:PlayUIEffect(EXCHANGE_EFFECT_NAME, EXCHANGE_EFFECT_SCALE, 'RELOCATE_EFFECT');
	
	ReserveScript('RELEASE_LEGEND_MISC_EXCHANGE_UI_HOLD()', EXCHANGE_EFFECT_DURATION);
end

function RELEASE_LEGEND_MISC_EXCHANGE_UI_HOLD()
	ui.SetHoldUI(false);
end

function LEGEND_MISC_EXCHANGE_RESULT(frame, msg, dest_guid)
	local frame = ui.GetFrame("legend_misc_exchange");

	local soundname = frame:GetUserConfig("SUCCESS_SOUND");	
	imcSound.PlaySoundEvent(soundname);

	
	local issuccess_bg = GET_CHILD_RECURSIVELY(frame, "issuccess_bg");
	issuccess_bg:ShowWindow(1);

	local send_ok = GET_CHILD(frame, "send_ok");
	send_ok:ShowWindow(1);
	
	_LEGEND_MISC_EXCHANGE_RESULT(frame);
end

function _LEGEND_MISC_EXCHANGE_RESULT(frame)
	local pic_bg = GET_CHILD(frame, 'pic_bg');
	pic_bg:StopUIEffect('RELOCATE_EFFECT', true, 0.5);

	RELEASE_LEGEND_MISC_EXCHANGE_UI_HOLD();
end