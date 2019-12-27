-- etc_tooltip.lua

function ITEM_TOOLTIP_ETC(tooltipframe, invitem, argStr, usesubframe)    
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'etc'
	
	if usesubframe == "usesubframe" then
		mainframename = "etc_sub"
	elseif usesubframe == "usesubframe_recipe" then
		mainframename = "etc_sub"
	end

	local ypos = DRAW_ETC_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, argStr); -- 기타 템이라면 공통적으로 그리는 툴팁들	
	ypos = DRAW_ETC_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 아이템 설명.
	ypos = DRAW_ETC_RECIPE_NEEDITEM_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 재료템이라면 필요한 재료랑 보여줌
	ypos = DRAW_ETC_PREVIEW_TOOLTIP(tooltipframe, invitem, ypos, mainframename);			-- 아이콘 확대해서 보여줌
	ypos = DRAW_EQUIP_TRADABILITY(tooltipframe, invitem, ypos, mainframename);
	
	local isHaveLifeTime = TryGetProp(invitem, "LifeTime");	
	if 0 == isHaveLifeTime then
		ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename); -- 가격
	else
		ypos = DRAW_REMAIN_LIFE_TIME(tooltipframe, invitem, ypos, mainframename); -- 남은 시간
	end
	
end

function DRAW_ETC_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, from)
    local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	--스킨 세팅
	local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
	gBox:SetSkinName('test_Item_tooltip_normal');
	
	local CSet = gBox:CreateControlSet('tooltip_etc_common', 'tooltip_etc_common', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 아이템 이미지
	local itemPicture = GET_CHILD(CSet, "itempic", "ui::CPicture");
	
	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
	    local itemImg = invitem.TooltipImage;
	    
	    -- 레시피 툴팁 이미지와 인벤 이미지를 통일
	    if invitem.GroupName == 'Recipe' then
	        itemImg = invitem.Icon;
	    end
	    
		itemPicture:SetImage(itemImg);
		itemPicture:ShowWindow(1);
	else
		itemPicture:ShowWindow(0);
	end

	local questMark = GET_CHILD(CSet, "questMark", "ui::CPicture");
	if invitem.GroupName ~= 'Quest' then		
		questMark:ShowWindow(0);
	end

	-- 별 그리기
	SET_GRADE_TOOLTIP(CSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name", "ui::CRichText");
	
	--EVENT_1909_ANCIENT
	if invitem.ClassName == 'EVENT_190919_ANCIENT_MONSTER_PIECE' then
		local mon = GetClass('Ancient', invitem.KeyWord);
		fullname = mon.Name .. '{/}['..'{img star_mark 20 20}'..']'
		if mon.Rarity == 1 then
			fullname =  "{#ffffff}"..fullname
		elseif mon.Rarity == 2 then
			fullname =  "{#0e7fe8}"..fullname
		elseif mon.Rarity == 3 then
			fullname =  "{#d92400}"..fullname
		elseif mon.Rarity == 4 then
			fullname =  "{#ffa800}"..fullname
		end
		fullname = invitem.Name .. ' - ' .. fullname
	end

	nameChild:SetText(fullname);
	nameChild:AdjustFontSizeByWidth(nameChild:GetWidth());
	nameChild:SetTextAlign("center","center");
    
    -- 쿨타임 등 세팅 옮김
	local invDesc = GET_ITEM_DESC_BY_TOOLTIP_VALUE(invitem);
	local propRichtext= GET_CHILD(CSet,'prop_text','ui::CRichText')
	propRichtext:SetText(invDesc)

	-- 아이템 유저 거래 유무 다시 세팅
	local noTrade_cnt = GET_CHILD(CSet, "noTrade_cnt", "ui::CRichText");
	local noTradeCount = TryGetProp(invitem, "BelongingCount");
	if nil ~= noTradeCount and 0 > noTradeCount then
		noTradeCount = 0
	end
	noTrade_cnt:SetTextByKey('count', noTradeCount);

	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
	if itemProp ~= nil then
		if itemProp:IsEnableUserTrade() ~= true then
			if nil ~= noTrade_cnt then
				noTrade_cnt:ShowWindow(0);
			end
		end
	else
		if nil ~= noTrade_cnt then
			noTrade_cnt:ShowWindow(0);
		end
	end
    
    if from ~= nil and from == 'accountwarehouse' then
        noTrade_cnt:ShowWindow(0)
    end
    
	
	-- 아이템 종류 세팅
	local type_richtext = GET_CHILD(CSet, "type_text", "ui::CRichText");
	type_richtext:SetTextByKey('type',ScpArgMsg(invitem.GroupName));
	
	--무게
	local weightRichtext = GET_CHILD(CSet, "weight_text", "ui::CRichText");
	local weightString = string.format("%.1f", invitem.Weight)
	weightRichtext:SetTextByKey('weight', weightString);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight();
end

-- 쿨타임등 표시
function DRAW_ETC_PROPRTY(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')

	gBox:RemoveChild('tooltip_etc_property');

	local invDesc = GET_ITEM_DESC_BY_TOOLTIP_VALUE(invitem);

	if invDesc == "" then
		return yPos;
	end

	local Cset = gBox:CreateOrGetControlSet('tooltip_etc_property', 'tooltip_etc_property', 0, yPos);	
	local propRichtext= GET_CHILD(Cset,'prop_text','ui::CRichText')
	
	-- 아이템 설명 설정
	propRichtext:SetText(invDesc)

	tolua.cast(Cset, "ui::CControlSet");
	local BOTTOM_MARGIN = Cset:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	Cset:Resize(Cset:GetOriginalWidth(), propRichtext:GetY()+propRichtext:GetHeight() + BOTTOM_MARGIN)
	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + Cset:GetHeight())
	return Cset:GetHeight() + Cset:GetY();
end

function DRAW_ETC_DESC_TOOLTIP(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_etc_desc');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_etc_desc', 'tooltip_etc_desc', 0, yPos);
	local descRichtext= GET_CHILD(CSet,'desc_text','ui::CRichText')

	local customSet = false;
	local customTooltip = TryGetProp(invitem, "CustomToolTip");
	if customTooltip ~= nil and customTooltip ~= "None" then
		local nameFunc = _G[customTooltip .. "_DESC"];
		if nameFunc ~= nil then
			local desc = invitem.Desc;
			desc = desc .. "{nl} {nl}" .. nameFunc(invitem);
			descRichtext:SetText(desc );
			customSet = true;
		end
	end

	if false == customSet then
		descRichtext:SetText(invitem.Desc);
	end

	tolua.cast(CSet, "ui::CControlSet");
	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(), descRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();

end

function DRAW_ETC_RECIPE_NEEDITEM_TOOLTIP(tooltipframe, invitem, ypos, mainframename)


	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_recipes');

	if invitem.GroupName ~= 'Recipe' then
		return ypos;
	end

	local CSet = gBox:CreateControlSet('tooltip_recipe_needitems', 'tooltip_recipes', 0, ypos);
	tolua.cast(CSet, "ui::CControlSet");
	local gbox_items= GET_CHILD(CSet,'needitem_gbox','ui::CGroupBox')


	-- 세트아이템 세트 효과 텍스트 표시 부분
	inner_yPos = 0;

	local AVAIABLE_MAKE_FONT = CSet:GetUserConfig("AVAIABLE_MAKE_FONT")
	local UNAVAIABLE_MAKE_FONT = CSet:GetUserConfig("UNAVAIABLE_MAKE_FONT")

	local recipecls = GetClass('Recipe', invitem.ClassName);

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then
			local recipeItemCnt, invItemCnt, dragRecipeItem = GET_RECIPE_MATERIAL_INFO(recipecls, i);

			local itemSet = gbox_items:CreateOrGetControlSet("tooltip_recipe_eachitem", "ITEM_" .. i, 0, inner_yPos);
			itemSet = tolua.cast(itemSet, 'ui::CControlSet');
			
			local image = GET_CHILD(itemSet, "image", "ui::CPicture");
			local text = GET_CHILD(itemSet, "text", "ui::CRichText");
			image:SetImage(dragRecipeItem.Icon)
			text:SetTextByKey("itemName",dragRecipeItem.Name)
			text:SetTextByKey("havecount",invItemCnt)
			text:SetTextByKey("needcount",recipeItemCnt)

			if invItemCnt >= recipeItemCnt then
				text:SetFontName(AVAIABLE_MAKE_FONT)
			else
				text:SetFontName(UNAVAIABLE_MAKE_FONT)
			end

			local GRADE_FONT_SIZE = itemSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기
			SET_GRADE_TOOLTIP(itemSet,dragRecipeItem,GRADE_FONT_SIZE)
			
			inner_yPos = inner_yPos + itemSet:GetHeight();
		end
	end

	gbox_items:Resize( gbox_items:GetWidth() ,inner_yPos)

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	
	CSet:Resize(CSet:GetWidth(), gbox_items:GetHeight() + gbox_items:GetY() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + CSet:GetHeight()+ BOTTOM_MARGIN)

	return CSet:GetHeight() + CSet:GetY();
end

function DRAW_ETC_PREVIEW_TOOLTIP(tooltipframe, invitem, ypos, mainframename)
	if string.find(invitem.StringArg, "Balloon_") == nil then
		return ypos;
	end

	local iconName = invitem.Icon;
	if string.find(invitem.StringArg, "Balloon_") ~= nil then
		-- 말풍선 아이템일 경우 item의 icon이 아닌 chat_balloon의 SkinPreview 이미지 출력
		local balloonCls = GetClass('Chat_Balloon', invitem.StringArg);
		iconName = balloonCls.SkinPreview;
	end

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_preview');

	local CSet = gBox:CreateControlSet('tooltip_preview', 'tooltip_preview', 0, ypos);
	tolua.cast(CSet, "ui::CControlSet");
	local previewPic = GET_CHILD(CSet,'previewPic','ui::CPicture')
	previewPic:SetImage(iconName);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN");
	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + CSet:GetHeight()+ BOTTOM_MARGIN)

	return CSet:GetHeight() + CSet:GetY();
end

local function _SET_TRUST_POINT_PARAM_INFO(tooltipframe, index, paramType)
	-- point
	local starTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'starTextBox'..index);
	local point = session.inventory.GetTrustPointByParam(paramType);
	local STAR_IMG = 'star_in_arrow';
	local STAR_SIZE = 19;
	local starText = '';
	if point == 5 then
		starText = starText..string.format('{img %s %s %s}', STAR_IMG, STAR_SIZE, STAR_SIZE);
		starText = starText..string.format('{img %s %s %s}', "starmark_multipl05", 19, 15);
	else
		for i = 1, point do
			starText = starText..string.format('{img %s %s %s}', STAR_IMG, STAR_SIZE, STAR_SIZE);
		end
	end	
	starTextBox:SetTextByKey('value', starText);

	-- info
	local paramTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'paramTextBox'..index);
	if paramType == 'SafeAuth' then
		paramTextBox:SetTextByKey('value', ClMsg('SafeAuthInfo'));
	else		
		paramTextBox:SetTextByKey('value', session.inventory.GetTrustInfoCriteria(paramType));
	end

	-- check
	local check = GET_CHILD_RECURSIVELY(tooltipframe, 'check'..index);
	if session.inventory.IsSatisfyTrustParam(paramType) == true then
		check:SetCheck(1);
	else
		check:SetCheck(0);
	end
