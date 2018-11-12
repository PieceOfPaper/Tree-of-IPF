-- legendcardupgrade.lua


function LEGENDCARDUPGRADE_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_LEGENDCARDUPGRADE_UI", "LEGENDCARDUPGRADE_FRAME_OPEN");
end

function LEGENDCARDUPGRADE_FRAME_OPEN()

	ui.OpenFrame("legendcardupgrade")
	local frame = ui.GetFrame('legendcardupgrade')

	CARD_SLOTS_CREATE(frame)
	LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, 3)
	local optionGbox = GET_CHILD_RECURSIVELY(frame, "option_bg")
	optionGbox:ShowWindow(1)
	LEGENDCARD_UPGRADE_PERCENT_OPEN(frame)
end


function OPEN_LEGENDCARD_REINFORCE(frame)
	LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, 3);
	local needItemSlot = GET_CHILD_RECURSIVELY(frame, "materialItem_slot")
	local needItemIcon = CreateIcon(needItemSlot);
	needItemIcon:SetImage("icon_item_legend_card_misc")
	local materialCls = GetClass("Item", 'legend_card_reinforce_misc')


	SET_ITEM_TOOLTIP_ALL_TYPE(needItemIcon, nil, materialCls.ClassName, 'LegendCardReinforce', materialCls.ClassID, 0)
		
	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2:ShowWindow(0)
	ui.OpenFrame("inventory");
				 
	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn : SetTextByKey("value", ClMsg("Reinforce_2"))
	frame:SetUserValue("IsVisibleResult", 0)

end

function CLOSE_LEGENDCARD_REINFORCE(frame)
	LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, 3);
	ui.CloseFrame("inventory");
end

function LEGENDCARDUPGRADE_FRAME_CLOSE(frame)
	
end


function LEGENDCARD_UPGRADE_PERCENT_OPEN(monsterCardSlotFrame)
	local frame = monsterCardSlotFrame;
	if frame == nil then
		frame = ui.GetFrame('legendcardupgrade')
	end

	local optionGbox = GET_CHILD_RECURSIVELY(frame, "option_bg")
	if optionGbox ~= nil then
		optionGbox:RemoveAllChild();
	end

end


function LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, clearType)
	local frame = ui.GetFrame('legendcardupgrade')
	local legendCardSlot = GET_CHILD_RECURSIVELY(frame, "LEGcard_slot")
	if clearType == 3 then
		legendCardSlot:ClearIcon()
		legendCardSlot:SetText("")
	end
	
	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, "upgradeBtn")
	upgradeBtn:SetTextByKey("value", ClMsg("Reinforce_2"))
	frame : SetUserValue("IsVisibleResult", 0)
	local legendCardNameGbox = GET_CHILD_RECURSIVELY(frame, 'legendcardnameGbox')
	legendCardNameGbox:ShowWindow(0)

		--4빼야함
	for i = 1, 4 do
		local materialCardSlot = GET_CHILD_RECURSIVELY(frame, "material_slot" .. i)
		materialCardSlot:ClearIcon()
		materialCardSlot:SetText("")
	end		

	local materialItemSlot = GET_CHILD_RECURSIVELY(frame, "materialItem_slot")
	if clearType == 3 then
		materialItemSlot:SetText("")
	end
	
	local successPercentText = GET_CHILD_RECURSIVELY(frame, 'success_percent')
	local failPercentText = GET_CHILD_RECURSIVELY(frame, 'fail_percent')
	local brokenPercentText = GET_CHILD_RECURSIVELY(frame, 'broken_percent')
	if successPercentText == nil or failPercentText == nil or brokenPercentText == nil then
		return
	end

	successPercentText:SetTextByKey("value", 0);
	failPercentText:SetTextByKey("value", 0);
	brokenPercentText:SetTextByKey("value", 0);

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox : ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2 : ShowWindow(0)

	INVENTORY_SET_ICON_SCRIPT("LEGENDCARD_REINFORCE_RECOVER_ICON");
end

