function SHOPCOMMON_ON_INIT(addon, frame)

	
end

function SHOPCOMMON_ON_MSG(frame, msg, argStr, argNum)
	if msg == "COMMON_SHOP_ITEM_LIST_GET" then
		ui.OpenFrame("shopcommon");
		SHOPCOMMON_ITEM_LIST(frame);
		SHOPCOMMON_ITEM_SLOT_INIT(frame);
	end
end

function SHOPCOMMON_UI_OPEN(frame)
	OPEN_SHOPUI_COMMON();
end

function SHOPCOMMON_UI_CLOSE(frame, obj, argStr, argNum)
	control.DialogOk()
	
	local invenFrame = ui.GetFrame('inventory');
	if invenFrame:IsVisible() == 1 then
		invenFrame:ShowWindow(0);
	end
end

function SHOPCOMMON_ITEM_LIST(frame)
	local shopListGroupBox = GET_CHILD(frame, "shop", "ui::CGroupBox");
	shopListGroupBox:DeleteAllControl();
	
	local shopItemList = session.GetShopItemList();
	if shopItemList == nil then
		return;
	end
	
	local shopItemCount = shopItemList:Count();
	
	local shopPrevItemCtrlSet = nil;
	for i=0, shopItemCount-1 do
		local shopItemCtrlSet		= shopListGroupBox:CreateControlSet('shopitemset_Type', 'SHOPITEMLLIST_'..i, 8, 8);
		tolua.cast(shopItemCtrlSet, "ui::CControlSet");
		shopItemCtrlSet:SetEnableSelect(1);
		shopItemCtrlSet:SetSelectGroupName("ShopItemList");
		
		if i == 0 then
			shopItemCtrlSet:SetGravity(ui.LEFT, ui.TOP);
			shopPrevItemCtrlSet = shopItemCtrlSet;
		else 
			if i % 2 == 1 then
				shopItemCtrlSet:SetSnap(shopPrevItemCtrlSet, ui.AS_RIGHT, ui.AS_BOTTOM);
				shopItemCtrlSet:Move(-8, -8);
			elseif i % 2 == 0 then
				shopItemCtrlSet:SetSnap(shopPrevItemCtrlSet, ui.AS_BOTTOM, ui.AS_NONE);
				shopItemCtrlSet:Move(0, -8);
				shopPrevItemCtrlSet = shopItemCtrlSet;
			end
		end
		
		local shopItem	= shopItemList:PtrAt(i);
		
		local slot	 	= GET_CHILD(shopItemCtrlSet, "slot", "ui::CSlot");		
		local icon = CreateIcon(slot);

		local class 	= GetClassByType('Item', shopItem.type);
		local imageName = class.Icon;		
		icon:Set(imageName, 'SHOPITEM', i, 0);
		
	--SET_ITEM_TOOLTIP_TYPE(icon, class.ClassID, class);
	--icon:SetTooltipArg('sell', class.ClassID, shopItem.iesID);

		SET_ITEM_TOOLTIP_ALL_TYPE(icon, shopItem, class.ClassName, 'sell', class.ClassID, shopItem.iesID);

		
		slot:SetEventScript(ui.RBUTTONDOWN, 'SHOPCOMMON_SLOT_RBTNDOWN');
		slot:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
		slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
	
		-- ���������� ���� ǥ��
		if shopItem.count > 1 then
			slot:SetText(shopItem.count);
		end

		local printText	= '{@st42b}' .. GET_SHOPITEM_TXT(shopItem, class);
		local priceText	= string.format("{img icon_item_silver 20 20}{@st50}%s", GET_SHOPITEM_PRICE_TXT(shopItem));
		shopItemCtrlSet:SetEventScript(ui.RBUTTONDOWN, 'SHOPCOMMON_SLOT_RBTNDOWN');
		shopItemCtrlSet:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
		shopItemCtrlSet:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
		shopItemCtrlSet:SetTextByKey('ItemName_Count', printText);
		shopItemCtrlSet:SetTextByKey('Item_Price', priceText);
		shopItemCtrlSet:SetOverSound("button_over");
		
		local result = CHECK_EQUIPABLE(shopItem.type);
		if result ~= "OK" then
			icon:SetColorTone("FFFF0000");
			local printText	= '{@st51}' .. GET_SHOPITEM_TXT(shopItem, class);
			local priceText = string.format("{img icon_item_silver 20 20}{@st52}%s", GET_SHOPITEM_PRICE_TXT(shopItem));
			shopItemCtrlSet:SetTextByKey('ItemName_Count', printText);
			shopItemCtrlSet:SetTextByKey('Item_Price', priceText);
		end
	end
	
	shopListGroupBox:UpdateData();
end

function SHOPCOMMON_ITEM_SLOT_INIT(frame)
	local buyItemSlotSet = GET_CHILD(frame, "buyitemslot", "ui::CSlotSet");	
	local slotCount = buyItemSlotSet:GetSlotCount();
	
	for i = 0, slotCount - 1 do
		local slot = buyItemSlotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:ClearText();
			slot:ClearIcon();
			slot:SetValue(0);
		end
	end
	
	SHOPCOMMON_UPDATE_BUY_PRICE(frame);
