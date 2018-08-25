-- market.lua

g_titleGboxList = {"defaultTitle", "equipTitle", "recipeTitle", "accessoryTitle", "gemTitle", "cardTitle", "exporbTitle"};

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

	local groupName = sList[1];
	local categoryName = "";
	if 2 <= #sList then
		categoryName = sList[2];
		imcSound.PlaySoundEvent("button_click_4");
	else
		imcSound.PlaySoundEvent("button_click_roll_open");
	end

	local frame = parent:GetTopParentFrame();
	frame:SetUserValue("isRecipeSearching", 0)
	frame:SetUserValue("searchListIndex", 0)
	frame:SetUserValue("Group", groupName);
	frame:SetUserValue("ClassType", categoryName);

	MARKET_FIND_PAGE(frame, 0);
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

function MARKET_FIND_PAGE(frame, page)
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
	local findItem = tostring(find_name:GetText())
	local minLength = 0
	local findItemStrLength = findItem.len(findItem);
	local maxLength = 60
	if config.GetServiceNation() == "GLOBAL" then
		minLength = 1
		maxLength = 20
	elseif config.GetServiceNation() == "JPN" then
		maxLength = 60
	elseif config.GetServiceNation() == "KOR" then
		maxLength = 60
	end

	if findItemStrLength ~= 0 then	-- 있다면 길이 조건 체크
		if findItemStrLength <= minLength then
			ui.SysMsg(ClMsg("InvalidFindItemQueryMin"));
		elseif findItemStrLength > maxLength then
			ui.SysMsg(ClMsg("InvalidFindItemQueryMax"));
	    else 
	        market.ReqMarketList(page, find_name:GetText(), groupName, classType, lv_min, lv_max, rein_min, rein_max, sortype);
        end
	else  -- 검색어가 없으면 바로 검색...
		market.ReqMarketList(page, find_name:GetText(), groupName, classType, lv_min, lv_max, rein_min, rein_max, sortype);
	end	
end

function RECIPE_SEARCH_FIND_PAGE(frame, page)
	local pagecontrol = GET_CHILD(frame, "pagecontrol_material", "ui::CPageController");		
	local MaxPage = pagecontrol:GetMaxPage();
	if page >= MaxPage then
		page = MaxPage -1;
	elseif page <= 0 then
		page = 0;
	end

	local recipeSearchGbox = GET_CHILD_RECURSIVELY(frame, "recipeSearchGbox")
	local itemClassName = recipeSearchGbox:GetUserValue("itemClassName")

	local recipeCls = GetClass("Recipe", itemClassName)
	if recipeCls == nil then
		return
	end

	local materialList = ""
	local maxRecipeMaterialCount = MAX_RECIPE_MATERIAL_COUNT
	for i = 1, maxRecipeMaterialCount do
		local materialItem = recipeCls["Item_" .. i .. "_1"]
		if materialItem ~= nil and materialItem ~= "None" then
			local itemCls = GetClass("Item", materialItem)
			materialList = materialList .. itemCls.ClassID .. "#"
			local materialCnt = recipeCls["Item_" .. i .. "_1_Cnt"]
		end
	end

	market.ReqRecipeSearchList(page, materialList)
end

function SEARCH_ITEM_MARKET()
	local frame = ui.GetFrame("market");
	MARKET_FIND_PAGE(frame, 0);
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

function MARKET_CLEAR_RECIPE_SEARCHLIST(frame)
	local recipeGboxHeight = frame:GetUserConfig("RECIPE_BG_HEIGHT")

	local recipeBG = GET_CHILD_RECURSIVELY(frame, "market_midle3")
	local recipeGbox = GET_CHILD_RECURSIVELY(frame, "itemListGbox")
	local materialBG = GET_CHILD_RECURSIVELY(frame, "market_material_bg")
	local materialGbox = GET_CHILD_RECURSIVELY(frame, "recipeSearchGbox")
	local pageControl = GET_CHILD_RECURSIVELY(frame, "pagecontrol")
	local recipePageControl = GET_CHILD_RECURSIVELY(frame, "pagecontrol_recipe")
	local recipeSearchTitle = GET_CHILD_RECURSIVELY(frame, "recipeSearchTitle")
	local materialPageControl = GET_CHILD_RECURSIVELY(frame, "pagecontrol_material")
	local recipeSearchTemp = GET_CHILD_RECURSIVELY(frame, "recipeSearchTemp")

	materialBG:ShowWindow(0)
	materialGbox:ShowWindow(0)
	recipeSearchTitle:ShowWindow(0)
	local margin = recipePageControl:GetOriginalMargin()
	recipePageControl:ShowWindow(0)
	recipeBG:Resize(recipeBG:GetWidth(), recipeGboxHeight)
	recipeGbox:Resize(recipeGbox:GetWidth(), recipeGboxHeight - 35)
	materialPageControl:ShowWindow(0)
	recipeSearchTemp:ShowWindow(0)
	pageControl:ShowWindow(1)

	frame:SetUserValue("searchListIndex", 0)
	frame:SetUserValue("isRecipeSearching", 0) 

end

