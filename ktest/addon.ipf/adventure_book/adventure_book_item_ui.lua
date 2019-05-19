ADVENTURE_BOOK_ITEM = {};
ADVENTURE_BOOK_ITEM.SELECTED_ITEM = "";
ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX = 1;
ADVENTURE_BOOK_ITEM.CUR_LIST_COUNT = 0;
ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX = 1

function ADVENTURE_BOOK_ITEM.RENEW()
	ADVENTURE_BOOK_ITEM.CLEAR();
	ADVENTURE_BOOK_ITEM.FILL_ITEM_LIST();
	ADVENTURE_BOOK_ITEM.DROPDOWN_LIST_INIT()
	ADVENTURE_BOOK_ITEM_SET_POINT();
	
	local item_list_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_LIST_ALL"];
	local item_list = item_list_func();
	if #item_list < 1 then
		return;
	end
	if ADVENTURE_BOOK_ITEM.SELECTED_ITEM == "" then
		ADVENTURE_BOOK_ITEM.SELECTED_ITEM = item_list[1]
	end
	ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO();
	ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX = 1;

    ReqAdventureBookRankingForItemPage();
end

function ADVENTURE_BOOK_ITEM.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_item", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "item_list", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "item_info_gb", "ui::CGroupBox");
	
	list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_item", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "item_list", "ui::CGroupBox");
	list_box:RemoveAllChild();
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	local sub_category_opt_list = GET_CHILD(page, "sub_category_opt_list", "ui::CDropList");
	local search_editbox = GET_CHILD(page, "search_editbox");

	local item_list_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_LIST_ALL"];
	local filter_func = ADVENTURE_BOOK_ITEM_CONTENT['FILTER_LIST']
	local item_info_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_INFO"];

	local item_list = item_list_func();
	item_list = filter_func(item_list, sort_opt_list:GetSelItemIndex(), category_opt_list:GetSelItemIndex(), sub_category_opt_list:GetSelItemIndex(), search_editbox:GetText())
	ADVENTURE_BOOK_ITEM.CUR_LIST_COUNT = (#item_list)
	local firstIndex, lastIndex = ADVENTURE_BOOK_ITEM.CUR_GROUP_INDICES()
	for i=1, lastIndex do
		local clsID = item_list[i]
		local info =  item_info_func(clsID)
		local height = frame:GetUserConfig("ITEM_ELEM_HEIGHT")
		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_item_elem", "list_item_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
        if info['icon'] ~= 'None' then
		    icon:SetImage(info['icon']);
        end
		if info['is_found'] == 0 then
            local SIHOUETTE_COLOR_TONE = tostring(frame:GetUserConfig('SIHOUETTE_COLOR_TONE'));
			ctrlSet:SetColorTone(SIHOUETTE_COLOR_TONE);
		end
		SET_TEXT(ctrlSet, "name_text", "value", info['name'])
		ctrlSet:SetUserValue('BtnArg', clsID);

        ADVENTURE_BOOK_ITEM_LIST_CTRLSET_POINT(ctrlSet, clsID);
	end
end
function ADVENTURE_BOOK_ITEM.INCREASE_GROUP_INDEX()
	local maxIndex = ADVENTURE_BOOK_ITEM.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX = ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX + 1;
	end
end
function ADVENTURE_BOOK_ITEM.MAX_GROUP_INDEX()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local ret = math.ceil(ADVENTURE_BOOK_ITEM.CUR_LIST_COUNT / count)
	return ret;
end
function ADVENTURE_BOOK_ITEM.CUR_GROUP_INDICES()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local firstIndex = 1+count*(ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX-1);
	local lastIndex = 1+count*(ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX);
	firstIndex = math.min(firstIndex, ADVENTURE_BOOK_ITEM.CUR_LIST_COUNT)
	lastIndex = math.min(lastIndex, ADVENTURE_BOOK_ITEM.CUR_LIST_COUNT)
	return firstIndex, lastIndex
end
function ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO_MATERIAL(ctrlSet, info, isCraft)
	local icon_pic = GET_CHILD(ctrlSet, "item_icon_pic", "ui::CPicture");
	local info_sub1 = GET_CHILD(ctrlSet, "item_info_sub1", "ui::CGroupBox");
	local info_sub2 = GET_CHILD(ctrlSet, "item_info_sub2", "ui::CGroupBox");
	local item_count_set = GET_CHILD(info_sub2, "item_count_set", "ui::CControlSet");
	local item_score_set = GET_CHILD(info_sub2, "item_score_set", "ui::CControlSet");
	local item_place_slotset = GET_CHILD(info_sub2, "item_place_slotset");
	local tradability_set = GET_CHILD(info_sub1, "tradability_set", "ui::CControlSet");

	local info_sub3 = GET_CHILD(ctrlSet, "item_info_sub3", "ui::CGroupBox");
	local item_consume_count_set = GET_CHILD(info_sub3, "item_consume_count_set", "ui::CControlSet");
	local item_myranking_set = GET_CHILD(info_sub3, "item_myranking_set", "ui::CControlSet");

	ADVENTURE_BOOK_ITEM.FILL_ITEM_TRADABILITY(tradability_set, info)

    if info['icon'] ~= 'None' then
	    icon_pic:SetImage(info['icon']);
    end
	SET_TEXT(ctrlSet, "item_name_text", "value", info['name'])
	SET_TEXT(ctrlSet, "item_desc_text", "value", info['desc'])

	if isCraft ~= 1 then
		info_sub2:SetVisible(1)
		info_sub3:SetVisible(1)

		SET_TEXT(item_count_set, "attr_name_text", "value", ClMsg('Count'));
		SET_TEXT(item_score_set, "attr_name_text", "value", ClMsg('Score'));

		SET_TEXT(item_consume_count_set, "attr_name_text", "value", ClMsg('ConsumedCount'))
		SET_TEXT(item_myranking_set, "attr_name_text", "value", ClMsg('MyRanking'))

		local item_consume_count_set_bg = GET_CHILD(item_consume_count_set, "attr_bg", "ui::CPicture");
		item_consume_count_set_bg:SetVisible(0);
		local item_myranking_set_bg = GET_CHILD(item_myranking_set, "attr_bg", "ui::CPicture");
		item_myranking_set_bg:SetVisible(0)

		SET_TEXT(item_count_set, "attr_value_text", "value", info['count'])
		SET_TEXT(item_score_set, "attr_value_text", "value", info['score'])
		SET_TEXT(item_consume_count_set, "attr_value_text", "value", info['consumed_count'])

		SET_TEXT(item_myranking_set, "attr_value_text", "value", ScpArgMsg('MyRanking'))

		ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX = 1
		ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO_SLOT(item_place_slotset, info['class_id'])
	else
		info_sub2:SetVisible(0)
		info_sub3:SetVisible(0)
	end

	ADVENTURE_BOOK_ITEM.SHIFT_BY_DESC_HEIGHT(ctrlSet);
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO_EQUIP(ctrlSet, info, isCraft)
	local icon_pic = GET_CHILD(ctrlSet, "item_icon_pic", "ui::CPicture");
	local bg_pic = GET_CHILD(ctrlSet, "item_icon_bg", "ui::CPicture");
	local info_sub1 = GET_CHILD(ctrlSet, "item_info_sub1", "ui::CGroupBox");
	local info_sub2 = GET_CHILD(ctrlSet, "item_info_sub2", "ui::CGroupBox");
	local item_count_set = GET_CHILD(info_sub2, "item_count_set", "ui::CControlSet");
	local item_score_set = GET_CHILD(info_sub2, "item_score_set", "ui::CControlSet");
	local item_place_slotset = GET_CHILD(info_sub2, "item_place_slotset");
	local prop_set = GET_CHILD(info_sub1, "prop_set", "ui::CControlSet");

	SET_TEXT(ctrlSet, "item_name_text", "value", info['name'])
	
    if info['icon'] ~= 'None' then
	    icon_pic:SetImage(info['icon']);
    end
	if bg_pic ~= nil and info['bg'] ~= nil then
		bg_pic:SetImage(info['bg']);
	end

	local propFunc =  ADVENTURE_BOOK_ITEM['FILL_ITEM_PROP_EQUIP']
	if info['group'] == 'Gem' then
		propFunc =  ADVENTURE_BOOK_ITEM['FILL_ITEM_PROP_GEM']
	elseif info['group'] == 'Card' then
		propFunc =  ADVENTURE_BOOK_ITEM['FILL_ITEM_PROP_CARD']
	end
	propFunc(prop_set, info, isCraft)
	
	if isCraft ~= 1 then
		info_sub2:ShowWindow(1)
		if info['group'] == 'Gem' then
			SET_TEXT(ctrlSet, "star_text", "value", info['grade'])
		end
		SET_TEXT(item_count_set, "attr_name_text", "value", ScpArgMsg('Count'))
		SET_TEXT(item_score_set, "attr_name_text", "value", ScpArgMsg('Score'))

		SET_TEXT(item_count_set, "attr_value_text", "value", info['count'])
		SET_TEXT(item_score_set, "attr_value_text", "value", info['score'])

		ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX = 1
		ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO_SLOT(item_place_slotset, info['class_id'])
	else
		info_sub2:ShowWindow(0)
	end
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO_SLOT(item_place_slotset, selectedItemClsID)
	local left_btn = GET_CHILD(item_place_slotset, "left_btn");
	local right_btn = GET_CHILD(item_place_slotset, "right_btn");
	local slotset = GET_CHILD(item_place_slotset, "slotset");

	left_btn:SetEventScriptArgString(ui.LBUTTONUP, "Item");    
	right_btn:SetEventScriptArgString(ui.LBUTTONUP, "Item");

	local item_place_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_PLACE_LIST"];
	local placeInfo = item_place_func(selectedItemClsID)

	local slotCount = slotset:GetSlotCount();
	local startIndex = (ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX-1) * slotCount + 1
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);
		local place = placeInfo[startIndex+i]
		if place ~= nil then
			SET_SLOT_IMG(slot, place['icon'])
			slot:EnableHitTest(1)
			slot:SetEventScript(ui.LBUTTONDOWN, "ON_ADVENTURE_BOOK_SLOT_ITEM_TO_MONSTER");
			slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, place['monster_id']);
		else
			slot:ClearIcon()
		end
	end
