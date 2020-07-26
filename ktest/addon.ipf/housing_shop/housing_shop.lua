function HOUSING_SHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('GUILD_HOUSING_SHOP', 'ON_GUILD_HOUSING_SHOP');
	addon:RegisterMsg('START_GUILD_HOUSING_SHOP', 'ON_START_GUILD_HOUSING_SHOP');
	addon:RegisterMsg('START_HOUSING_SHOP_BUTTON_BUYSELL', 'ON_START_HOUSING_SHOP_BUTTON_BUYSELL');
	
	addon:RegisterMsg('PERSONAL_HOUSING_SHOP', 'ON_PERSONAL_HOUSING_SHOP');
end

function ON_GUILD_HOUSING_SHOP(frame)
	ui.OpenFrame("housing_shop");
end

function ON_PERSONAL_HOUSING_SHOP(frame)
	ui.OpenFrame("housing_shop");
end

function OPEN_HOUSING_SHOP(frame)
	housing.BeginPreviewEditMode();

	local buy_price = GET_CHILD_RECURSIVELY(frame, 'buy_price');
	local sell_price = GET_CHILD_RECURSIVELY(frame, 'sell_price');
	
	local pricetxt = GET_CHILD_RECURSIVELY(frame, 'pricetxt');
	local finalprice = GET_CHILD_RECURSIVELY(frame, 'finalprice');
	local tradePrice = GET_CHILD_RECURSIVELY(frame, 'tradePrice');
	local inven_Zenytext = GET_CHILD_RECURSIVELY(frame, 'inven_Zenytext');

	if IS_PERSONAL_HOUSING_PLACE() == true then
		ui.OpenFrame("inventory");
		
		local function _RESET_PARAM(uiObject, format, value1)
			uiObject:ResetParamInfo();
			uiObject:SetFormat(format);
			uiObject:AddParamInfo("price1", 0);
			uiObject:SetTextByParamIndex(0, value1);
			uiObject:SetUserValue("Price", 0);
		end
		
		_RESET_PARAM(buy_price, "{img silver 20 20} {@st41}%s{/}", 0);
		
		local format = "{@st41}";

		local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
		for i = 1, #couponList do
			local itemClass = GetClass("Item", couponList[i]);
			if itemClass ~= nil then
				format = format .. string.format("{img %s 30 30}", TryGetProp(itemClass, "Icon"));
				format = format .. "  %s";

				if i ~= #couponList then
					format = format .. "    ";
				end
			end
		end
		
		format = format .. "{/}";

		sell_price:ResetParamInfo();
		sell_price:SetFormat(format);

		for i = 1, #couponList do
			sell_price:AddParamInfo(couponList[i] .. "_count", 0);
			sell_price:SetTextByParamIndex(0, 0);
		end
	
		pricetxt:SetVisible(0);
		finalprice:SetVisible(0);
		tradePrice:SetVisible(0);
		inven_Zenytext:SetVisible(0);

		SCP_HOUSING_SHOP_TAB_LANDSCAPE(frame, nil);
	else
		local function _RESET_PARAM(uiObject, format, value1, value2, value3, value4)
			uiObject:ResetParamInfo();
			uiObject:SetFormat(format);
			uiObject:AddParamInfo("price1", 0);
			uiObject:AddParamInfo("price2", 0);
			uiObject:AddParamInfo("price3", 0);
			uiObject:AddParamInfo("price4", 0);

			uiObject:SetTextByParamIndex(0, 0);
			uiObject:SetTextByParamIndex(1, 0);
			uiObject:SetTextByParamIndex(2, 0);
			uiObject:SetTextByParamIndex(3, 0);
			uiObject:SetUserValue("Price", 0);
		end
		
		_RESET_PARAM(buy_price, "{img icon_guild_housing_coin_01 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st41}%s{/}", 0, 0, 0, 0);
		_RESET_PARAM(sell_price, "{img icon_guild_housing_coin_01 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st41}%s{/}", 0, 0, 0, 0);

		pricetxt:SetVisible(1);
		finalprice:SetVisible(1);
		tradePrice:SetVisible(1);
		inven_Zenytext:SetVisible(1);

		housing.RequestGuildAgitInfo("START_GUILD_HOUSING_SHOP");
	end
end

function ON_START_GUILD_HOUSING_SHOP(frame)
	ui.OpenFrame("inventory");

	local itembox_tab = GET_CHILD_RECURSIVELY(frame, "itembox");
	itembox_tab:SelectTab(0);
end

function CLOSE_HOUSING_SHOP(frame)
	housing.EndPreviewEditMode();
	housing.ClearPreviewFurniture();
	control.DialogOk();
	ui.EnableSlotMultiSelect(0);

	SHOP_SELECT_ITEM_LIST = {};
	
	local invenFrame = ui.GetFrame('inventory');
	INVENTORY_UPDATE_ICONS(invenFrame);
	INVENTORY_CLEAR_SELECT(invenFrame);
	if invenFrame:IsVisible() == 1 then
		invenFrame:ShowWindow(0);
	end

	ui.CloseFrame("housing_shop_payment");
end

function HOUSING_SHOP_SLOT_RBTNDOWN_2(gbox, slotList, argStr, argNum)
	local ConSetBySlot = slotList:GetChild('slot');
	local slot = tolua.cast(ConSetBySlot, "ui::CSlot");

	HOUSING_SHOP_SLOT_RBTNDOWN(gbox, slot, argStr, argNum);
end

function HOUSING_SHOP_SLOT_RBTNDOWN(gbox, slot, argStr, argNum)
	local classID = argNum;
	local shopItem = geShopTable.GetByClassID(classID);

	local frame = gbox:GetTopParentFrame();

	local buyCount = shopItem.count;
	if keyboard.IsKeyPressed("LSHIFT") == 1 then
		local buyableCnt = 99;

		local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", buyableCnt);
		INPUT_NUMBER_BOX(frame, titleText, "HOUSING_SHOP_BUY_LARGE", 1, 1, buyableCnt, nil, nil, 1);
		frame:SetUserValue("BUY_CLSID", classID);
		return;
	end

	HOUSING_SHOP_BUY(frame, classID, 1);
end

function HOUSING_SHOP_BUY_LARGE(frame, buyCount)
	local classID = tonumber(frame:GetUserValue("BUY_CLSID"));
	HOUSING_SHOP_BUY(frame, classID, buyCount);
end