-- 인벤토리의 카드 슬롯 오른쪽 클릭시 정보창오픈 과정시작 스크립트
function MATERIAL_CARD_SLOT_RBTNUP_ITEM_INFO(frame, slot, argStr, argNum)
	local icon = slot:GetIcon();		
	if icon == nil then		
		return;		
	end;

	local parentSlotSet = slot:GetTopParentFrame()
	if parentSlotSet == nil then
		return
	end

	local invSlotIcon = slot:GetIcon()
	if invSlotIcon == nil then
		return
	end

	local invSlotInfo = invSlotIcon :GetInfo()
	if invSlotInfo == nil then
		return
	end

	local invItem = GET_ITEM_BY_GUID(invSlotInfo:GetIESID())

	slot:ClearIcon();
	slot:SetText("")
	CALC_UPGRADE_PERCENTS(frame)
	if slot:GetName() == 'LEGcard_slot' then
		local legendCardNameGbox = GET_CHILD_RECURSIVELY(parentSlotSet, 'legendcardnameGbox')
		legendCardNameGbox : ShowWindow(0)
		local materialItemSlot = GET_CHILD_RECURSIVELY(parentSlotSet, 'materialItem_slot')

		materialItemSlot:SetText("")

		local successPercentText = GET_CHILD_RECURSIVELY(parentSlotSet, 'success_percent')
		local failPercentText = GET_CHILD_RECURSIVELY(parentSlotSet, 'fail_percent')
		local brokenPercentText = GET_CHILD_RECURSIVELY(parentSlotSet, 'broken_percent')
		if successPercentText == nil or failPercentText == nil or brokenPercentText == nil then
			return
		end

		INVENTORY_SET_ICON_SCRIPT("LEGENDCARD_REINFORCE_RECOVER_ICON");

		successPercentText:SetTextByKey("value", 0);
		failPercentText:SetTextByKey("value", 0);
		brokenPercentText:SetTextByKey("value", 0);
						 
		for i = 1, 4 do
			local materialSlot = GET_CHILD_RECURSIVELY(frame, "material_slot"..i)
			materialSlot:ClearIcon();
			materialSlot:SetText("")
		end					
	end

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox : ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2 : ShowWindow(0)

	
	local invenSlot = INV_GET_SLOT_BY_ITEMGUID(invSlotInfo:GetIESID())
	local invenIcon = invenSlot:GetIcon();
	invenIcon:SetColorTone("FFFFFFFF");

end


