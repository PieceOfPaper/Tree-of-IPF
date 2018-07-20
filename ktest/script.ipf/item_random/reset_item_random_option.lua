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

		ItemRandomResetMongoLog(pc, resultGUID, prevItemOptionGroupList, prevItemOptionList, prevItemOptionValueList, materialSlotCnt, materialClassNameList, materialCntList, errorGuidList, errorInfoStrList);
		SendAddOnMsg(pc, "MSG_SUCCESS_RESET_RANDOM_OPTION", "", 0);
	end

end
