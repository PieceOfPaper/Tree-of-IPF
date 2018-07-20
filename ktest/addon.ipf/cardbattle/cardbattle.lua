

function CARDBATTLE_UI_INIT_COMMON(frame, handle)
	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() * 0.65, -frame:GetHeight(), 3, 1);
end

function MY_CARDBATTELE_OPEN(ownerHandle, tableHandle, info)

	local frame = ui.GetFrame("cardbattle");
	frame:ShowWindow(1);
	frame:SetUserValue("MODE", "HOST");
	frame:SetUserValue("OWNER_HANDLE", ownerHandle);
	CARDBATTLE_UI_INIT_COMMON(frame, tableHandle);
	UPDATE_CARDBATTLE_FRAME(frame, info);
end

function OBSERVE_CARD_BATTLE(ownerHandle, tableHandle, info)

	local frame = ui.GetFrame("cardbattle");
	frame:ShowWindow(1);
	frame:SetUserValue("OWNER_HANDLE", ownerHandle);
	frame:SetUserValue("MODE", "OBSERVER");
	CARDBATTLE_UI_INIT_COMMON(frame, tableHandle);
	UPDATE_CARDBATTLE_FRAME(frame, info);
	REGISTERR_LASTUIOPEN_POS(frame);

end

function EXIT_OBSERVE_CARD_BATTLE()

	ui.CloseFrame("cardbattle");
	ui.CloseFrame("cardbattle_result");
	ui.CloseFrame("cardbattle_rullet");

	local rulletFrame = ui.GetFrame("cardbattle_rullet");
	rulletFrame:StopUpdateScript("RUN_CARDBATTLE_RULLET");
	rulletFrame:CancelReserveScript("OPEN_RULLET_FRAME");
	rulletFrame:CancelReserveScript("START_RULLET");

	local resultFrame = ui.GetFrame("cardbattle_result");
	resultFrame:CancelReserveScript("OPEN_RULLET_FRAME");	

end

function JOIN_CARD_BATTLE(ownerHandle, tableHandle, info)
	imcSound.PlaySoundEvent("sys_card_battle_percussion_timpani");
	local frame = ui.GetFrame("cardbattle");
	frame:ShowWindow(1);
	frame:SetUserValue("OWNER_HANDLE", ownerHandle);
	frame:SetUserValue("MODE", "TARGET");
	CARDBATTLE_UI_INIT_COMMON(frame, tableHandle);
	UPDATE_CARDBATTLE_FRAME(frame, info);
end


function CARDBATTLE_UPDATE(ownerHandle, info)
	if 0 == ui.IsFrameVisible("cardbattle") then
		return;
	end

	local frame = ui.GetFrame("cardbattle");
	if frame:GetUserIValue("OWNER_HANDLE") == ownerHandle then
		UPDATE_CARDBATTLE_FRAME(frame, info);
	end
end

function EXIT_CARD_BATTLE()
	ui.CloseFrame("cardbattle");
end

function CLOSE_CARDBATTLE(frame)

	if frame:GetUserValue("MODE") == "HOST" then
		geClientCardBattle.ReqCloseBattle();
	elseif frame:GetUserValue("MODE") == "TARGET" then
		local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
		geClientCardBattle.ReqExitBattle(ownerHandle);
	elseif frame:GetUserValue("MODE") == "OBSERVER" then
		local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
		geClientCardBattle.ReqExitBattle(ownerHandle);
	end

end

function READY_CARDBATTLE(frame)
	
	if frame:GetUserValue("MODE") == "HOST" then
		local card_2 = GET_CHILD(frame, "card_2");
		local tooltipType = card_2:GetTooltipType();
		if tooltipType == "None" then
			ui.SysMsg(ScpArgMsg("PleaseDropCard"));
			return;
		end

		local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
		geClientCardBattle.SendReady(ownerHandle);		
	elseif frame:GetUserValue("MODE") == "TARGET" then
		local card_1 = GET_CHILD(frame, "card_1");
		local tooltipType = card_1:GetTooltipType();
		if tooltipType == "None" then
			ui.SysMsg(ScpArgMsg("PleaseDropCard"));
			return;
		end
		
		local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
		geClientCardBattle.SendReady(ownerHandle);
	end

end

