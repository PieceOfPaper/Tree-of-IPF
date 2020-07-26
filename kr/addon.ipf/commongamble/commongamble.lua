function COMMONGAMBLE_ON_INIT(addon, frame)
    addon:RegisterMsg("COMMON_GAMBLE_ITEM_GET", "ON_COMMON_GAMBLE_ITEM_GET");
end

-- UI 오픈
function COMMON_GAMBLE_OPEN(gamble_type)
	local frame = ui.GetFrame("commongamble");

	COMMON_GAMBLE_INIT(frame, gamble_type);
	frame:ShowWindow(1);
end

function COMMON_GAMBLE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
        return;
	end

	STOP_commongamble();

	ui.CloseFrame("commongamble");
end

function COMMON_GAMBLE_INIT(frame, gamble_type)
	if ui.CheckHoldedUI() == true then
        return;
	end

	local gambleCls = GetClassByType("gamble_list", gamble_type);

	local title_text = GET_CHILD_RECURSIVELY(frame, "title_text");
	local title = TryGetProp(gambleCls, "Desc");
	title_text:SetTextByKey("value", title);

	local resultslot = GET_CHILD_RECURSIVELY(frame, "resultslot");
    resultslot:ClearIcon();
	resultslot:SetText("");
	
	local slot_gb = GET_CHILD(frame, "slot_gb");
	local slot_gb_childCnt = slot_gb:GetChildCount();
	for i = 0, slot_gb_childCnt - 2 do
		local itemslot = GET_CHILD(slot_gb, "slot"..i);
		if itemslot ~= nil then
			itemslot:ClearIcon();
        	itemslot:SetText("");
		end
	end

	-- 뽑기 타입에 따라 제공되는 보상의 수량 및 뽑기 아이템 slot 설정
	local RewardItemCount = TryGetProp(gambleCls, "RewardItemCount");
	local RewardItemStr = StringSplit(TryGetProp(gambleCls, "RewardItemList"), ';');
	for i = 0, RewardItemCount - 1 do
		local itemslot = GET_CHILD(slot_gb, "slot"..i);
		local itemStrlist = StringSplit(RewardItemStr[i+1], '/');
		local itemClassName = itemStrlist[1];
		local itemCls = GetClass("Item", itemClassName);
		if itemCls ~= nil then
			local itemCnt = itemStrlist[2];

			SET_SLOT_ITEM_INFO(itemslot, itemCls, itemCnt,'{s20}{ol}{b}{ds}', -11, -10);  
			itemslot:SetUserValue("ITEM_CLASSID", itemCls.ClassID);
			itemslot:SetUserValue("ITEM_COUNT", itemCnt);
			
			local icon = itemslot:GetIcon();
			icon:SetDisableSlotSize(true);
			icon:SetReducedvalue(10, 10);
		end
	end

	-- 재료 아이템 slot 설정
	local consumeitem_gb = GET_CHILD(frame, "consumeitem_gb");
	local consumeitem_gb_childCnt = consumeitem_gb:GetChildCount();
	for i = 0, consumeitem_gb_childCnt - 2 do
		local itemslot = GET_CHILD(consumeitem_gb, "consumeslot"..i);
		if itemslot ~= nil then
			itemslot:ClearIcon();
			itemslot:SetText("");
		end
	end

	local ConsumeItemCount = TryGetProp(gambleCls, "ConsumeItemCount");
	local ConsumeItemStr = StringSplit(TryGetProp(gambleCls, "ConsumeItem"), ';');	
	for i = 0, ConsumeItemCount - 1 do
		local itemslot = GET_CHILD(consumeitem_gb, "consumeslot"..i);
		local itemStrlist = StringSplit(ConsumeItemStr[i+1], '/');
		local itemClassName = itemStrlist[1];
		local itemCls = GetClass("Item", itemClassName);
		if itemCls ~= nil then
			local itemCnt = itemStrlist[2];

			SET_SLOT_ITEM_INFO(itemslot, itemCls, itemCnt,'{s20}{ol}{b}{ds}', -11, -10);  
			itemslot:SetUserValue("ITEM_CLASSID", itemCls.ClassID);
			itemslot:SetUserValue("ITEM_COUNT", itemCnt);
			
			local icon = itemslot:GetIcon();
			icon:SetDisableSlotSize(true);
			icon:SetReducedvalue(10, 10);
		end
	end

	-- 뽑기 버튼에 현재 뽑기 type에 따른 스크립트 호출 할 수 있도록 지정
	local one_btn = GET_CHILD_RECURSIVELY(frame, "one_btn");
	one_btn:SetEventScript(ui.LBUTTONDOWN, "COMMON_GAMBLE_OK_BTN_CLICK");
	one_btn:SetEventScriptArgNumber(ui.LBUTTONDOWN, gamble_type);

	-- 자동 뽑기 관련
	local auto_btn = GET_CHILD_RECURSIVELY(frame, "auto_btn");
	auto_btn:SetEventScript(ui.LBUTTONDOWN, "AUTO_COMMON_GAMBLE_START_BTN_CLICK");
	auto_btn:SetEventScriptArgNumber(ui.LBUTTONDOWN, gamble_type);
	auto_btn:SetEnable(1);
	
	local stop_btn = GET_CHILD_RECURSIVELY(frame, "stop_btn");
	stop_btn:SetEventScript(ui.LBUTTONDOWN, "AUTO_COMMON_GAMBLE_STOP_BTN_CLICK");
	stop_btn:SetEnable(1);

	local edit = GET_CHILD_RECURSIVELY(frame, "auto_edit");
	edit:SetEnable(1);
	edit:SetText('');

	local auto_text = GET_CHILD_RECURSIVELY(frame, "auto_text");
	auto_text:ShowWindow(1);
