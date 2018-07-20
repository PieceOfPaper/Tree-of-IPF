function SCR_RESET_RANDOM_OPTION_ITEM(pc, itemGUID, argList)
	local item = GetInvItemByGuid(pc, itemGUID);
	if nil == item then
		return
	end

	local itemCls = GetClassByType('Item', item.ClassID)
	if itemCls.NeedRandomOption ~= 1 then
		return
	end

    local randomOptionClass, randomOptionCnt = GetClassList('item_random')
    
	local prevItemOptionGroupList = {}
	local prevItemOptionList = {}
	local prevItemOptionValueList = {}

	
    --OptionCnt--
    local optionCnt = 0;
    local itemGroupList = {};
    for i = 1 , 6 do
        local itemOptionGroup = TryGetProp(item, 'RandomOptionGroup_'..i)
        if itemOptionGroup ~= nil and itemOptionGroup ~= 'None' then
            itemGroupList[i] = itemOptionGroup
			prevItemOptionGroupList[i] = itemOptionGroup
            optionCnt = optionCnt + 1 
        end
    end
	
	for i = 1, optionCnt do
		local prevItemOption = TryGetProp(item, 'RandomOption_'..i)
		local prevItemOptionValue = TryGetProp(item, 'RandomOptionValue_'..i)
		if prevItemOption ~= nil and prevItemOptionValue ~= nil then
			prevItemOptionList[i] = prevItemOption
			prevItemOptionValueList[i] = prevItemOptionValue
		end
	end

    -- Option Group select --
    
    local groupCount = {};
    local atrributeGroup = ITEM_RANDOME_OPTION_GROUP_FILTER(randomOptionClass, randomOptionCnt, itemGroupList);
    
    if atrributeGroup == nil then
        return
    end

    --option name select--
    
    local optionNameList = {}
    local optionIndex = 0
    for i = 1, optionCnt do
      optionNameList[i] = SELECT_RANDOM_OPTION_NAME(randomOptionClass, randomOptionCnt, atrributeGroup[itemGroupList[i]] , itemGroupList[i] )
		
      if optionNameList[i] == nil then
        return
      end
  
      for j = 1, #atrributeGroup[itemGroupList[i]] do
        if atrributeGroup[itemGroupList[i]][j] == optionNameList[i] then
            optionIndex = j;
            break;
        end
      end
      table.remove(atrributeGroup[itemGroupList[i]], optionIndex)
    end
    
    --option state select--
    local optionStateList = {};
    
    for i = 1 , optionCnt do
        for j = 0, randomOptionCnt - 1 do
            local itemRandomOptionList = GetClassByIndexFromList(randomOptionClass, j)
            local optionNameCheckList = TryGetProp(itemRandomOptionList, "OptionName")
            if optionNameCheckList == nil then
                return ;
            end
            
            local optionStat = TryGetProp(itemRandomOptionList, "OptionValue")
            if optionStat == nil then
                return ;
            end

            local groupCheck = TryGetProp(itemRandomOptionList, "Group");
            
            if optionNameList[i] == optionNameCheckList and groupCheck == itemGroupList[i] then
                local optionValue = optionStat
                local scp = _G[optionValue]
                if scp ~= nil then
                    optionStateList[i] = scp(item)
                end
            end
        end
    end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrate(tx);
       
	if item.MaxDur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET or item.Dur <= MAXDUR_DECREASE_POINT_PER_RANDOM_RESET then
		return
	elseif item.MaxDur - item.Dur < MAXDUR_DECREASE_POINT_PER_RANDOM_RESET then
		TxSetIESProp(tx, item, 'MaxDur', item.MaxDur - MAXDUR_DECREASE_POINT_PER_RANDOM_RESET);
		TxSetIESProp(tx, item, 'Dur', item.MaxDur - MAXDUR_DECREASE_POINT_PER_RANDOM_RESET);
	else
		TxSetIESProp(tx, item, 'MaxDur', item.MaxDur - MAXDUR_DECREASE_POINT_PER_RANDOM_RESET);
	end

	for i = 1, optionCnt do
		local group = itemGroupList[i];
		local option = optionNameList[i];
		local value = optionStateList[i];
        
		SetExProp_Str(item, 'RandomOptionGroup_'..i, group);
		SetExProp_Str(item, 'RandomOption_'..i, option);
		SetExProp(item, 'RandomOptionValue_'..i, value);

        -- 치트
        if IsGM(pc) == 1 and GetExProp(pc, 'ERROR_RANDOM_OPTION_FORCELY') == 1 then                 
            group = 'STAT';
            option = 'ADD_FIRE';
            value = IMCRandom(1, 2000);
        end

		TxSetIESProp(tx, item, 'RandomOptionGroup_'..i, group);
		TxSetIESProp(tx, item, 'RandomOption_'..i, option);
		TxSetIESProp(tx, item, 'RandomOptionValue_'..i, value);
	end
	TxSetIESProp(tx, item, "NeedRandomOption", 0);

	SetExProp(item, 'RANDOM_OPTION_CNT', optionCnt);
	
			
	local itemRandomResetMaterial = nil;
	local list, cnt = GetClassList("item_random_reset_material")
	
	if list == nil then
		return;
	end
	

	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(list, i);
		if cls == nil then
			return;
		end

		if item.ClassType == cls.ItemType and item.ItemGrade == cls.ItemGrade then
			itemRandomResetMaterial = cls
		end
	end

	if itemRandomResetMaterial == nil then
		return;
	end

	if itemRandomResetMaterial.MaterialItemSlot > 0 then
		for i = 1, itemRandomResetMaterial.MaterialItemSlot do
			local materialIndex = 'MaterialItem_' ..i
			local materialItemCount = 0
			local materialCountScp = itemRandomResetMaterial[materialIndex .."_SCP"]
			if materialCountScp ~= "None" then
				materialCountScp = _G[materialCountScp];
				materialItemCount = materialCountScp(item);
			else
				return
			end

			local myInvItem, myInvItemCnt = GetInvItemByName(pc, itemRandomResetMaterial[materialIndex])
			if myInvItemCnt < materialItemCount then
				return;
			end
		end
	end

	local materialClassNameList = {}
	local materialCntList = {}

	for i = 1, itemRandomResetMaterial.MaterialItemSlot do
		local materialIndex = 'MaterialItem_' ..i
		local materialItemCount = 0
		local materialCountScp = itemRandomResetMaterial[materialIndex .."_SCP"]
		if materialCountScp ~= "None" then
			materialCountScp = _G[materialCountScp];
			materialItemCount = materialCountScp(item);
		else
			return
		end

		if materialItemCount > 0 then
			TxTakeItem(tx, itemRandomResetMaterial[materialIndex], materialItemCount);

			materialClassNameList[i] = itemRandomResetMaterial[materialIndex]
			materialCntList[i] = materialItemCount
		end
	end

	local materialSlotCnt = itemRandomResetMaterial.MaterialItemSlot

	local resultGUID = GetItemGuid(item)

	local ret = TxCommit(tx);

	if ret == "SUCCESS" then
        local randomItemList = {};
        randomItemList[1] = item;
        local wrongItemList = SCR_RANDOM_SETIESPROP_LOG(randomItemList);
        local errorGuidList, errorInfoStrList = GET_RANDOM_OPTION_ERROR_LOG_PARAM(wrongItemList);

		ItemRandomResetMongoLog(pc, resultGUID, prevItemOptionGroupList, prevItemOptionList, prevItemOptionValueList, materialSlotCnt, materialClassNameList, materialCntList, errorGuidList, errorInfoStrList, 'NPC', optionCnt);
		SendAddOnMsg(pc, "MSG_SUCCESS_RESET_RANDOM_OPTION", "", 0);
	end