end

function ADVENTURE_BOOK_ITEM.ADJUST_SLOT_INDEX(item_place_slotset, selectedItemClsID)
	local slotset = GET_CHILD(item_place_slotset, "slotset");
	local slotCount = slotset:GetSlotCount();

	local item_place_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_PLACE_LIST"];
	local placeInfo = item_place_func(selectedItemClsID)

	local infoCount = #placeInfo
	local startIndex = (ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX-1) * slotCount + 1

	if startIndex > infoCount then
		ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX = ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX - 1;
	end

	if ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX < 1 then
		ADVENTURE_BOOK_ITEM.INFO_SLOT_INDEX  = 1;
	end
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_PROP_ATK_N_DEF(atk_n_def_set, itemCls, basicProp)
	local typeiconname = ''
	local typestring = ''
	local arg1 = nil
	local arg2 = nil
	if basicProp == 'ATK' then
	    typeiconname = 'test_sword_icon'
		typestring = ScpArgMsg("Melee_Atk")
		arg1 = itemCls.MINATK
		arg2 = itemCls.MAXATK
	elseif basicProp == 'MATK' then
	    typeiconname = 'test_sword_icon'
		typestring = ScpArgMsg("Magic_Atk")
		arg1 = itemCls.MATK
		arg2 = itemCls.MATK
	else
		typeiconname = 'test_shield_icon'
		typestring = ScpArgMsg(basicProp);
		arg1 = TryGetProp(itemCls, basicProp)
		arg2 = TryGetProp(itemCls, basicProp)
	end

	SET_DAMAGE_TEXT(atk_n_def_set, typestring, typeiconname, arg1, arg2, 1, 0);

	local adv_width = atk_n_def_set:GetUserConfig("ADVBOOK_WIDTH");
	atk_n_def_set:Resize(adv_width, atk_n_def_set:GetOriginalHeight())
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_PROP_EQUIP(prop_set, info, isCraft)	
	local frame = ui.GetFrame('adventure_book')
	local gb = GET_CHILD(prop_set, "gb");
	local desc_text = GET_CHILD(gb, "desc_text");
	local labelline1 = GET_CHILD(gb, "labelline1");
	local labelline2 = GET_CHILD(gb, "labelline2");

	local itemCls = GetClassByType("Item", info['class_id'])
	SET_TEXT(gb, "item_type_text", "value", TryGetProp(itemCls, "ReqToolTip"))
	SET_TEXT(gb, "weight_text", "value", TryGetProp(itemCls, "Weight"))
	SET_TEXT(gb, "desc_text", "value", info['desc'])

	local craftAddHeight = 0
	if isCraft == 1 then
 		craftAddHeight = frame:GetUserConfig("CRAFT_INFO_PROP_ADD_HEIGHT")
	end
	prop_set:Resize(prop_set:GetOriginalWidth(), prop_set:GetOriginalHeight()+craftAddHeight)
	gb:Resize(gb:GetOriginalWidth(), gb:GetOriginalHeight()+craftAddHeight)
	
	local dummyIES = CreateIESByID('Item', info['class_id']);
	local dummyItemObj = nil
	if dummyIES ~= nil then
		dummyItemObj = dummyIES
		local refreshScp = dummyItemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(dummyItemObj);
		end	
	end

	local basicProp = TryGetProp(dummyItemObj, "BasicTooltipProp")
	local height = frame:GetUserConfig("ITEM_INFO_PROP_HEIGHT")
    local basicTooltipProp = 'None';
	local y = frame:GetUserConfig("ITEM_INFO_PROP_Y")
    if dummyItemObj.BasicTooltipProp ~= 'None' then
        local basicTooltipPropList = StringSplit(dummyItemObj.BasicTooltipProp, ';');
        for i = 1, #basicTooltipPropList do
            basicTooltipProp = basicTooltipPropList[i];
			local atk_n_def_set = gb:CreateOrGetControlSet("tooltip_equip_atk_n_def", "atk_n_def_" .. i, ui.LEFT, ui.TOP, 0, y, 0, 0);
			ADVENTURE_BOOK_ITEM.FILL_ITEM_PROP_ATK_N_DEF(atk_n_def_set, dummyItemObj, basicTooltipProp)	
			y = y + height
        end
    end
	y = y + 10;
	labelline1:SetOffset(labelline1:GetOriginalX(), y)

	local dep_y = DRAW_EQUIP_PROPERTY(prop_set, dummyItemObj, y, 'gb')
	local tep = GET_CHILD(gb, 'tooltip_equip_property')
	if tep ~= nil then
		local tep_labelline = GET_CHILD(tep, 'labelline')
		tep_labelline:SetVisible(0)
		y = dep_y
	end

	y = y + 10;
	desc_text:SetOffset(desc_text:GetOriginalX(), y)

	local tradability_label = GET_CHILD(gb, "tradability_label");
	local tradability_set = GET_CHILD(gb, "tradability_set");
	ADVENTURE_BOOK_ITEM.FILL_ITEM_TRADABILITY(tradability_set, info)
	y = y + desc_text:GetHeight();
	y = y + 10;

	labelline2:SetOffset(labelline2:GetOriginalX(), y);
	y = y + 10;

	tradability_label:SetOffset(tradability_label:GetOriginalX(), y);
	tradability_set:SetOffset(tradability_set:GetOriginalX(), y);

	gb:Resize(gb:GetOriginalWidth(), gb:GetOriginalHeight())
	DestroyIES(dummyIES)
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_PROP_GEM(prop_set, info)
	local gb = GET_CHILD(prop_set, "gb");
	local gb2 = GET_CHILD(gb, "gb2");
	local weight_type_text = GET_CHILD(gb, "weight_type_text");

	local dummyIES = CreateIESByID('Item', info['class_id']);
	local dummyItemObj = nil
	if dummyIES ~= nil then
		dummyItemObj = dummyIES
	end
	
	dummyItemObj.ItemExp = GET_ITEM_EXP_BY_LEVEL(dummyItemObj, info['GemLevel'])
	
	DRAW_GEM_PROPERTYS_TOOLTIP(gb, dummyItemObj, 0, 'gb2')

	local propNameList = GET_ITEM_PROP_NAME_LIST(dummyItemObj)
	for i = 1 , #propNameList do
		local title = propNameList[i]["Title"];
		if title ~= nil then
			local CSet = gb2:GetControlSet('tooltip_gem_property', 'tooltip_gem_property');
			local property_gbox= GET_CHILD(CSet,'gem_property_gbox','ui::CGroupBox')
			innerCSet = property_gbox:GetControlSet('tooltip_each_gem_property', title)
			if innerCSet ~= nil then
				local labelline = GET_CHILD(innerCSet, 'labelline')
				labelline:SetSkinName('labelline_def2');
				labelline:SetVisible(0)
			end
		end
	end
	weight_type_text:SetTextByKey('value', TryGetProp(dummyItemObj,"Weight"))
	DestroyIES(dummyIES)
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_PROP_CARD(prop_set, info)
	local gb = GET_CHILD(prop_set, "gb");
	local gb2 = GET_CHILD(gb, "gb2");
	local desc_text = GET_CHILD(gb, "desc_text");
	local tradability_set = GET_CHILD(gb2, "tradability_set");
	desc_text:SetTextByKey('value', info['desc'])
	gb2:SetOffset(gb2:GetOriginalX(), gb2:GetOriginalY() + desc_text:GetHeight())
	
	ADVENTURE_BOOK_ITEM.FILL_ITEM_TRADABILITY(tradability_set, info)
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_TRADABILITY(tradeCtrlSet, info)
	local shop = GET_CHILD(tradeCtrlSet, "option_npc");
	local market = GET_CHILD(tradeCtrlSet, "option_market");
	local team = GET_CHILD(tradeCtrlSet, "option_teamware");
	local user = GET_CHILD(tradeCtrlSet, "option_trade");

	local onImage = 'tradecondition_on'
	local offImage = 'tradecondition_off'
	if info['trade_shop'] == 1 then
		shop:SetImage(onImage)
	else
		shop:SetImage(offImage)
	end
	if info['trade_market'] == 1 then
		market:SetImage(onImage)
	else
		market:SetImage(offImage)
	end
	if info['trade_team'] == 1 then
		team:SetImage(onImage)
	else
		team:SetImage(offImage)
	end
	if info['trade_user'] == 1 then
		user:SetImage(onImage)
	else
		user:SetImage(offImage)
	end
