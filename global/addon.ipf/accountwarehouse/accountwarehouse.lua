function ACCOUNTWAREHOUSE_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ACCOUNTWAREHOUSE", "ON_OPEN_ACCOUNTWAREHOUSE");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_LIST", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_ADD", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_REMOVE", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_CHANGE_COUNT", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_IN", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");


end

function ON_OPEN_ACCOUNTWAREHOUSE(frame)

	ui.OpenFrame("accountwarehouse");
end

function ACCOUNTWAREHOUSE_OPEN(frame)
	
	ui.OpenFrame("inventory");
	packet.RequestItemList(IT_ACCOUNT_WAREHOUSE);
	ui.EnableSlotMultiSelect(1);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ACCOUNT_WAREHOUSE_INV_RBTN")	

end
   
function ACCOUNTWAREHOUSE_CLOSE(frame)
	ui.EnableSlotMultiSelect(0);
	ui.CloseFrame("inventory");
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	TRADE_DIALOG_CLOSE();
end

function PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame)

	local obj = GetIES(invItem:GetObject());
	
	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemCls = GetClassByType("Item", invItem.type);
	if itemCls.ItemType == 'Quest' then
		ui.MsgBox(ScpArgMsg("IT_ISNT_REINFORCEABLE_ITEM"));
		return;
	end
	
	if fromFrame:GetName() == "inventory" then
		local accountObj = GetMyAccountObj();
		local itemClassID = session.loginInfo.GetPremiumStateArg(ITEM_TOKEN)
		local tokenItemCls = GetClassByType("Item", itemClassID);
		local remainTardeCnt = 0;
		if tokenItemCls ~= nil then
			remainTardeCnt = tokenItemCls.NumberArg2 - accountObj.TradeCount
		end
		if 0 >= remainTardeCnt then
			ui.MsgBox(ScpArgMsg("RemainTradeCountDoesNotExist"));
			return;
		end

		if geItemTable.IsHavePotential(itemCls.ClassID) == 1 then
			if obj.PR <= 0 then
				ui.MsgBox(ScpArgMsg("NoMorePotential"));
				return;
			end

			local msg = "";
			if 5 < remainTardeCnt then
				msg = ScpArgMsg('DecreasePotaionWhenPutItToAccountWareHouse_Continue?', 'COUNT', remainTardeCnt)
			else
				msg = ScpArgMsg('WANNING_DecreasePotaionWhenPutItToAccountWareHouse_Continue?', 'COUNT', remainTardeCnt)
			end

			local yesScp = string.format("EXEC_PUT_TO_ACCOUNT_WAREHOUSE(\"%s\", %d, %d)", invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));
			ui.MsgBox(msg, yesScp, "None");
			return;
		end

		if TryGetProp(obj, "BelongingCount") ~= nil then
			local remainBelongCount = invItem.count - obj.BelongingCount;
			if remainBelongCount <= 0 then
				ui.MsgBox(ScpArgMsg("NotEnoughTradePossibleCount"));
				return;
			end
			local msg = "";
			if 5 < remainTardeCnt then
				msg = ScpArgMsg('IfPutItemToWareHouse_TradePossibleItemWillBePut_Continue?', 'COUNT', remainTardeCnt)
			else
				msg = ScpArgMsg('WANNING_IfPutItemToWareHouse_TradePossibleItemWillBePut_Continue?', 'COUNT', remainTardeCnt)
			end

			local yesScp = string.format("MSG_PUTITEM_ACCOUNT_WAREHOUSE(\"%s\", %d, %d)", invItem:GetIESID(), remainBelongCount, frame:GetUserIValue("HANDLE"));
			ui.MsgBox(msg, yesScp, "None");
			return;
		end


		if invItem.count > 1 then
			INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE", invItem.count, 1, invItem.count, nil, tostring(invItem:GetIESID()));
		else
			item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));
		end
	else
		if slot ~= nil then
			AUTO_CAST(slot);
	
			local iconSlot = liftIcon:GetParent();
			AUTO_CAST(iconSlot);
			item.SwapSlotIndex(IT_ACCOUNT_WAREHOUSE, slot:GetSlotIndex(), iconSlot:GetSlotIndex());
			ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame);
		end
	end

end

function PUT_ACCOUNT_ITEM_TO_WAREHOUSE(parent, slot)

	local frame = parent:GetTopParentFrame();

	local liftIcon 			= ui.GetLiftIcon();
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	if invItem == nil then
		return;
	end

	local fromFrame = liftIcon:GetTopParentFrame();
	PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame);

