
function OBLATION_SELL_ON_INIT(addon, frame)


end

function OBLATION_SELL_INIT(frame, totalItemCount, handle)
	frame:SetUserValue("TOTAL_ITEM_COUNT", totalItemCount);
	frame:SetUserValue("HANDLE", handle);

	local baseInfo = session.autoSeller.GetShopBaseInfo(AUTO_SELL_OBLATION);
	local curCount = frame:GetUserIValue("TOTAL_ITEM_COUNT");
	local maxCount = GET_OBLATION_MAX_COUNT(baseInfo.skillLevel);
	local ctrlset_box_count = frame:GetChild("ctrlset_box_count");
	local count = GET_CHILD(ctrlset_box_count, "count");
	count:SetTextByKey("curcount", curCount);
	count:SetTextByKey("maxcount", maxCount);
	
end

function OBLATION_SELL_GET_SLOTSET(frame)
	local gbox = frame:GetChild("gbox");
	local gbox_slotset = gbox:GetChild("gbox_slotset");
	return GET_CHILD(gbox_slotset, "slotset");
end

function OBLATION_SELL_OPEN(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("INV_RBTN_DOWN_OBLATION_SELL");
	INVENTORY_SET_CUSTOM_RDBTNDOWN("INV_RBTN_DBLDOWN_OBLATION_SELL");
	ui.OpenFrame("inventory");
end

function OBLATION_SELL_CLOSE(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_CUSTOM_RDBTNDOWN("NOne");
	ui.CloseFrame("inventory");
end

function OBLATION_SELL_ADD_SELL_ITEM(frame, invItem, addCount, iesID, countSet)
	local slotset = OBLATION_SELL_GET_SLOTSET(frame);
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemCls = GetIES(invItem:GetObject());
	local itemProp = geItemTable.GetPropByName(itemCls.ClassName);
	if itemProp:IsEnableShopTrade() == false then
		ui.SysMsg(ClMsg("Auto_SangJeom_PanMae_BulKaNeung"));
		return;
	end

	local duplicateSlot = GET_SLOT_BY_IESID(slotset, invItem:GetIESID());
	if duplicateSlot == nil then
		local emptySlot = GET_EMPTY_SLOT(slotset);
		if itemCls.MaxStack <= 1 then
			SET_SLOT_ITEM(emptySlot, invItem);	
		else
			SET_SLOT_ITEM(emptySlot, invItem, addCount)
			SET_SLOT_COUNT_TEXT(emptySlot, addCount);
		end
	else
		local iconInfo = duplicateSlot:GetIcon():GetInfo();
		iconInfo.count = iconInfo.count + addCount;
		if countSet ~= nil and countSet == true then
			iconInfo.count = addCount;
		end
		if iconInfo.count > invItem.count then
			iconInfo.count = invItem.count;
		end

		if itemCls.MaxStack > 1 then
			SET_SLOT_COUNT_TEXT(duplicateSlot, iconInfo.count);
		end
	end

	--inventory item check
	if iesID ~= nil then
		SHOP_SELECT_ITEM_LIST[iesID] = invItem.count;
	end

	--Check Slot Register
	INVENTORY_UPDATE_ICON_BY_INVITEM(ui.GetFrame('inventory'), invItem);
end

function INV_RBTN_DBLDOWN_OBLATION_SELL(itemObj, slot)
	local invItem = session.GetInvItemByGuid(GetIESID(itemObj));
	if invItem == nil then
		return;
	end
	local frame = ui.GetFrame("oblation_sell");
	local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", invItem.count);
	INPUT_NUMBER_BOX(frame, titleText, "SET_OBLATION_SELL_COUNT", 1, 1, invItem.count, nil, GetIESID(itemObj));
	
end

function SET_OBLATION_SELL_COUNT(frame, count, inputFrame)
	local iesid = inputFrame:GetUserValue("ArgString");
	local invItem = session.GetInvItemByGuid(iesid);
	local frame = ui.GetFrame("oblation_sell");
	OBLATION_SELL_ADD_SELL_ITEM(frame, invItem, count, nil, true);
	OBLATION_SELL_CALCULATE_PRICE(frame);
end

function INV_RBTN_DOWN_OBLATION_SELL(itemObj, slot, iesID)
	local invItem = session.GetInvItemByGuid(GetIESID(itemObj));
	if invItem == nil then
		return;
	end

	local frame = ui.GetFrame("oblation_sell");
	OBLATION_SELL_ADD_SELL_ITEM(frame, invItem, 1, iesID);
	OBLATION_SELL_CALCULATE_PRICE(frame);

end


function OBLATION_SELL_SLOT_RBTN(parent, slot)
	local frame = parent:GetTopParentFrame();
	local slotset = OBLATION_SELL_GET_SLOTSET(frame);
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	CLEAR_SLOT_ITEM_INFO(slot);
	OBLATION_SELL_CALCULATE_PRICE(frame);	

end

function GET_SLOT_OBLATION_SELL_PRICE(slot)
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return 0;
	end
	local itemCls = GetIES(invItem:GetObject());

	local iconInfo = slot:GetIcon():GetInfo();
	local slotCount = 0;
	if itemCls.MaxStack > 1 then
		slotCount = iconInfo.count;
	else
		slotCount = 1;	
	end
	local itemCls = GetIES(invItem:GetObject());
	local itemProp = geItemTable.GetPropByName(itemCls.ClassName);
	local price = math.floor(geItemTable.GetSellPrice(itemProp) * GET_OBLATION_PRICE_PERCENT());
	if 0 >= price then
		price = 1;
	end
	return price* slotCount;

end

function OBLATION_SELL_CLEAR(parent)
	local frame = ui.GetFrame("oblation_sell");
	local slotset = OBLATION_SELL_GET_SLOTSET(frame);
	CLEAR_SLOTSET(slotset);
	OBLATION_SELL_CALCULATE_PRICE(frame)
end

function OBLATION_SELL_CALCULATE_PRICE(frame)
	
	local slotset = OBLATION_SELL_GET_SLOTSET(frame);
	local expectedSellPrice = GET_FROM_ALL_ITEM_SLOT(slotset, GET_SLOT_OBLATION_SELL_PRICE);
	
	local gbox = frame:GetChild("gbox");
	local expectsilver = gbox:GetChild("expectsilver");
	expectsilver:SetTextByKey("value", expectedSellPrice);
	local myMoney = GET_TOTAL_MONEY();
	myMoney = myMoney + expectedSellPrice;
	local mysilver = gbox:GetChild("mysilver");
	mysilver:SetTextByKey("value", myMoney);

end

function OBLATION_SELL_EXEC(parent)
	ui.MsgBox(ScpArgMsg("ReallySell?"), "_OBLATION_SELL_EXEC()", "None");
end

function _OBLATION_SELL_EXEC()
	local frame = ui.GetFrame("oblation_sell");
	local slotSet = OBLATION_SELL_GET_SLOTSET(frame);

	session.ResetItemList();
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i );
		local slotItem = GET_SLOT_ITEM(slot);
		if slotItem ~= nil then
			local iconInfo = slot:GetIcon():GetInfo();
			local slotItemCls = GetIES(slotItem:GetObject());

			if slotItemCls.MaxStack > 1 then
			session.AddItemID(iconInfo:GetIESID(), iconInfo.count);
			else
				session.AddItemID(iconInfo:GetIESID(), 1);
			end
		end
	end

	local handle = frame:GetUserIValue("HANDLE");
	session.autoSeller.BuyItems(handle, AUTO_SELL_OBLATION, session.GetItemIDList());

	OBLATION_SELL_CLEAR(frame);

end



