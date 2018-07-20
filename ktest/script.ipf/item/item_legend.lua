-- 아이템 옵션 추출
function SCR_EXTRACT_ITEM_OPTION(pc, itemGUID, argList)    
    if #argList ~= 1 then
        return;
    end

    local item = GetInvItemByGuid(pc, itemGUID);    
    if item == nil or IsFixedItem(item) == 1 then
        return;
    end

    if IS_ENABLE_EXTRACT_OPTION(item) == false then
        return;
    end

    local kitID = argList[1];    
    local kitCls = GetClassByType('Item', kitID);
    if kitCls == nil then
        return;
    end
    local kitName = kitCls.ClassName;
    if IS_VALID_OPTION_EXTRACT_KIT(kitCls) == false then
        return;
    end

    local kitItem = GetInvItemByName(pc, kitName);
    if kitItem == nil or IsFixedItem(kitItem) == 1 then
        return;
    end

    local needMatCount = GET_OPTION_EXTRACT_NEED_MATERIAL_COUNT(item);
    if IS_ENABLE_NOT_TAKE_MATERIAL_KIT(kitCls) == false then
        local matItem, matItemCount = GetInvItemByName(pc, GET_OPTION_EXTRACT_MATERIAL_NAME());
        if matItem == nil or IsFixedItem(matItem) == 1 then
            return;
        end

        if matItemCount < needMatCount then
            return;
        end
    end

    if TryGetProp(item, 'LegendGroup', 'None') == 'None' then -- 랜덤 옵션 적용된 아이템
        if IS_APPLIED_VALID_RANDOM_OPTION(item) == false then
            SendSysMsg(pc, 'InvalidRandomOption');
            return;
        end
    end

    if IsRunningScript(pc, 'TX_EXTRACT_OPTION') ~= 1 then
        TX_EXTRACT_OPTION(pc, item, kitItem, needMatCount);
    end
end

function IS_SUCCESS_OPTION_EXTRACT()
    local randValue = IMCRandom(1, 100);
    local successRatio = 5; 
    if randValue <= successRatio then
        return 1;
    end

    return 0;
end

