
function ON_NEXON_AMERICA_BALANCE(frame, msg, str, num)
	local remainNexonCash = GET_CHILD_RECURSIVELY(frame,"remainNexonCash");	
	remainNexonCash:SetText(math.floor(session.ui.GetTotalBalance()));
	local remainNexonCash_prepaid = GET_CHILD_RECURSIVELY(frame,"remainNexonCash_prepaid");	
	remainNexonCash_prepaid:SetText(math.floor(session.ui.GetPrepaidBalance()));
	local remainNexonCash_credit = GET_CHILD_RECURSIVELY(frame,"remainNexonCash_credit");	
	remainNexonCash_credit:SetText(math.floor(session.ui.GetCreditBalance()));
end

function ON_NEXON_AMERICA_BALANCE_ENOUGH(frame, msg, str, num)
	local item = GetClassByType("Item", num);
	local itemName = TryGetProp(item, "Name")
	if itemName == nil then
		return;
	end

	local yesScp = string.format("REQ_NEXON_AMERICA_PURCHASE(%d, 1)", num);
	local noScp = string.format("ON_PURCHASE_CANCELLED()");
	ui.MsgBox(ScpArgMsg("NXABillingConfirmPurchase{Item}", "Item", itemName), yesScp, noScp);
end

function ON_NEXON_AMERICA_BALANCE_NOT_ENOUGH(frame, msg, str, num)
	local yesScp = string.format("REQ_NEXON_AMERICA_PURCHASE(%d, 0)", num);
	local noScp = string.format("ON_NEXON_AMERICA_PURCHASE_CANCELLED()");
	ui.MsgBox(ScpArgMsg("NXABillingNotEnoughBalanceQueryRefill"), yesScp, noScp);
end

function ON_NEXON_AMERICA_BUY_ITEM(parent, control, ItemClassIDstr, itemid)
	ui.BuyIngameShopItem(itemid);
end

function ON_NEXON_AMERICA_SELLITEMLIST()
	UPDATE_NEXON_AMERICA_SELLITEMLIST();
end

function REQ_NEXON_AMERICA_REFRESH()
	ui.ReqNXABalance();
	ui.ReqNXARePickUp();
end

function REQ_NEXON_AMERICA_PURCHASE(itemID, hasEnoughNX)
	ui.ReqNXAPurchase(itemID, hasEnoughNX);
end

function ON_NEXON_AMERICA_PURCHASE_CANCELLED()
	ui.SysMsg(ScpArgMsg("NXABillingPurchaseCancelled"));
end

function UPDATE_NEXON_AMERICA_SELLITEMLIST() 
	local frame = ui.GetFrame("tpitem");
	local leftgFrame = GET_CHILD(frame,"leftgFrame");	
	local leftgbox = GET_CHILD(leftgFrame,"leftgbox");	
	local tpSubgbox = GET_CHILD(leftgbox,"tpSubgbox");		
	local tpMaingbox = GET_CHILD(leftgbox,"tpMaingbox");	
	local mainSubGbox = GET_CHILD_RECURSIVELY(tpMaingbox,"tpMainSubGbox");	
	local index = 0;
	DESTROY_CHILD_BYNAME(mainSubGbox, "eachitem_");
	DESTROY_CHILD_BYNAME(tpSubgbox, "specialProduct_");
	tpSubgbox:ShowWindow(1)

	local cnt = session.ui.GetNXASalesItemCount();
	if cnt == 0 then		
		return;
	end
	
	for index = 0, cnt - 1 do 
		local iteminfo = session.ui.GetNXASalesItemByIndex(index)
		if iteminfo == nil then
			return;
		end

		local itemID = iteminfo.itemID;
		local price = iteminfo.price;
		local prepaidOnly = iteminfo.prepaidOnly;

		local itemCls = GetClassByType("Item", iteminfo.itemID);
		local itemName = TryGetProp(itemCls, "Name");
		
		local x = ( index % 4) * ui.GetControlSetAttribute("tpshop_itemtp", 'width')
		local y = (math.floor(index / 4)) * (ui.GetControlSetAttribute("tpshop_itemtp", 'height') * 1)
		

		local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_itemtp', 'eachitem_'..index, x, y);

		local title = GET_CHILD_RECURSIVELY(itemcset,"title");
		local staticTPbox = GET_CHILD_RECURSIVELY(itemcset,"staticTPbox")
		local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");

		SET_SLOT_IMG(slot, itemCls.Icon);
		
		staticTPbox:SetText("{img THB_cash_mark 30 30}{/}{@st43}{s18}".. price .."{/}");
		title:SetText(itemName);

		local icon = slot:GetIcon();

		local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");	
		buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemID);
		buyBtn:SetEventScriptArgString(ui.LBUTTONUP, string.format("%d", itemID));
		buyBtn:SetUserValue("LISTINDEX", index);
	end
end