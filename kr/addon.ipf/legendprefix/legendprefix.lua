function LEGENDPREFIX_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_LEGEND_PREFIX', 'ON_SUCCESS_LEGEND_PREFIX');
	addon:RegisterMsg('FAIL_LEGEND_PREFIX', 'ON_FAIL_LEGEND_PREFIX');
end

function OPEN_LEGENDPREFIX(frame)
	ui.OpenFrame('inventory');
	LEGENDPREFIX_RESET(frame);
	lock_state_check.clear_lock_state();
	LEGENDPREFIX_CREATE_MAT_BALLOON();
	LEGENDPREFIX_MAT_BALLOON(false);
end

function CLOSE_LEGENDPREFIX(frame)
	LEGENDPREFIX_MAT_BALLOON(false);
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
	LEGENDPREFIX_RESET_DROPLIST(frame);
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
	frame:SetUserValue('MAT_ITEM_GUID', "None");
	local matSlot = GET_CHILD_RECURSIVELY(frame, 'matSlot');
	if matSlot ~= nil then
		matSlot:ClearIcon();
	end

	local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
	if matText ~= nil then
		matText:ShowWindow(0);
	end
end

function LEGENDPREFIX_RESET_DROPLIST(frame)
	local dropList = GET_CHILD_RECURSIVELY(frame, "legend_OptionSelect_DropList");
	if dropList ~= nil then
		dropList:ClearItems();
		dropList:Invalidate();
		LEGEND_PREFIX_SELECT_DROPLIST(frame, dropList)
	end
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

	if itemGuid == nil then
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
	
	if invItem.isLockState == true then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
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

-- 마우스 오른쪽 버튼으로 아이템 등록
function LEGENDPREFIX_SET_ITEM(frame, itemGuid)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	if itemGuid == nil then
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
	
	-- 세트옵션 부여할 아이템
	if IS_VALID_ITEM_FOR_GIVING_PREFIX(invItemCls) == true then
		_LEGENDPREFIX_SET_TARGET(frame, itemGuid)
		return;
	end

	local targetitemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
	if targetitemGuid == "None" then
		ui.SysMsg(ClMsg('PleasePrefixItem'));
		return;
	end

	local targetItem = session.GetInvItemByGuid(targetitemGuid);
	local targetObject = GetIES(targetItem:GetObject());
	if targetObject == nil then
		return;
	end
	local obj = GetIES(invItem:GetObject());
	
	-- 사용할 재료 아이템
	if IS_LEGEND_PREFIX_MATERIAL_CHECK(obj, targetObject) ==  true then		
		_LEGENDPREFIX_SET_MAT(frame, itemGuid, targetObject);
		return;
	else
		ui.SysMsg(ClMsg('NotEnoughTarget'));
		return;
	end

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

	LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);
	LEGENDPREFIX_RESET_DROPLIST(frame);
	LEGENDPREFIX_MAT_BALLOON(true)
end

function IS_LEGEND_PREFIX_MATERIAL_CHECK(obj, targetObject)
	if ui.CheckHoldedUI() == true then
		return;
	end

	if obj.StringArg == "None" then
		if obj.ClassName == "Legend_ExpPotion_2_complete" then
			return true;
		end
	elseif string.find(obj.StringArg, targetObject.LegendGroup) ~= nil then
		return true;
	end

	return false;
end

function LEGENDPREFIX_SET_MAT(parent, ctrtrl)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ctrtrl:GetTopParentFrame();

	-- 타겟 아이템이 등록 되어있는지 확인
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	if slot:GetIcon() == nil then
		ui.SysMsg(ClMsg('RegisterPrefixItem'));
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local fromFrame = liftIcon:GetTopParentFrame();
	if fromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local frame = parent:GetTopParentFrame();
		local itemGuid = iconInfo:GetIESID();
		if itemGuid == nil then
			return;
		end

		local invItem = session.GetInvItemByGuid(itemGuid);
		local obj = GetIES(invItem:GetObject());

		local targetitemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
		if targetitemGuid == "None" then
			return;
		end
		local targetItem = session.GetInvItemByGuid(targetitemGuid);
		local targetObject = GetIES(targetItem:GetObject());
		if targetObject == nil then
			return;
		end

		-- 등록된 타겟아이템의 레전드 그룹을 이용해 등록 할 수 있는 재료들이 뭐가 있는지 확인
		-- 내가 등록하려는 아이템이 그 아이템인지 확인하는 함수 추가
		if IS_LEGEND_PREFIX_MATERIAL_CHECK(obj, targetObject) ==  false then
			ui.SysMsg(ClMsg('NotEnoughTarget'));
			return;
		end

		_LEGENDPREFIX_SET_MAT(frame, itemGuid, targetObject);
	end
end

function _LEGENDPREFIX_SET_MAT(frame, itemGuid, targetObject)
	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return;
	end

	local invItemCls = GetClassByType('Item', invItem.type);
	if invItemCls == nil then
		return;
	end

	if invItem.isLockState == true then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return;
	end

	frame:SetUserValue('MAT_ITEM_GUID', itemGuid);

	LEGENDPREFIX_MAT_BALLOON(false);
	LEGEND_PREFIX_DROPLIST_INIT(frame, targetObject, invItemCls.ClassName);
	LEGENDPREFIX_SET_MAT_COUNT(frame, targetObject, invItemCls)
