function PROPERTYSHOP_ON_INIT(addon, frame)

	addon:RegisterMsg('PROPERTY_SHOP_UI_OPEN', 'PROPERTY_SHOP_DO_OPEN');
	addon:RegisterMsg('UPDATE_PROPERTY_SHOP', 'ON_UPDATE_PROPERTY_SHOP');
	addon:RegisterOpenOnlyMsg('PVP_PROPERTY_UPDATE', 'ON_UPDATE_PROPERTY_SHOP');
	addon:RegisterMsg("PVP_PC_INFO", "ON_PVP_POINT_UPDATE");
end

function PROPERTY_SHOP_DO_OPEN(frame, msg, shopName, argNum)
	OPEN_PROPERTY_SHOP(shopName);
	local invframe = ui.GetFrame('inventory');
	if invframe:IsVisible() == 0 then
		ui.ToggleFrame('inventory')
	end
end

function ON_UPDATE_PROPERTY_SHOP(frame, msg, shopName, isSuccess)

	if isSuccess == 1 then
		imcSound.PlaySoundEvent("quest_ui_alarm_2");
	end

	if frame:IsVisible() == 1 then
		if shopName == "None" then 
			shopName = frame:GetUserValue("SHOPNAME");
		end

		OPEN_PROPERTY_SHOP(shopName);
	end
end

function PROPERTYSHOP_OPEN(frame)
	REGISTERR_LASTUIOPEN_POS(frame);
end

function PROPERTYSHOP_CLOSE(frame)
	UNREGISTERR_LASTUIOPEN_POS(frame);
	ui.CloseFrame('inventory');
end

function TOGGLE_PROPERTY_SHOP(shopName)
	local frame = ui.GetFrame("propertyshop");
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);
		return;
	end

	if shopName == 'PvpMineBattleShop' then
		OPEN_PVP_PROPERTY_SHOP(shopName)
	else
		OPEN_PROPERTY_SHOP(shopName);
	end
end

function OPEN_PROPERTY_SHOP(shopName)
	local ret = worldPVP.RequestPVPInfo();
	local frame = ui.GetFrame("propertyshop");
	frame:ShowWindow(1);

	local bg = frame:GetChild("bg");
	local t_totalprice = GET_CHILD(bg, "t_totalprice");
	local t_mymoney = GET_CHILD(bg, "t_mymoney");
	t_totalprice:SetTextByKey("text", ScpArgMsg("TotalBuyPoint"));
	t_mymoney:SetTextByKey("text", ScpArgMsg("TotalHavePoint"));

	local title = frame:GetChild("title");
	title:SetTextByKey("value", ClMsg(shopName));


	frame:SetUserValue("SHOPNAME", shopName);
	local shopInfo = gePropertyShop.Get(shopName);

	local itemlist = GET_CHILD(bg, "itemlist");

	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st42b}" .. ClMsg("Item"), 250);
	itemlist:AddBarInfo("Price", "{@st42b}" .. ClMsg("Price"), 120);
	itemlist:AddBarInfo("BuyCount", "{@st42b}" .. ClMsg("BuyCount"), 120);
	itemlist:RemoveAllChild();

	local itemBoxFont = frame:GetUserConfig("ItemBoxFont");
	local cnt = shopInfo:GetItemCount();
	for i = 0 , cnt - 1 do
		local itemInfo = shopInfo:GetItemByIndex(i);
		local itemName, itemCount, addText;
		local scriptName = itemInfo:GetScriptName();
		if scriptName == "None" then
			itemName = itemInfo:GetItemName();
			itemCount = itemInfo.count;
		else
			local func = _G[scriptName .."_GET_ITEM_C"];
			itemName, itemCount, addText = func();
		end

		local itemCls = GetClass("Item", itemName);
		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "propertyshop_item");
		ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
		ctrlSet:EnableHitTestSet(0);
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(itemCls.Icon);
		SET_ITEM_TOOLTIP_BY_TYPE(pic, itemCls.ClassID);
		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", itemCount);
		local name = ctrlSet:GetChild("name");
		local nameText = itemCls.Name;
		nameText = nameText .. " " .. itemCount .. " " .. ScpArgMsg("Piece");

		if addText == nil then
			addText = "";
		end

		if itemInfo.dailyBuyLimit > 0 then
			if addText ~= "" then
				addText = addText .. ", ";
			end

			addText = addText .. ScpArgMsg("BuyableCountPerDay_{Count}", "Count", itemInfo.dailyBuyLimit);
		end

		if addText ~= "" then
			nameText = nameText .. " (" .. addText ..")";
		end

		name:SetTextByKey("value", nameText);
		name:SetTextTooltip("{s18}" .. nameText);

		local priceTxt = GetCommaedText(itemInfo.price);
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 1, itemBoxFont .. priceTxt, nil, nil, priceTxt);

		local numUpDown = INSERT_NUMUPDOWN_DETAIL_LIST(itemlist, i, 2, itemBoxFont .. "0");
		if itemInfo.dailyBuyLimit > 0 then
			numUpDown:SetMaxValue(itemInfo.dailyBuyLimit);
		end

		numUpDown:SetNumChangeScp("PROPERTYSHOP_CHANGE_COUNT");

	end

	itemlist:RealignItems();
	PROPERTYSHOP_CHANGE_COUNT(frame);
	local t_mymoney = bg:GetChild("t_mymoney");
	t_mymoney:SetTextByKey("value", GET_PROPERTY_SHOP_MY_POINT(frame));

