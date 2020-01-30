function OPEN_HOUSING_EDITMODE_PAGE(frame)
	session.party.ReqGuildAsset();

	local gbox_page = GET_CHILD_RECURSIVELY(frame, "gbox_page");
	gbox_page:RemoveAllChild();

	for i = 1, 3 do
		local ctrlSet = gbox_page:CreateControlSet("housing_page_slot", "HOUSING_PAGE_SLOT_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local text_page_num = GET_CHILD_RECURSIVELY(ctrlSet, "text_page_num");
		text_page_num:SetTextByKey("value", tostring(i));

		local btn_page_preview = GET_CHILD_RECURSIVELY(ctrlSet, "btn_page_preview");
		btn_page_preview:SetUserValue("PageIndex", i);
		
		local btn_page_save = GET_CHILD_RECURSIVELY(ctrlSet, "btn_page_save");
		btn_page_save:SetUserValue("PageIndex", i);
		
		local btn_page_load = GET_CHILD_RECURSIVELY(ctrlSet, "btn_page_load");
		btn_page_load:SetUserValue("PageIndex", i);
		
		local btn_page_delete = GET_CHILD_RECURSIVELY(ctrlSet, "btn_page_delete");
		btn_page_delete:SetUserValue("PageIndex", i);
		
		local isValid = housing.IsValidPage(i);
		local title = housing.GetPageTitle(i);
		
		local edit_page_title = GET_CHILD_RECURSIVELY(ctrlSet, "edit_page_title");

		edit_page_title:SetText(title);
		if isValid == false then
			edit_page_title:SetEnable(1);
		else
			edit_page_title:SetEnable(0);
		end
	end
	
    GBOX_AUTO_ALIGN(gbox_page, 5, 3, 10, true, false);
end

function CLOSE_HOUSING_EDITMODE_PAGE()
	housing.ClosePagePreview();
end

function BTN_CLOSE_HOUSING_EDITMODE_PAGE()
	ui.CloseFrame("housing_editmode_page");
end

function REFRESH_HOUSING_PAGE_INFO(pageIndex, title)
	local frame = ui.GetFrame("housing_editmode_page");
	local gbox_page = GET_CHILD_RECURSIVELY(frame, "HOUSING_PAGE_SLOT_" .. pageIndex);
	if gbox_page == nil then
		return;
	end
	
	local edit_page_title = GET_CHILD_RECURSIVELY(gbox_page, "edit_page_title");
	edit_page_title:SetText(title);
	
	local isValid = housing.IsValidPage(pageIndex);
	if isValid == false then
		edit_page_title:SetEnable(1);
	else
		edit_page_title:SetEnable(0);
		edit_page_title:ReleaseFocus();
	end
end

function BTN_HOUSING_EDITMODE_PAGE_PREVIEW(gbox, btn)
	local pageIndex = tonumber(btn:GetUserValue("PageIndex"));
	if pageIndex < 1 then
		return;
	end
	
	if housing.IsPagePreview(pageIndex) == true then
		housing.ClosePagePreview();
	else
		housing.PagePreview(pageIndex);
	end
end

function BTN_HOUSING_EDITMODE_PAGE_SAVE(gbox, btn)
	local pageIndex = tonumber(btn:GetUserValue("PageIndex"));
	if pageIndex < 1 then
		return;
	end
	
	local edit_page_title = GET_CHILD_RECURSIVELY(gbox, "edit_page_title");

	local isValid = housing.IsValidPage(pageIndex);
	if isValid == true then
		local clmsg = ScpArgMsg("Housing_Page_Really_Save{PAGE_NUMBER}", "PAGE_NUMBER", pageIndex);
		local yesscp = string.format("DO_HOUSING_EDITMODE_PAGE_SAVE(%d, '%s')", pageIndex, edit_page_title:GetText());
		ui.MsgBox(clmsg, yesscp, 'None');
	else
		DO_HOUSING_EDITMODE_PAGE_SAVE(pageIndex, edit_page_title:GetText());
	end
end

function DO_HOUSING_EDITMODE_PAGE_SAVE(pageIndex, title)
	housing.PageSave(pageIndex, title);
end

function BTN_HOUSING_EDITMODE_PAGE_LOAD(gbox, btn)
	local pageIndex = tonumber(btn:GetUserValue("PageIndex"));
	if pageIndex < 1 then
		return;
	end

	if housing.IsValidPage(pageIndex) == false then
		return;
	end

	local furnitureNameCount = {};

	local arrangedFurnitureCount = housing.GetFurnitureCount(0);
	for i = 0, arrangedFurnitureCount - 1 do
		local arrangedFurntiureName = housing.GetFurnitureName(0, i);
		if furnitureNameCount[arrangedFurntiureName] == nil then
			furnitureNameCount[arrangedFurntiureName] = 0;
		end
		furnitureNameCount[arrangedFurntiureName] = furnitureNameCount[arrangedFurntiureName] + 1;
	end
	
	local changeFurnitureCount = housing.GetFurnitureCount(pageIndex);
	for i = 0, changeFurnitureCount - 1 do
		local changeFurntiureName = housing.GetFurnitureName(pageIndex, i);
		if furnitureNameCount[changeFurntiureName] == nil then
			furnitureNameCount[changeFurntiureName] = 0;
		end
		furnitureNameCount[changeFurntiureName] = furnitureNameCount[changeFurntiureName] - 1;
	end

	local requiredFurnitureNameCount = {};
	local removeFurnitureNameCount = {};

	local requiredCount = 0;
	local removeCount = 0;

	for key, value in pairs(furnitureNameCount) do
		if value < 0 then
			local housingClass = GetClass("Housing_Furniture", key);
			local itemClassName = TryGetProp(housingClass, "ItemClassName", "None");

			local count = math.abs(value);

			local item = session.GetInvItemByName(itemClassName);
			if item == nil or count > tonumber(item:GetAmountStr()) then
				requiredFurnitureNameCount[key] = count;
				requiredCount = requiredCount + 1;
			end
		elseif value > 0 then
			removeFurnitureNameCount[key] = value;
			removeCount = removeCount + 1;
		end
	end
	
	if requiredCount > 0 then
		SCR_HOUSING_PAGE_LOAD_REQUIRED_FURNITURE(pageIndex, requiredFurnitureNameCount);
	elseif removeCount > 0 then
		SCR_HOUSING_PAGE_LOAD_REMOVE_FURNITURE(pageIndex, removeFurnitureNameCount);
	else
		local clmsg = ScpArgMsg("Housing_Page_Really_Load{PAGE_NUMBER}", "PAGE_NUMBER", pageIndex);
		local yesscp = string.format("housing.PageLoad(%d); ON_HOUSING_EDITMODE_CLOSE();", pageIndex);
		ui.MsgBox(clmsg, yesscp, 'None');
	end
end

function SCR_HOUSING_PAGE_LOAD_REQUIRED_FURNITURE(pageIndex, requiredFurnitureNameCount)
	ui.OpenFrame("housing_editmode_page_change");
	local frame = ui.GetFrame("housing_editmode_page_change");
	frame:SetUserValue("PageIndex", pageIndex);
	
	local gbox_required_furniture = GET_CHILD_RECURSIVELY(frame, "gbox_required_furniture");
	local gbox_remove_furniture = GET_CHILD_RECURSIVELY(frame, "gbox_remove_furniture");
	gbox_required_furniture:ShowWindow(1);
	gbox_remove_furniture:ShowWindow(0);

	local gbox_furniture_list = GET_CHILD_RECURSIVELY(gbox_required_furniture, "gbox_furniture_list");
	gbox_furniture_list:RemoveAllChild();
	
	for key, value in pairs(requiredFurnitureNameCount) do
		local housingClass = GetClass("Housing_Furniture", key);
		local itemClassName = TryGetProp(housingClass, "ItemClassName", "None");
	
		local itemClass = GetClass("Item", itemClassName);

		local ctrlSet = gbox_furniture_list:CreateControlSet("housing_page_chnage_remove_furniture_slot", "HOUSING_PAGE_SLOT_" .. key, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		
		local item_image = GET_CHILD_RECURSIVELY(ctrlSet, "item_image");
		item_image:SetImage(GET_ITEM_ICON_IMAGE(itemClass));

		local text_item = GET_CHILD_RECURSIVELY(ctrlSet, "text_item");
		text_item:SetTextByKey("name", TryGetProp(itemClass, "Name", "None"));
		text_item:SetTextByKey("count", value);
	end
	
    GBOX_AUTO_ALIGN(gbox_furniture_list, 5, 0, 0, true, false);
end

function SCR_HOUSING_PAGE_LOAD_REMOVE_FURNITURE(pageIndex, removeFurnitureNameCount)
    local guild = session.party.GetPartyInfo(PARTY_GUILD);

	local currentMapName = session.GetMapName();
	local housingPlaceClass = GetClass("Housing_Place", currentMapName);
	if housingPlaceClass == nil then
		return;
	end
	
	local type = TryGetProp(housingPlaceClass, "Type");
	local isGuildHousing = type == "Guild";

	ui.OpenFrame("housing_editmode_page_change");
	local frame = ui.GetFrame("housing_editmode_page_change");
	frame:SetUserValue("PageIndex", pageIndex);
	
	local gbox_required_furniture = GET_CHILD_RECURSIVELY(frame, "gbox_required_furniture");
	local gbox_remove_furniture = GET_CHILD_RECURSIVELY(frame, "gbox_remove_furniture");
	gbox_required_furniture:ShowWindow(0);
	gbox_remove_furniture:ShowWindow(1);
	
	local gbox_furniture_list = GET_CHILD_RECURSIVELY(gbox_remove_furniture, "gbox_furniture_list");
	gbox_furniture_list:RemoveAllChild();
	
	local allDemolitionPrice = 0;
	
	for key, value in pairs(removeFurnitureNameCount) do
		local housingClass = GetClass("Housing_Furniture", key);
		local itemClassName = TryGetProp(housingClass, "ItemClassName", "None");
	
		local itemClass = GetClass("Item", itemClassName);

		local ctrlSet = gbox_furniture_list:CreateControlSet("housing_page_chnage_remove_furniture_slot", "HOUSING_PAGE_SLOT_" .. key, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		
		local item_image = GET_CHILD_RECURSIVELY(ctrlSet, "item_image");
		item_image:SetImage(GET_ITEM_ICON_IMAGE(itemClass));

		local text_item = GET_CHILD_RECURSIVELY(ctrlSet, "text_item");
		text_item:SetTextByKey("name", TryGetProp(itemClass, "Name", "None"));
		text_item:SetTextByKey("count", value);
		
		if isGuildHousing == true then
			local demolitionPrice = TryGetProp(housingClass, "DemolitionPrice");
			allDemolitionPrice = allDemolitionPrice + (demolitionPrice * value);
		end
	end
	
	local txt_has_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_has_guild_money");
	local txt_need_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_need_guild_money");
	local listselect_gb = GET_CHILD_RECURSIVELY(frame, "listselect_gb");
	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
	local txt_memo3 = GET_CHILD_RECURSIVELY(gbox_remove_furniture, "txt_memo3");

	if isGuildHousing == true then
		frame:Resize(450, 550);

		listselect_gb:Resize(0, 0, 450, 550);
		gbox:Resize(0, 0, 430, 480);
		gbox_remove_furniture:Resize(0, 0, 430, 460);
		txt_memo3:SetMargin(0, 375, 0, 0);

		txt_has_guild_money:ShowWindow(1);
		txt_has_guild_money:SetTextByKey("money", GET_COMMAED_STRING(guild.info:GetAssetAmount()));

		txt_need_guild_money:ShowWindow(1);
		txt_need_guild_money:SetTextByKey("money", GET_COMMAED_STRING(allDemolitionPrice));
	else
		frame:Resize(450, 500);

		listselect_gb:Resize(0, 0, 450, 500);
		gbox:Resize(0, 0, 430, 430);
		gbox_remove_furniture:Resize(0, 0, 430, 400);
		txt_memo3:SetMargin(0, 315, 0, 0);

		txt_has_guild_money:ShowWindow(0);
		txt_need_guild_money:ShowWindow(0);
	end

    GBOX_AUTO_ALIGN(gbox_furniture_list, 5, 0, 0, true, false);
end

function BTN_HOUSING_EDITMODE_PAGE_DELETE(gbox, btn)
	local pageIndex = tonumber(btn:GetUserValue("PageIndex"));
	if pageIndex < 1 then
		return;
	end
	
	local clmsg = ScpArgMsg("Housing_Page_Really_Delete{PAGE_NUMBER}", "PAGE_NUMBER", pageIndex);
	local yesscp = string.format("housing.PageDelete(%d);", pageIndex);
	ui.MsgBox(clmsg, yesscp, 'None');
end