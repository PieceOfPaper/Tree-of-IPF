function FISHING_ITEM_BAG_ON_INIT(addon, frame)    
    addon:RegisterMsg("FISHING_ITEM_LIST", "ON_FISHING_ITEM_LIST");
    addon:RegisterMsg('FISHING_EXPAND_SLOT', 'FISHING_ITEM_BAG_RESET_MAX_SLOT_COUNT');
    addon:RegisterMsg('FISHING_SUCCESS_COUNT', 'FISHING_ITEM_BAG_SET_COUNT_BOX');
end

function FISHING_ITEM_BAG_TOGGLE_UI()
    local frame = ui.GetFrame('fishing_item_bag');
    if frame ~= nil and frame:IsVisible() == 1 then
        ui.CloseFrame('fishing_item_bag');
        return;
    end
    FISHING_ITEM_BAG_OPEN_UI();
end

function FISHING_ITEM_BAG_OPEN_UI()
    local frame = ui.GetFrame('fishing_item_bag');
    FISHING_ITEM_BAG_RESET_MAX_SLOT_COUNT(frame);
    frame:SetUserValue('OWNER_AID', session.loginInfo.GetAID());
    frame:ShowWindow(1);
    packet.RequestItemList(IT_FISHING);
    
    -- FishingBag Open Sound --
    imcSound.PlaySoundEvent("sys_event_start_1");

    local enable = Fishing.GetMyFishingState();
    FISHING_ITEM_BAG_ENABLE_EXIT_BTN(enable);
end

function FISHING_ITEM_BAG_RESET_MAX_SLOT_COUNT(frame)
    local account = session.barrack.GetMyAccount();
    local slotCount = account:GetMaxFishingItemBagSlotCount();
    local slotCountText = frame:GetChild('slotCountText');
    local itemSlotset = GET_CHILD(frame, 'itemSlotset');
    slotCountText:SetTextByKey('max', slotCount);

    for i = 0, slotCount - 1 do
       local slot = itemSlotset:GetSlotByIndex(i);
        if slot == nil then
            slot = GET_EMPTY_SLOT(itemSlotset);
        end
        slot:ShowWindow(1);
    end
    FISHING_ITEM_BAG_AUTO_RESIZING(itemSlotset, slotCount - 1);
end

function FISHING_ITEM_BAG_CLOSE_UI()
    ui.CloseFrame('fishing_item_bag');
end

function FISHING_ITEM_BAG_EXIT_BTN(parent, ctrl)
    local clmsg = ClMsg('ReallyExitFishing?');
    local itemList = session.GetEtcItemList(IT_FISHING);
    if itemList:Count() > 0 then
        clmsg = ClMsg('YouHaveFishingItem') .. clmsg;
    end
    ui.MsgBox(clmsg, 'FISHING_ITEM_BAG_EXIT', 'None');
end

function FISHING_ITEM_BAG_EXIT()
    Fishing.ReqFishing(0, 0, 0, 0);
    FISHING_ITEM_BAG_CLOSE_UI();
end

function ON_FISHING_ITEM_LIST(frame, msg, argStr, argNum) -- argStr: owner aid, argNum: owner max slot count
    local isMyFishingItemBag = false;
    if argStr == nil or argStr == 'None' then
        argStr = session.loginInfo.GetAID();
        isMyFishingItemBag = true;
    end
    frame:SetUserValue('OWNER_AID', argStr);

    local itemSlotset = GET_CHILD(frame, 'itemSlotset');    
    itemSlotset:ClearIconAll();

    local itemList = session.GetEtcItemList(IT_FISHING);
    if isMyFishingItemBag == false then
        itemList = session.GetOtherPCFishingItemBag();
    end    
    local index = itemList:Head();
    local slotIndex = 0;
    while itemList:InvalidIndex() ~= index do
        local invItem = itemList:Element(index);
        local itemCls = GetIES(invItem:GetObject());
        local iconImg = GET_ITEM_ICON_IMAGE(itemCls);
        local slot = itemSlotset:GetSlotByIndex(slotIndex);
        if slot == nil then
            slot = GET_EMPTY_SLOT(itemSlotset);
        end
        
        SET_SLOT_IMG(slot, iconImg);
        SET_SLOT_COUNT(slot, invItem.count);
        SET_SLOT_COUNT_TEXT(slot, invItem.count);
        SET_SLOT_IESID(slot, invItem:GetIESID());
        SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, nil);
        slot:SetMaxSelectCount(1);

        local icon = slot:GetIcon();
        icon:SetTooltipArg("accountwarehouse", invItem.type, invItem:GetIESID());
        SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls, "accountwarehouse");  
        slot:ShowWindow(1);

        slotIndex = slotIndex + 1;
        index = itemList:Next(index);
    end

    local slotCountText = frame:GetChild('slotCountText');
    local maxSlotCount = tonumber(slotCountText:GetTextByKey('max'));
    if argNum ~= 0 then
        maxSlotCount = argNum;
        slotCountText:SetTextByKey('max', maxSlotCount);
    end
    slotCountText:SetTextByKey('current', slotIndex);

    -- other pc ui
    if isMyFishingItemBag == false then
        FISHING_ITEM_BAG_AUTO_RESIZING(itemSlotset, slotIndex - 1);
        frame:ShowWindow(1);
    end
    FISHING_ITEM_BAG_ENABLE_BTN(frame, isMyFishingItemBag);

    for i = slotIndex, maxSlotCount do
        local slot = itemSlotset:GetSlotByIndex(i);
        if slot == nil then
            slot = GET_EMPTY_SLOT(itemSlotset);
        end
        slot:ShowWindow(1);
    end

    local slotCount = itemSlotset:GetSlotCount();
    for i = maxSlotCount, slotCount - 1 do
        local slot = itemSlotset:GetSlotByIndex(i);
        if slot ~= nil then
            slot:ShowWindow(0);
        end
    end
    FISHING_ITEM_BAG_SET_COUNT_BOX(frame);