end

function COMMON_GAMBLE_OK_BTN_CLICK(parent, ctrl, argStr, gamble_type)
	if ui.CheckHoldedUI() == true then
        return;
	end

	ui.SetHoldUI(true);
    common_gamble.RequestCommonGamble(gamble_type);
	COMMON_GAMBLE_OK_BTN_EFFECT(frame);
	
	local delay = WORLD_EVENT_CLICK_DELAY;
	ReserveScript("COMMON_GAMBLE_OK_BTN_UNFREEZE()", delay);
end

function AUTO_COMMON_GAMBLE_OK_BTN_CLICK()
	local frame = ui.GetFrame("commongamble");
	local edit = GET_CHILD_RECURSIVELY(frame, "auto_edit");
	local count = edit:GetText();
	if edit:GetText() == "" or tonumber(count) - 1 < 0  then
		STOP_commongamble();
		return;
	end

	local auto_btn = GET_CHILD_RECURSIVELY(frame, "auto_btn");
	local gamble_type = auto_btn:GetEventScriptArgNumber(ui.LBUTTONDOWN);
	
	common_gamble.RequestCommonGamble(gamble_type)
end

function AUTO_commongamble(gamble_type, count)
	local frame = ui.GetFrame("commongamble");

	local auto_btn = GET_CHILD_RECURSIVELY(frame, "auto_btn");
	auto_btn:SetEnable(0);

	local edit = GET_CHILD_RECURSIVELY(frame, "auto_edit");
	edit:SetEnable(0);

	local one_btn = GET_CHILD_RECURSIVELY(frame, 'one_btn');
	one_btn:SetEnable(0);

	local count = edit:GetText();

	local delay = WORLD_EVENT_CLICK_DELAY * 1000;
	delay = delay + 100;
	AddUniqueTimerFunccWithLimitCount('AUTO_COMMON_GAMBLE_OK_BTN_CLICK', delay, count)
end

function STOP_commongamble()
	RemoveLuaTimerFunc('AUTO_COMMON_GAMBLE_OK_BTN_CLICK')
	
	local frame = ui.GetFrame("commongamble");
	local edit = GET_CHILD_RECURSIVELY(frame, "auto_edit");
	edit:SetEnable(1);

	local auto_btn = GET_CHILD_RECURSIVELY(frame, "auto_btn");
	auto_btn:SetEnable(1);

	local one_btn = GET_CHILD_RECURSIVELY(frame, "one_btn");
	one_btn:SetEnable(1);
end

function COMMON_GAMBLE_OK_BTN_UNFREEZE()
	ui.SetHoldUI(false);
end

-- 확인 버튼 이펙트
function COMMON_GAMBLE_OK_BTN_EFFECT(frame)
    frame = ui.GetFrame("commongamble");

    local OK_BUTTON_EFFECT_NAME = frame:GetUserConfig("OK_BUTTON_EFFECT_NAME");
    local OK_BUTTON_EFFECT_SCALE = tonumber(frame:GetUserConfig("OK_BUTTON_EFFECT_SCALE"));
    
    local one_btn = GET_CHILD_RECURSIVELY(frame, "one_btn");
	if one_btn == nil then
		return;
    end
    
	one_btn:PlayUIEffect(OK_BUTTON_EFFECT_NAME, OK_BUTTON_EFFECT_SCALE, "OK_BUTTON_EFFECT");
    ReserveScript("_OK_BUTTON_EFFECT()", 0.2);
