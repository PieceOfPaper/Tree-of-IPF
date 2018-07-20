-- lib_slot.lua

function SET_SLOT_ITEM_CLS(slot, itemCls)
	if itemCls == nil then
		return;
	end
	local img = itemCls.Icon;
	SET_SLOT_IMG(slot, img);
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
end



function SET_SLOT_ITEM_INFO(slot, itemCls, count)

	local icon = CreateIcon(slot);
	icon:EnableHitTest(0);

	if itemCls == nil then
		return;
	end

	icon:Set(itemCls.Icon, "item", itemCls.ClassID, count);
	slot:SetText('{s12}{ol}{b}'..count, 'count', 'right', 'bottom', -2, 1);
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
	return icon;
end


function SET_SLOT_ITEM_OBJ(slot, itemCls, gender, isBarrack)
	local img = GET_ITEM_ICON_IMAGE(itemCls, gender);

	SET_SLOT_IMG(slot, img);
	local icon = slot:GetIcon();

	if nil == icon then
		return;
	end
	local tooltipID = GetExProp(itemCls, "TooltipID");
	if tooltipID == 0 then
		SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls);
	else
		SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemCls, itemCls.ClassName, "tooltips", itemCls.ClassID, tooltipID);
		if nil == isBarrack then
			slot:CopyTooltipData(icon);
		end
	end
end

function SET_SLOT_INVITEM(slot, invItem, cnt, font, hor, ver, stateX, stateY)
	if cnt == nil then
		cnt = invItem.count;
	end

	local obj = GetIES(invItem:GetObject());
	local icon = CreateIcon(slot);
	icon:Set(obj.Icon, 'None', invItem.type, invItem.count, invItem:GetIESID(), cnt);
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, invItem.ClassName, 'None', invItem.type, invItem:GetIESID());
--SET_ITEM_TOOLTIP_TYPE(icon, invItem.type);
--icon:SetTooltipArg('None', invItem.type, invItem:GetIESID());
	SET_SLOT_COUNT_TEXT(slot, cnt, font, hor, ver, stateX, stateY);
end

function SET_SLOT_ITEM_INV(slot, itemCls)
		local type = itemCls.ClassID;
	local img = itemCls.Icon;
	SET_SLOT_IMG(slot, img)
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), type);

	local iconInfo = slot:GetIcon():GetInfo();
	iconInfo.type = type;
	local invItem = session.GetInvItemByType(type);
	if nil ~= invItem then
		slot:SetText('{s12}{ol}{b}'..invItem.count, 'count', 'right', 'bottom', -2, 1);
	end

	slot:SetEventScript(ui.RBUTTONDOWN, 'SLOT_ITEMUSE_BY_TYPE');
	slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, itemCls.ClassID);

	slot:SetEventScript(ui.LBUTTONUP, 'SLOT_ITEMUSE_BY_TYPE');
	slot:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);

end

-- ?˜ë‹¨ ?„ì´??ê°?ˆ˜ ?«ìžê°€ê°€ ? ì„œ... ?´ë?ì§€ë§?ë³´ì´ê²??˜ê¸° ?„í•´
function SET_SLOT_ITEM_IMANGE(slot, invItem)
	if nil == invItem then
		return;
	end

	if cnt == nil then
		cnt = invItem.count;
	end

	local obj = GetIES(invItem:GetObject());
	local icon = CreateIcon(slot);
	local iconName = GET_ITEM_ICON_IMAGE(obj);
	icon:Set(iconName, 'None', invItem.type, invItem.count, invItem:GetIESID(), cnt);
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, invItem.ClassName, 'None', invItem.type, invItem:GetIESID());
end

function SET_SLOT_ITEM(slot, invItem, count)

	local itemCls = GetClassByType("Item", invItem.type);

	local type = itemCls.ClassID;
	local obj = GetIES(invItem:GetObject());
	local img = GET_ITEM_ICON_IMAGE(obj);
	SET_SLOT_IMG(slot, img)
	SET_SLOT_COUNT(slot, count)
	SET_SLOT_IESID(slot, invItem:GetIESID())
	slot:SetTooltipArg('inven', type, invItem:GetIESID());

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	iconInfo.type = type;
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, itemCls.ClassName, 'inven', type, invItem:GetIESID());
	--SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls);
	--icon:SetTooltipArg('inven', type, invItem:GetIESID());

end

function SET_SLOT_IMG(slot, img)
	tolua.cast(slot, "ui::CSlot");
	local icon = CreateIcon(slot);
	icon:SetImage(img);

end

