function LEGENDPREFIX_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_LEGEND_PREFIX', 'ON_SUCCESS_LEGEND_PREFIX');
	addon:RegisterMsg('FAIL_LEGEND_PREFIX', 'ON_FAIL_LEGEND_PREFIX');
end

function OPEN_LEGENDPREFIX(frame)
	ui.OpenFrame('inventory');
	LEGENDPREFIX_RESET(frame);
	LEGEND_PREFIX_DROPLIST_RESET(frame);
    lock_state_check.clear_lock_state();
end

function CLOSE_LEGENDPREFIX(frame)    
	ui.CloseFrame('inventory');
	ui.CloseFrame("legendprefix_tooltip");
    lock_state_check.clear_lock_state()
end

function LEGENDPREFIX_CLOSE_BUTTON(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	ui.CloseFrame('legendprefix')
	ui.CloseFrame('inventory')
    lock_state_check.clear_lock_state()
end

function LEGENDPREFIX_RESET(frame)
	LEGENDPREFIX_RESET_TARGET_ITEM(frame);
	LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);	
    lock_state_check.clear_lock_state()
end

function LEGENDPREFIX_RESET_TARGET_ITEM(frame)
	frame:SetUserValue('TARGET_ITEM_GUID', "None");

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	slot:ClearIcon();

	local targetText = GET_CHILD_RECURSIVELY(frame, 'targetText');
	targetText:SetTextByKey('name', '')
end

function LEGENDPREFIX_RESET_MATERIAL_SLOT(frame)	
	local matPic = GET_CHILD_RECURSIVELY(frame, 'matPic');
	local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
	matPic:ShowWindow(0);
	matText:ShowWindow(0);
end

function LEGENDPREFIX_SET_TARGET(parent, ctrl)    
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local fromFrame = liftIcon:GetTopParentFrame();
	if fromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local frame = parent:GetTopParentFrame();
		_LEGENDPREFIX_SET_TARGET(frame, iconInfo:GetIESID());
	end
end

function LEGENDPREFIX_SET_TARGET_ITEM(frame, itemGuid, prefixName)    
	if ui.CheckHoldedUI() == true then
		return;
	end

	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return;
	end

	local invItemCls = GetClassByType('Item', invItem.type);
	if invItemCls == nil then
		return;
	end

	if LEGENDPREFIX_SET_TARGET_ITEM(invItemCls) == false then
		ui.SysMsg(ClMsg('NotEnoughTarget'));
		return;
	end

    if IS_VALID_ITEM_FOR_GIVING_PREFIX(invItemCls) == false then
    	ui.SysMsg(ClMsg('NotEnoughTarget'));
    	return;
    end

	frame:SetUserValue('TARGET_ITEM_GUID', itemGuid);

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local icon = slot:GetIcon();
	if icon == nil then
		icon = CreateIcon(slot);
	end
	icon:SetImage(invItemCls.Icon);
	SET_ITEM_TOOLTIP_BY_OBJ(icon, invItem);

	local targetText = GET_CHILD_RECURSIVELY(frame, 'targetText');
	local obj = GetIES(invItem:GetObject());	
	local nameText = GET_LEGEND_PREFIX_ITEM_NAME(obj, prefixName);
	targetText:SetTextByKey('name', nameText);
	return invItem;
end

function _LEGENDPREFIX_SET_TARGET(frame, itemGuid)
	local targetItem = LEGENDPREFIX_SET_TARGET_ITEM(frame, itemGuid);
	local targetObject = nil;
	if targetItem ~= nil then
		targetObject = GetIES(targetItem:GetObject());
	end
	
	if targetObject == nil then
		return;
	end

	local needItemClsName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME(targetObject.LegendGroup);
	local needItemCls = GetClass('Item', needItemClsName);
	local matPic = GET_CHILD_RECURSIVELY(frame, 'matPic');	
	local fullImage = GET_LEGENDEXPPOTION_ICON_IMAGE_FULL(needItemCls)
	matPic:SetImage(fullImage);
	matPic:ShowWindow(1);
	matPic:SetTooltipOverlap(0);
	matPic:SetTooltipType('wholeitem');
	matPic:SetTooltipArg('maxexp', needItemCls.ClassID, 0);	

	local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
	local needCnt = GET_LEGEND_PREFIX_NEED_MATERIAL_COUNT(targetObject);
	if needCnt == 0 then
		return;
	end
	local curCnt = GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT_C();
	matText:SetTextByKey('need', needCnt);
	matText:SetTextByKey('cur', curCnt);
	if needCnt > curCnt then
		local NOT_ENOUPH_STYLE = frame:GetUserConfig('NOT_ENOUPH_STYLE');
		matText:SetTextByKey('style', NOT_ENOUPH_STYLE);
	else
		local ENOUPH_STYLE = frame:GetUserConfig('ENOUPH_STYLE');
		matText:SetTextByKey('style', ENOUPH_STYLE);
	end
	matText:ShowWindow(1);

	LEGEND_PREFIX_DROPLIST_INIT(frame, targetObject);	
