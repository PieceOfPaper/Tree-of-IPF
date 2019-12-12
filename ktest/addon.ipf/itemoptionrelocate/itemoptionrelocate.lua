
function ITEMOPTIONRELOCATE_ON_INIT(addon, frame)
    addon:RegisterMsg("ITEMOPTIONRELOCATE_SUCCESS", 'ITEMOPTIONRELOCATE_SUCCESS');
end

function ITEMOPTIONRELOCATE_OPEN_DLG(type)
    local frame = ui.GetFrame("itemoptionrelocate");
	frame:SetUserValue("RELOCATE_TYPE", type);

	local title = GET_CHILD(frame, 'title');
	if title == nil then return; end
	local typetext = frame:GetUserConfig('TEXT_AWAKE');
	if type == 'ENCHANT' then
		typetext = frame:GetUserConfig('TEXT_ENCHANT');
	end
	title:SetTextByKey('value', typetext);

	local do_relocate = GET_CHILD(frame, 'do_relocate');
	if do_relocate == nil then return; end	
	do_relocate:SetTextByKey('value', typetext);

	ui.OpenFrame("itemoptionrelocate");
end

function ITEMOPTIONRELOCATE_OPEN(frame)
	CLEAR_ITEMOPTIONRELOCATE_UI()

	local relocateType = frame:GetUserValue("RELOCATE_TYPE");
	if relocateType == 'None' then return; end

	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMOPTIONRELOCATE_INV_RBTN")	
	ui.OpenFrame("inventory");	
end

function ITEMOPTIONRELOCATE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	CLEAR_ITEMOPTIONRELOCATE_UI();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
end

function CLEAR_ITEMOPTIONRELOCATE_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemoptionrelocate");
	
	local dest_guid = frame:GetUserValue('DEST_ITEM_GUID');
	local src_guid = frame:GetUserValue('SRC_ITEM_GUID');
	if dest_guid ~= 'None' then
		SELECT_INV_SLOT_BY_GUID(dest_guid, 0);
	end
	if dest_guid ~= 'None' then
		SELECT_INV_SLOT_BY_GUID(src_guid, 0);
	end
	
	frame:SetUserValue('DEST_ITEM_GUID', 0);
	frame:SetUserValue('SRC_ITEM_GUID', 0);

	ITEMOPTIONRELOCATE_CLEAR_OPTION(frame);

	local item_text_bg = GET_CHILD_RECURSIVELY(frame, 'item_text_bg')
	item_text_bg:ShowWindow(1);
	
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	pic_bg:ShowWindow(1);

	local item_text = GET_CHILD_RECURSIVELY(frame, "item_text");
	item_text:SetTextByKey('value', frame:GetUserConfig('ITEM_NAME_TEXT'))

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	slot1:ClearIcon();
	slot1:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);

	local slot1_bg_image = GET_CHILD(slot1, "slot1_bg_image");
	slot1_bg_image:ShowWindow(1);

	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	slot2:ClearIcon();
	slot2:ShowWindow(0);

	local slot2_bg_image = GET_CHILD(slot2, "slot2_bg_image");
	slot2_bg_image:ShowWindow(1);

	local arrowpic = GET_CHILD_RECURSIVELY(frame, "arrowpic");
	arrowpic:ShowWindow(0);

	local medal_gb = GET_CHILD_RECURSIVELY(frame, "medal_gb");
	medal_gb:ShowWindow(0);

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok");
	send_ok:ShowWindow(0);

	local do_relocate = GET_CHILD_RECURSIVELY(frame, "do_relocate");
	do_relocate:ShowWindow(1);

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox");
	resultGbox:ShowWindow(0);	
end

function ITEMOPTIONRELOCATE_INV_RBTN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemoptionrelocate");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	if slot1:GetIcon() == nil then
		-- 옵션을 이전할 아이템 등록
		ITEMOPTIONRELOCATE_REG_SRC_ITEM(frame, iconInfo:GetIESID());
	else
		-- 옵션을 이전 받을 아이템 등록
		ITEMOPTIONRELOCATE_REG_DEST_ITEM(frame, iconInfo:GetIESID());
	end
end

function ITEMOPTIONRELOCATE_ITEM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local frame = ui.GetFrame("itemoptionrelocate");
		if frame == nil then
			return;
		end
		local iconInfo = liftIcon:GetInfo();

		local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
		if slot1:GetIcon() == nil then
			-- 옵션을 이전할 아이템 등록
			ITEMOPTIONRELOCATE_REG_SRC_ITEM(toFrame, iconInfo:GetIESID());
		else
			-- 옵션을 이전 받을 아이템 등록
			ITEMOPTIONRELOCATE_REG_DEST_ITEM(toFrame, iconInfo:GetIESID());
		end
	end
