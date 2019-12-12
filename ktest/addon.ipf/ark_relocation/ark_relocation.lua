
function ARK_RELOCATION_ON_INIT(addon, frame)
	addon:RegisterMsg("ARK_RELOCATION_SUCCESS", 'ARK_RELOCATION_SUCCESS');
end

function TOGGLE_ARK_RELOCATION_UI(isOpen)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("ark_relocation");
	frame:ShowWindow(isOpen);
end

function ARK_RELOCATION_OPEN(frame)
	CLEAR_ARK_RELOCATION_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ARK_RELOCATION_INV_RBTNDOWN")	
	ui.OpenFrame("inventory");

end

function ARK_RELOCATION_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	CLEAR_ARK_RELOCATION_UI();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	ui.CloseFrame("inventory");
    
    ui.CloseFrame('ark_relocation');    
end

function CLEAR_ARK_RELOCATION_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end
	
    local frame = ui.GetFrame("ark_relocation");
    
    local dest_guid = frame:GetUserValue('DEST_ITEM_GUID');
	local src_guid = frame:GetUserValue('SRC_ITEM_GUID');
	if dest_guid ~= 'None' then
		SELECT_INV_SLOT_BY_GUID(dest_guid, 0);
	end
	if src_guid ~= 'None' then
		SELECT_INV_SLOT_BY_GUID(src_guid, 0);
	end	
	
	frame:SetUserValue('DEST_ITEM_GUID', 0);
    frame:SetUserValue('SRC_ITEM_GUID', 0);
    
	local item_text_bg = GET_CHILD_RECURSIVELY(frame, 'item_text_bg')
	item_text_bg:ShowWindow(1);
	
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	pic_bg:ShowWindow(1);
	pic_bg:EnableHitTest(1);

	local item_text = GET_CHILD_RECURSIVELY(frame, "item_text");
	item_text:SetTextByKey('value', frame:GetUserConfig('ITEM_NAME_TEXT'))

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	slot1:ClearIcon();
	slot1:SetGravity(ui.CENTER_HORZ, ui.TOP);

	local slot1_bg_image = GET_CHILD(slot1, "slot1_bg_image");
    slot1_bg_image:ShowWindow(1);
    
    local slot1_info = GET_CHILD(pic_bg, "slot1_info");
    slot1_info:ShowWindow(0);

	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	slot2:ClearIcon();
	slot2:ShowWindow(0);

	local slot2_bg_image = GET_CHILD(slot2, "slot2_bg_image");
    slot2_bg_image:ShowWindow(1);
    
    local slot2_info = GET_CHILD(pic_bg, "slot2_info");
    slot2_info:ShowWindow(0);

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

function ARK_RELOCATION_INV_RBTNDOWN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("ark_relocation");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	if slot1:GetIcon() == nil then
		-- 옵션을 이전할 아이템 등록
		ARK_RELOCATION_REG_SRC_ITEM(frame, iconInfo:GetIESID());
	else
		-- 옵션을 이전 받을 아이템 등록
		ARK_RELOCATION_REG_DEST_ITEM(frame, iconInfo:GetIESID());
	end
end

function ARK_RELOCATION_SRC_ITEM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local frame = ui.GetFrame("ark_relocation");
		if frame == nil then
			return;
		end
		local iconInfo = liftIcon:GetInfo();

		-- 옵션을 이전 받을 아이템 등록
		ARK_RELOCATION_REG_SRC_ITEM(toFrame, iconInfo:GetIESID());
	end
end

function ARK_RELOCATION_DEST_ITEM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local frame = ui.GetFrame("ark_relocation");
		if frame == nil then
			return;
		end
		local iconInfo = liftIcon:GetInfo();

		-- 옵션을 이전할 아이템 등록
		ARK_RELOCATION_REG_DEST_ITEM(toFrame, iconInfo:GetIESID());
	end
end

