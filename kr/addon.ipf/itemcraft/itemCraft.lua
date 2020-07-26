--itemcraft.lua

function ITEMCRAFT_ON_INIT(addon, frame)
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_START', 'CRAFT_DETAIL_CRAFT_EXEC_ON_START');
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_FAIL', 'CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL');
	addon:RegisterMsg('JOURNAL_DETAIL_CRAFT_EXEC_SUCCESS', 'CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS');

	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'ITEMCRAFT_REFRSH');
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'ITEMCRAFT_REFRSH');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'ITEMCRAFT_REFRSH');

	addon:RegisterMsg('RESTQUICKSLOT_CLOSE', 'CRAFT_EXIT');
	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_CLOSE', 'CRAFT_EXIT');
	
	addon:RegisterMsg("PROGRESS_ITEM_CRAFT_MSG", "PROGRESS_ITEM_CRAFT_MSG");

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:SetSkinName('bg');
end

g_itemCraftFrameName = "itemcraft";
g_craftRecipe = nil;
g_craftRecipe_detail_item = nil;
g_craftRecipe_detail_memo = nil;
g_craftRecipe_makeBtn = nil;
g_craftRecipe_upDown = nil;

-- craftRecipe
function SET_ITEM_CRAFT_UINAME(uiName)
	g_itemCraftFrameName = uiName;

	g_craftRecipe = "craftRecipe";
	g_craftRecipe_detail_item = "craftRecipe_detail_item";
	g_craftRecipe_detail_memo = "craftRecipe_detail_memo";
	g_craftRecipe_makeBtn = "craftRecipe_makeBtn";
	g_craftRecipe_upDown =  "craftRecipe_numupdown";

	if uiName == "itemcraft_alchemist" then
		g_craftRecipe = g_craftRecipe .. "_alchemist";
		g_craftRecipe_detail_item = g_craftRecipe_detail_item .. "_alchemist";
		g_craftRecipe_detail_memo = g_craftRecipe_detail_memo .. "_alchemist";
		g_craftRecipe_makeBtn = g_craftRecipe_makeBtn .. "_alchemist";
	elseif	uiName == "itemcraft_fletching"	then
		g_craftRecipe = g_craftRecipe .. "_alchemist";
		g_craftRecipe_detail_item = g_craftRecipe_detail_item .. "_alchemist";
		g_craftRecipe_detail_memo = g_craftRecipe_detail_memo .. "_alchemist";
		g_craftRecipe_makeBtn = g_craftRecipe_makeBtn .. "_alchemist";
	end

end

function ITEMCRAFT_REFRSH(frame, msg, str, time)
	if msg == 'INV_ITEM_ADD' or msg == 'INV_ITEM_POST_REMOVE' or msg == 'INV_ITEM_CHANGE_COUNT' then
		DebounceScript("_ITEMCRAFT_REFRSH", 0.1);
	end
end

function _ITEMCRAFT_REFRSH()
	local frame = ui.GetFrame(g_itemCraftFrameName);
	if frame == nil then
		return;
	end

	CREATE_CRAFT_ARTICLE(frame);
end

function CLOSE_ALL_ANOTHER_PAGE(nowpagename)

	local frame = ui.GetFrame(g_itemCraftFrameName);
	local slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;

	local tree = GET_CHILD_RECURSIVELY(frame, 'recipetree','ui::CTreeControl')

	local cnt = tree:GetAllTreeItemCount();
	for i = 0 , cnt - 1 do
		local item = tree:GetTreeItemByIndex(i);
		local page = item:GetObject();
		if page ~= nil then
			if page:GetClassName() == "page" and nowpagename ~= page:GetName() then
				page = tolua.cast(page, "ui::CPage");
				page:SetFocusedRowHeight(-1, slotHeight, 0.2, 0.7, 5);
				page:SetUserValue("minimized", 1);
				CRAFT_MINIMIZE_FOCUS(page);
			end
		end
	end
end

function ITEMCRAFT_FIRST_OPEN(frame)	
	CREATE_CRAFT_ARTICLE(frame);
end

function ITEMCRAFT_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	session.ResetItemList();

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("ITEMCRAFT_INV_ICON");
	RESET_INVENTORY_ICON();
	ui.CloseFrame('inventory');
    ui.CloseFrame('itemcraft');
end

function CRAFT_OPEN(frame)
	local f = ui.GetFrame(g_itemCraftFrameName);

	CREATE_CRAFT_ARTICLE(f)

	local bg = GET_CHILD(f, "bg", "ui::CGroupBox");
	bg:ShowWindow(1);

	local article = GET_CHILD(f, 'recipe', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(0);

	local group = GET_CHILD(f, 'Recipe', 'ui::CGroupBox')
	group:ShowWindow(1)
	imcSound.PlaySoundEvent('button_click_3');

	session.ResetItemList();
end

function SET_CRAFT_IDSPACE(frame, idSpace, arg1, arg2)
--	local frame = ui.GetFrame("itemcraft_alchemist");
	frame:SetUserValue("IDSPACE", idSpace);

	if arg1 ~= nil then
		frame:SetUserValue("IDSPACE_ARG1", arg1);
	end
	if arg2 ~= nil then
		frame:SetUserValue("IDSPACE_ARG2", arg2);
	end
end

function CRAFT_CHECK_Recipe(cls, arg1, arg2)
	if session.GetInvItemByName(cls.ClassName) ~= nil then
		return true;
	end

	return false;
end

function CHECK_PC_ABILITY(cls, arg1, arg2)
	local abil = session.GetAbilityByName(cls.ClassName)
	if abil ~= nil then
		return true;
	end

	return false;
end

function CRAFT_CHECK_Recipe_ItemCraft(cls, arg1, arg2)
	if cls.IDSpc == 'Skill_Ability' then
		return CHECK_PC_ABILITY(cls, arg1, arg2);
	end

	if cls.SklName == arg1 and cls.SklLevel <= tonumber(arg2) then
		return true;
	end

	return false;
end	
		
		
function CREATE_CRAFT_ARTICLE(frame)
	if g_craftRecipe == nil then
		return;
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	RESET_INVENTORY_ICON();

	local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

	local slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;

	local tree_box = GET_CHILD(group, 'recipetree_Box','ui::CGroupBox')
	local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')
	if nil == tree then
		return;
	end
	tree:Clear();
	tree:EnableDrawTreeLine(false)
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,100)
	tree:SetFontName("brown_18_b");
	tree:SetTabWidth(5);
	tree:EnableScrollBar(0);

	local idSpace = frame:GetUserValue("IDSPACE");
	
	if idSpace == "None" then
		idSpace = "Recipe";
		frame:SetUserValue("IDSPACE", "Recipe");
	end
	
	local arg1 = frame:GetUserValue("IDSPACE_ARG1");
	local arg2 = frame:GetUserValue("IDSPACE_ARG2");

	local clslist = GetClassList(idSpace);
	if clslist == nil then return end
    
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");	
	local checkHaveMaterial = showonlyhavemat:IsChecked();	

	local checkCraftFunc = _G["CRAFT_CHECK_".. idSpace];
	while cls ~= nil do     
		if checkCraftFunc(cls, arg1, arg2) == true then
			local haveM = CRAFT_HAVE_MATERIAL(cls);	-- 제작 가능 여부
			if checkHaveMaterial == 1 then
				if haveM == 1 then
					CRAFT_INSERT_CRAFT(cls, tree, slotHeight,haveM);
				end
			else
				CRAFT_INSERT_CRAFT(cls, tree, slotHeight,haveM);
			end
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

	tree:OpenNodeAll();

end

function CRAFT_UPDATE_PAGE(page, cls, haveMaterial, item)

	page:SetUserValue("CLASSID", cls.ClassID);
	if item == nil then
		item = GetClass('Item', cls.TargetItem);
	end

	local app = page:CreateOrGetControlSet(g_craftRecipe, cls.ClassName, 10, 10);
	local titleText = GET_CHILD(app, "name", "ui::CRichText");

	local font = "{@st42_yellow}{s20}";
	local ableText = ScpArgMsg('craft_able')
	if haveMaterial ~= 1 then
		font = "{@st66b}{s20}";
		ableText = ""
	end
	

    local pc = GetMyPCObject()
	
	local skill = GetSkill(pc, "Alchemist_Tincturing")
	local Level = 0;
	if nil ~= skill and g_itemCraftFrameName ~= "itemcraft" then
		Level= skill.Level;
		local abil = session.GetAbilityByName(cls.ClassName);
		if cls.IDSpc == 'Skill_Ability' and nil ~= abil then
			local abilObj =  GetIES(abil:GetObject());
			Level = abilObj.Level;

			-- 비급 특성 대상 아이템은 레벨을 표기하지 않도록 한다.
			if abilObj.Hidden == 1 then
				Level = 0;
			end
		end
	end
    local len = string.len(item.Name)
    local itmeName = string.sub(item.Name, 1, len - 1)

    if skill ~= nil and Level > 0 then
	    titleText:SetText(font ..itmeName..Level.. ableText .."{/}");
    else
        titleText:SetText(font ..item.Name.. ableText .."{/}");
    end
	local difficulty = GET_CHILD(app, "difficulty", "ui::CRichText");
	local difficultyText = GET_ITEM_GRADE_TXT(item, 24);
	difficulty:SetText(difficultyText);

	local icon = GET_CHILD(app, "icon", "ui::CPicture");
	icon:SetImage(item.Icon);
	icon:SetEnableStretch(1)
	--UI_ANIM(icon, "ItemCraftIconInit");
	icon:SetEventScript(ui.RBUTTONUP, 'CRAFT_BEFORE_START_CRAFT');
	icon:SetEventScriptArgString(ui.RBUTTONUP, cls.ClassName);