function MARKET_FIRST_OPEN(frame)
	local groupBox = GET_CHILD(frame, "categoryList", "ui::CGroupBox");
	local tree = GET_CHILD(groupBox, "tree", 'ui::CTreeControl')
	groupBox:SetUserValue("CTRLNAME", "None");
	tree:Clear();

	MARKET_CLEAR_RECIPE_SEARCHLIST(frame)

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

	tree:SetFitToChild(true, 5);
	frame:SetUserValue("Group", "ShowAll");
	frame:SetUserValue("ClassType", "ShowAll");

	GBOX_AUTO_ALIGN(tree, 0, 0, 0, true, false);
end

function MARKET_SELECT_SORTTYPE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	MARKET_FIND_PAGE(frame, 0);
end

function MARKET_SELECT_CLASSTYPE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	MARKET_FIND_PAGE(frame, 0);
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

	MARKET_FIND_PAGE(frame, 0);
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
	-- 마켓 이용 중에는 자동매칭중이면 간소화!
	local indunenter = ui.GetFrame('indunenter');
	if indunenter ~= nil and indunenter:IsVisible() == 1 then
		INDUNENTER_SMALL(indunenter, nil, true);
	end

	frame = frame:GetTopParentFrame();
	frame:SetUserValue("Group", 'ShowAll');
	frame:SetUserValue("ClassType", 'ShowAll');
	MARKET_FIND_PAGE(frame, 0);
end

function MARKET_PAGE_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();	
	MARKET_FIND_PAGE(frame, page);
end

function MARKET_PAGE_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	MARKET_FIND_PAGE(frame, page);
end

function MARKET_PAGE_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	MARKET_FIND_PAGE(frame, page);
end

function RECIPE_SEARCH_PAGE_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	frame:SetUserValue("isRecipeSearching", 2)
	MARKET_FIND_PAGE(frame, page);
end

function RECIPE_SEARCH_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	frame:SetUserValue("isRecipeSearching", 2)
	MARKET_FIND_PAGE(frame, page);
end

function RECIPE_SEARCH_PAGE_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	frame:SetUserValue("isRecipeSearching", 2)
	MARKET_FIND_PAGE(frame, page);
end

function MATERIAL_SEARCH_PAGE_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	RECIPE_SEARCH_FIND_PAGE(frame, page);
end

function MATERIAL_SEARCH_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	RECIPE_SEARCH_FIND_PAGE(frame, page);
end

function MATERIAL_SEARCH_PAGE_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage();
	local frame = pageControl:GetTopParentFrame();
	RECIPE_SEARCH_FIND_PAGE(frame, page);
end

function ON_MARKET_ITEM_LIST(frame, msg, argStr, argNum)
	if frame:IsVisible() == 0 then
		return;
	end

	local groupName = frame:GetUserValue("Group")
	local isRecipeSearching = frame:GetUserIValue("isRecipeSearching")
	if isRecipeSearching == 1 then
		MARKET_DRAW_CTRLSET_RECIPE_SEARCHLIST(frame)
	elseif isRecipeSearching == 2 then   --제작서 재료 검색후 제작서 페이지 넘기는 경우
		MARKET_DRAW_CTRLSET_RECIPE(frame)
	else
		MARKET_CLEAR_RECIPE_SEARCHLIST(frame)

		if groupName == "ShowAll" then
			MARKET_DRAW_CTRLSET_DEFAULT(frame)
		elseif groupName == "Weapon" or groupName == "SubWeapon" then
			MARKET_DRAW_CTRLSET_EQUIP(frame)
		elseif groupName == "Armor" then
			MARKET_DRAW_CTRLSET_EQUIP(frame)
		elseif groupName == "Recipe" then
			MARKET_DRAW_CTRLSET_RECIPE(frame)
		elseif groupName == "Accessory" then
			MARKET_DRAW_CTRLSET_ACCESSORY(frame)
		elseif groupName == "Gem" then
			MARKET_DRAW_CTRLSET_GEM(frame)
		elseif groupName == "Card" then
			MARKET_DRAW_CTRLSET_CARD(frame)
		elseif groupName == "ExpOrb" then
			MARKET_DRAW_CTRLSET_EXPORB(frame)
		else
			MARKET_DRAW_CTRLSET_DEFAULT(frame, false)
		end

		if nil ~= argNum and argNum == 1 then
			MARKET_FIND_PAGE(frame, session.market.GetCurPage());
		end
	end
end