function TX_EXTRACT_OPTION(pc, item, kitItem, matCnt)    
    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    
    local kitName = kitItem.ClassName;
    local kitGuid = GetItemGuid(kitItem);
    local takeMatCnt = 0;    
    if IS_ENABLE_NOT_TAKE_MATERIAL_KIT(kitItem) == false then
        TxTakeItem(tx, GET_OPTION_EXTRACT_MATERIAL_NAME(), matCnt, 'ExtractOption');        
        takeMatCnt = matCnt;
    end
    
    TxTakeItemByObject(tx, kitItem, 1, 'ExtractOption');

    local isSuccess = IS_SUCCESS_OPTION_EXTRACT();
    local extractTargetItemName = GET_OPTION_EXTRACT_TARGET_ITEM_NAME(item);
    local extractTargetItemGuid = nil;
    local prevPR = 0;
    local isDestroyed = 0;
    local extractedItemGuid = GetItemGuid(item);
    local extractedItemName = item.ClassName;
    local extractedItemID = item.ClassID;
    local extractedItemClassType = item.ClassType;
    local itemRandomOption = GET_ITEM_RANDOM_OPTION_INFO(item);
    local extractType = 'LegendItem';
    if TryGetProp(item, 'LegendGroup', 'None') ~= 'None' then
        extractType = 'RandomOption';
    end

    if isSuccess == 1 then    
        TxTakeItemByObject(tx, item, 1, 'Extract_Success');
        isDestroyed = 1;

        local giveCmd = TxGiveItem(tx, extractTargetItemName, 1, 'ExtractOption');

        TX_EXTRACT_OPTION_FROM_RANDOM_OPTION_ITEM(tx, giveCmd, item);

        TxAppendProperty(tx, giveCmd, 'InheritanceItemName', item.ClassName);            
        extractTargetItemGuid = TxGetGiveItemID(tx, giveCmd);        
    else -- extract fail
        prevPR = item.PR;
        if IS_ENABLE_NOT_TAKE_POTENTIAL_BY_EXTRACT_OPTION(kitItem) == false then
            if prevPR > 0 then
                TxAddIESProp(tx, item, 'PR', -1); -- 포텐셜 깎기
            else                
                TxTakeItemByObject(tx, item, 1, 'Extract_Fail');
                isDestroyed = 1;
            end
        end
    end

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        return;
    end

    local errorFlag = 0;
    if isSuccess == 1 then
        local extractTargetItem = GetInvItemByGuid(pc, extractTargetItemGuid);
        if IS_EXTRACT_OPTION_VALID(extractedItemName, itemRandomOption, extractTargetItem) == false then
            errorFlag = 1;
            IMC_LOG('ERROR_LOGIC', 'TX_EXTRACT_OPTION: extract randomoption error: guid['..extractTargetItemGuid..']');
        end
    end

    local curPR = -1; -- 장비 깨지는 경우
    if isDestroyed == 0 then
        curPR = item.PR;
    end

    ExtractOptionLog(pc, takeMatCnt, kitGuid, kitName, extractType, isSuccess, prevPR, curPR, extractedItemGuid, extractedItemName, extractedItemID, extractTargetItemGuid, errorFlag, isDestroyed, extractedItemClassType);

    if isSuccess == 1 then
        SendAddOnMsg(pc, 'MSG_SUCCESS_ITEM_OPTION_EXTRACT');
    else
        SendAddOnMsg(pc, 'MSG_FAIL_ITEM_OPTION_EXTRACT');        
    end

    if isDestroyed == 1 then
        SendSysMsg(pc, 'ItemDeletedByOptionExtract');
    end
end

function TX_EXTRACT_OPTION_FROM_RANDOM_OPTION_ITEM(tx, giveCmd, item)
    if TryGetProp(item, 'LegendGroup', 'None') ~= 'None' then
        return;
    end

    local maxRandomOptionCnt = 6;
    for i = 1, maxRandomOptionCnt do            
        TxAppendProperty(tx, giveCmd, 'RandomOption_'..i, item['RandomOption_'..i]);
        TxAppendProperty(tx, giveCmd, 'RandomOptionGroup_'..i, item['RandomOptionGroup_'..i]);
        TxAppendProperty(tx, giveCmd, 'RandomOptionValue_'..i, item['RandomOptionValue_'..i]);
    end
end

function IS_EXTRACT_OPTION_VALID(extractedItemName, extractedItemInfo, extractTargetItem)    
    if extractTargetItem == nil  then
        return false;
    end

    if extractedItemName ~= extractTargetItem.InheritanceItemName then
        return false;
    end

    local extractedItem = GetClass('Item', extractedItemName);
    if extractedItem == nil then
        return false;
    end

    if TryGetProp(extractedItem, 'LegendGroup', 'None') == 'None' then
        if extractedItemInfo == nil then
            return false;
        end

        local optionList = extractedItemInfo['Option'];
        local groupList = extractedItemInfo['Group'];
        local valueList = extractedItemInfo['Value'];
        local maxRandomOptionCnt = 6;
        for i = 1, maxRandomOptionCnt do
            if optionList[i] ~= extractTargetItem['RandomOption_'..i] then
                return false;
            end
            if groupList[i] ~= extractTargetItem['RandomOptionGroup_'..i] then
                return false;
            end
            if valueList[i] ~= extractTargetItem['RandomOptionValue_'..i] then
                return false;
            end
        end
    end

    return true;
end

