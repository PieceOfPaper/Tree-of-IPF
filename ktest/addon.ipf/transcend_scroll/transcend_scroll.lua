function TRANSCEND_SCROLL_ON_INIT(addon, frame)

end

function TRANSCEND_SCROLL_CHECK_TARGET_ITEM(slot)-- _CHECK_MORU_TARGET_ITEM
	local frame = ui.GetFrame("transcend_scroll");
	local scrollType = frame:GetUserValue("ScrollType");
	
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local obj = GetIES(item:GetObject());
		if IS_TRANSCEND_SCROLL_ABLE_ITEM(obj, scrollType) == 1 or IS_TRANSCEND_SCROLL_ITEM(obj) == 1 then
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end
	end
end

function TRANSCEND_SCROLL_SET_TARGET_ITEM(invframe, invItem)	
	local frame = ui.GetFrame("transcend_scroll");
	local scrollType = frame:GetUserValue("ScrollType");
	local slot = GET_CHILD(frame, "slot");
	local slot_temp = GET_CHILD(frame, "slot_temp");
	local text_name = GET_CHILD(frame, "text_name")
	local text_transcend = GET_CHILD(frame, "text_transcend")
	local text_rate = GET_CHILD(frame, "text_rate")
	local text_desc = GET_CHILD(frame, "text_desc")

	slot_temp:StopActiveUIEffect();
	slot_temp:ShowWindow(0);	

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));--not transcendable
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if IS_TRANSCEND_SCROLL_ABLE_ITEM(itemObj, scrollType) ~= 1 then
		if scrollType == "transcend_Add" then
			ui.SysMsg(ClMsg("TranscendScrollAddDisabledItem"));
		elseif scrollType == "transcend_Set" then
			ui.SysMsg(ClMsg("TranscendScrollSetDisabledItem"));
		end
		return;
	end

	local scrollGuid = frame:GetUserValue("ScrollGuid")
	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
	if scrollInvItem == nil then
		return;
	end
	local scrollObj = GetIES(scrollInvItem:GetObject());
	local anticipatedTranscend, percent = GET_ANTICIPATED_TRANSCEND_SCROLL_SUCCESS(itemObj, scrollObj)

	text_name:SetTextByKey("value", itemObj.Name)
	text_transcend:SetTextByKey("value", anticipatedTranscend)
	text_rate:SetTextByKey("value", percent)
	text_desc:SetTextByKey("value", anticipatedTranscend)

	TRANSCEND_SCROLL_CANCEL();

	TRANSCEND_SCROLL_TARGET_ITEM_SLOT(slot, invItem, scrollObj.ClassID);
	frame:OpenFrame(1);
end

function TRANSCEND_SCROLL_TARGET_ITEM_SLOT(slot, invItem, scrollClsID)
	local itemCls = GetClassByType("Item", invItem.type);

	local type = itemCls.ClassID;
	local obj = GetIES(invItem:GetObject());
	local img = GET_ITEM_ICON_IMAGE(obj);
	SET_SLOT_IMG(slot, img)
	SET_SLOT_COUNT(slot, count)
	SET_SLOT_IESID(slot, invItem:GetIESID())
	
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	iconInfo.type = type;

	icon:SetTooltipType("reinforceitem");
	icon:SetTooltipArg("transcendscroll", scrollClsID, invItem:GetIESID());
	
end