local function MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem)
	local pic = GET_CHILD_RECURSIVELY(ctrlSet, "pic");
	SET_SLOT_ITEM_CLS(pic, itemObj)
	SET_ITEM_TOOLTIP_ALL_TYPE(pic:GetIcon(), marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

    SET_SLOT_STYLESET(pic, itemObj)
    if itemObj.MaxStack > 1 then
		SET_SLOT_COUNT_TEXT(pic, marketItem.count, '{s16}{ol}{b}');
	end
end

function MARKET_DRAW_CTRLSET_DEFAULT(frame, isShowLevel)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "defaultTitle")
	local defaultTitle_level = GET_CHILD_RECURSIVELY(frame, "defaultTitle_level")
	if isShowLevel ~= nil and isShowLevel == false then
		defaultTitle_level:ShowWindow(0)
	else
		defaultTitle_level:ShowWindow(1)
	end

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_default", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		if itemObj.GroupName == "ExpOrb" then
			local curExp, maxExp = GET_LEGENDEXPPOTION_EXP(itemObj)
			local expPoint = 0
			if maxExp ~= nil and maxExp ~= 0 then
				expPoint = curExp / maxExp * 100
			else 
				expPoint = 0
			end
			local expStr = string.format("%.2f", expPoint)

			MARKET_SET_EXPORB_ICON(ctrlSet, curExp, maxExp, itemObj)
		end

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local level = ctrlSet:GetChild("level");
		local levelValue = ""
		if itemObj.GroupName == "Gem" then
			levelValue = GET_ITEM_LEVEL_EXP(itemObj)
		elseif itemObj.GroupName == "Card" then
			levelValue = itemObj.Level
		elseif itemObj.ItemType == "Equip" and itemObj.GroupName ~= "Premium" then
			levelValue = itemObj.UseLv
		end
		level:SetTextByKey("value", levelValue);

		local price_num = ctrlSet:GetChild("price_num");
		price_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
		price_num:SetUserValue("Price", marketItem.sellPrice);

		local price_text = ctrlSet:GetChild("price_text");
		price_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local editCount = GET_CHILD_RECURSIVELY(ctrlSet, "count")
			editCount:SetMinNumber(1)
			editCount:SetMaxNumber(marketItem.count)
			editCount:SetText("1")
			editCount:SetNumChangeScp("MARKET_CHANGE_COUNT");
			ctrlSet:SetUserValue("minItemCount", 1)
			ctrlSet:SetUserValue("maxItemCount", marketItem.count)
			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end