-- 몬스터 카드를 카드 슬롯에 드레그드롭으로 장착하려 할 경우.
function MATERIAL_CARD_SLOT_DROP(frame, slot, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();

	if toFrame:GetName() == 'legendcardupgrade' then
		local iconInfo = liftIcon:GetInfo();

		if iconInfo == nil then
			return
		end

		local invItem = session.GetInvItem(iconInfo.ext);		
		if nil == invItem then
			return;
		end
		
		local obj = GetIES(invItem:GetObject())
		if obj == nil then
			return
		end

		if slot:GetName() == 'LEGcard_slot' then
			if obj.CardGroupName ~= nil and obj.CardGroupName ~= 'LEG' then
				ui.SysMsg(ClMsg("LegendCardReinforce_OnlyLegCard"));
				return
			end
			LEGENDCARD_SET_SLOT(slot, invItem)
		else
			LEGENDCARD_MATERIAL_SET_SLOT(slot, invItem);
		end
	end

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2:ShowWindow(0)

end;
	
function LEGENDCARD_SET_SLOT(slot, invItem)
	local obj = GetIES(invItem:GetObject());
	local frame = ui.GetFrame("legendcardupgrade")
	if frame == nil then
		return
	end

	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn : SetTextByKey("value", ClMsg("Reinforce_2"))
	frame:SetUserValue("IsVisibleResult", 0)

	if obj.GroupName == "Card" then
		local invFrame    = ui.GetFrame("inventory");	
	
		local legendSlot = GET_CHILD_RECURSIVELY(frame, "LEGcard_slot")
		local icon = legendSlot:GetIcon()

		if icon ~= nil then
			local iconInfo = icon:GetInfo()
			local legendCardIconInfo = iconInfo:GetIESID()
			local invItemGUID = invItem:GetIESID()
			if legendCardIconInfo == invItemGUID then
				return
			end
			frame:SetUserValue("ITEM_GUID", invItemGUID)
		end
				
		local legendCardLv = GET_ITEM_LEVEL(obj)
		if legendCardLv >= 10 then
			ui.SysMsg(ClMsg("CanNotEnchantMore"));
			return
		end

		SET_SLOT_INVITEM_NOT_COUNT(slot, invItem)
		local legendSlotIcon = legendSlot:GetIcon()
		if legendSlotIcon ~= nil then
			local legendCardNameGbox = GET_CHILD_RECURSIVELY(frame, 'legendcardnameGbox')
			legendCardNameGbox : ShowWindow(1)
			local legendCardNameText = GET_CHILD_RECURSIVELY(frame, "legendcard_name_text")
			local legendIconInfo = legendSlotIcon:GetInfo();
	
			local cls = GetClassByType("Item", legendIconInfo.type)
			legendCardNameText:SetTextByKey("value", cls.Name)
		end

		SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, 1);

		frame:SetUserValue(slot:GetName(), itemGuid)
		CALC_UPGRADE_PERCENTS(frame)

		local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
		local needItemCountText = ""
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(legendCardReinforceList,i);
			local cardLv = TryGetProp(cls, "CardLevel");
			if cardLv == legendCardLv and obj.CardGroupName ~= nil and obj.CardGroupName == 'LEG' then
				local needReinforceItem = TryGetProp(cls, 'NeedReinforceItem')
				local needReinforceItemCount = TryGetProp(cls, 'NeedReinforceItemCount')
				local needItemSlot = GET_CHILD_RECURSIVELY(frame, "materialItem_slot")
				local needItemIcon = needItemSlot:GetIcon()
				if needItemIcon == nil then
					return
				end

				local needItemCls = GetClass("Item", needReinforceItem)
				if needItemCls ~= nil then
					local invItem = session.GetInvItemByName(needReinforceItem)
					local invItemCount = 0
					if invItem ~= nil then
						invItemCount = invItem.count
					end
					
					needItemCountText = invItemCount .. '/' ..needReinforceItemCount
					if invItemCount < needReinforceItemCount then
						local lackColor = frame:GetUserConfig("TEXT_COLOR_LACK_OF_MATERIAL")
						needItemCountText = lackColor ..needItemCountText .. '{/}'
					else
						local enoughColor = frame:GetUserConfig("TEXT_COLOR_ENOUGH_OF_MATERIAL")
						needItemCountText = enoughColor .. needItemCountText .. '{/}'
					end
					needItemSlot : SetText(needItemCountText)
				end
			end
		end
	end;	
	
	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2 : ShowWindow(0)

	frame:SetUserValue("ITEM_GUID", invItem:GetIESID());
	INVENTORY_SET_ICON_SCRIPT("LEGENDCARD_REINFORCE_CHECK_ICON", "GET_LEGENDCARD_REINFORCE_ITEM");

end

function LEGENDCARD_MATERIAL_SET_SLOT(slot, invItem)
	local obj = GetIES(invItem:GetObject());
	local frame = ui.GetFrame("legendcardupgrade")
	if frame == nil then
		return
	end

	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn : SetTextByKey("value", ClMsg("Reinforce_2"))
	frame:SetUserValue("IsVisibleResult", 0)
	
	if obj.GroupName == "Card" then
		local invFrame    = ui.GetFrame("inventory");	

		local legendSlot = GET_CHILD_RECURSIVELY(frame, "LEGcard_slot")
		local icon = legendSlot:GetIcon()
		if icon == nil then
			ui.SysMsg(ClMsg("LegendCardReinforce_Need_LegCard"));
			return
		end

		local iconInfo = icon:GetInfo()
		local legendCardIconInfo = iconInfo:GetIESID()
		local invItemGUID = invItem:GetIESID()
		if legendCardIconInfo == invItemGUID then
			return
		end

		for i = 1, 4 do
			local materialSlot = GET_CHILD_RECURSIVELY(frame, "material_slot"..i)
			local icon = materialSlot:GetIcon()
			if icon ~= nil then
				local iconInfo = icon:GetInfo()
				local materialCardIconInfo = iconInfo : GetIESID()
				local invItemGUID = invItem:GetIESID()
				if materialCardIconInfo == invItemGUID then
					return
				end
			end
		end
					
		SET_SLOT_INVITEM_NOT_COUNT(slot, invItem)

		SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, 1);

		frame:SetUserValue(slot:GetName(), itemGuid)
		CALC_UPGRADE_PERCENTS(frame)
	end;	

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2:ShowWindow(0)
	local legendCardNameGbox = GET_CHILD_RECURSIVELY(frame, 'legendcardnameGbox')
	legendCardNameGbox : ShowWindow(1)	

	frame:SetUserValue("ITEM_GUID", invItem:GetIESID());
	INVENTORY_SET_ICON_SCRIPT("LEGENDCARD_REINFORCE_CHECK_ICON", "GET_LEGENDCARD_REINFORCE_ITEM");

	LEGENDCARD_REINFORCE_INV_RBTN(invItem, slot)