function HOUSING_SHOP_BUY(frame, classID, buyCount)
	local shopItem = geShopTable.GetByClassID(classID);

	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	imcSound.PlaySoundEvent('inven_equip');
	
	local isExistsSameItem = false;
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		if slotIcon ~= nil then
			local slot = slotSet:GetSlotByIndex(i);
			local slotShopItem = GET_SHOP_SLOT_CLSID(slot);
			if slotShopItem == classID then
				isExistsSameItem = true;
				local itemCount = slot:GetUserValue("BuyCount");
				if itemCount == nil or itemCount == "None" then
					itemCount = 0;
				else
					itemCount = tonumber(itemCount);
				end

				if GET_SHOP_ITEM_MAXSTACK(shopItem) >= buyCount + itemCount then
					itemCount = itemCount + buyCount;

					slot:SetUserValue("BuyCount", tostring(itemCount));

					local slotIcon	= slotSet:GetIconByIndex(i);
					slot:SetText('{s18}{ol}{b}' .. itemCount, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
					slot:Invalidate();

					HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
					return;
				end
			end
		end
	end

	if isExistsSameItem == true then
		return;
	end
	
	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);

		if slotIcon == nil then
			local slot = slotSet:GetSlotByIndex(i);
			local icon = CreateIcon(slot);
			icon:Set(shopItem:GetIcon(), 'BUYITEMITEM', classID, 0);

			SET_SHOP_ITEM_TOOLTIP(icon, shopItem);

			slot:SetEventScript(ui.RBUTTONDOWN, "HOUSING_SHOP_CANCEL_BUY");
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
			
			slot:SetUserValue("BuyCount", tostring(buyCount));

			slot:SetText('{s18}{ol}{b}' .. buyCount, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
			HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
			return;
		end
	end
end

function HOUSING_SHOP_CANCEL_BUY(gbox, btn, argStr, argNum)
	local frame = gbox:GetTopParentFrame();

	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local slot	= slotSet:GetSlotByIndex(argNum);
	if slot:GetIcon() ~= nil then
		slot:SetUserValue("BuyCount", "0");
		slot:ClearText();
		slot:ClearIcon();

		HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
	end
	imcSound.PlaySoundEvent("inven_unequip");
end

function HOUSING_SHOP_ITEM_SLOT_INIT(gbox, btn)
	local frame = gbox:GetTopParentFrame();

	-- 구입 슬롯 초기화
	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:ClearText();
			slot:ClearIcon();
		end
	end

	-- 판매 슬롯 초기화 ( 판매는 인벤쪽으로 아이템을 복귀 시켜줘야 한다 )
	groupbox = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	local updateInv = false;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			local invItem = session.GetInvItemByGuid(itemID);

			updateInv = true;
			SHOP_SELECT_ITEM_LIST[itemID] = nil
			slot:SetUserValue("SellCount", "0");

			slot:ClearText();
			slot:ClearIcon();
		end
	end

	if updateInv == true then
		INVENTORY_UPDATE_ICONS(ui.GetFrame("inventory"));
	end
	
	local buy_price = GET_CHILD_RECURSIVELY(frame, 'buy_price');
	local sell_price = GET_CHILD_RECURSIVELY(frame, 'sell_price');
	local pricetxt = GET_CHILD_RECURSIVELY(frame, 'pricetxt');
	local finalprice = GET_CHILD_RECURSIVELY(frame, 'finalprice');
	
	local sell_itemtext = GET_CHILD_RECURSIVELY(frame, 'sell_itemtext');
	local sell_price = GET_CHILD_RECURSIVELY(frame, 'sell_price');
	local sellitemslot = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	
	local preview_itemtext = GET_CHILD_RECURSIVELY(frame, 'preview_itemtext');
	local preview_price = GET_CHILD_RECURSIVELY(frame, 'preview_price');
	local preview_furniture_slot = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	
	local tradePrice = GET_CHILD_RECURSIVELY(frame, 'tradePrice');
	local inven_Zenytext = GET_CHILD_RECURSIVELY(frame, 'inven_Zenytext');
	
	local boardLine_1 = GET_CHILD_RECURSIVELY(frame, 'boardLine_1');

	if IS_PERSONAL_HOUSING_PLACE() == true then
		local function _RESET_PARAM(uiObject, format, value1)
			uiObject:ResetParamInfo();
			uiObject:SetFormat(format);
			uiObject:AddParamInfo("price1", 0);
			uiObject:SetTextByParamIndex(0, value1);
			uiObject:SetUserValue("Price", 0);
		end
		
		_RESET_PARAM(buy_price, "{img silver 20 20} {@st41}%s{/}", 0);
		
		local format = "{@st41}";

		local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
		for i = 1, #couponList do
			local itemClass = GetClass("Item", couponList[i]);
			if itemClass ~= nil then
				format = format .. string.format("{img %s 30 30}", TryGetProp(itemClass, "Icon"));
				format = format .. "  %s";

				if i ~= #couponList then
					format = format .. "    ";
				end
			end
		end
		
		format = format .. "{/}";

		sell_price:ResetParamInfo();
		sell_price:SetFormat(format);

		for i = 1, #couponList do
			sell_price:AddParamInfo(couponList[i] .. "_count", 0);
			sell_price:SetTextByParamIndex(0, 0);
		end

		preview_price:SetTextByParamIndex(0, "0");

		pricetxt:SetVisible(0);
		finalprice:SetVisible(0);
		tradePrice:SetVisible(0);
		inven_Zenytext:SetVisible(0);
		boardLine_1:SetVisible(0);

		preview_price:SetVisible(1);
		preview_itemtext:SetVisible(1);
		preview_furniture_slot:SetVisible(1);
		
		sell_itemtext:SetMargin(20, 190, 0, 0);
		sell_price:SetMargin(0, 185, 20, 0);
		sellitemslot:SetMargin(0, 220, 0, 0);

		preview_itemtext:SetMargin(20, 105, 0, 0);
		preview_price:SetMargin(0, 105, 20, 0);
		preview_furniture_slot:SetMargin(0, 135, 0, 0);

		groupbox = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
		slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
		slotCount = slotSet:GetSlotCount();

		for i = 0, slotCount - 1 do
			local slot = slotSet:GetSlotByIndex(i);
			if slot:GetIcon() ~= nil then
				local count = tonumber(slot:GetUserValue("BuyCount"));
				for i = 1, count do
					local furnitureHandle = tonumber(slot:GetUserValue("FurnitureHandle_" .. tostring(i)));
					housing.RemovePreviewFurniture(furnitureHandle);
				end

				slot:ClearText();
				slot:ClearIcon();
				slot:SetUserValue("BuyCount", "0");
				slot:SetUserValue("ItemClassID", "0");
				slot:SetUserValue("FurnitureClassID", "0");
			end
		end
	else
		local function _RESET_PARAM(uiObject, format, value1, value2, value3, value4)
			uiObject:ResetParamInfo();
			uiObject:SetFormat(format);
			uiObject:AddParamInfo("price1", 0);
			uiObject:AddParamInfo("price2", 0);
			uiObject:AddParamInfo("price3", 0);
			uiObject:AddParamInfo("price4", 0);

			uiObject:SetTextByParamIndex(0, 0);
			uiObject:SetTextByParamIndex(1, 0);
			uiObject:SetTextByParamIndex(2, 0);
			uiObject:SetTextByParamIndex(3, 0);
			uiObject:SetUserValue("Price", 0);
		end

		_RESET_PARAM(buy_price, "{img icon_guild_housing_coin_01 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st41}%s{/}", 0, 0, 0, 0);
		_RESET_PARAM(sell_price, "{img icon_guild_housing_coin_01 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st41}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st41}%s{/}", 0, 0, 0, 0);
		
		pricetxt:SetVisible(1);
		_RESET_PARAM(pricetxt, "{img icon_guild_housing_coin_01 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st66d_y}%s{/}", 0, 0, 0, 0);
		
		local guildAgit = housing.GetGuildAgitInfo();

		local housingPoint_Originality = guildAgit.points[tos.housing.guild.eOriginality + 1];		-- 독창성
		local housingPoint_Functionality = guildAgit.points[tos.housing.guild.eFunctionality + 1];	-- 기능성
		local housingPoint_Artistry = guildAgit.points[tos.housing.guild.eArtistry + 1];			-- 예술성
		local housingPoint_Economy = guildAgit.points[tos.housing.guild.eEconomy + 1];				-- 경제성
		
		finalprice:SetVisible(1);
		_RESET_PARAM(finalprice, "{img icon_guild_housing_coin_01 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st66d_y}%s{/}", housingPoint_Originality, housingPoint_Functionality, housingPoint_Artistry, housingPoint_Economy);
		
		tradePrice:SetVisible(1);
		inven_Zenytext:SetVisible(1);
		boardLine_1:SetVisible(1);
		
		preview_price:SetVisible(0);
		preview_itemtext:SetVisible(0);
		preview_furniture_slot:SetVisible(0);

		sell_itemtext:SetMargin(20, 105, 0, 0);
		sell_price:SetMargin(0, 105, 20, 0);
		sellitemslot:SetMargin(0, 135, 0, 0);
	end
end

function HOUSING_SHOP_UPDATE_ITEM_PRICE(frame)
	if IS_PERSONAL_HOUSING_PLACE() == true then
		PERSONAL_HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
	else
		GUILD_HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
	end
end

function PERSONAL_HOUSING_SHOP_UPDATE_ITEM_PRICE(frame)
	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local buyPrice = 0;
	local buyPrice_coupon = 0;

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local slotItemClassID = GET_SHOP_SLOT_CLSID(slot);
		local shopItem = geShopTable.GetByClassID(slotItemClassID);
		if shopItem ~= nil then
			local itemClass = GET_SHOP_ITEM_CLS(shopItem);
			if itemClass ~= nil then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					buyPrice = buyPrice + TryGetProp(itemClass, "Price") * itemCount;
					buyPrice_coupon = buyPrice_coupon + TryGetProp(furnitureClass, "Price1") * itemCount;
				end
			end
		end
	end

	local sellPrice = 0;

	groupbox = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		
		local itemID = slot:GetUserValue("ItemClassID");
		local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(itemID);
		if furnitureClass ~= nil then
			local itemClass = GetClass("Item", TryGetProp(furnitureClass, "ItemClassName"));
			if itemClass ~= nil then
				local itemCount = slot:GetUserValue("SellCount");
				if itemCount == nil or itemCount == "None" then
					itemCount = 0;
				else
					itemCount = tonumber(itemCount);
				end
				
				sellPrice = sellPrice + TryGetProp(itemClass, "SellPrice") * itemCount;
			end
		end
	end
	
	local previewPrice = 0;

	groupbox = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		
		local itemID = slot:GetUserValue("ItemClassID");
		local slotShopItem = tonumber(slot:GetUserValue("ItemClassID"));
		local itemClass = GetClassByType("Item", slotShopItem);
		if itemClass ~= nil then
			local itemCount = slot:GetUserValue("BuyCount");
			if itemCount == nil or itemCount == "None" then
				itemCount = 0;
			else
				itemCount = tonumber(itemCount);
			end
				
			previewPrice = previewPrice + TryGetProp(itemClass, "Price") * itemCount;
		end
	end

	local buy_price = GET_CHILD_RECURSIVELY(frame, "buy_price");
	local sell_price = GET_CHILD_RECURSIVELY(frame, "sell_price");
	local preview_price = GET_CHILD_RECURSIVELY(frame, "preview_price");

	local hasSilver = 0;
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		hasSilver = tonumber(invItem:GetAmountStr());
	end

	buy_price:SetTextByParamIndex(0, GetCommaedText(buyPrice));
	preview_price:SetTextByParamIndex(0, GetCommaedText(previewPrice));
	
	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	local sortedCoupon, couponCount = HOUSING_SHOP_PAYMENT_AUTO_COUPON_COUNT(couponList, sellPrice, nil);

	for i = 1, #sortedCoupon do
		sell_price:SetTextByKey(sortedCoupon[i] .. "_count", couponCount[i]);
	end
	
	buy_price:SetUserValue("Price", tostring(buyPrice));
	sell_price:SetUserValue("Price", tostring(sellPrice));
	preview_price:SetUserValue("Price", tostring(previewPrice));
end

function GUILD_HOUSING_SHOP_UPDATE_ITEM_PRICE(frame)
	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local buyPrice = { 0, 0, 0, 0 };

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local slotItemClassID = GET_SHOP_SLOT_CLSID(slot);
		local shopItem = geShopTable.GetByClassID(slotItemClassID);
		if shopItem ~= nil then
			local itemClass = GET_SHOP_ITEM_CLS(shopItem);

			local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
			if furnitureClass ~= nil then
				local itemCount = slot:GetUserValue("BuyCount");
				if itemCount == nil or itemCount == "None" then
					itemCount = 0;
				else
					itemCount = tonumber(itemCount);
				end

				for j = 1, 4 do
					buyPrice[j] = buyPrice[j] + TryGetProp(furnitureClass, "Price" .. j, 0) * itemCount;
				end
			end
		end
	end

	local sellPrice = { 0, 0, 0, 0 };

	groupbox = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		
		local itemID = slot:GetUserValue("ItemClassID");
		local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(itemID);
		if furnitureClass ~= nil then
			local itemCount = slot:GetUserValue("SellCount");
			if itemCount == nil or itemCount == "None" then
				itemCount = 0;
			else
				itemCount = tonumber(itemCount);
			end

			for j = 1, 4 do
				sellPrice[j] = sellPrice[j] + TryGetProp(furnitureClass, "SellPrice" .. j, 0) * itemCount;
			end
		end
	end

	local buy_price = GET_CHILD_RECURSIVELY(frame, "buy_price");
	local sell_price = GET_CHILD_RECURSIVELY(frame, "sell_price");
	local pricetxt = GET_CHILD_RECURSIVELY(frame, "pricetxt");
	local finalprice = GET_CHILD_RECURSIVELY(frame, "finalprice");

	local guildAgit = housing.GetGuildAgitInfo();

	local hasPoint = {};
	hasPoint[1] = guildAgit.points[tos.housing.guild.eOriginality + 1];
	hasPoint[2] = guildAgit.points[tos.housing.guild.eFunctionality + 1];
	hasPoint[3] = guildAgit.points[tos.housing.guild.eArtistry + 1];
	hasPoint[4] = guildAgit.points[tos.housing.guild.eEconomy + 1];
	
	local maxPoint = 500 + (guildAgit.productionLevel * 100);

	local resultFormat = "";

	for i = 1, 4 do
		buy_price:SetTextByParamIndex(i - 1, buyPrice[i]);
		sell_price:SetTextByParamIndex(i - 1, sellPrice[i]);
		pricetxt:SetTextByParamIndex(i - 1, sellPrice[i] - buyPrice[i]);
		
		local color = "{@st66d_y}";
		local result = hasPoint[i] + sellPrice[i] - buyPrice[i];
		if result < 0 or (sellPrice[i] - buyPrice[i] > 0 and result > maxPoint) then
			color = color .. "{#ff0000}";
		end
		
		resultFormat = resultFormat .. "{img icon_guild_housing_coin_01 20 20} " .. color .. "%s{/}";
		if i ~= 4 then
			resultFormat = resultFormat .. "  ";
		end
	end
	
	finalprice:SetFormat(resultFormat);
	
	for i = 1, 4 do
		local result = hasPoint[i] + sellPrice[i] - buyPrice[i];
		finalprice:SetTextByParamIndex(i - 1, result);
	end
end

function HOUSING_SHOP_SELL(invitem, sellCount, frame, setTotalCount)
	if true == invitem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemobj = GetIES(invitem:GetObject());
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableShopTrade() == false then
		ui.SysMsg(ClMsg("CannoTradeToNPC"));
		return;
	end
	
	local isValid = false;
	local shopItemList = session.GetShopItemList();
	for i = 0, shopItemList:Count() - 1 do
		local shopItem = shopItemList:PtrAt(i);
		if shopItem.type == itemobj.ClassID then
			isValid = true;
			break;
		end
	end
	
	if isValid == false then
		ui.SysMsg(ClMsg("Housing_Cant_Sell_This_Item"));
		return;
	end

	imcSound.PlaySoundEvent('button_inven_click_item');
	local slot = GET_USABLE_SLOTSET(frame, invitem);
	slot:SetUserValue("SLOT_ITEM_ID", invitem:GetIESID());
	slot:SetUserValue("ItemClassID", tostring(invitem.type));

	local icon = CreateIcon(slot);
	local imageName = GET_EQUIP_ITEM_IMAGE_NAME(itemobj, 'Icon')
	icon:Set(imageName, 'SELLITEMITEM', 0, 0, invitem:GetIESID());
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invitem, itemobj.ClassName,'buy', invitem.type, invitem:GetIESID());

	slot:SetEventScript(ui.RBUTTONDOWN, "HOUSING_SHOP_CANCEL_SELL");

	local curCnt = slot:GetUserIValue("SellCount");
	if setTotalCount then
		curCnt = sellCount;
	else
		curCnt = curCnt + sellCount;
	end

	if curCnt > 1 and sellCount == 1 then
	    local sObj = session.GetSessionObjectByName("ssn_klapeda")
	    if sObj ~= nil then
    	    sObj = GetIES(sObj:GetIESObject())
    	    if sObj ~= nil then
    	        local pc = GetMyPCObject();
    	        if sObj.SHOP_SELLITEM_HELP == 0 then
    	            addon.BroadMsg('NOTICE_Dm_Shoptutorial', ScpArgMsg('shoptutorial_Rclick'), 10);
            	    sObj.SHOP_SELLITEM_HELP = sObj.SHOP_SELLITEM_HELP + 1
            	end
        	end
    	end
	end

	if curCnt > invitem.count then
		curCnt = invitem.count;
	end
	
	slot:SetUserValue("SellCount", curCnt);

	if itemobj.MaxStack > 1 then
		slot:SetText('{s18}{b}{ol}'..curCnt, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
	end
	
	SHOP_SELECT_ITEM_LIST[invitem:GetIESID()] = curCnt;

	HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
	INVENTORY_UPDATE_ICON_BY_INVITEM(ui.GetFrame('inventory'), invitem);
end

function HOUSING_SHOP_CANCEL_SELL(gbox, slot, argStr, argNum)
	local frame = gbox:GetTopParentFrame();

	local groupbox  = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	local slotSet  	= tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	if slot:GetClassName() == "slot" then
		slot = tolua.cast(slot, "ui::CSlot");
	end

	-- 인벤으로 아이템 복귀
	local itemID = slot:GetUserValue("SLOT_ITEM_ID");
	local invitem = session.GetInvItemByGuid(itemID);

	SHOP_SELECT_ITEM_LIST[itemID] = nil
	INVENTORY_UPDATE_ICON_BY_INVITEM(ui.GetFrame('inventory'), invitem);
	
	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("SLOT_ITEM_ID", "0");
	slot:SetUserValue("SellCount", "0");

	HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);

	imcSound.PlaySoundEvent("inven_unequip");
