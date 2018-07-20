ADVENTURE_BOOK_SELLER = {};
ADVENTURE_BOOK_SELLER.SELECTED_SKILL = "";

function ADVENTURE_BOOK_SELLER.RENEW()
	ADVENTURE_BOOK_SELLER.CLEAR();
	ADVENTURE_BOOK_SELLER.FILL_SELLER_CHAR_LIST();
	ADVENTURE_BOOK_SELLER.DROPDOWN_LIST_INIT();
    ADVENTURE_BOOK_LIVING_SET_POINT();

	local seller_skill_list_func = ADVENTURE_BOOK_SELLER_CONTENT["SELLER_SKILL_LIST"];
	local seller_skill_list = seller_skill_list_func();
	if #seller_skill_list < 1 then
		return;
	end
	
	ADVENTURE_BOOK_SELLER.SELECTED_SKILL = seller_skill_list[1];

	ADVENTURE_BOOK_SELLER.FILL_SKILL_INFO()
	ADVENTURE_BOOK_SELLER.FILL_ABILITY_INFO()
end

function ADVENTURE_BOOK_SELLER.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_seller", "ui::CGroupBox");
	local char_list_box = GET_CHILD(page, "seller_char_list", "ui::CGroupBox");
	char_list_box:RemoveAllChild();
	local abil_list_box = GET_CHILD(page, "seller_abil_list", "ui::CGroupBox");
	abil_list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_SELLER.FILL_SELLER_CHAR_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_seller", "ui::CGroupBox");
	local sales_gb = GET_CHILD(page, "sales_gb", "ui::CGroupBox");
	local total_silver_text = GET_CHILD(sales_gb, "silver_text");
	
	local list_box = GET_CHILD(page, "seller_char_list", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local category_opt_list = GET_CHILD(page, "category_opt_list", "ui::CDropList");
	list_box:RemoveAllChild();
	
	local seller_skill_list_func = ADVENTURE_BOOK_SELLER_CONTENT["SELLER_SKILL_LIST"];
	local seller_earnings_count_func = ADVENTURE_BOOK_SELLER_CONTENT["SELLER_EARNINGS_COUNT"];
	local seller_skill_info_func = ADVENTURE_BOOK_SELLER_CONTENT["SKILL_INFO"];
	local filter_func = ADVENTURE_BOOK_SELLER_CONTENT["FILTER_LIST"];
	local seller_total_earnings_count_func = ADVENTURE_BOOK_SELLER_CONTENT["SELLER_TOTAL_EARNINGS_COUNT"];

	local seller_skill_list = seller_skill_list_func();
	seller_skill_list = filter_func(seller_skill_list, sort_opt_list:GetSelItemIndex(), category_opt_list:GetSelItemIndex())
	for i=1, #seller_skill_list do
		local skillClsID = seller_skill_list[i]
		local earnings =  seller_earnings_count_func(skillClsID)
		local skillInfo =  seller_skill_info_func(skillClsID)
		local height = frame:GetUserConfig("SELLER_ELEM_HEIGHT")

		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_seller_skill", "list_skill_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
		local icon = GET_CHILD(ctrlSet, "job_pic", "ui::CPicture");
		icon:SetImage(skillInfo['job_icon']);
		SET_TEXT(ctrlSet, "charname_text", "value", skillInfo['job_name'])
		SET_TEXT(ctrlSet, "shopname_text", "value", skillInfo['skill_name'])
		SET_TEXT(ctrlSet, "silver_text", "value", skillInfo['earnings_count'])
		ctrlSet:SetUserValue('BtnArg', skillClsID);
		
		local list = ADVENTURE_BOOK_SELLER_CONTENT.SKILL_ABILITY_LIST(skillClsID)

	end

	total_silver_text:SetTextByKey('value', seller_total_earnings_count_func())
end

function ADVENTURE_BOOK_SELLER.FILL_SKILL_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_seller", "ui::CGroupBox");
	local skill_info_gb = GET_CHILD(page, "skill_info_gb", "ui::CGroupBox");
	local skill_icon = GET_CHILD(skill_info_gb, "skill_icon_pic", "ui::CPicture");
	
	if ADVENTURE_BOOK_SELLER.SELECTED_SKILL == "" then
		return;
	end
	
	local skill_info_func = ADVENTURE_BOOK_SELLER_CONTENT["SKILL_INFO"];
	local skill_info = skill_info_func(ADVENTURE_BOOK_SELLER.SELECTED_SKILL)
	
	SET_TEXT(skill_info_gb, "skill_name_text", "value", skill_info['skill_name'])
	SET_TEXT(skill_info_gb, "skill_desc_text", "value", skill_info['skill_desc'])
	skill_icon:SetImage(skill_info['skill_icon'])
end

function ADVENTURE_BOOK_SELLER.FILL_ABILITY_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_seller", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "seller_abil_list", "ui::CGroupBox");
	list_box:RemoveAllChild();

	if ADVENTURE_BOOK_SELLER.SELECTED_SKILL == "" then
		return;
	end
	
	local seller_ability_list_func = ADVENTURE_BOOK_SELLER_CONTENT["SKILL_ABILITY_LIST"];
	local seller_ability_info_func = ADVENTURE_BOOK_SELLER_CONTENT["ABILITY_INFO"];
	local ability_list = seller_ability_list_func(ADVENTURE_BOOK_SELLER.SELECTED_SKILL)

	for i=1, #ability_list do
		local abilityClassName = ability_list[i]
		local height = frame:GetUserConfig("SELLER_ABILITY_HEIGHT")
		local ability_info = seller_ability_info_func(abilityClassName);
		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_seller_ability", "list_ability_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);

		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		SET_TEXT(ctrlSet, "abilname_text", "value", ability_info['name'])
		SET_TEXT(ctrlSet, "desc_text", "value", ability_info['desc'])
		icon:SetImage(ability_info['icon'])
	end
end

function ADVENTURE_BOOK_SELLER.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page_living = GET_CHILD(frame, "page_living", "ui::CGroupBox");
	local page = GET_CHILD(page_living, "page_seller", "ui::CGroupBox");
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
    category_opt_list:AddItem(1, ClMsg('Auto_SoDeuMaen'));
    category_opt_list:AddItem(2, ClMsg('Auto_wiJeoDeu'));
    category_opt_list:AddItem(3, ClMsg('Auto_aCheo'));
    category_opt_list:AddItem(4, ClMsg('Auto_KeulLeLig'));
	
end