--T_ITEM_TOOLTIP_TYPE(icon, item.ClassID, item);
--on:SetTooltipArg('', item.ClassID, 0);
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, item.ClassName, '', item.ClassID, 0);

	app:SetEventScript(ui.LBUTTONUP, 'CRAFT_RECIPE_FOCUS');	
	app:SetOverSound('button_cursor_over_3');
	app:SetClickSound('button_click_big_2');

	page:Resize(page:GetWidth(), app:GetY() + app:GetHeight() + 20);

end

function CRAFT_INSERT_CRAFT(cls, tree, slotHeight, haveMaterial)

	local item = GetClass('Item', cls.TargetItem);
    	if item == nil then
    	    return 0;
    	end
	local groupName = item.GroupName;
	local classType = nil;
	if GetPropType(item, "ClassType") ~= nil then
		classType = item.ClassType;
	end

	local page = CRAFT_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType);
	CRAFT_UPDATE_PAGE(page, cls, haveMaterial, item);
end

function CRAFT_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType)
	
	local hGroup = tree:FindByValue(groupName);
	if tree:IsExist(hGroup) == 0 then
		hGroup = tree:Add(ScpArgMsg(groupName), groupName);
		tree:SetNodeFont(hGroup,"brown_18_b")
	end

	local hParent = nil;
	if classType == nil then
		hParent = hGroup;
	else
		local hClassType = tree:FindByValue(hGroup, classType);
		if tree:IsExist(hClassType) == 0 then
			hClassType = tree:Add(hGroup, ScpArgMsg(classType), classType);
			tree:SetNodeFont(hClassType,"brown_18_b")
			
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
		CRAFT_MINIMIZE_FOCUS(page);
		tree:Add(hParent, page);	
		tree:SetNodeFont(hParent,"brown_18_b")		
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
		retStr = string.format("{@st66b}%s : %d", ClMsg(propName), baseValue);
	else
		retStr = string.format("{@st66b}%s : %d ~ %d", ClMsg(propName), baseValue, baseValue + randValue);
	end

	text:SetText(retStr);
end

function CRAFT_HAVE_MATERIAL(recipecls)
    local duplicationCnt = 1;
	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			
			local recipeItemCnt, invItemCnt = GET_RECIPE_MATERIAL_INFO(recipecls, i);            
			if math.is_larger_than(tostring(recipeItemCnt), tostring(invItemCnt)) == 1 then
				return 0;
			end
			
			if i > 1 and i < 5 then
			    if recipecls["Item_"..i.."_1"] == recipecls["Item_"..(i + 1).."_1"] then
			        duplicationCnt = duplicationCnt + 1;
			        if duplicationCnt > invItemCnt then
			            return 0;
			        end
			    else
			        duplicationCnt = 1;
			    end
			end
			
		end
	end

	return 1;
end

function SORT_INVITEM_BY_WORTH(a,b)
	local itemobj_a = GetIES(a:GetObject());
	local itemobj_b = GetIES(b:GetObject());

	local a_amuletcnt = 0
	local b_amuletcnt = 0

	for i = 0, 3-1 do
	    local tempvala = TryGetProp(itemobj_a,'MagicAmulet_' .. i)
   	    local tempvalb = TryGetProp(itemobj_b,'MagicAmulet_' .. i)
        
        if tempvala ~= nil and tempvalb ~= nil then
            if itemobj_a['MagicAmulet_' .. i] ~= 0 then
    			a_amuletcnt = a_amuletcnt + 1
    		end
    		if itemobj_b['MagicAmulet_' .. i] ~= 0 then
    			b_amuletcnt = b_amuletcnt + 1
    		end
        end
        
	end

	if a_amuletcnt ~= b_amuletcnt then
		return a_amuletcnt < b_amuletcnt
	end

	local a_gemexp = 0
	local b_gemexp = 0

	for i = 0, 4 do
		a_gemexp = a_gemexp +  a:GetEquipGemExp(i);
		b_gemexp = b_gemexp +  b:GetEquipGemExp(i);
	end

	if a_gemexp ~= b_gemexp then
		return a_gemexp < b_gemexp
	end

	local a_gemcnt = 0
	local b_gemcnt = 0

	for i = 0, 4 do
		if a:GetEquipGemID(i) ~= 0 then
			a_gemcnt = a_gemcnt + 1
		end
		if b:GetEquipGemID(i) ~= 0 then
			b_gemcnt = b_gemcnt + 1
		end
	end

	if a_gemcnt ~= b_gemcnt then
		return a_gemcnt < b_gemcnt
	end


	local a_socketcnt = 0
	local b_socketcnt = 0

	for i = 0, 4 do
		if a:IsAvailableSocket(i) == true then
			a_socketcnt = a_socketcnt + 1
		end
		if b:IsAvailableSocket(i) == true then
			b_socketcnt = b_socketcnt + 1
		end
	end

	if a_socketcnt ~= b_socketcnt then
		return a_socketcnt < b_socketcnt
	end

    local tempvala_reinforce = TryGetProp(itemobj_a,'Reinforce_2')
    local tempvalb_reinforce = TryGetProp(itemobj_b,'Reinforce_2')
    
    if tempvala_reinforce ~= nil and tempvalb_reinforce ~= nil then
    	if itemobj_a.Reinforce_2 ~= itemobj_b.Reinforce_2 then
	    	return itemobj_a.Reinforce_2  < itemobj_b.Reinforce_2 
    	end
    end
    
    local tempvala_PR = TryGetProp(itemobj_a,'PR')
    local tempvalb_PR = TryGetProp(itemobj_b,'PR')
    
    if tempvala_PR ~= nil and tempvalb_PR ~= nil then
    	if itemobj_a.PR ~= itemobj_b.PR then
	    	return itemobj_a.PR < itemobj_b.PR
    	end
    end

    -- 기간에 대한 부분 추가
    local lifeTimeA = TryGetProp(itemobj_a, 'ItemLifeTime');
    local lifeTimeB = TryGetProp(itemobj_b, 'ItemLifeTime');
    if lifeTimeA ~= nil and lifeTimeB ~= nil then
        local remainLifeTimeA = 2147483647;
        local remainLifeTimeB = 2147483647;

        -- 무기한 아이템은 애초에 ItemLifeTime이 0이라 보정해줘야 함
        if lifeTimeA ~= 'None' then
            remainLifeTimeA = GET_REMAIN_LIFE_TIME(lifeTimeA);
        end
        if lifeTimeB ~= 'None' then
            remainLifeTimeB = GET_REMAIN_LIFE_TIME(lifeTimeB);
        end

        if remainLifeTimeA ~= remainLifeTimeB then
            return remainLifeTimeA < remainLifeTimeB;
        end
    end

    if itemobj_a.GroupName == 'Gem' and itemobj_b.GroupName == 'Gem' then  -- 왠지 카드인 경우도 넣어야 할 듯 한데...
        local lv_a, curExp_a, maxExp_a = GET_ITEM_LEVEL_EXP(itemobj_a);
        local lv_b, curExp_b, maxExp_b = GET_ITEM_LEVEL_EXP(itemobj_b);
        
        if maxExp_a < maxExp_b then			
            return true;
        elseif maxExp_a > maxExp_b then
		    return false;
	    else
		    if curExp_a < curExp_b then
                return true;
            else
			    return false;
            end
        end  
    end

	return a:GetIESID() < b:GetIESID()	
end

