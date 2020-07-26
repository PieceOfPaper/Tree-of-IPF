
function LEGENDPREFIX_TOOLTIP_ON_INIT(addon, frame)

end

function OPEN_LEGENDPREFIX_TOOLTIP()
	ui.OpenFrame('legendprefix_tooltip');
	
	local frame = ui.GetFrame("legendprefix_tooltip");
	if frame ~= nil then
		frame:SetVisible(0);
	end
end

function LEGEND_PREFIX_SELECT_TOOLTIP_DRAW(frame, targetItem, xpos, ypos, preFixName)
	if targetItem == nil then return end
	local targetObject = nil;
	if targetItem ~= nil then
		targetObject = GetIES(targetItem:GetObject());
	end

	frame:RemoveChild("SetItemOptionToolTip");
	local tooltip_CSet = frame:CreateControlSet('tooltip_set', 'SetItemOptionToolTip', xpos, ypos);

	if tooltip_CSet ~= nil then
		tolua.cast(tooltip_CSet, "ui::CControlSet");
		local set_gbox_type= GET_CHILD_RECURSIVELY(tooltip_CSet,'set_gbox_type');
		local set_gbox_prop= GET_CHILD_RECURSIVELY(tooltip_CSet,'set_gbox_prop');

		local DEFAULT_POS_Y = tooltip_CSet:GetUserConfig("DEFAULT_POS_Y")
		local inner_xPos = 0;
		local inner_yPos = DEFAULT_POS_Y;

		local EntireHaveCount = 0;
		local setList = {'RH', 'LH', 'SHIRT', 'PANTS', 'GLOVES', 'BOOTS'}
		local setFlagList = {RH_flag, LH_flag, SHIRT_flag, PANTS_flag, GLOVES_flag, BOOTS_flag}
		local setItemCount = 0

		setItemCount, setFlagList[1], setFlagList[2], setFlagList[3], setFlagList[4], setFlagList[5], setFlagList[6] = CHECK_EQUIP_SET_ITEM(targetObject)

		for i = 1, setItemCount do
			local setItemTextCset = set_gbox_type:CreateControlSet('eachitem_in_setitemtooltip', 'setItemText'..i, inner_xPos, inner_yPos);
			tolua.cast(setItemTextCset, "ui::CControlSet");
			local setItemName = GET_CHILD_RECURSIVELY(setItemTextCset, "setitemtext")
			if setFlagList[i] == 0 then
				setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("NOT_HAVE_ITEM_FONT"))
			else 
				setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("HAVE_ITEM_FONT"))
				EntireHaveCount = EntireHaveCount + 1
			end

			local prefixCls = GetClass('LegendSetItem', preFixName)

			local temp = ""
			if prefixCls ~= nil then
				temp = prefixCls.Name
			end
			local setItemText = temp .. ' ' .. tooltip_CSet:GetUserConfig(setList[i] .. '_SET_TEXT')
			setItemName:SetTextByKey("itemname", setItemText)
			local heightMargin = setItemTextCset:GetUserConfig("HEIGHT_MARGIN")
			inner_yPos = inner_yPos + heightMargin;
		end

		set_gbox_type:Resize(set_gbox_type:GetWidth(), inner_yPos)
		local USE_SETOPTION_FONT = tooltip_CSet:GetUserConfig("USE_SETOPTION_FONT")
		local NOT_USE_SETOPTION_FONT = tooltip_CSet:GetUserConfig("NOT_USE_SETOPTION_FONT");

		inner_yPos = DEFAULT_POS_Y;

		local prefixCls = GetClass('LegendSetItem', preFixName)
		local max_option_count = TryGetProp(prefixCls, 'MaxOptionCount', 5)
		if prefixCls ~= nil then
			for i = 0, (max_option_count - 3) do
				local index = 'EffectDesc_' .. i + 3
				local color = USE_SETOPTION_FONT
				if EntireHaveCount >= i + 3 then
					color = NOT_USE_SETOPTION_FONT
				end

				local setTitle = ScpArgMsg("Auto_{s16}{Auto_1}{Auto_2}_SeTeu_HyoKwa__{nl}", "Auto_1",color, "Auto_2",i + 3);
				local setDesc = string.format("{s16}%s%s", color, prefixCls[index]);

				local each_text_CSet = set_gbox_prop:CreateControlSet('tooltip_set_each_prop_text', 'each_text_CSet'..i, inner_xPos, inner_yPos);
				tolua.cast(each_text_CSet, "ui::CControlSet");
				local set_text = GET_CHILD(each_text_CSet,'set_prop_Text','ui::CRichText')
				set_text:SetTextByKey("setTitle",setTitle)
				set_text:SetTextByKey("setDesc",setDesc)

				local labelline = GET_CHILD_RECURSIVELY(each_text_CSet, 'labelline')
				local y_margin = each_text_CSet:GetUserConfig("TEXT_Y_MARGIN")
				local testRect = set_text:GetMargin();
				each_text_CSet:Resize(each_text_CSet:GetWidth(), set_text:GetHeight() + testRect.top);				
				inner_yPos = inner_yPos + each_text_CSet:GetHeight() + y_margin;
			end
		end

		local BOTTOM_MARGIN = 5;
		set_gbox_prop:Resize(set_gbox_prop:GetWidth(), inner_yPos + BOTTOM_MARGIN)
		set_gbox_prop:SetOffset(set_gbox_prop:GetX() + 5, set_gbox_type:GetY() + set_gbox_type:GetHeight())

		tooltip_CSet:Resize(tooltip_CSet:GetWidth(), set_gbox_prop:GetHeight() + set_gbox_prop:GetY() + BOTTOM_MARGIN);
		
		local margin = frame:GetMargin();
		local x = margin.left;
		local y = margin.top;
		frame:Resize(x, y, tooltip_CSet:GetWidth() + 5, tooltip_CSet:GetHeight());
	end
end