function ARK_RELOCATION_ITEM_REMOVE(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();	
	if argNum == 1 then
		local guid = frame:GetUserValue('SRC_ITEM_GUID');
		SELECT_INV_SLOT_BY_GUID(guid, 0);
		frame:SetUserValue('SRC_ITEM_GUID', 0);

		CLEAR_ARK_RELOCATION_UI();
	else
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
        
        local slot2_info = GET_CHILD_RECURSIVELY(frame, "slot2_info");
        slot2_info:ShowWindow(0);
	end
end

-- 옵션을 이전할 아이템 등록
function ARK_RELOCATION_REG_SRC_ITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return false;
	end
	
	local enable, reason = IS_ENABLE_REG_ARK_ITEM(frame, invItem);
	if enable == false then
		if reason == 'ItemLock' then
			ui.SysMsg(ClMsg('MaterialItemIsLock'));
		end
		return;
	end

	local guid = frame:GetUserValue('SRC_ITEM_GUID');
    SELECT_INV_SLOT_BY_GUID(guid, 0);
    frame:SetUserValue('SRC_ITEM_GUID', 0);
	
	local itemObj = GetIES(invItem:GetObject());

	local slot1_bg_image = GET_CHILD_RECURSIVELY(frame, "slot1_bg_image");
	slot1_bg_image:ShowWindow(0);

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	slot1:SetGravity(ui.LEFT, ui.TOP)
	
	local arrowpic = GET_CHILD_RECURSIVELY(frame, "arrowpic");
	arrowpic:ShowWindow(1);

	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	slot2:ShowWindow(1);

    local item_text_bg = GET_CHILD_RECURSIVELY(frame, "item_text_bg");
    item_text_bg:ShowWindow(0);

    local slot1_info = GET_CHILD_RECURSIVELY(frame, "slot1_info");
    slot1_info:ShowWindow(1);

    local mat_text = GET_CHILD(slot1_info, "mat_text");
    mat_text:SetTextByKey('value', itemObj.Name);

    local ark_lv = GET_CHILD(slot1_info, "ark_lv");
    ark_lv:SetTextByKey('value', itemObj.ArkLevel);
    
    local curExp = TryGetProp(itemObj, 'ArkExp', 0);
	local valid, require_exp = shared_item_ark.get_next_lv_exp(itemObj);
    if shared_item_ark.is_max_lv(itemObj) == 'YES' then		-- max 레벨인 경우
		valid, require_exp = shared_item_ark.get_current_lv_exp(itemObj);
		curExp = require_exp;
    end

	local exp_gauge = GET_CHILD(slot1_info, "exp_gauge");
    exp_gauge:ShowWindow(1);
    exp_gauge:SetPoint(curExp, require_exp);

	SET_SLOT_ITEM(slot1, invItem);
	
	local guid = GetIESID(itemObj);
	frame:SetUserValue('SRC_ITEM_GUID', guid);
	SELECT_INV_SLOT_BY_GUID(guid, 1)
end

-- 옵션을 이전 받을 아이템 등록
function ARK_RELOCATION_REG_DEST_ITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end
    
	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return false;
	end
			
    local enable, reason = IS_ENABLE_REG_ARK_ITEM(frame, invItem);
	if enable == false then
		if reason == 'Same' then
			ui.SysMsg(ClMsg('AlreadRegSameItem'));
		elseif reason == 'ItemLock' then
			ui.SysMsg(ClMsg('MaterialItemIsLock'));
		end
		return;
	end

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local src_item = GET_SLOT_ITEM(slot1);
	if src_item == nil then
		return;
	end
	
	local src_Obj = GetIES(src_item:GetObject());
    local dest_Obj = GetIES(invItem:GetObject());

    if shared_item_ark.is_valid_condition_for_copy(dest_Obj, src_Obj) == false then
		ui.SysMsg(ClMsg('DestItemLvHigh'));
        return
    end

    local guid = frame:GetUserValue('DEST_ITEM_GUID');
    SELECT_INV_SLOT_BY_GUID(guid, 0);
    frame:SetUserValue('DEST_ITEM_GUID', 0);
	
	-- 아이템 등록
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	SET_SLOT_ITEM(slot2, invItem);
	
	local dest_guid = GetIESID(dest_Obj);
	frame:SetUserValue('DEST_ITEM_GUID', dest_guid);
	SELECT_INV_SLOT_BY_GUID(dest_guid, 1)

	local slot2_bg_image = GET_CHILD(slot2, "slot2_bg_image");
    slot2_bg_image:ShowWindow(0);
    
    local slot2_info = GET_CHILD_RECURSIVELY(frame, "slot2_info");
    slot2_info:ShowWindow(1);

    local mat_text = GET_CHILD(slot2_info, "mat_text");
    mat_text:SetTextByKey('value', dest_Obj.Name);

    local ark_lv = GET_CHILD(slot2_info, "ark_lv");
    ark_lv:SetTextByKey('value', dest_Obj.ArkLevel);
    
    local curExp = TryGetProp(dest_Obj, 'ArkExp', 0);
	local valid, require_exp = shared_item_ark.get_next_lv_exp(dest_Obj);
    if shared_item_ark.is_max_lv(dest_Obj) == 'YES' then		-- max 레벨인 경우
		valid, require_exp = shared_item_ark.get_current_lv_exp(dest_Obj);
		curExp = require_exp;
    end
	
    local exp_gauge = GET_CHILD(slot2_info, "exp_gauge");
    exp_gauge:ShowWindow(1);
    exp_gauge:SetPoint(curExp, require_exp);

	local medal_gb = GET_CHILD_RECURSIVELY(frame, "medal_gb");
    medal_gb:ShowWindow(1);    
    
    -- 이전 비용
    local lv = TryGetProp(src_Obj, 'ArkLevel', -1)
    local cost = math.floor(lv * 1000000)  -- 레벨당 100만
	local decomposecost = GET_CHILD_RECURSIVELY(medal_gb, "decomposecost");
	decomposecost:SetText(cost);
	
    -- 예상 잔액
    local remainsilver = GET_CHILD_RECURSIVELY(medal_gb, "remainsilver");
    local silver = SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), '-'..cost);
    remainsilver:SetText(silver);