end

function MSG_PUTITEM_ACCOUNT_WAREHOUSE(iesID, count, handle)
	local frame = ui.GetFrame("accountwarehouse");	
	if count > 1 then
		INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE", count, 1, count, nil, iesID);
	else
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesID, count, handle);
	end
end

function EXEC_PUT_TO_ACCOUNT_WAREHOUSE(iesID, count, handle)
	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesID, count, handle);
end

function EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE(frame, count, inputframe)
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");
	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesid, tonumber(count), frame:GetUserIValue("HANDLE"));
end

function ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame)

	if frame:IsVisible() == 0 then
		return;
	end

	local gbox = frame:GetChild("gbox");
	local slotset = gbox:GetChild("slotset");
	if slotset == nil then
		local gbox_warehouse = gbox:GetChild("gbox_warehouse");
			slotset = gbox_warehouse:GetChild("slotset");
		end

	AUTO_CAST(slotset);
	local aObj = GetMyAccountObj();
	local slotCount = slotset:GetSlotCount();
	slotset:SetSlotCount(aObj.MaxAccountWarehouseCount + aObj.AccountWareHouseExtend);
	slotset:AutoAdjustRow();
	slotset:ShowWindow(1);
	
	UPDATE_ETC_ITEM_SLOTSET(slotset, IT_ACCOUNT_WAREHOUSE, "accountwarehouse");
	
	if gbox_warehouse ~= nil then
		gbox_warehouse:UpdateData();
		gbox_warehouse:SetCurLine(0);	
		gbox_warehouse:InvalidateScrollBar();
		frame:Invalidate();
	end

end

function ACCOUNT_WAREHOUSE_RECEIVE_ITEM(parent, slot)
	
	local frame = parent:GetTopParentFrame();
	local gbox = frame:GetChild("gbox");
	local slotset = gbox:GetChild("slotset");
	if slotset == nil then
	local gbox_warehouse = gbox:GetChild("gbox_warehouse");
		slotset = gbox_warehouse:GetChild("slotset");
	end

	session.ResetItemList();
	AUTO_CAST(slotset);
	for i = 0, slotset:GetSelectedSlotCount() -1 do
		local slot = slotset:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID(), slot:GetSelectCount());

	end

	if session.GetItemIDList():Count() == 0 then
		ui.MsgBox(ScpArgMsg("SelectItemByMouseLeftButton"));
		return;
	end
	
	local str = ScpArgMsg("TradeCountWillBeConsumedBy{Value}_Continue?", "Value", "1");
	ui.MsgBox(str, "_EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM", "None");

end

function _EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM()

	local frame = ui.GetFrame("accountwarehouse");
	item.TakeItemFromWarehouse_List(IT_ACCOUNT_WAREHOUSE, session.GetItemIDList(), frame:GetUserIValue("HANDLE"));
end

function ACCOUNT_WAREHOUSE_EXTEND(frame, slot)
	
	local aObj = GetMyAccountObj();
	if nil == aObj then
		return;
	end

	local slotDiff = aObj.AccountWareHouseExtend;
	local price = ACCOUNT_WAREHOUSE_EXTEND_PRICE;
	if slotDiff > 0 then
		if slotDiff >= tonumber(ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT) then
			ui.SysMsg(ScpArgMsg("WareHouseMax"))
			return;
		end
		price = price * GetPow(2, slotDiff);
	end

	local str = ScpArgMsg("ExtendWarehouseSlot{Silver}{SLOT}", "Silver", GetCommaedText(price), "SLOT", 1);

	local yesScp = string.format("CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(%d)", price) 
	ui.MsgBox(str, yesScp, "None");

	DISABLE_BUTTON_DOUBLECLICK("accountwarehouse","extend")

end

function CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(price)
	if 0 > GET_TOTAL_MONEY() - price then
		ui.SysMsg(ScpArgMsg("NotEnoughMoney"))
		return;
	end

	item.ExtendWareHouse(IT_ACCOUNT_WAREHOUSE);
end

function ACCOUNT_WAREHOUSE_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("accountwarehouse");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end

	local fromFrame = slot:GetTopParentFrame();	
	if fromFrame:GetName() == "inventory" then
		PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, nil, fromFrame)
	end
end