end

function CALC_UPGRADE_PERCENTS()
	local frame = ui.GetFrame('legendcardupgrade');

	local legendCardSlot = GET_CHILD_RECURSIVELY(frame, 'LEGcard_slot')
	if legendCardSlot == nil then
		successPercentText:SetTextByKey("value", 0);
		failPercentText:SetTextByKey("value", 0);
		brokenPercentText:SetTextByKey("value", 0);
		return
	end

	local legendCardIcon = legendCardSlot:GetIcon();
	local needPoint = 0;
	if legendCardIcon ~= nil then
		local legendCardIconInfo = legendCardIcon:GetInfo()
		local legendCardInvItem = GET_ITEM_BY_GUID(legendCardIconInfo : GetIESID())
		local legendCardObj = GetIES(legendCardInvItem : GetObject());

		if legendCardObj == nil then
			needPoint = 0
		end

		local legendCardType = TryGetProp(legendCardObj, 'Reinforce_Type')
		if legendCardType ~= 'Legend_Card' then
			needPoint = 0
		end

		local legendCardLv = GET_ITEM_LEVEL(legendCardObj)
		local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
		local reinforceCardCls = nil;
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(legendCardReinforceList,i);
			local cardLv = TryGetProp(cls, "CardLevel");
			local reinforceType = TryGetProp(cls, "ReinforceType")
			
			if cardLv == legendCardLv and reinforceType == legendCardType then
				needPoint = TryGetProp(cls, "NeedPoint")
			end
		end
	end

	local totalGivePoint = 0;
	local materialSlot = nil
	for i = 1, 4 do
		materialSlot = GET_CHILD_RECURSIVELY(frame, 'material_slot'..i)
		local materialIcon = materialSlot:GetIcon();
	
		if materialIcon ~= nil then
			local givePoint = 0
			local materialIconInfo = materialIcon:GetInfo()
			local materialInvItem = GET_ITEM_BY_GUID(materialIconInfo:GetIESID())
			local materialCardObj = GetIES(materialInvItem : GetObject());
			if materialCardObj == nil then
				givePoint = 0
			end

			local materialType = materialCardObj.Reinforce_Type
			local materialCardLv = GET_ITEM_LEVEL(materialCardObj)
			-- 이 두개로 material reinforce class 받아서 Give 포인트 찾아서 누적시켜주기

			local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")

			for i = 0, cnt - 1 do
				local cls = GetClassByIndexFromList(legendCardReinforceList,i);
				local cardLv = TryGetProp(cls, "CardLevel");
				local reinforceType = TryGetProp(cls, "ReinforceType")
			
				if cardLv == materialCardLv and reinforceType == materialType then
					givePoint = TryGetProp(cls, "GivePoint")
					totalGivePoint = totalGivePoint + givePoint
				end
			end
		end
	end

	local givePerNeedPoint = 0
	if needPoint == 0 then
		givePerNeedPoint = 0
	else
		givePerNeedPoint = totalGivePoint / needPoint
	end

	local successPercent = 0
	local failPercent = 0
	local brokenPercent = 0

	successPercent = math.floor(givePerNeedPoint * 100 + 0.5)
	failPercent = math.floor((1 - givePerNeedPoint) * 0.4 * 100 + 0.5)
	brokenPercent = 100 - (successPercent + failPercent)

	if successPercent > 100 then
		successPercent = 100
	elseif successPercent < 0 then
		successPercent = 0
	end

	if failPercent > 100 then
		failPercent = 100
	elseif failPercent < 0 then
		failPercent = 0
	end

	if brokenPercent > 100 then
		brokenPercent = 100
	elseif brokenPercent < 0 then
		brokenPercent = 0
	end


	local successPercentText = GET_CHILD_RECURSIVELY(frame, 'success_percent')
	local failPercentText = GET_CHILD_RECURSIVELY(frame, 'fail_percent')
	local brokenPercentText = GET_CHILD_RECURSIVELY(frame, 'broken_percent')
	if successPercentText == nil or failPercentText == nil or brokenPercentText == nil then
		return
	end
		
	successPercentText:SetTextByKey("value", successPercent);
	failPercentText:SetTextByKey("value", failPercent);
	brokenPercentText:SetTextByKey("value", brokenPercent);
