-- socialballoon_buy.lua

function SOCIAL_ITEMBUY_MODE_SIMPLE(frame, handle)
	frame:SetSkinName("balloonskin_buy");
	local buyGbox_detail = GET_CHILD(frame, "buyGbox_detail", "ui::CGroupBox");
	buyGbox_detail:ShowWindow(0);
	
	local buyGbox = GET_CHILD(frame, "buyGbox", "ui::CGroupBox");
	buyGbox:ShowWindow(1);
	
	local buyItemCount = social.GetBuyModeCount(handle);	
	for i=0, 2 do
		local buyItemStruct = social.GetBuyModeItemByIndex(handle, i);	
		
		ITEMBUY_SIMPLE_CTRL_SET(i, buyGbox, buyItemStruct);
	end
end

function SOCIAL_ITEMBUY_MODE_DETAIL(frame, handle)
	-- Init()	
	local buyGbox = GET_CHILD(frame, "buyGbox", "ui::CGroupBox");
	buyGbox:ShowWindow(0);
	
	frame:SetSkinName("socialwindow_shop");
	frame:Resize(320, 420);
	
	local buyGbox_detail = GET_CHILD(frame, "buyGbox_detail", "ui::CGroupBox");
	buyGbox_detail:ShowWindow(1);
	buyGbox_detail:Resize(270, 370);
	
	local titleText = GET_CHILD(buyGbox_detail, "titleText", "ui::CRichText");		
	titleText:SetText(info.GetPCName(handle)..ScpArgMsg("Auto_ui_KuMaeyoCheong"));
	
	local itemGbox = GET_CHILD(buyGbox_detail, "itemGbox", "ui::CGroupBox");		
	itemGbox:DeleteAllControl();
	
	local myPageMapCount = social.GetBuyModeCount(handle);
	local yPos = 10;
	for i=0, myPageMapCount-1 do
		local buyItemStruct = social.GetBuyModeItemByIndex(handle, i);
		yPos = ITEMBUY_DETAIL_CTRL_SET(itemGbox, buyItemStruct, i, yPos);
	end
	
	itemGbox:UpdateData();
	itemGbox:InvalidateScrollBar();
end

function ITEMBUY_SIMPLE_CTRL_SET(index, buyGbox, buyItemStruct)
	local buyItemSlot = GET_CHILD(buyGbox, "buyItem"..index, "ui::CSlot");
	if buyItemStruct == nil then
		buyItemSlot:ShowWindow(0);
		return;
	else
		buyItemSlot:ShowWindow(1);
	end
	
	local icon = buyItemSlot:GetIcon();	
	if icon == nil then
		icon = CreateIcon(buyItemSlot);
	end
	
	local itemCls = GetClassByType("Item", buyItemStruct.index);
	if itemCls == nil then
		return;
	end
	
	icon:Set(itemCls.Icon, "Item", itemCls.ClassID, 0);		
end

function ITEMBUY_DETAIL_CTRL_SET(itemGbox, itemStruct, index, yPos)
	local itemCls = GetClassByType("Item", itemStruct.index);
	if itemCls == nil then
		return yPos;
	end
	
	local xPos = 5;
	local buyItemCtrlSet = itemGbox:CreateOrGetControlSet("buyModeItemSet", "buyItem_"..index, xPos, yPos);
	
	local slot = GET_CHILD(buyItemCtrlSet, "slot", "ui::CSlot");
	local icon = CreateIcon(slot);
	icon:Set(itemCls.Icon, "Item", itemCls.ClassID, 0);
	
	local itemNameText = GET_CHILD(buyItemCtrlSet, "ItemName", "ui::CRichText");
	itemNameText:SetText(itemCls.Name);
	
	local itemPriceCountText = GET_CHILD(buyItemCtrlSet, "ItemPriceCount", "ui::CRichText");	
	local price = itemStruct.price * itemStruct.count;
	local priceCount = ScpArgMsg("Auto_Chong_KaKyeog_:_{Auto_1},_SuLyang_:_{Auto_2}_Kae","Auto_1", price, "Auto_2",itemStruct.count);
	itemPriceCountText:SetText(priceCount);
	
	return yPos + buyItemCtrlSet:GetHeight();
end