end

local function _HIDE_SAFEAUTH_INFO(tooltipframe, safeAuthIndex, questIndex)
	local starTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'starTextBox'..safeAuthIndex);
	local paramTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'paramTextBox'..safeAuthIndex);
	local check = GET_CHILD_RECURSIVELY(tooltipframe, 'check'..safeAuthIndex);
	starTextBox:ShowWindow(0);
	paramTextBox:ShowWindow(0);
	check:ShowWindow(0);

	local _starTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'starTextBox'..questIndex);
	local _paramTextBox = GET_CHILD_RECURSIVELY(tooltipframe, 'paramTextBox'..questIndex);
	local _check = GET_CHILD_RECURSIVELY(tooltipframe, 'check'..questIndex);
	_starTextBox:SetOffset(_starTextBox:GetX(), starTextBox:GetY());
	_paramTextBox:SetOffset(_paramTextBox:GetX(), paramTextBox:GetY());		
	local margin = check:GetMargin();
	_check:SetMargin(margin.left, margin.top, margin.right, margin.bottom);

	tooltipframe:Resize(tooltipframe:GetWidth(), _starTextBox:GetY() + _starTextBox:GetHeight() + 10);
end

function UPDATE_TRUST_POINT_TOOLTIP(tooltipframe, tree)
	_SET_TRUST_POINT_PARAM_INFO(tooltipframe, 1, 'TeamLevel');
	_SET_TRUST_POINT_PARAM_INFO(tooltipframe, 2, 'CharLevel');
	_SET_TRUST_POINT_PARAM_INFO(tooltipframe, 3, 'CreateTime');
	_SET_TRUST_POINT_PARAM_INFO(tooltipframe, 4, 'SafeAuth');
	_SET_TRUST_POINT_PARAM_INFO(tooltipframe, 5, 'Quest');

	if config.GetServiceNation() ~= 'KOR' and config.GetServiceNation() ~= 'GLOBAL' and config.GetServiceNation() ~= 'GLOBAL_JP' then
		_HIDE_SAFEAUTH_INFO(tooltipframe, 4, 5);
	end
