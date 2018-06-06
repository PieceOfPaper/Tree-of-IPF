-- item_transcend_server.lua

function IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND(pc)
	if IsBuffApplied(pc, 'Forgery_Buff') == 'YES' then
		return 'Forgery_Buff';
	end

	if IsBuffApplied(pc, 'OverEstimate_Buff') == 'YES' then
		return 'OverEstimate_Buff';
	end

	if IsBuffApplied(pc, 'Devaluation_Debuff') == 'YES' then
		return 'Devaluation_Debuff';
	end

	return 'YES';
end

function CHECK_VALID_TRANSCEND_SHOP(pc, targetItem)
	if TryGetProp(targetItem, 'LegendGroup', 'None') ~= 'None' then
		if GetExProp(pc, 'IS_LEGEND_SHOP') ~= 1 then
			return false;
		end
	end

	return true;
end

function CHECK_ENABLE_BREAK_TRANSCEND(pc, targetItem)
	if TryGetProp(targetItem, 'LegendGroup', 'None') ~= 'None' then
		return false;	
	end
	return true;
end

function SCR_ITEM_TRANSCEND_TX(pc, argList)	
	local materialCount = tonumber(argList[1]);
	
	local itemList = GetDlgItemList(pc);
	if #itemList ~= 2 then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end
	
	local targetItem = itemList[1];
	local materialItem = itemList[2];

	if targetItem == nil or materialItem == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end


    if CHECK_VALID_TRANSCEND_SHOP(pc, targetItem) == false then
    	return;
    end   

    local itemClass = GetClass("Item",targetItem.ClassName);

    if itemClass == nil then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
        return;
    end

    local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");

    if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then

        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
        return;
    end

	-- 잠금 상태 안되고
	if 1 == IsFixedItem(targetItem) or 1 == IsFixedItem(materialItem) then 
		SendSysMsg(pc, "MaterialItemIsLock");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end

	if IS_TRANSCEND_ABLE_ITEM(targetItem) == 0 then
		SendSysMsg(pc, "ThisItemIsNotAbleToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end

	if IS_NEED_APPRAISED_ITEM(targetItem) == true or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true  then 
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end

	-- 특정 버프 사용 중에는 강화/초월 막아달라고 하셨음.
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND(pc);
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			SendSysMsg(pc, "CannotReinforceAndTranscendBy{BUFFNAME}", 0, "BUFFNAME", buffCls.Name);
		end
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end

	local transcend = TryGetProp(targetItem, "Transcend");
	if transcend == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end
	
	local lastTranscend = transcend;	
	local lastTranscend_MatCount = TryGetProp(targetItem, "Transcend_MatCount");
	if lastTranscend_MatCount == nil then
		lastTranscend_MatCount = 0;
	end

	local materialName = materialItem.ClassName;
	if GET_TRANSCEND_MATERIAL_ITEM(targetItem) ~= materialName then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end
	
	local transcendCls = GetClass("ItemTranscend", transcend + 1);
	if transcendCls == nil then
		IMC_LOG("INFO_NORMAL", "SCR_ITEM_TRANSCEND_TX: Transcend Class is nil- type(".. transcend + 1 .. ")");
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end					

	local maxMaterialCount = GET_TRANSCEND_MATERIAL_COUNT(targetItem, nil);
	
	if maxMaterialCount == nil or maxMaterialCount == 0 then
	    return 0;
	end
	
	if materialCount > maxMaterialCount then
		materialCount = maxMaterialCount;
	end
	
	local successRatio = GET_TRANSCEND_SUCCESS_RATIO(targetItem, transcendCls, materialCount);

	local isSuccess = 0;
	if IMCRandom(1, 100) <= successRatio then
		isSuccess = 1;
	end

	local targetPR = TryGetProp(targetItem, "PR")
    if targetPR == nil then
	    local itemCls = GetClass("Item", itemObj.ClassName);
    	if itemCls ~= nil then
	    	targetPR = itemObj.MaxPR;
    	end
    end

	local itemTake = false;
	local tx = TxBegin(pc);
	TxTakeItemByObject(tx, materialItem, materialCount, "Transcend");

	local tempItemGUID;
	local tempItemID;
	local tempItemName;

	if isSuccess == 0 then
		-- 1초월 밑으로 내려줘서는 안됨.
		if transcend > 1 and targetPR > 0 then -- 사라질 아이템에 대해서는 초월 프로퍼티 변경할 필요 없다
			TxAddIESProp(tx, targetItem, 'Transcend_MatCount', materialCount);
			TxAddIESProp(tx, targetItem, 'Transcend', -1);
		end
		if targetPR > 0 then			
			TxAddIESProp(tx, targetItem, 'PR', -1);
		else
			tempItemGUID = GetItemGuid(targetItem)
			tempItemID = targetItem.ClassID
			tempItemName = targetItem.ClassName
			TxTakeItemByObject(tx, targetItem, 1, "Transcend");
			itemTake = true;
		end
	else
		TxAddIESProp(tx, targetItem, 'Transcend_MatCount', materialCount);
		TxAddIESProp(tx, targetItem, 'Transcend_SucessCount', materialCount);
		TxAddIESProp(tx, targetItem, 'Transcend', 1);
	end
	
	local ret = TxCommit(tx);	
	
	if ret ~= "SUCCESS" then		
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "ITEMTRANSCEND_FAIL_TO_TRANSCEND()");
		return;
	end

    if isSuccess == 1 then
        if IsExistItemInAdventureBook(pc, targetItem.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(pc, targetItem.Name);
        end
        AddAdventureBookItemPermanentInfo(pc, targetItem.ClassID, 'Transcend', transcend + 1);
    end

	if itemTake == true then
		ItemTranscendMongoLog(pc, nil, "Stone", isSuccess, lastTranscend, lastTranscend_MatCount, materialName, materialCount, tempItemGUID, tempItemID, tempItemName);
	else
		ItemTranscendMongoLog(pc, targetItem, "Stone", isSuccess, lastTranscend, lastTranscend_MatCount, materialName, materialCount);
	end
	InvalidateStates(pc);
	local stringScp = string.format("TRANSCEND_UPDATE(%d)", isSuccess);
	ExecClientScp(pc, stringScp);
end

function SCR_ITEM_TRANSCEND_BREAK_TX(pc, argList)
	local itemList = GetDlgItemList(pc);
	if #itemList ~= 2 then
		return;
	end
	
	local targetItem = itemList[1];
	local materialItem = itemList[2];

	if targetItem == nil or materialItem == nil then
		return;
	end

    if CHECK_ENABLE_BREAK_TRANSCEND(pc, targetItem) == false then    
    	return;
    end

    local itemClass = GetClass("Item",targetItem.ClassName);

    if itemClass == nil then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end

    local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");

    if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then

        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end

	local transcend = TryGetProp(targetItem, "Transcend");
	if transcend == nil or transcend < 1 then
		return;
	end
	
	local lastTranscend = transcend;
	local lastTranscend_MatCount = TryGetProp(targetItem, "Transcend_MatCount");
	if lastTranscend_MatCount == nil then
		lastTranscend_MatCount = 0;
	end

	if materialItem.ClassName ~= GET_TRANSCEND_BREAK_ITEM() then
		return;
	end

	local breakItemCount = GET_TRANSCEND_BREAK_ITEM_COUNT(targetItem);
	local breakItemCount = breakItemCount * 10;
	local needSilver = GET_TRANSCEND_BREAK_SILVER(targetItem);
    
    local successTranscend_MatCount = TryGetProp(targetItem, "Transcend_SucessCount");
    
    successTranscend_MatCount = math.floor(successTranscend_MatCount * 0.9) * 10;
    
    if successTranscend_MatCount <  breakItemCount then
        return 0;
    end
    
	local getItemName = "misc_BlessedStone";
	if getItemName == nil then
		return;
	end
	
	local targetItemGUID = GetItemGuid(targetItem);
	if targetItemGUID == nil then
		return;
	end
	local targetItemClassID = TryGetProp(targetItem, "ClassID");
	if targetItemClassID == nil then
		return;
	end
	local targetItemClassName = TryGetProp(targetItem, "ClassName");
	if targetItemClassName == nil then
		return;
	end
    local equipType = TryGetProp(targetItem, 'ClassType');
    if equipType == nil then
        return;
    end
    
	local tx = TxBegin(pc);
	TxTakeItemByObject(tx, targetItem, 1, "TranscendBreak");
	TxTakeItem(tx, 'Vis', needSilver, "TranscendBreak");
	TxTakeItemByObject(tx, materialItem, 1, "TranscendBreak");
	TxGiveItem(tx, getItemName, breakItemCount, "TranscendBreak");
	local ret = TxCommit(tx);	
	
	if ret == "SUCCESS" then
		ItemTranscendBreakMongoLog(pc, targetItemGUID, targetItemClassID, targetItemClassName, lastTranscend, lastTranscend_MatCount, getItemName, breakItemCount, equipType);
		
		InvalidateStates(pc);
		local strScp = string.format("TRANSCEND_BREAK_UPDATE(\"%s\", %d)", getItemName, breakItemCount)	
		ExecClientScp(pc, strScp);
	end	
	
end

function SCR_ITEM_TRANSCEND_REMOVE_TX(pc, argList)	
	local itemList = GetDlgItemList(pc);
	if #itemList ~= 2 then
		return;
	end
	
	local targetItem = itemList[1];
	local materialItem = itemList[2];

	if targetItem == nil or materialItem == nil then
		return;
	end

    if CHECK_ENABLE_BREAK_TRANSCEND(pc, targetItem) == false then
    	return;
    end

    local itemClass = GetClass("Item",targetItem.ClassName);

    if itemClass == nil then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end

    local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");

    if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then

        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end

	local transcend = TryGetProp(targetItem, "Transcend");
	if transcend == nil or transcend < 1 then
		return;
	end

	if materialItem.ClassName ~= GET_TRANSCEND_REMOVE_ITEM() then
		return;
	end

	local lastTranscend = transcend;
	local lastTranscend_MatCount = TryGetProp(targetItem, "Transcend_MatCount");
	if lastTranscend_MatCount == nil then
		lastTranscend_MatCount = 0;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, targetItem, 'Transcend_MatCount', 0);	
	TxSetIESProp(tx, targetItem, 'Transcend', 0);
	TxSetIESProp(tx, targetItem, 'Transcend_SucessCount', 0)	
	TxTakeItemByObject(tx, materialItem, 1, "TranscendRemove");
	local ret = TxCommit(tx);	

	if ret == "SUCCESS" then
		ItemTranscendRemoveMongoLog(pc, targetItem, lastTranscend, lastTranscend_MatCount);
		InvalidateStates(pc);
		local strScp = "TRANSCEND_REMOVE_UPDATE()";
		ExecClientScp(pc, strScp);
	end	
