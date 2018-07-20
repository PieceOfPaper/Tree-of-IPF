---- exporb_tooltip.lua
-- ExpOrb Items

function ITEM_TOOLTIP_LEGENDEXPPOTION(tooltipframe, invitem, strarg)
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'legendexppotion'
	local ypos = DRAW_LEGENDEXPPOTION_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); 
    ypos = DRAW_LEGENDEXPPOTION_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end

function GET_LEGENDEXPPOTION_ICON_IMAGE(itemObj)
	local curExp, maxExp = itemObj.ItemExp, itemObj.NumberArg1;
	local emptyImage, fullImage = TryGetProp(itemObj, "TooltipImage"), TryGetProp(itemObj, "StringArg");
	if curExp == maxExp then
		return fullImage;
	end
	return emptyImage;
end

function DRAW_LEGENDEXPPOTION_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSet = gBox:CreateControlSet('tooltip_legendexppotion_common', 'legendexppotion_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);

	local level_gauge = GET_CHILD(CSet,'level_gauge','ui::CGauge')
	local lv, curExp, maxExp = 1, invitem.ItemExp, invitem.NumberArg1
	if curExp > maxExp then
		curExp = maxExp;
	end
	level_gauge:SetPoint(curExp, maxExp);

	local itemPicture = GET_CHILD(CSet, "itempic", "ui::CPicture");
	local tooltipImage = GET_LEGENDEXPPOTION_ICON_IMAGE(invitem);
	if tooltipImage ~= nil and tooltipImage ~= 'None' then
		itemPicture:SetImage(tooltipImage);
		itemPicture:ShowWindow(1);
	else
		itemPicture:ShowWindow(0);
	end

	local weightRichtext = GET_CHILD(CSet, "weight_text", "ui::CRichText");
	weightRichtext:SetTextByKey("weight",invitem.Weight);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight();
end

function DRAW_LEGENDEXPPOTION_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_legendexppotion_tradability');

	local CSet = gBox:CreateControlSet('tooltip_legendexppotion_tradability', 'tooltip_legendexppotion_tradability', 0, ypos);
	tolua.cast(CSet, "ui::CControlSet");
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_npc', 'option_npc_text', 'ShopTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_market', 'option_market_text', 'MarketTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_teamware', 'option_teamware_text', 'TeamTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_trade', 'option_trade_text', 'UserTrade')

	CSet:Resize(CSet:GetWidth(),CSet:GetHeight());
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
    return ypos + CSet:GetHeight();
end

