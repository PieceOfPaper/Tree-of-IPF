-- lib_slot.lua

imcSlot = {
	GetEmptySlotIndex = function(self, slotset)
		for i = 0, slotset:GetSlotCount() - 1 do
			if slotset:GetSlotByIndex(i):GetIcon() == nil then
				return i;
			end
		end
		return 0;
	end,
	GetFilledSlotCount = function(self, slotset)
		local cnt = 0;
		for i = 0, slotset:GetSlotCount() - 1 do
			if slotset:GetSlotByIndex(i):GetIcon() ~= nil then
				cnt = cnt + 1;
			end
		end
		return cnt;
	end,
	SetImage = function(self, slot, img)		
		tolua.cast(slot, "ui::CSlot");
		local icon = slot:GetIcon();
		if icon == nil then
			icon = CreateIcon(slot);
		end
		icon:SetImage(img);
		return icon;
	end,
	SetItemInfo = function(self, slot, invItem, count)
		local itemCls = GetClassByType("Item", invItem.type);
		local type = itemCls.ClassID;
		local obj = GetIES(invItem:GetObject());
		local img = GET_ITEM_ICON_IMAGE(obj);    
		self:SetImage(slot, img);
		SET_SLOT_COUNT(slot, count);
		SET_SLOT_IESID(slot, invItem:GetIESID());
		local icon = slot:GetIcon();
		local iconInfo = icon:GetInfo();
		iconInfo.type = type;
		SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, itemCls.ClassName, 'inven', type, invItem:GetIESID());
		return icon;
	end,
};

function SET_SLOT_ITEM_CLS(slot, itemCls)
	if itemCls == nil then
		return;
	end
	local img =	GET_EQUIP_ITEM_IMAGE_NAME(itemCls, "TooltipImage");
	if itemCls.GroupName == "Card" or itemCls.GroupName == "Recipe" then
		img = itemCls.Icon
	end
	
	SET_SLOT_IMG(slot, img);
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
end



function SET_SLOT_ITEM_INFO(slot, itemCls, count, style)
	local icon = CreateIcon(slot);
	icon:EnableHitTest(0);
	if itemCls == nil then
		return;
	end
    local iconImageName = GET_EQUIP_ITEM_IMAGE_NAME(itemCls, 'Icon');
    if style == nil then
        style = '{s20}{ol}{b}'
    end
	icon:Set(iconImageName, "item", itemCls.ClassID, count);
	if itemCls.ItemType ~= "Equip" then
		slot:SetText(style..count, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
	end

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

function SET_SLOT_INVITEM_NOT_COUNT(slot, invItem, cnt, font, hor, ver, stateX, stateY)
	if cnt == nil then
		cnt = invItem.count;
	end

	local obj = GetIES(invItem:GetObject());
	local icon = CreateIcon(slot);
	icon:Set(obj.Icon, 'None', invItem.type, invItem.count, invItem:GetIESID(), cnt);
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, invItem.ClassName, 'None', invItem.type, invItem:GetIESID());
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
		slot:SetText('{s12}{ol}{b}'..invItem.count, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
	end

	slot:SetEventScript(ui.RBUTTONDOWN, 'SLOT_ITEMUSE_BY_TYPE');
	slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, itemCls.ClassID);

	slot:SetEventScript(ui.LBUTTONUP, 'SLOT_ITEMUSE_BY_TYPE');
	slot:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);

end

function SET_SLOT_ITEM_IMAGE(slot, invItem)
	if nil == invItem then
		return;
	end

	if cnt == nil then
		cnt = invItem.count;
	end

	local obj = GetIES(invItem:GetObject());
	local icon = slot:GetIcon();
    if icon == nil then
        icon = CreateIcon(slot);
    end
	local iconName = GET_ITEM_ICON_IMAGE(obj);
	icon:Set(iconName, 'None', invItem.type, invItem.count, invItem:GetIESID(), cnt);
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invItem, invItem.ClassName, 'None', invItem.type, invItem:GetIESID());
end

