function LEGEND_CRAFT_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_LEGEND_CRAFT', 'ON_OPEN_DLG_LEGEND_CRAFT');
	addon:RegisterMsg('SUCCESS_LEGEND_CRAFT', 'ON_SUCCESS_LEGEND_CRAFT');
	addon:RegisterMsg('END_LEGEND_CRAFT', 'ON_END_LEGEND_CRAFT');
end

function ON_OPEN_DLG_LEGEND_CRAFT(frame, msg, argStr)	
	LEGEND_CRAFT_TYPE_INIT(argStr);
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
	RESET_INVENTORY_ICON();

	local craftType = frame:GetUserValue("CRAFT_TYPE");
	if craftType == "LEGEND_CRAFT" then
		LEGEND_CRAFT_INIT_RECIPE_LIST();
		LEGEND_CRAFT_DROPLIST_INIT(frame);
		LEGEND_CRAFT_MAKE_LIST(frame);
	elseif craftType == "ARK_CRAFT" then
		LEGEND_CRAFT_MAKE_LIST(frame);
	elseif craftType == "SPECIAL_MISC_CRAFT" then
		SPECIAL_MISC_CRAFT_MAKE_LIST(frame)
	end		
end

-- CRAFT_TYPE : LEGEND_CRAFT = 레전드 장비 제작(테리아베리스)
--				ARK_CRAFT = 아크 제작 (바이도터스, 아벨루)
--				SPECIAL_MISC_CRAFT = 특수 재료 제작(아벨루)
function LEGEND_CRAFT_TYPE_INIT(craftType)
	local frame = ui.GetFrame('legend_craft');
	
	if craftType == nil then
		craftType = "LEGEND_CRAFT";
	end

	frame:SetUserValue("CRAFT_TYPE", craftType);

	local groupDroplist = GET_CHILD(frame, "groupDroplist");
	local itemGroupNameDroplist = GET_CHILD(frame, "itemGroupNameDroplist");
	local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat");
	local showOnlyEnableEquipCheck = GET_CHILD(frame, "showOnlyEnableEquipCheck");

	if craftType == "LEGEND_CRAFT" then
		groupDroplist:ShowWindow(1);
		itemGroupNameDroplist:ShowWindow(1);
		showonlyhavemat:ShowWindow(1);
		showOnlyEnableEquipCheck:ShowWindow(1);
	elseif craftType == "ARK_CRAFT" then
		groupDroplist:ShowWindow(0);
		itemGroupNameDroplist:ShowWindow(0);
		showonlyhavemat:ShowWindow(0);
		showOnlyEnableEquipCheck:ShowWindow(0);		
	elseif craftType == "SPECIAL_MISC_CRAFT" then			
		groupDroplist:ShowWindow(0);
		itemGroupNameDroplist:ShowWindow(0);
		showonlyhavemat:ShowWindow(0);
		showOnlyEnableEquipCheck:ShowWindow(0);
	end

	local ctrl = GET_CHILD(frame, "title");
	local title = frame:GetUserConfig(craftType);
	ctrl:SetTextByKey("value", title);

	local close = GET_CHILD(frame, "close");
	close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', title));
end

g_legendCraftRecipeTable = {}; -- key: DropGroupName, vlaue: className list
g_legendCraftRecipeTableByGroupName = {}; -- key: Item.GroupName, value: className list
g_legendArmorTable = {};
function LEGEND_CRAFT_INIT_RECIPE_LIST()	
	if #g_legendCraftRecipeTable > 0 then
		return;
	end

	local frame = ui.GetFrame('legend_craft');
	local craftType = frame:GetUserValue("CRAFT_TYPE");
	local clslist, cnt = GetClassList('legendrecipe');
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if cls.DropGroup ~= "Ark" then			
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

