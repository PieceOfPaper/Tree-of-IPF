function MINIMIZED_PVPMINE_SHOP_BUTTON_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_PVPMINE_SHOP_BUTTON_OPEN_CHECK');
end

function MINIMIZED_PVPMINE_SHOP_BUTTON_OPEN_CHECK(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
    if IS_BEAUTYSHOP_MAP(mapCls) == false then
        frame:ShowWindow(0);
    else
    	frame:ShowWindow(1);
    end
end

function MINIMIZED_PVPMINE_SHOP_BUTTON_CLICK(parent, ctrl)
	local frame = ui.GetFrame('earthtowershop')
	if frame ~= nil and frame:IsVisible() == 1 then
		return
	end
	pc.ReqExecuteTx_NumArgs("SCR_PVP_MINE_SHOP_OPEN", 0);
end