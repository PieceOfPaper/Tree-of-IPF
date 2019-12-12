
function ARK_COMPOSITION_ON_INIT(addon, frame)
    addon:RegisterMsg("ARK_COMPOSITION_EXP_UP_SUCCESS", 'ARK_COMPOSITION_EXP_UP_SUCCESS');
    addon:RegisterMsg("ARK_COMPOSITION_LV_UP_SUCCESS", 'ARK_COMPOSITION_LV_UP_SUCCESS');    
end

function TOGGLE_ARK_COMPOSITION_UI(isOpen)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("ark_composition");
	frame:ShowWindow(isOpen);
end

function ARK_COMPOSITION_OPEN(frame)
	ui.OpenFrame("inventory");
	CLEAR_ARK_COMPOSITION_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ARK_COMPOSITION_INV_RBTNDOWN");
end

function ARK_COMPOSITION_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	CLEAR_ARK_COMPOSITION_UI();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	ui.CloseFrame("inventory");
    
    ui.CloseFrame('ark_composition');
end

function CLEAR_ARK_COMPOSITION_UI()
	if ui.CheckHoldedUI() == true then
		return;
    end
    
    local frame = ui.GetFrame("ark_composition");
    ARK_COMPOSITION_CLEAR_ARK_ITEM(frame)
    ARK_COMPOSITION_CLEAR_MATERIAL_ITEM(frame)
    ARK_COMPOSITION_TOGGLE_RESULT_UI(frame, 0)
end

function ARK_COMPOSITION_CLEAR_ARK_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
    end

    frame:SetUserValue('TYPE', 'None');
    
	local ark_slot = GET_CHILD_RECURSIVELY(frame, 'ark_slot')
    ark_slot:ClearIcon();    

    local guid = frame:GetUserValue('ARK_ITEM_GUID');
    if guid ~= 'None' then
        SELECT_INV_SLOT_BY_GUID(guid, 0);
    end
    frame:SetUserValue('ARK_ITEM_GUID', 0);
    
    local text = frame:GetUserConfig('ITEM_NAME_TEXT');
	local ark_name = GET_CHILD_RECURSIVELY(frame, 'ark_name');
    ark_name:ShowWindow(1);
    ark_name:SetTextByKey('value', text);

    local ark_lv_text = GET_CHILD_RECURSIVELY(frame, 'ark_lv_text');
    ark_lv_text:ShowWindow(0);

    local ark_lv = GET_CHILD_RECURSIVELY(frame, 'ark_lv');
    ark_lv:ShowWindow(0);
    
    local exp_gauge_text = GET_CHILD_RECURSIVELY(frame, 'exp_gauge_text');
    exp_gauge_text:ShowWindow(0);

    local exp_gauge = GET_CHILD_RECURSIVELY(frame, 'exp_gauge');
    exp_gauge:ShowWindow(0);

    local exp_up_text = GET_CHILD_RECURSIVELY(frame, 'exp_up_text');
    exp_up_text:ShowWindow(0);
    
    local type_text = GET_CHILD_RECURSIVELY(frame, 'type_text');
    type_text:ShowWindow(0);

    local medal_gb = GET_CHILD_RECURSIVELY(frame, 'medal_gb');
    medal_gb:ShowWindow(0);

    local do_btn = GET_CHILD_RECURSIVELY(frame, 'do_btn');
    do_btn:ShowWindow(1);

    local mat_gb = GET_CHILD(frame, "mat_gb");
    mat_gb:EnableHitTest(1);
end

function ARK_COMPOSITION_CLEAR_MATERIAL_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
    local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
    lv_mat_gb:ShowWindow(0);
    
    local exp_mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
    exp_mat_gb:ShowWindow(0);
end

