
function MARKET_SELL_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_REGISTER", "ON_MARKET_REGISTER");
	addon:RegisterMsg("MARKET_SELL_LIST", "ON_MARKET_SELL_LIST");
	
	addon:RegisterMsg("MARKET_MINMAX_INFO", "ON_MARKET_MINMAX_INFO");
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_SELL_LIST");    
end

function MARKET_SELL_OPEN(frame)
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	market.ReqMySellList(0);
	packet.RequestItemList(IT_WAREHOUSE);

	local groupbox = frame:GetChild("groupbox");
	local droplist = GET_CHILD(groupbox, "sellTimeList", "ui::CDropList");	
	droplist:ClearItems();

	local defaultTime = 0;
	local cnt = GetMarketTimeCount();
	for i = 0 , cnt - 1 do
		local time, free = GetMarketTimeAndTP(i);
		local day = 0;
		local listType = ScpArgMsg("MarketTime{Time}{FREE}","Time", time, "FREE", free);
		droplist:AddItem(time, "{s16}{b}{ol}"..listType);
		defaultTime = time; -- 7일을 기본으로 해달래여
	end
	droplist:SelectItem(cnt - 1);
	droplist:SelectItemByKey(defaultTime);

	MARKET_SELL_ITEM_POP_BY_SLOT(frame, nil);
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

function ON_MARKET_SELL_LIST(frame, msg, argStr, argNum)
	if msg == MARKET_ITEM_LIST then
		local str = GET_TIME_TXT(argNum);
		ui.SysMsg(ScpArgMsg("MarketCabinetAfter{TIME}","Time", str));
		if frame:IsVisible() == 0 then
			return;
		end
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local sysTime = geTime.GetServerSystemTime();		
	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);

		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_sell_item_detail");
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		local imgName = GET_ITEM_ICON_IMAGE(itemObj);
		pic:SetImage(imgName);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local itemCount = ctrlSet:GetChild("count");
		itemCount:SetTextByKey("value", marketItem.count);

		local priceStr = string.format("{img icon_item_silver %d %d}%d", 20, 20, marketItem.sellPrice * marketItem.count) 
		local totalPrice = ctrlSet:GetChild("totalPrice");
		totalPrice:SetTextByKey("value", priceStr);

		local cashValue = GetCashValue(marketItem.premuimState, "marketSellCom") * 0.01;
		local stralue = GetCashValue(marketItem.premuimState, "marketSellCom");
		priceStr = string.format("{img icon_item_silver %d %d}%d[%d%%]", 20, 20, marketItem.sellPrice * marketItem.count * cashValue, stralue) 
		local silverFee = ctrlSet:GetChild("silverFee");
		silverFee:SetTextByKey("value", priceStr);

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());


		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Cancel"));
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		btn:SetEventScriptArgString(ui.LBUTTONUP,marketItem:GetMarketGuid());

	end

	itemlist:RealignItems();
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, false, true);
--local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_SELL_ITEM_PER_PAGE);
--local curPage = session.market.GetCurPage();
--local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
--pagecontrol:SetMaxPage(maxPage);
--pagecontrol:SetCurPage(curPage);

end

function ON_MARKET_REGISTER(frame, msg, argStr, argNum)
	ui.SysMsg(ClMsg("MarketItemRegisterSucceeded"));

	local groupbox = frame:GetChild("groupbox");
	local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(slot_item);
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
end

