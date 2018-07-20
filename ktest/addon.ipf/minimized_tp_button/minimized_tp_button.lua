function MINIMIZED_TP_BUTTON_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_TP_BUTTON_OPEN_CHECK');
end

function MINIMIZED_TP_BUTTON_OPEN_CHECK(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
    if IS_BEAUTYSHOP_MAP(mapCls) == false then
        frame:ShowWindow(0);
    else
    	frame:ShowWindow(1);
    end
end

function MINIMIZED_TP_BUTTON_CLICK(parent, ctrl)
	local tpitem = ui.GetFrame('tpitem');
	TP_SHOP_DO_OPEN(tpitem);
end