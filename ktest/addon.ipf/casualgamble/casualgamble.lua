function CASUALGAMBLE_ON_INIT(addon, frame)
    addon:RegisterMsg('CASUAL_GAMBLE_ITEM_GET', 'ON_CASUAL_GAMBLE_ITEM_GET');
end

-- 아이콘으로 UI 오픈
function CASUAL_GAMBLE_DO_OPEN()
	local frame = ui.GetFrame("casualgamble");
	ui.OpenFrame("casualgamble");
end

function CASUAL_GAMBLE_OPEN(frame)
	CASUAL_GAMBLE_INIT(frame);
	CASUAL_GAMBLE_REMAIN_TIME(frame);
	CASUAL_GAMBLE_ITME_LIST_INIT(frame);
end

function CASUAL_GAMBLE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
        return;
	end

	ui.CloseFrame("casualgamble");
end

-- 아이템 slot 초기화, 1회 봉헌 silver 설정
function CASUAL_GAMBLE_INIT(frame)
	if ui.CheckHoldedUI() == true then
        return;
	end

	local resultslot = GET_CHILD_RECURSIVELY(frame, 'resultslot');
    resultslot:ClearIcon();
    resultslot:SetText("");
    
    
    local maxslot = frame:GetUserConfig("MAX_SLOT_COUNT");
    for i = 0, maxslot - 1 do
        local itemslot = GET_CHILD_RECURSIVELY(frame, 'slot'..i);
        itemslot:ClearIcon();
        itemslot:SetText("");
    end
    
    local slivercost = session.Casual_Gamble.GetSilverCost();
    local silver_cost = GET_CHILD_RECURSIVELY(frame, 'silver_cost', 'ui::CRichText');
    silver_cost:SetTextByKey("value", slivercost)
    
end

-- 남은 시간 설정 
function CASUAL_GAMBLE_REMAIN_TIME(frame)
    local endtime = session.Casual_Gamble.GetEndTime();
    local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
    time:RunUpdateScript("UPDATE_CASUAL_GAMBLE_REMAIN_TIME", 0.1);
    UPDATE_CASUAL_GAMBLE_REMAIN_TIME(time);
end

function UPDATE_CASUAL_GAMBLE_REMAIN_TIME(ctrl)	
	local endtime = session.Casual_Gamble.GetEndTime();
    local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
    end
    
	local min = math.floor(remainsec/60)
	local sec = math.floor(remainsec%60)

	if isClear == true then
		local frame = ctrl:GetTopParentFrame();
		local font = frame:GetUserConfig("TIME_FONT_NOMAL");
		ctrl:SetFormat(font..ClMsg("RemainTime").." %s"..ClMsg("UI_Min").." %s"..ClMsg("UI_Sec"));
		ctrl:ReleaseBlink();
	elseif min < 1 then
		local frame = ctrl:GetTopParentFrame();
		ctrl = tolua.cast(ctrl, 'ui::CRichText');
		local font = frame:GetUserConfig("TIME_FONT_ONEMINUTE");
		if font ~= nil then
			ctrl:SetFormat(font..ClMsg("RemainTime").." %s"..ClMsg("UI_Min").." %s"..ClMsg("UI_Sec"));
			ctrl:SetBlink(600000, 1.0, "55FFFFFF", 1);
		end
	end

	ctrl:SetTextByKey('min', min);
	ctrl:SetTextByKey('sec', sec);

	return 1;
end

-- 겜블 아이템 정보 설정
function CASUAL_GAMBLE_ITME_LIST_INIT(frame)
	if frame == nil then
		frame = ui.GetFrame("casualgamble");
	end

    local cnt = session.Casual_Gamble.GetItemListCount();
	for i = 0, cnt - 1 do		
		slot = GET_CHILD_RECURSIVELY(frame, 'slot'..i);
		if slot ~= nil then
			local itemclassname = session.Casual_Gamble.GetItemClassNamebyIndex(i);	
			local itemCls = GetClass('Item', itemclassname);
            if itemCls ~= nil then
                local itemCount = session.Casual_Gamble.GetItemCountbyIndex(i);
                SET_SLOT_ITEM_INFO(slot, itemCls, itemCount,'{s20}{ol}{b}{ds}', -11, -10);  

				slot:SetUserValue("ITEM_CLASSID", itemCls.ClassID);
				slot:SetUserValue("ITEM_COUNT", itemCount);
                
                local icon = slot:GetIcon();
                icon:SetDisableSlotSize(true);
                icon:SetReducedvalue(10, 10);
			end
		end
	end
end

