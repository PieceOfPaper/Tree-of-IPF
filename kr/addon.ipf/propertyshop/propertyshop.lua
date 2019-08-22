function PROPERTYSHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('PROPERTY_SHOP_UI_OPEN', 'PROPERTY_SHOP_DO_OPEN');
	addon:RegisterMsg('UPDATE_PROPERTY_SHOP', 'ON_UPDATE_PROPERTY_SHOP');
	addon:RegisterOpenOnlyMsg('PVP_PROPERTY_UPDATE', 'ON_UPDATE_PROPERTY_SHOP');
	addon:RegisterMsg("PVP_PC_INFO", "ON_PVP_POINT_UPDATE");
	addon:RegisterMsg("SHOP_POINT_UPDATE", "ON_PVP_POINT_UPDATE");
	addon:RegisterMsg("UPDATE_GUILD_MILEAGE", "CALLBACK_MILEAGE_UPDATE_PROPERTY_SHOP");
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

function TOGGLE_PROPERTY_SHOP(shopName, isVisibleCheck)
	if isVisibleCheck == nil then
		isVisibleCheck = true;
	end

	local frame = ui.GetFrame("propertyshop");
	if isVisibleCheck == true and frame:IsVisible() == 1 then
		frame:ShowWindow(0);
		return;
	end

	if shopName == 'PvpMineBattleShop' then
		OPEN_PVP_PROPERTY_SHOP(shopName)
	else
		OPEN_PROPERTY_SHOP(shopName);
	end
end

function CALLBACK_MILEAGE_UPDATE_PROPERTY_SHOP()
	local frame = ui.GetFrame("propertyshop");
	local shopName = frame:GetUserValue("SHOPNAME");

	if shopName ~= "GUILD_MILEAGE_SHOP" then
		return;
	end

	TOGGLE_PROPERTY_SHOP('GUILD_MILEAGE_SHOP', false);
end

