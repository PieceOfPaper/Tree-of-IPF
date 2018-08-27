-- market.lua
local marketCategorySortCriteria = { -- 숫자가 작은 순서로 나오고, 없는 애들은 밑에 감
	Weapon = 1,
	Armor = 2,
	Consume = 3,
	Accessory = 4,
	Recipe = 5,
	Card = 6,
	Misc = 7,
	Gem = 8,
};

local function SORT_CATEGORY(categoryList, sortFunc)
	table.sort(categoryList, sortFunc);
	return categoryList;
end

function MARKET_INIT_CATEGORY(frame)	
	local marketCategory = GET_CHILD_RECURSIVELY(frame, 'marketCategory');
	local bgBox = GET_CHILD(marketCategory, 'bgBox');

	local cateListBox = GET_CHILD_RECURSIVELY(marketCategory, 'cateListBox');
	cateListBox:RemoveAllChild();
	
	local categoryList = SORT_CATEGORY(GetMarketCategoryList('root'), function(lhs, rhs)
			local lhsValue = marketCategorySortCriteria[lhs];
			local rhsValue = marketCategorySortCriteria[rhs];
			
			if lhsValue == nil then
				lhsValue = 200000000;				
			end
			if rhsValue == nil then
				rhsValue = 200000000;				
			end

			return lhsValue < rhsValue;
		end);

	for i = 0, #categoryList do
		local group;
		if i == 0 then
			group = 'IntegrateRetreive';			
		else
			group = categoryList[i];
		end
		local ctrlSet = cateListBox:CreateControlSet("market_tree", "CATEGORY_"..group, ui.LEFT, 0, 0, 0, 0, 0);
		local part = ctrlSet:GetChild("part");
		part:SetTextByKey("value", ClMsg(group));
		ctrlSet:SetUserValue('CATEGORY', group);
	end
	GBOX_AUTO_ALIGN(cateListBox, 0, 0, 0, true, false);

	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(0);

	frame:SetUserValue('SELECTED_CATEGORY', 'None');
	frame:SetUserValue('SELECTED_SUB_CATEGORY', 'None');

	-- 첨 키면 통합 검색 키게 해달라고 하셨다
	local integrateRetreiveCtrlset = GET_CHILD_RECURSIVELY(frame, 'CATEGORY_IntegrateRetreive');
	MARKET_CATEGORY_CLICK(integrateRetreiveCtrlset);
end

function ALIGN_CATEGORY_BOX(cateListBox, selectedCtrlset, subCateBox)
	local ypos = 0;
	local needMove = false;
	local childCnt = cateListBox:GetChildCount();
	for i = 0, childCnt - 1 do
		local child = cateListBox:GetChildByIndex(i);
		if string.find(child:GetName(), 'CATEGORY_') ~= nil then
			child:SetOffset(0, ypos);
			if subCateBox ~= nil and child == selectedCtrlset then
				subCateBox:SetOffset(subCateBox:GetX(), ypos + child:GetHeight());
				ypos = ypos + subCateBox:GetHeight();
				needMove = true;
			end
			ypos = ypos + child:GetHeight();
		end
	end
end

local function ADD_SUB_CATEGORY(detailBox, parentCategory, subCategoryList)
	if #subCategoryList < 1 then
		return 0;
	end

	local frame = detailBox:GetTopParentFrame();
	DESTROY_CHILD_BYNAME(detailBox, 'subCateBox');

	-- sort sub category
	if parentCategory == 'HairAcc' then
		subCategoryList = SORT_CATEGORY(subCategoryList, function(lhs, rhs)
			return lhs < rhs;
			end);
	end

	local subCateBox = detailBox:CreateControl('groupbox', 'subCateBox', 0, 0, detailBox:GetWidth(), 0);
	AUTO_CAST(subCateBox);
	subCateBox:SetSkinName('None');
	subCateBox:EnableScrollBar(0);
	for i = 0, #subCategoryList do
		local category = subCategoryList[i];		
		if category == nil then
			category = 'ShowAll';
		end
		
		local subCateCtrlset = subCateBox:CreateControl('groupbox', 'SUB_CATE_'..category, 0, 0, detailBox:GetWidth(), 20);
		AUTO_CAST(subCateCtrlset);
		subCateCtrlset:SetSkinName('None');
		subCateCtrlset:SetUserValue('PARENT_CATEGORY', parentCategory);
		subCateCtrlset:SetUserValue('CATEGORY', category);
		subCateCtrlset:SetEventScript(ui.LBUTTONUP, 'MARKET_SUB_CATEOGRY_CLICK');
		subCateCtrlset:EnableScrollBar(0);

		local text = subCateCtrlset:CreateControl('richtext', 'text', 20, 0, 100, 20);
		text:SetGravity(ui.LEFT, ui.CENTER_VERT);
		text:SetFontName('brown_16_b');
		text:SetText(ClMsg(category));
		text:EnableHitTest(0);
	end

	GBOX_AUTO_ALIGN(subCateBox, 2, 2, 0, true, true);
	detailBox:Resize(detailBox:GetWidth(), subCateBox:GetHeight());
	return subCateBox:GetHeight();
end

local function ADD_LEVEL_RANGE(detailBox, ypos, parentCategory)	
	if parentCategory ~= 'Weapon' and parentCategory ~= 'Accessory' and parentCategory ~= 'Armor' and parentCategory ~= 'Recipe' and parentCategory ~= 'OPTMisc' then
		return ypos;
	end

	local market_level = detailBox:CreateOrGetControlSet('market_level', 'levelRangeSet', 0, ypos);
	local minEdit = GET_CHILD_RECURSIVELY(market_level, 'minEdit');
	local maxEdit = GET_CHILD_RECURSIVELY(market_level, 'maxEdit');
	minEdit:SetText('');
	maxEdit:SetText('');
	ypos = ypos + market_level:GetHeight();
	return ypos;
end

local function ADD_ITEM_GRADE(detailBox, ypos, parentCategory)
	if parentCategory ~= 'Weapon' and parentCategory ~= 'Accessory' and parentCategory ~= 'Armor' and parentCategory ~= 'Recipe' then
		return ypos;
	end

	local market_grade = detailBox:CreateOrGetControlSet('market_grade', 'gradeCheckSet', 0, ypos);
	ypos = ypos + market_grade:GetHeight();
	return ypos;
end

local function ADD_ITEM_SEARCH(detailBox, ypos, parentCategory)
	local market_search = detailBox:CreateOrGetControlSet('market_search', 'itemSearchSet', 0, ypos);
	ypos = ypos + market_search:GetHeight();
	return ypos;
end

