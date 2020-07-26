function MINIMIZED_HOUSING_PROMOTE_BOARD_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START", "MINIMIZED_HOUDING_PROMOTE_BOARD_BUTTON_OPEN_CHECK");
end

function MINIMIZED_HOUDING_PROMOTE_BOARD_BUTTON_OPEN_CHECK(frame)
	local mapprop = session.GetCurrentMapProp();
    local mapCls = GetClassByType("Map", mapprop.type);	
    
    if IS_TOWN_MAP(mapCls) == false then
        frame:ShowWindow(0);
    else
    	frame:ShowWindow(1);
    end
end

function REQUEST_HOUSING_PROMOTE_BOARD_OPEN(frame)
    local boardframe = ui.GetFrame("housing_promote_board");
	if boardframe:IsVisible() == 1 then
		return;
    end
    
    HOUSING_PROMOTE_BOARD_OPEN();

    local openBtn = GET_CHILD(frame, "openBtn");
    openBtn:SetEnable(0);

    ReserveScript("RESET_HOUSING_PROMOTE_BOARD_OPEN()", 5);
end

function RESET_HOUSING_PROMOTE_BOARD_OPEN()
    local frame = ui.GetFrame("minimized_housing_promote_board");

    local openBtn = GET_CHILD(frame, "openBtn");
    openBtn:SetEnable(1);
end