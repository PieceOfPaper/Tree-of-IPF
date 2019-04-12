-- etc_tooltip.lua

function ITEM_TOOLTIP_ETC(tooltipframe, invitem, num1, usesubframe)
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'etc'
	
	if usesubframe == "usesubframe" then
		mainframename = "etc_sub"
	elseif usesubframe == "usesubframe_recipe" then
		mainframename = "etc_sub"
	end

	local ypos = DRAW_ETC_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 기타 템이라면 공통적으로 그리는 툴팁들
	ypos = DRAW_ETC_HEAL_AMOUNT(tooltipframe, invitem, ypos, mainframename); -- 회복량. (존재한다면)
	ypos = DRAW_ETC_PROPRTY(tooltipframe, invitem, ypos, mainframename); -- 쿨다운은 몇초입니다. 그런것들?
	ypos = DRAW_ETC_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 아이템 설명.
	ypos = DRAW_ETC_RECIPE_NEEDITEM_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 재료템이라면 필요한 재료랑 보여줌
	
	local isHaveLifeTime = TryGetProp(invitem, "LifeTime");	
	if 0 == isHaveLifeTime then
		ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename); -- 재료템이라면 필요한 재료랑 보여줌
	else
		ypos = DRAW_REMAIN_LIFE_TIME(tooltipframe, invitem, ypos, mainframename);
	end
	
end


function DRAW_ETC_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
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
	nameChild:SetText(fullname);

	-- 아이템 유저 거래 유무 세팅
	local trade_richtext = GET_CHILD(CSet, "trade_text", "ui::CRichText");
	local tradeText = "";
	local noTrade_cnt = GET_CHILD(CSet, "noTrade_cnt", "ui::CRichText");
	local noTradeCount = TryGetProp(invitem, "BelongingCount");
	if nil ~= noTradeCount and 0 > noTradeCount then
		noTradeCount = 0
	end
	noTrade_cnt:SetTextByKey('count', noTradeCount);

	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
	if itemProp ~= nil then
		if itemProp:IsExchangeable() == true then
			tradeText = ScpArgMsg("UserTradeAble")
		else
			tradeText = ScpArgMsg("UserTradeUnable")
			if nil ~= noTrade_cnt then
				noTrade_cnt:ShowWindow(0);
			end
		end
	else
		if nil ~= noTrade_cnt then
			noTrade_cnt:ShowWindow(0);
		end
	end

	trade_richtext:SetText(tradeText);
	
	-- 아이템 종류 세팅
	local type_richtext = GET_CHILD(CSet, "type_text", "ui::CRichText");
	type_richtext:SetTextByKey('type',ScpArgMsg(invitem.GroupName));
	
	--무게
	local weightRichtext = GET_CHILD(CSet, "weight_text", "ui::CRichText");
	weightRichtext:SetTextByKey('weight',invitem.Weight);

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

-- 회복량 표시.
function DRAW_ETC_HEAL_AMOUNT(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_etc_heal_amount');
	
	-- 회복량 등 표시
	local usable = IS_DRAW_ETC_ITEM_DAMAGE(invitem)

	if usable ~= 1 then
		return yPos;
	end

--	local Cset = gBox:CreateOrGetControlSet('tooltip_etc_heal_amount', 'tooltip_etc_heal_amount', 0, yPos);
--	
--	SET_DAMAGE_TEXT(Cset, ScpArgMsg("PotionRecovery"), 'None', invitem.NumberArg1, invitem.NumberArg2, 1);
--
--	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + Cset:GetHeight())
--	return Cset:GetHeight() + Cset:GetY();
	return yPos;
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