function LEGENDPREFIX_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_LEGEND_PREFIX', 'ON_SUCCESS_LEGEND_PREFIX')
end

function OPEN_LEGENDPREFIX(frame)
	ui.OpenFrame('inventory');
	LEGENDPREFIX_RESET(frame);
end

function CLOSE_LEGENDPREFIX(frame)
	ui.CloseFrame('inventory');
end

function LEGENDPREFIX_CLOSE_BUTTON(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	ui.CloseFrame('legendprefix')
	ui.CloseFrame('inventory')
end

function LEGENDPREFIX_RESET(frame)
	LEGENDPREFIX_RESET_TARGET_ITEM(frame);
	LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);	
end

function LEGENDPREFIX_RESET_TARGET_ITEM(frame)
	frame:SetUserValue('TARGET_ITEM_GUID', "None");

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	slot:ClearIcon();

	local targetText = GET_CHILD_RECURSIVELY(frame, 'targetText');
	targetText:SetTextByKey('name', '');
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

function LEGENDPREFIX_SET_TARGET_ITEM(frame, itemGuid)
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
	local nameText = GET_LEGEND_PREFIX_ITEM_NAME(obj);
	targetText:SetTextByKey('name', nameText);

	return invItem;
end

function _LEGENDPREFIX_SET_TARGET(frame, itemGuid)
	local targetItem = LEGENDPREFIX_SET_TARGET_ITEM(frame, itemGuid);
	local targetObject = nil;
	if targetItem ~= nil then
		targetObject = GetIES(targetItem:GetObject());
	end

	local needItemClsName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME();
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
end

function GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT_C() -- 경험치 꽉 찬 아이템만 개수 세주는 함수
    local count = 0;
    local needItemName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME();
    local invItemList = session.GetInvItemList();
    local i = invItemList:Head();
    while true do		
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);
		local item = GetIES(invItem:GetObject());
		local itemExpNum = tonumber(item.ItemExpString)
        if item.ClassName == needItemName and itemExpNum ~= nil and itemExpNum >= item.NumberArg1 then
            count = count + 1;
        end

        i = invItemList:Next(i);
    end

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
    local resultlist = session.GetItemIDList();
    item.DialogTransaction("EXECUTE_PREFIX_SET", resultlist);
end

function LEGENDPREFIX_APPLY_RESULT(argStr)
	local frame = ui.GetFrame('legendprefix');
	_LEGENDPREFIX_SET_TARGET(frame, argStr);

	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local resultframe = ui.GetFrame('legendprefix_result');		
	resultframe:ShowWindow(1);
	resultframe:SetDuration(3);
end

function LEGENDPREFIX_BG_ANIM_TICK(ctrl, str, tick)
	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();		
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();
		
		local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
		local str = string.format('LEGENDPREFIX_APPLY_RESULT("%s")', itemGuid);
		
		ui.SetHoldUI(false);

    	local linkButton = GET_CHILD_RECURSIVELY(frame, 'reg')
    	linkButton:EnableHitTest(1)
		ReserveScript(str, 0.3);
	end
end

function ON_SUCCESS_LEGEND_PREFIX(frame, msg, argStr, argNum)	

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
end