end

function ITEMOPTIONRELOCATE_ITEM_REMOVE(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();	
	if argNum == 1 then
		-- 이전 할 아이템 등록 해제
		local guid = frame:GetUserValue('SRC_ITEM_GUID');
		SELECT_INV_SLOT_BY_GUID(guid, 0);
		frame:SetUserValue('SRC_ITEM_GUID', 0);

		CLEAR_ITEMOPTIONRELOCATE_UI();
	else
		-- 이전 받을 아이템 등록 해제
		local guid = frame:GetUserValue('DEST_ITEM_GUID');
		SELECT_INV_SLOT_BY_GUID(guid, 0);
		frame:SetUserValue('DEST_ITEM_GUID', 0);
		
		local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
		slot2:ClearIcon();
	
		local slot2_bg_image = GET_CHILD_RECURSIVELY(frame, "slot2_bg_image");
		slot2_bg_image:ShowWindow(1);
		
		local toFrame = frame:GetTopParentFrame();
		local medal_gb = GET_CHILD_RECURSIVELY(toFrame, "medal_gb");
		medal_gb:ShowWindow(0);

		ITEMOPTIONRELOCATE_CLEAR_OPTION(toFrame)
	end
end

-- 옵션을 이전할 아이템 등록
function ITEMOPTIONRELOCATE_REG_SRC_ITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local relocateType = frame:GetUserValue("RELOCATE_TYPE");

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return false;
	end
	
	local enable, reason = IS_ENABLE_REG_ITEM(invItem);
	if enable == false then
		local typetext = frame:GetUserConfig('TEXT_AWAKE');
		if relocateType == 'ENCHANT' then
			typetext = frame:GetUserConfig('TEXT_ENCHANT');
		end

		ui.SysMsg(ScpArgMsg('CannotItemOptionRelocateBecause{TYPE}{REASON}', 'TYPE', typetext, 'REASON', ClMsg(reason)));
		return;
	end
	
	local itemObj = GetIES(invItem:GetObject());
	if relocateType == 'AWAKE' then
		if itemObj.IsAwaken == 0 then
			return;
		end
	elseif relocateType == 'ENCHANT' then
		if itemObj['RandomOptionRare'] == nil or itemObj['RandomOptionRare'] == 'None' then
			return;
		end
	else 
		return;
	end

	local slot1_bg_image = GET_CHILD_RECURSIVELY(frame, "slot1_bg_image");
	slot1_bg_image:ShowWindow(0);

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	slot1:SetGravity(ui.LEFT, ui.CENTER_VERT)
	
	local arrowpic = GET_CHILD_RECURSIVELY(frame, "arrowpic");
	arrowpic:ShowWindow(1);

	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	slot2:ShowWindow(1);

	local item_text = GET_CHILD_RECURSIVELY(frame, "item_text");
	item_text:SetTextByKey('value', itemObj.Name);

	SET_SLOT_ITEM(slot1, invItem);

	local guid = GetIESID(itemObj);
	frame:SetUserValue('SRC_ITEM_GUID', guid);
	SELECT_INV_SLOT_BY_GUID(guid, 1)
end

-- 옵션을 이전 받을 아이템 등록
function ITEMOPTIONRELOCATE_REG_DEST_ITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
    local guid = frame:GetUserValue('DEST_ITEM_GUID');
    SELECT_INV_SLOT_BY_GUID(guid, 0);
    frame:SetUserValue('DEST_ITEM_GUID', 0);
    
	local relocateType = frame:GetUserValue("RELOCATE_TYPE");

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return false;
	end
	
	local enable, reason = IS_ENABLE_REG_ITEM(invItem);
	if enable == false then
		local typetext = frame:GetUserConfig('TEXT_AWAKE');
		if relocateType == 'ENCHANT' then
			typetext = frame:GetUserConfig('TEXT_ENCHANT');
		end
		ui.SysMsg(ScpArgMsg('CannotItemOptionRelocateBecause{TYPE}{REASON}', 'TYPE', typetext,'REASON', ClMsg(reason)));
		return;
	end
	
	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local src_item = GET_SLOT_ITEM(slot1);
	if src_item == nil then
		return;
	end
	
	local src_Obj = GetIES(src_item:GetObject());
	local dest_Obj = GetIES(invItem:GetObject());

	local relocateType = frame:GetUserValue("RELOCATE_TYPE");
	local enable2, reason2 = false, 'Type';
	if relocateType == 'AWAKE' then
		-- 동일한 레벨, 동일한 부위, 동일한 등급
		enable2, reason2 = IS_ENABLE_AWAKE_OPTION_RELOCATE(dest_Obj, src_Obj);
	elseif relocateType == 'ENCHANT' then
		-- 부위 제한이 없음. 동일한 레벨, 동일한 등급
		enable2, reason2 = IS_ENABLE_ENCHANT_OPTION_RELOCATE(dest_Obj, src_Obj);
	else 
		return;
	end

	if enable2 == false then
		if reason2 == 'Same' then
			ui.SysMsg(ClMsg('AlreadRegSameItem'));
		else
			ui.SysMsg(ScpArgMsg('CannotItemOptionRelocateBecause{REASON}_2', 'REASON', ClMsg(reason2)));
		end
		return;
	end

	-- 아이템 등록
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	SET_SLOT_ITEM(slot2, invItem);
	
	local dest_guid = GetIESID(dest_Obj);
	frame:SetUserValue('DEST_ITEM_GUID', dest_guid);
	SELECT_INV_SLOT_BY_GUID(dest_guid, 1)

	local slot2_bg_image = GET_CHILD(slot2, "slot2_bg_image");
	slot2_bg_image:ShowWindow(0);

	local medal_gb = GET_CHILD_RECURSIVELY(frame, "medal_gb");
	medal_gb:ShowWindow(1);

	-- 이전 옵션
	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_0");
	gBox:RemoveAllChild();
	
	if relocateType == 'AWAKE' then
		local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(src_Obj.HiddenProp));
		local strInfo = ABILITY_DESC_PLUS(opName, src_Obj.HiddenPropValue);

		local ctrlSet = gBox:CreateOrGetControl('richtext', 'OPTION_TEXT_2', 3, 0, 400, 30);
		ctrlSet:SetText(strInfo);
		ctrlSet:SetFontName('brown_16');		
	elseif relocateType == 'ENCHANT' then
		local strInfo = GET_RANDOM_OPTION_RARE_CLIENT_TEXT(src_Obj)
		
		local ctrlSet = gBox:CreateOrGetControl('richtext', 'OPTION_TEXT_1', 3, 0, 400, 30);
		ctrlSet:SetText(strInfo);
	end

	-- 이전 비용
	local itemUseLv = TryGetProp(src_Obj, "UseLv", 9999);
	local cost = GET_ITEM_OPTION_RELOCATE_COST(itemUseLv);
	local decomposecost = GET_CHILD_RECURSIVELY(medal_gb, "decomposecost");
	decomposecost:SetText(cost);
	
	-- 예상 잔액
	local silverAmountStr = tonumber(GET_TOTAL_MONEY_STR());
	local remainsilver = GET_CHILD_RECURSIVELY(medal_gb, "remainsilver");
	remainsilver:SetText(silverAmountStr - cost);