end

function PVP_PROPERTY_SHOP_INIT(frame)
	local dropList = frame:CreateControl('droplist', 'propertyshop_droplist', 0, 0, 200, 25);
	AUTO_CAST(dropList)
	dropList:SetMargin(30,70,0,0)
	dropList:SetSelectedScp('PVP_PROPERTY_SHOP_CATEGORY_SELECT')
	dropList:SetVisibleLine(4)
	dropList:SetSkinName('droplist_normal')
	dropList:SetTextAlign('left','center')
	dropList:SetTextOffset(10,0)

	dropList:AddItem(0, ClMsg('PartyShowAll'));
	dropList:SetUserValue('GROUP_INDEX__0', 'None');
	local category = {'Weapon','Armor','Accessory'}
	for i = 1,#category do
		dropList:AddItem(i, ClMsg('Wiki_'..category[i]));
		dropList:SetUserValue('GROUP_INDEX_'..i, category[i]);
	end
end

function OPEN_PVP_PROPERTY_SHOP(shopName)
	local ret = worldPVP.RequestPVPInfo();
	local frame = ui.GetFrame("propertyshop");
	frame:ShowWindow(1);
	PVP_PROPERTY_SHOP_INIT(frame)

	local bg = frame:GetChild("bg");
	local t_totalprice = GET_CHILD(bg, "t_totalprice");
	local t_mymoney = GET_CHILD(bg, "t_mymoney");
	t_totalprice:SetTextByKey("text", ScpArgMsg("TotalBuyPoint"));
	t_mymoney:SetTextByKey("text", ScpArgMsg("TotalHavePoint"));

	local title = frame:GetChild("title");
	title:SetTextByKey("value", ClMsg(shopName));


	frame:SetUserValue("SHOPNAME", shopName);
	local shopInfo = gePropertyShop.Get(shopName);
	local itemlist = GET_CHILD(bg, "itemlist");
	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st42b}" .. ClMsg("Item"), 250);
	itemlist:AddBarInfo("Price", "{@st42b}" .. ClMsg("Price"), 120);
	itemlist:AddBarInfo("BuyCount", "{@st42b}" .. ClMsg("BuyCount"), 120);
	itemlist:RemoveAllChild();

	local itemBoxFont = frame:GetUserConfig("ItemBoxFont");
	local cnt = shopInfo:GetItemCount();

	local dropList = GET_CHILD_RECURSIVELY(frame,'propertyshop_droplist')
	local groupName = dropList:GetUserValue('GROUP_INDEX_'..dropList:GetSelItemIndex())
	if groupName == nil then
		groupName = 'None'
	end
	local idx = 0
	for i = 0 , cnt - 1 do
		
		local itemInfo = shopInfo:GetItemByIndex(i);
		local itemName, itemCount;
		local scriptName = itemInfo:GetScriptName();
		if scriptName == "None" then
			itemName = itemInfo:GetItemName();
			itemCount = itemInfo.count;
		else
			local func = _G[scriptName .."_GET_ITEM_C"];
			itemName, itemCount, addText = func();
		end

		local itemCls = GetClass("Item", itemName);
		local start,_ = string.find(itemCls.MarketCategory,groupName)
		if start == 1 or groupName == 'None' then
			local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, idx, 0, "propertyshop_item");
			ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
			ctrlSet:EnableHitTestSet(0);
			ctrlSet:SetUserValue('REAL_INDEX',i)
			local pic = GET_CHILD(ctrlSet, "pic");
			pic:SetImage(itemCls.Icon);
			SET_ITEM_TOOLTIP_BY_TYPE(pic, itemCls.ClassID);
			local count = ctrlSet:GetChild("count");
			count:SetTextByKey("value", itemCount);
			local name = ctrlSet:GetChild("name");
			local nameText = itemCls.Name;
			nameText = nameText .. " " .. itemCount .. " " .. ScpArgMsg("Piece");

			name:SetTextByKey("value", nameText);
			name:SetTextTooltip("{s18}" .. nameText);

			local priceTxt = GetCommaedText(itemInfo.price);
			INSERT_TEXT_DETAIL_LIST(itemlist, idx, 1, itemBoxFont .. priceTxt, nil, nil, priceTxt);

			local numUpDown = INSERT_NUMUPDOWN_DETAIL_LIST(itemlist, idx, 2, itemBoxFont .. "0");
			if itemInfo.dailyBuyLimit > 0 then
				numUpDown:SetMaxValue(itemInfo.dailyBuyLimit);
			end

			numUpDown:SetNumChangeScp("PROPERTYSHOP_CHANGE_COUNT");
			idx = idx + 1
		end

	end

	itemlist:RealignItems();
	PROPERTYSHOP_CHANGE_COUNT(frame);
	local t_mymoney = bg:GetChild("t_mymoney");
	t_mymoney:SetTextByKey("value", GET_PROPERTY_SHOP_MY_POINT(frame));
	
