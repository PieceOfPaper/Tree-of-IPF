function NECRONOMICON_HUD_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('GAME_START', 'NECRONOMICON_HUD_ZONE_ENTER_HANDLER');
	addon:RegisterOpenOnlyMsg("UPDATE_NECRONOMICON_UI", "NECRONOMICON_HUD_UPDATE_AMOUNT");
    addon:RegisterMsg('JOB_CHANGE', 'NECRONOMICON_HUD_ZONE_ENTER_HANDLER');
    addon:RegisterMsg('CHANGE_RESOLUTION', 'NECRONOMICON_HUD_SET_SAVED_OFFSET');
end

function NECRONOMICON_HUD_CHECK_OPEN(propName, propValue)
    if ui.CanOpenFrame('necronomicon') == 0 then
        return 0;
    end
    local configValue = config.GetXMLConfig('NecronomiconHUD');
    if configValue == 0 then
        return 0;
    end
    return 1;
end

function NECRONOMICON_HUD_CHECK_VISIBLE()
    local frame = ui.GetFrame('necronomicon_hud');
    if ui.CanOpenFrame('necronomicon_hud') == 1 then
        frame:ShowWindow(1);
    else
        frame:ShowWindow(0);
        return false;
    end
    return true;
end

function NECRONOMICON_HUD_UPDATE_AMOUNT(frame, msg, argStr, argNum)
    if NECRONOMICON_HUD_CHECK_VISIBLE() == false then
        return;
    end

    local etc = GetMyEtcObject();
    if etc == nil then
        return;
    end

	local deadPartsCnt = etc.Necro_DeadPartsCnt;
	local totalCount = GET_NECRONOMICON_TOTAL_COUNT();	
	local part_gauge = GET_CHILD_RECURSIVELY(frame, 'necroGauge');
	part_gauge:SetPoint(deadPartsCnt, totalCount);
end

function GET_NECRONOMICON_TOTAL_COUNT()
    local totalCount = 300;	
	local abil = session.GetAbilityByName("Necromancer21")
	if abil ~= nil then
	    local abilObj = GetIES(abil:GetObject());
	    totalCount = totalCount + abilObj.Level * 100
	end
    return totalCount;
end

function NECRONOMICON_HUD_LBTN_UP(frame, msg, argStr, argNum)    
    if NECRONOMICON_HUD_CHECK_VISIBLE() == false then
        return;
    end
    SET_CONFIG_HUD_OFFSET(frame);
end

function NECRONOMICON_HUD_SET_SAVED_OFFSET(frame, msg, argStr, argNum)
    if NECRONOMICON_HUD_CHECK_VISIBLE() == false then
        return;
    end
    local savedX, savedY = GET_CONFIG_HUD_OFFSET(frame, frame:GetOriginalX(), frame:GetOriginalY());          
    savedX, savedY = GET_OFFSET_IN_SCREEN(savedX, savedY, frame:GetWidth(), frame:GetHeight());    
    frame:SetOffset(savedX, savedY);
end

function NECRONOMICON_HUD_ZONE_ENTER_HANDLER(frame, msg, argStr, argNum)
    NECRONOMICON_HUD_SET_SAVED_OFFSET(frame, msg, argStr, argNum);
    NECRONOMICON_HUD_UPDATE_AMOUNT(frame, msg, argStr, argNum);
end