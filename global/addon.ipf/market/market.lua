-- market.lua

function MARKET_ON_INIT(addon, frame)
	addon:RegisterMsg("MARKET_ITEM_LIST", "ON_MARKET_ITEM_LIST");
	addon:RegisterMsg("OPEN_DLG_MARKET", "ON_OPEN_MARKET");
end

function ON_OPEN_MARKET(frame)
	MARKET_BUYMODE(frame)
	MARKET_FIRST_OPEN(frame);
	ui.OpenFrame("inventory");
end

function MARKET_CLOSE(frame)
	TRADE_DIALOG_CLOSE();
end

function MARKET_CATEGORY_CLICK(frame)
end

function MARKET_TREE_CLICK(parent, ctrl, str, num)
	local tree = AUTO_CAST(ctrl);
	local tnode = tree:GetLastSelectedNode();
	if tnode == nil then
		return;
	end

	local btnName = parent:GetUserValue("CTRLNAME");
	local obj = tnode:GetObject();
	if "None" ~= btnName and obj ~= nil then
		if btnName ~= obj:GetName() then
			local htreeitem = tree:FindByName(btnName);
			local oldObj = tree:GetNodeObject(htreeitem);
			local gBox = oldObj:GetChild("group");
			gBox:SetSkinName("base_btn");
			tree:ShowTreeNode(htreeitem, 0);
			imcSound.PlaySoundEvent("button_click_roll_close");
		end
	end
	if nil ~= obj then
		parent:SetUserValue("CTRLNAME", obj:GetName());
		local gBox = obj:GetChild("group");
		gBox:SetSkinName("baseyellow_btn");
	end

	local selValue = tnode:GetValue();
	local sList = StringSplit(selValue, "#");
	if #sList <= 0 then
		return;
	end

	local grouName = sList[1];
	local categoryName = "";
	if 2 <= #sList then
		categoryName = sList[2];
		imcSound.PlaySoundEvent("button_click_4");
	else
		imcSound.PlaySoundEvent("button_click_roll_open");
	end

	local frame = parent:GetTopParentFrame();
	frame:SetUserValue("Group", grouName);
	frame:SetUserValue("ClassType", categoryName);
	MARGET_FIND_PAGE(frame, 0);
end

function MARKET_SEARCH_GROUP_AND_CLASSTYPE(frame)
	local groupName = frame:GetUserValue("Group");
	local classType = frame:GetUserValue("ClassType");
	if "None" == groupName or "None" == classType then
		groupName = "ShowAll";
		classType = "ShowAll";
	end

	return groupName, classType;
end

function MARGET_FIND_PAGE(frame, page)
	local pagecontrol = GET_CHILD(frame, "pageControl", "ui::CPageController");		
	local MaxPage = pagecontrol:GetMaxPage();
	if page >= MaxPage then
		page = MaxPage -1;
	elseif page <= 0 then
		page = 0;
	end

	local gBox = GET_CHILD(frame, "detailOption");
	local find_name = GET_CHILD(gBox, "find_edit");
	local expesive = GET_CHILD(gBox, "expensive", "ui::CCheckBox");
	local chip = GET_CHILD(gBox, "chip", "ui::CCheckBox");
	local lv_min = GET_CHILD_NUMBER_VALUE(gBox, "edit_1");
	local lv_max = GET_CHILD_NUMBER_VALUE(gBox, "edit_1_1");
	local rein_min = GET_CHILD_NUMBER_VALUE(gBox, "edit_2");
	local rein_max = GET_CHILD_NUMBER_VALUE(gBox, "edit_2_1");
	
	-- 디폴트로 최근	
	local sortype = 2;
	if 1 == chip:IsChecked() then
		sortype = 0;
	elseif 1 == expesive:IsChecked() then
		sortype = 1;
	end

	local groupName, classType = MARKET_SEARCH_GROUP_AND_CLASSTYPE(frame);
	market.ReqMarketList(page, find_name:GetText(), groupName, classType, lv_min, lv_max, rein_min, rein_max, sortype);
end

function SEARCH_ITEM_MARKET()
	local frame = ui.GetFrame("market");
	MARGET_FIND_PAGE(frame, 0);