function CARDBATTLE_UPDATE_CARDINFO(gBox, starText, obj)
	if obj == nil then
		gBox:ShowWindow(0);
		starText:ShowWindow(0);
	else

		local bossCls = GetClassByType('Monster', obj.NumberArg1);

		local cardCls = GetClass("CardBattle", obj.ClassName);
		if cardCls == nil then
			return;
		end

		local name = gBox:GetChild("name");
		local engname = gBox:GetChild("engname");
		local race = gBox:GetChild("race");
		local attr = gBox:GetChild("attr");
		local weight = gBox:GetChild("weight");
		local height = gBox:GetChild("height");
		local legcount = gBox:GetChild("legcount");
		name:SetTextByKey("value", obj.Name);
		engname:SetTextByKey("value", cardCls.EngName);
		race:SetTextByKey("value", ScpArgMsg(bossCls.RaceType));
		attr:SetTextByKey("value", ScpArgMsg("Attr_" .. bossCls.Attribute));
		weight:SetTextByKey("value", cardCls.BodyWeight);
		height:SetTextByKey("value", cardCls.Height);
		legcount:SetTextByKey("value", cardCls.LegCount);

		local starTextValue = GET_ITEM_STAR_TXT(obj, 24);
		starText:SetTextByKey("value", starTextValue);
		gBox:ShowWindow(1);
		starText:ShowWindow(1);
		
	end
	
end

function OPEN_CARDBATTLE(frame)

	local card_1 = GET_CHILD(frame, "card_1");
	card_1:SetImage("test_card_slot");
	card_1:SetTooltipType('None');
	local card_2 = GET_CHILD(frame, "card_2");
	card_2:SetImage("test_card_slot");
	card_2:SetTooltipType('None');

	local gbox_card_1 = frame:GetChild("gbox_card_1");
	local gbox_card_2 = frame:GetChild("gbox_card_2");
	local text_star_1 = frame:GetChild("text_star_1");
	local text_star_2 = frame:GetChild("text_star_2");
	text_star_1:ShowWindow(0);
	text_star_2:ShowWindow(0);
	CARDBATTLE_UPDATE_CARDINFO(gbox_card_1, text_star_1, nil);
	CARDBATTLE_UPDATE_CARDINFO(gbox_card_2, text_star_2, nil);

end

function CARDBATTLE_ESCKEY(frame)

	if frame:IsVisible() == 1 then
		local btn_cancel = frame:GetChild("btn_cancel");
		if btn_cancel:IsVisible() == 1 then
			CLOSE_CARDBATTLE(frame);
		end
	end

end

function MY_CARDBATTELE_CLOSE()
	ui.CloseFrame("cardbattle");
end

function DIALOG_CARDTABLE(actor, isEnter)

	if isEnter == 1 then
		geClientCardBattle.DialogTarget(actor:GetHandleVal());
	end
	
end

function DIALOG_CARDTABLE_CHECK(targetHandle)
	local targetActor = world.GetActor(targetHandle);
	local ownerHandle = targetActor:GetUserIValue("OWNER_HANDLE");
	if session.GetMyHandle() == ownerHandle then
		return false;
	end

	return true;
end