end

function DO_LEGENDCARD_UPGRADE_LBTNUP(frame, slot, argStr, argNum)
	local frame = ui.GetFrame('legendcardupgrade');
	local isVisibleResult = frame:GetUserIValue("IsVisibleResult")
	
	if isVisibleResult == 1 then
		LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, 1)
		return
	end		
		
	session.ResetItemList();	

	local legendCardSlot = GET_CHILD_RECURSIVELY(frame, 'LEGcard_slot')
	local legendCardSlotIcon = legendCardSlot:GetIcon()

	if legendCardSlotIcon == nil then
		ui.SysMsg(ClMsg("LegendCardReinforce_Need_LegCard"));
		return
	end

	local legendCardSlotInfo = legendCardSlotIcon:GetInfo()
	if legendCardSlotInfo == nil then
		return
	end

	local legendCardInvItem = GET_ITEM_BY_GUID(legendCardSlotInfo:GetIESID())
	if legendCardInvItem == nil then
		return
	end

	session.AddItemID(legendCardSlotInfo:GetIESID());

	if legendCardInvItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- 4를 빼놓자
	local isSlotEmpty = 1
	for i = 1, 4 do
		local materialCardSlot = GET_CHILD_RECURSIVELY(frame, 'material_slot'..i)
		local materialCardSlotIcon = materialCardSlot:GetIcon()
		if materialCardSlotIcon ~= nil then
			local materialCardSlotInfo = materialCardSlotIcon:GetInfo()
			if materialCardSlotInfo ~= nil then
				local materialCardInvItem = GET_ITEM_BY_GUID(materialCardSlotInfo:GetIESID())
				if materialCardInvItem ~= nil then
					session.AddItemID(materialCardSlotInfo:GetIESID());
					isSlotEmpty = 0
				end
			end
		end		
	end

	if isSlotEmpty == 1 then
		ui.SysMsg(ClMsg("LegendCardReinforce_Need_Card"));
		return
	end
	
	local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
	local needReinforceItem = 'None';
	local needReinforceItemCount = 0;
	local legendCardObj = GetIES(legendCardInvItem:GetObject())
	local legendCardLv = GET_ITEM_LEVEL(legendCardObj)

	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(legendCardReinforceList,i);
		local cardLv = TryGetProp(cls, "CardLevel");
		local reinforceType = TryGetProp(cls, 'ReinforceType')
		if cardLv == legendCardLv and reinforceType == 'LegendCard' and legendCardObj.CardGroupName ~= nil and legendCardObj.CardGroupName == 'LEG' then
			needReinforceItem = TryGetProp(cls, 'NeedReinforceItem')
			needReinforceItemCount = TryGetProp(cls, 'NeedReinforceItemCount')
		end
	end

	if needReinforceItem == nil or needReinforceItem == 'None' then
		return
	end

	local needInvItem = session.GetInvItemByName(needReinforceItem)
	if needInvItem == nil then
		ui.SysMsg(ClMsg("LegendCardReinforce_NeedItem"));
		return
	end

	if needInvItem.count < needReinforceItemCount then
		ui.SysMsg(ClMsg("LegendCardReinforce_NeedItem"));
		return
	end
	
	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, "resultGbox2")
	resultGbox2 : ShowWindow(0)
			
	frame:SetUserValue("legendCardGUID", legendCardSlotInfo:GetIESID())
	ui.MsgBox_NonNested(ClMsg("LegendCardReinforce_OK"), frame:GetName(), "LEGENDCARD_REINFORCE_EXEC", "LEGENDCARD_REINFORCE_CANCEL");			
end


function LEGENDCARD_REINFORCE_CANCEL()

end;

function LEGENDCARD_REINFORCE_EXEC()
	--ui.SetHoldUI(true);
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("LEGENDCARD_UPGRADE_TX", resultlist);
end

function LEGENDCARD_REINFORCE_TIMER(ctrl, str, tick)
	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();
		ReserveScript("LEGENDCARD_UPGRADE_EFFECT()", 0.3);
	elseif tick == 30 then	
		local frame = ctrl:GetTopParentFrame();
		local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
		resultGbox : ShowWindow(0)
		local resultGbox2 = GET_CHILD_RECURSIVELY(frame, 'resultGbox2')
		resultGbox2 : ShowWindow(0)
	end
end

