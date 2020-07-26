function TRANSFERSEAL_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_TRANSFERSEAL", "ON_OPEN_DLG_TRANSFERSEAL");
	addon:RegisterMsg("TRANSFER_SEAL_SUCCESS", "TRANSFER_SEAL_SUCCESS");
end

local function _CREATE_SEAL_APPLY_OPTION(parent, ypos, width, height, option, optionValue, idx, xMargin, islockImg, lockImgName, lockImgSize, farFutureOptionSkin)
	if islockImg == true then
		local bg = parent:CreateControl('groupbox', 'OPTION_HIDE_'..idx, 5, ypos, width, height);
		bg:SetSkinName(farFutureOptionSkin);		

		local lockImg = bg:CreateControl('picture', 'lockImg', 0, 0, lockImgSize, lockImgSize);
		AUTO_CAST(lockImg);
		lockImg:SetImage(lockImgName);
		lockImg:SetGravity(ui.RIGHT, ui.CENTER_VERT);
	end

	local richtext = parent:CreateControl('richtext', 'OPTION_'..idx, xMargin, ypos + 7, width - 10, height);
	local str = string.format('{img tooltip_attribute2 20 20} %d%s : %s', idx, ClMsg('Step'), GET_OPTION_VALUE_OR_PERCECNT_STRING(option, optionValue));
	richtext:SetTextFixWidth(1);
	richtext:EnableTextOmitByWidth(1);
	richtext:SetText(str);
	richtext:SetFontName('white_16_b_ol');
	
	ypos = ypos + height;
	return ypos;
end

local function _TRANSFER_SEAL_APPLY_OPTION_BOX(frame, itemObj, level)	
    local applyOptionBox = GET_CHILD_RECURSIVELY(frame, 'applyOptionBox');
	DESTROY_CHILD_BYNAME(applyOptionBox, 'OPTION_');
	if itemObj == nil then
		return;
	end

	local ypos = 40;
	local APPLY_OPTION_CTRLSET_WIDTH = tonumber(frame:GetUserConfig('APPLY_OPTION_CTRLSET_WIDTH'));
	local APPLY_OPTION_CTRLSET_HEIGHT = tonumber(frame:GetUserConfig('APPLY_OPTION_CTRLSET_HEIGHT'));
	local APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y = tonumber(frame:GetUserConfig('APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y'));
	local FAR_FUTURE_OPTION_SKIN = frame:GetUserConfig('FAR_FUTURE_OPTION_SKIN');	
    local LOCK_IMG_NAME = frame:GetUserConfig('LOCK_IMG_NAME');	
	local LOCK_IMG_SIZE = tonumber(frame:GetUserConfig('LOCK_IMG_SIZE'));
    
    local islockImg = false;
    for i = 1, itemObj.MaxReinforceCount do
        if level < i then
            islockImg = true;
        end

        local option, optionValue = GetSealUnlockOption(itemObj.ClassName, i);
		if option ~= nil then
			ypos = _CREATE_SEAL_APPLY_OPTION(applyOptionBox, ypos, APPLY_OPTION_CTRLSET_WIDTH, APPLY_OPTION_CTRLSET_HEIGHT, option, optionValue, i, 10, islockImg, LOCK_IMG_NAME, LOCK_IMG_SIZE, FAR_FUTURE_OPTION_SKIN) + APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y;
        end
	end
end

local function _TRANSFER_SEAL_PRICE_UPDATE(frame, ClassName)
	local matrial_slot = GET_CHILD_RECURSIVELY(frame, "matrial_slot");
	
	local mat_className, mat_count = GET_TRANSFER_SEAL_MATERIAL();
	local itemCls = GetClass("Item", mat_className);
	SET_SLOT_ITEM_CLS(matrial_slot, itemCls);

	local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = mat_className}}, false);
	local matrial_name = GET_CHILD_RECURSIVELY(frame, "matrial_name");
	matrial_name:SetTextByKey("value", itemCls.Name);
	matrial_name:ShowWindow(1);

	local matrial_count = GET_CHILD_RECURSIVELY(frame, "matrial_count");
	matrial_count:ShowWindow(1);
	matrial_count:SetTextByKey("cur", curCnt);
	matrial_count:SetTextByKey("need", mat_count);
	if curCnt < mat_count then
		matrial_count:SetTextByKey("style", "{#ff0000}");
	else
		matrial_count:SetTextByKey("style", "");
	end
end

function ON_OPEN_DLG_TRANSFERSEAL()
	ui.OpenFrame("transferseal");
end

function OPEN_TRANSFER_SEAL(frame)
    TRANSFER_SEAL_UI_RESET();

	INVENTORY_SET_CUSTOM_RBTNDOWN("TRANSFER_SEAL_INV_RBTNDOWN");
	ui.OpenFrame("inventory");
end