end

function EXEC_HOUSING_SHOP_SELL(frame, cnt)
	local shopFrame = ui.GetFrame("housing_shop");

	cnt = tonumber(cnt);
	local itemGuid = frame:GetUserValue("SELL_ITEM_GUID");
	local invItem = session.GetInvItemByGuid(itemGuid);
	HOUSING_SHOP_SELL(invItem, cnt, shopFrame, true);
end

function HOUSING_SHOP_BUTTON_BUYSELL(gbox, btn)
	if IS_PERSONAL_HOUSING_PLACE() == true then
		local frame = gbox:GetTopParentFrame();
		local buy_price = GET_CHILD_RECURSIVELY(frame, 'buy_price');
		local preview_price = GET_CHILD_RECURSIVELY(frame, 'preview_price');
		local sell_price = GET_CHILD_RECURSIVELY(frame, 'sell_price');
		
		local buyPrice = buy_price:GetUserIValue("Price");
		local previewPrice = preview_price:GetUserIValue("Price");
		local sellPrice = sell_price:GetUserIValue("Price");
		if buyPrice ~= 0 or previewPrice ~= 0 or sellPrice ~= 0 then
			HOUSING_SHOP_PAYMENT_INITIALIZE(buyPrice, previewPrice, sellPrice);
		end
	else
		housing.RequestGuildAgitInfo("START_HOUSING_SHOP_BUTTON_BUYSELL");
	end