function MARKET_DRAW_CTRLSET_EQUIP(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "equipTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_equip", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);
		ctrlSet:SetUserValue("optionIndex", 0)

		local inheritanceItem = GetClass('Item', itemObj.InheritanceItemName)
		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = GET_CHILD_RECURSIVELY(ctrlSet, "name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local level = GET_CHILD_RECURSIVELY(ctrlSet, "level");
		level:SetTextByKey("value", itemObj.UseLv);

		--ATK, MATK, DEF 
		local atkdefImageSize = ctrlSet:GetUserConfig("ATKDEF_IMAGE_SIZE")
 		local basicProp = 'None';
 		local atkdefText = "";
    	if itemObj.BasicTooltipProp ~= 'None' then
    		local basicTooltipPropList = StringSplit(itemObj.BasicTooltipProp, ';');
    	    for i = 1, #basicTooltipPropList do
    	        basicProp = basicTooltipPropList[i];
    	        if basicProp == 'ATK' then
				    typeiconname = 'test_sword_icon'
					typestring = ScpArgMsg("Melee_Atk")
					if TryGetProp(itemObj, 'EquipGroup') == "SubWeapon" then
						typestring = ScpArgMsg("PATK_SUB")
					end
					arg1 = itemObj.MINATK;
					arg2 = itemObj.MAXATK;
				elseif basicProp == 'MATK' then
				    typeiconname = 'test_sword_icon'
					typestring = ScpArgMsg("Magic_Atk")
					arg1 = itemObj.MATK;
					arg2 = itemObj.MATK;
				else
					typeiconname = 'test_shield_icon'
					typestring = ScpArgMsg(basicProp);
					if itemObj.RefreshScp ~= 'None' then
						local scp = _G[itemObj.RefreshScp];
						if scp ~= nil then
							scp(itemObj);
						end
					end
					
					arg1 = TryGetProp(itemObj, basicProp);
					arg2 = TryGetProp(itemObj, basicProp);
				end

				local tempStr = string.format("{img %s %d %d}", typeiconname, atkdefImageSize, atkdefImageSize)
				local tempATKDEF = ""
				if arg1 == arg2 or arg2 == 0 then
					tempATKDEF = " " .. arg1
				else
					tempATKDEF = " " .. arg1 .. "~" .. arg2
				end

				if i == 1 then
					atkdefText = atkdefText .. tempStr .. typestring .. tempATKDEF
				else
					atkdefText = atkdefText .. "{nl}" .. tempStr .. typestring .. tempATKDEF
				end
    	    end
   		end

    	local atkdef = GET_CHILD_RECURSIVELY(ctrlSet, "atkdef");
		atkdef:SetTextByKey("value", atkdefText);

		--SOCKET

		local socket = GET_CHILD_RECURSIVELY(ctrlSet, "socket")
		
		local needAppraisal = TryGetProp(itemObj, "NeedAppraisal");
		local needRandomOption = TryGetProp(itemObj, "NeedRandomOption");
			local maxSocketCount = itemObj.MaxSocket
			local drawFlag = 0
			if maxSocketCount > 3 then
				drawFlag = 1
			end

			local curCount = 1
			local socketText = ""
			local tempStr = ""
			for i = 0, maxSocketCount - 1 do
				if itemObj['Socket_' .. i] > 0 then
					
					local isEquip = itemObj['Socket_Equip_' .. i]
					if isEquip == 0 then
						tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_EMPTY")
						if drawFlag == 1 and curCount % 2 == 1 then
							socketText = socketText .. tempStr
						else
							socketText = socketText .. tempStr .. "{nl}"
						end
					else
						local gemClass = GetClassByType("Item", isEquip);
						if gemClass.ClassName == 'gem_circle_1' then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_RED")
						elseif gemClass.ClassName == 'gem_square_1' then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_BLUE")
						elseif gemClass.ClassName == 'gem_diamond_1' then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_GREEN")
						elseif gemClass.ClassName == 'gem_star_1' then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_YELLOW")
						elseif gemClass.ClassName == 'gem_White_1' then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_WHITE")
						elseif gemClass.EquipXpGroup == "Gem_Skill" then
							tempStr = ctrlSet:GetUserConfig("SOCKET_IMAGE_MONSTER")
						end
						
						local gemLv = GET_ITEM_LEVEL_EXP(gemClass, itemObj['SocketItemExp_' .. i])
						tempStr = tempStr .. "Lv" .. gemLv

						if drawFlag == 1 and curCount % 2 == 1 then
							socketText = socketText .. tempStr
						else
							socketText = socketText .. tempStr .. "{nl}"
						end
					end									
				end
				curCount = curCount + 1
			end
			socket:SetTextByKey("value", socketText)

		-- POTENTIAL

		local potential = GET_CHILD_RECURSIVELY(ctrlSet, "potential");
		if needAppraisal == 1 then
			potential:SetTextByKey("value1", "?")
			potential:SetTextByKey("value2", "?")			
		else
			potential:SetTextByKey("value1", itemObj.PR)
			potential:SetTextByKey("value2", itemObj.MaxPR)
		end

		-- OPTION

		local originalItemObj = itemObj
		if inheritanceItem ~= nil then
			itemObj = inheritanceItem
		end

		if needAppraisal == 1 or needRandomOption == 1 then
			SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, '{@st66b}'..ScpArgMsg("AppraisalItem"))
		end

		local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(itemObj);
	    local list = {};
    	local basicTooltipPropList = StringSplit(itemObj.BasicTooltipProp, ';');
    	for i = 1, #basicTooltipPropList do
    	    local basicTooltipProp = basicTooltipPropList[i];
    	    list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list);
    	end

		local list2 = GET_EUQIPITEM_PROP_LIST();
		local cnt = 0;
		local class = GetClassByType("Item", itemObj.ClassID);

		local maxRandomOptionCnt = MAX_OPTION_EXTRACT_COUNT;
		local randomOptionProp = {};
		for i = 1, maxRandomOptionCnt do
			if itemObj['RandomOption_'..i] ~= 'None' then
				randomOptionProp[itemObj['RandomOption_'..i]] = itemObj['RandomOptionValue_'..i];
			end
		end

		for i = 1 , #list do
			local propName = list[i];
			local propValue = class[propName];

			local needToShow = true;
			for j = 1, #basicTooltipPropList do
				if basicTooltipPropList[j] == propName then
					needToShow = false;
				end
			end

			if needToShow == true and propValue ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음
				if  itemObj.GroupName == 'Weapon' then
					if propName ~= "MINATK" and propName ~= 'MAXATK' then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);			
						SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
					end
				elseif  itemObj.GroupName == 'Armor' then
					if itemObj.ClassType == 'Gloves' then
						if propName ~= "HR" then
							local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
							SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
						end
					elseif itemObj.ClassType == 'Boots' then
						if propName ~= "DR" then
							local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
							SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
						end
					else
						if propName ~= "DEF" then
							local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
							SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
						end
					end
				else
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
					SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
				end
			end
		end

		for i = 1 , 3 do
			local propName = "HatPropName_"..i;
			local propValue = "HatPropValue_"..i;
			if itemObj[propValue] ~= 0 and itemObj[propName] ~= "None" then
				local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(itemObj[propName]));
				local strInfo = ABILITY_DESC_PLUS(opName, itemObj[propValue]);
				SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
			end
		end
	
		for i = 1 , maxRandomOptionCnt do
		    local propGroupName = "RandomOptionGroup_"..i;
			local propName = "RandomOption_"..i;
			local propValue = "RandomOptionValue_"..i;
			local clientMessage = 'None'

			local propItem = originalItemObj

			if propItem[propGroupName] == 'ATK' then
			    clientMessage = 'ItemRandomOptionGroupATK'
			elseif propItem[propGroupName] == 'DEF' then
			    clientMessage = 'ItemRandomOptionGroupDEF'
			elseif propItem[propGroupName] == 'UTIL_WEAPON' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif propItem[propGroupName] == 'UTIL_ARMOR' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif propItem[propGroupName] == 'UTIL_SHILED' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif propItem[propGroupName] == 'STAT' then
			    clientMessage = 'ItemRandomOptionGroupSTAT'
			end
			
			if propItem[propValue] ~= 0 and propItem[propName] ~= "None" then
				local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(propItem[propName]));
				local strInfo = ABILITY_DESC_NO_PLUS(opName, propItem[propValue], 0);
				SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
			end
		end

		for i = 1 , #list2 do
			local propName = list2[i];
			local propValue = itemObj[propName];
			if propValue ~= 0 then
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemObj[propName]);
				SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
			end
		end

		if itemObj.OptDesc ~= nil and itemObj.OptDesc ~= 'None' then
			SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, itemObj.OptDesc);
		end
		
        if originalItemObj['RandomOptionRareValue'] ~= 0 and originalItemObj['RandomOptionRare'] ~= "None" then
			local strInfo = _GET_RANDOM_OPTION_RARE_CLIENT_TEXT(originalItemObj['RandomOptionRare'], originalItemObj['RandomOptionRareValue'], '');
            if strInfo ~= nil then
			    SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
            end
		end
		
		if inheritanceItem == nil then
		if itemObj.IsAwaken == 1 then
			local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(itemObj.HiddenProp));
			local strInfo = ABILITY_DESC_PLUS(opName, itemObj.HiddenPropValue);
				SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
			end
		else
			if inheritanceItem.IsAwaken == 1 then
				local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(inheritanceItem.HiddenProp));
				local strInfo = ABILITY_DESC_PLUS(opName, inheritanceItem.HiddenPropValue);
				SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
			end
		end

		if itemObj.ReinforceRatio > 100 then
			local opName = ClMsg("ReinforceOption");
			local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * itemObj.ReinforceRatio/100));
			SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, strInfo);
		end



		-- 내 판매리스트 처리

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = GET_CHILD_RECURSIVELY(ctrlSet, "reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local totalPrice_num = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, true, false)

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end

function SET_MARKET_EQUIP_CTRLSET_OPTION_TEXT(ctrlSet, str)
	local index = ctrlSet:GetUserIValue("optionIndex")
	local optionText = GET_CHILD_RECURSIVELY(ctrlSet, "randomoption_" .. index)

	optionText:SetTextByKey("value", str)
	if index < 7 then
		ctrlSet:SetUserValue("optionIndex", index + 1)
	end
end

function MARKET_DRAW_CTRLSET_RECIPE(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "recipeTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_recipe", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);
		ctrlSet:SetUserValue("itemClassName", itemObj.ClassName)

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", marketItem.count);
		
		local price_num = ctrlSet:GetChild("price_num");
		price_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
		price_num:SetUserValue("Price", marketItem.sellPrice);

		local price_text = ctrlSet:GetChild("price_text");
		price_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local editCount = GET_CHILD_RECURSIVELY(ctrlSet, "count")
			editCount:SetMinNumber(1)
			editCount:SetMaxNumber(marketItem.count)
			editCount:SetText("1")
			editCount:SetNumChangeScp("MARKET_CHANGE_COUNT");
			ctrlSet:SetUserValue("minItemCount", 1)
			ctrlSet:SetUserValue("maxItemCount", marketItem.count)
			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("marketItemGuid", marketItem:GetMarketGuid())
		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	local itemlistHeight = itemlist:GetHeight()
	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);
	if frame:GetUserIValue("isRecipeSearching") == 2 then
		frame:SetUserValue("isRecipeSearching", 1)
		local maxPage_recipe = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
		local curPage_recipe = session.market.GetCurPage();
		local pagecontrol_recipe = GET_CHILD(frame, 'pagecontrol_recipe', 'ui::CPageController')
	    if maxPage_recipe < 1 then
	        maxPage_recipe = 1;
	    end

		pagecontrol_recipe:SetMaxPage(maxPage_recipe);
		pagecontrol_recipe:SetCurPage(curPage_recipe);
	end
	itemlist:Resize(itemlist:GetWidth(), itemlistHeight)
	
	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end