end

function UPDATE_INDUN_INFO_TOOLTIP(tooltipframe, cidStr, param1, param2, actor)
	actor =	tolua.cast(actor, "CFSMActor")
	tootltipframe = AUTO_CAST(tooltipframe)

	local indunClsList, indunCount = GetClassList('Indun');
	local ctrlWidth = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_WIDTH"))
	local ctrlHeight = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_HEIGHT"))
	local ctrlLeftMargin = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_LEFT_MARGIN"))
	local playPerRestTypeTable={}

	local accountInfo = session.barrack.GetMyAccount();
	local indunListBox = GET_CHILD_RECURSIVELY(tooltipframe, "indunListBox")

	local indunLabelText = GET_CHILD_RECURSIVELY(tooltipframe, "indunLabelText")
	indunLabelText:SetText("{@st43}{s20}" ..ClMsg("IndunCountInfo"))
	local pcInfo = accountInfo:GetByStrCID(cidStr)
	-- 인던 이용 현황 출력
	for j = 0, indunCount - 1 do
		local indunCls = GetClassByIndexFromList(indunClsList, j)

		if indunCls ~= nil and indunCls.Category ~= "None" then

			local indunGroupBox = indunListBox:CreateOrGetControl("groupbox", "INDUN_CONTROL_".. indunCls.PlayPerResetType, ctrlLeftMargin, 0, ctrlWidth, ctrlHeight)
			indunGroupBox = tolua.cast(indunGroupBox, "ui::CGroupBox")
			indunGroupBox:EnableDrawFrame(0)
			local indunLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_NAME_" .. indunCls.PlayPerResetType, 0, 0, ctrlWidth / 2, ctrlHeight)
			indunLabel = tolua.cast(indunLabel, 'ui::CRichText')
			indunLabel:SetText('{@st42b}' .. indunCls.Category)
			indunLabel:SetEnable(0)
		
			local indunCntLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_COUNT_" .. indunCls.PlayPerResetType, 0, 0, ctrlWidth / 2, ctrlHeight)
			indunCntLabel:SetGravity(ui.RIGHT, ui.TOP)
			indunCntLabel:SetEnable(0)

			local entranceCount = BARRACK_GET_CHAR_INDUN_ENTRANCE_COUNT(cidStr, indunCls.PlayPerResetType)

			if entranceCount ~= nil then
				if entranceCount == 'None' then
					entranceCount = 0;
				else
					entranceCount = tonumber(entranceCount)
				end
				indunCntLabel:SetText("{@st42b}" .. entranceCount .. "/" .. BARRACK_GET_INDUN_MAX_ENTERANCE_COUNT(indunCls.PlayPerResetType))
			end

			if pcInfo ~= nil then
				if indunCls.Level <= actor:GetLv() or playPerRestTypeTable["INDUN_COUNT_" .. indunCls.PlayPerResetType]==1 then
					indunLabel:SetEnable(1)
					indunCntLabel:SetEnable(1)
					playPerRestTypeTable["INDUN_COUNT_" .. indunCls.PlayPerResetType]=1
				end
			end
		end
	end

	-- 챌린지 모드, 프리 던전 보스 이용 현황 출력
	local contentsClsList, count = GetClassList('contents_info');
	for i = 0, count - 1 do
        local contentsCls = GetClassByIndexFromList(contentsClsList, i);
		if contentsCls ~= nil then
            local resetGroupID = contentsCls.ResetGroupID;
			local category = contentsCls.Category;
			local indunGroupBox = indunListBox:GetChild('INDUN_CONTROL_'..resetGroupID);
			if category ~= 'None' then
				local indunGroupBox = indunListBox:CreateOrGetControl("groupbox", "INDUN_CONTROL_".. resetGroupID, ctrlLeftMargin, 0, ctrlWidth, ctrlHeight);
				indunGroupBox = tolua.cast(indunGroupBox, "ui::CGroupBox");
				indunGroupBox:EnableDrawFrame(0);

				local indunLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_NAME_" .. resetGroupID, 0, 0, ctrlWidth / 2, ctrlHeight);
				indunLabel = tolua.cast(indunLabel, 'ui::CRichText');
				indunLabel:SetText('{@st42b}' .. category);
				indunLabel:SetEnable(0);

				local indunCntLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_COUNT_" .. resetGroupID, 0, 0, ctrlWidth / 2, ctrlHeight);
				indunCntLabel = tolua.cast(indunCntLabel, 'ui::CRichText');
				indunCntLabel:SetGravity(ui.RIGHT, ui.TOP);
				indunCntLabel:SetEnable(0);

				local curCount = BARRACK_GET_CHAR_INDUN_ENTRANCE_COUNT(cidStr, resetGroupID);
				if curCount == nil or curCount == 'None' then
					curCount = 0;
				else
					curCount = tonumber(curCount)
				end

				local maxCount = BARRACK_GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID);
				indunCntLabel:SetText("{@st42b}" .. curCount .. "/" .. maxCount);

				if pcInfo ~= nil then
					if contentsCls.Level <= actor:GetLv()  or playPerRestTypeTable["INDUN_COUNT_" .. resetGroupID]== 1 then
						indunLabel:SetEnable(1);
						indunCntLabel:SetEnable(1);
						playPerRestTypeTable["INDUN_COUNT_" .. resetGroupID] = 1;
					end
				end
			end
		end
	end

	-- 실버 표시
	local indunGroupBox = indunListBox:CreateOrGetControl("groupbox", "INDUN_CONTROL_SILVER", ctrlLeftMargin, 0, ctrlWidth, ctrlHeight)
	indunGroupBox = tolua.cast(indunGroupBox, "ui::CGroupBox")
	indunGroupBox:EnableDrawFrame(0)
	local indunLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_NAME_SILVER", 0, 0, ctrlWidth / 2, ctrlHeight)
	indunLabel = tolua.cast(indunLabel, 'ui::CRichText')
	indunLabel:SetText('{@st42b}' .. ScpArgMsg('Auto_SilBeo'))
	indunLabel:SetEnable(1)
	
	local indunCntLabel = indunGroupBox:CreateOrGetControl("richtext", "INDUN_CRRUNT_SILVER", 0, 0, ctrlWidth / 2, ctrlHeight)
	indunCntLabel:SetGravity(ui.RIGHT, ui.TOP)
	indunCntLabel:SetText('{@st42b}' .. GET_COMMAED_STRING(pcInfo:GetSilver()))
	indunCntLabel:SetEnable(1)

	local spacing = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_SPACING"))
	local startY = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_START_TOP_MARGIN"))
	local offset = tonumber(tooltipframe:GetUserConfig("INDUN_CTRL_OFFSET"))
	local frameoffset = tonumber(tooltipframe:GetUserConfig("INDUN_FRAME_OFFSET"))
	GBOX_AUTO_ALIGN(indunListBox, startY, spacing, offset, true, false)

	-- 인던 갯수에 따른 툴팁 크기변환
	local spaceOffset = indunListBox:GetChildCount() * (ctrlHeight + spacing) + offset;	-- 인던 list gb 크기

	local bgBox = GET_CHILD(tooltipframe, 'indunListBoxBg');
	indunListBox:Resize(indunListBox:GetOriginalWidth(), spaceOffset);
	bgBox:Resize(bgBox:GetOriginalWidth(), spaceOffset + frameoffset);
	tootltipframe:Resize(tootltipframe:GetOriginalWidth(), spaceOffset + frameoffset);
end


function ITEM_TOOLTIP_MONSTER_PIECE(tooltipframe, invitem, argStr, usesubframe)    
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'etc'
	
	if usesubframe == "usesubframe" then
		mainframename = "etc_sub"
	elseif usesubframe == "usesubframe_recipe" then
		mainframename = "etc_sub"
	end

	local ypos = DRAW_ETC_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, argStr); -- 기타 템이라면 공통적으로 그리는 툴팁들	
	ypos = DRAW_ETC_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 아이템 설명.
	ypos = DRAW_ETC_RECIPE_NEEDITEM_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 재료템이라면 필요한 재료랑 보여줌
	ypos = DRAW_EQUIP_TRADABILITY(tooltipframe, invitem, ypos, mainframename);
	
	local isHaveLifeTime = TryGetProp(invitem, "LifeTime", 0);	
	if 0 == tonumber(isHaveLifeTime) then
		ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename); -- 가격
	else
		ypos = DRAW_REMAIN_LIFE_TIME(tooltipframe, invitem, ypos, mainframename); -- 남은 시간
	end
	
end