function CRAFT_BEFORE_START_CRAFT(ctrl, ctrlset, recipeName, artNum)    
    
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('CannotUseInPVPZone'));
        return;
    end

	if session.world.IsIntegrateServer() == true or
	 session.world.IsIntegrateIndunServer() == true or
	 session.IsMissionMap() == true then      
	  ui.SysMsg(ClMsg("CannotCraftInIndun"));
      return
	end
	
	-- In Challenge Mode
	if info.GetBuffByName(session.GetMyHandle(), "ChallengeMode_Player") ~= nil then
		ui.SysMsg(ClMsg("CannotCraftInChallengeMode"));
		return
	end

	local frame = ctrlset:GetTopParentFrame();
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
	local someflag = 0;
    local lifeTimeOverFlag = false;
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);

		if IS_VALUEABLE_ITEM(tempitem.ItemID) == 1 then
			someflag = 1
		end

        if IS_LIFE_TIME_OVER_ITEM(tempitem.ItemID) then
            lifeTimeOverFlag = true;
        end
	end
    if lifeTimeOverFlag then
        ui.SysMsg(ClMsg('CannotUseLifeTimeOverItem'));
        return;
    end
    
    local recipeCls = GetClass('Recipe', recipeName)
    local targetItemName = TryGetProp(recipeCls, 'TargetItem', 'None')
    local targetItem = GetClass('Item', targetItemName,'None')
    local targetItemGrade = TryGetProp(targetItem, 'ItemGrade', 0)
    

	if someflag > 0  then
		local yesScp = string.format("CRAFT_START_CRAFT(\'%s\', \'%s\', %d)",idSpace, recipeName, totalCount);        
		ui.MsgBox(ScpArgMsg("IsValueAbleItem"), yesScp, "None");
	else   
		CRAFT_START_CRAFT(idSpace, recipeName, totalCount, upDown)        
	end
end

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

local function SET_REQITEM_CERTAIN_NUMBER()    
    local ctrl = GET_CHILD_RECURSIVELY(ui.GetFrame(g_itemCraftFrameName), "upDown", "ui::CNumUpDown");
    local topFrame = ui.GetFrame(g_itemCraftFrameName)    
	local frame = ctrl:GetParent();
	local idSpace = topFrame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, frame:GetName());
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");

	local number  = ctrl:GetNumber();
	if 0 >= number then
		ctrl:SetNumberValue(0);
		return
	end

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if nil ~= invItemlist then
				for j = 0, recipeItemCnt - 1 do
					local slot = frame:GetChild("EACHMATERIALITEM_" .. i ..'_'.. j);
					if nil ~= slot then
						local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
						needcountTxt:SetTextByKey("count", recipeItemCnt * number);
					end
				end
			else
				local slot = frame:GetChild("EACHMATERIALITEM_" .. i);
				if nil ~= slot then
					local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
					needcountTxt:SetTextByKey("count", recipeItemCnt * number);
				end
			end
		end
	end
end

local function startswith(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end


-- 제작하기에 충분한 재료를 가지고 있는지 체크한다.
local function CHECK_MATERIAL_COUNT(recipecls, totalCount)    
    local havingItemCount = {}      -- 가지고 있는 재료 수
    local requiredItemCount = {}    -- 제작에 필요한 재료 수
    
    local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipecls);
    local IsValidRecipeMaterial = _G[validRecipeMaterial];

    for index = 1, 5 do
        local clsName = "Item_"..index.."_1";
		local itemName = recipecls[clsName];
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, clsName);        
        if itemName ~= 'None' then
            havingItemCount[itemName] = 0
            if recipeItemCnt ~= nil and recipeItemCnt ~= 'None' then
                if requiredItemCount[itemName] == nil then  -- 경험의서 합치기처럼 같은 아이템 목록이 있을 수 있기 때문에 map으로 같은 종류를 묶는다.
                    requiredItemCount[itemName] = recipeItemCnt * totalCount
                else
                    requiredItemCount[itemName] = requiredItemCount[itemName] + (recipeItemCnt * totalCount)
                end
            end            
        end
    end
        
	local invItemList = session.GetInvItemList();
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, havingItemCount)		
		if invItem ~= nil then
            for key, value in pairs(havingItemCount) do
                local item_classname = GetIES(invItem:GetObject()).ClassName
                if item_classname ~= nil and IsValidRecipeMaterial(key, GetIES(invItem:GetObject())) and invItem.isLockState == false then                    
                    havingItemCount[key] = havingItemCount[key] + invItem.count
                end    
            end
	    end
	end, false, havingItemCount);

    local max_try_count = 210000000 -- 가진 재료로 최대로 만들 수 있는 개수
        
    if totalCount == 0 then
        totalCount = 1
    end

    for key, requiredCount in pairs(requiredItemCount) do
        local unit = requiredCount / totalCount
        local current_cnt = toint(havingItemCount[key] / unit)        

        if max_try_count > current_cnt then
            max_try_count = current_cnt    
        end        
    end

    for key, requiredCount in pairs(requiredItemCount) do        
        if requiredCount > havingItemCount[key] then
            return false, max_try_count    -- 재료 부족
        end
    end

    return true, 0 -- 조건 만족
end

function CRAFT_START_CRAFT(idSpace, recipeName, totalCount, upDown)    
	control.DialogEscape();
	local frame = ui.GetFrame(g_itemCraftFrameName);
	local ctrl = GET_CHILD_RECURSIVELY(frame, "LABEL", "ui::CGroupBox");

	local recipecls = GetClass(idSpace, recipeName);
	local nameList = nil;
	local targetItem = GetClass("Item", recipecls.TargetItem);
	
    frame:SetUserValue('customize_name', '')
    frame:SetUserValue('customize_memo', '')

	if IS_EQUIP(targetItem) then
		local cset = ctrl:GetParent()
		local memoSet = cset:GetChild("MEMO");

		if memoSet ~= nil then
			local name = memoSet:GetChild("name"):GetText();
			local memo = memoSet:GetChild("memo"):GetText();

			nameList = NewStringList();
			
			if GetUTF8Len(name) > RECIPE_ITEM_NAME_LEN then
				ui.SysMsg(ScpArgMsg("RecipeItemNameCantExceed{Auto_1}Byte", "Auto_1", RECIPE_ITEM_NAME_LEN));
				return;
			end
			
			if GetUTF8Len(memo) > ITEM_MEMO_LEN then	
				ui.SysMsg(ScpArgMsg("RecipeMemoCantExceed{Auto_1}Byte", "Auto_1", ITEM_MEMO_LEN));
				return;
			end

			if ui.IsValidItemName(name, 1) == false then
				return;
			end

			if ui.IsValidItemName(memo) == false then
				return;
			end

            frame:SetUserValue('customize_name', name)
            frame:SetUserValue('customize_memo', memo)

			nameList:Add(name);
			nameList:Add(memo);
		end
	end

    local flag, cnt = CHECK_MATERIAL_COUNT(recipecls, totalCount)
    if flag == false then
        ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
        if upDown ~= nil then
            upDown:SetNumberValue(cnt)
            ITMCRAFT_BUTTON_UP(upDown)
        end
		return
    end

    -- get validation script
    local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipecls);
    local IsValidRecipeMaterial = _G[validRecipeMaterial];

    local is_stack_item = true
	local resultlist = session.GetItemIDList();
	for index=1, 5 do
		local clsName = "Item_"..index.."_1";
		local itemName = recipecls[clsName];        
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, clsName);

		if 'None' ~= itemName then
			for j = 0, resultlist:Count() - 1 do
				local tempitem = resultlist:PtrAt(j);
				local invItem = session.GetInvItemByGuid(tempitem.ItemID);
				local itemobj = GetIES(invItem:GetObject());
                if itemobj ~= nil and itemobj.MaxStack == 1 then
                    is_stack_item = false
                end                
				if nil ~= invItem and IsValidRecipeMaterial(itemName, itemobj) then
					if true == invItem.isLockState then
						ui.SysMsg(ClMsg("MaterialItemIsLock"));
						return;
					end
					break
				end

				if resultlist:Count() - 1 == j then
					ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
					return;
				end
			end
		end
	end

	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end

	if TryGetProp(recipecls, "UseQueue") == "YES" then
		session.CopyTempItemID();
		local queueFrame = ui.GetFrame("craftqueue");
		CLEAR_CRAFT_QUEUE(queueFrame);		
		queueFrame:SetUserValue("RECIPE_NAME", recipeName);    

        if is_stack_item == true then
			ADD_CRAFT_QUEUE(queueFrame, targetItem, recipecls.ClassID, totalCount, is_stack_item);
        else
            for i = 1, totalCount do
			    ADD_CRAFT_QUEUE(queueFrame, targetItem, recipecls.ClassID, 1, is_stack_item);
		    end
        end

		if frame:GetUserIValue("MANUFACTURING") == 1 then
			return;
		end

	    frame:SetUserValue("MANUFACTURING", 1);
	    SetCraftState(1);
		ui.OpenFrame("craftqueue");	
		frame:SetUserValue("MANUFACTURING", 1);
	end

	local resultlist = session.GetItemIDList();
    local cntText = ''
    if is_stack_item == true then
        cntText = string.format("%s %s", recipecls.ClassID, totalCount);        
    else
        cntText = string.format("%s %s", recipecls.ClassID, 1)
    end
	
	SetCraftState(1);
	ui.SetHoldUI(true);

	frame:SetUserValue("IDSPACE", idSpace);
	item.DialogTransaction("SCR_ITEM_MANUFACTURE_" .. idSpace, resultlist, cntText, nameList);    