function MARKET_DRAW_CTRLSET_RECIPE_SEARCH(ctrlSet)
	local frame = ui.GetFrame("market")
	if frame == nil then
		return
	end

	local searchBtn = GET_CHILD_RECURSIVELY(ctrlSet, "searchBtn");
	ui.DisableForTime(searchBtn, 1.5);

	frame:SetUserValue("isRecipeSearching", 1)
	frame:SetUserValue("searchListIndex", 0)

	local recipeBG = GET_CHILD_RECURSIVELY(frame, "market_midle3")
	local recipeGbox = GET_CHILD_RECURSIVELY(frame, "itemListGbox")
	local market_low = GET_CHILD_RECURSIVELY(frame, "market_low")
	local materialBG = GET_CHILD_RECURSIVELY(frame, "market_material_bg")
	local materialGbox = GET_CHILD_RECURSIVELY(frame, "recipeSearchGbox")
	local pageControl = GET_CHILD_RECURSIVELY(frame, "pagecontrol")
	local recipePageControl = GET_CHILD_RECURSIVELY(frame, "pagecontrol_recipe")
	local recipeSearchTitle = GET_CHILD_RECURSIVELY(frame, "recipeSearchTitle")
	local recipeSearchTemp = GET_CHILD_RECURSIVELY(frame, "recipeSearchTemp")

	materialBG:ShowWindow(1)
	materialGbox:ShowWindow(1)
	recipeSearchTitle:ShowWindow(1)
	materialGbox:SetUserValue("yPos", 0)
	materialGbox:RemoveAllChild();

	recipeBG:Resize(recipeBG:GetWidth(), market_low:GetHeight()/3 + 13)
	recipeGbox:Resize(recipeGbox:GetWidth(), market_low:GetHeight()/3 - 22)
	recipePageControl:ShowWindow(1)
	recipeSearchTemp:ShowWindow(1)
	pageControl:ShowWindow(0)

	local itemClassName = ctrlSet:GetUserValue("itemClassName")
	materialGbox:SetUserValue("itemClassName", itemClassName)
	local recipeCls = GetClass("Recipe", itemClassName)
	if recipeCls == nil then
		return
	end

	local materialList = ""
	local maxRecipeMaterialCount = MAX_RECIPE_MATERIAL_COUNT
	for i = 1, maxRecipeMaterialCount do
		local materialItem = recipeCls["Item_" .. i .. "_1"]
		if materialItem ~= nil and materialItem ~= "None" then
			local itemCls = GetClass("Item", materialItem)
			materialList = materialList .. itemCls.ClassID .. "#"
			local materialCnt = recipeCls["Item_" .. i .. "_1_Cnt"]
		end
