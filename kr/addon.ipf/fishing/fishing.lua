function FISHING_ON_INIT(addon, frame)
end

function FISHING_OPEN_UI(fishingPlaceHandle, fishingRodID)
    local frame = ui.GetFrame('fishing');

    FISHING_INIT_UI(frame, fishingPlaceHandle, fishingRodID);    
    frame:ShowWindow(1);
    packet.RequestItemList(IT_FISHING);
    ui.OpenFrame('inventory');
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

    local pasteBaitSlot = GET_CHILD(frame, 'pasteBaitSlot');
    pasteBaitSlot:ClearIcon();
    
    frame:SetUserValue('FISHING_PLACE_HANDLE', fishingPlaceHandle);
    frame:SetUserValue('FISHING_ROD_ID', fishingRodID);
    frame:SetUserValue('PASTE_BAIT_ID', 0);
end

function FISHING_CLOSE_UI()
    ui.CloseFrame('fishing');
    ui.CloseFrame('inventory');
    control.EnableControl(1);
end

function FISHING_CANCEL_LBTN_CLICK(parent, ctrl)
    FISHING_CLOSE_UI();
end

function FISHING_START_LBTN_CLICK(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local fishingPlaceHandle = topFrame:GetUserIValue('FISHING_PLACE_HANDLE');
    local fishingRodID = topFrame:GetUserIValue('FISHING_ROD_ID');
    local pasteBaitID = topFrame:GetUserIValue('PASTE_BAIT_ID');
    if fishingPlaceHandle == 0 or fishingRodID == 0 then -- invalid data
        ui.SysMsg(ClMsg('TryLater')); 
        FISHING_CLOSE_UI();
        return;
    end

    if pasteBaitID == 0 then
        ui.SysMsg(ClMsg('YouNeedPasteBait'));
        return;
    end
    
    -- Fishing Start Button Sound --
    imcSound.PlaySoundEvent("button_click_big");
    Fishing.ReqFishing(1, fishingPlaceHandle, fishingRodID, pasteBaitID);
    FISHING_CLOSE_UI();
end

function FISHING_EXIT_LBTN_CLICK(parent, ctrl)    
    FISHING_CLOSE_UI();
end

function FISHING_DROP_PASTE_BAIT(parent, ctrl)
    local liftIcon = ui.GetLiftIcon();
    local iconInfo = liftIcon:GetInfo();
    local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());   
    if invItem == nil or iconInfo == nil then
        return nil;
    end 
    if true == invItem.isLockState then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return;
    end 
    if nil == session.GetInvItemByType(invItem.type) then
        ui.SysMsg(ClMsg("CannotDropItem"));
        return nil;
    end
    if IS_PASTE_BAIT_ITEM(invItem.type) ~= 1 then
        ui.SysMsg(ClMsg('ItsNotPasteBaitItem'));
        return nil;
    end
    
    local topFrame = parent:GetTopParentFrame();
    topFrame:SetUserValue('PASTE_BAIT_ID', invItem.type);
    SET_SLOT_ITEM_IMAGE(ctrl, invItem);
end

function FISHING_POP_PASTE_BAIT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    topFrame:SetUserValue('PASTE_BAIT_ID', 0);
    ctrl:ClearIcon();
end