end

function ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_item", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "item_info_gb", "ui::CGroupBox");
	info_box:RemoveAllChild()
	
	if ADVENTURE_BOOK_ITEM.SELECTED_ITEM == "" then
		return;
	end
	local item_info_func = ADVENTURE_BOOK_ITEM_CONTENT["ITEM_INFO"];
	local info = item_info_func(ADVENTURE_BOOK_ITEM.SELECTED_ITEM)
	local ctrlName = 'adventure_book_item_info_material'
	local info_gb_func =  ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_MATERIAL']

	if info['type'] == 'Equip' then
		ctrlName = 'adventure_book_item_info_equip'
		info_gb_func =  ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_EQUIP']
	elseif info['group'] == 'Gem' then
		ctrlName = 'adventure_book_item_info_gem'
		info_gb_func =  ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_EQUIP']
	elseif info['group'] == 'Card' then
		ctrlName = 'adventure_book_item_info_card'
		info_gb_func =  ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_EQUIP']
	end

	local ctrlSet = info_box:CreateOrGetControlSet(ctrlName, "list_info", ui.LEFT, ui.TOP, 0, 0, 0, 0);        
	info_gb_func(ctrlSet, info);    
    ADVENTURE_BOOK_ITEM_DETAIL_SOURCE_TYPE(ctrlSet, ADVENTURE_BOOK_ITEM.SELECTED_ITEM);
    ADVENTURE_BOOK_ITEM_DETAIL_POINT(ctrlSet, ADVENTURE_BOOK_ITEM.SELECTED_ITEM);
    ADVENTURE_BOOK_ITEM_CONSUME_RANKING(ctrlSet);