end

function ON_START_HOUSING_SHOP_BUTTON_BUYSELL()
	local guildAgit = housing.GetGuildAgitInfo();

    local isSound = false

	local frame = ui.GetFrame("housing_shop")

	housing.ClearHousingShopItems();
	
	local groupbox = GET_CHILD_RECURSIVELY(frame, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	local hasPoints = {};
	hasPoints[1] = guildAgit.points[tos.housing.guild.eOriginality + 1];
	hasPoints[2] = guildAgit.points[tos.housing.guild.eFunctionality + 1];
	hasPoints[3] = guildAgit.points[tos.housing.guild.eArtistry + 1];
	hasPoints[4] = guildAgit.points[tos.housing.guild.eEconomy + 1];

	local needPoints = { 0, 0, 0, 0 };

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local slotItemClassID = GET_SHOP_SLOT_CLSID(slot);
			local shopItem = geShopTable.GetByClassID(slotItemClassID);
			if shopItem ~= nil then
				local itemClass = GET_SHOP_ITEM_CLS(shopItem);
				
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						for j = 1, 4 do
							needPoints[j] = needPoints[j] + TryGetProp(furnitureClass, "Price" .. j, 0) * itemCount;
						end

						housing.AddHousingShopBuyItem(slotItemClassID, itemCount);
						isSound = "BuySound"
					end
				end
			end
		end
	end

	groupbox = GET_CHILD_RECURSIVELY(frame, 'sellitemslot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	local updateInv = false;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			local invitem = session.GetInvItemByGuid(itemID);
			if invitem ~= nil then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(invitem.type);
				if furnitureClass ~= nil then
					local itemCount = slot:GetUserValue("SellCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						for j = 1, 4 do
							needPoints[j] = needPoints[j] - TryGetProp(furnitureClass, "SellPrice" .. j, 0) * itemCount;
						end

						housing.AddHousingShopSellItem(itemID, itemCount);
						isSound = "SellSound"
					end
				end
			end
		end
	end

	for i = 1, 4 do
		if hasPoints[i] < needPoints[i] then
			ui.AddText("SystemMsgFrame", ClMsg('Housing_Not_Enough_Point'));
			housing.ClearHousingShopItems();
			return;
		end
	end

	housing.CommitHousingShopItems("START_GUILD_HOUSING_SHOP");

	if isSound ~= false and isSound == "BuySound" then
		imcSound.PlaySoundEvent("market buy");
	elseif isSound ~= false and isSound == "SellSound" then
		imcSound.PlaySoundEvent("market_sell");
	end
end

function HOUSING_SHOP_INIT_TAB(frame, gboxName, marketCategory)
	local shopItemList = session.GetShopItemList();

	local gbox_sell_list = GET_CHILD_RECURSIVELY(frame, gboxName);
	gbox_sell_list:RemoveAllChild();
	
	local curTime = geTime.GetServerSystemTime();

	local yPos = 0;
	for i = 0, shopItemList:Count() - 1 do
		local shopItem = shopItemList:PtrAt(i);

		if shopItem:GetPropName() ~= "Hide" then
			local itemClass = GetClassByType(shopItem:GetIDSpace(), shopItem.type);
			if marketCategory[itemClass.MarketCategory] == 1 then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(shopItem.type);
				if furnitureClass ~= nil then
					local ShopItemCountObj = gbox_sell_list:CreateControlSet("housing_shop_itemset", "SHOPITEM_" .. i, 0, yPos);
					yPos = yPos + ShopItemCountObj:GetHeight() - 5;

					local ShopItemCountCtrl = tolua.cast(ShopItemCountObj, "ui::CControlSet");

					ShopItemCountCtrl:SetEnableSelect(1);
					ShopItemCountCtrl:SetSelectGroupName("ShopItemList");

					-- 상점 아이콘 설정 및 기타 설정들을 한다
					local ConSetBySlot = ShopItemCountCtrl:GetChild('slot');
					local slot = tolua.cast(ConSetBySlot, "ui::CSlot");
					local icon = CreateIcon(slot);

					local imageName = shopItem:GetIcon();

					icon:Set(imageName, 'SHOPITEM', i, 0);
					local printText	= '{@st66b}' .. GET_SHOPITEM_TXT(shopItem, itemClass);
					local priceText = "";

					local btn_furniture_preview = ShopItemCountCtrl:GetChild("btn_furniture_preview");

					if IS_PERSONAL_HOUSING_PLACE() == true then
						priceText = string.format("{img silver 20 20} {@st66b}%s", TryGetProp(itemClass, "Price", 0));

						btn_furniture_preview:ShowWindow(1);
						btn_furniture_preview:SetUserValue("FurnitureClassID", tostring(furnitureClass.ClassID));
						btn_furniture_preview:SetUserValue("ItemClassID", tostring(shopItem.type));
					else
						local priceText1 = string.format("{img icon_guild_housing_coin_01 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price1", 0));
						local priceText2 = string.format("  {img icon_guild_housing_coin_02 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price2", 0));
						local priceText3 = string.format("  {img icon_guild_housing_coin_03 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price3", 0));
						local priceText4 = string.format("  {img icon_guild_housing_coin_04 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price4", 0));
					
						priceText = priceText1 .. priceText2 .. priceText3 .. priceText4;
					
						btn_furniture_preview:ShowWindow(0);
					end
				
					local pic_new = GET_CHILD_RECURSIVELY(ShopItemCountObj, "pic_new");

					local newOpenTimeString = TryGetProp(furnitureClass, "NewOpenTime", "None");
					local newCloseTimeString = TryGetProp(furnitureClass, "NewCloseTime", "None");

					if newOpenTimeString ~= "None" and newCloseTimeString ~= "None" then
						local yy, mm, dd, hh, mm2, ss = date_time.get_date_time(newOpenTimeString);
						local newOpenTime = imcTime.GetSysTime(yy, mm, dd, hh, mm2, ss);
				
						local yy, mm, dd, hh, mm2, ss = date_time.get_date_time(newCloseTimeString);
						local newCloseTime = imcTime.GetSysTime(yy, mm, dd, hh, mm2, ss);

						if imcTime.IsLaterThan(curTime, newOpenTime) == 1 and imcTime.IsLaterThan(newCloseTime, curTime) == 1 then
							pic_new:ShowWindow(1);
						else
							pic_new:ShowWindow(0);
						end
					else
						pic_new:ShowWindow(0);
					end

					ShopItemCountCtrl:SetEventScript(ui.RBUTTONDOWN, 'HOUSING_SHOP_SLOT_RBTNDOWN_2');
					ShopItemCountCtrl:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
					ShopItemCountCtrl:SetEventScriptArgNumber(ui.RBUTTONDOWN, shopItem.classID);
					ShopItemCountCtrl:SetTextByKey('ItemName_Count', printText);
					ShopItemCountCtrl:SetTextByKey('Item_Price', priceText);
					ShopItemCountCtrl:SetOverSound("button_over");
				
					ShopItemCountCtrl:SetUserValue("FurnitureName", TryGetProp(furnitureClass, "Name", "None"));
					ShopItemCountCtrl:SetUserValue("FurnitureTheme", TryGetProp(furnitureClass, "Theme", "None"));
					ShopItemCountCtrl:SetUserValue("FurnitureUsage", TryGetProp(furnitureClass, "Usage", "None"));
					ShopItemCountCtrl:SetUserValue("FurnitureGroup", TryGetProp(furnitureClass, "Group", "None"));

					slot:SetEventScript(ui.RBUTTONDOWN, 'HOUSING_SHOP_SLOT_RBTNDOWN');
					slot:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
					slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, shopItem.classID);

					-- 묶음아이템 수량 표시
					if shopItem.count > 1 then
						slot:SetText(shopItem.count,  'quickiconfont', ui.RIGHT, ui.BOTTOM, 0, 0);
					end

					SET_SHOP_ITEM_TOOLTIP(icon, shopItem);
				end
			end
		end
	end

	HOUSING_SHOP_ITEM_SLOT_INIT(frame);
