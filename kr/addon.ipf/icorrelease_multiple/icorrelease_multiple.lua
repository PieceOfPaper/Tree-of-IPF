
function ICORRELEASE_MULTIPLE_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ICORRELEASE_MULTIPLE", "ON_OPEN_DLG_ICORRELEASE_MULTIPLE")

	--성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ICOR_RELEASE_MULTIPLE", "SUCCESS_ICOR_RELEASE_MULTIPLE")

	addon:RegisterMsg("UPDATE_COLONY_TAX_RATE_SET", "ON_ICORRELEASE_MULTIPLE_UPDATE_COLONY_TAX_RATE_SET")
end

function ON_OPEN_DLG_ICORRELEASE_MULTIPLE(frame)
	frame:ShowWindow(1)
end

function ON_ICORRELEASE_MULTIPLE_UPDATE_COLONY_TAX_RATE_SET(frame)
	local costStaticText = GET_CHILD_RECURSIVELY(frame, 'costStaticText')
	SET_COLONY_TAX_RATE_TEXT(costStaticText, "tax_rate")
	CLEAR_ICORRELEASE_MULTIPLE()
end

function ICORRELEASE_MULTIPLE_OPEN(frame)
	ui.CloseFrame('rareoption')
	CLEAR_ICORRELEASE_MULTIPLE()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ICORRELEASE_MULTIPLE_INV_RBTN")
	ui.OpenFrame("inventory")
end

function ICORRELEASE_MULTIPLE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None")
	frame:ShowWindow(0)
	control.DialogOk()
	ui.CloseFrame("inventory")
end

function CLEAR_ICORRELEASE_CTRL(ctrlSet)
	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot", "ui::CSlot")
	slot:ClearIcon()
	slot:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT)
	slot:SetMargin(0, 0, 0, 0)

	local resultGbox = GET_CHILD_RECURSIVELY(ctrlSet, "resultGbox")
	resultGbox:ShowWindow(0)

	local slotGbox = GET_CHILD_RECURSIVELY(ctrlSet, "slotGbox")
	slotGbox:ShowWindow(1)
	
	local slot_bg_image = GET_CHILD_RECURSIVELY(ctrlSet, "slot_bg_image")
	slot_bg_image:ShowWindow(1)	

	local arrowbox = GET_CHILD_RECURSIVELY(ctrlSet, "arrowbox")
	arrowbox:ShowWindow(0)

	local slot_result = GET_CHILD_RECURSIVELY(ctrlSet, "slot_result")
	slot_result:ShowWindow(0)

	local optionGbox = GET_CHILD_RECURSIVELY(ctrlSet, 'optionGbox')
	optionGbox:ShowWindow(1)

	local optionGbox_1 = GET_CHILD_RECURSIVELY(ctrlSet, 'optionGbox_1')
	optionGbox_1:ShowWindow(1)
	optionGbox_1:RemoveAllChild()
	optionGbox_1:Resize(optionGbox:GetWidth(), optionGbox:GetHeight())
end

function CLEAR_ICORRELEASE_MULTIPLE()
	if ui.CheckHoldedUI() == true then
		return
	end

	local frame = ui.GetFrame("icorrelease_multiple")

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
		CLEAR_ICORRELEASE_CTRL(ctrlSet)
	end

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok")
	send_ok:ShowWindow(0)

	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release")
	do_release:ShowWindow(1)

	local costBox = GET_CHILD_RECURSIVELY(frame, 'costBox')
	local priceText = GET_CHILD_RECURSIVELY(costBox, 'priceText')
	priceText:SetTextByKey('price', GET_OPTION_RELEASE_COST())
	costBox:ShowWindow(1)
end

function _UPDATE_RELEASE_MULTIPLE_COST(frame)
	local totalPrice = 0

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)
		if invItem ~= nil then
			local invItemObj = GetIES(invItem:GetObject())
			local eachPrice = GET_OPTION_RELEASE_COST(invItemObj, GET_COLONY_TAX_RATE_CURRENT_MAP())

			totalPrice = totalPrice + eachPrice
		end
	end

	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText')
	priceText:SetTextByKey('price', GET_COMMAED_STRING(totalPrice))
end

