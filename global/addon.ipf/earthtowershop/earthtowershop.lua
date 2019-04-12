function REQ_EARTH_TOWER_SHOP_OPEN()

	local frame = ui.GetFrame("earthtowershop");
	frame:SetUserValue("SHOP_TYPE", 'EarthTower');
	ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP_OPEN()
	local frame = ui.GetFrame("earthtowershop");
	frame:SetUserValue("SHOP_TYPE", 'EventShop');
	ui.OpenFrame('earthtowershop');
end

function EARTH_TOWER_SHOP_OPEN(frame)
	if frame == nil then
		frame = ui.GetFrame("earthtowershop")
	end
	
	local shopType = frame:GetUserValue("SHOP_TYPE");
	if shopType == 'None' then
		shopType = "EarthTower";
		frame:SetUserValue("SHOP_TYPE", shopType);
	end

	EARTH_TOWER_INIT(frame, shopType)

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(1);

	local article = GET_CHILD(frame, 'recipe', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(0);
	
	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')
	group:ShowWindow(1)
	imcSound.PlaySoundEvent('button_click_3');

	session.ResetItemList();
end

function  EARTH_TOWER_SHOP_OPTION(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local shopType = frame:GetUserValue("SHOP_TYPE");
	EARTH_TOWER_INIT(frame, shopType);
end

function EARTH_TOWER_INIT(frame, shopType)

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("None");

	local title = GET_CHILD(frame, 'title', 'ui::CRichText')
	if shopType == 'EarthTower' then
		title:SetText('{@st43}'..ScpArgMsg("EarthTowerShop"));
	elseif shopType == 'EventShop' then
		title:SetText('{@st43}'..ScpArgMsg("EventShop"));
	end

	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

	local slotHeight = ui.GetControlSetAttribute('earthTowerRecipe', 'height') + 5;

	local tree_box = GET_CHILD(group, 'recipetree_Box','ui::CGroupBox')
	local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')

	if nil == tree then
		return;
	end
	tree:Clear();
	tree:EnableDrawTreeLine(false)
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,200)
	tree:SetFontName("brown_18_b");
	tree:SetTabWidth(5);
		
	--모든 제작 레시피 생성.
	local clslist = GetClassList("ItemTradeShop");
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");	
	local checkHaveMaterial = showonlyhavemat:IsChecked();	

	while cls ~= nil do

		if cls.ShopType == shopType then
			local haveM = CRAFT_HAVE_MATERIAL(cls);		
			if checkHaveMaterial == 1 then
				if haveM == 1 then
					INSERT_ITEM(cls, tree, slotHeight,haveM);
				end
			else
				INSERT_ITEM(cls, tree, slotHeight,haveM);
			end
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

	tree:OpenNodeAll();

end


function INSERT_ITEM(cls, tree, slotHeight, haveMaterial)

	local item = GetClass('Item', cls.TargetItem);
	local groupName = item.GroupName;
	local classType = nil;
	if GetPropType(item, "ClassType") ~= nil then
		classType = item.ClassType;
	end

	EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls);
end


function EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls)
	
	local hGroup = tree:FindByValue(groupName);
	if tree:IsExist(hGroup) == 0 then
		hGroup = tree:Add(GET_RECIPE_GROUP_NAME(groupName), groupName);
		tree:SetNodeFont(hGroup,"brown_18_b")
	end

	local hParent = nil;
	if classType == nil then
		hParent = hGroup;
	else
		local hClassType = tree:FindByValue(hGroup, classType);
		if tree:IsExist(hClassType) == 0 then
			hClassType = tree:Add(hGroup, GET_RECIPE_GROUP_NAME(classType), classType);
			tree:SetNodeFont(hClassType,"brown_18_b")
			
		end

		hParent = hClassType;
	end
	
	local pageCtrlName = "PAGE_" .. groupName;
	if classType ~= nil then
		pageCtrlName = pageCtrlName .. "_" .. classType;
	end

	--DESTROY_CHILD_BY_USERVALUE(tree, "EARTH_TOWER_CTRL", "YES");

	--local page = tree:GetChild(pageCtrlName);
	--if page == nil then
	--page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);
	--CreateOrGetControl('groupbox', "upbox", 0, 0, detailView:GetWidth(), 0);
	--local groupbox = tree:CreateOrGetControlSet('groupbox_sub', tree:GetName(), 0, 0)
	--local groupbox = CreateOrGetControl('groupbox', 'questreward', 10, 10, frame:GetWidth()-70, frame:GetHeight());
	--print(tree:GetName())
	
	local page = tree:GetChild(pageCtrlName);
	if page == nil then
		page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);

		tolua.cast(page, 'ui::CPage')
		page:SetSkinName('None');
		page:SetSlotSize(415, slotHeight);
		page:SetFocusedRowHeight(-1, slotHeight);
		page:SetFitToChild(true, 10);
		page:SetSlotSpace(0, 0)
		page:SetBorder(5, 0, 0, 0)
		CRAFT_MINIMIZE_FOCUS(page);
		tree:Add(hParent, page);	
		tree:SetNodeFont(hParent,"brown_18_b")		
	end
	
	local ctrlset = page:CreateOrGetControlSet('earthTowerRecipe', cls.ClassName, 10, 10);
	local groupbox = ctrlset:CreateOrGetControl('groupbox', pageCtrlName, 0, 0, 530, 200);	
	
	groupbox:SetSkinName("None")
	groupbox:EnableHitTest(0);
	groupbox:ShowWindow(1);
	tree:Add(hParent, groupbox);	
	tree:SetNodeFont(hParent,"brown_18_b")		

	local x = 180;
	local startY = 80;
	local y = startY;
	y = y + 10;
	local itemHeight = ui.GetControlSetAttribute('craftRecipe_detail_item', 'height');
	local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
	local targetItem = GetClass("Item", recipecls.TargetItem);
	local itemName = GET_CHILD(ctrlset, "itemName")
	local itemIcon = GET_CHILD(ctrlset, "itemIcon")
	local minHeight = itemIcon:GetHeight() + startY + 10;


	itemName:SetTextByKey("value", targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]" );
	itemIcon:SetImage(targetItem.Icon);
	itemIcon:SetEnableStretch(1);
	SET_ITEM_TOOLTIP_ALL_TYPE(itemIcon, nil, targetItem.ClassName, '', targetItem.ClassID, 0);

	local itemCount = 0;
	for i = 1, 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if invItemlist ~= nil then
				for j = 0, recipeItemCnt - 1 do
					local itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
					itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
					CRAFT_DETAIL_CTRL_INIT(itemSet);
					local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
					local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
					needcountTxt:SetTextByKey("count", recipeItemCnt)
					local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
					SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
					slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
					slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
					slot:SetEventScriptArgString(ui.DROP, 1)
					slot:EnableDrag(0);
					local icon 		= slot:GetIcon();
					icon:SetColorTone('33333333')
					itemtext:SetText(dragRecipeItem.Name);
					y = y + itemHeight;
					itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)
						
					slot:SetOverSound('button_cursor_over_2');
					slot:SetClickSound('button_click');
					itemCount = itemCount + 1;				
				end
			else			
				local itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i, x, y);
				itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
				CRAFT_DETAIL_CTRL_INIT(itemSet);
				local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
				local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
				needcountTxt:SetTextByKey("count",recipeItemCnt)--제작에 필요한 아이템 카운트
				local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
				SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
				slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
				slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
				slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
				slot:EnableDrag(0);	
				local icon 		= slot:GetIcon();
				icon:SetColorTone('33333333')
				itemtext:SetText(dragRecipeItem.Name);
				y = y + itemHeight;
				itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)
				
				slot:SetOverSound('button_cursor_over_2');
				slot:SetClickSound('button_click');
				itemCount = itemCount + 1;
			end
		end
	end

	local height = 0;	
	if y < minHeight then
		height = minHeight;
	else
		height = 120 + (itemCount * 55);
	end;
		
	local lableLine = GET_CHILD(ctrlset, "labelline_1");
	local exchangeCountText = GET_CHILD(ctrlset, "exchangeCount");	
	if recipecls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
		local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
		local cntText = string.format("%d", sCount).. ScpArgMsg("Excnaged_Count_Remind");
		local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
		if sCount <= 0 then
			cntText = ScpArgMsg("Excnaged_No_Enough");
			tradeBtn:SetColorTone("FF444444");
		end;
		
		exchangeCountText:SetTextByKey("value", cntText);

		lableLine:SetPos(0, height);
		height = height + 10 + lableLine:GetHeight();
		exchangeCountText:SetPos(0, height);
		height = height + 10 + exchangeCountText:GetHeight() + 15;
		lableLine:SetVisible(1);
		exchangeCountText:SetVisible(1);
	else
		height = height+ 20;
		lableLine:SetVisible(0);
		exchangeCountText:SetVisible(0);
	end;

	ctrlset:Resize(ctrlset:GetWidth(), height);
	GBOX_AUTO_ALIGN(groupbox, 0, 0, 10, true, false);

	groupbox:SetUserValue("HEIGHT_SIZE", groupbox:GetUserIValue("HEIGHT_SIZE") + ctrlset:GetHeight())
	groupbox:Resize(groupbox:GetWidth(), groupbox:GetUserIValue("HEIGHT_SIZE"));
	
	page:SetSlotSize(ctrlset:GetWidth(), ctrlset:GetHeight())
end

function EARTH_TOWER_SHOP_EXEC(parent, ctrl)

	local parentcset = ctrl:GetParent()

	
	local frame = ctrl:GetTopParentFrame();	
	local cnt = parentcset:GetChildCount();
	for i = 0, cnt - 1 do
		local eachcset = parentcset:GetChildByIndex(i);		
		if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
			local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")
			if selected ~= 'selected' then
				ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
				return;
			end
		end
	end

	local resultlist = session.GetItemIDList();
	local someflag = 0
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);

		if IS_VALUEABLE_ITEM(tempitem.ItemID) == 1 then
			someflag = 1
		end
	end

	session.ResetItemList();

	local recipeCls = GetClass("ItemTradeShop", parentcset:GetName())

	for index=1, 5 do
		local clsName = "Item_"..index.."_1";
		local itemName = recipeCls[clsName];
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipeCls, clsName);
		local invItem = session.GetInvItemByName(itemName);
		if "None" ~= itemName then
			if nil == invItem then
				ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
				return;
			else
				if true == invItem.isLockState then
					ui.SysMsg(ClMsg("MaterialItemIsLock"));
					return;
				end
				session.AddItemID(invItem:GetIESID(), recipeItemCnt);
			end
		end
	end

	local resultlist = session.GetItemIDList();
	local cntText = string.format("%s %s", recipeCls.ClassID, 1);
	

	local shopType = frame:GetUserValue("SHOP_TYPE");
	if shopType == 'EarthTower' then
		item.DialogTransaction("EARTH_TOWER_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'EventShop' then
		item.DialogTransaction("EVENT_ITEM_SHOP_TREAD", resultlist, cntText);
	end

	frame:ShowWindow(0)
end