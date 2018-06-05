-- bin/addon/social/social_sell.lua
function SOCIAL_SELL_ON_INIT(addon, frame)
end

function SOCIAL_SELL_INIT(frame)
	local sellGbox = GET_CHILD(frame, "sellGbox", "ui::CGroupBox");
	if sellGbox == nil then
		return;
	end

	local sellMenu_1 = GET_CHILD(sellGbox, "sellMenu_1", "ui::CRichText");
	sellMenu_1:SetText("{@st41b}"..ClMsg("Social_Sell_Menu_1"));

	local sellMenu_2 = GET_CHILD(sellGbox, "sellMenu_2", "ui::CRichText");
	sellMenu_2:SetText("{@st41b}"..ClMsg("Social_Sell_Menu_2"));
end

function SOCIAL_SELL_ON_DROP(sellGbox, itemGbox, argStr, argNum)	
	local liftIcon 			= ui.GetLiftIcon();
	local iconParentFrame 	= liftIcon:GetTopParentFrame();	
	local dropIconInfo 		= liftIcon:GetInfo();

	local result, itemMaxCount = SOCIAL_SELL_DROP_CHECK(itemGbox, dropIconInfo);
	if result == false then
		return;
	end
	
	if dropIconInfo.category ~= "Item" then
		return;
	end

	local itemIES = GetClassByType('Item', dropIconInfo.type);
	if itemIES == nil then
		return;
	end
	
	local divideFrame = ui.GetFrame("socialitemdivide");
	SOCIALITEMDIVIDE_SETTING(divideFrame, dropIconInfo.ext, dropIconInfo.type, itemMaxCount);	
end

function SOCIAL_SELL_CTRL_SET(invIndex, itemType, itemCount)
	local socialFrame = ui.GetFrame("social");
	local sellGbox	  = GET_CHILD(socialFrame, "sellGbox", "ui::CGroupBox");
	local itemGbox	  = GET_CHILD(sellGbox, "sellItemGbox", "ui::CGroupBox");
	
	local searchCount = GET_CHILD_BYNAME(itemGbox, "sellItem_");
	local yPos = searchCount * 70;
	local sellItemCtrlSet = itemGbox:CreateOrGetControlSet("socialitemset_Type", "sellItem_"..searchCount, 5, 5+yPos);

	SOCIAL_SELL_ITEM_SET(sellItemCtrlSet, invIndex, itemType, itemCount);

	-- DeleteBtn
	local buyItemDeleteBtn = itemGbox:CreateOrGetControl("button", "deleteBtn_"..searchCount, -20, yPos + 10, 26, 60);
	buyItemDeleteBtn:SetText("{@st42}X{/}");
	buyItemDeleteBtn:SetGravity(ui.RIGHT, ui.TOP);
	buyItemDeleteBtn:SetValue(invIndex);	
	buyItemDeleteBtn:SetSValue(sellItemCtrlSet:GetName());
	buyItemDeleteBtn:SetEventScript(ui.LBUTTONUP, "SOCIAL_SELL_CTRL_DELETE");
	buyItemDeleteBtn:ShowWindow(1);

	itemGbox:Invalidate();	
end

function SOCIAL_SELL_ITEM_SET(itemCtrlSet, invIndex, itemType, itemCount)

	local itemIES = GetClassByType('Item', itemType);
	if itemIES == nil then
		return;
	end

	local sellItemSlot = GET_CHILD(itemCtrlSet, "slot", "ui::CSlot");
	local sellItemName = GET_CHILD(itemCtrlSet, "ItemName", "ui::CRichText");	
	local sellPriceNumUpDown = GET_CHILD(itemCtrlSet, "priceEdit", "ui::CNumUpDown");

	local icon 	= CreateIcon(sellItemSlot);
	icon:Set(itemIES.Icon, "Item", itemType, invIndex);

	sellItemName:SetText('{@st42b}' .. itemIES.Name);	
	sellPriceNumUpDown:SetLBtnUpScp("SOCIAL_SELL_PRICE_DOWN");
	sellPriceNumUpDown:SetRBtnUpScp("SOCIAL_SELL_PRICE_UP");
	sellItemSlot:Invalidate();	
end

function SOCIAL_SELL_DROP_CHECK(itemGbox, dropIconInfo)
	local invenInfo = session.GetInvItem(dropIconInfo.ext);
	local itemCount = invenInfo.count;

	local cnt = itemGbox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = itemGbox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "sellItem_") ~= nil then
			local sellItemSlot = GET_CHILD(childObj, "slot", "ui::CSlot");
			
			local sellItemIcon = sellItemSlot:GetIcon();
			local sellItemIconInfo = sellItemIcon:GetInfo();

			if sellItemIconInfo.type == dropIconInfo.type then
				itemCount = itemCount;
			end
		end
	end

	if itemCount <= 0 then
		return false, -1;
	end

	return true, itemCount;
