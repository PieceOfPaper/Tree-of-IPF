function ITEMSANDRA_4LINE_REVERT_RANDOM_ON_INIT(addon, frame)
	addon:RegisterMsg("SUCCESS_SANDRA_4LINE_REVERT_RANDOM_OPTION", "SUCCESS_SANDRA_4LINE_REVERT_RANDOM_OPTION");
end

-- 산드라의 완벽한 돋보기 아이템을 이용해서 UI 오픈
function OPEN_SANDRA_4LINE_REVERT_RANDOM(invItem)
	for i = 1, #revertrandomitemlist do
		local frame = ui.GetFrame(revertrandomitemlist[i]);
		if frame ~= nil and frame:IsVisible() == 1 and revertrandomitemlist[i] ~= "itemsandra_4line_revert_random" then
			return;
		end
	end

	local frame = ui.GetFrame('itemsandra_4line_revert_random');
	frame:SetUserValue('REVERTITEM_GUID', invItem:GetIESID());	 
	frame:ShowWindow(1);
end

function ITEM_SANDRA_4LINE_REVERT_RANDOM_OPEN(frame)
	ui.OpenFrame("inventory");

	CLEAR_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI();
	local tab = GET_CHILD_RECURSIVELY(ui.GetFrame("inventory"), "inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(0); -- 인벤토리의 모두보기 탭으로 이동

	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEM_SANDRA_4LINE_REVERT_RANDOM_INV_RBTN");
end

function ITEM_SANDRA_4LINE_REVERT_RANDOM_CLOSE(frame)
	if ui.CheckHoldedUI() == true then return; end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
end

-- UI 초기화
function CLEAR_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemsandra_4line_revert_random");
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok");
	sendOK:ShowWindow(0);

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom");
	do_revertrandom:ShowWindow(1);

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem");
	putOnItem:ShowWindow(1);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image");
	slot_bg_image:ShowWindow(1);
		
	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname");
	itemName:SetText("");

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1);
	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0);
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();

	UPDATE_REMAIN_SANDRA_GLASS_4LINE_COUNT(frame);
end

-- 감정 후 확인 버튼 클릭시 UI 갱신
function SENDOK_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemsandra_4line_revert_random");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	slot:ClearIcon();
	
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok");
	sendOK:ShowWindow(0);

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom");
	do_revertrandom:ShowWindow(1);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image");
	slot_bg_image:ShowWindow(1);

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1);
	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:RemoveAllChild();

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0);
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:RemoveAllChild();

	ITEM_SANDRA_4LINE_REVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID());
end

-- 슬롯에 아이템 드랍
function ITEM_SANDRA_4LINE_REVERT_RANDOM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	CLEAR_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI();

	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();

		local invItem = session.GetInvItemByGuid(iconInfo:GetIESID());
		if invItem == nil then return; end
		local itemObj = GetIES(invItem:GetObject());
		if IS_ENABLE_4LINE_REVERT_RANDOM_ITEM(itemObj) ~= true then
			return;
		end

		ITEM_SANDRA_4LINE_REVERT_RANDOM_REG_TARGETITEM(toFrame, iconInfo:GetIESID());
	end
end

-- 슬롯에 아이템 등록 시 아이템 옵션 관련 UI 정보 갱신
function ITEM_SANDRA_4LINE_REVERT_RANDOM_REG_TARGETITEM(frame, itemID)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local invItem = session.GetInvItemByGuid(itemID);
	if invItem == nil then return; end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID);

	if TryGetProp(itemCls, "NeedRandomOption") == nil or itemCls.NeedRandomOption ~= 1 then
		ui.SysMsg(ClMsg("NotAllowedRandomReset"));
		return;
	end

	local pc = GetMyPCObject();
	if pc == nil then return; end

	local obj = GetIES(invItem:GetObject());
	if IS_NEED_APPRAISED_ITEM(obj) == true or IS_NEED_RANDOM_OPTION_ITEM(obj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end
		
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local invframe = ui.GetFrame("inventory");

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem");
	putOnItem:ShowWindow(0);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image");
	slot_bg_image:ShowWindow(0);

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname");
	itemName:SetText(obj.Name);

	local gBox = GET_CHILD_RECURSIVELY(frame:GetTopParentFrame(), "bodyGbox1_1");
	local ypos = 0;
	local cnt = 0;
	for i = 1 , MAX_RANDOM_OPTION_COUNT do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None';
		
		if obj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif obj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif obj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if obj[propValue] ~= 0 and obj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(obj[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, obj[propValue], 0);
			
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl);
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y");
			itemClsCtrl:Move(0, i * pos_y);
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo);

			ypos = i * pos_y + propertyList:GetHeight() + 5;			
			cnt = cnt + 1;
		end
	end

	local isAbleExchange = 1;
	if obj.MaxDur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET or obj.Dur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET then
		isAbleExchange = -2;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
end

-- 재감정 버튼 클릭
function ITEM_SANDRA_4LINE_REVERT_RANDOM_EXEC(frame)
	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);

	if invItem == nil then
		return;
	end

	local curcount = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'StringArg', Value ='Sandra_Glass_MAX_4line'}
	}, false);

	if curcount == 0 then
		ui.SysMsg(ClMsg("LackOfSandra4LineRevertRandomMaterial"));
		return;
	end

	if invItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local clmsg = ScpArgMsg("DoSandra4LineRandomResetOptionCountNoReset")
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEM_SANDRA_4LINE_REVERT_RANDOM_EXEC", "_ITEM_SANDRA_4LINE_REVERT_RANDOM_CANCEL");
end

