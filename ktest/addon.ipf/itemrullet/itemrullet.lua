-- item_seal UI
function ITEMRULLET_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_ITEMRULLET', 'ON_OPEN_DLG_REINFORCE_SEAL');
	addon:RegisterMsg('SUCCESS_REINFORCE_SEAL', 'ON_SUCCESS_REINFORCE_SEAL');
end

local s_reinforceSeal = {};
local function _INIT_COMPONENT(frame)
	local slotBox = GET_CHILD_RECURSIVELY(frame, 'slotBox');
	local slotBox2 = GET_CHILD_RECURSIVELY(frame, 'slotBox2');
	local costBox = GET_CHILD_RECURSIVELY(frame, 'costBox');
	DESTROY_CHILD_BYNAME(slotBox, 'Component_');
	DESTROY_CHILD_BYNAME(costBox, 'Component_');

	local TARGET_SLOT_SIZE = tonumber(frame:GetUserConfig('TARGET_SLOT_SIZE'));
	local MATERIAL_SLOT_SIZE = tonumber(frame:GetUserConfig('MATERIAL_SLOT_SIZE'));
	local SLOT_INTERVAL_MARGIN_X = tonumber(frame:GetUserConfig('SLOT_INTERVAL_MARGIN_X'));
	s_reinforceSeal['TargetSeal'] = CREATE_TARGET_ITEM_SLOT_COMPONENT(slotBox, 'Component_targetSeal', {
		x = 0, y = 0, width = TARGET_SLOT_SIZE, height = TARGET_SLOT_SIZE, 
		margin = {-SLOT_INTERVAL_MARGIN_X, 30, 0, 0},
		gravity = { horz = ui.CENTER_HORZ, vert = ui.TOP },
		dropScp = 'REINFORCE_SEAL_DROP_TARGET',
		dropCheckScp = 'REINFORCE_SEAL_CHECK_TARGET',
		rBtnUpScp = 'RESET_REINFORCE_SEAL',
	});

	s_reinforceSeal['MaterialSeal'] = CREATE_TARGET_ITEM_SLOT_COMPONENT(slotBox, 'Component_materialSeal', {
		x = 0, y = 0, width = MATERIAL_SLOT_SIZE, height = MATERIAL_SLOT_SIZE, 
		margin = {SLOT_INTERVAL_MARGIN_X, 50, 0, 0},
		gravity = { horz = ui.CENTER_HORZ, vert = ui.TOP },
		dropScp = 'REINFORCE_SEAL_DROP_MATERIAL',
		dropCheckScp = 'REINFORCE_SEAL_CHECK_MATERIAL',
		rBtnUpScp = 'REINFORCE_SEAL_CLEAR_SIMULATE',
	});

	local MINMAX_COMP_WIDTH = tonumber(frame:GetUserConfig('MINMAX_COMP_WIDTH'));
	local MINMAX_COMP_HEIGHT = tonumber(frame:GetUserConfig('MINMAX_COMP_HEIGHT'));
	local MINMAX_MARGIN_RIGHT = tonumber(frame:GetUserConfig('MINMAX_MARGIN_RIGHT'));
	local MINMAX_MARGIN_TOP = tonumber(frame:GetUserConfig('MINMAX_MARGIN_TOP'));
	s_reinforceSeal['UpDownMax'] = CREATE_UPDOWNMAX_COMPONENT(costBox, 'Component_updownmax', {
		x = 0, y = 0, width = MINMAX_COMP_WIDTH, height = MINMAX_COMP_HEIGHT, 
		margin = {0, MINMAX_MARGIN_TOP, MINMAX_MARGIN_RIGHT, 0},
		gravity = { horz = ui.RIGHT, vert = ui.TOP },
		upBtnUpScp = 'REINFORCE_SEAL_UPDATE_SIMULATE',
		downBtnUpScp = 'REINFORCE_SEAL_UPDATE_SIMULATE',
		maxBtnUpScp = 'REINFORCE_SEAL_UPDATE_SIMULATE',
		checkScp = 'REINFORCE_SEAL_CHECK_ADDITIONAL_ITEM',
		isAlwaysWithMax = true,
	});
	local additionalItemCls = GetClass('Item', GET_SEAL_ADDITIONAL_ITEM());
	local additionalInvItem = session.GetInvItemByType(additionalItemCls.ClassID);
	s_reinforceSeal.UpDownMax:SetMinMax(0, 0);
	s_reinforceSeal.UpDownMax:SetStyle('{#FF0000}');
	slotBox:ShowWindow(1);
	slotBox2:ShowWindow(1);
