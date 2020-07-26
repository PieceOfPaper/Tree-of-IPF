function CUSTOM_COIN_SHOP_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_CUSTOM_COIN_SHOP", "CUSTOM_COIN_SHOP_OPEN");
end

function CUSTOM_COIN_SHOP_OPEN(frame,msg,argStr,argNum)
	local shopName = frame:SetUserValue("SHOPNAME",argStr);
	frame:ShowWindow(1)
end

function OPEN_CUSTOM_COIN_SHOP(frame)
	local edit = GET_CHILD_RECURSIVELY(frame,"edit_itemSearch")
	edit:SetText("")
	frame:SetUserValue("SEARCH_TEXT","")
	local droplist = GET_CHILD_RECURSIVELY(frame,"droplist_search")
	droplist:SelectItem(0)

	local gbox_sell_list_item = GET_CHILD_RECURSIVELY(frame,"gbox_sell_list_item")
	local grid_item_list = GET_CHILD_RECURSIVELY(gbox_sell_list_item,"grid_item_list")
	CUSTOM_COIN_SHOP_MAKE_DROPLIST(droplist,grid_item_list)
	CUSTOM_COIN_SHOP_MAKE_ITEMLIST(gbox_sell_list_item,grid_item_list)
	
	local buyMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"buy_price")
	local remainMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"finalprice")
	CUSTOM_COIN_SHOP_ADD_MONEY(buyMoneyCtrl, remainMoneyCtrl,0)
end

function CLOSE_CUSTOM_COIN_SHOP(frame)
	local slotset = GET_CHILD_RECURSIVELY(frame,"buyitemslot")
	CUSTOM_COIN_SHOP_CLEAR_BUYLIST(frame,slotset)
end

function CUSTOM_COIN_SHOP_GET_NAME(ctrl)
	local frame = ctrl:GetTopParentFrame()
	return frame:GetUserValue("SHOPNAME")
end

function CUSTOM_COIN_SHOP_MAKE_ITEMLIST(parent,ctrl)
	local frame = parent:GetTopParentFrame()
	local searchText = frame:GetUserValue("SEARCH_TEXT")
	local dropList = GET_CHILD_RECURSIVELY(frame,"droplist_search")
	local selectKey = dropList:GetSelItemKey()

	local shopName = CUSTOM_COIN_SHOP_GET_NAME(parent)
	local shopItemList = gePropertyShop.Get(shopName);
	local cnt = shopItemList:GetItemCount()
	ctrl:RemoveAllChild()
	for i = 0,cnt-1 do
		local shopItem = shopItemList:GetItemByIndex(i);
		local itemCls = GetClass("Item", shopItem:GetItemName());
		if CUSTOM_COIN_SHOP_IS_VALID_ITEM(itemCls,selectKey,searchText) == true then
			local ShopItemCountCtrl = ctrl:CreateControlSet("shopitemset_Type", "SHOPITEM_" .. i, 0, 0);
			tolua.cast(ShopItemCountCtrl, "ui::CControlSet");
		
			ShopItemCountCtrl:SetOverSound("button_over");
			local printText	= '{@st66b}' .. GET_SHOPITEM_TXT(shopItem, itemCls);
			local priceText	= string.format(" {img icon_item_pvpmine_2 20 20} {@st66b}%s", shopItem.price);
			ShopItemCountCtrl:SetTextByKey('ItemName_Count', printText);
			ShopItemCountCtrl:SetTextByKey('Item_Price', priceText);
			ShopItemCountCtrl:Resize(ShopItemCountCtrl:GetWidth()-20,ShopItemCountCtrl:GetHeight())
		
			-- 상점 아이콘 설정 및 기타 설정들을 한다
			local slot = GET_CHILD(ShopItemCountCtrl,'slot');
			local icon = CreateIcon(slot);
			icon:Set(itemCls.Icon, 'SHOPITEM', shopItem.index, 0);
			SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID);
			icon:SetTooltipArg('sell', itemCls.ClassID, "");

			ShopItemCountCtrl:SetEventScript(ui.RBUTTONDOWN, 'CUSTOM_COIN_SHOP_SHOP_ONCLICK');
		end
	end
	local height = 50 * ctrl:GetChildCount()
	ctrl:Resize(ctrl:GetWidth(),height)

	parent:UpdateData();
end

function CUSTOM_COIN_SHOP_IS_VALID_ITEM(itemCls,key,searchText)
	if CHECK_EQUIPABLE(itemCls.ClassID) ~= "OK" then
		return false
	end
	if key ~= "All" and key ~= TryGetProp(itemCls,"ClassType") then
		return false
	end
	if searchText ~= nil and string.find(itemCls.Name,searchText) == nil then
		return false
	end
	return true
	
end

