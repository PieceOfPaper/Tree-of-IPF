function MINIMIZED_GUILD_HOUSING_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('ENTER_GUILD_AGIT', 'MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE');
end

function MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
	
	if mapCls.ClassName == "guild_agit_extension" then
	    if argStr == "YES" then
             frame:ShowWindow(1);
		else
		    frame:ShowWindow(0);
		end
	else
		frame:ShowWindow(0);
	end
end

function BTN_MINIMIZED_GUILD_HOUSING_OPEN_EDIT_MODE(parent, btn)
	if housing.IsEditMode() == false then
		ON_HOUSING_EDITMODE_OPEN();

		btn:SetUserValue("Time", imcTime.GetAppTime() + 5);
	else
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
