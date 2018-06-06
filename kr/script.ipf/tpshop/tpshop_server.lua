-- tpshop_server.lua

function CHECK_EQUIP_PREMIUMITEM(pc, itemInfo, sendMsg, fromTpShop)
	if nil == sendMsg then
		sendMsg = 0;
	end

	if nil == fromTpShop then
		fromTpShop = 0;
	end

	local tpitem = nil;
	if 1 == fromTpShop then
		tpitem = GetClassByType("TPitem",itemInfo)
	else
		tpitem  = GetClassByStrProp("TPitem",'ItemClassName',itemInfo)
		if nil == tpitem then
			local itemcls = GetClass("Item", itemInfo)
			if itemcls == nil then
				SendSysMsg(pc,"DataError");
				return 0
			end

			if itemcls.GroupName ~= 'Premium' then
				SendSysMsg(pc,"DataError");
				return 0
			else
				return 1;
			end
		end
	end

	if tpitem == nil then
		SendSysMsg(pc,"DataError");
		return 0
	end

	local itemcls = GetClass("Item", tpitem.ItemClassName)
	if itemcls == nil then
		return 0
	end

	local useGender = TryGetProp(itemcls,'UseGender')
	if nil ~= useGender then
		if useGender =="Male" and pc.Gender ~= 1 then
			if 1 == sendMsg then
				SendSysMsg(pc,"Auto_yeoSeongeun_ChagyongHal_Su_eopSeupNiDa._aiTem_SeolMyeongeSeo_JangChag_KaNeungHan_SeongByeolKwa_LeBeleul_HwaginHaSeyo")
			end
			return 0
		elseif useGender == "Female" and pc.Gender ~= 2 then
			if 1 == sendMsg then
				SendSysMsg(pc,"Auto_NamSeongeun_ChagyongHal_Su_eopSeupNiDa._aiTem_SeolMyeongeSeo_JangChag_KaNeungHan_SeongByeolKwa_LeBeleul_HwaginHaSeyo")
			end
			return 0
		end
	end

	local etcObj = GetETCObject(pc);

	local prop = geItemTable.GetProp(itemcls.ClassID);
	if tpitem.SubCategory == "TP_Costume_Color" then
		local nowAllowedColor = etcObj['AllowedHairColor']
		if string.find(nowAllowedColor, itemcls.StringArg) ~= nil or TryGetProp(etc, "HairColor_"..itemcls.StringArg) == 1 then
			SendSysMsg(pc,"AlearyEquipColor");
			return 0
		end

		local invItem, invItemCnt = GetInvItemByType(pc, itemcls.ClassID);
		if invItem ~= nil or 0 < invItemCnt then
			SendSysMsg(pc,"AlearyEquipColor");
			return 0
		end

		local wareItem, wareCnt = GetWareInvItemByType(pc, itemcls.ClassID);
		if wareItem ~= nil or 0 < wareCnt then
			SendSysMsg(pc,"AlearyEquipColor");
			return 0
		end
	end

	if IS_EQUIP(itemcls) == true then
		if itemcls.ItemType == "Equip" and itemcls.ClassType2 == "Premium" then
			local Rootclasslist = imcIES.GetClassList('HairType');
			local Selectclass   = Rootclasslist:GetClass(pc.Gender);
			local Selectclasslist = Selectclass:GetSubClassList();
			local cnt		      = Selectclasslist:Count();
			for i = 0, cnt - 1 do
				local etcObj = GetETCObject(pc);
				local nextCls = Selectclasslist:GetByIndex(i);
				local EngName = imcIES.GetString(nextCls, 'EngName')
				if itemcls.StringArg == EngName then
					if EngName == etcObj.CurHairName or EngName == etcObj.StartHairName then 
    					if fromTpShop == 1 then
    						SendSysMsg(pc, "EquipPremiumItem");
	    					return 0;
	    				else
	    				    SendSysMsg(pc, "CarGoPremiumItem");
	    				    return 0;
    				    end
					end
				end
			end
		end
	end

	return 1;
end

