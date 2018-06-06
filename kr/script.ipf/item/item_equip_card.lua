--item_equip_card.lua

function SCR_TX_EQUIP_CARD_SLOT(pc, argStr)
	local argList = StringSplit(argStr, '#');
	local slotIndex = argList[1];
	slotIndex = slotIndex + 1;
	local cardGuid = argList[2];
	--�����ε����� ũ�ٴ°� ī�� �������ġ��?���� ��.
		
	if slotIndex > MAX_NORMAL_MONSTER_CARD_SLOT_COUNT + LEGEND_CARD_SLOT_COUNT then
		return;
	end

	local item, count = GetInvItemByGuid(pc, cardGuid)
	--�ش� GUID�� �������� ���ٸ� ����
	if item == nil then
		return;
	end
	local pcEtc = GetETCObject(pc);
	--EquipCardID_Slot%d
	--EquipCardLv_Slot%d
	--EquipCardExp_Slot%d
	--ī�带 ��â�Ϸ��� ���Կ��� �ƹ��͵� �����?��.
	if pcEtc["EquipCardID_Slot"..slotIndex] ~= 0 then
		return;
	end
	
	local c = IS_ENABLE_EQUIPPED_CARD(pc, item)
	if c >= MONSTER_CARD_SLOT_COUNT_PER_TYPE then
		SendSysMsg(pc, "CantEquipMonsterCard");
		return;
	end


	local itemGroup = item.GroupName
	if itemGroup ~= 'Card' then
		return
	end

	local itemType = item.CardGroupName
	local clsID = item.ClassID;
	local itemLv = item.Level;
	
	local itemExp = item.ItemExp;
    local itemBelongingCount = TryGetProp(item, 'BelongingCount');
    if itemBelongingCount == nil then
        itemBelongingCount = 0;
    end
	local itemClassName = item.ClassName;

	local cardcls = GetClass("EquipBossCard", itemClassName);
	if cardcls == nil then
		print(itemClassName)
		return;
	end

	if slotIndex < MAX_NORMAL_MONSTER_CARD_SLOT_COUNT + LEGEND_CARD_SLOT_COUNT then
		if itemType == 'LEG' then
			return
		end
	elseif slotIndex == MAX_NORMAL_MONSTER_CARD_SLOT_COUNT + LEGEND_CARD_SLOT_COUNT then
		if itemType ~= 'LEG' then
			return
		end
	end

	if itemType == 'LEG' then
		local isLegendCardOpen = GetIESProp(pcEtc, 'IS_LEGEND_CARD_OPEN')
		if isLegendCardOpen ~= 1 then
			return
		end
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, pcEtc, "EquipCardID_Slot"..slotIndex, clsID);
	TxSetIESProp(tx, pcEtc, "EquipCardLv_Slot"..slotIndex, itemLv);
	TxSetIESProp(tx, pcEtc, "EquipCardExp_Slot"..slotIndex, itemExp);
	TxSetIESProp(tx, pcEtc, "EquipCardBelongingCount_Slot"..slotIndex, itemBelongingCount);
	TxTakeItemByObject(tx, item, 1, "EquipCard");
	local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
		EquipCard(pc, slotIndex, itemLv, itemClassName)
		ItemCardEquipMongoLog(pc, "InvenSlot", "Equip", slotIndex, cardGuid, clsID, itemLv, itemExp);
		local cardInfo = GetClass("EquipBossCard", itemClassName);
		if cardInfo ~= nil and cardInfo.UseType == "Always" then
			AlwaysCardScriptRun(pc, slotIndex, itemLv, itemClassName, 1);
		end
		local sucScp = string.format("_CARD_SLOT_EQUIP(\'%d\', \'%d\', \'%d\', \'%d\')", slotIndex, clsID, itemLv, itemExp);
		ExecClientScp(pc, sucScp);		
    end
end