end

local function _CREATE_SEAL_OPTION(parent, ypos, width, height, option, optionValue, idx, xMargin)
	local richtext = parent:CreateControl('richtext', 'OPTION_'..idx, xMargin, ypos, width - 10, height);
	local str = string.format('{img tooltip_attribute2 20 20} %d%s : %s', idx, ClMsg('Step'), GET_OPTION_VALUE_OR_PERCECNT_STRING(option, optionValue));
	richtext:SetTextFixWidth(1);
	richtext:EnableTextOmitByWidth(1);
	richtext:SetText(str);
	richtext:SetFontName('white_16_b_ol');
	ypos = ypos + height;
	return ypos;
end

local function _GET_NEXT_SEAL_OPTION_TEXT(sealItemObj, minmaxInfo)
	local text = '{@st43b}{s18}'..ClMsg('WillBeAppliedOptionRandomly')..'{/}{/}{nl} {nl}';
	for group, options in pairs(minmaxInfo) do
		text = text..'{@st66d_y}'..ClMsg(group)..'{/}{nl}';
		for optionName, info in pairs(options) do
			local optionStr = string.format('   {@st43b}{s18}%s [%d ~ %d]{/}{/}{nl}', ClMsg(optionName), info.min, info.max);
			text = text..optionStr;
		end
		text = text..' {nl}';
	end
	return text;
end

local function _CREATE_SEAL_OPTION_HIDE(parent, ypos, idx, showHelpImg, itemObj, prop)
	local bg = parent:CreateControl('groupbox', 'OPTION_HIDE_'..idx, 5, ypos, prop.width, prop.height);
	if showHelpImg == true then
		if itemObj.SealType == 'random' then
			local helpImg = bg:CreateControl('picture', 'helpPic', 0, 0, 24, 24);
			AUTO_CAST(helpImg);
			helpImg:SetImage('tip_questionmark');
			helpImg:SetGravity(ui.RIGHT, ui.CENTER_VERT);
			helpImg:SetMargin(0, 0, 5, 0);
		end
		bg:SetSkinName(prop.nextOptionSkin);
		bg:SetUserValue('NEXT_OPTION', 'YES');
	else
		bg:SetSkinName(prop.farFutureOptionSkin);
	end

	if itemObj.SealType == 'unlock' then
		local option, optionValue = GetSealUnlockOption(itemObj.ClassName, idx);
		if option ~= nil then			
			_CREATE_SEAL_OPTION(bg, 4, prop.width, prop.height, option, optionValue, idx, 5);
		end
	end

	local lockImg = bg:CreateControl('picture', 'lockImg', 0, 0, prop.lockImgSize, prop.lockImgSize);
	AUTO_CAST(lockImg);
	lockImg:SetImage(prop.lockImgName);
	lockImg:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);

	ypos = ypos + bg:GetHeight();
	return ypos;
end

local function _REQUEST_SEAL_MINMAX_INFO(targetSeal)
	session.ResetItemList();
    session.AddItemID(targetSeal:GetIESID(), 1);
    local resultlist = session.GetItemIDList();
    item.DialogTransaction('GET_SEAL_INFO', resultlist, '0');
end

local function _REQUEST_SEAL_BASIC_RATIO(targetSeal)	
	session.ResetItemList();
    session.AddItemID(targetSeal:GetIESID(), 1);
    local resultlist = session.GetItemIDList();
    item.DialogTransaction('GET_SEAL_INFO', resultlist, '1');
end

local function _REQUEST_SEAL_ADDITIONAL_RATIO(targetSeal, matSeal, additionalItemCount)	
	session.ResetItemList();
	session.AddItemID(targetSeal:GetIESID(), 1);
	session.AddItemID(matSeal:GetIESID(), 1);
    local resultlist = session.GetItemIDList();
	item.DialogTransaction('GET_SEAL_INFO', resultlist, '2 '..additionalItemCount);
