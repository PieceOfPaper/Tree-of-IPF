
function ITEMTRANSCEND_REMOVE_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMTRANSCEND_REMOVE", "ON_OPEN_DLG_ITEMTRANSCEND_REMOVE");

end

function ON_OPEN_DLG_ITEMTRANSCEND_REMOVE(frame, msg, argStr, isLegendShop)
	frame:ShowWindow(1);	
	ui.SetHoldUI(false);
	frame:SetUserValue("ANIMETION_PROG_WIP", 0);
	frame:SetUserValue('IS_LEGEND_SHOP', isLegendShop);
end

function ITEMTRASCEND_REMOVE_OPEN(frame)
	
	local slot = GET_CHILD(frame, "slot");
	local slot_material = GET_CHILD(frame, "slot_material");
	slot:ClearIcon();
	slot_material:ClearIcon();
	slot_material:SetText("");
	
	UPDATE_TRANSCEND_REMOVE_ITEM(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMTRANSCEND_REMOVE_INV_RBTN")	
	ui.OpenFrame("inventory");
	
    frame:SetUserValue('TRANSCEND_REMOVE', 'YES');
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_REMOVE_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end

function ITEMTRASCEND_REMOVE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame:SetUserValue("ANIMETION_PROG_WIP", 0);
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
 end

 function ITEMTRANSCEND_REMOVE_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("itemtranscend_remove");

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	if obj.ClassName == GET_TRANSCEND_REMOVE_ITEM() then
		ITEM_TRANSCEND_REMOVE_REG_MATERIAL(frame, iconInfo:GetIESID());
	else
		ITEM_TRANSCEND_REMOVE_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end		
end

function REMOVE_TRANSCEND_REMOVE_TARGET_ITEM(frame)
	frame:SetUserValue("ANIMETION_PROG_WIP", 0);

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_REMOVE_ITEM(frame);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);

	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_REMOVE_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
end

 function ITEM_TRANSEND_REMOVE_DROP(frame, icon, argStr, argNum)

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();

	local iconInfo = liftIcon:GetInfo();
	ITEM_TRANSCEND_REMOVE_REG_TARGETITEM(frame, iconInfo:GetIESID());

end
  
function ITEM_TRANSCEND_REMOVE_REG_TARGETITEM(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if IS_TRANSCEND_ABLE_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotAbleToTranscendRemove"));
		return;
	end

	if IS_TRANSCEND_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotTranscended"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if transcend == 0 then
		ui.MsgBox(ScpArgMsg("YouCanRemoveOnlyTreancendedItem"));
		return;
	end

	if TryGetProp(obj, 'LegendGroup', 'None') ~= 'None' then
		control.CustomCommand("REQ_LEGEND_ITEM_DIALOG", 1);
		ui.CloseFrame('itemtranscend_remove');
		ui.CloseFrame('inventory');
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:ClearIcon();
	slot_material:SetText("");

	UPDATE_TRANSCEND_REMOVE_ITEM(frame, 0);	
	
	
		local mtrlCls = GetClass("Item", "Premium_deleteTranscendStone");
		if mtrlCls == nil then
			return;
		end
		local needTxt = "";	
		needTxt = string.format("{img %s 30 30}{/}{@st43_green}{s16}%s{/}{@st42b}{s16}{/}{@st42b}{s16}%s{/}", mtrlCls.Icon, mtrlCls.Name, ScpArgMsg("Need_Item"));			
		SETTEXT_GUIDE(frame, 1, needTxt);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end

function UPDATE_TRANSCEND_REMOVE_ITEM(frame, isResult)

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);

	local text_material = frame:GetChild("text_material");
	local text_itemstar = frame:GetChild("text_itemstar");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	

	if invItem == nil then
		text_itemstar:ShowWindow(0);
		text_material:ShowWindow(0);
		text_itemtranscend:ShowWindow(0);		
	else
		local targetObj = GetIES(invItem:GetObject());
		text_itemstar:ShowWindow(1);
		local starTxt = GET_ITEM_GRADE_TXT(targetObj, 24);
		text_itemstar:ShowWindow(1);
		text_itemstar:SetTextByKey("value", starTxt);

		if isResult == 1 then			
			text_itemtranscend:SetTextByKey("value", "{@st43_red}{s20}".. targetObj.Transcend);
		else
			text_itemtranscend:SetTextByKey("value", "{s20}"..targetObj.Transcend);
		end;
		text_itemtranscend:ShowWindow(1);

		text_material:SetTextByKey("value", GET_FULL_NAME(targetObj));
		text_material:ShowWindow(1);

	end


end

