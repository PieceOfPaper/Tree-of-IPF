-- housing_tooltip.lua

function ITEM_TOOLTIP_HOUSING(tooltipframe, invitem, argStr, usesubframe)
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'equip_main';

	local ypos = DRAW_HOUSING_TOOLTIP(tooltipframe, invitem, mainframename, argStr); -- 기타 템이라면 공통적으로 그리는 툴팁들	
	ypos = DRAW_ETC_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 아이템 설명.
	ypos = DRAW_ETC_RECIPE_NEEDITEM_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 재료템이라면 필요한 재료랑 보여줌
	ypos = DRAW_EQUIP_TRADABILITY(tooltipframe, invitem, ypos, mainframename);

	ypos = DRAW_HOUSING_SELL_PRICE(tooltipframe, invitem, ypos, mainframename); -- 가격
end

function DRAW_HOUSING_TOOLTIP(tooltipframe, invitem, mainframename, from)
	local gbox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gbox:RemoveAllChild();

	local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
	gbox:SetSkinName('test_Item_tooltip_normal');

	local tooltip_housing = gbox:CreateControlSet("tooltip_housing", 'tooltip_housing', 0, 0);
	tolua.cast(tooltip_housing, "ui::CControlSet");

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(tooltip_housing, "name", "ui::CRichText");
	nameChild:SetText(fullname);
	nameChild:AdjustFontSizeByWidth(nameChild:GetWidth());
	nameChild:SetTextAlign("center","center");

	-- 아이템 이미지
	local item_bg = GET_CHILD(tooltip_housing, "item_bg", "ui::CPicture");
	item_bg:SetImage("one_two_star_item_bg3");

	local itemPicture = GET_CHILD(tooltip_housing, "itempic", "ui::CPicture");
	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
	    local itemImg = invitem.TooltipImage;

		itemPicture:SetImage(itemImg);
		itemPicture:ShowWindow(1);
	else
		itemPicture:ShowWindow(0);
	end
	
	local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(invitem.ClassName);

	local value_list = GET_CHILD_RECURSIVELY(tooltip_housing, "value_list");
	value_list:SetTextByKey("list", TryGetProp(furnitureClass, "Category"));

	local value_size = GET_CHILD_RECURSIVELY(tooltip_housing, "value_size");
	local size = string.format("%sx%s", TryGetProp(furnitureClass, "Column"), TryGetProp(furnitureClass, "Row"));
	value_size:SetTextByKey("size", size);

	local gbox_rotation = GET_CHILD_RECURSIVELY(tooltip_housing, "gbox_rotation");

	local rotationType = TryGetProp(furnitureClass, "RotationType");
	if rotationType == "AllSides" then
		local pic_rotation_rightdown_close = gbox_rotation:GetChild("pic_rotation_rightdown_close");
		pic_rotation_rightdown_close:ShowWindow(0);

		local pic_rotation_rightup_close = gbox_rotation:GetChild("pic_rotation_rightup_close");
		pic_rotation_rightup_close:ShowWindow(0);

		local pic_rotation_leftup_close = gbox_rotation:GetChild("pic_rotation_leftup_close");
		pic_rotation_leftup_close:ShowWindow(0);

		local pic_rotation_leftdown_close = gbox_rotation:GetChild("pic_rotation_leftdown_close");
		pic_rotation_leftdown_close:ShowWindow(0);

		local pic_rotation_rightdown_open = gbox_rotation:GetChild("pic_rotation_rightdown_open");
		pic_rotation_rightdown_open:ShowWindow(1);

		local pic_rotation_rightup_open = gbox_rotation:GetChild("pic_rotation_rightup_open");
		pic_rotation_rightup_open:ShowWindow(1);

		local pic_rotation_leftup_open = gbox_rotation:GetChild("pic_rotation_leftup_open");
		pic_rotation_leftup_open:ShowWindow(1);

		local pic_rotation_leftdown_open = gbox_rotation:GetChild("pic_rotation_leftdown_open");
		pic_rotation_leftdown_open:ShowWindow(1);
	elseif rotationType == "TwoSides" then
		local pic_rotation_rightdown_close = gbox_rotation:GetChild("pic_rotation_rightdown_close");
		pic_rotation_rightdown_close:ShowWindow(0);

		local pic_rotation_rightup_close = gbox_rotation:GetChild("pic_rotation_rightup_close");
		pic_rotation_rightup_close:ShowWindow(1);

		local pic_rotation_leftup_close = gbox_rotation:GetChild("pic_rotation_leftup_close");
		pic_rotation_leftup_close:ShowWindow(1);

		local pic_rotation_leftdown_close = gbox_rotation:GetChild("pic_rotation_leftdown_close");
		pic_rotation_leftdown_close:ShowWindow(0);

		local pic_rotation_rightdown_open = gbox_rotation:GetChild("pic_rotation_rightdown_open");
		pic_rotation_rightdown_open:ShowWindow(1);

		local pic_rotation_rightup_open = gbox_rotation:GetChild("pic_rotation_rightup_open");
		pic_rotation_rightup_open:ShowWindow(0);

		local pic_rotation_leftup_open = gbox_rotation:GetChild("pic_rotation_leftup_open");
		pic_rotation_leftup_open:ShowWindow(0);

		local pic_rotation_leftdown_open = gbox_rotation:GetChild("pic_rotation_leftdown_open");
		pic_rotation_leftdown_open:ShowWindow(1);
	else
		local pic_rotation_rightup_close = gbox_rotation:GetChild("pic_rotation_rightup_close");
		pic_rotation_rightup_close:ShowWindow(1);

		local pic_rotation_leftup_close = gbox_rotation:GetChild("pic_rotation_leftup_close");
		pic_rotation_leftup_close:ShowWindow(1);

		local pic_rotation_rightup_open = gbox_rotation:GetChild("pic_rotation_rightup_open");
		pic_rotation_rightup_open:ShowWindow(0);

		local pic_rotation_leftup_open = gbox_rotation:GetChild("pic_rotation_leftup_open");
		pic_rotation_leftup_open:ShowWindow(0);

		local frontDirection = TryGetProp(furnitureClass, "FrontDirection", "Right");
		if frontDirection == "Right" then
			local pic_rotation_rightdown_close = gbox_rotation:GetChild("pic_rotation_rightdown_close");
			pic_rotation_rightdown_close:ShowWindow(0);

			local pic_rotation_rightdown_open = gbox_rotation:GetChild("pic_rotation_rightdown_open");
			pic_rotation_rightdown_open:ShowWindow(1);

			local pic_rotation_leftdown_close = gbox_rotation:GetChild("pic_rotation_leftdown_close");
			pic_rotation_leftdown_close:ShowWindow(1);

			local pic_rotation_leftdown_open = gbox_rotation:GetChild("pic_rotation_leftdown_open");
			pic_rotation_leftdown_open:ShowWindow(0);
		else
			local pic_rotation_rightdown_close = gbox_rotation:GetChild("pic_rotation_rightdown_close");
			pic_rotation_rightdown_close:ShowWindow(1);

			local pic_rotation_rightdown_open = gbox_rotation:GetChild("pic_rotation_rightdown_open");
			pic_rotation_rightdown_open:ShowWindow(0);

			local pic_rotation_leftdown_close = gbox_rotation:GetChild("pic_rotation_leftdown_close");
			pic_rotation_leftdown_close:ShowWindow(0);

			local pic_rotation_leftdown_open = gbox_rotation:GetChild("pic_rotation_leftdown_open");
			pic_rotation_leftdown_open:ShowWindow(1);
		end
	end

	gbox:Resize(gbox:GetWidth(),gbox:GetHeight() + tooltip_housing:GetHeight())
	return tooltip_housing:GetHeight();
