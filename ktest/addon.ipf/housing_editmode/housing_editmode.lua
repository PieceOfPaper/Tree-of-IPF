function HOUSING_EDITMODE_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'RESET_HOUSING_EDITMODE');
	addon:RegisterMsg('PERSONAL_HOUSING_BUY_BACKGROUND', 'RESET_HOUSING_EDITMODE_CHANGE_BACKGROUND');

	addon:RegisterMsg('PERSONAL_HOUSING_IS_REALLY_ENTER', 'SCR_PERSONAL_HOUSING_IS_REALLY_ENTER');
	addon:RegisterMsg('PERSONAL_HOUSING_IS_REALLY_ENTER_PARTY', 'SCR_PERSONAL_HOUSING_IS_REALLY_ENTER_PARTY');
end

function SCR_PERSONAL_HOUSING_IS_REALLY_ENTER(frame, msg, argstr, argnum)
    local clmsg = ScpArgMsg("ANSWER_JOIN_PH_1");
	local yesscp = string.format("ON_PERSONAL_HOUSING_IS_REALLY_ENTER(%d)", argnum);
	ui.MsgBox(clmsg, yesscp, 'None');
end


function SCR_PERSONAL_HOUSING_IS_REALLY_ENTER_PARTY(frame, msg, argstr, argnum)
    local clmsg = ScpArgMsg("ANSWER_JOIN_PH_2");
	local yesscp = string.format("ON_PERSONAL_HOUSING_IS_REALLY_ENTER(%d)", argnum);
	ui.MsgBox(clmsg, yesscp, 'None');
end

function ON_PERSONAL_HOUSING_IS_REALLY_ENTER(key)
    control.CustomCommand('ASWER_PERSONAL_HOUSING_ENTER', key);
end

function RESET_HOUSING_EDITMODE()
	ui.SetEscapeScp("");
end

function ON_HOUSING_EDITMODE_OPEN(isGuild)
	if isGuild == true then
		session.party.ReqGuildAsset();
	end
	housing.OpenEditMode();
end

function ON_HOUSING_EDITMODE_CLOSE()
	housing.CloseEditMode();
end

function ON_HOUSING_EDITMODE_FURNITURE_MOVE(handle)
	local className = housing.GetFurnitureClassName(handle);
	if className == "None" then
		return;
	end

	if className == "h_field" then
		local clmsg = ScpArgMsg("Housing_Really_Remove_Field_Exists_Object_On_Field{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Move"));
		local yesscp = string.format("_ON_HOUSING_EDITMODE_FURNITURE_MOVE(%d)", handle);
		ui.MsgBox(clmsg, yesscp, 'None');
	else
		_ON_HOUSING_EDITMODE_FURNITURE_MOVE(handle);
	end
end

function _ON_HOUSING_EDITMODE_FURNITURE_MOVE(handle)
	housing.MoveFurniture(handle);
end

function OPEN_HOUSING_EDITMODE()
	ui.OpenFrame("housing_editmode");
	ui.SetEscapeScp("ON_HOUSING_EDITMODE_CLOSE()");

	if IsJoyStickMode() == 1 then
		ui.SysMsg(ClMsg("Housing_Restricted_To_Use_When_Using_Joypad"));
	end

	local minimized_personal_housing = ui.GetFrame("minimized_personal_housing");
	if minimized_personal_housing ~= nil then
		minimized_personal_housing:ShowWindow(0);
	end
	
	local frame = ui.GetFrame("housing_editmode");
	local gbox_remove_list = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list");
	local gbox_remove_list_detail = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list_detail");
    gbox_remove_list_detail:RemoveAllChild();
	gbox_remove_list:ShowWindow(0);

	HOUSING_EDITMODE_CONTROL_IMAGE_SET(true, true);
	
	ui.CloseFrame("questinfoset_2");
	
	local option = IsEnabledOption("HousingPromoteLock");
	if option == 0 then
		local gbox_editmode = GET_CHILD_RECURSIVELY(frame, "gbox_editmode");
		gbox_editmode:Resize(280, 315);		

		local btn_promote = GET_CHILD_RECURSIVELY(frame, "btn_promote");
		btn_promote:ShowWindow(1);		
	else
		local gbox_editmode = GET_CHILD_RECURSIVELY(frame, "gbox_editmode");
		gbox_editmode:Resize(280, 260);

		local btn_promote = GET_CHILD_RECURSIVELY(frame, "btn_promote");
		btn_promote:ShowWindow(0);		
    end
end