end

local function _INIT_APPLY_OPTION_BOX(frame, itemObj)	
	local applyOptionBox = GET_CHILD_RECURSIVELY(frame, 'applyOptionBox');
	DESTROY_CHILD_BYNAME(applyOptionBox, 'OPTION_');
	if itemObj == nil then
		return;
	end

	if itemObj.SealType == 'random' then
		local targetSeal = s_reinforceSeal.TargetSeal:GetItemInfo();
		_REQUEST_SEAL_MINMAX_INFO(targetSeal);
	end

	local ypos = 40;
	local APPLY_OPTION_CTRLSET_WIDTH = tonumber(frame:GetUserConfig('APPLY_OPTION_CTRLSET_WIDTH'));
	local APPLY_OPTION_CTRLSET_HEIGHT = tonumber(frame:GetUserConfig('APPLY_OPTION_CTRLSET_HEIGHT'));
	local APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y = tonumber(frame:GetUserConfig('APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y'));
	local LOCK_IMG_SIZE = tonumber(frame:GetUserConfig('LOCK_IMG_SIZE'));
	local NEXT_OPTION_SKIN = frame:GetUserConfig('NEXT_OPTION_SKIN');
	local FAR_FUTURE_OPTION_SKIN = frame:GetUserConfig('FAR_FUTURE_OPTION_SKIN');	
	local LOCK_IMG_NAME = frame:GetUserConfig('LOCK_IMG_NAME');	
	local showHelpImg = true;
	for i = 1, itemObj.MaxReinforceCount do
		local option = TryGetProp(itemObj, 'SealOption_'..i, 'None');
		if option ~= 'None' then
			ypos = _CREATE_SEAL_OPTION(applyOptionBox, ypos, APPLY_OPTION_CTRLSET_WIDTH, APPLY_OPTION_CTRLSET_HEIGHT, itemObj['SealOption_'..i], itemObj['SealOptionValue_'..i], i, 10) + APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y;
		else
			ypos = _CREATE_SEAL_OPTION_HIDE(applyOptionBox, ypos, i, showHelpImg, itemObj,  {
				width = APPLY_OPTION_CTRLSET_WIDTH, height= APPLY_OPTION_CTRLSET_HEIGHT, 
				nextOptionSkin = NEXT_OPTION_SKIN, farFutureOptionSkin = FAR_FUTURE_OPTION_SKIN,
				lockImgSize = LOCK_IMG_SIZE, lockImgName = LOCK_IMG_NAME,
			}) + APPLY_OPTIOIN_CTRLSET_INTERVAL_MARGIN_Y;
			showHelpImg = false;
		end
	end
end

local function _GET_ADDITIONAL_ITEM(frame)
	local itemSlot = GET_CHILD_RECURSIVELY(frame, 'itemSlot');
	local additionalItemID = GET_SLOT_ITEM_TYPE(itemSlot);
	local additionalInvItem = session.GetInvItemByType(additionalItemID);	
	if additionalInvItem == nil or additionalInvItem:GetObject() == nil then
		return nil, 0;
	end
	local additionalItem = GetIES(additionalInvItem:GetObject());
	return additionalItem, s_reinforceSeal.UpDownMax:GetNumber(), additionalInvItem;
end

local function _SIMULATE_RESULT(frame)
	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialItem, materialItemObj = s_reinforceSeal.MaterialSeal:GetItemInfo();
	if targetItem == nil or materialItem == nil then
		return;
	end
	
	local additionalRatioText = GET_CHILD_RECURSIVELY(frame, 'additionalRatioText');
	additionalRatioText:SetTextByKey('ratio', 0);
	_REQUEST_SEAL_BASIC_RATIO(targetItem);
end

local function _UPDATE_PRICE(frame)
	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText');
	local targetSeal, targetSealObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialSeal, materialSealObj = s_reinforceSeal.MaterialSeal:GetItemInfo();
	local additionalItem, additionalItemCount = _GET_ADDITIONAL_ITEM(frame);
	priceText:SetTextByKey('price', GET_COMMAED_STRING(GET_SEAL_PRICE(targetSealObj, materialSealObj, additionalItem, additionalItemCount)));
end