function SCR_TX_UNEQUIP_CARD_SLOT(pc, argList)
	if #argList < 2 then
		return
	end
	
	local index = argList[1]
	local isNoEffect = false
	if argList[2] == 1 then
		isNoEffect = true
	end

	local slotIndex = index;
	slotIndex = slotIndex + 1;

	local pcEtc = GetETCObject(pc);

	if pcEtc["EquipCardID_Slot"..slotIndex] == 0 then
		return;
	end

	local bossCardID = pcEtc["EquipCardID_Slot"..slotIndex];
	local cardCls = GetClassByType("Item", bossCardID)
	local cardLv =	pcEtc["EquipCardLv_Slot"..slotIndex];
	local cardExp = pcEtc["EquipCardExp_Slot"..slotIndex];
    local belongingCount = pcEtc["EquipCardBelongingCount_Slot"..slotIndex];

    if cardLv == 1 then
        isNoEffect = false; -- 1레벨일때는 보존하고 뭐고 할 필요 없음
    end

	local myMoney, myMoneyCount = GetInvItemByName(pc, "Vis");
	local cardGroupName = cardCls.CardGroupName
	local consumeSilver = 0;
	local deleteVisReason = "";
	if cardGroupName == 'LEG' then
		--1000000
		consumeSilver = cardLv * CONSUME_SILVER_WHEN_UNEQUIP_LEGEND_CARD
		deleteVisReason = "UnEquipLegCard_Silver"
	else
		--20000
		consumeSilver = cardLv * CONSUME_SILVER_WHEN_UNEQUIP_MONSTER_CARD
		deleteVisReason = "UnEquipCard_Silver"
	end

	local itemCls = nil
	-- 실버 사용하는 경우
	if isNoEffect == true then
		-- 실버 부족할때
		if myMoneyCount < consumeSilver then
			SendSysMsg(pc, "REQUEST_TAKE_SILVER")
			return
		end

		itemCls = GetClass('Item', 'BossCardUnEquipTP')
		if itemCls == nil or TryGetProp(itemCls, 'ClassName') == nil or TryGetProp(itemCls, 'ClassID') == nil then
			return
		end
	end

	local cardInfo = GetClass("EquipBossCard", cardCls.ClassName);
	if cardInfo ~= nil and cardInfo.UseType == "Always" then
		AlwaysCardScriptRun(pc, slotIndex, cardLv, cardCls.ClassName, 0);
	end
	local success = UnEquipCard(pc, slotIndex, cardCls.ClassName);
	if success == 0 then
		return;
	end	

	local tx = TxBegin(pc);
	local cardID = pcEtc["EquipCardID_Slot"..slotIndex];
	local cardLv = pcEtc["EquipCardLv_Slot"..slotIndex];
	local cardExp = pcEtc["EquipCardExp_Slot"..slotIndex];

	TxSetIESProp(tx, pcEtc, "EquipCardID_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardLv_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardExp_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardBelongingCount_Slot"..slotIndex, 0);

	local newCard = GetClassByType("Item", cardID)
	local resultGUID = 0;
	local PrevLv = GET_ITEM_PREV_LEVEL(newCard, cardExp)

	if isNoEffect == true and cardLv > 1 then	-- 현재 카드가 1렙 이상인 경우, 5tp소모 후 카드 레벨 감소 효과 적용 x
			local cmdIdx  = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			TxAppendProperty(tx, cmdIdx, "ItemExp", cardExp);
			TxAppendProperty(tx, cmdIdx, "Level", cardLv);

			 -- 마켓 시세 분리 때문에 추가됐습니다. 위에 "Level"을 그냥 바꾸면 몬스터 카드 장착에 문제 생길까봐 따로 저장하겠습니당(강우씨 요청으로 카드의 레벨은 CardLevel로 저장)
			TxAppendProperty(tx, cmdIdx, "CardLevel", cardLv);

			resultGUID = TxGetGiveItemID(tx, cmdIdx);

			-- silver 사용해서 카드해제하는 경우			
			TxTakeItemByObject(tx, myMoney, consumeSilver, deleteVisReason);
	else
		if PrevLv > 1 then		
			local cmdIdx  = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			local newLv = PrevLv
			local PrevExp =	GET_ITEM_EXP_BY_LEVEL(newCard, newLv - 1)
			TxAppendProperty(tx, cmdIdx, "ItemExp", PrevExp);
			TxAppendProperty(tx, cmdIdx, "Level", newLv);
			TxAppendProperty(tx, cmdIdx, "CardLevel", newLv);
			resultGUID = TxGetGiveItemID(tx, cmdIdx);
			cardLv = newLv;
		else
			local cmdIdx = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			resultGUID = TxGetGiveItemID(tx, cmdIdx);
			cardLv = 1;
		end
	end

	local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
		ItemCardEquipMongoLog(pc, "InvenSlot", "UnEquip", slotIndex, resultGUID, cardID, cardLv, 0);
		local sucScp = string.format("_CARD_SLOT_REMOVE(\'%d\', \'%s\')", slotIndex, cardCls.CardGroupName);
		ExecClientScp(pc, sucScp);		
    end
end

function TEST_CARDSLOT_ALLRESET(pc)
	for i = 0, MAX_NORMAL_MONSTER_CARD_SLOT_COUNT - 1 do
		TEST_CARDSLOT_RESET(pc, i)
	end
end