-- 인벤토리에서 마우스 오른쪽 버튼 클릭
function ARK_COMPOSITION_INV_RBTNDOWN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("ark_composition");
	if frame == nil then
		return;
	end

	local icon = slot:GetIcon();
    local iconInfo = icon:GetInfo();
    local guid = iconInfo:GetIESID();
    local invItem = session.GetInvItemByGuid(guid)
	if invItem == nil then
		return false;
    end
    
    local itemObj = GetIES(invItem:GetObject());
	if TryGetProp(itemObj, 'StringArg', 'None') == 'Ark' then
		-- 합성에 사용할 아크 아이템 등록
        ARK_COMPOSITION_REG_ARK_ITEM(frame, iconInfo:GetIESID(), invItem, itemObj);
    else
        -- 합성에 사용할 재료 아이템 등록
        if frame:GetUserValue('TYPE') == 'EXP' then
            local className = shared_item_ark.get_exp_material();
            if itemObj.ClassName == className then
                ARK_COMPOSITION_REG_EXP_MATERIAL_ITEM(frame, iconInfo:GetIESID(), invItem, itemObj, className);
            end
        elseif frame:GetUserValue('TYPE') == 'LV' then
            local itemClassNameList = {};
            itemClassNameList[1], itemClassNameList[2], itemClassNameList[3] = shared_item_ark.get_require_item_list_for_lv();

            for i = 1, #itemClassNameList do
                if itemObj.ClassName == itemClassNameList[i] then
                    local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
                    local lv_mat = GET_CHILD(lv_mat_gb, "lv_mat_"..i);
                    if lv_mat == nil then return; end
                
                    local mat_slot = GET_CHILD(lv_mat, "mat_slot");
                    local needCnt = mat_slot:GetUserValue("NEED_COUNT");
                    ARK_COMPOSITION_REG_LV_UP_MATERIAL_ITEM(frame, mat_slot, invItem, itemClassNameList[i], needCnt);
                end
            end
        end
	end
end

-- 합성할 아크 아이템 Drop
function ARK_COMPOSITION_ARK_ITEM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	local frame = ui.GetFrame("ark_composition");
	if frame == nil then
		return;
    end
    
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
    if FromFrame:GetName() == 'inventory' then        
        local iconInfo = liftIcon:GetInfo();
        local guid = iconInfo:GetIESID();
        local invItem = session.GetInvItemByGuid(guid)
        if invItem == nil then
            return false;
        end
        
        local itemObj = GetIES(invItem:GetObject());
        if TryGetProp(itemObj, 'StringArg', 'None') == 'Ark' then
            ARK_COMPOSITION_REG_ARK_ITEM(frame, iconInfo:GetIESID(), invItem, itemObj);
        end
	end
end

-- 합성할 아크 아이템 등록
function ARK_COMPOSITION_REG_ARK_ITEM(frame, itemID, invItem, itemObj)
	if ui.CheckHoldedUI() == true then
		return;
    end
    
	if invItem.isLockState == true then
        ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
    end
    
    local current_lv = TryGetProp(itemObj, 'ArkLevel', -1)
    local max_lv = TryGetProp(itemObj, 'MaxArkLv', -1)

    if max_lv <= current_lv then
        ui.SysMsg(ClMsg('CantUseInMaxLv'));
        return;
    end
    
    local guid = frame:GetUserValue('ARK_ITEM_GUID');
    SELECT_INV_SLOT_BY_GUID(guid, 0);
    frame:SetUserValue('ARK_ITEM_GUID', 0);

    local exp_up_text = GET_CHILD_RECURSIVELY(frame, 'exp_up_text');
    exp_up_text:ShowWindow(0);

	local ark_slot = GET_CHILD_RECURSIVELY(frame, "ark_slot");
    SET_SLOT_ITEM(ark_slot, invItem);

    local ark_name = GET_CHILD_RECURSIVELY(frame, "ark_name");
    ark_name:SetTextByKey('value', "");
    ark_name:SetTextByKey('value', itemObj.Name);
    
    local ark_lv_text = GET_CHILD_RECURSIVELY(frame, "ark_lv_text");
    ark_lv_text:ShowWindow(1);

    local ark_lv = GET_CHILD_RECURSIVELY(frame, "ark_lv");
    ark_lv:ShowWindow(1);
    ark_lv:SetTextByKey('value', "");
    ark_lv:SetTextByKey('value', itemObj.ArkLevel);

    local exp_gauge_text = GET_CHILD_RECURSIVELY(frame, "exp_gauge_text");
    exp_gauge_text:ShowWindow(1);

    local curExp = TryGetProp(itemObj, 'ArkExp', 0);
    local valid, require_exp = shared_item_ark.get_next_lv_exp(itemObj);
	if shared_item_ark.is_max_lv(itemObj) == 'YES' then		-- max 레벨인 경우
		valid, require_exp = shared_item_ark.get_current_lv_exp(itemObj);
		curExp = require_exp;
	end
    
    local exp_gauge = GET_CHILD_RECURSIVELY(frame, "exp_gauge");
    exp_gauge:ShowWindow(1);
    exp_gauge:SetPoint(curExp, require_exp);

    local typetext = frame:GetUserConfig('COMPOSITION_TYPE_LV');
    if curExp < require_exp then
        typetext = frame:GetUserConfig('COMPOSITION_TYPE_EXP');
    end

    local type_text = GET_CHILD_RECURSIVELY(frame, "type_text");
    type_text:ShowWindow(1);
    type_text:SetTextByKey('value', "");
    type_text:SetTextByKey('value', typetext);

    local decomposecost_text = GET_CHILD_RECURSIVELY(frame, "decomposecost_text");
    decomposecost_text:SetTextByKey('value', "");
    decomposecost_text:SetTextByKey('value', typetext);    

    SELECT_INV_SLOT_BY_GUID(itemID, 1);
    frame:SetUserValue('ARK_ITEM_GUID', itemID);

    local medal_gb = GET_CHILD_RECURSIVELY(frame, 'medal_gb');
    medal_gb:ShowWindow(0);

    if curExp < require_exp then
        frame:SetUserValue('TYPE', 'EXP');
        ARK_EXP_UP_MATERIAL_INIT(frame, itemObj);
    else
        frame:SetUserValue('TYPE', 'LV');
        ark_lv:SetTextByKey('value', "");
        ark_lv:SetTextByKey('value', current_lv.. "   {img white_right_arrow 16 16}   ".. current_lv + 1);
    
        ARK_LV_UP_MATERIAL_INIT(frame, itemObj);
    end