end

function IS_LIFE_TIME_OVER_ITEM(itemid)
    local invitem = session.GetInvItemByGuid(itemid);
	if invitem == nil then
		return true; -- 못쓰는 아이템이야
	end
	local itemobj = GetIES(invitem:GetObject());
    if itemobj == nil then
        return true;
    end
    local isLifeTimeOver = TryGetProp(itemobj, 'ItemLifeTimeOver');
    if isLifeTimeOver > 0 then
        return true;
    end
    return false;
end

function IS_VALUEABLE_ITEM(itemid)

	local invitem = session.GetInvItemByGuid(itemid);

	if nil == invitem then
		return;
	end

	local itemobj = GetIES(invitem:GetObject());

	if itemobj.ItemType ~= "Equip" then
		return 0
	end

	local amuletcnt = 0

	for i = 0, 3-1 do
		if itemobj['MagicAmulet_' .. i] ~= 0 then
			amuletcnt = amuletcnt + 1
		end
	end

	if amuletcnt > 0 then
		return 1
	end

	local gemcnt = 0

	for i = 0, 4 do
		if invitem:GetEquipGemID(i) ~= 0 then
		gemcnt = gemcnt + 1
		end
	end

	if gemcnt > 0 then
		return 1
	end

	if itemobj.ItemGrade >= 2 then
		return 1
	end

	if itemobj.Reinforce_2 > 0 then
		return 1
	end

	if itemobj.IsAwaken ~= 0 then
		return 1
	end

	return 0
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_START(frame, msg, str, time)
	frame = ui.GetFrame(g_itemCraftFrameName);
	if frame:GetUserIValue("MANUFACTURING") == 1 then
		
	end
end

function CANCEL_ANIM_ITEMCRAFT()
	local myActor = GetMyActor();
	if myActor ~= nil then
		myActor:SetHoldMovePath(false);
	end
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL(mainFrame, msg, str, time)
	local myActor = GetMyActor();
	if myActor ~= nil then
		myActor:SetHoldMovePath(true);
	end

	AddLuaTimerFuncWithLimitCount("CANCEL_ANIM_ITEMCRAFT", 1500, 1);

	local frame = ui.GetFrame(g_itemCraftFrameName)
	if nil == frame then
		mainFrame:SetUserValue("MANUFACTURING", 0);
		return;
	end

	if frame:GetUserIValue("MANUFACTURING") == 1 then
		local queueFrame = ui.GetFrame("craftqueue");
		CLEAR_CRAFT_QUEUE(queueFrame);
		ui.CloseFrame("craftqueue");
	end
	frame:SetUserValue("MANUFACTURING", 0);
	SetCraftState(0)
	ui.SetHoldUI(false);
end

function CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS(frame, msg, str, time)
	imcSound.PlaySoundEvent('sys_item_jackpot_get');

	frame = ui.GetFrame(g_itemCraftFrameName)
	if frame:GetUserIValue("MANUFACTURING") ~= 1 then       
		return;
	end

	local queueFrame = ui.GetFrame("craftqueue");
	local recipeType, totalCount = REMOVE_CRAFT_QUEUE(queueFrame);
	local remainCount = GET_CRAFT_REMAIONCOUNT(queueFrame);
	if recipeType == nil then
		frame:SetUserValue("MANUFACTURING", 0);
		SetCraftState(0)
		ui.SetHoldUI(false);
		return;
	elseif totalCount ~= remainCount and string.find(str, "Premium_boostToken") == nil then
		if frame:GetUserIValue("MANUFACTURING") == 1 then
			CLEAR_CRAFT_QUEUE(queueFrame);
			ui.CloseFrame("craftqueue");
		end

	    frame:SetUserValue("MANUFACTURING", 0);
	    SetCraftState(0)
		ui.SetHoldUI(false);
		return;
	end

	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClassByType(idSpace, recipeType);
	local resultlist = session.GetTempItemIDList();--session.GetItemIDList();
	local cntText = string.format("%s %s", recipecls.ClassID, totalCount);
    local targetItem = GetClass("Item", recipecls.TargetItem);
	
    local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipecls);
    local IsValidRecipeMaterial = _G[validRecipeMaterial];    
    local map_classname = {}  -- 제작에 필요한 아이템 목록
    local map_classID = {}
    local map_cnt = {}  -- 제작에 필요한 아이템별 필요 개수
    local item_count = 0
    
	for index=1, 5 do        
		local clsName = "Item_"..index.."_1";        
		local itemName = recipecls[clsName];
        if itemName ~= 'None' then
            local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, clsName)
            if recipeItemCnt ~= 0 then
                item_count = item_count + 1
                map_classname[item_count] = itemName
                map_cnt[item_count] = recipeItemCnt                
            end
        end		
	end
    
    local extralist = {}    -- 중복 체크용 셋
    local ordered_list = {}
    local ordered_cnt = 1
    
    for i = 1, item_count do -- 제작에 필요한 아이템을 인벤에서 가져온다.        
        local classname = map_classname[i]    -- item ClassName
        
        local start, e = string.find(classname, 'R_')
        if start == 1 then
            local invItem = session.GetInvItemByName(classname);
            if invItem == nil then
                session.ResetItemList()
                ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		        CLEAR_CRAFT_QUEUE(queueFrame);
		        frame:SetUserValue("MANUFACTURING", 0);
		        SetCraftState(0)
				ui.SetHoldUI(false);         
                return
            else    -- 레시피 아이템이 존재하면
                if invItem.isLockState == false then
                    local invItemObj = GetIES(invItem:GetObject())
                    ordered_list[ordered_cnt] = invItem:GetIESID()
                    ordered_cnt = ordered_cnt + 1
                else
                    session.ResetItemList()
                    ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		            CLEAR_CRAFT_QUEUE(queueFrame);
		            frame:SetUserValue("MANUFACTURING", 0);
		            SetCraftState(0)
					ui.SetHoldUI(false);
                    return
                end
            end
        else
            local candidate_list = GET_SORTED_INV_ITEMLIST()        
            for j = 1, #candidate_list do
                local candidate_item_classname = GetIES(candidate_list[j]:GetObject()).ClassName
            
                if session.GetInvItemByGuid(candidate_list[j]:GetIESID()).isLockState == false then
                    if IsValidRecipeMaterial(classname, GetIES(candidate_list[j]:GetObject())) then                        
                        if geItemTable.IsStack(GetIES(candidate_list[j]:GetObject()).ClassID) == 1 then -- stack 형 아이템이라면
                            extralist[candidate_list[j]:GetIESID()] = candidate_list[j]:GetIESID()                
                            ordered_list[ordered_cnt] = candidate_list[j]:GetIESID()
                            ordered_cnt = ordered_cnt + 1                    
                            break
                        else                
                            if extralist[candidate_list[j]:GetIESID()] == nil and extralist[candidate_list[j]:GetIESID()] == nil then
                                extralist[candidate_list[j]:GetIESID()] = candidate_list[j]:GetIESID()
                                ordered_list[ordered_cnt] = candidate_list[j]:GetIESID()                                
                                ordered_cnt = ordered_cnt + 1
                                break
                            end
                        end
                    end            
                end            
            end
        end
    end

    session.ResetItemList()
    for i = 1, ordered_cnt - 1 do        
        if ordered_list[i] == nil or map_cnt[i] == nil then
            session.ResetItemList()
            ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		    CLEAR_CRAFT_QUEUE(queueFrame);
		    frame:SetUserValue("MANUFACTURING", 0);
			SetCraftState(0)
			ui.SetHoldUI(false);             
            return
        end
        session.AddItemID(ordered_list[i], map_cnt[i]);
    end
    
    resultlist = session.GetItemIDList()
    
    if resultlist:Count() ~= item_count then
        session.ResetItemList()
        ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		CLEAR_CRAFT_QUEUE(queueFrame);
		frame:SetUserValue("MANUFACTURING", 0);
		SetCraftState(0)
		ui.SetHoldUI(false);     
        return
    end 
    
    local nameList = NewStringList();

    if IS_EQUIP(targetItem) then
        local name = frame:GetUserValue('customize_name')
        local memo = frame:GetUserValue('customize_memo')
        nameList:Add(name)
	    nameList:Add(memo)
    end

	item.DialogTransaction("SCR_ITEM_MANUFACTURE_" .. idSpace, resultlist, cntText, nameList)
end