-- 클릭시 function CRAFT_ITEM_ALL()
function LEGEND_CRAFT_MAKE_LIST(frame)
	session.ResetItemList();

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

	local craftType = frame:GetUserValue("CRAFT_TYPE");
	if craftType == "LEGEND_CRAFT" and recipeCls.DropGroup == "Ark" then
		return false;
	end

	if craftType == "ARK_CRAFT" and recipeCls.DropGroup ~= "Ark" then
		return false;
	end

	return true;
end

function LEGEND_CRAFT_MAKE_CTRLSET(recipeBox, recipeCls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial)	
	local frame = ui.GetFrame('legend_craft');
	if IS_NEED_TO_SHOW_LEGEND_RECIPE(frame, recipeCls, checkGroup, checkMaterial, checkGroupName, checkEquipable, checkHaveMaterial) == false then
		return;
	end	

	local targetItem = GetClass('Item', recipeCls.ClassName);
	local ctrlset = recipeBox:CreateOrGetControlSet('earthTowerRecipe', 'RECIPE_'..recipeCls.ClassName, 0, 0);

	local itemCountGBox = GET_CHILD_RECURSIVELY(ctrlset, "gbox");
    if itemCountGBox ~= nil then
		itemCountGBox:ShowWindow(0);
    end

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
	local matBox = ctrlset:CreateControl('groupbox', 'matBox', itemIcon:GetX() + itemIcon:GetWidth(), itemIcon:GetY(), 500, 150);
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
			local require_reinforce = TryGetProp(recipeCls, 'MaterialItemReinforce_'.. i, 0)
			local prefix = ''
			if require_reinforce ~= 0 then
				prefix = '{#FF0000}+' .. tostring(require_reinforce) .. ' {/}'
			end

			item:SetText(prefix .. matItemCls.Name);

			local needcount = GET_CHILD(matCtrlset, 'needcount');
			local matItemCnt = recipeCls['MaterialItemCnt_'..i];
			needcount:SetTextByKey('count', matItemCnt);

			local slot = GET_CHILD(matCtrlset, 'slot');
			slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
			slot:SetEventScriptArgNumber(ui.DROP, matItemCls.ClassID);
			slot:SetEventScriptArgString(ui.DROP, matItemCnt);
			slot:SetUserValue("recipe_name", recipeCls.ClassName);  -- 제작 레시피
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

	local recipeCls = nil;
	local craftType = frame:GetUserValue("CRAFT_TYPE");
	if craftType == "SPECIAL_MISC_CRAFT" then
		local strlist = StringSplit(parent:GetName(), 'RECIPE_');
		recipeCls = GetClassByType("SpecialMiscRecipe", strlist[2]);
	else
		recipeCls = GetClass("legendrecipe", targetRecipeName);
	end
	if recipeCls == nil then
		return;
	end

	local argList = string.format("%d", recipeCls.ClassID);	
	local guid_list = {}

	local maxMaterialCnt = recipeCls.MaterialItemSlotCnt;
	for i = 1, maxMaterialCnt do
		local matCtrlset = GET_CHILD_RECURSIVELY(parent, 'MATERIAL_'..i);
		guid_list[i] = tostring(matCtrlset:GetUserValue(matCtrlset:GetName()))
		if matCtrlset ~= nil then
			local btn = GET_CHILD(matCtrlset, 'btn');
			if btn:IsVisible() == 1 then
				ui.SysMsg(ClMsg('NotEnoughRecipe'));
				return;
			end
		end
	end

	ui.SetHoldUI(true);
	if craftType == "SPECIAL_MISC_CRAFT" then
		-- 실버 부족 검사
		local silver = 0;
		local silvercost = recipeCls.SilverCost;
		local invItem = session.GetInvItemByName('Vis');
		if invItem ~= nil then
			silver = tonumber(invItem:GetAmountStr());
		end

		if silver < silvercost then
			ui.SysMsg(ScpArgMsg("REQUEST_TAKE_SILVER"));		
			return;
		end

    	local nameList = NewStringList();
    	nameList:Add(recipeCls.ClassID)    
	    session.ResetItemList();
		for i = 1, maxMaterialCnt do
			session.AddItemID(guid_list[i], 1);
		end
		local resultlist = session.GetItemIDList();
    	item.DialogTransaction("SPECIAL_MISC_CRAFT", resultlist, "", nameList);    
	else
		pc.ReqExecuteTx_Item2("LEGEND_CRAFT", guid_list[1], guid_list[2], guid_list[3], argList);

	end