function CUSTOM_COIN_SHOP_MAKE_DROPLIST(droplist,groupBox)
	local msgDict = {}
	local shopName = CUSTOM_COIN_SHOP_GET_NAME(groupBox)
	local shopItemList = gePropertyShop.Get(shopName);
	local cnt = shopItemList:GetItemCount()
	droplist:ClearItems()
	for i = 0,cnt-1 do
		local shopItem = shopItemList:GetItemByIndex(i);
		local itemCls = GetClass("Item", shopItem:GetItemName());
		local classType = TryGetProp(itemCls,"ClassType","None")
		if classType ~= "None" and CHECK_EQUIPABLE(itemCls.ClassID) == "OK" then
			msgDict[classType] = true
		end
	end
	droplist:AddItem("All",ClMsg("Auto_MoDuBoKi"))
	local msgList = {}
	for type,_ in pairs(msgDict) do
		table.insert(msgList,type)
	end
	table.sort(msgList,function(a,b)return a<b;end)
	for i = 1,#msgList do
		droplist:AddItem(msgList[i],ClMsg(msgList[i]))
	end
end

function CUSTOM_COIN_SHOP_SHOP_ONCLICK(parent, ctrl, argStr, argNum)
	local shopName = CUSTOM_COIN_SHOP_GET_NAME(parent)
	local frame = parent:GetTopParentFrame();
	local slot = GET_CHILD(ctrl,"slot")
	local icon = CreateIcon(slot)
	local index = icon:GetInfo().type
	local shop = gePropertyShop.Get(shopName)
	local shopItem = shop:GetItemByIndex(index);

	local slotset = GET_CHILD_RECURSIVELY(frame,"buyitemslot")
	local buyMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"buy_price")
	local remainMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"finalprice")
	CUSTOM_COIN_SHOP_ADD_BUYLIST(slotset,shopItem,buyMoneyCtrl,remainMoneyCtrl)
end

function CUSTOM_COIN_SHOP_ADD_BUYLIST(slotset, shopItem, buyMoneyCtrl, remainMoneyCtrl)
	local slot = CUSTOM_COIN_SHOP_GET_SLOT(slotset,shopItem)
	if slot == nil then
		return
	end
	local icon = CreateIcon(slot)
	local iconInfo = icon:GetInfo()
	if iconInfo.type == 0 then
		local itemCls = GetClass("Item",shopItem:GetItemName())
		icon:Set(itemCls.Icon, 'BUYITEMITEM', shopItem.index, 0,"",1);
		icon:SetTooltipArg('sell', itemCls.ClassID, "");
		SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID);
	else
		icon:SetCount(icon:GetCount() + 1)
	end
	slot:SetText('{s18}{ol}{b}'..icon:GetCount() * shopItem.count, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
	slot:Invalidate();
	CUSTOM_COIN_SHOP_ADD_MONEY(buyMoneyCtrl, remainMoneyCtrl,shopItem.price)
end

function CUSTOM_COIN_SHOP_GET_SLOT(slotset,shopItem)
	local item = GetClass("Item",shopItem:GetItemName())
	local pc = GetMyPCObject()
	local now_cnt = GetInvItemCount(pc,item.ClassName)
	local cnt = slotset:GetSlotCount()
	for i = 0,cnt-1 do
		local icon = slotset:GetIconByIndex(i)
		if icon == nil then
			return slotset:GetSlotByIndex(i)
		elseif icon:GetInfo().type == shopItem.index and item.MaxStack > 1 then
			if now_cnt + shopItem.count > item.MaxStack then
				return nil 
			else
				return slotset:GetSlotByIndex(i)
			end
		end
	end
	return nil
end

function SCR_CUSTOM_COIN_SHOP_REMOVE_BUYLIST(slotset,slot,argNum,argStr)
	local frame = slotset:GetTopParentFrame()
	local buyMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"buy_price")
	local remainMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"finalprice")
	CUSTOM_COIN_SHOP_REMOVE_BUYLIST(slotset,slot,buyMoneyCtrl, remainMoneyCtrl)
end

function CUSTOM_COIN_SHOP_REMOVE_BUYLIST(slotset,slot,buyMoneyCtrl, remainMoneyCtrl)
	local Lslot = slot
	local start = slot:GetSlotIndex()
	local last = slotset:GetSlotCount() -2
	local icon = CreateIcon(slot)
	if icon == nil then
		return
	end
	local info = icon:GetInfo()
	local shopName = CUSTOM_COIN_SHOP_GET_NAME(slotset)
	local shop = gePropertyShop.Get(shopName)
	local shopItem = shop:GetItemByIndex(info.type);
	local price = shopItem.price * info.count
	for i = start,last do
		local Rslot = slotset:GetSlotByIndex(i+1)
		local Ricon = Rslot:GetIcon()
		if Ricon == nil or Ricon:GetInfo().type == 0 then
			break
		end
		local Licon = CreateIcon(Lslot)
		CUSTOM_COIN_SHOP_COPY_ICON(Ricon,Licon)
		local text = Rslot:GetText()
		Lslot:SetText(text)
		if Rslot == nil then
			break
		end
		Lslot = Rslot
	end
	Lslot:ClearIcon()
	Lslot:SetText("")

	CUSTOM_COIN_SHOP_ADD_MONEY(buyMoneyCtrl, remainMoneyCtrl,-price)