function UPDATE_CARDBATTLE_FRAME(frame, info)
		
	local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
	info = tolua.cast(info, "CARD_BATTLE_TABLE_INFO");
	local wincount_1 = frame:GetChild("wincount_1");
	
	if -1 == info.targetWinCount then
		info.targetWinCount = 0;
	end
	wincount_1:SetTextByKey("value", info.targetWinCount);
	
	local wincount_2 = frame:GetChild("wincount_2");
	wincount_2:SetTextByKey("value", info.ownerWinCount);
	
	local wait_image_1 = frame:GetChild("wait_image_1");
	local wait_image_2 = frame:GetChild("wait_image_2");

	local text_msg_1 = frame:GetChild("text_msg_1");
	local text_msg_2 = frame:GetChild("text_msg_2");

	local text_star_1 = frame:GetChild("text_star_1");
	local text_star_2 = frame:GetChild("text_star_2");
	
	wait_image_1:ShowWindow(0);
	wait_image_2:ShowWindow(0);
	text_msg_1:ShowWindow(0);
	text_msg_2:ShowWindow(0);

	local btn_ready = frame:GetChild("btn_ready");
	btn_ready:SetEnable(0);
	btn_ready:ShowWindow(1);
	local btn_cancel = frame:GetChild("btn_cancel");
	btn_cancel:ShowWindow(1);
	local txt_observer = frame:GetChild("txt_observer");
	txt_observer:ShowWindow(0);
	if info.ownerReady == true and info.targetReady == true then
		btn_cancel:ShowWindow(0);
		imcSound.PlaySoundEvent("sys_card_battle_rival_slot_show");
	end

	if info.ownerCardType == -1 then
		local card_2 = GET_CHILD(frame, "card_2");
		card_2:SetImage("test_card_slot");
		card_2:SetTooltipType('None');
	end

	if info.targetCardType == -1 then
		local card_1 = GET_CHILD(frame, "card_1");
		card_1:SetImage("test_card_slot");
		card_1:SetTooltipType('None');
	end

	local modeType = frame:GetUserValue("MODE");
	if modeType == "HOST" then
		if info.ownerCardType == -1 then
			wait_image_2:ShowWindow(1);	
		end

		if info.ownerReady == false then
			btn_ready:SetEnable(1);
		end
	else
		if info.hasItemInfo == false then
			text_msg_2:ShowWindow(1);
		end
	end

	if modeType == "TARGET" then
		if info.targetCardType == -1 then
			wait_image_1:ShowWindow(1);	
		end

		if info.targetReady == false then
			btn_ready:SetEnable(1);
		end

	else
		if info.hasItemInfo == false then
			text_msg_1:ShowWindow(1);
		end
	end

	if modeType == "OBSERVER" then
		btn_ready:ShowWindow(0);
		btn_cancel:ShowWindow(1);
		btn_cancel:SetEnable(1);
		txt_observer:ShowWindow(1);
		txt_observer:SetTextByKey("value", ScpArgMsg("ObserveMode"));
	end

	if info.ownerReady == true then
		text_msg_2:SetTextByKey("value", "{#00FF00}" .. ScpArgMsg("SelectComplete"));
		imcSound.PlaySoundEvent("sys_card_battle_rival_slot_select");
	elseif info.ownerCardType == -1 then
		text_msg_2:SetTextByKey("value", ScpArgMsg("CardNotRegistered"));
	elseif info.ownerCardType == 0 then
		text_msg_2:SetTextByKey("value", ScpArgMsg("SelectingTheCard"));	
	end

	if info.targetReady == true then
		text_msg_1:SetTextByKey("value", "{#00FF00}" .. ScpArgMsg("SelectComplete"));
		imcSound.PlaySoundEvent("sys_card_battle_rival_slot_select");
	elseif info.targetCardType == -1 then
		text_msg_1:SetTextByKey("value", ScpArgMsg("CardNotRegistered"));
	elseif info.targetCardType == 0 then
		text_msg_1:SetTextByKey("value", ScpArgMsg("SelectingTheCard"));	
	end

	if info.hasItemInfo == true then
		
		local ownerItemObj, targetItem = GetCardBattleItems(ownerHandle);
		
		local card_2 = GET_CHILD(frame, "card_2");
		card_2:SetImage(ownerItemObj.TooltipImage);
		SET_ITEM_TOOLTIP_ALL_TYPE(card_2, nil, ownerItemObj.ClassName, 'cardbattle', ownerItemObj.ClassID, ownerHandle * 10 + 2);

		local gbox_card_2 = frame:GetChild("gbox_card_2");
		CARDBATTLE_UPDATE_CARDINFO(gbox_card_2, text_star_2, ownerItemObj);
		
		local card_1 = GET_CHILD(frame, "card_1");
		card_1:SetImage(targetItem.TooltipImage);
		SET_ITEM_TOOLTIP_ALL_TYPE(card_1, nil, targetItem.ClassName, 'cardbattle', targetItem.ClassID, ownerHandle * 10 + 1);

		local gbox_card_1 = frame:GetChild("gbox_card_1");
		CARDBATTLE_UPDATE_CARDINFO(gbox_card_1, text_star_1, targetItem);
			
	end
	
end

function DROP_CARD_1(parent, ctrl)
	
	local frame				= parent:GetTopParentFrame();
	if frame:GetUserValue("MODE") ~= "TARGET" then
		return;
	end
	local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
	if geClientCardBattle.GetTableInfoByHandle(ownerHandle).targetReady == true then
		return;
	end
	
	DROP_CARDBATTLE_CARD(frame);
	
end

function DROP_CARD_2(parent, ctrl)
	local frame	= parent:GetTopParentFrame();
	if frame:GetUserValue("MODE") ~= "HOST" then
		return;
	end

	local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
	if geClientCardBattle.GetTableInfoByHandle(ownerHandle).ownerReady == true then
		return;
	end

	DROP_CARDBATTLE_CARD(frame);
