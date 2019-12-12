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

function ON_HOUSING_EDITMODE_FURNITURE_REMOVE(handle)
	local className = housing.GetFurnitureClassName(handle);
	if className == "None" then
		return;
	end

	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);
	local housingPlace = GetClass("Housing_Place", nowZoneName);
	local housingType = TryGetProp(housingPlace, "Type");

	if housingType == "Guild" then
		if className == "h_field" then
			local clmsg = ScpArgMsg("Housing_Really_Remove_Field_Exists_Object_On_Field{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Remove"));
			local yesscp = string.format("HOUSING_EDIT_MODE_REMOVE_OPEN(%d)", handle);
			ui.MsgBox(clmsg, yesscp, 'None');
		elseif housing.IsWallFurniture(handle) == true then
			local clmsg = ScpArgMsg("Housing_Really_Remove_Wall_Furniture{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Remove"));
			local yesscp = string.format("HOUSING_EDIT_MODE_REMOVE_OPEN(%d)", handle);
			ui.MsgBox(clmsg, yesscp, 'None');
		else
			HOUSING_EDIT_MODE_REMOVE_OPEN(handle);
		end
	elseif housingType == "Personal" then
		local yesscp = string.format("PERSONAL_HOUSING_EDITMODE_REMOVE_YES(%d)", handle);
		ui.MsgBox(ClMsg("ReallyRemove?"), yesscp, "None");
	end
end

function _ON_HOUSING_EDITMODE_FURNITURE_REMOVE(handle)
	housing.RemoveFurniture(handle);
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

	local type = TryGetProp(housingPlaceClass, "Type");
	if type == "Personal" then
		btn_change_background:ShowWindow(1);
		btn_page_load:ShowWindow(1);
		
		gbox_editmode:Resize(280, 260);
		btn_change_background:SetMargin(-67, 195, 7, 0);
		btn_page_load:SetMargin(67, 195, 7, 0);
	else
		btn_change_background:ShowWindow(0);
		btn_page_load:ShowWindow(0);
		
		gbox_editmode:Resize(280, 200);
		btn_change_background:SetMargin(0, 0, 0, 0);
		btn_page_load:SetMargin(0, 0, 0, 0);
	end
end

function CLOSE_HOUSING_EDITMODE()
	ui.CloseFrame("housing_editmode");
	ui.CloseFrame("housing_editmode_page");
	ui.CloseFrame("housing_editmode_control");
	ui.CloseFrame("housing_editmode_page_change");
	ui.CloseFrame("housing_editmode_background_chagne");
	ui.SetEscapeScp("");
	
	local minimized_personal_housing = ui.GetFrame("minimized_personal_housing");
	if minimized_personal_housing ~= nil then
		minimized_personal_housing:ShowWindow(1);
	end
end

function START_ARRANGING_MOVING_FURNITURE()
	ui.OpenFrame("housing_editmode_control");
	local frame = ui.GetFrame("housing_editmode_control");
	frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
	frame:RunUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE", 0.001);

	ui.SetEscapeScp("CANCEL_ARRANGING_MOVING_FURNITURE()");
end

function CANCEL_ARRANGING_MOVING_FURNITURE()
	housing.CancelArrangingMovingMove();
	local frame = ui.GetFrame("housing_editmode");
	frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
	ui.CloseFrame("housing_editmode_control");
	ui.SetEscapeScp("ON_HOUSING_EDITMODE_CLOSE()");
end

function END_ARRANGING_MOVING_FURNITURE()
	local frame = ui.GetFrame("housing_editmode");
	frame:StopUpdateScript("EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE");
	ui.CloseFrame("housing_editmode_control");
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
	
	DO_HOUSING_EDIT_MODE_REMOVE_OPEN(ClMsg("Housing_All_Furniture"), allDemolitionPrice, nil);
end

function SCR_OPEN_HOUSING_EDITMODE_PAGE(gbox, btn)
	local isOpen = btn:GetUserValue("IsOpen");
	if isOpen == "None" or isOpen == "false" then
		ui.OpenFrame("housing_editmode_page");
		btn:SetUserValue("IsOpen", "true");
	else
		ui.CloseFrame("housing_editmode_page");
		btn:SetUserValue("IsOpen", "false");
	end
end

function SCR_OPEN_HOUSING_EDITMODE_CHANGE_BACKGROUND(gbox, btn)
	local isOpen = btn:GetUserValue("IsOpen");
	if isOpen == "None" or isOpen == "false" then
		ui.OpenFrame("housing_editmode_background_chagne");
		btn:SetUserValue("IsOpen", "true");
	else
		ui.CloseFrame("housing_editmode_background_chagne");
		btn:SetUserValue("IsOpen", "false");
	end
end