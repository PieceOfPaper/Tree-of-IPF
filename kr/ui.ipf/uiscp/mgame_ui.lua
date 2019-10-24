--- mgame_ui.lua --

function MGAME_C_OPEN_UI(actor, uiName, isOpen)
	if isOpen == 1 then
		ui.OpenFrame(uiName);
	else
		ui.CloseFrame(uiName);
	end
end

function MGAME_C_CUSTOM_OPTION_CHECK(actor, type)
	addon.BroadMsg("CUSTOM_OPTION_CHECK", "MGAME", type);
end

function MGAME_C_SET_CONFIG(actor, configName, value)
	config.SetConfig(configName, value);
end

function MGAME_C_CLIENT_SCRIPT(actor, funcName)
	local func = _G[funcName];
	func(actor);
end

function MGAME_C_RESET_ADVBOX(actor, uiName, boxName)
	session.mission.ClearUIInfo();
end

function MGAME_ADVBOX_ITEMS(updateInfo)

	local uiList = session.mission.GetAdvBoxList();
	local cnt = uiList:size();
	for i = 0 , cnt - 1 do
		local uiInfo = uiList:at(i);
		if uiInfo.teamID == updateInfo.teamID then
			local uiFrame = ui.GetFrame(uiInfo:GetFrameName());
			if uiFrame ~= nil then
				local advBox = GET_CHILD(uiFrame, uiInfo:GetBoxName(), "ui::CAdvListBox");
				if advBox ~= nil then
					MGAME_UPDATE_BOX_ITEMS(advBox, uiInfo, updateInfo);
				end
			end
		end
	end

end

function MGAME_UPDATE_BOX_ITEMS(advBox, uiInfo, updateInfo)
	local teamInfo = session.mission.GetTeam(uiInfo.teamID);
	if teamInfo == nil then
		return;
	end

	local updated = false;
	local teamList = teamInfo:GetPCList();
	local cnt = teamList:size();
	for i = 0 , cnt - 1 do
		local pcInfo = teamList:at(i);
		if updateInfo.pcInfo == pcInfo then
			local key = "_KEY_" .. i;
			local pcObj = GetIES(pcInfo:GetIESObject());
			local itemCnt = uiInfo:GetItemCount();
			for j = 0 , itemCnt - 1 do
				local itemInfo = uiInfo:GetItem(j);
				if updateInfo:IsUpdateBoxItem(itemInfo) == 1 then
					local richTxt = advBox:GetObjectByKey(key, itemInfo.index);
					if richTxt ~= nil then
						richTxt:SetTextByKey("param", MGAME_BOX_GET_PROP(pcInfo, pcObj, itemInfo));
						updated = true;
					end
				end
			end
		end
	end

	if updated == true then
		advBox:UpdateAdvBox();
	end

end

function MGAME_C_UPDATE_ADVBOX(actor)

	local uiList = session.mission.GetAdvBoxList();
	local cnt = uiList:size();
	for i = 0 , cnt - 1 do
		local uiInfo = uiList:at(i);
		local uiFrame = ui.GetFrame(uiInfo:GetFrameName());
		if uiFrame ~= nil then
			local advBox = GET_CHILD(uiFrame, uiInfo:GetBoxName(), "ui::CAdvListBox");
			if advBox ~= nil then
				MGAME_UPDATE_BOX(advBox, uiInfo);
			end
		end
	end
end

function MGAME_BOX_GET_PROP(pcInfo, pcObj, itemInfo)
	local isMyPC = false;
	if pcInfo.name == GETMYPCNAME() then
		isMyPC = true;
	end

	if itemInfo:GetPropName() == "Name" then
		if isMyPC then
			return "{i}" .. pcInfo.name;
		end

		return pcInfo.name;
	end

	if isMyPC then
		return "{i}" .. pcObj[itemInfo:GetPropName()];
	end

	return pcObj[itemInfo:GetPropName()];
end

function MGAME_UPDATE_BOX(advBox, uiInfo)
	
	advBox:ClearUserItems();
	local teamInfo = session.mission.GetTeam(uiInfo.teamID);
	if teamInfo == nil then
		return;
	end

	local itemCnt = uiInfo:GetItemCount();
	for j = 0 , itemCnt - 1 do
		local itemInfo = uiInfo:GetItem(j);
		advBox:SetColWidth(itemInfo.index, itemInfo.colWidth);
	end

	for j = 0 , itemCnt - 1 do
		local itemInfo = uiInfo:GetItem(j);
		local d = SET_ADVBOX_ITEM_C(advBox, "Title", itemInfo.index, itemInfo:GetTitleName(), "white_16_ol");
		d:SetText(itemInfo:GetTitleName());
	end

	local teamList = teamInfo:GetPCList();
	local cnt = teamList:size();
	for i = 0 , cnt - 1 do
		local pcInfo = teamList:at(i);
		local pcObj = GetIES(pcInfo:GetIESObject());
		local key = "_KEY_" .. i;
		local pcObj = GetIES(pcInfo:GetIESObject());
		local itemCnt = uiInfo:GetItemCount();
		for j = 0 , itemCnt - 1 do
			local itemInfo = uiInfo:GetItem(j);
			local propValue = "";
			local richTxt = SET_ADVBOX_ITEM_C(advBox, key, itemInfo.index, itemInfo:GetFormat(), "white_16_ol");
			richTxt = tolua.cast(richTxt, "ui::CRichText");
			richTxt:SetFormat(itemInfo:GetFormat());
			richTxt:AddParamInfo("param", MGAME_BOX_GET_PROP(pcInfo, pcObj, itemInfo));
			richTxt:UpdateFormat();
		end
	end

	advBox:UpdateAdvBox();

end

function MGAME_C_SET_ADVBOX(actor, uiName, boxName, teamID, col, colWidth, titleFormat, propValue, titleName)
	session.mission.SetAdvBoxInfo(teamID, uiName, boxName, col, colWidth, titleFormat, propValue, titleName);
end