function HOUSING_EDITMODE_CONTROL_IMAGE_SET(isOpen, isMoveRemove)
	if isOpen == true then
		ui.OpenFrame("housing_editmode_control");
		local frame = ui.GetFrame("housing_editmode_control");
		local txt_editmode_control_left_click = GET_CHILD_RECURSIVELY(frame, "txt_editmode_control_left_click");
		local txt_editmode_control_right_click = GET_CHILD_RECURSIVELY(frame, "txt_editmode_control_right_click");

		if isMoveRemove == true then
			txt_editmode_control_left_click:SetTextByKey("value", ClMsg("Housing_Context_Furniture_Move"));
			txt_editmode_control_right_click:SetTextByKey("value", ClMsg("Housing_Context_Furniture_Remove"));
		else
			txt_editmode_control_left_click:SetTextByKey("value", ClMsg("Housing_Control_Text_Build"));
			txt_editmode_control_right_click:SetTextByKey("value", ClMsg("Housing_Control_Text_Rotate"));
		end
	
		frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
		frame:RunUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE", 0.001);
	else
		local frame = ui.GetFrame("housing_editmode_control");
		frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
		ui.CloseFrame("housing_editmode_control");
	end
end

function SCR_OPEN_HOUSING_EDITMODE(frame)
	local currentMapName = session.GetMapName();
	local housingPlaceClass = GetClass("Housing_Place", currentMapName);
	if housingPlaceClass == nil then
		return;
	end
	
	local gbox_editmode = GET_CHILD_RECURSIVELY(frame, "gbox_editmode");
	local btn_change_background = GET_CHILD_RECURSIVELY(frame, "btn_change_background");
	local btn_page_load = GET_CHILD_RECURSIVELY(frame, "btn_page_load");
	local btn_shop = GET_CHILD_RECURSIVELY(frame, "btn_shop");

	local type = TryGetProp(housingPlaceClass, "Type");
	if type == "Personal" then
		btn_change_background:SetEnable(1);
		btn_shop:ShowWindow(1);
	else
		btn_change_background:SetEnable(0);
		btn_shop:ShowWindow(0);
	end
	
	local txt_editmode_floor = GET_CHILD_RECURSIVELY(frame, "txt_editmode_floor");
	txt_editmode_floor:SetTextByKey("value", "1");
end

function CLOSE_HOUSING_EDITMODE()
	ui.CloseFrame("housing_editmode");
	ui.CloseFrame("housing_editmode_page");
	ui.CloseFrame("housing_editmode_page_change");
	ui.CloseFrame("housing_editmode_background_change");
	ui.SetEscapeScp("");

	HOUSING_EDITMODE_CONTROL_IMAGE_SET(false);
	
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);

	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		return
	end

	local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
	if housingPlaceType == "Personal" then
		local minimized_personal_housing = ui.GetFrame("minimized_personal_housing");
		if minimized_personal_housing ~= nil then
			minimized_personal_housing:ShowWindow(1);
		end
	end
end

function START_ARRANGING_MOVING_FURNITURE()
	HOUSING_EDITMODE_CONTROL_IMAGE_SET(true, false);
	ui.SetEscapeScp("CANCEL_ARRANGING_MOVING_FURNITURE()");
end

function CANCEL_ARRANGING_MOVING_FURNITURE()
	housing.CancelArrangingMovingMove();
	local frame = ui.GetFrame("housing_editmode");
	frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
	HOUSING_EDITMODE_CONTROL_IMAGE_SET(true, true);
	ui.SetEscapeScp("ON_HOUSING_EDITMODE_CLOSE()");
end

function END_ARRANGING_MOVING_FURNITURE()
	local frame = ui.GetFrame("housing_editmode");
	frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
	HOUSING_EDITMODE_CONTROL_IMAGE_SET(true, true);
	ui.SetEscapeScp("ON_HOUSING_EDITMODE_CLOSE()");
end

function SET_HOUSING_EDITMODE_FLOOR(floor)
	if floor == nil then
		floor = 1;
	end

	local frame = ui.GetFrame("housing_editmode");
	local txt_editmode_floor = GET_CHILD_RECURSIVELY(frame, "txt_editmode_floor");
	txt_editmode_floor:SetTextByKey("value", tostring(floor));
end

function SET_HOUSING_EDITMODE_SELECTED_FURNITURE_NAME(name)
	if name == nil then
		name = "";
	end

	local frame = ui.GetFrame("housing_editmode");
	local txt_editmode_selected_furniture = GET_CHILD_RECURSIVELY(frame, "txt_editmode_selected_furniture");
	txt_editmode_selected_furniture:SetTextByKey("value", name);
end

