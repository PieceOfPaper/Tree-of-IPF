
function ITEMOPTIONRELEASE_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ITEMOPTIONRELEASE", "ON_OPEN_DLG_ITEMOPTIONRELEASE");

	--성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ITEM_OPTION_RELEASE", "SUCCESS_ITEM_OPTION_RELEASE");

	addon:RegisterMsg("UPDATE_COLONY_TAX_RATE_SET", "ON_OPTIONRELEASE_UPDATE_COLONY_TAX_RATE_SET");
end;

function ON_OPEN_DLG_ITEMOPTIONRELEASE(frame)
	frame:ShowWindow(1);
end;

function ON_OPTIONRELEASE_UPDATE_COLONY_TAX_RATE_SET(frame)
	local costStaticText = GET_CHILD_RECURSIVELY(frame, 'costStaticText');
	SET_COLONY_TAX_RATE_TEXT(costStaticText, "tax_rate");
	CLEAR_ITEMOPTIONRELEASE_UI();
end;

function ITEMOPTIONRELEASE_OPEN(frame)
	ui.CloseFrame('rareoption');
	SET_OPTIONRELEASE_RESET(frame);
	CLEAR_ITEMOPTIONRELEASE_UI();
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMOPTIONRELEASE_INV_RBTN");
	ui.OpenFrame("inventory");
end;

function ITEMOPTIONRELEASE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end;
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
 end;

function OPTIONRELEASE_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemoptionrelease");
	UPDATE_OPTIONRELEASE_ITEM(frame);
	UPDATE_OPTIONRELEASE_RESULT(frame, isSuccess);
end;

function CLEAR_ITEMOPTIONRELEASE_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end;

	local frame = ui.GetFrame("itemoptionrelease");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();
	slot:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);

	local pic_bg = GET_CHILD_RECURSIVELY(frame, "pic_bg");
	pic_bg:ShowWindow(1);

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok");
	send_ok:ShowWindow(0);

	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release");
	do_release : ShowWindow(1);

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox");
	resultGbox:ShowWindow(0);

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem");
	putOnItem:ShowWindow(1);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image");
	slot_bg_image : ShowWindow(1);
		
	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox");
	arrowbox : ShowWindow(0);

	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result");
	slot_result : ShowWindow(0);

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname");
	itemName:SetText("");

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1);
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0);

	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:ShowWindow(1);
	bodyGbox1_1:Resize(bodyGbox1:GetWidth(), bodyGbox1:GetHeight());
	bodyGbox1_1:RemoveAllChild();
	local bodyGbox3_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3_1');
	bodyGbox3_1:ShowWindow(1);
	bodyGbox3_1:RemoveAllChild();

	local costBox = GET_CHILD_RECURSIVELY(frame, 'costBox');
	local priceText = GET_CHILD_RECURSIVELY(costBox, 'priceText');
	priceText:SetTextByKey('price', GET_OPTION_RELEASE_COST());
	costBox:ShowWindow(1);
end;

function _UPDATE_RELEASE_COST(frame)
	local priceText = GET_CHILD_RECURSIVELY(frame, 'priceText');
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end;
	local invItemObj = GetIES(invItem:GetObject());
	priceText:SetTextByKey('price', GET_COMMAED_STRING(GET_OPTION_RELEASE_COST(invItemObj, GET_COLONY_TAX_RATE_CURRENT_MAP())));
end

function ITEM_OPTIONRELEASE_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end;
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	CLEAR_ITEMOPTIONRELEASE_UI();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_OPTIONRELEASE_REG_TARGETITEM(toFrame, iconInfo:GetIESID());
		_UPDATE_RELEASE_COST(toFrame);
	end;
end;

