function UI_CHECK_ALCHEMYWORKSHOP_OPEN(propname, propvalue)    
    local alchemyJob = GetClass('Job', 'Char2_5');
    if IS_HAD_JOB(alchemyJob.ClassID) == true then
        return 1;
    end
    return 0;
end

local function _CHECK_ALCHMY_WORKSHOP_VALID_ITEM(slotName, itemID)
    if slotName == 'combSlot' then
        return IS_VALID_ALCHEMY_WORKSHOP_COMBUSTION(itemID);
    elseif slotName == 'hpSlot' then
        return IS_VALID_ALCHEMY_WORKSHOP_SPRINKLE_HP(itemID);
    elseif slotName == 'spSlot' then
        return IS_VALID_ALCHEMY_WORKSHOP_SPRINKLE_SP(itemID);
    end
    return false;
end

local function _SET_ALCHEMY_WORKSHOP_SLOT(frame, slotName, itemID)    
    local slot = GET_CHILD_RECURSIVELY(frame, slotName);
    if itemID == 0 then
        slot:ClearIcon();
    else        
        if _CHECK_ALCHMY_WORKSHOP_VALID_ITEM(slotName, itemID) == false then            
            ui.SysMsg(ClMsg('WrongDropItem'));
            return;
        end

        local icon = slot:GetIcon();
        if icon == nil then
            icon = CreateIcon(slot);
        end

        local itemCls = GetClassByType('Item', itemID);
        local invItem = session.GetInvItemByType(itemID);
        local itemCount = 0;
        if invItem ~= nil then
            itemCount = invItem.count;
        end
        
        icon:Set(itemCls.Icon, 'None', itemID, itemCount, 0, itemCount);
        SET_SLOT_COUNT_TEXT(icon, itemCount);
        SET_ITEM_TOOLTIP_BY_TYPE(icon, itemID);
    end
end

local function _INIT_ALCHEMY_WORKSHOP(frame)
    local etc = GetMyEtcObject();
    local combustionItemID = etc.AlcheWorkshopItemID_Combustion;
    local sprinkleHPItemID = etc.AlcheWorkshopItemID_SprinkleHP;
    local sprinkleSPItemID = etc.AlcheWorkshopItemID_SprinkleSP;
    frame:SetUserValue('SAVED_ID_COMBUSTION', combustionItemID);
    frame:SetUserValue('SAVED_ID_SPRINKLE_HP', sprinkleHPItemID);
    frame:SetUserValue('SAVED_ID_SPRINKLE_SP', sprinkleSPItemID);

    _SET_ALCHEMY_WORKSHOP_SLOT(frame, 'combSlot', combustionItemID);
    _SET_ALCHEMY_WORKSHOP_SLOT(frame, 'hpSlot', sprinkleHPItemID);
    _SET_ALCHEMY_WORKSHOP_SLOT(frame, 'spSlot', sprinkleSPItemID);
end

local function _GET_ALCHEMY_WORKSHOP_SLOT_ID(frame, slotName)
    local slot = GET_CHILD_RECURSIVELY(frame, slotName);
    local icon = slot:GetIcon();
    if icon == nil then
        return 0;
    end

    local iconinfo = icon:GetInfo();
    if iconinfo == nil then
        return 0;
    end
    return iconinfo.type;
end

local function _REQ_SAVE_ALCHEMY_WORKSHOP(frame)
    local savedID_Combustion = frame:GetUserIValue('SAVED_ID_COMBUSTION');
    local savedID_SprinkleHP = frame:GetUserIValue('SAVED_ID_SPRINKLE_HP');
    local savedID_SprinkleSP = frame:GetUserIValue('SAVED_ID_SPRINKLE_SP');
    local curID_Combustion = _GET_ALCHEMY_WORKSHOP_SLOT_ID(frame, 'combSlot');
    local curID_SprinkleHP = _GET_ALCHEMY_WORKSHOP_SLOT_ID(frame, 'hpSlot');
    local curID_SprinkleSP = _GET_ALCHEMY_WORKSHOP_SLOT_ID(frame, 'spSlot');

    if savedID_Combustion == curID_Combustion and savedID_SprinkleHP == curID_SprinkleHP and savedID_SprinkleSP == curID_SprinkleSP then
        return;
    end

    control.CustomCommand('ALCHEMY_WORKSHOP', curID_Combustion, curID_SprinkleHP, curID_SprinkleSP);
end

function ALCHEMY_WORKSHOP_REGISTER(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return ;
	end
	
	if iconInfo == nil or invItem == nil then
		return nil;
    end
    _SET_ALCHEMY_WORKSHOP_SLOT(frame, ctrl:GetName(), invItem.type);
end

function ALCHEMY_WORKSHOP_UNREGISTER(parent, ctrl)
    ctrl:ClearIcon();
end

function OPEN_ALCHEMY_WORKSHOP(frame)
    _INIT_ALCHEMY_WORKSHOP(frame);
    ui.OpenFrame('inventory');
end

function CLOSE_ALCHEMY_WORKSHOP(frame)
    _REQ_SAVE_ALCHEMY_WORKSHOP(frame);
    ui.CloseFrame('inventory');    
end