function _ITEM_SANDRA_4LINE_REVERT_RANDOM_CANCEL()
	
end

function _ITEM_SANDRA_4LINE_REVERT_RANDOM_EXEC()
	local frame = ui.GetFrame("itemsandra_4line_revert_random");
	if frame:IsVisible() == 0 then return; end
	
	local isAbleExchange = frame:GetUserIValue("isAbleExchange");
	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', itemObj.ClassID);

	if itemCls.NeedRandomOption ~= 1 then
		ui.SysMsg(ClMsg("NotAllowedRandomReset"));
		return;
	end

	if ui.GetFrame("apps") ~= nil then
		ui.CloseFrame("apps");
	end

	session.ResetItemList();
	session.AddItemID(frame:GetUserValue('REVERTITEM_GUID'));
	session.AddItemID(invItem:GetIESID());
	local resultlist = session.GetItemIDList();

	item.DialogTransaction("REVERT_ITEM_OPTION", resultlist);

	return;
end

function SUCCESS_SANDRA_4LINE_REVERT_RANDOM_OPTION(frame, msg, argStr, argNum)
	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then return; end

	pic_bg:PlayUIEffect(RESET_SUCCESS_EFFECT_NAME, EFFECT_SCALE, 'RESET_SUCCESS_EFFECT');

	local do_revertrandom = GET_CHILD_RECURSIVELY(frame, "do_revertrandom");
	do_revertrandom:ShowWindow(0);

	ui.SetHoldUI(true);

	ReserveScript("_SUCCESS_SANDRA_4LINE_REVERT_RANDOM_OPTION()", EFFECT_DURATION)
end

function _SUCCESS_SANDRA_4LINE_REVERT_RANDOM_OPTION()
	ui.SetHoldUI(false);
	local frame = ui.GetFrame("itemsandra_4line_revert_random");
	if frame:IsVisible() == 0 then return; end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	local RESET_SUCCESS_EFFECT_NAME = frame:GetUserConfig('RESET_SUCCESS_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then return; end
	pic_bg:StopUIEffect('RESET_SUCCESS_EFFECT', true, 0.5);

	local item = GetIES(invItem:GetObject());

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok");
	sendOK:ShowWindow(1);

	local gbox = frame:GetChild("gbox");
	invItem = GET_SLOT_ITEM(slot);
	local invItemGUID = invItem:GetIESID();
	local resetInvItem = session.GetInvItemByGuid(invItemGUID);
	if resetInvItem == nil then
		resetInvItem = session.GetEquipItemByGuid(invItemGUID);
	end

	local obj = GetIES(resetInvItem:GetObject());

	local refreshScp = obj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end
	
	-- 변경 후 옵션 UI 변경
	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_1");
    local ypos = 0;
	for i = 1 , MAX_RANDOM_OPTION_COUNT do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None';
		
		if obj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif obj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif obj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'			
		elseif obj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if obj[propValue] ~= 0 and obj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(obj[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, obj[propValue], 0);
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl);
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y");
			itemClsCtrl:Move(0, i * pos_y);
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo);
            ypos = i * pos_y + propertyList:GetHeight() + 5;
		end
	end

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(0);
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(1);

	UPDATE_REMAIN_SANDRA_GLASS_4LINE_COUNT(frame);

	return;
end

-- 보유한 돋보기 갯 수 출력
function UPDATE_REMAIN_SANDRA_GLASS_4LINE_COUNT(frame)
	local itemHaveCount = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'StringArg', Value ='Sandra_Glass_MAX_4line'}
	}, false);
	
	local text_havematerial = GET_CHILD_RECURSIVELY(frame, "text_havematerial");
	text_havematerial:SetTextByKey("count", itemHaveCount);
end

-- 슬롯에서 마우스 오른쪽 버튼클릭 시 등록된 아이템 해제
function REMOVE_SANDRA_4LINE_REVERT_RANDOM_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI();
end

-- 인벤토리에서 마우스 오른쪽 버튼을 이용해 슬롯에 아이템 등록
function ITEM_SANDRA_4LINE_REVERT_RANDOM_INV_RBTN(itemObj, slot)	
	local frame = ui.GetFrame("itemsandra_4line_revert_random");
	if frame == nil then
		return;
	end

	if IS_ENABLE_4LINE_REVERT_RANDOM_ITEM(itemObj) ~= true then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	
	CLEAR_ITEM_SANDRA_4LINE_REVERT_RANDOM_UI();

	ITEM_SANDRA_4LINE_REVERT_RANDOM_REG_TARGETITEM(frame, iconInfo:GetIESID()); 
end

-- 산드라의 완벽한 돋보기 사용 가능 아이템 확인
function IS_ENABLE_4LINE_REVERT_RANDOM_ITEM(itemObj)
	if TryGetProp(itemObj, 'UseLv', 1) ~= 430 then
		ui.SysMsg(ScpArgMsg('CanUseLV430'));
		return false;
	end

	if 4 < GET_RANDOM_OPTION_COUNT(itemObj) then
		ui.SysMsg(ClMsg("4lineRevertRandomItemEnableRandomOptionCount"));
		return false;
	end

	return true;
end