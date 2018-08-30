function MARKET_SELL_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_REGISTER", "ON_MARKET_REGISTER");
	addon:RegisterMsg("MARKET_SELL_LIST", "ON_MARKET_SELL_LIST");
	
	addon:RegisterMsg("MARKET_MINMAX_INFO", "ON_MARKET_MINMAX_INFO");
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_SELL_LIST");
	addon:RegisterMsg('RESPONSE_MIN_PRICE', 'ON_RESPONSE_MIN_PRICE');
	addon:RegisterMsg('WEB_RELOAD_SELL_LIST', 'ON_WEB_RELOAD_SELL_LIST');
end

function ON_WEB_RELOAD_SELL_LIST(frame, msg, argStr, argNum)	
	RequestMarketSellList();
end

function MARKET_SELL_OPEN(frame)
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	RequestMarketSellList();
	packet.RequestItemList(IT_WAREHOUSE);

	local groupbox = frame:GetChild("groupbox");

	local defaultTime = 0;
	local cnt = GetMarketTimeCount();
	local timeTable = {};
	local timeVec = {};	
	for i = 0 , cnt - 1 do
		local time, free = GetMarketTimeAndTP(i);
		timeTable[time] = free;
		timeVec[#timeVec + 1] = time;	
		--가장 최근에 선택한 라디오로 세팅
		local recent_radio_config = config.GetXMLConfig('MarketSellFeeValue'..i + 1);
		if recent_radio_config == 1 then
			local recent_radio = GET_CHILD_RECURSIVELY(frame, "feePerTime_"..i + 1);
			if recent_radio ~= nil then
				recent_radio:SetCheck(true);
			end
		end
	end

	table.sort(timeVec);
	for i = 1, #timeVec do
		local time = timeVec[i];
		local free = timeTable[time];
		local listType = ScpArgMsg("MarketTime{Time}{FREE}","Time", time, "FREE", free);
		defaultTime = time; -- 7일을 기본으로 해달래여
		frame:SetUserValue('TIME_'..tostring(i - 1), time);
		frame:SetUserValue('FREE_'..tostring(i - 1), free);

		local radio = GET_CHILD_RECURSIVELY(frame, "feePerTime_"..i);
		radio:SetTextByKey("time", time)
		radio:SetTextByKey("free", free)
	end

	MARKET_SELL_ITEM_POP_BY_SLOT(frame, nil);
	CLEAR_SELL_INFO(frame)
end

function MARKET_SELL_UPDATE_SLOT_ITEM(frame)
	local groupbox = frame:GetChild("groupbox");

	local slot_item = GET_CHILD_RECURSIVELY(groupbox, "slot_item", "ui::CSlot");
	local itemname = GET_CHILD_RECURSIVELY(groupbox, "itemname");
	local slotItem = GET_SLOT_ITEM(slot_item);
	local itemObj = nil;
	if slotItem == nil then
		itemname:SetTextByKey("name", frame:GetUserConfig("ITEM_NAME_DEF"));
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
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CSlot");
		local imgName = GET_ITEM_ICON_IMAGE(itemObj);
        local icon = CreateIcon(pic)
        SET_SLOT_ITEM_CLS(pic, itemObj)
        SET_SLOT_STYLESET(pic, itemObj)
        if itemObj.MaxStack > 1 then        	
			SET_SLOT_COUNT_TEXT(pic, marketItem.count, '{s16}{ol}{b}');
		end

		local nameCtrl = ctrlSet:GetChild("name");
		nameCtrl:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local totalPriceCtrl = ctrlSet:GetChild("totalPrice");
		local totalPriceValue = math.mul_int_for_lua(marketItem.sellPrice, marketItem.count);
		local totalPrice = GET_COMMAED_STRING(totalPriceValue);
		totalPriceCtrl:SetTextByKey("value", totalPrice);

		local totalPriceStrCtrl = ctrlSet:GetChild("totalPriceStr");
		local totalPriceStr = GetMonetaryString(totalPriceValue);
		totalPriceStrCtrl:SetTextByKey("value", totalPriceStr);

		-- 시간 표기하는 부분
		local remainTimeCtrl = ctrlSet:GetChild("remainTime");
		if marketItem:IsWatingForRegister() == true then
			remainTimeCtrl:SetTextByKey("value", ClMsg("PleaseWaiting"));
		else
			local endSYSTime = marketItem:GetEndTime();
			local difSec = imcTime.GetDifSec(endSYSTime, sysTime);			
			remainTimeCtrl:SetUserValue("REMAINSEC", difSec);
			remainTimeCtrl:SetUserValue("STARTSEC", imcTime.GetAppTime());
			remainTimeCtrl:RunUpdateScript("SHOW_REMAIN_MARKET_SELL_TIME");
		end
		-- 시간 표기하는 부분 end

		local cashValue = GetCashValue(marketItem.premuimState, "marketSellCom") * 0.01;
		local stralue = GetCashValue(marketItem.premuimState, "marketSellCom");
		local feeValueCtrl = ctrlSet:GetChild("feeValue");
		local feeValue =  math.floor(math.mul_int_for_lua(totalPriceValue, cashValue));

		local feeStr = GET_COMMAED_STRING(feeValue);
		feeValueCtrl:SetTextByKey("value", feeStr);
		local feeValueStrCtrl = ctrlSet:GetChild("feeValueStr");
		local feeValueStr = GetMonetaryString(feeValue);
		feeValueStrCtrl:SetTextByKey("value", feeValueStr);

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Cancel"));
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		btn:SetEventScriptArgString(ui.LBUTTONUP,marketItem:GetMarketGuid());
	end

	itemlist:RealignItems();
	GBOX_AUTO_ALIGN(itemlist, 2, 0, 0, false, true);
end

function SHOW_REMAIN_MARKET_SELL_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	if 0 > startSec then
	 	ctrl:StopUpdateScript("SHOW_REMAIN_MARKET_SELL_TIME");
		return 0;
	end 
	
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", timeTxt );
	return 1;
end

function ON_MARKET_REGISTER(frame, msg, argStr, argNum)
	ui.SysMsg(ClMsg("MarketItemRegisterSucceeded"));

	local groupbox = frame:GetChild("groupbox");
	local slot_item = GET_CHILD_RECURSIVELY(groupbox, "slot_item", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(slot_item);
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	CLEAR_SELL_INFO(frame)
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

	local obj = GetIES(invItem:GetObject());

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

	local groupbox = frame:GetChild("groupbox");
	local sellPriceGbox = GET_CHILD_RECURSIVELY(groupbox, "sellPriceGbox");
	local maxPrice = sellPriceGbox:GetChild("maxPrice");
	local minPrice = sellPriceGbox:GetChild("minPrice");
	
	sellPriceGbox:SetTextByKey("value", '0');
	sellPriceGbox:SetTextByKey("value", '0');

	local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_count", "ui::CEditControl");
	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price", "ui::CEditControl");
	if obj.ClassName == "PremiumToken" then
		edit_count:SetText("1");
		edit_count:SetMaxNumber(1);
		edit_price:SetMaxNumber(TOKEN_MARKET_REG_MAX_PRICE * invItem.count);
		edit_price:SetMaxLen(edit_price:GetMaxLen() + 3);
	else
		edit_price:SetMaxNumber(2147483647);
		edit_price:SetMaxLen(edit_price:GetMaxLen() + 3); -- 3: , 텍스트로 변환		
	end



	if nil == slot then
		slot = GET_CHILD_RECURSIVELY(groupbox, "slot_item", "ui::CSlot");
	end
	SET_SLOT_ITEM(slot, invItem);
	edit_count:SetText(tradeCount);
	edit_count:SetMaxNumber(tradeCount);
	MARKET_SELL_UPDATE_SLOT_ITEM(frame);
	
	return true;
end

function MARKET_SELL_RBUTTON_ITEM_CLICK(frame, invItem)
	local groupbox = frame:GetChild("groupbox");
	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price", "ui::CEditControl");
	local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_count", "ui::CEditControl");

	local ret = MARKET_SELL_UPDATE_REG_SLOT_ITEM(frame, invItem, nil);
	if ret == true then
		edit_price:SetText("0");
		edit_price:SetMinNumber(0);

		local edit_count_value = string.gsub(edit_count:GetText(), ",", "")
		local edit_price_value = string.gsub(edit_price:GetText(), ",", "")
		local radioCtrl = GET_CHILD_RECURSIVELY(frame, "feePerTime_1")
		local feeSelectIndex = GET_RADIOBTN_NUMBER(radioCtrl) - 1;
		local feeSelected = tonumber(frame:GetUserValue('FREE_'..feeSelectIndex));
		local priceText = GET_CHILD_RECURSIVELY(frame, "priceText")
		priceText:SetTextByKey("priceText", GetMonetaryString(edit_price_value))
		UPDATE_FEE_INFO(frame, feeSelected, edit_count_value, edit_price_value)

		MARKET_SELL_REQUEST_PRICE_INFO(frame, invItem:GetIESID(), invItem.type);
	end
end

function MARKET_SELL_ITEM_POP_BY_SLOT(parent, slot)

	local groupbox = parent:GetChild("groupbox");
	if groupbox == nil then
		local frame = parent:GetTopParentFrame();
		groupbox = frame:GetChild("groupbox");
	end

	local frame = parent:GetTopParentFrame();
	local itemname = GET_CHILD_RECURSIVELY(groupbox, "itemname");
	itemname:SetTextByKey("name", frame:GetUserConfig("ITEM_NAME_DEF"));
	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price", "ui::CEditControl");
	edit_price:SetText("0");
	local edit_count =GET_CHILD_RECURSIVELY(groupbox, "edit_count", "ui::CEditControl");
	edit_count:SetText("1");
	local silverRate = groupbox:GetChild("sellPriceGbox");

	local maxPrice = silverRate:GetChild("maxPrice");
	local minPrice = silverRate:GetChild("minPrice");
	
	maxPrice:SetTextByKey("value", '0');
	minPrice:SetTextByKey("value", '0');

	local slot_item = GET_CHILD_RECURSIVELY(groupbox, "slot_item", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(slot_item);
	CLEAR_SELL_INFO(frame)
end

function MARKET_SELL_ITEM_DROP_BY_SLOT(parent, slot)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local groupbox = slot:GetParent();
	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price", "ui::CEditControl");
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
			MARKET_SELL_REQUEST_PRICE_INFO(frame, itemID, invItem.type);
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
	local silverRate = groupbox:GetChild("sellPriceGbox");

	local maxPrice = silverRate:GetChild("maxPrice");
	local minPrice = silverRate:GetChild("minPrice");
	maxPrice:SetTextByKey("value", '0');
	minPrice:SetTextByKey("value", '0');

	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price", "ui::CEditControl");
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
		maxPrice:SetTextByKey("value", GET_COMMAED_STRING(maxAllow));        
		minPrice:SetTextByKey("value", GET_COMMAED_STRING(minAllow));
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

		local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_count", "ui::CEditControl");
		local edit_count_value = string.gsub(edit_count:GetText(), ",", "")
		local edit_price_value = string.gsub(edit_price:GetText(), ",", "")
		local radioCtrl = GET_CHILD_RECURSIVELY(frame, "feePerTime_1")
		local feeSelectIndex = GET_RADIOBTN_NUMBER(radioCtrl) - 1;
		local feeSelected = tonumber(frame:GetUserValue('FREE_'..feeSelectIndex));

		local priceText = GET_CHILD_RECURSIVELY(frame, "priceText")
		priceText:SetTextByKey("priceText", GetMonetaryString(edit_price_value))

		UPDATE_FEE_INFO(frame, feeSelected, edit_count_value, edit_price_value)
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

	if count + 1 > maxCount then
		ui.SysMsg(ClMsg("MarketRegitCntOver"));
		return;
	end
	local frame = parent:GetTopParentFrame();
	local groupbox = frame:GetChild("groupbox");
	local slot_item = GET_CHILD_RECURSIVELY(groupbox, "slot_item", "ui::CSlot");
	local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_count");
	local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price");

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
	local limitMoney = MARKET_REGISTER_SILVER_LIMIT;
	if price * count > limitMoney then
		ui.SysMsg(ScpArgMsg('MarketMaxSilverLimit{LIMIT}Over', 'LIMIT', GET_COMMAED_STRING(limitMoney)));
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

        local sellPriceGbox = GET_CHILD_RECURSIVELY(frame, 'sellPriceGbox');
        local priceText = GET_CHILD(sellPriceGbox, 'priceText');
        priceText:SetTextByKey('priceText', GetMonetaryString(floorprice));
	end

	if count <= 0 then
		ui.SysMsg(ClMsg("SellCountMustOverThenZeo"));		
		return;
	end

	local isPrivate = GET_CHILD_RECURSIVELY(groupbox, "isPrivate", "ui::CCheckBox");
	local itemGuid = invitem:GetIESID();
	local obj = GetIES(invitem:GetObject());

	--선택한 라디오를 가져옴
	local radioCtrl = GET_CHILD_RECURSIVELY(frame, "feePerTime_1")
	local selecIndex = GET_RADIOBTN_NUMBER(radioCtrl) - 1;

	local needTime = frame:GetUserIValue('TIME_'..selecIndex);
	local free = tonumber(frame:GetUserValue('FREE_'..selecIndex));
	local registerFeeValueCtrl = GET_CHILD_RECURSIVELY(frame, "registerFeeValue");
	local commission = registerFeeValueCtrl:GetTextByKey("value")	
	commission = string.gsub(commission, ",", "")
	commission = math.max(tonumber(commission), 1);
	if IsGreaterThanForBigNumber(commission, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ClMsg("Auto_SilBeoKa_BuJogHapNiDa."));
		return;
	end

	UPDATE_FEE_INFO(frame, free, count, price)

	local sellPriceGbox = GET_CHILD_RECURSIVELY(groupbox, "sellPriceGbox");

	local down = sellPriceGbox:GetChild("minPrice");

	local minPrice = down:GetTextByKey("value");
	local iminPrice = GET_NOT_COMMAED_NUMBER(minPrice);
	local iPrice = tonumber(price);
	if IGNORE_ITEM_AVG_TABLE_FOR_TOKEN == 1 then
		if false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			if 0 ~= iminPrice and  iPrice < iminPrice then
				ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", minPrice));	
				return;
			end
		end
	else
		if 0 ~= iminPrice and  iPrice < iminPrice then
			ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", minPrice));	
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
	commission = registerFeeValueCtrl:GetTextByKey("value");	
	commission = string.gsub(commission, ",", "");
	commission = math.max(tonumber(commission), 1);
	if nil~= obj and obj.ItemType =='Equip' then
		if 0 < obj.BuffValue then
			-- 장비그룹만 buffValue가 있다.
			ui.MsgBox(ScpArgMsg("BuffDestroy{Price}","Price", tostring(commission)), yesScp, "None");
		else
			ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", GetMonetaryString(commission)), yesScp, "None");			
		end
	else
		ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", GetMonetaryString(commission)), yesScp, "None");
	end
end

function UPDATE_COUNT_STRING(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local edit_price = GET_CHILD_RECURSIVELY(frame, "edit_price");
	
	local limitMoney = MARKET_REGISTER_SILVER_LIMIT
	local itemPrice = edit_price:GetText()
    itemPrice = string.gsub(itemPrice, ',', '')
    itemPrice = tonumber(itemPrice)

	local countTxt = ctrl:GetText();
	if countTxt ~= nil then
		local count = tonumber(countTxt);
		if count == nil or countTxt == "" then
			count = 0;
		end
		
		if count * tonumber(itemPrice) > limitMoney then
			count = math.floor(limitMoney / itemPrice)
			ui.SysMsg(ScpArgMsg('MarketMaxSilverLimit{LIMIT}Over', 'LIMIT', GET_COMMAED_STRING(limitMoney)));
		end
		ctrl:SetText(count)
		UPDATE_FEE_INFO(frame, nil, count, nil)
	end
end

function UPDATE_MONEY_COMMAED_STRING(parent, ctrl)	
    local moneyText = ctrl:GetText();
    if moneyText == "" then
        moneyText = 0;
    end

    local frame = parent:GetTopParentFrame();
    local limitMoney = MARKET_REGISTER_SILVER_LIMIT;
    if frame:GetName() == 'accountwarehouse' then
    	limitMoney = ACCOUNT_WAREHOUSE_MAX_STORE_SILVER;
    end

    if tonumber(moneyText) > limitMoney then
        moneyText = tostring(limitMoney);
        ui.SysMsg(ScpArgMsg('MarketMaxSilverLimit{LIMIT}Over', 'LIMIT', GET_COMMAED_STRING(limitMoney)));
    end
    ctrl:SetText(GET_COMMAED_STRING(moneyText));
end

function UPDATE_MARKET_MONEY_STRING(parent, ctrl)	
    local moneyText = ctrl:GetText();    
    if moneyText == "" then
        moneyText = 0;
    end

    local frame = parent:GetTopParentFrame();    
    local limitMoney = MARKET_REGISTER_SILVER_LIMIT;
    
	local edit_count = GET_CHILD_RECURSIVELY(frame, "edit_count")
	local itemCount = edit_count:GetText()

    if tonumber(moneyText) * itemCount > limitMoney then
        moneyText = tostring(math.floor(limitMoney / itemCount));
        ui.SysMsg(ScpArgMsg('MarketMaxSilverLimit{LIMIT}Over', 'LIMIT', GET_COMMAED_STRING(limitMoney)));
	end
    ctrl:SetText(GET_COMMAED_STRING(moneyText));

	local feeGBoxFrame = GET_CHILD_RECURSIVELY(frame, "feeGbox");
	UPDATE_FEE_INFO(feeGBoxFrame, nil, nil, tonumber(moneyText))

	local price_text = GET_CHILD_RECURSIVELY(frame, "priceText");
	price_text:SetTextByKey("priceText", GetMonetaryString(tonumber(moneyText)));
end

--feeGBox의 컨텐츠 업데이트(등록 수수료, 총 판매 가격, 수수료, 최종 수령금 표시)
--호출 함수 : 라디오버튼 클릭시, edit_price에서 가격 수정시
function UPDATE_FEE_INFO(frame, free, count, price)
	local registerFeeValueCtrl = GET_CHILD_RECURSIVELY(frame, "registerFeeValue"); --등록 수수료
	local totalSellPriceValueCtrl = GET_CHILD_RECURSIVELY(frame, "totalSellPriceValue"); --총 판매 가격
	local feeValueCtrl = GET_CHILD_RECURSIVELY(frame, "feeValue"); --수수료(10% or 30%)
	local finalRecieveValueCtrl = GET_CHILD_RECURSIVELY(frame, "finalRecieveValue"); --최종 수령금

	if free == nil then
		local radioCtrl = GET_CHILD_RECURSIVELY(frame, "feePerTime_1")
		local selecIndex = GET_RADIOBTN_NUMBER(radioCtrl) - 1;
		local parentFrame = frame:GetTopParentFrame();
		free = tonumber(parentFrame:GetUserValue('FREE_'..selecIndex));
	end
	if count == nil then
		local parentFrame = frame:GetTopParentFrame();
		local groupbox = parentFrame:GetChild("groupbox");
		local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_count");
		local countTxt = edit_count:GetText();
		if countTxt ~= nil then
			count = tonumber(countTxt);
			if count == nil or countTxt == "" then
				count = 0;
			end
		else
			return;
		end
	end
	if price == nil then
		local parentFrame = frame:GetTopParentFrame();
		local groupbox = parentFrame:GetChild("groupbox");
		local edit_price = GET_CHILD_RECURSIVELY(groupbox, "edit_price");
		local priceTxt = edit_price:GetText();
		if priceTxt ~= nil then
			price = GET_NOT_COMMAED_NUMBER(priceTxt);
		else
			return;
		end
	end
	
	--소수점 단위 버림
	local totalPrice = math.mul_int_for_lua(price, count);
	local registerFeeValue = math.max(math.floor(tonumber(math.mul_int_for_lua(math.mul_int_for_lua(totalPrice, free), 0.01))), 1);	
	local feeValue = 0;
	local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
	local isPremiumStateNexonPC = session.loginInfo.IsPremiumState(NEXON_PC);
	if isTokenState == true then
		feeValue = tonumber(math.mul_for_lua(GetCashValue(ITEM_TOKEN, "marketSellCom"), 0.01));		
	elseif isPremiumStateNexonPC == true then
		feeValue = tonumber(math.mul_for_lua(GetCashValue(NEXON_PC, "marketSellCom"), 0.01));		
	else
		feeValue = tonumber(math.mul_for_lua(GetCashValue(NONE_PREMIUM, "marketSellCom"), 0.01))		
	end	

	feeValue = math.mul_int_for_lua(totalPrice, feeValue)
	feeValue = tonumber(feeValue)
	feeValue = math.floor(feeValue)
	if feeValue > 0 then
		feeValue = tonumber(math.mul_int_for_lua(feeValue, -1));
	end
	feeValue = math.floor(feeValue)
	local finalValue = tonumber(math.add_for_lua(totalPrice, feeValue));

	registerFeeValueCtrl:SetTextByKey("value", GET_COMMAED_STRING(registerFeeValue));
	totalSellPriceValueCtrl:SetTextByKey("value", GET_COMMAED_STRING(totalPrice));
	feeValueCtrl:SetTextByKey("value", GET_COMMAED_STRING(feeValue));
	finalRecieveValueCtrl:SetTextByKey("value", GET_COMMAED_STRING(finalValue));
end

--라디오 버튼의 선택에 따라 feeGBox의 컨텐츠 업데이트
function UPDATE_FEE_INFO_BY_RADIO(frame, slot, argStr, argNum)
	local parentFrame = frame:GetTopParentFrame();
	local free = tonumber(parentFrame:GetUserValue('FREE_'..argNum - 1));
	UPDATE_FEE_INFO(frame, free, nil, nil)

	--현재 선택한 라디오 저장
	local cnt = GetMarketTimeCount();
	for i = 1 , cnt do
		config.ChangeXMLConfig('MarketSellFeeValue'..i, 0);
	end
	config.ChangeXMLConfig('MarketSellFeeValue'..argNum, 1);
end

--거래 완료 후 판매 창의 info 0으로 초기화
function CLEAR_SELL_INFO(frame)
	local feeGBoxFrame = GET_CHILD_RECURSIVELY(frame, "feeGbox");
	UPDATE_FEE_INFO(feeGBoxFrame, 0, 0, 0);

	local groupbox = frame:GetChild("groupbox");
	local edit_count = GET_CHILD_RECURSIVELY(groupbox, "edit_price");
	edit_count:SetText(0);
	local price_text = GET_CHILD_RECURSIVELY(frame, "priceText");
	price_text:SetTextByKey("priceText", 0)
	local curMinPrice = GET_CHILD_RECURSIVELY(frame, 'curMinPrice');
	curMinPrice:SetTextByKey("value", 0)
	local priceText = GET_CHILD_RECURSIVELY(frame, "priceText")
	priceText:SetTextByKey("priceText", "0")
end

function MARKET_SELL_REQUEST_PRICE_INFO(frame, itemGuid, itemClassID)
	market.ReqSellMinMaxInfo(itemGuid);
	RequestMarketMinPrice(itemClassID);
	frame:SetUserValue('REQ_ITEMID', itemGuid)
end

function ON_RESPONSE_MIN_PRICE(frame, msg, minPrice, argNum)	
	local curMinPrice = GET_CHILD_RECURSIVELY(frame, 'curMinPrice');
	curMinPrice:SetTextByKey('value', GetMonetaryString(minPrice));
end