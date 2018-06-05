
function MARKET_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_ITEM_LIST");
	addon:RegisterMsg("OPEN_DLG_MARKET", "ON_OPEN_MARKET");
		
end

function ON_OPEN_MARKET(frame)
	frame:ShowWindow(1);
end

function MARKET_CLOSE(frame)
	TRADE_DIALOG_CLOSE();
end

function MARKET_FIRST_OPEN(frame)

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:ClearBarInfo();
	itemlist:AddBarInfo("Name", "{@st40}" .. ClMsg("Name"), 650);
	itemlist:AddBarInfo("Level", "{@st40}" .. ClMsg("Level"), 120);
	itemlist:AddBarInfo("SellCount", "{@st40}" .. ClMsg("SellCount"), 120);
	itemlist:AddBarInfo("PricePerOne", "{@st40}" .. ClMsg("PricePerOne"), 200);
	itemlist:AddBarInfo("BuyCount", "{@st40}" .. ClMsg("BuyCount"), 120);
	itemlist:AddBarInfo("TotalPrice", "{@st40}" .. ClMsg("TotalPrice"), 200);	
	itemlist:AddBarInfo("Seller", "{@st40}" .. ClMsg("Seller"),  200);
	itemlist:AddBarInfo("ConfirmBuy", "{@st40}" .. ClMsg("ConfirmBuy"), 120);
	itemlist:LoadUserSize();
	
	local filter_category = GET_CHILD_RECURSIVELY(frame, "filter_category", "ui::CGroupBox");
	local droplist_cate = GET_CHILD(filter_category, "droplist_cate", "ui::CDropList");

	droplist_cate:ClearItems();	
	droplist_cate:AddItem("ShowAll", ClMsg("ShowAll"));
	local cnt = geItemTable.GetGroupCount();
	
	for i = 0 , cnt - 1 do
		local group = geItemTable.GetGroupByIndex(i);
		if group ~= "Money" and group ~= "Quest" and group ~= "Unused" then
			droplist_cate:AddItem(group, ClMsg(group));
		end
	end

	local droplist_align = GET_CHILD_RECURSIVELY(frame, "droplist_align");
	droplist_align:ClearItems();	
	droplist_align:AddItem("LowPriceFirst", ClMsg("LowPriceFirst"));
	droplist_align:AddItem("HighPriceFirst", ClMsg("HighPriceFirst"));
	droplist_align:AddItem("RecentFirst", ClMsg("RecentFirst"));

	MARKET_SELECT_GROUP(frame);	
end

function MARKET_SELECT_SORTTYPE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, 0);
end

function MARKET_SELECT_CLASSTYPE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, 0);
end

function MARKET_SELECT_GROUP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local filter_category = GET_CHILD_RECURSIVELY(frame, "filter_category", "ui::CGroupBox");
	local droplist_classtype = GET_CHILD(filter_category, "droplist_classtype", "ui::CDropList");
	droplist_classtype:ClearItems();
	droplist_classtype:AddItem("ShowAll", ClMsg("ShowAll"));

	local droplist_cate = GET_CHILD(filter_category, "droplist_cate", "ui::CDropList");
	local groupName = droplist_cate:GetSelItemKey();
	local scpList = geItemTable.CreateClassTypeList(groupName);
	local cnt = scpList:Count();
	for i = 0 , cnt - 1 do
		local cate = scpList:Get(i);
    	if cate ~= 'None' then
    		droplist_classtype:AddItem(cate, ClMsg(cate));
    	end
	end

	if cnt > 0 then
		droplist_classtype:ShowWindow(1);
	else
		droplist_classtype:ShowWindow(0);
	end	

	MARGET_FIND_PAGE(frame, 0);
end

function GET_CHILD_NUMBER_VALUE(parent, childName)

	local ret = parent:GetChild(childName):GetText();
	if ret == "" then
		return -1;
	end

	ret = tonumber(ret);
	if ret == nil then
		return -1;
	end

	return ret;
end