function MARKET_SELL_UPDATE_REG_SLOT_ITEM(frame, invItem, slot)	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local groupbox = frame:GetChild("groupbox");
	local silverRate = groupbox:GetChild("silverRate");
	local upValue = silverRate:GetChild("upValue");
	local downValue = silverRate:GetChild("downValue");
	local min = silverRate:GetChild("min");
	local max = silverRate:GetChild("max");
	
	upValue:SetTextByKey("value", '0');
	downValue:SetTextByKey("value", '0');
	min:SetTextByKey("value", '0');
	max:SetTextByKey("value", '0');

	local edit_count = GET_CHILD(groupbox, "edit_count", "ui::CEditControl");
	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");

	local obj = GetIES(invItem:GetObject());
	local reason = GetTradeLockByProperty(obj);
	if reason ~= "None" then
		ui.SysMsg(ScpArgMsg(reason));
		return;
	end

	if obj.ClassName == "PremiumToken" then
		edit_count:SetText("1");
		edit_count:SetMaxNumber(1);
		edit_price:SetMaxNumber(TOKEN_MARKET_REG_MAX_PRICE * invItem.count);
		edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);
	else
		edit_price:SetMaxNumber(2147483647);
		edit_price:SetMaxLen(edit_price:GetMaxLen() + 3); -- , 텍스트로 변환		
	end

	local itemProp = geItemTable.GetProp(obj.ClassID);
	local pr = TryGetProp(obj, "PR");

	local noTradeCnt = TryGetProp(obj, "BelongingCount");
	local tradeCount = invItem.count
	if nil ~= noTradeCnt and 0 < tonumber(noTradeCnt) then
		local wareItem = nil 
		if obj.MaxStack > 1 then
			wareItem = session.GetWarehouseItemByType(obj.ClassID);
		end
		local wareCnt = 0;
		if nil ~= wareItem then
			wareCnt = wareItem.count;
		end
		tradeCount = (invItem.count + wareCnt) - tonumber(noTradeCnt);
		if tradeCount <= 0 then
			ui.AlarmMsg("ItemIsNotTradable");
			return false;
		end
	end

	if itemProp:IsEnableMarketTrade() == false or itemProp:IsMoney() == true or ((pr ~= nil and pr < 1) and itemProp:NeedCheckPotential() == true) then
		ui.AlarmMsg("ItemIsNotTradable");
		return false;
	end


	if nil == slot then
		slot = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	end
	SET_SLOT_ITEM(slot, invItem);
	edit_count:SetText(tradeCount);
	edit_count:SetMaxNumber(tradeCount);

	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	return true;
end

function MARKET_SELL_RBUTTON_ITEM_CLICK(frame, invItem)
	local groupbox = frame:GetChild("groupbox");
	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");
	edit_price:SetMinNumber(0);

	local ret = MARKET_SELL_UPDATE_REG_SLOT_ITEM(frame, invItem, nil);
	if ret == true then
		market.ReqSellMinMaxInfo(invItem:GetIESID());
		frame:SetUserValue('REQ_ITEMID', invItem:GetIESID())
	end
end

function MARKET_SELL_ITEM_POP_BY_SLOT(parent, slot)

	local groupbox = parent:GetChild("groupbox");
	if groupbox == nil then
		local frame = parent:GetTopParentFrame();
		groupbox = frame:GetChild("groupbox");
	end

	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");
	local edit_count =GET_CHILD(groupbox, "edit_count", "ui::CEditControl");
	edit_count:SetText("1");
	local silverRate = groupbox:GetChild("silverRate");

	local upValue = silverRate:GetChild("upValue");
	local downValue = silverRate:GetChild("downValue");
	local min = silverRate:GetChild("min");
	local max = silverRate:GetChild("max");

	upValue:SetTextByKey("value", '0');
	downValue:SetTextByKey("value", '0');
	min:SetTextByKey("value", '0');
	max:SetTextByKey("value", '0');

	local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(slot_item);
end

function MARKET_SELL_ITEM_DROP_BY_SLOT(parent, slot)

	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local groupbox = slot:GetParent();
	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");
	edit_price:SetMinNumber(0);

	local iconInfo = liftIcon:GetInfo();
	local itemID = iconInfo:GetIESID();

	if session.GetEquipItemByGuid(itemID) ~= nil then
		ui.SysMsg(ClMsg("CantRegisterEquipItem"));
		return;
	end


	local invItem = session.GetInvItemByGuid(itemID);
	if invItem ~= nil then
		local ret = MARKET_SELL_UPDATE_REG_SLOT_ITEM(parent:GetTopParentFrame(), invItem, slot);
		if ret == true then
			market.ReqSellMinMaxInfo(itemID);
			frame:SetUserValue('REQ_ITEMID', itemID)
		end
		return;
	end

	CLEAR_SLOT_ITEM_INFO(slot);
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
end

