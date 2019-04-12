
-- tpitem_selected.lua : (tp shop)

function TPITEM_SELECTED_OPEN(refControl)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(1);	
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:ShowWindow(1);
	
	local icon = refControl:GetIcon();
	if icon == nil then		
		return;
	end	

	local ItemClsId			= icon:GetUserValue("itemClassID");
	local ProductNo			= icon:GetUserValue("ProductNo");
	
	local OrderQuantity		= icon:GetUserValue("OrderQuantity");
	local OrderNo			= icon:GetUserValue("OrderNo");
	local OrderPrice			= icon:GetUserValue("OrderPrice");

	local stdBox = GET_CHILD(tpitem_selected, "stdBox");
	TPSHOP_SHOWINFO_SELECTED_CASHITEM_INFO(stdBox, icon, 1);
	
	local cls = GetClassByType("Item", ItemClsId);
	if cls == nil  then
		return;
	end

	local itemTitle = GET_CHILD(stdBox, "itemTitle");
	itemTitle:SetTextByKey("name", cls.Name);

	local Itemslot = GET_CHILD(stdBox, "Itemslot");
	SET_SLOT_IMG(Itemslot, cls.Icon);
		
	tpitem_selected:SetUserValue("ItemClsId", ItemClsId);
	tpitem_selected:SetUserValue("OrderQuantity", OrderQuantity);
	tpitem_selected:SetUserValue("OrderPrice", OrderPrice);

	local puchaseBtn = GET_CHILD(stdBox, "puchaseBtn");
	puchaseBtn:SetEventScriptArgString(ui.LBUTTONUP, OrderNo);
	puchaseBtn:SetEventScriptArgNumber(ui.LBUTTONUP, ProductNo);

	local cancelBtn = GET_CHILD(stdBox, "cancelBtn");
	cancelBtn:SetEventScriptArgString(ui.LBUTTONUP, OrderNo);
	cancelBtn:SetEventScriptArgNumber(ui.LBUTTONUP, ProductNo);	
end

function TPITEM_SELECTED_PICKUP(parent, control, orderNo, productNo)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(0);	

	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:SetUserValue("IsClose", 1);
	local orderQuantity = tpitem_selected:GetUserValue("OrderQuantity");
	local orderPrice = tpitem_selected:GetUserValue("OrderPrice");
	local clsID = tpitem_selected:GetUserValue("ItemClsId");
	ui.PickUpCashItem(orderNo, productNo, orderQuantity, orderPrice, clsID);
	tpitem_selected:ShowWindow(0);	
	
	UPDATE_BASKET_MONEY(frame);
end

function TPITEM_SELECTED_DEFER(parent, control)
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:SetUserValue("IsClose", 1);
	TPITEM_SELECTED_CLOSE(parent, control);
end

function TPITEM_SELECTED_REFUND(parent, control, orderNo, productNo)
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:SetUserValue("IsClose", 0);
	tpitem_selected:ShowWindow(0);

	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(1);	

	local strMsg = "";
	local frame = ui.GetFrame("tpitem");
	strMsg = string.format("{@st43d}{s18}%s{/}{nl}{s8}{/} {/}{nl}{@st45d}{s20}%s{/}", ScpArgMsg("NISMS_REFUND_GUIDE1"), ScpArgMsg("NISMS_REFUND_GUIDE2"));
	ui.MsgBox_NonNested_Ex(strMsg, 0x00000004, frame:GetName(), "ON_TPITEM_SELECTED_REFUND", "ON_TPSHOP_FREE_UI", "None", orderNo, productNo);	
		
end

function ON_TPITEM_SELECTED_REFUND(parent, control, orderNo, productNo)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(0);	
	
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	local orderQuantity = tpitem_selected:GetUserValue("OrderQuantity");
	local clsID = tpitem_selected:GetUserValue("ItemClsId");
	ui.RefundIngameShopItem(orderNo, productNo, orderQuantity, clsID);
	tpitem_selected:SetUserValue("IsClose", 0);
	tpitem_selected:ShowWindow(0);	
end


function TPITEM_SELECTED_CLOSE(parent, control)
		local tpitem_selected = ui.GetFrame("tpitem_selected");		
		local IsClose = tpitem_selected:GetUserIValue("IsClose");
		if IsClose == 1 then
			tpitem_selected:ShowWindow(0);
			ON_TPSHOP_FREE_UI();
		else
			tpitem_selected:SetUserValue("IsClose", 1);
		end
end