end

function CUSTOM_COIN_SHOP_COPY_ICON(from,to)
	if from == nil or to == nil then
		return
	end
	local fromInfo = from:GetInfo()
	local toInfo = to:GetInfo()
	to:Set(fromInfo:GetImageName(),fromInfo:GetCategory(),fromInfo.type,fromInfo.ext,fromInfo:GetIESID(),fromInfo.count)
	to:SetTooltipArg('sell', from:GetTooltipNumArg(), from:GetTooltipStrArg());
	SET_ITEM_TOOLTIP_TYPE(to, from:GetTooltipNumArg());
end

function CUSTOM_COIN_SHOP_CLEAR_BUYLIST_ONCLICK(parent,ctrl,argStr,argNum)
	local frame = parent:GetTopParentFrame()
	local slotset = GET_CHILD_RECURSIVELY(frame,"buyitemslot")
	CUSTOM_COIN_SHOP_CLEAR_BUYLIST(frame,slotset)
end

function CUSTOM_COIN_SHOP_CLEAR_BUYLIST(frame,slotset)
	local cnt = slotset:GetSlotCount()
	for i = 0,cnt-1 do
		local slot = slotset:GetSlotByIndex(i)
		slot:ClearIcon()
		slot:SetText("")
	end
	local frame = slotset:GetTopParentFrame()
	local buyMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"buy_price")
	buyMoneyCtrl:SetTextByKey("price1",0)
	buyMoneyCtrl:SetValue("0")
	local remainMoneyCtrl = GET_CHILD_RECURSIVELY(frame,"finalprice")
	remainMoneyCtrl:SetTextByKey("price1",0)
end

function CUSTOM_COIN_SHOP_ADD_MONEY(buyMoneyCtrl, remainMoneyCtrl, price)
	local totalprice = buyMoneyCtrl:GetValue()
	if totalprice == nil then
		totalprice = "0"
	end
	totalprice = totalprice + price
	buyMoneyCtrl:SetTextByKey("price1",totalprice)
	buyMoneyCtrl:SetValue(totalprice)
	local now_money = GET_PROPERTY_SHOP_MY_POINT(buyMoneyCtrl:GetTopParentFrame());
	local remain_money = now_money - totalprice;
	remainMoneyCtrl:SetTextByKey("price1",remain_money)
end

function CUSTOM_COIN_SHOP_SELECT_DROPLIST(parent, dropList)
	local frame = parent:GetTopParentFrame()
	local gbox_sell_list_item = GET_CHILD_RECURSIVELY(frame,"gbox_sell_list_item")
	local grid_item_list = GET_CHILD_RECURSIVELY(gbox_sell_list_item,"grid_item_list")
	CUSTOM_COIN_SHOP_MAKE_ITEMLIST(gbox_sell_list_item,grid_item_list)
end

function CUSTOM_COIN_SHOP_BUY_ITEM(parent,ctrl,argStr,argNum)
	local frame = parent:GetTopParentFrame()
	local slotset = GET_CHILD_RECURSIVELY(frame,"buyitemslot")
	local cnt = slotset:GetSlotCount()
	local totalprice = 0
	local shopName = CUSTOM_COIN_SHOP_GET_NAME(parent)
	local shop = gePropertyShop.Get(shopName)
	for i = 0 , cnt-1 do
		local icon = slotset:GetIconByIndex(i)
		if icon ~= nil then
			local info = icon:GetInfo()
			local shopItem = shop:GetItemByIndex(info.type);
			totalprice = totalprice + shopItem.price * info.count
			propertyShop.AddPropertyShopItem(info.type,info.count)
		end
	end
	if GET_PROPERTY_SHOP_MY_POINT(frame) - totalprice < 0 then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughMoney'));
		return;
	end
	
	if frame == nil then
		frame = ui.GetFrame('shop');
	end

	propertyShop.ReqBuyPropertyShopItem(shopName)
	imcSound.PlaySoundEvent("market buy");
	CUSTOM_COIN_SHOP_CLEAR_BUYLIST(frame,slotset)
	propertyShop.ClearPropertyShopInfo()
end

function CUSTOM_COIN_SHOP_SEARCH(parent,ctrl,argStr,argNum)
	local edit = GET_CHILD(parent,"edit_itemSearch")
	local frame = parent:GetTopParentFrame()
	frame:SetUserValue("SEARCH_TEXT",edit:GetText())
	local gbox_sell_list_item = GET_CHILD_RECURSIVELY(frame,"gbox_sell_list_item")
	local grid_item_list = GET_CHILD_RECURSIVELY(gbox_sell_list_item,"grid_item_list")
	CUSTOM_COIN_SHOP_MAKE_ITEMLIST(gbox_sell_list_item,grid_item_list)
end