end

function ADVENTURE_BOOK_ITEM.SHIFT_BY_DESC_HEIGHT(ctrlSet)
	local item_desc_text = GET_CHILD(ctrlSet, "item_desc_text", "ui::CRichText");

	local info_sub1 = GET_CHILD(ctrlSet, "item_info_sub1", "ui::CGroupBox");
	local info_sub2 = GET_CHILD(ctrlSet, "item_info_sub2", "ui::CGroupBox");
	local info_sub3 = GET_CHILD(ctrlSet, "item_info_sub3", "ui::CGroupBox");

	info_sub1:SetOffset(0, info_sub1:GetOriginalY() + item_desc_text:GetHeight());
	info_sub2:SetOffset(0, info_sub2:GetOriginalY() + item_desc_text:GetHeight());
	info_sub3:SetOffset(0, info_sub3:GetOriginalY() + item_desc_text:GetHeight());
end

function ADVENTURE_BOOK_ITEM.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_item", "ui::CGroupBox");
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
	category_opt_list:AddItem(6, ClMsg('JustGem'));
	category_opt_list:AddItem(7, ClMsg('Card'));

    sub_category_opt_list:ClearItems();
	sub_category_opt_list:SetEnable(0);
    sub_category_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
end

function ADVENTURE_BOOK_ITEM.DROPDOWN_LIST_UPDATE_SUB()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_item", "ui::CGroupBox");
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
		sub_category_opt_list:AddItem(8, ClMsg('THMace'));
		sub_category_opt_list:AddItem(9, ClMsg('Spear'));
		sub_category_opt_list:AddItem(10, ClMsg('THSpear'));
		sub_category_opt_list:AddItem(11, ClMsg('Rapier'));
		sub_category_opt_list:AddItem(12, ClMsg('Musket'));
	elseif categoryOption == 2 then
		sub_category_opt_list:SetEnable(1);
		sub_category_opt_list:AddItem(1, ClMsg('Shirt'));
		sub_category_opt_list:AddItem(2, ClMsg('Pants'));
		sub_category_opt_list:AddItem(3, ClMsg('Boots'));
		sub_category_opt_list:AddItem(4, ClMsg('Gloves'));
		sub_category_opt_list:AddItem(5, ClMsg('Neck'));
		sub_category_opt_list:AddItem(6, ClMsg('Ring'));
		sub_category_opt_list:AddItem(7, ClMsg('Shield'));
		sub_category_opt_list:AddItem(8, ClMsg('Hat'));
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

