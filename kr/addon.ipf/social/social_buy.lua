-- bin/addon/social/social_buy.lua
function SOCIAL_BUY_INIT(frame)
	--local buyGbox = GET_CHILD(frame, "buyGbox", "ui::CGroupBox");

	--local buyMenu_1 = GET_CHILD(buyGbox, "buyMenu_1", "ui::CRichText");
	--buyMenu_1:SetText("{@st41b}"..ClMsg("Social_Buy_Menu_1"));

	--local buyMenu_2 = GET_CHILD(buyGbox, "buyMenu_2", "ui::CRichText");
	--buyMenu_2:SetText("{@st41b}"..ClMsg("Social_Buy_Menu_2"));
end

function SOCIAL_BUY_ON_DROP(buyGbox, itemGbox, argStr, argNum)
	local liftIcon 					= ui.GetLiftIcon();
	local iconParentFrame 			= liftIcon:GetTopParentFrame();

	local searchCount = GET_CHILD_CNT_BYNAME(itemGbox, "buyItem_");
	local yPos = searchCount * 70;
	local buyItemCtrlSet = itemGbox:CreateOrGetControlSet("socialitemset_Type", "buyItem_"..searchCount, 5, 5+yPos);

	SOCIAL_BUY_ITEM_SET(buyItemCtrlSet, liftIcon:GetInfo());
	itemGbox:Invalidate();
end

function SOCIAL_BUY_ITEM_SET_FROM_WIKI(frame, itemCls)
	local buyGbox = GET_CHILD(frame, "buyGbox", "ui::CGroupBox");
	local buyItemGbox = GET_CHILD(buyGbox, "buyItemGbox", "ui::CGroupBox");

	local searchCount = GET_CHILD_CNT_BYNAME(buyItemGbox, "buyItem_");
	local yPos = searchCount * 62;
	local buyItemCtrlSet = buyItemGbox:CreateOrGetControlSet("socialitemset_Type", "buyItem_"..searchCount, 5, yPos);

	local buyItemSlot = GET_CHILD(buyItemCtrlSet, "slot", "ui::CSlot");
	local icon 	= CreateIcon(buyItemSlot);
	icon:Set(itemCls.Icon, "item", itemCls.ClassID, 0);

	local buyItemName = GET_CHILD(buyItemCtrlSet, "ItemName", "ui::CRichText");
	buyItemName:SetText('{@st42b}' .. itemCls.Name);

	local buyItemCount = GET_CHILD(buyItemCtrlSet, "ItemCount", "ui::CRichText");
	buyItemCount:SetText(ScpArgMsg("Auto_{s14}{b}{ds}KuMae_SuLyang"));

	local buyItemPriceNumUpDown = GET_CHILD(buyItemCtrlSet, "priceEdit", "ui::CNumUpDown");
	buyItemPriceNumUpDown:SetLBtnUpScp("SOCIAL_BUY_PRICE_DOWN");
	buyItemPriceNumUpDown:SetRBtnUpScp("SOCIAL_BUY_PRICE_UP");

	local buyItemCountNumUpDown = GET_CHILD(buyItemCtrlSet, "countEdit", "ui::CNumUpDown");
	buyItemCountNumUpDown:SetLBtnUpScp("SOCIAL_BUY_COUNT_DOWN");
	buyItemCountNumUpDown:SetRBtnUpScp("SOCIAL_BUY_COUNT_UP");

	-- DeleteBtn
	local buyItemDeleteBtn = buyItemGbox:CreateOrGetControl("button", "deleteBtn_"..searchCount, -20, yPos + 10, 26, 60);
	buyItemDeleteBtn:SetText("{@st42}X{/}");
	buyItemDeleteBtn:SetGravity(ui.RIGHT, ui.TOP);
	buyItemDeleteBtn:SetValue(searchCount);
	buyItemDeleteBtn:SetEventScript(ui.LBUTTONUP, "SOCIAL_BUY_ITEM_DELETE");
	buyItemDeleteBtn:ShowWindow(1);
end

function SOCIAL_BUY_ITEM_SET(itemCtrlSet, dropIconInfo)
	local buyItemSlot = GET_CHILD(itemCtrlSet, "slot", "ui::CSlot");
	local buyItemName = GET_CHILD(itemCtrlSet, "ItemName", "ui::CRichText");
	local buyCountNumUpDown = GET_CHILD(itemCtrlSet, "countEdit", "ui::CNumUpDown");
	local icon 	= CreateIcon(buyItemSlot);

	if dropIconInfo:GetCategory() == "Item" then
		local itemIES = GetClassByType('Item', dropIconInfo.type);
		if itemIES ~= nil then
			icon:Set(itemIES.Icon, dropIconInfo:GetCategory(), dropIconInfo.type, dropIconInfo.ext);

			buyItemName:SetText('{@st42b}' .. itemIES.Name);

			local invenInfo = session.GetInvItem(dropIconInfo.ext);
			buyCountNumUpDown:SetMaxValue(invenInfo.count);
		end
	end

	buyItemSlot:Invalidate();
end

function SOCIAL_BUY_ITEM_DELETE(itemGbox, deleteBtn, argStr, argNum)
	itemGbox:RemoveChild("buyItem_"..deleteBtn:GetValue());
	deleteBtn:ShowWindow(0);

	local findCnt = 0;
	local findBtnCnt = 0;
	local cnt = itemGbox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = itemGbox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "buyItem_") ~= nil then
			childObj:SetOffset(5, findCnt*62);
			findCnt = findCnt + 1;
		elseif string.find(name, "deleteBtn_") ~= nil and childObj:IsVisible() == 1 then
			childObj:SetOffset(-20, findBtnCnt*62 + 22);
			findBtnCnt = findBtnCnt + 1;
		end
	end
	itemGbox:Invalidate();
end

function SOCIAL_BUY_PRICE_DOWN(numUpDownCtrl, argStr, argNum)

end

function SOCIAL_BUY_PRICE_UP(numUpDownCtrl, argStr, argNum)

end

function SOCIAL_BUY_COUNT_DOWN(numUpDownCtrl, argStr, argNum)

end

function SOCIAL_BUY_COUNT_UP(numUpDownCtrl, argStr, argNum)

end

function BUY_MODE_START(buyGbox, btnCtrl, argStr, argNum)
	local buyItemGbox = GET_CHILD(buyGbox, "buyItemGbox", "ui::CGroupBox");
	BUY_MODE_CHECK(buyItemGbox);
	session.BuyModeOn();
end