end

	market.ReqRecipeSearchList(0, materialList)
end


function MARKET_DRAW_CTRLSET_RECIPE_SEARCHLIST(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "recipeSearchGbox");
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetRecipeSearchItemCount();

	DESTROY_CHILD_BYNAME(itemlist, "ITEM_MATERIAL_")

	local yPos = 0
	local index = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetRecipeSearchByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	
		
		local ctrlSet = itemlist:CreateControlSet("market_item_detail_default", "ITEM_MATERIAL_" .. index, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)

		ctrlSet:SetUserValue("marketRecipeSearchGuid", marketItem:GetMarketGuid())
		ctrlSet:SetUserValue("DETAIL_ROW", index);
		index = index + 1
		frame:SetUserValue("searchListIndex", index)

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", marketItem.count);
		
		local level = ctrlSet:GetChild("level");
		level:SetTextByKey("value", itemObj.UseLv);

		local price_num = ctrlSet:GetChild("price_num");
		price_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
		price_num:SetUserValue("Price", marketItem.sellPrice);

		local price_text = ctrlSet:GetChild("price_text");
		price_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));

		local reportBtn = ctrlSet:GetChild("reportBtn")
		reportBtn:ShowWindow(0)

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(0)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local editCount = GET_CHILD_RECURSIVELY(ctrlSet, "count")
			editCount:SetMinNumber(1)
			editCount:SetMaxNumber(marketItem.count)
			editCount:SetText("1")
			editCount:SetNumChangeScp("MARKET_CHANGE_COUNT");
			ctrlSet:SetUserValue("minItemCount", 1)
			ctrlSet:SetUserValue("maxItemCount", marketItem.count)
			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, true, false);

	local maxPage_recipe = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage_recipe = session.market.GetCurPage();
	local pagecontrol_recipe = GET_CHILD(frame, 'pagecontrol_recipe', 'ui::CPageController')
    if maxPage_recipe < 1 then
        maxPage_recipe = 1;
    end

	pagecontrol_recipe:SetMaxPage(maxPage_recipe);
	pagecontrol_recipe:SetCurPage(curPage_recipe);


	local maxPage_material = math.ceil(session.market.GetRecipeSearchCount() / RECIPE_SEARCH_COUNT_PER_PAGE);
	local curPage_material = session.market.GetRecipeSearchPage();

	local pagecontrol_material = GET_CHILD(frame, 'pagecontrol_material', 'ui::CPageController')
	pagecontrol_material:ShowWindow(1)
    if maxPage_material < 1 then
        maxPage_material = 1;
    end

	pagecontrol_material:SetMaxPage(maxPage_material);
	pagecontrol_material:SetCurPage(curPage_material);

end