function OPEN_PROPERTY_SHOP(shopName)
	local ret = worldPVP.RequestPVPInfo();
	local frame = ui.GetFrame("propertyshop");
	local wasVisible = frame:IsVisible();
	frame:ShowWindow(1);

	local bg = frame:GetChild("bg");
	local t_totalprice = GET_CHILD_RECURSIVELY(bg, "t_totalprice");
	local t_mymoney = GET_CHILD_RECURSIVELY(bg, "t_mymoney");
	local t_remainprice = GET_CHILD_RECURSIVELY(bg, "t_remainprice");
	local tab = GET_CHILD_RECURSIVELY(frame, "itembox");
	
	local title = frame:GetChild("title");

	if shopName == "GUILD_CONTRIBUTION_SHOP" then
		t_mymoney:SetTextByKey("text", ScpArgMsg("Guild_Housing_Has_Contribution"));
		t_totalprice:SetTextByKey("text", ScpArgMsg("Guild_Housing_Use_Contribution"));
		t_remainprice:SetTextByKey("text", ScpArgMsg("Guild_Housing_Remain_Contribution"));

		t_remainprice:ShowWindow(1);
		tab:ShowWindow(1);
		tab:ChangeCaption(0, "{@st66b}" .. "            " .. ClMsg("Housing_Contribution") .. "            ");
		tab:ChangeCaption(1, "{@st66b}" .. "            " .. ClMsg("Mileage_Name") .. "            ");

		if wasVisible == 0 then
			tab:ChangeTab(0);
		end
		
		title:SetTextByKey("value", ClMsg("GUILD_CONTRIBUTION_SHOP"));
	elseif shopName == "GUILD_MILEAGE_SHOP" then
		t_mymoney:SetTextByKey("text", ScpArgMsg("Guild_Housing_Has_Mileage"));
		t_totalprice:SetTextByKey("text", ScpArgMsg("Guild_Housing_Use_Mileage"));
		t_remainprice:SetTextByKey("text", ScpArgMsg("Guild_Housing_Remain_Mileage"));

		t_remainprice:ShowWindow(1);
		tab:ShowWindow(1);
		tab:ChangeCaption(0, "{@st66b}" .. "            " .. ClMsg("Housing_Contribution") .. "            ");
		tab:ChangeCaption(1, "{@st66b}" .. "            " .. ClMsg("Mileage_Name") .. "            ");
		
		title:SetTextByKey("value", ClMsg("GUILD_CONTRIBUTION_SHOP"));
	else
		t_mymoney:SetTextByKey("text", ScpArgMsg("TotalHavePoint"));
		t_totalprice:SetTextByKey("text", ScpArgMsg("TotalBuyPoint"));

		t_remainprice:ShowWindow(0);
		tab:ShowWindow(0);

		title:SetTextByKey("value", ClMsg(shopName));
	end

	frame:SetUserValue("SHOPNAME", shopName);
	local shopInfo = gePropertyShop.Get(shopName);

	local itemlist = GET_CHILD_RECURSIVELY(bg, "itemlist");

	itemlist:ClearBarInfo();
	itemlist:SetBarSkin("lightbrownbox_op_100");
	itemlist:AddBarInfo("Name", "{@st42b}" .. ClMsg("Item"), 250, 3);
	itemlist:AddBarInfo("Price", "{@st42b}" .. ClMsg("Price"), 120, 3);
	itemlist:AddBarInfo("BuyCount", "{@st42b}" .. ClMsg("BuyCount"), 120);
	itemlist:RemoveAllChild();

	local itemBoxFont = frame:GetUserConfig("ItemBoxFont");
	if shopInfo ~= nil then
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
			ctrlSet:SetUserValue('REAL_INDEX',i)
			ctrlSet:EnableHitTestSet(0);
			local pic = GET_CHILD_RECURSIVELY(ctrlSet, "pic");
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
				nameText = nameText .. "{nl}( " .. addText ..")";
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
	end

	itemlist:RealignItems();
	
	PROPERTYSHOP_CHANGE_COUNT(frame);

	if shopName == "GUILD_CONTRIBUTION_SHOP" then
		t_mymoney:SetTextByKey("value", GET_COMMAED_STRING(GET_MY_CONTRIBUTION()));
	elseif shopName == "GUILD_MILEAGE_SHOP" then
		t_mymoney:SetTextByKey("value", GET_COMMAED_STRING(GET_MY_GUILD_MILEAGE()));
	else
		t_mymoney:SetTextByKey("value", GET_COMMAED_STRING(GET_PROPERTY_SHOP_MY_POINT(frame)));
	end
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
	
	local tab = GET_CHILD_RECURSIVELY(frame, "itembox");
	if tab ~= nil then
		tab:ShowWindow(0);
	end
end

function OPEN_PVP_PROPERTY_SHOP(shopName)
	local ret = worldPVP.RequestPVPInfo();
	local frame = ui.GetFrame("propertyshop");
	frame:ShowWindow(1);
	PVP_PROPERTY_SHOP_INIT(frame)

	local bg = frame:GetChild("bg");
	local t_totalprice = GET_CHILD_RECURSIVELY(bg, "t_totalprice");
	local t_mymoney = GET_CHILD_RECURSIVELY(bg, "t_mymoney");
	local t_remainprice = GET_CHILD_RECURSIVELY(bg, "t_remainprice");
	t_totalprice:SetTextByKey("text", ScpArgMsg("TotalBuyPoint"));
	t_mymoney:SetTextByKey("text", ScpArgMsg("TotalHavePoint"));
	t_remainprice:ShowWindow(0);

	local title = frame:GetChild("title");
	title:SetTextByKey("value", ClMsg(shopName));
	
	frame:SetUserValue("SHOPNAME", shopName);
	local shopInfo = gePropertyShop.Get(shopName);
	local itemlist = GET_CHILD_RECURSIVELY(bg, "itemlist");
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
			local pic = GET_CHILD_RECURSIVELY(ctrlSet, "pic");
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
	local t_mymoney = GET_CHILD_RECURSIVELY(bg, "t_mymoney");
	t_mymoney:SetTextByKey("value", GET_COMMAED_STRING(GET_PROPERTY_SHOP_MY_POINT(frame)));
	
end