function LEGENDCARD_UPGRADE_EFFECT()
--	ui.SetHoldUI(false);
	local frame = ui.GetFrame("legendcardupgrade");
	LEGENDCARD_UPGRADE_DRAW_RESULT(frame)
		
end

function LEGENDCARD_UPGRADE_DRAW_RESULT(frame)
	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox : ShowWindow(1)

	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn : EnableHitTest(1)
end

function LEGENDCARD_UPGRADE_UPDATE(resultFlag, beforeLv, afterLv)
	local frame = ui.GetFrame("legendcardupgrade")
	LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, resultFlag)
	local timer = GET_CHILD_RECURSIVELY(frame, "timer");
	timer:ShowWindow(1);
	timer:ForcePlayAnimation();

	--결과에 따라 이팩트 따로 출력
	
	local resultImage = GET_CHILD_RECURSIVELY(frame, 'resultImage')
	local beforeLvText = GET_CHILD_RECURSIVELY(frame, 'before_lv')
	local afterLvText = GET_CHILD_RECURSIVELY(frame, 'after_lv')
	beforeLvText:SetTextByKey("value", "LV" .. beforeLv)

	local needItemSlot = GET_CHILD_RECURSIVELY(frame, 'materialItem_slot')
	local legCardGUID = frame : GetUserValue("legendCardGUID")
	local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
	local needItemCountText = "";
	if resultFlag ~= 3 then
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(legendCardReinforceList,i);
			local cardLv = TryGetProp(cls, "CardLevel");
			local legCardInvItem = session.GetInvItemByGuid(legCardGUID);
			local obj = GetIES(legCardInvItem:GetObject())
			if cardLv == afterLv and obj.CardGroupName ~= nil and obj.CardGroupName == 'LEG' then
				local needReinforceItem = TryGetProp(cls, 'NeedReinforceItem')
				local needReinforceItemCount = TryGetProp(cls, 'NeedReinforceItemCount')
				local needItemCls = GetClass("Item", needReinforceItem)
				if needItemCls ~= nil then
					local invItem = session.GetInvItemByName(needReinforceItem)
					local invItemCount = 0
					if invItem ~= nil then
						invItemCount = invItem.count
					end
					
					needItemCountText = invItemCount .. '/' ..needReinforceItemCount
					if invItemCount < needReinforceItemCount then
						local lackColor = frame:GetUserConfig("TEXT_COLOR_LACK_OF_MATERIAL")
						needItemCountText = lackColor ..needItemCountText .. '{/}'
					else
						local enoughColor = frame:GetUserConfig("TEXT_COLOR_ENOUGH_OF_MATERIAL")
						needItemCountText = enoughColor .. needItemCountText .. '{/}'
					end
				end
			end
		end
	end
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	local gbox = popupFrame:GetChild("gbox");
	gbox:RemoveAllChild();
	
	--SETTEXT_GUIDE(frame, 2, resultTxt);
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true , true);
	
	ui.SetTopMostFrame(popupFrame);
	popupFrame:Resize(popupFrame:GetWidth(), gbox:GetHeight());

	local resulteffect_position_slot = GET_CHILD_RECURSIVELY(frame, "resulteffect_position_slot");

	local posX, posY = GET_SCREEN_XY(resulteffect_position_slot);
	movie.PlayUIEffect(frame:GetUserConfig("UPGRADE_RESULT_EFFECT_START"), posX, posY, tonumber(frame:GetUserConfig("UPGRADE_RESULT_EFFECT_SCALE")))
	if resultFlag == 0 then
		return
	elseif resultFlag == 1 then
		--성공
		local legendCardSlot = GET_CHILD_RECURSIVELY(frame, 'LEGcard_slot')
		local icon = legendCardSlot:GetIcon()

		local legCardInvItem = session.GetInvItemByGuid(legCardGUID);
		local rewardLv = 0

		legendCardSlot:ClearIcon()
		SET_SLOT_INVITEM_NOT_COUNT(legendCardSlot, legCardInvItem)
		local obj = GetIES(legCardInvItem:GetObject())
		SET_SLOT_ITEM_TEXT_USE_INVCOUNT(legendCardSlot, legCardInvItem, obj, 1);
		needItemSlot:SetText(needItemCountText)
		afterLvText:SetTextByKey("value", "LV " .. afterLv)
		movie.PlayUIEffect(frame:GetUserConfig("UPGRADE_RESULT_EFFECT_SUCCESS"), posX, posY, tonumber(frame:GetUserConfig("LEGENDCARD_OPEN_EFFECT_SCALE")))
	elseif resultFlag == 2 then
		--실패
		needItemSlot:SetText(needItemCountText)
		afterLvText:SetTextByKey("value", "LV " ..afterLv)
		movie.PlayUIEffect(frame:GetUserConfig("UPGRADE_RESULT_EFFECT_FAIL"), posX, posY, tonumber(frame:GetUserConfig("LEGENDCARD_OPEN_EFFECT_SCALE")))
	elseif resultFlag == 3 then
		--파괴
		afterLvText:SetTextByKey("value", "DESTROY")
		movie.PlayUIEffect(frame:GetUserConfig("UPGRADE_RESULT_EFFECT_BROKEN"), posX, posY, tonumber(frame:GetUserConfig("LEGENDCARD_OPEN_EFFECT_SCALE")))
	end

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	local resultGbox2 = GET_CHILD_RECURSIVELY(frame, 'resultGbox2')
	resultGbox : ShowWindow(0)
	resultGbox2 : ShowWindow(1)
	
	local legCardSlot = GET_CHILD_RECURSIVELY(frame, "LEGcard_slot")
	legCardSlot:ClearIcon()
	legCardSlot:SetText("")
	local needItemSlot = GET_CHILD_RECURSIVELY(frame, "materialItem_slot")
	needItemSlot:ClearIcon()
	local needItemIcon = CreateIcon(needItemSlot);
	needItemIcon:SetImage("icon_item_legend_card_misc")

	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn:SetTextByKey("value", ClMsg("Confirm"))
	upgradeBtn:EnableHitTest(0)
	frame : SetUserValue("IsVisibleResult", 1)