--- about detail controlset
function CRAFT_RECIPE_FOCUS(page, ctrlSet)
	
	session.ResetItemList();
	page = tolua.cast(page, "ui::CPage");
	local row = page:GetObjectRow(ctrlSet);
	local curFocus = page:GetFocusedRow();
	local minimized = page:GetUserIValue("minimized");
	local slotHeight = 0;

	if nil ~= g_craftRecipe then
		slotHeight = ui.GetControlSetAttribute(g_craftRecipe, 'height') + 5;	
	end
	
	if row == curFocus and minimized == 0 then
		page:SetFocusedRowHeight(-1, slotHeight, 0.2, 0.7, 5);
		page:SetUserValue("minimized", 1);
		CRAFT_MINIMIZE_FOCUS(page);

		INVENTORY_SET_CUSTOM_RBTNDOWN("None");
		RESET_INVENTORY_ICON();		
	else
		CRAFT_MINIMIZE_FOCUS(page);
		page:SetUserValue("minimized", 0);
		page:SetFocusedRow(row);
		local resultHeight = CRAFT_CRAFT_SET_DETAIL(ctrlSet, 1);
		if resultHeight ~= 0 then
			page:SetFocusedRowHeight(slotHeight, resultHeight, 0.15, 0.7, 5);
		end

		INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMCRAFT_INV_RBTN");
		INVENTORY_SET_ICON_SCRIPT("ITEMCRAFT_INV_ICON");
		ui.OpenFrame('inventory')

		CLOSE_ALL_ANOTHER_PAGE(page:GetName())
	end

	local invframe = ui.GetFrame('inventory')
	INVENTORY_UPDATE_ICONS(invframe)

end

function CRAFT_MINIMIZE_FOCUS(page)
	local curFocus = page:GetFocusedRow();
	local beforeFocus = page:GetObjectByRow(curFocus);	
	if beforeFocus ~= nil then
		CRAFT_CRAFT_SET_DETAIL(beforeFocus, 0);
	end
end

function CRAFT_CRAFT_SET_DETAIL(ctrlset, detailMode, ignoreUserValue)

	if nil == g_craftRecipe then
		return;
	end

	local curMode = ctrlset:GetUserIValue("DETAILMODE");
	if curMode == detailMode and ignoreUserValue ~= 1 then
		return 0;
	end
	ctrlset:SetUserValue("DETAILMODE", detailMode);
	local height = ui.GetControlSetAttribute(g_craftRecipe, 'height');
	if detailMode == 0 then
		ctrlset:Resize(ctrlset:GetWidth(), height);
		ctrlset:SetSkinName("test_skin_01");
		local icon = ctrlset:GetChild("icon");
		--UI_ANIM(icon, "ItemCraftIconSizeDown");
		local name = ctrlset:GetChild("name");
		--UI_ANIM(name, "ItemCraftIconTextLeft");
		local diff = ctrlset:GetChild("difficulty");
		--UI_ANIM(diff, "ItemCraftIconTextLeft");
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");
		return 0;
	else
		
		local frame = ui.GetFrame(g_itemCraftFrameName)
		frame:SetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME',ctrlset:GetName())		
		DESTROY_CHILD_BY_USERVALUE(ctrlset, "DETAIL_CTRL", "YES");		
		local icon = ctrlset:GetChild("icon");
		--UI_ANIM(icon, "ItemCraftIconSizeUp");
		local name = ctrlset:GetChild("name");
		--UI_ANIM(name, "ItemCraftIconTextRight");
		local diff = ctrlset:GetChild("difficulty");
		--UI_ANIM(diff, "ItemCraftIconTextRight");
		local itemHeight = CRAFT_MAKE_DETAIL_REQITEMS(ctrlset);
		local resizeHeight = height + itemHeight;
		return resizeHeight;
	end
	
	return 0;
end

function CRAFT_DETAIL_CTRL_INIT(ctrl)
	ctrl:SetUserValue("DETAIL_CTRL", "YES");
end

function ITEMCRAFT_INV_ICON(slot, reinfItemObj, invItem, itemobj)
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	
	local someflag = 0
	local resultlist = session.GetItemIDList();
	
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);
		if tempitem.ItemID == iconInfo:GetIESID() then
			someflag = 1
			break;
		end
	end

	if someflag == 1 then
		slot:Select(1)
	else
		slot:Select(0)
	end

end

function ITEMCRAFT_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame(g_itemCraftFrameName)
	local ITEM_CRAFT_NOW_FOCUSED_CSET_NAME = frame:GetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME')

	local nowCset = GET_CHILD_RECURSIVELY(frame,ITEM_CRAFT_NOW_FOCUSED_CSET_NAME,'ui::CControlSet')

	if nowCset == nil then
		return
	end

	imcSound.PlaySoundEvent('inven_equip');    

    local dropResult = 'FAIL'
	local cnt = nowCset:GetChildCount();
	for i = 0, cnt - 1 do
		local eachcset = nowCset:GetChildByIndex(i);
		if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
			
			local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")

			if selected == 'nonselected' then
				local targetslot = GET_CHILD(eachcset, "slot", "ui::CSlot");				
				local targeticon 	= targetslot:GetIcon();
				local targeticonInfo = targeticon:GetInfo();
				
				local icon 	= slot:GetIcon();
				local iconInfo = icon:GetInfo();

				local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);
				local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
				local needcount = tonumber(materialItemCnt)

				local resultlist = session.GetItemIDList();
	
				for i = 0, resultlist:Count() - 1 do
					local tempitem = resultlist:PtrAt(i);
					if tempitem.ItemID == iconInfo:GetIESID() then
						return
					end
				end
				
                local recipeCls = GetClass('Recipe', eachcset:GetUserValue('RECIPE_CLASS_NAME'));
                local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipeCls);
				local IsValidRecipeMaterial = _G[validRecipeMaterial];
				local tempinvitem = session.GetInvItemByGuid(iconInfo:GetIESID());
                local invItemObj = nil;
                if tempinvitem ~= nil then
                    invItemObj = GetIES(tempinvitem:GetObject());
				end
				
				if invItemObj~= nil and IsValidRecipeMaterial(eachcset:GetUserValue('ClassName'), invItemObj) and iconInfo.count >= needcount  then                    
					if true == tempinvitem.isLockState then
						ui.SysMsg(ClMsg("MaterialItemIsLock"));                        
						return;
					end
					
					if IS_EQUIP(invItemObj) == true then
						local frame = ui.GetFrame(g_itemCraftFrameName);
						frame:SetUserValue("TARGETSET", eachcset:GetName())
						frame:SetUserValue("TARGET_GUID", iconInfo:GetIESID())
						local equip = REGISTER_EQUIP(invItemObj, tempinvitem);						
						if equip == 1 then
							return;
						end
					end

					session.AddItemID(iconInfo:GetIESID(), needcount);
					local icon 		= targetslot:GetIcon();
					icon:SetColorTone('FFFFFFFF')
					SET_ITEM_TOOLTIP_BY_OBJ(icon, tempinvitem)

					eachcset:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
					
					targetslot:SetEventScript(ui.RBUTTONUP, "CRAFT_ITEM_CANCEL");
					targetslot:SetEventScriptArgString(ui.RBUTTONUP, tempinvitem:GetIESID())

					local invframe = ui.GetFrame('inventory')
					INVENTORY_UPDATE_ICONS(invframe);
                    dropResult = 'SUCCESS';

					local btn = GET_CHILD(eachcset, "btn", "ui::CButton");
										
					if btn ~= nil then
						btn:ShowWindow(0)
					end					

					return;
				end

			end
					
		end
	end

    if dropResult ~= 'SUCCESS' then
        ui.SysMsg(ClMsg('WrongDropItem'));
    end
end

local function _RUNFUNC_TO_MERGED_CTRLSET(ctrlset, setName, func)

	local setInfo = ui.GetControlSetInfo(setName);	
	if setInfo == nil then
		return;
	end

	local cnt = setInfo:GetControlCount();
	for i = 0 , cnt - 1 do
		local name = setInfo:GetControl(i):GetName();
		local child = ctrlset:GetChild(name);
		func(child);
	end

end

