function ABILITY_POINT_EXTRACTOR_ON_INIT(addon, frame)
    addon:RegisterMsg('SUCCESS_EXTRACT_ABILITY_POINT', 'ABILITY_POINT_EXTRACTOR_RESET');
end

function ABILITY_POINT_EXTRACTOR_OPEN(frame)
    local feeValueText = GET_CHILD_RECURSIVELY(frame, 'feeValueText');
    feeValueText:SetTextByKey('value', GET_COMMAED_STRING(ABILITY_POINT_EXTRACTOR_FEE));
    ABILITY_POINT_EXTRACTOR_RESET(frame);

    local sklAbilFrame = ui.GetFrame('skillability');
    SET_FRAME_OFFSET_TO_RIGHT_TOP(frame, sklAbilFrame);
end

function ABILITY_POINT_EXTRACTOR_RESET(frame)
    local extractScrollEdit = GET_CHILD_RECURSIVELY(frame, 'extractScrollEdit');
    local money = GET_TOTAL_MONEY_STR();
    local enableCountByMoney = math.floor(tonumber(money) / ABILITY_POINT_EXTRACTOR_FEE);
    local enableCountByPoint = math.floor(session.ability.GetAbilityPoint() / ABILITY_POINT_SCROLL_RATE);
    local enableCount = math.min(enableCountByMoney, enableCountByPoint)
    frame:SetUserValue('ENABLE_COUNT', enableCount);

    ABILITY_POINT_EXTRACTOR_SET_EDIT(extractScrollEdit, 0);
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(frame);
end