function ON_MARKET_MINMAX_INFO(frame, msg, argStr, argNum)
	local itemID = frame:GetUserValue('REQ_ITEMID');
	local invItem = session.GetInvItemByGuid(itemID);
	local groupbox = frame:GetChild("groupbox");
	local silverRate = groupbox:GetChild("silverRate");

	local upValue = silverRate:GetChild("upValue");
	local downValue = silverRate:GetChild("downValue");
	local min = silverRate:GetChild("min");
	local max = silverRate:GetChild("max");

	upValue:SetTextByKey("value", '0');
	downValue:SetTextByKey("value", '0');
	min:SetTextByKey("value", '0');
	max:SetTextByKey("value", '0');

	local edit_price = GET_CHILD(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");
	edit_price:SetMaxNumber(2147483647);
	edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);

	if argNum == 1 then	
		local tokenList = TokenizeByChar(argStr, ";");
		local minStr = tokenList[1];
		local minAllow = tokenList[2];
		local maxStr = tokenList[3];
		local maxAllow = tokenList[4];
		local avg = tokenList[5];

		upValue:SetTextByKey("value", maxAllow);
		downValue:SetTextByKey("value", minAllow);
		min:SetTextByKey("value", minStr);
		max:SetTextByKey("value", maxStr);
		edit_price:SetText(GET_COMMAED_STRING(avg));
		if IGNORE_ITEM_AVG_TABLE_FOR_TOKEN == 1 then
			if false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
				edit_price:SetMaxNumber(maxAllow);
				edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);
			else
				edit_price:SetMaxNumber(2147483647);
				edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);
			end
		else
			edit_price:SetMaxNumber(maxAllow);
			edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);
		end
		return;
	end

	frame:SetUserValue('REQ_ITEMID', 'None')
	MARKET_SELL_UPDATE_REG_SLOT_ITEM(frame:GetTopParentFrame(), invItem, nil);
end