end

-- 돋보기
function SCR_REVERT_ITEM_OPTION(pc, argList, strArgList)	
	local itemList = GetDlgItemList(pc);
	if itemList == nil or #itemList ~= 2 then
		return;
	end

	local revertItem = itemList[1];
	local targetItem = itemList[2];	
	if revertItem == nil or targetItem == nil then
		return;
	end
	if revertItem.StringArg ~= 'Mystic_Glass' and revertItem.StringArg ~= 'Master_Glass' then
		return;
	end

	local originTargetItemCls = GetClass('Item', targetItem.ClassName);
	if originTargetItemCls.NeedRandomOption ~= 1 or targetItem.NeedRandomOption ~= 0 then
		return;
	end

	if IsFixedItem(revertItem) == 1 or IsFixedItem(targetItem) == 1 then
		SendSysMsg(pc, 'MaterialItemIsLock');
--		return;
	end

	if targetItem.LifeTime > 0 then
		SendSysMsg(pc, 'WebService_15');
		return;
	end

	if revertItem.StringArg == 'Mystic_Glass' then
		if IsRunningScript(pc, 'TX_REVERT_ITEM_OPTION_NORMAL') ~= 1 then
			TX_REVERT_ITEM_OPTION_NORMAL(pc, revertItem, targetItem);
		end
	elseif revertItem.StringArg == 'Master_Glass' then
		if IsRunningScript(pc, 'TX_REVERT_ITEM_OPTION_MASTER') ~= 1 then
			TX_REVERT_ITEM_OPTION_MASTER(pc, revertItem, targetItem);
		end
	end
