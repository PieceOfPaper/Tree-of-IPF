function HOUSING_EDIT_MODE_REMOVE_OPEN(handle)
    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
	session.party.ReqGuildAsset();
	
	RunScript("_HOUSING_EDIT_MODE_REMOVE_OPEN", handle);
end

function _HOUSING_EDIT_MODE_REMOVE_OPEN(handle)
	sleep(500);

	local actor = world.GetActor(handle);
	if actor == nil then
		return;
	end

	if GetProperty(handle) == nil then
		return;
	end

	local name = actor:GetName();
	local className = GetProperty(handle).ClassName;

	local furnitureClass = GetClass("Housing_Furniture", className);
	local demolitionPrice = TryGetProp(furnitureClass, "DemolitionPrice", 0);

    local guild = session.party.GetPartyInfo(PARTY_GUILD);

	ui.OpenFrame("housing_editmode_remove");
	local frame = ui.GetFrame("housing_editmode_remove");

	local txt_furniture_name = GET_CHILD_RECURSIVELY(frame, "txt_furniture_name");
	txt_furniture_name:SetTextByKey("name", actor:GetName());

	local txt_has_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_has_guild_money");
	txt_has_guild_money:SetTextByKey("money", GET_COMMAED_STRING(guild.info:GetAssetAmount()));
	
	local txt_need_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_need_guild_money");
	txt_need_guild_money:SetTextByKey("money", GET_COMMAED_STRING(demolitionPrice));

	local btn_yes = GET_CHILD_RECURSIVELY(frame, "btn_yes");
	btn_yes:SetUserValue("Handle", tostring(handle));
end

function BTN_HOUSING_EDITMODE_REMOVE_YES(gbox, btn)
	local handle = btn:GetUserValue("Handle");
	if handle ~= nil and handle ~= "None" then
		housing.RemoveFurniture(tostring(handle));
	end

	ui.CloseFrame("housing_editmode_remove");
end

function BTN_HOUSING_EDITMODE_REMOVE_NO()
	ui.CloseFrame("housing_editmode_remove");
end