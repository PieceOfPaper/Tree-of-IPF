function SET_HOUSING_EDITMODE_CHANGE_BACKGROUND(housingPlaceClass, mapClassID, currentMapName, accountObject, slotControlSet)
	local txt_is_has = GET_CHILD_RECURSIVELY(slotControlSet, "txt_is_has");
	local pic_silver = GET_CHILD_RECURSIVELY(slotControlSet, "pic_silver");
	local txt_silver = GET_CHILD_RECURSIVELY(slotControlSet, "txt_silver");
	local btn_apply = GET_CHILD_RECURSIVELY(slotControlSet, "btn_apply");
	local btn_background_preview = GET_CHILD_RECURSIVELY(slotControlSet, "btn_background_preview");

	if currentMapName == housingPlaceClass.ClassName then
		txt_is_has:SetTextByKey("value", ClMsg("ITEM_IsUsed"));
		pic_silver:ShowWindow(0);
		txt_silver:ShowWindow(0);
		btn_apply:SetTextByKey("value", ClMsg("ITEM_IsUsed"));
		btn_apply:SetEnable(0);
	else
		local isHas_name = "PersonalHousing_HasPlace_" .. tostring(mapClassID);
		local isHas = TryGetProp(accountObject, isHas_name, "NO");
		if isHas == "YES" then
			txt_is_has:SetTextByKey("value", ClMsg("IsHaved"));
			pic_silver:ShowWindow(0);
			txt_silver:ShowWindow(0);
			btn_apply:SetTextByKey("value", ClMsg("GuildEmblemChange"));
		else
			txt_is_has:SetTextByKey("value", "");
			pic_silver:ShowWindow(1);
			txt_silver:ShowWindow(1);
			txt_silver:SetTextByKey("value", GET_COMMAED_STRING(TryGetProp(housingPlaceClass, "ThemaPrice", 0)));
			btn_apply:SetTextByKey("value", ClMsg("Auto_KuMae"));
		end
		btn_apply:SetEnable(1);
		btn_apply:SetUserValue("IS_HAS", isHas);
	end

	btn_apply:SetUserValue("MapID", mapClassID);
	btn_background_preview:SetUserValue("MapID", mapClassID);
end

function RESET_HOUSING_EDITMODE_CHANGE_BACKGROUND()
	local frame = ui.GetFrame("housing_editmode_background_chagne");
	local gbox_page = GET_CHILD_RECURSIVELY(frame, "gbox_page");
	
	local housingPlaceClassList, count = GetClassList("Housing_Place");
	if housingPlaceClassList == nil then
		return;
	end
	
	local currentMapName = session.GetMapName();
	local accountObject = GetMyAccountObj();

	for i = 0, count - 1 do
		local housingPlaceClass = GetClassByIndexFromList(housingPlaceClassList, i);
		local mapClass = GetClass("Map", housingPlaceClass.ClassName);
		local type = TryGetProp(housingPlaceClass, "Type");
		if mapClass ~= nil and type == "Personal" then
			local slotControlSet = GET_CHILD_RECURSIVELY(gbox_page, "HOUSING_BACKGROUND_CHANGE_SLOT_" .. housingPlaceClass.ClassName);
			if slotControlSet ~= nil then
				SET_HOUSING_EDITMODE_CHANGE_BACKGROUND(housingPlaceClass, mapClass.ClassID, currentMapName, accountObject, slotControlSet);
			end
		end
	end
end

function OPEN_HOUSING_EDITMODE_BACKGROUND_CHANGE(frame)
	local gbox_page = GET_CHILD_RECURSIVELY(frame, "gbox_page");
	gbox_page:RemoveAllChild();

	local housingPlaceClassList, count = GetClassList("Housing_Place");
	if housingPlaceClassList == nil then
		return;
	end
	
	local currentMapName = session.GetMapName();
	local accountObject = GetMyAccountObj();

	for i = 0, count - 1 do
		local housingPlaceClass = GetClassByIndexFromList(housingPlaceClassList, i);
		local mapClass = GetClass("Map", housingPlaceClass.ClassName);
		local type = TryGetProp(housingPlaceClass, "Type");
		if mapClass ~= nil and type == "Personal" then
			local ctrlSet = gbox_page:CreateControlSet("housing_background_change_slot", "HOUSING_BACKGROUND_CHANGE_SLOT_" .. housingPlaceClass.ClassName, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

			local pic_place = GET_CHILD_RECURSIVELY(ctrlSet, "pic_place");
			pic_place:SetImage("icon_" .. housingPlaceClass.ClassName);

			local txt_place_name = GET_CHILD_RECURSIVELY(ctrlSet, "txt_place_name");
			txt_place_name:SetTextByKey("value", mapClass.Name);
			
			SET_HOUSING_EDITMODE_CHANGE_BACKGROUND(housingPlaceClass, mapClass.ClassID, currentMapName, accountObject, ctrlSet);
		end
	end
	
    GBOX_AUTO_ALIGN(gbox_page, 5, 3, 10, true, false);
end

function CLOSE_HOUSING_EDITMODE_BACKGROUND_CHANGE()
	housing.CloseBackgroundPreview();
end

function BTN_CLOSE_HOUSING_EDITMODE_BACKGROUND_CHANGE()
	ui.CloseFrame("housing_editmode_background_chagne");
end

function BTN_HOUSING_EDITMODE_BACKGROUND_CHANGE(gbox, btn)
	local isHasValue = 0;

	local mapID = tonumber(btn:GetUserValue("MapID"));
	local isHas = btn:GetUserValue("IS_HAS");
	local msg = "ReallyBuy?";

	if isHas == "YES" then
		isHasValue = 1;
		msg = "ReallyChange?";
	end

	local yesscp = string.format("DO_HOUSING_EDITMODE_BACKGROUND_CHANGE(%d, %d)", isHasValue, mapID);
	ui.MsgBox(ScpArgMsg(msg), yesscp, 'None');
end

function DO_HOUSING_EDITMODE_BACKGROUND_CHANGE(isHas, mapID)
	if isHas == 1 then
		housing.RequestApplyPersonalHouseBackground(mapID);
	else
		housing.RequestBuyPersonalHouseBackground(mapID);
	end
end

function BTN_HOUSING_EDITMODE_BACKGROUND_PREVIEW(gbox, btn)
	local mapID = tonumber(btn:GetUserValue("MapID"));
	if housing.IsBackgroundPreview(mapID) == true then
		housing.CloseBackgroundPreview();
	else
		housing.BackgroundPreview(mapID);
	end
end