end

function _OK_BUTTON_EFFECT()
	local frame = ui.GetFrame("commongamble");
	if frame:IsVisible() == 0 then
		return;
	end
	
    local one_btn = GET_CHILD_RECURSIVELY(frame, "one_btn");
	if one_btn == nil then
		return;
    end

	one_btn:StopUIEffect("OK_BUTTON_EFFECT", true, 0.5);
end

-- 뽑은 슬롯 이펙트
function ON_COMMON_GAMBLE_ITEM_GET(frame, msg, itemid, itemCount)
	frame = ui.GetFrame("commongamble");

	local itemCls = GetClassByType("Item", itemid);
    if itemCls ~= nil then
		local slot = COMMON_GAMBLE_ITEM_SLOT_GET(itemid, itemCount);      -- 뽑을 수 있는 아이템 slot
		local resultslot = GET_CHILD_RECURSIVELY(frame, "resultslot");    -- 뽑은 아이템 slot 
        if slot == nil then return; end
        if resultslot == nil then return; end

        resultslot:SetUserValue("ITEM_CLASSID", itemid);
        resultslot:SetUserValue("ITEM_COUNT", itemCount);

        SET_SLOT_ITEM_INFO(resultslot, itemCls, itemCount,'{s20}{ol}{b}{ds}', -7, -6);
        
	    local RESULT_EFFECT_NAME = frame:GetUserConfig('RESULT_EFFECT');
        local RESULT_EFFECT_SCALE_S = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE_S'));
        local RESULT_EFFECT_SCALE_M = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE_M'));
        local RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
        
        slot:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE_S, 'RESULT_EFFECT');
        resultslot:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE_S, 'RESULT_EFFECT');
	    ReserveScript("_RESULT_EFFECT()", RESULT_EFFECT_DURATION);
		
		COMMON_GAMBLE_AUTO_COUNT_UPDATE(frame);
    end
end

function _RESULT_EFFECT()
	local frame = ui.GetFrame("commongamble");
	if frame:IsVisible() == 0 then
		return;
    end
    
    local resultslot = GET_CHILD_RECURSIVELY(frame, "resultslot");
    if resultslot == nil then return; end

	local classID = resultslot:GetUserValue("ITEM_CLASSID");
	local itemCount = resultslot:GetUserIValue("ITEM_COUNT");
	
    local slot = COMMON_GAMBLE_ITEM_SLOT_GET(classID, itemCount);
    if slot == nil then return; end

	slot:StopUIEffect("RESULT_EFFECT", true, 0.5);
	resultslot:StopUIEffect("RESULT_EFFECT", true, 0.5);
end

-- itemid의 아이템이 등록된 slot 찾기
function COMMON_GAMBLE_ITEM_SLOT_GET(itemid, itemCount)
	local frame = ui.GetFrame("commongamble");
	
	local slot_gb = GET_CHILD(frame, "slot_gb");
	local slot_gb_childCnt = slot_gb:GetChildCount();
	for i = 0, slot_gb_childCnt - 2 do
		local itemslot = GET_CHILD(slot_gb, "slot"..i);
		local slotitemid = itemslot:GetUserValue("ITEM_CLASSID");
		local slotitemCount = itemslot:GetUserIValue("ITEM_COUNT");
		if tonumber(itemid) == tonumber(slotitemid) and itemCount == slotitemCount then
			return itemslot;
		end		
	end

	return nil;
end
function COMMON_GAMBLE_AUTO_EDIT_CLICK(parent, ctrl)
	local auto_text = GET_CHILD(parent, "auto_text");
	auto_text:ShowWindow(0);
end

function AUTO_COMMON_GAMBLE_START_BTN_CLICK(parent, ctrl, argStr, gamble_type)
	if ui.CheckHoldedUI() == true then
        return;
	end

	AUTO_commongamble(gamble_type, count)
end

function AUTO_COMMON_GAMBLE_STOP_BTN_CLICK(parent, ctrl)
	STOP_commongamble();
end

function COMMON_GAMBLE_AUTO_COUNT_UPDATE(frame)
	local auto_btn = GET_CHILD_RECURSIVELY(frame, "auto_btn");
	if auto_btn:IsEnable() == 1 then
		return;
	end

	local edit = GET_CHILD_RECURSIVELY(frame, "auto_edit");
	local count = tonumber(edit:GetText());
	local next_count = count - 1;
	if next_count < 0 then
		return;
	end

	edit:SetText(next_count);
end