end

function SCP_HOUSING_SHOP_TAB_LANDSCAPE(frame, gbox)
	local landscape = GET_CHILD_RECURSIVELY(frame, "landscape");
	local facilities = GET_CHILD_RECURSIVELY(frame, "facilities");
	local contract = GET_CHILD_RECURSIVELY(frame, "contract");
	
	local tab = GET_CHILD_RECURSIVELY(frame, "itembox");

	if IS_PERSONAL_HOUSING_PLACE() == true then
		tab:SetTabVisible(0, true);
		tab:SetTabVisible(1, false);
		tab:SetTabVisible(2, false);
		tab:ChangeCaption(0, ClMsg("Personal_Housing_Tab_General"), false);
		
		HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_landscape_itemlist", {["PHousing_Furniture"] = 1, ["PHousing_Carpet"] = 1, ["PHousing_Wall"] = 1});
	else
		tab:SetTabVisible(0, true);
		tab:SetTabVisible(1, true);
		tab:SetTabVisible(2, true);
		tab:ChangeCaption(0, ClMsg("Guild_Housing_Tab_Landscape"), false);
		
		HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_landscape_itemlist", {["Housing_Furniture"] = 1});
	end
	
	local edit_itemSearch = GET_CHILD_RECURSIVELY(frame, "edit_itemSearch");
	edit_itemSearch:SetText("");

	local droplist_search_first = GET_CHILD_RECURSIVELY(frame, 'droplist_search_first');
	local droplist_search_second = GET_CHILD_RECURSIVELY(frame, 'droplist_search_second');

	droplist_search_first:ClearItems();
	droplist_search_second:ClearItems();

	droplist_search_first:AddItem(0, ClMsg("Auto_MoDu_BoKi"));
	droplist_search_first:AddItem(1, ClMsg("Housing_Search_Item_First_Theme"));
	droplist_search_first:AddItem(2, ClMsg("Housing_Search_Item_First_Purpose"));
	
	if IS_PERSONAL_HOUSING_PLACE() == true then
		droplist_search_first:AddItem(3, ClMsg("Housing_Search_Item_First_Group"));
	end
	
	droplist_search_second:AddItem(0, ClMsg("Auto_MoDu_BoKi"));
