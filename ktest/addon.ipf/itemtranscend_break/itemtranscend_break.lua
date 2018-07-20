
function ITEMTRANSCEND_BREAK_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMTRANSCEND_BREAK", "ON_OPEN_DLG_ITEMTRANSCEND_BREAK");

end

function ON_OPEN_DLG_ITEMTRANSCEND_BREAK(frame)
	frame:ShowWindow(1);		
	ui.SetHoldUI(false);
	frame:SetUserValue("ANIMETION_PROG_WIP", 0);
end

function ITEMTRASCEND_BREAK_OPEN(frame)
	
	local slot = GET_CHILD(frame, "slot");
	local slot_material = GET_CHILD(frame, "slot_material");
	slot:ClearIcon();
	slot:SetText("");
	slot_material:ClearIcon();
	slot_material:SetText("");
	
	UPDATE_TRANSCEND_BREAK_ITEM(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMTRANSCEND_BREAK_INV_RBTN")	
	ui.OpenFrame("inventory");
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_BREAK_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end

function ITEMTRASCEND_BREAK_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
		
	frame:SetUserValue("ANIMETION_PROG_WIP", 0);
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
 end

 function ITEMTRANSCEND_BREAK_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("itemtranscend_break");

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	if obj.ClassName == GET_TRANSCEND_BREAK_ITEM() then
		ITEM_TRANSCEND_BREAK_REG_MATERIAL(frame, iconInfo:GetIESID());
	else
		ITEM_TRANSCEND_BREAK_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end
	
	
end

function REMOVE_TRANSCEND_BREAK_TARGET_ITEM(frame)

	local bProg_wip = frame:GetUserIValue("ANIMETION_PROG_WIP");
	if bProg_wip == 1 then
		return;
	end
	frame:SetUserValue("ANIMETION_PROG_WIP", 0);

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();
	slot:SetText("");
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_BREAK_ITEM(frame);
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_BREAK_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end

 function ITEM_TRANSEND_BREAK_DROP(frame, icon, argStr, argNum)

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();

	local iconInfo = liftIcon:GetInfo();
	ITEM_TRANSCEND_BREAK_REG_TARGETITEM(frame, iconInfo:GetIESID());

end
  
function ITEM_TRANSCEND_BREAK_REG_TARGETITEM(frame, itemID)
	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if IS_TRANSCEND_ABLE_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotAbleToTranscendBreak"));
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
	
	local transcend = TryGetProp(obj, "Transcend")
	if transcend == nil or transcend == 0 then
		ui.MsgBox(ScpArgMsg("YouCanBreakOnlyTreancendedItem"));
		return;
	end

	if TryGetProp(obj, 'LegendGroup', 'None') ~= 'None' then
		control.CustomCommand("REQ_LEGEND_ITEM_DIALOG", 1);
		ui.CloseFrame('itemtranscend_break');
		ui.CloseFrame('inventory');
		return;
	end

	local itemCount = GET_TRANSCEND_BREAK_ITEM_COUNT(obj);
	if itemCount == 0 then
		ui.MsgBox(ScpArgMsg("TranscendValueIsTooSmallSoReturnItemDoesNotExist"));
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:ClearIcon();
	slot_material:SetText("");

	local txt_result = frame:GetChildRecursively("txt_result");
	txt_result:ShowWindow(0);
	UPDATE_TRANSCEND_BREAK_ITEM(frame);	
	
end

function UPDATE_TRANSCEND_BREAK_ITEM(frame)

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);

	local text_material = frame:GetChild("text_material");
	local text_itemstar = frame:GetChild("text_itemstar");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	
	local text_breakresult = frame:GetChild("text_breakresult");	

	if invItem == nil then
		text_itemstar:ShowWindow(0);
		text_material:ShowWindow(0);
		text_itemtranscend:ShowWindow(0);		
		text_breakresult:ShowWindow(0);
	else
		local targetObj = GetIES(invItem:GetObject());
		text_itemstar:ShowWindow(1);
		local starTxt = GET_ITEM_GRADE_TXT(targetObj, 24);
		text_itemstar:ShowWindow(1);
		text_itemstar:SetTextByKey("value", starTxt);

		text_itemtranscend:SetTextByKey("value", targetObj.Transcend);
		text_itemtranscend:ShowWindow(1);

		text_material:SetTextByKey("value", GET_FULL_NAME(targetObj));
		text_material:ShowWindow(1);

		local materialItem = "misc_BlessedStone";
		local matItemCls = GetClass("Item", materialItem);
		if matItemCls ~= nil then
			local resultString = ScpArgMsg("{Item}WillBeReturnedBy{Count}", "Item", matItemCls.Name, "Count", GET_TRANSCEND_BREAK_ITEM_COUNT(targetObj) * 10);
			text_breakresult:SetTextByKey("value", resultString);
		else
			text_breakresult:SetTextByKey("value", "");
		end

		text_breakresult:ShowWindow(1);
		
	
		local mtrlCls = GetClass("Item", "Premium_itemDissassembleStone");
		if mtrlCls == nil then
			return;
		end
		local needTxt = "";	
		local sil = GET_TRANSCEND_BREAK_SILVER(targetObj);
		needTxt = string.format("{img %s 30 30}{/}{@st43_green}{s16}%s{/}{@st42b}{s16}, {/}{@st43_red}{s16}%s  {/}{@st42b}{s16}%s{/}", mtrlCls.Icon, mtrlCls.Name, GET_MONEY_IMG(24) .. " " .. GetCommaedText(sil), ScpArgMsg("Need_Item"));			
		SETTEXT_GUIDE(frame, 1, needTxt);
	end