function CLOSE_TRANSFER_SEAL(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	control.DialogOk();

    frame:ShowWindow(0);
end

function TRANSFER_SEAL_UI_RESET()
    local frame = ui.GetFrame("transferseal");
    frame:SetUserValue("SRC_ITEM_GUID", "None");
    frame:SetUserValue("SRC_ITEM_CLASSNAME", "None");

    local desc_slot = GET_CHILD_RECURSIVELY(frame, "desc_slot");
    desc_slot:ClearIcon();

    local src_slot = GET_CHILD_RECURSIVELY(frame, "src_slot");
    src_slot:ClearIcon();
    
    local desc_item_text = GET_CHILD_RECURSIVELY(frame, "desc_item_text");
    desc_item_text:ShowWindow(0);
    
    local src_slot_img = GET_CHILD(src_slot, "src_slot_img");
    src_slot_img:ShowWindow(1);

    local applyOptionBox = GET_CHILD_RECURSIVELY(frame, "applyOptionBox");
	DESTROY_CHILD_BYNAME(applyOptionBox, 'OPTION_');

	local matrial_slot = GET_CHILD_RECURSIVELY(frame, "matrial_slot");
    matrial_slot:ClearIcon();

	local matrial_count = GET_CHILD_RECURSIVELY(frame, "matrial_count");
	matrial_count:ShowWindow(0);

	local matrial_name = GET_CHILD_RECURSIVELY(frame, "matrial_name");
	matrial_name:ShowWindow(0);

	local reinfBtn = GET_CHILD_RECURSIVELY(frame, "reinfBtn");
	reinfBtn:ShowWindow(1);

	local resetBtn = GET_CHILD_RECURSIVELY(frame, "resetBtn");
	resetBtn:ShowWindow(0);	
	
    local reinfResultBox = GET_CHILD_RECURSIVELY(frame, "reinfResultBox");
    reinfResultBox:ShowWindow(0);
end

function TRANSFER_SEAL_INV_RBTNDOWN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("transferseal");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	TRANSFER_SEAL_SRC_REG(iconInfo:GetIESID());
end

function TRANSFER_SEAL_SRC_DROP(frame, icon)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		TRANSFER_SEAL_SRC_REG(iconInfo:GetIESID());
	end
end

function TRANSFER_SEAL_SRC_REG(guid)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	local invItem = session.GetInvItemByGuid(guid);
	if invItem == nil then
		return;
    end
    
    local itemObj = GetIES(invItem:GetObject());
    local ret, transferName = IS_SEAL_TRANSFER_ITEM(itemObj);
    if ret == false then
        return;
    end

    local curLv = GET_CURRENT_SEAL_LEVEL(itemObj);    
    if curLv <= 0 then
        return;
	end
	
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

    local frame = ui.GetFrame("transferseal");
    frame:SetUserValue("SRC_ITEM_GUID", guid);
    frame:SetUserValue("SRC_ITEM_CLASSNAME", itemObj.ClassName);

    local src_slot = GET_CHILD_RECURSIVELY(frame, "src_slot");
    SET_SLOT_ITEM(src_slot, invItem);
    
	local src_slot_img = GET_CHILD(src_slot, "src_slot_img");
    src_slot_img:ShowWindow(0);
    
    local itemCls = GetClass("Item", transferName);
    local desc_slot = GET_CHILD_RECURSIVELY(frame, "desc_slot");
    desc_slot:EnableHitTest(1);
    SET_SLOT_ITEM_CLS(desc_slot, itemCls);
    
    local fullname = string.format("+%d %s", curLv, itemCls.Name);
    local desc_item_text = GET_CHILD_RECURSIVELY(frame, "desc_item_text");
    desc_item_text:ShowWindow(1);    
    desc_item_text:SetTextByKey("value", fullname);

    _TRANSFER_SEAL_APPLY_OPTION_BOX(frame, itemCls, curLv);
	_TRANSFER_SEAL_PRICE_UPDATE(frame, itemCls.ClassName);
end

function TRANSFER_SEAL_SRC_POP(frame, icon, argStr, argNum)
	TRANSFER_SEAL_UI_RESET();
end

function TRANSFER_SEAL_BTN_CLICK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local src_guid = frame:GetUserValue("SRC_ITEM_GUID");
	if src_guid == "None" then
        ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end

	local src_ClassName = frame:GetUserValue("SRC_ITEM_CLASSNAME");
	local mat_className, mat_count = GET_TRANSFER_SEAL_MATERIAL();;
	local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = mat_className}}, false);
	if curCnt < mat_count then
        ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end
	
	session.ResetItemList();
	session.AddItemID(src_guid, 1);

	local resultlist = session.GetItemIDList();
	item.DialogTransaction("SCR_TRANSFER_SEAL", resultlist);
end

function TRANSFER_SEAL_SUCCESS(frame, msg, guid)
	local frame = ui.GetFrame("transferseal");

	local reinfResultBox = GET_CHILD_RECURSIVELY(frame, "reinfResultBox");
	reinfResultBox:ShowWindow(1);

	local reinfBtn = GET_CHILD(frame, "reinfBtn");
	reinfBtn:ShowWindow(0);

	local resetBtn = GET_CHILD(frame, "resetBtn");
	resetBtn:ShowWindow(1);

	local invItem = session.GetInvItemByGuid(guid);
	local successItem = GET_CHILD_RECURSIVELY(frame, "successItem");
	SET_SLOT_ITEM(successItem, invItem);
	
	local SUCCESS_EFFECT = frame:GetUserConfig("SUCCESS_EFFECT");
	local successItem = GET_CHILD_RECURSIVELY(reinfResultBox, "successItem");
	successItem:PlayUIEffect(SUCCESS_EFFECT, 5, "SUCCESS_EFFECT", true);
end