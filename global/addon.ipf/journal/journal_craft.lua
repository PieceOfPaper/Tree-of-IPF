
function CREATE_JOURNAL_ARTICLE_CRAFT(frame, grid, key, text, iconImage, callback)


	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);

	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

	local ctrlset = GET_CHILD(group, "ctrlset");
	local slotHeight = ui.GetControlSetAttribute("journalRecipe", 'height') + 5;

	local tree_box = GET_CHILD(ctrlset, 'recipetree_Box','ui::CGroupBox')
	local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')

	tree:Clear();
	tree:EnableDrawTreeLine(false)
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,100)
	tree:SetFontName("white_20_ol");
	tree:SetTabWidth(5);

	
	local clslist = GetClassList("Recipe");
	if clslist == nil then 
		return 
	end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	local showonlyhavemat = GET_CHILD(ctrlset, "showonlyhavemat", "ui::CCheckBox");
	showonlyhavemat:ShowWindow(0);
	local checkHaveMaterial = showonlyhavemat:IsChecked();

	-- f[ ??°?.
	while cls ~= nil do
		if GetWikiByName(cls.ClassName) ~= nil then
			--print(i,cls.ClassName,cls.ClassID)
		end

		if cls.NeedWiki == 0 or GetWikiByName(cls.ClassName) ~= nil then
			if checkHaveMaterial == 1 then
				if JOURNAL_HAVE_MATERIAL(cls) == 1 then
					JOURNAL_INSERT_CRAFT(cls, tree, slotHeight);
				end
			else
				JOURNAL_INSERT_CRAFT(cls, tree, slotHeight);
			end
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end
	
	JOURNAL_UPDATE_SCORE(frame, group, "Recipe");

	tree:OpenNodeAll();
	
end

function JOURNAL_INSERT_CRAFT(cls, tree, slotHeight)

	local item = GetClass('Item', cls.TargetItem);
	local groupName = item.GroupName;
	local classType = nil;
	if GetPropType(item, "ClassType") ~= nil then
		classType = item.ClassType;
	end

	local page = JOURNAL_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType);
	
	local app = page:CreateOrGetControlSet("journalRecipe", cls.ClassName, 10, 10);

	local titleText = GET_CHILD(app, "name", "ui::CRichText");
	titleText:SetText("{@st48}{s18}"..item.Name.."{/}{/}");

	local difficulty = GET_CHILD(app, "difficulty", "ui::CRichText");
	local difficultyText = GET_ITEM_GRADE_TXT(item, 24);
	difficulty:SetText(difficultyText);

	local icon = GET_CHILD(app, "icon", "ui::CPicture");
	icon:SetImage(item.Icon);
	icon:SetEnableStretch(1)

	SET_ITEM_TOOLTIP_ALL_TYPE(icon, item, item.ClassName, '', item.ClassID, 0);

	local titleText = GET_CHILD(app, "count", "ui::CRichText");
	titleText:SetText('');

	local gauge = GET_CHILD(app, 'progress', "ui::CGauge");
	gauge:ShowWindow(0);

	app:SetEventScript(ui.LBUTTONUP, 'JORNAL_RECIPE_FOCUS');
	page:Resize(page:GetWidth(), app:GetY() + app:GetHeight() + 20);

end