end

function MARKET_OPTION_CHECK(frame, ctrl)
	if "chip" == ctrl:GetName() then
		local expesive = GET_CHILD(frame, "expensive", "ui::CCheckBox");
		expesive:SetCheck(0);
	else
		local chip = GET_CHILD(frame, "chip", "ui::CCheckBox");
		chip:SetCheck(0);
	end
end

function MARKET_FIRST_OPEN(frame)
	local groupBox = GET_CHILD(frame, "categoryList", "ui::CGroupBox");
	local tree = GET_CHILD(groupBox, "tree", 'ui::CTreeControl')
	groupBox:SetUserValue("CTRLNAME", "None");
	tree:Clear();

	local clslist, cnt = GetClassList("ItemCategory");
	for i = -1 , cnt - 1 do
		local group = nil;
		local cls = nil;
		local isDraw = false;
		if -1 == i then
			group = "ShowAll"
			isDraw = true;
		else
			cls = GetClassByIndexFromList(clslist, i);
			group = cls.ClassName;
			if cls.UseMarket == "YES" then
				isDraw = true;
			end
		end

		if true == isDraw then
			local subCateList = {};
			if nil ~= cls and cls.SubCategory ~= "None" then
				subCateList = StringSplit(cls.SubCategory, "/");
		end

			local ctrlSet = tree:CreateControlSet("market_tree", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
			local part = ctrlSet:GetChild("part");
			part:SetTextByKey("value", ClMsg(group));
	
			if 0 >= #subCateList then
			local foldimg = ctrlSet:GetChild("foldimg");
			foldimg:ShowWindow(0);
			tree:Add(ctrlSet,  group);
		else
			tree:Add(ctrlSet, group);
			local htreeitem = tree:FindByName(ctrlSet:GetName());
			tree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
				for j = 1 , #subCateList do
					local cate = subCateList[j]
		    	if cate ~= 'None' then
						tree:Add(htreeitem, "{@st66}"..ClMsg(cate), group.."#"..cate, "{#000000}");
		    	end
			end
		end
	end
	end

	frame:SetUserValue("Group", "ShowAll");
	frame:SetUserValue("ClassType", "ShowAll");

	GBOX_AUTO_ALIGN(tree, 0, 0, 300, true, true);
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

function MARKET_REQ_LIST(frame)
	frame = frame:GetTopParentFrame();
	frame:SetUserValue("Group", 'ShowAll');
	frame:SetUserValue("ClassType", 'ShowAll');
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

function ON_MARKET_ITEM_LIST(frame, msg, argStr, argNum)
	if frame:IsVisible() == 0 then
		return;
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_item_detail");
		ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
		ctrlSet:EnableHitTestSet(1);
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", marketItem.count);
		
		local level = ctrlSet:GetChild("level");
		level:SetTextByKey("value", itemObj.UseLv);

		local price = ctrlSet:GetChild("price");
		price:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
		price:SetUserValue("Price", marketItem.sellPrice);
		if cid == marketItem:GetSellerCID() then
			local button_1 = ctrlSet:GetChild("button_1");
			button_1:SetEnable(0);
			local button_report = ctrlSet:GetChild("button_report");
			button_report:SetEnable(0);

			local btn = ctrlSet:CreateControl("button", "DETAIL_ITEM_" .. i, 720, 8, 100, 50);
			btn = tolua.cast(btn, "ui::CButton");
			btn:ShowWindow(1);
			btn:SetText("{@st41b}" .. ClMsg("Cancel"));
			btn:SetTextAlign("center", "center");

			if notUseAnim ~= true then
				btn:SetAnimation("MouseOnAnim", "btn_mouseover");
				btn:SetAnimation("MouseOffAnim", "btn_mouseoff");
			end
			btn:UseOrifaceRectTextpack(true)
			btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
			btn:SetEventScriptArgString(ui.LBUTTONUP,marketItem:GetMarketGuid());
			btn:SetSkinName("test_pvp_btn");
			local totalPrice = ctrlSet:GetChild("totalPrice");
			totalPrice:SetTextByKey("value", 0);
		else
			local numUpDown = ctrlSet:CreateControl("numupdown", "DETAIL_ITEM_" .. i, 560, 20, 100, 30);
			numUpDown = tolua.cast(numUpDown, "ui::CNumUpDown");
			numUpDown:SetFontName("white_18_ol");
			numUpDown:MakeButtons("btn_numdown", "btn_numup", "editbox");
			numUpDown:ShowWindow(1);
			numUpDown:SetMaxValue(marketItem.count);
			numUpDown:SetMinValue(1);
			numUpDown:SetNumChangeScp("MARKET_CHANGE_COUNT");
			numUpDown:SetClickSound('button_click_chat');
			numUpDown:SetNumberValue(1)

			local totalPrice = ctrlSet:GetChild("totalPrice");
				totalPrice:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
				totalPrice:SetUserValue("Price", marketItem.sellPrice);
		end		
	end

	itemlist:RealignItems();
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);

	if nil ~= argNum and  argNum == 1 then
		MARGET_FIND_PAGE(frame, session.market.GetCurPage());
	end