-- 고정옵션 아이커 장착해제 
function ITEM_OPTIONRELEASE_REG_TARGETITEM(frame, itemID)
	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_1");
	gBox:RemoveChild('tooltip_equip_property');

	if ui.CheckHoldedUI() == true then
		return;
	end;
	local invItem = session.GetInvItemByGuid(itemID);
	if invItem == nil then
		return;
	end;

	local invItemObj = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', invItemObj.ClassID);
	
	if IS_ENABLE_RELEASE_OPTION(invItemObj) ~= true then
		-- 복원 대상인지 체크
		ui.SysMsg(ClMsg("IcorNotAdded"));
		return;
	end;
	
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end;

	local obj = GetIES(invItem:GetObject());

	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end;

	local inheritItemName = TryGetProp(invItemObj, 'InheritanceItemName', 'None');
	local inheritItemCls = nil;
	if inheritItemName ~= 'None' then
		inheritItemCls = GetClass('Item', inheritItemName);
	end;

    if inheritItemCls == nil then    
        ui.SysMsg(ClMsg("IcorNotAdded"));
        return
    end

	local yPos = 0;
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(inheritItemCls);
    local list = {};
    local basicTooltipPropList = StringSplit(inheritItemCls.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list);
    end;

	local list2 = GET_EUQIPITEM_PROP_LIST();
	
	local cnt = 0;
	for i = 1 , #list do

		local propName = list[i];
		local propValue = inheritItemCls[propName];
		
		if propValue ~= 0 then
            local checkPropName = propName;
            if propName == 'MINATK' or propName == 'MAXATK' then
                checkPropName = 'ATK';
            end
            if EXIST_ITEM(basicTooltipPropList, checkPropName) == false then
                cnt = cnt + 1;
            end;
		end;
	end;

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = inheritItemCls[propName];
		
		if propValue ~= 0 then
			cnt = cnt + 1;
		end;
	end;

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if inheritItemCls[propValue] ~= 0 and inheritItemCls[propName] ~= "None" then
			cnt = cnt +1
		end;
	end;

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline");
	labelline:ShowWindow(0);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox');

	local inner_yPos = 0;
		
	local randomOptionProp = {};

	for i = 1 , #list do
		local propName = list[i];
		local propValue = inheritItemCls[propName];
		local needToShow = true;
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false;
			end;
		end;

		if needToShow == true and inheritItemCls[propName] ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음

			if  inheritItemCls.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), inheritItemCls[propName]);					
					inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
				end;
			elseif  inheritItemCls.GroupName == 'Armor' then
				if inheritItemCls.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), inheritItemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end;
				elseif inheritItemCls.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), inheritItemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end;
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), inheritItemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end;
				end;
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), inheritItemCls[propName]);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end;
		end;
	end;

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invItemObj[propValue] ~= 0 and invItemObj[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(invItemObj[propName]));
			local strInfo = ABILITY_DESC_PLUS(opName, invItemObj[propValue]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end;
	end;

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = invItemObj[propName];
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), invItemObj[propName]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end;
	end;

	if inheritItemCls.OptDesc ~= nil and inheritItemCls.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, inheritItemCls.OptDesc, 0, inner_yPos);
	end

	if invItemObj.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption");
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * invItemObj.ReinforceRatio/100));
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos);
	end;

	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 40);

	gBox:Resize(gBox:GetWidth(), tooltip_equip_property_CSet:GetHeight());

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem");
	putOnItem:ShowWindow(0);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image");
	slot_bg_image : ShowWindow(0);

	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox");
	arrowbox : ShowWindow(1);

	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result");
	slot_result : ShowWindow(1);

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText(obj.Name);

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT);
	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result");
	local icor_img = nil;
	if itemCls.GroupName == "Weapon" or itemCls.GroupName == "SubWeapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON");
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR");
	end

	SET_SLOT_IMG(slot_result, icor_img);
	frame:SetUserValue("icor_img", icor_img);
	SET_SLOT_ITEM(slot, invItem);
	SET_OPTIONRELEASE_RESET(frame);
end

function SET_OPTIONRELEASE_RESET(frame)
--	reg:ShowWindow(0);
end;

function ITEMOPTIONRELEASE_EXEC(frame)
	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end;

	local invItemObj = GetIES(invItem:GetObject());
	local price = GET_OPTION_RELEASE_COST(invItemObj, GET_COLONY_TAX_RATE_CURRENT_MAP());
	local pcMoney = GET_TOTAL_MONEY_STR();
	if IsGreaterThanForBigNumber(price, pcMoney) == 1 then
        ui.SysMsg(ClMsg('NotEnoughMoney'));
        return;
    end;

	local clmsg = ScpArgMsg("ReallyRollbackIcor");
	WARNINGMSGBOX_FRAME_OPEN(clmsg, "_ITEMOPTIONRELEASE_EXEC", "_ITEMOPTIONRELEASE_CANCEL");
end

function _ITEMOPTIONRELEASE_CANCEL()
	local frame = ui.GetFrame("itemoptionrelease");
end;

