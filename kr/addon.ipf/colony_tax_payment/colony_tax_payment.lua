
function COLONY_TAX_PAYMENT_ON_INIT(addon, frame)
	addon:RegisterMsg('COLONY_TAX_PAYMENT_RECV_SUCCESS', 'ON_COLONY_TAX_PAYMENT_RECV_SUCCESS');
end

function GET_COLONY_TAX_PAYMENT_BY_LOG_KEY(logKey)
	local paymentCount = session.colonytax.GetPaymentCount();
    local height = ui.GetControlSetAttribute("colony_tax_payment_elem", "height")
    for i=0, paymentCount-1 do
		local paymentElem = session.colonytax.GetPaymentByIndex(i);
        if logKey == paymentElem:GetLogKey() then
		    return session.colonytax.GetPaymentByIndex(i);
        end
    end
    return nil;
end

function ON_COLONY_TAX_PAYMENT_RECV_SUCCESS(frame, msg, logKey)
    local paymentElem = GET_COLONY_TAX_PAYMENT_BY_LOG_KEY(logKey);
    if paymentElem ~= nil then
        local silverStr = paymentElem:GetAmount();
        silverStr = GET_COMMAED_STRING(silverStr);
        ui.SysMsg(ScpArgMsg("ColonyTax_Payment_Received{Silver}", "Silver", silverStr));
    end

    session.colonytax.RemovePaymentByLogKey(logKey);

    local list_gb = GET_CHILD_RECURSIVELY(frame, "list_gb");
    list_gb:RemoveAllChild();
    CREATE_COLONY_TAX_PAYMENT_LIST(frame);
    silverStr = GET_COMMAED_STRING(silverStr);
end

function ON_OPEN_COLONY_TAX_PAYMENT(frame)
    local guidance_text = GET_CHILD_RECURSIVELY(frame, "guidance_text");
    local receiveDetailMsg = ScpArgMsg("ColonyTaxReceiveDetail{TaxReceiveTime}", "TaxReceiveTime", (COLONY_TAX_RECEIVE_PERIOD_MIN/1440));
    guidance_text:SetTextByKey("value", receiveDetailMsg);
    
    CREATE_COLONY_TAX_PAYMENT_LIST(frame)
end

function CREATE_COLONY_TAX_PAYMENT_LIST(frame)
	local paymentCount = session.colonytax.GetPaymentCount();
    local list_gb = GET_CHILD_RECURSIVELY(frame, "list_gb")
    local height = ui.GetControlSetAttribute("colony_tax_payment_elem", "height")
    for i=0, paymentCount-1 do
		local paymentElem = session.colonytax.GetPaymentByIndex(i);
        local ctrlset = list_gb:CreateOrGetControlSet("colony_tax_payment_elem", "payment_"..i, 0, i*height)
        AUTO_CAST(ctrlset)
        ctrlset:SetUserValue("Type", "PaymentCtrl")
        ctrlset:SetUserValue("LogKey", paymentElem:GetLogKey())
        local date_text = GET_CHILD_RECURSIVELY(ctrlset, "date_text")
        local taxamount_text = GET_CHILD_RECURSIVELY(ctrlset, "taxamount_text")
        local expire_text = GET_CHILD_RECURSIVELY(ctrlset, "expire_text")
        local textStyle = ctrlset:GetUserConfig("REMAIN_DAY_STYLE")

        local provideTime = paymentElem:GetProvideTime()
        local remainSec = imcTime.GetDifSec(paymentElem:GetEndTime(), geTime.GetServerSystemTime())
        if remainSec < 86400 then
            textStyle = ctrlset:GetUserConfig("REMAIN_HOUR_STYLE")
        end
        date_text:SetTextByKey("year", provideTime.wYear)
        date_text:SetTextByKey("month", provideTime.wMonth)
        date_text:SetTextByKey("day", provideTime.wDay)

        local amountStr = paymentElem:GetAmount()
        taxamount_text:SetTextByKey("value", GET_COMMAED_STRING(amountStr))
        expire_text:SetTextByKey("value", textStyle..GET_COLONY_TAX_EXPIRE_TEXT(remainSec))
    end
    SET_COLONY_TAX_PAYMENT_LIST_SKIN(GET_COLONY_TAX_PAYMENT_LIST(frame), "none", "midle_line_skin")
end

function GET_COLONY_TAX_PAYMENT_LIST(frame)
    local list_gb = GET_CHILD_RECURSIVELY(frame, "list_gb")
	local cnt = GET_CHILD_COUNT_BY_USERVALUE(list_gb, "Type", "PaymentCtrl");
    local list = {}
    for i=1, cnt do
        local ctrlset = GET_CHILD(list_gb, "payment_"..i)
        list[#list+1] = ctrlset
    end
    return list
end

function GET_COLONY_TAX_PAYMENT_RECV(parent, ctrl)
    local ctrlset = parent:GetAboveControlset()
    local logKeyStr = ctrlset:GetUserValue("LogKey")
    if logKeyStr ~= "None" then
        session.colonytax.ReqTaxPayment(logKeyStr)
    end
end

function GET_COLONY_TAX_PAYMENT_RECV_ALL(parent, ctrl)

end