function TEST_CARDSLOT_RESET(pc, sindex)
	local index = sindex
	local isNoEffect = false

	local slotIndex = index;
	slotIndex = slotIndex + 1;

	local pcEtc = GetETCObject(pc);

	if pcEtc["EquipCardID_Slot"..slotIndex] == 0 then
		return;
	end

	local bossCardID = pcEtc["EquipCardID_Slot"..slotIndex];
	local cardCls = GetClassByType("Item", bossCardID)
	local cardLv =	pcEtc["EquipCardLv_Slot"..slotIndex];
	local cardExp = pcEtc["EquipCardExp_Slot"..slotIndex];
    local belongingCount = pcEtc["EquipCardBelongingCount_Slot"..slotIndex];

    if cardLv == 1 then
        isNoEffect = false; -- 1레벨일때는 보존하고 뭐고 할 필요 없음
    end
    		
	local consumeTP = CONSUME_TP_WHEN_UNEQUIP_MONSTER_CARD
	local itemCls = nil
	-- 5tp 사용하려는 경우의 예외처리
	if isNoEffect == true then
		-- 5TP 없으면 해제 못함
		local userTP = GetPCTotalTPCount(pc)
		if userTP < consumeTP then
			SendSysMsg(pc, "REQUEST_TAKE_MEDAL")
			return
		end

		-- TP 사용에 대한 로그가 item_premium.xml에 정의되어 있어야함
		itemCls = GetClass('Item', 'BossCardUnEquipTP')
		if itemCls == nil or TryGetProp(itemCls, 'ClassName') == nil or TryGetProp(itemCls, 'ClassID') == nil then
			return
		end
	end

	local cardInfo = GetClass("EquipBossCard", cardCls.ClassName);
	if cardInfo ~= nil and cardInfo.UseType == "Always" then
		AlwaysCardScriptRun(pc, slotIndex, cardLv, cardCls.ClassName, 0);
	end
	local success = UnEquipCard(pc, slotIndex, cardCls.ClassName);
	if success == 0 then
		return;
	end	

	local tx = TxBegin(pc);
	local cardID = pcEtc["EquipCardID_Slot"..slotIndex];
	local cardLv = pcEtc["EquipCardLv_Slot"..slotIndex];
	local cardExp = pcEtc["EquipCardExp_Slot"..slotIndex];

	TxSetIESProp(tx, pcEtc, "EquipCardID_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardLv_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardExp_Slot"..slotIndex, 0);
	TxSetIESProp(tx, pcEtc, "EquipCardBelongingCount_Slot"..slotIndex, 0);

	local newCard = GetClassByType("Item", cardID)

    if IsShutDown("Item", newCard.ClassName) == 1 or IsShutDown("ShutDownContent", "GemCardSocket") == 1 then
        SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
        return;
    end

	local resultGUID = 0;
	local PrevLv = GET_ITEM_PREV_LEVEL(newCard, cardExp)

	if isNoEffect == true and cardLv > 1 then	-- 현재 카드가 1렙 이상인 경우, 5tp소모 후 카드 레벨 감소 효과 적용 x
			local cmdIdx  = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			TxAppendProperty(tx, cmdIdx, "ItemExp", cardExp);
			TxAppendProperty(tx, cmdIdx, "Level", cardLv);

			 -- 마켓 시세 분리 때문에 추가됐습니다. 위에 "Level"을 그냥 바꾸면 몬스터 카드 장착에 문제 생길까봐 따로 저장하겠습니당(강우씨 요청으로 카드의 레벨은 CardLevel로 저장)
			TxAppendProperty(tx, cmdIdx, "CardLevel", cardLv);

			resultGUID = TxGetGiveItemID(tx, cmdIdx);

			-- 5TP사용해서 카드해제하는 경우도, TP소모이므로 로그 남아야함			
			TxAddIESProp(tx, GetAccountObj(pc), "Medal", -consumeTP, itemCls.ClassName..":"..itemCls.ClassID..":"..itemCls.ClassID, cmdIdx);
	else
		if PrevLv > 1 then		
			local cmdIdx  = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			local newLv = PrevLv
			local PrevExp =	GET_ITEM_EXP_BY_LEVEL(newCard, newLv - 1)
			TxAppendProperty(tx, cmdIdx, "ItemExp", PrevExp);
			TxAppendProperty(tx, cmdIdx, "Level", newLv);
			TxAppendProperty(tx, cmdIdx, "CardLevel", newLv);
			resultGUID = TxGetGiveItemID(tx, cmdIdx);
			cardLv = newLv;
		else
			local cmdIdx = TxGiveItem(tx, newCard.ClassName, 1, "CardUnEquip", 0, nil, 0, belongingCount);
			resultGUID = TxGetGiveItemID(tx, cmdIdx);
			cardLv = 1;
		end
	end

	local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
		ItemCardEquipMongoLog(pc, "InvenSlot", "UnEquip", slotIndex, resultGUID, cardID, cardLv, 0);
		local sucScp = string.format("_CARD_SLOT_REMOVE(\'%d\', \'%s\')", slotIndex, cardCls.CardGroupName);
		ExecClientScp(pc, sucScp);		
    end
end