end

function DROP_CARDBATTLE_CARD(frame)

	local liftIcon 			= ui.GetLiftIcon();
	if liftIcon == nil then
		return;
	end

	local iconInfo			= liftIcon:GetInfo();
	if iconInfo == nil then
		return;
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if obj.GroupName ~= "Card" then
		ui.SysMsg(ClMsg("PutOnlyCardItem"));
		return;
	end
	imcSound.PlaySoundEvent("sys_card_battle_icon_equip");
	local ownerHandle = frame:GetUserIValue("OWNER_HANDLE");
	
	local targetWinCount = geClientCardBattle.GetTableInfoByHandle(ownerHandle).targetWinCount;
	if targetWinCount == -1 then
		ui.SysMsg(ClMsg("EnemyDoesNotExist"));
		return;
	end

	geClientCardBattle.PutMyCard( ownerHandle, GetIESID(obj) );
	
end

function CARDBATTLE_PUT_MY_CARD(guid)
	
	if 0 == ui.IsFrameVisible("cardbattle") then
		return;
	end

	local frame = ui.GetFrame("cardbattle");	
	local invItem = GET_PC_ITEM_BY_GUID(guid);
	local obj = GetIES(invItem:GetObject());

	local modeString = frame:GetUserValue("MODE");
	if modeString == "TARGET" then
		local card_1 = GET_CHILD(frame, "card_1");
		card_1:SetImage(obj.TooltipImage);
		SET_ITEM_TOOLTIP_BY_OBJ(card_1, invItem);

		local gbox_card_1 = frame:GetChild("gbox_card_1");
		local text_star_1 = frame:GetChild("text_star_1");
		CARDBATTLE_UPDATE_CARDINFO(gbox_card_1, text_star_1, obj);

		local bg = frame:GetChild("card_bg_1");
		UI_PLAYFORCE(card_1, "cardbattle_drop");
		UI_PLAYFORCE(bg, "cardbattle_drop");

		local posX, posY = GET_SCREEN_XY(bg);
		movie.PlayUIEffect(frame:GetUserConfig("UIEFFECT_DROP"), posX, posY, tonumber(frame:GetUserConfig("UIEFFECT_DROP_SCALE")));


	elseif modeString == "HOST" then
		local card_2 = GET_CHILD(frame, "card_2");
		card_2:SetImage(obj.TooltipImage);
		SET_ITEM_TOOLTIP_BY_OBJ(card_2, invItem);

		local gbox_card_2 = frame:GetChild("gbox_card_2");
		local text_star_2 = frame:GetChild("text_star_2");
		CARDBATTLE_UPDATE_CARDINFO(gbox_card_2, text_star_2, obj);

		local bg = frame:GetChild("card_bg_2");
		UI_PLAYFORCE(bg, "cardbattle_drop");
		UI_PLAYFORCE(card_2, "cardbattle_drop");

		local posX, posY = GET_SCREEN_XY(bg);
		movie.PlayUIEffect(frame:GetUserConfig("UIEFFECT_DROP"), posX, posY, tonumber(frame:GetUserConfig("UIEFFECT_DROP_SCALE")));

	end

end

function RESTART_CARD_BATTLE(ownerHandle)
	if 0 == ui.IsFrameVisible("cardbattle") then
		return;
	end

	local frame = ui.GetFrame("cardbattle");
	if frame:GetUserIValue("OWNER_HANDLE") == ownerHandle then	
		ui.CloseFrame("cardbattle_result");
		ui.CloseFrame("cardbattle_rullet");

		local card_1 = GET_CHILD(frame, "card_1");
		card_1:SetImage("test_card_slot");
		card_1:SetTooltipType('None');
		local card_2 = GET_CHILD(frame, "card_2");
		card_2:SetImage("test_card_slot");
		card_2:SetTooltipType('None');

		local gbox_card_1 = frame:GetChild("gbox_card_1");
		gbox_card_1:ShowWindow(0);
		local gbox_card_2 = frame:GetChild("gbox_card_2");
		gbox_card_2:ShowWindow(0);

		local text_star_1 = frame:GetChild("text_star_1");
		local text_star_2 = frame:GetChild("text_star_2");
		text_star_1:ShowWindow(0);
		text_star_2:ShowWindow(0);
		card_1:SetColorTone("FFFFFFFF");
		card_2:SetColorTone("FFFFFFFF");
	end

end