local function ADD_APPRAISAL_OPTION(detailBox, ypos, parentCategory)
	if parentCategory ~= 'Weapon' and parentCategory ~= 'Accessory' and parentCategory ~= 'Armor' then
		return ypos;
	end

	local market_appraisal = detailBox:CreateOrGetControlSet('market_appraisal', 'appCheckSet', 0, ypos);
	ypos = ypos + market_appraisal:GetHeight();
	return ypos;
end

local function ADD_DETAIL_OPTION_SETTING(detailBox, ypos, parentCategory)
	if parentCategory ~= 'Weapon' and parentCategory ~= 'Accessory' and parentCategory ~= 'Armor' and parentCategory ~= 'Recipe' and parentCategory ~= 'HairAcc' then
		return ypos;
	end

	if parentCategory ~= 'HairAcc' then
		local market_detail_setting = detailBox:CreateOrGetControlSet('market_detail_setting', 'detailOptionSet', 0, ypos);
		MARKET_ADD_SEARCH_DETAIL_SETTING(market_detail_setting, nil, true);
		ypos = ypos + market_detail_setting:GetHeight();
	end

	local market_option_group = detailBox:CreateOrGetControlSet('market_option_group', 'optionGroupSet', 0, ypos);
	MARKET_ADD_SEARCH_OPTION_GROUP(market_option_group, nil, true);
	ypos = ypos + market_option_group:GetHeight();
	return ypos;
end

local function ADD_SEARCH_COMMIT(detailBox, ypos, parentCategory)	
	local market_commit = detailBox:CreateOrGetControlSet('market_commit', 'commitSet', 0, ypos);
	ypos = ypos + market_commit:GetHeight();
	return ypos;
end

local function ADD_GEM_OPTION(detailBox, ypos, parentCategory)
	if parentCategory ~= 'Gem' and parentCategory ~= 'Card' then
		return ypos;
	end

	local market_gem_option = detailBox:CreateOrGetControlSet('market_gem_option', 'gemOptionSet', 0, ypos);
	local levelMinEdit = GET_CHILD_RECURSIVELY(market_gem_option, 'levelMinEdit');
	local levelMaxEdit = GET_CHILD_RECURSIVELY(market_gem_option, 'levelMaxEdit');
	levelMinEdit:SetText('');
	levelMaxEdit:SetText('');

	local roastingMinEdit = GET_CHILD_RECURSIVELY(market_gem_option, 'roastingMinEdit');
	local roastingMaxEdit = GET_CHILD_RECURSIVELY(market_gem_option, 'roastingMaxEdit');
	roastingMinEdit:SetText('');
	roastingMaxEdit:SetText('');

	if parentCategory == 'Card' then
		market_gem_option:Resize(market_gem_option:GetWidth(), 40);
	end
	ypos = ypos + market_gem_option:GetHeight();
	return ypos;
end

function DRAW_DETAIL_CATEGORY(frame, selectedCtrlset, subCategoryList)
	local parentCategory = selectedCtrlset:GetUserValue('CATEGORY');	
	local cateListBox = selectedCtrlset:GetParent();
	local detailBox = cateListBox:CreateControl('groupbox', 'detailBox', 5, 0, selectedCtrlset:GetWidth() - 20, 0);
	AUTO_CAST(detailBox);
	detailBox:SetSkinName('None');
	detailBox:EnableScrollBar(0);

	if parentCategory == 'IntegrateRetreive' then
		local _ypos = ADD_ITEM_SEARCH(detailBox, 0, parentCategory);
		_ypos = ADD_SEARCH_COMMIT(detailBox, _ypos, parentCategory);
		detailBox:Resize(detailBox:GetWidth(), _ypos);
		return detailBox;
	end

	local ypos = ADD_SUB_CATEGORY(detailBox, parentCategory, subCategoryList);
	ypos = ADD_LEVEL_RANGE(detailBox, ypos, parentCategory);
	ypos = ADD_ITEM_GRADE(detailBox, ypos, parentCategory);
	ypos = ADD_ITEM_SEARCH(detailBox, ypos, parentCategory);
	ypos = ADD_APPRAISAL_OPTION(detailBox, ypos, parentCategory);
	ypos = ADD_DETAIL_OPTION_SETTING(detailBox, ypos, parentCategory);
	ypos = ADD_GEM_OPTION(detailBox, ypos, parentCategory);
	ypos = ADD_SEARCH_COMMIT(detailBox, ypos, parentCategory);

	detailBox:Resize(detailBox:GetWidth(), ypos);
	return detailBox;
end

function MARKET_CATEGORY_CLICK(ctrlset, ctrl, reqList, forceOpen)	
	local frame = ctrlset:GetTopParentFrame();
	frame:SetUserValue('SELECTED_SUB_CATEGORY', 'None');
	MARKET_OPTION_BOX_CLOSE_CLICK(frame);

	local prevSelectCategory = frame:GetUserValue('SELECTED_CATEGORY');
	local category = ctrlset:GetUserValue('CATEGORY');
	local foldimg = GET_CHILD(ctrlset, 'foldimg');
	local cateListBox = GET_CHILD_RECURSIVELY(frame, 'cateListBox');
	DESTROY_CHILD_BYNAME(cateListBox, 'detailBox');

	if forceOpen ~= true and (prevSelectCategory == 'None' or prevSelectCategory == category) then
		if foldimg:GetUserValue('IS_PLUS_IMAGE') == 'YES' then
			foldimg:SetImage('viewunfold');
			foldimg:SetUserValue('IS_PLUS_IMAGE', 'NO');
			ALIGN_CATEGORY_BOX(ctrlset:GetParent(), ctrlset);
			return;
		end
	end
	frame:SetUserValue('isRecipeSearching', 0);

	-- color change
	local prevSelectCtrlset = GET_CHILD_RECURSIVELY(frame, 'CATEGORY_'..prevSelectCategory);
	if prevSelectCtrlset ~= nil then
		local bgBox = GET_CHILD(prevSelectCtrlset, 'bgBox');
		bgBox:SetSkinName('base_btn');

		local foldimg = GET_CHILD(prevSelectCtrlset, 'foldimg');		
		foldimg:SetImage('viewunfold');
		foldimg:SetUserValue('IS_PLUS_IMAGE', 'NO');
		imcSound.PlaySoundEvent('button_click_roll_close');
	end
	local bgBox = GET_CHILD(ctrlset, 'bgBox');
	bgBox:SetSkinName('baseyellow_btn');
	frame:SetUserValue('SELECTED_CATEGORY', category);

	-- fold img
	foldimg:SetImage('spreadclose');
	foldimg:SetUserValue('IS_PLUS_IMAGE', 'YES');
	
	local subCategoryList = GetMarketCategoryList(category);
	if #subCategoryList > 0 then
		imcSound.PlaySoundEvent("button_click_roll_open");
	else
		imcSound.PlaySoundEvent("button_click_4");
	end
	local detailBox = DRAW_DETAIL_CATEGORY(frame, ctrlset, subCategoryList);
	ALIGN_CATEGORY_BOX(ctrlset:GetParent(), ctrlset, detailBox);

	if reqList ~= false then		
		MARKET_REQ_LIST(frame);
	end