end


function SCR_ITEM_TRANSCEND_SCROLL_TX(pc)	
	local itemList = GetDlgItemList(pc);
	
	if #itemList ~= 2 then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	local targetItem = itemList[1];
	local scrollItem = itemList[2];
	if targetItem == nil or scrollItem == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end

--    if IsShutDown("Item", targetItem.ClassName, targetItem) == 1 or IsShutDown("Item", scrollItem.ClassName, scrollItem) == 1 or IsShutDown("ShutDownContent", "Transcend") == 1 then
--        SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
--        return;
--    end
   
    local itemClass = GetClass("Item", targetItem.ClassName);
    if itemClass == nil then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
        return;
    end
	
    local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");
    if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
        return;
    end
	
	-- locked item is not allowed
	if 1 == IsFixedItem(targetItem) or 1 == IsFixedItem(scrollItem) then
		SendSysMsg(pc, "MaterialItemIsLock");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	if IS_TRANSCEND_ABLE_ITEM(targetItem) == 0 then
		SendSysMsg(pc, "ThisItemIsNotAbleToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	if IS_NEED_APPRAISED_ITEM(targetItem) == true or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true  then 
		SendSysMsg(pc, "ThisItemIsNotAbleToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	-- can not exec reinforce and transcend while having specific buff
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND(pc);
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			SendSysMsg(pc, "CannotReinforceAndTranscendBy{BUFFNAME}", 0, "BUFFNAME", buffCls.Name);
		end
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	local transcend = TryGetProp(targetItem, "Transcend");
	if transcend == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	local lastTranscend = transcend; -- for log
	local lastTranscend_MatCount = TryGetProp(targetItem, "Transcend_MatCount"); -- for log
	if lastTranscend_MatCount == nil then
		lastTranscend_MatCount = 0;
	end
	
	if IS_TRANSCEND_SCROLL_ITEM(scrollItem) ~= 1 then -- check valid scrollItem
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end
	
	local scrollTypeForLog = GET_TRANSCEND_SCROLL_TYPE(scrollItem);
	if scrollTypeForLog == nil then
		return;
	end
	
	local scrollName = scrollItem.ClassName;
	local expectedTranscend, successRatio = GET_ANTICIPATED_TRANSCEND_SCROLL_SUCCESS(targetItem, scrollItem)
	if expectedTranscend == nil or successRatio == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end

	local transcendCls = GetClass("ItemTranscend", expectedTranscend); -- check whether transcend level allowed
	if transcendCls == nil then
		IMC_LOG("INFO_NORMAL", "SCR_ITEM_TRANSCEND_TX: Transcend Class is nil- type(".. expectedTranscend .. ")");
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end	
	local isSuccess = 0;
	if IMCRandom(1, 100) <= successRatio then
		isSuccess = 1;
	end

	local targetPR = TryGetProp(targetItem, "PR")
	if targetPR == nil then
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
    end

	local itemTake = false;
	local tx = TxBegin(pc);
	TxTakeItemByObject(tx, scrollItem, 1, "Transcend");

	local tempItemGUID;
	local tempItemID;
	local tempItemName;

	if isSuccess == 0 then
		-- can not make transcend value under 1
		if transcend > 1 and targetPR > 0 then -- targetItem will be deleted
			TxAddIESProp(tx, targetItem, 'Transcend', -1);
		end
		if targetPR > 0 then			
			TxAddIESProp(tx, targetItem, 'PR', -1);
		else
			tempItemGUID = GetItemGuid(targetItem)
			tempItemID = targetItem.ClassID
			tempItemName = targetItem.ClassName
			TxTakeItemByObject(tx, targetItem, 1, "Transcend");
			itemTake = true;
		end
	else
		TxSetIESProp(tx, targetItem, 'Transcend', expectedTranscend);
	end
	
	local ret = TxCommit(tx);	
	
	if ret ~= "SUCCESS" then		
		SendSysMsg(pc, "FailedToTranscend");
		ExecClientScp(pc, "TRANSCEND_SCROLL_ATTEMPT_FAIL()");
		return;
	end

	if scrollTypeForLog == "transcend_Set" then
		scrollTypeForLog = "Transcend_Set"
	elseif scrollTypeForLog == "transcend_Add" then
		scrollTypeForLog = "Transcend_Add"
	end

	if itemTake == true then
		ItemTranscendMongoLog(pc, nil, scrollTypeForLog, isSuccess, lastTranscend, lastTranscend_MatCount, scrollName, 1, tempItemGUID, tempItemID, tempItemName);
	else
		ItemTranscendMongoLog(pc, targetItem, scrollTypeForLog, isSuccess, lastTranscend, lastTranscend_MatCount, scrollName, 1);
	end
	
	InvalidateStates(pc);
	local stringScp = string.format("TRANSCEND_SCROLL_RESULT(%d)", isSuccess);
	ExecClientScp(pc, stringScp);
end

function SHOW_ITEM_TRANCEND_UI(pc, uiName, dlgPriority, isLegendShop, npc)
	SetExProp_Str(pc, "TRANSCEND_NPC_NAME", npc.ClassName);
    SetExProp(pc, 'IS_LEGEND_SHOP', isLegendShop);
    if isLegendShop == 1 then
    	SetExProp(pc, 'LEGEND_NPC_HANDLE', GetHandle(npc));
    end
    ShowCustomDlg(pc, uiName, dlgPriority, '', isLegendShop);
end