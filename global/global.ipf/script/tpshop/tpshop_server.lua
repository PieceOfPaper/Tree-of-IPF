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

	for i = 1, #argList do
		if 0 == CHECK_EQUIP_PREMIUMITEM(pc, argList[i], 0, 1) then
			return;
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

		local itemcls = GetClass("Item",tpitem.ItemClassName)
		if itemcls == nil then
			return
		end
		
		local tx = TxBegin(pc);
		if tx == nil then
			return
		end

		if itemcls.ClassName == "PremiumToken" and pc.Lv < 150 then
		
			local now = os.time()
			local nowtime = os.date("%c",now)
			local nextbuyabletime = os.date("%c",now+(60*60*24))

			
			local buyabletime = aobj.NextBuyTokenTime;

			if buyabletime == "None" then
				TxSetIESProp(tx, aobj, 'NextBuyTokenTime', nextbuyabletime);
			else

				local ymhbuyabletime = string.sub(buyabletime,7,8) .. string.sub(buyabletime,0,5) .. string.sub(buyabletime,9)
				local ymhnowtime = string.sub(nowtime,7,8) .. string.sub(nowtime,0,5) .. string.sub(nowtime,9)

				if ymhbuyabletime < ymhnowtime then 
					TxSetIESProp(tx, aobj, 'NextBuyTokenTime', nextbuyabletime);
				else
					SendSysMsg(pc, "NextTokenBuyableTime", 0, "Time", buyabletime);
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

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			CustomMongoLog(pc,"TpshopBuyList","AllPrice",tostring(allprice),"Items", itemcls.ClassName)
			SendAddOnMsg(pc, "TPSHOP_BUY_SUCCESS", "", 0);
		end
	end


end