function ICORADD_MULTIPLE_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ICORADD_MULTIPLE", "ON_OPEN_DLG_ICORADD_MULTIPLE")

	-- 성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ICOR_ADD_MULTIPLE", "SUCCESS_ICOR_ADD_MULTIPLE")
end

function ON_OPEN_DLG_ICORADD_MULTIPLE(frame, msg, argStr, argNum)
	frame:ShowWindow(1)
end

function ICORADD_MULTIPLE_OPEN(frame)
	ui.CloseFrame('rareoption')
	CLEAR_ICORADD_MULTIPLE()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ICORADD_MULTIPLE_INV_RBTN")
	ui.OpenFrame("inventory")
end

function ICORADD_MULTIPLE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None")
	frame:ShowWindow(0)
	control.DialogOk()
	ui.CloseFrame("inventory")
end

function CLEAR_ICORADD_CTRL(ctrlSet)
	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot", "ui::CSlot")
	slot:ClearIcon()
	slot:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT)
	slot:SetMargin(0, 0, 0, 0)

	local text_beforeadd = GET_CHILD_RECURSIVELY(ctrlSet, "text_beforeadd")
	text_beforeadd:ShowWindow(1)
	local text_afteradd = GET_CHILD_RECURSIVELY(ctrlSet, "text_afteradd")
	text_afteradd:ShowWindow(0)

	local resultGbox = GET_CHILD_RECURSIVELY(ctrlSet, "resultGbox")
	resultGbox:ShowWindow(0)

	local slotGbox = GET_CHILD_RECURSIVELY(ctrlSet, "slotGbox")
	slotGbox:ShowWindow(1)

	local slot_bg_image = GET_CHILD_RECURSIVELY(ctrlSet, "slot_bg_image")
	slot_bg_image:ShowWindow(1)

	local arrowbox = GET_CHILD_RECURSIVELY(ctrlSet, "arrowbox")
	arrowbox:ShowWindow(0)

	local slot_add = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
	slot_add:ClearIcon()
	slot_add:ShowWindow(0)

	local optionGbox = GET_CHILD_RECURSIVELY(ctrlSet, 'optionGbox')
	local optionGbox_1 = GET_CHILD_RECURSIVELY(ctrlSet, 'optionGbox_1')
	optionGbox_1:RemoveAllChild()
	optionGbox_1:Resize(optionGbox:GetWidth(), optionGbox:GetHeight())
end

function CLEAR_ICORADD_MULTIPLE()
	if ui.CheckHoldedUI() == true then
		return
	end
	
	local frame = ui.GetFrame("icoradd_multiple")

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(0)
	
	local do_add = GET_CHILD_RECURSIVELY(frame, "do_add")
	do_add:ShowWindow(1)

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)
		CLEAR_ICORADD_CTRL(ctrlSet)
	end
end

