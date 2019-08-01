function HOUSING_SHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('GUILD_HOUSING_SHOP', 'ON_GUILD_HOUSING_SHOP');
	addon:RegisterMsg('START_GUILD_HOUSING_SHOP', 'ON_START_GUILD_HOUSING_SHOP');
	addon:RegisterMsg('START_HOUSING_SHOP_BUTTON_BUYSELL', 'ON_START_HOUSING_SHOP_BUTTON_BUYSELL');
end

function ON_GUILD_HOUSING_SHOP(frame)
	ui.OpenFrame("housing_shop");
end

function OPEN_HOUSING_SHOP(frame)
	housing.RequestGuildAgitInfo("START_GUILD_HOUSING_SHOP");
end

function ON_START_GUILD_HOUSING_SHOP(frame)
	ui.OpenFrame("inventory");

	local itembox_tab = GET_CHILD_RECURSIVELY(frame, "itembox");
	itembox_tab:SelectTab(0);
end

function CLOSE_HOUSING_SHOP(frame)
	control.DialogOk();
	ui.EnableSlotMultiSelect(0);

	SHOP_SELECT_ITEM_LIST = {};
	
	local invenFrame = ui.GetFrame('inventory');
	INVENTORY_UPDATE_ICONS(invenFrame);
	INVENTORY_CLEAR_SELECT(invenFrame);
	if invenFrame:IsVisible() == 1 then
		invenFrame:ShowWindow(0);
	end
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

		local imageName = shopItem:GetIcon();

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
	
	local guildAgit = housing.GetGuildAgitInfo();

	local buy_price = GET_CHILD_RECURSIVELY(frame, 'buy_price');
	buy_price:SetTextByKey("price1", 0);
	buy_price:SetTextByKey("price2", 0);
	buy_price:SetTextByKey("price3", 0);
	buy_price:SetTextByKey("price4", 0);
	
	local sell_price = GET_CHILD_RECURSIVELY(frame, 'sell_price');
	sell_price:SetTextByKey("price1", 0);
	sell_price:SetTextByKey("price2", 0);
	sell_price:SetTextByKey("price3", 0);
	sell_price:SetTextByKey("price4", 0);
	
	local pricetxt = GET_CHILD_RECURSIVELY(frame, 'pricetxt');
	pricetxt:SetTextByKey("price1", 0);
	pricetxt:SetTextByKey("price2", 0);
	pricetxt:SetTextByKey("price3", 0);
	pricetxt:SetTextByKey("price4", 0);
	
	local housingPoint_Originality = guildAgit.points[tos.housing.guild.eOriginality + 1];		-- 독창성
	local housingPoint_Functionality = guildAgit.points[tos.housing.guild.eFunctionality + 1];	-- 기능성
	local housingPoint_Artistry = guildAgit.points[tos.housing.guild.eArtistry + 1];			-- 예술성
	local housingPoint_Economy = guildAgit.points[tos.housing.guild.eEconomy + 1];				-- 경제성

	local finalprice = GET_CHILD_RECURSIVELY(frame, 'finalprice');
	finalprice:SetFormat("{img icon_guild_housing_coin_01 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_02 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_03 20 20} {@st66d_y}%s{/}  {img icon_guild_housing_coin_04 20 20} {@st66d_y}%s{/}");
	finalprice:SetTextByKey("price1", housingPoint_Originality);
	finalprice:SetTextByKey("price2", housingPoint_Functionality);
	finalprice:SetTextByKey("price3", housingPoint_Artistry);
	finalprice:SetTextByKey("price4", housingPoint_Economy);
end

function HOUSING_SHOP_UPDATE_ITEM_PRICE(frame)
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
		buy_price:SetTextByKey("price" .. i, buyPrice[i]);
		sell_price:SetTextByKey("price" .. i, sellPrice[i]);
		pricetxt:SetTextByKey("price" .. i, sellPrice[i] - buyPrice[i]);
		
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
		finalprice:SetTextByKey("price" .. i, result);
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
	housing.RequestGuildAgitInfo("START_HOUSING_SHOP_BUTTON_BUYSELL");
end

function ON_START_HOUSING_SHOP_BUTTON_BUYSELL()
	local guildAgit = housing.GetGuildAgitInfo();

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
end

function HOUSING_SHOP_INIT_TAB(frame, gboxName, marketCategory)
	local shopItemList = session.GetShopItemList();

	local gbox_sell_list = GET_CHILD_RECURSIVELY(frame, gboxName);
	gbox_sell_list:RemoveAllChild();

	local yPos = 0;
	for i = 0, shopItemList:Count() - 1 do
		local shopItem = shopItemList:PtrAt(i);
		
		local itemClass = GetClassByType(shopItem:GetIDSpace(), shopItem.type);
		if itemClass.MarketCategory == marketCategory then
			local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(shopItem.type);
			if furnitureClass ~= nil then
				local ShopItemCountObj = gbox_sell_list:CreateControlSet('shopitemset_Type', "SHOPITEM_" .. i, 0, yPos);
				yPos = yPos + ShopItemCountObj:GetHeight() - 5;

				local ShopItemCountCtrl = tolua.cast(ShopItemCountObj, "ui::CControlSet");
				local foodInfoBox = ShopItemCountCtrl:GetChild('foodInfoBox');
				foodInfoBox:ShowWindow(0);

				ShopItemCountCtrl:SetEnableSelect(1);
				ShopItemCountCtrl:SetSelectGroupName("ShopItemList");

				-- 상점 아이콘 설정 및 기타 설정들을 한다
				local ConSetBySlot = ShopItemCountCtrl:GetChild('slot');
				local slot = tolua.cast(ConSetBySlot, "ui::CSlot");
				local icon = CreateIcon(slot);
	
				local imageName = shopItem:GetIcon();

				icon:Set(imageName, 'SHOPITEM', i, 0);
				local printText	= '{@st66b}' .. GET_SHOPITEM_TXT(shopItem, itemClass);
		
				local priceText1 = string.format("{img icon_guild_housing_coin_01 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price1", 0));
				local priceText2 = string.format("  {img icon_guild_housing_coin_02 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price2", 0));
				local priceText3 = string.format("  {img icon_guild_housing_coin_03 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price3", 0));
				local priceText4 = string.format("  {img icon_guild_housing_coin_04 20 20} {@st66b}%s", TryGetProp(furnitureClass, "Price4", 0));
				local priceText	= priceText1 .. priceText2 .. priceText3 .. priceText4;

				ShopItemCountCtrl:SetEventScript(ui.RBUTTONDOWN, 'HOUSING_SHOP_SLOT_RBTNDOWN_2');
				ShopItemCountCtrl:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
				ShopItemCountCtrl:SetEventScriptArgNumber(ui.RBUTTONDOWN, shopItem.classID);
				ShopItemCountCtrl:SetTextByKey('ItemName_Count', printText);
				ShopItemCountCtrl:SetTextByKey('Item_Price', priceText);
				ShopItemCountCtrl:SetOverSound("button_over");

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

	HOUSING_SHOP_ITEM_SLOT_INIT(frame);
end

function SCP_HOUSING_SHOP_TAB_LANDSCAPE(frame, gbox)
	HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_landscape", "Housing_Furniture");
end

function SCP_HOUSING_SHOP_TAB_FACILITIES(frame, gbox)
	HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_facilities", "Housing_Laboratory");
end

function SCP_HOUSING_SHOP_TAB_CONTRACT(frame, gbox)
	HOUSING_SHOP_INIT_TAB(frame, "gbox_sell_list_contract", "Housing_Contract");
end