function SCR_TX_TP_SHOP(pc, argList)

	if #argList < 1 then
		return
	end

	local aobj = GetAccountObj(pc);
	local etcObj = GetETCObject(pc);
	if aobj == nil or etcObj == nil then
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

					local startSysTimeStr = string.format("%04d%09d%02d", curYear, startTime, '00')	
					local endSysTimeStr = string.format("%04d%09d%02d", curYear, endTime, '00')

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

    -- 구매 불가능한 목록이 포함되어 있는지 검사한다.
    for i = 1, #argList do
        local tpitem = GetClassByType("TPitem", argList[i])
		if tpitem == nil then
			return
		end

        --- TxBegin 들어가기전에 구매제한 걸린건 막는다.
		if IS_ENABLE_BUY_TPITEM(pc, tpitem, 1) == false then
		   SendSysMsg(pc, "IncludeCanNotBuyItem");
		   return
		end
    end

	for i = 1, #argList do
		local tpitem = GetClassByType("TPitem",argList[i])
		if tpitem == nil then
			return
		end

		if 0 > GetPCTotalTPCount(pc) - tpitem.Price then
			return
		end

		local itemcls = GetClass("Item", tpitem.ItemClassName)
		if itemcls == nil then
			return
		end

		local tx = TxBegin(pc);
		if tx == nil then
			return
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

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			CustomMongoLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			CustomMongoCashLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end
end

function SCR_TX_RECYCLE_SELL(pc)

	local invList, itemCntList = GetDlgItemList(pc);
	
	if invList == nil or #invList < 1 then
		return;
	end

	for i = 1, #invList do

		local invitem = invList[i]
		local invitemcnt = itemCntList[i]

		if invitemcnt < 0 then
			return;
		end

		if invitem == nil then
			return
		end

		local itemcls = GetClassByType("Item",invitem.ClassID)
		if itemcls == nil then
			return
		end
        
		local sellitem = GetClass("recycle_shop",invitem.ClassName)
		if sellitem == nil then
			return
		end
        
		if sellitem.SellPrice == 0 then
			return;
		end

		local tx = TxBegin(pc);
		if tx == nil then
			return
		end

		TxTakeItemByObject(tx, invitem, invitemcnt, "RECYCLE_SHOP_SELL");
		TxGiveItem(tx, 'Recycle_Shop_Medal', sellitem.SellPrice * invitemcnt, 'RECYCLE_SHOP_SELL');

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end
	
end

function SCR_TX_RECYCLE_BUY(pc, argList)

	if #argList < 1 then
		return
	end

	for i = 1, #argList do
		local tpitem = GetClassByType("recycle_shop",argList[i])
		if tpitem == nil then
			return
		end

		if tpitem.BuyPrice == 0 then
			return;
		end

		local recyclemedalcls, recyclemedalcnt = GetInvItemByName(pc, "Recycle_Shop_Medal");

		if recyclemedalcls == nil then
			return;
		end

		if 0 > recyclemedalcnt - tpitem.BuyPrice then
			return
		end

		local itemcls = GetClass("Item",tpitem.ClassName)
		if itemcls == nil then
			return
		end

		local tx = TxBegin(pc);
		if tx == nil then
			return
		end

		TxGiveItem(tx, itemcls.ClassName, 1, "RECYCLE_SHOP_BUY");
		TxTakeItem(tx, "Recycle_Shop_Medal", tpitem.BuyPrice, "RECYCLE_SHOP_BUY");

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end
end


function CHECK_TPSHOP_MESSAGE_UPDATE(pc)
	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end

	local tpshopMessageIndex = aObj.TPShopMessageIndex;
	
--	print(tpshopMessageIndex)
	if tpshopMessageIndex >= 6 then
		return;
	end

	local itemObj = GetClassByType("TPitem", 7);

	local startTime = TryGetProp(itemObj, "SellStartTime");
	local endTime = TryGetProp(itemObj, "SellEndTime");

	if startTime == nil or endTime == nil or startTime =='None' or endTime == 'None' then
		return;
	end

	local curTime = GetDBTime();

	local curSysTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
	local curYear = curTime.wYear

	local startSysTimeStr = string.format("%04d%09d%02d", curYear, startTime, '00')
	local endSysTimeStr = string.format("%04d%09d%02d", curYear, endTime, '00')
	local curSysTime = imcTime.GetSysTimeByStr(curSysTimeStr)
	local startSysTime = imcTime.GetSysTimeByStr(startSysTimeStr)
	local endSysTime = imcTime.GetSysTimeByStr(endSysTimeStr)
	local startDifSec = imcTime.GetDifSec(startSysTime, curSysTime);
	local endDifSec = imcTime.GetDifSec(endSysTime, curSysTime);

