function HOUSING_EDITMODE_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'RESET_HOUSING_EDITMODE');
end

function RESET_HOUSING_EDITMODE()
	ui.SetEscapeScp("");
end

function ON_HOUSING_EDITMODE_OPEN()
    session.party.ReqGuildAsset();
	housing.OpenEditMode();
end

function ON_HOUSING_EDITMODE_CLOSE()
	housing.CloseEditMode();
end

function ON_HOUSING_EDITMODE_FURNITURE_MOVE(handle)
	if GetProperty(handle) == nil then
		return;
	end

	local className = GetProperty(handle).ClassName;
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
	if GetProperty(handle) == nil then
		return;
	end

	local className = GetProperty(handle).ClassName;
	if className == "h_field" then
		local clmsg = ScpArgMsg("Housing_Really_Remove_Field_Exists_Object_On_Field{WORD}", "WORD", ClMsg("Housing_Context_Furniture_Remove"));
		local yesscp = string.format("HOUSING_EDIT_MODE_REMOVE_OPEN(%d)", handle);
		ui.MsgBox(clmsg, yesscp, 'None');
	else
		HOUSING_EDIT_MODE_REMOVE_OPEN(handle);
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
end

function CLOSE_HOUSING_EDITMODE()
	ui.CloseFrame("housing_editmode");
	ui.CloseFrame("housing_editmode_control");
	ui.SetEscapeScp("");
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