end

function SCP_HOUSING_SHOP_TAB_FACILITIES(frame, gbox)
	HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_facilities", {["Housing_Laboratory"] = 1});
end

function SCP_HOUSING_SHOP_TAB_CONTRACT(frame, gbox)
	HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_contract", {["Housing_Contract"] = 1});
end

function SCP_SELECT_DROPLIST_ITEM_FIRST(parent, dropList)
	local droplist_search_second = GET_CHILD_RECURSIVELY(parent, 'droplist_search_second');
	
	droplist_search_second:SetUserValue("SortType", "All");

	droplist_search_second:ClearItems();

	local selectedIndex = dropList:GetSelItemIndex();
	if selectedIndex == 1 then
		droplist_search_second:SetUserValue("SortType", "Theme");
		
		local sortType = "Guild";
		if IS_PERSONAL_HOUSING_PLACE() == true then
			sortType = "Personal";
		end

		local themes = {};
		local themeCount = 0;
		local housingFurnitureClassList, count = GetClassList("Housing_Furniture");
		for i = 0, count - 1 do
			local housingFurnitureClass = GetClassByIndexFromList(housingFurnitureClassList, i);
			if housingFurnitureClass ~= nil then
				local type = TryGetProp(housingFurnitureClass, "Type");
				if type == sortType then
					local itemClassName = TryGetProp(housingFurnitureClass, "ItemClassName");
					local itemClass = GetClass("Item", itemClassName);

					if IS_PERSONAL_HOUSING_PLACE() == true then
						if itemClass ~= nil then
							local itemShopProperty = geShopTable.GetByItemClassID("Personal_Housing", itemClass.ClassID);
							if itemShopProperty ~= nil and itemShopProperty:GetPropName() ~= "Hide" then
								local itemMarketCategory = TryGetProp(itemClass, "MarketCategory", "None");
								if itemMarketCategory == "PHousing_Furniture" or itemMarketCategory == "PHousing_Wall" or itemMarketCategory == "PHousing_Carpet" then
									local theme = TryGetProp(housingFurnitureClass, "Theme");
									if theme ~= "None" and themes[theme] == nil then
										themes[theme] = 0;
										themeCount = themeCount + 1;
									end
								end
							end
						end
					else
						if itemClass ~= nil and TryGetProp(itemClass, "MarketCategory", "None") == "Housing_Furniture" then
							local theme = TryGetProp(housingFurnitureClass, "Theme");
							if theme ~= "None" and themes[theme] == nil then
								themes[theme] = 0;
								themeCount = themeCount + 1;
							end
						end
					end
				end
			end
		end
		
		local sortedThemes = {};
		local index = 1;
		for key, value in pairs(themes) do
			sortedThemes[index] = key;
			index = index + 1;
		end

		table.sort(sortedThemes, function(a, b) return string.byte(a) < string.byte(b) end);

		for i = 1, #sortedThemes do
			droplist_search_second:AddItem(i, sortedThemes[i]);
		end

		themeCount = CLAMP(themeCount, 2, 8);
		droplist_search_second:SetVisibleLine(themeCount);
	elseif selectedIndex == 2 then
		droplist_search_second:SetUserValue("SortType", "Usage");
		
		local sortType = "Guild";
		if IS_PERSONAL_HOUSING_PLACE() == true then
			sortType = "Personal";
		end

		local usages = {};
		local usageCount = 0;
		local housingFurnitureClassList, count = GetClassList("Housing_Furniture");
		for i = 0, count - 1 do
			local housingFurnitureClass = GetClassByIndexFromList(housingFurnitureClassList, i);
			if housingFurnitureClass ~= nil then
				local type = TryGetProp(housingFurnitureClass, "Type");
				if type == sortType then
					local itemClassName = TryGetProp(housingFurnitureClass, "ItemClassName");
					local itemClass = GetClass("Item", itemClassName);
					
					if IS_PERSONAL_HOUSING_PLACE() == true then
						if itemClass ~= nil then
							local itemShopProperty = geShopTable.GetByItemClassID("Personal_Housing", itemClass.ClassID);
							if itemShopProperty ~= nil and itemShopProperty:GetPropName() ~= "Hide" then
								local itemMarketCategory = TryGetProp(itemClass, "MarketCategory", "None");
								if itemMarketCategory == "PHousing_Furniture" or itemMarketCategory == "PHousing_Wall" or itemMarketCategory == "PHousing_Carpet" then
									local usage = TryGetProp(housingFurnitureClass, "Usage");
									if usage ~= "None" and usages[usage] == nil then
										usages[usage] = 0;
										usageCount = usageCount + 1;
									end
								end
							end
						end
					else
						if itemClass ~= nil and TryGetProp(itemClass, "MarketCategory", "None") == "Housing_Furniture" then
							local usage = TryGetProp(housingFurnitureClass, "Usage");
							if usage ~= "None" and usages[usage] == nil then
								usages[usage] = 0;
								usageCount = usageCount + 1;
							end
						end
					end
				end
			end
		end
		
		local sortedUsages = {};
		local index = 1;
		for key, value in pairs(usages) do
			sortedUsages[index] = key;
			index = index + 1;
		end

		table.sort(sortedUsages, function(a, b) return string.byte(a) < string.byte(b) end);

		for i = 1, #sortedUsages do
			droplist_search_second:AddItem(i, sortedUsages[i]);
		end

		usageCount = CLAMP(usageCount, 4, 8);
		droplist_search_second:SetVisibleLine(usageCount);
	elseif selectedIndex == 3 then
		droplist_search_second:SetUserValue("SortType", "Group");
		
		local sortType = "Guild";
		if IS_PERSONAL_HOUSING_PLACE() == true then
			sortType = "Personal";
		end

		local groups = {};
		local groupCount = 0;
		local housingFurnitureClassList, count = GetClassList("Housing_Furniture");
		for i = 0, count - 1 do
			local housingFurnitureClass = GetClassByIndexFromList(housingFurnitureClassList, i);
			if housingFurnitureClass ~= nil then
				local type = TryGetProp(housingFurnitureClass, "Type");
				if type == sortType then
					local itemClassName = TryGetProp(housingFurnitureClass, "ItemClassName");
					local itemClass = GetClass("Item", itemClassName);
					
					if IS_PERSONAL_HOUSING_PLACE() == true then
						if itemClass ~= nil then
							local itemShopProperty = geShopTable.GetByItemClassID("Personal_Housing", itemClass.ClassID);
							if itemShopProperty ~= nil and itemShopProperty:GetPropName() ~= "Hide" then
								local itemMarketCategory = TryGetProp(itemClass, "MarketCategory", "None");
								if itemMarketCategory == "PHousing_Furniture" or itemMarketCategory == "PHousing_Wall" or itemMarketCategory == "PHousing_Carpet" then
									local group = TryGetProp(housingFurnitureClass, "Group");
									if group ~= "None" and groups[group] == nil then
										groups[group] = 0;
										groupCount = groupCount + 1;
									end
								end
							end
						end
					else
						if itemClass ~= nil and TryGetProp(itemClass, "MarketCategory", "None") == "Housing_Furniture" then
							local group = TryGetProp(housingFurnitureClass, "Group");
							if group ~= "None" and groups[group] == nil then
								groups[group] = 0;
								groupCount = groupCount + 1;
							end
						end
					end
				end
			end
		end
		
		local sortedGroups = {};
		local index = 1;
		for key, value in pairs(groups) do
			sortedGroups[index] = key;
			index = index + 1;
		end

		table.sort(sortedGroups, function(a, b) return string.byte(a) < string.byte(b) end);

		for i = 1, #sortedGroups do
			local groupClass = GetClass("Housing_Furniture_Group", sortedGroups[i]);
			droplist_search_second:AddItem(i, TryGetProp(groupClass, "Name", "None"));
		end

		groupCount = CLAMP(groupCount, 4, 8);
		droplist_search_second:SetVisibleLine(groupCount);
	else
		droplist_search_second:AddItem(0, ClMsg("Auto_MoDu_BoKi"));
		droplist_search_second:SetVisibleLine(1);
	end
	
	local frame = parent:GetTopParentFrame();
	SCP_HOUSING_SHOP_SORT_BY_SELECT_DROPlIST(frame);