function MARKET_DRAW_CTRLSET_ACCESSORY(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "accessoryTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_accessory", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local enchantOption = ""
		local strInfo = ""
		for j = 1 , 3 do
			local propName = "HatPropName_"..j;
			local propValue = "HatPropValue_"..j;
			if itemObj[propValue] ~= 0 and itemObj[propName] ~= "None" then
				enchantOption = ScpArgMsg(itemObj[propName]);
				if j == 1 then
					strInfo = strInfo .. ABILITY_DESC_PLUS(enchantOption, itemObj[propValue]);
				else
					strInfo = strInfo .. "{nl} " .. ABILITY_DESC_PLUS(enchantOption, itemObj[propValue]);
				end
			end
		end

		local enchantText = GET_CHILD_RECURSIVELY(ctrlSet, "enchant")
		enchantText:SetTextByKey("value", strInfo)

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end



function MARKET_DRAW_CTRLSET_GEM(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "gemTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_gem", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local gemLevel = GET_CHILD_RECURSIVELY(ctrlSet, "gemLevel")
		local gemLevelValue = GET_ITEM_LEVEL_EXP(itemObj)
		gemLevel:SetTextByKey("value", gemLevelValue)

		local gemRoastingLevel = TryGetProp(itemObj, 'GemRoastingLv', 0);
		local roastingLevel = GET_CHILD_RECURSIVELY(ctrlSet, "roastingLevel")
		roastingLevel:SetTextByKey("value", gemRoastingLevel)

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end


function MARKET_DRAW_CTRLSET_CARD(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "cardTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_card", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		local level = GET_CHILD_RECURSIVELY(ctrlSet, "level")
		level:SetTextByKey("value", itemObj.Level)

		local option = GET_CHILD_RECURSIVELY(ctrlSet, "option")

		local tempText1 = itemObj.Desc;
		if itemObj.Desc == "None" then
			tempText1 = "";
		end

		local textDesc = string.format("%s", tempText1)	
		option:SetTextByKey("value", textDesc);

		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end


function MARKET_DRAW_CTRLSET_EXPORB(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local count = session.market.GetItemCount();

	MARKET_SELECT_SHOW_TITLE(frame, "exporbTitle")

	local yPos = 0
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = itemlist:CreateControlSet("market_item_detail_exporb", "ITEM_EQUIP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, yPos);
		AUTO_CAST(ctrlSet)
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		MARKET_CTRLSET_SET_ICON(ctrlSet, itemObj, marketItem);

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));


		local curExp, maxExp = GET_LEGENDEXPPOTION_EXP(itemObj)
		local expPoint = 0
		if maxExp ~= nil and maxExp ~= 0 then
			expPoint = curExp / maxExp * 100
		else 
			expPoint = 0
		end
		local expStr = string.format("%.2f", expPoint)

		MARKET_SET_EXPORB_ICON(ctrlSet, curExp, maxExp, itemObj)


		local exp = GET_CHILD_RECURSIVELY(ctrlSet, "exp")
		exp:SetTextByKey("value", expStr .. "%")


		if cid == marketItem:GetSellerCID() then
			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(0)
			buyBtn:SetEnable(0);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(1)
			cancelBtn:SetEnable(1)

			if USE_MARKET_REPORT == 1 then
				local reportBtn = ctrlSet:GetChild("reportBtn");
				reportBtn:SetEnable(0);
			end

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", 0);
			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", 0);
		else

			local buyBtn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
			buyBtn:ShowWindow(1)
			buyBtn:SetEnable(1);
			local cancelBtn = GET_CHILD_RECURSIVELY(ctrlSet, "cancelBtn");
			cancelBtn:ShowWindow(0)
			cancelBtn:SetEnable(0)

			local totalPrice_num = ctrlSet:GetChild("totalPrice_num");
			totalPrice_num:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
			totalPrice_num:SetUserValue("Price", marketItem.sellPrice);

			local totalPrice_text = ctrlSet:GetChild("totalPrice_text");
			totalPrice_text:SetTextByKey("value", GetMonetaryString(marketItem.sellPrice));
			
		end		

		ctrlSet:SetUserValue("sellPrice", marketItem.sellPrice)
	end

	GBOX_AUTO_ALIGN(itemlist, 4, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
    if maxPage < 1 then
        maxPage = 1;
    end

	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);
end

function MARKET_SET_EXPORB_ICON(ctrlSet, curExp, maxExp, itemObj)
	local pic = GET_CHILD_RECURSIVELY(ctrlSet, "pic");
	if curExp == maxExp then
		local fullImage = GET_LEGENDEXPPOTION_ICON_IMAGE_FULL(itemObj);
		local icon = pic:GetIcon()
		if icon ~= nil then
			icon:SetImage(fullImage)
		end
	end
end

function MARKET_SELECT_SHOW_TITLE(frame, titleName)
	frame = ui.GetFrame("market")
	if titleName == nil or titleName == "" then
		return
	end

	for i = 1, #g_titleGboxList do
		local visible = 0
		local tempTitle = g_titleGboxList[i]
		if titleName == tempTitle then
			visible = 1
		end
		local tempTitleGbox = GET_CHILD_RECURSIVELY(frame, tempTitle)
		if tempTitleGbox ~= nil then
			tempTitleGbox:ShowWindow(visible)
		end
	end

end

function CANCEL_MARKET_ITEM(parent, ctrl)
	local row = parent:GetUserIValue("DETAIL_ROW");
	local marketItem = session.market.GetItemByIndex(row);
	local itemObj = GetIES(marketItem:GetObject());
	local guid = marketItem:GetMarketGuid()

	local yesScp = string.format("EXEC_CANCEL_MARKET_ITEM(\"%s\")", guid);
	ui.MsgBox(ClMsg("ReallyCancelRegisteredItem"), yesScp, "None");
end

function EXEC_CANCEL_MARKET_ITEM(itemGuid)
	market.CancelMarketItem(itemGuid);
end

function MARKET_SET_TOTAL_PRICE(ctrlset, price, count)

	local totalPrice_num = GET_CHILD_RECURSIVELY(ctrlset, "totalPrice_num")
	totalPrice_num:SetTextByKey("value", GetCommaedText(tonumber(math.mul_int_for_lua(price, count))))
	local totalPrice_text = GET_CHILD_RECURSIVELY(ctrlset, "totalPrice_text")
	totalPrice_text:SetTextByKey("value", GetMonetaryString(tonumber(math.mul_int_for_lua(price, count))))
end

function MARKET_CHANGE_COUNT(parent, ctrl)
	local ctrlset = parent;
	if parent:GetName() == "count" then
		ctrlset = parent:GetParent()
	end
	
	local priceFrame = GET_CHILD_RECURSIVELY(ctrlset, "price_num");
	local editCount = GET_CHILD_RECURSIVELY(ctrlset, "count");
	local price = priceFrame:GetUserValue("Price");
	
	MARKET_SET_TOTAL_PRICE(ctrlset, price, editCount:GetNumber())
end

function MARKET_ITEM_COUNT_UP(frame)
	local editCount = GET_CHILD_RECURSIVELY(frame, "count")
	if editCount == nil then
		return
	end

	local nowCount = tonumber(editCount:GetText())
	nowCount = nowCount + 1

	local maxItemCount = frame:GetUserIValue("maxItemCount")

	if nowCount >= maxItemCount then
		nowCount = maxItemCount;
	end;

	editCount:SetText(tostring(nowCount))
	
	local price_num = GET_CHILD_RECURSIVELY(frame, "price_num")
	local price = frame:GetUserIValue("sellPrice")

	MARKET_SET_TOTAL_PRICE(frame, price, nowCount)
end

function MARKET_ITEM_COUNT_DOWN(frame)
	local editCount = GET_CHILD_RECURSIVELY(frame, "count")
	if editCount == nil then
		return
	end

	local nowCount = tonumber(editCount:GetText())
	nowCount = nowCount - 1

	local minItemCount = frame:GetUserIValue("minItemCount")

	if nowCount <= minItemCount then
		nowCount = minItemCount;
	end;

	editCount:SetText(tostring(nowCount))

	local price_num = GET_CHILD_RECURSIVELY(frame, "price_num")
	local price = frame:GetUserIValue("sellPrice")
	
	MARKET_SET_TOTAL_PRICE(frame, price, nowCount)
end

function MARKET_ITEM_COUNT_MAX(frame)
	local editCount = GET_CHILD_RECURSIVELY(frame, "count")
	if editCount == nil then
		return
	end

	local maxItemCount = frame:GetUserIValue("maxItemCount")
	local mySilver = GET_TOTAL_MONEY();

	local price_num = GET_CHILD_RECURSIVELY(frame, "price_num")
	local price = frame:GetUserIValue("sellPrice")
	
	local maxCanBuyCount = math.floor(mySilver / price)
	local maxItemCount = math.min(maxItemCount, maxCanBuyCount)
	editCount:SetText(tostring(maxItemCount))

	MARKET_SET_TOTAL_PRICE(frame, price, maxItemCount)
end

function _BUY_MARKET_ITEM(row, isRecipeSearchBox)
	local frame = ui.GetFrame("market");

	local totalPrice = 0;
	market.ClearBuyInfo();

	if isRecipeSearchBox ~= nil and isRecipeSearchBox == 1 then
		local itemlist = GET_CHILD_RECURSIVELY(frame, "recipeSearchGbox")
		local child = itemlist:GetChildByIndex(row);
		local editCount = GET_CHILD_RECURSIVELY(child, "count")
		if editCount == nil then
			local marketItem = session.market.GetRecipeSearchByIndex(row-1);
			market.AddBuyInfo(marketItem:GetMarketGuid(), 1);
			totalPrice = totalPrice + marketItem.sellPrice;
		else
			local buyCount = editCount:GetText()
			if tonumber(buyCount) > 0 then
				local marketItem = session.market.GetRecipeSearchByIndex(row-1);
				market.AddBuyInfo(marketItem:GetMarketGuid(), buyCount);
				totalPrice = totalPrice + buyCount * marketItem.sellPrice;
			else
				ui.SysMsg(ScpArgMsg("YouCantBuyZeroItem"));
			end
		end
	else
		local itemlist = GET_CHILD_RECURSIVELY(frame, "itemListGbox");
		local child = itemlist:GetChildByIndex(row);
		local editCount = GET_CHILD_RECURSIVELY(child, "count")
		if editCount == nil then
			local marketItem = session.market.GetItemByIndex(row-1);
			market.AddBuyInfo(marketItem:GetMarketGuid(), 1);
			totalPrice = totalPrice + marketItem.sellPrice;
		else
			local buyCount = editCount:GetText()
			if tonumber(buyCount) > 0 then
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
	local frame = ui.GetFrame("market")
	local row = parent:GetUserIValue("DETAIL_ROW");
	local marketGuid = parent:GetUserValue("marketItemGuid")
	local marketRecipeSearchGuid = parent:GetUserValue("marketRecipeSearchGuid")
	local isRecipeSearchBox = 0
	local marketItem = session.market.GetItemByIndex(row);
	if marketRecipeSearchGuid ~= nil and marketRecipeSearchGuid ~= "None" then
		marketItem = session.market.GetRecipeSearchItemByMarketID(marketRecipeSearchGuid)
		isRecipeSearchBox = 1
		frame:SetUserValue("isRecipeSearching", 1)
	else
		frame:SetUserValue("isRecipeSearching", 0)
	end

	local itemObj = GetIES(marketItem:GetObject());

	local txt = ScpArgMsg("ReallyBuy?");
	ui.MsgBox(txt, string.format("_BUY_MARKET_ITEM(%d, %d)", row+1, isRecipeSearchBox), "None");
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
	frame:SetUserValue("isRecipeSearching", 0)
	ui.CloseFrame("market");
	ui.CloseFrame("market_cabinet");
	ui.OpenFrame("market_sell");
	ui.OpenFrame("inventory");
end

function MARKET_BUYMODE(frame)	
	frame:SetUserValue("isRecipeSearching", 0)
	ui.OpenFrame("market");	
	ui.CloseFrame("market_sell");
	ui.CloseFrame("market_cabinet");
end

function MARKET_CABINET_MODE(frame)
	frame:SetUserValue("isRecipeSearching", 0)
	ui.CloseFrame("market");
	ui.CloseFrame("market_sell");
	ui.OpenFrame("market_cabinet");
end