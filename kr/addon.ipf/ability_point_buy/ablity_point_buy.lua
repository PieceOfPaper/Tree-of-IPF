function ABILITY_POINT_BUY_ON_INIT(addon, frame)
    addon:RegisterMsg('SUCCESS_BUY_ABILITY_POINT', 'ABILITY_POINT_BUY_RESET');
end

function GET_SILVER_BY_ONE_ABILITY_POINT_CALC()
    local exchangeRate = SILVER_BY_ONE_ABILITY_POINT;
    -- Test Server Spec : 80% Sale --
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        exchangeRate = math.floor(exchangeRate * 0.2);
    end
    
    if exchangeRate < 1 then
        exchangeRate = 1;
    end
    
    return exchangeRate;
end

function ABILITY_POINT_BUY_OPEN(frame)
    local ratioValueText = GET_CHILD_RECURSIVELY(frame, 'ratioValueText');
    local exchangeRate = GET_SILVER_BY_ONE_ABILITY_POINT_CALC();
    ratioValueText:SetTextByKey('ratio', GET_COMMAED_STRING(exchangeRate));
--    ratioValueText:SetTextByKey('ratio', GET_COMMAED_STRING(SILVER_BY_ONE_ABILITY_POINT));

    ABILITY_POINT_BUY_RESET(frame);
end

function ABILITY_POINT_BUY_RESET(frame)
    local enableValueText = GET_CHILD_RECURSIVELY(frame, 'enableValueText');
    local buyPointEdit = GET_CHILD_RECURSIVELY(frame, 'buyPointEdit');
    local money = GET_TOTAL_MONEY();
    
    local exchangeRate = GET_SILVER_BY_ONE_ABILITY_POINT_CALC();
    local enableCount = math.floor(money / exchangeRate);
    
    enableValueText:SetTextByKey('count', enableCount);
    frame:SetUserValue('ENABLE_COUNT', enableCount);

    ABILITY_POINT_BUY_SET_EDIT(buyPointEdit, 0);
    ABILITY_POINT_BUY_UPDATE_MONEY(frame);
end

function ABILITY_POINT_BUY_DOWN(parent, ctrl)
    local buyPointEdit = parent:GetChild('buyPointEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentPoint = topFrame:GetUserIValue('POINT_COUNT');
    ABILITY_POINT_BUY_SET_EDIT(buyPointEdit, math.max(0, tonumber(currentPoint) - 1));
    ABILITY_POINT_BUY_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_BUY_UP(parent, ctrl)
    local buyPointEdit = parent:GetChild('buyPointEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentPoint = topFrame:GetUserIValue('POINT_COUNT');
    ABILITY_POINT_BUY_SET_EDIT(buyPointEdit, math.min(MAX_ABILITY_POINT, tonumber(currentPoint) + 1));
    ABILITY_POINT_BUY_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_BUY_CANCEL(parent, ctrl)
    ui.CloseFrame('ability_point_buy');
end

function ABILITY_POINT_BUY_UPDATE_MONEY(frame)
    local buyPointEdit = GET_CHILD_RECURSIVELY(frame, 'buyPointEdit');
    local consumeMoneyText = GET_CHILD_RECURSIVELY(frame, 'consumeMoneyText');
    local remainMoneyText = GET_CHILD_RECURSIVELY(frame, 'remainMoneyText');
    local moneyValueText = GET_CHILD_RECURSIVELY(frame, 'moneyValueText');
    local money = GET_TOTAL_MONEY();

    local consumeMoney = ABILITY_POINT_BUY_GET_CONSUME_MONEY(frame);
    local remainMoney = money - consumeMoney;
    local consumeMoneyStr = GET_COMMAED_STRING(consumeMoney);
    local remainMoneyStr = "";
    if consumeMoney > 0 then
        consumeMoneyStr = '-'..consumeMoneyStr;
    end
    if remainMoney >= 0 then
        remainMoneyStr = GET_COMMAED_STRING(remainMoney);
    else
        local EXCEED_MONEY_STYLE = frame:GetUserConfig('EXCEED_MONEY_STYLE');
        remainMoneyStr = EXCEED_MONEY_STYLE..'-'..GET_COMMAED_STRING(-remainMoney)..'{/}';
    end

    moneyValueText:SetTextByKey('money', GET_COMMAED_STRING(money));
    consumeMoneyText:SetTextByKey('money', consumeMoneyStr);
    remainMoneyText:SetTextByKey('money', remainMoneyStr);
end

function ABILITY_POINT_BUY_GET_CONSUME_MONEY(frame)
    local pointCount = frame:GetUserIValue('POINT_COUNT');
    local exchangeRate = GET_SILVER_BY_ONE_ABILITY_POINT_CALC();
    local consumeMoney = pointCount * exchangeRate;
    return consumeMoney;
end

function ABILITY_POINT_BUY_TYPE(parent, ctrl)
    ABILITY_POINT_BUY_SET_EDIT(ctrl, ctrl:GetText());
    ABILITY_POINT_BUY_UPDATE_MONEY(parent:GetTopParentFrame());
end

function ABILITY_POINT_BUY_SET_EDIT(edit, count)
    local topFrame = edit:GetTopParentFrame();
    local enableCount = topFrame:GetUserIValue('ENABLE_COUNT');
    if count == nil or count == "" then
        count = 0;
        edit:SetText('0');
    end
    count = math.min(tonumber(count), MAX_ABILITY_POINT);
    if count > enableCount then
        local EXCEED_POINT_STYLE = topFrame:GetUserConfig('EXCEED_POINT_STYLE');
        edit:SetText(EXCEED_POINT_STYLE..count..'{/}');
    else
        edit:SetText(count);
    end
    topFrame:SetUserValue('POINT_COUNT', count);
end

function ABILITY_POINT_BUY(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local point = topFrame:GetUserIValue('POINT_COUNT');
    if point < 1 then
        return;
    end

    local consumeMoney = ABILITY_POINT_BUY_GET_CONSUME_MONEY(topFrame);
    local money = GET_TOTAL_MONEY();
    if consumeMoney > money then
        ui.SysMsg(ClMsg('NotEnoughMoney'));
        return;
    end
    
    ui.Chat('/buyabilpoint '..point);
end