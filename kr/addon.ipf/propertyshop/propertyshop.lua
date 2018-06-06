function PROPERTYSHOP_ON_INIT(addon, frame)

	addon:RegisterMsg('PROPERTY_SHOP_UI_OPEN', 'PROPERTY_SHOP_DO_OPEN');
	addon:RegisterMsg('UPDATE_PROPERTY_SHOP', 'ON_UPDATE_PROPERTY_SHOP');
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

function OPEN_PROPERTY_SHOP(shopName)

	local frame = ui.GetFrame("propertyshop");
	frame:ShowWindow(1);

	local title = frame:GetChild("title");
	title:SetTextByKey("value", ClMsg(shopName));


	frame:SetUserValue("SHOPNAME", shopName);
	local shopInfo = gePropertyShop.Get(shopName);

	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD(bg, "itemlist");

	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st42b}" .. ClMsg("Item"), 250);
	itemlist:AddBarInfo("Price", "{@st42b}" .. ClMsg("Price"), 120);	
	itemlist:AddBarInfo("BuyCount", "{@st42b}" .. ClMsg("BuyCount"), 120);
	itemlist:LoadUserSize();

	itemlist:RemoveAllChild();

	local itemBoxFont = frame:GetUserConfig("ItemBoxFont");

	local cnt = shopInfo:GetItemCount();
	for i = 0 , cnt - 1 do
		local itemInfo = shopInfo:GetItemByIndex(i);
		local itemCls = GetClass("Item", itemInfo:GetItemName());
		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "propertyshop_item");
		ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
		ctrlSet:EnableHitTestSet(1);
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(itemCls.Icon);
		SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);
		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", itemInfo.count);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", itemCls.Name);

		INSERT_TEXT_DETAIL_LIST(itemlist, i, 1, itemBoxFont .. itemInfo.price);

		local numUpDown = INSERT_NUMUPDOWN_DETAIL_LIST(itemlist, i, 2, itemBoxFont .. "0");
		numUpDown:SetNumChangeScp("PROPERTYSHOP_CHANGE_COUNT");

	end	

	itemlist:RealignItems();
	PROPERTYSHOP_CHANGE_COUNT(frame);

	local pointScp = shopInfo:GetPointScript();
	local func = _G[pointScp .. "_C"];
	local myMoney = func();
	local t_mymoney = bg:GetChild("t_mymoney");
	t_mymoney:SetTextByKey("value", myMoney);

end

function PROPERTY_SHOP_BUY(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);
	local pointScp = shopInfo:GetPointScript();
	local func = _G[pointScp .. "_C"];
	local myMoney = func();
	
	propertyShop.ClearPropertyShopInfo();

	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD(bg, "itemlist");
	local totalPrice = 0;
	local count = itemlist:GetRowCount();
	for i = 0 , count do
		local numUpDown = itemlist:GetObjectByRowCol(i, 2);
		AUTO_CAST(numUpDown);
		local num = numUpDown:GetNumber();
		if num > 0 then
			local itemInfo = shopInfo:GetItemByIndex(i);
			totalPrice = totalPrice + itemInfo.price * num;
			propertyShop.AddPropertyShopItem(i, num);
		end
	end

	if totalPrice > myMoney then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		-- return;
	end
	
	propertyShop.ReqBuyPropertyShopItem(shopName);

	-- 연타 방지용 시간 제한 걸기
	ReserveScript("REFRESH_PROPERTY_SHOP_BUY_BTN_SET_ENABLE()", 5);
	ctrl:SetEnable(0)

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