function GET_RECIPE_GROUP_NAME(groupname)

	if groupname == 'Wood' then
		return ScpArgMsg('RecipeGroup_Wood')
	end

	if groupname == 'Quest' then
		return ScpArgMsg('RecipeGroup_Quest')
	end

	if groupname == 'Weapon' then
		return ScpArgMsg('RecipeGroup_Weapon')
	end

	if groupname == 'Armor' then
		return ScpArgMsg('RecipeGroup_Armor')
	end

	if groupname == 'THSword' then
		return ScpArgMsg('RecipeGroup_THSword')
	end

	if groupname == 'Neck' then
		return ScpArgMsg('RecipeGroup_Neck')
	end

	if groupname == 'Pants' then
		return ScpArgMsg('RecipeGroup_Pants')
	end

	if groupname == 'THBow' then
		return ScpArgMsg('RecipeGroup_THBow')
	end

	if groupname == 'Bow' then
		return ScpArgMsg('RecipeGroup_Bow')
	end

	if groupname == 'Sword' then
		return ScpArgMsg('RecipeGroup_Sword')
	end

	if groupname == 'Staff' then
		return ScpArgMsg('RecipeGroup_Staff')
	end

	if groupname == 'Mace' then
		return ScpArgMsg('RecipeGroup_Mace')
	end

	if groupname == 'None' then
		return ScpArgMsg('RecipeGroup_None')
	end

	if groupname == 'Spear' then
		return ScpArgMsg('RecipeGroup_Spear')
	end

	if groupname == 'Shirt' then
		return ScpArgMsg('RecipeGroup_Shirt')
	end

	if groupname == 'Gloves' then
		return ScpArgMsg('RecipeGroup_Gloves')
	end

	if groupname == 'Boots' then
		return ScpArgMsg('RecipeGroup_Boots')
	end
	
	if groupname == 'Shield' then
		return ScpArgMsg('RecipeGroup_Shield')
	end

	if groupname == 'Material' then
		return ScpArgMsg('RecipeGroup_Material')
	end

	if groupname == 'Ring' then
		return ScpArgMsg('RecipeGroup_Ring')
	end
	
	if groupname == 'THStaff' then
		return ScpArgMsg('RecipeGroup_THStaff')
	end
    
    if groupname == 'THSpear' then
		return ScpArgMsg('RecipeGroup_THSpear')
	end
	
	if groupname == 'Rapier' then
		return ScpArgMsg('RecipeGroup_Rapier')
	end
	
	if groupname == 'Pistol' then
		return ScpArgMsg('RecipeGroup_Pistol')
	end
	
	if groupname == 'Hat' then
		return ScpArgMsg('RecipeGroup_Hat')
	end
	
	if groupname == 'SubWeapon' then
		return ScpArgMsg('RecipeGroup_SubWeapon')
	end
	
	if groupname == 'Artefact' then
		return ScpArgMsg('RecipeGroup_Artefact')
	end

	if groupname == 'Armband' then
		return ScpArgMsg('RecipeGroup_Armband')
	end
	
	if groupname == 'MagicAmulet' then
		return ScpArgMsg('RecipeGroup_MagicAmulet')
	end
	
	if groupname == 'Cannon' then
		return ScpArgMsg('RecipeGroup_Cannon')
	end
	
	if groupname == 'Dagger' then
		return ScpArgMsg('RecipeGroup_Dagger')
	end
	
	if groupname == 'Musket' then
		return ScpArgMsg('RecipeGroup_Musket')
	end
	
	if groupname == 'Premium' then
		return ScpArgMsg('TP_Premium')
	end
	
	if groupname == 'Drug' then
		return ScpArgMsg('Drug')
	end
	
	return groupname;

end

function JOURNAL_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType)

		local hGroup = tree:FindByValue(groupName);
		if tree:IsExist(hGroup) == 0 then
			hGroup = tree:Add(GET_RECIPE_GROUP_NAME(groupName), groupName);
			tree:SetNodeFont(hGroup,"white_20")
		end

		local hParent = nil;
		if classType == nil then
			hParent = hGroup;
		else
			local hClassType = tree:FindByValue(hGroup, classType);
			if tree:IsExist(hClassType) == 0 then
				hClassType = tree:Add(hGroup, GET_RECIPE_GROUP_NAME(classType), classType);
				tree:SetNodeFont(hClassType,"white_20")
				
			end

			hParent = hClassType;
		end

		local pageCtrlName = "PAGE_" .. groupName;
		if classType ~= nil then
			pageCtrlName = pageCtrlName .. "_" .. classType;
		end

		local page = tree:GetChild(pageCtrlName);
		if page == nil then
			page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);
			tolua.cast(page, 'ui::CPage')
			page:SetSkinName('None');
			page:SetSlotSize(415, slotHeight)
			page:SetFocusedRowHeight(-1, slotHeight);
			page:SetFitToChild(true, 10);
			page:SetSlotSpace(0, 0)
			page:SetBorder(5, 0, 0, 0)
			JORNAL_CRAFT_MINIMIZE_FOCUS(page);
			tree:Add(hParent, page);	
			tree:SetNodeFont(hParent,"white_20")		
		end

		return page;

end


function JORNAL_DRAW_ITEM_PROP_TOOLTIP(queue, tgtItem, propName)
	local text = queue:CreateOrGetControl('richtext', propName, 200, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0);
	local randValue = 0;
	if GetPropType(tgtItem, propName .. "_RANDOM") ~= nil then
		randValue = tgtItem[propName .. "_RANDOM"];
	elseif propName == "MINATK" or propName == "MAXATK" then
		randValue = tgtItem.ATK_RANDOM;
	end

	local baseValue = tgtItem[propName];
	local retStr;
	if randValue == 0 then
		retStr = string.format("{@st41}%s : %d", ClMsg(propName), baseValue);
	else
		retStr = string.format("{@st41}%s : %d ~ %d", ClMsg(propName), baseValue, baseValue + randValue);
	end

	text:SetText(retStr);
end

function JOURNAL_HAVE_MATERIAL(recipecls)

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local dragRecipeItem = GetClass('Item', recipecls["Item_"..i.."_1"]);
			local invItem = session.GetInvItemByType(dragRecipeItem.ClassID);
			if invItem ~= nil then
				return 1;
			end
		end
	end

	return 0;
end

