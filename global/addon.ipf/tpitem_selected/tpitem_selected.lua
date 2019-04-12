
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
	
	local cls = GetClassByType("Item", ItemClsId);
	if cls == nil  then
		return;
	end

	local itemTitle = GET_CHILD(stdBox, "itemTitle");
	itemTitle:SetTextByKey("name", cls.Name);

	local Itemslot = GET_CHILD(stdBox, "Itemslot");
	SET_SLOT_IMG(Itemslot, cls.Icon);
		
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
	local orderQuantity = tpitem_selected:GetUserValue("OrderQuantity");
	local orderPrice = tpitem_selected:GetUserValue("OrderPrice");
	ui.PickUpCashItem(orderNo, productNo, orderQuantity, orderPrice);
	tpitem_selected:ShowWindow(0);	
end

function TPITEM_SELECTED_DEFER(parent, control)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(0);	

	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:ShowWindow(0);
end

function TPITEM_SELECTED_REFUND(parent, control, orderNo, productNo)
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	tpitem_selected:ShowWindow(0);

	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(1);	
	

	local strMsg = "";
	local frame = ui.GetFrame("tpitem");
	strMsg = string.format("{@st43d}{s18}%s{/}{nl}{s8}{/} {/}{nl}{@st45d}{s20}%s{/}", ScpArgMsg("NISMS_REFUND_GUIDE1"), ScpArgMsg("NISMS_REFUND_GUIDE2"));
	ui.MsgBox_NonNested_Ex(strMsg, 0x00000004, frame:GetName(), "ON_TPITEM_SELECTED_REFUND", "ON_TPSHOP_FREE_UI", productNo, orderNo);	
		
end

function ON_TPITEM_SELECTED_REFUND(parent, control, orderNo, productNo)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(0);	
	
	local tpitem_selected = ui.GetFrame("tpitem_selected");
	local orderQuantity = tpitem_selected:GetUserValue("OrderQuantity");
	ui.RefundIngameShopItem(orderNo, productNo, orderQuantity);
	tpitem_selected:ShowWindow(0);	
end