function ADVENTURE_BOOK_ITEM_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_item = adventure_book:GetChild('page_item');
    local total_score_text = page_item:GetChild('total_score_text');
    local totalScore = GET_ADVENTURE_BOOK_ITEM_POINT();
    total_score_text:SetTextByKey('value', totalScore);
end

function ADVENTURE_BOOK_ITEM_LIST_CTRLSET_POINT(ctrlSet, itemClsID)
    local itemObtainCount = GetItemObtainCount(pc, itemClsID);
    local itemCls = GetClassByType('Item', itemClsID);
    if itemCls == nil then
        return;
    end

    local curScore, maxScore, curLv, curPoint, maxPoint = 0, 0, 0, 0, 0;
    if itemCls.ItemType == 'Equip' then
        curScore, maxScore = _GET_ADVENTURE_BOOK_POINT_ITEM(true, itemObtainCount);
        curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO(true, itemObtainCount);
    else
        curScore, maxScore = _GET_ADVENTURE_BOOK_POINT_ITEM(false, itemObtainCount);
        curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO(false, itemObtainCount);
    end
    local score_text = ctrlSet:GetChild('score_text');
    score_text:SetTextByKey('value', curScore);
    score_text:SetTextByKey('maxvalue', maxScore);

    local score_guage = GET_CHILD(ctrlSet, 'score_guage');
    local levelText = ctrlSet:GetChild('levelText');
    levelText:SetTextByKey('level', curLv);
    score_guage:SetPoint(curPoint, maxPoint);
