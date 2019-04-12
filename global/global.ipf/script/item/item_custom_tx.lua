function SCR_TX_TRADE_SELECT_ITEM(pc, argStr)
	
	local argList = StringSplit(argStr, '#');
	local itemGuid = argList[1];
	local selected = argList[2];

	local item, count = GetInvItemByGuid(pc, itemGuid);
	if item == nil then
		return;
	end
	
	if item.ItemLifeTimeOver == 1 then
		SendSysMsg(pc, "CannotUseLifeTimeOverItem");
		return
	end

	local cls = GetClass("TradeSelectItem", item.ClassName);

	if cls == nil then
		return;
	end

	local giveItemName = TryGetProp(cls, "SelectItemName_"..selected);
	local giveItemCount = TryGetProp(cls, "SelectItemCount_"..selected);

	if giveItemName == nil or giveItemCount == nil then
		return;
	end

	-- Steam Event Start --
	if item.ClassName == 'Steam_Event_Weapon_Select_Box_14day' then -- @@Steam Returning Event Start@@ --
		if pc.Lv >= 230 then
			local tx = TxBegin(pc);
			TxEnableInIntegrate(tx);
			TxTakeItemByObject(tx, item, 1, "TradeSelectItem");
			local cmdIdx_Global_Event = TxGiveItem(tx, giveItemName, giveItemCount, "TradeSelectItem");
			TxAppendProperty(tx, cmdIdx_Global_Event, 'Transcend', 3)
			TxAppendProperty(tx, cmdIdx_Global_Event, 'Reinforce_2', 10);
			local ret = TxCommit(tx);
		else
			SysMsg(pc, "Instant", ScpArgMsg("EV161215_NEXONCASHBOX_MSG1","LV",230));
		end -- @@Steam Returning Event Start@@ --
	else
		local tx = TxBegin(pc);
		TxEnableInIntegrate(tx);
		TxTakeItemByObject(tx, item, 1, "TradeSelectItem");
		TxGiveItem(tx, giveItemName, giveItemCount, "TradeSelectItem");
		local ret = TxCommit(tx);
	end
end