function SET_SLOT_ITEM(slot, invItem, count)
	imcSlot:SetItemInfo(slot, invItem, count);
end

function SET_SLOT_IMG(slot, img)
	imcSlot:SetImage(slot, img);
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
			hor = ui.RIGHT;
		end

		if ver == nil then
			ver = ui.BOTTOM;
		end

		if stateX == nil then
			stateX = -2;
		end

		if stateY == nil then
			stateY = 1;
		end
		
		slot:SetText(font..cnt, 'count', hor, ver, stateX, stateY);
end

function SET_SLOT_STYLESET(slot, itemCls, itemGrade_Flag, itemLevel_Flag, itemAppraisal_Flag, itemReinforce_Flag, isInventory)
	if slot == nil then
		return
	end

	if itemCls == nil then
		return
	end

	if itemGrade_Flag == nil or itemGrade_Flag == 1 then
		if isInventory ~= nil and isInventory == 1 and config.GetXMLConfig("ViewGradeStyle") == 0 then
			
		else
			SET_SLOT_BG_BY_ITEMGRADE(slot, itemCls.ItemGrade)
		end
	end

	if itemLevel_Flag == nil or itemLevel_Flag == 1 then
		if isInventory ~= nil and isInventory == 1 and config.GetXMLConfig("ViewTranscendStyle") == 0 then
		
		else
			SET_SLOT_TRANSCEND_LEVEL(slot, TryGetProp(itemCls, 'Transcend'))
		end
	end

	local needAppraisal = nil
	local needRandomOption = nil
	if itemCls ~= nil then
		needAppraisal = TryGetProp(itemCls, "NeedAppraisal");
		needRandomOption = TryGetProp(itemCls, "NeedRandomOption");
	end

	if itemAppraisal_Flag == nil or itemAppraisal_Flag == 1 then
		SET_SLOT_NEED_APPRAISAL(slot, needAppraisal, needRandomOption)
	end

	if itemReinforce_Flag == nil or itemReinforce_Flag == 1 then
		if isInventory ~= nil and isInventory == 1 and config.GetXMLConfig("ViewReinforceStyle") == 0 then

		else
			local reinforceLv = TryGetProp(itemCls, 'Reinforce_2');
			if TryGetProp(itemCls, 'GroupName') == 'Seal' then
				reinforceLv = GET_CURRENT_SEAL_LEVEL(itemCls);
			end
			SET_SLOT_REINFORCE_LEVEL(slot, reinforceLv);			
		end
	end

	if TryGetProp(itemCls, "Dur") ~= nil then
		SET_SLOT_DURATION(slot, itemCls)
	end
end


function SET_SLOT_TRANSCEND_LEVEL(slot, transcendLv)
	if slot == nil then
		return
	end 

	DESTROY_CHILD_BYNAME(slot, "styleset_transcend")
	
	if transcendLv == nil or transcendLv == 0 then
		return
	end

	local icon = slot:GetIcon()
	if icon == nil then
		return
	end

	local styleSet = slot:CreateOrGetControlSet('itemslot_transcend_styleset', "styleset_transcend", 0, 0)
	styleSet:Resize(slot:GetWidth(), slot:GetHeight())

	local imgName = "itemslot_star_icon_" .. transcendLv
	local starIcon = GET_CHILD_RECURSIVELY(styleSet, "starIcon")
	if starIcon == nil then
		return
	end

	starIcon:SetImage(imgName)
	
end

function SET_SLOT_BG_BY_ITEMGRADE(slot, itemgrade)
	local skinName = "invenslot_nomal"
	if slot == nil then
		return
	end
	if itemgrade == nil or itemgrade == 0 or itemgrade == 1 or itemgrade == "None" then
		slot:SetSkinName(skinName)
		return
	end
		
	if itemgrade == 2 then
		skinName = "invenslot_magic"
	elseif itemgrade == 3 then
		skinName = "invenslot_rare"
	elseif itemgrade == 4 then
		skinName = "invenslot_unique"
	elseif itemgrade == 5 then
		skinName = "invenslot_legend"
	end

	slot:SetSkinName(skinName)
	