end

function LEGENDCARD_REINFORCE_CHECK_ICON(slot, reinfItemObj, invItem, itemobj)
--	slot:EnableDrag(0);
--	slot:EnableDrop(0);
	local icon = slot:GetIcon();
	if itemobj ~= nil and reinfItemObj ~= nil and TryGetProp(reinfItemObj, 'Reinforce_Type') ~= nil then
		local reinforceCls = GetClass("Reinforce", reinfItemObj.Reinforce_Type);
		local materialScp = TryGetProp(reinforceCls, 'MaterialScript')
		if materialScp ~= nil then
			if 1 == _G[materialScp](reinfItemObj, itemobj) then
				if 0 == slot:GetUserIValue("LEGENDCARD_REINFORCE_SELECTED") and itemobj.ItemLifeTimeOver == 0 then
						icon:SetColorTone("FFFFFFFF");
					else
						icon:SetColorTone("33000000");
					end
					return;
				end
			end
		end
	
	if icon ~= nil then
		icon:SetColorTone("AA000000");
	end

end


function GET_LEGENDCARD_REINFORCE_ITEM()
	local frame = ui.GetFrame("legendcardupgrade");
	local guid = frame:GetUserValue("ITEM_GUID");
	if guid == nil then
		return nil
	end

	local invItem = GET_ITEM_BY_GUID(guid);
	if invItem == nil then
		return nil
	end
	return GetIES(invItem:GetObject());
end


function LEGENDCARD_REINFORCE_INV_RBTN(invitem, slot)        
	if nil == invitem then
		return;
	end

	if true == invitem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	local nowselectedcount = slot:GetUserIValue("LEGENDCARD_REINFORCE_SELECTED")

	if selectall == 'YES' then
		nowselectedcount = invitem.count -1;
	end

	if nowselectedcount < invitem.count then
		local slot = INV_GET_SLOT_BY_ITEMGUID(invitem:GetIESID())
		local icon = slot:GetIcon();

		slot:SetUserValue("LEGENDCARD_REINFORCE_SELECTED", nowselectedcount + 1);
		local nowselectedcount = slot:GetUserIValue("LEGENDCARD_REINFORCE_SELECTED")
					
		if icon ~= nil and nowselectedcount == invitem.count then
			icon:SetColorTone("AA000000");
		end
	end
end


function LEGENDCARD_REINFORCE_RECOVER_ICON(slot, reinfItemObj, invItem, itemobj)
	slot:SetUserValue("LEGENDCARD_REINFORCE_SELECTED", 0);
	local icon = slot:GetIcon();
	icon:SetColorTone("FFFFFFFF");
end