function ICORRELEASE_CTRL_ITEM_DROP(slot, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return
	end

	local liftIcon = ui.GetLiftIcon()
	local FromFrame = liftIcon:GetTopParentFrame()
	local toFrame = slot:GetTopParentFrame()
	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	CLEAR_ICORRELEASE_CTRL(ctrlSet)
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo()
		ICORRELEASE_CTRL_REG_TARGETITEM(ctrlSet, iconInfo:GetIESID())
		_UPDATE_RELEASE_MULTIPLE_COST(toFrame)
	end
end

-- 고정옵션 아이커 장착해제 
function ICORRELEASE_CTRL_REG_TARGETITEM(ctrlSet, itemID)
	local frame = ctrlSet:GetTopParentFrame()

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

	local gBox = GET_CHILD_RECURSIVELY(ctrlSet, "optionGbox_1")
	gBox:RemoveChild('tooltip_equip_property_narrow')

	if ui.CheckHoldedUI() == true then
		return
	end

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return
	end

	local invItemObj = GetIES(invItem:GetObject())
	local itemCls = GetClassByType('Item', invItemObj.ClassID)
	
	if IS_ENABLE_RELEASE_OPTION(invItemObj) ~= true then
		-- 복원 대상인지 체크
		ui.SysMsg(ClMsg("IcorNotAdded"))
		return
	end
	
	local pc = GetMyPCObject()
	if pc == nil then
		return
	end

	local obj = GetIES(invItem:GetObject())

	local invframe = ui.GetFrame("inventory")
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"))
		return
	end

	local inheritItemName = TryGetProp(invItemObj, 'InheritanceItemName', 'None')
	local inheritItemCls = nil
	if inheritItemName ~= 'None' then
		inheritItemCls = GetClass('Item', inheritItemName)
	end

    if inheritItemCls == nil then    
        ui.SysMsg(ClMsg("IcorNotAdded"))
        return
    end

	local yPos = 0
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(inheritItemCls)
    local list = {}
    local basicTooltipPropList = StringSplit(inheritItemCls.BasicTooltipProp, ';')
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i]
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list)
    end

	local list2 = GET_EUQIPITEM_PROP_LIST()
	
	local cnt = 0
	for i = 1 , #list do
		local propName = list[i]
		local propValue = TryGetProp(inheritItemCls, propName, 0)
		
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
		local propValue = TryGetProp(inheritItemCls, propName, 0)
		
		if propValue ~= 0 then
			cnt = cnt + 1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i
		local propValue = "HatPropValue_"..i
		if inheritItemCls[propValue] ~= 0 and inheritItemCls[propName] ~= "None" then
			cnt = cnt + 1
		end
	end

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property_narrow', 'tooltip_equip_property_narrow', 0, yPos)
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline")
	labelline:ShowWindow(0)
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	local inner_yPos = 0

	local randomOptionProp = {}

	for i = 1 , #list do
		local propName = list[i]
		local propValue = TryGetProp(inheritItemCls, propName, 0)
		local needToShow = true
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false
			end
		end

		if needToShow == true and propValue ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음
			if  inheritItemCls.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
					inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
				end
			elseif  inheritItemCls.GroupName == 'Armor' then
				if inheritItemCls.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
						inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
					end
				elseif inheritItemCls.ClassType == 'Boots' then
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
		if invItemObj[propValue] ~= 0 and invItemObj[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(invItemObj[propName]))
			local strInfo = ABILITY_DESC_PLUS(opName, invItemObj[propValue])
			inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i]
		local propValue = TryGetProp(invItemObj, propName, 0)
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue)
			inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo, 0, inner_yPos)
		end
	end

	if inheritItemCls.OptDesc ~= nil and inheritItemCls.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, inheritItemCls.OptDesc, 0, inner_yPos)
	end

	if invItemObj.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption")
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * invItemObj.ReinforceRatio/100))
		inner_yPos = ADD_ITEM_PROPERTY_TEXT_NARROW(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos)
	end

	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 40)

	gBox:Resize(gBox:GetWidth(), tooltip_equip_property_CSet:GetHeight())

	local slot_bg_image = GET_CHILD_RECURSIVELY(ctrlSet, "slot_bg_image")
	slot_bg_image:ShowWindow(0)

	local arrowbox = GET_CHILD_RECURSIVELY(ctrlSet, "arrowbox")
	arrowbox:ShowWindow(1)

	local slot_result = GET_CHILD_RECURSIVELY(ctrlSet, "slot_result")
	slot_result:ShowWindow(1)

	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
	local SLOT_MARGIN_LEFT = frame:GetUserConfig("SLOT_MARGIN_LEFT")
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT)
	slot:SetMargin(SLOT_MARGIN_LEFT, 0, 0, 0)
	local slot_result = GET_CHILD_RECURSIVELY(ctrlSet, "slot_result")
	local icor_img = nil
	if itemCls.GroupName == "Weapon" or itemCls.GroupName == "SubWeapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON")
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR")
	end

	SET_SLOT_IMG(slot_result, icor_img)
	ctrlSet:SetUserValue("icor_img", icor_img)
	SET_SLOT_ITEM(slot, invItem)
end

