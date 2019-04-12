-- tpshop_server.lua

local eventUserType = {
	normalUser = 0,		-- 일반
	returnUser = 1, -- 복귀유저
	newbie  = 2,	-- 신규
};

function SCR_TX_TP_SHOP(pc, argList)
	if #argList < 1 then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: argError- aid['..GetPcAIDStr(pc)..']');
		return
	end

	local aobj = GetAccountObj(pc);
	local etcObj = GetETCObject(pc);
	if aobj == nil or etcObj == nil then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: account or etc object is nil- aid['..GetPcAIDStr(pc)..']');
		return
	end

	local tpitem = nil;
	
	for i = 1, #argList do
		tpitem = GetClassByType("TPitem", argList[i])
		
		if tpitem ~= nil then 
			local startProp = TryGetProp(tpitem, "SellStartTime");
			local endProp = TryGetProp(tpitem, "SellEndTime");

			if startProp ~= nil and endProp ~= nil then
				if startProp ~= "None" and endProp ~= "None" then
					local curTime = GetDBTime()
					local curSysTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
					local startTime = TryGetProp(tpitem, "SellStartTime")
					local endTime = TryGetProp(tpitem, "SellEndTime");
					local curYear = curTime.wYear
					if startTime > endTime then
						curYear = curYear + 1
					end

                    local curYear = curTime.wYear
                    local endYear = curTime.wYear
                    startTime, curYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT_SERVER(startTime)
                    endTime, endYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT_SERVER(endTime)
                    startTime = tonumber(startTime)
                    endTime = tonumber(endTime)

					local startSysTimeStr = string.format("%04d%09d%02d", curYear, startTime, '00')	
					local endSysTimeStr = string.format("%04d%09d%02d", endYear, endTime, '00')

					local curSysTime = imcTime.GetSysTimeByStr(curSysTimeStr)
					local startSysTime = imcTime.GetSysTimeByStr(startSysTimeStr)
					local endSysTime = imcTime.GetSysTimeByStr(endSysTimeStr)
					
					local startDifSec = imcTime.GetDifSec(startSysTime, curSysTime);
					local difSec = imcTime.GetDifSec(endSysTime, curSysTime);
		
					if 0 >= difSec then
						SendSysMsg(pc, "ExistSaleTimeExpiredItem")
						return
					end

					if 0 <= startDifSec then
						SendSysMsg(pc, "ExistSaleTimeExpiredItem")
						return
					end
				end
			end
		end
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
	--구매 불가능한 목록이 포함되어 있는지 검사한다.
	for i = 1, #argList do 
		local tpitem = GetClassByType("TPitem",argList[i])
		if tpitem == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end

		  --- TxBegin 들어가기전에 구매제한 걸린건 막는다.
		  if IS_ENABLE_BUY_TPITEM(pc, tpitem, 1) == false then
			SendSysMsg(pc, "IncludeCanNotBuyItem");
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
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end

		if 0 > GetPCTotalTPCount(pc) - tpitem.Price then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: lack of tp- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], totalTP['..GetPCTotalTPCount(pc)..'], price['..tpitem.Price..']');
			return
		end

		local itemcls = GetClass("Item",tpitem.ItemClassName)
		if itemcls == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: item class is nil- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], item['..tpitem.ItemClassName..']');
			return
		end
		
		if isLimitPaymentState == true then
			if false == PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, tpitem.Price, freeMedal) then
				return;
			end
		end
		
		local tx = TxBegin(pc);
		if tx == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: tx is nil- aid['..GetPcAIDStr(pc)..']');
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
        
		local limit, limitCount = GET_LIMITATION_TO_BUY(tpitem.ClassID);        
		if limit ~= 'NO' then
			TxAddBuyLimitCount(tx, 0, tpitem.ClassID, 1, limitCount);
		end
		
		--스팀 카드 도용관련 프로퍼티 증가
		if isLimitPaymentState == true then
			TX_LIMIT_PAYMENT_STATE(pc, tx, tpitem.Price, freeMedal)
		end

		local premiumDiff = 0; -- steam event --
		if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then 
			local currentFreeMedal = aobj.GiftMedal + aobj.Medal
			if tpitem.Price > currentFreeMedal then
				premiumDiff = tpitem.Price - currentFreeMedal
			end
			TxAddIESProp(tx, aobj, "EVENT_STEAM_TPSHOP_BUY_PRICE", premiumDiff, "PoPo_Shop_Prop"); 
		end -- steam event --
		
		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then -- steam event --
				if premiumDiff > 0 then 
					local premiumDiff_Popo = premiumDiff * 2
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", "Try", "ex_point", premiumDiff_Popo)
					local pointResult = GivePCBangPointShopPoint(pc, premiumDiff_Popo, "PoPo_Shop")
					local point_Type = "fail"
					if pointResult == 1 then
						point_Type = 'SUCCESS'
					end
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", point_Type, "point", premiumDiff_Popo)
				end
			end -- steam event --
			CustomMongoLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			CustomMongoCashLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		else
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_TP_SHOP: Tx Fail- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..']');
		end
	end