end

-- 등록한 재료 초기화, 세트 옵션 드랍리스트 초기화
function LEGENDPREFIX_REMOVE_MAT(parent, ctrtrl)
	local frame = ctrtrl:GetTopParentFrame();
	LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);
	LEGENDPREFIX_RESET_DROPLIST(frame);
end

-- 보유 아이템 수 / 필요 아이템, 아이콘 내용 등록
function LEGENDPREFIX_SET_MAT_COUNT(frame, targetObject, needItemCls)
	local needItemClsName = needItemCls.ClassName;
	local matText = GET_CHILD_RECURSIVELY(frame, 'matText');

	local needCnt = GET_LEGEND_PREFIX_NEED_MATERIAL_COUNT_BY_NEEDITEM(targetObject, needItemClsName, GetMyPCObject());
	if needCnt == 0 then
		return;
	end

	local curCnt = GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT_C(needItemClsName);
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

	local matSlot = GET_CHILD_RECURSIVELY(frame, 'matSlot');
	local matPic = matSlot:GetIcon();
	if matPic == nil then
		matPic = CreateIcon(matSlot);
	end
	matPic:SetImage(needItemCls.Icon);
	
	matPic:ShowWindow(1);
	matPic:SetTooltipOverlap(0);
	matPic:SetTooltipType('wholeitem');
	matPic:SetTooltipArg('maxexp', needItemCls.ClassID, 0);	

end

-- 등록한 재료 보유 수
function GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT_C(needItemName)  
	local frame = ui.GetFrame("legendprefix");
	if frame == nil then return end
	
	local itemGuid = frame:GetUserValue("TARGET_ITEM_GUID");
	local targetItem = nil;
	if itemGuid ~= nil and itemGuid ~= "None" then
		targetItem = session.GetInvItemByGuid(itemGuid);
	end

	local itemObj = GetIES(targetItem:GetObject());
	if itemObj == nil then return end
	
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

-- 확인버튼 클릭
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

	local matguid = frame:GetUserValue('MAT_ITEM_GUID');
	if matguid == "None" then
		ui.SysMsg(ClMsg("Auto_JaeLyoLeul_olLyeoJuSeyo"));
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

function LEGEND_PREFIX_DROPLIST_INIT(frame, targetObj, needItemClsName)
	local dropList = GET_CHILD_RECURSIVELY(frame, "legend_OptionSelect_DropList");
	dropList:ClearItems();
	dropList:AddItem('', '');
    local legendGroup = TryGetProp(targetObj, 'LegendGroup' , 'None')
	
	local AlreadyPrefix = false;
	local dropListIndex = 1;
	local clsList, cnt = GetClassList("LegendSetItem");
	if clsList ~= nil then
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			if string.find(cls.LegendGroup, legendGroup) ~= nil and targetObj.LegendPrefix ~= cls.ClassName and cls.NeedMaterial == needItemClsName then
				local name = cls.Name;
				dropList:AddItem(cls.ClassName, name, i);
				dropListIndex = dropListIndex + 1;
			elseif targetObj.LegendPrefix == cls.ClassName and cls.NeedMaterial == needItemClsName then
				AlreadyPrefix = true;
			end
		end
	end

	if AlreadyPrefix == true and dropListIndex == 1 then
		LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);	
		LEGENDPREFIX_RESET_DROPLIST(frame);
		ui.SysMsg(ClMsg('AlreadyPrefixOption'));
		return;
	end

	dropList:SetVisibleLine(dropListIndex);
	dropList:SetDropListDefaultOffset(false);
	dropList:SelectItem(0);
	dropList:Invalidate();
	OPEN_LEGENDPREFIX_TOOLTIP();
	LEGEND_PREFIX_SELECT_DROPLIST(frame, dropList)
end

function LEGEND_PREFIX_SELECT_DROPLIST(parent, ctrl)
	local preFixName = ctrl:GetSelItemKey();
	local frame = parent:GetTopParentFrame();
	local itemGuid = frame:GetUserValue("TARGET_ITEM_GUID");
	
	local invItem = nil;
	if itemGuid ~= nil and itemGuid ~= "None" then
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

-- 재료 등록 안내 말풍선 추가
function LEGENDPREFIX_CREATE_MAT_BALLOON(frame)
	local matBalloon = ui.GetFrame("legendprefix_mat");
	if matBalloon ~= nil then
		return;
	end	
	
	local frame = ui.GetFrame("legendprefix")
	local matSlot = GET_CHILD_RECURSIVELY(frame, 'matSlot');
	local matBalloon = MAKE_BALLOON_FRAME(ClMsg("Auto_JaeLyoLeul_olLyeoJuSeyo"), 0, 0, nil, "legendprefix_mat", "{#050505}{s16}{b}");
	local margin = matSlot:GetMargin();
	matBalloon:SetMargin(93, 80, 0, 0);
	matBalloon:SetLayerLevel(105);
end

-- 재료 등록 안내 말풍선 출력 여부 결정
function LEGENDPREFIX_MAT_BALLOON(isdraw)
	local matBalloon = ui.GetFrame("legendprefix_mat");

	if matBalloon == nil then
		return;
	end

	if isdraw == true then
		matBalloon:ShowWindow(1);
	else		
		matBalloon:ShowWindow(0);
	end
end

