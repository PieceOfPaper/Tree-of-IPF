function SOCKET_TICKET_ON_INIT(addon, frame)

end

function SOCKET_TICKET_OPEN(frame, targetItem)
    if targetItem == nil then
        return;
    end
    local fromItemSlot = GET_CHILD_RECURSIVELY(frame, 'fromItemSlot');
    local targetItemObj = GetIES(targetItem:GetObject());
    local img = GET_ITEM_ICON_IMAGE(targetItemObj);
    SET_SLOT_IMG(fromItemSlot, img);
    SET_SLOT_IESID(fromItemSlot, targetItem:GetIESID());

    local icon = fromItemSlot:GetIcon();
    local iconInfo = icon:GetInfo();
    iconInfo.type = targetItemObj.ClassID;

    SET_ITEM_TOOLTIP_BY_OBJ(icon, targetItem);
    local appraisalSocket = targetItemObj.AppraisalSoket
    if appraisalSocket == nil then
        appraisalSocket = 0;
    end
    
    local itemMaxSocket = targetItemObj.MaxSocket_COUNT;
    if itemMaxSocket == nil then
        return;
    end
    
    local maxSocket = itemMaxSocket + appraisalSocket;
    if 0 == maxSocket then
        return;
    end
    
    local nextSlotIdx = GET_NEXT_SOCKET_SLOT_INDEX(targetItemObj);
    local hitCountDesc = GET_CHILD_RECURSIVELY(frame, 'hitCountDesc');
    hitCountDesc:SetTextByKey('cur', nextSlotIdx);
    hitCountDesc:SetTextByKey('max', maxSocket);

    local hitPriceDesc = GET_CHILD_RECURSIVELY(frame, 'hitPriceDesc');
    local priceStr = GET_COMMAED_STRING(GET_SOCKET_ADD_PRICE_BY_TICKET(targetItemObj));
    hitPriceDesc:SetTextByKey('price', priceStr);
end

function CLIENT_SOCKET_TICKET(ticketItem)
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('CannotUseInPVPZone'));
        return;
    end

    if IsPVPServer() == 1 then
        ui.SysMsg(ScpArgMsg('CantUseThisInIntegrateServer'));
        return;
    end

    local rankresetFrame = ui.GetFrame("rankreset");
    if 1 == rankresetFrame:IsVisible() then
        ui.SysMsg(ScpArgMsg('CannotDoAction'));
        return;
    end

    local frame = ui.GetFrame("socket_ticket");
    if 1 == frame:IsVisible() then
        return;
    end
    local obj = GetIES(ticketItem:GetObject());
    frame:SetUserValue('TICKET_ITEM_ID', ticketItem:GetIESID());

    if obj.ItemLifeTimeOver > 0 then
        ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
        return;
    end

    local fromItemSlot = GET_CHILD_RECURSIVELY(frame, 'fromItemSlot');
    SET_SLOT_ITEM(fromItemSlot, ticketItem);
    ui.GuideMsg("SelectItem");

    local invframe = ui.GetFrame("inventory");
    local gbox = invframe:GetChild("inventoryGbox");
    local x, y = GET_GLOBAL_XY(gbox);
    x = x - gbox:GetWidth() * 0.7;
    y = y - 40;
    SET_MOUSE_FOLLOW_BALLOON(ClMsg("ClickSocketTargetItem"), 0, x, y);
    ui.SetEscapeScp("CANCEL_MORU()");

    local tab = gbox:GetChild("inventype_Tab");
    tolua.cast(tab, "ui::CTabControl");
    tab:SelectTab(0);

    SET_SLOT_APPLY_FUNC(invframe, "_CHECK_SOCKET_TICKET_TARGET_ITEM");
    SET_INV_LBTN_FUNC(invframe, "SOCKET_TICKET_EXECUTE");

    CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_SOCKET_PLUS");
end

function _CHECK_SOCKET_TICKET_TARGET_ITEM(slot)
    local item = GET_SLOT_ITEM(slot);
    if nil == item then
        return;
    end

    local obj = GetIES(item:GetObject());
    if obj == nil then
        return;
    end

    if SCR_CHECK_ADD_SOCKET(obj, item) == true then
        slot:GetIcon():SetGrayStyle(0);
        slot:SetBlink(60000, 2.0, "FFFFFF00", 1);
    else
        slot:GetIcon():SetGrayStyle(1);
        slot:ReleaseBlink();
    end
end

function SOCKET_TICKET_EXECUTE(frame, invItem)
    if true == invItem.isLockState then
        ui.SysMsg(ClMsg("ThisItemCannotPlusSocket"));
        return;
    end

    local obj = GetIES(invItem:GetObject());
    if obj == nil then
        return;
    end

    if SCR_CHECK_ADD_SOCKET(obj, item) == false then
        ui.SysMsg(ClMsg("ThisItemCannotPlusSocket"));
        return;
    end

    CANCEL_MORU();

    local socket_ticket = ui.GetFrame('socket_ticket');
    SOCKET_TICKET_OPEN(socket_ticket, invItem);
    socket_ticket:ShowWindow(1);
end

function CURSOR_CHECK_SOCKET_PLUS(slot)
    local item = GET_SLOT_ITEM(slot);
    if item == nil then
        return 0;
    end

    local obj = GetIES(item:GetObject());
    if obj == nil then
        return 0;
    end

    if SCR_CHECK_ADD_SOCKET(obj, item) == false then
        return 0;
    end

    return 1;
end

function SOCKET_TICKET_CLICK_EXEC_BTN(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local fromItemSlot = GET_CHILD_RECURSIVELY(frame, 'fromItemSlot');
    local icon = fromItemSlot:GetIcon();
    local iconInfo = icon:GetInfo();

    local targetItemID = iconInfo:GetIESID();
    local ticketItemID = frame:GetUserValue('TICKET_ITEM_ID');
    local targetItemClassID = iconInfo.type;
    local targetItem = GetClassByType('Item', targetItemClassID);
    if targetItem == nil then
        return;
    end

    -- check item
    local ticketInvItem = session.GetInvItemByGuid(ticketItemID);
    local targetInvItem = session.GetInvItemByGuid(targetItemID);
    if ticketInvItem == nil or targetInvItem == nil then
        return;
    end 
    
    if ticketInvItem.isLockState == true or targetInvItem.isLockState == true then
        ui.SysMsg(ClMsg('MaterialItemIsLock'));
        return;
    end

    -- check price
    local hitPriceDesc = GET_CHILD_RECURSIVELY(frame, 'hitPriceDesc');
    local price = GET_NOT_COMMAED_NUMBER(hitPriceDesc:GetTextByKey('price'));
    if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
        ui.SysMsg(ClMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
        return;
    end

    local yesScp = string.format('REQUEST_ADD_SOCKET_BY_TICKET("%s", "%s")', targetItemID, ticketItemID);
    ui.MsgBox(ScpArgMsg('AddSocketByTicketInfoMsg{ITEM_NAME}', 'ITEM_NAME', targetItem.Name), yesScp, 'None');
end

function REQUEST_ADD_SOCKET_BY_TICKET(targetItemID, ticketItemID)
    local resultlist = session.GetItemIDList();
    session.ResetItemList();
	if nil~= targetItemID then
		session.AddItemID(targetItemID);
        session.AddItemID(ticketItemID);
	end
    item.DialogTransaction("ADD_SOCKET_BY_TICKET", resultlist);
    ui.CloseFrame('socket_ticket');
end