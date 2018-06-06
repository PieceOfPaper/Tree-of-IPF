-- hair_gacha_start.lua --

function RECYCLESHOP_POPUPMSG_ON_INIT(addon, frame)

end

function RECYCLESHOP_POPUPMSG_MAKE_ITEMLIST(type)

	local frame = ui.GetFrame("recycleshop_popupmsg");
	local tpitemframe = ui.GetFrame("tpitem");

	if frame == nil or tpitemframe == nil then
		return false;
	end

	local slotsetname = nil
	if type == "buy" then
		slotsetname = "rcycle_basketbuyslotset"
	else
		slotsetname = "rcycle_basketsellslotset"
	end

	local slotset = GET_CHILD_RECURSIVELY(tpitemframe,slotsetname)
	

	local gbox = GET_CHILD_RECURSIVELY(frame,"itemlistgbox")
	if gbox == nil then
		return false;
	end
	DESTROY_CHILD_BYNAME(gbox, 'eachitem_');
	local slotCount = slotset:GetSlotCount();
	local allprice = 0
	local drawcount = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);

			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local cnt = slot:GetUserValue("COUNT");
			local item = GetClass("Item",tpitemname)
			local tpitem = GetClass("recycle_shop",tpitemname)

			if tpitem ~= nil and item ~= nil then

				local itemcset = gbox:CreateOrGetControlSet('tpshop_recycle_popup', 'eachitem_'..drawcount, 0, ui.GetControlSetAttribute("tpshop_recycle_popup", 'height') * drawcount);
				local slot = GET_CHILD_RECURSIVELY(itemcset,"itemicon")
				
				SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
				
				local itemname = GET_CHILD_RECURSIVELY(itemcset,"itemname")
				local itemStaticprice_buy = GET_CHILD_RECURSIVELY(itemcset,"itemStaticprice_buy")
				local itemStaticprice_sell = GET_CHILD_RECURSIVELY(itemcset,"itemStaticprice_sell")
				local itemprice = GET_CHILD_RECURSIVELY(itemcset,"itemprice")
				
				if type == "buy" then
					itemname:SetText(item.Name)
					itemStaticprice_buy:ShowWindow(1)
					itemStaticprice_sell:ShowWindow(0)
					itemprice:SetText(tostring(tpitem.BuyPrice))
					allprice = allprice + tpitem.BuyPrice
				else
					itemname:SetText(item.Name.. " X"..tostring(cnt))
					itemStaticprice_buy:ShowWindow(0)
					itemStaticprice_sell:ShowWindow(1)
					itemprice:SetText(tostring(tpitem.SellPrice * cnt))
					allprice = allprice + (tpitem.SellPrice * cnt)
				end

				drawcount = drawcount + 1
			else
				return false
			end

		end
	end

	if allprice == 0 then
		return false;
	end

	local totalmedal_buy = GET_CHILD_RECURSIVELY(frame,"totalmedal_buy")
	local totalmedal_sell = GET_CHILD_RECURSIVELY(frame,"totalmedal_sell")
	local explain_buy = GET_CHILD_RECURSIVELY(frame,"explain_buy")
	local explain_buy2 = GET_CHILD_RECURSIVELY(frame,"explain_buy2")
	local explain_sell = GET_CHILD_RECURSIVELY(frame,"explain_sell")
	local explain_sell2 = GET_CHILD_RECURSIVELY(frame,"explain_sell2")
	local button_ok = GET_CHILD_RECURSIVELY(frame,"button_ok")
	local button_cancel = GET_CHILD_RECURSIVELY(frame,"button_cancel")

	if type == "buy" then
		totalmedal_buy:ShowWindow(1)
		explain_buy:ShowWindow(1)
		explain_buy2:ShowWindow(1)
		totalmedal_sell:ShowWindow(0)
		explain_sell:ShowWindow(0)
		explain_sell2:ShowWindow(0)
		button_ok:SetEventScript(ui.LBUTTONUP, 'EXEC_BUY_RECYCLE_ITEM');
		button_cancel:SetEventScript(ui.LBUTTONUP, 'TPSHOP_RECYCLE_ITEM_BASKET_BUY_CANCEL');
	else
		totalmedal_buy:ShowWindow(0)
		explain_buy:ShowWindow(0)
		explain_buy2:ShowWindow(0)
		totalmedal_sell:ShowWindow(1)
		explain_sell:ShowWindow(1)
		explain_sell2:ShowWindow(1)
		button_ok:SetEventScript(ui.LBUTTONUP, 'EXEC_SELL_RECYCLE_ITEM');
		button_cancel:SetEventScript(ui.LBUTTONUP, 'TPSHOP_RECYCLE_ITEM_BASKET_SELL_CANCEL');
	end

	local totalmedal = GET_CHILD_RECURSIVELY(frame,"totalmedal")
	totalmedal:SetTextByKey("price",allprice)

	return true
end