end


-- 신규유저 TP 샵
function SCR_TX_NEWBIE_TP_SHOP(pc, argList)
    if IsDummyPC(pc) == 1 then
        return
    end

	 --신규 유저 확인.
	 local userType, startDate, retCount = GetEventUserType(pc, 1);
	 if userType ~= eventUserType.newbie then
		return;
	 end

	 if #argList < 1 then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: argError- aid['..GetPcAIDStr(pc)..']');
		return
	end

	local aobj = GetAccountObj(pc);
	local etcObj = GetETCObject(pc);
	if aobj == nil or etcObj == nil then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: account or etc object is nil- aid['..GetPcAIDStr(pc)..']');
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

	--구매 불가능한 목록이 포함되어 있는지 검사한다.
	for i = 1, #argList do
		local tpitem = GetClassByType("TPitem_User_New",argList[i])
		if tpitem == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end

        --- TxBegin 들어가기전에 구매제한 걸린건 막는다.
		if IS_ENABLE_BUY_TPITEM_WITH_SHOPTYPE(pc, tpitem, 1, userType) == false then
		   SendSysMsg(pc, "IncludeCanNotBuyItem");
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
		local tpitem = GetClassByType("TPitem_User_New", argList[i]);		
		if tpitem == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end

		if 0 > GetPCTotalTPCount(pc) - tpitem.Price then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: lack of tp- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], totalTP['..GetPCTotalTPCount(pc)..'], price['..tpitem.Price..']');
			return
		end

		local itemcls = GetClass("Item",tpitem.ItemClassName)
		if itemcls == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: item class is nil- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], item['..tpitem.ItemClassName..']');
			return
		end

		if isLimitPaymentState == true then
			if false == PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, tpitem.Price, freeMedal) then
				return;
			end
		end
		
		local tx = TxBegin(pc);
		if tx == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: tx is nil- aid['..GetPcAIDStr(pc)..']');
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

		local cmdIdx = TxGiveItem(tx, itemcls.ClassName, 1, "Newbie_Shop"); -- PremiumItemGet 컬렉션 Reason : Newbie_Shop
		itemID = TxGetGiveItemID(tx, cmdIdx);
		TxAddIESProp(tx, aobj, "Medal", -tpitem.Price, "Newbie_Shop:"..itemcls.ClassID..":"..itemID, cmdIdx); -- TP 사용로그
        
        local limit, limitCount = GET_LIMITATION_TO_BUY_WITH_SHOPTYPE(tpitem.ClassID, userType);        
		if limit ~= 'NO' then
			TxAddBuyLimitCount(tx, userType, tpitem.ClassID, 1, limitCount);
		end

		--스팀 카드 도용관련 프로퍼티 증가
		if isLimitPaymentState == true then
			TX_LIMIT_PAYMENT_STATE(pc, tx, tpitem.Price, freeMedal)
		end

		local premiumDiff = 0; -- steam event --
		if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then 
			local currentFreeMedal = aobj.GiftMedal + aobj.Medal
			if tpitem.Price > currentFreeMedal then
				premiumDiff = tpitem.Price - currentFreeMedal
			end
			TxAddIESProp(tx, aobj, "EVENT_STEAM_TPSHOP_BUY_PRICE", premiumDiff, "PoPo_Shop_Prop"); 
		end -- steam event --

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			-- 완료 후 현재 구매한 카운트.
			local currentBuyCount = GetBuyLimitCount(pc, userType, tpitem.ClassID); -- 잔여 구매 가능 횟수.
			-- 잔여 구매
			local remainBuyCnt = 0;
			if limit ~= 'NO' then
				remainBuyCnt = limitCount - currentBuyCount
			end

			if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then -- steam event --
				if premiumDiff > 0 then 
					local premiumDiff_Popo = premiumDiff * 2 
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", "Try", "ex_point", premiumDiff_Popo)
					local pointResult = GivePCBangPointShopPoint(pc, premiumDiff_Popo, "PoPo_Shop")
					local point_Type = "fail"
					if pointResult == 1 then
						point_Type = 'SUCCESS'
					end
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", point_Type, "point", premiumDiff_Popo)
				end
			end -- steam event --

			-- 전용 상점 로그.
			CustomMongoCashLog(pc,"Newbie_Shop", "ItemIDX", itemID, "ClassID", itemcls.ClassID, "ClassName", itemcls.ClassName, "Cnt", 1, "Price", tpitem.Price, "RemainBuyCnt", remainBuyCnt); -- 아이템 구매 로그
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		else
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_NEWBIE_TP_SHOP: Tx Fail- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..']');
		end
	end
end