end

-- 신비한 돋보기
function TX_REVERT_ITEM_OPTION_NORMAL(pc, revertItem, targetItem)
	local MAX_RANDOM_OPTION_CNT = 6;
    local itemGroupList, optionNameList, optionCnt, optionStateList = FIRST_RANDOM_OPTION_ITEM(pc, targetItem);
    if itemGroupList== nil or  optionNameList== nil or optionCnt== nil or optionStateList == nil then
        IMC_LOG('ERROR_LOGIC', 'TX_REVERT_ITEM_OPTION_NORMAL: random option value get fail');
        return;
    end

    local prevItemOptionGroupList = {};
    local prevItemOptionList = {};
    local prevItemOptionValueList = {};
    local revertItemClassName = revertItem.ClassName;
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxTakeItemByObject(tx, revertItem, 1, 'MysticGlass');
	for i = 1, MAX_RANDOM_OPTION_CNT do
		local prevOptionGroup = targetItem['RandomOptionGroup_'..i];
		local prevOptionName = targetItem['RandomOption_'..i];
		local prevOptionValue = targetItem['RandomOptionValue_'..i];

		if i <= optionCnt then -- override
			TxSetIESProp(tx, targetItem, 'RandomOptionGroup_'..i, itemGroupList[i]);
			TxSetIESProp(tx, targetItem, 'RandomOption_'..i, optionNameList[i]);
			TxSetIESProp(tx, targetItem, 'RandomOptionValue_'..i, optionStateList[i]);
		else -- reset			
			if prevOptionGroup ~= 'None' then
				TxSetIESProp(tx, targetItem, 'RandomOptionGroup_'..i, 'None');
			end

			if prevOptionName ~= 'None' then
				TxSetIESProp(tx, targetItem, 'RandomOption_'..i, 'None');
			end

			if prevOptionValue ~= 0 then
				TxSetIESProp(tx, targetItem, 'RandomOptionValue_'..i, 0);
			end
		end

		if prevOptionGroup ~= 'None' then
			prevItemOptionGroupList[#prevItemOptionGroupList + 1] = prevOptionGroup;
		end

		if prevOptionName ~= 'None' then
			prevItemOptionList[#prevItemOptionList + 1] = prevOptionName;
		end

		if prevOptionValue ~= 'None' then
			prevItemOptionValueList[#prevItemOptionValueList + 1] = prevOptionValue;
		end
	end
	SetExProp(targetItem, 'RANDOM_OPTION_CNT', #prevItemOptionGroupList);

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		IMC_LOG('ERROR_TX_FAIL', 'TX_REVERT_ITEM_OPTION_NORMAL: TxFail- cid['..GetPcCIDStr(pc)..'], revertItem['..revertItemClassName..'], targetItem['..targetItem.ClassName..']');
		return;
	end

	SendAddOnMsg(pc, 'MSG_SUCCESS_UNREVERT_RANDOM_OPTION');
	ItemRandomResetMongoLog(pc, GetItemGuid(targetItem), prevItemOptionGroupList, prevItemOptionList, prevItemOptionValueList, 1, {revertItemClassName}, {1}, {}, {}, 'MysticGlass', optionCnt);
end

-- 장인의 돋보기
function TX_REVERT_ITEM_OPTION_MASTER(pc, revertItem, targetItem)	
    local itemGroupList, optionNameList, optionCnt, optionStateList = FIRST_RANDOM_OPTION_ITEM(pc, targetItem);
    if itemGroupList== nil or  optionNameList== nil or optionCnt== nil or optionStateList == nil then
        IMC_LOG('ERROR_LOGIC', 'TX_REVERT_ITEM_OPTION_NORMAL: random option value get fail');
        return;
    end


    if TryGetProp(targetItem, 'DisableContents', 0) == 1 then    	
    	SendSysMsg(pc, 'AlreadyReserveProperty');
    	SendReservePropertyList(pc, targetItem);
    	return;
    end

    if IsExistReserveProperty(pc) == 1 then -- targetItem은 아니지만 다른 reserve 프로퍼티 아이템이 있는 경우(사실 들어오면 안됨)    	
    	local reserveItem = GetReservePropertyItem(pc);
    	local propNameList, propValueList = GetReservePropertyList(pc, reserveItem);
    	SendReservePropertyList(pc, reserveItem);
    	SendSysMsg(pc, 'AlreadyReserveProperty');
    	return;
    end
    
    local reservePropNameList = {};
    local reservePropValueList = {};
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxTakeItemByObject(tx, revertItem, 1, 'MysticGlass');
	TxSetIESProp(tx, targetItem, 'DisableContents', 1); -- forbid release lock
	TxItemLock(tx, targetItem, 1); -- lock

	for i = 1, optionCnt do		
		local propName, propValue = _TX_ADD_RESERVE_PROPERTY(tx, targetItem, 'RandomOptionGroup_'..i, itemGroupList[i]);
		reservePropNameList[#reservePropNameList + 1] = propName;
		reservePropValueList[#reservePropValueList + 1] = propValue;

		propName, propValue = _TX_ADD_RESERVE_PROPERTY(tx, targetItem, 'RandomOption_'..i, optionNameList[i]);
		reservePropNameList[#reservePropNameList + 1] = propName;
		reservePropValueList[#reservePropValueList + 1] = propValue;

		propName, propValue = _TX_ADD_RESERVE_PROPERTY(tx, targetItem, 'RandomOptionValue_'..i, optionStateList[i]);
		reservePropNameList[#reservePropNameList + 1] = propName;
		reservePropValueList[#reservePropValueList + 1] = propValue;
	end

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		IMC_LOG('ERROR_TX_FAIL', 'TX_REVERT_ITEM_OPTION_MASTER: TxFail- cid['..GetPcCIDStr(pc)..'], revertItem['..revertItem.ClassName..'], targetItem['..GetItemGuid(targetItem)..']');
		return;
	end
    
    SendReservePropertyList(pc, targetItem);    
    MasterGlassLog(pc, 'GlassUse', targetItem, #reservePropNameList, reservePropNameList, reservePropValueList);
end

function _TX_ADD_RESERVE_PROPERTY(tx, item, propName, propValue)
	TxReserveIESProperty(tx, item, propName, propValue);
	return propName, propValue;
end

function TX_REVERT_ITEM_OPTION_MASTER_ANSWER(pc, targetItem, doChange)
	local propNameList, propValueList = GetReservePropertyList(pc, targetItem);
	if propNameList == nil or #propNameList == 0 then
		IMC_LOG('ERROR_LOGIC', 'TX_REVERT_ITEM_OPTION_MASTER_ANSWER: targetItem['..GetItemGuid(targetItem)..'] not have reserve property!');
		return;
	end

	-- for log
	local prevItemOptionGroupList = {};
    local prevItemOptionList = {};
    local prevItemOptionValueList = {};
	local MAX_RANDOM_OPTION_CNT = 6;
	for i = 1, MAX_RANDOM_OPTION_CNT do
		local prevOptionGroup = targetItem['RandomOptionGroup_'..i];
		if prevOptionGroup ~= 'None' then
			prevItemOptionGroupList[#prevItemOptionGroupList + 1] = prevOptionGroup;			
		end

		local prevOptionName = targetItem['RandomOption_'..i];
		if prevOptionName ~= 'None' then
			prevItemOptionList[#prevItemOptionList + 1] = prevOptionName;			
		end

		local prevOptionValue = targetItem['RandomOptionValue_'..i];
		if prevOptionValue ~= 0 then
			prevItemOptionValueList[#prevItemOptionValueList + 1] = prevOptionValue;
			SetExProp(targetItem, 'RANDOM_OPTION_CNT', i);
		end
	end

	local logType = 'MasterGlass';
	local logTypeForMasterGlass = 'OptionSelect';
	if doChange == 1 then
		logType = logType..'_New';
		logTypeForMasterGlass = 'New'..logTypeForMasterGlass;
	else
		logType = logType..'_Old';
		logTypeForMasterGlass = 'Old'..logTypeForMasterGlass;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxSetIESProp(tx, targetItem, 'DisableContents', 0); -- allow release lock
	TxItemLock(tx, targetItem, 0); -- release lock

	local curMaxRandomOptionCnt = 0;
	if doChange == 1 then
		for i = 1, #propNameList do
			TxSetIESProp(tx, targetItem, propNameList[i], propValueList[i]);

			local underbarIndex = string.find(propNameList[i], '_');
			if underbarIndex == nil then
				TxRollBack(tx);
				IMC_LOG('ERROR_TX_FAIL', 'TX_REVERT_ITEM_OPTION_MASTER_ANSWER: reserve property must be random option property!- item['..GetItemGuid(targetItem)..'], propName['..propNameList[i]..']');
				return;
			end
			local propIndex = tonumber(string.sub(propNameList[i], underbarIndex + 1));
			curMaxRandomOptionCnt = math.max(curMaxRandomOptionCnt, propIndex);
		end

		for i = curMaxRandomOptionCnt + 1, MAX_RANDOM_OPTION_CNT do
			if targetItem['RandomOptionGroup_'..i] ~= 'None' then
				TxSetIESProp(tx, targetItem, 'RandomOptionGroup_'..i, 'None');
			end

			if targetItem['RandomOption_'..i] ~= 'None' then
				TxSetIESProp(tx, targetItem, 'RandomOption_'..i, 'None');
			end

			if targetItem['RandomOptionValue_'..i] ~= 'None' then
				TxSetIESProp(tx, targetItem, 'RandomOptionValue_'..i, 0);
			end
		end
	end

	TxRemoveReserveIESProperty(tx, targetItem);

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		IMC_LOG('ERROR_TX_FAIL', 'TX_REVERT_ITEM_OPTION_MASTER_ANSWER: TxFail- cid['..GetPcCIDStr(pc)..'], targetItem['..GetItemGuid(targetItem)..']');
		return;
	end

	ItemRandomResetMongoLog(pc, GetItemGuid(targetItem), prevItemOptionGroupList, prevItemOptionList, prevItemOptionValueList, 0, {}, {}, {}, {}, logType, curMaxRandomOptionCnt);
	MasterGlassLog(pc, logTypeForMasterGlass, targetItem);
end

function SCR_ANSWER_REVERT_ITEM_OPTION(pc, argList)
	local itemList = GetDlgItemList(pc);
	if itemList == nil or #itemList ~= 1 then
		return;
	end

	local targetItem = itemList[1];
	if targetItem == nil then
		return;
	end

	local originTargetItemCls = GetClass('Item', targetItem.ClassName);
	if originTargetItemCls.NeedRandomOption ~= 1 or targetItem.NeedRandomOption ~= 0 then
		return;
	end

	if #argList ~= 1 then		
		return;
	end

	local doChange = argList[1];
	if doChange ~= 1 and doChange ~= 0 then
		return; -- invalid value
	end


	if IsRunningScript(pc, 'TX_REVERT_ITEM_OPTION_MASTER_ANSWER') ~= 1 then
		TX_REVERT_ITEM_OPTION_MASTER_ANSWER(pc, targetItem, doChange);
	end
end