function _ITEMOPTIONRELEASE_EXEC(checkRebuildFlag)
	local frame = ui.GetFrame("itemoptionrelease");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end;

	local invItemObj = GetIES(invItem:GetObject());

	if checkRebuildFlag ~= false then
		if TryGetProp(invItemObj, 'Rebuildchangeitem', 0) > 0 then
			ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ITEMOPTIONRELEASE_EXEC(false)', 'None');
			return;
		end;
	end;
	
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, "bodyGbox3");
	bodyGbox3:ShowWindow(0);
	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox");
	resultGbox:ShowWindow(1);

	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release");
	do_release:ShowWindow(0);
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1);

	local frame = ui.GetFrame("itemoptionrelease");
	if frame:IsVisible() == 0 then
		return;
	end;
	
		------------------------------
		-- release(rollback) 서버 스크립트 호출 부분--
		------------------------------

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox');
	resultGbox:ShowWindow(0);

	pc.ReqExecuteTx_Item("RELEASE_ITEM_ICOR", invItem:GetIESID());
	return;
end;

function SUCCESS_ITEM_OPTION_RELEASE(frame)
	local frame = ui.GetFrame("itemoptionrelease");
	local RELEASE_RESULT_EFFECT_NAME = frame:GetUserConfig('RELEASE_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end;
	
	pic_bg:ShowWindow(1);
	pic_bg:PlayUIEffect(RELEASE_RESULT_EFFECT_NAME, EFFECT_SCALE, 'RELEASE_RESULT_EFFECT');

	local do_release = GET_CHILD_RECURSIVELY(frame, "do_release");
	do_release:ShowWindow(0);
	ui.SetHoldUI(true);

	ReserveScript("_SUCCESS_ITEM_OPTION_RELEASE()", EFFECT_DURATION);
end;

function _SUCCESS_ITEM_OPTION_RELEASE()
	
	local frame = ui.GetFrame("itemoptionrelease");
	if frame:IsVisible() == 0 then
		return;
	end;

	local RELEASE_RESULT_EFFECT_NAME = frame:GetUserConfig('RELEASE_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end;
	pic_bg:StopUIEffect('RELEASE_RESULT_EFFECT', true, 0.5);
	pic_bg:ShowWindow(0);

	local slot = GET_CHILD_RECURSIVELY(frame, "slot_result");

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok");
	sendOK:ShowWindow(1);

	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0);

	local gbox = frame:GetChild("gbox");

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox:ShowWindow(1);
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	local image_success = GET_CHILD_RECURSIVELY(frame, 'yellow_skin_success');
	local text_success = GET_CHILD_RECURSIVELY(frame, 'text_success');
	result_effect_bg:ShowWindow(1);
	image_success:ShowWindow(1);
	text_success:ShowWindow(1);

	local resultItemImg = GET_CHILD_RECURSIVELY(frame, "result_item_img");
	resultItemImg:ShowWindow(1);

	local icor_img = frame:GetUserValue("icor_img");
	resultItemImg:SetImage(icor_img);
				
	RELEASE_SUCCESS_EFFECT(frame);

	return;
end;

function RELEASE_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionrelease");
	local RELEASE_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RELEASE_SUCCESS_EFFECT');
	local SUCCESS_EFFECT_SCALE = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_SCALE'));
	local SUCCESS_EFFECT_DURATION = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_DURATION'));
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end;

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end;
	pic_bg:ShowWindow(0);

	result_effect_bg:PlayUIEffect(RELEASE_SUCCESS_EFFECT_NAME, SUCCESS_EFFECT_SCALE, 'RELEASE_SUCCESS_EFFECT');

	ReserveScript("_RELEASE_SUCCESS_EFFECT()", SUCCESS_EFFECT_DURATION);
end

function _RELEASE_SUCCESS_EFFECT()
	local frame = ui.GetFrame("itemoptionrelease");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end
	result_effect_bg:StopUIEffect('RELEASE_SUCCESS_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end


function REMOVE_OPTIONRELEASE_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end;

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEMOPTIONRELEASE_UI();
end;

function ITEMOPTIONRELEASE_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("itemoptionrelease");
	if frame == nil then
		return;
	end;

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem ~= nil then
		CLEAR_ITEMOPTIONRELEASE_UI();
		ITEM_OPTIONRELEASE_REG_TARGETITEM(frame, iconInfo:GetIESID());
		_UPDATE_RELEASE_COST(frame)
	end;
end;