end

function IS_ENABLE_REG_ARK_ITEM(frame, invItem)
	if invItem.isLockState == true then
		return false, 'ItemLock';
	end
	
	local itemObj = GetIES(invItem:GetObject());
	if TryGetProp(itemObj, 'StringArg', 'None') ~= 'Ark' then
		return false, 'Type';
	end
	
	if 0 < TryGetProp(itemObj , 'LifeTime') or 0 < TryGetProp(itemObj , 'ItemLifeTimeOver') then
		return false, 'LimitTime';
	end
	
	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local src_item = GET_SLOT_ITEM(slot1);
	if invItem == src_item then
		return false, 'Same';
	end
	
	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	local dest_item = GET_SLOT_ITEM(slot2);
	if invItem == dest_item then
		return false, 'Same';
	end
	
	return true;
end

-- 옵션 이전 버튼 클릭
function ARK_RELOCATE_BUTTON_CLICK(parent, ctrl)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	local frame = parent:GetTopParentFrame();
	local pic_bg = GET_CHILD(frame, "pic_bg");
	pic_bg:EnableHitTest(0);

	WARNINGMSGBOX_FRAME_OPEN(ClMsg('ReallyArkRelocation'), '_ARK_RELOCATE_START', '_ARK_RELOCATE_ENABLEHITTEST');
end

function _ARK_RELOCATE_ENABLEHITTEST()	
	local frame = ui.GetFrame("ark_relocation");
	local pic_bg = GET_CHILD(frame, "pic_bg");
	pic_bg:EnableHitTest(1);
end

-- 옵션 이전 조건 한번더 확인
function _ARK_RELOCATE_START()	
	local frame = ui.GetFrame("ark_relocation");

	local slot1 = GET_CHILD_RECURSIVELY(frame, "slot1");
	local src_item = GET_SLOT_ITEM(slot1);
	if src_item == nil then 
		return;
	end	
	local src_Obj = GetIES(src_item:GetObject());

	local slot2 = GET_CHILD_RECURSIVELY(frame, "slot2");
	local dest_item = GET_SLOT_ITEM(slot2);
	if dest_item == nil then 
		return;
	end	
	local dest_Obj = GetIES(dest_item:GetObject());
	
    local lv = TryGetProp(src_Obj, 'ArkLevel', -1)
    local cost = math.floor(lv * 1000000)  -- 레벨당 100만
	local silverAmountStr = tonumber(GET_TOTAL_MONEY_STR());
	if silverAmountStr - cost < 0 then
		ui.SysMsg(ClMsg("Auto_SoJiKeumi_BuJogHapNiDa."));
		return;
	end
	
	SetCraftState(1);
	ui.SetHoldUI(true);
	
	session.ResetItemList();
    session.AddItemID(dest_item:GetIESID(), 1);
    session.AddItemID(src_item:GetIESID(), 1);
    local resultlist = session.GetItemIDList();
	item.DialogTransaction("ARK_RELOCATE", resultlist);
	
	PLAY_ARK_RELOCATE_EFFECT()
