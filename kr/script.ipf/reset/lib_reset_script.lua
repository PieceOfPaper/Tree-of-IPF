--lib_reset_script.lua

function RESET_SCRIPT_LIST(pc)
	RESET_INDUN_COUNT(pc);
    RESET_FISHING_SUCCESS_COUNT(pc);
    RESET_ADVENTURE_BOOK_REWARD_INFO(pc);
    RESET_INDUN_WEEKLY_ENTERED_COUNT(pc);

if GetServerNation() == 'GLOBAL' then
        RESET_LAST_PAYMENT_VALUE(pc);
    end 
end

function RESET_LAST_PAYMENT_VALUE(pc)
   	local aobj = GetAccountObj(pc);
	if aobj == nil then
		return;
	end

    local lastPaymentValue = TryGetProp(aobj, "LastPaymentMonth");
    local spentPaymentValue = TryGetProp(aobj, "SpentPaymentValue");
    local curTime = GetDBTime()
	local curSysTimeStr = string.format("%04d%02d", curTime.wYear, curTime.wMonth);
	local numCurTime = tonumber(curSysTimeStr);
	if numCurTime > lastPaymentValue then
        local tx = TxBegin(pc);
        if tx == nil then
            return;
        end
        if spentPaymentValue ~= 0 then
            TxSetIESProp(tx, aobj, 'SpentPaymentValue', 0);
        end

        TxSetIESProp(tx, aobj, 'LastPaymentMonth', numCurTime);
        local ret = TxCommit(tx);
        if ret == 'SUCCESS' then
            return;
        end
	end
end