ADVENTURE_BOOK_CRAFT = {};
ADVENTURE_BOOK_CRAFT.SELECTED_ITEM = "";
ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX = 1;
ADVENTURE_BOOK_CRAFT.CUR_LIST_COUNT = 0;

function ADVENTURE_BOOK_CRAFT.RENEW()
	ADVENTURE_BOOK_CRAFT.CLEAR();
	ADVENTURE_BOOK_CRAFT.FILL_CRAFT_LIST();
	ADVENTURE_BOOK_CRAFT.DROPDOWN_LIST_INIT();
    ADVENTURE_BOOK_CRAFT_SET_POINT();
	
	local craft_list_func = ADVENTURE_BOOK_CRAFT_CONTENT["CRAFT_LIST_ALL"];
	local craft_list = craft_list_func();
	if #craft_list < 1 then
		return;
	end
	if ADVENTURE_BOOK_CRAFT.SELECTED_ITEM == "" then
		ADVENTURE_BOOK_CRAFT.SELECTED_ITEM = craft_list[1]['target']
	end
	ADVENTURE_BOOK_CRAFT.FILL_CRAFT_INFO();
end

function ADVENTURE_BOOK_CRAFT.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_craft", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "craft_elem_list", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "craft_item_info_gb", "ui::CGroupBox");
	
	list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_CRAFT.FILL_CRAFT_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_craft", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "craft_elem_list", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	local sub_category_opt_list = GET_CHILD(page, "sub_category_opt_list", "ui::CDropList");
	local search_editbox = GET_CHILD(page, "search_editbox");
    local SIHOUETTE_COLOR_TONE = frame:GetUserConfig('SIHOUETTE_COLOR_TONE');
	list_box:RemoveAllChild()
	
	local craft_list_func = ADVENTURE_BOOK_CRAFT_CONTENT["CRAFT_LIST_ALL"];
	local craft_recipe_info_func = ADVENTURE_BOOK_CRAFT_CONTENT["CRAFT_RECIPE_INFO"];
	local craft_material_info_func = ADVENTURE_BOOK_CRAFT_CONTENT["CRAFT_MATERIAL_INFO"];
	local filter_func = ADVENTURE_BOOK_CRAFT_CONTENT['FILTER_LIST']

	local craft_list = craft_list_func();
	craft_list = filter_func(craft_list, sort_opt_list:GetSelItemIndex(), category_opt_list:GetSelItemIndex(), sub_category_opt_list:GetSelItemIndex(), search_editbox:GetText())
	ADVENTURE_BOOK_CRAFT.CUR_LIST_COUNT = (#craft_list)
	local firstIndex, lastIndex = ADVENTURE_BOOK_CRAFT.CUR_GROUP_INDICES()
	local y = 0;
	for i=1, lastIndex do
		local recipeClsName = craft_list[i]['recipe']
		local targetClsName = craft_list[i]['target']
		local target_info =  craft_recipe_info_func(recipeClsName, targetClsName)
		local material_info_list =  craft_material_info_func(recipeClsName)

		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_craft_elem", "list_craft_" .. i, ui.LEFT, ui.TOP, 0, y, 0, 0);
		ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');
    	local ARROW_OPEN = ctrlSet:GetUserConfig('ARROW_OPEN');
    	local ARROW_CLOSE = ctrlSet:GetUserConfig('ARROW_CLOSE');

		local ctrlSetGb = GET_CHILD(ctrlSet, "gb", "ui::CGroupBox");
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		icon:SetImage(target_info['icon']);
		SET_TEXT(ctrlSet, "name_text", "value", target_info['name'])
		ctrlSet:SetUserValue('BtnArg', targetClsName);
		if target_info['is_found'] == 0 then
            ctrlSet:SetColorTone(SIHOUETTE_COLOR_TONE);
		end

        ADVENTURE_BOOK_CRAFT_SET_LIST_ITEM_POINT(ctrlSet, target_info['class_id']);

		local isOpened = 0;
		local material_height = frame:GetUserConfig("CRAFT_MATERIAL_HEIGHT")
		local elem_closed_height = frame:GetUserConfig("CRAFT_ELEM_HEIGHT")
		local material_margin_top = frame:GetUserConfig("CRAFT_MATERIAL_MARGIN_TOP")
		local material_margin_bottom  = frame:GetUserConfig("CRAFT_MATERIAL_MARGIN_BOTTOM")
		local elem_opened_height = elem_closed_height + material_height*#material_info_list + material_margin_top+material_margin_bottom;
		if #material_info_list > 0 and tostring(ADVENTURE_BOOK_CRAFT.SELECTED_ITEM) == tostring(targetClsName) then
			 isOpened = 1;
		end

		if isOpened == 1 then
			SET_TEXT(ctrlSet, "arrow_text", "value", ARROW_CLOSE);
		elseif #material_info_list > 0 then
			SET_TEXT(ctrlSet, "arrow_text", "value", ARROW_OPEN);
		else
			SET_TEXT(ctrlSet, "arrow_text", "value", "");
		end

		y = y + elem_closed_height;
		if isOpened == 1 then
			y = y + material_margin_top
			for m = 1, #material_info_list do
				local material_info = material_info_list[m];
				if material_info['class_name'] ~= nil and material_info['class_name'] ~= 'None' then
					local materialCtrlSet = list_box:CreateOrGetControlSet("adventure_book_craft_material", "list_craft_" .. i .. "_material_" .. m, ui.LEFT, ui.TOP, 0, y, 0, 0);
					y = y + material_height;
					local materialPic = GET_CHILD(materialCtrlSet, "icon_pic", "ui::CPicture");
                    if material_info['icon'] ~= 'None' then
					    materialPic:SetImage(material_info['icon']);
                    end
                    SET_ITEM_TOOLTIP_BY_NAME(materialPic, material_info['class_name']);
                    materialPic:SetTooltipOverlap(1);
					
					if target_info['is_found'] == 0 then
						materialPic:SetColorTone(SIHOUETTE_COLOR_TONE);
					end

                    local score_guage = GET_CHILD(materialCtrlSet, 'score_guage');                    
                    score_guage:SetPoint(material_info['count'], material_info['max_count']);
				end
			end
			ctrlSet:Resize(ctrlSet:GetOriginalWidth(), elem_opened_height)
			ctrlSetGb:Resize(ctrlSetGb:GetOriginalWidth(), elem_opened_height)
			y = y + material_margin_bottom
		end
	end
end

function ADVENTURE_BOOK_CRAFT.INCREASE_GROUP_INDEX()
	local maxIndex = ADVENTURE_BOOK_CRAFT.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX = ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX + 1;
	end
end
function ADVENTURE_BOOK_CRAFT.MAX_GROUP_INDEX()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local ret = math.ceil(ADVENTURE_BOOK_CRAFT.CUR_LIST_COUNT / count)
	return ret;
end
function ADVENTURE_BOOK_CRAFT.CUR_GROUP_INDICES()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local firstIndex = 1+count*(ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX-1);
	local lastIndex = 1+count*(ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX);
	firstIndex = math.min(firstIndex, ADVENTURE_BOOK_CRAFT.CUR_LIST_COUNT)
	lastIndex = math.min(lastIndex, ADVENTURE_BOOK_CRAFT.CUR_LIST_COUNT)
	return firstIndex, lastIndex
end

function ADVENTURE_BOOK_CRAFT.FILL_CRAFT_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_craft", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "craft_item_info_gb", "ui::CGroupBox");
	info_box:RemoveAllChild();

	if ADVENTURE_BOOK_CRAFT.SELECTED_ITEM == "" then
		return;
	end

	local ctrlName = 'adventure_book_item_info_material'
	local item_info_func =  ADVENTURE_BOOK_CRAFT_CONTENT['CRAFT_TARGET_INFO']
	local info_gb_func_name = 'FILL_ITEM_INFO_MATERIAL';
	
	local info = item_info_func(ADVENTURE_BOOK_CRAFT.SELECTED_ITEM);
	if info['type'] == 'Equip' then
		ctrlName = 'adventure_book_item_info_equip'
		info_gb_func_name = 'FILL_ITEM_INFO_EQUIP'
	elseif info['group'] == 'Gem' then
		ctrlName = 'adventure_book_item_info_gem'
		info_gb_func_name = 'FILL_ITEM_INFO_EQUIP'
	elseif info['group'] == 'Card' then
		ctrlName = 'adventure_book_item_info_card'
		info_gb_func_name = 'FILL_ITEM_INFO_EQUIP'
	end

	local ctrlSet = info_box:CreateOrGetControlSet(ctrlName, "list_info", ui.LEFT, ui.TOP, 0, 0, 0, 0);

	local info_gb_func = ADVENTURE_BOOK_ITEM[info_gb_func_name]
	local isCraft = 1
	info_gb_func(ctrlSet, info, isCraft);

	if info_gb_func_name == 'FILL_ITEM_INFO_MATERIAL' then
		local item_info_sub3 = GET_CHILD(ctrlSet, 'item_info_sub3')
		item_info_sub3:SetVisible(0)
	end
end

function ADVENTURE_BOOK_CRAFT.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_craft", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	local sub_category_opt_list = GET_CHILD(page, "sub_category_opt_list", "ui::CDropList");
	
    if sort_opt_list:GetItemCount() > 0 then
        return;
   	end
    sort_opt_list:ClearItems();
    sort_opt_list:AddItem(0, ClMsg('ALIGN_ITEM_TYPE_5'));
    sort_opt_list:AddItem(1, ClMsg('ALIGN_ITEM_TYPE_6'));
    
    category_opt_list:ClearItems();
    category_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    category_opt_list:AddItem(1, ClMsg('Weapon'));
    category_opt_list:AddItem(2, ClMsg('Armor'));
    category_opt_list:AddItem(3, ClMsg('SubWeapon'));
    category_opt_list:AddItem(4, ClMsg('Drug'));
	category_opt_list:AddItem(5, ClMsg('Material'));
	category_opt_list:AddItem(6, ClMsg('Cube'));

    sub_category_opt_list:ClearItems();
	sub_category_opt_list:SetEnable(0);
    sub_category_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
end

function ADVENTURE_BOOK_CRAFT.DROPDOWN_LIST_UPDATE_SUB()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_craft", "ui::CGroupBox");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	local sub_category_opt_list = GET_CHILD(page, "sub_category_opt_list", "ui::CDropList");
	local categoryOption = category_opt_list:GetSelItemIndex();

    sub_category_opt_list:ClearItems();
    sub_category_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
	if categoryOption == 1 then
		sub_category_opt_list:SetEnable(1);
		sub_category_opt_list:AddItem(1, ClMsg('Sword'));
		sub_category_opt_list:AddItem(2, ClMsg('THSword'));
		sub_category_opt_list:AddItem(3, ClMsg('Staff'));
		sub_category_opt_list:AddItem(4, ClMsg('THStaff'));
		sub_category_opt_list:AddItem(5, ClMsg('THBow'));
		sub_category_opt_list:AddItem(6, ClMsg('Bow'));
		sub_category_opt_list:AddItem(7, ClMsg('Mace'));
		sub_category_opt_list:AddItem(8, ClMsg('Spear'));
		sub_category_opt_list:AddItem(9, ClMsg('THSpear'));
		sub_category_opt_list:AddItem(10, ClMsg('Rapier'));
		sub_category_opt_list:AddItem(11, ClMsg('Musket'));
	elseif categoryOption == 2 then
		sub_category_opt_list:SetEnable(1);
		sub_category_opt_list:AddItem(1, ClMsg('Shirt'));
		sub_category_opt_list:AddItem(2, ClMsg('Pants'));
		sub_category_opt_list:AddItem(3, ClMsg('Boots'));
		sub_category_opt_list:AddItem(4, ClMsg('Gloves'));
		sub_category_opt_list:AddItem(5, ClMsg('Neck'));
		sub_category_opt_list:AddItem(6, ClMsg('Ring'));
		sub_category_opt_list:AddItem(7, ClMsg('Shield'));
		sub_category_opt_list:AddItem(8, ClMsg('Outer'));
		sub_category_opt_list:AddItem(9, ClMsg('Hat'));
	elseif categoryOption == 3 then
		sub_category_opt_list:SetEnable(1);
		sub_category_opt_list:AddItem(1, ClMsg('Dagger'));
		sub_category_opt_list:AddItem(2, ClMsg('Pistol'));
		sub_category_opt_list:AddItem(3, ClMsg('Cannon'));
		sub_category_opt_list:AddItem(4, ClMsg('ETC'));
	else
		sub_category_opt_list:SetEnable(0);
	end
end

function ADVENTURE_BOOK_CRAFT_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_craft = adventure_book:GetChild('page_craft');
    local total_score_text = page_craft:GetChild('total_score_text');
    local totalScore = GET_ADVENTURE_BOOK_RECIPE_POINT();
    total_score_text:SetTextByKey('value', totalScore);
end

function ADVENTURE_BOOK_CRAFT_SET_LIST_ITEM_POINT(ctrlSet, targetItemID)
    local count = GetCraftCount(pc, targetItemID);
    local itemCls = GetClassByType('Item', targetItemID);
    if itemCls == nil then
        return;
    end
	
	local curScore, maxScore = _GET_ADVENTURE_BOOK_CRAFT_POINT(count);
	local curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_CRAFT_COUNT_INFO(count);

    local score_text = GET_CHILD_RECURSIVELY(ctrlSet, 'score_text');
    score_text:SetTextByKey('value', curScore);
    score_text:SetTextByKey('maxvalue', maxScore);
    
    local score_guage = GET_CHILD_RECURSIVELY(ctrlSet, 'score_guage');
    score_guage:SetPoint(curPoint, maxPoint);
end