end

function ADVENTURE_BOOK_ITEM_DETAIL_POINT(ctrlSet, itemClsID)
   local itemObtainCount = GetItemObtainCount(pc, itemClsID);
    local itemCls = GetClassByType('Item', itemClsID);
    if itemCls == nil then
        return;
    end

    local curPoint, maxPoint = 0, 0;
    if itemCls.ItemType == 'Equip' then
        curPoint, maxPoint = _GET_ADVENTURE_BOOK_POINT_ITEM(true, itemObtainCount);
    else
        curPoint, maxPoint = _GET_ADVENTURE_BOOK_POINT_ITEM(false, itemObtainCount);
    end

    local scoreSet = GET_CHILD_RECURSIVELY(ctrlSet, 'item_score_set');    
    local attr_value_text = scoreSet:GetChild('attr_value_text');
    attr_value_text:SetTextByKey('value', curPoint);
end

function ADVENTURE_BOOK_ITEM_DETAIL_SOURCE_TYPE(ctrlSet, itemClsID)
    local data = GetAdventureBookInstByClassID(ABT_ITEM_COUNTABLE, itemClsID);    
    if data == nil then
        return;
    end
    data = tolua.cast(data, "ADVENTURE_BOOK_ITEM_COUNTABLE_DATA");
    local sourceType = '';
    if data.sourceType == FROM_DROP then
        sourceType = ClMsg('MonsterDrop');
    elseif data.sourceType == FROM_CRAFT then
        sourceType = ClMsg('Manufacture');
    elseif data.sourceType == FROM_CUBE then
        sourceType = ClMsg('Cube');
    else
        sourceType = '-';
    end

    local sourceTypeText = GET_CHILD_RECURSIVELY(ctrlSet, 'sourceTypeText');
    sourceTypeText: SetTextByKey('value', sourceType);
