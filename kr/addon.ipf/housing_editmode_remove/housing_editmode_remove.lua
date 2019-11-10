function HOUSING_EDIT_MODE_REMOVE_OPEN(handle)
    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
	session.party.ReqGuildAsset();
	
	local frame = ui.GetFrame("housing_editmode");
	frame:SetUserValue("FURNITURE_HANDLE", tostring(handle));
	AddLuaTimerFunc("_HOUSING_EDIT_MODE_REMOVE_OPEN_CALLBACK", 500, 0);
end

function _HOUSING_EDIT_MODE_REMOVE_OPEN_CALLBACK(handle)
	local frame = ui.GetFrame("housing_editmode");
	local handle = tonumber(frame:GetUserValue("FURNITURE_HANDLE"));
	
	local className = housing.GetFurnitureClassName(handle);
	if className == "None" then
		return;
	end

	local furnitureClass = GetClass("Housing_Furniture", className);
	if furnitureClass == nil then
		return;
	end
	
	local name = TryGetProp(furnitureClass, "Name");
	local demolitionPrice = TryGetProp(furnitureClass, "DemolitionPrice", 0);
	DO_HOUSING_EDIT_MODE_REMOVE_OPEN(name, demolitionPrice, handle);
end

function DO_HOUSING_EDIT_MODE_REMOVE_OPEN(name, demolitionPrice, handle)
    local guild = session.party.GetPartyInfo(PARTY_GUILD);
	
	local currentMapName = session.GetMapName();
	local housingPlaceClass = GetClass("Housing_Place", currentMapName);
	if housingPlaceClass == nil then
		return;
	end
	
	ui.OpenFrame("housing_editmode_remove");
	local frame = ui.GetFrame("housing_editmode_remove");
	
	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");

	local txt_has_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_has_guild_money");
	local txt_need_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_need_guild_money");
	local txt_memo = GET_CHILD_RECURSIVELY(frame, "txt_memo");

	local type = TryGetProp(housingPlaceClass, "Type");
	if type == "Personal" then
		frame:Resize(500, 295);
		gbox:Resize(478, 250);
		gbox:SetMargin(0, 30, 0, 0);

		txt_memo:SetMargin(0, 130, 0, 0);

		txt_has_guild_money:ShowWindow(0);
		txt_need_guild_money:ShowWindow(0);
	else
		frame:Resize(500, 375);
		gbox:Resize(478, 320);
		gbox:SetMargin(0, 42, 0, 0);
		
		txt_memo:SetMargin(0, 200, 0, 0);

		txt_has_guild_money:ShowWindow(1);
		txt_has_guild_money:SetTextByKey("money", GET_COMMAED_STRING(guild.info:GetAssetAmount()));
		
		txt_need_guild_money:ShowWindow(1);
		txt_need_guild_money:SetTextByKey("money", GET_COMMAED_STRING(demolitionPrice));
	end

	local txt_furniture_name = GET_CHILD_RECURSIVELY(frame, "txt_furniture_name");
	txt_furniture_name:SetTextByKey("name", name);

	local btn_yes = GET_CHILD_RECURSIVELY(frame, "btn_yes");
	if handle ~= nil then
		btn_yes:SetUserValue("Handle", tostring(handle));
	else
		btn_yes:SetUserValue("Handle", "AllRemove");
	end
end

function BTN_HOUSING_EDITMODE_REMOVE_YES(gbox, btn)
	local handle = btn:GetUserValue("Handle");
	if handle ~= nil and handle ~= "None" then
		if handle == "AllRemove" then
			housing.RemoveAllFurniture();
		else
			housing.RemoveFurniture(tostring(handle));
		end
	end

	ui.CloseFrame("housing_editmode_remove");
end

function BTN_HOUSING_EDITMODE_REMOVE_NO()
	ui.CloseFrame("housing_editmode_remove");
end

function PERSONAL_HOUSING_EDITMODE_REMOVE_YES(handle)
	housing.RemoveFurniture(handle);
end