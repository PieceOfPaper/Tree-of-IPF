function LEGEND_CRAFT_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_LEGEND_CRAFT', 'ON_OPEN_DLG_LEGEND_CRAFT');
	addon:RegisterMsg('SUCCESS_LEGEND_CRAFT', 'ON_SUCCESS_LEGEND_CRAFT');
	addon:RegisterMsg('END_LEGEND_CRAFT', 'ON_END_LEGEND_CRAFT');
end

function ON_OPEN_DLG_LEGEND_CRAFT(frame)
	ui.OpenFrame('legend_craft');
end

function LEGEND_CRAFT_OPEN(frame)	
	LEGEND_CRAFT_INIT(frame);
    ui.OpenFrame('inventory');
end

function LEGEND_CRAFT_CLOSE(frame)
	control.DialogOk();
end

function LEGEND_CRAFT_INIT(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("None");

	LEGEND_CRAFT_INIT_RECIPE_LIST();
	LEGEND_CRAFT_DROPLIST_INIT(frame);
	LEGEND_CRAFT_MAKE_LIST(frame);
end

g_legendCraftRecipeTable = {}; -- key: DropGroupName, vlaue: className list
g_legendCraftRecipeTableByGroupName = {}; -- key: Item.GroupName, value: className list
g_legendArmorTable = {};
function LEGEND_CRAFT_INIT_RECIPE_LIST()
	if #g_legendCraftRecipeTable > 0 then
		return;
	end

	local clslist, cnt = GetClassList('legendrecipe');
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if g_legendCraftRecipeTable[cls.DropGroupName] == nil then
			g_legendCraftRecipeTable[cls.DropGroupName] = {};
		end
		local recipeList = g_legendCraftRecipeTable[cls.DropGroupName];
		g_legendCraftRecipeTable[cls.DropGroupName][#recipeList + 1] = cls.ClassName;

		local targetItem = GetClass('Item', cls.ClassName);		
		if g_legendCraftRecipeTableByGroupName[targetItem.GroupName] == nil then
			g_legendCraftRecipeTableByGroupName[targetItem.GroupName] = {};			
		end
		local nameList = g_legendCraftRecipeTableByGroupName[targetItem.GroupName];
		g_legendCraftRecipeTableByGroupName[targetItem.GroupName][#nameList + 1] = cls.ClassName;

		if targetItem.GroupName == 'Armor' and g_legendArmorTable[targetItem.Material] == nil then		
			g_legendArmorTable[targetItem.Material] = true;
		end
	end
end

function IS_HAVE_LEGEND_CRAFT_MATERIAL(recipeCls)
	local maxMaterialCnt = 5;
	for i = 1, maxMaterialCnt do
		local materialItemName = TryGetProp(recipeCls, 'MaterialItem_'..i, 'None');
		if materialItemName ~= 'None' then
			local invItem = session.GetInvItemByName(materialItemName);
			if invItem == nil or recipeCls['MaterialItemCnt_'..i] > invItem.count then
				return false;
			end
		end
	end
	return true;
end

function LEGEND_CRAFT_DROPLIST_INIT(frame)
    local groupDroplist = GET_CHILD_RECURSIVELY(frame, 'groupDroplist');    
    groupDroplist:ClearItems();
    local dropGroupIndex = 1;
    groupDroplist:AddItem(0, ClMsg('PartyShowAll'));
    for dropGroup, list in pairs (g_legendCraftRecipeTable) do
    	groupDroplist:AddItem(dropGroupIndex, dropGroup);
    	groupDroplist:SetUserValue('GROUP_INDEX_'..dropGroupIndex, dropGroup);
    	dropGroupIndex = dropGroupIndex + 1;
   	end
    
    local itemGroupNameDroplist = GET_CHILD_RECURSIVELY(frame, 'itemGroupNameDroplist');
    itemGroupNameDroplist:ClearItems();
    local groupNameIndex = 1;
    itemGroupNameDroplist:AddItem(0, ClMsg('PartyShowAll'));
    for groupName, list in pairs (g_legendCraftRecipeTableByGroupName) do
    	if groupName ~= 'Armor' then -- 방어구는 재료별로 따로 하기로 함
	    	itemGroupNameDroplist:AddItem(groupNameIndex, ClMsg(groupName));
	    	itemGroupNameDroplist:SetUserValue('GROUPNAME_INDEX_'..groupNameIndex, groupName);
	    	groupNameIndex = groupNameIndex + 1;
    	end
	end

	for material, dummy in pairs (g_legendArmorTable) do
		local clmsg = ClMsg('Armor');
		if material ~= 'None' then
			clmsg = clmsg..'-'..ClMsg(material);
		end
		itemGroupNameDroplist:AddItem(groupNameIndex, clmsg);
	    itemGroupNameDroplist:SetUserValue('GROUPNAME_INDEX_'..groupNameIndex, 'Armor');
	    itemGroupNameDroplist:SetUserValue('MATERIAL_OPTION_'..groupNameIndex, material);
	    groupNameIndex = groupNameIndex + 1;
	end
end

function LEGEND_CRAFT_MAKE_LIST(parent, ctrl)	
	session.ResetItemList();

	local frame = parent:GetTopParentFrame();
	local recipeBox = GET_CHILD_RECURSIVELY(frame, 'recipeBox');
	recipeBox:RemoveAllChild();

	local checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial = GET_LEGEND_CRAFT_SHOW_OPTION(frame);	
	local list = GET_LEGEND_CRAFT_TARGET_LIST_AND_CNT(frame);
	if list ~= nil then
		for i = 1, #list do
			local cls = GetClass('legendrecipe', list[i]);
			LEGEND_CRAFT_MAKE_CTRLSET(recipeBox, cls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial);
		end		
	else -- 옵션이 전부 모두 보기인 경우
		local clslist, cnt = GetClassList('legendrecipe');
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			LEGEND_CRAFT_MAKE_CTRLSET(recipeBox, cls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial)
		end
	end
	GBOX_AUTO_ALIGN(recipeBox, 0, 0, 0, true, false, true);
    recipeBox:SetScrollPos(0);
end

function GET_LEGEND_CRAFT_SHOW_OPTION(frame)
	local groupDroplist = GET_CHILD_RECURSIVELY(frame, 'groupDroplist');
	local itemGroupNameDroplist = GET_CHILD_RECURSIVELY(frame, 'itemGroupNameDroplist');
	local showOnlyEnableEquipCheck = GET_CHILD_RECURSIVELY(frame, 'showOnlyEnableEquipCheck');
	local showonlyhavemat = GET_CHILD_RECURSIVELY(frame, 'showonlyhavemat');
	return 	groupDroplist:GetUserValue('GROUP_INDEX_'..groupDroplist:GetSelItemIndex()), 
			itemGroupNameDroplist:GetUserValue('MATERIAL_OPTION_'..itemGroupNameDroplist:GetSelItemIndex()), 
			itemGroupNameDroplist:GetUserValue('GROUPNAME_INDEX_'..itemGroupNameDroplist:GetSelItemIndex()),
			showOnlyEnableEquipCheck:IsChecked(),
			showonlyhavemat:IsChecked();
end

function IS_NEED_TO_SHOW_LEGEND_RECIPE(frame, recipeCls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial)
	if checkGroup ~= 'None' then -- 그룹 체크
		if recipeCls.DropGroupName ~= checkGroup then
			return false;
		end
	end

	local targetItem = GetClass('Item', recipeCls.ClassName);	
	if checkGroupName ~= 'None' then -- 클래스 타입 체크
		if targetItem.GroupName ~= checkGroupName then
			return false;
		end

		if checkMaterial ~= 'None' and checkMaterial ~= targetItem.Material then
			return false;
		end
	end

	if checkEquipable == 1 then -- 착용 여부 체크
		local prop = geItemTable.GetProp(targetItem.ClassID);		
		local result = prop:CheckEquip(GETMYPCLEVEL(), GETMYPCJOB(), GETMYPCGENDER());
		if result ~= "OK" then
			return false;
		end
	end

	if checkHaveMaterial == 1 then -- 재료 체크
		if IS_HAVE_LEGEND_CRAFT_MATERIAL(recipeCls) == false then
			return false;
		end
	end

	return true;
end

function LEGEND_CRAFT_MAKE_CTRLSET(recipeBox, recipeCls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial)	
	if IS_NEED_TO_SHOW_LEGEND_RECIPE(frame, recipeCls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial) == false then
		return;
	end	

	local targetItem = GetClass('Item', recipeCls.ClassName);
	local ctrlset = recipeBox:CreateOrGetControlSet('earthTowerRecipe', 'RECIPE_'..recipeCls.ClassName, 0, 0);
	-- common
	local tradeBtn = GET_CHILD(ctrlset, 'tradeBtn');
	tradeBtn:SetTextByKey('text', ClMsg('Manufacture'));
	tradeBtn:SetUserValue('TARGET_RECIPE_NAME', recipeCls.ClassName);

	local itemIcon = GET_CHILD(ctrlset, 'itemIcon');
	itemIcon:SetImage(targetItem.Icon);
	SET_ITEM_TOOLTIP_BY_NAME(itemIcon, targetItem.ClassName);

	local itemName = GET_CHILD(ctrlset, 'itemName');
	itemName:SetTextByKey('value', targetItem.Name);

	local exchangeCount = GET_CHILD(ctrlset, 'exchangeCount');
	local labelline_1 = GET_CHILD(ctrlset, 'labelline_1');	
	exchangeCount:ShowWindow(0);
	labelline_1:ShowWindow(0);

	-- material
	local matBox = ctrlset:CreateControl('groupbox', 'matBox', itemIcon:GetX() + itemIcon:GetWidth(), itemIcon:GetY(), 270, 150);
	matBox = AUTO_CAST(matBox);
	matBox:SetSkinName('None');
	matBox:EnableScrollBar(0);

	local maxMaterialCnt = recipeCls.MaterialItemSlotCnt;
	for i = 1, maxMaterialCnt do
		local materialItemName = TryGetProp(recipeCls, 'MaterialItem_'..i, 'None');
		if materialItemName ~= 'None' then
			local matCtrlset = matBox:CreateOrGetControlSet('craftRecipe_detail_item', 'MATERIAL_'..i, 0, 0);
			matCtrlset:SetUserValue('ClassName', materialItemName);
			matCtrlset:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');

			local matItemCls = GetClass('Item', materialItemName);
			local item = GET_CHILD(matCtrlset, 'item');
			item:SetText(matItemCls.Name);

			local needcount = GET_CHILD(matCtrlset, 'needcount');
			local matItemCnt = recipeCls['MaterialItemCnt_'..i];
			needcount:SetTextByKey('count', matItemCnt);

			local slot = GET_CHILD(matCtrlset, 'slot');
			slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
			slot:SetEventScriptArgNumber(ui.DROP, matItemCls.ClassID);
			slot:SetEventScriptArgString(ui.DROP, matItemCnt);
			slot:EnableDrag(0);

			local icon = slot:GetIcon();
			if icon == nil then
				icon = CreateIcon(slot);
			end
			icon:SetImage(matItemCls.Icon);
			icon:SetColorTone('33333333')
		end
	end
	GBOX_AUTO_ALIGN(matBox, 0, 0, 0, true, true, true);

	local ypos = math.max(matBox:GetY() + matBox:GetHeight() + 20, itemIcon:GetY() + itemIcon:GetHeight() + 30);
	ctrlset:Resize(ctrlset:GetWidth(), ypos);
end

function GET_LEGEND_CRAFT_TARGET_LIST_AND_CNT(frame)
	local cacheHit = true;
	local list = GET_LEGEND_CRAFT_LIST_BY_GROUP(frame);
	local cnt = 0;
	if list == nil then
		list = GET_LEGEND_CRAFT_LIST_BY_CLASS_TYPE(frame);
	end
	return list;
end

function GET_LEGEND_CRAFT_LIST_BY_GROUP(frame)
	local groupDroplist = GET_CHILD_RECURSIVELY(frame, 'groupDroplist');	
	return g_legendCraftRecipeTable[groupDroplist:GetUserValue('GROUP_INDEX_'..groupDroplist:GetSelItemIndex())];
end

function GET_LEGEND_CRAFT_LIST_BY_CLASS_TYPE(frame)
	local itemGroupNameDroplist = GET_CHILD_RECURSIVELY(frame, 'itemGroupNameDroplist');	
	return g_legendCraftRecipeTable[itemGroupNameDroplist:GetUserValue('GROUPNAME_INDEX_'..itemGroupNameDroplist:GetSelItemIndex())];
end

function LEGEND_CRAFT_EXECUTE(parent, ctrl)
	local frame = ctrl:GetTopParentFrame();
	local targetRecipeName = ctrl:GetUserValue('TARGET_RECIPE_NAME');
	local ctrlset = GET_CHILD_RECURSIVELY(frame, 'RECIPE_'..targetRecipeName);
	if ctrlset == nil then
		return;
	end

	local recipeCls = GetClass('legendrecipe', targetRecipeName);
	local maxMaterialCnt = recipeCls.MaterialItemSlotCnt;
	for i = 1, maxMaterialCnt do
		local matCtrlset = GET_CHILD_RECURSIVELY(ctrlset, 'MATERIAL_'..i);
		if matCtrlset ~= nil then
			local btn = GET_CHILD(matCtrlset, 'btn');
			if btn:IsVisible() == 1 then
				ui.SysMsg(ClMsg('NotEnoughRecipe'));
				return;
			end
		end
	end
	
    ui.SetHoldUI(true);
	local argList = string.format("%d", recipeCls.ClassID);
    pc.ReqExecuteTx_Item("LEGEND_CRAFT", '0', argList);
end

function ON_SUCCESS_LEGEND_CRAFT(frame, msg, argStr, argNum)
	PLAY_BLACKSMITH_SUCCESS_EFFECT(argStr);	
	LEGEND_CRAFT_MAKE_LIST(frame);
end

function ON_END_LEGEND_CRAFT(frame, msg, argStr, argNum)	
	ui.SetHoldUI(false);
	ui.CloseFrame('fulldark_itemblacksmith');
	ui.CloseFrame('legend_craft');
end