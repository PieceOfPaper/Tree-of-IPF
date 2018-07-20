---- lib_detaillist

function INSERT_TEXT_DETAIL_LIST(itemlist, row, col, text, horAlign, Item, textTooltip)
	local ctrl = itemlist:CreateControl("richtext", "DETAIL_ITEM_" .. row .. "_" .. col, 0, 0, 200, 20);
	ctrl = tolua.cast(ctrl, "ui::CRichText");
	ctrl:EnableResizeByText(0);
	ctrl:SetTextFixWidth(1);
	ctrl:SetTextFixHeight(true);
	if nil ~= Item then
		local obj = GetIES(Item:GetObject());
		if nil ~= obj and
		   obj.ClassName == 'Scroll_SkillItem' then		
			local sklCls = GetClassByType("Skill", obj.SkillType)
			text = text .. " [".. sklCls.Name .. ":" .. obj.SkillLevel.."]";
		end
	end
	ctrl:SetText(text);
	if horAlign == nil then
		horAlign = "center";
	end

	ctrl:SetTextAlign(horAlign, "center");

	ctrl:EnableHitTest(1);
	ctrl:SetUseOrifaceRect(true);

	itemlist:SetObjectRowCol(ctrl, row, col);
	if textTooltip ~= nil then
		ctrl:SetTextTooltip(textTooltip);
	end

	return ctrl;
end

function INSERT_NUMUPDOWN_DETAIL_LIST(itemlist, row, col, text)
	local ctrl = itemlist:CreateControl("numupdown", "DETAIL_ITEM_" .. row .. "_" .. col, 0, 0, 200, 30);
	ctrl = tolua.cast(ctrl, "ui::CNumUpDown");
	ctrl:SetFontName("white_18_ol");
	ctrl:MakeButtons("btn_numdown", "btn_numup", "editbox");
	ctrl:ShowWindow(1);

	itemlist:SetObjectRowCol(ctrl, row, col, 3, false);
	return ctrl;
end

function INSERT_PICTURE_DETAIL_LIST(itemlist, row, col, imageName, picSize)
	local ctrl = itemlist:CreateControl("picture", "DETAIL_ITEM_" .. row .. "_" .. col, 0, 0, picSize, picSize);
	ctrl = tolua.cast(ctrl, ctrl:GetClassString());
	ctrl:ShowWindow(1);
	ctrl:SetImage(imageName);
	ctrl:SetEnableStretch(1);
	itemlist:SetObjectRowCol(ctrl, row, col, 3, false);
	return ctrl;
end


function INSERT_BUTTON_DETAIL_LIST(itemlist, row, col, text, notUseAnim)
	local ctrl = itemlist:CreateControl("button", "DETAIL_ITEM_" .. row .. "_" .. col, 0, 0, 200, 20);
	ctrl = tolua.cast(ctrl, "ui::CButton");
	ctrl:ShowWindow(1);
	ctrl:SetText(text);
	ctrl:SetTextAlign("center", "center");

	if notUseAnim ~= true then
		ctrl:SetAnimation("MouseOnAnim", "btn_mouseover");
		ctrl:SetAnimation("MouseOffAnim", "btn_mouseoff");
	end
	itemlist:SetObjectRowCol(ctrl, row, col, 3);
	return ctrl;
end

function INSERT_CONTROLSET_DETAIL_LIST(itemlist, row, col, ctrlSetName)
	local ctrl = itemlist:CreateControlSet(ctrlSetName, "DETAIL_ITEM_" .. row .. "_" .. col, 0, 0);
	ctrl:ShowWindow(1);
	itemlist:SetObjectRowCol(ctrl, row, col, 3);
	return ctrl;
end