function ICORADD_CTRL_MAIN_ITEM_DROP(slot, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return
	end

	local liftIcon = ui.GetLiftIcon()
	local FromFrame = liftIcon:GetTopParentFrame()
	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	CLEAR_ICORADD_CTRL(ctrlSet)
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo()
		ICORADD_CTRL_REG_MAIN_ITEM(ctrlSet, iconInfo:GetIESID())
	end
end

function ICORADD_CTRL_ADD_ITEM_DROP(slot, icon, argStr, argNum)    
	if ui.CheckHoldedUI() == true then
		return
	end

	local liftIcon = ui.GetLiftIcon()
	local FromFrame = liftIcon:GetTopParentFrame()
	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo()
		ICORADD_CTRL_REG_ADD_ITEM(ctrlSet, iconInfo:GetIESID())
	end
end

function ICORADD_CTRL_REG_MAIN_ITEM(ctrlSet, itemID)
	local frame = ctrlSet:GetTopParentFrame()

	local gBox = GET_CHILD_RECURSIVELY(ctrlSet, "optionGbox_1")
	gBox:RemoveChild('tooltip_equip_property_narrow')

	if ui.CheckHoldedUI() == true then
		return
	end

	local pc = GetMyPCObject()
	if pc == nil then
		return
	end
	
	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return
	end

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local temp = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
		local tempSlot = GET_CHILD_RECURSIVELY(temp, 'slot')
		local tempItem = GET_SLOT_ITEM(tempSlot)
		if tempItem ~= nil then
			if itemID == tempItem:GetIESID() then
				ui.SysMsg(ClMsg("AlreadRegSameItem"))
				return
			end
		end
	end
	
	local itemObj = GetIES(invItem:GetObject())
	local itemCls = GetClassByType('Item', itemObj.ClassID)
	if TryGetProp(itemCls, 'NeedRandomOption', 0) == 1 and TryGetProp(itemCls, 'LegendGroup', 'None') == 'None' then
	    ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"))
        return
	end
		
	local invframe = ui.GetFrame("inventory")
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"))
		return
	end

	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
	local slotInvItem = GET_SLOT_ITEM(slot)
	if slotInvItem == nil then
		-- invitem 이 slot 들어갈 템이 아니면 에러후 리턴
		if TryGetProp(itemObj, 'LegendGroup', 'None') == 'None' then
			--장착 안대는 아이템
			ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"))
			return
		end

		SET_SLOT_ITEM(slot, invItem)
	end

	local SLOT_MARGIN_LEFT = frame:GetUserConfig("SLOT_MARGIN_LEFT")
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT)
	slot:SetMargin(SLOT_MARGIN_LEFT, 0, 0, 0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(ctrlSet, "slot_bg_image")
	slot_bg_image:ShowWindow(0)

	local arrowbox = GET_CHILD_RECURSIVELY(ctrlSet, "arrowbox")
	arrowbox:ShowWindow(1)

	local slot_add = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
	slot_add:ShowWindow(1)

	local icor_img = nil
	if itemCls.GroupName == "Weapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON")
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR")
	end
end