function CASUAL_GAMBLE_OK_BTN_CLICK()
	if ui.CheckHoldedUI() == true then
        return;
	end

    local endtime = session.Casual_Gamble.GetEndTime();
    local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
    if remainsec < 0 then
        ui.SysMsg(ClMsg("CasulgambleEnd"));
		return 0;
    end

	local silvercost = session.Casual_Gamble.GetSilverCost();
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		silver = tonumber(invItem:GetAmountStr());
	end

	if silver < silvercost then
		ui.SysMsg(ScpArgMsg("REQUEST_TAKE_SILVER"));		
		return;
	end

	ui.SetHoldUI(true);
    casual_gamble.RequestCasualGamble();
	CASUAL_GAMBLE_OK_BTN_EFFECT(frame)    
	ReserveScript("CASUAL_GAMBLE_OK_BTN_UNFREEZE()", CASUAL_GAMBLE_CLICK_DELAY);
end

function CASUAL_GAMBLE_OK_BTN_UNFREEZE()
	ui.SetHoldUI(false);
end

-- 확인 버튼 이펙트
function CASUAL_GAMBLE_OK_BTN_EFFECT(frame)
    frame = ui.GetFrame("casualgamble");

    local OK_BUTTON_EFFECT_NAME = frame:GetUserConfig('OK_BUTTON_EFFECT_NAME');
    local OK_BUTTON_EFFECT_SCALE = tonumber(frame:GetUserConfig('OK_BUTTON_EFFECT_SCALE'));
    
    local okbtn = GET_CHILD_RECURSIVELY(frame, 'okbtn');
	if okbtn == nil then
		return;
    end
    
	okbtn:PlayUIEffect(OK_BUTTON_EFFECT_NAME, OK_BUTTON_EFFECT_SCALE, 'OK_BUTTON_EFFECT');
    ReserveScript("_OK_BUTTON_EFFECT()", CASUAL_GAMBLE_CLICK_DELAY);
end

function _OK_BUTTON_EFFECT()
	local frame = ui.GetFrame("casualgamble");
	if frame:IsVisible() == 0 then
		return;
	end
	
    local okbtn = GET_CHILD_RECURSIVELY(frame, 'okbtn');
	if okbtn == nil then
		return;
    end

	okbtn:StopUIEffect('OK_BUTTON_EFFECT', true, 0.5);
end

-- 뽑은 슬롯 이펙트
function ON_CASUAL_GAMBLE_ITEM_GET(frame, msg, itemid, itemCount)
	frame = ui.GetFrame("casualgamble");

    local itemCls = GetClassByType('Item', itemid);
    if itemCls ~= nil then
		local slot = CASUAL_GAMBLE_ITEM_SLOT_GET(itemid, itemCount);           -- 뽑을 수 있는 아이템 slot
        local resultslot = GET_CHILD_RECURSIVELY(frame, 'resultslot');    -- 뽑은 아이템 slot 
        if slot == nil then return; end
        if resultslot == nil then return; end

        resultslot:SetUserValue("ITEM_CLASSID", itemid)
        resultslot:SetUserValue("ITEM_COUNT", itemCount)

        SET_SLOT_ITEM_INFO(resultslot, itemCls, itemCount,'{s20}{ol}{b}{ds}', -7, -6);
        
	    local RESULT_EFFECT_NAME = frame:GetUserConfig('RESULT_EFFECT');
        local RESULT_EFFECT_SCALE_S = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE_S'));
        local RESULT_EFFECT_SCALE_M = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE_M'));
        local RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
        
        slot:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE_S, 'RESULT_EFFECT');
        resultslot:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE_M, 'RESULT_EFFECT');
	    ReserveScript("_RESULT_EFFECT()", RESULT_EFFECT_DURATION);
    end
end

function _RESULT_EFFECT()
	local frame = ui.GetFrame("casualgamble");
	if frame:IsVisible() == 0 then
		return;
    end
    
    local resultslot = GET_CHILD_RECURSIVELY(frame, 'resultslot');
    if resultslot == nil then return; end

	local classID = resultslot:GetUserValue("ITEM_CLASSID");
	local itemCount = resultslot:GetUserIValue("ITEM_COUNT");
	
    local slot = CASUAL_GAMBLE_ITEM_SLOT_GET(classID, itemCount);
    if slot == nil then return; end

	slot:StopUIEffect('RESULT_EFFECT', true, 0.5);
	resultslot:StopUIEffect('RESULT_EFFECT', true, 0.5);
end

-- itemid의 아이템이 등록된 slot 찾기
function CASUAL_GAMBLE_ITEM_SLOT_GET(itemid, itemCount)
	local frame = ui.GetFrame("casualgamble");

    local cnt = session.Casual_Gamble.GetItemListCount();
	for i = 0, cnt - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, 'slot'..i);
		local slotitemid = slot:GetUserValue("ITEM_CLASSID");
		local slotitemCount = slot:GetUserIValue("ITEM_COUNT");
		if tonumber(itemid) == tonumber(slotitemid) and itemCount == slotitemCount then
			return slot;
		end		 
	end

	return nil;
end