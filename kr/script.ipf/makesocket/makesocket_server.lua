function SCR_MAKE_SOCKET(pc)

    local itemList = GetDlgItemList(pc);
    if itemList == nil then
        return;
    end

    for i = 1, #itemList do
        local targetitem = itemList[i]

        if targetitem == nil then
            return;
        end

        local itemClass = GetClass("Item", targetitem.ClassName);

        if itemClass == nil then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
            return;
        end

        local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");

        if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then

            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
            return;
        end



        if 1 == IsFixedItem(targetitem) then
            return;
        end

		-- �� Ÿ��
        if targetitem == nil or targetitem.ItemType ~= 'Equip' then
			print('Equip��� �ƴϴ� Ŭ���� �����˻縦 �����ٵ�.. ����� ���Դٴ°� Ŭ�� �շȴٴ°� �ƴѰ�?')
            return;
        end

		-- ���� ���ټ�
        if targetitem.PR <= 0 then
			print('���ټ��� �����ϴ�. Ŭ���� �����˻縦 �����ٵ�.. ����� ���Դٴ°� Ŭ�� �շȴٴ°� �ƴѰ�?')
            return;
        end

        local nowusesocketcount = 0

        for i = 0, targetitem.MaxSocket - 1 do
            local nowsockettype = targetitem['Socket_' .. i]

            if nowsockettype ~= 0 then
                nowusesocketcount = nowusesocketcount + 1
            end
        end

		-- ���� �ƽ� ����
        if targetitem.MaxSocket - nowusesocketcount <= 0 then
			print('���� ������ �����ϴ�. Ŭ���� �����˻縦 �����ٵ�.. ����� ���Դٴ°� Ŭ�� �շȴٴ°� �ƴѰ�?')
            return;
        end


        local maxcnt = targetitem.MaxSocket;
        local curcnt = GET_SOCKET_CNT(targetitem);


        if curcnt >= maxcnt then
            SysMsg(pc, "Item", ScpArgMsg("ALREADY_MAX_SOCKET"));
            return;
        end
        local lv = TryGetProp(targetitem, "UseLv");
        if lv == nil then
            return 0;
        end
        local grade = TryGetProp(targetitem, "ItemGrade");
        if grade == nil then
            return 0;
        end
        local price = GET_MAKE_SOCKET_PRICE(lv, grade, curcnt)
        local MyMoneyCount = GetInvItemCount(pc, 'Vis');
        if MyMoneyCount < price then
            SysMsg(pc, "Item", ScpArgMsg("NOT ENOUGH MONEY"));
            return;
        end

        local tx = TxBegin(pc);
        if tx == nil then
            return;
        end

        TxAddIESProp(tx, targetitem, 'PR', -1);

        if price > 0 then
            TxTakeItem(tx, 'Vis', price, "SocketAdd");
        end

        local randomsocket = DECIDE_SOCKET_TYPE();
        TxSetIESProp(tx, targetitem, 'Socket_' .. curcnt, randomsocket);

        local ret = TxCommit(tx);
        if ret == 'SUCCESS' then
            SocketMongoLog(pc, "SocketAdd", "None", price, 0, curCnt, targetitem.ClassName, targetitem);
        end
    end

    SendAddOnMsg(pc, "MSG_MAKE_ITEM_SOCKET", "", 0);
    InvalidateStates(pc);
end

function SCR_GOLD_SOCKET_TICKET(targetItem)

    local item = targetItem

    local enable_Socket = SCR_CHECK_ADD_SOCKET(item)
    if enable_Socket == false then
        return;
    end

    local curcnt = GET_SOCKET_CNT(item);

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end

    local randomsocket = DECIDE_SOCKET_TYPE();
    TxSetIESProp(tx, item, 'Socket_' .. curcnt, randomsocket);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
    end

end

function SCR_ADD_SOCKET_BY_TICKET(pc)
    local itemList = GetDlgItemList(pc);
	if itemList == nil then
		return;
	end

    local targetItem = itemList[1];
    local ticketItem = itemList[2];

    -- check target item    
    if SCR_CHECK_ADD_SOCKET(targetItem) == false or IsFixedItem(targetItem) == 1 then
        return;
    end

    -- check ticket item
    if IS_SOCKET_ADD_TICKET_ITEM(ticketItem) == false or IsFixedItem(ticketItem) == 1 then
        return;
    end

    -- check price
    local price = GET_SOCKET_ADD_PRICE_BY_TICKET(targetItem);
    local pcMoney, cnt = GetInvItemByName(pc, MONEY_NAME);
    if pcMoney == nil or price > cnt then
        return;
    end

    if IsRunningScript(pc, 'TX_ADD_SOCKET_BY_TICKET') == 1 then
        return;
    end

    TX_ADD_SOCKET_BY_TICKET(pc, targetItem, ticketItem, price);
end

function TX_ADD_SOCKET_BY_TICKET(pc, targetItem, ticketItem, price)
    if pc == nil or targetItem == nil or ticketItem == nil then
        return;
    end

    local curcnt = GET_SOCKET_CNT(targetItem);
    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    
    local takePrice = price;
    local randomsocket = DECIDE_SOCKET_TYPE();    
    TxTakeItemByObject(tx, ticketItem, 1, "USE_GOLD_SOCKET_TICKET")
    TxTakeItem(tx, 'Vis', takePrice , "USE_GOLD_SOCKET_TICKET")
    TxSetIESProp(tx, targetItem, 'Socket_' .. curcnt, randomsocket);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
    end
end

function IS_SOCKET_ADD_TICKET_ITEM(item)
    if item.StringArg == 'OLD_GOLD_SOCKET' then
        return true;
    end

    return false;
end