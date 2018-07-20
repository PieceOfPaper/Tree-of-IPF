-- legendcardupgrade_server.lua

function SCR_LEGENDCARD_UPGRADE_TX(pc, argList)	
	local itemList = GetDlgItemList(pc);

	if #itemList < 1 then
		return;
	end
	--넘겨온 아이템 검증 해야함

	for i = 1, #itemList do
		local invCardItem = GetInvItemByGuid(pc, GetItemGuid(itemList[i]))
		if invCardItem == nil then
			return
		end

		if IsFixedItem(invCardItem) == 1 then
			return
		end

		if i+1 <= #itemList then
			for j = i + 1, #itemList do
				local otherSlotItem = GetInvItemByGuid(pc, GetItemGuid(itemList[j]))
				if GetItemGuid(itemList[i]) == GetItemGuid(itemList[j]) then
					return
				end
			end
		end		
	end

	local legendCard = itemList[1];
	local materialCardList = {};
	if #itemList > 1 then
		for i = 2, #itemList do
			materialCardList[i - 1] = itemList[i]
		end
	end

	if legendCard == nil then
		return;
	end

	local successRatio, failRatio, brokenRatio, needPoint, totalGivePoint = CALC_LEGENDCARD_UPGRADE_RATIO(legendCard, materialCardList)

	local resultFlag = 0;
	local randomResult = IMCRandom(1, 100)
	local resultText = "";

	if randomResult <= successRatio then
		resultFlag = 1;
		resultText = "Success"
		--성공
	elseif successRatio < randomResult and randomResult <= successRatio + failRatio then
		resultFlag = 2
		resultText = "Fail"
		--실패
	elseif successRatio + failRatio < randomResult and randomResult <= successRatio + failRatio + brokenRatio then
		resultFlag = 3
		resultText = "Destroy"
		--파괴
	else
		resultFlag = 0
	end


	local materialCardClassIDList = {};
	local materialCardClassNameList = {};
	local materialCardLvList = {};

	local tx = TxBegin(pc);
	--재료 카드들 take
	for i = 1, #materialCardList do
		materialCardClassIDList[i] = materialCardList[i].ClassID
		materialCardClassNameList[i] = materialCardList[i].ClassName
		materialCardLvList[i] = GET_ITEM_LEVEL(materialCardList[i])
		TxTakeItemByObject(tx, materialCardList[i], 1, "LegendCard_Upgrade_material");
		
	end

	--재료 아이템 take

	local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
	local legendCardLv = GET_ITEM_LEVEL(legendCard)
	local beforeLegendCardLv = legendCardLv
	local needReinforceItem = 'None';
	local needReinforceItemCount = 0;
	local destroyReward = ""
	local destroyRewardExp = ""
	local materialItemID = 646069

	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(legendCardReinforceList,i);
		local cardLv = TryGetProp(cls, "CardLevel");
		local reinforceType = TryGetProp(cls, 'ReinforceType')
		if cardLv == legendCardLv and reinforceType == 'LegendCard' and legendCard.CardGroupName ~= nil and legendCard.CardGroupName == 'LEG' then
			needReinforceItem = TryGetProp(cls, 'NeedReinforceItem')
			needReinforceItemCount = TryGetProp(cls, 'NeedReinforceItemCount')
			destroyReward = TryGetProp(cls, 'DestroyReward')
			destroyRewardExp = TryGetProp(cls, "ItemProperty")
			local materialItemCls = GetClass("Item", needReinforceItem)
			materialItemID = materialItemCls.ClassID
		end
	end

	if needReinforceItem ~= nil and needReinforceItem ~= 'None' then
		local needItemCls = GetClass("Item", needReinforceItem)
		local needInvItem, cnt = GetInvItemByName(pc, needReinforceItem)
		
		if cnt < needReinforceItemCount then
			return
		end
		
		TxTakeItemByObject(tx, needInvItem, needReinforceItemCount, "LegendCard_Upgrade_material")
	end
	local tempItemGUID = GetItemGuid(legendCard);
	local tempItemID = legendCard.ClassID;
	local tempItemName = legendCard.ClassName;
	local isItemTake = false;
	local afterLegendCardLv = beforeLegendCardLv

	local destroyRewardCls = GetClass("Item", destroyReward)
	local destroyRewardClassID = nil
	local destroyRewardCount = 0;
	local destroyRewardGUID = "";

	if resultFlag == 1 then
		TxAddIESProp(tx, legendCard, 'ItemExp', needPoint)
		afterLegendCardLv = afterLegendCardLv + 1
	elseif resultFlag == 2 then
	elseif resultFlag == 3 then
		TxTakeItemByObject(tx, legendCard, 1, "LegendCard_Upgrade_broken")
		if destroyReward ~= nil and destroyReward ~= 'None' then
			destroyRewardCount = 1
			local cmdIdx = TxGiveItem(tx, destroyReward, destroyRewardCount, "LegendCard_Upgrade_broken")
			
			TxAppendProperty(tx, cmdIdx, "ItemExp", destroyRewardExp);
			destroyRewardGUID = TxGetGiveItemID(tx, cmdIdx);

			if destroyRewardCls ~= nil then
				destroyRewardClassID = destroyRewardCls.ClassID
				
			end
			isItemTake = true;
		end		
		afterLegendCardLv = 0
	end
	
	local ret = TxCommit(tx);	
	
	if ret ~= "SUCCESS" then		
	--트랜잭션 실패
		return;
	else
		--몽고로그 남기기
		InvalidateStates(pc);
		local stringScp = string.format("LEGENDCARD_UPGRADE_UPDATE(%d, %d, %d)", resultFlag, beforeLegendCardLv, afterLegendCardLv);
		ExecClientScp(pc, stringScp);
		local itemObj = GetInvItemByGuid(pc, destroyRewardGUID);
		local rewardLv = 0
		if itemObj ~= nil then
			rewardLv = GET_ITEM_LEVEL(itemObj)
		end
		
		LegendCardReinforceMongoLog(pc, tempItemGUID, tempItemID, tempItemName, legendCardLv, resultText, afterLegendCardLv, destroyRewardClassID, rewardLv, destroyRewardCount, totalGivePoint, materialCardClassIDList, materialCardClassNameList, materialCardLvList, materialItemID, needReinforceItemCount)
	end
	InvalidateStates(pc);
