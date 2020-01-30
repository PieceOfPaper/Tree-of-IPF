function MINIMIZED_GUILD_HOUSING_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('ENTER_GUILD_AGIT', 'MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('ENTER_PERSONAL_HOUSE', 'MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE');
end

function MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
	
	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		frame:ShowWindow(0);
		return
	end
	
	if argStr == "YES" then
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
end

function BTN_MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE(parent, btn)
	if housing.IsEditMode() == false then
		local mapprop = session.GetCurrentMapProp();
		local mapCls = GetClassByType("Map", mapprop.type);

		local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
		if housingPlaceClass == nil then
			return;
		end

		local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
		local isGuild = false;
		if housingPlaceType == "Guild" then
			isGuild = true;
		end
		ON_HOUSING_EDITMODE_OPEN(isGuild);

		btn:SetUserValue("Time", imcTime.GetAppTime() + 5);
	else
		housing.CancelArrangingMovingMove();
		ui.CloseFrame("housing_editmode_control");

		ON_HOUSING_EDITMODE_CLOSE();
		
		local time = tonumber(btn:GetUserValue("Time"));
		if time > imcTime.GetAppTime() then
			btn:SetEnable(0);
			AddLuaTimerFunc("RESET_MINIMIZED_GUILD_HOUSING_BUTTON", (time - imcTime.GetAppTime()) * 1000, 0);
		end
	end
end

function RESET_MINIMIZED_GUILD_HOUSING_BUTTON()
	local frame = ui.GetFrame("minimized_guild_housing");
	local button = GET_CHILD_RECURSIVELY(frame, "openGuildHousingEditMode");
	button:SetEnable(1);
end