end

function SHOPCOMMON_UPDATE_BUY_PRICE(frame)	
	local price = GET_TOTAL_BUY_PRICE(frame);
	local txt = frame:GetChild("pricetxt");
	if price >= 0 then
		txt:SetText("{@st57}" ..COLOR_YELLOW .. price);
	else
		txt:SetText("{@st58}" ..COLOR_RED .. price);
	end

	local totaltext = frame:GetChild("finalprice");
	local totalprice = SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), price);

	totaltext:SetText("{@st43}"..COLOR_YELLOW .. totalprice);

	return totalprice;
end

function SHOPCOMMON_SLOT_RBTNDOWN(frame, slot, argStr, argNum)
	local frame     = ui.GetFrame("shopcommon");
	SHOPCOMMON_BUY(frame, argStr, argNum);
	SHOPCOMMON_UPDATE_BUY_PRICE(frame);
end

function SHOPCOMMON_BUY(frame, imageName, itemIndex)	
	local TotalPrice = GET_TOTAL_BUY_PRICE(frame);
	local shopItemList = session.GetShopItemList();
	local shopItem	= shopItemList:PtrAt(itemIndex);

	if shopItem:GetPropName() ~= "None" then
		local used = GET_SHOP_TOTAL_USED_POINT(frame, shopItem);
		local remain = GET_SHOP_HAVE_POINT(shopItem);
		if used + 1 > remain then
			ui.AlarmMsg("ItemBuyCountLimited");
			return;
		end
	end

	if IsGreaterThanForBigNumber(shopItem.price + (-1 * TotalPrice), GET_TOTAL_MONEY_STR()) == 1 then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughMoney'));
		return;
	end
	
	local groupbox  = frame:GetChild('buyitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	imcSound.PlaySoundEvent('inven_equip');

	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		local slot 		= slotSet:GetSlotByIndex(i);

		local shopItemList = session.GetShopItemList();
		local shopItem	= shopItemList:PtrAt(itemIndex);

		local class 		= GetClassByType('Item', shopItem.type);
		local imageName 	= class.Icon;
		
		local slotBuyCount  = slot:GetValue();

		if slotIcon ~= nil and class.MaxStack >= slotBuyCount + 1 then
			if itemIndex == slot:GetSlotIndex() then
				slot:SetValue(slotBuyCount + 1);
				local slotIcon	= slotSet:GetIconByIndex(i);
				slot:SetText('{s18}{ol}{b}'..slotBuyCount+1, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
				slot:Invalidate();
				SHOPCOMMON_ITEM_LIST(frame);
				return;
			end
		end
	end

	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);

		if slotIcon == nil then
			local slot			= slotSet:GetSlotByIndex(i);
			local icon = CreateIcon(slot);
			icon:Set(imageName, 'BUYITEMITEM', itemIndex, 0);

			
			slot:SetSlotIndex(itemIndex);

			local itemlist = session.GetShopItemList();
			SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemlist:PtrAt(itemIndex), class.ClassName, 'sell', itemlist:PtrAt(itemIndex).type, nil);


		--SET_ITEM_TOOLTIP_TYPE(icon, itemlist:PtrAt(itemIndex).type);
		--icon:SetTooltipArg('sell', itemlist:PtrAt(itemIndex).type, nil);
			icon:SetValue(itemIndex);

			slot:SetEventScript(ui.RBUTTONDOWN, "CANCEL_BUY");
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
			slot:SetValue(1);
			SHOPCOMMON_ITEM_LIST(frame);
			return;
		end
	end
end

function SHOPCOMMON_BUTTON_BUYSELL(frame, slot, argStr, argNum)	
	local TotalPrice = GET_TOTAL_BUY_PRICE(frame);
	if IsGreaterThanForBigNumber(-TotalPrice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughMoney'));
		return;
	end	
	
	local isBuySound  = SHOPCOMMON_BUTTON_BUY(frame);		
	if isBuySound == true then
		imcSound.PlaySoundEvent("market buy");	
	end
	
	SHOPCOMMON_UPDATE_BUY_PRICE(frame);
end

function SHOPCOMMON_BUTTON_BUY(frame, slot, argStr, argNum)
	-- ������ ����
	local frame     = ui.GetFrame("shopcommon");	
	local buyslotSet= GET_CHILD(frame, "buyitemslot", "ui::CSlotSet");
	local slotCount = buyslotSet:GetSlotCount();
	local isSound = false;
	for i = 0, slotCount - 1 do
		local slotIcon	= buyslotSet:GetIconByIndex(i);

		if slotIcon ~= nil then
			local slot  = buyslotSet:GetSlotByIndex(i);
			item.AddToBuyList(slot:GetSlotIndex(), slot:GetValue());			
			slot:SetValue(0);
			slot:ClearText();
			isSound = true;
		end
	end
	item.BuyList();
	buyslotSet:ClearIconAll();
	
	return isSound;
end