function ICORADD_CTRL_REG_ADD_ITEM(ctrlSet, itemID)
	if ui.CheckHoldedUI() == true then
		return
	end

	local frame = ctrlSet:GetTopParentFrame()

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local temp = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
		local tempSlot = GET_CHILD_RECURSIVELY(temp, 'slot_add')
		local tempItem = GET_SLOT_ITEM(tempSlot)
		if tempItem ~= nil then
			if itemID == tempItem:GetIESID() then
				ui.SysMsg(ClMsg("AlreadRegSameItem"))
				return
			end
		end
	end

	local gBox = GET_CHILD_RECURSIVELY(ctrlSet, "optionGbox_1")
	gBox:RemoveChild('tooltip_equip_property_narrow')

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return
	end

	local itemObj = GetIES(invItem:GetObject())
	local itemCls = GetClassByType('Item', itemObj.ClassID)

	local pc = GetMyPCObject()
	if pc == nil then
		return
	end

	-- invItem 이 아이커가 아니면 에러 후 리턴 if invItem
	if TryGetProp(itemObj, 'GroupName') ~= 'Icor' then
		ui.SysMsg(ClMsg("MustEquipIcor"))
		return
	end

	local invframe = ui.GetFrame("inventory")
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"))
		return
	end
	
	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
	local slotInvItem = GET_SLOT_ITEM(slot)
	local slotInvItemCls = nil
	if slotInvItem ~= nil then
		local tempItem = GetIES(slotInvItem:GetObject())
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
	end
    
	--아이커의 atk 과 slot 의 atk 이 맞아야만 장착가능
	local targetItem = GetClass('Item', itemObj.InheritanceItemName)
    if targetItem == nil then
        targetItem = GetClass('Item', itemObj.InheritanceRandomItemName)
    end
        
	if targetItem.ClassType ~= slotInvItemCls.ClassType or (IS_ICORABLE_RANDOM_LEGEND_ITEM(slotInvItemCls) and itemObj.InheritanceRandomItemName ~= 'None') then
		ui.SysMsg(ClMsg('NotMatchItemClassType')) -- atk 타입이 안맞아서 리턴
		return
	end
	
	local yPos = 0
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(targetItem)
    local list = {}
    local basicTooltipPropList = StringSplit(targetItem.BasicTooltipProp, ';')
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i]
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list)
    end

	local list2 = GET_EUQIPITEM_PROP_LIST()
	
	local cnt = 0
	for i = 1 , #list do
		local propName = list[i]
		local propValue = TryGetProp(targetItem, propName, 0)
		
		if propValue ~= 0 then
            local checkPropName = propName
            if propName == 'MINATK' or propName == 'MAXATK' then
                checkPropName = 'ATK'
            end
            if EXIST_ITEM(basicTooltipPropList, checkPropName) == false then
                cnt = cnt + 1
            end
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i]
		local propValue = TryGetProp(targetItem, propName, 0)
		if propValue ~= 0 then
			cnt = cnt + 1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i
		local propValue = "HatPropValue_"..i
		if targetItem[propValue] ~= 0 and targetItem[propName] ~= "None" then
			cnt = cnt + 1
		end
	end

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property_narrow', 'tooltip_equip_property_narrow', 0, yPos)
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline")
	labelline:ShowWindow(0)
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	local class = GetClassByType("Item", targetItem.ClassID)

	local inner_yPos = 0
	
	local maxRandomOptionCnt = 6
	local randomOptionProp = {}
	for i = 1, maxRandomOptionCnt do
		if targetItem['RandomOption_'..i] ~= 'None' then
			randomOptionProp[targetItem['RandomOption_'..i]] = targetItem['RandomOptionValue_'..i]
		end
	end

	for i = 1 , #list do
		local propName = list[i]
		local propValue = TryGetProp(targetItem, propName, 0)
		local needToShow = true
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false
			end
		end

		if needToShow == true and propValue ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음
			if  targetItem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
					inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
				end
			elseif  targetItem.GroupName == 'Armor' then
				if targetItem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
						inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
					end
				elseif targetItem.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
						inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
					end
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
						inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
					end
				end
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
				inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
			end
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i
		local propValue = "HatPropValue_"..i
		if targetItem[propValue] ~= 0 and targetItem[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(targetItem[propName]))
			local strInfo = ABILITY_DESC_PLUS(opName, targetItem[propValue])
			inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
		end
	end
	
	for i = 1 , maxRandomOptionCnt do
	    local propGroupName = "RandomOptionGroup_"..i
		local propName = "RandomOption_"..i
		local propValue = "RandomOptionValue_"..i
		local clientMessage = 'None'
		
		if itemObj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif itemObj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif itemObj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif itemObj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif itemObj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif itemObj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if itemObj[propValue] ~= 0 and itemObj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(itemObj[propName]))
			local strInfo = ABILITY_DESC_NO_PLUS(opName, itemObj[propValue], 0)

			inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i]
		local propValue = TryGetProp(targetItem, propName, 0)
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), targetItem[propName])
			inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
		end
	end

	if targetItem.OptDesc ~= nil and targetItem.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, targetItem.OptDesc, 0, inner_yPos)
	end

	if targetItem.IsAwaken == 1 then
		local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(targetItem.HiddenProp))
		local strInfo = ABILITY_DESC_PLUS(opName, targetItem.HiddenPropValue)
		inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
	end

	if targetItem.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption")
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * targetItem.ReinforceRatio/100))
		inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos)
	end

	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 40)

	gBox:Resize(gBox:GetWidth(), tooltip_equip_property_CSet:GetHeight())

	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
	SET_SLOT_ITEM(slot, invItem)
end

function ICORADD_MULTIPLE_EXEC(frame)
	frame = frame:GetTopParentFrame()
	local invframe = ui.GetFrame('inventory')
	
	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)

		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)

		local slot_add = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
		local invItem_add = GET_SLOT_ITEM(slot_add)

		if invItem ~= nil then
			if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
				ui.SysMsg(ClMsg("MaterialItemIsLock"))
				return
			end

			if invItem_add == nil then
				-- 메인 아이템만 등록하고 아이커 아이템 안올려놨다면 리턴
				ui.SysMsg(ClMsg("MustAddIcorToSlot"))
				return
			else
				if invItem_add.isLockState or true == IS_TEMP_LOCK(invframe, invItem_add) then
					ui.SysMsg(ClMsg("MaterialItemIsLock"))
					return
				end

				local obj = GetIES(invItem:GetObject())
				local obj_add = GetIES(invItem_add:GetObject())
				if (TryGetProp(obj, 'InheritanceItemName', 'None') ~= 'None' and TryGetProp(obj_add, 'InheritanceItemName', 'None') ~= 'None')
				or TryGetProp(obj, 'InheritanceRandomItemName', 'None') ~= 'None' and TryGetProp(obj_add, 'InheritanceRandomItemName', 'None') ~= 'None' then
					ui.SysMsg(ClMsg("AlearyIcorAdded"))
					return
				end
			end
		end
	end
	
	local clmsg = ScpArgMsg("DoItemOptionAdd")
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ICORADD_MULTIPLE_EXEC", "_ICORADD_MULTIPLE_CANCEL")
end

