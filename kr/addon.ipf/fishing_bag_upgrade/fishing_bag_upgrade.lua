function FISHING_BAG_UPGRADE_ON_INIT(addon, frame)
end

function OPEN_FISHING_BAG_UPGRADE(frame)
    local pc = GetMyPCObject();
    local account = session.barrack.GetMyAccount();
    local accountObj = GetMyAccountObj();
    local currentExpandCount = accountObj.FishingItemBagExpandCount;
    local nextExpandCount = currentExpandCount + 1;
        
    -- button
    local upgradeBtn = frame:GetChild('upgradeBtn');
    local cost = GET_FISHING_ITEM_BAG_UPGRADE_COST(pc, currentExpandCount);    
    if cost == 0 then
        ui.SysMsg(ClMsg('ExceedMaxFishingItemBagSlotCount'));
        frame:ShowWindow(0);
        return;
    end
    upgradeBtn:SetTextByKey('cost', cost);

    -- text
    local beforeText = frame:GetChild('beforeText');
    local afterText = frame:GetChild('afterText');
    beforeText:SetTextByKey('step', currentExpandCount + 1);
    afterText:SetTextByKey('step', nextExpandCount + 1);

    -- slot
    local UPGRADE_IMG = frame:GetUserConfig('UPGRADE_IMG');
    local beforeSlot = frame:GetChild('beforeSlot');
    local afterSlot = frame:GetChild('afterSlot');
    SET_SLOT_IMG(beforeSlot, UPGRADE_IMG..currentExpandCount);
    SET_SLOT_IMG(afterSlot, UPGRADE_IMG..nextExpandCount);

    -- info
    local beforeInfoText = GET_CHILD_RECURSIVELY(frame, 'beforeInfoText');
    beforeInfoText:SetTextByKey('capacity', account:GetMaxFishingItemBagSlotCount(0));
    beforeInfoText:SetTextByKey('count', SCR_GET_MAX_FISHING_SUCCESS_COUNT(pc, 0));

    local afterInfoText = GET_CHILD_RECURSIVELY(frame, 'afterInfoText');
    afterInfoText:SetTextByKey('capacity', account:GetMaxFishingItemBagSlotCount(1));
    afterInfoText:SetTextByKey('count', SCR_GET_MAX_FISHING_SUCCESS_COUNT(pc, 1));
end

function FISHING_BAG_UPGRADE_CLICK(parent, ctrl)
    ui.Chat('/upgradeFishingItemBag');
    ui.CloseFrame('fishing_bag_upgrade');
end