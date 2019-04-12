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
	upgradeBtn : SetTextByKey("value", "Enhance")
	frame:SetUserValue("IsVisibleResult", 0)

end

function LEGENDCARD_UPGRADE_SLOT_CLEAR(frame, clearType)
	local frame = ui.GetFrame('legendcardupgrade')
	local legendCardSlot = GET_CHILD_RECURSIVELY(frame, "LEGcard_slot")
	if clearType == 3 then
		legendCardSlot:ClearIcon()
		legendCardSlot:SetText("")
	end
	
	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, "upgradeBtn")
	upgradeBtn:SetTextByKey("value", "Enhance")
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

function LEGENDCARD_SET_SLOT(slot, invItem)
	local obj = GetIES(invItem:GetObject());
	local frame = ui.GetFrame("legendcardupgrade")
	if frame == nil then
		return
	end

	local upgradeBtn = GET_CHILD_RECURSIVELY(frame, 'upgradeBtn')
	upgradeBtn : SetTextByKey("value", "Enhance")
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
	upgradeBtn : SetTextByKey("value", "Enhance")
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
	upgradeBtn:SetTextByKey("value", "Confirm")
	upgradeBtn:EnableHitTest(0)
	frame : SetUserValue("IsVisibleResult", 1)
end