function _ICORADD_MULTIPLE_CANCEL()
	local frame = ui.GetFrame("icoradd_multiple")
end

function _ICORADD_MULTIPLE_EXEC(checkRebuildFlag)
	local frame = ui.GetFrame("icoradd_multiple")
	if frame:IsVisible() == 0 then
		return
	end

	local rebuild_flag = false

	session.ResetItemList()

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)

		local mainSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local mainInvItem = GET_SLOT_ITEM(mainSlot)

		if mainInvItem ~= nil then
			if checkRebuildFlag ~= false then
				local targetItemObj = GetIES(mainInvItem:GetObject())
				if TryGetProp(targetItemObj, 'Rebuildchangeitem', 0) > 0 then
					rebuild_flag = true
				end
			end
		
			local text_beforeadd = GET_CHILD_RECURSIVELY(ctrlSet, "text_beforeadd")
			text_beforeadd:ShowWindow(0)
			local text_afteradd = GET_CHILD_RECURSIVELY(ctrlSet, "text_afteradd")
			text_afteradd:ShowWindow(1)

			local addSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
			local addInvItem = GET_SLOT_ITEM(addSlot)
			if addInvItem == nil then
				return
			end
	
			session.AddItemID(mainInvItem:GetIESID(), 1)
			session.AddItemID(addInvItem:GetIESID(), 1)
		end
	end

	if rebuild_flag == true then
		ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ICORADD_EXEC(false)', 'None')
		return
	end

	local doAdd = GET_CHILD_RECURSIVELY(frame, "do_add")
	doAdd:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)
	
    local resultlist = session.GetItemIDList()
    item.DialogTransaction("EQUIP_ITEM_ICOR_MULTIPLE", resultlist)
end

function SUCCESS_ICOR_ADD_MULTIPLE(frame)
	local do_add = GET_CHILD_RECURSIVELY(frame, "do_add")
	do_add:ShowWindow(0)

	ReserveScript("_SUCCESS_ICOR_ADD_MULTIPLE()", 0.01)
end

function _SUCCESS_ICOR_ADD_MULTIPLE()
	local frame = ui.GetFrame("icoradd_multiple")
	if frame:IsVisible() == 0 then
		return
	end

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)
		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)
		if invItem ~= nil then
			local slotGbox = GET_CHILD_RECURSIVELY(ctrlSet, "slotGbox")
			slotGbox:ShowWindow(0)

			local item = GetIES(invItem:GetObject())
			local text_beforeadd = GET_CHILD_RECURSIVELY(ctrlSet, "text_beforeadd")
			text_beforeadd:ShowWindow(0)
			local text_afteradd = GET_CHILD_RECURSIVELY(ctrlSet, "text_afteradd")
			text_afteradd:ShowWindow(1)

			local resultGbox = GET_CHILD_RECURSIVELY(ctrlSet, "resultGbox")
			resultGbox:ShowWindow(1)
	
			local invItemGUID = invItem:GetIESID()
			local resetInvItem = session.GetInvItemByGuid(invItemGUID)
			local obj = GetIES(resetInvItem:GetObject())
	
			local refreshScp = obj.RefreshScp
			if refreshScp ~= "None" then
				refreshScp = _G[refreshScp]
				refreshScp(obj)
			end

			local resultItemImg = GET_CHILD_RECURSIVELY(ctrlSet, "result_item_img")
			resultItemImg:ShowWindow(1)
			resultItemImg:SetImage(item.Icon)
		end
	end
	
	local doAdd = GET_CHILD_RECURSIVELY(frame, "do_add")
	doAdd:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)