function CRAFT_MAKE_DETAIL_REQITEMS(ctrlset)	
	session.ResetItemList();

	local frame = ctrlset:GetTopParentFrame();
	local idSpace = frame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, ctrlset:GetName());
	local x = 140;
	local startY = 80;
	local y = startY;
	local labelBox = ctrlset:CreateOrGetControl("groupbox", "LABEL", 0, startY, ctrlset:GetWidth() , 30);	
	local cRicon = ctrlset:GetChild("icon");
	local minHeight = cRicon:GetHeight() + startY + 10;

	CRAFT_DETAIL_CTRL_INIT(labelBox);
	labelBox:SetSkinName("None");
	labelBox:ShowWindow(1);
	y = y + 10;

	local itemHeight = ui.GetControlSetAttribute(g_craftRecipe_detail_item, 'height');

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if invItemlist ~= nil then -- 재료 아이템이 비스택형이면 일로 온다
				for j = 0, recipeItemCnt - 1 do
					local itemSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_item, "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
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
					itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName);
                    itemSet:SetUserValue('RECIPE_CLASS_NAME', recipecls.ClassName);

					slot:SetOverSound('button_cursor_over_2');
					slot:SetClickSound('button_click');
				end
			else -- 재료 아이템이 스택형이면 일로 온다
				local itemSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_item, "EACHMATERIALITEM_" .. i, x, y);
				itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
				CRAFT_DETAIL_CTRL_INIT(itemSet);
				local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
				local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
				needcountTxt:SetTextByKey("count",recipeItemCnt)
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
				itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName);
				
				slot:SetOverSound('button_cursor_over_2');
				slot:SetClickSound('button_click');
		end
		end
	end

	if y < minHeight then
		y = minHeight;
	end;

	local verticalLine = GET_CHILD(ctrlset,'verticalLine','ui::CPicture')
	verticalLine:Resize(verticalLine:GetWidth(), y - verticalLine:GetY());
	y = y + 10;

	local gboxHeight = y - startY;
	labelBox:Resize(labelBox:GetWidth(), gboxHeight );
	
	local targetItem = GetClass("Item", recipecls.TargetItem);
	if IS_EQUIP(targetItem) == true then
		local memoSet = ctrlset:CreateOrGetControlSet(g_craftRecipe_detail_memo, "MEMO", 0, y);
		memoSet:SetSkinName('None');
		CRAFT_DETAIL_CTRL_INIT(memoSet);
		CRAFT_INIT_MEMO_SET(memoSet);
	end

	y = y + 10;

	ctrlset:MergeControlSet(g_craftRecipe_makeBtn, 100, y +5);
	_RUNFUNC_TO_MERGED_CTRLSET(ctrlset, g_craftRecipe_makeBtn, CRAFT_DETAIL_CTRL_INIT);
	local make = GET_CHILD(ctrlset, "make", "ui::CButton");
	make:SetEventScript(ui.LBUTTONUP, 'CRAFT_BEFORE_START_CRAFT');
	make:SetOverSound('button_over');
	make:SetClickSound('button_click_big');
	make:SetEventScriptArgString(ui.LBUTTONUP, recipecls.ClassName);
	make:ShowWindow(1)

	ctrlset:MergeControlSet(g_craftRecipe_upDown, 357, y + 5);
	_RUNFUNC_TO_MERGED_CTRLSET(ctrlset, g_craftRecipe_upDown, CRAFT_DETAIL_CTRL_INIT);
	y = y + ui.GetControlSetAttribute(g_craftRecipe_upDown, 'height');
	y = y + ui.GetControlSetAttribute(g_craftRecipe_makeBtn, 'height');
	local upDown = GET_CHILD(ctrlset, "upDown", "ui::CNumUpDown");
	upDown:SetNumChangeScp('ITMCRAFT_BUTTON_UP');
	upDown:SetNumberValue(1)
	upDown:ShowWindow(1)
upDown:SetOverSound('button_cursor_over_2');
	upDown:SetClickSound('button_click');

	y = y + 10

	return y - 60;
end

function ITMCRAFT_BUTTON_UP(ctrl)    
	local topFrame = ctrl:GetTopParentFrame();    
	local frame = ctrl:GetParent();
	local idSpace = topFrame:GetUserValue("IDSPACE");
	local recipecls = GetClass(idSpace, frame:GetName());
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");

	local number  = ctrl:GetNumber();
	if 0 >= number then
		ctrl:SetNumberValue(0);
		return;
	end

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if nil ~= invItemlist then
				for j = 0, recipeItemCnt - 1 do
					local slot = frame:GetChild("EACHMATERIALITEM_" .. i ..'_'.. j);
					if nil ~= slot then
						local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
						needcountTxt:SetTextByKey("count", recipeItemCnt * number);
					end
				end
			else
				local slot = frame:GetChild("EACHMATERIALITEM_" .. i);
				if nil ~= slot then
					local needcountTxt = GET_CHILD(slot, "needcount", "ui::CSlot");
					needcountTxt:SetTextByKey("count", recipeItemCnt * number);
				end
			end
		end
	end

end

function ITEMCRAFT_ON_DROP(cset, control, materialItemCnt, materialItemClassID)
	imcSound.PlaySoundEvent('inven_equip');

	local slot 	   		= tolua.cast(control, 'ui::CSlot');
	local needcount = tonumber(materialItemCnt)
	
	local itemname = cset:GetUserValue("ClassName")
	local invItem = session.GetInvItemByName(itemname);
	
	local liftIcon 				= ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();

	--등록 안된 IESID에 한하여
	local resultlist = session.GetItemIDList();
	
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);
		if tempitem.ItemID == iconInfo:GetIESID() then
			return
		end
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject())
	if IS_EQUIP(itemObj) == true then
		local frame = ui.GetFrame(g_itemCraftFrameName);
		frame:SetUserValue("TARGETSET", cset:GetName())
		frame:SetUserValue("TARGET_GUID", GetIESID(invItem))
		local equip = REGISTER_EQUIP(itemObj,  invItem);		
		if equip == 1 then
			return;
		end
	end

	if iconInfo.type == materialItemClassID and iconInfo.count >= needcount  then

		session.AddItemID(iconInfo:GetIESID(), needcount);
		local icon 		= slot:GetIcon();
		icon:SetColorTone('FFFFFFFF')
		cset:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
	end

	local invframe = ui.GetFrame('inventory')
	INVENTORY_UPDATE_ICONS(invframe)

end

function REMOVE_TAG(str)
	local pattern = "{[^}]*}";
	local clean = str:gsub(pattern, "");
	
	pattern = "}[^{]*{";  -- "}{" 도 제거.
	clean = clean:gsub(pattern, "");

	return clean;
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

function CRAFT_INIT_MEMO_SET(memoSet)
	local name = GET_CHILD(memoSet, "name", "ui::CEditControl");
	local memo = GET_CHILD(memoSet, "memo", "ui::CEditControl");
	--name:SetMaxLen(ITEM_MEMO_LEN);
	--memo:SetMaxLen(RECIPE_ITEM_NAME_LEN);
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

function CRAFT_CRAFT_OPTION(frame, ctrl)
	frame = frame:GetTopParentFrame();
	CREATE_CRAFT_ARTICLE(frame);
end

function CRAFT_EXIT(frame, msg, argStr, argNum)
	packet.StopTimeAction();
	ui.CloseFrame("timeaction");
	ui.CloseFrame(g_itemCraftFrameName);
end

function SORT_PURE_INVITEMLIST(a,b)
	-- 같은 ClassID를 가진 템일 경우 쓸모 없는 템부터 합성 하도록 정렬하는 함수. 
	-- 정렬순위 : 매직어뮬렛 > 총 젬 경험치 > 뚫린 소켓 수 > 현재 강화 횟수 > 남은 포텐셜 > 젬 레벨
	local itemobj_a = GetIES(a:GetObject());
	local itemobj_b = GetIES(b:GetObject());
    
    if itemobj_a.GroupName ~= 'Gem' and itemobj_b.GroupName ~= 'Gem' and itemobj_a.GroupName ~= 'Card' and itemobj_b.GroupName ~= 'Card' and itemobj_a.GroupName ~= 'Premium' then
    
    	local a_amuletcnt = 0
    	local b_amuletcnt = 0
    
    	for i = 0, 3-1 do
    		if itemobj_a['MagicAmulet_' .. i] ~= 0 then
    			a_amuletcnt = a_amuletcnt + 1
    		end
    		if itemobj_b['MagicAmulet_' .. i] ~= 0 then
    			b_amuletcnt = b_amuletcnt + 1
    		end
    	end
    
    	if a_amuletcnt ~= b_amuletcnt then
    		return a_amuletcnt < b_amuletcnt
    	end
    
    	local a_gemexp = 0
    	local b_gemexp = 0
    
    	for i = 0, 4 do
    		a_gemexp = a_gemexp + a:GetEquipGemExp(i);
    		b_gemexp = b_gemexp + b:GetEquipGemExp(i);
    	end
    
    	if a_gemexp ~= b_gemexp then
    		return a_gemexp < b_gemexp
    	end
    
    
    	local a_gemcnt = 0
    	local b_gemcnt = 0
    
    	for i = 0, 4 do
    		if a:GetEquipGemID(i) ~= 0 then
    			a_gemcnt = a_gemcnt + 1
    		end
    		if b:GetEquipGemID(i) ~= 0 then
    			b_gemcnt = b_gemcnt + 1
    		end
    	end
    
    	if a_amuletcnt ~= b_amuletcnt then
    		return a_amuletcnt < b_amuletcnt
    	end
    
    
    	local a_socketcnt = 0
    	local b_socketcnt = 0
    
    	for i = 0, 4 do
    		if a:IsAvailableSocket(i) == true then
    			a_socketcnt = a_socketcnt + 1
    		end
    		if b:IsAvailableSocket(i) == true then
    			b_socketcnt = b_socketcnt + 1
    		end
    	end
    
    	if a_socketcnt ~= b_socketcnt then
    		return a_socketcnt < b_socketcnt
    	end
    
    	if itemobj_a.Reinforce_2 ~= itemobj_b.Reinforce_2 then
    		return itemobj_a.Reinforce_2  < itemobj_b.Reinforce_2 
    	end
    
    	if itemobj_a.PR ~= itemobj_b.PR then
    		return itemobj_a.PR < itemobj_b.PR
    	end
    else        
        local lv_a, curExp_a, maxExp_a = GET_ITEM_LEVEL_EXP(itemobj_a);
        local lv_b, curExp_b, maxExp_b = GET_ITEM_LEVEL_EXP(itemobj_b);
        
        if maxExp_a < maxExp_b then			
            return true;
        elseif maxExp_a > maxExp_b then
			return false;
		else
			if curExp_a < curExp_b then
                return true;
            else
				return false;
            end
        end        
    end
    
	return a:GetIESID() < b:GetIESID()
	