function ABILITY_POINT_EXTRACTOR_DOWN(parent, ctrl, argstr, argnum)
    local extractScrollEdit = parent:GetChild('extractScrollEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentCount = topFrame:GetUserIValue('SCROLL_COUNT');
    ABILITY_POINT_EXTRACTOR_SET_EDIT(extractScrollEdit, math.max(0, tonumber(currentCount) - argnum));
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_EXTRACTOR_UP(parent, ctrl, argstr, argnum)
    local extractScrollEdit = parent:GetChild('extractScrollEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentCount = topFrame:GetUserIValue('SCROLL_COUNT');
    local enableCountByPoint = math.floor(session.ability.GetAbilityPoint() / ABILITY_POINT_SCROLL_RATE);
    ABILITY_POINT_EXTRACTOR_SET_EDIT(extractScrollEdit, math.min(enableCountByPoint, tonumber(currentCount) + argnum));
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_EXTRACTOR_MIN(parent, ctrl, argstr, argnum)
    local extractScrollEdit = parent:GetChild('extractScrollEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentCount = topFrame:GetUserIValue('SCROLL_COUNT');
    ABILITY_POINT_EXTRACTOR_SET_EDIT(extractScrollEdit, 0);
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_EXTRACTOR_MAX(parent, ctrl, argstr, argnum)
    local extractScrollEdit = parent:GetChild('extractScrollEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentCount = topFrame:GetUserIValue('SCROLL_COUNT');
    local enableCountByPoint = math.floor(session.ability.GetAbilityPoint() / ABILITY_POINT_SCROLL_RATE);
    ABILITY_POINT_EXTRACTOR_SET_EDIT(extractScrollEdit, enableCountByPoint);
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_EXTRACTOR_CANCEL(parent, ctrl)
    ui.CloseFrame('ability_point_extractor');
end

function ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(frame)
    local extractScrollEdit = GET_CHILD_RECURSIVELY(frame, 'extractScrollEdit');
    local consumeMoneyText = GET_CHILD_RECURSIVELY(frame, 'consumeMoneyText');
    local expectMoneyText = GET_CHILD_RECURSIVELY(frame, 'expectMoneyText');
    local consumePointText = GET_CHILD_RECURSIVELY(frame, 'consumePointText');
    local remainPointText = GET_CHILD_RECURSIVELY(frame, 'remainPointText');
    local money = GET_TOTAL_MONEY_STR();

    local consumeMoney, eventDiscount = ABILITY_POINT_EXTRACTOR_GET_CONSUME_MONEY(frame);
    local expectMoney = SumForBigNumberInt64(money, '-'..consumeMoney);
    local consumeMoneyStr = GET_COMMAED_STRING(consumeMoney);
    local expectMoneyStr = "";
    if tonumber(consumeMoney) > 0 then
        consumeMoneyStr = '-'..consumeMoneyStr;
    end
    if tonumber(expectMoney) >= 0 then
        expectMoneyStr = GET_COMMAED_STRING(expectMoney);
    else
        local EXCEED_MONEY_STYLE = frame:GetUserConfig('EXCEED_MONEY_STYLE');
        expectMoneyStr = EXCEED_MONEY_STYLE..'-'..GET_COMMAED_STRING(-expectMoney)..'{/}';
    end

    local consumePoint = ABILITY_POINT_EXTRACTOR_GET_CONSUME_POINT(frame);
    local consumePointStr = GET_COMMAED_STRING(consumePoint);
    
    local abilityPoint = session.ability.GetAbilityPoint();
    local expectAbilityPoint = abilityPoint - tonumber(consumePoint);
    local expectAbilityPointStr = "";
    if expectAbilityPoint < 0 then
        local EXCEED_MONEY_STYLE = frame:GetUserConfig('EXCEED_MONEY_STYLE');
        expectAbilityPointStr = EXCEED_MONEY_STYLE..GET_COMMAED_STRING(expectAbilityPoint)..'{/}';
    else
        expectAbilityPointStr = GET_COMMAED_STRING(expectAbilityPoint)
    end
    
    if eventDiscount == 1 then
        consumeMoneyStr = consumeMoneyStr..' '..ScpArgMsg('EVENT_1811_ABILITY_EXTRACTOR_MSG1','COUNT',100)
    end
    
    consumePointText:SetTextByKey('value', consumePointStr);
    remainPointText:SetTextByKey('value', expectAbilityPointStr);
    consumeMoneyText:SetTextByKey('value', consumeMoneyStr);
    expectMoneyText:SetTextByKey('value', expectMoneyStr);
end

function ABILITY_POINT_EXTRACTOR_GET_CONSUME_MONEY(frame)
    local scrollCount = frame:GetUserIValue('SCROLL_COUNT');
    local exchangeFee = ABILITY_POINT_EXTRACTOR_FEE;
    local consumeMoney = MultForBigNumberInt64(scrollCount, exchangeFee);
    local sObj = session.GetSessionObjectByName("ssn_klapeda");
    if sObj ~= nil then
    	sObj = GetIES(sObj:GetIESObject());
    end
    
    local eventDiscount = 0
    -- EVENT_1811_ABILITY_EXTRACTOR
--    local useFlag = TryGetProp(sObj, 'EVENT_1811_ABILITY_EXTRACTOR_USE')
--    local exceptFlag = TryGetProp(sObj, 'EVENT_1811_ABILITY_EXTRACTOR_EXCEPT')
    
    
    if exceptFlag == 0 and useFlag == 0 then
        consumeMoney = 0
        eventDiscount = 1
    end

    return consumeMoney, eventDiscount;
end

function ABILITY_POINT_EXTRACTOR_GET_CONSUME_POINT(frame)
    local scrollCount = frame:GetUserIValue('SCROLL_COUNT');
    local exchangeRate = ABILITY_POINT_SCROLL_RATE;
    local exchangeCount = MultForBigNumberInt64(scrollCount, exchangeRate);
    return exchangeCount;
end

function ABILITY_POINT_EXTRACTOR_TYPE(parent, ctrl)
    ABILITY_POINT_EXTRACTOR_SET_EDIT(ctrl, ctrl:GetText());
    ABILITY_POINT_EXTRACTOR_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_EXTRACTOR_SET_EDIT(edit, count)
    local topFrame = edit:GetTopParentFrame();
    local enableCount = topFrame:GetUserIValue('ENABLE_COUNT');
    count = tonumber(count)
    if count == nil then
        count = 0;
        edit:SetText('0');
    end
    count = math.min(count, MAX_ABILITY_POINT);
    if count > enableCount then
        local EXCEED_POINT_STYLE = topFrame:GetUserConfig('EXCEED_POINT_STYLE');
        edit:SetText(EXCEED_POINT_STYLE..count..'{/}');
    else
        edit:SetText(count);
    end
    topFrame:SetUserValue('SCROLL_COUNT', count);
end

function ABILITY_POINT_EXTRACTOR(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local count = topFrame:GetUserIValue('SCROLL_COUNT');
    if count < 1 then
        return;
    end
    
    local consumeMoney, eventDiscount = ABILITY_POINT_EXTRACTOR_GET_CONSUME_MONEY(topFrame);
    local money = GET_TOTAL_MONEY_STR();
    if IsGreaterThanForBigNumber(consumeMoney, money) == 1 then
        ui.SysMsg(ClMsg('NotEnoughMoney'));
        return;
    end
	
    local consumePoint = ABILITY_POINT_EXTRACTOR_GET_CONSUME_POINT(topFrame);
	
    local consumeMoneyStr = GET_COMMAED_STRING(consumeMoney);
--    local pointRateStr = GET_COMMAED_STRING(ABILITY_POINT_SCROLL_RATE);
    local consumePointStr = GET_COMMAED_STRING(consumePoint);
	
	if eventDiscount == 1 then
        consumeMoneyStr = consumeMoneyStr..' '..ScpArgMsg('EVENT_1811_ABILITY_EXTRACTOR_MSG1','COUNT',100)
    end
	
    local msg = ScpArgMsg("AskExtractAbilityPoint{Silver}{Scroll}{ConsumePoint}", "Silver", consumeMoneyStr, "Scroll", count, "ConsumePoint", consumePointStr);
	local yesscp = string.format('EXEC_ABILITY_POINT_EXTRACTOR(%d)', count);
    ui.MsgBox_NonNested(msg, topFrame:GetName(), yesscp, 'None');
end

function EXEC_ABILITY_POINT_EXTRACTOR(count)
    control.CustomCommand('REQ_EXTRACT_ABILITY', count);
end