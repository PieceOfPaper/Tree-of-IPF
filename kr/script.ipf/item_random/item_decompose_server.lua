function SCR_ITEM_DECOMPOSE(pc)
	if IsRunningScript(pc, 'TX_ITEM_DECOMPOSE') == 1 then
		SendSysMsg(pc, 'ItIsAlreadyInProcessAfter');
		return;
	end
    
	RunScript('TX_ITEM_DECOMPOSE', pc);
end



function TX_ITEM_DECOMPOSE(pc)

    local itemList = GetDlgItemList(pc);
    
    local totalPrice = 0;
    
    local decomposeItemList = { };
    decomposeItemList[#decomposeItemList + 1] = 'misc_ore22';   -- 뉴클 --
    decomposeItemList[#decomposeItemList + 1] = 'misc_ore23';   -- 시에라 --
    
    local decomposeItemCountList = { };
    decomposeItemCountList[#decomposeItemCountList + 1] = 0;
    decomposeItemCountList[#decomposeItemCountList + 1] = 0;
    
    if itemList ~= nil then
        
        -- 아이템 분해를 위한 테이블 생성 시작 --
        local itemGradeRatio = {75, 50, 35, 20};
        local itemMaxRatio = {1.4, 1.5, 1.8, 2};
        -- 아이템 분해를 위한 테이블 생성 끝 --
        
        for i = 1, #itemList do
            local min = 0;
            local max = 0;
            local newcleCount = 0;
            local sieraCount = 0;
            local priceCount = 0;
            
            totalPrice = totalPrice + GET_DECOMPOSE_PRICE(itemList[i])
            decomposeAble = TryGetProp(itemList[i], 'DecomposeAble')
            if decomposeAble == nil then
                return;
            end
            
            itemLv = TryGetProp(itemList[i], 'UseLv')
            if itemLv == nil then
                return;
            end

            itemGrade = TryGetProp(itemList[i], 'ItemGrade')
            if itemGrade == nil then
                return;
            end

            --뉴클 획득량-- 
            if decomposeAble ~= nil and decomposeAble =='YES' and itemLv ~= nil and itemGrade ~= nil and itemLv >= 75 and IsFixedItem(itemList[i]) and itemGrade <= 4   then
                min = math.floor(1 + (itemLv / itemGradeRatio[itemGrade]))
                max = math.floor(min * itemMaxRatio[itemGrade])
                newcleCount = IMCRandom(min, max);
                decomposeItemCountList[1] = decomposeItemCountList[1] + newcleCount;
                
                --시에라 획득량 -- 
                if itemGrade >= 4 then
                    min = math.floor(1 + math.floor(itemLv/150) * math.floor(itemLv/100))
                    max = math.floor(1 + math.floor(itemLv/75) * math.floor(itemLv/75))
                    sieraCount = IMCRandom(min, max);
                    decomposeItemCountList[2] = decomposeItemCountList[2] + sieraCount
                end
            end
        end
    end
    
    local guidList = {};
    local IDList = {};
    local nameList = {};

    local tx = TxBegin(pc)
    for j = 1, #itemList do
        local itemClassName = TryGetProp(itemList[j], 'ClassName')
        if itemClassName == nil then
            TxRollBack(tx);
            return;
        end

        local itemCls = GetClass('Item', itemClassName);
        if itemCls == nil then
            TxRollBack(tx);
            return;
        end
    
        local matItemGUID = GetItemGuid(itemList[j]);
        local matItem = GetInvItemByGuid(pc, matItemGUID);
        if matItem == nil then
            TxRollBack(tx);
            return;
        end

        if IsFixedItem(matItem) == 1 then
            SendSysMsg(pc, 'MaterialItemIsLock');
            TxRollBack(tx);
            return;
        end

        guidList[#guidList + 1] = matItemGUID;
        IDList[#IDList + 1] = itemCls.ClassID;
        nameList[#nameList + 1] = itemClassName;

        TxTakeItemByObject(tx, matItem, 1, "ITEM_DECOMPOSE_TAKE_ITEM")
    end
    
    if totalPrice > 0 then
        TxTakeItem(tx, 'Vis', totalPrice, "ITEM_DECOMPOSE_TAKE_VIS")
    end
    
    -- 분해 아이템 준다
    local resultIDList = {};
    local resultNameList = {};
    local resultCntList = {};
    for k = 1, #decomposeItemList do
        if decomposeItemCountList[k] > 0 then
            local resultItemName = decomposeItemList[k];
            local resultItemCnt = decomposeItemCountList[k];
            local resultItemCls = GetClass('Item', resultItemName);
            if resultItemCls == nil then
                TxRollBack(tx);
                return;
            end

            TxGiveItem(tx, resultItemName, resultItemCnt, "ITEM_DECOMPOSE_GIVE_ITEM");

            resultIDList[#resultIDList + 1] = resultItemCls.ClassID;
            resultNameList[#resultNameList + 1] = resultItemName;
            resultCntList[#resultCntList + 1] = resultItemCnt;            
        end
    end
    
    local ret = TxCommit(tx);    
    if ret == 'SUCCESS' then
        ItemDecomposingMongoLog(pc, 'RandomOption', guidList, IDList, nameList, resultIDList, resultNameList, resultCntList)

        local itemString = '';
        for m = 1, #decomposeItemList do
            itemString = itemString ..'"' .. decomposeItemList[m] .. '/' .. decomposeItemCountList[m] .. '"';
            
            if m < #decomposeItemList then
                itemString = itemString .. ','
            end
        end
        local stringFunc = string.format('ITEM_DECOMPOSE_COMPLETE(%s)', itemString);
        ExecClientScp(pc, stringFunc);
    end
end