function MARKET_SELL_REGISTER(parent, ctrl)
	local count = session.market.GetItemCount();
	local userType = session.loginInfo.GetPremiumState();
	local maxCount = GetCashValue(userType, "marketUpMax");
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		local tokenCnt = GetCashValue(ITEM_TOKEN, "marketUpMax");
		if tokenCnt > maxCount then
			maxCount = tokenCnt;
		end
	end

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
    local price = GET_NOT_COMMAED_NUMBER(edit_price:GetText());
	if price < 100 then
		ui.SysMsg(ClMsg("SellPriceMustOverThen100Silver"));		
		return;
	end

	local strprice = string.format("%d", price);

	if string.len(strprice) < 3 then
		return
	end

	local floorprice = strprice.sub(strprice,0,2)
	for i = 0 , string.len(strprice) - 3 do
		floorprice = floorprice .. "0"
	end
	
	if strprice ~= floorprice then
		edit_price:SetText(GET_COMMAED_STRING(floorprice));
		ui.SysMsg(ScpArgMsg("AutoAdjustToMinPrice"));		
		price = tonumber(floorprice);
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

	local needTime, free = GetMarketTimeAndTP(selecIndex);
	local commission = (price * count * free * 0.01);
	local vis = session.GetInvItemByName("Vis");
	if vis == nil or 0 > vis.count - commission then
		ui.SysMsg(ClMsg("Auto_SilBeoKa_BuJogHapNiDa."));
		return;
	end

	local silverRate = groupbox:GetChild("silverRate");

	local down = silverRate:GetChild("downValue");
	local downValue = down:GetTextByKey("value");
	local idownValue = tonumber(downValue);
	local iPrice = tonumber(price);
	if IGNORE_ITEM_AVG_TABLE_FOR_TOKEN == 1 then
		if false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			if 0 ~= idownValue and  iPrice < idownValue then
				ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", downValue));	
				return;
			end
		end
	else
		if 0 ~= idownValue and  iPrice < idownValue then
			ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", downValue));	
			return;
		end
	end

	if obj.ClassName == "PremiumToken" and iPrice < tonumber(TOKEN_MARKET_REG_LIMIT_PRICE) then
    	ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", TOKEN_MARKET_REG_LIMIT_PRICE));
    	return;
	end
	if obj.ClassName == "PremiumToken" and iPrice > tonumber(TOKEN_MARKET_REG_MAX_PRICE) then
    	ui.SysMsg(ScpArgMsg("PremiumRegMaxPrice{Price}","Price", TOKEN_MARKET_REG_MAX_PRICE));
    	return;
	end


	if true == invitem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invitem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end
	local itemProp = geItemTable.GetProp(obj.ClassID);
	local pr = TryGetProp(obj, "PR");

	local noTradeCnt = TryGetProp(obj, "BelongingCount");
	local tradeCount = invitem.count
	if nil ~= noTradeCnt and 0 < tonumber(noTradeCnt) then
		local wareItem = nil;
		if obj.MaxStack > 1 then
			wareItem =session.GetWarehouseItemByType(obj.ClassID);
		end
		local wareCnt = 0;
		if nil ~= wareItem then
			wareCnt = wareItem.count;
		end
		tradeCount = (invitem.count + wareCnt) - tonumber(noTradeCnt);
		if tradeCount <= 0 then
			ui.AlarmMsg("ItemIsNotTradable");
			return false;
		end
	end

	if itemProp:IsEnableMarketTrade() == false or itemProp:IsMoney() == true or ((pr ~= nil and pr < 1) and itemProp:NeedCheckPotential() == true) then
		ui.AlarmMsg("ItemIsNotTradable");
		return false;
	end


	local yesScp = string.format("market.ReqRegisterItem(\'%s\', %d, %d, 1, %d)", itemGuid, price, count, needTime);
	
	commission = math.floor(commission);
	if commission <= 0 then
		commission = 1;
	end
	if nil~= obj and obj.ItemType =='Equip' then
		if 0 < obj.BuffValue then
			-- 장비그룹만 buffValue가 있다.
			ui.MsgBox(ScpArgMsg("BuffDestroy{Price}","Price", tostring(commission)), yesScp, "None");
		else
			ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", GET_COMMAED_STRING(commission)), yesScp, "None");			
		end
	else
		ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", GET_COMMAED_STRING(commission)), yesScp, "None");
	end

end

function MARKET_SELL_SELECT_NEXT(pageControl, numCtrl)
--pageControl = tolua.cast(pageControl, "ui::CPageController");
--local page = pageControl:GetCurPage();
--local frame = pageControl:GetTopParentFrame();
--local MaxPage = pageControl:GetMaxPage();
--local nexPage = page + 1;
--if nexPage >= MaxPage then
--	nexPage = MaxPage - 1;
--end
--
--market.ReqMySellList(nexPage);
end

function MARKET_SELL_SELECT_PREV(pageControl, numCtrl)
--pageControl = tolua.cast(pageControl, "ui::CPageController");
--local page = pageControl:GetCurPage();
--local frame = pageControl:GetTopParentFrame();
--local prePage = page - 1;
--if prePage <= 0 then
--	prePage = 0;
--end
--market.ReqMySellList(prePage);
end

function MARKET_SELL_SELECT(pageControl, numCtrl)
--pageControl = tolua.cast(pageControl, "ui::CPageController");
--local page = pageControl:GetCurPage();
--local frame = pageControl:GetTopParentFrame();
--market.ReqMySellList(page);
end

function UPDATE_MONEY_COMMAED_STRING(parent, ctrl)
    local moneyText = ctrl:GetText();    
    if moneyText == "" then
        moneyText = 0;
    end
    if tonumber(moneyText) > MONEY_MAX_STACK then
        moneyText = tostring(MONEY_MAX_STACK);
        ui.SysMsg(ScpArgMsg('MarketMaxSilverLimit{LIMIT}Over', 'LIMIT', GET_COMMAED_STRING(MONEY_MAX_STACK)));
    end
    ctrl:SetText(GET_COMMAED_STRING(moneyText));
end