end

function RELEASE_ARK_RELOCATION_UI_HOLD()
	ui.SetHoldUI(false);
end

-- 옵션 이전 성공
function ARK_RELOCATION_SUCCESS(pc, msg, dest_item_idx)
	local frame = ui.GetFrame("ark_relocation");

	local do_relocate = GET_CHILD_RECURSIVELY(frame, "do_relocate");
	do_relocate:ShowWindow(0);

	local pic_bg = GET_CHILD_RECURSIVELY(frame, "pic_bg");
	pic_bg:ShowWindow(0);

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox");
	resultGbox:ShowWindow(1);

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok");
	send_ok:ShowWindow(1);

	local result_item_pic = GET_CHILD_RECURSIVELY(frame, "result_item_pic");
	local invItem = session.GetInvItemByGuid(dest_item_idx);
	if invItem == nil then
		return
	end
	local itemObj = GetIES(invItem:GetObject());
	result_item_pic:SetImage(itemObj.Icon)
	
	ARK_RELOCATE_SUCCESS_EFFECT(frame)
end

function ARK_RELOCATE_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("ark_relocation");

	local RELOCATE_RESULT_EFFECT_NAME = frame:GetUserConfig('RELOCATE_RESULT_EFFECT_NAME');
	local RELOCATE_RESULT_EFFECT_SCALE = tonumber(frame:GetUserConfig('RELOCATE_RESULT_EFFECT_SCALE'));
	local RELOCATE_RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RELOCATE_RESULT_EFFECT_DURATION'));
	
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end

	local relocation_effect_gb = GET_CHILD_RECURSIVELY(frame, 'relocation_effect_gb');
	relocation_effect_gb:StopUIEffect('RELOCATE_EFFECT', true, 0.5);
	
	local relocation_effect_gb2 = GET_CHILD_RECURSIVELY(frame, 'relocation_effect_gb2');
	relocation_effect_gb2:StopUIEffect('RELOCATE_EFFECT', true, 0.5);

	result_effect_bg:PlayUIEffect(RELOCATE_RESULT_EFFECT_NAME, RELOCATE_RESULT_EFFECT_SCALE, 'ARK_RELOCATE_RESULT_EFFECT');
	ReserveScript("_ARK_RELOCATE_RESULT_EFFECT()", RELOCATE_RESULT_EFFECT_DURATION)
end

function _ARK_RELOCATE_RESULT_EFFECT()
	local frame = ui.GetFrame("ark_relocation");
	if frame:IsVisible() == 0 then return; end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	result_effect_bg:StopUIEffect('ARK_RELOCATE_RESULT_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
	SetCraftState(0);
end

function PLAY_ARK_RELOCATE_EFFECT()
	local frame = ui.GetFrame("ark_relocation");

	local RELOCATE_EFFECT_NAME = frame:GetUserConfig('RELOCATE_EFFECT_NAME');
	local RELOCATE_EFFECT_SCALE = tonumber(frame:GetUserConfig('RELOCATE_EFFECT_SCALE'));
	local RELOCATE_EFFECT_DURATION = tonumber(frame:GetUserConfig('RELOCATE_EFFECT_DURATION'));

	local relocation_effect_gb = GET_CHILD_RECURSIVELY(frame, 'relocation_effect_gb');
	relocation_effect_gb:ShowWindow(1);
	relocation_effect_gb:PlayUIEffect(RELOCATE_EFFECT_NAME, RELOCATE_EFFECT_SCALE, 'RELOCATE_EFFECT');

	local relocation_effect_gb2 = GET_CHILD_RECURSIVELY(frame, 'relocation_effect_gb2');
	relocation_effect_gb2:ShowWindow(1);
	relocation_effect_gb2:PlayUIEffect(RELOCATE_EFFECT_NAME, RELOCATE_EFFECT_SCALE, 'RELOCATE_EFFECT');
	
	ui.SetHoldUI(true);
	ReserveScript('RELEASE_ARK_RELOCATION_UI_HOLD()', 7);
end