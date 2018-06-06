
function SIMPLEINGAMESHOP_ON_INIT(addon, frame)

		addon:RegisterMsg("UPDATE_INGAME_SHOP_ITEM_LIST", "ON_UPDATE_INGAME_SHOP_ITEM_LIST");
		addon:RegisterMsg("CLOSE_INGAMESHOP_UI", "ON_CLOSE_INGAMESHOP_UI");
		addon:RegisterMsg("UPDATE_INGAME_SHOP_REMAIN_CASH", "ON_UPDATE_INGAME_SHOP_REMAIN_CASH");
		
end

function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                :gsub(",(%-?)$","%1"):reverse()
end

function ON_UPDATE_INGAME_SHOP_REMAIN_CASH(frame) -- for override

end

function ON_CLOSE_INGAMESHOP_UI()
	ui.CloseFrame("simpleingameshop");
end

function SIMPLEINGAMESHOP_OPEN(frame)

	local listbox = GET_CHILD_RECURSIVELY(frame, "itemlist");
	listbox:RemoveAllChild();
	frame:Invalidate()

	ui.OpenIngameShopUI();
end

function ON_UPDATE_INGAME_SHOP_ITEM_LIST(frame)
	
	local listbox = GET_CHILD_RECURSIVELY(frame, "itemlist");
	listbox:RemoveAllChild();

	local cnt = session.ui.GetIngameShopItemListSize();

	for i = 0 , cnt-1 do

		local iteminfo = session.ui.GetIngameShopItemInfo(i)
		
		local ctrlSet = listbox:CreateControlSet('ingameshop_item', "INGAMESHOP_ITEM_" .. i, (i % 2) * ui.GetControlSetAttribute("ingameshop_item", "width") , math.floor(i / 2) * ui.GetControlSetAttribute("ingameshop_item", "height"));
		local btn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
		local title = GET_CHILD_RECURSIVELY(ctrlSet, "title");
		local tpicon_change = GET_CHILD_RECURSIVELY(ctrlSet, "tpicon_change");
		local nxp = GET_CHILD_RECURSIVELY(ctrlSet, "nxp");
		
		title:SetText(iteminfo:GetName())
		tpicon_change:SetImage(iteminfo:GetImgName())
		nxp:SetText(tostring(iteminfo.addtp))
		
		btn:SetUserValue("ITEMGUID", iteminfo:GetItemGuid());

	end
	
	frame:Invalidate()

end

function INGAMESHOP_ITEM_PURCHASE(parent, control, tpitemname, classid)	

	local itemguid = control:GetUserValue("ITEMGUID");

	local yesScp = string.format("EXEC_INGAMESHOP_ITEM_PURCHASE(\"%s\")", itemguid);
	local txt = ScpArgMsg("AreYouSureToUse");
	ui.MsgBox(txt, yesScp, "None");

end

function EXEC_INGAMESHOP_ITEM_PURCHASE(itemguid)

	ui.BuyIngameShopItem(itemguid);
end

function UI_CHECK_SIMPLEINGAMESHOP_UI_OPEN() -- 오버라이드로 사용해라
	
	print("qweqwe")
	return 1
end