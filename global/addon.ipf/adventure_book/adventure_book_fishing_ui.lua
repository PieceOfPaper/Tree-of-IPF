ADVENTURE_BOOK_FISHING = {};
ADVENTURE_BOOK_FISHING.SELECTED_FISH = "";

function ADVENTURE_BOOK_FISHING.RENEW()
	ADVENTURE_BOOK_FISHING.CLEAR();
	ADVENTURE_BOOK_FISHING.FILL_FISH_LIST();
    ADVENTURE_BOOK_FISHING_SET_POINT();
	
	local fish_list_func = ADVENTURE_BOOK_FISHING_CONTENT["FISH_LIST"];
	local fish_list = fish_list_func();
	if #fish_list < 1 then
		return;
	end
	
	ADVENTURE_BOOK_FISHING.SELECTED_FISH = fish_list[1];
	ADVENTURE_BOOK_FISHING.FILL_FISH_INFO()
	ADVENTURE_BOOK_FISHING.TOTAL_FISHING_COUNT()
end

function ADVENTURE_BOOK_FISHING.TOTAL_FISHING_COUNT()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_fishing", "ui::CGroupBox");
	local fishing_count_text = GET_CHILD(page, "fishing_count_text");
	fishing_count_text:SetTextByKey("value", ADVENTURE_BOOK_FISHING_CONTENT['TOTAL_FISH_COUNT']());
end

function ADVENTURE_BOOK_FISHING.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_fishing", "ui::CGroupBox");
	local fish_list = GET_CHILD(page, "fish_list", "ui::CGroupBox");
	fish_list:RemoveAllChild();
end

function ADVENTURE_BOOK_FISHING.FILL_FISH_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_fishing", "ui::CGroupBox");
	local fish_list_gb = GET_CHILD(page, "fish_list", "ui::CGroupBox");
	local fish_sort_gb = GET_CHILD(page, "fish_sort_gb", "ui::CGroupBox");
	local sort_1 = GET_CHILD(fish_sort_gb, "sort_1")
	local sort_2 = GET_CHILD(fish_sort_gb, "sort_2")
	fish_list_gb:RemoveAllChild();
	local sortType = GET_RADIOBTN_NUMBER(sort_1);
	
	local fish_list_func = ADVENTURE_BOOK_FISHING_CONTENT["FISH_LIST"];
	local fish_info_func = ADVENTURE_BOOK_FISHING_CONTENT["FISH_INFO"];
	local filter_func = ADVENTURE_BOOK_FISHING_CONTENT['FILTER_LIST']

	local fish_list = fish_list_func();
	fish_list = filter_func(fish_list, sortType)

	for i=1, #fish_list do
		local fishClsID = fish_list[i]
		local fish_info =  fish_info_func(fishClsID)
		local height = frame:GetUserConfig("FISH_ELEM_SIZE")

		local ctrlSet = fish_list_gb:CreateOrGetControlSet("adventure_book_fishing_elem", "list_fish_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		if fish_info['icon'] ~= nil then
			icon:SetImage(fish_info['icon']);
		end
		SET_TEXT(ctrlSet, "name_text", "value", fish_info['name'])
		ctrlSet:SetUserValue('BtnArg', fishClsID);
		
		local list = ADVENTURE_BOOK_SELLER_CONTENT.SKILL_ABILITY_LIST(skillClsID)

	end

end

function ADVENTURE_BOOK_FISHING.FILL_FISH_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_fishing", "ui::CGroupBox");
	local fish_info_gb = GET_CHILD(page, "fish_info_gb", "ui::CGroupBox");
	local fish_info_sub_gb = GET_CHILD(fish_info_gb, "fish_info_sub_gb", "ui::CGroupBox");
	local item_name_text = GET_CHILD(fish_info_gb, "item_name_text");
	local item_icon_pic = GET_CHILD(fish_info_gb, "item_icon_pic");
	local item_type_text = GET_CHILD(fish_info_gb, "item_type_text");
	local item_weight_text = GET_CHILD(fish_info_gb, "item_weight_text");
	local item_desc_text = GET_CHILD(fish_info_gb, "item_desc_text");
	local tradability_set = GET_CHILD(fish_info_sub_gb, "tradability_set");
	
	if ADVENTURE_BOOK_FISHING.SELECTED_FISH == "" then
		return;
	end

	local fish_info_func = ADVENTURE_BOOK_FISHING_CONTENT['FISH_INFO']
	local info = fish_info_func(ADVENTURE_BOOK_FISHING.SELECTED_FISH)
	item_name_text:SetTextByKey('value', info['name'])
	item_icon_pic:SetImage(info['icon'])
	item_desc_text:SetTextByKey('value', info['desc'])
	item_type_text:SetTextByKey('value', info['type'])
	item_weight_text:SetTextByKey('value', info['weight'])
	
	fish_info_sub_gb:SetOffset(fish_info_sub_gb:GetOriginalX(), item_desc_text:GetHeight() + fish_info_sub_gb:GetOriginalY())
	fish_info_gb:Resize(fish_info_gb:GetOriginalWidth(), fish_info_gb:GetOriginalHeight() + item_desc_text:GetHeight())

	local tradability_func = ADVENTURE_BOOK_ITEM['FILL_ITEM_TRADABILITY']
	tradability_func(tradability_set, info)
end

function ADVENTURE_BOOK_FISHING_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_living = adventure_book:GetChild('page_living');
    local total_score_text = page_living:GetChild('total_score_text');
    total_score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_FISHING_POINT());
end