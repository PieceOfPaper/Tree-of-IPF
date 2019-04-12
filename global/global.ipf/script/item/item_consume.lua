function SCR_USE_ITEM_INDUN_COUNT_RESET(self, itemGUID, argList)

	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= 'Premium_indunReset' and invItem.ClassName ~= 'Premium_indunReset_14d' and invItem.ClassName ~= 'Premium_indunReset_14d_test' and invItem.ClassName ~= 'Premium_indunReset_1add' and invItem.ClassName ~= 'Premium_indunReset_1add_14d' and invItem.ClassName ~= 'indunReset_1add_14d_NoStack' and invItem.ClassName ~= 'Event_1704_Premium_indunReset_1add' and invItem.ClassName ~= 'Event_1704_Premium_indunReset' and invItem.ClassName ~= 'Premium_indunReset_TA' then 
		-- 이거 차후 위험요소 있음. 
		-- Premium_indunReset 아이템을 소모해서 Premium_indunReset_14d_test 한 것과 같은 효과를 낼 수 있다.
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end
	local pcetc = GetETCObject(self);

	local countType1 = "InDunCountType_100";
	local countType2 = "InDunCountType_200";

	if pcetc[countType1] == 0 and pcetc[countType2] == 0 then
		return;
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end

	TxTakeItemByObject(tx, invItem, 1, "use");
	if pcetc[countType1] > 0 then
	    if invItem.ClassName == 'Premium_indunReset_1add' or invItem.ClassName == 'Premium_indunReset_1add_14d' or invItem.ClassName == 'indunReset_1add_14d_NoStack' or invItem.ClassName == 'Event_1704_Premium_indunReset_1add' then
	        TxSetIESProp(tx, pcetc, countType1, pcetc[countType1] - 1);
	    else
	        TxSetIESProp(tx, pcetc, countType1, 0);
	    end
	end

	if pcetc[countType2] > 0 then
	    if invItem.ClassName == 'Premium_indunReset_1add' or invItem.ClassName == 'Premium_indunReset_1add_14d' or invItem.ClassName == 'indunReset_1add_14d_NoStack' or invItem.ClassName == 'Event_1704_Premium_indunReset_1add' then
	        TxSetIESProp(tx, pcetc, countType2, pcetc[countType2] - 1);
	    else
	        TxSetIESProp(tx, pcetc, countType2, 0);
	    end
	end

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		PremiumItemMongoLog(self, "IndunReset", "Use", 0);
		PlayEffect(self, 'F_sys_TOKEN_open', 2.5, 1, "BOT", 1);
		-- SendAddOnMsg(self, "INDUN_COUNT_RESET", '', 0) -- 쓰지도 않는데 왜 메세지 뿌리지.
	end
end