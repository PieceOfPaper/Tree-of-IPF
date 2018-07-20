-- mgame_itemdungeon.lua
function EXEC_ITEM_AWAKENING(buyer, seller, skill, targetItem, stoneItem, price)    
    if buyer == nil or seller == nil or skill == nil or targetItem == nil then
        return;
    end

    if price < 1 then
        return;
    end
    local needItemClsName, needCnt = GET_ITEM_AWAKENING_PRICE(targetItem);
    local needItem, sellerItemCnt = GetInvItemByName(seller, needItemClsName);    
    if sellerItemCnt < needCnt or IsFixedItem(needItem) == 1 then
        SendSysMsg(buyer, "NotEnoughRecipe");
        return;
    end

    local totalPrice = price * needCnt;
    local pcMoney, moneyCnt  = GetInvItemByName(buyer, MONEY_NAME);
    if pcMoney == nil or moneyCnt < totalPrice or IsFixedItem(pcMoney) == 1 then
        SendSysMsg(buyer, "NotEnoughMoney");
        return;
    end

    if (stoneItem == nil and targetItem.PR < 1) or targetItem.IsAwaken == 1 or IsFixedItem(targetItem) == 1 then
        return;
    end

    if IS_NEED_APPRAISED_ITEM(targetItem) == true  or IS_NEED_RANDOM_OPTION_ITEM(targetItem) == true then
        return;
    end

    local useStone = 0;
    if stoneItem ~= nil then
        if IsFixedItem(stoneItem) == 1 or IS_ITEM_AWAKENING_STONE(stoneItem) == false or stoneItem.ItemLifeTimeOver > 0 then
            return;
        end
        useStone = 1;
    end

    -- Tx
    local sellerHandle = GetHandle(seller);
    local buyerHandle = GetHandle(buyer);
    if sellerHandle == buyerHandle then -- 자기가 자기거 각성할 때
        local tx = TxBegin(buyer);
        TxTakeItem(tx, needItemClsName, needCnt, skill.ClassName);
        TX_ITEM_AWAKENING(tx, targetItem, stoneItem);
        local ret = TxCommit(tx);
        if ret ~= 'SUCCESS' then            
            SendSysMsg(buyer, 'DataError');
            return;
        end
    else
        local tx1, tx2 = TxBeginDouble(seller, buyer);
        if tx1 == nil or tx2 == nil then
            return;
        end
        TxTakeItem(tx1, needItemClsName, needCnt, skill.ClassName);
        TxTakeItem(tx2, MONEY_NAME, totalPrice, skill.ClassName);
        
        local giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100);
        if giveMoney > 0 then
            TxGiveItem(tx1, MONEY_NAME, giveMoney, skill.ClassName);
        end
        TX_ITEM_AWAKENING(tx2, targetItem, stoneItem);

        local ret = TxCommit(tx1);
        if ret ~= 'SUCCESS' then            
            SendSysMsg(buyer, 'DataError');
            return;
        end

        if giveMoney > 0 then
            if IsExistAutoSellerInAdevntureBook(seller, skill.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(seller, skill.Name);
            end
            AddAdventureBookAutoSellerInfo(seller, skill.ClassID, giveMoney);
        end
        AddAutoSellHistory(seller, AUTO_SELL_AWAKENING, targetItem.ClassID, 1, giveMoney, GetTeamName(buyer)..'#'..targetItem.ClassName);
    end

    ShowItemBalloon(buyer, "{@st43}", "ItemIsAwaken", "", targetItem, 5, 1, "reward_itembox");
    ItemAwakeningMongoLog(seller, buyer, "Alchemist", targetItem, useStone, targetItem.HiddenProp, targetItem.HiddenPropValue, giveMoney, 1);
    SendAddOnMsg(buyer, 'SUCCESS_ITEM_AWAKENING');
end

function TX_ITEM_AWAKENING(tx, targetItem, stoneItem)
    if nil == stoneItem then
        TxAddIESProp(tx, targetItem, "PR", -1);
    else
        TxTakeItemByObject(tx, stoneItem, 1, "ItemDungeon");
    end
    local propName, propValue = SCR_GET_HIDDEN_PROP_AND_VALUE(targetItem);
    if propName ~= targetItem.HiddenProp then        
        TxSetIESProp(tx, targetItem, "HiddenProp", tostring(propName));
    end
    if propValue ~= targetItem.HiddenPropValue then
        TxSetIESProp(tx, targetItem, "HiddenPropValue", tonumber(propValue));
    end

    TxSetIESProp(tx, targetItem, "IsAwaken", 1);
end

function CHECK_PC_EXIT(cmd, curStage, eventInst, obj)
    local worldInstID = cmd:GetZoneInstID();
    local zoneObj = GetLayerObject(worldInstID, 0);
    local itemGuid = GetExProp_Str(zoneObj, "ITEM_GUID");

    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if 0 >= cnt then
        return 1;
    end

    local livePCCnt = 0
    local aliveOwenr = 0;

    for i = 1 , cnt do
        local pc = list[i];
        if IsDead(pc) ~= 1 then
            livePCCnt = livePCCnt + 1
        end

        local invItem = GetPCItemByGuid(pc, itemGuid);
        if invItem ~= nil then
            aliveOwenr = IsDead(pc);
        end
    end

    if 1 == aliveOwenr then
        return 1;
    end

    if livePCCnt <= 0 then
        return 1;
    end 

    return 0;
end