function SET_SLOT_IESID(slot, iesid)

	local icon = slot:GetIcon();
	if iesid == nil or icon == nil then
		return
	end
	
	tolua.cast(icon, "ui::CIcon");
	icon:SetIESID(iesid);

end

function SET_SLOT_COUNT(slot, count)

	local icon = slot:GetIcon();
	if count == nil or icon == nil then
		return
	end
	
	icon:SetCount(count);

end

function GET_SLOT(icon)

	local slot = icon:GetParent();
	return tolua.cast(slot, "ui::CSlot");

end

function CreateIconByIndex(slot, index)

	if index == 0 then
		return CreateIcon(slot);
	end

	return slot:CreateSubIcon(index - 1);

end

function CreateIcon(slot)

	if slot == nil then
		return nil;
	end

	local icon = slot:GetIcon();
	if icon == nil then
		icon = ui.CIcon:new();
		slot:SetIcon(icon);
	end

	return icon;
end

function CreateSlotFolderIcon(slotFolder, index)
	tolua.cast(slotFolder, "ui::CSlotFolder");
	local icon = slotFolder:GetIconByIndex(index);

	if icon == nil then
		icon = ui.CIcon:new();
		slotFolder:SetIcon(icon);
	end

	return icon;
end

function SET_SLOT_COUNT_TEXT(slot, cnt, font, hor, ver, stateX, stateY)
		if font == nil then
			font = '{s18}{ol}{b}';
		end
		
		if hor == nil then
			hor = 'right';
		end

		if ver == nil then
			ver = 'bottom';
		end

		if stateX == nil then
			stateX = -2;
		end

		if stateY == nil then
			stateY = 1;
		end
		
		slot:SetText(font..cnt, 'count', hor, ver, stateX, stateY);
end

function SET_SLOT_ITEM_TEXT(slot, invItem, obj)
	if obj.MaxStack > 1 then
		SET_SLOT_COUNT_TEXT(slot, invItem.count);
		return;
	end

	local lv = TryGetProp(obj, "Level");
	if lv ~= nil and lv > 1 then
		slot:SetFrontImage('enchantlevel_indi_icon');
		slot:SetText('{s20}{ol}{#FFFFFF}{b}'..lv, 'count', 'left', 'top', 8, 2);
		return;
	end
end

function SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, count)

	local refreshScp = TryGetProp(obj,'RefreshScp')

	if refreshScp ~= "None" and refreshScp ~= nil and obj ~= nil then
		refreshScpfun = _G[refreshScp];
		refreshScpfun(obj);
	end	

	if obj.MaxStack > 1 then
		if count ~= nil then
			SET_SLOT_COUNT_TEXT(slot, count);
		else
			SET_SLOT_COUNT_TEXT(slot, invItem.count);
		end
		return;
	end

	local lv = TryGetProp(obj, "Level");
	if lv ~= nil and lv > 1 then
		--slot:SetFrontImage('enchantlevel_indi_icon');
		slot:SetText('{s17}{ol}{#FFFFFF}{b}LV. '..lv, 'count', 'left', 'top', 3, 2);
		return;
	end
end

function GET_SLOT_ITEM(slot)

	slot = AUTO_CAST(slot);
	local icon = slot:GetIcon();
	if icon == nil then
		return nil;
	end
	local iconInfo = icon:GetInfo();

	if iconInfo:GetIESID() ~= "0" then
		return GET_PC_ITEM_BY_GUID(iconInfo:GetIESID()), iconInfo.count
	else
		return GET_PC_ITEM_BY_GUID(slot:GetTooltipIESID()), iconInfo.count
	end
end

function PLAY_SLOT_EFT(slot, eftName, size)

	local posX, posY = GET_SCREEN_XY(slot);
	movie.PlayUIEffect(eftName, posX, posY, size);
end

function SLOT_SELECT_COUNT(fullNameStack, maxSelectCount)

	INPUT_NUMBER_BOX(nil, ScpArgMsg("InputCount"), "_EXEC_SLOT_SELECT_COUNT", maxSelectCount, 1, maxSelectCount, nil, fullNameStack);

end

function _EXEC_SLOT_SELECT_COUNT(numberString, inputFrame)

	local nameString = inputFrame:GetUserValue("ArgString");

	local obj = ui.GetObjectByParentNameStackString(nameString);
	if obj == nil then
		return;
	end

	AUTO_CAST(obj);
	obj:Select(0, 0);
	if tonumber(numberString) > 0 then
		obj:Select(1, tonumber(numberString));
	end

	local slotSet = obj:GetParent();
	AUTO_CAST(slotSet);
	slotSet:MakeSelectionList();


end