end


function GET_SORTED_INV_ITEMLIST()
    local resultlist = {};
	local invItemList = session.GetInvItemList();
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, resultlist)		
		if invItem ~= nil then
			if invItem.isLockState == false then
				local itemobj = GetIES(invItem:GetObject());			
				resultlist[#resultlist+1] = invItem
			end
		end
	end, false, resultlist);

	table.sort(resultlist, SORT_INVITEM_BY_WORTH)
	return resultlist
end

function GET_ONLY_PURE_INVITEMLIST(type)
	local resultlist = {};
	local invItemList = session.GetInvItemList();
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, resultlist)		
		if invItem ~= nil then
			if invItem.type == type and invItem.isLockState == false then
				local itemobj = GetIES(invItem:GetObject());			
				resultlist[#resultlist+1] = invItem
			end
		end
	end, false, resultlist);

	table.sort(resultlist, SORT_PURE_INVITEMLIST);
	return resultlist
end

local _itemSet = nil
local _btn = nil

function CRAFT_ITEM_ALL(itemSet, btn)    
	_itemSet = itemSet
	_btn = btn
	
	local itemname = itemSet:GetUserValue("ClassName")
	local itemcls = GetClass("Item", itemname);
	local invItemlist = nil;
	local invItemadd = nil;
    local recipeCls = GetClass('Recipe', itemSet:GetUserValue('RECIPE_CLASS_NAME'));
    local ignoreType = false;
    if recipeCls ~= nil then
        local getMaterialScript = TryGetProp(recipeCls, 'GetMaterialScript');
        if getMaterialScript == nil then
            getMaterialScript = 'SCR_GET_RECIPE_ITEM';
        end
        local GetRecipeMaterialItemList = _G[getMaterialScript];        
        invItemlist = GetRecipeMaterialItemList(itemcls);        
        ignoreType = true; -- 별도의 스크립트 함수를 거치는 경우
    else        
	    invItemlist = GET_ONLY_PURE_INVITEMLIST(itemcls.ClassID);
    end

	if #invItemlist < 1 or invItemlist == nil then
		return;
	end

	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");
	local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);    
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	local needcount = tonumber(materialItemCnt);
	local resultlist = session.GetItemIDList();	

	local check_reinforce = false
	local restrict_reinforce = 0

	local legend_recipe = targetslot:GetUserValue('recipe_name')		
	if legend_recipe ~= 'None' then
		local legend_recipe_cls = GetClass('legendrecipe', legend_recipe)
		local token = StringSplit(itemSet:GetName(), '_')
		if #token >= 2 then
			local slot_number = token[2]
			 restrict_reinforce = TryGetProp(legend_recipe_cls, 'MaterialItemReinforce_' .. slot_number, 0)
			if restrict_reinforce ~= 0 then
				check_reinforce = true
			end
		end	
	end

	local min_reinforce = 1000

	for i = 1, #invItemlist do
		local tempinvItem = invItemlist[i];
		local isAlreadyAdd = 0

		for j = 0, resultlist:Count() - 1 do
			local tempitem = resultlist:PtrAt(j);
			if tempitem.ItemID == tempinvItem:GetIESID() then                
				isAlreadyAdd = 1
			end
		end

		if check_reinforce == true then
			local item_obj = GetIES(tempinvItem:GetObject())
			if isAlreadyAdd == 0 and tempinvItem.isLockState == false and TryGetProp(item_obj, 'Reinforce_2', 0) >= restrict_reinforce then				
				local diff = math.abs(TryGetProp(item_obj, 'Reinforce_2', 0) - restrict_reinforce)
				if diff < min_reinforce then
					min_reinforce = diff
					invItemadd = tempinvItem					
				end
			end
		else
		if isAlreadyAdd == 0 and tempinvItem.isLockState == false then
			invItemadd = tempinvItem
			break
		end
	end
	end

	if invItemadd == nil then
		if check_reinforce == true then
			ui.SysMsg(ScpArgMsg('MoreReinforceForCraft{count}', 'count', restrict_reinforce))
		end
		return
	end
	
	if true == invItemadd.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemObj = GetIES(invItemadd:GetObject())
	local item_guid = GetIESID(itemObj)
	itemSet:SetUserValue(itemSet:GetName(), tostring(item_guid))

	if IS_EQUIP(itemObj) == true then		
		-- 제작재료 강화수치 체크
		local legend_recipe = targetslot:GetUserValue('recipe_name')		
		if legend_recipe ~= 'None' then
			local legend_recipe_cls = GetClass('legendrecipe', legend_recipe)			
			local token = StringSplit(itemSet:GetName(), '_')
			if #token >= 2 then
				local slot_number = token[2]
				local restrict_reinforce = TryGetProp(legend_recipe_cls, 'MaterialItemReinforce_' .. slot_number, 0)
				if TryGetProp(itemObj, 'Reinforce_2', 0) < restrict_reinforce then
					ui.SysMsg(ScpArgMsg('MoreReinforceForCraft{count}', 'count', restrict_reinforce))
					return
				end
			end			
		end
		-- end of 제작재료 강화수치 체크

		local frame = ui.GetFrame(g_itemCraftFrameName);
		frame:SetUserValue("TARGETSET", itemSet:GetName())
		frame:SetUserValue("TARGET_GUID", GetIESID(itemObj))
		local equip = REGISTER_EQUIP_ForLegend(itemObj, invItemadd);				
		if equip == 1 then
			return;
		end
	end

	if (ignoreType or invItemadd.type == materialItemClassID) and invItemadd.count >= needcount then		
		session.AddItemID(invItemadd:GetIESID(), needcount);
		local icon 		= targetslot:GetIcon();
		SET_ITEM_TOOLTIP_BY_OBJ(icon, invItemadd)
		targetslot:SetEventScript(ui.RBUTTONUP, "CRAFT_ITEM_CANCEL");
		targetslot:SetEventScriptArgString(ui.RBUTTONUP,invItemadd:GetIESID())

		--슬롯 컬러톤 및 폰트 밝게 변경. 
		icon:SetColorTone('FFFFFFFF')
		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		btn:ShowWindow(0)
		INVENTORY_UPDATE_ICONS(invframe)
	end
end

-- 용병단 증표
function CRAFT_PVP_MINE_ITEM_ALL(itemSet, btn)
	local itemname = itemSet:GetUserValue("ClassName");
	
	if itemname ~= 'misc_pvp_mine2' then
		return;
	end
	
	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");	
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	
	if itemname == 'misc_pvp_mine2' then
		local myAccount = GetMyAccountObj()		
		local count = TryGetProp(myAccount, 'MISC_PVP_MINE2', '0')
		if count == 'None' then
			count = '0'
		end
		if math.is_larger_than(tostring(materialItemCnt), count) == 1 then
			ui.SysMsg(ClMsg('NotEnoughRecipe'))
			return
		end
		local icon = targetslot:GetIcon();			
		targetslot:SetEventScript(ui.RBUTTONUP, "CRAFT_ITEM_CANCEL");

		--슬롯 컬러톤 및 폰트 밝게 변경. 
		icon:SetColorTone('FFFFFFFF')
		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		btn:ShowWindow(0)		
	end
end