function JOURNAL_UPDATE_RECIPE_TOOLTIP(frame, recipeID, targetItemID)

	local queue = GET_CHILD(frame, 'itempic', 'ui::CQueue')
	queue:RemoveAllChild()
	--queue:SetOffset(20, 20)
	queue:SetSkinName('')

	local recipecls = GetClass('Recipe', recipeID);
	local tgtItem = GetClass('Item', recipecls.TargetItem)

	local itemicon = GET_CHILD(frame, "itemicon", "ui::CPicture");
	itemicon:SetImage(tgtItem.Icon);
	local recipename = frame:GetChild("recipename");
	local difficulty = frame:GetChild("difficulty");
	recipename:SetTextByKey("value", tgtItem.Name);
	local difficultyText = GET_ITEM_GRADE_TXT(tgtItem, 20);
	difficulty:SetTextByKey("value", difficultyText);

	local propList = GET_MAIN_PROP_LIST(tgtItem);
	for i = 1 , #propList do
		local propName = propList[i];
		if GetPropType(tgtItem, propName) ~= nil and tgtItem[propName] > 0 then
			JORNAL_DRAW_ITEM_PROP_TOOLTIP(queue, tgtItem, propName);
		end
	end

	frame:Resize(frame:GetWidth(), queue:GetY() + queue:GetHeight() + 10);
end


function JOURNAL_PAGE_CHANGE_CRAFT(ctrl, ctrlset)

	local frame = ui.GetFrame('journal')
	local craftGroup = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox');
	local page = GET_CHILD(craftGroup, 'page', 'ui::CPage')

	if page ~= nil then
		local control = GET_CHILD(craftGroup, 'control', 'ui::CPageController')
		local index = control:GetCurPage();
		JORNAL_CRAFT_MINIMIZE_FOCUS(page);
		page:SetCurPage(index)

		imcSound.PlaySoundEvent('button_click');
	end

end

function JOURNAL_OPEN_CRAFT_ARTICLE(frame)

	local f = ui.GetFrame("journal");
	JOURNAL_HIDE_ARTICLES(f)
	JOURNAL_OPEN_ARTICLE(f, 'Recipe')
	imcSound.PlaySoundEvent('button_click_3');

end

--- about detail controlset

function JORNAL_RECIPE_FOCUS(page, ctrlSet)
	page = tolua.cast(page, "ui::CPage");
	local row = page:GetObjectRow(ctrlSet);
	local curFocus = page:GetFocusedRow();

	local minimized = page:GetUserIValue("minimized");
	local slotHeight = ui.GetControlSetAttribute("journalRecipe", 'height') + 5;
	if row == curFocus and minimized == 0 then
		page:SetFocusedRowHeight(-1, slotHeight, 0.2, 0.7, 5);
		page:SetUserValue("minimized", 1);
	else
		JORNAL_CRAFT_MINIMIZE_FOCUS(page);

		page:SetUserValue("minimized", 0);
		page:SetFocusedRow(row);
		local resultHeight = JOURNAL_CRAFT_SET_DETAIL(ctrlSet, 1);
		if resultHeight ~= 0 then
			page:SetFocusedRowHeight(slotHeight, resultHeight, 0.15, 0.7, 5);
		end
	end
end

function JORNAL_CRAFT_MINIMIZE_FOCUS(page)
	local curFocus = page:GetFocusedRow();
	local beforeFocus = page:GetObjectByRow(curFocus);
	if beforeFocus ~= nil then
		JOURNAL_CRAFT_SET_DETAIL(beforeFocus, 0);
	end
end

function JOURNAL_CRAFT_SET_DETAIL(ctrlset, detailMode, ignoreUserValue)
	local curMode = ctrlset:GetUserIValue("DETAILMODE");
	if curMode == detailMode and ignoreUserValue ~= 1 then
		return 0;
	end

	ctrlset:SetUserValue("DETAILMODE", detailMode);
	local height = ui.GetControlSetAttribute("journalRecipe", 'height');
	if detailMode == 0 then
		ctrlset:Resize(ctrlset:GetWidth(), height);
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");
		return 0;
	else
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");
		ctrlset:MergeControlSet("journalRecipe_detail");
		local lvgauge = GET_CHILD(ctrlset, "lvgauge", "ui::CGauge");
		local myWiki = GetWikiByName(ctrlset:GetName());
		if myWiki ~= nil then
			local cnt = GetWikiIntProp(myWiki, "MakeCount");
			lvgauge:SetPoint(cnt, 10);
		end

		RUNFUNC_TO_MERGED_CTRLSET(ctrlset, "journalRecipe_detail", JOURNAL_DETAIL_CTRL_INIT);
		local itemHeight = MAKE_DETAIL_REQITEMS(ctrlset);
		local resizeHeight = height + itemHeight + ui.GetControlSetAttribute("journalRecipe_detail", "height") + 20;
		return resizeHeight;
	end

	return 0;
