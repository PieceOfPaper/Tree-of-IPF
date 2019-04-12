-- tpshop_server.lua


function SCR_TX_TP_SHOP(pc, argList)

	if #argList < 1 then
		return
	end

	local aobj = GetAccountObj(pc);
	local etcObj = GetETCObject(pc);
	if aobj == nil or etcObj == nil then
		return
	end

	local isLimitPaymentState = nil;
	local isGlobalServer = GetServerNation() == 'GLOBAL';

	--스팀 카드 도용 방지를 위한 월 결제 한도가 걸려있는지 확인하는 함수
	if isGlobalServer == true then
		isLimitPaymentState = CHECK_LIMIT_PAYMENT_STATE(pc);
		if isLimitPaymentState == nil then
			isLimitPaymentState = false;
		end	
	end

	if isLimitPaymentState == true then
		local isOver = CHECK_SPENT_PAYMENT_VALUE_OVER(pc, nil);
		if isOver == true then
			return;
		end
	end

	local itemListPrice = 0;
	for i = 1, #argList do 
		local tpitem = GetClassByType("TPitem",argList[i])
		if tpitem == nil then
			return
		end
		itemListPrice = itemListPrice + tpitem.Price;
	end

	if isLimitPaymentState == true then
		local isOver = CHECK_SPENT_PAYMENT_VALUE_OVER(pc, itemListPrice);
		if isOver == true then
			return;
		end
	end

	local freeMedal = aobj.GiftMedal + aobj.Medal

	for i = 1, #argList do
		local tpitem = GetClassByType("TPitem",argList[i])
		if tpitem == nil then
			return
		end

		if 0 > GetPCTotalTPCount(pc) - tpitem.Price then
			return
		end

		local itemcls = GetClass("Item",tpitem.ItemClassName)
		if itemcls == nil then
			return
		end
		
		if isLimitPaymentState == true then
			if false == PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, tpitem.Price, freeMedal) then
				return;
			end
		end

		local tx = TxBegin(pc);
		if tx == nil then
			return
		end

		if itemcls.ClassName == "PremiumToken" and pc.Lv < 150 then

			local curDBTime = GetDBTime()
			local nextBuyableTime = imcTime.AddSec(curDBTime, 60 * 60 * 24);

			local curDBTimeStr = string.format("%04d%02d%02d%02d%02d%02d", curDBTime.wYear, curDBTime.wMonth, curDBTime.wDay, curDBTime.wHour, curDBTime.wMinute, curDBTime.wSecond)
			local nextBuyableTimeStr = string.format("%04d%02d%02d%02d%02d%02d", nextBuyableTime.wYear, nextBuyableTime.wMonth, nextBuyableTime.wDay, nextBuyableTime.wHour, nextBuyableTime.wMinute, nextBuyableTime.wSecond)

			local buyableTime = aobj.NextBuyTokenTime;
			if buyableTime == "None" or buyableTime == nil or buyableTime == "" then
				TxSetIESProp(tx, aobj, 'NextBuyTokenTime', nextBuyableTimeStr);
			else
				if buyableTime < curDBTimeStr then
					TxSetIESProp(tx, aobj, 'NextBuyTokenTime', nextBuyableTimeStr);
				else					
					SendSysMsg(pc, "NextTokenBuyableTime", 0, "Year", string.sub(buyableTime, 1, 4), "Month", string.sub(buyableTime, 5, 6), "Day", string.sub(buyableTime, 7, 8), "Hour", string.sub(buyableTime, 9, 10), "Minute", string.sub(buyableTime, 11, 12));
					TxRollBack(tx);
					return;
				end
			end	
		end
		
		local cmdIdx = TxGiveItem(tx, itemcls.ClassName, 1, "NpcShop");
		itemID = TxGetGiveItemID(tx, cmdIdx);
		local logType = "NpcShop:";
		logType = logType ..tostring(itemcls.ClassID)..":";
		logType = logType ..tostring(itemID);
		TxAddIESProp(tx, aobj, "Medal", -tpitem.Price, "NpcShop:"..itemcls.ClassID..":"..itemID, cmdIdx);

		--스팀 카드 도용관련 프로퍼티 증가
		if isLimitPaymentState == true then
			TX_LIMIT_PAYMENT_STATE(pc, tx, tpitem.Price, freeMedal)
		end

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			CustomMongoLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end
end


