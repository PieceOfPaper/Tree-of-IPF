-- bosscard_tooltip.lua
-- 보스카드 아이템

function ITEM_TOOLTIP_BOSSCARD(tooltipframe, invitem, strarg)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'bosscard'

	local ypos = DRAW_BOSSCARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 보스 카드라면 공통적으로 그리는 툴팁들
	ypos = DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_BOSSCARD_EXP_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 경험치 바
    ypos = DRAW_BOSSCARD_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 
	ypos = DRAW_BOSSCARD_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end

function ITEM_TOOLTIP_LEGEND_BOSSCARD(tooltipframe, invitem, strarg)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'bosscard'

	local ypos = DRAW_BOSSCARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 보스 카드라면 공통적으로 그리는 툴팁들
	ypos = DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
        ypos = DRAW_BOSSCARD_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 
	ypos = DRAW_BOSSCARD_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end

function ITEM_TOOLTIP_REINFORCE_CARD(tooltipframe, invitem, strarg)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'bosscard'

	local ypos = DRAW_REINFORCE_CARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 강화용 카드 툴팁
	ypos = DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_BOSSCARD_EXP_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 경험치 바
    ypos = DRAW_BOSSCARD_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 
	ypos = DRAW_BOSSCARD_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end


function DRAW_REINFORCE_CARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSetBg = gBox : CreateControlSet('tooltip_bosscard_bg', 'boss_bg_cset', 0, 200);

	local CSet = gBox:CreateControlSet('tooltip_bosscard_common', 'boss_common_cset', 0, 50);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기
	

	-- 카드 테두리 세팅
	SET_CARD_EDGE_TOOLTIP(CSet, invitem);

	-- 아이템 이미지
	local itemPicture = GET_CHILD(CSet, "itempic");
	itemPicture:SetImage(invitem.TooltipImage);

	-- 별 그리기
	SET_GRADE_TOOLTIP(CSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name");
	nameChild:SetText(fullname);

	local typeRichtext = GET_CHILD(CSet, "type_text");
	typeRichtext:SetText("");
    
	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),typeRichtext:GetY() + typeRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight() + 50)
	return CSet:GetHeight()+50;
end



function DRAW_BOSSCARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSetBg = gBox : CreateControlSet('tooltip_bosscard_bg', 'boss_bg_cset', 0, 200);
	local CSet = gBox:CreateControlSet('tooltip_bosscard_common', 'boss_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 카드 테두리 세팅
	SET_CARD_EDGE_TOOLTIP(CSet, invitem);

	-- 아이템 이미지
	local spineItemPicture = GET_CHILD(CSet, "itempic");
	SET_SPINE_TOOLTIP_IMAGE(spineItemPicture, invitem);

	-- 별 그리기
	SET_GRADE_TOOLTIP(CSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name");
	nameChild:SetText(fullname);

	-- 종족 세팅
	local bossCls = GetClassByType('Monster', invitem.NumberArg1);
	local typeRichtext = GET_CHILD(CSet, "type_text");
	typeRichtext:SetText(ScpArgMsg(bossCls.RaceType));
    
	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),typeRichtext:GetY() + typeRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight());
	return CSet:GetHeight();
end

--포텐 및 내구도
function DRAW_BOSSCARD_EXP_TOOLTIP(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename)
	gBox:RemoveChild('tooltip_bosscard_exp');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_exp', 'tooltip_bosscard_exp', 0, yPos);

	--경험치 게이지
	local gauge = GET_CHILD(CSet,'level_gauge','ui::CGauge')
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(invitem);
	if curExp > maxExp then
		curExp = maxExp;
	end
	gauge:SetPoint(curExp, maxExp);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--스텟
function DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename)
	gBox:RemoveChild('tooltip_bosscard_desc');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_desc', 'tooltip_bosscard_desc', 0, yPos);
		
	--스텟
	local desc_text = GET_CHILD(CSet,'desc_text')
	if invitem.GroupName == "Card" then
		local tempText1 = invitem.Desc;
		local tempText2 = invitem.Desc_Sub;
		if invitem.Desc == "None" then
			tempText1 = "";
		end
		if invitem.Desc_Sub == "None" then
			tempText2 = "";
		end
		local textDesc = string.format("%s{nl}%s{/}", tempText1, tempText2)	
		desc_text:SetTextByKey("text", textDesc);
		CSet:Resize(CSet:GetWidth(), desc_text:GetHeight() + desc_text:GetOffsetY());
	else
		desc_text:SetTextByKey("text", invitem.Desc);
		CSet:Resize(CSet:GetWidth(), desc_text:GetHeight() + desc_text:GetOffsetY());
	end
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

function DRAW_BOSSCARD_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_bosscard_tradability');

	local CSet = gBox:CreateControlSet('tooltip_bosscard_tradability', 'tooltip_bosscard_tradability', 0, ypos);
	tolua.cast(CSet, "ui::CControlSet");
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_npc', 'option_npc_text', 'ShopTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_market', 'option_market_text', 'MarketTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_teamware', 'option_teamware_text', 'TeamTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_trade', 'option_trade_text', 'UserTrade')

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
    return ypos + CSet:GetHeight();
end
function DRAW_BOSSCARD_SELL_PRICE(tooltipframe, invitem, yPos, mainframename)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
	if itemProp:IsEnableShopTrade() == false then
		return yPos
	end

	local gBox = GET_CHILD(tooltipframe, mainframename, 'ui::CGroupBox')
	gBox : RemoveChild('tooltip_sellinfo_bosscard');
	
	local tooltip_sellinfo_CSet = gBox:CreateControlSet('tooltip_sellinfo_bosscard', 'tooltip_sellinfo_bosscard', 0, yPos);
	tolua.cast(tooltip_sellinfo_CSet, "ui::CControlSet");

	local sellprice_text = GET_CHILD(tooltip_sellinfo_CSet, 'sellprice', 'ui::CRichText')
	sellprice_text:SetTextByKey("silver", GET_COMMAED_STRING(geItemTable.GetSellPrice(itemProp)));

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); --맨 아랫쪽 여백
	tooltip_sellinfo_CSet : Resize(tooltip_sellinfo_CSet : GetWidth(), tooltip_sellinfo_CSet : GetHeight() + BOTTOM_MARGIN);

	local height = gBox:GetHeight() + tooltip_sellinfo_CSet : GetHeight();
	gBox:Resize(gBox : GetWidth(), height);
	return yPos + tooltip_sellinfo_CSet:GetHeight();
end