end

function GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT_C() -- 경험치 꽉 찬 아이템만 개수 세주는 함수
	local frame = ui.GetFrame("legendprefix");
	if frame == nil then return end
	
	local itemGuid = frame:GetUserValue("TARGET_ITEM_GUID");
	local targetItem = nil;
	if itemGuid ~= nil then
		targetItem = session.GetInvItemByGuid(itemGuid);
	end

	local itemObj = GetIES(targetItem:GetObject());
	if itemObj == nil then return end

	local needItemName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME(itemObj.LegendGroup);
	
    local count = 0;
	local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value = needItemName}
	}, false, nil, function(item)
		if item == nil then
			return false;
		end
		local itemExpStr = TryGetProp(item, 'ItemExpString', 'None');
        if itemExpStr == 'None' then
            itemExpStr = '0';
        end
		local itemExpNum = tonumber(itemExpStr);
        if itemExpNum ~= nil and itemExpNum >= item.NumberArg1 then
            return true;
		end
		return false;
	end);	
    return count;
end

function LEGENDPREFIX_EXECUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
	if itemGuid == "None" then
		return;
	end
	
    local invItem = session.GetInvItemByGuid(itemGuid);
    if invItem == nil then
        return;
    end

    if invItem.isLockState == true then
    	ui.SysMsg(ClMsg('MaterialItemIsLock'));
    	return;
    end

    local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
    local needCnt = tonumber(matText:GetTextByKey('need'));
    local curCnt = tonumber(matText:GetTextByKey('cur'));
    if needCnt > curCnt then
    	ui.SysMsg(ClMsg('NotEnoughRecipe'));
    	return;
    end

	local prefixName = frame:GetUserConfig("PREFIXNAME");
	if prefixName == "" then
		ui.SysMsg(ClMsg("PleaseSelectSetOption"));
		return;
	end

	ui.MsgBox(ClMsg('CannotProcessUIInputDuringPrefixing'), '_LEGENDPREFIX_EXECUTE', 'None');
end

function _LEGENDPREFIX_EXECUTE()
	local frame = ui.GetFrame('legendprefix');
	local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
	if itemGuid == "None" then
		return;
	end

    local invItem = session.GetInvItemByGuid(itemGuid);
    if invItem == nil then
        return;
    end

    if invItem.isLockState == true then
    	ui.SysMsg(ClMsg('MaterialItemIsLock'));
    	return;
    end

    local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
    local needCnt = tonumber(matText:GetTextByKey('need'));
    local curCnt = tonumber(matText:GetTextByKey('cur'));
    if needCnt > curCnt then
    	ui.SysMsg(ClMsg('NotEnoughRecipe'));
    	return;
    end

    ui.SetHoldUI(true);

    local linkButton = GET_CHILD_RECURSIVELY(frame, 'reg')
    linkButton:EnableHitTest(0)

	-- effect
	local pic = GET_CHILD_RECURSIVELY(frame, 'pic');
	local matPic_dummy = GET_CHILD_RECURSIVELY(frame, 'matPic_dummy');
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	pic:PlayActiveUIEffect();
	matPic_dummy:PlayActiveUIEffect();
	slot:PlayActiveUIEffect();

	session.ResetItemList();
    session.AddItemID(invItem:GetIESID(), 1);

	local prefixName = frame:GetUserConfig("PREFIXNAME");
	local stringList = NewStringList();
	stringList:Add(prefixName);

    local resultlist = session.GetItemIDList();
    item.DialogTransaction("EXECUTE_PREFIX_SET", resultlist, "", stringList);
    lock_state_check.disable_lock_state(itemGuid)