function CRAFT_ITEM_ALL_ForLegend()    
	if _itemSet == nil or _btn == nil then
		return
	end
	itemSet = _itemSet
	btn = _btn
	
	local itemname = itemSet:GetUserValue("ClassName")
	local itemcls = GetClass("Item", itemname);
	local invItemlist = nil;
	local invItemadd = nil;
    local recipeCls = GetClass('Recipe', itemSet:GetUserValue('RECIPE_CLASS_NAME'));
    local ignoreType = false;
    if recipeCls ~= nil then
        local getMaterialScript = TryGetProp(recipeCls, 'GetMaterialScript');
        if getMaterialScript == nil then
            getMaterialScript = 'SCR_GET_RECIPE_ITEM';
        end
        local GetRecipeMaterialItemList = _G[getMaterialScript];        
        invItemlist = GetRecipeMaterialItemList(itemcls);        
        ignoreType = true; -- 별도의 스크립트 함수를 거치는 경우
    else        
	    invItemlist = GET_ONLY_PURE_INVITEMLIST(itemcls.ClassID);
    end

	if #invItemlist < 1 or invItemlist == nil then
		return;
	end

	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");
	local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);    
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	local needcount = tonumber(materialItemCnt);
	local resultlist = session.GetItemIDList();	

	local check_reinforce = false
	local restrict_reinforce = 0

	local legend_recipe = targetslot:GetUserValue('recipe_name')		
	if legend_recipe ~= 'None' then
		local legend_recipe_cls = GetClass('legendrecipe', legend_recipe)
		local token = StringSplit(itemSet:GetName(), '_')
		if #token >= 2 then
			local slot_number = token[2]
			 restrict_reinforce = TryGetProp(legend_recipe_cls, 'MaterialItemReinforce_' .. slot_number, 0)
			if restrict_reinforce ~= 0 then
				check_reinforce = true
			end
		end	
	end

	local min_reinforce = 1000

	for i = 1, #invItemlist do
		local tempinvItem = invItemlist[i];
		local isAlreadyAdd = 0

		for j = 0, resultlist:Count() - 1 do
			local tempitem = resultlist:PtrAt(j);
			if tempitem.ItemID == tempinvItem:GetIESID() then                
				isAlreadyAdd = 1
			end
		end

		if check_reinforce == true then
			local item_obj = GetIES(tempinvItem:GetObject())
			if isAlreadyAdd == 0 and tempinvItem.isLockState == false and TryGetProp(item_obj, 'Reinforce_2', 0) >= restrict_reinforce then				
				local diff = math.abs(TryGetProp(item_obj, 'Reinforce_2', 0) - restrict_reinforce)
				if diff < min_reinforce then
					min_reinforce = diff
					invItemadd = tempinvItem					
				end
			end
		else
		if isAlreadyAdd == 0 and tempinvItem.isLockState == false then
			invItemadd = tempinvItem
			break
		end
	end
	end

	if invItemadd == nil then
		return
	end
	
	if true == invItemadd.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemObj = GetIES(invItemadd:GetObject())
	local item_guid = GetIESID(itemObj)
	itemSet:SetUserValue(itemSet:GetName(), tostring(item_guid))

	if IS_EQUIP(itemObj) == true then		
		-- 제작재료 강화수치 체크
		local legend_recipe = targetslot:GetUserValue('recipe_name')		
		if legend_recipe ~= 'None' then
			local legend_recipe_cls = GetClass('legendrecipe', legend_recipe)			
			local token = StringSplit(itemSet:GetName(), '_')
			if #token >= 2 then
				local slot_number = token[2]
				local restrict_reinforce = TryGetProp(legend_recipe_cls, 'MaterialItemReinforce_' .. slot_number, 0)
				if TryGetProp(itemObj, 'Reinforce_2', 0) < restrict_reinforce then
					ui.SysMsg(ScpArgMsg('MoreReinforceForCraft{count}', 'count', restrict_reinforce))
					return
				end
			end			
		end
		-- end of 제작재료 강화수치 체크

		local frame = ui.GetFrame(g_itemCraftFrameName);
		frame:SetUserValue("TARGETSET", itemSet:GetName())
		frame:SetUserValue("TARGET_GUID", GetIESID(itemObj))		
	end

	if (ignoreType or invItemadd.type == materialItemClassID) and invItemadd.count >= needcount then		
		session.AddItemID(invItemadd:GetIESID(), needcount);
		local icon = targetslot:GetIcon();
		SET_ITEM_TOOLTIP_BY_OBJ(icon, invItemadd)
		targetslot:SetEventScript(ui.RBUTTONUP, "CRAFT_ITEM_CANCEL");
		targetslot:SetEventScriptArgString(ui.RBUTTONUP,invItemadd:GetIESID())

		--슬롯 컬러톤 및 폰트 밝게 변경. 
		icon:SetColorTone('FFFFFFFF')
		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		btn:ShowWindow(0)
		INVENTORY_UPDATE_ICONS(invframe)
	end
end


function ITEM_EQUIP_CRAFT()
	local frame = ui.GetFrame(g_itemCraftFrameName);	
	local ITEM_CRAFT_NOW_FOCUSED_CSET_NAME = frame:GetUserValue('ITEM_CRAFT_NOW_FOCUSED_CSET_NAME')	
	local nowCset = GET_CHILD_RECURSIVELY(frame,ITEM_CRAFT_NOW_FOCUSED_CSET_NAME,'ui::CControlSet')
	
	if nowCset == nil then	
		return
	end
	local itemSetName = frame:GetUserValue("TARGETSET")
	local itemSet = nowCset:GetChild(itemSetName)
	local itemGuid = frame:GetUserValue("TARGET_GUID")

	local invItem = session.GetInvItemByGuid(itemGuid);
	
	if invItem == nil then
		return
	end
	
	local targetslot = GET_CHILD(itemSet, "slot", "ui::CSlot");
	local btn = GET_CHILD(itemSet, "btn", "ui::CButton");
	
	if btn ~= nil then
		btn:ShowWindow(0)
	end

	local materialItemClassID = targetslot:GetEventScriptArgNumber(ui.DROP);
	local materialItemCnt = tonumber(targetslot:GetEventScriptArgString(ui.DROP));
	local needcount = tonumber(materialItemCnt)

	if invItem.type == materialItemClassID and invItem.count >= needcount then
		session.AddItemID(invItem:GetIESID(), needcount);
		local icon 		= targetslot:GetIcon();
		icon:SetColorTone('FFFFFFFF')
		SET_ITEM_TOOLTIP_BY_OBJ(icon, invItem)

		targetslot:SetEventScript(ui.RBUTTONUP, "CRAFT_ITEM_CANCEL");
		targetslot:SetEventScriptArgString(ui.RBUTTONUP, invItem:GetIESID())

		itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'selected');
		local invframe = ui.GetFrame('inventory')
		INVENTORY_UPDATE_ICONS(invframe)		
	end

end

function REGISTER_EQUIP_ForLegend(itemObj, invItem)		
	if itemObj.Reinforce_2 ~= 0 then
		local yesScp = string.format("CRAFT_ITEM_ALL_ForLegend()");
		ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
		return 1;
	else 		
		if itemObj.MaxSocket > 100 then itemObj.MaxSocket = 0 end
		for i = 0, itemObj.MaxSocket - 1 do        
			if invItem:IsAvailableSocket(i) then
				local yesScp = string.format("ITEM_EQUIP_CRAFT()");
				ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
				return 1;
			end            
		end		
	end

	return 0
end


-- Legend Item craft Able Y/N
function REGISTER_EQUIP(itemObj, invItem)		
	if itemObj.Reinforce_2 ~= 0 then
		local yesScp = string.format("ITEM_EQUIP_CRAFT()");
		ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
		return 1;
	else 		
		if itemObj.MaxSocket > 100 then itemObj.MaxSocket = 0 end
		for i = 0, itemObj.MaxSocket - 1 do        
			if invItem:IsAvailableSocket(i) then
				local yesScp = string.format("ITEM_EQUIP_CRAFT()");
				ui.MsgBox(ScpArgMsg("craft_really_make"), yesScp, "None");
				return 1;
			end            
		end		
	end

	return 0
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
	_RUNFUNC_TO_MERGED_CTRLSET(ctrlset, "journalRecipe_makeBtn", JOURNAL_DETAIL_CTRL_INIT);
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

	while cls ~= nil do
		if checkHaveMaterial == 1 then
			if JOURNAL_HAVE_MATERIAL(cls) == 1 then
				JOURNAL_INSERT_CRAFT(cls, tree, slotHeight);
			end
		else
			JOURNAL_INSERT_CRAFT(cls, tree, slotHeight);
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

	tree:OpenNodeAll();	
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




-- 아이템 제작 외에도 SetCraftState()를 이용해 유저 행동 제한하고 싶어서
-- 이쪽에서 안내 msg 내용 관리하도록 함
function PROGRESS_ITEM_CRAFT_MSG()
	local goddess_roulette_frame = ui.GetFrame("goddess_roulette");
	if goddess_roulette_frame:IsVisible() == 1 then
		return;
	end

	ui.SysMsg(ClMsg("prosessItemCraft"));
end