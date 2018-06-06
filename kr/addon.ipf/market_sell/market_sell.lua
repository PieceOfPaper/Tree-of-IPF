
function MARKET_SELL_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_REGISTER", "ON_MARKET_REGISTER");
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_SELL_LIST");
	
end

function MARKET_SELL_OPEN(frame)
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	market.ReqMySellList(0);
	packet.RequestItemList(IT_WAREHOUSE);

	local groupbox = frame:GetChild("groupbox");
	local droplist = GET_CHILD(groupbox, "sellTimeList", "ui::CDropList");	
	droplist:ClearItems();
	
	local userType = session.loginInfo.GetPremiumState();
	local needMedalFee = GetCashValue(userType, "marketUpCom")
	local cnt = GetMarketTimeCount();
	for i = 0 , cnt - 1 do
		local time, tp = GetMarketTimeAndTP(i);
		local day = 0;
		local listType = nil;
		if time < 24 then -- 하루는 24시간
			listType = ScpArgMsg("MarketTime{Time}{TP}","Time", time, "TP", tp*needMedalFee);
		else
			listType = ScpArgMsg("MarketTime{Time}{Day}{TP}","Time", time, "Day", time/24, "TP", math.floor(tp*needMedalFee));
		end
		droplist:AddItem(time, "{@st42}"..listType);
	end
	droplist:SelectItem(0);
	droplist:SelectItemByKey(1);
end

function MARKET_SELL_TYPE_SELECT(parent, ctrl)
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
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_sell_item_detail");
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));
		local itemCount = ctrlSet:GetChild("count");
		itemCount:SetTextByKey("value", marketItem.count);
		local totalPrice = ctrlSet:GetChild("totalPrice");
		totalPrice:SetTextByKey("value", GetCommaedText(marketItem.sellPrice) .. " * " .. GetCommaedText(marketItem.count) .. " = " .. GetCommaedText(marketItem.sellPrice * marketItem.count));
		
		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Cancel"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		
	end

	itemlist:RealignItems();
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, false, true);
	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_SELL_ITEM_PER_PAGE);
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
		if obj.GroupName == "Premium" then
			edit_price:SetMinNumber(TOKEN_MARKET_REG_LIMIT_PRICE);
			edit_price:SetMaxNumber(TOKEN_MARKET_REG_MAX_PRICE);
		else
			edit_price:SetMinNumber(0);
			edit_price:SetMaxNumber(2147483647);
		end

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
			or invItem:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_AWAKEN") 
			or invItem:GetIESID() == invframe:GetUserValue("STONE_ITEM_GUID_IN_AWAKEN") then
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
	local count = session.market.GetItemCount();
	local userType = session.loginInfo.GetPremiumState();
	local maxCount = GetCashValue(userType, "marketUpMax");
	if count+1 > maxCount then
		ui.SysMsg(ClMsg("MarketRegitCntOver"));		
		return;
	end
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

	local droplist = GET_CHILD(groupbox, "sellTimeList", "ui::CDropList");	
	local selecIndex = droplist:GetSelItemIndex();

	-- tp계산할것
	local userType = session.loginInfo.GetPremiumState();
	local needMedalFee = GetCashValue(userType, "marketUpCom")
	local needTime, needTp = GetMarketTimeAndTP(selecIndex);
	local resultMadel = needTp*needMedalFee;
	
	if 0 > GET_CASH_POINT_C() - resultMadel then
		ui.SysMsg(ClMsg("NotEnoughMedal"));	
		return;
	end

	-- 장비그룹만 buffValue가 있다.
	if nil~= obj and obj.ItemType =='Equip' then
		if 0 < obj.BuffValue then
			local yesScp = string.format("market.ReqRegisterItem(\'%s\', %d, %d, 1, %d)", itemGuid, price, count, selecIndex);
			ui.MsgBox(ScpArgMsg("BuffDestroy"), yesScp, "None");
		else
			market.ReqRegisterItem(itemGuid, price, count, 1, selecIndex);
		end
	else
		market.ReqRegisterItem(itemGuid, price, count, 1, selecIndex);
	end

end

function MARKET_SELL_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	local MaxPage = pageControl:GetMaxPage();
	local nexPage = page + 1;
	if nexPage >= MaxPage then
		nexPage = MaxPage - 1;
	end

	market.ReqMySellList(nexPage);
end

function MARKET_SELL_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	local prePage = page - 1;
	if prePage <= 0 then
		prePage = 0;
	end
	market.ReqMySellList(prePage);
end

function MARKET_SELL_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	market.ReqMySellList(page);
end