end

function ARK_COMPOSITION_REG_EXP_MATERIAL_ITEM(frame, itemID, invItem, itemObj, itemClassName)
	if invItem.isLockState == true then
        ui.SysMsg(ClMsg('MaterialItemIsLock'));
        return;
    end

    local itemObj = GetIES(invItem:GetObject());
    if itemObj.ClassName ~= itemClassName then
        ui.SysMsg(ClMsg('NotEnoughTarget'));
        return;
    end
    local guid = GetIESID(itemObj);

    local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", invItem.count);
    local inputstringframe = ui.GetFrame("inputstring");
    inputstringframe:SetUserValue("ITEM_CLASSNAME", itemObj.ClassName);
    inputstringframe:SetUserValue("SLOT_NUMBER", 1);
    inputstringframe:SetUserValue("ITEM_GUID", guid);
    INPUT_NUMBER_BOX(inputstringframe, titleText, "CHECK_ARK_EXP_UP_MATERIAL_ITEMDROP", 1, 1, invItem.count, 1);
end

-- 아크 아이템 등록 취소
function ARK_COMPOSITION_ARK_ITEM_REMOVE(frame, icon)
    if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local ark_slot = GET_CHILD_RECURSIVELY(frame, "ark_slot");

    CLEAR_ARK_COMPOSITION_UI();
end

-- 경험치 증가에 필요한 재료 아이템 UI 설정
function ARK_EXP_UP_MATERIAL_INIT(frame, itemObj)
    local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
    lv_mat_gb:ShowWindow(0);

    local exp_mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
    exp_mat_gb:ShowWindow(1);

    local curExp = TryGetProp(itemObj, 'ArkExp', 0);
    local valid, require_exp = shared_item_ark.get_next_lv_exp(itemObj);
	if shared_item_ark.is_max_lv(itemObj) == 'YES' then		-- max 레벨인 경우
		valid, require_exp = shared_item_ark.get_current_lv_exp(itemObj);
		curExp = require_exp;
	end

    local remainderexp = require_exp - curExp;
    
    local matClassName = shared_item_ark.get_exp_material();    
    ARK_EXP_UP_MATERIAL_INFO(frame, 1, matClassName, remainderexp)

    local medal_gb = GET_CHILD(frame, "medal_gb");
    medal_gb:ShowWindow(1);
    
    -- 비용
    local cost = 0;
	local decomposecost = GET_CHILD_RECURSIVELY(medal_gb, "decomposecost");
	decomposecost:SetText(cost);
	
    -- 예상 잔액
    local remainsilver = GET_CHILD_RECURSIVELY(medal_gb, "remainsilver");
    local silver = SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), '-'..cost);
    remainsilver:SetText(silver);