end

function DRAW_HOUSING_SELL_PRICE(tooltipframe, invitem, yPos, mainframename)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
    if itemProp:IsEnableShopTrade() == false then
        return yPos
    end

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_sellinfo');

	local tooltip_sellinfo_CSet = gBox:CreateControlSet('tooltip_sellinfo', 'tooltip_sellinfo', 0, yPos);
	tolua.cast(tooltip_sellinfo_CSet, "ui::CControlSet");

	local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(invitem.ClassName);
	if furnitureClass ~= nil then
		local baseidClass = GetClass("inven_baseid", invitem.MarketCategory);
		if baseidClass.TreeGroup == "Housing" then
			local priceText1 = string.format("{img icon_guild_housing_coin_01 20 20} {@st66b}%s", TryGetProp(furnitureClass, "SellPrice1", 0));
			local priceText2 = string.format("  {img icon_guild_housing_coin_02 20 20} {@st66b}%s", TryGetProp(furnitureClass, "SellPrice2", 0));
			local priceText3 = string.format("  {img icon_guild_housing_coin_03 20 20} {@st66b}%s", TryGetProp(furnitureClass, "SellPrice3", 0));
			local priceText4 = string.format("  {img icon_guild_housing_coin_04 20 20} {@st66b}%s", TryGetProp(furnitureClass, "SellPrice4", 0));
			local txt_price = GET_CHILD(tooltip_sellinfo_CSet, 'sellprice', 'ui::CRichText');
			txt_price:SetText(priceText1 .. priceText2 .. priceText3 .. priceText4);
		else
			local priceText1 = string.format("{img silver 20 20} {@st66b}%s", TryGetProp(invitem, "SellPrice", 0));
			local txt_price = GET_CHILD(tooltip_sellinfo_CSet, 'sellprice', 'ui::CRichText');
			txt_price:SetText(priceText1);
		end
	end

	local pic_silver = GET_CHILD(tooltip_sellinfo_CSet, "silver");
	pic_silver:ShowWindow(0);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_sellinfo_CSet:Resize(gBox:GetWidth(), tooltip_sellinfo_CSet:GetHeight() + BOTTOM_MARGIN);

	local height = gBox:GetHeight() + tooltip_sellinfo_CSet:GetHeight();
	gBox:Resize(gBox:GetWidth(), height);
	return yPos + tooltip_sellinfo_CSet:GetHeight();
end