function HOUSING_EDITMODE_REMOVE_ALL_FURNITURE()
	local allDemolitionPrice = 0;

	local arrangedFurnitureCount = housing.GetFurnitureCount(0);
	for i = 0, arrangedFurnitureCount - 1 do
		local arrangedFurntiureName = housing.GetFurnitureName(0, i);
		local furnitureClass = GetClass("Housing_Furniture", arrangedFurntiureName);
		local demolitionPrice = TryGetProp(furnitureClass, "DemolitionPrice");
		allDemolitionPrice = allDemolitionPrice + demolitionPrice;
	end
	
	DO_HOUSING_EDITMODE_REMOVE_OPEN(ClMsg("Housing_All_Furniture"), allDemolitionPrice, "AllRemove");
end

function SCR_OPEN_HOUSING_EDITMODE_PAGE(gbox, btn)
	local pageFrame = ui.GetFrame("housing_editmode_page");
	if pageFrame == nil then
		return;
	end

	if pageFrame:IsVisible() == 0 then
		ui.OpenFrame("housing_editmode_page");
	else
		ui.CloseFrame("housing_editmode_page");
	end
end

function SCR_OPEN_HOUSING_EDITMODE_CHANGE_BACKGROUND(gbox, btn)
	local pageFrame = ui.GetFrame("housing_editmode_background_change");
	if pageFrame == nil then
		return;
	end
	
	if pageFrame:IsVisible() == 0 then
		ui.OpenFrame("housing_editmode_background_change");
	else
		ui.CloseFrame("housing_editmode_background_change");
	end
end

function SCR_OPEN_HOUSING_EDITMODE_PAGE_SHOP(gbox, btn)
	local shopFrame = ui.GetFrame("shop");
	if shopFrame:IsVisible() == 0 then
		control.CustomCommand('REQ_PERSONAL_HOUSING_PAGE_SHOP', 0);
	else
		local shopFrame = ui.GetFrame("shop");
		SHOP_ON_MSG(shopFrame, "DIALOG_CLOSE", "Personal_Housing", 0)
	end
end

function SCR_OPEN_HOUSING_EDITMODE_TILE(gbox, btn)
	local shopFrame = ui.GetFrame("shop");
	if shopFrame:IsVisible() == 0 then
		control.CustomCommand('REQ_PERSONAL_HOUSING_PAGE_SHOP', 0);
	else
		local shopFrame = ui.GetFrame("shop");
		SHOP_ON_MSG(shopFrame, "DIALOG_CLOSE", "Personal_Housing", 0)
	end
end

function SCR_HOUSING_EDITMODE_ADD_REMOVE_FURNITURE(handle)
	local className = housing.GetFurnitureClassName(handle);
	if className == "None" then
		return;
	end

	if className == "h_field" then
		local clmsg = ScpArgMsg("Housing_Really_Remove_Field_Exists_Object_On_Field{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Remove"));
		local yesscp = string.format("housing.AddRemoveList(%d)", handle);
		ui.MsgBox(clmsg, yesscp, 'None');
	elseif housing.IsWallFurniture(handle) == true then
		local clmsg = ScpArgMsg("Housing_Really_Remove_Wall_Furniture{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Remove"));
		local yesscp = string.format("housing.AddRemoveList(%d)", handle);
		ui.MsgBox(clmsg, yesscp, 'None');
	else
		housing.AddRemoveList(handle);
	end
end