function DROP_TRANSCEND_REMOVE_MATERIAL(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	ITEM_TRANSCEND_REMOVE_REG_MATERIAL(frame, iconInfo:GetIESID());

end

function ITEM_TRANSCEND_REMOVE_REG_MATERIAL(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end
	
	local obj = GetIES(invItem:GetObject());
	local matItemName = GET_TRANSCEND_REMOVE_ITEM();
	if obj.ClassName ~= matItemName then
		local msgString = ScpArgMsg("PleaseDropItem{Name}", "Name", GetClass("Item", matItemName).Name);
		ui.MsgBox(msgString);
		return;
	end
	
	local slot = GET_CHILD(frame, "slot");
	local Icon = slot:GetIcon();
	if Icon == nil then
		return;
	end
		
	local iconInfo = Icon:GetInfo();
	if iconInfo == nil then
		return;
	end
	
	local item = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if item == nil then
		return;
	end

	local obj = GetIES(item:GetObject());
	if obj == nil then
		return;
	end

	if IS_TRANSCEND_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotTranscended"));
		return;
	end

	local slot_material = GET_CHILD(frame, "slot_material");
	SET_SLOT_INVITEM(slot_material, invItem, 1);
	UPDATE_TRANSCEND_REMOVE_ITEM(frame, 0);
			
	SETTEXT_GUIDE(frame, 0, nil);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(1);
end

function ITEMTRANSCEND_REMOVE_EXEC(frame)

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if invItem == nil then
		ui.MsgBox(ScpArgMsg("DropItemPlz"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		return;
	end

	if materialItem == nil then
		local matItemName = GET_TRANSCEND_REMOVE_ITEM();
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		local msgString = ScpArgMsg("PleaseDropItem{Name}", "Name", GetClass("Item", matItemName).Name);
		ui.MsgBox(msgString);
		return;
	end
	
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	ui.SetHoldUI(true);
--	ui.MsgBox_NonNested(ScpArgMsg("IfYouRemoveTranscend_YouCannotReceieveTranscendStones_Continue?"), frame:GetName(), "_ITEMTRANSCEND_REMOVE_EXEC_MSG", "_ITEMTRANSCEND_REMOVE_CANCEL");		
	WARNINGMSGBOX_FRAME_OPEN(ScpArgMsg("IfYouRemoveTranscend_YouCannotReceieveTranscendStones_Continue?"), "_ITEMTRANSCEND_REMOVE_EXEC_MSG", "_ITEMTRANSCEND_REMOVE_CANCEL")		
	frame:SetUserValue("ANIMETION_PROG_WIP", 1);
end

function _ITEMTRANSCEND_REMOVE_EXEC_MSG()
	--ui.MsgBox(ScpArgMsg("TranscendValueWillBeZero_Continue?"), "_ITEMTRANSCEND_REMOVE_EXEC", "_ITEMTRANSCEND_REMOVE_CANCEL");	
	WARNINGMSGBOX_FRAME_OPEN(ScpArgMsg("TranscendValueWillBeZero_Continue?"), "_ITEMTRANSCEND_REMOVE_EXEC", "_ITEMTRANSCEND_REMOVE_CANCEL")		
end

function _ITEMTRANSCEND_REMOVE_CANCEL()
	local frame = ui.GetFrame("itemtranscend_remove");
	ui.SetHoldUI(false);
end;

function _ITEMTRANSCEND_REMOVE_EXEC()

	local frame = ui.GetFrame("itemtranscend_remove");
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if slot == nil or materialItem == nil then
		return;
	end

	session.ResetItemList();	
	session.AddItemID(invItem:GetIESID());
	session.AddItemID(materialItem:GetIESID());	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("ITEM_TRANSCEND_REMOVE_TX", resultlist);

	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_REMOVE_ITEM(frame , 0);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_REMOVE_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end

function TRANSCEND_REMOVE_UPDATE()
	local frame = ui.GetFrame("itemtranscend_remove");	
    local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_REMOVE_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);

	local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
	animpic_bg:ShowWindow(1);
	animpic_bg:ForcePlayAnimation();

	ui.MsgBox(ScpArgMsg("TranscendRemove"));
end

function ITEMTRANSCEND_BG_ANIM_TICK_REMOVE(ctrl, str, tick)

	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		imcSound.PlaySoundEvent('sys_transcend_success');
		ReserveScript("TRANSCEND_EFFECT_REMOVE()", 0.3);
		frame:SetUserValue("ANIMETION_PROG_WIP", 0);
		ui.SetHoldUI(false);
	end

end

function TRANSCEND_EFFECT_REMOVE()
	local frame = ui.GetFrame("itemtranscend_remove");
	_UPDATE_TRANSCEND_RESULT_REMOVE(frame);
end

function _UPDATE_TRANSCEND_RESULT_REMOVE(frame)				
	UPDATE_TRANSCEND_REMOVE_ITEM(frame, 1);
	local slot = GET_CHILD(frame, "slot");	
	slot:PlayActiveUIEffect();
end