function TRANSCEND_SCROLL_EXEC_ASK_AGAIN(frame, btn)
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND_C();
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			ui.SysMsg(ScpArgMsg("CannotReinforceAndTranscendBy{BUFFNAME}","BUFFNAME", buffCls.Name));
		end
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		ui.MsgBox(ScpArgMsg("DropItemPlz"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local potential = TryGetProp(itemObj, "PR");
	if potential == nil then
		return;
	end

	local scrollGuid = frame:GetUserValue("ScrollGuid")
	local scrollInvItem = session.GetInvItemByGuid(scrollGuid);
	if scrollInvItem == nil then
		return;
	end
	local scrollObj = GetIES(scrollInvItem:GetObject());

	local transcend, rate = GET_ANTICIPATED_TRANSCEND_SCROLL_SUCCESS(itemObj, scrollObj);
	if transcend == nil then
		return;
	end

	local beforeTranscend = TryGetProp(itemObj, "Transcend");
	if beforeTranscend == nil then
		beforeTranscend = 0;
	end

	local clmsg = ScpArgMsg("TranscendScrollWarning{Before}To{After}", "Before", beforeTranscend, "After", transcend)
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "TRANSCEND_SCROLL_EXEC", "None");
end

function TRANSCEND_SCROLL_RESULT(isSuccess)
	local frame = ui.GetFrame("transcend_scroll");
	if isSuccess == 1 then
		local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
		animpic_bg:ShowWindow(1);
		animpic_bg:ForcePlayAnimation();
	else
		TRANSCEND_SCROLL_RESULT_UPDATE(frame, 0);
	end
end

function TRANSCEND_SCROLL_RESULT_UPDATE(frame, isSuccess)
	local slot = GET_CHILD(frame, "slot");
	
	local timesecond = 0;
	if isSuccess == 1 then
		ui.SysMsg(ScpArgMsg("SuccessToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_SUCCESS_SOUND"));
		slot:StopActiveUIEffect();
		slot:PlayActiveUIEffect();
		timesecond = 2;
	else
		ui.SysMsg(ScpArgMsg("FailedToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_FAIL_SOUND"));
		local slot_temp = GET_CHILD(frame, "slot_temp");
		slot_temp:ShowWindow(1);
		slot_temp:StopActiveUIEffect();
		slot_temp:PlayActiveUIEffect();
		timesecond = 1;
	end
	
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		if isSuccess == 0 then
			ui.SysMsg(ClMsg('ItemDeleted'));
		end
		--ui.SetHoldUI(false);
		slot:ClearIcon();
		return;
	end
	
	frame:StopUpdateScript("TIMEWAIT_STOP_TRANSCEND_SCROLL");
	frame:RunUpdateScript("TIMEWAIT_STOP_TRANSCEND_SCROLL", timesecond);
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
end

function TRANSCEND_SCROLL_BG_ANIM_TICK(ctrl, str, tick)
	if tick == 10 then
		local frame = ctrl:GetTopParentFrame();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		ReserveScript("TRANSCEND_SCROLL_EFFECT()", 0.3);
	end
end

function TRANSCEND_SCROLL_EFFECT()
	local frame = ui.GetFrame("transcend_scroll");
	TRANSCEND_SCROLL_RESULT_UPDATE(frame, 1);	
end

function TIMEWAIT_STOP_TRANSCEND_SCROLL()
	local frame = ui.GetFrame("transcend_scroll");
	local slot_temp = GET_CHILD(frame, "slot_temp");
	slot_temp:ShowWindow(0);
	slot_temp:StopActiveUIEffect();
	
	frame:StopUpdateScript("TIMEWAIT_STOP_TRANSCEND_SCROLL");
	return 1;
end

function TRANSCEND_SCROLL_EXEC()
	local frame = ui.GetFrame("transcend_scroll");	
	--ui.SetHoldUI(true);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	
	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	local scrollGuid = frame:GetUserValue("ScrollGuid")
	session.ResetItemList();
	session.AddItemID(targetItem:GetIESID());
	session.AddItemID(scrollGuid);
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("ITEM_TRANSCEND_SCROLL", resultlist);

	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
end

function TRANSCEND_SCROLL_SELECT_TARGET_ITEM(scrollItem)
	if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('CannotUseInPVPZone'));
        return;
    end

	if IsPVPServer() == 1 then	
		ui.SysMsg(ScpArgMsg('CantUseThisInIntegrateServer'));
		return;
	end

	local rankresetFrame = ui.GetFrame("rankreset");
	if 1 == rankresetFrame:IsVisible() then
		ui.SysMsg(ScpArgMsg('CannotDoAction'));
		return;
	end
	
	local frame = ui.GetFrame("transcend_scroll");
	local slot = GET_CHILD(frame, "slot", "ui::CSlot");

	local scrollObj = GetIES(scrollItem:GetObject());
	if IS_TRANSCEND_SCROLL_ITEM(scrollObj) ~= 1 then
		return;
	end
	
	local scrollType = GET_TRANSCEND_SCROLL_TYPE(scrollObj);
	local scrollGuid = GetIESGuid(scrollObj);
	frame:SetUserValue("ScrollType", scrollType)
	frame:SetUserValue("ScrollGuid", scrollGuid)

	if scrollObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	ui.GuideMsg("SelectItem");

	local invframe = ui.GetFrame("inventory");
	local gbox = invframe:GetChild("inventoryGbox");
	local x, y = GET_GLOBAL_XY(gbox);
	x = x - gbox:GetWidth() * 0.7;
	y = y - 40;
	SET_MOUSE_FOLLOW_BALLOON(ClMsg("ClickItemToTranscendByScroll"), 0, x, y);
	ui.SetEscapeScp("TRANSCEND_SCROLL_CANCEL()");
		
	local tab = gbox:GetChild("inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(0);

	SET_SLOT_APPLY_FUNC(invframe, "TRANSCEND_SCROLL_CHECK_TARGET_ITEM");
	SET_INV_LBTN_FUNC(invframe, "TRANSCEND_SCROLL_SET_TARGET_ITEM");
end

function TRANSCEND_SCROLL_CANCEL()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	SET_INV_LBTN_FUNC(invframe, "None");
	RESET_MOUSE_CURSOR();
end

function TRANSCEND_SCROLL_ATTEMPT_FAIL(num)
end

function TRANSCEND_SCROLL_CLOSE()
	local frame = ui.GetFrame("transcend_scroll");
	frame:SetUserValue("ScrollType", "None")
	frame:SetUserValue("ScrollGuid", "None")
	frame:OpenFrame(0);
end