function ON_HOUSING_EDITMODE_ADD_REMOVE_FURNITURE(handle)
	local className = housing.GetFurnitureClassName(handle);
	if className == "None" then
		return;
	end

	local frame = ui.GetFrame("housing_editmode");
	local gbox_remove_list = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list");
	local gbox_remove_list_detail = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list_detail");

	local ctrlSet = GET_CHILD_RECURSIVELY(gbox_remove_list_detail, "HOUSING_REMOVE_SLOT_" .. handle);
	if ctrlSet ~= nil then
		gbox_remove_list_detail:RemoveChild("HOUSING_REMOVE_SLOT_" .. handle);
		
		local slotCount = 0;
		local childCount = gbox_remove_list_detail:GetChildCount();
		for i = 0, childCount - 1 do
			local removeSlot = gbox_remove_list_detail:GetChildByIndex(i);
			if string.match(removeSlot:GetName(), "HOUSING_REMOVE_SLOT_") then
				slotCount = slotCount + 1;
			end
		end

		if slotCount == 0 then
			gbox_remove_list:ShowWindow(0);
		end
	else
		local slotCount = 0;
		local childCount = gbox_remove_list_detail:GetChildCount();
		for i = 0, childCount - 1 do
			local removeSlot = gbox_remove_list_detail:GetChildByIndex(i);
			if string.match(removeSlot:GetName(), "HOUSING_REMOVE_SLOT_") then
				slotCount = slotCount + 1;
			end
		end
		
		if slotCount == 0 then
			gbox_remove_list:ShowWindow(1);
		end

		local housingClass = GetClass("Housing_Furniture", className);
		local itemClassName = TryGetProp(housingClass, "ItemClassName", "None");
	
		local itemClass = GetClass("Item", itemClassName);

		ctrlSet = gbox_remove_list_detail:CreateControlSet("housing_remove_furniture_slot", "HOUSING_REMOVE_SLOT_" .. handle, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		ctrlSet:SetUserValue("Furniture_Handle", tostring(handle));

		local item_image = GET_CHILD_RECURSIVELY(ctrlSet, "item_image");
		item_image:SetImage(GET_ITEM_ICON_IMAGE(itemClass));

		local text_item = GET_CHILD_RECURSIVELY(ctrlSet, "text_item");
		text_item:SetTextByKey("name", TryGetProp(itemClass, "Name", "None"));
		text_item:EnableSlideShow(1);
		text_item:EnableSlideInterval(true);
		text_item:SetSlideWaitTime(3);
	end

	GBOX_AUTO_ALIGN(gbox_remove_list_detail, 0, 0, 0, true, false);
end

function SCR_HOUSING_EDITMODE_CLEAR_REMOVE_LIST()
	local frame = ui.GetFrame("housing_editmode");
	local gbox_remove_list = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list");
	local gbox_remove_list_detail = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list_detail");
    gbox_remove_list_detail:RemoveAllChild();
	gbox_remove_list:ShowWindow(0);
	
	housing.ClearRemoveList();
end

function SCR_HOUSING_EDITMODE_DO_REMOVE()
	local frame = ui.GetFrame("housing_editmode");
	local gbox_remove_list = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list");
	local gbox_remove_list_detail = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list_detail");
	
	local currentMapName = session.GetMapName();
	local housingPlaceClass = GetClass("Housing_Place", currentMapName);
	if housingPlaceClass == nil then
		return;
	end
	
	local type = TryGetProp(housingPlaceClass, "Type");
	if type == "Personal" then
		local removeFurnitureCount = 0;
		local childCount = gbox_remove_list_detail:GetChildCount();
		for i = 0, childCount - 1 do
			local removeSlot = gbox_remove_list_detail:GetChildByIndex(i);
			local handle = removeSlot:GetUserIValue("Furniture_Handle");
			if handle ~= 0 then
				removeFurnitureCount = removeFurnitureCount + 1;
			end
		end

		local clmsg = ScpArgMsg("Housing_Remove_Furniture_Count", "Count", removeFurnitureCount);
		DO_HOUSING_EDITMODE_REMOVE_OPEN(clmsg, 0, "RemoveList");
	else
		local totalDemolitionPrice = 0;
		local removeFurnitureCount = 0;

		local childCount = gbox_remove_list_detail:GetChildCount();
		for i = 0, childCount - 1 do
			local removeSlot = gbox_remove_list_detail:GetChildByIndex(i);
			local handle = removeSlot:GetUserIValue("Furniture_Handle");
			if handle ~= 0 then
				removeFurnitureCount = removeFurnitureCount + 1;

				local className = housing.GetFurnitureClassName(handle);
				if className ~= "None" then
					local furnitureClass = GetClass("Housing_Furniture", className);
					if furnitureClass ~= nil then
						totalDemolitionPrice = totalDemolitionPrice + TryGetProp(furnitureClass, "DemolitionPrice", 0);
					end
				end
			end
		end

		HOUSING_EDITMODE_REMOVE_OPEN_GUILD(totalDemolitionPrice, removeFurnitureCount);
	end
end

function REQUEST_HOUSING_PROMOTE_BOARD_OPEN_EDITMODE(frame)
    local boardframe = ui.GetFrame("housing_promote_board");
	if boardframe:IsVisible() == 1 then
		return;
	end
	
    HOUSING_PROMOTE_BOARD_OPEN();

    local btn_promote = GET_CHILD_RECURSIVELY(frame, "btn_promote");
    btn_promote:SetEnable(0);

    ReserveScript("RESET_HOUSING_PROMOTE_BOARD_OPEN_EDITMODE()", 5);
end

function RESET_HOUSING_PROMOTE_BOARD_OPEN_EDITMODE()
    local frame = ui.GetFrame("housing_editmode");
    
    local btn_promote = GET_CHILD_RECURSIVELY(frame, "btn_promote");
    btn_promote:SetEnable(1);
end