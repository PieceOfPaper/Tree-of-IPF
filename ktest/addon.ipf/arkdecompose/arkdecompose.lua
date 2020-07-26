function ARKDECOMPOSE_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_ARKDECOMPOSE', 'ON_OPEN_DLG_ARKDECOMPOSE')
	addon:RegisterMsg('RESULT_ARK_DECOMPOSE', 'ON_RESULT_ARK_DECOMPOSE')
end

function ON_OPEN_DLG_ARKDECOMPOSE(frame, msg, argStr, argNum)
	frame:ShowWindow(1)
end

function ARKDECOMPOSE_OPEN(frame)
	ui.OpenFrame('inventory')
	CLEAR_ARKDECOMPOSE()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ARKDECOMPOSE_INV_RBTN")
end

function ARKDECOMPOSE_CLOSE(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None")
	control.DialogOk()
	ui.CloseFrame('inventory')
end

function CLEAR_ARKDECOMPOSE()
	local frame = ui.GetFrame('arkdecompose')

	for i = 1, 2 do
		local slot_result = GET_CHILD_RECURSIVELY(frame, 'result' .. i)
		slot_result:ClearIcon()
		slot_result:ShowWindow(0)

		local text_result = GET_CHILD_RECURSIVELY(frame, 'text_result' .. i)
		text_result:SetText('')
	end

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot', 'ui::CSlot')
	slot:ClearIcon()

	local item_name = GET_CHILD_RECURSIVELY(frame, 'text_itemname')
	item_name:SetText('')
	
	local txt_complete = GET_CHILD_RECURSIVELY(frame, 'text_complete')
	txt_complete:ShowWindow(0)

	local txt_puton = GET_CHILD_RECURSIVELY(frame, 'text_putonitem')
	txt_puton:ShowWindow(1)

	local okbutton = GET_CHILD_RECURSIVELY(frame, 'okbutton')
	okbutton:ShowWindow(0)

	local execbutton = GET_CHILD_RECURSIVELY(frame, 'execbutton')
	execbutton:ShowWindow(1)
end

function ARKDECOMPOSE_DROP_TARGET(parent, ctrl)
	local liftIcon = ui.GetLiftIcon()
	local fromFrame = liftIcon:GetTopParentFrame()
	if fromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo()
		local frame = parent:GetTopParentFrame()
		ARKDECOMPOSE_SET_TARGET(frame, iconInfo:GetIESID())
	end
end

function ARKDECOMPOSE_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame('arkdecompose')

	local icon = slot:GetIcon()
	local iconInfo = icon:GetInfo()
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID())
	if invItem == nil then
		return
	end
	
	ARKDECOMPOSE_SET_TARGET(frame, iconInfo:GetIESID())
end

function ARKDECOMPOSE_SET_TARGET(frame, itemGuid)
	local invItem = session.GetInvItemByGuid(itemGuid)
	if invItem == nil then
		return
	end

	if invItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'))
		return
	end

	local itemObj = GetIES(invItem:GetObject())
	if TryGetProp(itemObj, 'ClassType', 'None') ~= 'Ark' then
        return
	end

	local decomposeAble = TryGetProp(itemObj, 'DecomposeAble')
    if decomposeAble == nil or decomposeAble == "NO" then
        ui.SysMsg(ClMsg('decomposeCant'))
        return
	end
	
	local target_lv = TryGetProp(itemObj, 'ArkLevel', 1)
	local target_exp = TryGetProp(itemObj, 'ArkExp', 0)
	if target_lv > 1 or target_exp > 0 then
		ui.SysMsg(ClMsg('DecomposeArkCant'))
		return
	end

	CLEAR_ARKDECOMPOSE()
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot")
	SET_SLOT_ITEM(slot, invItem)

	local txt_puton = GET_CHILD_RECURSIVELY(frame, 'text_putonitem')
	txt_puton:ShowWindow(0)
	
	local item_name = GET_CHILD_RECURSIVELY(frame, 'text_itemname')
	item_name:SetText(dic.getTranslatedStr(TryGetProp(itemObj, 'Name', 'None')))

	frame:SetUserValue('TARGET_ITEM_GUID', itemGuid)
end

function ARKDECOMPOSE_EXECUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame()
	local targetGuid = frame:GetUserValue('TARGET_ITEM_GUID')
	if targetGuid == "None" then
		return
	end
	
	local targetItem = session.GetInvItemByGuid(targetGuid)
	if targetItem == nil then
		return
	end
    
	if targetItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'))
		return
	end
	
	local targetObj = GetIES(targetItem:GetObject())
	local decomposeAble = TryGetProp(targetObj, 'DecomposeAble')
    if decomposeAble == nil or decomposeAble == "NO" then
        ui.SysMsg(ClMsg('decomposeCant'))
        return
	end

	local target_lv = TryGetProp(targetObj, 'ArkLevel', 1)
	local target_exp = TryGetProp(targetObj, 'ArkExp', 0)
	if target_lv > 2 or target_exp > 0 then
		ui.SysMsg(ClMsg('DecomposeArkCant'))
		return
	end

	local yesScp = string.format('_ARKDECOMPOSE_EXECUTE("%s")', targetGuid)
	ui.MsgBox(ScpArgMsg('ReallyDecomposeArk'), yesScp, 'None')
end

function _ARKDECOMPOSE_EXECUTE(targetGuid)
	local frame = ui.GetFrame('arkdecompose')
	local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID')
	if itemGuid == 'None' then
		return
	end
	
    pc.ReqExecuteTx_Item("ITEM_ARK_DECOMPOSE", itemGuid)
end

function ON_RESULT_ARK_DECOMPOSE(frame, msg, argStr, argNum)
	if argStr == nil then
		return
	end

	local rewardList = StringSplit(argStr, ';')
	if #rewardList <= 0 or #rewardList > 2 then
		return
	end

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot', 'ui::CSlot')
	slot:ClearIcon()
	
	local item_name = GET_CHILD_RECURSIVELY(frame, 'text_itemname')
	item_name:SetText('')
	
	local txt_complete = GET_CHILD_RECURSIVELY(frame, 'text_complete')
	txt_complete:ShowWindow(1)

	for i = 1, 2 do
		local rewardClassName = rewardList[i]
		local rewardCls = GetClass('Item', rewardClassName)
		if rewardCls ~= nil then
			local slot_result = GET_CHILD_RECURSIVELY(frame, 'result' .. i)
			slot_result:ShowWindow(1)
			SET_SLOT_IMG(slot_result, rewardCls.Icon)

			local text_result = GET_CHILD_RECURSIVELY(frame, 'text_result' .. i)
			local reward_name = dic.getTranslatedStr(rewardCls.Name)
			text_result:SetText(reward_name)
		end
	end

	local execbutton = GET_CHILD_RECURSIVELY(frame, 'execbutton')
	execbutton:ShowWindow(0)

	local okbutton = GET_CHILD_RECURSIVELY(frame, 'okbutton')
	okbutton:ShowWindow(1)
end