end

function SET_SLOT_NEED_APPRAISAL(slot, needAppraisal, needRandomOption)
	if slot == nil then
		return
	end

	DESTROY_CHILD_BYNAME(slot, "styleset_appraisal")

	if needAppraisal == nil and needRandomOption == nil then
		return
	end

	local icon = slot:GetIcon()
	if icon == nil then
		return
	end

	if needAppraisal == 1 or needRandomOption == 1 then
		local styleSet = slot:CreateOrGetControlSet('itemslot_appraisal_styleset', "styleset_appraisal", 0, 0)
		styleSet:Resize(slot:GetWidth(), slot:GetHeight())
		icon:SetColorTone("FFFF0000")
		local temp = GET_CHILD_RECURSIVELY(slot, "styleset_appraisal")
	else
		DESTROY_CHILD_BYNAME(slot, "styleset_appraisal")
	end
end

function SET_SLOT_REINFORCE_LEVEL(slot, reinforceLv)
	if slot == nil then
		return
	end

	DESTROY_CHILD_BYNAME(slot, "styleset_reinforce")

	if reinforceLv == nil or reinforceLv == 0 then
		return
	end

	local icon = slot:GetIcon()
	if icon == nil then
		return
	end

	local styleSet = slot:CreateOrGetControlSet('itemslot_reinforce_styleset', "styleset_reinforce", 0, 0)
	styleSet:Resize(slot:GetWidth(), slot:GetHeight())
	local levelText = GET_CHILD_RECURSIVELY(styleSet, "levelText")
	if levelText == nil then
		return
	end

	levelText:SetTextByKey("level", reinforceLv)
end

function SET_SLOT_DURATION(slot, itemCls)
	if itemCls.Dur == 0 then
		local icon = slot:GetIcon()
		if icon == nil then
			return
		end

		icon : SetColorTone("FFFF0000")
	end
end

function SET_SLOT_ITEM_TEXT(slot, invItem, obj)
	if obj.MaxStack > 1 then
		SET_SLOT_COUNT_TEXT(slot, invItem.count);
		return;
	end

	local lv = TryGetProp(obj, "Level");
	if lv ~= nil and lv > 1 then		
		slot:SetFrontImage('enchantlevel_indi_icon');
		slot:SetText('{s20}{ol}{#FFFFFF}{b}'..lv, 'count', ui.LEFT, ui.TOP, 8, 2);
		return;
	end
end

function SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, count, font)

	local refreshScp = TryGetProp(obj,'RefreshScp')

	if refreshScp ~= "None" and refreshScp ~= nil and obj ~= nil then
		refreshScpfun = _G[refreshScp];
		refreshScpfun(obj);
	end	

	if obj.MaxStack > 1 then
		if count ~= nil then
			SET_SLOT_COUNT_TEXT(slot, count, font);
		else
			SET_SLOT_COUNT_TEXT(slot, invItem.count, font);
		end
		return;
	end

	local lv = TryGetProp(obj, "Level");
	if lv ~= nil and lv > 1 then
		--slot:SetFrontImage('enchantlevel_indi_icon');
		if IS_ENCHANT_JEWELL_ITEM(obj) == true then
			slot:SetText('{s15}{ol}{#FFFFFF}{b}LV.'..lv, 'count', ui.LEFT, ui.BOTTOM, 3, 2);
		else
			slot:SetText('{s17}{ol}{#FFFFFF}{b}LV. '..lv, 'count', ui.LEFT, ui.TOP, 3, 2);
		end
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

function GET_SLOT_ITEM_TYPE(slot)
	local icon = slot:GetIcon();
	if icon == nil then
		return 0;		
	end
	local iconinfo = icon:GetInfo();
	if iconinfo == nil then
		return 0;
	end
	return iconinfo.type;
end