end

function REMOVE_ICORADD_CTRL_MAIN_ITEM(slot)
	if ui.CheckHoldedUI() == true then
		return
	end

	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
	slot:ClearIcon()
	CLEAR_ICORADD_CTRL(ctrlSet)
end

function REMOVE_ICORADD_CTRL_ADD_ITEM(slot)
	if ui.CheckHoldedUI() == true then
		return
	end

	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
	slot:ClearIcon()

	local gBox = GET_CHILD_RECURSIVELY(ctrlSet, "optionGbox_1")
	gBox:RemoveChild('tooltip_equip_property_narrow')
end

function ICORADD_MULTIPLE_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("icoradd_multiple")
	if frame == nil then
		return
	end
	
	local itemCls = GetClass('Item', TryGetProp(itemObj, 'ClassName', 'None'))
	if TryGetProp(itemCls, 'NeedRandomOption', 0) == 1 and TryGetProp(itemCls, 'LegendGroup', 'None') == 'None' then    
	    ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"))
        return
	end

	local icon = slot:GetIcon()
	local iconInfo = icon:GetInfo()
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID())
	local obj = GetIES(invItem:GetObject())

	local isIcor = (TryGetProp(itemObj, 'GroupName', 'None') == 'Icor')
	local inheritItemName = 'None'
	if isIcor == true then
		local inheritanceItemName = TryGetProp(itemObj, 'InheritanceItemName', 'None')
		local inheritanceRandomItemName = TryGetProp(itemObj, 'InheritanceRandomItemName', 'None')
		if inheritanceItemName ~= 'None' then
			inheritItemName = inheritanceItemName
		elseif inheritanceRandomItemName ~= 'None' then
			inheritItemName = inheritanceRandomItemName
		end

		if inheritItemName == 'None' then
			return
		end
	end

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
		local tempSlot = nil
		if isIcor == true then
			tempSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot_add")
		else
			tempSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		end

		local slotSetItem = GET_SLOT_ITEM(tempSlot)
		if slotSetItem == nil then
			if isIcor == true then
				local mainSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
				local mainItem = GET_SLOT_ITEM(mainSlot)
				if mainItem ~= nil then
					local mainObj = GetIES(mainItem:GetObject())
					local inheritItem = GetClass('Item', inheritItemName)
					if inheritItem ~= nil and mainObj.ClassType == inheritItem.ClassType then
						ICORADD_CTRL_REG_ADD_ITEM(ctrlSet, iconInfo:GetIESID())

						break
					end
				end
			else
				-- invitem 이 slot 들어갈 템이 아니면 에러후 리턴
				if TryGetProp(obj, 'LegendGroup', 'None') == 'None' then
					--장착 안대는 아이템
					ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"))
					return
				end
			
				CLEAR_ICORADD_CTRL(ctrlSet)

				ICORADD_CTRL_REG_MAIN_ITEM(ctrlSet, iconInfo:GetIESID())
				
				break
			end
		end
	end
end

function ADD_ITEM_PROPERTY_TEXT_NARROW(GroupCtrl, txt, xmargin, yPos )
	if GroupCtrl == nil then
		return 0
	end

	local cnt = GroupCtrl:GetChildCount()
	local ControlSetObj	= GroupCtrl:CreateControlSet('tooltip_item_prop_richtxt_narrow', "ITEM_PROP_" .. cnt , 0, yPos)
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet')
	local richText = GET_CHILD(ControlSetCtrl, "text", "ui::CRichText")
	richText:SetTextByKey('text', txt)
	ControlSetCtrl:Resize(ControlSetCtrl:GetWidth(), richText:GetHeight())
	GroupCtrl:ShowWindow(1)

	GroupCtrl:Resize(GroupCtrl:GetWidth(),GroupCtrl:GetHeight() + ControlSetObj:GetHeight())
	
	return ControlSetCtrl:GetHeight() + ControlSetCtrl:GetY()
end