end

-- 레벨 증가에 필요한 재료 아이템 UI 설정
function ARK_LV_UP_MATERIAL_INIT(frame, itemObj)
    local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
    lv_mat_gb:ShowWindow(1);

    local exp_mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
    exp_mat_gb:ShowWindow(0);

    local current_lv = TryGetProp(itemObj, 'ArkLevel', -1)
    local max_lv = TryGetProp(itemObj, 'MaxArkLv', -1)

    local transcend, arcane, siera = shared_item_ark.get_require_item_list_for_lv()
    local transcend_count, arcane_count, siera_count = shared_item_ark.get_require_count_for_next_lv(current_lv + 1 , max_lv)
    
    ARK_LV_UP_MATERIAL_INFO(frame, 1, transcend, transcend_count)
    ARK_LV_UP_MATERIAL_INFO(frame, 2, arcane, arcane_count)
    ARK_LV_UP_MATERIAL_INFO(frame, 3, siera, siera_count)
    
    local curExp = TryGetProp(itemObj, 'ArkExp', 0);
    local valid, require_exp = shared_item_ark.get_next_lv_exp(itemObj);
    if shared_item_ark.is_max_lv(itemObj) == 'YES' then		-- max 레벨인 경우
		valid, require_exp = shared_item_ark.get_current_lv_exp(itemObj);
		curExp = require_exp;
    end

    local counttext = string.format("%d / %d", 0, require_exp - curExp)
end

-- 경험치 증가 재료 SLOT에 아이콘, 필요 개 수 등 정보 설정
function ARK_EXP_UP_MATERIAL_INFO(frame, slotNum, itemClassName, remainderexp)
    local matCls = GetClass('Item', itemClassName);

    local exp_mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
    local exp_mat = GET_CHILD(exp_mat_gb, "exp_mat_"..slotNum);

    local mat_slot = GET_CHILD(exp_mat, "mat_slot");
    mat_slot:SetUserValue('ITEM_GUID', 'None');
    mat_slot:SetEventScript(ui.DROP, 'DROP_ARK_EXP_UP_MATERIAL');
    mat_slot:SetEventScriptArgString(ui.DROP, itemClassName);
    mat_slot:SetEventScriptArgNumber(ui.DROP, remainderexp);
    
    mat_slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_ARK_MATERIAL');
    mat_slot:SetEventScriptArgString(ui.RBUTTONUP, itemClassName);
    mat_slot:SetEventScriptArgNumber(ui.RBUTTONUP, remainderexp);

	local icon = imcSlot:SetImage(mat_slot, matCls.Icon);
    icon:SetColorTone('FFFF0000');

    local mat_text = GET_CHILD(exp_mat, "mat_text");
    mat_text:SetTextByKey('value', matCls.Name);

    mat_slot:SetText('{s16}{ol}{b} '..remainderexp, 'count', ui.RIGHT, ui.BOTTOM, -5, -5);
    mat_slot:SetUserValue("REMAINDER_EXP", remainderexp);
end

-- 레벨 증가 재료 SLOT에 아이콘, 필요 개 수 등 정보 설정
function ARK_LV_UP_MATERIAL_INFO(frame, slotNum, itemClassName, needCnt)
    local matCls = GetClass('Item', itemClassName);

    local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
    local lv_mat = GET_CHILD(lv_mat_gb, "lv_mat_"..slotNum);
    if lv_mat == nil then
        return;
    end

    local mat_slot = GET_CHILD(lv_mat, "mat_slot");
    mat_slot:SetUserValue('ITEM_GUID', 'None');
    mat_slot:SetEventScript(ui.DROP, 'DROP_ARK_LV_UP_MATERIAL');
    mat_slot:SetEventScriptArgString(ui.DROP, itemClassName);
    mat_slot:SetEventScriptArgNumber(ui.DROP, needCnt);
    mat_slot:SetUserValue('NEED_COUNT', needCnt);
    
    mat_slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_ARK_MATERIAL');
    mat_slot:SetEventScriptArgString(ui.RBUTTONUP, itemClassName);
	mat_slot:SetEventScriptArgNumber(ui.RBUTTONUP, needCnt);

	local icon = imcSlot:SetImage(mat_slot, matCls.Icon);
    icon:SetColorTone('FFFF0000');

    local mat_text = GET_CHILD(lv_mat, "mat_text");
    mat_text:SetTextByKey('value', matCls.Name);

    mat_slot:SetText('{s16}{ol}{b} '..needCnt, 'count', ui.RIGHT, ui.BOTTOM, -5, -5);