end

function SCP_SELECT_DROPLIST_ITEM_SECOND(parent, dropList)
	local frame = parent:GetTopParentFrame();
	SCP_HOUSING_SHOP_SORT_BY_SELECT_DROPlIST(frame);
end

function HOUSING_SHOP_SEARCH_TYPING(parent, edit)
	local frame = parent:GetTopParentFrame();
	SCP_HOUSING_SHOP_SORT_BY_SELECT_DROPlIST(frame);
end

function SCP_HOUSING_SHOP_SORT_BY_SELECT_DROPlIST(frame)
	local gbox_sell_list_landscape_itemlist = GET_CHILD_RECURSIVELY(frame, "gbox_sell_list_landscape_itemlist");
	local droplist_search_first = GET_CHILD_RECURSIVELY(frame, "droplist_search_first");
	local firstSelectedIndex = droplist_search_first:GetSelItemIndex();

	local droplist_search_second = GET_CHILD_RECURSIVELY(frame, "droplist_search_second");
	local secondSelectedIndex = droplist_search_second:GetSelItemIndex();
	
	local edit_itemSearch = GET_CHILD_RECURSIVELY(frame, "edit_itemSearch");
	local searchText = string.lower(edit_itemSearch:GetText());

	local yPos = 0;
	local childCount = gbox_sell_list_landscape_itemlist:GetChildCount();
	for i = 0, childCount do
		local child = gbox_sell_list_landscape_itemlist:GetChildByIndex(i);
		if child ~= nil and string.match(child:GetName(), "SHOPITEM_") then
			local findCaption = nil;
			local selectedCaption = nil;
			if firstSelectedIndex == 1 then
				-- 테마별
				findCaption = child:GetUserValue("FurnitureTheme");
				selectedCaption = droplist_search_second:GetSelItemCaption();
			elseif firstSelectedIndex == 2 then
				-- 용도별
				findCaption = child:GetUserValue("FurnitureUsage");
				selectedCaption = droplist_search_second:GetSelItemCaption();
			elseif firstSelectedIndex == 3 then
				-- 그룹별
				findCaption = child:GetUserValue("FurnitureGroup");
				selectedCaption = droplist_search_second:GetSelItemCaption();
				
				local groupClass = GetClass("Housing_Furniture_Group", findCaption);
				findCaption = TryGetProp(groupClass, "Name", "None");
			end
			
			local furnitureName = child:GetUserValue("FurnitureName");
			furnitureName = string.lower(dictionary.ReplaceDicIDInCompStr(furnitureName));
			if ((findCaption == nil or selectedCaption == nil) or (findCaption == selectedCaption)) and (searchText == "" or string.match(furnitureName, searchText)) then
				local margin = child:GetMargin();
				
				child:ShowWindow(1);
				child:SetOffset(margin.left, yPos);
				yPos = yPos + child:GetHeight() - 5;
			else
				local margin = child:GetMargin();
				child:SetOffset(margin.left, 0);
				child:ShowWindow(0);
			end
		end
	end
