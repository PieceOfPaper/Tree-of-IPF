-- costume_exchangeshop_popupmsg.lua --

function COSTUME_EXCHANGESHOP_POPUPMSG_ON_INIT(addon, frame)

end

function COSTUME_EXCHANGESHOP_POPUPMSG_MAKE_ITEMLIST()
	local frame = ui.GetFrame("costume_exchangeshop_popupmsg");
	local tpitemframe = ui.GetFrame("tpitem");
	
	if frame == nil or tpitemframe == nil then
		return false;
	end

	local slotsetname = "costume_exchange_basketbuyslotset"
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
			local tpitem = GetClass("costume_exchange_shop",tpitemname)

			if tpitem ~= nil and item ~= nil then

				local itemcset = gbox:CreateOrGetControlSet('tpshop_costume_exchange_popup', 'eachitem_'..drawcount, 0, ui.GetControlSetAttribute("tpshop_costume_exchange_popup", 'height') * drawcount);
				local slot = GET_CHILD_RECURSIVELY(itemcset,"itemicon")
				
				SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
				
				local itemname = GET_CHILD_RECURSIVELY(itemcset,"itemname")
				local itemStaticprice_buy = GET_CHILD_RECURSIVELY(itemcset,"itemStaticprice_buy")
				local itemprice = GET_CHILD_RECURSIVELY(itemcset,"itemprice")
				
				itemname:SetText(item.Name)
				itemStaticprice_buy:ShowWindow(1)
				itemprice:SetText(tostring(tpitem.BuyPrice))
				allprice = allprice + tpitem.BuyPrice
				

				drawcount = drawcount + 1
			else
				return false
			end

		end
	end
	
	if allprice == 0 then
		return false;
	end

	local totalcoupon_buy = GET_CHILD_RECURSIVELY(frame,"totalcoupon_buy")
	local explain_buy = GET_CHILD_RECURSIVELY(frame,"explain_buy")
	local explain_buy2 = GET_CHILD_RECURSIVELY(frame,"explain_buy2")
	local button_ok = GET_CHILD_RECURSIVELY(frame,"button_ok")
	local button_cancel = GET_CHILD_RECURSIVELY(frame,"button_cancel")

	totalcoupon_buy:ShowWindow(1)
	explain_buy:ShowWindow(1)
	explain_buy2:ShowWindow(1)
											
	button_ok:SetEventScript(ui.LBUTTONUP, 'EXEC_BUY_COSTUME_EXCHANGE_ITEM');
	button_cancel:SetEventScript(ui.LBUTTONUP, 'TPSHOP_COSTUME_EXCHANGE_ITEM_BASKET_BUY_CANCEL');
	
	local totalcoupon = GET_CHILD_RECURSIVELY(frame,"totalcoupon")
	totalcoupon:SetTextByKey("price",allprice)
	
	return true
end