end

-- 경험치 증가 재료 Drop
function DROP_ARK_EXP_UP_MATERIAL(parent, ctrl, itemClassName, remainderexp)
    if ui.CheckHoldedUI() == true then
		return;
    end

	local frame = ui.GetFrame("ark_composition");
	if frame == nil then
		return;
    end

    local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
    if FromFrame:GetName() == 'inventory' then        
        local iconInfo = liftIcon:GetInfo();
        local guid = iconInfo:GetIESID();
        local invItem = session.GetInvItemByGuid(guid)
        
        if invItem == nil then
            return false;
        end

        ARK_COMPOSITION_REG_EXP_MATERIAL_ITEM(frame, iconInfo:GetIESID(), invItem, itemObj, itemClassName);
    end
end

-- 경험치 증가 재료 등록 
function CHECK_ARK_EXP_UP_MATERIAL_ITEMDROP(parent, cost)
    local slotNum = parent:GetUserValue('SLOT_NUMBER');
    
    local frame = ui.GetFrame("ark_composition");
    local mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
    local mat_set = GET_CHILD(mat_gb, "exp_mat_"..slotNum);
    local mat_slot = GET_CHILD(mat_set, "mat_slot", 'ui::CSlot');

    local strlist = StringSplit(mat_slot:GetText(), ' ');
    local maxCnt = tonumber(strlist[2]);

    if maxCnt < tonumber(cost) then
        cost = maxCnt;
    end

    mat_slot:SetText('{s16}{ol}{b} '..cost, 'count', ui.RIGHT, ui.BOTTOM, -5, -5);
    
    local icon = mat_slot:GetIcon();
    icon:SetColorTone('FFFFFFFF');

    local medal_gb = GET_CHILD_RECURSIVELY(frame, 'medal_gb');
    local decomposecost = GET_CHILD_RECURSIVELY(medal_gb, "decomposecost");
	decomposecost:SetText(cost);
	
	-- 예상 잔액
    local remainsilver = GET_CHILD_RECURSIVELY(medal_gb, "remainsilver");
    local silver = SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), '-'..cost);
    remainsilver:SetText(silver);
    
    local exp_up_text = GET_CHILD_RECURSIVELY(frame, 'exp_up_text');
    exp_up_text:ShowWindow(1);
    exp_up_text:SetTextByKey('value', cost);

    mat_slot:SetUserValue('EXP_UP_MATERIAL_COUNT', cost)

    local guid = parent:GetUserValue('ITEM_GUID');
    mat_slot:SetUserValue('ITEM_GUID', guid);
end

-- 레벨 증가 재료 Drop
function DROP_ARK_LV_UP_MATERIAL(parent, ctrl, itemClassName, needCnt)
    if ui.CheckHoldedUI() == true then
		return;
    end
    
	local frame = ui.GetFrame("ark_composition");
	if frame == nil then
		return;
    end
    
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
    if FromFrame:GetName() == 'inventory' then        
        local iconInfo = liftIcon:GetInfo();
        local guid = iconInfo:GetIESID();
        local invItem = session.GetInvItemByGuid(guid)
        if invItem == nil then
            return false;
        end
        
	    if invItem.isLockState == true then
            ui.SysMsg(ClMsg('MaterialItemIsLock'));
		    return;
        end
        
        ARK_COMPOSITION_REG_LV_UP_MATERIAL_ITEM(frame, ctrl, invItem, itemClassName, needCnt)
    end
end

-- slot에 레벨 증가 재료 아이템 등록 
function ARK_COMPOSITION_REG_LV_UP_MATERIAL_ITEM(frame, slot, invItem, itemClassName, needCnt)
    if slot == nil then
        return;
    end
    slot = tolua.cast(slot, 'ui::CSlot');

    local itemObj = GetIES(invItem:GetObject());
    if itemObj.ClassName ~= itemClassName then
        ui.SysMsg(ClMsg('NotEnoughTarget'));
        return;
    end
    
    local curcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value = itemObj.ClassName}
    }, false);

    if curcnt < tonumber(needCnt) then
        ui.SysMsg(ClMsg('NotEnoughRecipe'));
        return;
    end

    local icon = slot:GetIcon();
    icon:SetColorTone('FFFFFFFF');

	local guid = GetIESID(itemObj);
    slot:SetUserValue("ITEM_GUID", guid);