function PROPERTY_SHOP_BUY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);
	
	local myMoney;

	if shopName == "GUILD_CONTRIBUTION_SHOP" then
		myMoney = GET_MY_CONTRIBUTION();
	elseif shopName == "GUILD_MILEAGE_SHOP" then
		myMoney = GET_MY_GUILD_MILEAGE();
	else
		myMoney = GET_PROPERTY_SHOP_MY_POINT(frame);
	end

	propertyShop.ClearPropertyShopInfo();

	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD_RECURSIVELY(bg, "itemlist");
	local totalPrice = 0;
	local count = itemlist:GetRowCount();
	local idx = 0
	for i = 0 , count do
		local ctrlSet = GET_CHILD_RECURSIVELY(itemlist,'DETAIL_ITEM_'..i..'_'..0)
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
		if shopName == "GUILD_CONTRIBUTION_SHOP" then
			ui.SysMsg(ClMsg("Housing_Not_Enough_Contribution"));
		elseif shopName == "GUILD_MILEAGE_SHOP" then
			ui.SysMsg(ClMsg("Housing_Not_Enough_Mileage"));
		else
			ui.SysMsg(ClMsg("NotEnoughMoney"));
		end
		return;
	end

    if shopName == "GUILD_MILEAGE_SHOP" then
        local isLeader = AM_I_LEADER(PARTY_GUILD);
	    if 0 == isLeader then
            ui.SysMsg(ClMsg("OnlyLeaderAbleToDoThis"));
            return;
        end
    end

	propertyShop.ReqBuyPropertyShopItem(shopName);
	frame:ShowWindow(0)
end

function REFRESH_PROPERTY_SHOP_BUY_BTN_SET_ENABLE()

	local frame = ui.GetFrame("propertyshop")
	local btn = GET_CHILD_RECURSIVELY(frame,"buy")

	btn:SetEnable(1)
end

function PROPERTYSHOP_CHANGE_COUNT(parent)
	local frame = parent:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local itemlist = GET_CHILD_RECURSIVELY(bg, "itemlist");

	local shopName = frame:GetUserValue("SHOPNAME");
	local shopInfo = gePropertyShop.Get(shopName);

	local totalPrice = 0;
	local count = itemlist:GetRowCount();
	for i = 0 , count do
		local numUpDown = itemlist:GetObjectByRowCol(i, 2);
		if numUpDown ~= nil then
			AUTO_CAST(numUpDown);
			local num = numUpDown:GetNumber();
			if num > 0 then
				local itemInfo = shopInfo:GetItemByIndex(i);
				totalPrice = totalPrice + itemInfo.price * num;
			end
		end
	end
	
	local t_totalprice = GET_CHILD_RECURSIVELY(bg, "t_totalprice");
	t_totalprice:SetTextByKey("value", GET_COMMAED_STRING(totalPrice));
	
	if shopName == "GUILD_CONTRIBUTION_SHOP" then
		local contribution = GET_MY_CONTRIBUTION();

		local t_remainprice = GET_CHILD_RECURSIVELY(bg, "t_remainprice");
		t_remainprice:SetTextByKey("value", GET_COMMAED_STRING(contribution - totalPrice));
	elseif shopName == "GUILD_MILEAGE_SHOP" then
		local mileage = GET_MY_GUILD_MILEAGE();

		local t_remainprice = GET_CHILD_RECURSIVELY(bg, "t_remainprice");
		t_remainprice:SetTextByKey("value", GET_COMMAED_STRING(mileage - totalPrice));
	end
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

	local shopName = frame:GetUserValue("SHOPNAME");
	if shopName == "GUILD_CONTRIBUTION_SHOP" or shopName == "GUILD_MILEAGE_SHOP" then
		return;
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

function SCP_PROPERTY_SHOP_TAB1(frame, gbox)
	local frame = frame:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");
	if shopName == "GUILD_CONTRIBUTION_SHOP" then
		return;
	end
	
	TOGGLE_PROPERTY_SHOP('GUILD_CONTRIBUTION_SHOP', false);
end

function SCP_PROPERTY_SHOP_TAB2(frame, gbox)
	local frame = frame:GetTopParentFrame();
	local shopName = frame:GetUserValue("SHOPNAME");
	
	frame:SetUserValue("SHOPNAME", "GUILD_MILEAGE_SHOP");
	control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
end