end

function SOCIAL_SELL_COUNT_DOWN(numUpDownCtrl, argStr, argNum)
	tolua.cast(numUpDownCtrl, "ui::CNumUpDown");

	local itemCtrlSet 		 = numUpDownCtrl:GetParent();
	local sellPriceNumUpDown = GET_CHILD(itemCtrlSet, "priceEdit", "ui::CNumUpDown");
	local priceTotal = GET_CHILD(itemCtrlSet, "priceTotal", "ui::CRichText");

	priceTotal:SetText(ScpArgMsg("Auto_Chong_KaKyeog_:_")..sellPriceNumUpDown:GetNumber() * numUpDownCtrl:GetNumber());

end

function SOCIAL_SELL_COUNT_UP(numUpDownCtrl, argStr, argNum)
	tolua.cast(numUpDownCtrl, "ui::CNumUpDown");

	local itemCtrlSet 		 = numUpDownCtrl:GetParent();
	local sellPriceNumUpDown = GET_CHILD(itemCtrlSet, "priceEdit", "ui::CNumUpDown");
	local priceTotal = GET_CHILD(itemCtrlSet, "priceTotal", "ui::CRichText");

	priceTotal:SetText(ScpArgMsg("Auto_Chong_KaKyeog_:_")..sellPriceNumUpDown:GetNumber() * numUpDownCtrl:GetNumber());
end

function SOCIAL_SELL_PRICE_DOWN(numUpDownCtrl, argStr, argNum)
	tolua.cast(numUpDownCtrl, "ui::CNumUpDown");

	local itemCtrlSet 		 = numUpDownCtrl:GetParent();
	local sellCountNumUpDown = GET_CHILD(itemCtrlSet, "countEdit", "ui::CNumUpDown");
	local priceTotal = GET_CHILD(itemCtrlSet, "priceTotal", "ui::CRichText");

	priceTotal:SetText(ScpArgMsg("Auto_Chong_KaKyeog_:_")..sellCountNumUpDown:GetNumber() * numUpDownCtrl:GetNumber());
end

function SOCIAL_SELL_PRICE_UP(numUpDownCtrl, argStr, argNum)
	tolua.cast(numUpDownCtrl, "ui::CNumUpDown");

	local itemCtrlSet 		 = numUpDownCtrl:GetParent();
	local sellCountNumUpDown = GET_CHILD(itemCtrlSet, "countEdit", "ui::CNumUpDown");
	local priceTotal = GET_CHILD(itemCtrlSet, "priceTotal", "ui::CRichText");

	priceTotal:SetText(ScpArgMsg("Auto_Chong_KaKyeog_:_")..sellCountNumUpDown:GetNumber() * numUpDownCtrl:GetNumber());

end

function SOCIAL_SELL_CTRL_DELETE(itemGbox, deleteBtn, argStr, argNum)
	itemGbox:RemoveChild(deleteBtn:GetSValue());
	deleteBtn:ShowWindow(0);

	local findCnt = 0;
	local findBtnCnt = 0;
	local cnt = itemGbox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = itemGbox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "sellItem_") ~= nil then
			childObj:SetOffset(5, findCnt*62);
			findCnt = findCnt + 1;
		elseif string.find(name, "deleteBtn_") ~= nil and childObj:IsVisible() == 1 then
			childObj:SetOffset(-20, findBtnCnt*62 + 22);
			findBtnCnt = findBtnCnt + 1;
		end
	end
	
	itemGbox:Invalidate();
	
	SOCIAL_SELL_ITEM_DELETE(deleteBtn:GetValue());
end

function SELL_MODE_START(sellGbox, btnCtrl, argStr, argNum)
	session.SellModeOn();
end

function SOCIAL_SELL_ITEM_LIST(frame)
	local sellGbox = GET_CHILD(frame, "sellGbox", "ui::CGroupBox");
	local sellItemGbox = GET_CHILD(sellGbox, "sellItemGbox", "ui::CGroupBox");
	sellItemGbox:DeleteAllControl();
	
	local list = session.GetSocialSellModeItemList();
	local i = list:Head();
	local idx = 0;
	while 1 do
		if i == list:InvalidIndex() then
			break;
		end
		
		local info = list:Element(i);
		SOCIAL_SELL_CTRL_SET(info.invIndex, info.type, info.count);		
		idx = idx + 1;
		i = list:Next(i);
	end
end