function ICORRELEASE_MULTIPLE_EXEC(frame)
	frame = frame:GetTopParentFrame()
	local invframe = ui.GetFrame("inventory")

	local totalPrice = 0
	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)
		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)
		if invItem ~= nil then
			if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
				ui.SysMsg(ClMsg("MaterialItemIsLock"))
				return
			end
			
			local invItemObj = GetIES(invItem:GetObject())
			local eachPrice = GET_OPTION_RELEASE_COST(invItemObj, GET_COLONY_TAX_RATE_CURRENT_MAP())

			totalPrice = totalPrice + eachPrice
		end
	end

	local pcMoney = GET_TOTAL_MONEY_STR()
	if IsGreaterThanForBigNumber(totalPrice, pcMoney) == 1 then
        ui.SysMsg(ClMsg('NotEnoughMoney'))
        return
    end

	local clmsg = ScpArgMsg("ReallyRollbackIcor")
	WARNINGMSGBOX_FRAME_OPEN(clmsg, "_ICORRELEASE_MULTIPLE_EXEC", "_ICORRELEASE_MULTIPLE_CANCEL")
end

function _ICORRELEASE_MULTIPLE_CANCEL()
	local frame = ui.GetFrame("icorrelease_multiple")
end

function _ICORRELEASE_MULTIPLE_EXEC(checkRebuildFlag)
	local frame = ui.GetFrame("icorrelease_multiple")
	if frame:IsVisible() == 0 then
		return
	end

	local rebuild_flag = false

	session.ResetItemList()

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)
		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)
		if invItem ~= nil then
			local invItemObj = GetIES(invItem:GetObject())

			if checkRebuildFlag ~= false then
				if TryGetProp(invItemObj, 'Rebuildchangeitem', 0) > 0 then
					rebuild_flag = true
				end
			end
			
			session.AddItemID(invItem:GetIESID(), 1)
		end
	end
	
	if rebuild_flag == true then
		ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ICORRELEASE_MULTIPLE_EXEC(false)', 'None')
		return
	end

	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release")
	do_release:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local resultlist = session.GetItemIDList()
    item.DialogTransaction("RELEASE_ITEM_ICOR_MULTIPLE", resultlist)
end

function SUCCESS_ICOR_RELEASE_MULTIPLE(frame)
	local frame = ui.GetFrame("icorrelease_multiple")
	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release")
	do_release:ShowWindow(0)

	ReserveScript("_SUCCESS_ICOR_RELEASE_MULTIPLE()", 0.01)
end

function _SUCCESS_ICOR_RELEASE_MULTIPLE()
	local frame = ui.GetFrame("icorrelease_multiple")
	if frame:IsVisible() == 0 then
		return
	end

	local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
	for i = 1, max_count do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "ctrlset_" .. i)
		local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
		local invItem = GET_SLOT_ITEM(slot)
		if invItem ~= nil then
			local slotGbox = GET_CHILD_RECURSIVELY(ctrlSet, 'slotGbox')
			slotGbox:ShowWindow(0)
	
			local resultGbox = GET_CHILD_RECURSIVELY(ctrlSet, 'resultGbox')
			resultGbox:ShowWindow(1)
			local result_effect_bg = GET_CHILD_RECURSIVELY(ctrlSet, 'result_effect_bg')
			local image_success = GET_CHILD_RECURSIVELY(ctrlSet, 'yellow_skin_success')
			local text_success = GET_CHILD_RECURSIVELY(ctrlSet, 'text_success')
			result_effect_bg:ShowWindow(1)
			image_success:ShowWindow(1)
			text_success:ShowWindow(1)
	
			local resultItemImg = GET_CHILD_RECURSIVELY(ctrlSet, "result_item_img")
			resultItemImg:ShowWindow(1)
			
			local icor_img = ctrlSet:GetUserValue("icor_img")
			resultItemImg:SetImage(icor_img)
		end
	end

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)
end

function REMOVE_ICORRELEASE_CTRL_TARGETITEM(slot)
	if ui.CheckHoldedUI() == true then
		return
	end

	local slotGbox = slot:GetParent()
	local ctrlSet = slotGbox:GetParent()
	local frame = ctrlSet:GetTopParentFrame()

	CLEAR_ICORRELEASE_CTRL(ctrlSet)
	_UPDATE_RELEASE_MULTIPLE_COST(frame)
end

function ICORRELEASE_MULTIPLE_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("icorrelease_multiple")
	if frame == nil then
		return
	end

	local icon = slot:GetIcon()
	local iconInfo = icon:GetInfo()
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID())
	if invItem ~= nil then
		local max_count = GET_ICOR_MULTIPLE_MAX_COUNT()
		for i = 1, max_count do
			local ctrlSet = GET_CHILD_RECURSIVELY(frame, 'ctrlset_' .. i)
			local tempSlot = GET_CHILD_RECURSIVELY(ctrlSet, "slot")
	
			local slotSetItem = GET_SLOT_ITEM(tempSlot)
			if slotSetItem == nil then
				CLEAR_ICORRELEASE_CTRL(ctrlSet)
				ICORRELEASE_CTRL_REG_TARGETITEM(ctrlSet, iconInfo:GetIESID())
				_UPDATE_RELEASE_MULTIPLE_COST(frame)
				
				break
			end
		end
	end
end