end

-- 재료 등록 해제 
function REMOVE_ARK_MATERIAL(parent, ctrl, itemClassName, needCnt)
    ctrl = tolua.cast(ctrl, 'ui::CSlot');
    
    local frame = parent:GetTopParentFrame();
    local remainderexp = ctrl:GetUserValue('REMAINDER_EXP');
    if frame:GetUserValue('TYPE') == 'EXP' and remainderexp ~= 'None' then
        ctrl:SetText('{s16}{ol}{b} '..remainderexp, 'count', ui.RIGHT, ui.BOTTOM, -5, -5);

        local medal_gb = GET_CHILD_RECURSIVELY(frame, 'medal_gb');

        -- 비용
        local cost = 0;
	    local decomposecost = GET_CHILD_RECURSIVELY(medal_gb, "decomposecost");
	    decomposecost:SetText(cost);
	
        -- 예상 잔액
        local remainsilver = GET_CHILD_RECURSIVELY(medal_gb, "remainsilver");
        local silver = SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), '-'..cost);
        remainsilver:SetText(silver);
        
        local exp_up_text = GET_CHILD_RECURSIVELY(frame, 'exp_up_text');
        exp_up_text:ShowWindow(0);

        ctrl:SetUserValue('EXP_UP_MATERIAL_COUNT', 0);
    end

    ctrl:SetUserValue("ITEM_GUID", 'None');

    local icon = ctrl:GetIcon();
    icon:SetColorTone('FFFF0000');
end

-- 합성 버튼 클릭
function ARK_COMPOSITION_BUTTON_CLICK(parent, ctrl)
	if ui.CheckHoldedUI() == true then
		return;
    end

    local frame = parent:GetTopParentFrame();
    
    local ark_guid = frame:GetUserValue('ARK_ITEM_GUID');
    if ark_guid == 'None' or ark_guid == '0' then
        return;
    end

    local decomposecost = GET_CHILD_RECURSIVELY(frame, "decomposecost");
    if IsGreaterThanForBigNumber(decomposecost:GetText(), GET_TOTAL_MONEY_STR()) == 1 then
        ui.SysMsg(ClMsg("Auto_SoJiKeumi_BuJogHapNiDa."));
        return;
    end

    local type = frame:GetUserValue('TYPE');
    if type == 'EXP' then
        local countList = NewStringList();

        -- 재료 아이템 1개가 모두 등록됬는지 확인
        for i = 1, 1 do
            local exp_mat_gb = GET_CHILD_RECURSIVELY(frame, "exp_mat_gb");
            local exp_mat = GET_CHILD(exp_mat_gb, "exp_mat_"..i);
            local mat_slot = GET_CHILD(exp_mat, "mat_slot");
            local guid = mat_slot:GetUserValue('ITEM_GUID');
            if guid == 'None' then
                ui.SysMsg(ClMsg('NotEnoughRecipe'));
                return;
            end

            local count = mat_slot:GetUserIValue('EXP_UP_MATERIAL_COUNT');
            if count <= 0 then
                ui.SysMsg(ClMsg('NotEnoughRecipe'));
                return;
            end
            countList:Add(count);
        end

        session.ResetItemList();
        session.AddItemID(ark_guid, 1);

    	local resultlist = session.GetItemIDList()
        item.DialogTransaction("ARK_COMPOSITION_EXP", resultlist, "", countList)
        
        PLAY_ARK_COMPOSITION_EFFECT();
    elseif type == 'LV' then
        -- 재료 아이템 3개가 모두 등록됬는지 확인
        for i = 1, 3 do
            local lv_mat_gb = GET_CHILD_RECURSIVELY(frame, "lv_mat_gb");
            local lv_mat = GET_CHILD(lv_mat_gb, "lv_mat_"..i);
            local mat_slot = GET_CHILD(lv_mat, "mat_slot");
            local guid = mat_slot:GetUserValue('ITEM_GUID');
            if guid == 'None' then
                ui.SysMsg(ClMsg('NotEnoughRecipe'));
                return;
            end
        end

	    session.ResetItemList();
        session.AddItemID(ark_guid, 1);

        local resultlist = session.GetItemIDList();
	    item.DialogTransaction("ARK_COMPOSITION_LV", resultlist);
           
        PLAY_ARK_COMPOSITION_EFFECT();
    end    
