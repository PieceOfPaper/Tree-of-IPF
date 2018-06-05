
function MARKET_SELL_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_REGISTER", "ON_MARKET_REGISTER");
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_SELL_LIST");
	
end

function MARKET_SELL_FIRST_OPEN(frame)

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st50}" .. ClMsg("Name"), 200);
	itemlist:AddBarInfo("TotalPrice", "{@st50}" .. ClMsg("TotalPrice"), 250);	
	itemlist:AddBarInfo("Cancel", "{@st50}" .. ClMsg("Cancel"), 100);	
	--itemlist:LoadUserSize();
	
end

function MARKET_SELL_OPEN(frame)
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	market.ReqMySellList(0);
	packet.RequestItemList(IT_WAREHOUSE);
end

function MARKET_SELL_UPDATE_SLOT_ITEM(frame)

	local groupbox = frame:GetChild("groupbox");

	local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	local itemname = groupbox:GetChild("itemname");
	local slotItem = GET_SLOT_ITEM(slot_item);
	local itemObj = nil;
	if slotItem == nil then
		itemname:SetTextByKey("name", "");
	else
		itemObj = GetIES(slotItem:GetObject());
		itemname:SetTextByKey("name", GET_FULL_NAME(itemObj));
	end

end

function ON_MARKET_SELL_LIST(frame)

	if frame:IsVisible() == 0 then
		return;
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local sysTime = geTime.GetServerSystemTime();		
	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local registerTime = marketItem:GetSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		local timeString = GET_TIME_TXT(difSec);
		local itemObj = GetIES(marketItem:GetObject());

		local itemText = INSERT_TEXT_DETAIL_LIST(itemlist, i, 0, "{@st42}" .. GET_ITEM_IMG_BY_CLS(itemObj, 32) .. " " .. GET_FULL_NAME(itemObj), "left", marketItem);
		
		SET_ITEM_TOOLTIP_ALL_TYPE(itemText, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());


	--SET_ITEM_TOOLTIP_TYPE(itemText, marketItem.itemType);
	--itemText:SetTooltipArg("market", marketItem.itemType, marketItem:GetMarketGuid());
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 1, "{@st42}" .. GetCommaedText(marketItem.sellPrice) .. " * " .. GetCommaedText(marketItem.count) .. "  =" .. GetCommaedText(marketItem.sellPrice * marketItem.count));
		local btn = INSERT_BUTTON_DETAIL_LIST(itemlist,i, 2, "{@st42}" .. ClMsg("Cancel"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		
	end

	itemlist:RealignItems();

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);

end

function ON_MARKET_REGISTER(frame)
	ui.SysMsg(ClMsg("MarketItemRegisterSucceeded"));
	
	local groupbox = frame:GetChild("groupbox");
	local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(slot_item);
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
end

function DROP_MARKET_SELL_SLOT(parent, slot)

	local liftIcon = ui.GetLiftIcon();
	
	local groupbox = slot:GetParent();
	local edit_count = GET_CHILD(groupbox, "edit_count", "ui::CEditControl");
	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");

	local iconInfo = liftIcon:GetInfo();
	local itemID = iconInfo:GetIESID();
	if session.GetEquipItemByGuid(itemID) ~= nil then
		ui.SysMsg(ClMsg("CantRegisterEquipItem"));
		return;
	end

	local invItem = session.GetInvItemByGuid(itemID);
	if invItem == nil then
		CLEAR_SLOT_ITEM_INFO(slot);
		edit_count:SetText("0");
	else
		if true == invItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
		local obj = GetIES(invItem:GetObject());
		local itemProp = geItemTable.GetProp(obj.ClassID);
		local pr = TryGetProp(obj, "PR");

		local noTradeCnt = TryGetProp(obj, "BelongingCount");
		local tradeCount = invItem.count
		if nil ~= noTradeCnt and 0 < tonumber(noTradeCnt) then
			local wareItem = session.GetWarehouseItemByType(obj.ClassID);
			local wareCnt = 0;
			if nil ~= wareItem then
				wareCnt = wareItem.count;
			end
			tradeCount = (invItem.count + wareCnt) - tonumber(noTradeCnt);
			if tradeCount <= 0 then
				ui.AlarmMsg("ItemIsNotTradable");
				return;
			end
		end

		if itemProp:IsExchangeable() == false or itemProp:IsMoney() == true or (pr ~= nil and pr < 1) then
			ui.AlarmMsg("ItemIsNotTradable");
			return;
		end

		local invframe = ui.GetFrame("inventory");
		if invItem:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_MORU")
			or invItem:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_AWAKEN") then
			return;
		end

		SET_SLOT_ITEM(slot, invItem);
		edit_count:SetText(tradeCount);
		edit_count:SetMaxNumber(tradeCount);
	end
		
	local frame = parent:GetTopParentFrame();
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);

end

function MARKET_SELL_REGISTER(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local groupbox = frame:GetChild("groupbox");
	local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	local edit_count = groupbox:GetChild("edit_count");
	local edit_price = groupbox:GetChild("edit_price");

	local invitem = GET_SLOT_ITEM(slot_item);
	if invitem == nil then
		return;
	end

	local count = tonumber(edit_count:GetText());
	local price = tonumber(edit_price:GetText());
	if price <= 0 then
		ui.SysMsg(ClMsg("SellPriceMustOverThenZeroSilver"));		
		return;
	end

	if count <= 0 then
		ui.SysMsg(ClMsg("SellCountMustOverThenZeo"));		
		return;
	end

	local isPrivate = GET_CHILD(groupbox, "isPrivate", "ui::CCheckBox");
	local itemGuid = invitem:GetIESID();
	local obj = GetIES(invitem:GetObject());

	-- 장비그룹만 buffValue가 있다.
	if nil~= obj and obj.ItemType =='Equip' then
		if 0 < obj.BuffValue then
			local yesScp = string.format("market.ReqRegisterItem(\'%s\', %d, %d, %d)", itemGuid, price, count,isPrivate:IsChecked());
			ui.MsgBox(ScpArgMsg("BuffDestroy"), yesScp, "None");
		else
			market.ReqRegisterItem(itemGuid, price, count, isPrivate:IsChecked());
		end
	else
		market.ReqRegisterItem(itemGuid, price, count, isPrivate:IsChecked());
	end

end

function MARKET_SELL_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	market.ReqMySellList(page + 1);
end

function MARKET_SELL_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	market.ReqMySellList(page - 1);
end

function MARKET_SELL_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	market.ReqMySellList(page);
end


