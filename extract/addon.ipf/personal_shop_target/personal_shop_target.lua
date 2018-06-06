
function PERSONAL_SHOP_TARGET_ON_INIT(addon, frame)


end

function TARGET_PERSONALSHOP_LIST(groupName, sellType, handle)
	packet.RequestItemList(IT_WAREHOUSE);

	local frame = ui.GetFrame("personal_shop_target");

	frame:SetUserValue("HANDLE", handle);
	frame:SetUserValue("GROUPNAME", groupName);
	frame:SetUserValue("SELLTYPE", sellType);
	local ctrlsetType = "personalshop_target";
	local ctrlsetUpdateFunc = UPDATE_PERSONALSHOP_CTRLSET_TARGET;
	
	local titleName = session.autoSeller.GetTitle(groupName);
	local gbox = frame:GetChild("gbox");
	local items = gbox:GetChild("items");
	items:RemoveAllChild();
	
	local cnt = session.autoSeller.GetCount(groupName);
	for i = 0 , cnt - 1 do
		local info = session.autoSeller.GetByIndex(groupName, i);
		local ctrlSet = items:CreateControlSet(ctrlsetType, "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 5, 0, 0, 0);
		ctrlsetUpdateFunc(ctrlSet, info);
		ctrlSet:SetUserValue("TYPE", info.classID);
		ctrlSet:SetUserValue("INDEX", 0);
	end

	GBOX_AUTO_ALIGN(items, 10, 10, 10, true, false);
	frame:ShowWindow(1);


	PERSONAL_SHOP_TARGET_CLEAR_SELL(frame);
	PERSONAL_SHOP_TARGET_UPDATE_PRICE(frame);

	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "_CHECK_PERSONALSHOP_ITEM");
	invframe:SetUserValue("PSGroupName", groupName)
	invframe:ShowWindow(1);
end

function _CHECK_PERSONALSHOP_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local groupName = slot:GetTopParentFrame():GetUserValue("PSGroupName");
		local sellInfo = session.autoSeller.GetByType(groupName, item.type);
		if sellInfo == nil then
			slot:GetIcon():SetGrayStyle(1);
			slot:StopUIEffect("PersonalShop", true, 0.0);
		else
			slot:GetIcon():SetGrayStyle(0);
			slot:PlayUIEffect("I_sys_item_slot_loop", 2.2, "PersonalShop");
		end
		
	end
end

function CLOSE_PERSONAL_SHOP_TARGET(frame)
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	invframe:ShowWindow(0);
end

function UPDATE_PERSONALSHOP_CTRLSET_TARGET(ctrlSet, info)
	local itemObj = GetClassByType("Item", info.classID);
	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, itemObj);
	ctrlSet:SetUserValue("Type", info.classID);
	ctrlSet:GetChild("itemname"):SetTextByKey("value", itemObj.Name);
	ctrlSet:GetChild("remaincount"):SetTextByKey("value", info.remainCount);
	local priceStr = GetCommaedText(info.price);
	ctrlSet:GetChild("price"):SetTextByKey("value", priceStr);
end

function PERSONAL_SHOP_TARGET_CLEAR_SELL(frame)

	local sellbox = frame:GetChild("sellbox");
	local sellslots = GET_CHILD(sellbox, "sellslots");
	sellslots:ClearIconAll();

end

function PERSONAL_SHOP_TARGET_UPDATE_PRICE(frame)
	local sellbox = frame:GetChild("sellbox");
	local sellslots = GET_CHILD(sellbox, "sellslots");
	
	local groupName = frame:GetUserValue("GROUPNAME");
	local t_totalprice = sellbox:GetChild("t_totalprice");

	local totalPrice = 0;
	for i = 0 , sellslots:GetSlotCount() - 1 do
		local slot = sellslots:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			local type = icon:GetInfo().type;
			local count = icon:GetInfo().count;
			local sellInfo = session.autoSeller.GetByType(groupName, type);
			local price = sellInfo.price * count;
			totalPrice = totalPrice + price;
		end
	end

	local priceTxt = GET_MONEY_IMG(24) .. " " .. GetCommaedText(totalPrice);
	t_totalprice:SetTextByKey("value", priceTxt);

end

function CLEAR_PERSONAL_SLOT(parent, slot)
	local frame = parent:GetTopParentFrame();
	CLEAR_SLOT_ITEM_INFO(slot);
	PERSONAL_SHOP_TARGET_UPDATE_PRICE(frame);