end

function LEGENDPREFIX_APPLY_RESULT(argStr)
	local frame = ui.GetFrame('legendprefix');
	_LEGENDPREFIX_SET_TARGET(frame, argStr);

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local resultframe = ui.GetFrame('legendprefix_result');		
	resultframe:ShowWindow(1);
	resultframe:SetDuration(3);
	
	frame:SetUserConfig("PREFIXNAME", "");
end

function LEGENDPREFIX_BG_ANIM_TICK(ctrl, str, tick)
	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();		
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();
		
		local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
		if itemGuid == "None" then
			return;
		end
		
		local str = string.format('LEGENDPREFIX_APPLY_RESULT("%s")', itemGuid);
    	local linkButton = GET_CHILD_RECURSIVELY(frame, 'reg')
    	linkButton:EnableHitTest(1)
		ReserveScript(str, 0.3);
	end
end

function ON_SUCCESS_LEGEND_PREFIX(frame, msg, argStr, argNum)	
	ui.SetHoldUI(false);
	
    local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
	animpic_bg:ShowWindow(1);
	animpic_bg:ForcePlayAnimation();

	-- effect
	local pic = GET_CHILD_RECURSIVELY(frame, 'pic');
	local matPic_dummy = GET_CHILD_RECURSIVELY(frame, 'matPic_dummy');
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	pic:PlayActiveUIEffect();
	matPic_dummy:PlayActiveUIEffect();
	slot:PlayActiveUIEffect();

    local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
    lock_state_check.enable_lock_state(itemGuid)
end

function ON_FAIL_LEGEND_PREFIX(frame, msg, argStr, argNum)
    local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
    lock_state_check.enable_lock_state(itemGuid)
	ui.SetHoldUI(false);
end

function LEGEND_PREFIX_DROPLIST_RESET(frame)
	local dropList = GET_CHILD_RECURSIVELY(frame, "legend_OptionSelect_DropList");
	dropList:ClearItems();
	dropList:Invalidate();
end

function LEGEND_PREFIX_DROPLIST_INIT(frame, targetObj)
	local dropList = GET_CHILD_RECURSIVELY(frame, "legend_OptionSelect_DropList");
	dropList:ClearItems();
	dropList:AddItem('', '');
    local legendGroup = TryGetProp(targetObj, 'LegendGroup' , 'None')
    
	local dropListIndex = 1;
	local clsList, cnt = GetClassList("LegendSetItem");
	if clsList ~= nil then
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			if cls.LegendGroup == legendGroup and targetObj.LegendPrefix ~= cls.ClassName then
				local name = cls.Name;
				dropList:AddItem(cls.ClassName, name, i);
				dropListIndex = dropListIndex + 1;
			end
		end
	end

	dropList:SetVisibleLine(dropListIndex);
	dropList:SetDropListDefaultOffset(false);
	dropList:SelectItem(0);
	dropList:Invalidate();
	OPEN_LEGENDPREFIX_TOOLTIP();
end

function LEGEND_PREFIX_SELECT_DROPLIST(parent, ctrl)
	local preFixName = ctrl:GetSelItemKey();
	local frame = parent:GetTopParentFrame();
	local itemGuid = frame:GetUserValue("TARGET_ITEM_GUID");
	
	local invItem = nil;
	if itemGuid ~= nil then
		invItem = session.GetInvItemByGuid(itemGuid);
	end

	local tooltipFrame = ui.GetFrame("legendprefix_tooltip");
	if tooltipFrame ~= nil then
		if preFixName == "" then
			tooltipFrame:SetVisible(0);
		elseif invItem ~= nil and preFixName ~= "" then
		tooltipFrame:SetVisible(1);

			LEGEND_PREFIX_SELECT_TOOLTIP_DRAW(tooltipFrame, invItem, 0, 0, preFixName);
		end
	end

	frame:SetUserConfig("PREFIXNAME", preFixName);
end

