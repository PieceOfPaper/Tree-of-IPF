ADVENTURE_BOOK_INDUN = {};
ADVENTURE_BOOK_INDUN.SELECTED_INDUN = "";

function ADVENTURE_BOOK_INDUN.RENEW()
	ADVENTURE_BOOK_INDUN.CLEAR();
	ADVENTURE_BOOK_INDUN.FILL_INDUN_LIST();
 	ADVENTURE_BOOK_INDUN.DROPDOWN_LIST_INIT();
    ADVENTURE_BOOK_INDUN_SET_POINT();
	
	local indun_list_func = ADVENTURE_BOOK_INDUN_CONTENT["INDUN_LIST"];
	local indun_list = indun_list_func();
	if #indun_list < 1 then
		return;
	end

	ADVENTURE_BOOK_INDUN.SELECTED_INDUN = indun_list[1];
	ADVENTURE_BOOK_INDUN.FILL_INDUN_INFO()
end

function ADVENTURE_BOOK_INDUN.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_indun", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "indun_list", "ui::CGroupBox");
	list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_INDUN.FILL_INDUN_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_indun", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "indun_list", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	local search_editbox = GET_CHILD(page, "search_editbox");
	list_box:RemoveAllChild();
	
	local indun_list_func = ADVENTURE_BOOK_INDUN_CONTENT["INDUN_LIST"];
	local indun_info_func = ADVENTURE_BOOK_INDUN_CONTENT["INDUN_INFO"];
	local filter_func = ADVENTURE_BOOK_INDUN_CONTENT['FILTER_LIST']

	if indun_list_func == nil or indun_info_func == nil then
		return;
	end
	local indun_list = indun_list_func();
	indun_list = filter_func(indun_list, sort_opt_list:GetSelItemIndex(), category_opt_list:GetSelItemIndex(), search_editbox:GetText())
	for i=1, #indun_list do
		local indunClsID = indun_list[i]
		local indun_info =  indun_info_func(indunClsID)
		local height = frame:GetUserConfig("INDUN_ELEM_HEIGHT")

		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_indun_elem", "list_indun_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
		SET_TEXT(ctrlSet, "name_text", "value", indun_info['name'])
		SET_TEXT(ctrlSet, "level_text", "value", indun_info['level'])
		SET_TEXT(ctrlSet, "count_text", "value", indun_info['count'])
		SET_TEXT(ctrlSet, "score_text", "value", indun_info['count'])
		ctrlSet:SetUserValue('BtnArg', indunClsID);
	end
end

function ADVENTURE_BOOK_INDUN.FILL_INDUN_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_indun", "ui::CGroupBox");
	local indun_info_gb = GET_CHILD(page, "indun_info_gb", "ui::CGroupBox");
	
	if ADVENTURE_BOOK_INDUN.SELECTED_INDUN == "" then
		return;
	end

	local indun_info_func = ADVENTURE_BOOK_INDUN_CONTENT["INDUN_INFO"];
	local indun_info = indun_info_func(ADVENTURE_BOOK_INDUN.SELECTED_INDUN);

	SET_TEXT(indun_info_gb, "item_name_text", "value", indun_info['name'])

	SET_TEXT(indun_info_gb, "level_text", "value", indun_info['level'])
	SET_TEXT(indun_info_gb, "difficulty_text", "value", indun_info['difficulty'])
	SET_TEXT(indun_info_gb, "location_text", "value", indun_info['location'])
	SET_TEXT(indun_info_gb, "score_text", "value", indun_info['count'])
	SET_TEXT(indun_info_gb, "count_text", "value", indun_info['count'])
end

function ADVENTURE_BOOK_INDUN.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_indun", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");

    if sort_opt_list:GetItemCount() > 0 then
        return;
   	end
    sort_opt_list:ClearItems();
    sort_opt_list:AddItem(0, ClMsg('ALIGN_ITEM_TYPE_5'));
    sort_opt_list:AddItem(1, ClMsg('ALIGN_ITEM_TYPE_6'));
    
    category_opt_list:ClearItems();
    category_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    category_opt_list:AddItem(1, ClMsg('IndunDungeon'));
    category_opt_list:AddItem(2, ClMsg('IndunMission'));
    category_opt_list:AddItem(3, ClMsg('IndunGroundTower'));
	category_opt_list:AddItem(4, ClMsg('IndunNunnery'));
	category_opt_list:AddItem(5, ClMsg('IndunUpHill'));
	category_opt_list:AddItem(6, ClMsg('IndunFantasyLib'));
	category_opt_list:AddItem(7, ClMsg('IndunRaid'));
end

function ADVENTURE_BOOK_INDUN_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_indun = adventure_book:GetChild('page_indun');
    local total_score_text = page_indun:GetChild('total_score_text');
    local totalPoint = GET_ADVENTURE_BOOK_INDUN_POINT();
    total_score_text:SetTextByKey('value', totalPoint);
end