-- 복귀 유저 TP 샵
function SCR_TX_RETURNUSER_TP_SHOP(pc, argList)
	if IsDummyPC(pc) == 1 then
        return
    end

	-- 복귀 유저 확인.
	local userType, startDate, retCount = GetEventUserType(pc, 1);
	if userType ~= eventUserType.returnUser then
		return;
	 end

	 if #argList < 1 then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: argError- aid['..GetPcAIDStr(pc)..']');
		return
	end

	local aobj = GetAccountObj(pc);
	local etcObj = GetETCObject(pc);
	if aobj == nil or etcObj == nil then
		IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: account or etc object is nil- aid['..GetPcAIDStr(pc)..']');
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
	--구매 불가능한 목록이 포함되어 있는지 검사한다.
	for i = 1, #argList do
		local tpitem = GetClassByType("TPitem_Return_User",argList[i])
		if tpitem == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end
		
        --- TxBegin 들어가기전에 구매제한 걸린건 막는다.
		if IS_ENABLE_BUY_TPITEM_WITH_SHOPTYPE(pc, tpitem, 1, userType) == false then
		   SendSysMsg(pc, "IncludeCanNotBuyItem");
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
		local tpitem = GetClassByType("TPitem_Return_User", argList[i]);		
		if tpitem == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: tpitem is nil- aid['..GetPcAIDStr(pc)..'], itemID['..argList[i]..']');
			return
		end

		if 0 > GetPCTotalTPCount(pc) - tpitem.Price then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: lack of tp- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], totalTP['..GetPCTotalTPCount(pc)..'], price['..tpitem.Price..']');
			return
		end

		local itemcls = GetClass("Item",tpitem.ItemClassName)
		if itemcls == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: item class is nil- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..'], item['..tpitem.ItemClassName..']');
			return
		end

		if isLimitPaymentState == true then
			if false == PRECHECK_TX_LIMIT_PAYMENT_OVER(pc, tpitem.Price, freeMedal) then
				return;
			end
		end
		
		local tx = TxBegin(pc);
		if tx == nil then
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: tx is nil- aid['..GetPcAIDStr(pc)..']');
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


		local cmdIdx = TxGiveItem(tx, itemcls.ClassName, 1, "ReturnUser_Shop"); -- PremiumItemGet 컬렉션 Reason : Newbie_Shop
		itemID = TxGetGiveItemID(tx, cmdIdx);
		TxAddIESProp(tx, aobj, "Medal", -tpitem.Price, "ReturnUser_Shop:"..itemcls.ClassID..":"..itemID, cmdIdx); -- TP 사용로그
        
        local limit, limitCount = GET_LIMITATION_TO_BUY_WITH_SHOPTYPE(tpitem.ClassID, userType);        
		if limit ~= 'NO' then
			TxAddBuyLimitCount(tx, userType, tpitem.ClassID, 1, limitCount);
		end

		--스팀 카드 도용관련 프로퍼티 증가
		if isLimitPaymentState == true then
			TX_LIMIT_PAYMENT_STATE(pc, tx, tpitem.Price, freeMedal)
		end

		local premiumDiff = 0; -- steam event --
		if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then 
			local currentFreeMedal = aobj.GiftMedal + aobj.Medal
			if tpitem.Price > currentFreeMedal then
				premiumDiff = tpitem.Price - currentFreeMedal
			end
			TxAddIESProp(tx, aobj, "EVENT_STEAM_TPSHOP_BUY_PRICE", premiumDiff, "PoPo_Shop_Prop"); 
		end -- steam event --

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			-- 완료 후 현재 구매한 카운트.
			local currentBuyCount = GetBuyLimitCount(pc, userType, tpitem.ClassID); -- 잔여 구매 가능 횟수.
			-- 잔여 구매
			local remainBuyCnt = 0;
			if limit ~= 'NO' then
				remainBuyCnt = limitCount - currentBuyCount
			end
			
			if EVENT_STEAM_POPOSHOP_PRECHECK() == 'YES' then -- steam event --
				if premiumDiff > 0 then 
					local premiumDiff_Popo = premiumDiff * 2 
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", "Try", "ex_point", premiumDiff_Popo)
					local pointResult = GivePCBangPointShopPoint(pc, premiumDiff_Popo, "PoPo_Shop")
					local point_Type = "fail"
					if pointResult == 1 then
						point_Type = 'SUCCESS'
					end
					CustomMongoLog(pc, "GivePCBangPointShopPoint", "Type", point_Type, "point", premiumDiff_Popo)
				end
			end -- steam event --

			-- 전용 상점 로그.
			CustomMongoCashLog(pc,"ReturnUser_Shop", "ItemIDX", itemID, "ClassID", itemcls.ClassID, "ClassName", itemcls.ClassName, "Cnt", 1, "Price", tpitem.Price, "RemainBuyCnt", remainBuyCnt, "ReturnCnt", retCount); -- 아이템 구매 로그
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		else
			IMC_LOG('ERROR_LOGIC', 'SCR_TX_RETURN_USER_TP_SHOP: Tx Fail- aid['..GetPcAIDStr(pc)..'], tpitem['..tpitem.ClassName..']');
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