function FISHING_ON_INIT(addon, frame)
end

function FISHING_OPEN_UI(fishingPlaceHandle, fishingRodID)
    local frame = ui.GetFrame('fishing');

    FISHING_INIT_UI(frame, fishingPlaceHandle, fishingRodID);    
    frame:ShowWindow(1);
    packet.RequestItemList(IT_FISHING);
    -- Fishing UI Open Sound --
    imcSound.PlaySoundEvent("sys_event_window_open_1");    
    control.EnableControl(0);
end

function FISHING_INIT_UI(frame, fishingPlaceHandle, fishingRodID)
    local fishingPlace = world.GetActor(fishingPlaceHandle);
    local fishingRod = GetClassByType('Item', fishingRodID);    
    if fishingPlace == nil or fishingRod == nil then        
        return;
    end
    local pasteBaitCount = FISHING_PASTE_BAIT_SLOTSET_INIT(frame);
    FISHING_ARROW_BTN_INIT(frame, pasteBaitCount);
    
    frame:SetUserValue('FISHING_PLACE_HANDLE', fishingPlaceHandle);
    frame:SetUserValue('FISHING_ROD_ID', fishingRodID);
    frame:SetUserValue('PASTE_BAIT_ID', 0);
end

function FISHING_CLOSE_UI()
    ui.CloseFrame('fishing');    
    control.EnableControl(1);
end

function FISHING_CANCEL_LBTN_CLICK(parent, ctrl)
    FISHING_CLOSE_UI();
end

function FISHING_START_LBTN_CLICK(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local fishingPlaceHandle = topFrame:GetUserIValue('FISHING_PLACE_HANDLE');
    local fishingRodID = topFrame:GetUserIValue('FISHING_ROD_ID');    
    if fishingPlaceHandle == 0 or fishingRodID == 0 then -- invalid data
        ui.SysMsg(ClMsg('TryLater')); 
        FISHING_CLOSE_UI();
        return;
    end

    local pasteBaitID = 0;
    local pasteBaitSlotset = GET_CHILD_RECURSIVELY(topFrame, 'pasteBaitSlotset');
    local selectedSlot = pasteBaitSlotset:GetSelectedSlot(0);
    if selectedSlot == nil then
        ui.SysMsg(ClMsg('YouNeedPasteBait'));
        return;
    end
    pasteBaitID = selectedSlot:GetUserIValue('PASTE_BAIT_ID');
    
    -- Fishing Start Button Sound --
    imcSound.PlaySoundEvent("button_click_big");
    Fishing.ReqFishing(1, fishingPlaceHandle, fishingRodID, pasteBaitID);
    FISHING_CLOSE_UI();
end

function FISHING_EXIT_LBTN_CLICK(parent, ctrl)    
    FISHING_CLOSE_UI();
end

function FISHING_LEFT_BTN_CLICK(parent, ctrl)  
    local currentSlot = parent:GetUserIValue('CURRENT_SLOT');
    local pasteBaitSlotset = GET_CHILD_RECURSIVELY(parent, 'pasteBaitSlotset');        
    if currentSlot == 0 then
        return;
    end
        
    UI_PLAYFORCE(pasteBaitSlotset, "slotsetRightMove_1");
    parent:SetUserValue('CURRENT_SLOT', currentSlot - 1);

     -- button enable
    if currentSlot - 1 == 0 then
       ctrl:SetEnable(0);
    end
    local rightBtn = GET_CHILD_RECURSIVELY(parent, 'rightBtn');
    rightBtn:SetEnable(1);
end

function FISHING_RIGHT_BTN_CLICK(parent, ctrl)
    local currentSlot = parent:GetUserIValue('CURRENT_SLOT');
    local pasteBaitSlotset = GET_CHILD_RECURSIVELY(parent, 'pasteBaitSlotset');
    if currentSlot == 0 then
        return;
    end
        
    UI_PLAYFORCE(pasteBaitSlotset, "slotsetLeftMove_1");
    parent:SetUserValue('CURRENT_SLOT', currentSlot - 1);

     -- button enable
    if currentSlot + 5 == 10 then
       ctrl:SetEnable(0);
    end
    local leftBtn = GET_CHILD_RECURSIVELY(parent, 'leftBtn');
    leftBtn:SetEnable(1);
end

function FISHING_PASTE_BAIT_SLOTSET_INIT(frame)
    local pasteBaitSlotset = GET_CHILD_RECURSIVELY(frame, 'pasteBaitSlotset');
    pasteBaitSlotset:ClearIconAll();
    pasteBaitSlotset:ClearSelectedSlot();

    local invItemList = session.GetInvItemList();
    FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, pasteBaitSlotset)		
		if invItem ~= nil then
		    local itemObj = GetIES(invItem:GetObject());
            if IS_PASTE_BAIT_ITEM(itemObj.ClassID) == 1 then
                local pasteBaitCount = imcSlot:GetEmptySlotIndex(pasteBaitSlotset);
                local slot = pasteBaitSlotset:GetSlotByIndex(pasteBaitCount);
                if slot == nil then
                    slot = GET_EMPTY_SLOT(pasteBaitSlotset);
                end        
                SET_SLOT_IMG(slot, itemObj.Icon);
                SET_SLOT_COUNT(slot, invItem.count);
                SET_SLOT_COUNT_TEXT(slot, invItem.count);
                SET_SLOT_IESID(slot, invItem:GetIESID());
                SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemObj, nil);
                SET_ITEM_TOOLTIP_BY_NAME(slot:GetIcon(), itemObj.ClassName);
                slot:SetMaxSelectCount(1);
                slot:SetUserValue('PASTE_BAIT_ID', itemObj.ClassID);
            end
	    end
	end, false, pasteBaitSlotset);
    return imcSlot:GetFilledSlotCount(pasteBaitSlotset);
end

function FISHING_ARROW_BTN_INIT(frame, pasteBaitCount)
    local leftBtn = frame:GetChild('leftBtn');
    local rightBtn = frame:GetChild('rightBtn');
    frame:SetUserValue('CURRENT_SLOT', 0);
    if pasteBaitCount < 6 then
        leftBtn:SetEnable(0);
        rightBtn:SetEnable(0);
        return;
    else        
        leftBtn:SetEnable(0);
        rightBtn:SetEnable(1);
    end
end 