function POISONPOT_HUD_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'POISONPOT_HUD_UPDATE_POISON_AMOUNT');
	addon:RegisterOpenOnlyMsg('GAME_START', 'POISONPOT_HUD_CHECK_VISIBLE');
	addon:RegisterMsg("MSG_UPDATE_POISONPOT_UI", "POISONPOT_HUD_UPDATE_POISON_AMOUNT");
	addon:RegisterMsg("DO_OPEN_POISONPOT_UI", "POISONPOT_HUD_UPDATE_POISON_AMOUNT");
	addon:RegisterMsg('GAME_START', 'POISONPOT_HUD_ZONE_ENTER_HANDLER');
    addon:RegisterMsg('JOB_CHANGE', 'POISONPOT_HUD_ZONE_ENTER_HANDLER');
    addon:RegisterMsg('CHANGE_RESOLUTION', 'POISONPOT_HUD_SET_SAVED_OFFSET');
end

function POISONPOT_HUD_UPDATE_POISON_AMOUNT(frame, msg, argStr, argNum)
    if POISONPOT_HUD_CHECK_VISIBLE() == false then
        return;
    end

    local etc = GetMyEtcObject();
    if etc == nil then
        return;
    end
	local poisonAmount = etc.Wugushi_PoisonAmount;
	local poisonMaxAmount = etc.Wugushi_PoisonMaxAmount;
	local poisonAmountGauge = GET_CHILD_RECURSIVELY(frame,'poisonGauge');
	poisonAmountGauge:SetPoint(poisonAmount, poisonMaxAmount);
end

function POISONPOT_HUD_CHECK_VISIBLE()
    local frame = ui.GetFrame('poisonpot_hud');
    if ui.CanOpenFrame('poisonpot_hud') == 1 then
        frame:ShowWindow(1);
    else
        frame:ShowWindow(0);
        return false;
    end
    return true;
end

function POISONPOT_HUD_CHECK_OPEN(propName, propValue)
    if ui.CanOpenFrame('poisonpot') == 0 then
        return 0;
    end    
    local configValue = config.GetXMLConfig('PoisonPotHUD');
    if configValue == 0 then
        return 0;
    end
    return 1;
end

function POISONPOT_HUD_LBTN_UP(frame, msg, argStr, argNum)    
    if POISONPOT_HUD_CHECK_VISIBLE() == false then
        return;
    end
    SET_CONFIG_HUD_OFFSET(frame);
end

function POISONPOT_HUD_SET_SAVED_OFFSET(frame, msg, argStr, argNum)
    if POISONPOT_HUD_CHECK_VISIBLE() == false then
        return;
    end
    local savedX, savedY = GET_CONFIG_HUD_OFFSET(frame, frame:GetOriginalX(), frame:GetOriginalY());
    savedX, savedY = GET_OFFSET_IN_SCREEN(savedX, savedY, frame:GetWidth(), frame:GetHeight());
    frame:SetOffset(savedX, savedY);
end

function POISONPOT_HUD_ZONE_ENTER_HANDLER(frame, msg, argStr, argNum)
    POISONPOT_HUD_SET_SAVED_OFFSET(frame, msg, argStr, argNum);
    POISONPOT_HUD_UPDATE_POISON_AMOUNT(frame, msg, argStr, argNum);
end