function TX_LIMIT_PAYMENT_STATE(pc, tx, itemPrice, freeMedal)
	local aobj = GetAccountObj(pc);
	local lastPaymentMonth = TryGetProp(aobj, "LastPaymentMonth");
	local curTime = GetDBTime()
	local curSysTimeStr = string.format("%04d%02d", curTime.wYear, curTime.wMonth);
	local numCurTime = tonumber(curSysTimeStr);
	if numCurTime > lastPaymentMonth then
		TxSetIESProp(tx, aobj, "LastPaymentMonth", numCurTime);
		if freeMedal > 0 then
			local freeMedal = freeMedal - itemPrice;
			if freeMedal < 0 then
				TxSetIESProp(tx, aobj, "SpentPaymentValue", math.abs(freeMedal));
			end
		else
			TxSetIESProp(tx, aobj, "SpentPaymentValue", itemPrice);
		end			
	else
		if freeMedal > 0 then
			local freeMedal = freeMedal - itemPrice;
			if freeMedal < 0 then
				TxAddIESProp(tx, aobj, "SpentPaymentValue", math.abs(freeMedal));
			end
		else
			TxAddIESProp(tx, aobj, "SpentPaymentValue", itemPrice);
		end
	end
	

	return true;
end



function PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, itemPrice, freeTP)
	local aobj = GetAccountObj(pc);
	local limitConst = VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT;
	local spentPaymentValue = aobj.SpentPaymentValue;
	local lastPaymentMonth = TryGetProp(aobj, "LastPaymentMonth");
	local curTime = GetDBTime()
	local curSysTimeStr = string.format("%04d%02d", curTime.wYear, curTime.wMonth);
	local numCurTime = tonumber(curSysTimeStr);
	local addPrice = itemPrice - freeTP

	if addPrice < 0 then
		 addPrice = 0
	end

	if spentPaymentValue + addPrice > limitConst then
		if numCurTime > lastPaymentMonth then
			return true
		else
			return false;
		end
	else
		return true;
	end
end

function CHECK_LIMIT_PAYMENT_STATE(pc)
	local aobj = GetAccountObj(pc);
	--TryGetProp를 쓰지 않는 이유는 이 부분은 필수로 지켜져야 되는 부분이라 없으면 그냥 스크립트가 죽는게 좋음
	local limitPaymentStateBySteam = aobj.LimitPaymentStateBySteam;
	local limitPaymentStateByGM = aobj.LimitPaymentStateByGM;

	if limitPaymentStateBySteam == "Trusted" or limitPaymentStateByGM == "Trusted" then
		return false;
	end

	return true;
end

function CHECK_SPENT_PAYMENT_VALUE_OVER(pc, addValue)
	
	local aobj = GetAccountObj(pc);
	if aobj == nil then
		return false;
	end
	
	local spentPaymentValue = TryGetProp(aobj, "SpentPaymentValue");
	local lastPaymentMonth = TryGetProp(aobj, "LastPaymentMonth");
    local curTime = GetDBTime()
	local curSysTimeStr = string.format("%04d%02d", curTime.wYear, curTime.wMonth);
	local numCurTime = tonumber(curSysTimeStr);

	if spentPaymentValue == nil then
		return false;
	end

	if addValue == nil then
		if VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT < spentPaymentValue then
			if numCurTime > lastPaymentMonth then
				return false;
			else
				return true;
			end
		end
	else
		if VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT < (spentPaymentValue + addValue) then
			if numCurTime > lastPaymentMonth then
				return false;
			else
				return true;
			end		
		else
			return false;
		end
	end

	return false;
end

function TEST_SET_PAYMENT_STATE(pc, steam, gm)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	if steam == nil then
		TxSetIESProp(tx, aObj, "LimitPaymentStateBySteam", "Active");
	elseif steam == "T" then
		TxSetIESProp(tx, aObj, "LimitPaymentStateBySteam", "Trusted");
	elseif steam == "A" then
		TxSetIESProp(tx, aObj, "LimitPaymentStateBySteam", "Active");
	end

	if gm == nil then
		TxSetIESProp(tx, aObj, "LimitPaymentStateByGM", "Active");
	elseif gm == "T" then
		TxSetIESProp(tx, aObj, "LimitPaymentStateByGM", "Trusted");
	elseif gm == "A" then
		TxSetIESProp(tx, aObj, "LimitPaymentStateByGM", "Active");
	end

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function TEST_SET_TP(pc, gift, free)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	if free == nil then
		free = 0
	end

	if gift == nil then
		gift = 0
	end

	TxSetIESProp(tx, aObj, "GiftMedal", free);
	TxSetIESProp(tx, aObj, "Medal", free);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function TEST_SET_MONTH(pc, month)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	if month == nil then
		month = 0
	end

	TxSetIESProp(tx, aObj, "LastPaymentMonth", month);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function TEST_LIMIT_RESET(pc)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	if month == nil then
		month = 0
	end

	TxSetIESProp(tx, aObj, "SpentPaymentValue", 0);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function TEST_LIMIT_PRINT_INFO(pc)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end

	Chat(pc, aObj.LimitPaymentStateBySteam)
	Chat(pc, aObj.LimitPaymentStateByGM)
	Chat(pc, aObj.LastPaymentMonth)
	Chat(pc, aObj.SpentPaymentValue)

end