function MARGET_FIND_PAGE(frame, page)
	local filter_category = GET_CHILD_RECURSIVELY(frame, "filter_category", "ui::CGroupBox");
	local droplist_cate = GET_CHILD(filter_category, "droplist_cate", "ui::CDropList");
	local droplist_classtype = GET_CHILD(filter_category, "droplist_classtype", "ui::CDropList");
	local groupName = droplist_cate:GetSelItemKey();
	local classType = droplist_classtype:GetSelItemKey();
	if droplist_classtype:IsVisible() == 0 then
		droplist_classtype = "ShowAll";
	end

	local find = GET_CHILD_RECURSIVELY(frame, "find", "ui::CGroupBox");
	local find_name = find:GetChild("find_name");

	local filter_value = GET_CHILD_RECURSIVELY(frame, "filter_value", "ui::CGroupBox");
	local lv_min = GET_CHILD_NUMBER_VALUE(filter_value, "lv_min");
	local lv_max = GET_CHILD_NUMBER_VALUE(filter_value, "lv_max");
	local rein_min = GET_CHILD_NUMBER_VALUE(filter_value, "rein_min");
	local rein_max = GET_CHILD_NUMBER_VALUE(filter_value, "rein_max");


	local droplist_align = GET_CHILD_RECURSIVELY(frame, "droplist_align");
	local sortType = droplist_align:GetSelItemIndex();
		
	market.ReqMarketList(page, find_name:GetText(), groupName, classType, lv_min, lv_max, rein_min, rein_max, sortType);
end

function MARKET_REQ_LIST(frame)
	frame = frame:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, 0);
end

function MARKET_PAGE_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, page + 1);
end

function MARKET_PAGE_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, page - 1);
end

function MARKET_PAGE_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	MARGET_FIND_PAGE(frame, page);
end

function ON_MARKET_ITEM_LIST(frame)

	if frame:IsVisible() == 0 then
		return;
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local sysTime = geTime.GetServerSystemTime();		
	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local registerTime = marketItem:GetSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		local timeString = GET_TIME_TXT(difSec);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_item_detail");
		ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
		ctrlSet:EnableHitTestSet(1);

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

--SET_ITEM_TOOLTIP_TYPE(ctrlSet, marketItem.itemType);
--ctrlSet:SetTooltipArg("market", marketItem.itemType, marketItem:GetMarketGuid());
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local value = ctrlSet:GetChild("value");
		local desc = itemObj.Desc;
		
		SET_ITEM_DESC(value, desc, marketItem);

		--[[
		local itemText = INSERT_TEXT_DETAIL_LIST(itemlist, i, 0, "{@st40}" .. GET_ITEM_IMG_BY_CLS(itemObj, 32) .. " " .. GET_FULL_NAME(itemObj), "left");
		
		]]
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 1, "{@st40}" .. itemObj.UseLv);
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 2, "{@st40}" .. GetCommaedText(marketItem.count));
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 3, "{@st40}" .. GetCommaedText(marketItem.sellPrice));
		if cid == marketItem:GetSellerCID() then
			local btn = INSERT_BUTTON_DETAIL_LIST(itemlist,i, 4, "{@st40}" .. ClMsg("Cancel"));
			btn:UseOrifaceRectTextpack(true)
			btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		else
			local numUpDown = INSERT_NUMUPDOWN_DETAIL_LIST(itemlist, i, 4, "{@st40}" .. "0");
			numUpDown:SetMaxValue(marketItem.count);
			numUpDown:SetNumChangeScp("MARKET_CHANGE_COUNT");
			if IS_EQUIP(itemObj) == true then
				numUpDown:SetNumberValue(1)
				numUpDown:ShowWindow(0)
			end 
		end		
		
		INSERT_TEXT_DETAIL_LIST(itemlist, i, 5, "{@st40}" .. "0");
		if marketItem.isPrivate == true then
			INSERT_TEXT_DETAIL_LIST(itemlist, i, 6, "{@st40}" .. ClMsg("Private"));
		else
			INSERT_TEXT_DETAIL_LIST(itemlist, i, 6, "{@st40}" .. marketItem:GetSeller());
		end
		
		local btn = INSERT_BUTTON_DETAIL_LIST(itemlist,i, 7, "{@st40}" .. ClMsg("Buy"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "BUY_MARKET_ITEM");
	end

	itemlist:RealignItems();

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);

	local find = GET_CHILD_RECURSIVELY(frame, "find", "ui::CGroupBox");
	local buy_btn = GET_CHILD_RECURSIVELY(frame, "buy_btn", "ui::CButton");
	if buy_btn ~= nil then
		buy_btn:SetEnable(0);
	end
end

