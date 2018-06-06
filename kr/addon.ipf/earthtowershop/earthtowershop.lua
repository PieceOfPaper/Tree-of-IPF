function REQ_EARTH_TOWER_SHOP_OPEN()
	ui.OpenFrame('earthtowershop')
end

function EARTH_TOWER_SHOP_OPEN(frame)
	if frame == nil then
		fream = ui.GetFrame("earthtowershop")
	end

	EARTH_TOWER_INIT(frame)

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
	EARTH_TOWER_INIT(frame);
end

function EARTH_TOWER_INIT(frame)

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("None");

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

	local idSpace = frame:GetUserValue("IDSPACE");
	
	if idSpace == "None" then
		idSpace = "EarthTowerRecipe";
		frame:SetUserValue("IDSPACE", "EarthTowerRecipe");
	end
	
	local arg1 = frame:GetUserValue("IDSPACE_ARG1");
	local arg2 = frame:GetUserValue("IDSPACE_ARG2");

	--모든 제작 레시피 생성.
	local clslist = GetClassList(idSpace);
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");	
	local checkHaveMaterial = showonlyhavemat:IsChecked();	

	--local checkCraftFunc = _G["CRAFT_CHECK_".. idSpace];
	-- 제작 카테고리.

	while cls ~= nil do

		--if checkCraftFunc(cls, arg1, arg2) == true then
			local haveM = CRAFT_HAVE_MATERIAL(cls);		
			if checkHaveMaterial == 1 then
				if haveM == 1 then
					INSERT_ITEM(cls, tree, slotHeight,haveM);
				end
			else
				INSERT_ITEM(cls, tree, slotHeight,haveM);
			end
		--end

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

	CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls);
end


function CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls)
	
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
	local groupbox = tree:CreateOrGetControl('groupbox', pageCtrlName, 0, 0, 530, 200)
	--DESTROY_CHILD_BY_USERVALUE(groupbox, "EARTH_TOWER_CTRL", "YES");
	groupbox:SetSkinName("None")
	tree:Add(hParent, groupbox);	
	tree:SetNodeFont(hParent,"brown_18_b")		

	local ctrlset = groupbox:CreateOrGetControlSet('earthTowerRecipe', cls.ClassName , 0, 0);
	ctrlset:SetUserValue("EARTH_TOWER_CTRL", "YES");

	local x = 180;
	local startY = 80;
	local y = startY;
	y = y + 10;
	local itemHeight = ui.GetControlSetAttribute('craftRecipe_detail_item', 'height');

	local recipecls = GetClass('EarthTowerRecipe', ctrlset:GetName());
	local targetItem = GetClass("Item", recipecls.TargetItem);

	local itemName = GET_CHILD(ctrlset, "itemName")
	itemName:SetTextByKey("value", targetItem.Name)

	local itemIcon = GET_CHILD(ctrlset, "itemIcon")
	itemIcon:SetImage(targetItem.Icon)
	itemIcon:SetEnableStretch(1)
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

	if itemCount >= 3 then
		ctrlset:Resize(ctrlset:GetWidth(), 120 + (itemCount * 68));
	end

	GBOX_AUTO_ALIGN(groupbox, 0, 0, 10, true, false);

	groupbox:SetUserValue("HEIGHT_SIZE", groupbox:GetUserIValue("HEIGHT_SIZE") + ctrlset:GetHeight())
	groupbox:Resize(groupbox:GetWidth(), groupbox:GetUserIValue("HEIGHT_SIZE"));
end

function EARTH_TOWER_SHOP_TREAD(parent, ctrl)

	local parentcset = ctrl:GetParent()

	
	local frame = ctrl:GetTopParentFrame();
	local idSpace = frame:GetUserValue("IDSPACE");
	--[[
	local parentcset = ctrlset:GetParent()
	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, recipeName);

	if recipecls == nil then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		return;
	end

	local totalCount = 0;
	local upDown = GET_CHILD(parentcset, "upDown", "ui::CNumUpDown");
	if nil ~= upDown then
		totalCount = upDown:GetNumber();	
	end	

	if 0 >= totalCount then
		ui.SysMsg(ClMsg("InputCount"));
		return;
	end
	]]--
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

	local recipeCls = GetClass("EarthTowerRecipe", parentcset:GetName())

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
	frame:SetUserValue("IDSPACE", idSpace);
	local cntText = string.format("%s %s", recipeCls.ClassID, 1);
	item.DialogTransaction("EARTH_TOWER_SHOP_TREAD", resultlist, cntText);

	--EARTH_TOWER_INIT(frame)

	frame:ShowWindow(0)

end