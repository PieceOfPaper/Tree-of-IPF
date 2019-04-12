function BEAUTY_COUPON_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_BEAUTY_COUPON_STAMP', 'ON_UPDATE_BEAUTY_COUPON_STAMP');
end

function BEAUTY_COUPON_OPEN()
    local frame = ui.GetFrame('beauty_coupon');
    session.beautyshop.RequestStampInfo();
    BEAUTY_COUPON_INIT_EXCHANGE_BOX(frame);
    frame:ShowWindow(1);
end

function BEAUTY_COUPON_INIT_EXCHANGE_BOX(frame)
    local exchangeBox = GET_CHILD_RECURSIVELY(frame, 'exchangeBox');
    local exchangeList = GET_BEAUTYSHOP_STAMP_EXCHANGE_LIST();
    for i = 1, #exchangeList do
        local exchangeInfo = exchangeList[i];
        local ctrlset = exchangeBox:CreateOrGetControlSet('beauty_coupon_info', 'INFO_'..exchangeInfo.stampCount, 0, 0);
        local countText = GET_CHILD(ctrlset, 'countText');
        countText:SetTextByKey('count', exchangeInfo.stampCount);

        local couponItemCls = GetClass('Item', exchangeInfo.rewardItemName);
        local couponPic = GET_CHILD(ctrlset, 'couponPic');
        couponPic:SetImage(couponItemCls.Icon);

        local couponText = GET_CHILD(ctrlset, 'couponText');
        couponText:SetTextByKey('percentage', couponItemCls.NumberArg1);

        local line = GET_CHILD(ctrlset, 'line');
        if i == #exchangeList then
            line:ShowWindow(0);
        end
    end
    GBOX_AUTO_ALIGN(exchangeBox, 0, 0, 0, true, false, false);
end

function BEAUTY_COUPON_EXCHANGE_BTN_CLICK(parent, ctrl)
    local countText = GET_CHILD(parent, 'countText');
    local stampCount = tonumber(countText:GetTextByKey('count'));
    local frame = parent:GetTopParentFrame();
    local curStampCnt = frame:GetUserIValue('CUR_STAMP_CNT');
    if curStampCnt < stampCount then
        ui.SysMsg(ClMsg('LackOfStampCount'));
        return;
    end

    local info = GET_STAMP_EXHCANGE_INFO(stampCount);
    if info == nil then
        return;
    end

    control.CustomCommand('EXCHANGE_BEAUTYSHOP_COUPON', stampCount);
end

function ON_UPDATE_BEAUTY_COUPON_STAMP(frame, msg, argStr, stampCnt)
    local stampBox = GET_CHILD_RECURSIVELY(frame, 'stampBox');
    stampBox:RemoveAllChild();
    frame:SetUserValue('CUR_STAMP_CNT', stampCnt);

    local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
    countText:SetTextByKey('cur', stampCnt);

    local MAX_COL = 5;
    local MAX_ROW = 3;
    local MAX_COUNT = MAX_COL * MAX_ROW;
    local STAMP_INTERVAL_X = tonumber(frame:GetUserConfig('STAMP_INTERVAL_X'));
    local STAMP_INTERVAL_Y = tonumber(frame:GetUserConfig('STAMP_INTERVAL_Y'));
    for i = 1, MAX_COUNT do
        local ctrlset = stampBox:CreateOrGetControlSet('beauty_coupon_stamp', 'STAMP_'..i, 0, 0);
        local colIndex = ((i - 1) % MAX_COL);
        local rowIndex = math.floor((i - 1) / MAX_COL);

        local targetX = ctrlset:GetWidth() * colIndex + STAMP_INTERVAL_X * colIndex;
        local targetY = ctrlset:GetHeight() * rowIndex + STAMP_INTERVAL_Y * math.max(0, rowIndex - 1);        
        ctrlset:SetOffset(targetX, targetY);
        if i > stampCnt then
            local stampPic = GET_CHILD(ctrlset, 'stampPic');
            stampPic:ShowWindow(0);
        end
    end
end