function GET_ITEM_RANDOM_OPTION_INFO(item)
    local table = {}; -- key: Option / Group / Value, value: 1~6 list
    local maxRandomOptionCnt = 6;
    for i = 1, 6 do
        -- option
        local optionList = table['Option'];
        if optionList == nil then
            table['Option'] = {};
            optionList = table['Option'];            
        end
        optionList[i] = item['RandomOption_'..i];

        -- group
        local groupList = table['Group'];
        if groupList == nil then
            table['Group'] = {};
            groupList = table['Group'];            
        end
        groupList[i] = item['RandomOptionGroup_'..i];

        -- value
        local valueList = table['Value'];
        if valueList == nil then
            table['Value'] = {};
            valueList = table['Value'];            
        end
        valueList[i] = item['RandomOptionValue_'..i];
    end

    return table;
end

-- 아이템 옵션 장착
function SCR_EQUIP_ITEM_OPTION(pc)
    local itemList, itemCntList = GetDlgItemList(pc);
    if itemList == nil or #itemList ~= 2 then
        return;
    end

    local targetItem = itemList[1];
    if targetItem == nil or IsFixedItem(targetItem) == 1 then
        return;
    end

    if IS_LEGEND_GROUP_ITEM(targetItem) == false then
        return;
    end

    local icorItem = itemList[2];
    if icorItem == nil or IsFixedItem(targetItem) == 1 then
        return;
    end

    if icorItem.GroupName ~= 'Icor' then 
        return;
    end

    local inheritanceItemName = icorItem.InheritanceItemName;
    if inheritanceItemName == 'None' then        
        IMC_LOG('ERROR_LOGIC', 'SCR_EXTRACT_ITEM_OPTION: Icor must have inheritance item!');
        return;
    end

    local inheritanceItemCls = GetClass('Item', inheritanceItemName);
    if inheritanceItemCls == nil then        
        IMC_LOG('ERROR_LOGIC', 'SCR_EXTRACT_ITEM_OPTION: Icor inheritance invalid item-'..inheritanceItemName);
        return;
    end

    if targetItem.ClassType ~= inheritanceItemCls.ClassType then
        return;
    end

    local limitLevel = GET_OPTION_EQUIP_LIMIT_LEVEL(inheritanceItemCls);
    if targetItem.UseLv < limitLevel then
        SendSysMsg(pc, '{LEVEL}CanEquipIcor', 'LEVEL', limitLevel);
        return;
    end    

    local matInvItem, matCount = GetInvItemByName(pc, GET_OPTION_EXTRACT_MATERIAL_NAME());
    if matInvItem == nil or IsFixedItem(matInvItem) == 1 then
        return;
    end    

    local needMatCnt = GET_OPTION_EQUIP_NEED_MATERIAL_COUNT(targetItem);    
    if matCount < needMatCnt then
        return;
    end

    
    local capitalItem, capitalItemCnt = GetInvItemByName(pc, GET_OPTION_EQUIP_CAPITAL_MATERIAL_NAME());    
    if capitalItem == nil or IsFixedItem(capitalItem) == 1 then
        return;
    end

    local needCapitalCnt = GET_OPTION_EQUIP_NEED_CAPITAL_COUNT(targetItem);
    if capitalItemCnt < needCapitalCnt then
        return;
    end

    if IsRunningScript(pc, 'TX_EQUIP_OPTION') ~= 1 then
        TX_EQUIP_OPTION(pc, targetItem, icorItem, needMatCnt, needCapitalCnt);
    end
end