end

function FISHING_ITEM_BAG_AUTO_RESIZING(slotset, slotIndex)
    local slotsetStartYPos = slotset:GetY();
    local slotsetCol = slotset:GetCol();
    local slotsetSpcY = slotset:GetSpcY();            
    local slotRow = math.floor(slotIndex / slotsetCol) + 1;
    local maxSlotBottomPos = slotsetStartYPos + slotset:GetSlotHeight() * slotRow + slotsetSpcY * (slotRow - 1);

    local topFrame = slotset:GetTopParentFrame();   
    local exitBtn = topFrame:GetChild('exitBtn');
    local countBox = topFrame:GetChild('countBox');
    local btnMarginRect = exitBtn:GetMargin();  

    topFrame:Resize(topFrame:GetWidth(), maxSlotBottomPos + exitBtn:GetHeight() + btnMarginRect.bottom * 2 + countBox:GetHeight());
end

function FISHING_ITEM_BAG_GET_ITEM_BTN(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local getItemBtn = GET_CHILD_RECURSIVELY(topFrame, 'getItemBtn');
    local ownerAID = topFrame:GetUserValue('OWNER_AID');
    if session.loginInfo.GetAID() ~= ownerAID then
       return; 
    end

    local itemList = session.GetEtcItemList(IT_FISHING);
    if itemList:Count() < 1 then
        ui.SysMsg(ClMsg('YouDontHaveAnyItemToTake'));
        return;
    end    
    Fishing.ReqGetFishingItem();
end

function FISHING_ITEM_BAG_ENABLE_BTN(frame, needShow)
    local getItemBtn = GET_CHILD_RECURSIVELY(frame, 'getItemBtn');
    local exitBtn = GET_CHILD_RECURSIVELY(frame, 'exitBtn');
    if needShow == true then
        getItemBtn:ShowWindow(1);
        exitBtn:ShowWindow(1);
    else
        getItemBtn:ShowWindow(0);
        exitBtn:ShowWindow(0);
    end
end

function FISHING_ITEM_BAG_SET_COUNT_BOX(frame, msg, argStr, argNum)
    local account = session.barrack.GetMyAccount();
    local accountObj = GetMyAccountObj();
    local curSuccessCount = TryGetProp(accountObj, 'FishingSuccessCount');
    local maxSuccessCount = SCR_GET_MAX_FISHING_SUCCESS_COUNT(GetMyPCObject());
    if curSuccessCount == nil then
        return;
    end
    local isMyFishingItemBag = false;
    if argStr ~= nil and argStr ~= 'None' then
        curSuccessCount = argStr;
        isMyFishingItemBag = true;
    end

    local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
    local countBox = countText:GetParent();
    if frame:GetUserValue('OWNER_AID') ~= session.loginInfo.GetAID() and isMyFishingItemBag == false then
        countBox:ShowWindow(0);
        return;
    end
    countText:SetTextByKey('current', curSuccessCount);
    countText:SetTextByKey('max', maxSuccessCount);
    countBox:ShowWindow(1);
end

function FISHING_ITEM_BAG_ENABLE_EXIT_BTN(enable)
    local frame = ui.GetFrame('fishing_item_bag');
    local exitBtn = frame:GetChild('exitBtn');
    exitBtn:SetEnable(enable);
end

function FISHING_ITEM_BAG_TOGGLE()
    local frame = ui.GetFrame('fishing_item_bag');
    if frame ~= nil and frame:IsVisible() == 1 then
        FISHING_ITEM_BAG_CLOSE_UI();
        return;
    end
    FISHING_ITEM_BAG_OPEN_UI();
end

function FISHING_ITEM_BAG_UPGRADE(parent, ctrl)
    ui.OpenFrame('fishing_bag_upgrade');
end