end

function PROPERTY_SHOP_BUY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);
	local myMoney = GET_PROPERTY_SHOP_MY_POINT(frame);

	propertyShop.ClearPropertyShopInfo();

	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD(bg, "itemlist");
	local totalPrice = 0;
	local count = itemlist:GetRowCount();
	local idx = 0
	for i = 0 , count do
		local ctrlSet = GET_CHILD(itemlist,'DETAIL_ITEM_'..i..'_'..0)
		local numUpDown = itemlist:GetObjectByRowCol(i, 2);
		AUTO_CAST(numUpDown);
		local num = numUpDown:GetNumber();
		if num > 0 then
			local itemInfo = shopInfo:GetItemByIndex(i);
			totalPrice = totalPrice + itemInfo.price * num;
			
			local idx = ctrlSet:GetUserValue("REAL_INDEX")
			propertyShop.AddPropertyShopItem(idx, num);
		end
	end

	if totalPrice > myMoney then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	propertyShop.ReqBuyPropertyShopItem(shopName);
end

function REFRESH_PROPERTY_SHOP_BUY_BTN_SET_ENABLE()

	local frame = ui.GetFrame("propertyshop")
	local btn = GET_CHILD_RECURSIVELY(frame,"buy")

	btn:SetEnable(1)
end

function PROPERTYSHOP_CHANGE_COUNT(parent)

	local frame = parent:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD(bg, "itemlist");

	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);

	local totalPrice = 0;
	local count = itemlist:GetRowCount();
	for i = 0 , count do
		local numUpDown = itemlist:GetObjectByRowCol(i, 2);
		AUTO_CAST(numUpDown);
		local num = numUpDown:GetNumber();
		if num > 0 then
			local itemInfo = shopInfo:GetItemByIndex(i);
			totalPrice = totalPrice + itemInfo.price * num;
		end

	end

	local t_totalprice = bg:GetChild("t_totalprice");
	t_totalprice:SetTextByKey("value", totalPrice);



end

function GET_PROPERTY_SHOP_MY_POINT(frame)

	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);
    if shopInfo == nil then
        return 0;
    end

	local clientScp = _G[shopInfo:GetPointScript() .. "_C"];
	return clientScp();
end

function ON_PVP_POINT_UPDATE(frame, msg, argStr, argNum)	
	if frame == nil then
		frame = ui.GetFrame(argStr)
	end

	local t_mymoney = GET_CHILD_RECURSIVELY(frame, "t_mymoney");
	t_mymoney:SetTextByKey("value", GET_PROPERTY_SHOP_MY_POINT(frame));
end

function PVP_PROPERTY_SHOP_CATEGORY_SELECT(parent,ctrl)
	local frame = parent:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");

	propertyShop.ClearPropertyShopInfo();

	local groupName = ctrl:GetUserValue('GROUP_INDEX_'..ctrl:GetSelItemIndex())
	OPEN_PVP_PROPERTY_SHOP(shopName)
	
end