function TX_EQUIP_OPTION(pc, targetItem, icorItem, needMatCnt, needCapitalCnt)
    local matItemGuid = GetItemGuid(icorItem);
    local matItemID = icorItem.ClassID;
    local matItemName = icorItem.ClassName;

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxTakeItem(tx, GET_OPTION_EXTRACT_MATERIAL_NAME(), needMatCnt, 'EquipOption');
    TxTakeItem(tx, GET_OPTION_EQUIP_CAPITAL_MATERIAL_NAME(), needCapitalCnt, 'EquipOption');
    TxTakeItemByObject(tx, icorItem, 1, 'EquipOption');

    TxSetIESProp(tx, targetItem, 'InheritanceItemName', icorItem.InheritanceItemName);

    local maxRandomOptionCnt = 6;
    for i = 1, maxRandomOptionCnt do
        TxSetIESProp(tx, targetItem, 'RandomOption_'..i, icorItem['RandomOption_'..i]);
        TxSetIESProp(tx, targetItem, 'RandomOptionGroup_'..i, icorItem['RandomOptionGroup_'..i]);
        TxSetIESProp(tx, targetItem, 'RandomOptionValue_'..i, icorItem['RandomOptionValue_'..i]);
    end

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        return;
    end

    SendAddOnMsg(pc, 'MSG_SUCCESS_ITEM_OPTION_ADD');
    EquipOptionLog(pc, needMatCnt, needCapitalCnt, GetItemGuid(targetItem), matItemGuid, matItemID, matItemName, targetItem.ClassType);
end

-- 레전드 아이템 분해
function SCR_EXECUTE_LEGEND_DECOMPOSE(pc)
    local itemList, itemCntList = GetDlgItemList(pc);
    if itemList == nil or #itemList ~= 1 then
        return;
    end

    local targetItem = itemList[1];
    if targetItem == nil or IsFixedItem(targetItem) == 1 then
        return;
    end

    if IS_LEGEND_GROUP_ITEM(targetItem) == false then
        return;
    end

    local rewardInfo = GetClass('LegendDecompose', targetItem.LegendGroup);
    if rewardInfo == nil then
        IMC_LOG('ERROR_LOGIC', 'SCR_EXECUTE_LEGEND_DECOMPOSE: Decompose legend item reward is nil- '..targetItem.LegendGroup);
        return;
    end

    if _G[rewardInfo.MaterialCountScp] == nil then
        IMC_LOG('ERROR_LOGIC', 'SCR_EXECUTE_LEGEND_DECOMPOSE: Decompose reward count scp is null- '..targetItem.LegendGroup);
        return;
    end

    if IsRunningScript(pc, 'TX_LEGEND_DECOMPOSE') ~= 1 then
        TX_LEGEND_DECOMPOSE(pc, targetItem, rewardInfo);
    end
end