function CANCEL_MARKET_ITEM(parent, ctrl)
	local frame = ctrl:GetTopParentFrame();
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	ctrl = tolua.cast(ctrl, "ui::CButton");
	local row = ctrl:GetUserIValue("DETAIL_ROW");
	local col = ctrl:GetUserIValue("DETAIL_COL");
	local marketItem = session.market.GetItemByIndex(row);
	local yesScp = string.format("EXEC_CANCEL_MARKET_ITEM(\"%s\")", marketItem:GetMarketGuid());
	ui.MsgBox(ClMsg("ReallyCancelRegisteredItem"), yesScp, "None");
end

function EXEC_CANCEL_MARKET_ITEM(itemGuid)
	market.CancelMarketItem(itemGuid);
end

function MARKET_CHANGE_COUNT(ctrl)
	local frame = ctrl:GetTopParentFrame();
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");

	local row = ctrl:GetUserIValue("DETAIL_ROW");
	local col = ctrl:GetUserIValue("DETAIL_COL");
	local totalPriceControl = itemlist:GetObjectByRowCol(row, 5);
	local marketItem = session.market.GetItemByIndex(row);
	local totalPrice = marketItem.sellPrice * ctrl:GetNumber();
	totalPriceControl:SetText("{@st40}" .. GetCommaedText(totalPrice));
	totalPriceControl:SetTextTooltip("{@st40}" .. GetCommaedText(totalPrice));

	local find = GET_CHILD_RECURSIVELY(frame, "find", "ui::CGroupBox");
	local buy_btn = GET_CHILD_RECURSIVELY(frame, "buy_btn", "ui::CButton");
	if buy_btn ~= nil then
		if totalPrice > 0 then
			buy_btn:SetEnable(1);
		else
			buy_btn:SetEnable(0);
		end
	end
end

function _BUY_MARKET_ITEM(row)
	local frame = ui.GetFrame("market");

	local totalPrice = 0;
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");

	market.ClearBuyInfo();

	local ctrl = itemlist:GetObjectByRowCol(row, 4);
	if ctrl:GetClassName() == "numupdown" then
		local numUpDown = tolua.cast(ctrl, "ui::CNumUpDown");
		local buyCount = numUpDown:GetNumber();
		if buyCount > 0 then
			local marketItem = session.market.GetItemByIndex(row);
			market.AddBuyInfo(marketItem:GetMarketGuid(), buyCount);
			totalPrice = totalPrice + buyCount * marketItem.sellPrice;
		else
			ui.SysMsg(ScpArgMsg("YouCantBuyZeroItem"));
		end
	end

	if totalPrice == 0 then
		return;
	end

	local myMoney = GET_TOTAL_MONEY();
	if totalPrice > myMoney then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	market.ReqBuyItems();

end

function BUY_MARKET_ITEM(parent, ctrl)
	
	local row = ctrl:GetUserIValue("DETAIL_ROW");
	ui.MsgBox(ScpArgMsg("ReallyBuy?"), string.format("_BUY_MARKET_ITEM(%d)", row), "None");
	
end

function MARKET_EXEC_BUY(frame)

	local totalPrice = 0;

	frame = frame:GetTopParentFrame();
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	local count = session.market.GetItemCount();

	market.ClearBuyInfo();

	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local ctrl = itemlist:GetObjectByRowCol(i, 4);
		if ctrl:GetClassName() == "numupdown" then
			local numUpDown = tolua.cast(ctrl, "ui::CNumUpDown");
			local buyCount = numUpDown:GetNumber();
			if buyCount > 0 then
				market.AddBuyInfo(marketItem:GetMarketGuid(), buyCount);
				totalPrice = totalPrice + buyCount * marketItem.sellPrice;
			end
		end
	end

	if totalPrice == 0 then
		return;
	end

	local myMoney = GET_TOTAL_MONEY();
	if totalPrice > myMoney then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end

	market.ReqBuyItems();
end

function MARKET_SELLMODE(frame)
	ui.CloseFrame("market");
	ui.CloseFrame("market_cabinet");
	ui.OpenFrame("market_sell");
	ui.OpenFrame("inventory");
end

function MARKET_BUYMODE(frame)
	ui.OpenFrame("market");
	ui.CloseFrame("market_sell");
	ui.CloseFrame("market_cabinet");
end

function MARKET_CABINET_MODE(frame)
	ui.CloseFrame("market");
	ui.CloseFrame("market_sell");
	ui.OpenFrame("market_cabinet");
end

