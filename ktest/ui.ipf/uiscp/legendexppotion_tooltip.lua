---- exporb_tooltip.lua
-- ExpOrb Items

function ITEM_TOOLTIP_LEGENDEXPPOTION(tooltipframe, invitem, strarg)
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'legendexppotion'
	local ypos = DRAW_LEGENDEXPPOTION_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, strarg); 
	ypos = DRAW_LEGENDEXPPOTION_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_LEGENDEXPPOTION_TRADABILITY_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end

function DRAW_LEGENDEXPPOTION_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, strarg)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSet = gBox:CreateControlSet('tooltip_legendexppotion_common', 'legendexppotion_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);

	local level_gauge = GET_CHILD(CSet,'level_gauge','ui::CGauge')
	local itemPicture = GET_CHILD(CSet, "itempic", "ui::CPicture");
	
	local curExp, maxExp = GET_LEGENDEXPPOTION_EXP(invitem);
	local tooltipImage = GET_LEGENDEXPPOTION_ICON_IMAGE(invitem);
	
	if strarg == 'maxexp' then
		curExp = maxExp;
		tooltipImage = GET_LEGENDEXPPOTION_ICON_IMAGE_FULL(invitem);
	end
	
	level_gauge:SetPoint(curExp, maxExp);
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

function DRAW_LEGENDEXPPOTION_DESC_TOOLTIP(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_legendexppotion_desc');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_legendexppotion_desc', 'tooltip_legendexppotion_desc', 0, yPos);
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

function GET_LEGENDEXPPOTION_EXP(itemObj)
	local curExpStr, maxExp = itemObj.ItemExpString, itemObj.NumberArg1;
	local curExp = tonumber(curExpStr);
	if curExp == nil then
		curExp = 0;
	end

	if GetExpOrbGuidStr() ~= "0" then
		if GetExpOrbGuidStr() == GetIESID(itemObj) and curExp < maxExp then
				curExp = GetExpOrbFillingExp();
		end
	end
    return curExp, maxExp;
end

function GET_LEGENDEXPPOTION_ICON_IMAGE_FULL(itemObj)
    return TryGetProp(itemObj, "StringArg");
end

function GET_LEGENDEXPPOTION_ICON_IMAGE(itemObj)
    local curExp, maxExp = GET_LEGENDEXPPOTION_EXP(itemObj);
	if curExp >= maxExp then
		return GET_LEGENDEXPPOTION_ICON_IMAGE_FULL(itemObj);
	end
    local emptyImage = TryGetProp(itemObj, "TooltipImage");
	return emptyImage;
end