end

function ARK_COMPOSITION_EXP_UP_SUCCESS(pc, msg, guid)
    local frame = ui.GetFrame("ark_composition");

    local invItem = session.GetInvItemByGuid(guid)
    if invItem == nil then
        return false;
    end

    local itemObj = GetIES(invItem:GetObject());
    if itemObj == nil then
        return false;
    end

    COMPOSITION_SUCCESS_EFFECT(frame, itemObj);
end

function ARK_COMPOSITION_LV_UP_SUCCESS(pc, msg, guid)
    local frame = ui.GetFrame("ark_composition");

    local invItem = session.GetInvItemByGuid(guid)
    if invItem == nil then
        return false;
    end

    local itemObj = GetIES(invItem:GetObject());
    if itemObj == nil then
        return false;
    end

    COMPOSITION_SUCCESS_EFFECT(frame, itemObj);
end

function PLAY_ARK_COMPOSITION_EFFECT()
	local frame = ui.GetFrame("ark_composition");

	local COMPOSITION_EFFECT_NAME = frame:GetUserConfig('COMPOSITION_EFFECT_NAME');
	local COMPOSITION_EFFECT_SCALE = tonumber(frame:GetUserConfig('COMPOSITION_EFFECT_SCALE'));
	local COMPOSITION_EFFECT_DURATION = tonumber(frame:GetUserConfig('COMPOSITION_EFFECT_DURATION'));
	local effect_gb = GET_CHILD_RECURSIVELY(frame, 'effect_gb');
	effect_gb:ShowWindow(1);
    effect_gb:PlayUIEffect(COMPOSITION_EFFECT_NAME, COMPOSITION_EFFECT_SCALE, 'COMPOSITION_EFFECT');
    
    local mat_gb = GET_CHILD(frame, "mat_gb");
    mat_gb:EnableHitTest(0);

    SetCraftState(1);
    ui.SetHoldUI(true);
    ReserveScript('RELEASE_COMPOSITION_UI_HOLD()', 5);
end

function RELEASE_COMPOSITION_UI_HOLD()
    ui.SetHoldUI(false);
    SetCraftState(0);
end

function COMPOSITION_SUCCESS_EFFECT(frame, itemObj)
    local frame = ui.GetFrame("ark_composition");

	local RESULT_EFFECT_NAME = frame:GetUserConfig('RESULT_EFFECT_NAME');
	local RESULT_EFFECT_SCALE = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE'));
    local RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
	
    local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox');
	if resultGbox == nil then
		return;
    end

	local frame = ui.GetFrame("ark_composition");
    local effect_gb = GET_CHILD_RECURSIVELY(frame, 'effect_gb');
	effect_gb:StopUIEffect('COMPOSITION_EFFECT', true, 0);
    
    ARK_COMPOSITION_TOGGLE_RESULT_UI(frame, 1);

    local result_item_pic = GET_CHILD_RECURSIVELY(frame, 'result_item_pic');
    result_item_pic:SetImage(itemObj.Icon);

    ui.SetHoldUI(true);
	resultGbox:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE, 'RESULT_EFFECT');
    ReserveScript("_COMPOSITION_SUCCESS_EFFECT()", RESULT_EFFECT_DURATION)
end

function  _COMPOSITION_SUCCESS_EFFECT()
	local frame = ui.GetFrame("ark_composition");
	if frame:IsVisible() == 0 then return; end
    
	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox');
	resultGbox:StopUIEffect('RESULT_EFFECT', true, 0.5);
    RELEASE_COMPOSITION_UI_HOLD()
end

function ARK_COMPOSITION_TOGGLE_RESULT_UI(frame, toggle)
    local ark_gb = GET_CHILD(frame, 'ark_gb');
    ark_gb:ShowWindow(1 - toggle);

    local do_btn = GET_CHILD(frame, 'do_btn');
    do_btn:ShowWindow(1 - toggle);

    local resultGbox = GET_CHILD(frame, 'resultGbox');
    resultGbox:ShowWindow(toggle);

    local send_ok = GET_CHILD(frame, 'send_ok');
    send_ok:ShowWindow(toggle);    
end