end

function ADVENTURE_BOOK_ITEM_CONSUME_RANKING(frame, msg, argStr, argNum)
    local item_info_sub3 = GET_CHILD_RECURSIVELY(frame, 'item_info_sub3');    
    if item_info_sub3 == nil then
        return;
    end
    local itemClsID = ADVENTURE_BOOK_ITEM.SELECTED_ITEM;
    local itemCls = GetClassByType('Item', itemClsID);
    if itemCls == nil then
        return;
    end
    if itemCls.GroupName ~= 'Drug' then
        item_info_sub3:ShowWindow(0);
        return;
    end

    local myRank = GetAdventureBookMyItemConsumeRank();
    local item_myranking_set = item_info_sub3:GetChild('item_myranking_set');
    local attr_value_text = item_myranking_set:GetChild('attr_value_text');
    attr_value_text:SetTextByKey('value', tostring(myRank + 1)..ClMsg('Rank'));
    
    local itemConsumRankBox = item_info_sub3:GetChild('itemConsumRankBox');
    local rankInfo = GetAdventureBookConsumeRankInfo(0);
    if rankInfo ~= nil then
        local rankText = itemConsumRankBox:GetChild('rankText1');
        rankText:SetTextByKey('score', rankInfo.score);
    end

    rankInfo = GetAdventureBookConsumeRankInfo(1);
    if rankInfo ~= nil then
        local rankText = itemConsumRankBox:GetChild('rankText2');
        rankText:SetTextByKey('score', rankInfo.score);
    end

    rankInfo = GetAdventureBookConsumeRankInfo(2);
    if rankInfo ~= nil then
        local rankText = itemConsumRankBox:GetChild('rankText3');
        rankText:SetTextByKey('score', rankInfo.score);
    end
    item_info_sub3:ShowWindow(1);
end