end

function CANCEL_MARKET_ITEM(parent, ctrl, guid)
	local yesScp = string.format("EXEC_CANCEL_MARKET_ITEM(\"%s\")", guid);
	ui.MsgBox(ClMsg("ReallyCancelRegisteredItem"), yesScp, "None");
end

function EXEC_CANCEL_MARKET_ITEM(itemGuid)
	market.CancelMarketItem(itemGuid);
end

function MARKET_CHANGE_COUNT(ctrl)
	local frame = ctrl:GetParent();
	local priceFrame = GET_CHILD(frame, "price");
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");

	local prcie = priceFrame:GetUserIValue("Price");
	local totalPrice = GET_CHILD(frame, "totalPrice");
	totalPrice:SetTextByKey("value", GetCommaedText(tonumber(prcie) * ctrl:GetNumber()));
end

function _BUY_MARKET_ITEM(row)
	local frame = ui.GetFrame("market");

	local totalPrice = 0;
	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	market.ClearBuyInfo();

	local child = itemlist:GetChildByIndex(row);
	local childCnt = child:GetChildCount();

	for i = 0, childCnt - 1 do
		local ctrl = child:GetChildByIndex(i);
	if ctrl:GetClassName() == "numupdown" then
		local numUpDown = tolua.cast(ctrl, "ui::CNumUpDown");
		local buyCount = numUpDown:GetNumber();
		if buyCount > 0 then
				local marketItem = session.market.GetItemByIndex(row-1);
			market.AddBuyInfo(marketItem:GetMarketGuid(), buyCount);
			totalPrice = totalPrice + buyCount * marketItem.sellPrice;
		else
			ui.SysMsg(ScpArgMsg("YouCantBuyZeroItem"));
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

function BUY_MARKET_ITEM(parent, ctrl)
	local row = parent:GetUserIValue("DETAIL_ROW");
	local marketItem = session.market.GetItemByIndex(row);
	local itemObj = GetIES(marketItem:GetObject());
	local txt = ScpArgMsg("ReallyBuy?");
	if itemObj.GroupName == "Premium" then
		txt = ScpArgMsg("CannotSoldAnyMore")
	elseif itemObj.ItemType == "Equip" then
		txt = ScpArgMsg("DecreasePotaion");
	end

	ui.MsgBox(txt, string.format("_BUY_MARKET_ITEM(%d)", row+1), "None");
end

function _REPORT_MARKET_ITEM(row)

	if row == nil then
		return
	end

	local marketItem = session.market.GetItemByIndex(row-1);

	if marketItem == nil then
		return;
	end

	
	local scpString = string.format("/marketreport %s",  marketItem:GetMarketGuid());
	ui.Chat(scpString);
end

function REPORT_MARKET_ITEM(parent, ctrl)
	local row = parent:GetUserIValue("DETAIL_ROW");
	local marketItem = session.market.GetItemByIndex(row);
	local itemObj = GetIES(marketItem:GetObject());
	local txt = ScpArgMsg("ReallyReport");

	ui.MsgBox(txt, string.format("_REPORT_MARKET_ITEM(%d)", row+1), "None");
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