end

function MARKET_SUB_CATEOGRY_CLICK(parent, subCategoryCtrlset, reqList)	
	local frame = parent:GetTopParentFrame();
	local prevSelectedSubCategory = frame:GetUserValue('SELECTED_SUB_CATEGORY');
	local prevSelectedSubCateCtrlset = GET_CHILD_RECURSIVELY(frame, 'SUB_CATE_'..prevSelectedSubCategory);
	if prevSelectedSubCateCtrlset ~= nil then
		prevSelectedSubCateCtrlset:FillColorRect(false, nil);
	end

	local parentCategory = subCategoryCtrlset:GetUserValue('PARENT_CATEGORY');
	local category = subCategoryCtrlset:GetUserValue('CATEGORY');	
	subCategoryCtrlset:FillColorRect(true, 'FFDEDE00');
	frame:SetUserValue('SELECTED_SUB_CATEGORY', category);

	if reqList ~= false then
		MARKET_REQ_LIST(frame);
	end
end

local function CLAMP_MARKET_PAGE_NUMBER(frame, pageControllerName, page)
	if page == nil then
		return 0;
	end
	local pagecontrol = GET_CHILD(frame, pageControllerName);
	local MaxPage = pagecontrol:GetMaxPage();	
	if page >= MaxPage then
		page = MaxPage - 1;
	elseif page <= 0 then
		page = 0;
	end
	return page;
end

function GET_CATEGORY_STRING(frame)
	if frame:GetUserIValue('isRecipeSearching') > 0 then
		return 'Recipe', 'Recipe_Detail', 'None';
	end

	local cateStr = frame:GetUserValue('SELECTED_CATEGORY');
	if cateStr == 'None' or cateStr == 'IntegrateRetreive' then
		return '';
	end

	local subCate = frame:GetUserValue('SELECTED_SUB_CATEGORY');
	if subCate ~= 'None' and subCate ~= 'ShowAll' then
		cateStr = cateStr..'_'..subCate;
	end
	return cateStr, cateStr, subCate;
end

local function GET_SEARCH_PRICE_ORDER(frame)
	local priceOrderCheck_0 = GET_CHILD_RECURSIVELY(frame, 'priceOrderCheck_0');
	local priceOrderCheck_1 = GET_CHILD_RECURSIVELY(frame, 'priceOrderCheck_1');
	if priceOrderCheck_0 == nil or priceOrderCheck_1 == nil then
		return -1;
	end

	if priceOrderCheck_0:IsChecked() == 1 then
		return 0;
	end
	if priceOrderCheck_1:IsChecked() == 1 then
		return 1;
	end
	return 0; -- default
end

local function GET_SEARCH_TEXT(frame)
	local defaultValue = '';
	local market_search = GET_CHILD_RECURSIVELY(frame, 'itemSearchSet');
	if market_search ~= nil and market_search:IsVisible() == 1 then
		local searchEdit = GET_CHILD_RECURSIVELY(market_search, 'searchEdit');
		local findItem = searchEdit:GetText();
		local minLength = 0;
		local findItemStrLength = findItem.len(findItem);
		local maxLength = 60;
		if config.GetServiceNation() == "GLOBAL" then
			minLength = 1;
			maxLength = 20;
		elseif config.GetServiceNation() == "JPN" then
			maxLength = 60;
		elseif config.GetServiceNation() == "KOR" then
			maxLength = 60;
		end
		if findItemStrLength ~= 0 then	-- 있다면 길이 조건 체크
			if findItemStrLength <= minLength then
				ui.SysMsg(ClMsg("InvalidFindItemQueryMin"));
				return defaultValue;
			elseif findItemStrLength > maxLength then
				ui.SysMsg(ClMsg("InvalidFindItemQueryMax"));
				return defaultValue;
	        end
	    end 
	    return findItem;
	end
	return defaultValue;
end

local function GET_MINMAX_QUERY_VALUE_STRING(minEdit, maxEdit)
	local queryValue = '';
	local minValue = -1;
	local maxValue = -1;
	if minEdit:GetText() ~= nil and minEdit:GetText() ~= '' then
		minValue = tonumber(minEdit:GetText());
	end
	if maxEdit:GetText() ~= nil and maxEdit:GetText() ~= '' then
		maxValue = tonumber(maxEdit:GetText());
	end
	if minValue < 0 and maxValue < 0 then
		return queryValue; -- 아무 입력 없을 때의 처리
	end
	queryValue = minValue..';'..maxValue;	
	return queryValue;
end