end

function JOURNAL_DETAIL_CTRL_INIT(ctrl)
	ctrl:SetUserValue("DETAIL_CTRL", "YES");
end

function MAKE_DETAIL_REQITEMS(ctrlset)
	local recipecls = GetClass("Recipe", ctrlset:GetName());
	local x = 90;
	local startY = 85;
	local y = startY;

	local labelBox = ctrlset:CreateControl("groupbox", "LABEL", 80, startY, ctrlset:GetWidth() - 95, 0);
	JOURNAL_DETAIL_CTRL_INIT(labelBox);
	labelBox:ShowWindow(1);
	labelBox:SetSkinName(" ");
	ctrlset:SetSkinName("test_skin_01");
	y = y + 10;

	local itemHeight = ui.GetControlSetAttribute("journalRecipe_detail_item", 'height');
	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem = GET_RECIPE_MATERIAL_INFO(recipecls, i);

			local itemSet = ctrlset:CreateOrGetControlSet("journalRecipe_detail_item", "ITEM_" .. i, x, y);
			JOURNAL_DETAIL_CTRL_INIT(itemSet);
			local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
			local gauge = GET_CHILD(itemSet, "gauge", "ui::CGauge");
			SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
			gauge:SetPoint(invItemCnt, recipeItemCnt);

			y = y + itemHeight + 5;
		end
	end

	y = y + 10;
	local gboxHeight = y - startY;
	labelBox:Resize(labelBox:GetWidth(), gboxHeight);
	y = y + 0;

	local targetItem = GetClass("Item", recipecls.TargetItem);
	if IS_EQUIP(targetItem) == true then
		local memoSet = ctrlset:CreateControlSet("journalRecipe_detail_memo", "MEMO", 20, y);
		JOURNAL_DETAIL_CTRL_INIT(memoSet);
		JOURNAL_INIT_MEMO_SET(memoSet);
		y = y;
	end


	ctrlset:MergeControlSet("journalRecipe_makeBtn", ctrlset:GetWidth() - 320, y + 0);
	RUNFUNC_TO_MERGED_CTRLSET(ctrlset, "journalRecipe_makeBtn", JOURNAL_DETAIL_CTRL_INIT);
	y = y + ui.GetControlSetAttribute("journalRecipe_makeBtn", 'height') + 0;
	local make = GET_CHILD(ctrlset, "make", "ui::CButton");
	
	local myActor = GetMyActor();

	if myActor:IsSit() == 1 then -- ¾?? UI°¡ ¹?? ¶§¹®¿¡(¸¸??´?½þ? [μ¿ ¾?? ¹??°¡·s??? ±??f[: ?½ĸ???§¸¸ ?¸???sª 140922.
		--make:ShowWindow(1)
		make:ShowWindow(0)
	else
		make:ShowWindow(0)
	end

	return y - startY;
end

function RECIPE_TYPING_NAME(frame, ctrl)
	local removedTag = REMOVE_TAG(ctrl:GetText());
	ctrl:SetText(removedTag);
	frame:GetTopParentFrame():SetUserValue("EQP_NAME", ctrl:GetText());
end

function RECIPE_TYPING_MEMO(frame, ctrl)
	local removedTag = REMOVE_TAG(ctrl:GetText());
	ctrl:SetText(removedTag);
	frame:GetTopParentFrame():SetUserValue("EQP_MEMO", ctrl:GetText());
end

function JOURNAL_INIT_MEMO_SET(memoSet)
	local name = GET_CHILD(memoSet, "name", "ui::CEditControl");
	local memo = GET_CHILD(memoSet, "memo", "ui::CEditControl");
	name:SetMaxLen(ITEM_MEMO_LEN);
	memo:SetMaxLen(RECIPE_ITEM_NAME_LEN);
	local frame = memoSet:GetTopParentFrame();
	local before_name = frame:GetUserValue("EQP_NAME");
	local before_memo = frame:GetUserValue("EQP_MEMO");
	if before_name ~= "None" then
		name:SetText(before_name);
	end
	if before_memo ~= "None" then
		memo:SetText(before_memo);
	end

end

function JOURNAL_CRAFT_OPTION(frame, ctrl)
	frame = frame:GetTopParentFrame();
	JOURNAL_REMAKE_CRAFT(frame);
end

function JOURNAL_REMAKE_CRAFT(frame)

	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')
	local grid = GET_CHILD_RECURSIVELY(frame, "article");
	
	CREATE_JOURNAL_ARTICLE_CRAFT(frame, grid, 'Recipe', ScpArgMsg('Auto_JeJag'), 'journal_craet_icon', 'JOURNAL_OPEN_CRAFT_ARTICLE');
end


function JORNAL_CRAFT_UPDATE_INV(frame)
	frame:Invalidate();
end