end

function ITEMOPTIONRELOCATE_CLEAR_OPTION(frame)
	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_0");
	gBox:RemoveAllChild();
end

-- 옵션 이전 버튼 클릭
function OPTION_RELOCATE_BUTTON_CLICK(frame, ctrl)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = ui.GetFrame("itemoptionrelocate");

	local remainsilver = GET_CHILD_RECURSIVELY(frame, "remainsilver");
	if tonumber(remainsilver:GetText()) < 0 then
		ui.SysMsg(ClMsg("Auto_SilBeoKa_BuJogHapNiDa."));
		return;
	end

	local msg = ClMsg('ItemOptionRelocate_Check_Message_Awake');
	local relocateType = frame:GetUserValue("RELOCATE_TYPE");
	if relocateType == 'ENCHANT' then
		msg = ClMsg('ItemOptionRelocate_Check_Message_Enchant');
	end

	WARNINGMSGBOX_FRAME_OPEN(msg, '_ITEMOPTIONRELOCATE_START', 'None');
end

function _ITEMOPTIONRELOCATE_START()	
	local frame = ui.GetFrame('itemoptionrelocate');

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");

	local dest_item = GET_SLOT_ITEM(slot2);
	local src_item = GET_SLOT_ITEM(slot1);
	if dest_item == nil or src_item == nil then
		return;
	end
	
	local dest_Obj = GetIES(dest_item:GetObject());
	local src_Obj = GetIES(src_item:GetObject());

	local enable, reason = false, nil;
	local relocateType = frame:GetUserValue("RELOCATE_TYPE");
	if relocateType == 'AWAKE' then
		enable, reason = IS_ENABLE_AWAKE_OPTION_RELOCATE(dest_Obj, src_Obj);
	elseif relocateType == 'ENCHANT' then
		enable, reason = IS_ENABLE_ENCHANT_OPTION_RELOCATE(dest_Obj, src_Obj);
	end

	if enable == false then
		return;
	end
	
	session.ResetItemList();
    session.AddItemID(dest_item:GetIESID(), 1);
    session.AddItemID(src_item:GetIESID(), 1);
	local resultlist = session.GetItemIDList();
	
	local relocateType = frame:GetUserValue("RELOCATE_TYPE");
	if relocateType == 'AWAKE' then
		item.DialogTransaction("ITEM_OPTION_RELOCATE_AWAKE", resultlist);	-- 이펙트 출력 후 옵션 로직 실행
		PLAY_RELOCATE_EFFECT(frame)
	elseif relocateType == 'ENCHANT' then
		item.DialogTransaction("ITEM_OPTION_RELOCATE_ENCHANT", resultlist);	-- 이펙트 출력 후 옵션 로직 실행
		PLAY_RELOCATE_EFFECT(frame)
	end
	
