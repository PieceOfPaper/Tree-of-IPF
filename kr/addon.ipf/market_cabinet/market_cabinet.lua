
function MARKET_CABINET_ON_INIT(addon, frame)
		addon:RegisterMsg("CABINET_ITEM_LIST", "ON_CABINET_ITEM_LIST");
end

function MARKET_CABINET_OPEN(frame)
	market.ReqCabinetList();
end

function ON_CABINET_ITEM_LIST(frame)
	local itemGbox = GET_CHILD(frame, "itemGbox");
	local itemlist = GET_CHILD(itemGbox, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();

	local cnt = session.market.GetCabinetItemCount();
	for i = 0 , cnt - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local itemID = cabinetItem:GetItemID();
		local itemObj = GetIES(cabinetItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_sell_item_detail");
		ctrlSet:Resize(1350, ctrlSet:GetHeight());

		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));
		name:SetOffset(name:GetX() + 10, name:GetY());
		local itemCount = ctrlSet:GetChild("count");
		itemCount:ShowWindow(0);
		local totalPrice = ctrlSet:GetChild("totalPrice");
		totalPrice:SetTextByKey("value", cabinetItem.count);
		totalPrice:SetOffset(totalPrice:GetX() + 115, totalPrice:GetY());
		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, cabinetItem, itemObj.ClassName, "cabinet", cabinetItem.itemType, cabinetItem:GetItemID());

		local noTrade = TryGetProp(itemObj, "BelongingCount");
		if nil ~= noTrade then
			ctrlSet:SetNoTradeCount(noTrade);
		end
		
		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Receieve"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		btn:SetEventScript(ui.LBUTTONUP, "CABINET_ITEM_BUY");
		
	end
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, true, true);
	itemlist:RealignItems();
end

function CABINET_GET_ALL_ITEM(parent, ctrl)
	for i = 0 , session.market.GetCabinetItemCount() - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		market.ReqGetCabinetItem(cabinetItem:GetItemID());
	end
end

function CABINET_ITEM_BUY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	
	local row = ctrl:GetUserIValue("DETAIL_ROW");
	local col = ctrl:GetUserIValue("DETAIL_COL");
	local cabinetItem = session.market.GetCabinetItemByIndex(row);
	market.ReqGetCabinetItem(cabinetItem:GetItemID());

end