end

function DROP_PERSONAL_SLOT(parent, slot, str, num)

	local liftIcon = ui.GetLiftIcon():GetInfo();
	local invItem = session.GetInvItemByGuid(liftIcon:GetIESID());
	if invItem == nil then
		return;
	end
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	local frame = parent:GetTopParentFrame();
	local groupName = frame:GetUserValue("GROUPNAME");
	local sellInfo = session.autoSeller.GetByType(groupName, invItem.type);
	if sellInfo == nil then
		ui.SysMsg(ClMsg("BuyerNotWantThisItem"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	local noTrade = TryGetProp(obj, "BelongingCount");
	local tradeCount = invItem.count;
	if nil ~= noTrade then
		local wareItem = session.GetWarehouseItemByType(obj.ClassID);
		local wareCnt = 0;
		if nil ~= wareItem then
			wareCnt = wareItem.count;
		end
		tradeCount = (invItem.count + wareCnt) - noTrade;
		if tradeCount > invItem.count then
			tradeCount = invItem.count;
		end
		if 0 >= tradeCount then
			ui.SysMsg(ClMsg("ItemOverCount"));	
			return;
		end
	end

	local maxCount = math.min(tradeCount, sellInfo.remainCount);
	INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_REGISTER_PERSONAL_SHOP_ITEM_SELL", maxCount, 1, maxCount, nil, invItem:GetIESID(), 1);
	frame:SetUserValue("SLOT_INDEX", slot:GetSlotIndex());


end

function EXEC_REGISTER_PERSONAL_SHOP_ITEM_SELL(frame, numberString, inputFrame)

	local itemID = inputFrame:GetUserValue("ArgString");

	local sellbox = frame:GetChild("sellbox");
	local sellslots = GET_CHILD(sellbox, "sellslots");
	local slotIndex = frame:GetUserIValue("SLOT_INDEX");
	local slot = sellslots:GetSlotByIndex(slotIndex);
	local invItem = session.GetInvItemByGuid(itemID);
	if invItem == nil then
		return;
	end
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	local groupName = frame:GetUserValue("GROUPNAME");
	local inputCnt = tonumber(numberString);
	local obj = GetIES(invItem:GetObject());
	local noTrade = TryGetProp(obj, "BelongingCount");
	local tradeCount = inputCnt;
	if nil ~= noTrade then
		local wareItem = session.GetWarehouseItemByType(obj.ClassID);
		local wareCnt = 0;
		if nil ~= wareItem then
			wareCnt = wareItem.count;
		end
		tradeCount = (invItem.count + wareCnt) - noTrade;
		if tradeCount > inputCnt then
			tradeCount = inputCnt;
		end
	end

	if 0 > inputCnt or inputCnt > tradeCount then
		ui.SysMsg(ClMsg("ItemOverCount"));	
		return;
	end

	inputFrame:ShowWindow(0);

	local beforeSlot = GET_SLOT_BY_TYPE(sellslots, invItem.type);
	if beforeSlot ~= nil then
		CLEAR_SLOT_ITEM_INFO(beforeSlot);
	end

	SET_SLOT_ITEM(slot, invItem, inputCnt);
	SET_SLOT_COUNT_TEXT(slot, inputCnt);
	PERSONAL_SHOP_TARGET_UPDATE_PRICE(frame);
	
end

function SELL_PERSONALSHOP_TARGET(parent, ctrl)
	ui.MsgBox(ClMsg("ReallySell?"), "EXEC_SELL_PERSONALSHOP_TARGET", "None");	
end

function EXEC_SELL_PERSONALSHOP_TARGET()
	local frame = ui.GetFrame("personal_shop_target");
	local sellbox = frame:GetChild("sellbox");
	local sellslots = GET_CHILD(sellbox, "sellslots");

	session.ResetItemList();

	for i = 0 , sellslots:GetSlotCount() - 1 do
		local slot = sellslots:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			local iesID = icon:GetInfo():GetIESID();
			local count = icon:GetInfo().count;
			session.AddItemID(iesID, count);
		end
	end

	local sellType = frame:GetUserIValue("SELLTYPE");
	local handle =  frame:GetUserIValue("HANDLE");
	session.autoSeller.BuyItems(handle, sellType, session.GetItemIDList());

end