end



function CALC_LEGENDCARD_UPGRADE_RATIO(legendCardObj, materialCardList)
	if legendCardObj == nil then
		return 0, 0, 0
	end

	if #materialCardList < 1 then
		return 0, 40, 60
	end

	local needPoint = 0
	local legendCardType = TryGetProp(legendCardObj, 'Reinforce_Type')
	if legendCardType ~= 'Legend_Card' then
		needPoint = 0
	end
	local legendCardLv = GET_ITEM_LEVEL(legendCardObj)
	
	local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(legendCardReinforceList,i);
		local cardLv = TryGetProp(cls, "CardLevel");
		local reinforceType = TryGetProp(cls, "ReinforceType")
		
		if cardLv == legendCardLv and reinforceType == legendCardType then
			needPoint = TryGetProp(cls, "NeedPoint")
		end
	end

	if needPoint == 0 then
		return 0, 40, 60
	end

	local totalGivePoint = 0;
	for i = 1, #materialCardList do
		local materialCardObj = materialCardList[i]
		local materialCardType = TryGetProp(materialCardObj, 'Reinforce_Type')
		local materialCardLv = GET_ITEM_LEVEL(materialCardObj)

		local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(legendCardReinforceList,i);
			local cardLv = TryGetProp(cls, "CardLevel");
			local reinforceType = TryGetProp(cls, "ReinforceType")
		
			if cardLv == materialCardLv and reinforceType == materialCardType then
				totalGivePoint = totalGivePoint + TryGetProp(cls, "GivePoint")
			end
		end
	end

	local givePerNeedPoint = 0
	if needPoint == 0 then
		givePerNeedPoint = 0
	else
		givePerNeedPoint = totalGivePoint / needPoint
	end

	local successRatio = 0
	local failRatio = 0
	local brokenRatio = 0

	successRatio = math.floor(givePerNeedPoint * 100 + 0.5)
	failRatio = math.floor((1 - givePerNeedPoint) * 0.4 * 100 + 0.5)
	brokenRatio = math.floor((1 - givePerNeedPoint) * 0.6 * 100 + 0.5)

	if givePerNeedPoint >= 0.995 then
		successRatio = 100
	end

	if successRatio > 100 then
		successRatio = 100
	elseif successRatio < 0 then
		successRatio = 0
	end

	if failRatio > 100 then
		failRatio = 100
	elseif failRatio < 0 then
		failRatio = 0
	end

	if brokenRatio > 100 then
		brokenRatio = 100
	elseif brokenRatio < 0 then
		brokenRatio = 0
	end

	return successRatio, failRatio, brokenRatio, needPoint, totalGivePoint
end