function TPSHOP_SHOWINFO_SELECTED_CASHITEM_INFO(frame, icon, visible)

	local selectedCashInvenItem = frame:CreateOrGetControl('groupbox', 'selectedCashInvenItem', 0, 350, 380, 120);
	selectedCashInvenItem = tolua.cast(selectedCashInvenItem, "ui::CGroupBox");
	selectedCashInvenItem:DeleteAllControl();
	selectedCashInvenItem:EnableDrawFrame(1);
	selectedCashInvenItem:SetScrollBar(120);
	selectedCashInvenItem:SetScrollPos(0);
	selectedCashInvenItem:SetSkinName("test_frame_midle_light");
	selectedCashInvenItem:SetGravity(ui.CENTER_HORZ, ui.TOP);
		
	if visible == 1 then
		selectedCashInvenItem:SetVisible(1);	
		selectedCashInvenItem:SetScrollPos(0);
	else
		selectedCashInvenItem:SetVisible(0);	
		return;
	end
	
	if icon == nil then
		return;
	end
		
	local ItemClsId = icon:GetUserValue("itemClassID");
	local ProductNo = icon:GetUserValue("ProductNo");
	local ProductName = icon:GetUserValue("ItemClassName");
	local OrderNo = icon:GetUserValue("OrderNo");
	local OrderPrice = icon:GetUserValue("OrderPrice");
	local OrderDate = icon:GetUserValue("OrderDate");
	local OrderQuantity = icon:GetUserValue("OrderQuantity");
	local strDate = ScpArgMsg("GetPurchasedItemInfo_DATE");
	local strQuantity = ScpArgMsg("GetPurchasedItemInfo_QUANTITY");
	local strPrice = ScpArgMsg("GetPurchasedItemInfo_PRICE");
	
	local cls = GetClassByType("Item", ItemClsId);
	if cls == nil  then
		return;
	end

	local innerBox = selectedCashInvenItem:CreateOrGetControl('groupbox', 'innerBox', 0, 0, selectedCashInvenItem:GetWidth(), 120);
	innerBox = tolua.cast(innerBox, "ui::CGroupBox");
	innerBox:DeleteAllControl();
	innerBox:EnableDrawFrame(0);
	innerBox:EnableScrollBar(0);
	innerBox:SetSkinName("None");
	
	local y = 9;
	local selectedItemInfo = innerBox:CreateOrGetControl("richtext", "selectedItemInfo", 14, y, 340, 250);
	selectedItemInfo = tolua.cast(selectedItemInfo, "ui::CRichText");
	selectedItemInfo:SetTextFixWidth(1);
	selectedItemInfo:SetFontName("black_16_b");

	local reFormatOrderDate = string.gsub(OrderDate, "(%d+-%d+-%d+)T(%d+:%d+:%d+).%d*+%d+:%d+", "%1 %2");
	if OrderQuantity == "1" then
		local strData = string.format("{@st43d}{s18}%s %s {nl} %s %s{img Nexon_cash_mark 30 30}{/}{/}{nl}{@st43d}{s18}%s %s %s{/}", strDate, reFormatOrderDate, strPrice, OrderPrice, strQuantity, OrderQuantity, ScpArgMsg("Piece"));
		selectedItemInfo:SetText(strData);
	else
		local UnitPrice = icon:GetUserValue("UnitPrice");
		local strUNITPrice = ScpArgMsg("GetPurchasedItemInfo_UNITPRICE");
		local strData = string.format("{@st43d}{s18}%s %s {nl} %s %s{img Nexon_cash_mark 30 30}{/}{/}(%s %s{img Nexon_cash_mark 30 30}{/}{/}){nl}{@st43d}{s18}%s %s %s{/}", strDate, reFormatOrderDate, strPrice, OrderPrice, strUNITPrice, UnitPrice, strQuantity, OrderQuantity, ScpArgMsg("Piece"));
		selectedItemInfo:SetText(strData);
	end
	y = selectedItemInfo:GetY() + selectedItemInfo:GetHeight() + 5;

	local selectedItemDesc = innerBox:CreateOrGetControl("richtext", "selectedItemDesc", 14, y, 340, 250);
	selectedItemDesc = tolua.cast(selectedItemDesc, "ui::CRichText");
	selectedItemDesc:SetTextFixWidth(1);
	selectedItemDesc:SetFontName("black_16_b");
	selectedItemDesc:SetText(string.format("{@st43d}{s18}%s{/}",cls.Desc)); 
	y = selectedItemDesc:GetY()  + selectedItemDesc:GetHeight() + 10;	
		
	innerBox:Resize(innerBox:GetWidth(), y);
end