end

-- 슬롯 2개에 이펙트 출력
function PLAY_RELOCATE_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionrelocate");

	local RELOCATE_EFFECT_NAME = frame:GetUserConfig('RELOCATE_EFFECT');
	local RELOCATE_EFFECT_SCALE = tonumber(frame:GetUserConfig('RELOCATE_EFFECT_SCALE'));
	local RELOCATE_EFFECT_DURATION = tonumber(frame:GetUserConfig('RELOCATE_EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	pic_bg:ShowWindow(1);
	pic_bg:PlayUIEffect(RELOCATE_EFFECT_NAME, RELOCATE_EFFECT_SCALE, 'RELOCATE_EFFECT_EFFECT');

	local do_relocate = GET_CHILD_RECURSIVELY(frame, "do_relocate")
	do_relocate:ShowWindow(0);
	ui.SetHoldUI(true);
	
    ReserveScript('RELEASE_UI_HOLD()', 7);
end

function RELEASE_UI_HOLD()
    ui.SetHoldUI(false);
end

function ITEMOPTIONRELOCATE_SUCCESS(pc, msg, dest_guid)
	local frame = ui.GetFrame("itemoptionrelocate");
	if frame:IsVisible() == 0 then
		return;
	end

	local item_text_bg = GET_CHILD_RECURSIVELY(frame, 'item_text_bg')
	item_text_bg:ShowWindow(0);

	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('RELOCATE_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	pic_bg:StopUIEffect('RELOCATE_EFFECT_EFFECT', true, 0.5);
	pic_bg:ShowWindow(0);

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok")
	send_ok:ShowWindow(1);

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox:ShowWindow(1);
	
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg')
	result_effect_bg:ShowWindow(1);
	
	local invItem = session.GetInvItemByGuid(dest_guid)
	local itemObj = GetIES(invItem:GetObject());
	
	local result_item_pic = GET_CHILD_RECURSIVELY(frame, 'result_item_pic')
	result_item_pic:SetImage(itemObj.Icon)
	SET_ITEM_TOOLTIP_BY_OBJ(result_item_pic, invItem)
				
	RELOCATE_SUCCESS_EFFECT(frame)
end

function RELOCATE_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionrelocate");

	local EXTRACT_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RELOCATE_RESULT_EFFECT');
	local RESULT_EFFECT_SCALE = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE'));
	local RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
	
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then return; end
	pic_bg:ShowWindow(0);

	result_effect_bg:PlayUIEffect(EXTRACT_SUCCESS_EFFECT_NAME, RESULT_EFFECT_SCALE, 'EXTRACT_SUCCESS_EFFECT');
	ReserveScript("_RELOCATE_SUCCESS_EFFECT()", RESULT_EFFECT_DURATION)
end

function  _RELOCATE_SUCCESS_EFFECT()
	local frame = ui.GetFrame("itemoptionrelocate");
	if frame:IsVisible() == 0 then return; end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	result_effect_bg:StopUIEffect('EXTRACT_SUCCESS_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end

function IS_ENABLE_REG_ITEM(invItem)    
	if invItem.isLockState == true then
		return false, 'ItemLock';
	end
	
	local itemObj = GetIES(invItem:GetObject());
	if TryGetProp(itemObj, 'ItemStar', -1) < 0 then
		return false, 'Type';
	end

	if 0 < TryGetProp(itemObj , 'LifeTime') or 0 < TryGetProp(itemObj , 'ItemLifeTimeOver') then
		return false, 'LimitTime';
	end

	if TryGetProp(itemObj , 'NeedAppraisal') == 1 or TryGetProp(itemObj , 'NeedRandomOption') == 1 then
		return false, 'NeedRandomOption';
	end

	return true;
end