local function GET_SEARCH_OPTION(frame)
	local optionName, optionValue = {}, {};
	local optionSet = {}; -- for checking duplicate option
	local category = frame:GetUserValue('SELECTED_CATEGORY');

	-- level range
	local levelRangeSet = GET_CHILD_RECURSIVELY(frame, 'levelRangeSet');
	if levelRangeSet ~= nil and levelRangeSet:IsVisible() == 1 then
		local minEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'minEdit');
		local maxEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'maxEdit');
		local opValue = GET_MINMAX_QUERY_VALUE_STRING(minEdit, maxEdit);
		if opValue ~= '' then
			local opName = 'CT_UseLv';
			if category == 'OPTMisc' then
				opName = 'Level';
			end
			optionName[#optionName + 1] = opName;
			optionValue[#optionValue + 1] = opValue;
			optionSet[opName] = true;
		end
	end

	-- grade
	local gradeCheckSet = GET_CHILD_RECURSIVELY(frame, 'gradeCheckSet');
	if gradeCheckSet ~= nil and gradeCheckSet:IsVisible() == 1 then
		local checkStr = '';
		local matchCnt, lastMatch = 0, nil;
		local childCnt = gradeCheckSet:GetChildCount();
		for i = 0, childCnt - 1 do
			local child = gradeCheckSet:GetChildByIndex(i);
			if string.find(child:GetName(), 'gradeCheck_') ~= nil then
				AUTO_CAST(child);
				if child:IsChecked() == 1 then
					local grade = string.sub(child:GetName(), string.find(child:GetName(), '_') + 1);
					checkStr = checkStr..grade..';';
					matchCnt = matchCnt + 1;
					lastMatch = grade;
				end
			end
		end
		if checkStr ~= '' then
			if matchCnt == 1 then
				checkStr = checkStr..lastMatch;
			end
			local opName = 'CT_ItemGrade';
			optionName[#optionName + 1] = opName;
			optionValue[#optionValue + 1] = checkStr;
			optionSet[opName] = true;
		end
	end

	-- random option flag
	local appCheckSet = GET_CHILD_RECURSIVELY(frame, 'appCheckSet');
	if appCheckSet ~= nil and appCheckSet:IsVisible() == 1 then
		local ranOpName, ranOpValue;
		local appCheck_0 = GET_CHILD(appCheckSet, 'appCheck_0');
		if appCheck_0:IsChecked() == 1 then
			ranOpName = 'Random_Item';
			ranOpValue = '2'
		end

		local appCheck_1 = GET_CHILD(appCheckSet, 'appCheck_1');
		if appCheck_1:IsChecked() == 1 then
			ranOpName = 'Random_Item';
			ranOpValue = '1'
		end

		if ranOpName ~= nil then
			optionName[#optionName + 1] = ranOpName;
			optionValue[#optionValue + 1] = ranOpValue;
			optionSet[ranOpName] = true;
		end
	end

	-- detail setting
	local detailOptionSet = GET_CHILD_RECURSIVELY(frame, 'detailOptionSet');
	if detailOptionSet ~= nil and detailOptionSet:IsVisible() == 1 then
		local curCnt = detailOptionSet:GetUserIValue('ADD_SELECT_COUNT');
		for i = 0, curCnt do
			local selectSet = GET_CHILD_RECURSIVELY(detailOptionSet, 'SELECT_'..i);
			if selectSet ~= nil and selectSet:IsVisible() == 1 then
				local nameList = GET_CHILD(selectSet, 'groupList');
				local opName = nameList:GetSelItemKey();
				if opName ~= '' then
					local opValue = GET_MINMAX_QUERY_VALUE_STRING(GET_CHILD_RECURSIVELY(selectSet, 'minEdit'), GET_CHILD_RECURSIVELY(selectSet, 'maxEdit'));				
					if opValue ~= '' and optionSet[opName] == nil then
						optionName[#optionName + 1] = opName;
						optionValue[#optionValue + 1] = opValue;
						optionSet[opName] = true;
					end
				end
			end
		end
	end

	-- option group
	local optionGroupSet = GET_CHILD_RECURSIVELY(frame, 'optionGroupSet');
	if optionGroupSet ~= nil and optionGroupSet:IsVisible() == 1 then
		local curCnt = optionGroupSet:GetUserIValue('ADD_SELECT_COUNT');		
		for i = 0, curCnt do
			local selectSet = GET_CHILD_RECURSIVELY(optionGroupSet, 'SELECT_'..i);
			if selectSet ~= nil then
				local nameList = GET_CHILD(selectSet, 'nameList');
				local opName = nameList:GetSelItemKey();
				if opName ~= '' then
					local opValue = GET_MINMAX_QUERY_VALUE_STRING(GET_CHILD_RECURSIVELY(selectSet, 'minEdit'), GET_CHILD_RECURSIVELY(selectSet, 'maxEdit'));
					if opValue ~= '' and optionSet[opName] == nil then
						optionName[#optionName + 1] = opName;
						optionValue[#optionValue + 1] = opValue;
						optionSet[opName] = true;
					end
				end
			end
		end
	end

	-- gem option
	local gemOptionSet = GET_CHILD_RECURSIVELY(frame, 'gemOptionSet');
	if gemOptionSet ~= nil and gemOptionSet:IsVisible() == 1 then
		local levelMinEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'levelMinEdit');
		local levelMaxEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'levelMaxEdit');
		local roastingMinEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'roastingMinEdit');
		local roastingMaxEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'roastingMaxEdit');
		if category == 'Gem' then
			local opValue = GET_MINMAX_QUERY_VALUE_STRING(levelMinEdit, levelMaxEdit);
			if opValue ~= '' then
				optionName[#optionName + 1] = 'GemLevel';
				optionValue[#optionValue + 1] = opValue;
				optionSet['GemLevel'] = true;
			end

			local roastOpValue = GET_MINMAX_QUERY_VALUE_STRING(roastingMinEdit, roastingMaxEdit);			
			if roastOpValue ~= '' then
				optionName[#optionName + 1] = 'GemRoastingLv';
				optionValue[#optionValue + 1] = roastOpValue;
				optionSet['GemRoastingLv'] = true;
			end
		elseif category == 'Card' then
			local opValue = GET_MINMAX_QUERY_VALUE_STRING(levelMinEdit, levelMaxEdit);
			if opValue ~= '' then
				optionName[#optionName + 1] = 'CardLevel';
				optionValue[#optionValue + 1] = opValue;
				optionSet['CardLevel'] = true;
			end
		end
	end

	return optionName, optionValue;
end

function MARKET_REQ_LIST(frame)
	frame = frame:GetTopParentFrame();
	MARKET_FIND_PAGE(frame, 0);
end

function MARKET_FIND_PAGE(frame, page)
	page = CLAMP_MARKET_PAGE_NUMBER(frame, 'pageControl', page);
	local orderByDesc = GET_SEARCH_PRICE_ORDER(frame);
	if orderByDesc < 0 then
		return;
	end
	local searchText = GET_SEARCH_TEXT(frame);
	local category, _category, _subCategory = GET_CATEGORY_STRING(frame);
	if category == '' and searchText == '' then
		return;
	end
	local optionKey, optionValue = GET_SEARCH_OPTION(frame);
	local itemCntPerPage = GET_MARKET_SEARCH_ITEM_COUNT(_category);	
	MarketSearch(page + 1, orderByDesc, searchText, category, optionKey, optionValue, itemCntPerPage);	
	DISABLE_BUTTON_DOUBLECLICK_WITH_CHILD(frame:GetName(), 'commitSet', 'searchBtn', 1);
	MARKET_OPTION_BOX_CLOSE_CLICK(frame);
end

function MARKET_UPDATE_PRICE_ORDER(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local curClickedOrderType = tonumber(string.sub(ctrl:GetName(), string.find(ctrl:GetName(), '_') + 1));
	local otherCheckType = 0;
	if curClickedOrderType == 0 then
		otherCheckType = 1;
	end
	if ctrl:IsChecked() == 1 then
		local otherCheck = GET_CHILD_RECURSIVELY(frame, 'priceOrderCheck_'..otherCheckType);
		otherCheck:SetCheck(0);
	else
		ctrl:SetCheck(1);
	end
end

function MARKET_UPDATE_APPRAISAL_CHECK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local curClickedOrderType = tonumber(string.sub(ctrl:GetName(), string.find(ctrl:GetName(), '_') + 1));
	local otherCheckType = 0;
	if curClickedOrderType == 0 then
		otherCheckType = 1;
	end
	if ctrl:IsChecked() == 1 then
		local otherCheck = GET_CHILD_RECURSIVELY(frame, 'appCheck_'..otherCheckType);
		otherCheck:SetCheck(0);
	end
end

local function ALIGN_OPTION_GROUP_SET(optionGroupSet)
	local Y_ADD_MARGIN = 2;
	local staticText = GET_CHILD(optionGroupSet, 'staticText');
	local ypos = staticText:GetY() + staticText:GetHeight() + Y_ADD_MARGIN;
	local childCnt = optionGroupSet:GetChildCount();

	local visibleSelectChildCount = 0;
	local visibleChild = nil;
	for i = 0, childCnt - 1 do
		local child = optionGroupSet:GetChildByIndex(i);
		if string.find(child:GetName(), 'SELECT_') ~= nil then
			child:SetOffset(child:GetX(), ypos);
			visibleChild = child;
			ypos = ypos + child:GetHeight();
			visibleSelectChildCount = visibleSelectChildCount + 1;
		end
	end
	local addOptionBtn = GET_CHILD(optionGroupSet, 'addOptionBtn');
	addOptionBtn:SetOffset(0, ypos);
	ypos = ypos + addOptionBtn:GetHeight() + Y_ADD_MARGIN;
	optionGroupSet:Resize(optionGroupSet:GetWidth(), ypos);
	return visibleSelectChildCount, visibleChild;
end

local function ALIGN_ALL_CATEGORY(frame)
	local cateListBox = GET_CHILD_RECURSIVELY(frame, 'cateListBox');
	local selectedCtrlset = GET_CHILD_RECURSIVELY(frame, 'CATEGORY_'..frame:GetUserValue('SELECTED_CATEGORY'));
	local subCateBox = GET_CHILD_RECURSIVELY(frame, 'detailBox');
	GBOX_AUTO_ALIGN(subCateBox, 0, 1, 0, true, true);
	ALIGN_CATEGORY_BOX(cateListBox, selectedCtrlset, subCateBox);
end

local function GET_DETAIL_OPTION_CTRLSET_COUNT(optionGroupSet)
	local ctrlsetCnt = 0;
	local childCnt = optionGroupSet:GetChildCount();
	for i = 0, childCnt - 1 do
		local child = optionGroupSet:GetChildByIndex(i);
		if string.find(child:GetName(), 'SELECT_') ~= nil and child:IsVisible() == 1 then
			ctrlsetCnt = ctrlsetCnt + 1;
		end
	end
	return ctrlsetCnt;
end

function MARKET_ADD_SEARCH_OPTION_GROUP(optionGroupSet, ctrl, hideDeleteCtrl)
	if GET_DETAIL_OPTION_CTRLSET_COUNT(optionGroupSet) >= 8 then
		return;
	end

	local curSelectCnt = optionGroupSet:GetUserIValue('ADD_SELECT_COUNT');
	optionGroupSet:SetUserValue('ADD_SELECT_COUNT', curSelectCnt + 1);
	local childIdx = curSelectCnt;
	local selectSet = optionGroupSet:CreateOrGetControlSet('market_option_group_select', 'SELECT_'..childIdx, 0, 0);
	local minEdit = GET_CHILD_RECURSIVELY(selectSet, 'minEdit');
	local maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'maxEdit');
	minEdit:SetText('');
	maxEdit:SetText('');

	if hideDeleteCtrl == true then
		local deleteText = GET_CHILD(selectSet, 'deleteText');
		deleteText:ShowWindow(0);
		optionGroupSet:SetUserValue('HIDE_CHILD_INDEX', childIdx);
	else
		local hideChildIdx = optionGroupSet:GetUserValue('HIDE_CHILD_INDEX');
		local hideChild = GET_CHILD(optionGroupSet, 'SELECT_'..hideChildIdx);
		if hideChild ~= nil then
			local hideDelText = GET_CHILD(hideChild, 'deleteText');
			hideDelText:ShowWindow(1);
			optionGroupSet:SetUserValue('HIDE_CHILD_INDEX', 'None');
		end
	end
	local groupList = GET_CHILD(selectSet, 'groupList');
	MARKET_INIT_OPTION_GROUP_DROPLIST(groupList);
	ALIGN_OPTION_GROUP_SET(optionGroupSet);
	ALIGN_ALL_CATEGORY(optionGroupSet:GetTopParentFrame());

	return selectSet;
end

function MARKET_DELETE_OPTION_GROUP_SELECT(selectCtrlset, ctrl)	
	local optionGroupSet = selectCtrlset:GetParent();	
	optionGroupSet:RemoveChild(selectCtrlset:GetName());
	local visibleChildCnt, visibleChild = ALIGN_OPTION_GROUP_SET(optionGroupSet);
	if visibleChildCnt == 1 and visibleChild ~= nil then
		local deleteText = GET_CHILD(visibleChild, 'deleteText');
		deleteText:ShowWindow(0);
		local visibleChildName = visibleChild:GetName();
		optionGroupSet:SetUserValue('HIDE_CHILD_INDEX', string.sub(visibleChildName, string.find(visibleChildName, '_') + 1));
	end
	ALIGN_ALL_CATEGORY(selectCtrlset:GetTopParentFrame());
end

function MARKET_ADD_SEARCH_DETAIL_SETTING(detailOptionSet, ctrl, hideDeleteCtrl)
	if GET_DETAIL_OPTION_CTRLSET_COUNT(detailOptionSet) >= 3 then
		return;
	end

	local frame = detailOptionSet:GetTopParentFrame();
	local curSelectCnt = detailOptionSet:GetUserIValue('ADD_SELECT_COUNT');	
	detailOptionSet:SetUserValue('ADD_SELECT_COUNT', curSelectCnt + 1);

	local childIdx = curSelectCnt;
	local selectSet = detailOptionSet:CreateOrGetControlSet('market_detail_option_select', 'SELECT_'..childIdx, 0, 0);
	local minEdit = GET_CHILD_RECURSIVELY(selectSet, 'minEdit');
	local maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'maxEdit');
	minEdit:SetText('');
	maxEdit:SetText('');

	if hideDeleteCtrl == true then
		local deleteText = GET_CHILD(selectSet, 'deleteText');
		deleteText:ShowWindow(0);
		detailOptionSet:SetUserValue('HIDE_CHILD_INDEX', childIdx);
	else
		local hideChildIdx = detailOptionSet:GetUserValue('HIDE_CHILD_INDEX');
		local hideChild = GET_CHILD(detailOptionSet, 'SELECT_'..hideChildIdx);
		if hideChild ~= nil then
			local hideDelText = GET_CHILD(hideChild, 'deleteText');
			hideDelText:ShowWindow(1);
			detailOptionSet:SetUserValue('HIDE_CHILD_INDEX', 'None');
		end
	end

	MARKET_INIT_DETAIL_SETTING_DROPLIST(GET_CHILD(selectSet, 'groupList'));
	ALIGN_OPTION_GROUP_SET(detailOptionSet);
	ALIGN_ALL_CATEGORY(detailOptionSet:GetTopParentFrame());
	return selectSet;
end

function MARKET_REFRESH_SEARCH_OPTION(parent, ctrl)
	local frame = parent:GetTopParentFrame();

	-- price order
	local priceOrderCheck = GET_CHILD_RECURSIVELY(frame, 'priceOrderCheck_0');
	priceOrderCheck:SetCheck(1);
	MARKET_UPDATE_PRICE_ORDER(priceOrderCheck:GetParent(), priceOrderCheck);

	-- level range
	local levelRangeSet = GET_CHILD_RECURSIVELY(frame, 'levelRangeSet');
	if levelRangeSet ~= nil and levelRangeSet:IsVisible() == 1 then
		local minEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'minEdit');
		local maxEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'maxEdit');
		minEdit:SetText('');
		maxEdit:SetText('');
	end

	-- item grade
	local gradeCheckSet = GET_CHILD_RECURSIVELY(frame, 'gradeCheckSet');
	if gradeCheckSet ~= nil and gradeCheckSet:IsVisible() == 1 then
		for i = 1, 5 do
			local check = GET_CHILD_RECURSIVELY(gradeCheckSet, 'gradeCheck_'..i);
			check:SetCheck(0);
		end
	end

	-- search
	local itemSearchSet = GET_CHILD_RECURSIVELY(frame, 'itemSearchSet');
	if itemSearchSet ~= nil and itemSearchSet:IsVisible() == 1 then
		local searchEdit = GET_CHILD_RECURSIVELY(itemSearchSet, 'searchEdit');
		searchEdit:SetText('');
	end

	-- appraisal
	local appCheckSet = GET_CHILD_RECURSIVELY(frame, 'appCheckSet');
	if appCheckSet ~= nil and appCheckSet:IsVisible() == 1 then
		for i = 0, 1 do
			local appCheck = GET_CHILD(appCheckSet, 'appCheck_'..i);
			appCheck:SetCheck(0);
		end
	end

	-- detail setting
	local detailOptionSet = GET_CHILD_RECURSIVELY(frame, 'detailOptionSet');
	if detailOptionSet ~= nil and detailOptionSet:IsVisible() == 1 then
		DESTROY_CHILD_BYNAME(detailOptionSet, 'SELECT_');
		detailOptionSet:SetUserValue('ADD_SELECT_COUNT', 0);
		ALIGN_OPTION_GROUP_SET(detailOptionSet);
	end

	-- option group
	local optionGroupSet = GET_CHILD_RECURSIVELY(frame, 'optionGroupSet');
	if optionGroupSet ~= nil and optionGroupSet:IsVisible() == 1 then
		DESTROY_CHILD_BYNAME(optionGroupSet, 'SELECT_');
		optionGroupSet:SetUserValue('ADD_SELECT_COUNT', 0);
		ALIGN_OPTION_GROUP_SET(optionGroupSet);
	end

	-- gem
	local gemOptionSet = GET_CHILD_RECURSIVELY(frame, 'gemOptionSet');
	if gemOptionSet ~= nil and gemOptionSet:IsVisible() == 1 then
		local levelMinEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'levelMinEdit');
		local levelMaxEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'levelMaxEdit');
		local roastingMinEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'roastingMinEdit');
		local roastingMaxEdit = GET_CHILD_RECURSIVELY(gemOptionSet, 'roastingMaxEdit');
		levelMinEdit:SetText('');
		levelMaxEdit:SetText('');
		roastingMinEdit:SetText('');
		roastingMaxEdit:SetText('');
	end

	ALIGN_ALL_CATEGORY(frame);
end

function MARKET_SAVE_CATEGORY_OPTION(parent, ctrl)	
	local configKeyList = GetMarketCategoryConfigKeyList();
	if #configKeyList > 19 then
		ui.SysMsg(ClMsg('TooManyMarketSaveOption'))
		return;
	end

	local frame = parent:GetTopParentFrame();
	local orderByDesc = GET_SEARCH_PRICE_ORDER(frame);
	local searchText = GET_SEARCH_TEXT(frame);
	local category = GET_CATEGORY_STRING(frame);
	local optionKey, optionValue = GET_SEARCH_OPTION(frame);

	local saveConfigNameEdit = GET_CHILD(parent, 'saveConfigNameEdit');
	local configKey = saveConfigNameEdit:GetText();
	if configKey == nil or configKey == '' then
		ui.SysMsg(ClMsg('InputTitlePlease'));
		return;
	end

	_MARKET_SAVE_CATEGORY_OPTION(frame, configKey, orderByDesc, searchText, category, optionKey, optionValue);
end

function _MARKET_SAVE_CATEGORY_OPTION(frame, configKey, orderByDesc, searchText, category, optionKey, optionValue)
	local serialize = string.format('order:%d@searchText:%s@category:%s', orderByDesc, searchText, category);
	for i = 1, #optionKey do
		serialize = serialize..'@'..optionKey[i]..':'..optionValue[i];		
	end

	session.market.SaveCategoryConfig(configKey, serialize);

	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(0);
end

local function GET_MINMAX_VALUE_BY_QUERY_STRING(queryString)
	local semiColonIdx = string.find(queryString, ';');
	local minValue = tonumber(string.sub(queryString, 0, semiColonIdx - 1));
	local maxValue = tonumber(string.sub(queryString, semiColonIdx + 1));
	minValue = math.max(minValue, 0);
	maxValue = math.max(maxValue, 0);
	return minValue, maxValue;
end

function MARKET_LOAD_CATEGORY_OPTION(parent, ctrl, argStr)	
	local frame = parent:GetTopParentFrame();
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(0);

	_MARKET_LOAD_CATEGORY_OPTION(frame, argStr);
end

function _MARKET_LOAD_CATEGORY_OPTION(frame, configKey)
	frame = frame:GetTopParentFrame();
	local configText = session.market.GetCategoryConfig(configKey);
	if configText == nil or configText == '' then
		return false;
	end

	-- parse
	local configList = StringSplit(configText, '@');
	local configTable = {};
	for i = 1, #configList do
		local config = configList[i];
		local idx = string.find(config, ':');
		if idx == nil then
			return false;
		end
		local propName = string.sub(config, 0, idx - 1);
		local propValue = string.sub(config, idx + 1);
		configTable[propName] = propValue;
	end

	-- set category
	local categoryStr = configTable['category'];	
	local underBarIdx = string.find(categoryStr, '_');
	local category = categoryStr;
	local subCategory = '';
	if underBarIdx ~= nil then
		category = string.sub(categoryStr, 0, underBarIdx - 1);
		subCategory = string.sub(categoryStr, underBarIdx + 1);
	end
	if category == '' then
		category = 'IntegrateRetreive';
	end

	local categoryCtrlset = GET_CHILD_RECURSIVELY(frame, 'CATEGORY_'..category);
	MARKET_CATEGORY_CLICK(categoryCtrlset, categoryCtrlset:GetChild('bgBox'), false, true);
	
	if subCategory ~= '' then
		local subCategoryCtrlset = GET_CHILD_RECURSIVELY(frame, 'SUB_CATE_'..subCategory);
		if subCategoryCtrlset ~= nil then
			MARKET_SUB_CATEOGRY_CLICK(subCategoryCtrlset:GetParent(), subCategoryCtrlset, false);
		end
	end
	
	-- set price order
	local checkIdx = configTable['order'];
	local priceOrderCheck = GET_CHILD_RECURSIVELY(frame, 'priceOrderCheck_'..checkIdx);	
	priceOrderCheck:SetCheck(1);
	MARKET_UPDATE_PRICE_ORDER(frame, priceOrderCheck);
	
	-- set level range
	if configTable['CT_UseLv'] ~= nil or configTable['Level'] ~= nil then
		local levelRangeSet = GET_CHILD_RECURSIVELY(frame, 'levelRangeSet');
		if levelRangeSet ~= nil and levelRangeSet:IsVisible() == 1 then
			local rangeValue = configTable['CT_UseLv'];
			if configTable['Level'] ~= nil then
				rangeValue = configTable['Level'];
			end
			local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(rangeValue);
			local minEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'minEdit');
			local maxEdit = GET_CHILD_RECURSIVELY(levelRangeSet, 'maxEdit');
			minEdit:SetText(minValue);
			maxEdit:SetText(maxValue);
		end
	end

	-- set item grade	
	if configTable['CT_ItemGrade'] ~= nil then
		local gradeCheckSet = GET_CHILD_RECURSIVELY(frame, 'gradeCheckSet');
		if gradeCheckSet ~= nil and gradeCheckSet:IsVisible() == 1 then
			local checkValue = configTable['CT_ItemGrade'];
			local checkValueList = StringSplit(checkValue, ';');
			-- init
			local gradeChildCnt = gradeCheckSet:GetChildCount();
			for i = 0, gradeChildCnt - 1 do
				local child = gradeCheckSet:GetChildByIndex(i);
				if string.find(child:GetName(), 'gradeCheck_') ~= nil then
					AUTO_CAST(child);
					child:SetCheck(0);
				end
			end

			-- set check
			for i = 1, #checkValueList do
				local gradeCheck = GET_CHILD(gradeCheckSet, 'gradeCheck_'..checkValueList[i]);
				gradeCheck:SetCheck(1);
			end
		end
	end

	-- set search text
	local itemSearchSet = GET_CHILD_RECURSIVELY(frame, 'itemSearchSet');
	local searchEdit = GET_CHILD_RECURSIVELY(itemSearchSet, 'searchEdit');
	searchEdit:SetText(configTable['searchText']);

	-- set appraisal check
	if configTable['Random_Item'] ~= nil then
		local appCheckSet = GET_CHILD_RECURSIVELY(frame, 'appCheckSet');
		if appCheckSet ~= nil and appCheckSet:IsVisible() == 1 then
			local configValue = tonumber(configTable['Random_Item']);
			local checkCtrl = nil;			
			if configValue == 1 then
				checkCtrl = GET_CHILD(appCheckSet, 'appCheck_1');
			elseif configValue == 2 then
				checkCtrl = GET_CHILD(appCheckSet, 'appCheck_0');
			end
			if checkCtrl ~= nil then
				checkCtrl:SetCheck(1);				
				MARKET_UPDATE_APPRAISAL_CHECK(checkCtrl:GetParent(), checkCtrl);
			end
		end
	end

	-- detail setting
	local detailOptionSet = GET_CHILD_RECURSIVELY(frame, 'detailOptionSet');
	if detailOptionSet ~= nil and detailOptionSet:IsVisible() == 1 then
		for configName, configValue in pairs(configTable) do
			if IS_MARKET_DETAIL_SETTING_OPTION(configName) == true then
				local selectSet = MARKET_ADD_SEARCH_DETAIL_SETTING(detailOptionSet);
				local groupList = GET_CHILD(selectSet, 'groupList');
				groupList:SelectItemByKey(configName);

				local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(configValue);
				local minEdit, maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'minEdit'), GET_CHILD_RECURSIVELY(selectSet, 'maxEdit');
				minEdit:SetText(minValue);
				maxEdit:SetText(maxValue);
			end
		end
	end

	-- option group
	local optionGroupSet = GET_CHILD_RECURSIVELY(frame, 'optionGroupSet');
	if optionGroupSet ~= nil and optionGroupSet:IsVisible() == 1 then
		for configName, configValue in pairs(configTable) do
			local isOptionGroup, group = IS_MARKET_SEARCH_OPTION_GROUP(configName);			
			if isOptionGroup == true then
				local selectSet = MARKET_ADD_SEARCH_OPTION_GROUP(optionGroupSet);
				local groupList = GET_CHILD(selectSet, 'groupList');
				groupList:SelectItemByKey(group);
				MARKET_INIT_OPTION_GROUP_VALUE_DROPLIST(groupList:GetParent(), groupList);

				local nameList = GET_CHILD(selectSet, 'nameList');
				nameList:SelectItemByKey(configName);

				local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(configValue);
				local minEdit, maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'minEdit'), GET_CHILD_RECURSIVELY(selectSet, 'maxEdit');
				minEdit:SetText(minValue);
				maxEdit:SetText(maxValue);
			end
		end
	end

	-- gem
	local gemOptionSet = GET_CHILD_RECURSIVELY(frame, 'gemOptionSet');
	if gemOptionSet ~= nil then
		if configTable['GemLevel'] ~= nil then			
			local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(configTable['GemLevel']);
			local minEdit, maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'levelMinEdit'), GET_CHILD_RECURSIVELY(selectSet, 'levelMaxEdit');
			minEdit:SetText(minValue);
			maxEdit:SetText(maxValue);
		end
		if configTable['CardLevel'] ~= nil then
			local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(configTable['CardLevel']);
			local minEdit, maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'levelMinEdit'), GET_CHILD_RECURSIVELY(selectSet, 'levelMaxEdit');
			minEdit:SetText(minValue);
			maxEdit:SetText(maxValue);
		end
		if configTable['GemRoastingLv'] ~= nil then
			local minValue, maxValue = GET_MINMAX_VALUE_BY_QUERY_STRING(configTable['CardLevel']);
			local minEdit, maxEdit = GET_CHILD_RECURSIVELY(selectSet, 'levelMinEdit'), GET_CHILD_RECURSIVELY(selectSet, 'levelMaxEdit');
			minEdit:SetText(minValue);
			maxEdit:SetText(maxValue);
		end
	end

	-- saveBtn
	local saveCheck = GET_CHILD_RECURSIVELY(frame, 'saveCheck');
	if saveCheck ~= nil then
		saveCheck:SetCheck(1);
	end

	MARKET_REQ_LIST(frame);

	return true;
end

function MARKET_TRY_SAVE_CATEGORY_OPTION(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(1);

	local optionSaveBox = GET_CHILD(optionBox, 'optionSaveBox');
	local saveConfigNameEdit = GET_CHILD(optionSaveBox, 'saveConfigNameEdit');
	saveConfigNameEdit:SetText('');
	optionSaveBox:ShowWindow(1);

	local optionLoadBox = GET_CHILD(optionBox, 'optionLoadBox');	
	optionLoadBox:ShowWindow(0);
end

function MARKET_TRY_LOAD_CATEGORY_OPTION(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(1);

	local optionSaveBox = GET_CHILD(optionBox, 'optionSaveBox');
	local optionLoadBox = GET_CHILD(optionBox, 'optionLoadBox');
	optionSaveBox:ShowWindow(0);
	optionLoadBox:ShowWindow(1);

	local optionListBox = GET_CHILD(optionLoadBox, 'optionListBox');
	optionListBox:RemoveAllChild();

	local ypos = 0;
	local CATEGORY_SAVE_OPTION_SKIN = frame:GetUserConfig('CATEGORY_SAVE_OPTION_SKIN');	
	local configKeyList = GetMarketCategoryConfigKeyList();
	local showCnt = 0;
	for i = 1, #configKeyList do
		if configKeyList[i] ~= '' then
			local keyText = optionListBox:CreateOrGetControlSet('market_save_option', 'CONFIG_'..i, 0, ypos);
			local nameText = GET_CHILD(keyText, 'nameText');		
			nameText:SetText(configKeyList[i]);
			nameText:SetEventScript(ui.LBUTTONUP, 'MARKET_LOAD_CATEGORY_OPTION');
			nameText:SetEventScriptArgString(ui.LBUTTONUP, configKeyList[i]);

			if showCnt % 2 == 1 then			
				local skinBox = GET_CHILD(keyText, 'skinBox');
				skinBox:SetSkinName(CATEGORY_SAVE_OPTION_SKIN);				
			end
			showCnt = showCnt + 1;

			ypos = ypos + keyText:GetHeight();
		end
	end
end

function MARKET_REQ_RECIPE_LIST(frame, page, recipeCls)
	page = CLAMP_MARKET_PAGE_NUMBER(frame, 'pagecontrol_material', page);

	local materialList = '';
	for i = 1, MAX_RECIPE_MATERIAL_COUNT do
		local materialItem = recipeCls["Item_" .. i .. "_1"];
		if materialItem ~= nil and materialItem ~= "None" then
			local itemCls = GetClass("Item", materialItem)
			materialList = materialList .. itemCls.ClassID .. ";";
		end
	end

	local itemCntPerPage = GET_MARKET_SEARCH_ITEM_COUNT('RecipeMaterial');
	MarketRecipeSearch(page + 1, materialList, itemCntPerPage);
	MARKET_OPTION_BOX_CLOSE_CLICK(frame);
end

function ON_MARKET_ESCAPE_PRESSED(frame)	
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	if optionBox:IsVisible() == 1 then
		optionBox:ShowWindow(0);
		return 0;
	end
	frame:ShowWindow(0);
	return 1;
end

function MARKET_OPTION_BOX_CLOSE_CLICK(parent, closeBtn)
	local frame = parent:GetTopParentFrame();
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	optionBox:ShowWindow(0);
end

function MARKET_SEARCH_RECIPE_IN_DETAIL_MODE(frame, pageControl, ctrlset)
	local clickedCtrlSetName = ctrlset:GetName();
	local splited = StringSplit(clickedCtrlSetName, '_');
	local curItemIdx = tonumber(splited[3]) + GET_MARKET_SEARCH_ITEM_COUNT('Recipe') * pageControl:GetCurPage();
	local pageInRecipeDetailMode = math.floor(curItemIdx / GET_MARKET_SEARCH_ITEM_COUNT('Recipe_Detail'));
	MARKET_FIND_PAGE(frame, pageInRecipeDetailMode);
end

function MARKET_DELETE_SAVED_OPTION(parent, ctrl)
	local nameText = GET_CHILD(parent, 'nameText');
	session.market.DeleteCategoryConfig(nameText:GetText());
	MARKET_TRY_LOAD_CATEGORY_OPTION(parent);
end

function MARKET_CATEGORY_CHECK_DUPLICATE_OPTION(parent, ctrl)
	local selectedKey = ctrl:GetSelItemKey();
	if selectedKey == '' then
		return;
	end

	local groupSet = parent:GetParent();
	local childCnt = groupSet:GetChildCount();
	local optionSet = {};
	for i = 0, childCnt - 1 do
		local child = groupSet:GetChildByIndex(i);
		if string.find(child:GetName(), 'SELECT_') ~= nil then
			local droplist = GET_CHILD_RECURSIVELY(child, ctrl:GetName());
			local selectedValue = droplist:GetSelItemKey();
			if selectedValue ~= '' then
				if optionSet[selectedValue] ~= nil then
					ui.SysMsg(ClMsg('DuplicateMarketSearchOption'));
					ctrl:SelectItemByKey('');
					return;
				end
				optionSet[selectedValue] = true;
			end
		end
	end
end