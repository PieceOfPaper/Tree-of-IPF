function LEGENDDECOMPOSE_ON_INIT(addon, frame)
	addon:RegisterMsg('RESULT_LEGEND_DECOMPOSE', 'ON_RESULT_LEGEND_DECOMPOSE');
end

function LEGENDDECOMPOSE_OPEN(frame)
	ui.OpenFrame('inventory');
	LEGENDPREFIX_RESET(frame);
end

function LEGENDDECOMPOSE_CLOSE(frame)
	ui.CloseFrame('inventory');
end

function LEGENDDECOMPOSE_SET_TARGET(parent, ctrl)
	local liftIcon = ui.GetLiftIcon();
	local fromFrame = liftIcon:GetTopParentFrame();
	if fromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local frame = parent:GetTopParentFrame();		
		_LEGENDDECOMPOSE_SET_TARGET(frame, iconInfo:GetIESID());
	end
end

function _LEGENDDECOMPOSE_SET_TARGET(frame, itemGuid)
	LEGENDPREFIX_SET_TARGET_ITEM(frame, itemGuid);
	LEGENDPREFIX_RESET_MATERIAL_SLOT(frame);
end

function LEGENDDECOMPOSE_EXECUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local targetGuid = frame:GetUserValue('TARGET_ITEM_GUID');
	if targetGuid == "None" then
		return;
	end
	
	local targetItem = session.GetInvItemByGuid(targetGuid);
	if targetItem == nil then
		return;
	end
    
	if targetItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end
	
	local targetObj = GetIES(targetItem:GetObject());
	decomposeAble = TryGetProp(targetObj, 'DecomposeAble')
    if decomposeAble == nil or decomposeAble == "NO" then
        ui.SysMsg(ClMsg('decomposeCant'));
        return;
    end
	local rewardCls = GetClass('LegendDecompose', targetObj.LegendGroup);	
	local matCls = GetClass('Item', rewardCls.MaterialClassName);	
	local yesScp = string.format('_LEGENDDECOMPOSE_EXECUTE("%s")', targetGuid);
	if TryGetProp(targetObj, 'UseLv', 1) >= 430 then
	    ui.MsgBox(ScpArgMsg('ReallyDecomposeLEgendItemFor{ITEM}?_LV430_UPPER'), yesScp, 'None');
	else
	    ui.MsgBox(ScpArgMsg('ReallyDecomposeLEgendItemFor{ITEM}?', 'ITEM', matCls.Name), yesScp, 'None');
    end
end

function _LEGENDDECOMPOSE_EXECUTE(targetGuid)
	local frame = ui.GetFrame('legenddecompose');
	local itemGuid = frame:GetUserValue('TARGET_ITEM_GUID');
	if itemGuid == 'None' then
		return;
	end

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

	session.ResetItemList();
    session.AddItemID(itemGuid, 1);
    local resultlist = session.GetItemIDList();
    item.DialogTransaction("EXECUTE_LEGEND_DECOMPOSE", resultlist);
end

function ON_RESULT_LEGEND_DECOMPOSE(frame, msg, rewardClassName, rewardCnt)
	LEGENDPREFIX_RESET_TARGET_ITEM(frame);

	local rewardCls = GetClass('Item', rewardClassName);
	local matPic = GET_CHILD_RECURSIVELY(frame, 'matPic');
	local matText = GET_CHILD_RECURSIVELY(frame, 'matText');
	
	local rewardIcon = CreateIcon(matPic);
	rewardIcon:SetImage(rewardCls.Icon);
	SET_ITEM_TOOLTIP_ALL_TYPE(rewardIcon, nil, rewardClassName, 'legenddecompose', rewardCls.ClassID, 0)

	matText:SetTextByKey('cur', rewardCnt);
	matPic:ShowWindow(1);	
	matText:ShowWindow(1);
end