local function _INIT_ADDITIONAL_ITEM(frame)
	local itemSlot = GET_CHILD_RECURSIVELY(frame, 'itemSlot');
	local additionalItemCls = GetClass('Item', GET_SEAL_ADDITIONAL_ITEM());
	SET_SLOT_ITEM_CLS(itemSlot, additionalItemCls);

	local icon = itemSlot:GetIcon();
	icon:GetInfo().type = additionalItemCls.ClassID;	

	local min, max = s_reinforceSeal.UpDownMax:GetMinMax();
	if min >= max then
		icon:SetColorTone('AAFF0000');
	else
		icon:SetColorTone('FFFFFFFF');
	end
end

local function _GET_NEXT_OPTION_BOX(frame)
	local applyOptionBox = GET_CHILD_RECURSIVELY(frame, 'applyOptionBox');	
	local childCount = applyOptionBox:GetChildCount();
	for i = 0, childCount - 1 do
		local child = applyOptionBox:GetChildByIndex(i);
		if string.find(child:GetName(), 'OPTION_HIDE_') ~= nil and child:GetUserValue('NEXT_OPTION') == 'YES' then
			return child;
		end
	end
end

-- global functions 
function OPEN_REINFORCE_SEAL(frame)
	RESET_REINFORCE_SEAL(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN('REFINFORCE_SEAL_RBTN_CLICK');	
	ui.OpenFrame('inventory');
end

function CLOSE_REINFORCE_SEAL(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN('None');
	ui.CloseFrame('inventory');
	control.DialogOk();
end

local function _UPDATE_ADDITIONAL_ITEM_STYLE(frame)
	local itemSlot = GET_CHILD_RECURSIVELY(frame, 'itemSlot');
	local icon = itemSlot:GetIcon();
	if s_reinforceSeal.UpDownMax:IsMax() == true then
		s_reinforceSeal.UpDownMax:SetStyle('{@st41}{s18}');
		icon:SetColorTone('FFFFFFFF');
	else
		s_reinforceSeal.UpDownMax:SetStyle('{#FF0000}');
		icon:SetColorTone('AAFF0000');
	end
end

function REINFORCE_SEAL_DROP_TARGET(parent, slot)
	local frame = parent:GetTopParentFrame();
	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	_INIT_APPLY_OPTION_BOX(frame, targetItemObj);
	_UPDATE_PRICE(frame);
	
	local targetNameText = GET_CHILD_RECURSIVELY(frame, 'targetNameText');
	targetNameText:SetTextByKey('name', GET_FULL_NAME(targetItemObj));

	local maxCnt = GET_MAX_SEAL_ADDIONAL_ITEM_COUNT(targetItemObj);
	s_reinforceSeal.UpDownMax:SetMinMax(0, maxCnt);
	_UPDATE_ADDITIONAL_ITEM_STYLE(frame);
end

function REINFORCE_SEAL_DROP_MATERIAL(parent, slot)	
	local frame = parent:GetTopParentFrame();
	_SIMULATE_RESULT(frame);
	_UPDATE_PRICE(frame);
end

function REINFORCE_SEAL_DROP_ADDITIONAL_ITEM(parent, slot)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if IS_SEAL_ADDITIONAL_ITEM(itemObj) == false then
		ui.SysMsg(ClMsg('CantUseSeal'));
		return;
	end

	SET_SLOT_ITEM_OBJ(slot, itemObj);
end

function REINFORCE_SEAL_CHECK_TARGET(parent, ctrl, itemObj)
	if IS_SEAL_ITEM(itemObj) == false then
		ui.SysMsg(ClMsg('CantUseSeal'));
		return false;
	end

	if itemObj.MaxReinforceCount <= GET_CURRENT_SEAL_LEVEL(itemObj) then
		ui.SysMsg(ClMsg('CanNotEnchantMore'));
		return false;
	end

	return true;
end

function REINFORCE_SEAL_CHECK_MATERIAL(parent, ctrl, itemObj)	
	if s_reinforceSeal.TargetSeal:IsEmpty() == true then
		ui.SysMsg(ClMsg('RegisterTargetSealFirst'));
		return false;
	end

	local targetSeal, targetSealObj = s_reinforceSeal.TargetSeal:GetItemInfo();	
	if IS_VALID_SEAL_MATERIAL_ITEM(targetSealObj, itemObj) == false then
		ui.SysMsg(ClMsg('CantUseSeal'));
		return false;
	end

	if targetSeal:GetIESID() == GetIESID(itemObj) then
		return false;
	end

	return true;
end

function REINFORCE_SEAL_CLEAR_SIMULATE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local simulateBox = GET_CHILD_RECURSIVELY(frame, 'simulateBox');
	simulateBox:ShowWindow(0);
end

function RESET_REINFORCE_SEAL(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	_INIT_COMPONENT(frame);
	_INIT_ADDITIONAL_ITEM(frame);
	REINFORCE_SEAL_CLEAR_SIMULATE(frame);

	local targetNameText = GET_CHILD_RECURSIVELY(frame, 'targetNameText');
	targetNameText:SetTextByKey('name', '');

	local applyOptionBox = GET_CHILD_RECURSIVELY(frame, 'applyOptionBox');
	DESTROY_CHILD_BYNAME(applyOptionBox, 'OPTION_');
	applyOptionBox:SetOffset(applyOptionBox:GetX(), applyOptionBox:GetOriginalY());
	applyOptionBox:ShowWindow(1);

	local reinfResultBox = GET_CHILD_RECURSIVELY(frame, 'reinfResultBox');
	reinfResultBox:ShowWindow(0);

	local costBox = GET_CHILD_RECURSIVELY(frame, 'costBox');
	local priceText = GET_CHILD_RECURSIVELY(costBox, 'priceText');
	priceText:SetTextByKey('price', GET_SEAL_PRICE());
	costBox:ShowWindow(1);
end

function REINFORCE_SEAL_EXECUTE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText');
	local price = GET_NOT_COMMAED_NUMBER(priceText:GetTextByKey('price'));
	local money = GET_TOTAL_MONEY_STR();
	if IsGreaterThanForBigNumber(price, money) == 1 then
        ui.SysMsg(ClMsg('NotEnoughMoney'));
        return;
    end

	local targetSeal, targetSealObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialSeal, materialSealObj = s_reinforceSeal.MaterialSeal:GetItemInfo();
	if targetSeal == nil or materialSeal == nil then
		ui.SysMsg(ClMsg('RegisterSeal'));
		return;
	end

	local resultText = GET_CHILD_RECURSIVELY(frame, 'resultText');
	local successRatio = tonumber(resultText:GetTextByKey('ratio'));
	local clmsg = '';
	if s_reinforceSeal.UpDownMax:IsMax() == true then
		clmsg = ClMsg('AdditionalItemCountIsMax');
	else
		clmsg = ClMsg('AdditionalItemCountIsNotMax');
	end
	if successRatio < 100 then
		clmsg = clmsg..'{nl}'..ClMsg('DestroyReinforceItem');
	end

	clmsg = clmsg..'{nl}'..ClMsg('ReallyReinforceSeal');

	ui.MsgBox(clmsg, 'IMPL_REINFORCE_SEAL_EXECUTE', 'None');
end

function IMPL_REINFORCE_SEAL_EXECUTE()
	local frame = ui.GetFrame('itemrullet');
	local targetSeal, targetSealObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialSeal, materialSealObj = s_reinforceSeal.MaterialSeal:GetItemInfo();	
	
	session.ResetItemList();
    session.AddItemID(targetSeal:GetIESID(), 1);
    session.AddItemID(materialSeal:GetIESID(), 1);
	local additionalItem, additionalItemCount, additionalInvItem = _GET_ADDITIONAL_ITEM(frame);	
	if additionalItem ~= nil then		
		session.AddItemID(additionalInvItem:GetIESID(), additionalItemCount);
	end
    local resultlist = session.GetItemIDList();
	item.DialogTransaction("REINFORCE_SEAL", resultlist);
end

function REFINFORCE_SEAL_RBTN_CLICK(itemObj, invSlot, invItemGuid)
	local frame = ui.GetFrame('itemrullet');
	local reinfResultBox = GET_CHILD_RECURSIVELY(frame, 'reinfResultBox');	
	if reinfResultBox:IsVisible() == 1 then
		return;
	end

	if invSlot:IsSelected() == 1 then
		RESET_REINFORCE_SEAL(frame);
	else
		if s_reinforceSeal.TargetSeal:IsEmpty() == true then
			if REINFORCE_SEAL_CHECK_TARGET(nil, nil, itemObj) == false then				
				return;
			end
			s_reinforceSeal.TargetSeal:SetSlotItem(session.GetInvItemByGuid(invItemGuid));
			REINFORCE_SEAL_DROP_TARGET(frame);
		elseif s_reinforceSeal.MaterialSeal:IsEmpty() == true then
			if REINFORCE_SEAL_CHECK_MATERIAL(nil, nil, itemObj) == false then
				return;
			end
			s_reinforceSeal.MaterialSeal:SetSlotItem(session.GetInvItemByGuid(invItemGuid));
			REINFORCE_SEAL_DROP_MATERIAL(frame);
		end
	end
end

function REINFORCE_SEAL_UPDATE_SIMULATE(parent, ctrl)	
	local frame = parent:GetTopParentFrame();
	_SIMULATE_RESULT(frame);
	_UPDATE_ADDITIONAL_ITEM_STYLE(frame);
end

local function _SET_RESULT_INFO(frame, result)	
	-- hide
	local applyOptionBox = GET_CHILD_RECURSIVELY(frame, 'applyOptionBox');
	local simulateBox = GET_CHILD_RECURSIVELY(frame, 'simulateBox');
	local costBox = GET_CHILD_RECURSIVELY(frame, 'costBox');
	local slotBox = GET_CHILD_RECURSIVELY(frame, 'slotBox');
	local slotBox2 = GET_CHILD_RECURSIVELY(frame, 'slotBox2');	
	applyOptionBox:ShowWindow(0);
	simulateBox:ShowWindow(0);
	costBox:ShowWindow(0);
	slotBox:ShowWindow(0);
	slotBox2:ShowWindow(0);

	-- show
	local reinfResultBox = GET_CHILD_RECURSIVELY(frame, 'reinfResultBox');
	local successBgBox = GET_CHILD(reinfResultBox, 'successBgBox');
	local failBgBox = GET_CHILD(reinfResultBox, 'failBgBox');
	if result == 'Success' then
		local successItemPic = GET_CHILD(successBgBox, 'successItemPic');
		local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
		successItemPic:SetImage(targetItemObj.Icon);

		applyOptionBox:Move(0, 100);
		applyOptionBox:ShowWindow(1);
		successBgBox:ShowWindow(1);
		failBgBox:ShowWindow(0);
	else
		local failPic = GET_CHILD(failBgBox, 'failPic');
		local failText = GET_CHILD(failBgBox, 'failText');
		if result == 'Fail' then
			failPic:SetImage('card_reinforce_FAIL');
			failText:ShowWindow(0);
		else
			failPic:SetImage('card_reinforce_DESTROY');
			failText:ShowWindow(1);
		end
		successBgBox:ShowWindow(0);
		failBgBox:ShowWindow(1);
		slotBox:ShowWindow(1);
		slotBox2:ShowWindow(1);
	end

	reinfResultBox:ShowWindow(1);
end

function ON_SUCCESS_REINFORCE_SEAL(frame, msg, result, argNum)
	_SET_RESULT_INFO(frame, result);
	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialItem, materialItemObj = s_reinforceSeal.MaterialSeal:GetItemInfo();
	if targetItemObj == nil then
		s_reinforceSeal.TargetSeal:Clear();		
	end
	if materialItemObj == nil then
		s_reinforceSeal.MaterialSeal:Clear();
	end

	if result ~= 'Success' then
		return;
	end

	local nextOptionBox = _GET_NEXT_OPTION_BOX(frame);
	imcGroupBox:StartAlphaEffect(nextOptionBox, 2, 0.1);
	ReserveScript("SUCESS_REINFORCE_SEAL_EFFECT()", 2);
end

function SUCESS_REINFORCE_SEAL_EFFECT()
	local frame = ui.GetFrame('itemrullet');
	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	s_reinforceSeal.MaterialSeal:Clear();
	_INIT_APPLY_OPTION_BOX(frame, targetItemObj);
end

function CB_SEALMINMAX(minmaxStr)
	local frame = ui.GetFrame('itemrullet');
	local nextOptionBox = _GET_NEXT_OPTION_BOX(frame);
	if nextOptionBox == nil then
		return;
	end
	local helpPic = GET_CHILD_RECURSIVELY(nextOptionBox, 'helpPic');
	if helpPic == nil then
		return;
	end

	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	if targetItem == nil then
		return;
	end

	local minmaxInfo = {};
	local groups = StringSplit(minmaxStr, '@');
	for i = 1, #groups do
		local groupAndOptions = StringSplit(groups[i], '*');
		local group = groupAndOptions[1];
		local optionminmax = StringSplit(groupAndOptions[2], '#');
		local options = {};
		for j = 1, #optionminmax, 3 do
			local optionName = optionminmax[j];
			local minStr = optionminmax[j + 1];
			local maxStr = optionminmax[j + 2];
			options[optionName] = {
				min = tonumber(minStr),
				max = tonumber(maxStr)
			};
		end
		minmaxInfo[group] = options;
	end

	local text = _GET_NEXT_SEAL_OPTION_TEXT(targetItemObj, minmaxInfo);
	helpPic:SetTextTooltip(text);
end

function CB_SEAL_BASIC_RATIO(basicRatio)	
	local frame = ui.GetFrame('itemrullet');	
	local simulateBox = GET_CHILD_RECURSIVELY(frame, 'simulateBox');
	local defaultRatioText = GET_CHILD_RECURSIVELY(simulateBox, 'defaultRatioText');
	local additionalRatioText = GET_CHILD_RECURSIVELY(frame, 'additionalRatioText');	
	defaultRatioText:SetTextByKey('ratio', basicRatio);
	additionalRatioText:ShowWindow(0);
	simulateBox:ShowWindow(1);

	local targetItem, targetItemObj = s_reinforceSeal.TargetSeal:GetItemInfo();
	local materialItem, materialItemObj = s_reinforceSeal.MaterialSeal:GetItemInfo();
	local additionalItem, additionalItemCount = _GET_ADDITIONAL_ITEM(frame);
	if targetItem == nil or materialItem == nil then
		return;
	end

	local resultText = GET_CHILD_RECURSIVELY(simulateBox, 'resultText');
	resultText:SetTextByKey('ratio', basicRatio);
	imcRichText:SetColorBlend(resultText, true, 2,  0xFFFF0000, 0xFFFFBB00);
	simulateBox:ShowWindow(1);

	_REQUEST_SEAL_ADDITIONAL_RATIO(targetItem, materialItem, additionalItemCount);
end

function CB_SEAL_ADDITIONAL_RATIO(additionalRatio)	
	local frame = ui.GetFrame('itemrullet');	
	local simulateBox = GET_CHILD_RECURSIVELY(frame, 'simulateBox');
	local defaultRatioText = GET_CHILD_RECURSIVELY(simulateBox, 'defaultRatioText');	
	local basicRatio = tonumber(defaultRatioText:GetTextByKey('ratio'));

	local additionalItem, additionalItemCount = _GET_ADDITIONAL_ITEM(frame);
	local additionalRatioText = GET_CHILD_RECURSIVELY(frame, 'additionalRatioText');
	if additionalItem == nil or additionalItemCount < 1 then		
		additionalRatioText:ShowWindow(0);
	else
		additionalRatioText:SetTextByKey('ratio', additionalRatio);
		additionalRatioText:ShowWindow(1);
	end

	local resultText = GET_CHILD_RECURSIVELY(simulateBox, 'resultText');
	resultText:SetTextByKey('ratio', basicRatio + additionalRatio);
	imcRichText:SetColorBlend(resultText, true, 2,  0xFFFF0000, 0xFFFFBB00);
	simulateBox:ShowWindow(1);
end

function ON_OPEN_DLG_REINFORCE_SEAL(frame, msg, argStr, argNum)
	ui.OpenFrame('itemrullet');
end

function REINFORCE_SEAL_CHECK_ADDITIONAL_ITEM(parent, ctrl)
	local curCnt = s_reinforceSeal.UpDownMax:GetNumber();
	local curHaveCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({}, false, nil, function(item)
		return IS_SEAL_ADDITIONAL_ITEM(item);
	end);
	return curHaveCnt > curCnt;
end