end

function DROP_TRANSCEND_BREAK_MATERIAL(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	ITEM_TRANSCEND_BREAK_REG_MATERIAL(frame, iconInfo:GetIESID());

end

function ITEM_TRANSCEND_BREAK_REG_MATERIAL(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end
	
	local obj = GetIES(invItem:GetObject());
	local matItemName = GET_TRANSCEND_BREAK_ITEM();
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
	UPDATE_TRANSCEND_BREAK_ITEM(frame);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(1);
end

function ITEMTRANSCEND_BREAK_EXEC(frame)

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
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		local matItemName = GET_TRANSCEND_BREAK_ITEM();
		local msgString = ScpArgMsg("PleaseDropItem{Name}", "Name", GetClass("Item", matItemName).Name);
		ui.MsgBox(msgString);
		return;
	end
	ui.SetHoldUI(false);
	
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	ui.MsgBox_NonNested(ScpArgMsg("ItemWillBeDeleted_Continue?"), frame:GetName(), "_ITEMTRANSCEND_BREAK_EXEC_MSG", "_ITEMTRANSCEND_BREAK_CANCEL");		
	
end

function _ITEMTRANSCEND_BREAK_EXEC_MSG()
	ui.MsgBox(ScpArgMsg("ReallyBreakTransendedItem?"), "_ITEMTRANSCEND_BREAK_EXEC", "_ITEMTRANSCEND_BREAK_CANCEL");		
	ui.SetHoldUI(false);
end

function _ITEMTRANSCEND_BREAK_CANCEL()
	local frame = ui.GetFrame("itemtranscend_break");
	ui.SetHoldUI(false);
end;

function _ITEMTRANSCEND_BREAK_EXEC()

	local frame = ui.GetFrame("itemtranscend_break");
	
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if slot == nil or materialItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if GET_TOTAL_MONEY() < GET_TRANSCEND_BREAK_SILVER(obj) then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	ui.SetHoldUI(true);
	frame:SetUserValue("ANIMETION_PROG_WIP", 1);
	session.ResetItemList();	
	session.AddItemID(invItem:GetIESID());
	session.AddItemID(materialItem:GetIESID());	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("ITEM_TRANSCEND_BREAK_TX", resultlist);

	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_BREAK_ITEM(frame);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));

end

function TRANSCEND_BREAK_UPDATE(itemName, count)
	local frame = ui.GetFrame("itemtranscend_break");
    local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_BREAK_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);

	UPDATE_TRANSCEND_BREAK_ITEM(frame);
	UPDATE_TRANSCEND_BREAK_RESULT(frame, itemName, count);
end

function UPDATE_TRANSCEND_BREAK_RESULT(frame, itemName, count)

	local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
	animpic_bg:ShowWindow(1);
	animpic_bg:ForcePlayAnimation();
	frame:SetUserValue("BREAK_RESULT_ITEM_NAME", itemName);
	frame:SetUserValue("BREAK_RESULT_ITEM_COUNT", count);
end

function ITEMTRANSCEND_BG_ANIM_TICK_BREAK(ctrl, str, tick)

	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		imcSound.PlaySoundEvent('sys_transcend_success');
		ReserveScript("TRANSCEND_EFFECT_BREAK()", 0.3);
		frame:SetUserValue("ANIMETION_PROG_WIP", 0);
		ui.SetHoldUI(false);
	end

end

function TRANSCEND_EFFECT_BREAK()
	local frame = ui.GetFrame("itemtranscend_break");
	_UPDATE_TRANSCEND_RESULT_BREAK(frame);
end

function _UPDATE_TRANSCEND_RESULT_BREAK(frame)		
		
	local itemName = string.format("%s",frame:GetUserValue("BREAK_RESULT_ITEM_NAME"));
	local count = frame:GetUserIValue("BREAK_RESULT_ITEM_COUNT");
	local itemCls = GetClass("Item", itemName );
	local slot = GET_CHILD(frame, "slot");	
	slot:PlayActiveUIEffect();
	slot:ClearIcon();
	slot:SetText("");
	SET_SLOT_ITEM_CLS(slot, itemCls);
	SET_SLOT_COUNT_TEXT(slot, count, "{@st43}{s22}{ol}{b}");
	
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:ClearIcon();
	slot_material:SetText("");

	local text_material = frame:GetChild("text_material");
	local text_itemstar = frame:GetChild("text_itemstar");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	
	local text_breakresult = frame:GetChild("text_breakresult");	
	text_itemstar:ShowWindow(0);
	text_itemtranscend:ShowWindow(0);
	text_breakresult:ShowWindow(0);

	text_material:SetTextByKey("value", GET_FULL_NAME(itemCls));
	
	local txt_result = frame:GetChildRecursively("txt_result");
	txt_result:ShowWindow(1);

	local resultTxt = GET_FULL_NAME(itemCls) .. " " .. count .. ScpArgMsg("CountOfThings");
	txt_result:SetTextByKey("value", resultTxt);
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_BREAK_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end