end

function ON_SUCCESS_LEGEND_CRAFT(frame, msg, argStr, argNum)
	local craftType = frame:GetUserValue("CRAFT_TYPE");
	PLAY_BLACKSMITH_SUCCESS_EFFECT(argStr, craftType, argNum);
	
	if craftType == "LEGEND_CRAFT" then
		LEGEND_CRAFT_MAKE_LIST(frame);
	elseif craftType == "ARK_CRAFT" then
		LEGEND_CRAFT_MAKE_LIST(frame);
	elseif craftType == "SPECIAL_MISC_CRAFT" then
		SPECIAL_MISC_CRAFT_MAKE_LIST(frame)
	end		
end

function ON_END_LEGEND_CRAFT(frame, msg, argStr, argNum)	
	ui.SetHoldUI(false);
	ui.CloseFrame('fulldark_itemblacksmith');
	ui.CloseFrame('legend_craft');
end

---------------------- 특수 재료 제작 -----------------------------
function SPECIAL_MISC_CRAFT_MAKE_LIST(frame)
	session.ResetItemList();

	local recipeBox = GET_CHILD_RECURSIVELY(frame, 'recipeBox');
	recipeBox:RemoveAllChild();

	local clslist, cnt = GetClassList("SpecialMiscRecipe");
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if cls ~= nil then
			SPECIAL_MISC_MAKE_CTRLSET(recipeBox, cls)
		end
	end

	GBOX_AUTO_ALIGN(recipeBox, 0, 0, 0, true, false, true);
    recipeBox:SetScrollPos(0);
end

function SPECIAL_MISC_MAKE_CTRLSET(recipeBox, recipeCls)
	local frame = recipeBox:GetTopParentFrame();

	local targetItem = GetClass('Item', recipeCls.TargetItem);
	local ctrlset = recipeBox:CreateOrGetControlSet('craft_recipe', 'RECIPE_'..recipeCls.ClassID, 0, 0);

	local itemCountGBox = GET_CHILD_RECURSIVELY(ctrlset, "gbox");
    if itemCountGBox ~= nil then
		itemCountGBox:ShowWindow(0);
    end

	-- common
	local tradeBtn = GET_CHILD(ctrlset, 'tradeBtn');
	tradeBtn:SetTextByKey('text', ClMsg('Manufacture'));
	tradeBtn:SetUserValue('TARGET_RECIPE_NAME', recipeCls.TargetItem);

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
	local matBox = ctrlset:CreateControl('groupbox', 'matBox', itemIcon:GetX() + itemIcon:GetWidth(), itemIcon:GetY(), 500, 150);
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
			item:AdjustFontSizeByWidth(item:GetWidth());

			local needcount = GET_CHILD(matCtrlset, 'needcount');
			local matItemCnt = recipeCls['MaterialItemCnt_'..i];
			needcount:SetTextByKey('count', matItemCnt);

			local slot = GET_CHILD(matCtrlset, 'slot');
			slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
			slot:SetEventScriptArgNumber(ui.DROP, matItemCls.ClassID);
			slot:SetEventScriptArgString(ui.DROP, matItemCnt);
			slot:SetUserValue("recipe_name", recipeCls.TargetItem);  -- 제작 레시피
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

	local cost_value = GET_CHILD_RECURSIVELY(ctrlset, 'cost_value');
	cost_value:SetText(GetCommaedString(recipeCls.SilverCost));

	local ypos = math.max(matBox:GetY() + matBox:GetHeight() + 60, itemIcon:GetY() + itemIcon:GetHeight() + 70);
	ctrlset:Resize(ctrlset:GetWidth(), ypos);
end