--	print(startDifSec)
--	print(endDifSec)
	local remainStartTime_minute = 0;
	remainStartTime_minute = math.floor(startDifSec / 60) + 1
	local remainEndTime_minute = 0;
	remainEndTime_minute = math.floor(endDifSec / 60) + 1

	if endDifSec < 0 then
		return;
	elseif endDifSec < 600 and tpshopMessageIndex <= 5 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 6)
		ToAll(ScpArgMsg("TPShopSellEndMsg{REMAIN_TIME}", "REMAIN_TIME", remainEndTime_minute));
	elseif endDifSec < 1800 and tpshopMessageIndex <= 4 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 5)
		ToAll(ScpArgMsg("TPShopSellEndMsg{REMAIN_TIME}", "REMAIN_TIME", remainEndTime_minute));
	elseif endDifSec < 3600 and tpshopMessageIndex <= 3 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 4)
		ToAll(ScpArgMsg("TPShopSellEndMsg{REMAIN_TIME}", "REMAIN_TIME", remainEndTime_minute));
	elseif startDifSec > 0 and startDifSec < 600 and tpshopMessageIndex <= 2 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 3)
		ToAll(ScpArgMsg("TPShopSellStartMsg{REMAIN_TIME}", "REMAIN_TIME", remainStartTime_minute));
	elseif startDifSec > 0 and startDifSec < 1800 and tpshopMessageIndex <= 1 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 2)
		ToAll(ScpArgMsg("TPShopSellStartMsg{REMAIN_TIME}", "REMAIN_TIME", remainStartTime_minute));
	elseif startDifSec > 0 and startDifSec < 3600 and tpshopMessageIndex <= 0 then
		RunScript('TX_TPSHOP_MESSAGE_INDEX', pc, 1)
		ToAll(ScpArgMsg("TPShopSellStartMsg{REMAIN_TIME}", "REMAIN_TIME", remainStartTime_minute));
	end
end


function TX_TPSHOP_MESSAGE_INDEX(pc, index)

	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	TxSetIESProp(tx, aObj, "TPShopMessageIndex", index);
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function TEST_RESET_TPSHOP_MESSAGE(pc)

	local aObj = GetAccountObj(pc);
	if aObj == nil then
		return;
	end
	local tx = TxBegin(pc);

	TxSetIESProp(tx, aObj, "TPShopMessageIndex", 0);
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end

function SCR_TX_WING_STORE_BUY(pc, argList)
	if #argList < 1 then
		return
	end

	for i = 1, #argList do
		local tpitem = GetClassByType("WingStore", argList[i]);
		if tpitem == nil then
			return
		end

		if tpitem.Price == 0 then
			return;
		end

		local recyclemedalcls, recyclemedalcnt = GetInvItemByName(pc, "Wing_Shop_Coupon");
		if recyclemedalcls == nil then
			return;
		end

		if 0 > recyclemedalcnt - tpitem.Price then
			return;
		end

		local itemcls = GetClass("Item", tpitem.ItemClassName);
		if itemcls == nil then
			return
		end

        if IsShutDown("Item", itemcls.ClassName) == 1 or IsShutDown("ShutDownContent", "TPAndRecycle") == 1 then
            SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
            return;
        end
		
		local tx = TxBegin(pc);
		if tx == nil then
			return
		end

		TxGiveItem(tx, itemcls.ClassName, 1, "WING_STORE_BUY");
		TxTakeItem(tx, "Wing_Shop_Coupon", tpitem.Price, "WING_STORE_BUY");

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end
end

function IS_ENABLE_BUY_TPITEM(pc, tpItem, buyCount)
    local limit, limitCount = GET_LIMITATION_TO_BUY(tpItem.ClassID);
    if limit == 'NO' then
        return true;
    end

    local currentBuyCount = GetBuyLimitCount(pc, 0, tpItem.ClassID);
    if currentBuyCount + buyCount > limitCount then -- limitCount개 까지는 구매 가능해
        return false;
    end

    return true;
end