
function COLONY_PAYMENT_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_COLONY_MARKET_FEE_PAYMENT_LIST', 'ON_UPDATE_COLONY_MARKET_FEE_PAYMENT_LIST');
end

function ON_UPDATE_COLONY_MARKET_FEE_PAYMENT_LIST(frame, msg, strarg, numarg)
    local list_gb = GET_CHILD_RECURSIVELY(frame, "list_gb");
    list_gb:RemoveAllChild();

    local cnt = session.colonywar.payment.GetCount();
    local curTime = geTime.GetServerSystemTime();
    local listcnt = 0;
    for i=0, cnt-1 do
        local paymentInfo = session.colonywar.payment.GetByIndex(i);
        local payday = paymentInfo:GetPayDay();
        if imcTime.IsLaterThan(curTime, payday) == 1 then
            local ctrlset = list_gb:CreateControlSet("colony_payment_elem", "colony_payment_elem_"..i, 0, 45*listcnt);
            ctrlset = AUTO_CAST(ctrlset);
            local date_text = GET_CHILD_RECURSIVELY(ctrlset, "date_text");
            local map_text = GET_CHILD_RECURSIVELY(ctrlset, "map_text");
            local reward_pic = GET_CHILD_RECURSIVELY(ctrlset, "reward_pic");
            local reward_text = GET_CHILD_RECURSIVELY(ctrlset, "reward_text");
            local recv_btn = GET_CHILD_RECURSIVELY(ctrlset, "recv_btn");

            date_text:SetTextByKey("year", paymentInfo:GetCriterionTime().wYear)
            date_text:SetTextByKey("month", paymentInfo:GetCriterionTime().wMonth)
            date_text:SetTextByKey("day", paymentInfo:GetCriterionTime().wDay)
            
            local mapCls = GetClassByType("Map", paymentInfo.mapID);
            map_text:SetText(mapCls.Name);

            local itemCls = GetClassByType("Item", paymentInfo.itemID);
            reward_pic:SetImage(itemCls.Icon);
            
            reward_text:SetTextByKey("value", paymentInfo:GetAmount())

            recv_btn:SetEventScriptArgNumber(ui.LBUTTONUP, i);
            listcnt = listcnt + 1;
        end
    end

    frame:ShowWindow(1);
end

function ON_REQ_COLONY_MARKET_FEE_PAYMENT_BTN(parent, ctrl, strarg, numarg)
    session.colonywar.payment.ReqColonyMarketFeePayment(numarg);
end

function ON_OPEN_COLONY_PAYMENT(frame)
    control.CustomCommand("REQ_COLONY_MARKET_FEE_PAYMENT_LIST", 0);
end