function TX_LEGEND_DECOMPOSE(pc, targetItem, rewardCls)
    sleep(1200); -- 애니 끝나고 줄라고

    local matGuidList, matIDList, matNameList = {}, {}, {};
    matGuidList[#matGuidList + 1] = GetItemGuid(targetItem);
    matIDList[#matIDList + 1] = targetItem.ClassID;
    matNameList[#matNameList + 1] = targetItem.ClassName;

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end

    TxTakeItemByObject(tx, targetItem, 1, 'LegendItem_Decompose');

    local GetRewardCountScp = _G[rewardCls.MaterialCountScp];
    local rewardClsName = rewardCls.MaterialClassName;
    local rewardMatCls = GetClass('Item', rewardClsName);
    local rewardCnt = GetRewardCountScp(targetItem);
    TxGiveItem(tx, rewardClsName, rewardCnt, 'LegendItem_Decompose');

    local resultNameList, resultIDList, resultCntList = {}, {}, {};
    resultIDList[#resultIDList + 1] = rewardMatCls.ClassID;
    resultNameList[#resultNameList + 1] = rewardMatCls.ClassName;
    resultCntList[#resultCntList + 1] = rewardCnt;

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        return;
    end

    SendAddOnMsg(pc, 'RESULT_LEGEND_DECOMPOSE', rewardClsName, rewardCnt);
    ItemDecomposingMongoLog(pc, 'LegendItem', matGuidList, matIDList, matNameList, resultIDList, resultNameList, resultCntList);
end

-- 레전드 아이템 제작
function LEGEND_CRAFT_RELEASE(pc) -- 제작시 UI 홀드해두기 때문에 제작 실패든 성공이든 다시 풀어줘야 함
    SendAddOnMsg(pc, 'END_LEGEND_CRAFT');
    local npcHandle = GetExProp(pc, 'LEGEND_NPC_HANDLE');    
    local npc = GetByHandle(pc, npcHandle);
    if npc ~= nil then
        PlayArmorTouchUp(npc, pc, 0);
    end
end

function SCR_LEGEND_CRAFT(pc, itemGuid, argList)    
    if #argList ~= 1 then
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    if IsRunningScript(pc, '_SCR_LEGEND_CRAFT') ~= 1 then
        _SCR_LEGEND_CRAFT(pc, argList[1]);
    end
end

function _SCR_LEGEND_CRAFT(pc, recipeID)    
    local recipeCls = GetClassByType('legendrecipe', recipeID);
    if recipeCls == nil then
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    local maxMaterialCnt = recipeCls.MaterialItemSlotCnt;
    local matTable = {};
    local aniItemID = 0;
    for i = 1, maxMaterialCnt do
        local materialItemName = TryGetProp(recipeCls, 'MaterialItem_'..i, 'None');        
        if materialItemName ~= 'None' then
            if matTable[materialItemName] ~= nil then
                 -- 재료 아이템은 전부 스택형이고, 겹치지 않는 것이 현재의 요구사항.
                 -- 혹시 추후 비스택형 아이템도 재료가 돼서 여러개 쓰여야 하면 재료 검증에서 서로 다른 guid로 여러개 있나 확인하는 등 재료 확인 로직을 수정해주세요.
                Chat(pc, 'Duplicate Material Error!');
                LEGEND_CRAFT_RELEASE(pc);
                return;
            end

            local invItem, cnt = GetInvItemByName(pc, materialItemName);
            if invItem == nil or cnt < recipeCls['MaterialItemCnt_'..i] then
                LEGEND_CRAFT_RELEASE(pc);
                return;
            end

            if IsFixedItem(invItem) == 1 then                
                SendSysMsg(pc, 'MaterialItemIsLock');
                LEGEND_CRAFT_RELEASE(pc);
                return;
            end

            matTable[materialItemName] = true;

            if aniItemID == 0 then
                local aniItem = GetClass('Item', materialItemName);
                aniItemID = aniItem.ClassID;
            end
        end
    end

    -- 대장장이 애니
    local npcHandle = GetExProp(pc, 'LEGEND_NPC_HANDLE');    
    if npcHandle == 0 then
        SendSysMsg(pc, 'CantUseEnchantBomb');
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    local npc = GetByHandle(pc, npcHandle);
    if npc == nil then
        SendSysMsg(pc, 'CantUseEnchantBomb');
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    local aniTime = 3;    
    PlayArmorTouchUp(npc, pc, aniItemID);
    local result = DOTIMEACTION_ONLY_TARGET(npc, pc, ScpArgMsg("GivingBuffToWeapon"), '#LegendCrafting', aniTime, 0);    
    if result ~= 1 then
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    if IsRunningScript(pc, 'TX_LEGEND_CRAFT') ~= 1 then
        TX_LEGEND_CRAFT(pc, recipeCls);
    end
end

function TX_LEGEND_CRAFT(pc, recipeCls)
    local tx = TxBegin(pc);
    if tx == nil then
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    local matGuidList = {};
    local matClassNameList = {};    
    local matCntList = {};
    local maxMaterialCnt = recipeCls.MaterialItemSlotCnt;
    for i = 1, maxMaterialCnt do
        local matItemClassName = recipeCls['MaterialItem_'..i];
        local matItemCnt = recipeCls['MaterialItemCnt_'..i];
        local matItem, curCnt = GetInvItemByName(pc, matItemClassName);        
        if matItem == nil or curCnt < matItemCnt then
            TxRollBack(tx);
            LEGEND_CRAFT_RELEASE(pc);
            return;
        end
        local matItemGuid = GetItemGuid(matItem);
        TxTakeItemByObject(tx, matItem, matItemCnt, 'LegendCraft');

        matGuidList[#matGuidList + 1] = matItemGuid;
        matClassNameList[#matClassNameList + 1] = matItemClassName;
        matCntList[#matCntList + 1] = matItemCnt;
    end

    local targetItemClassName = recipeCls.ClassName;
    local giveCmd = TxGiveItem(tx, targetItemClassName, 1, 'LegendCraft');
    local targetItemGuid = TxGetGiveItemID(tx, giveCmd);
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        LEGEND_CRAFT_RELEASE(pc);
        return;
    end

    -- 연출
    local npcHandle = GetExProp(pc, 'LEGEND_NPC_HANDLE');    
    local npc = GetByHandle(pc, npcHandle);
    if npc ~= nil then        
        local targetItem = GetClass('Item', targetItemClassName);        
        PlayEffectNode(npc, 'F_light008', 1, 'Dummy_ITEM', pc, 'armor_maintain');
        sleep(1500); -- 연출
        PlayArmorTouchUp(npc, pc, targetItem.ClassID);
        sleep(2000);
        PlayArmorTouchUp(npc, pc, 0);
    end

    LegendItemCraftLog(pc, matGuidList, matClassNameList, matCntList, targetItemGuid, targetItemClassName);
    SendAddOnMsg(pc, 'SUCCESS_LEGEND_CRAFT', targetItemClassName);

    sleep(4000); -- 성공 결과 UI 보여주는 동안 딴짓 못하게 막아달라고 하셨음
    LEGEND_CRAFT_RELEASE(pc);
    sleep(1000); -- 연출용
    ShowOkDlg(pc, 'NPC_TERIAVELIS_DLG2', 1);
end

function SCR_REQ_LEGEND_ITEM_DIALOG(pc, dialogType) 
    sleep(200); -- 샵 다이얼로그를 닫으면서 OkDlg가 같이 닫힘. 조금 나중에 다이얼로그를 띄워줄 수 있게 하기 위함
    if dialogType == 0 then -- 초월 관련 다이얼로그
        if GetExProp(pc, 'IS_LEGEND_SHOP') ~= 1 then                        
            local npcClassName = GetExProp_Str(pc, 'TRANSCEND_NPC_NAME');
            if npcClassName == 'npc_fedimian_merchant_4' then -- 페디미안 대장장이 안나--
                ShowOkDlg(pc, 'NPC_ANNA_LEGENDITEM_DLG1', 1); 
            elseif npcClassName == 'npc_blacksmith' then -- 클라페다 대장장이 자라스--
                ShowOkDlg(pc, 'NPC_JARAS_LEGENDITEM_DLG1', 1); 
            elseif npcClassName == 'npc_illanai' then -- 오르샤 대장장이 일라나이--
                ShowOkDlg(pc, 'NPC_ILANAI_LEGENDITEM_DLG1', 1);
            end
        end
    elseif dialogType == 1 then -- 축복석 추출 / 아이템 추출 관련 다이얼로그--     
        local npcClassName = GetExProp_Str(pc, 'TRANSCEND_NPC_NAME');
        if npcClassName == 'npc_fedimian_merchant_4' then -- 페디미안 대장장이 안나--
            ShowOkDlg(pc, 'NPC_ANNA_LEGENDITEM_DLG1', 1); 
        elseif npcClassName == 'npc_blacksmith' then -- 클라페다 대장장이 자라스--
            ShowOkDlg(pc, 'NPC_JARAS_LEGENDITEM_DLG1', 1); 
        elseif npcClassName == 'npc_illanai' then -- 오르샤 대장장이 일라나이--
            ShowOkDlg(pc, 'NPC_ILANAI_LEGENDITEM_DLG1', 1);
        elseif npcClassName == 'npc_Teliavelis' then -- 테리아베리스 --
            ShowOkDlg(pc, 'NPC_ILANAI_LEGENDITEM_DLG1', 1);
        end
    end
end