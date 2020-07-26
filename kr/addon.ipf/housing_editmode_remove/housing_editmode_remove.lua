function HOUSING_EDITMODE_REMOVE_OPEN_GUILD(totalDemolitionPrice, removeFurnitureCount)
    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
	session.party.ReqGuildAsset();
	
	local frame = ui.GetFrame("housing_editmode");
	frame:SetUserValue("FURNITURE_DEMOLITION_PRICE", tostring(totalDemolitionPrice));
	frame:SetUserValue("REMOVE_FURNITURE_COUNT", tostring(removeFurnitureCount));
	AddLuaTimerFunc("_HOUSING_EDITMODE_REMOVE_OPEN_GUILD_CALLBACK", 500, 0);
end

function _HOUSING_EDITMODE_REMOVE_OPEN_GUILD_CALLBACK()
	local frame = ui.GetFrame("housing_editmode");
	local totalDemolitionPrice = tonumber(frame:GetUserValue("FURNITURE_DEMOLITION_PRICE"));
	local removeFurnitureCount = tonumber(frame:GetUserValue("REMOVE_FURNITURE_COUNT"));
	
	local clmsg = ScpArgMsg("Housing_Remove_Furniture_Count", "Count", removeFurnitureCount);
	DO_HOUSING_EDITMODE_REMOVE_OPEN(clmsg, totalDemolitionPrice, "RemoveList");
end

function DO_HOUSING_EDITMODE_REMOVE_OPEN(name, demolitionPrice, removeType, value)
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
	btn_yes:SetUserValue("RemoveType", removeType);
end

function BTN_HOUSING_EDITMODE_REMOVE_YES(gbox, btn)
	local type = btn:GetUserValue("RemoveType");
	if type == "AllRemove" then
		housing.RemoveAllFurniture();
	elseif type == "RemoveList" then
		local frame = ui.GetFrame("housing_editmode");
		local gbox_remove_list = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list");
		local gbox_remove_list_detail = GET_CHILD_RECURSIVELY(frame, "gbox_remove_list_detail");
	
		gbox_remove_list_detail:RemoveAllChild();
		gbox_remove_list:ShowWindow(0);

		housing.DoRemoveList();
	end

	ui.CloseFrame("housing_editmode_remove");
end

function BTN_HOUSING_EDITMODE_REMOVE_NO()
	ui.CloseFrame("housing_editmode_remove");
end

function PERSONAL_HOUSING_EDITMODE_REMOVE_YES(handle)
	housing.RemoveFurniture(handle);
end