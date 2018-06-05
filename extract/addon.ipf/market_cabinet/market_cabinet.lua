
function MARKET_CABINET_ON_INIT(addon, frame)
		addon:RegisterMsg("CABINET_ITEM_LIST", "ON_CABINET_ITEM_LIST");
end

function MARKET_CABINET_OPEN(frame)

end

function MARKET_CABINET_FIRST_OPEN(frame)

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st50}" .. ClMsg("Name"), 200);
	itemlist:AddBarInfo("Count", "{@st50}" .. ClMsg("Count"), 150);
	itemlist:AddBarInfo("Receieve", "{@st50}" .. ClMsg("Receieve"), 150);	
	
end

function MARKET_CABINET_OPEN(frame)
	market.ReqCabinetList();
end

function ON_CABINET_ITEM_LIST(frame)

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();

	local cnt = session.market.GetCabinetItemCount();

	for i = 0 , cnt - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local itemID = cabinetItem:GetItemID();
		local itemObj = GetIES(cabinetItem:GetObject());
		local itemText = INSERT_TEXT_DETAIL_LIST(itemlist, i, 0, "{@st42}" .. GET_ITEM_IMG_BY_CLS(itemObj, 32) .. " " .. GET_FULL_NAME(itemObj), "left", cabinetItem);
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	
		SET_ITEM_TOOLTIP_ALL_TYPE(itemText, cabinetItem, itemObj.ClassName, "cabinet", cabinetItem.itemType, cabinetItem:GetItemID());

		local noTrade = TryGetProp(itemObj, "BelongingCount");
		if nil ~= noTrade then
			itemText:SetNoTradeCount(noTrade);
		end
	--SET_ITEM_TOOLTIP_TYPE(itemText, cabinetItem.itemType);
	--itemText:SetTooltipArg("cabinet", cabinetItem.itemType, cabinetItem:GetItemID());
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 1, "{@st42}" .. cabinetItem.count);
		local btn = INSERT_BUTTON_DETAIL_LIST(itemlist, i, 2, "{@st42}" .. ClMsg("Receieve"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CABINET_ITEM_BUY");
		
	end
	
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