end

function BTN_HOUSING_SHOP_PREVIEW_FURNITURE(gbox, btn, argStr, argNum)
	local frame = gbox:GetTopParentFrame();

	local preview_furniture_slot = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	local slotSet = tolua.cast(preview_furniture_slot, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local emptySlotCount = 0;

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local count = tonumber(slot:GetUserValue("BuyCount"));
		if count == nil or count == 0 then
			emptySlotCount = emptySlotCount + 1;
		end
	end

	if emptySlotCount == 0 then
		ui.SysMsg(ClMsg("Personal_Housing_Not_Exists_Empty_Preview_Slot"));
		return;
	end

	local furnitureClassID = tonumber(btn:GetUserValue("FurnitureClassID"));
	local furnitureClass = GetClassByType("Housing_Furniture", furnitureClassID);
	if furnitureClass == nil then
		return;
	end

	local furnitureType = TryGetProp(furnitureClass, "Type");
	if furnitureType ~= "Personal" then
		return;
	end
	
	local itemClassID = btn:GetUserValue("ItemClassID");
	frame:SetUserValue("previewItemClassID", itemClassID);

	local handle = housing.CreatePreviewFurniture(furnitureClassID);
	if handle ~= 0 then
	end
end

function HOUSING_SHOP_ADD_PREVIEW_FURNITURE(handle, furnitureClassID)
	local furnitureClass = GetClassByType("Housing_Furniture", furnitureClassID);
	if furnitureClass == nil then
		return;
	end

	local itemClass = GetClass("Item", TryGetProp(furnitureClass, "ItemClassName"));
	if itemClass == nil then
		return;
	end
	
	local frame = ui.GetFrame("housing_shop");
	local previewItemClassID = tonumber(frame:GetUserValue("previewItemClassID"));
	
	local shopItem = geShopTable.GetByItemClassID("Personal_Housing", previewItemClassID);
	if shopItem == nil then
		return;
	end
	
	local buyCount = 1;
	
	local preview_furniture_slot = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	local slotSet = tolua.cast(preview_furniture_slot, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	local isExistsSameItem = false;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local slotShopItem = tonumber(slot:GetUserValue("ItemClassID"));
		if slotShopItem == previewItemClassID then
			isExistsSameItem = true;

			local itemCount = slot:GetUserValue("BuyCount");
			if itemCount == nil or itemCount == "None" then
				itemCount = 0;
			else
				itemCount = tonumber(itemCount);
			end

			if GET_SHOP_ITEM_MAXSTACK(shopItem) >= buyCount + itemCount then
				itemCount = itemCount + buyCount;

				slot:SetUserValue("BuyCount", tostring(itemCount));
				slot:SetUserValue("FurnitureHandle_" .. itemCount, tostring(handle));

				local slotIcon	= slotSet:GetIconByIndex(i);
				slot:SetText('{s18}{ol}{b}' .. itemCount, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
				slot:Invalidate();

				HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
				return;
			end
		end
	end
	
	if isExistsSameItem == true then
		return;
	end

	for i = 0, slotCount - 1 do
		local slotIcon	= slotSet:GetIconByIndex(i);
		if slotIcon == nil then
			local slot = slotSet:GetSlotByIndex(i);
			slot:SetUserValue("FurnitureClassID", tostring(furnitureClassID));
			slot:SetUserValue("ItemClassID", tostring(previewItemClassID));

			local icon = CreateIcon(slot);
			icon:Set(shopItem:GetIcon(), 'BUYITEMITEM', previewItemClassID, 0);

			SET_SHOP_ITEM_TOOLTIP(icon, shopItem);

			slot:SetEventScript(ui.RBUTTONDOWN, "HOUSING_SHOP_REMOVE_PREVIEW_FURNITURE_RIGHTDOWN");
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, i);
			
			slot:SetUserValue("FurnitureHandle_" .. 1, tostring(handle));
			slot:SetUserValue("BuyCount", tostring(buyCount));

			slot:SetText('{s18}{ol}{b}' .. buyCount, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
			HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
			return;
		end
	end
end

function HOUSING_SHOP_REMOVE_PREVIEW_FURNITURE(handle, furnitureClassID)
	local furnitureClass = GetClassByType("Housing_Furniture", furnitureClassID);
	if furnitureClass == nil then
		return;
	end

	local itemClass = GetClass("Item", TryGetProp(furnitureClass, "ItemClassName"));
	if itemClass == nil then
		return;
	end

	local itemClassID = itemClass.ClassID;

	local frame = ui.GetFrame("housing_shop");
	
	local preview_furniture_slot = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	local slotSet = tolua.cast(preview_furniture_slot, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local slotShopItem = tonumber(slot:GetUserValue("ItemClassID"));
		if slotShopItem == itemClassID then
			local count = tonumber(slot:GetUserValue("BuyCount"));
			if count > 2 then
				slot:SetUserValue("BuyCount", count - 1);
				slot:SetText('{s18}{ol}{b}' .. count - 1, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
				slot:Invalidate();
			else
				slot:SetUserValue("BuyCount", "0");
				slot:SetUserValue("ItemClassID", "0");
				slot:SetUserValue("FurnitureClassID", "0");
				slot:ClearText();
				slot:ClearIcon();
			end
		end
	end
	
	HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
end

function HOUSING_SHOP_REMOVE_PREVIEW_FURNITURE_RIGHTDOWN(gbox, btn, argStr, argNum)
	local frame = gbox:GetTopParentFrame();

	local preview_furniture_slot = GET_CHILD_RECURSIVELY(frame, 'preview_furniture_slot');
	local slotSet = tolua.cast(preview_furniture_slot, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();

	local slot	= slotSet:GetSlotByIndex(argNum);
	if slot:GetIcon() ~= nil then
		local count = tonumber(slot:GetUserValue("BuyCount"));
		for i = 1, count do
			local furnitureHandle = tonumber(slot:GetUserValue("FurnitureHandle_" .. tostring(i)));
			housing.RemovePreviewFurniture(furnitureHandle);
		end

		slot:SetUserValue("BuyCount", "0");
		slot:SetUserValue("ItemClassID", "0");
		slot:SetUserValue("FurnitureClassID", "0");
		slot:ClearText();
		slot:ClearIcon();

		HOUSING_SHOP_UPDATE_ITEM_PRICE(frame);
	end
	imcSound.PlaySoundEvent("inven_unequip");
end