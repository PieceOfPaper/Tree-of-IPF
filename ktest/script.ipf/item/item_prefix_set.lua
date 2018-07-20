function SCR_EXECUTE_PREFIX_SET(pc)
    local itemList, itemCntList = GetDlgItemList(pc);
    if itemList == nil or #itemList ~= 1 then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] SCR_EXECUTE_PREFIX_SET: itemList Error');
        return;
    end

    local targetItem = itemList[1];
    if IS_VALID_ITEM_FOR_GIVING_PREFIX(targetItem) == false then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        SendSysMsg(pc, 'NotEnoughTarget');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] SCR_EXECUTE_PREFIX_SET: not valid prefix item['..targetItem.ClassName..']');
        return;
    end

    if IsFixedItem(targetItem) == 1 then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        SendSysMsg(pc, 'MaterialItemIsLock');
        return;
    end
    
    local needCount = GET_LEGEND_PREFIX_NEED_MATERIAL_COUNT(targetItem);
    local validCount = GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT(pc);    
    if needCount == 0 then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] SCR_EXECUTE_PREFIX_SET: needCount error- item['..targetItem.ClassName..']');
        return;
    end

    if validCount < needCount then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] SCR_EXECUTE_PREFIX_SET: Lack of valid count exporb- valid['..validCount..'], need['..needCount..']');
        return;
    end

    if IsRunningScript(pc, 'EXECUTE_GIVE_PREFIX') ~= 1 then
        EXECUTE_GIVE_PREFIX(pc, targetItem);
    end
end

function GET_VALID_LEGEND_PREFIX_MATERIAL_LIST(pc)
    local list = {};
    local needItemName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME();
    local itemList = GetInvItemList(pc);
    if itemList ~= nil then
        for i = 1, #itemList do
            local item = itemList[i];
            local itemExpNum = tonumber(item.ItemExpString);
            if itemExpNum == nil then
                itemExpNum = 0;
            end
            if item.ClassName == needItemName and itemExpNum >= item.NumberArg1 then
                list[#list + 1] = item;
            end
        end
    end

    return list;
end

function GET_VALID_LEGEND_PREFIX_MATERIAL_COUNT(pc) -- 경험치 꽉 찬 아이템만 개수 세주는 함수
    local list = GET_VALID_LEGEND_PREFIX_MATERIAL_LIST(pc);
    return #list;
end

function EXECUTE_GIVE_PREFIX(pc, targetItem)
    local npcHandle = GetExProp(pc, 'LEGEND_NPC_HANDLE');    
    if npcHandle == 0 then
        SendSysMsg(pc, 'CantUseEnchantBomb');
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: npcHandle error');
        return;
    end
    local npc = GetByHandle(pc, npcHandle);
    if npc == nil then
        SendSysMsg(pc, 'CantUseEnchantBomb');
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: npc not exist');
        return;
    end

    local prefixList = GET_TARGET_PREFIX_SET(targetItem.LegendGroup);

    -- 이미 접두사 있는 아이템이면 그 접두사 빼고 다시 돌려달라고 하셨음
    local candidateList = prefixList;
    local legendPrefix = targetItem.LegendPrefix;
    if legendPrefix ~= 'None' then
        candidateList = {};
        for i = 1, #prefixList do
            if prefixList[i] ~= legendPrefix then
                candidateList[#candidateList + 1] = prefixList[i];
            end
        end
    end

    if #candidateList < 1 then
        SendSysMsg(pc, 'CannotGivePrefixAnymore');
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: not exist candidate set name');
        return;
    end

    local aniTime = 7;
    CreateClientMonster(npc, pc, 'alchemist_roasting', aniTime, 'SKL_ROASTING_BORN', 'SKL_ROASTING_DEAD');
    AttachGaugeToTarget(npc, pc, aniTime, 1, "gauge");
    local result = DOTIMEACTION_ONLY_TARGET(npc, pc, ScpArgMsg("GivingBuffToWeapon"), '#LegendPrefix', aniTime, 0);    
    if result ~= 1 then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: dotimeaction error');
        return;
    end

    local index = IMCRandom(1, #candidateList);
    local targetPrefix = candidateList[index];
    
    local matCount = GET_LEGEND_PREFIX_NEED_MATERIAL_COUNT(targetItem);
    local materialList = GET_VALID_LEGEND_PREFIX_MATERIAL_LIST(pc);
    if #materialList < matCount then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');        
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: material count error- list['..#materialList..'], need['..matCount..']');
        return;
    end

    local tx = TxBegin(pc);
    if tx == nil then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: TxBegin error');
        return;
    end

    for i=1, matCount do
        local materialObj = materialList[i];
        TxTakeItemByObject(tx, materialObj, 1, 'LegendPrefix');
    end

    TxSetIESProp(tx, targetItem, 'LegendPrefix', targetPrefix);
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        SendAddOnMsg(pc, 'FAIL_LEGEND_PREFIX');
        IMC_LOG('ERROR_LOGIC', '[LegendPrefix] EXECUTE_GIVE_PREFIX: tx commit fail');
        return;
    end
    SendAddOnMsg(pc, 'SUCCESS_LEGEND_PREFIX');

    local targetItemGuid = GetItemGuid(targetItem);
    LegendPrefixLog(pc, targetItemGuid, legendPrefix, targetPrefix, matCount);        
end

g_legendGroupMap = {};
function GET_TARGET_PREFIX_SET(legendGroup)
    local prefixList = g_legendGroupMap[legend];
    if prefixList == nil then
        prefixList = CREATE_PREFIX_GROUP(legendGroup);
    end
    return prefixList;
end

function CREATE_PREFIX_GROUP(legendGroup)
    local prefixList = {};
    local clsList, cnt = GetClassList('LegendSetItem');
    for i = 0, cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);        
        if cls.LegendGroup == legendGroup then
            prefixList[#prefixList + 1] = cls.ClassName;            
        end
    end
    
    g_legendGroupMap[legendGroup] = prefixList;
    return prefixList;
end

-- 여기부터 테스트 함수
function TEST_SET_PREFIX_MATERIAL_EXP(pc) -- 인벤토리에 있는 모든 접두사 부여 재료 아이템 경험치를 풀로 세팅하는 치트
    local matName = GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME();
    local invItem = GetInvItemByName(pc, matName);
    if invItem == nil then
        Chat(pc, '재료 아이템이 인벤에 없어요! 재료 아이템: '..matName);
        return;
    end

    local matCls = GetClass('Item', matName);

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    
    local itemList = GetInvItemList(pc);
    local cheatItemList = {};
    for i = 1, #itemList do
        local item = itemList[i];
        if item.ClassName == matName then
            TxSetIESProp(tx, item, 'ItemExpString', matCls.NumberArg1);
            cheatItemList[#cheatItemList + 1] = item;
        end
    end

    local ret = TxCommit(tx);
    Chat(pc, '치트 끝!: '..ret..', exp['..matCls.NumberArg1..']');    

    if ret == 'SUCCESS' then
        for i = 1, #cheatItemList do
            SendPropertyByName(pc, cheatItemList[i], 'ItemExpString');
        end
    end
end

function TEST_ITEM_LINK(pc, itemClassName, prefix)
    local item = GetInvItemByName(pc, itemClassName);
    if item == nil then
        Chat(pc, '아이템이 인벤토리에 없어요');
        return;
    end

    local tx = TxBegin(pc);
    TxSetIESProp(tx, item, 'LegendPrefix', prefix);
    local ret = TxCommit(tx);
    Chat(pc,"아이템 링크 결과: "..ret);
end